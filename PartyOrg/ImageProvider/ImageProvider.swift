//
//  ImageProvider.swift
//  PartyOrg
//
//  Created by Максим Казаков on 18/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

enum LoadImageError: Error {
    case wrongUrl
    case failLoadingData
}


class ImageProvider {
    
    static let shared = ImageProvider()
    let cache = NSCache<NSString, UIImage>()
    
    
    
    func delete(url: URL?) {
        guard let url = url, let key = getKey(from: url) else {
            return
        }
        cache.removeObject(forKey: key)
        DispatchQueue.global(qos: .background).async {
            do {
                try FileManager.default.removeItem(at: url)
            }
            catch {
                print("Error while deleting event image. \(error)")
            }
        }
    }
    
    
    static func getDocumentsDirectory() -> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    
    func getUrl(by filename: String) -> URL {
        var path = ImageProvider.getDocumentsDirectory()
        path.appendPathComponent(filename)
        return path
    }
    
    
    
    func save(image: UIImage) -> URL {
        let key = "\(UUID().uuidString).jpeg"
        let path = getUrl(by: key)
        cache.setObject(image, forKey: NSString(string: key))
        
        DispatchQueue.global(qos: .background).async {
            do {
                try UIImageJPEGRepresentation(image, 1.0)?.write(to: path)
            }
            catch {
                fatalError("Error while saving event image. \(error)")
            }
        }
        return path
    }
    
    
    
    
    func load(url: URL?, completion: @escaping (Error?, UIImage?) -> ()) {
        guard let url = url, let key = getKey(from: url) else {
            completion(LoadImageError.wrongUrl, nil)
            return
        }
        
        if let image = cache.object(forKey: key) {
            completion(nil, image)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var image: UIImage?
            var error: Error?
            if let loadedImage = UIImage.init(contentsOfFile: url.absoluteString) {
                self.cache.setObject(loadedImage, forKey: key)
                image = loadedImage
            }
            else {
                error = LoadImageError.failLoadingData
            }
            DispatchQueue.main.async {
                completion(error, image)
            }
        }
    }
    
    
    
    func getKey(from url: URL) -> NSString? {
        let key = url.lastPathComponent
        if key.isEmpty  {
            return nil
        }
        return NSString(string: key)
    }
}



