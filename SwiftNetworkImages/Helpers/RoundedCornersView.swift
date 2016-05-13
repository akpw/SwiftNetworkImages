//
//  RoundedCornersView.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 6/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Rounded Corners for UIViews

class RoundedCornersView: UIView {
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }    
}

