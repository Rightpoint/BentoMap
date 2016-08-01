//
//  BoundingBox.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public struct BoundingBox {
    public var mapRect: MKMapRect

    public init(minCoordinate: CLLocationCoordinate2D, maxCoordinate: CLLocationCoordinate2D) {
        let minPoint = MKMapPointForCoordinate(minCoordinate)
        let maxPoint = MKMapPointForCoordinate(maxCoordinate)

        let minX = min(minPoint.x, maxPoint.x)
        let minY = min(minPoint.y, maxPoint.y)
        let maxX = max(minPoint.x, maxPoint.x)
        let maxY = max(minPoint.y, maxPoint.y)

        mapRect = MKMapRect(origin: MKMapPoint(x: minX, y: minY),
                            size: MKMapSize(width: maxX - minX, height: maxY - minY))
    }

    public init(mapRect: MKMapRect) {
        self.mapRect = mapRect
    }
}

public extension BoundingBox {

    public var minPoint: MKMapPoint {
        return MKMapPoint(x: MKMapRectGetMinX(mapRect), y: MKMapRectGetMinY(mapRect))
    }

    public var maxPoint: MKMapPoint {
        return MKMapPoint(x: MKMapRectGetMaxX(mapRect), y: MKMapRectGetMaxY(mapRect))
    }

    public var minCoordinate: CLLocationCoordinate2D {
        let (minCoord, maxCoord) = (MKCoordinateForMapPoint(minPoint), MKCoordinateForMapPoint(maxPoint))
        return CLLocationCoordinate2D(latitude: min(minCoord.latitude, maxCoord.latitude), longitude: min(minCoord.longitude, maxCoord.longitude))
    }

    public var maxCoordinate: CLLocationCoordinate2D {
        let (minCoord, maxCoord) = (MKCoordinateForMapPoint(minPoint), MKCoordinateForMapPoint(maxPoint))
        return CLLocationCoordinate2D(latitude: max(minCoord.latitude, maxCoord.latitude), longitude: max(minCoord.longitude, maxCoord.longitude))
    }

}

extension BoundingBox {

    func containsMapPoint(mapPoint: MKMapPoint) -> Bool {
        return MKMapRectContainsPoint(mapRect, mapPoint)
    }

    func intersectsBoundingBox(boundingBox: BoundingBox) -> Bool {
        return MKMapRectIntersectsRect(mapRect, boundingBox.mapRect)
    }

    var quadrants: QuadrantWrapper<BoundingBox> {
        let (north, south) = mapRect.divide(percent: 0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(percent: 0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(percent: 0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BoundingBox.init)
    }

}

private extension MKMapRect {
    func divide(percent percent: Double, edge: CGRectEdge) -> (slice: MKMapRect, remainder: MKMapRect) {
        let amount: Double
        switch edge {
        case .MaxXEdge, .MinXEdge:
            amount = size.width / 2.0
        case .MaxYEdge, .MinYEdge:
            amount = size.height / 2.0
        }

        let slice = UnsafeMutablePointer<MKMapRect>.alloc(1)
        defer {
            slice.destroy()
        }
        let remainder = UnsafeMutablePointer<MKMapRect>.alloc(1)
        defer {
            remainder.destroy()
        }
        MKMapRectDivide(self, slice, remainder, amount, edge)
        return (slice: slice[0], remainder: remainder[0])
    }
}
