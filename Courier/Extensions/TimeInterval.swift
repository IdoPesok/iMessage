//
//  TimeInterval.swift
//  Courier
//
//  Created by Ido Pesok on 4/3/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

extension TimeInterval {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = Date.init(timeIntervalSince1970: self)
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = Date.init(timeIntervalSince1970: self)
        let string = dateFormatter.string(from: date)
        return string
    }
    
}
