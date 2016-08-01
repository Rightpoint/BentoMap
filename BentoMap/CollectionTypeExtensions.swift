//
//  CollectionTypeExtensions.swift
//  BentoMap
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public extension CollectionType where Generator.Element: MapPointProvider {

    /// Computes the BoundingBox of the point cloud in O(n) time.
    var boundingBox: BoundingBox {
        guard let first = first else {
            return BoundingBox(mapRect: MKMapRect())
        }

        var min = first.mapPoint
        var max = first.mapPoint

        for point in self {
            let mapPoint = point.mapPoint

            if mapPoint.x < min.x {
                min.x = mapPoint.x
            }
            if mapPoint.x > max.x {
                max.x = mapPoint.x
            }
            if mapPoint.y < min.y {
                min.y = mapPoint.y
            }
            if mapPoint.y > max.y {
                max.y = mapPoint.y
            }
        }

        let rect = MKMapRect(origin: min, size: MKMapSize(width: max.x - min.x, height: max.y - min.y))
        return BoundingBox(mapRect: rect)
    }

}

public extension CollectionType where Generator.Element == CLLocationCoordinate2D {

    /// Computes the BoundingBox of the coordinate list in O(n) time.
    var boundingBox: BoundingBox {
        guard let first = first else {
            return BoundingBox(mapRect: MKMapRect())
        }

        var min = first
        var max = first

        for coord in self {
            if coord.latitude < min.latitude {
                min.latitude = coord.latitude
            }
            if coord.latitude > max.latitude {
                max.latitude = coord.latitude
            }
            if coord.longitude < min.longitude {
                min.longitude = coord.longitude
            }
            if coord.longitude > max.longitude {
                max.longitude = coord.longitude
            }
        }

        return BoundingBox(minCoordinate: min, maxCoordinate: max)
    }

}
