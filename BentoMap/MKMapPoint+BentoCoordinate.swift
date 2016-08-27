//
//  MKMapPoint+BentoCoordinate.swift
//  BentoMap
//
//  Created by Matthew Buckley on 8/27/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

extension MKMapPoint: BentoCoordinate {

    public var x: CGFloat {
        return CGFloat(x)
    }

    public var y: CGFloat {
        return CGFloat(y)
    }

    public init(x: CGFloat, y: CGFloat) {
        self.init()
    }

}
