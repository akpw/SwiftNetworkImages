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
    var configStackView: UIStackView?
    var configButton: UIButton?
    var label: UILabel?
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .darkGrayColor()

        configureStackView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewGlobalHeader {
    func configureStackView() {
        label = UILabel().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            $0.textColor = .whiteColor()
            $0.textAlignment = .Center
            $0.text = "About Cats and Dogs"
            $0.setContentHuggingPriority(249, forAxis: .Horizontal)
            $0.setContentCompressionResistancePriority(500, forAxis: .Horizontal)
        }
        configButton = UIButton(type: .Custom).configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setBackgroundImage(UIImage(asset: .LayoutConfigOptions), forState: .Normal)
            $0.showsTouchWhenHighlighted = true
            $0.addTarget(nil, action: .showLayoutConfigOptions, forControlEvents:.TouchUpInside)
        }
        configStackView = UIStackView().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .Horizontal
            $0.distribution = .Fill
            $0.alignment = .Center
            $0.spacing = 10.0
            $0.layoutMargins = UIEdgeInsets(top: 0, left: $0.spacing, bottom: 0, right: $0.spacing)
            $0.layoutMarginsRelativeArrangement = true
            $0.addArrangedSubview(label!)
            $0.addArrangedSubview(configButton!)
            self.addSubview($0)
        }
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let configStackView = configStackView else {return}
        
        configStackView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        configStackView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        configStackView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        configStackView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
    }
}

// MARK: - 🐞Debug configuration
extension ImageCollectionViewGlobalHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = .cyanColor()
    }
}

// MARK: - private Selector extension for usage with the responder chain
private extension Selector {
    static let showLayoutConfigOptions = #selector(SampleImagesViewController.showLayoutConfigOptions(_:))
}


