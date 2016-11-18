//
//  OrdinalNodes.swift
// BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct OrdinalNodes<NodeData, Rect: BentoRect, Coordinate: BentoCoordinate> {

    /// A type that exposes all 4 quadrants of a given QuadTree
    fileprivate typealias QuadTreeWrapper = QuadrantWrapper<QuadTree<NodeData, Rect, Coordinate>>

    // Recursive structs require a workaround class type
    // because it is impossible at runtime to calculate
    // how much memory must be allocated
    fileprivate var quadrants: Box<QuadTreeWrapper>

    /// The NorthWest quadrant of the QuadTree's root.
    var northWest: QuadTree<NodeData, Rect, Coordinate> {
        get {
            return quadrants.value.northWest
        }
        set {
            quadrants.value.northWest = newValue
        }
    }

    /// The NorthEast quadrant of the QuadTree's root.
    var northEast: QuadTree<NodeData, Rect, Coordinate> {
        get {
            return quadrants.value.northEast
        }
        set {
            quadrants.value.northEast = newValue
        }
    }

    /// The SouthWest quadrant of the QuadTree's root.
    var southWest: QuadTree<NodeData, Rect, Coordinate> {
        get {
            return quadrants.value.southWest
        }
        set {
            quadrants.value.southWest = newValue
        }
    }

    /// The SouthEast quadrant of the QuadTree's root.
    var southEast: QuadTree<NodeData, Rect, Coordinate> {
        get {
            return quadrants.value.southEast
        }
        set {
            quadrants.value.southEast = newValue
        }
    }

    init(northWest: QuadTree<NodeData, Rect, Coordinate>,
         northEast: QuadTree<NodeData, Rect, Coordinate>,
         southWest: QuadTree<NodeData, Rect, Coordinate>,
         southEast: QuadTree<NodeData, Rect, Coordinate>) {
        quadrants = Box(value: QuadrantWrapper(northWest: northWest,
            northEast: northEast,
            southWest: southWest,
            southEast: southEast))
    }
}
