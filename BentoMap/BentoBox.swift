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

        let minX = min(minPoint.coordX, maxPoint.coordX)
        let minY = min(minPoint.coordY, maxPoint.coordY)
        let maxX = max(minPoint.coordX, maxPoint.coordX)
        let maxY = max(minPoint.coordY, maxPoint.coordY)

        root = Rect(originCoordinate: Coordinate(coordX: minX, coordY: minY),
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
        return Coordinate(coordX: root.minX, coordY: root.minY)
    }

    /// The coordinate at the bottom right corner of the root rect
    public var maxCoordinate: Coordinate {
        return Coordinate(coordX: root.maxX, coordY: root.maxY)
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
    func containsCoordinate(_ coordinate: BentoCoordinate) -> Bool {
        // we aren't using MKMapRectContainsPoint(mapRect, pt) because it will test true for points that
        // are exatly on either edge, which means that a point exact on an edge may be counted in multiple boxes
        let width = root.maxX - root.minX
        let height = root.maxY - root.minY

        let isContained = coordinate.coordX >= root.minX &&
            coordinate.coordX < (root.minX + width) &&
            coordinate.coordY >= root.minY &&
            coordinate.coordY < (root.minY + height)
        return isContained
    }

    /**
     Returns a Bool value for whether the root intersects with the
     root of the bentoBox passed in

     - parameter bentoBox: a BentoBox

     - returns: whether the root intersects with the
     root of the bentoBox passed in
     */
    func intersectsBentoBox(_ bentoBox: BentoBox) -> Bool {
        return root.minX < bentoBox.root.maxX && root.maxX > bentoBox.root.minX &&
            root.minY < bentoBox.root.maxY && root.maxY > bentoBox.root.minY
    }

    /// A wrapper around the 4 child nodes of the root
    var quadrants: QuadrantWrapper<BentoBox> {
        let (north, south) = root.divide(0.5, edge: .minYEdge)
        let (northWest, northEast) = north.divide(0.5, edge: .minXEdge)
        let (southWest, southEast) = south.divide(0.5, edge: .minXEdge)

        return QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast).map(BentoBox.init)
    }

    @discardableResult func union(_ other: BentoBox<Rect, Coordinate>) -> Rect {
        return root.unionWith(other.root)
    }

}
