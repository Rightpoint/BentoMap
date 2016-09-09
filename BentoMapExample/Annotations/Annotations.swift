//
//  Annotations.swift
//  BentoBox
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit
import BentoMap

class BaseAnnotation: NSObject, MKAnnotation {
    let mapPoint: MKMapPoint
    let rootNode: MKMapRect
    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(mapPoint)
    }

    init(mapPoint: MKMapPoint, rootNode: MKMapRect) {
        self.mapPoint = mapPoint
        self.rootNode = rootNode
    }

    static func makeAnnotation(result: QuadTreeResult<Int, MKMapRect, MKMapPoint>) -> BaseAnnotation {
        let annotation: BaseAnnotation
        switch result {
        case let .Single(node: node):
            annotation = SingleAnnotation(mapPoint: result.mapPoint,
                                          annotationNumber: node.content,
                                          rootNode: result.contentRect)
        case let .Multiple(nodes: nodes):
            annotation = ClusterAnnotation(mapPoint: result.mapPoint,
                                           annotationNumbers: nodes.map({ $0.content }),
                                           rootNode: result.contentRect)
        }
        return annotation
    }
}

final class SingleAnnotation: BaseAnnotation {

    let annotationNumber: Int

    init(mapPoint: MKMapPoint, annotationNumber: Int, rootNode: MKMapRect) {
        self.annotationNumber = annotationNumber
        super.init(mapPoint: mapPoint, rootNode: rootNode)
    }

}

final class ClusterAnnotation: BaseAnnotation {

    let annotationNumbers: [Int]

    init(mapPoint: MKMapPoint, annotationNumbers: [Int], rootNode: MKMapRect) {
        self.annotationNumbers = annotationNumbers.sort()
        super.init(mapPoint: mapPoint, rootNode: rootNode)
    }

}

func == (lhs: BaseAnnotation, rhs: BaseAnnotation) -> Bool {
    if let lSingle = lhs as? SingleAnnotation,
        rSingle = rhs as? SingleAnnotation {
        return lSingle.annotationNumber == rSingle.annotationNumber
    } else if let lMulti = lhs as? ClusterAnnotation,
        rMulti = rhs as? ClusterAnnotation {
        return lMulti.annotationNumbers == rMulti.annotationNumbers
    }
    return false
}
