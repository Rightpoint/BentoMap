//
//  CGRect+BentoRect.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension CGRect: BentoRect {

    public func containsCoordinate(_ c: BentoCoordinate) -> Bool {
        let point = CGPoint(x: c.coordX, y: c.coordY)
        return self.contains(point)
    }

    public func divide(_ percent: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let amount: CGFloat
        switch edge {
        case .maxXEdge, .minXEdge:
            amount = size.width / 2.0
        case .maxYEdge, .minYEdge:
            amount = size.height / 2.0
        }

        let (slice, remainder) = divided(atDistance: amount, from: edge)
        return (slice: slice, remainder: remainder)
    }

    public func unionWith(_ other: CGRect) -> CGRect {
        return union(other)
    }

    public init(originCoordinate origin: BentoCoordinate, size: CGSize) {
        self.init(origin: CGPoint(x: origin.coordX, y: origin.coordY), size: size)
    }

}
