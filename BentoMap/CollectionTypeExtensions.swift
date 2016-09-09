//
//  CollectionTypeExtensions.swift
//  BentoBox
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public extension CollectionType where Generator.Element: BentoCoordinate {

    func bentoBox<R: BentoRect>() -> BentoBox<R, Generator.Element> {

        let coordinates: [BentoCoordinate] = flatMap({return $0 as BentoCoordinate})

        return BentoBox(root: bb(coordinates, rectType: R.self))
    }

}

public extension CollectionType {

    func bb<R: BentoRect>(coords: [BentoCoordinate], rectType: R.Type) -> R {
        var min: CGPoint = CGPoint(x: CGFloat.max, y: CGFloat.max)
        var max: CGPoint = CGPoint.zero

        for point in coords {

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

        return R(originCoordinate: min, size: CGSize(width: max.x - min.x, height: max.y - min.y))
    }
}

public extension CollectionType where Generator.Element: CoordinateProvider {

    func boundingBox<R: BentoRect, C: BentoCoordinate>() -> BentoBox<R, C> {
        let boundingBox: [BentoCoordinate] = map({ $0.coordinate })


        return BentoBox(root: bb(boundingBox, rectType: R.self))
    }

}
