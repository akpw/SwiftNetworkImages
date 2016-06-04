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
        
        let flowLayout: AKPCollectionViewFlowLayout = {
            $0.minimumInteritemSpacing = 2
            return $0
        }( AKPCollectionViewFlowLayout() )
        
        _collectionView = {
            $0.backgroundColor = UIColor.greenColor()
            
            $0.dataSource = _dataSourceDelegate
            $0.delegate = _dataSourceDelegate
            
            $0.registerClass(ImageCollectionViewCell.self)
            $0.registerClass(ImageCollectionViewHeader.self,
                                         forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            $0.registerClass(ImageCollectionViewGlobalHeader.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            view.addSubview($0)
            return $0
        }( UICollectionView(frame: .zero, collectionViewLayout: flowLayout) )
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



