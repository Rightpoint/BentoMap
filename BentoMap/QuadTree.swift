//
//  QuadTree.swift
//  BentoBox
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

//following example code and text from https://robots.thoughtbot.com/how-to-handle-large-amounts-of-data-on-maps
public struct QuadTree<NodeData, R: BentoRect, C: BentoCoordinate> {

    /// The individual nodes that compose the QuadTree
    public var ordinalNodes: OrdinalNodes<NodeData, R, C>?

    /// The rectangular map specified by the QuadTree
    var root: BentoBox<R, C>

    /// The number of coordinates or points that an individual node may contain
    public let bucketCapacity: Int
    public var points = [QuadTreeNode<NodeData, C>]()

    public init(bentoBox: BentoBox<R, C>, bucketCapacity: Int) {
        precondition(bucketCapacity > 0, "Bucket capacity must be greater than 0")
        self.root = bentoBox
        self.bucketCapacity = bucketCapacity
    }

}

public extension QuadTree {


    /// Recursively computes the bounding box of the points in the quad tree in O(n) time.
    public var bentoBox: BentoBox<R, C> {
        let boundingBox: BentoBox<R, C> = points.boundingBox()

        if let ordinals = ordinalNodes {
            boundingBox.union(ordinals.northWest.bentoBox)
            boundingBox.union(ordinals.northEast.bentoBox)
            boundingBox.union(ordinals.southWest.bentoBox)
            boundingBox.union(ordinals.southEast.bentoBox)
        }

        return boundingBox
    }

    /**
     Computes clusters of data based on the zoomscale
     and cell size passed in.

     - parameter rootNode:  the root bentoBox of the Quadtree (used
     to compute the bounding rectangle for the map.
     - parameter zoomScale: used to calculate scale factor relative to the cell size passed in.
     - parameter cellSize:  the desired size for the "clustering region" for each individual bucket.i

     - returns: an array of quadtree results for each cell that contains nodes.
     */
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
                let nodes = nodesInRange(BentoBox(rootNode: cellRectangle))

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


    /**
     Inserts a node if the node fits in the
     bucket's coordinate space and if the bucket
     capacty has not been reach. If the bucket
     capacity has been reached, it subdivides the
     Quadtree (if required) and inserts the node
     into the appropriate subnode.

     - parameter node: the node to insert.

     - returns: a Bool indicating success or failure of the insertion.
     */
    public mutating func insertNode(node: QuadTreeNode<NodeData, C>) -> Bool {
        guard root.containsCoordinate(node.mapPoint) else {
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

    /**
     Divides the QuadTree into quadrants of equal dimension.
     */
    mutating func subdivide() {
        let trees = root.quadrants.map { quadrant in
            QuadTree(bentoBox: quadrant, bucketCapacity: self.bucketCapacity)
        }

        ordinalNodes = OrdinalNodes(northWest: trees.northWest,
                                    northEast: trees.northEast,
                                    southWest: trees.southWest,
                                    southEast: trees.southEast)
    }

    /**
     Computes the collection of nodes contained within a box's
     coordinate space.

     - parameter range: the containing box.

     - returns: a collection of nodes.
     */
    func nodesInRange(range: BentoBox<R, C>) -> [QuadTreeNode<NodeData, C>] {
        var nodes = [QuadTreeNode<NodeData, C>]()

        guard root.intersectsBentoBox(range) else {
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
