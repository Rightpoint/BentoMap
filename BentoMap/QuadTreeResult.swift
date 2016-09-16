//
//  QuadTreeResult.swift
//  BentoBox
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public enum QuadTreeResult<NodeData, R: BentoRect, C: BentoCoordinate> {

    case Single(node: QuadTreeNode<NodeData, C>)
    case Multiple(nodes: [QuadTreeNode<NodeData, C>])

    /// The average of the origin points of all the nodes
    /// contained in the QuadTree.
    public var originCoordinate: C {
        let originCoordinate: C
        switch self {
        case let .Single(node):
            originCoordinate = node.originCoordinate
        case let .Multiple(nodes):
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            for node in nodes {
                x += node.originCoordinate.x
                y += node.originCoordinate.y
            }
            x /= CGFloat(nodes.count)
            y /= CGFloat(nodes.count)
            originCoordinate = C(x: x, y: y)
        }
        return originCoordinate
    }

    /// The smallest possible rectangle that contains the node(s) contained in this QuadTree.
    public var contentRect: R {
        let origin: C
        let size: CGSize
        switch  self {
        case let .Single(node: node):
            origin = node.originCoordinate
            size = CGSize()
        case let .Multiple(nodes: nodes):
            var minCoordinate = CGPoint(x: CGFloat(DBL_MAX), y: CGFloat(DBL_MAX))
            var maxCoordinate = CGPoint(x: CGFloat(DBL_MIN), y: CGFloat(DBL_MIN))
            for node in nodes {
                minCoordinate.x = min(minCoordinate.x, node.originCoordinate.x)
                minCoordinate.y = min(minCoordinate.y, node.originCoordinate.y)
                maxCoordinate.x = max(maxCoordinate.x, node.originCoordinate.x)
                maxCoordinate.y = max(maxCoordinate.y, node.originCoordinate.y)
            }
            origin = C(x: minCoordinate.x, y: minCoordinate.y)
            // slightly pad the size to make sure all nodes are contained
            size = CGSize(width: abs(minCoordinate.x - maxCoordinate.x) + 0.001,
                             height: abs(minCoordinate.y - maxCoordinate.y) + 0.001)
        }
        return R(originCoordinate: origin, size: size)
    }

}
