//
//  OrdinalNodes.swift
//  BentoBox
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct OrdinalNodes<NodeData, R: BentoRect, C: BentoCoordinate> {

    /// A type that exposes all 4 quadrants of a given QuadTree
    private typealias QuadTreeWrapper = QuadrantWrapper<QuadTree<NodeData, R, C>>

    // Recursive structs require a workaround class type
    // because it is impossible at runtime to calculate
    // how much memory must be allocated
    private var quadrants: Box<QuadTreeWrapper>

    /// The NorthWest quadrant of the QuadTree's root.
    var northWest: QuadTree<NodeData, R, C> {
        get {
            return quadrants.value.northWest
        }
        set {
            quadrants.value.northWest = newValue
        }
    }

    /// The NorthEast quadrant of the QuadTree's root.
    var northEast: QuadTree<NodeData, R, C> {
        get {
            return quadrants.value.northEast
        }
        set {
            quadrants.value.northEast = newValue
        }
    }

    /// The SouthWest quadrant of the QuadTree's root.
    var southWest: QuadTree<NodeData, R, C> {
        get {
            return quadrants.value.southWest
        }
        set {
            quadrants.value.southWest = newValue
        }
    }

    /// The SouthEast quadrant of the QuadTree's root.
    var southEast: QuadTree<NodeData, R, C> {
        get {
            return quadrants.value.southEast
        }
        set {
            quadrants.value.southEast = newValue
        }
    }

    init(northWest: QuadTree<NodeData, R, C>,
         northEast: QuadTree<NodeData, R, C>,
         southWest: QuadTree<NodeData, R, C>,
         southEast: QuadTree<NodeData, R, C>) {
        quadrants = Box(value: QuadrantWrapper(northWest: northWest,
            northEast: northEast,
            southWest: southWest,
            southEast: southEast))
    }
}
