//
//  UIActivityIndicatorViewExtension.swift
//  Countries Game Lesson 18
//
//  Created by Yoni on 04/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    public func setup(view: UIView) {
        self.center = CGPoint(x: view.layer.bounds.width / 2, y: view.layer.bounds.height / 2)
        self.hidesWhenStopped = true
        self.style = UIActivityIndicatorView.Style.large
        self.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(self)
    }
}
