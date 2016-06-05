//
//  ImageCollectionViewGlobalHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 17/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// A custom UICollectionReusableView section header

class ImageCollectionViewGlobalHeader: UICollectionReusableView {
    var sectionHeaderLabel: UILabel?
    var sectionHeaderText: String? {
        didSet {
            sectionHeaderLabel?.text = sectionHeaderText
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sectionHeaderLabel = {
            let label = UILabel()
            label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            label.text = "Global Section Header"
            label.textAlignment = .Center
            
            self.addSubview(label)
            return label
        }()
        
        backgroundColor = UIColor.darkGrayColor()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let sectionHeaderLabel = sectionHeaderLabel else {return}
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        sectionHeaderLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        sectionHeaderLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20).active = true
    }
    
}

extension ImageCollectionViewGlobalHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = UIColor.cyanColor()
    }
}




