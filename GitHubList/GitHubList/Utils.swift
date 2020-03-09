//
//  Utils.swift
//  GitHubList
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation
import UIKit


class Utils {
    
    static func createAlertController(title: String, message: String? = nil, actions: [UIAlertAction], includeCancelAction: Bool = false, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        if includeCancelAction {
            alert.addAction(UIAlertAction(title: NSLocalizedString(Constants.cancel, comment: ""), style: .cancel, handler: nil))
        }
        
        return alert
    }
    
    static func saveOnDevice(fileName: String, image: UIImage) {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = "\(fileName).png"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
        
    }
    
    static func getFromDevice(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent("\(fileName).png")
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
    
    static func databaseSafeObject(object: AnyObject?) -> AnyObject {
        if let safeObject: AnyObject = object{
            return safeObject;
        }

        return NSNull();
    }

    
}

extension UIImageView {
        
    func downloaded(id: String, from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let image = Utils.getFromDevice(fileName: id) {
            self.image = image
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            Utils.saveOnDevice(fileName: id, image: image)
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
}


