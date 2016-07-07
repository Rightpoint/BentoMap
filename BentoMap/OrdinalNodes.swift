//
//  OrdinalNodes.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct OrdinalNodes<NodeData> {

    // Recursive structs require boxes
    private var quadrants: Box<QuadrantWrapper<QuadTree<NodeData>>>

    var northWest: QuadTree<NodeData> {
        get {
            return quadrants.value.northWest
        }
        set {
            quadrants.value.northWest = newValue
        }
    }

    var northEast: QuadTree<NodeData> {
        get {
            return quadrants.value.northEast
        }
        set {
            quadrants.value.northEast = newValue
        }
    }

    var southWest: QuadTree<NodeData> {
        get {
            return quadrants.value.southWest
        }
        set {
            quadrants.value.southWest = newValue
        }
    }

    var southEast: QuadTree<NodeData> {
        get {
            return quadrants.value.southEast
        }
        set {
            quadrants.value.southEast = newValue
        }
    }

    init(northWest: QuadTree<NodeData>,
         northEast: QuadTree<NodeData>,
         southWest: QuadTree<NodeData>,
         southEast: QuadTree<NodeData>) {
        quadrants = Box(value: QuadrantWrapper(northWest: northWest, northEast: northEast, southWest: southWest, southEast: southEast))
    }
}
