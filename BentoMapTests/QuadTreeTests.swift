//
//  QuadTreeTests.swift
//  BentoMapTests
//
//  Created by Michael Skiba on 7/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import MapKit
@testable import BentoMap

class QuadTreeTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testQuadTreeInitialization() {
        let box = BentoMap<MKMapRect, MKMapPoint>(rootNode: MKMapRectWorld)
        let quadTree = QuadTree<Void, MKMapRect, MKMapPoint>(bentoMap: box, bucketCapacity: 5)

        XCTAssert(MKMapRectEqualToRect(box.rootNode, quadTree.bentoMap.rootNode), "The bounding box should equal the initalized bounding box")
        XCTAssert(quadTree.bucketCapacity == 5, "The bucket capacity passed in is the bucket capacity used")
        XCTAssertNil(quadTree.ordinalNodes, "The initalized nodes should be empty")
        XCTAssertTrue(quadTree.points.isEmpty, "The bucket of points should be empty")
    }

    private func resultRectTester(result: QuadTreeResult<Int, MKMapRect, MKMapPoint>) {
        let contentRect = result.contentRect
        switch result {
        case let .Single(node: node):
            XCTAssert(MKMapPointEqualToPoint(contentRect.origin, node.mapPoint), "Single nodes should have an origin equal to the node's point")
            XCTAssert(MKMapSizeEqualToSize(MKMapSize(), contentRect.size), "single nodes should have a zero-size content size")
        case let .Multiple(nodes: nodes):
            for node in nodes {
                XCTAssert(MKMapRectContainsPoint(contentRect, node.mapPoint), "Every node should be contained in the map content rect")
            }
        }
    }

    func testQuadTreeInsertion() {

        let bentoMap = BentoMap<MKMapRect, MKMapPoint>(rootNode: MKMapRect(origin: MKMapPoint(), size: MKMapSize(width: 5000, height: 5000)))
        var quadTree = QuadTree<Int, MKMapRect, MKMapPoint>(bentoMap: bentoMap, bucketCapacity: 5)
        var i = 0
        for x in 0.stride(to: 5000, by: 50) {
            for y in 0.stride(to: 5000, by: 50) {
                let mapPoint = MKMapPoint(x: Double(x), y: Double(y))
                let node = QuadTreeNode(mapPoint: mapPoint, content: i)
                quadTree.insertNode(node)
                i += 1
            }
        }

        let unclusteredNodes = quadTree.clusteredDataWithinMapRect(bentoMap.rootNode, zoomScale: 1, cellSize: 50)
        for point in unclusteredNodes {
            XCTAssert(Int(point.mapPoint.x) % 50 == 0, "all map point coords should be divisible by 50")
            XCTAssert(Int(point.mapPoint.y) % 50 == 0, "all map point coords should be divisible by 50")
            resultRectTester(point)
        }
        XCTAssertTrue(unclusteredNodes.count == 10000, "This should return 10k clusters")
        let clusteredNodes = quadTree.clusteredDataWithinMapRect(bentoMap.rootNode, zoomScale: 1, cellSize: 500)
        XCTAssertTrue(clusteredNodes.count == 100, "This should return 100 clusters")
        var totalNodeCount = 0
        for cluster in clusteredNodes {
            XCTAssert(Int(cluster.mapPoint.x - 225) % 500 == 0, "all map point coords should be divisible by 500 after centering/ point was \(cluster.mapPoint.x)")
            XCTAssert(Int(cluster.mapPoint.y - 225) % 500 == 0, "all map point coords should be divisible by 500 after centering. point was \(cluster.mapPoint.y)")
            resultRectTester(cluster)
            switch cluster {
            case .Single:
                totalNodeCount += 1
            case let .Multiple(nodes: nodes):
                XCTAssert(nodes.count == 100, "Each cluster contains 100 nodes")
                totalNodeCount += nodes.count
            }
        }
        XCTAssertTrue(totalNodeCount == 10000, "All nodes should add up to 10k nodes")

        XCTAssertFalse(quadTree.insertNode(QuadTreeNode(mapPoint: MKMapPoint(x: Double(5002), y: Double(5002)), content: 1)))
        let unclusteredNodes2 = quadTree.clusteredDataWithinMapRect(bentoMap.rootNode, zoomScale: 1, cellSize: 50)
        XCTAssertTrue(unclusteredNodes2.count == 10000, "This should return 10k clusters as an out of bounds cluster shouldn't insert")

        // making sure divide by zero avoidance works
        let testZero = quadTree.clusteredDataWithinMapRect(MKMapRectMake(0, 0, 5, 5), zoomScale: 0, cellSize: 0)
        XCTAssertTrue(testZero.count == 1, "This should return 100 clusters")
    }


}
