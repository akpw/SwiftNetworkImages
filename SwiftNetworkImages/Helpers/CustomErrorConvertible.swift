//
//  CustomErrorConvertible.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 1/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Foundation


/// Enhancements to base ErrorType,
/// to provide base compatibility with NSError

protocol CustomErrorConvertible: ErrorType, CustomStringConvertible {
    func errorDomain() -> String
    func errorCode() -> Int
    func userInfo() -> Dictionary<String, String>?
}
extension CustomErrorConvertible {
    func errorDomain() -> String {
        return String(self.dynamicType)
    }

    var description: String  {
        return "An error has occured at \(#file), \(#function), \(#line). More Info: \(self.userInfo())"
    }

    func userInfo() -> Dictionary<String, String>? {
        return [NSLocalizedDescriptionKey: description]
    }

    var error: NSError {
        return NSError(domain: self.errorDomain(), code: self.errorCode(), userInfo: self.userInfo())
    }
}

