//
//  MKMapRect+BentoRect.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

extension MKMapRect: BentoRect {

    public var minX: CGFloat {
        return CGFloat(MKMapRectGetMinX(self))
    }

    public var minY: CGFloat {
        return CGFloat(MKMapRectGetMinY(self))
    }

    public var maxX: CGFloat {
        return CGFloat(MKMapRectGetMaxX(self))
    }

    public var maxY: CGFloat {
        return CGFloat(MKMapRectGetMaxY(self))
    }

    public func containsCoordinate(_ c: BentoCoordinate) -> Bool {
        let originCoordinate = MKMapPoint(x: Double(c.coordX), y: Double(c.coordY))
        return MKMapRectContainsPoint(self, originCoordinate)
    }

    public func divide(_ percent: CGFloat, edge: CGRectEdge) -> (MKMapRect, MKMapRect) {
        let amount: Double
        switch edge {
        case .maxXEdge, .minXEdge:
            amount = size.width / 2.0
        case .maxYEdge, .minYEdge:
            amount = size.height / 2.0
        }

        let slice = UnsafeMutablePointer<MKMapRect>.allocate(capacity: 1)
        defer {
            slice.deinitialize()
        }
        let remainder = UnsafeMutablePointer<MKMapRect>.allocate(capacity: 1)
        defer {
            remainder.deinitialize()
        }
        MKMapRectDivide(self, slice, remainder, amount, edge)
        return (slice: slice[0], remainder: remainder[0])
    }

    public func unionWith(_ other: MKMapRect) -> MKMapRect {
        return MKMapRectUnion(self, other)
    }

    public init(originCoordinate origin: BentoCoordinate, size: CGSize) {
        self.init(origin: MKMapPoint(x: Double(origin.coordX), y: Double(origin.coordY)), size: MKMapSize(width: Double(size.width), height: Double(size.height)))
    }

}
