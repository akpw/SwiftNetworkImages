//
//  Array+Helpers.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

extension Array {
    /// Returns the element at the given `index` and a new array with that element removed.
    private func arrayByRemovingElementAtIndex(index: Int) -> (Element, [Element]) {
        var newArray = self
        let removedElement = newArray.removeAtIndex(index)
        return (removedElement, newArray)
    }
    /// Returns an array of arrays, where each array in the array
    /// is one permutation of the elements in the receiver.
    public var permutations: [[Element]] {
        switch self.count {
        case 0:
            return []
        case 1:
            return [self]
        default:
            precondition(self.count > 1)
            var permutations: [[Element]] = []
            for idx in 0..<self.count {
                let (currentElement, remainingElements) = self.arrayByRemovingElementAtIndex(idx)
                
                permutations += remainingElements.permutations.map { [currentElement] + $0 }
            }
            return permutations
        }
    }
    
    func isSorted(isOrderedBefore: (Element, Element) -> Bool) -> Bool {
        for i in 0..<self.count - 1 {
            if !isOrderedBefore(self[i], self[i + 1]) {
                return false
            }
        }
        return true
    }
}