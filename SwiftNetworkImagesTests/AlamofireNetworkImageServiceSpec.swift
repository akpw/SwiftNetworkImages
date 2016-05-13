//
//  AlamofireNetworkImageServiceSpec.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 10/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftNetworkImages


class AlamofireNetworkImageServiceSpec: QuickSpec {
    override func spec() {
        var networkImageServiceWrapper: NetworkImageServiceWrapper!
        beforeEach {
            let networkImageService = AlamofireNetworkImageService()
            networkImageServiceWrapper = NetworkImageServiceWrapper(networkImageService: networkImageService)
        }
        itBehavesLike("a NetworkImageService") { ["networkImageService": networkImageServiceWrapper] }
    }
}
