//
//  BentoBox.swift
//  BentoBox
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BentoBox<R: BentoRect, C: BentoCoordinate> {

    /// The root node of the tree. Can be thought of
    /// as the container map of the sub-rectangles
    public var root: R

    public init(minPoint: C, maxPoint: C) {

        let minX = min(minPoint._x, maxPoint._x)
        let minY = min(minPoint._y, maxPoint._y)
        let maxX = max(minPoint._x, maxPoint._x)
        let maxY = max(minPoint._y, maxPoint._y)

        root = R(originCoordinate: C(_x: minX, _y: minY),
                    size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(root: R) {
        self.root = root
    }

}

// MARK: Public API

public extension BentoBox {

    /// The coordinate at the top left corner of the root rect
    public var minCoordinate: C {
        return C(_x: root.minX, _y: root.minY)
    }

    /// The coordinate at the bottom right corner of the root rect
    public var maxCoordinate: C {
        return C(_x: root.maxX, _y: root.maxY)
    }

}

extension BentoBox {

    /**
     Returns a Bool value for whether the root contains
     the coordinate passed in

     - parameter coordinate: a BentoCoordinate

     - returns: whether the root contains
     the coordinate passed in
     */
    func containsCoordinate(coordinate: BentoCoordinate) -> Bool {
        return root.containsCoordinate(coordinate)
    }

    /**
     Returns a Bool value for whether the root intersects with the
     root of the bentoBox passed in

     - parameter bentoBox: a BentoBox

     - returns: whether the root intersects with the
     root of the bentoBox passed in
     */
    func intersectsBentoBox(bentoBox: BentoBox) -> Bool {
        return root.minX < bentoBox.root.maxX && root.maxX > bentoBox.root.minX &&
            root.minY < bentoBox.root.maxY && root.maxY > bentoBox.root.minY
    }

    /// A wrapper around the 4 child nodes of the root
    var quadrants: QuadrantWrapper<BentoBox> {
        let (north, south) = root.divide(0.5, edge: .MinYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .MinXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .MinXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BentoBox.init)
    }

    func union(other: BentoBox<R, C>) -> R {
        return root.unionWith(other.root)
    }

}
