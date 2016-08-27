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
            return BentoBox(mapRectangle: R())
        }

        let minIn = first
        let maxIn = first
        var minOut: CGPoint = CGPoint.zero
        var maxOut: CGPoint = CGPoint.zero


        for point in self {

            if point.x < minIn.x {
                minOut.x = point.x
            }
            if point.x > maxIn.x {
                maxOut.x = point.x
            }
            if point.y < minIn.y {
                minOut.y = point.y
            }
            if point.y > maxIn.y {
                maxOut.y = point.y
            }
        }

        let BentoRect = R(origin: minOut, size: CGSize(width: maxOut.x - minOut.x, height: maxOut.y - minOut.y))
        return BentoBox(mapRectangle: BentoRect)
    }

}
