//
//  NSURLSessionNetworkImageService.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 9/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit

/// Implementation of the NetworkImageService protocol using NSURLSession

struct NSURLSessionNetworkImageService: NetworkImageService  {
    // MARK: - ImageService
    func requestImage(urlString: String, completion: Result<UIImage> -> Void) {
        guard let url = NSURL(string: urlString) else {
            return completion( Result.Failure( NetworkError.CannotConnectToServer ) )
        }
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithURL(url) { data, response, error in            
            dispatch_async(dispatch_get_main_queue()) {
                if let error = error {
                    return completion( Result.Failure( NetworkError(error: error) ) )
                }
                guard let data = data, image = UIImage(data: data) else {
                    return completion( Result.Failure( NetworkError.ContentValidationFailed ) )
                }
                completion(Result.Success(image))
            }
        }.resume()
    }
}

