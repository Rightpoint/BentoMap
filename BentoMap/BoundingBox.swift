//
//  BoundingBox.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BoundingBox<R: Rectangle, C: Coordinate> {

//    public static let world = BoundingBox<R, C>!

    public var mapRectangle: R

    public init(minPoint: C, maxPoint: C) {

        let minX = min(minPoint.x, maxPoint.x)
        let minY = min(minPoint.y, maxPoint.y)
        let maxX = max(minPoint.x, maxPoint.x)
        let maxY = max(minPoint.y, maxPoint.y)

        mapRectangle = R(origin: C(x: minX, y: minY),
                            size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(mapRectangle: R) {
        self.mapRectangle = mapRectangle
    }

}

public extension BoundingBox {

    public var minPoint: Coordinate {
        return C(x: mapRectangle.minX, y: mapRectangle.minY)
    }

    public var maxPoint: Coordinate {
        return C(x: mapRectangle.maxX, y: mapRectangle.maxY)
    }

}

extension BoundingBox {

    func containsMapPoint(mapPoint: Coordinate) -> Bool {
        return mapRectangle.contains(mapPoint)
    }

    func intersectsBoundingBox(boundingBox: BoundingBox) -> Bool {
        return true
    }

    var quadrants: QuadrantWrapper<BoundingBox> {
        let (north, south) = mapRectangle.divide(0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BoundingBox.init)
    }

}

//private extension MKMapRectangle {
//
//    func divide(percent percent: Double, edge: CGRectangleEdge) -> (slice: MKMapRectangle, remainder: MKMapRectangle) {
//        let amount: Double
//        switch edge {
//        case .MaxXEdge, .MinXEdge:
//            amount = size.width / 2.0
//        case .MaxYEdge, .MinYEdge:
//            amount = size.height / 2.0
//        }
//
//        let slice = UnsafeMutablePointer<MKMapRectangle>.alloc(1)
//        defer {
//            slice.destroy()
//        }
//        let remainder = UnsafeMutablePointer<MKMapRectangle>.alloc(1)
//        defer {
//            remainder.destroy()
//        }
//        MKMapRectangleDivide(self, slice, remainder, amount, edge)
//        return (slice: slice[0], remainder: remainder[0])
//    }
//
//}
