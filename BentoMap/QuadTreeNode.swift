//
//  QuadTreeNode.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public protocol BentoCoordinate {

    var _x: CGFloat { get }
    var _y: CGFloat { get }

    init(_x: CGFloat, _y: CGFloat)
}

public protocol BentoRect {

    var maxX: CGFloat { get }
    var maxY: CGFloat { get }
    var minX: CGFloat { get }
    var minY: CGFloat { get }

    func containsCoordinate(c: BentoCoordinate) -> Bool

    func divide(percent: CGFloat, edge: CGRectEdge) -> (Self, Self)

    func unionWith(other: Self) -> Self

    init(originCoordinate: BentoCoordinate, size: CGSize)
}

public struct QuadTreeNode<NodeData, C: BentoCoordinate> {

    public var mapPoint: C
    public var content: NodeData

    public init(mapPoint: C, content: NodeData) {
        self.mapPoint = mapPoint
        self.content = content
    }

}

public protocol CoordinateProvider {

    associatedtype CoordinateType: BentoCoordinate

    var coordinate: CoordinateType { get }

}

extension QuadTreeNode: CoordinateProvider {

    public typealias CoordinateType = C

    public var coordinate: C {
        return mapPoint
    }

}
