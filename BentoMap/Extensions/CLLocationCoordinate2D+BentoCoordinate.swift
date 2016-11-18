//
//  CLLocationCoordinate2D+BentoCoordinate.swift
// BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: BentoCoordinate {

    public var coordX: CGFloat {
        get { return CGFloat(latitude) }
        set { latitude = CLLocationDegrees(newValue) }
    }

    public var coordY: CGFloat {
        get { return CGFloat(longitude) }
        set { longitude = CLLocationDegrees(newValue) }
    }

    public init(coordX: CGFloat, coordY: CGFloat) {
        self.init(latitude: CLLocationDegrees(coordX), longitude: CLLocationDegrees(coordY))
    }

}
