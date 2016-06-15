//
//  ImageCollectionViewCell.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/**
    A custom UICollectionViewCell that presents an image with caption,
    based on ovservable data from its ImageViewModel
*/

@IBDesignable class ImageCollectionViewCell: UICollectionViewCell {
    var roundedCornersView: RoundedCornersView?
    var imageView: UIImageView?
    var captionLabel: UILabel?

    var imageVewModel: ImageViewModel? {
        didSet {
            guard let imageVewModel = imageVewModel else {return}
            imageVewModel.imageCaption.observe { [weak self] in
                self?.captionLabel?.text = $0
            }
            _loadingIndicator.startAnimating()
            _loadingIndicator.hidden = false
            imageVewModel.image.observe { [weak self] in
                self?.imageView?.image = $0
                dispatch_after(delayInSeconds: 0.7) {
                    self?._loadingIndicator.stopAnimating()
                    self?._loadingIndicator.hidden = true
                }
            }
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        roundedCornersView = RoundedCornersView().configure {
            $0.cornerRadius = 4.0
            $0.backgroundColor = .lightTextColor()
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        imageView = UIImageView().configure {
            $0.contentMode = .ScaleAspectFill
            $0.addSubview(_loadingIndicator)
            roundedCornersView?.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        captionLabel = UILabel().configure {
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            $0.text = "Image Caption"
            $0.textAlignment = .Center
            roundedCornersView?.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
            $0.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        }
        // _configureForDebug()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - 🕶Private
    private lazy var _loadingIndicator: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.color = .darkGrayColor()
        return $0
    }( UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge) )
}

extension ImageCollectionViewCell {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let roundedCornersView = roundedCornersView,
                  captionLabel = captionLabel, imageView = imageView else {return}
        
        let layoutGuide = UILayoutGuide()
        roundedCornersView.addLayoutGuide(layoutGuide)
        
        NSLayoutConstraint.activateConstraints([
            roundedCornersView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            roundedCornersView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            roundedCornersView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            roundedCornersView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),

            imageView.topAnchor.constraintEqualToAnchor(roundedCornersView.topAnchor),
            imageView.leadingAnchor.constraintEqualToAnchor(roundedCornersView.leadingAnchor),
            imageView.trailingAnchor.constraintEqualToAnchor(roundedCornersView.trailingAnchor),
            imageView.heightAnchor.constraintEqualToAnchor(roundedCornersView.heightAnchor,
                                                                                    multiplier: 0.90),
            _loadingIndicator.centerXAnchor.constraintEqualToAnchor(imageView.centerXAnchor),
            _loadingIndicator.centerYAnchor.constraintEqualToAnchor(imageView.centerYAnchor),
            
            layoutGuide.bottomAnchor.constraintEqualToAnchor(roundedCornersView.bottomAnchor),
            layoutGuide.leadingAnchor.constraintEqualToAnchor(roundedCornersView.leadingAnchor),
            layoutGuide.trailingAnchor.constraintEqualToAnchor(roundedCornersView.trailingAnchor),
            layoutGuide.heightAnchor.constraintEqualToAnchor(roundedCornersView.heightAnchor,
                                                                                    multiplier: 0.10),            
            captionLabel.centerXAnchor.constraintEqualToAnchor(layoutGuide.centerXAnchor),
            captionLabel.centerYAnchor.constraintEqualToAnchor(layoutGuide.centerYAnchor),
            captionLabel.leadingAnchor.constraintEqualToAnchor(roundedCornersView.layoutMarginsGuide.leadingAnchor)
        ])
    }
}

// MARK: - 🐞Debug configuration
extension ImageCollectionViewCell: DebugConfigurable {
    func _configureForDebug() {
        guard let roundedCornersView = roundedCornersView,
            captionLabel = captionLabel, imageView = imageView else {return}
        
        contentView.backgroundColor = .cyanColor()
        roundedCornersView.backgroundColor = .greenColor()
        imageView.backgroundColor = .redColor()
        captionLabel.backgroundColor = .yellowColor()
    }
}