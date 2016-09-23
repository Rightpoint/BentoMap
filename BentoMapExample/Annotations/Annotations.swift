//
//  Annotations.swift
// BentoMap
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit
import BentoMap

class BaseAnnotation: NSObject, MKAnnotation {
    let originCoordinate: MKMapPoint
    let root: MKMapRect
    var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(originCoordinate)
    }

    init(originCoordinate: MKMapPoint, root: MKMapRect) {
        self.originCoordinate = originCoordinate
        self.root = root
    }

    static func makeAnnotation(result: QuadTreeResult<Int, MKMapRect, MKMapPoint>) -> BaseAnnotation {
        let annotation: BaseAnnotation
        switch result {
        case let .Single(node: node):
            annotation = SingleAnnotation(originCoordinate: result.originCoordinate,
                                          annotationNumber: node.content,
                                          root: result.contentRect)
        case let .Multiple(nodes: nodes):
            annotation = ClusterAnnotation(originCoordinate: result.originCoordinate,
                                           annotationNumbers: nodes.map({ $0.content }),
                                           root: result.contentRect)
        }
        return annotation
    }
}

final class SingleAnnotation: BaseAnnotation {

    let annotationNumber: Int

    init(originCoordinate: MKMapPoint, annotationNumber: Int, root: MKMapRect) {
        self.annotationNumber = annotationNumber
        super.init(originCoordinate: originCoordinate, root: root)
    }

}

final class ClusterAnnotation: BaseAnnotation {

    let annotationNumbers: [Int]

    init(originCoordinate: MKMapPoint, annotationNumbers: [Int], root: MKMapRect) {
        self.annotationNumbers = annotationNumbers.sort()
        super.init(originCoordinate: originCoordinate, root: root)
    }

}

func == (lhs: BaseAnnotation, rhs: BaseAnnotation) -> Bool {
    if let lSingle = lhs as? SingleAnnotation,
        rSingle = rhs as? SingleAnnotation {
        return lSingle.annotationNumber == rSingle.annotationNumber
    }
    else if let lMulti = lhs as? ClusterAnnotation,
        rMulti = rhs as? ClusterAnnotation {
        return lMulti.annotationNumbers == rMulti.annotationNumbers
    }
    return false
}
