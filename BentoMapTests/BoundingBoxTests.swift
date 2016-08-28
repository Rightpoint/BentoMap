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

        let mapRectBoundingBox = BentoBox<MKMapRect, MKMapPoint>(mapRect: mapRect)

        XCTAssert(MKMapRectEqualToRect(mapRect, mapRectBoundingBox.mapRect), "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CLLocationCoordinate2D(latitude: 30, longitude: 60)
        let minCoord = CLLocationCoordinate2D(latitude: 20, longitude: 40)

        let coordBoundingBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: minCoord, maxPoint: maxCoord)

        let minLat = CGFloat(min(minCoord._x, maxCoord._x))
        XCTAssertEqualWithAccuracy(coordBoundingBox.mapRect.minX, minLat, accuracy: 0.001, "The bounding box's min latitude \(coordBoundingBox.mapRect.minX) should equal the smallest latitude passed in \(minLat)")


        let maxLat = max(minCoord._x, maxCoord._x)
        XCTAssertEqualWithAccuracy(coordBoundingBox.maxPoint._x, maxLat, accuracy: 0.001, "The bounding box's max latitude \(coordBoundingBox.maxPoint._x) should equal the largest latitude passed in \(maxLat)")

        let minLong = min(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBoundingBox.minPoint._y, minLong, accuracy: 0.001, "The bounding box's min longitude \(coordBoundingBox.minPoint._y) should equal the smallest longitude passed in \(minLong)")


        let maxLong = max(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBoundingBox.maxPoint._y, maxLong, accuracy: 0.001, "The bounding box's max longitude \(coordBoundingBox.minPoint._y) should equal the largest longitude passed in \(minLong)")
    }

    func testBoundingBoxCoordinates() {
        let coordBoundingBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: CLLocationCoordinate2D(latitude: 30, longitude: 60),
                                        maxPoint: CLLocationCoordinate2D(latitude: 20, longitude: 40))

        let maxPoint = MKMapPoint(x: Double(coordBoundingBox.maxPoint._x), y: Double(coordBoundingBox.maxPoint._y))
        let minPoint = MKMapPoint(x: Double(coordBoundingBox.minPoint._x), y: Double(coordBoundingBox.minPoint._y))

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
        let midCoord = MKMapPoint(x: Double(maxPoint._x + minPoint._x) / 2.0,
                                  y: Double(maxPoint._y + minPoint._y) / 2.0)
        XCTAssert(coordBoundingBox.containsMapPoint(midCoord))
    }

    func testBoundingBoxIntersection() {
        let rect = MKMapRectMake(0, 0, 500, 500)
        let intersectingRect =  MKMapRectMake(250, 250, 500, 500)
        let nonIntersectingRect = MKMapRectMake(500, 0, 500, 500)

        let bentoBox = BentoBox<MKMapRect, MKMapPoint>(mapRect: rect)
        let intersectingBox = BentoBox<MKMapRect, MKMapPoint>(mapRect: intersectingRect)
        let nonIntersectingBox = BentoBox<MKMapRect, MKMapPoint>(mapRect: nonIntersectingRect)

        XCTAssert(bentoBox.intersectsBentoBox(intersectingBox))
        XCTAssertFalse(bentoBox.intersectsBentoBox(nonIntersectingBox))
    }

    func testQuadrants() {
        let baseRect = MKMapRectMake(0, 0, 500, 500)
        let nwRect = MKMapRectMake(0, 0, 250, 250)
        let neRect = MKMapRectMake(250, 0, 250, 250)
        let swRect = MKMapRectMake(0, 250, 250, 250)
        let seRect = MKMapRectMake(250, 250, 250, 250)

        let quadrants = BentoBox<MKMapRect, MKMapPoint>(mapRect: baseRect).quadrants

        XCTAssert(MKMapRectEqualToRect(quadrants.northWest.mapRect, nwRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.northEast.mapRect, neRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southWest.mapRect, swRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southEast.mapRect, seRect))
    }

    func testCollectionTypeExtensions() {
        let points = [
            MKMapPoint(x: 25.0, y: 10956.7),
            MKMapPoint(x: 1894.5, y: 22897.5550),
            MKMapPoint(x: 25278.445, y: 156.339),
            MKMapPoint(x: 17603.8472, y: 2456.7),
        ]

        let mapPointBentoBox: BentoBox<MKMapRect, MKMapPoint> = points.bentoBox()

        let minPoint = mapPointBentoBox.minPoint
        let maxPoint = mapPointBentoBox.maxPoint

        XCTAssert(MKMapPointEqualToPoint(minPoint, MKMapPoint(x: 25.0, y: 156.339)))
        XCTAssert(MKMapPointEqualToPoint(maxPoint, MKMapPoint(x: 25278.445, y: 22897.5550)))

        let coords = [
            CLLocationCoordinate2D(latitude: 34.6790, longitude: 28.2847),
            CLLocationCoordinate2D(latitude: -34.6790, longitude: 88.1349),
            CLLocationCoordinate2D(latitude: 61.9471, longitude: -14.1887),
            CLLocationCoordinate2D(latitude: 1.2898, longitude: 42.4277),
        ]

        let coordinateBentoBox: BentoBox<MKMapRect, CLLocationCoordinate2D> = coords.bentoBox()

        XCTAssertEqualWithAccuracy(coordinateBentoBox.minPoint._x, -34.6790, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.minPoint._y, -14.1887, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxPoint._x, 61.9471, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxPoint._y, 88.1349, accuracy: 1e-4)
    }
}

private extension MKMapPoint {
    func offset(latitude latitudeOffset: Double = 0, longitude longitudeOffset: Double = 0) -> MKMapPoint {
        return MKMapPoint(x: x + latitudeOffset, y: y + longitudeOffset)
    }
}
