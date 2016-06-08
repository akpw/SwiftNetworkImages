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
            $0.backgroundColor = UIColor.lightTextColor()
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
        $0.color = UIColor.darkGrayColor()
        return $0
    }( UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge) )
}

extension ImageCollectionViewCell {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let roundedCornersView = roundedCornersView,
                  captionLabel = captionLabel, imageView = imageView else {return}
        
        roundedCornersView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        roundedCornersView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        roundedCornersView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
        roundedCornersView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true

        imageView.topAnchor.constraintEqualToAnchor(roundedCornersView.topAnchor).active = true
        imageView.leadingAnchor.constraintEqualToAnchor(roundedCornersView.leadingAnchor).active = true
        imageView.trailingAnchor.constraintEqualToAnchor(roundedCornersView.trailingAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(roundedCornersView.heightAnchor,
                                                                                multiplier: 0.90).active = true
        
        _loadingIndicator.centerXAnchor.constraintEqualToAnchor(imageView.centerXAnchor).active = true
        _loadingIndicator.centerYAnchor.constraintEqualToAnchor(imageView.centerYAnchor).active = true
        
        let layoutGuide = UILayoutGuide()
        roundedCornersView.addLayoutGuide(layoutGuide)
        layoutGuide.bottomAnchor.constraintEqualToAnchor(roundedCornersView.bottomAnchor).active = true
        layoutGuide.leadingAnchor.constraintEqualToAnchor(roundedCornersView.leadingAnchor).active = true
        layoutGuide.trailingAnchor.constraintEqualToAnchor(roundedCornersView.trailingAnchor).active = true
        layoutGuide.heightAnchor.constraintEqualToAnchor(roundedCornersView.heightAnchor,
                                                                                multiplier: 0.10).active = true
        
        captionLabel.centerXAnchor.constraintEqualToAnchor(layoutGuide.centerXAnchor).active = true
        captionLabel.centerYAnchor.constraintEqualToAnchor(layoutGuide.centerYAnchor).active = true
        captionLabel.leadingAnchor.constraintEqualToAnchor(roundedCornersView.layoutMarginsGuide.leadingAnchor).active = true
    }
}

extension ImageCollectionViewCell: DebugConfigurable {
    func _configureForDebug() {
        guard let roundedCornersView = roundedCornersView,
            captionLabel = captionLabel, imageView = imageView else {return}
        
        contentView.backgroundColor = UIColor.cyanColor()
        roundedCornersView.backgroundColor = UIColor.greenColor()
        imageView.backgroundColor = UIColor.redColor()
        captionLabel.backgroundColor = UIColor.yellowColor()
    }
}