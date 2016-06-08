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
    var compositeStackView: UIStackView?
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let globalHeaderStackView = configureStackView("About Cats and Dogs...",
                                                   selector: #selector(onGLobalHeaderSwitch(_:)))
        
        compositeStackView = UIStackView().configure {
            $0.axis = .Vertical
            $0.distribution = .Fill
            $0.alignment = .Fill
            $0.spacing = 2.0
            self.addSubview($0)
            
            $0.addArrangedSubview(globalHeaderStackView)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        backgroundColor = UIColor.darkGrayColor()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension ImageCollectionViewGlobalHeader {
    func onGLobalHeaderSwitch(on: Bool) {
        
    }
}

extension ImageCollectionViewGlobalHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        guard let compositeStackView = compositeStackView else {return}
        compositeStackView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        compositeStackView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        compositeStackView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        compositeStackView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
    }
}

extension ImageCollectionViewGlobalHeader {
    func configureStackView(labelText: String, selector: Selector) -> UIStackView {
        let stackView = UIStackView().configure {
            $0.axis = .Horizontal
            $0.distribution = .Fill
            $0.alignment = .Fill
            $0.spacing = 2.0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        _ = UILabel().configure {
            $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            $0.textColor = UIColor.whiteColor()
            $0.textAlignment = .Center
            $0.text = labelText
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setContentHuggingPriority(250.0, forAxis: .Horizontal)
            $0.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
            stackView.addArrangedSubview($0)
        }
        _ = UISwitch().configure {
            $0.userInteractionEnabled = true
            $0.on = true
            $0.addTarget(self, action: selector, forControlEvents: .ValueChanged)
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        return stackView
    }
}


extension ImageCollectionViewGlobalHeader: DebugConfigurable {
    func _configureForDebug() {
        backgroundColor = UIColor.cyanColor()
    }
}

