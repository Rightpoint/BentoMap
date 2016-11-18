//
//  CGPoint+BentoCoordinate.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension CGPoint: BentoCoordinate {

    public var coordX: CGFloat {
        get { return x }
        set { x = newValue }
    }

    public var coordY: CGFloat {
        get { return y }
        set { y = newValue }
    }

    public init(coordX: CGFloat, coordY: CGFloat) {
        self.init(x: coordX, y: coordY)
    }

}
