//
//  ImageFetcher.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit
import AlamofireImage

/// Fetches images from network
/// Provides a simple image cache with a fixed predefined capacity

struct ImageFetcher {
    // MARK: - 👀Public
    /// Looks to provide an image from internal cache
    /// If not there, uses an image service to fetch it from network and,
    /// if successfull, caches the image
    func fetchImage(urlString: String, completion: UIImage? -> ()) {
        if let image = cachedImage(urlString) {
            completion(image)
        } else {
            _imageService?.requestImage(urlString) { result in
                do {
                    let image = try result.resolve()
                    self.cacheImage(urlString, image: image)
                    completion(image)
                } catch {
                    completion(nil)
                }
            }
        }
    }    
    
    // MARK: - 🕶Private
    private var _imageService: NetworkImageService?

    private func cacheImage(imageURLString: String, image: Image) {
        _imageCache.addImage(image, withIdentifier: imageURLString)
    }
    private func cachedImage(imageURLString: String) -> Image? {
        return _imageCache.imageWithIdentifier(imageURLString)
    }
    private let _imageCache = AutoPurgingImageCache(
        //The total memory capacity of the cache in bytes.
        memoryCapacity: 100 * 1024 * 1024,
        
        //preferred memory usage after purge in bytes
        preferredMemoryUsageAfterPurge: 100 * 1024 * 1024
    )    
}

extension ImageFetcher: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    mutating func inject(imageService: NetworkImageService) {
        self._imageService = imageService
    }
}

