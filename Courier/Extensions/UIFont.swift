//
//  UIFont.swift
//  Courier
//
//  Created by Ido Pesok on 3/27/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Bold", size: size)!
    }
    
    static func black(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Black", size: size)!
    }
    
    static func light(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Light", size: size)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Medium", size: size)!
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Regular", size: size)!
    }
    
    static func thin(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Roboto-Thin", size: size)!
    }
    
}
