//
//  AKPLayoutAttributes.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 17/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

let AKPUICollectionElementKindGobalSectionHeader: String = "AKPUICollectionElementKindGobalSectionHeader"

class AKPLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var pinnable: Bool = false
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! AKPLayoutAttributes
        copy.pinnable = pinnable
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? AKPLayoutAttributes {
            if attributes.pinnable == pinnable {
                return super.isEqual(object)
            }
        }
        return false
    }  
}
