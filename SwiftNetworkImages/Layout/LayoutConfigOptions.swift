//
//  LayoutConfigOptions.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

/// AKPCollectionViewFlowLayout configuration options

struct LayoutConfigOptions: OptionSetType {
    let rawValue: Int
    static let FirstSectionIsGlobalHeader =
                        LayoutConfigOptions(rawValue: 1 << 1)
    static let FirstSectionStretchable =
                        LayoutConfigOptions(rawValue: 1 << 2)
    static let SectionsPinToGlobalHeaderOrVisibleBounds =
                        LayoutConfigOptions(rawValue: 1 << 3)
}

extension LayoutConfigOptions: CustomStringConvertible {
    var descriptions: [String] {
        let optionsDescriptions = ["First Section Is Global Header",
                                   "First Section Stretchable",
                                   "Sections Pin To Global Header Or Visible Bounds"]
        var memberDescriptions = [String]()
        for (shift, description) in optionsDescriptions.enumerate()
                    where contains( LayoutConfigOptions(rawValue: 1<<(shift + 1)) ) {
            memberDescriptions.append(description)
        }
        return memberDescriptions
    }
    
    var description: String {
        return descriptions.description
    }
}



