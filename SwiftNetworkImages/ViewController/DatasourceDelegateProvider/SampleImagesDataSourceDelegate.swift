//
//  SampleImagesDataSourceDelegate.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// Implements UICollectionViewDataSource and UICollectionViewDelegate methods 
/// for `SampleImagesViewController`'s collectionView

class SampleImagesDataSourceDelegate: NSObject, UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return _imagesDataSource?.numberOfSections ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imagesDataSource?.numberOfImageItemsInSection(section) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if let imageViewModel = _imagesDataSource?.imageViewModelForItemAtIndexPath(indexPath) {
            cell.imageVewModel = imageViewModel
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                                      atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header: ImageCollectionViewGlobalHeader =
                collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                  forIndexPath: indexPath)
            header.sectionHeaderText = _imagesDataSource?.headerInSection(indexPath.section)
            return header
        } else {
            let header: ImageCollectionViewHeader =
                collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                      forIndexPath: indexPath)
            header.sectionHeaderText = _imagesDataSource?.headerInSection(indexPath.section)
            return header
        }
    }
    
    // MARK: - 🕶Private
    private var _imagesDataSource: ImagesDataSource?
}

extension SampleImagesDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSizeZero}
        let sectionInsetWidth = self.collectionView(collectionView, layout: layout,
                                                    insetForSectionAtIndex: indexPath.section).left
        let width = collectionView.bounds.width / 2 - layout.minimumInteritemSpacing / 2 - sectionInsetWidth
        return CGSize(width: width, height: width)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(collectionView.frame.size.width, 75)
        }
        else {
            return CGSizeMake(collectionView.frame.size.width, 35)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
}

/// AKPCollectionViewFlowLayoutDelegate
extension SampleImagesDataSourceDelegate: AKPCollectionViewFlowLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                                    viewForGlobalSupplementaryElementOfKind kind: String,
                                    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let globalHeader: ImageCollectionViewGlobalHeader =
            collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                  forIndexPath: indexPath)
        globalHeader.sectionHeaderText = _imagesDataSource?.headerInSection(indexPath.section)
        return globalHeader
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForGlobalSupplementaryElementOfKind kind: String,
                                                                atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let globalHeader: ImageCollectionViewGlobalHeader =
            collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
                                                                  forIndexPath: indexPath)
        return globalHeader
    }
}

extension SampleImagesDataSourceDelegate: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    func inject(imagesDataSource: ImagesDataSource) {
        self._imagesDataSource = imagesDataSource
    }
}





