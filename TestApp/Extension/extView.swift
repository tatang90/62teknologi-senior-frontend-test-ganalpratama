//
//  extView.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 17/05/23.
//

import UIKit

extension UIView{
    func setRadius(_ radius: CGFloat){
        layer.masksToBounds = true
        layer.cornerRadius  = radius
    }
}
