//
//  MKMapPoint+BentoCoordinate.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

extension MKMapPoint: BentoCoordinate {

    public var coordX: CGFloat {
        get { return CGFloat(x) }
        set { x = Double(newValue) }
    }

    public var coordY: CGFloat {
        get { return CGFloat(y) }
        set { y = Double(newValue) }
    }

    public init(coordX: CGFloat, coordY: CGFloat) {
        self.init(x: Double(coordX), y: Double(coordY))
    }

}
