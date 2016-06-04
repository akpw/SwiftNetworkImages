//
//  AKPDataSource.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 1/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


struct GlobalSectionMetrics {
    
}

protocol AKPDataSource {
    var globalSection: GlobalSectionMetrics? {get set}
    
    associatedtype Data
    var sectionedData: SortedDictionary<String, [Data]>? {get set}
    mutating func loadData(sectionedData: SortedDictionary<String, [Data]>)
    
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
}

extension AKPDataSource {
    mutating func loadData(data: SortedDictionary<String, [Data]>) {
        sectionedData = data
    }
    
    func numberOfSections() -> Int {
        return sectionedData?.count ?? 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return 0
    }
}


struct AAA: AKPDataSource {
    typealias Data = ImageInfo
    var sectionedData: SortedDictionary<String, [Data]>?
    var globalSection: GlobalSectionMetrics?
}


extension AAA: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    typealias ExternalDependencies = (imageInfoLoader: ImageInfoLoadable, imageFetcher: ImageFetcher)
    mutating func inject(dependencies: ExternalDependencies) {
        sectionedData = dependencies.imageInfoLoader.loadImagesInfo()
    }
}