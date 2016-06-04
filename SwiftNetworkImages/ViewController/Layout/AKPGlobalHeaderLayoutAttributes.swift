//
//  AKPGlobalHeaderLayoutAttributes.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 17/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

class AKPGlobalHeaderLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var pinnable: Bool = false
    var height: CGFloat = 0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! AKPGlobalHeaderLayoutAttributes
        copy.pinnable = pinnable
        copy.height = height
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? AKPGlobalHeaderLayoutAttributes {
            if attributes.pinnable == pinnable && attributes.height == height {
                return super.isEqual(object)
            }
        }
        return false
    }  
}
