//
//  CollectionTypeExtensions.swift
//  BentoMap
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public extension CollectionType where Generator.Element: Coordinate {

    func boundingBox<R: Rectangle>() -> BoundingBox<R, Generator.Element> {
        guard let first = first else {
            return BoundingBox(mapRectangle: R())
        }

        var min = first
        var max = first

        for point in self {

            if point.x < min.x {
                min.x = point.x
            }
            if point.x > max.x {
                max.x = point.x
            }
            if point.y < min.y {
                min.y = point.y
            }
            if point.y > max.y {
                max.y = point.y
            }
        }

        let rectangle = R(origin: min, size: CGSize(width: max.x - min.x, height: max.y - min.y))
        return BoundingBox(mapRectangle: rectangle)
    }

}
