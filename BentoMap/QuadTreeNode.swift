//
//  QuadTreeNode.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public protocol Initializable {
    init()
}

public protocol BentoCoordinate: Initializable {

    var _x: CGFloat { get }
    var _y: CGFloat { get }

    init(_x: CGFloat, _y: CGFloat)
}

public protocol BentoRect: Initializable {

    var maxX: CGFloat { get }
    var maxY: CGFloat { get }
    var minX: CGFloat { get }
    var minY: CGFloat { get }

    func containsCoordinate(c: BentoCoordinate) -> Bool

    func divide(percent: CGFloat, edge: CGRectEdge) -> (Self, Self)

    init(originCoordinate: BentoCoordinate, size: CGSize)
}

extension BentoRect {

    func intersects(rect: BentoRect) -> Bool {
        return true
    }

}

public struct QuadTreeNode<NodeData, C: BentoCoordinate> {

    public var mapPoint: C
    public var content: NodeData

    public init(mapPoint: C, content: NodeData) {
        self.mapPoint = mapPoint
        self.content = content
    }

}
