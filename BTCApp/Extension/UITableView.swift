//
//  UITableView.swift
//  News
//
//  Created by Sahassawat on 20/1/2566 BE.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCells(classNames: [String]) {
        for className in classNames {
            register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        }
    }

}
