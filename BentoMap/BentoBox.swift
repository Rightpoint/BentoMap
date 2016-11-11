//
// BentoBox.swift
// BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct BentoBox<Rect: BentoRect, Coordinate: BentoCoordinate> {

    /// The root node of the tree. Can be thought of
    /// as the container map of the sub-rectangles
    public var root: Rect

    public init(minPoint: Coordinate, maxPoint: Coordinate) {

        let minX = min(minPoint.x, maxPoint.x)
        let minY = min(minPoint.y, maxPoint.y)
        let maxX = max(minPoint.x, maxPoint.x)
        let maxY = max(minPoint.y, maxPoint.y)

        root = Rect(originCoordinate: Coordinate(x: minX, y: minY),
                    size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    public init(root: Rect) {
        self.root = root
    }

}

// MARK: Public API

public extension BentoBox {

    /// The coordinate at the top left corner of the root rect
    public var minCoordinate: Coordinate {
        return Coordinate(x: root.minX, y: root.minY)
    }

    /// The coordinate at the bottom right corner of the root rect
    public var maxCoordinate: Coordinate {
        return Coordinate(x: root.maxX, y: root.maxY)
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
        // we aren't using MKMapRectContainsPoint(mapRect, pt) because it will test true for points that
        // are exatly on either edge, which means that a point exact on an edge may be counted in multiple boxes
        let width = root.maxX - root.minX
        let height = root.maxY - root.minY

        let isContained = coordinate.x >= root.minX &&
            coordinate.x < (root.minX + width) &&
            coordinate.y >= root.minY &&
            coordinate.y < (root.minY + height)
        return isContained
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

    func union(other: BentoBox<Rect, Coordinate>) -> Rect {
        return root.unionWith(other.root)
    }

}
