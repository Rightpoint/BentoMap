# BentoMap

[![Build Status](https://travis-ci.org/Raizlabs/BentoMap.svg?branch=develop)](https://travis-ci.org/Raizlabs/BentoMap)
[![Version](https://img.shields.io/cocoapods/v/BentoMap.svg?style=flat)](http://cocoapods.org/pods/BentoMap)
[![License](https://img.shields.io/cocoapods/l/BentoMap.svg?style=flat)](http://cocoapods.org/pods/BentoMap)
[![Platform](https://img.shields.io/cocoapods/p/BentoMap.svg?style=flat)](http://cocoapods.org/pods/BentoMap)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

BentoMap is an implementation of [quadtrees](https://en.wikipedia.org/wiki/Quadtree) for map annotation clustering and storage written in Swift. The library intends to require minimal code in-app to get clustered annotations on screen, the example target included in BentoMap.xcodeproj contains the bare code required dynamically update the map with clusters whenever the map view's bounds changes.

The Android equivalent, known as "Marker Clustering," is [documented here](https://developers.google.com/maps/documentation/android-api/utility/marker-clustering).

## Installation with CocoaPods

BentoMap is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BentoMap'
```

## Installation with Carthage

BentoMap is also compatible with [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```ogdl
github "Raizlabs/BentoMap"
```

## Authors

Michael Skiba, mike.skiba@raizlabs.com
Rob Visentin, rob.visentin@raizlabs.com
Matt Buckley, matt.buckley@raizlabs.com

## License

BentoMap is available under the MIT license. See the LICENSE file for more info.
