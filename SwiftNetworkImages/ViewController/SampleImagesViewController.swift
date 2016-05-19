//
//  SampleImagesViewController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/**
    Top level view controller for the project
 */


class SampleImagesViewController: UIViewController {
    
    // MARK: - ♻️Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView = {
            let flowLayout = AKPCollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 2
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.backgroundColor = UIColor.whiteColor()
            
            collectionView.dataSource = _dataSourceDelegate
            collectionView.delegate = _dataSourceDelegate
            
            collectionView.registerClass(ImageCollectionViewCell.self)
            collectionView.registerClass(ImageCollectionViewHeader.self,
                                         forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            view.addSubview(collectionView)
            return collectionView
        }()
        setConstraints()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - 🕶Private
    private var _collectionView: UICollectionView?
    private var _dataSourceDelegate: SampleImagesDataSourceDelegate?
}

extension SampleImagesViewController: DependencyInjectable {
    // MARK: - 🔌Dependencies injection
    func inject(dataSourceDelegate: SampleImagesDataSourceDelegate) {
        _dataSourceDelegate = dataSourceDelegate
    }
    
}
    
extension SampleImagesViewController {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let collectionView = _collectionView else {return}
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.bottomAnchor).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    }
}



