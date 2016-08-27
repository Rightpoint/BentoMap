//
//  QuadTreeResult.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public enum QuadTreeResult<NodeData, R: BentoRect, C: BentoCoordinate> {

    case Single(node: QuadTreeNode<NodeData, C>)
    case Multiple(nodes: [QuadTreeNode<NodeData, C>])

    public var mapPoint: C {
        let mapPoint: C
        switch self {
        case let .Single(node):
            mapPoint = node.mapPoint
        case let .Multiple(nodes):
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            for node in nodes {
                x += node.mapPoint.x
                y += node.mapPoint.y
            }
            x /= CGFloat(nodes.count)
            y /= CGFloat(nodes.count)
            mapPoint = C(x: x, y: y)
        }
        return mapPoint
    }

    public var contentRectangle: R {
        let origin: C
        let size: CGSize
        switch  self {
        case let .Single(node: node):
            origin = node.mapPoint
            size = CGSize()
        case let .Multiple(nodes: nodes):
            var minPoint = CGPoint(x: CGFloat(DBL_MAX), y: CGFloat(DBL_MAX))
            var maxPoint = CGPoint(x: CGFloat(DBL_MIN), y: CGFloat(DBL_MIN))
            for node in nodes {
                minPoint.x = min(minPoint.x, node.mapPoint.x)
                minPoint.y = min(minPoint.y, node.mapPoint.y)
                maxPoint.x = max(maxPoint.x, node.mapPoint.x)
                maxPoint.y = max(maxPoint.y, node.mapPoint.y)
            }
            origin = C(x: minPoint.x, y: minPoint.y)
            // slightly pad the size to make sure all nodes are contained
            size = CGSize(width: abs(minPoint.x - maxPoint.x) + 0.001,
                             height: abs(minPoint.y - maxPoint.y) + 0.001)
        }
        return R(origin: origin, size: size)
    }

}
