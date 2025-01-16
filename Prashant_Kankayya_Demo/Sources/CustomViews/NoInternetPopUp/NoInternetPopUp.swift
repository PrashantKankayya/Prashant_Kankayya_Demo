//
//  NoInternetPopUp.swift
//  NeoLife


import UIKit

class NoInternetPopUp : UIViewController {
    
    @IBOutlet weak var backGroundVFXView: UIVisualEffectView!
    @IBOutlet weak var mainContentView: UIView!
    
    var onTryAgainTapped: (() -> Void)?
    var onGoToSettingsTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundVFXView?.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        showPopUpView()
    }
    
    @IBAction func closeBtTapped(_ sender: Any) {
        closeView { }
    }
    
    func showPopUpView(){
        backGroundVFXView.alpha = 0
        self.mainContentView.frame = CGRect(x: 0, y: self.view.frame.height * 0.8, width: self.view.frame.width, height: self.view.frame.height * 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.mainContentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height * 0.8)
            self.backGroundVFXView.alpha = 1
        }, completion : { _ in
            debugPrint("")
        })
    }
    
    func initTryAgainBtEvent(onTryAgainCompletion:(() -> Void)? = nil,
                             onGoToSettingsCompletion:(() -> Void)? = nil) {
        self.onTryAgainTapped = onTryAgainCompletion
        self.onGoToSettingsTapped = onGoToSettingsCompletion
    }
    
    @IBAction func goToSettingsBtTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [self] in
            onGoToSettingsTapped!()
        }
    }
    
    @IBAction func tryAgainBtTapped(_ sender: UIButton) {
        DispatchQueue.main.async { [self] in
            closeView { [self] in
                onTryAgainTapped!()
            }
        }
    }
    
    func closeView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.mainContentView.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            self.backGroundVFXView.alpha = 0
        },  completion: { [self] (true) in
            self.dismiss(animated: false, completion: {
                completion()
            })
        })
    }
}
