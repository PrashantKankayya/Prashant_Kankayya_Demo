//
//  EFTiming.swift
//  Prashant_Kankayya_Demo



import UIKit
import QuartzCore

protocol EFTiming {
    func update(_ time: CGFloat) -> CGFloat
}

protocol EFCount {
    func countFrom(_ startValue: CGFloat, to endValue: CGFloat, withDuration duration: TimeInterval)
    func countFromCurrentValueTo(_ endValue: CGFloat, withDuration duration: TimeInterval)
    func stopCountAtCurrentValue()
}

extension EFCount {
    func countFromZeroTo(_ endValue: CGFloat, withDuration duration: TimeInterval) {
        countFrom(0, to: endValue, withDuration: duration)
    }
    
    func countFrom(_ startValue: CGFloat, to endValue: CGFloat) {
        countFrom(startValue, to: endValue, withDuration: 2)
    }
    
    func countFromCurrentValueTo(_ endValue: CGFloat) {
        countFromCurrentValueTo(endValue, withDuration: 2)
    }
    
    func countFromZeroTo(_ endValue: CGFloat) {
        countFromZeroTo(endValue, withDuration: 2)
    }
}

class EFCounter {
    var timingFunction: EFTiming = EFTimingFunction.linear
    
    var updateBlock: ((CGFloat) -> Void)?
    var completionBlock: (() -> Void)?
    
    private(set) var fromValue: CGFloat = 0
    private(set) var toValue: CGFloat = 1
    private var currentDuration: TimeInterval = 0
    private(set) var totalDuration: TimeInterval = 1
    private var lastUpdate: TimeInterval = 0
    
    private var timer: CADisplayLink?
    
    var isCounting: Bool {
        return timer != nil
    }
    
    var progress: CGFloat {
        guard totalDuration != 0 else { return 1 }
        return CGFloat(currentDuration / totalDuration)
    }
    
    var currentValue: CGFloat {
        if currentDuration == 0 {
            return 0
        } else if currentDuration >= totalDuration {
            return toValue
        }
        return fromValue + timingFunction.update(progress) * (toValue - fromValue)
    }
    
    init() { }
    
    @objc func updateValue(_ timer: Timer) {
        let now = CACurrentMediaTime()
        currentDuration += now - lastUpdate
        lastUpdate = now
        
        if currentDuration >= totalDuration {
            invalidate()
            currentDuration = totalDuration
        }
        
        updateBlock?(currentValue)
        
        if currentDuration == totalDuration {
            runCompletionBlock()
        }
    }
    
    private func runCompletionBlock() {
        if let tryCompletionBlock = completionBlock {
            completionBlock = nil
            tryCompletionBlock()
        }
    }
    
    func reset() {
        invalidate()
        fromValue = 0
        toValue = 1
        currentDuration = 0
        lastUpdate = 0
        totalDuration = 1
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}

extension EFCounter: EFCount {
    func countFromCurrentValueTo(_ endValue: CGFloat, withDuration duration: TimeInterval) {
        countFrom(currentValue, to: endValue, withDuration: duration)
    }
    
    func countFrom(_ startValue: CGFloat, to endValue: CGFloat, withDuration duration: TimeInterval) {
        fromValue = startValue
        toValue = endValue
        
        invalidate()
        
        if duration == 0.0 {
            updateBlock?(endValue)
            runCompletionBlock()
            return
        }
        
        currentDuration = 0
        totalDuration = duration
        lastUpdate = CACurrentMediaTime()
        
        let timer = CADisplayLink(target: self, selector: #selector(updateValue(_:)))
        if #available(iOS 10.0, *) {
            timer.preferredFramesPerSecond = 30
        } else {
            timer.frameInterval = 2
        }
        timer.add(to: .main, forMode: .default)
        timer.add(to: .main, forMode: .tracking)
        self.timer = timer
    }
    
    func stopCountAtCurrentValue() {
        invalidate()
        updateBlock?(currentValue)
    }
}

protocol EFCountAdapter: AnyObject, EFCount {
    var counter: EFCounter { get }
}

extension EFCountAdapter {
    func setUpdateBlock(_ update: ((_ value: CGFloat, _ sender: Self) -> Void)?) {
        if let update = update {
            counter.updateBlock = { [unowned self] value in
                update(value, self)
            }
        } else {
            counter.updateBlock = nil
        }
    }
    
