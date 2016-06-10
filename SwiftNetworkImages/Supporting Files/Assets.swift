//
//  Assets.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

enum Asset: String {
    case LayoutConfigOptions = "LayoutConfigOptions"
    
    var image: UIImage? {
        return UIImage(asset: self)
    }
}

extension UIImage {
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}