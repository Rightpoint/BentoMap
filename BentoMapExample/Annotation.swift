//
//  Annotation.swift
//  BentoMap
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

private extension NSNumberFormatter {

    static let annotationFormatter: NSNumberFormatter = { annotationFormatter in
        annotationFormatter.numberStyle = .DecimalStyle
        return annotationFormatter
    }(NSNumberFormatter())
}

class SingleAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(mapPoint)
    }
    private let annotationNumber: Int
    let mapPoint: MKMapPoint
    let mapRect: MKMapRect

    init(mapPoint: MKMapPoint, annotationNumber: Int, mapRect: MKMapRect) {
        self.mapPoint = mapPoint
        self.annotationNumber = annotationNumber
        self.mapRect = mapRect
    }

    var title: String? {
        return NSNumberFormatter.annotationFormatter.stringFromNumber(NSNumber(integer: annotationNumber))
    }

}

class ClusterAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(mapPoint)
    }
    private let annotationNumbers: [Int]
    let mapPoint: MKMapPoint
    let mapRect: MKMapRect

    init(mapPoint: MKMapPoint, annotationNumbers: [Int], mapRect: MKMapRect) {
        self.mapPoint = mapPoint
        self.annotationNumbers = annotationNumbers.sort()
        self.mapRect = mapRect
    }

    var title: String? {
        let numbers = annotationNumbers.map({ NSNumber(integer: $0)})
        let strings = numbers.flatMap(NSNumberFormatter.annotationFormatter.stringFromNumber)
        return strings.joinWithSeparator(", ")
    }
}

func == (lhs: MKAnnotation, rhs: MKAnnotation) -> Bool {
    if let lSingle = lhs as? SingleAnnotation, rSingle = rhs as? SingleAnnotation {
        return lSingle.annotationNumber == rSingle.annotationNumber
    }
    else if let lMulti = lhs as? ClusterAnnotation, rMulti = rhs as? ClusterAnnotation {
        return lMulti.annotationNumbers == rMulti.annotationNumbers
    }
    return false
}
