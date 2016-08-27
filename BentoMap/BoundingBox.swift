//
//  BentoBox.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BentoBox<R: BentoRect, C: BentoCoordinate> {

    public var mapRect: R

    public init(minPoint: C, maxPoint: C) {

        let minX = min(minPoint._x, maxPoint._x)
        let minY = min(minPoint._y, maxPoint._y)
        let maxX = max(minPoint._x, maxPoint._x)
        let maxY = max(minPoint._y, maxPoint._y)

        mapRect = R(origin: C(x: minX, y: minY),
                            size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(mapRect: R) {
        self.mapRect = mapRect
    }

}

public extension BentoBox {

    public var minPoint: C {
        return C(x: mapRect.minX, y: mapRect.minY)
    }

    public var maxPoint: C {
        return C(x: mapRect.maxX, y: mapRect.maxY)
    }

}

extension BentoBox {

    func containsMapPoint(mapPoint: BentoCoordinate) -> Bool {
        return mapRect.contains(mapPoint)
    }

    func intersectsBentoBox(bentoBox: BentoBox) -> Bool {
        return true
    }

    var quadrants: QuadrantWrapper<BentoBox> {
        let (north, south) = mapRect.divide(0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BentoBox.init)
    }

}

//private extension MKMapRect {
//
//    func divide(percent percent: Double, edge: CGRectangleEdge) -> (slice: MKMapRect, remainder: MKMapRect) {
//        let amount: Double
//        switch edge {
//        case .MaxXEdge, .MinXEdge:
//            amount = size.width / 2.0
//        case .MaxYEdge, .MinYEdge:
//            amount = size.height / 2.0
//        }
//
//        let slice = UnsafeMutablePointer<MKMapRect>.alloc(1)
//        defer {
//            slice.destroy()
//        }
//        let remainder = UnsafeMutablePointer<MKMapRect>.alloc(1)
//        defer {
//            remainder.destroy()
//        }
//        MKMapRectDivide(self, slice, remainder, amount, edge)
//        return (slice: slice[0], remainder: remainder[0])
//    }
//
//}
