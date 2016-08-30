//
//  QuadTree+SampleData.swift
//  BentoMap
//
//  Created by Michael Skiba on 7/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit
import BentoMap

extension QuadTree {

    static var sampleData: QuadTree<Int> {
        var samples = QuadTree<Int>(BentoMap: BentoMap(minCoordinate: CLLocationCoordinate2D.minCoord, maxCoordinate: CLLocationCoordinate2D.maxCoord), bucketCapacity: 5)
        for count in 1...5000 {
            let node = QuadTreeNode(mapPoint: MKMapPointForCoordinate(CLLocationCoordinate2D.randomCoordinate()), content: count)
            samples.insertNode(node)
        }
        return samples
    }

}

private extension CLLocationCoordinate2D {
    enum Coordinates {
        static let bostonLatitude: Double = 42.3584300
        static let bostonLongitude: Double = -71.0597700
        static let adjustment: Double = 0.5
        static let minLatitude: Double =  Coordinates.bostonLatitude - Coordinates.adjustment
        static let minLongitude: Double = Coordinates.bostonLongitude - Coordinates.adjustment
        static let maxLatitude: Double = Coordinates.bostonLatitude + Coordinates.adjustment
        static let maxLongitude: Double = Coordinates.bostonLongitude + Coordinates.adjustment
    }

    static let minCoord = CLLocationCoordinate2D(latitude: Coordinates.minLatitude,
                                                 longitude: Coordinates.minLongitude)
    static let maxCoord = CLLocationCoordinate2D(latitude: Coordinates.maxLatitude,
                                                 longitude: Coordinates.maxLongitude)

    static func randomCoordinate() -> CLLocationCoordinate2D {
        let lat = Double.cappedRandom(min: Coordinates.minLatitude,
                                      max: Coordinates.maxLatitude)
        let long = Double.cappedRandom(min: Coordinates.minLongitude,
                                       max: Coordinates.maxLongitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

private extension Double {
    static func cappedRandom(min minValue: Double, max maxValue: Double) -> Double {
        let exponent: Double = 10000.0
        let diff = UInt32(abs(minValue - maxValue) * exponent)
        let randomNumber = Double(arc4random_uniform(diff)) / exponent
        return min(minValue, maxValue) + randomNumber
    }
}
