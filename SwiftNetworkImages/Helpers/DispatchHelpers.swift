//
//  DispatchHelpers.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 1/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation

public func dispatch_after(delayInSeconds delay: NSTimeInterval = 0.1,
                                          queue: dispatch_queue_t = dispatch_get_main_queue(),
                                          block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW,
                             Int64(NSTimeInterval(NSEC_PER_SEC) * delay))
    dispatch_after(time,
                   queue,
                   block)
}
