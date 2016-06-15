//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// A custom UICollectionReusableView section header


class ImageCollectionViewHeader: UICollectionReusableView {
    var sectionHeaderLabel: UILabel?
    var sectionHeaderText: String? {
        didSet {
            sectionHeaderLabel?.text = sectionHeaderText
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sectionHeaderLabel = UILabel().configure {
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            $0.text = "Section Header"
            $0.textAlignment = .Center
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        backgroundColor = .lightGrayColor()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let sectionHeaderLabel = sectionHeaderLabel else {return}
        NSLayoutConstraint.activateConstraints([
            sectionHeaderLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor),
            sectionHeaderLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor),
            sectionHeaderLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20)
        ])
    }
}

// MARK: - 🐞Debug configuration
extension ImageCollectionViewHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = .magentaColor()
    }
}


