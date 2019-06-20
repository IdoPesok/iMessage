//
//  ProfileImageController.swift
//  Courier
//
//  Created by Ido Pesok on 4/21/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import RSKImageCropper

class ProfileImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerController()
        setupNavBar()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
    }
    
    private func setupPickerController() {
        let pickerView = UIImagePickerController()
        
        pickerView.delegate = self
        
        present(pickerView, animated: true, completion: nil)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Select Profile Picture"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = (info[.originalImage] as? UIImage)!
        picker.dismiss(animated: false, completion: { () -> Void in
            let rskImageCropper = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            rskImageCropper.delegate = self
            self.navigationController?.pushViewController(rskImageCropper, animated: true)
        })
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        handleCancel()
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        changeProfilePicture(croppedImage)
    }
    
    private func changeProfilePicture(_ image: UIImage) {
        StorageService.shared.upload(image: image) { (downloadUrl) in
            UserService.shared.changeProfileImageUrl(downloadUrl, onError: { (errMessage) in
                AlertService.shared.launchOkAlert(title: "Oops!", message: "Could not upload your image due to an unknown error. Please try again.", sender: self)
            }, completion: {
                AppUser.currentUser?.profileImageUrl = downloadUrl
                self.handleCancel()
            })
        }
    }
    
    @objc private func handleCancel() {
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
}
