//
//  BentoBoxTests.swift
//  BentoMapTests
//
//  Created by Michael Skiba on 7/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import MapKit
@testable import BentoMap

class MapKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBentoBoxCreation() {

        let mapRect = MKMapRectWorld

        let mapRectBentoBox = BentoBox<MKMapRect, MKMapPoint>(mapRect: mapRect)

        XCTAssert(MKMapRectEqualToRect(mapRect, mapRectBentoBox.mapRect), "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CLLocationCoordinate2D(latitude: 30, longitude: 60)
        let minCoord = CLLocationCoordinate2D(latitude: 20, longitude: 40)

        let coordBentoBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: minCoord, maxPoint: maxCoord)

        let minLat = CGFloat(min(minCoord._x, maxCoord._x))
        XCTAssertEqualWithAccuracy(coordBentoBox.mapRect.minX, minLat, accuracy: 0.001, "The bounding box's min latitude \(coordBentoBox.mapRect.minX) should equal the smallest latitude passed in \(minLat)")


        let maxLat = max(minCoord._x, maxCoord._x)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxPoint._x, maxLat, accuracy: 0.001, "The bounding box's max latitude \(coordBentoBox.maxPoint._x) should equal the largest latitude passed in \(maxLat)")

        let minLong = min(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBentoBox.minPoint._y, minLong, accuracy: 0.001, "The bounding box's min longitude \(coordBentoBox.minPoint._y) should equal the smallest longitude passed in \(minLong)")


        let maxLong = max(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxPoint._y, maxLong, accuracy: 0.001, "The bounding box's max longitude \(coordBentoBox.minPoint._y) should equal the largest longitude passed in \(minLong)")
    }

    func testBentoBoxCoordinates() {
        let coordBentoBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: CLLocationCoordinate2D(latitude: 30, longitude: 60),
                                        maxPoint: CLLocationCoordinate2D(latitude: 20, longitude: 40))

        let maxPoint = MKMapPoint(x: Double(coordBentoBox.maxPoint._x), y: Double(coordBentoBox.maxPoint._y))
        let minPoint = MKMapPoint(x: Double(coordBentoBox.minPoint._x), y: Double(coordBentoBox.minPoint._y))

        // the min or higher is inside the bounding box
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(longitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(latitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint))
        // slightly lower than the map is inside the mounding box
        XCTAssert(coordBentoBox.containsCoordinate(maxPoint.offset(latitude: -0.1, longitude: -0.1)))
        // the max or higher is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(latitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(longitude: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(latitude: 0.1)))
        // lower than the min is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(latitude: -0.1, longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(latitude: -0.1)))


        // the middle point is inside the bounding box
        let midCoord = MKMapPoint(x: Double(maxPoint._x + minPoint._x) / 2.0,
                                  y: Double(maxPoint._y + minPoint._y) / 2.0)
        XCTAssert(coordBentoBox.containsCoordinate(midCoord))
    }

    func testBentoBoxIntersection() {
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

class CoreGraphicsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBentoBoxCreationForCGRect() {

        let origin = CGPoint.zero
        let gridSize = CGSize(width: 1000.0, height: 1000.0)
        let mapRect = CGRect(origin: origin, size: gridSize)

        let mapRectBentoBox = BentoBox<CGRect, CGPoint>(mapRect: mapRect)

        XCTAssertEqual(mapRect, mapRectBentoBox.mapRect, "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CGPoint(x: 30.0, y: 60.0)
        let minCoord = CGPoint(x: 20.0, y: 40.0)

        let coordBentoBox = BentoBox<CGRect, CGPoint>(minPoint: minCoord, maxPoint: maxCoord)

        let minLat = CGFloat(min(minCoord._x, maxCoord._x))
        XCTAssertEqualWithAccuracy(coordBentoBox.mapRect.minX, minLat, accuracy: 0.001, "The bounding box's min x \(coordBentoBox.mapRect.minX) should equal the smallest x passed in \(minLat)")


        let maxLat = max(minCoord._x, maxCoord._x)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxPoint._x, maxLat, accuracy: 0.001, "The bounding box's max x \(coordBentoBox.maxPoint._x) should equal the largest x passed in \(maxLat)")

        let minLong = min(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBentoBox.minPoint._y, minLong, accuracy: 0.001, "The bounding box's min y \(coordBentoBox.minPoint._y) should equal the smallest y passed in \(minLong)")


        let maxLong = max(minCoord._y, maxCoord._y)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxPoint._y, maxLong, accuracy: 0.001, "The bounding box's max y \(coordBentoBox.minPoint._y) should equal the largest y passed in \(minLong)")
    }

    func testBentoBoxCoordinates() {
        let coordBentoBox = BentoBox<CGRect, CGPoint>(minPoint: CGPoint(x: 30, y: 60),
                                        maxPoint: CGPoint(x: 20, y: 40))

        let maxPoint = CGPoint(x: coordBentoBox.maxPoint._x, y: coordBentoBox.maxPoint._y)
        let minPoint = CGPoint(x: coordBentoBox.minPoint._x, y: coordBentoBox.minPoint._y)

        // the min or higher is inside the bounding box
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(x: 0.1, y: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(y: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint.offset(x: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minPoint))
        // slightly lower than the map is inside the mounding box
        XCTAssert(coordBentoBox.containsCoordinate(maxPoint.offset(x: -0.1, y: -0.1)))
        // the max or higher is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(x: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(x: 0.1, y: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(y: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxPoint.offset(x: 0.1)))
        // lower than the min is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(x: -0.1, y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minPoint.offset(x: -0.1)))


        // the middle point is inside the bounding box
        let midCoord = CGPoint(x: (maxPoint._x + minPoint._x) / 2.0,
                                  y: (maxPoint._y + minPoint._y) / 2.0)
        XCTAssert(coordBentoBox.containsCoordinate(midCoord))
    }

    func testBentoBoxIntersection() {
        let rect = CGRect(x: 0, y: 0, width: 500, height: 500)
        let intersectingRect =  CGRect(x: 250, y: 250, width: 500, height: 500)
        let nonIntersectingRect = CGRect(x: 500, y: 0, width: 500, height: 500)

        let bentoBox = BentoBox<CGRect, CGPoint>(mapRect: rect)
        let intersectingBox = BentoBox<CGRect, CGPoint>(mapRect: intersectingRect)
        let nonIntersectingBox = BentoBox<CGRect, CGPoint>(mapRect: nonIntersectingRect)

        XCTAssert(bentoBox.intersectsBentoBox(intersectingBox))
        XCTAssertFalse(bentoBox.intersectsBentoBox(nonIntersectingBox))
    }

    func testQuadrants() {
        let baseRect = CGRect(x: 0, y: 0, width: 500, height: 500)
        let nwRect = CGRect(x: 0, y: 0, width: 250, height: 250)
        let neRect = CGRect(x: 250, y: 0, width: 250, height: 250)
        let swRect = CGRect(x: 0, y: 250, width: 250, height: 250)
        let seRect = CGRect(x: 250, y: 250, width: 250, height: 250)

        let quadrants = BentoBox<CGRect, CGPoint>(mapRect: baseRect).quadrants

        XCTAssert(CGRectEqualToRect(quadrants.northWest.mapRect, nwRect))
        XCTAssert(CGRectEqualToRect(quadrants.northEast.mapRect, neRect))
        XCTAssert(CGRectEqualToRect(quadrants.southWest.mapRect, swRect))
        XCTAssert(CGRectEqualToRect(quadrants.southEast.mapRect, seRect))
    }

    func testCollectionTypeExtensions() {
        let points = [
            CGPoint(x: 25.0, y: 10956.7),
            CGPoint(x: 1894.5, y: 22897.5550),
            CGPoint(x: 25278.445, y: 156.339),
            CGPoint(x: 17603.8472, y: 2456.7),
        ]

        let mapPointBentoBox: BentoBox<CGRect, CGPoint> = points.bentoBox()

        let minPoint = mapPointBentoBox.minPoint
        let maxPoint = mapPointBentoBox.maxPoint

        XCTAssert(CGPointEqualToPoint(minPoint, CGPoint(x: 25.0, y: 156.339)))
        XCTAssert(CGPointEqualToPoint(maxPoint, CGPoint(x: 25278.445, y: 22897.5550)))

        let coords = [
            CGPoint(x: 34.6790, y: 28.2847),
            CGPoint(x: -34.6790, y: 88.1349),
            CGPoint(x: 61.9471, y: -14.1887),
            CGPoint(x: 1.2898, y: 42.4277),
        ]

        let coordinateBentoBox: BentoBox<CGRect, CGPoint> = coords.bentoBox()

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

private extension CGPoint {
    func offset(x xOffset: CGFloat = 0.0, y yOffset: CGFloat = 0.0) -> CGPoint {
        return CGPoint(x: x + xOffset, y: y + yOffset)
    }
}
