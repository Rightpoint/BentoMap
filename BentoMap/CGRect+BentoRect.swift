//
//  CGRect+BentoRect.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension CGRect: BentoRect {

    public func containsCoordinate(c: BentoCoordinate) -> Bool {
        let point = CGPoint(x: c.x, y: c.y)
        return self.contains(point)
    }

    public func divide(percent: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let amount: CGFloat
        switch edge {
        case .MaxXEdge, .MinXEdge:
            amount = size.width / 2.0
        case .MaxYEdge, .MinYEdge:
            amount = size.height / 2.0
        }

        let slice = UnsafeMutablePointer<CGRect>.alloc(1)
        defer {
            slice.destroy()
        }
        let remainder = UnsafeMutablePointer<CGRect>.alloc(1)
        defer {
            remainder.destroy()
        }
        CGRectDivide(self, slice, remainder, amount, edge)
        return (slice: slice[0], remainder: remainder[0])
    }

    public func unionWith(other: CGRect) -> CGRect {
        return union(other)
    }

    public init(originCoordinate origin: BentoCoordinate, size: CGSize) {
        self.init(origin: CGPoint(x: origin.x, y: origin.y), size: size)
    }

}
