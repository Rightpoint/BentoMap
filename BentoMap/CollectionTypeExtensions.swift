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
        guard let first = first else {
            return BentoBox(mapRect: R())
        }

        let minIn = first
        let maxIn = first
        var minOut: CGPoint = CGPoint.zero
        var maxOut: CGPoint = CGPoint.zero


        for point in self {

            if point._x < minIn._x {
                minOut.x = point._x
            }
            if point._x > maxIn._x {
                maxOut.x = point._x
            }
            if point._y < minIn._y {
                minOut.y = point._y
            }
            if point._y > maxIn._y {
                maxOut.y = point._y
            }
        }

        let BentoRect = R(origin: minOut, size: CGSize(width: maxOut.x - minOut.x, height: maxOut.y - minOut.y))
        return BentoBox(mapRect: BentoRect)
    }

}
