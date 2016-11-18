//
//  CollectionTypeExtensions.swift
// BentoMap
//
//  Created by Rob Visentin on 8/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public extension Collection where Iterator.Element: BentoCoordinate {

    func bentoBox<Rect: BentoRect>() -> BentoBox<Rect, Iterator.Element> {

        let coordinates: [BentoCoordinate] = flatMap({return $0 as BentoCoordinate})

        return BentoBox(root: bb(coordinates, rectType: Rect.self))
    }

}

public extension Collection {

    func bb<Rect: BentoRect>(_ coords: [BentoCoordinate], rectType: Rect.Type) -> Rect {
        var min: CGPoint = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
        var max: CGPoint = CGPoint.zero

        for point in coords {

            if point.coordX < min.coordX {
                min.coordX = point.coordX
            }
            if point.coordX > max.coordX {
                max.coordX = point.coordX
            }
            if point.coordY < min.coordY {
                min.coordY = point.coordY
            }
            if point.coordY > max.coordY {
                max.coordY = point.coordY
            }
        }

        return Rect(originCoordinate: min, size: CGSize(width: max.x - min.x, height: max.y - min.y))
    }
}

public extension Collection where Iterator.Element: CoordinateProvider {

    func boundingBox<Rect: BentoRect, Coordinate: BentoCoordinate>() -> BentoBox<Rect, Coordinate> {
        let boundingBox: [BentoCoordinate] = map({ $0.coordinate })

        return BentoBox(root: bb(boundingBox, rectType: Rect.self))
    }

}
