//
//  AlamofireNetworkImageService.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import Alamofire
import AlamofireImage

/// Implementation of the NetworkImageService protocol using Alamofire

struct AlamofireNetworkImageService: NetworkImageService  {
    // MARK: - ImageService
    func requestImage(urlString: String, completion: Result<UIImage> -> Void) {
        Alamofire.request(.GET, urlString).responseImage {            
            if let error = $0.result.error {
                return completion( Result.Failure( NetworkError(error: error) ) )
            }
            guard let image: UIImage = $0.result.value else {
                return completion( Result.Failure( NetworkError.ContentValidationFailed ) )
            }
            completion(Result.Success(image))
        }
    }
}


