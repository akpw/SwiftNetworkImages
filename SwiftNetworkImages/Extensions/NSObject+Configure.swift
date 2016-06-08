//
//  NSObject+Configure.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 29/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

public protocol Configure {}
extension Configure {
    public func configure(@noescape block: inout Self -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
//    public func optionalConfigure(@noescape block: inout Self -> Void) -> Self? {
//        var copy = self
//        block(&copy)
//        return copy
//    }
}

extension UIResponder: Configure {}