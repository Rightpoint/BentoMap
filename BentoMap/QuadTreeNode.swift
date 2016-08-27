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

public protocol BentoCoordinate: Initializable {

    var _x: CGFloat { get }
    var _y: CGFloat { get }

    init(x: CGFloat, y: CGFloat)
}

public protocol BentoRect: Initializable {

    var maxX: CGFloat { get }
    var maxY: CGFloat { get }
    var minX: CGFloat { get }
    var minY: CGFloat { get }

    func contains(c: BentoCoordinate) -> Bool

    func divide(percent: CGFloat, edge: CGRectEdge) -> (Self, Self)

    init(origin: BentoCoordinate, size: CGSize)
}

//public protocol MapPointProvider {
//
//    associatedtype C = BentoCoordinate
//    associatedtype R = BentoRect
//
//    var mapPoint: C { get }
//
//}

//extension MKMapPoint: MapPointProvider {
//
//    public var mapPoint: MKMapPoint { return self }
//
//}

public struct QuadTreeNode<NodeData, C: BentoCoordinate> {

    public var mapPoint: C
    public var content: NodeData

    public init(mapPoint: C, content: NodeData) {
        self.mapPoint = mapPoint
        self.content = content
    }

}
