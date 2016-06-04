//
//  NSObject+Configure.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 29/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

public protocol Configure {}

extension Configure {
    public func configure(@noescape block: inout Self -> Void) -> Self {
        var m = self
        block(&m)
        return m
    }
    
    public func configure(@noescape block: inout Self -> Void) -> Self? {
        var m = self
        block(&m)
        return m
    }
}

extension NSObject: Configure {}

