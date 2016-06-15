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
import AKPFlowLayout

/// Custom UICollectionReusableView section header that serves as
/// a Global Header

class ImageCollectionViewGlobalHeader: UICollectionReusableView {
    var configStackView: UIStackView?
    var configButton: UIButton?
    var label: UILabel?
    var backgroundImageView: UIImageView?
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .darkGrayColor()
        self.clipsToBounds = true

        configureStackView()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var bckgImageViewFullHeight: CGFloat = 0
    private var bckgImageViewHeightConstraint: NSLayoutConstraint?
}

extension ImageCollectionViewGlobalHeader {
    func configureStackView() {
        let backgImage = UIImage(asset: .GlobalHeaderBackground)
        bckgImageViewFullHeight = backgImage.size.width *  backgImage.scale

        backgroundImageView = UIImageView().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = backgImage
            $0.contentMode = .ScaleAspectFill
            addSubview($0)
        }
        label = UILabel().configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            $0.textColor = .whiteColor()
            $0.textAlignment = .Center
            $0.text = "About Cats and Dogs..."
            $0.setContentHuggingPriority(249, forAxis: .Horizontal)
            $0.setContentCompressionResistancePriority(500, forAxis: .Horizontal)
        }
        configButton = UIButton(type: .Custom).configure {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsAsset), forState: .Normal)
            $0.setBackgroundImage(UIImage(asset: .LayoutConfigOptionsTouchedAsset), forState: .Selected)
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
            addSubview($0)
        }
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let configStackView = configStackView,  backgroundImageView = backgroundImageView else {return}
        
        bckgImageViewHeightConstraint = {
            $0.priority = UILayoutPriorityRequired
            return $0
        }( backgroundImageView.heightAnchor.constraintEqualToConstant(bckgImageViewFullHeight) )
        
        NSLayoutConstraint.activateConstraints([
            backgroundImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
            backgroundImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
            bckgImageViewHeightConstraint!,
            backgroundImageView.widthAnchor.constraintEqualToAnchor(backgroundImageView.heightAnchor),
            
            configStackView.topAnchor.constraintEqualToAnchor(topAnchor),
            configStackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
            configStackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
            configStackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
        ])
    }
}

extension ImageCollectionViewGlobalHeader {
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes = layoutAttributes as? AKPFlowLayoutAttributes,
                  bckgImageViewHeightConstraint = bckgImageViewHeightConstraint else { return }
        bckgImageViewHeightConstraint.constant = bckgImageViewFullHeight - layoutAttributes.stretchFactor
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


