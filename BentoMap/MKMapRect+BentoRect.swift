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
        return true
    }

    public func divide(percent: CGFloat, edge: CGRectEdge) -> (MKMapRect, MKMapRect) {
        return (self, self)
    }

    public init(origin: BentoCoordinate, size: CGSize) {
        self.init()
    }
}
