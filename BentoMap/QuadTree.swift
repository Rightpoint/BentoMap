//
//  QuadTree.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import MapKit

//following example code and text from https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps
public struct QuadTree<NodeData> {

    var ordinalNodes: OrdinalNodes<NodeData>?

    public let bucketRegion: BoundingBox
    public let bucketCapacity: Int
    public var points = [QuadTreeNode<NodeData>]()

    public init(bucketRegion: BoundingBox = .world, bucketCapacity: Int) {
        precondition(bucketCapacity > 0, "Bucket capacity must be greater than 0")
        self.bucketRegion = bucketRegion
        self.bucketCapacity = bucketCapacity
    }

}

public extension QuadTree {

    /// Recursively computes the bounding box of the points in the quad tree in O(n) time.
    public var boundingBox: BoundingBox {
        var boundingBox = points.boundingBox

        if let ordinals = ordinalNodes {
            boundingBox.union(ordinals.northWest.boundingBox)
            boundingBox.union(ordinals.northEast.boundingBox)
            boundingBox.union(ordinals.southWest.boundingBox)
            boundingBox.union(ordinals.southEast.boundingBox)
        }

        return boundingBox
    }

    public func clusteredDataWithinMapRect(mapRect: MKMapRect, zoomScale: Double, cellSize: Double) -> [QuadTreeResult<NodeData>] {

        let scaleFactor: Double

        // Prevents divide by zero errors from cropping up if handed bad data
        if cellSize == 0 || zoomScale == 0 {
            scaleFactor = 1
        }
        else {
            scaleFactor = zoomScale / cellSize
        }

        let stepSize = Int(1.0 / scaleFactor)

        let minX = mapRect.createStep(stepSize, edgeFunction: MKMapRectGetMinX, roundingFunction: floor)
        let maxX = mapRect.createStep(stepSize, edgeFunction: MKMapRectGetMaxX, roundingFunction: ceil)
        let minY = mapRect.createStep(stepSize, edgeFunction: MKMapRectGetMinY, roundingFunction: floor)
        let maxY = mapRect.createStep(stepSize, edgeFunction: MKMapRectGetMaxY, roundingFunction: ceil)

        var result = [QuadTreeResult<NodeData>]()

        let mapStep = MKMapSize(width: Double(stepSize), height: Double(stepSize))
        for x in minX.stride(through: maxX, by: stepSize) {
            for y in minY.stride(through: maxY, by: stepSize) {
                let cellRect = MKMapRect(origin: MKMapPoint(x: Double(x), y: Double(y)), size: mapStep)
                let nodes = nodesInRange(BoundingBox(mapRect: cellRect))

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


    public mutating func insertNode(node: QuadTreeNode<NodeData>) -> Bool {
        guard bucketRegion.containsMapPoint(node.mapPoint) else {
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
        let trees = bucketRegion.quadrants.map { quadrant in
            QuadTree(bucketRegion: quadrant, bucketCapacity: self.bucketCapacity)
        }

        ordinalNodes = OrdinalNodes(northWest: trees.northWest,
                                    northEast: trees.northEast,
                                    southWest: trees.southWest,
                                    southEast: trees.southEast)
    }

    func nodesInRange(range: BoundingBox) -> [QuadTreeNode<NodeData>] {
        var nodes = [QuadTreeNode<NodeData>]()

        guard bucketRegion.intersectsBoundingBox(range) else {
            return nodes
        }

        nodes += points.filter { point in
            range.containsMapPoint(point.mapPoint)
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

private extension MKMapRect {

    func createStep(stepSize: Int, edgeFunction: (MKMapRect -> Double),
                    roundingFunction: (Double -> Double)) -> Int {
        return Int(roundingFunction(edgeFunction(self))) - (Int(roundingFunction(edgeFunction(self))) % stepSize)
    }

}
