//
//  QuadTreeNode.swift
//  BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public protocol Initializable {
    init()
}

public protocol Coordinate: Initializable {

    var x: CGFloat { get set }
    var y: CGFloat { get set }

    init(x: CGFloat, y: CGFloat)
}

public protocol Rectangle: Initializable {

    var maxX: CGFloat { get }
    var maxY: CGFloat { get }
    var minX: CGFloat { get }
    var minY: CGFloat { get }

    func contains(c: Coordinate) -> Bool

    func divide(percent: CGFloat, edge: CGRectEdge) -> (Self, Self)

    init(origin: Coordinate, size: CGSize)
}

extension Coordinate {
    init(x: CGFloat, y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
}

//public protocol MapPointProvider {
//
//    associatedtype C = Coordinate
//    associatedtype R = Rectangle
//
//    var mapPoint: C { get }
//
//}

//extension MKMapPoint: MapPointProvider {
//
//    public var mapPoint: MKMapPoint { return self }
//
//}

public struct QuadTreeNode<NodeData, C: Coordinate> {

    public var mapPoint: C
    public var content: NodeData

    public init(mapPoint: C, content: NodeData) {
        self.mapPoint = mapPoint
        self.content = content
    }

}
