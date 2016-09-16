//
//  CLLocationCoordinate2D+BentoCoordinate.swift
//  BentoBox
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: BentoCoordinate {

    public var x: CGFloat {
        get { return CGFloat(latitude) }
        set { latitude = CLLocationDegrees(newValue) }
    }

    public var y: CGFloat {
        get { return CGFloat(longitude) }
        set { longitude = CLLocationDegrees(newValue) }
    }

    public init(x: CGFloat, y: CGFloat) {
        self.init(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y))
    }

}
