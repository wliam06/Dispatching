//
//  ImageExtensions.swift
//  Dispatching
//
//  Created by Wiliam on 04/08/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UIImage {
    static func randomImage(seed: Int) -> UIImage {
        let images = (1...10).map { i -> UIImage in
            return UIImage(named: "\(i)") ?? UIImage()
        }

        return images[seed % images.count]
    }
}

