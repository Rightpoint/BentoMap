//
//  BoundingBoxTests.swift
//  BentoMapTests
//
//  Created by Michael Skiba on 7/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import MapKit
@testable import BentoMap

class BoundingBoxTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBoundingBoxCreation() {

        let mapRect = MKMapRectWorld

        let mapRectBoundingBox = BoundingBox(mapRect: mapRect)

        XCTAssert(MKMapRectEqualToRect(mapRect, mapRectBoundingBox.mapRect), "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CLLocationCoordinate2D(latitude: 30, longitude: 60)
        let minCoord = CLLocationCoordinate2D(latitude: 20, longitude: 40)

        let coordBoundingBox = BoundingBox(minCoordinate: minCoord, maxCoordinate: maxCoord)

        let minLat = min(minCoord.latitude, maxCoord.latitude)
        XCTAssertEqualWithAccuracy(coordBoundingBox.minCoordinate.latitude, minLat, accuracy: 0.001, "The bounding box's min latitude \(coordBoundingBox.minCoordinate.latitude) should equal the smallest latitude passed in \(minLat)")


        let maxLat = max(minCoord.latitude, maxCoord.latitude)
        XCTAssertEqualWithAccuracy(coordBoundingBox.maxCoordinate.latitude, maxLat, accuracy: 0.001, "The bounding box's max latitude \(coordBoundingBox.maxCoordinate.latitude) should equal the largest latitude passed in \(maxLat)")

        let minLong = min(minCoord.longitude, maxCoord.longitude)
        XCTAssertEqualWithAccuracy(coordBoundingBox.minCoordinate.longitude, minLong, accuracy: 0.001, "The bounding box's min longitude \(coordBoundingBox.minCoordinate.longitude) should equal the smallest longitude passed in \(minLong)")


        let maxLong = max(minCoord.longitude, maxCoord.longitude)
        XCTAssertEqualWithAccuracy(coordBoundingBox.maxCoordinate.longitude, maxLong, accuracy: 0.001, "The bounding box's max longitude \(coordBoundingBox.minCoordinate.longitude) should equal the largest longitude passed in \(minLong)")
    }

    func testBoundingBoxCoordinates() {
        let coordBoundingBox = BoundingBox(minCoordinate: CLLocationCoordinate2D(latitude: 30, longitude: 60),
                                           maxCoordinate: CLLocationCoordinate2D(latitude: 20, longitude: 40))

        let maxPoint = coordBoundingBox.maxPoint
        let minPoint = coordBoundingBox.minPoint

        // the min or higher is inside the bounding box
        XCTAssert(coordBoundingBox.containsMapPoint(minPoint.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssert(coordBoundingBox.containsMapPoint(minPoint.offset(longitude: 0.1)))
        XCTAssert(coordBoundingBox.containsMapPoint(minPoint.offset(latitude: 0.1)))
        XCTAssert(coordBoundingBox.containsMapPoint(minPoint))
        // slightly lower than the map is inside the mounding box
        XCTAssert(coordBoundingBox.containsMapPoint(maxPoint.offset(latitude: -0.1, longitude: -0.1)))
        // the max or higher is outside the bounding box
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint.offset(longitude: -0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint.offset(latitude: -0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint.offset(longitude: 0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(maxPoint.offset(latitude: 0.1)))
        // lower than the min is outside the bounding box
        XCTAssertFalse(coordBoundingBox.containsMapPoint(minPoint.offset(latitude: -0.1, longitude: -0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(minPoint.offset(longitude: -0.1)))
        XCTAssertFalse(coordBoundingBox.containsMapPoint(minPoint.offset(latitude: -0.1)))

        // the middle point is inside the bounding box
        let midCoord = MKMapPoint(x: (maxPoint.x + minPoint.x) / 2.0,
                                  y: (maxPoint.y + minPoint.y) / 2.0)
        XCTAssert(coordBoundingBox.containsMapPoint(midCoord))
    }

    func testBoundingBoxIntersection() {
        let rect = MKMapRectMake(0, 0, 500, 500)
        let intersectingRect =  MKMapRectMake(250, 250, 500, 500)
        let nonIntersectingRect = MKMapRectMake(500, 0, 500, 500)

        let boundingBox = BoundingBox(mapRect: rect)
        let intersectingBox = BoundingBox(mapRect: intersectingRect)
        let nonIntersectingBox = BoundingBox(mapRect: nonIntersectingRect)

        XCTAssert(boundingBox.intersectsBoundingBox(intersectingBox))
        XCTAssertFalse(boundingBox.intersectsBoundingBox(nonIntersectingBox))
    }

    func testQuadrants() {
        let baseRect = MKMapRectMake(0, 0, 500, 500)
        let nwRect = MKMapRectMake(0, 0, 250, 250)
        let neRect = MKMapRectMake(250, 0, 250, 250)
        let swRect = MKMapRectMake(0, 250, 250, 250)
        let seRect = MKMapRectMake(250, 250, 250, 250)

        let quadrants = BoundingBox(mapRect: baseRect).quadrants

        XCTAssert(MKMapRectEqualToRect(quadrants.northWest.mapRect, nwRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.northEast.mapRect, neRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southWest.mapRect, swRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southEast.mapRect, seRect))
    }
}

private extension MKMapPoint {
    func offset(latitude latitudeOffset: Double = 0, longitude longitudeOffset: Double = 0) -> MKMapPoint {
        return MKMapPoint(x: x + latitudeOffset, y: y + longitudeOffset)
    }
}
