//
//  ImagesDataSource.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/// A helper class for the UICollectionView DataSource methods

struct ImagesDataSource {
    // MARK: - 👀Public
    /// UICollectionView DataSource Helpers
    var numberOfSections: Int {
        return _sortedDictionary?.count ?? 0
    }
    
    func numberOfImageItemsInSection(section: Int) -> Int {
        guard let imageItems = _sortedDictionary?.valueForKeyAtIndex(section) else {return 0}
        return imageItems.count
    }
    
    func headerInSection(section: Int) -> String? {
        guard let sections = _sortedDictionary?.sortedKeys else {return nil}
        return sections[section]
    }
    
    func imageViewModelForItemAtIndexPath(indexPath: NSIndexPath) -> ImageViewModel? {
        guard let imageItems = _sortedDictionary?.valueForKeyAtIndex(indexPath.section) else {return nil}
        
        var imageViewModel = ImageViewModel(imageInfo: imageItems[indexPath.item])
        imageViewModel.imageFetcher = _imageFetcher
        return imageViewModel
    }
    
    // MARK: - 🕶Private
    private var _imageInfoLoader: ImageInfoLoadable?
    private var _imageFetcher: ImageFetcher?
    private var _sortedDictionary: SortedDictionary<String, [ImageInfo]>?
}

extension ImagesDataSource: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    typealias ExternalDependencies = (imageInfoLoader: ImageInfoLoadable, imageFetcher: ImageFetcher)
    mutating func inject(dependencies: ExternalDependencies) {
        _imageInfoLoader = dependencies.imageInfoLoader
        _imageFetcher = dependencies.imageFetcher
        _sortedDictionary = dependencies.imageInfoLoader.loadImagesInfo()
    }
}