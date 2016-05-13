//
//  CollectionType+BinarySearch.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/// A popular binary search implementation

extension CollectionType where Index: RandomAccessIndexType {
    func binarySearch(predicate: Generator.Element -> Bool) -> Index {
        var low = startIndex
        var high = endIndex
        while low != high {
            let mid = low.advancedBy(low.distanceTo(high) / 2)
            if predicate(self[mid]) {
                low = mid.advancedBy(1)
            } else {
                high = mid
            }
        }
        return low
    }
}