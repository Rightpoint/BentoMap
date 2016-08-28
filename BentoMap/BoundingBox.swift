//
//  BentoBox.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BentoBox<R: BentoRect, C: BentoCoordinate> {

    public var mapRect: R

    public init(minPoint: C, maxPoint: C) {

        let minX = min(minPoint._x, maxPoint._x)
        let minY = min(minPoint._y, maxPoint._y)
        let maxX = max(minPoint._x, maxPoint._x)
        let maxY = max(minPoint._y, maxPoint._y)

        mapRect = R(originCoordinate: C(_x: minX, _y: minY),
                            size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(mapRect: R) {
        self.mapRect = mapRect
    }

}

public extension BentoBox {

    public var minPoint: C {
        return C(_x: mapRect.minX, _y: mapRect.minY)
    }

    public var maxPoint: C {
        return C(_x: mapRect.maxX, _y: mapRect.maxY)
    }

}

extension BentoBox {

    func containsCoordinate(point: BentoCoordinate) -> Bool {
        return mapRect.containsCoordinate(point)
    }

    func intersectsBentoBox(bentoBox: BentoBox) -> Bool {
        return mapRect.minX < bentoBox.mapRect.maxX && mapRect.maxX > bentoBox.mapRect.minX &&
            mapRect.minY < bentoBox.mapRect.maxY && mapRect.maxY > bentoBox.mapRect.minY
    }

    var quadrants: QuadrantWrapper<BentoBox> {
        let (north, south) = mapRect.divide(0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BentoBox.init)
    }

}