    func setCompletionBlock(_ completion: ((_ sender: Self) -> Void)?) {
        if let completion = completion {
            counter.completionBlock = { [unowned self] in
                completion(self)
            }
        } else {
            counter.completionBlock = nil
        }
    }
    
    func countFrom(_ startValue: CGFloat, to endValue: CGFloat, withDuration duration: TimeInterval) {
        counter.countFrom(startValue, to: endValue, withDuration: duration)
    }
    
    func countFromCurrentValueTo(_ endValue: CGFloat, withDuration duration: TimeInterval) {
        countFrom(counter.currentValue, to: endValue, withDuration: duration)
    }
    
    func stopCountAtCurrentValue() {
        counter.stopCountAtCurrentValue()
    }
}

class EFCountingButton: UIButton, EFCountAdapter {
    private(set) var counter = EFCounter()
    
    var formatBlock: ((CGFloat) -> String)? {
        set {
            if let formatBlock = newValue {
                setUpdateBlock { value, button in button.setTitle(formatBlock(value), for: .normal) }
            } else {
                setUpdateBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }
    var attributedFormatBlock: ((CGFloat) -> NSAttributedString)? {
        set {
            if let attributedFormatBlock = newValue {
                setUpdateBlock { value, button in button.setAttributedTitle(attributedFormatBlock(value), for: .normal) }
            } else {
                setUpdateBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }
    var completionBlock: (() -> Void)? {
        set {
            if let completionBlock = newValue {
                setCompletionBlock { _ in completionBlock() }
            } else {
                setCompletionBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    func customInit() {
        setUpdateBlock { [weak self] (value, _) in
            guard let self = self else { return }
            self.setTitle("\(Int(value))", for: .normal)
        }
    }

    deinit {
        counter.invalidate()
    }
}

class EFCountingLabel: UILabel, EFCountAdapter {
    private(set) var counter = EFCounter()
    
    var formatBlock: ((CGFloat) -> String)? {
        set {
            if let formatBlock = newValue {
                setUpdateBlock { value, label in label.text = formatBlock(value) }
            } else {
                setUpdateBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }
    var attributedFormatBlock: ((CGFloat) -> NSAttributedString)? {
        set {
            if let attributedFormatBlock = newValue {
                setUpdateBlock { value, label in label.attributedText = attributedFormatBlock(value) }
            } else {
                setUpdateBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }
    var completionBlock: (() -> Void)? {
        set {
            if let completionBlock = newValue {
                setCompletionBlock { _ in completionBlock() }
            } else {
                setCompletionBlock(nil)
            }
        }
        @available(*, unavailable)
        get {
            return nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    func customInit() {
        setUpdateBlock { [weak self] (value, _) in
            guard let self = self else { return }
            self.text = "\(Int(value))"
        }
    }
    
    deinit {
        counter.invalidate()
    }
}

enum EFTimingFunction: EFTiming {
    case linear
    case easeIn(easingRate: CGFloat)
    case easeOut(easingRate: CGFloat)
    case easeInOut(easingRate: CGFloat)
    case easeInBounce
    case easeOutBounce
    
    func update(_ time: CGFloat) -> CGFloat {
        switch self {
        case .linear:
            return time
        case .easeIn(let rate):
            return pow(time, rate)
        case .easeOut(let rate):
            return 1.0 - pow(1.0 - time, rate)
        case .easeInOut(let rate):
            let newt: CGFloat = 2 * time
            if newt < 1 {
                return 0.5 * pow(newt, rate)
            } else {
                return 0.5 * (2.0 - pow(2.0 - newt, rate))
            }
        case .easeInBounce:
            if time < 4.0 / 11.0 {
                return 1.0 - (pow(11.0 / 4.0, 2) * pow(time, CGFloat(2))) - time
            } else if time < 8.0 / 11.0 {
                return 1.0 - (3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(time - 6.0 / 11.0, 2)) - time
            } else if time < 10.0 / 11.0 {
                return 1.0 - (15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(time - 9.0 / 11.0, 2)) - time
            }
            return 1.0 - (63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(time - 21.0 / 22.0, 2)) - time
        case .easeOutBounce:
            if time < 4.0 / 11.0 {
                return pow(11.0 / 4.0, 2) * pow(time, CGFloat(2))
            } else if time < 8.0 / 11.0 {
                return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(time - 6.0 / 11.0, 2)
            } else if time < 10.0 / 11.0 {
                return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(time - 9.0 / 11.0, 2)
            }
            return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(time - 21.0 / 22.0, 2)
        }
    }
}
