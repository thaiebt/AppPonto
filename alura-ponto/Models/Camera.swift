//
//  Camera.swift
//  alura-ponto
//
//  Created by c94289a on 23/02/22.
//

import Foundation
import UIKit

protocol CameraDelegate: NSObject {
    func didFinishSelectPhoto(image: UIImage)
}

class Camera: NSObject {
    weak var delegate: CameraDelegate?
    
    func openCamera(controller: UIViewController, imagePicker: UIImagePickerController) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
        imagePicker.delegate = self
        controller.present(imagePicker, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(controller: UIViewController, imagePicker: UIImagePickerController) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        controller.present(imagePicker, animated: true, completion: nil)
    }
}

extension Camera: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        
        delegate?.didFinishSelectPhoto(image: selectedPhoto)
    }
}
