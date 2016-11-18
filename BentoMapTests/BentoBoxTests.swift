//
// BentoMapTests.swift
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

        let root = MKMapRectWorld

        let rootNodeBentoBox = BentoBox<MKMapRect, MKMapPoint>(root: root)

        XCTAssert(MKMapRectEqualToRect(root, rootNodeBentoBox.root), "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CLLocationCoordinate2D(latitude: 30, longitude: 60)
        let minCoord = CLLocationCoordinate2D(latitude: 20, longitude: 40)

        let coordBentoBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: minCoord, maxPoint: maxCoord)

        let minLat = CGFloat(min(minCoord.coordX, maxCoord.coordX))
        XCTAssertEqualWithAccuracy(coordBentoBox.root.minX, minLat, accuracy: 0.001, "The bounding box's min latitude \(coordBentoBox.root.minX) should equal the smallest latitude passed in \(minLat)")

        let maxLat = max(minCoord.coordX, maxCoord.coordX)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxCoordinate.coordX, maxLat, accuracy: 0.001, "The bounding box's max latitude \(coordBentoBox.maxCoordinate.coordX) should equal the largest latitude passed in \(maxLat)")

        let minLong = min(minCoord.coordY, maxCoord.coordY)
        XCTAssertEqualWithAccuracy(coordBentoBox.minCoordinate.coordY, minLong, accuracy: 0.001, "The bounding box's min longitude \(coordBentoBox.minCoordinate.coordY) should equal the smallest longitude passed in \(minLong)")

        let maxLong = max(minCoord.coordY, maxCoord.coordY)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxCoordinate.coordY, maxLong, accuracy: 0.001, "The bounding box's max longitude \(coordBentoBox.minCoordinate.coordY) should equal the largest longitude passed in \(minLong)")
    }

    func testBentoBoxCoordinates() {
        let coordBentoBox = BentoBox<MKMapRect, CLLocationCoordinate2D>(minPoint: CLLocationCoordinate2D(latitude: 30, longitude: 60),
                                                                        maxPoint: CLLocationCoordinate2D(latitude: 20, longitude: 40))

        let maxCoordinate = MKMapPoint(x: Double(coordBentoBox.maxCoordinate.coordX), y: Double(coordBentoBox.maxCoordinate.coordY))
        let minCoordinate = MKMapPoint(x: Double(coordBentoBox.minCoordinate.coordX), y: Double(coordBentoBox.minCoordinate.coordY))

        // the min or higher is inside the bounding box
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(longitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(latitude: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate))
        // slightly lower than the map is inside the mounding box
        XCTAssert(coordBentoBox.containsCoordinate(maxCoordinate.offset(latitude: -0.1, longitude: -0.1)))
        // the max or higher is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(latitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(latitude: 0.1, longitude: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(longitude: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(latitude: 0.1)))
        // lower than the min is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(latitude: -0.1, longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(longitude: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(latitude: -0.1)))

        // the middle point is inside the bounding box
        let midCoord = MKMapPoint(x: Double(maxCoordinate.coordX  + minCoordinate.coordX) / 2.0,
                                  y: Double(maxCoordinate.coordY + minCoordinate.coordY) / 2.0)
        XCTAssert(coordBentoBox.containsCoordinate(midCoord))
    }

    func testBentoBoxIntersection() {
        let rect = MKMapRectMake(0, 0, 500, 500)
        let intersectingRect =  MKMapRectMake(250, 250, 500, 500)
        let nonIntersectingRect = MKMapRectMake(500, 0, 500, 500)

        let bentoBox = BentoBox<MKMapRect, MKMapPoint>(root: rect)
        let intersectingBox = BentoBox<MKMapRect, MKMapPoint>(root: intersectingRect)
        let nonIntersectingBox = BentoBox<MKMapRect, MKMapPoint>(root: nonIntersectingRect)

        XCTAssert(bentoBox.intersectsBentoBox(intersectingBox))
        XCTAssertFalse(bentoBox.intersectsBentoBox(nonIntersectingBox))
    }

    func testQuadrants() {
        let baseRect = MKMapRectMake(0, 0, 500, 500)
        let nwRect = MKMapRectMake(0, 0, 250, 250)
        let neRect = MKMapRectMake(250, 0, 250, 250)
        let swRect = MKMapRectMake(0, 250, 250, 250)
        let seRect = MKMapRectMake(250, 250, 250, 250)

        let quadrants = BentoBox<MKMapRect, MKMapPoint>(root: baseRect).quadrants

        XCTAssert(MKMapRectEqualToRect(quadrants.northWest.root, nwRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.northEast.root, neRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southWest.root, swRect))
        XCTAssert(MKMapRectEqualToRect(quadrants.southEast.root, seRect))
    }

    func testCollectionTypeExtensions() {
        let points = [
            MKMapPoint(x: 25.0, y: 10956.7),
            MKMapPoint(x: 1894.5, y: 22897.5550),
            MKMapPoint(x: 25278.445, y: 156.339),
            MKMapPoint(x: 17603.8472, y: 2456.7),
        ]

        let mapPointBentoBox: BentoBox<MKMapRect, MKMapPoint> = points.bentoBox()

        let minCoordinate = mapPointBentoBox.minCoordinate
        let maxCoordinate = mapPointBentoBox.maxCoordinate

        XCTAssert(MKMapPointEqualToPoint(minCoordinate, MKMapPoint(x: 25.0, y: 156.339)))
        XCTAssert(MKMapPointEqualToPoint(maxCoordinate, MKMapPoint(x: 25278.445, y: 22897.5550)))

        let coords = [
            CLLocationCoordinate2D(latitude: 34.6790, longitude: 28.2847),
            CLLocationCoordinate2D(latitude: -34.6790, longitude: 88.1349),
            CLLocationCoordinate2D(latitude: 61.9471, longitude: -14.1887),
            CLLocationCoordinate2D(latitude: 1.2898, longitude: 42.4277),
        ]

        let coordinateBentoBox: BentoBox<MKMapRect, CLLocationCoordinate2D> = coords.bentoBox()

        XCTAssertEqualWithAccuracy(coordinateBentoBox.minCoordinate.coordX, -34.6790, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.minCoordinate.coordY, -14.1887, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxCoordinate.coordX, 61.9471, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxCoordinate.coordY, 88.1349, accuracy: 1e-4)
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
        let root = CGRect(origin: origin, size: gridSize)

        let rootNodeBentoBox = BentoBox<CGRect, CGPoint>(root: root)

        XCTAssertEqual(root, rootNodeBentoBox.root, "The bounding box's map rect should be equal to the input map rect")

        let maxCoord = CGPoint(x: 30.0, y: 60.0)
        let minCoord = CGPoint(x: 20.0, y: 40.0)

        let coordBentoBox = BentoBox<CGRect, CGPoint>(minPoint: minCoord, maxPoint: maxCoord)

        let minLat = CGFloat(min(minCoord.coordX, maxCoord.coordX))
        XCTAssertEqualWithAccuracy(coordBentoBox.root.minX, minLat, accuracy: 0.001, "The bounding box's min x \(coordBentoBox.root.minX) should equal the smallest x passed in \(minLat)")

        let maxLat = max(minCoord.coordX, maxCoord.coordX)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxCoordinate.coordX, maxLat, accuracy: 0.001, "The bounding box's max x \(coordBentoBox.maxCoordinate.coordX) should equal the largest x passed in \(maxLat)")

        let minLong = min(minCoord.coordY, maxCoord.coordY)
        XCTAssertEqualWithAccuracy(coordBentoBox.minCoordinate.coordY, minLong, accuracy: 0.001, "The bounding box's min y \(coordBentoBox.minCoordinate.coordY) should equal the smallest y passed in \(minLong)")

        let maxLong = max(minCoord.coordY, maxCoord.coordY)
        XCTAssertEqualWithAccuracy(coordBentoBox.maxCoordinate.coordY, maxLong, accuracy: 0.001, "The bounding box's max y \(coordBentoBox.minCoordinate.coordY) should equal the largest y passed in \(minLong)")
    }

    func testBentoBoxCoordinates() {
        let coordBentoBox = BentoBox<CGRect, CGPoint>(minPoint: CGPoint(x: 30, y: 60),
                                                      maxPoint: CGPoint(x: 20, y: 40))

        let maxCoordinate = CGPoint(x: coordBentoBox.maxCoordinate.coordX, y: coordBentoBox.maxCoordinate.coordY)
        let minCoordinate = CGPoint(x: coordBentoBox.minCoordinate.coordX, y: coordBentoBox.minCoordinate.coordY)

        // the min or higher is inside the bounding box
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(x: 0.1, y: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(y: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate.offset(x: 0.1)))
        XCTAssert(coordBentoBox.containsCoordinate(minCoordinate))
        // slightly lower than the map is inside the mounding box
        XCTAssert(coordBentoBox.containsCoordinate(maxCoordinate.offset(x: -0.1, y: -0.1)))
        // the max or higher is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(x: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(x: 0.1, y: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(y: 0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(maxCoordinate.offset(x: 0.1)))
        // lower than the min is outside the bounding box
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(x: -0.1, y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(y: -0.1)))
        XCTAssertFalse(coordBentoBox.containsCoordinate(minCoordinate.offset(x: -0.1)))

        // the middle point is inside the bounding box
        let midCoord = CGPoint(x: (maxCoordinate.coordX + minCoordinate.coordX) / 2.0,
                                  y: (maxCoordinate.coordY + minCoordinate.coordY) / 2.0)
        XCTAssert(coordBentoBox.containsCoordinate(midCoord))
    }

    func testBentoBoxIntersection() {
        let rect = CGRect(x: 0, y: 0, width: 500, height: 500)
        let intersectingRect =  CGRect(x: 250, y: 250, width: 500, height: 500)
        let nonIntersectingRect = CGRect(x: 500, y: 0, width: 500, height: 500)

        let bentoBox = BentoBox<CGRect, CGPoint>(root: rect)
        let intersectingBox = BentoBox<CGRect, CGPoint>(root: intersectingRect)
        let nonIntersectingBox = BentoBox<CGRect, CGPoint>(root: nonIntersectingRect)

        XCTAssert(bentoBox.intersectsBentoBox(intersectingBox))
        XCTAssertFalse(bentoBox.intersectsBentoBox(nonIntersectingBox))
    }

    func testQuadrants() {
        let baseRect = CGRect(x: 0, y: 0, width: 500, height: 500)
        let nwRect = CGRect(x: 0, y: 0, width: 250, height: 250)
        let neRect = CGRect(x: 250, y: 0, width: 250, height: 250)
        let swRect = CGRect(x: 0, y: 250, width: 250, height: 250)
        let seRect = CGRect(x: 250, y: 250, width: 250, height: 250)

        let quadrants = BentoBox<CGRect, CGPoint>(root: baseRect).quadrants

        XCTAssert(quadrants.northWest.root.equalTo(nwRect))
        XCTAssert(quadrants.northEast.root.equalTo(neRect))
        XCTAssert(quadrants.southWest.root.equalTo(swRect))
        XCTAssert(quadrants.southEast.root.equalTo(seRect))
    }

    func testCollectionTypeExtensions() {
        let points = [
            CGPoint(x: 25.0, y: 10956.7),
            CGPoint(x: 1894.5, y: 22897.5550),
            CGPoint(x: 25278.445, y: 156.339),
            CGPoint(x: 17603.8472, y: 2456.7),
        ]

        let mapPointBentoBox: BentoBox<CGRect, CGPoint> = points.bentoBox()

        let minCoordinate = mapPointBentoBox.minCoordinate
        let maxCoordinate = mapPointBentoBox.maxCoordinate

        XCTAssert(minCoordinate.equalTo(CGPoint(x: 25.0, y: 156.339)))
        XCTAssert(maxCoordinate.equalTo(CGPoint(x: 25278.445, y: 22897.5550)))

        let coords = [
            CGPoint(x: 34.6790, y: 28.2847),
            CGPoint(x: -34.6790, y: 88.1349),
            CGPoint(x: 61.9471, y: -14.1887),
            CGPoint(x: 1.2898, y: 42.4277),
        ]

        let coordinateBentoBox: BentoBox<CGRect, CGPoint> = coords.bentoBox()

        XCTAssertEqualWithAccuracy(coordinateBentoBox.minCoordinate.coordX, -34.6790, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.minCoordinate.coordY, -14.1887, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxCoordinate.coordX, 61.9471, accuracy: 1e-4)
        XCTAssertEqualWithAccuracy(coordinateBentoBox.maxCoordinate.coordY, 88.1349, accuracy: 1e-4)
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
