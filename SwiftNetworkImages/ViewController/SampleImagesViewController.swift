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


class SampleImagesViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
   
    func showPopover(sender: UIBarButtonItem) {
        let vc = MultipleChoiceController(style: UITableViewStyle.Grouped)
        vc.choices = ["First Section is GLobal Header",
                      "First Section is Stretchable",
                      "Sections Pin to Global Header or Visible Bounds"]
        vc.allowMultipleSelections = true
        
        vc.modalPresentationStyle = .Popover
        vc.preferredContentSize = CGSizeMake(400, vc.height)
        
        if let popoverPresentationViewController = vc.popoverPresentationController {
            popoverPresentationViewController.permittedArrowDirections = .Any
            popoverPresentationViewController.delegate = self
            popoverPresentationViewController.barButtonItem = sender
            presentViewController(vc, animated: true, completion: nil)
        }
    }


func adaptivePresentationStyleForPresentationController(controller: UIPresentationController)
                                                                            -> UIModalPresentationStyle{
    return .None
}
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController:
                                                                UIPopoverPresentationController) {
        if let vc  = popoverPresentationController.presentedViewController as? MultipleChoiceController {
            print(vc.selectedItems)
        }
    }

    
    
    func showConfig() {
        let vc = MultipleChoiceController(style: UITableViewStyle.Grouped)
        vc.choices = ["Apples", "Oranges", "Bananas"] //Provide an array of choices. These must be NSObjects.
        
        vc.allowMultipleSelections = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func multipleChoiceController(controller: MultipleChoiceController, didSelectItems items: [NSObject]) {
        //Do something with the "items" the user selected.
        print(items)
    }

    
    // MARK: - ♻️Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action,
                                                            target: self,
                                                            action: #selector(showPopover(_:)))
        
        let flowLayout: AKPCollectionViewFlowLayout = {
            $0.minimumInteritemSpacing = 2
            return $0
        }( AKPCollectionViewFlowLayout() )
        
        _collectionView = {
            $0.backgroundColor = UIColor.lightGrayColor()
            
            $0.dataSource = _dataSourceDelegate
            $0.delegate = _dataSourceDelegate
            
            $0.registerClass(ImageCollectionViewCell.self)
            $0.registerClass(ImageCollectionViewHeader.self,
                                         forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            $0.registerClass(ImageCollectionViewGlobalHeader.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader)
            
            $0.allowsSelection = true
            $0.allowsMultipleSelection = true
            
            view.addSubview($0)
            //_configureForDebug($0)
            
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

extension SampleImagesViewController: DebugConfigurable {
    private func _configureForDebug(collectionView: UICollectionView) -> UICollectionView {
        collectionView.backgroundColor = UIColor.greenColor()
        collectionView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0)
        return collectionView
    }
}

