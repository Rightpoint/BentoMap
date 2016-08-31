//
//  BentoMap.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BentoMap<R: BentoRect, C: BentoCoordinate> {

    /// The root node of the tree. Can be thought of
    /// as the container map of the sub-rectangles
    public var rootNode: R

    public init(minPoint: C, maxPoint: C) {

        let minX = min(minPoint._x, maxPoint._x)
        let minY = min(minPoint._y, maxPoint._y)
        let maxX = max(minPoint._x, maxPoint._x)
        let maxY = max(minPoint._y, maxPoint._y)

        rootNode = R(originCoordinate: C(_x: minX, _y: minY),
                    size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(rootNode: R) {
        self.rootNode = rootNode
    }

}

// MARK: Public API

public extension BentoMap {

    /// The coordinate at the top left corner of the root rect
    public var minCoordinate: C {
        return C(_x: rootNode.minX, _y: rootNode.minY)
    }

    /// The coordinate at the bottom right corner of the root rect
    public var maxCoordinate: C {
        return C(_x: rootNode.maxX, _y: rootNode.maxY)
    }

}

extension BentoMap {

    /**
     Returns a Bool value for whether the rootNode contains
     the coordinate passed in

     - parameter coordinate: a BentoCoordinate

     - returns: whether the rootNode contains
     the coordinate passed in
     */
    func containsCoordinate(coordinate: BentoCoordinate) -> Bool {
        return rootNode.containsCoordinate(coordinate)
    }

    /**
     Returns a Bool value for whether the rootNode intersects with the
     rootNode of the bentoMap passed in

     - parameter bentoMap: a BentoMap

     - returns: whether the rootNode intersects with the
     rootNode of the bentoMap passed in
     */
    func intersectsBentoBox(bentoMap: BentoMap) -> Bool {
        return rootNode.minX < bentoMap.rootNode.maxX && rootNode.maxX > bentoMap.rootNode.minX &&
            rootNode.minY < bentoMap.rootNode.maxY && rootNode.maxY > bentoMap.rootNode.minY
    }

    /// A wrapper around the 4 child nodes of the rootNode
    var quadrants: QuadrantWrapper<BentoMap> {
        let (north, south) = rootNode.divide(0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BentoMap.init)
    }

}
