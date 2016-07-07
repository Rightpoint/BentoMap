//
//  Annotations.swift
//  BentoMap
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

class SingleAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(mapPoint)
    }
    let annotationNumber: Int
    let mapPoint: MKMapPoint
    let mapRect: MKMapRect

    init(mapPoint: MKMapPoint, annotationNumber: Int, mapRect: MKMapRect) {
        self.mapPoint = mapPoint
        self.annotationNumber = annotationNumber
        self.mapRect = mapRect
    }

}

class ClusterAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(mapPoint)
    }
    let annotationNumbers: [Int]
    let mapPoint: MKMapPoint
    let mapRect: MKMapRect

    init(mapPoint: MKMapPoint, annotationNumbers: [Int], mapRect: MKMapRect) {
        self.mapPoint = mapPoint
        self.annotationNumbers = annotationNumbers.sort()
        self.mapRect = mapRect
    }

}
