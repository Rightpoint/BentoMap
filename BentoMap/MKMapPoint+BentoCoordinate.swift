//
//  MKMapPoint+BentoCoordinate.swift
//  BentoBox
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

extension MKMapPoint: BentoCoordinate {

    public var x: CGFloat {
        get { return CGFloat(x) }
        set { x = Double(newValue) }
    }

    public var y: CGFloat {
        get { return CGFloat(y) }
        set { y = Double(newValue) }
    }

    public init(x: CGFloat, y: CGFloat) {
        self.init(x: Double(x), y: Double(y))
    }

}
