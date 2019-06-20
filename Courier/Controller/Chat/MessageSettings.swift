//
//  MessageSettings.swift
//  Courier
//
//  Created by Ido Pesok on 4/22/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

extension ChatController {
    
    func addLongPressRecognizerForCell(cell: MessageCell) {
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(launchMessageSettings(_:)))
        cell.addGestureRecognizer(gr)
    }
    
    @objc private func launchMessageSettings(_ sender: UILongPressGestureRecognizer) {
        guard let messageCell = sender.view as? MessageCell, let msg = messageCell.getMessage() else {
            return
        }
        
        self.selectedMessageId = msg.messageId
        
        let deleteBtn = AlertButton.init(title: "Delete")
        deleteBtn.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        let messageSettingsActionSheet = ActionSheet.init(buttons: [deleteBtn])
        present(messageSettingsActionSheet, animated: true, completion: nil)
    }
    
    @objc private func handleDelete() {
        dismiss(animated: true, completion: {
            if let c = self.chat {
                MessageService.shared.deleteMessage(chatId: c.chatId, messageId: self.selectedMessageId, onError: { (errMessage) in
                    AlertService.shared.launchCancelAlert(title: "Oops!", message: errMessage, sender: self)
                }, completion: {
                    print("message deleted")
                })
            }
        })
    }
    
}
