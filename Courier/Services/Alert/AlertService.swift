//
//  AlertService.swift
//  Courier
//
//  Created by Ido Pesok on 3/27/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class AlertService {
    
    static let shared = AlertService()
    
    func launchOkAlert(title: String, message: String, sender: UIViewController) {
        let alertController = OkAlert.init(title: title, message: message)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    func launchCancelAlert(title: String, message: String, sender: UIViewController) {
        let alertController = CancelAlert.init(title: title, message: message)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    func launchActionSheet(buttons: [AlertButton], sender: UIViewController) {
        let alertController = ActionSheet.init(buttons: buttons)
        sender.present(alertController, animated: true, completion: nil)
    }
    
}
