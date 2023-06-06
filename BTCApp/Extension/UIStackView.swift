//
//  UIStackView.swift
//  BTCApp
//
//  Created by Sahassawat on 6/6/2566 BE.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
