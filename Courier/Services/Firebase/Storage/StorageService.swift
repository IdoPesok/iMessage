//
//  StorageService.swift
//  Courier
//
//  Created by Ido Pesok on 4/1/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

class StorageService {
    
    static let shared = StorageService()
    
    func upload(image: UIImage, completion: @escaping (String) -> Void) {
        if let uploadData = image.pngData() {
            let id = UUID().uuidString
            StorageReferences.profilePictures.child(id).putData(uploadData, metadata: nil) { (metadata, err) in
                guard err == nil, let md = metadata, let url = md.downloadURL() else { return }
                completion(url.absoluteString) 
            }
        }
    }
    
}
