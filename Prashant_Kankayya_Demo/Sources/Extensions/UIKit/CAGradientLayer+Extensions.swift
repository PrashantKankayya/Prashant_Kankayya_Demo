//
//  CAGradientLayer.swift
//  Prashant_Kankayya_Demo


import UIKit

extension CAGradientLayer {
    func calculatePoints(for angle: CGFloat) {
        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        if ang < 0 { ang = 360 + ang }
        let n: CGFloat = 0.5
        switch ang {
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            startPoint = a
            endPoint = b
        case 45...135:
            let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            startPoint = a
            endPoint = b
        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
           startPoint = a
            endPoint = b
        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            startPoint = a
            endPoint = b
        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            startPoint = a
            endPoint = b
        }
    }
    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    func calculatePoints(for angle: Int = 90) {
        calculatePoints(for: CGFloat(angle))
    }
    func calculatePoints(for angle: Float) {
        calculatePoints(for: CGFloat(angle))
    }
    func calculatePoints(for angle: Double) {
        calculatePoints(for: CGFloat(angle))
    }
}

