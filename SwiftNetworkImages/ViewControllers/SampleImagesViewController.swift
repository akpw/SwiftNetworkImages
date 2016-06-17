//
//  SampleImagesViewController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit
import AKPFlowLayout

/**
    Top level view controller for the project
 */

class SampleImagesViewController: UIViewController {
    var layoutOptions: AKPLayoutConfigOptions = [.FirstSectionIsGlobalHeader,
                                              .FirstSectionStretchable,
                                              .SectionsPinToGlobalHeaderOrVisibleBounds]
    override func prefersStatusBarHidden() -> Bool { return true }
    
    // MARK: - ♻️Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setConstraints()
        //_configureForDebug($0)
    }
    
    // MARK: - 🕶Private
    private var _collectionView: UICollectionView?
    private var _dataSourceDelegate: SampleImagesDataSourceDelegate?
}

// MARK: - 📐Layout && Constraints
extension SampleImagesViewController {
    func configureCollectionView() {
        let flowLayout: AKPFlowLayout = {
            $0.minimumInteritemSpacing = 2
            $0.layoutOptions = layoutOptions
            $0.firsSectionMaximumStretchHeight = view.bounds.width 
            return $0
        }( AKPFlowLayout() )
        
        _collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor.grayColor()
            
            $0.dataSource = _dataSourceDelegate
            $0.delegate = _dataSourceDelegate
            
            $0.registerClass(ImageCollectionViewCell.self)
            $0.registerClass(ImageCollectionViewHeader.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            $0.registerClass(ImageCollectionViewGlobalHeader.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            
            view.addSubview($0)
        }
    }
    func setConstraints() {
        guard let collectionView = _collectionView else {return}
        NSLayoutConstraint.activateConstraints([
            collectionView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
        ])
    }
}

// MARK: - Layout Config Options (UIPopoverPresentationControllerDelegate)
extension SampleImagesViewController: UIPopoverPresentationControllerDelegate {
    func showLayoutConfigOptions(sender: UIButton) {
        let configController = LayoutConfigController(style: UITableViewStyle.Grouped)
        configController.configOptions = [.FirstSectionIsGlobalHeader,
                                          .FirstSectionStretchable,
                                          .SectionsPinToGlobalHeaderOrVisibleBounds]
        configController.selectedOptions = layoutOptions
        configController.modalPresentationStyle = .Popover
        configController.preferredContentSize = CGSizeMake(355, configController.height)
        
        if let popOver = configController.popoverPresentationController {
            popOver.backgroundColor = .darkGrayColor()
            popOver.permittedArrowDirections = .Any
            popOver.delegate = self
            popOver.sourceView = sender
            popOver.sourceRect = sender.bounds
            presentViewController(configController, animated: true, completion: nil)
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController)
                                                                            -> UIModalPresentationStyle {
            return .None
    }
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController:
        UIPopoverPresentationController) {
        if let configController = popoverPresentationController.presentedViewController
                                                                            as? LayoutConfigController {
            if let selectedOptions = configController.selectedOptions,
                layout = self._collectionView?.collectionViewLayout as? AKPFlowLayout {
                self.layoutOptions = selectedOptions
                if layout.layoutOptions != selectedOptions {
                    layout.layoutOptions = selectedOptions
                    layout.invalidateLayout()
                }
            }
        }
    }
}

// MARK: - 🔌Dependencies injection
extension SampleImagesViewController: DependencyInjectable {
    func inject(dataSourceDelegate: SampleImagesDataSourceDelegate) {
        _dataSourceDelegate = dataSourceDelegate
    }
    
}

// MARK: - 🐞Debug configuration
extension SampleImagesViewController: DebugConfigurable {
    private func _configureForDebug(collectionView: UICollectionView) -> UICollectionView {
        collectionView.backgroundColor = .greenColor()
        collectionView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        return collectionView
    }
}

