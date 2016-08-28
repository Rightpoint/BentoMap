//
//  MKMapRect+BentoRect.swift
//  BentoMap
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

    public func contains(c: BentoCoordinate) -> Bool {
        let mapPoint = MKMapPoint(x: Double(c._x), y: Double(c._y))
        return MKMapRectContainsPoint(self, mapPoint)
    }

    public func divide(percent: CGFloat, edge: CGRectEdge) -> (MKMapRect, MKMapRect) {
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

    public init(originCoordinate origin: BentoCoordinate, size: CGSize) {
        self.init(origin: MKMapPoint(x: Double(origin._x), y: Double(origin._y)), size: MKMapSize(width: Double(size.width), height: Double(size.height)))
    }

}
