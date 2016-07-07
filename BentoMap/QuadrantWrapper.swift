//
//  QuadrantWrapper.swift
//  BentoMap
//
//  Created by Michael Skiba on 7/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct QuadrantWrapper<Quadrant> {
    var northWest: Quadrant
    var northEast: Quadrant
    var southWest: Quadrant
    var southEast: Quadrant

    func map<NewQuadrant>(converter: (Quadrant) -> NewQuadrant) -> QuadrantWrapper<NewQuadrant> {
        return QuadrantWrapper<NewQuadrant>(northWest: converter(northWest),
                                            northEast: converter(northEast),
                                            southWest: converter(southWest),
                                            southEast: converter(southEast))
    }
}
