//
//  AKPCollectionViewFlowLayout.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 18/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/**
 Sticky Headers using UICollectionViewFlowLayout
 Works for both for iOS8 and iOS9.
 
 For iOS9, since the sticky headers functionality is already built-in,
 it checks the `sectionHeadersPinToVisibleBounds` property not to interfere
 with the out-of-the-box implementation
 */


protocol AKPCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
}

class AKPCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var delegate: AKPCollectionViewFlowLayoutDelegate?
    var firstSectionIsGlobalHeader = true
    var firstSectionIsStretchable = true
    
    // MARK: - 📐Custom Layout
    /// Adds custom sticky header to the  UICollectionViewFlowLayout attributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard _shouldDoCustomLayout else { return super.layoutAttributesForElementsInRect(rect) }
        
        guard var layoutAttributes = super.layoutAttributesForElementsInRect(rect),
            // calucalte custom headers that should be confined in the rect
              let customSectionHeadersIdxs = customSectionHeadersIdxs(rect) else { return nil }
        
        // now add our custom headers to the regular UICollectionViewFlowLayout layoutAttributes
        for idx in customSectionHeadersIdxs {
            let indexPath = NSIndexPath(forItem: 0, inSection: idx)
            if let attributes = super.layoutAttributesForSupplementaryViewOfKind(
                                                            UICollectionElementKindSectionHeader,
                                                            atIndexPath: indexPath) {
                // add the custom headers to the layout attributes
                layoutAttributes.append(attributes)
            }
        }
        // for section headers in layoutAttributes, now time to adjust their attributes
        for attributes in layoutAttributes where
            attributes.representedElementKind == UICollectionElementKindSectionHeader {
                (attributes.frame, attributes.zIndex) = adjustLayoutAttributes(forSectionAttributes: attributes)
        }
        return layoutAttributes
    }
    
    /// Adjusts layout attributes for the custom sections
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String,
                                                             atIndexPath indexPath: NSIndexPath)
                                                                    -> UICollectionViewLayoutAttributes? {
        guard _shouldDoCustomLayout else {
            return super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)}
        
        guard let sectionHeaderAttributes = super.layoutAttributesForSupplementaryViewOfKind(
                                                                elementKind,
                                                                atIndexPath: indexPath) else { return nil }
        // For the purpose of invalidation, need to adjust section attributes
        (sectionHeaderAttributes.frame, sectionHeaderAttributes.zIndex) =
                                        adjustLayoutAttributes(forSectionAttributes: sectionHeaderAttributes)
        return sectionHeaderAttributes
    }
    
    // MARK: - 🎳Invalidation
    /// - returns: `true`, unless running on iOS9 with `sectionHeadersPinToVisibleBounds` set to `true`
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard _shouldDoCustomLayout else { return super.shouldInvalidateLayoutForBoundsChange(newBounds) }
        return true
    }
    
    /// Custom invalidation context
    override func invalidationContextForBoundsChange(newBounds: CGRect)
                                        -> UICollectionViewLayoutInvalidationContext {
        guard _shouldDoCustomLayout,
              let invalidationContext = super.invalidationContextForBoundsChange(newBounds)
                                                as? UICollectionViewFlowLayoutInvalidationContext,
              let oldBounds = collectionView?.bounds
                                                else {return super.invalidationContextForBoundsChange(newBounds)}
        // Size changes?
        if oldBounds.size != newBounds.size {
            // re-query the collection view delegate for metrics such as size information etc.
            invalidationContext.invalidateFlowLayoutDelegateMetrics = true
        }
        
        // Origin changes?
        if oldBounds.origin != newBounds.origin {
            // find and invalidate sections that would fall into the new bounds
            guard let sectionIdxPaths = sectionsHeadersIDxs(forRect: newBounds) else {return invalidationContext}
            
            // then invalidate
            let invalidatedIdxPaths = sectionIdxPaths.map { NSIndexPath(forItem: 0, inSection: $0) }
            invalidationContext.invalidateSupplementaryElementsOfKind(
                UICollectionElementKindSectionHeader, atIndexPaths: invalidatedIdxPaths )
        }
        return invalidationContext
    }
    
    // MARK: - 🕶Private Helpers
    private let _zIndexForSectionHeader = 1024
    
    // iOS9 supports sticky headers natively, so see if it should be used instead
    private var _shouldDoCustomLayout: Bool {
        return !sectionHeadersPinToVisibleBounds
    }

    /// Given a rect, calculates indexes of confined section headers
    private func sectionsHeadersIDxs(forRect rect: CGRect) -> Set<Int>? {
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect) else {return nil}
        var headersIdxs = layoutAttributes
            .filter { $0.representedElementCategory == .Cell ||
                $0.representedElementKind == UICollectionElementKindSectionHeader }
            .reduce(Set<Int>()) {
                var m = $0
                m.insert($1.indexPath.section)
                return m
        }
        if firstSectionIsGlobalHeader {
            headersIdxs.insert(0)
        }
        return headersIdxs
    }
    
    /// Given a rect, calculates the indexes of confined custom section headers
    private func customSectionHeadersIdxs(rect: CGRect) -> Set<Int>? {
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect),
            sectionIdxs = sectionsHeadersIDxs(forRect: rect)  else {return nil}
        
        // remove the sections that should already be taken care of by UICollectionViewFlowLayout
        let customHeadersIdxs = layoutAttributes
            .filter { $0.representedElementKind == UICollectionElementKindSectionHeader }
            .reduce(sectionIdxs) {
                var m = $0
                m.remove($1.indexPath.section)
                return m
        }
        return customHeadersIdxs
    }
    
    // Adjusts frames of section headers
    private func adjustLayoutAttributes(forSectionAttributes
        sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes) -> (CGRect, Int) {
        
        guard let collectionView = collectionView else { return (CGRect.zero, 0) }
        let section = sectionHeadersLayoutAttributes.indexPath.section
        var sectionFrame = sectionHeadersLayoutAttributes.frame

        // get attributes for first and last items in section
        let lastInSectionIdx = collectionView.numberOfItemsInSection(section) - 1
        guard let attributesForFirstItemInSection = layoutAttributesForItemAtIndexPath(
                                        NSIndexPath(forItem: 0, inSection: section)),
              let attributesForLastItemInSection = layoutAttributesForItemAtIndexPath(
                                        NSIndexPath(forItem: lastInSectionIdx, inSection: section))
                                                                            else {return (CGRect.zero, 0)}
        // height the first section
        var firstSectionHeight = headerReferenceSize.height
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where firstSectionHeight == 0 {
            firstSectionHeight = delegate.collectionView!(collectionView,
                                                     layout: self,
                                                     referenceSizeForHeaderInSection: 0).height
        }
        
        // the section insets
        var theSectionInset = sectionInset
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where theSectionInset == UIEdgeInsetsZero {
            theSectionInset = delegate.collectionView!(collectionView,
                                                           layout: self,
                                                           insetForSectionAtIndex: section)
        }
        
        // 1. Let's first set the boundaries:
        //   The section should not be higher than the top of the first cell in section
        let minY = attributesForFirstItemInSection.frame.minY - sectionFrame.height
        //   The section should not be lower than the bottom of the last cell
        let maxY = attributesForLastItemInSection.frame.maxY - sectionFrame.height
        
        // 2. If within these boundaries, follow the content offset && adjust a few more things along the way
        var offset = collectionView.contentOffset.y + collectionView.contentInset.top + theSectionInset.top
        if (section > 0) {
            // A global header adjustment
            if firstSectionIsGlobalHeader {
                offset += firstSectionHeight
            }
            sectionFrame.origin.y = min(max(offset, minY), maxY)
        } else {
            // A stretchy header adjustment
            if firstSectionIsStretchable && offset < 0 {
                sectionFrame.size.height = firstSectionHeight - offset
                sectionFrame.origin.y += offset
            // A global header adjustment
            } else if firstSectionIsGlobalHeader {
                sectionFrame.origin.y += offset
            } else {
                sectionFrame.origin.y = min(max(offset, minY), maxY)
            }
        }
        
        return (sectionFrame, section > 0 ? _zIndexForSectionHeader : _zIndexForSectionHeader + 1)
    }
}







