//
//  QuadTreeResult.swift
// BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public enum QuadTreeResult<NodeData, Rect: BentoRect, Coordinate: BentoCoordinate> {

    case single(node: QuadTreeNode<NodeData, Coordinate>)
    case multiple(nodes: [QuadTreeNode<NodeData, Coordinate>])

    /// The average of the origin points of all the nodes
    /// contained in the QuadTree.
    public var originCoordinate: Coordinate {
        let originCoordinate: Coordinate
        switch self {
        case let .single(node):
            originCoordinate = node.originCoordinate
        case let .multiple(nodes):
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            for node in nodes {
                x += node.originCoordinate.coordX
                y += node.originCoordinate.coordY
            }
            x /= CGFloat(nodes.count)
            y /= CGFloat(nodes.count)
            originCoordinate = Coordinate(coordX: x, coordY: y)
        }
        return originCoordinate
    }

    /// The smallest possible rectangle that contains the node(s) contained in this QuadTree.
    public var contentRect: Rect {
        let origin: Coordinate
        let size: CGSize
        switch  self {
        case let .single(node: node):
            origin = node.originCoordinate
            size = CGSize()
        case let .multiple(nodes: nodes):
            var minCoordinate = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
            var maxCoordinate = CGPoint(x: -CGFloat.greatestFiniteMagnitude, y: -CGFloat.greatestFiniteMagnitude)
            for node in nodes {
                minCoordinate.x = min(minCoordinate.coordX, node.originCoordinate.coordX)
                minCoordinate.y = min(minCoordinate.coordY, node.originCoordinate.coordY)
                maxCoordinate.x = max(maxCoordinate.coordX, node.originCoordinate.coordX)
                maxCoordinate.y = max(maxCoordinate.coordY, node.originCoordinate.coordY)
            }
            origin = Coordinate(coordX: minCoordinate.coordX, coordY: minCoordinate.coordY)
            // slightly pad the size to make sure all nodes are contained
            size = CGSize(width: abs(minCoordinate.x - maxCoordinate.x) + 0.001,
                             height: abs(minCoordinate.y - maxCoordinate.y) + 0.001)
        }
        return Rect(originCoordinate: origin, size: size)
    }

}
