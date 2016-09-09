//
//  QuadrantWrapper.swift
//  BentoBox
//
//  Created by Michael Skiba on 7/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct QuadrantWrapper<Quadrant> {

    /// top left node
    var northWest: Quadrant

    /// top right node
    var northEast: Quadrant

    /// bottom left node
    var southWest: Quadrant

    /// bottom right node
    var southEast: Quadrant

    /**
     Applies a closure to each quadrant.

     - parameter converter: a closure that takes a Quadrant type
     and returns another type specified in the function signature.

     - returns: a new QuadrantWrapper containing a new type.
     */
    func map<NewQuadrant>(converter: (Quadrant) -> NewQuadrant) -> QuadrantWrapper<NewQuadrant> {
        return QuadrantWrapper<NewQuadrant>(northWest: converter(northWest),
                                            northEast: converter(northEast),
                                            southWest: converter(southWest),
                                            southEast: converter(southEast))
    }
}
