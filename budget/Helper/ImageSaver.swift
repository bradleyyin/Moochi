//
//  ImageSaver.swift
//  budget
//
//  Created by Bradley Yin on 10/2/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit
class ImageSaver {
    func saveImage(image: UIImage) -> String? {
        //dont save absolute url, it changes every time, only save the appending
        let uuid = UUID().uuidString
        let fm = FileManager.default
        let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let filePath = dir?.appendingPathComponent("\(uuid).jpeg") else { return nil }
        
        if let imagedata = image.jpegData(compressionQuality: 1.0){
            do{
                try imagedata.write(to: filePath, options: .atomic)
                return "\(uuid).jpeg"
            } catch {
                print("error saving image : \(error)")
            }
            
        }
        
        return nil
    }
}
