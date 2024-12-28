//
//  String+.swift
//
//
//  Created by Luca Archidiacono on 27.07.2024.
//

import Foundation
import UIKit

public extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = prefix(1).capitalized
        // 2
        let remainingLetters = dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }

    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context

        return image ?? UIImage()
    }
}
