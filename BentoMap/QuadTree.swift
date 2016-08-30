//
//  QuadTree.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

//following example code and text from https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps
public struct QuadTree<NodeData, R: BentoRect, C: BentoCoordinate> {

    var ordinalNodes: OrdinalNodes<NodeData, R, C>?

    public let bentoMap: BentoMap<R, C>
    public let bucketCapacity: Int
    public var points = [QuadTreeNode<NodeData, C>]()

    public init(bentoMap: BentoMap<R, C>, bucketCapacity: Int) {
        precondition(bucketCapacity > 0, "Bucket capacity must be greater than 0")
        self.bentoMap = bentoMap
        self.bucketCapacity = bucketCapacity
    }

}

public extension QuadTree {

    public func clusteredDataWithinMapRect(rootNode: R, zoomScale: Double, cellSize: Double) -> [QuadTreeResult<NodeData, R, C>] {

        let scaleFactor: Double

        // Prevents divide by zero errors from cropping up if handed bad data
        if cellSize == 0 || zoomScale == 0 {
            scaleFactor = 1
        } else {
            scaleFactor = zoomScale / cellSize
        }

        let stepSize = CGFloat(1.0 / scaleFactor)

        let minX = rootNode.minX
        let maxX = rootNode.maxX
        let minY = rootNode.minY
        let maxY = rootNode.maxY

        var result = [QuadTreeResult<NodeData, R, C>]()

        let mapStep = CGSize(width: Double(stepSize), height: Double(stepSize))
        for x in minX.stride(through: maxX, by: stepSize) {
            for y in minY.stride(through: maxY, by: stepSize) {
                let cellRectangle = R(originCoordinate: C(_x: x, _y: y), size: mapStep)
                let nodes = nodesInRange(BentoMap(rootNode: cellRectangle))

                switch nodes.count {
                case 0:
                    continue
                case 1:
                    if let first = nodes.first {
                        result.append(.Single(node: first))
                    }
                default:
                    result.append(.Multiple(nodes: nodes))
                }
            }
        }
        return result
    }


    public mutating func insertNode(node: QuadTreeNode<NodeData, C>) -> Bool {
        guard bentoMap.containsCoordinate(node.mapPoint) else {
            return false
        }

        if points.count < bucketCapacity {
            points.append(node)
            return true
        }

        if ordinalNodes == nil {
            subdivide()
        }

        return ordinalNodes?.northWest.insertNode(node) ||?
            ordinalNodes?.northEast.insertNode(node) ||?
            ordinalNodes?.southWest.insertNode(node) ||?
            ordinalNodes?.southEast.insertNode(node)
    }

}

private extension QuadTree {

    mutating func subdivide() {
        let trees = bentoMap.quadrants.map { quadrant in
            QuadTree(bentoMap: quadrant, bucketCapacity: self.bucketCapacity)
        }

        ordinalNodes = OrdinalNodes(northWest: trees.northWest,
                                    northEast: trees.northEast,
                                    southWest: trees.southWest,
                                    southEast: trees.southEast)
    }

    func nodesInRange(range: BentoMap<R, C>) -> [QuadTreeNode<NodeData, C>] {
        var nodes = [QuadTreeNode<NodeData, C>]()

        guard bentoMap.intersectsBentoBox(range) else {
            return nodes
        }

        nodes += points.filter { point in
            range.containsCoordinate(point.mapPoint)
        }

        if let ordinals = ordinalNodes {
            nodes += ordinals.northWest.nodesInRange(range)
            nodes += ordinals.northEast.nodesInRange(range)
            nodes += ordinals.southWest.nodesInRange(range)
            nodes += ordinals.southEast.nodesInRange(range)
        }

        return nodes
    }

}
