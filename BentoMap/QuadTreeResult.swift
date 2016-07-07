//
//  QuadTreeResult.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

public enum QuadTreeResult<NodeData> {

    case Single(node: QuadTreeNode<NodeData>)
    case Multiple(nodes: [QuadTreeNode<NodeData>])

    public var mapPoint: MKMapPoint {
        let mapPoint: MKMapPoint
        switch self {
        case let .Single(node):
            mapPoint = node.mapPoint
        case let .Multiple(nodes):
            var aggregatePoint = MKMapPoint()
            for node in nodes {
                aggregatePoint.x += node.mapPoint.x
                aggregatePoint.y += node.mapPoint.y
            }
            aggregatePoint.x /= Double(nodes.count)
            aggregatePoint.y /= Double(nodes.count)
            mapPoint = aggregatePoint
        }
        return mapPoint
    }

    public var contentRect: MKMapRect {
        let origin: MKMapPoint
        let size: MKMapSize
        switch  self {
        case let .Single(node: node):
            origin = node.mapPoint
            size = MKMapSize()
        case let .Multiple(nodes: nodes):
            var minPoint = MKMapPoint(x: DBL_MAX, y: DBL_MAX)
            var maxPoint = MKMapPoint(x: DBL_MIN, y: DBL_MIN)
            for node in nodes {
                minPoint.x = min(minPoint.x, node.mapPoint.x)
                minPoint.y = min(minPoint.y, node.mapPoint.y)
                maxPoint.x = max(maxPoint.x, node.mapPoint.x)
                maxPoint.y = max(maxPoint.y, node.mapPoint.y)
            }
            origin = minPoint
            // slightly pad the size to make sure all nodes are contained
            size = MKMapSize(width: abs(minPoint.x - maxPoint.x) + 0.001,
                             height: abs(minPoint.y - maxPoint.y) + 0.001)
        }
        return MKMapRect(origin: origin, size: size)
    }

}
