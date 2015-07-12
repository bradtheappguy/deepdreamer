//
//  Extensions.swift
//  DeepDreamMachine
//
//  Created by Isaac Arvestad on 11/07/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//

import UIKit

extension UIImage {
    func getScaledJPEGWithSize(rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)

        self.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        return UIImage(data: imageData)
    }
}