//
//  NSURLSessionNetworkImageServiceSpec.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftNetworkImages

class NSURLSessionNetworkImageServiceSpec: QuickSpec {
    override func spec() {
        var networkImageServiceWrapper: NetworkImageServiceWrapper!
        beforeEach {
            let networkImageService = NSURLSessionNetworkImageService()
            networkImageServiceWrapper = NetworkImageServiceWrapper(networkImageService: networkImageService)
        }
        itBehavesLike("a NetworkImageService") { ["networkImageService": networkImageServiceWrapper] }
    }
}