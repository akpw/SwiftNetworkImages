//
//  AppDelegate.swift
//  SwiftNetworkImages
//
//  Created by Arseniy Kuznetsov on 30/4/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//


import UIKit

/// The App Delegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = {
            let window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = configureTopViewController()
            window.makeKeyAndVisible()
            return window
        }()
        return true
    }
}

extension AppDelegate {
    
    /// Configures top level view controller and its dependencies
    func configureTopViewController() -> UIViewController {
        
        // Images info loader
        let imagesInfoLoader = ImagesInfoLoader()
        
        // Network image service
        let imageService = NSURLSessionNetworkImageService()
        var imageFetcher = ImageFetcher()
        imageFetcher.inject(imageService)
        
        // Images info data source
        var imagesDataSource = ImagesDataSource()
        imagesDataSource.inject((imagesInfoLoader, imageFetcher))
        
        // Delegate / Data Source for the collection view
        let dataSourceDelegate = SampleImagesDataSourceDelegate()
        dataSourceDelegate.inject(imagesDataSource)
        
        // Top-level view controller
        let viewController = SampleImagesViewController()
        viewController.inject(dataSourceDelegate)
        return viewController
    }
}












