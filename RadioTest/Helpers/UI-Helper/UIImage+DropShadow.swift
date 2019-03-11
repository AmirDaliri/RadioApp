//
//  UIImage+DropShadow.swift
//  RadioTest
//
//  Created by Amir Daliri on 11.03.2019.
//  Copyright © 2019 AmirDaliri. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // APPLY DROP SHADOW
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius  = 2
    }
    
}
