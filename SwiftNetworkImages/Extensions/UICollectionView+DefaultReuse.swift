//
//  UICollectionView+DefaultReuseIdentifier.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Conformance to the `ReusableViewWithDefaultIdentifierAndKind` protocol
extension UICollectionReusableView: ReusableViewWithDefaultIdentifierAndKind {}

/** 
    Simplifies registering & dequeuing `UICollectionViewCell` and `UICollectionReusableView` classes & nibs.
 
    Sample usage: 
 
    ```
    class ImageCollectionViewCell: UICollectionViewCell {}

    collectionView.registerClass(ImageCollectionViewCell.self)

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        // ...
        return cell
    }

    ```
*/
extension UICollectionView {
    // MARK: - Register classes
    func registerClass<T: UICollectionViewCell
                        where T: ReusableViewWithDefaultIdentifier>(_: T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerClass<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifier>(_: T.Type,
                                                forSupplementaryViewOfKind elementKind: String) {
        registerClass(T.self, forSupplementaryViewOfKind: elementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerClass<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifierAndKind>(_: T.Type) {
        registerClass(T.self, forSupplementaryViewOfKind: T.defaultElementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: - Register nibs
    func registerNib<T: UICollectionViewCell
                        where T: ReusableViewWithDefaultIdentifier, T: NibLoadableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: NSBundle(forClass: T.self))
        registerNib(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerNib<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifier, T: NibLoadableView>(_: T.Type,
                                                forSupplementaryViewOfKind elementKind: String) {
        let nib = UINib(nibName: T.nibName, bundle: NSBundle(forClass: T.self))
        registerNib(nib, forSupplementaryViewOfKind: elementKind,
                                                withReuseIdentifier: T.defaultReuseIdentifier)
    }
    func registerNib<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifierAndKind, T: NibLoadableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: NSBundle(forClass: T.self))
        registerNib(nib, forSupplementaryViewOfKind: T.defaultElementKind,
                    withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: - Cells dequeueing
    func dequeueReusableCell<T: UICollectionViewCell
                         where T: ReusableViewWithDefaultIdentifier>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.defaultReuseIdentifier,
                                                                forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    // MARK: - Dequeueing of reusable views
    func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifier> (elementKind: String,
                                                                     forIndexPath indexPath: NSIndexPath)  -> T {
         let reuseIdentifier = T.defaultReuseIdentifier
         guard let reusableView = dequeueReusableSupplementaryViewOfKind(elementKind,
                                                                withReuseIdentifier: reuseIdentifier,
                                                                forIndexPath: indexPath) as? T else {
            fatalError(String(format: "%@%@", "Could not dequeue reusable view of kind \(elementKind)",
                                                                     "with identifier: \(T.defaultReuseIdentifier)"))
        }
        return reusableView
    }
    
    func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView
                        where T: ReusableViewWithDefaultIdentifierAndKind> (forIndexPath indexPath: NSIndexPath)  -> T {
        guard let reusableView = dequeueReusableSupplementaryViewOfKind(T.defaultElementKind,
                                                                        withReuseIdentifier: T.defaultReuseIdentifier,
                                                                        forIndexPath: indexPath) as? T else {
            fatalError(String(format: "%@%@", "Could not dequeue reusable view of kind \(T.defaultElementKind)",
                                                                    "with identifier: \(T.defaultReuseIdentifier)"))
        }
        return reusableView
    }
}









