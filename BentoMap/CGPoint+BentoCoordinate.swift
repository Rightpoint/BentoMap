//
//  CGPoint+BentoCoordinate.swift
//  BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension CGPoint: BentoCoordinate {

    public var _x: CGFloat {
        return x
    }

    public var _y: CGFloat {
        return y
    }

    public init(_x: CGFloat, _y: CGFloat) {
        self.init(x: _x, y: _y)
    }

}
