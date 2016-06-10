//
//  AKPCollectionViewFlowLayout.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 18/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/**
 Global / Sticky / Stretchy Headers using UICollectionViewFlowLayout
 Works for both for iOS8 and iOS9
 */

enum AKPCollectionViewFlowLayoutError: ErrorType {
    case SectionHeadersPinToVisibleBoundsError
}

class AKPCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var layoutOptions: LayoutConfigOptions = [.FirstSectionIsGlobalHeader,
                                              .FirstSectionStretchable,
                                              .SectionsPinToGlobalHeaderOrVisibleBounds]
    
    // AKPCollectionViewFlowLayout supports sticky headers by default,
    // and it should not interfere with the the built-in functionality
    override var sectionHeadersPinToVisibleBounds: Bool {
        didSet {
            do {
                try _checkSectionHeadersPinToVisibleBounds(sectionHeadersPinToVisibleBounds)
            } catch {
                print("AKPCollectionViewFlowLayout supports sticky headers by default, therefore " +
                      "The built-in functionality via sectionHeadersPinToVisibleBounds has been disabled")
                sectionHeadersPinToVisibleBounds = false
            }
        }
    }
    
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
                                                else { return super.invalidationContextForBoundsChange(newBounds) }
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
    private var _shouldDoCustomLayout: Bool {
        let requestForCustomLayout = layoutOptions.contains(.FirstSectionIsGlobalHeader) ||
                                     layoutOptions.contains(.FirstSectionStretchable) ||
                                     layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds)
        
        // hope the annoying compiler warning (Radar 21324005) will get fixed at some point...
        // http://ericasadun.com/2015/06/10/swift-is-available-the-most-irritating-new-swift-feature/
        if #available(iOS 9.0, *) {
            // iOS9 supports sticky headers natively, so we should not 
            // interfere with the the built-in functionality
            return !sectionHeadersPinToVisibleBounds && requestForCustomLayout
        }
        return requestForCustomLayout
    }
    
    private func _checkSectionHeadersPinToVisibleBounds(value: Bool) throws {
        if value {
            throw AKPCollectionViewFlowLayoutError.SectionHeadersPinToVisibleBoundsError
        }
    }
    private let _zIndexForSectionHeader = 1024

    /// Given a rect, calculates indexes of confined section headers 
    /// including the custom headers
    private func sectionsHeadersIDxs(forRect rect: CGRect) -> Set<Int>? {
        guard let layoutAttributes = super.layoutAttributesForElementsInRect(rect) else {return nil}
        var headersIdxs = layoutAttributes
            .filter { ( layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds) &&
                        $0.representedElementCategory == .Cell ) ||
                            $0.representedElementKind == UICollectionElementKindSectionHeader }
            .reduce(Set<Int>()) {
                var m = $0
                m.insert($1.indexPath.section)
                return m
        }
        if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
            headersIdxs.insert(0)
        }
        return headersIdxs
    }
    
    /// Given a rect, calculates the indexes of confined custom section headers
    /// excluding the regular headers handled by UICollectionViewFlowLayout
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
    private func adjustLayoutAttributes(
                    forSectionAttributes sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes)
                                                                                            -> (CGRect, Int) {
        guard let collectionView = collectionView else { return (CGRect.zero, 0) }
        let section = sectionHeadersLayoutAttributes.indexPath.section
        var sectionFrame = sectionHeadersLayoutAttributes.frame

        // 1. Let's establish the section boundaries:
        let (minY, maxY) = boundaryMetrics(forSectionAttributes: sectionHeadersLayoutAttributes)
        
        // 2. Let's also determine the height abd insets of the first section,
        //    in case it's stretchable or serves as a global header
        let (firstSectionHeight, firstSectionInsets) = firstSectionMetrics()
                                                                                                
        // 3. If within the above boundaries, the section should follow content offset
        //   (adjusting a few more things along the way)
        var offset = collectionView.contentOffset.y + collectionView.contentInset.top
        if (section > 0) {
            if layoutOptions.contains(.SectionsPinToGlobalHeaderOrVisibleBounds) {
                if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
                    // A global header adjustment
                    offset += firstSectionHeight + firstSectionInsets.top
                }
                sectionFrame.origin.y = min(max(offset, minY), maxY)
            }
        } else {
            if layoutOptions.contains(.FirstSectionStretchable) && offset < 0 {
                // A stretchy header adjustment
                sectionFrame.size.height = firstSectionHeight - offset
                sectionFrame.origin.y += offset + firstSectionInsets.top
            } else if layoutOptions.contains(.FirstSectionIsGlobalHeader) {
                // A global header adjustment
                sectionFrame.origin.y += offset + firstSectionInsets.top
            } else {
                sectionFrame.origin.y = min(max(offset, minY), maxY)
            }
        }
        return (sectionFrame, section > 0 ? _zIndexForSectionHeader : _zIndexForSectionHeader + 1)
    }
    
    private func boundaryMetrics(
                    forSectionAttributes sectionHeadersLayoutAttributes: UICollectionViewLayoutAttributes)
                                                                                        -> (CGFloat, CGFloat) {
            // get attributes for first and last items in section
            guard let collectionView = collectionView  else { return (0, 0) }
            let section = sectionHeadersLayoutAttributes.indexPath.section
            
            // Trying to use layoutAttributesForItemAtIndexPath for empty section would
            // cause EXC_ARITHMETIC in simulator (division by zero items)
            let lastInSectionIdx = collectionView.numberOfItemsInSection(section) - 1
            if lastInSectionIdx < 0 { return (0, 0) }
                                                                                            
            guard let attributesForFirstItemInSection = layoutAttributesForItemAtIndexPath(
                                            NSIndexPath(forItem: 0, inSection: section)),
                let attributesForLastItemInSection = layoutAttributesForItemAtIndexPath(
                                            NSIndexPath(forItem: lastInSectionIdx, inSection: section))
                else {return (0, 0)}
            let sectionFrame = sectionHeadersLayoutAttributes.frame
            
            // Section Boundaries:
            //   The section should not be higher than the top of its first cell
            let minY = attributesForFirstItemInSection.frame.minY - sectionFrame.height
            //   The section should not be lower than the bottom of its last cell
            let maxY = attributesForLastItemInSection.frame.maxY - sectionFrame.height
            return (minY, maxY)
    }
    
    private func firstSectionMetrics() -> (height: CGFloat, insets: UIEdgeInsets) {
        guard let collectionView = collectionView else { return (0, UIEdgeInsetsZero) }
        // height of the first section
        var firstSectionHeight = headerReferenceSize.height
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where firstSectionHeight == 0 {
            firstSectionHeight = delegate.collectionView!(collectionView,
                                                          layout: self,
                                                          referenceSizeForHeaderInSection: 0).height
        }
        // insets of the first section
        var theSectionInset = sectionInset
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
                                                            where theSectionInset == UIEdgeInsetsZero {
            theSectionInset = delegate.collectionView!(collectionView,
                                                       layout: self,
                                                       insetForSectionAtIndex: 0)
        }
        return (firstSectionHeight, theSectionInset)
    }
}







