//
//  UIButton.swift
//  BTCApp
//
//  Created by Sahassawat on 6/6/2566 BE.
//


import UIKit

extension UIButton {
    
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { setImage(image, for: $0) }
    }
    
    func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }
    
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { setTitleColor(color, for: $0) }
    }
}
