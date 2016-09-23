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

    func bentoBox<Rect: BentoRect>() -> BentoBox<Rect, Generator.Element> {

        let coordinates: [BentoCoordinate] = flatMap({return $0 as BentoCoordinate})

        return BentoBox(root: bb(coordinates, rectType: Rect.self))
    }

}

public extension CollectionType {

    func bb<Rect: BentoRect>(coords: [BentoCoordinate], rectType: Rect.Type) -> Rect {
        var min: CGPoint = CGPoint(x: CGFloat.max, y: CGFloat.max)
        var max: CGPoint = CGPoint.zero

        for point in coords {

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

        return Rect(originCoordinate: min, size: CGSize(width: max.x - min.x, height: max.y - min.y))
    }
}

public extension CollectionType where Generator.Element: CoordinateProvider {

    func boundingBox<Rect: BentoRect, Coordinate: BentoCoordinate>() -> BentoBox<Rect, Coordinate> {
        let boundingBox: [BentoCoordinate] = map({ $0.coordinate })


        return BentoBox(root: bb(boundingBox, rectType: Rect.self))
    }

}
