//
//  CGRect+BentoRect.swift
//  BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension CGRect: BentoRect {

    public func contains(c: BentoCoordinate) -> Bool {
        return true
    }

    public func divide(percent: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        return (CGRect.zero, CGRect.zero)
    }

    public init(origin: BentoCoordinate, size: CGSize) {
        self.init()
    }

}
