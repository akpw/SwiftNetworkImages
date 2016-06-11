//
//  NSObject+Configure.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 29/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Syntactic sugar for Swift initializers,
/// CCed from: https://github.com/devxoul/Then

public protocol Configure {}
extension Configure {
    public func configure(@noescape block: inout Self -> Void) -> Self {
        var m = self
        block(&m)
        return m
    }
}

extension UIResponder: Configure {}