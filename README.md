Swift Network Images
============

![Language](https://img.shields.io/badge/language-Swift%202-orange.svg)
![License](https://img.shields.io/badge/License-MIT%20License-blue.svg)


Swift Network Images is a sample iOS app developed in Swift 2.2. While primarily intended for [a series of blogs](#blogs), the app demonstrates best practices and latest features of iOS and Swift language.



## Blogs
* [Making your Quick test code DRYer with Shared Assertions](http://www.akpdev.com/articles/2016/05/12/Quick-Shared-Assertions.html)


## Features
* Written in Swift 2.2 and Xcode 7.3

* `MVVM`, with simple DIY bindings for mutable `ViewModel`s

* Shows and easy way to build UI in code with iOS9 `NSLayoutAnchor` and `UILayoutGuide`

* Custom UICollectionView Layouts, efficiently built on top of `UICollectionViewFlowLayout` using custom invalidation context.

* Protocol-Oriented and Value-Based Programming
 
* Testable design via Dependency Injections

* [DRY BDD tests using Quick's Shared Assertions](http://www.akpdev.com/articles/2016/05/12/Quick-Shared-Assertions.html)


## Docs		
 [Initial docs][docsLink], generated with [jazzy](https://github.com/realm/jazzy) and hosted by [GitHub Pages](https://pages.github.com).


## TODOs
* UICollectionView Custom Layout examples:
 - [x] Global section header (pinnable, stretchable)
 - [x] Sticky section headers 
 - [ ] Collapsible / expandable sections
 - [ ] Drag reodering
 - [ ] Swipe to edit
* UICollectionView transitions / animations
* UI Tests
* Snapshot Tests


## Building the project

1) Clone the repository

```bash
$ git clone https://github.com/akpw/SwiftNetworkImages
```

2) Install pods

```bash
$ cd SwiftNetworkImages
$ pod install
```

3) Open the workspace in Xcode

```bash
$ open "SwiftNetworkImages.xcworkspace"
```

4) Compile and run the app in your simulator


# Requirements

* Xcode 7.3
* iOS 9


[docsLink]:https://akpw.github.io//SwiftNetworkImages/index.html
