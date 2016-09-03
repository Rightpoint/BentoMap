//
//  CollectionTypeExtensions.swift
//  BentoMap
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public extension CollectionType where Generator.Element: BentoCoordinate {

    func bentoMap<R: BentoRect>() -> BentoMap<R, Generator.Element> {

        guard let y = self as? [BentoCoordinate] else {
            return bentoMap()
        }


        return BentoMap(rootNode: bb(y, rectType: R.self))
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

    func boundingBox<R: BentoRect, C: BentoCoordinate>() -> BentoMap<R, C> {
        let boundingBox: [BentoCoordinate] = map({ $0.coordinate })


        return BentoMap(rootNode: bb(boundingBox, rectType: R.self))
    }

}
