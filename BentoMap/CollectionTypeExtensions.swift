//
//  CollectionTypeExtensions.swift
//  BentoMap
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public extension CollectionType where Generator.Element: BentoCoordinate {

    func bentoBox<R: BentoRect>() -> BentoBox<R, Generator.Element> {

        var min: CGPoint = CGPoint(x: CGFloat.max, y: CGFloat.max)
        var max: CGPoint = CGPoint.zero

        for point in self {

            if point._x < min.x {
                min.x = point._x
            }
            if point._x > max.x {
                max.x = point._x
            }
            if point._y < min.y {
                min.y = point._y
            }
            if point._y > max.y {
                max.y = point._y
            }
        }

        let BentoRect = R(originCoordinate: min, size: CGSize(width: max.x - min.x, height: max.y - min.y))
        return BentoBox(mapRect: BentoRect)
    }

}
