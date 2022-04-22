//
//  Profile.swift
//  alura-ponto
//
//  Created by c94289a on 08/03/22.
//

import UIKit

class Profile {
    private let imageName = "image.png"
    
    func saveImage(_ image: UIImage) {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let urlImage = directory.appendingPathComponent(imageName)
        
        if FileManager.default.fileExists(atPath: urlImage.path) {
            removeImage(url: urlImage.path)
        }
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: false)
            try data.write(to: urlImage)
        } catch let error {
            print(error)
        }
    }
    
    private func removeImage(url: String) {
        do {
            try FileManager.default.removeItem(atPath: url)
        } catch let error {
            print(error)
        }
    }
    
    func loadImage() -> UIImage? {
        let directory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let urlArchive = NSSearchPathForDirectoriesInDomains(directory, userDomainMask, true)
        
        guard let path = urlArchive.first else { return nil }
        let urlImage = URL(fileURLWithPath: path).appendingPathComponent(imageName)
        let image = UIImage(contentsOfFile: urlImage.path)
        
        return image
    }
}

