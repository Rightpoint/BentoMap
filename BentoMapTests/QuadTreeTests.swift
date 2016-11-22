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
        let box = BentoBox<MKMapRect, MKMapPoint>(root: MKMapRectWorld)
        let quadTree = QuadTree<Void, MKMapRect, MKMapPoint>(bentoBox: box, bucketCapacity: 5)

        XCTAssert(MKMapRectEqualToRect(box.root, quadTree.root.root), "The bounding box should equal the initalized bounding box")
        XCTAssert(quadTree.bucketCapacity == 5, "The bucket capacity passed in is the bucket capacity used")
        XCTAssertNil(quadTree.ordinalNodes, "The initalized nodes should be empty")
        XCTAssertTrue(quadTree.points.isEmpty, "The bucket of points should be empty")
    }

    fileprivate func resultRectTester(_ result: QuadTreeResult<Int, MKMapRect, MKMapPoint>) {
        let contentRect = result.contentRect
        switch result {
        case let .single(node: node):
            XCTAssert(MKMapPointEqualToPoint(contentRect.origin, node.originCoordinate), "Single nodes should have an origin equal to the node's point")
            XCTAssert(MKMapSizeEqualToSize(MKMapSize(), contentRect.size), "single nodes should have a zero-size content size")
        case let .multiple(nodes: nodes):
            for node in nodes {
                XCTAssert(MKMapRectContainsPoint(contentRect, node.originCoordinate), "Every node should be contained in the map content rect")
            }
        }
    }

    func testQuadTreeInsertion() {

        let bentoBox = BentoBox<MKMapRect, MKMapPoint>(root: MKMapRect(origin: MKMapPoint(), size: MKMapSize(width: 5000, height: 5000)))
        var quadTree = QuadTree<Int, MKMapRect, MKMapPoint>(bentoBox: bentoBox, bucketCapacity: 5)
        var i = 0
        for x in stride(from: 0, to: 5000, by: 50) {
            for y in stride(from: 0, to: 5000, by: 50) {
                let originCoordinate = MKMapPoint(x: Double(x), y: Double(y))
                let node = QuadTreeNode(originCoordinate: originCoordinate, content: i)
                quadTree.insertNode(node)
                i += 1
            }
        }

        let unclusteredNodes = quadTree.clusteredDataWithinMapRect(bentoBox.root, zoomScale: 1, cellSize: 50)
        for point in unclusteredNodes {
            XCTAssert(Int(point.originCoordinate.coordX) % 50 == 0, "all map point coords should be divisible by 50")
            XCTAssert(Int(point.originCoordinate.coordY) % 50 == 0, "all map point coords should be divisible by 50")
            resultRectTester(point)
        }
        XCTAssertTrue(unclusteredNodes.count == 10000, "This should return 10k clusters")
        let clusteredNodes = quadTree.clusteredDataWithinMapRect(bentoBox.root, zoomScale: 1, cellSize: 500)
        XCTAssertTrue(clusteredNodes.count == 100, "This should return 100 clusters")
        var totalNodeCount = 0
        for cluster in clusteredNodes {
            XCTAssert(Int(cluster.originCoordinate.coordX - 225) % 500 == 0, "all map point coords should be divisible by 500 after centering/ point was \(cluster.originCoordinate.coordX)")
            XCTAssert(Int(cluster.originCoordinate.coordY - 225) % 500 == 0, "all map point coords should be divisible by 500 after centering. point was \(cluster.originCoordinate.coordY)")
            resultRectTester(cluster)
            switch cluster {
            case .single:
                totalNodeCount += 1
            case let .multiple(nodes: nodes):
                XCTAssert(nodes.count == 100, "Each cluster contains 100 nodes")
                totalNodeCount += nodes.count
            }
        }
        XCTAssertTrue(totalNodeCount == 10000, "All nodes should add up to 10k nodes")

        XCTAssertFalse(quadTree.insertNode(QuadTreeNode(originCoordinate: MKMapPoint(x: Double(5002), y: Double(5002)), content: 1)))
        let unclusteredNodes2 = quadTree.clusteredDataWithinMapRect(bentoBox.root, zoomScale: 1, cellSize: 50)
        XCTAssertTrue(unclusteredNodes2.count == 10000, "This should return 10k clusters as an out of bounds cluster shouldn't insert")

        // making sure divide by zero avoidance works
        let testZero = quadTree.clusteredDataWithinMapRect(MKMapRectMake(0, 0, 5, 5), zoomScale: 0, cellSize: 0)
        XCTAssertTrue(testZero.count == 1, "This should return 100 clusters")
    }

    func testClustering() {
        let bentoBox = BentoBox<MKMapRect, MKMapPoint>(root: MKMapRect(origin: MKMapPoint(), size: MKMapSize(width: 11, height: 11)))
        var quadTree = QuadTree<Int, MKMapRect, MKMapPoint>(bentoBox: bentoBox, bucketCapacity: 5)
        var i = 0
        for x in 0...10 {
            for y in 0...10 {
                let originCoordinate = MKMapPoint(x: Double(x), y: Double(y))
                let node = QuadTreeNode(originCoordinate: originCoordinate, content: i)
                quadTree.insertNode(node)
                i += 1
            }
        }

        let rect = MKMapRect(origin: MKMapPoint(), size: MKMapSize(width: 9, height: 9))
        let unclusteredNodes = quadTree.clusteredDataWithinMapRect(rect, zoomScale: 1, cellSize: 10)
        XCTAssertEqual(unclusteredNodes.count, 4, "there should be four clusters in this data set")
        guard let cluster = unclusteredNodes.first else {
            XCTFail("First node should be non nil")
            return
        }
        let nodeCenter: MKMapPoint
        switch cluster {
        case .multiple(nodes: let nodes):
            XCTAssertEqual(nodes.count, 100, "there should be 100 nodes in the cluster")
            let reducedNodeCenter = nodes.reduce(MKMapPoint()) { total, current in
                return MKMapPoint(x: total.x + current.coordinate.x, y: total.y + current.coordinate.y)
            }
            nodeCenter = MKMapPoint(x: reducedNodeCenter.x / Double(nodes.count),
                                    y: reducedNodeCenter.y / Double(nodes.count))
        case .single(node: _):
            XCTFail("node should be a multiple node")
            return
        }
        XCTAssertEqualWithAccuracy(nodeCenter.x, 4.5, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(nodeCenter.y, 4.5, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(nodeCenter.x, cluster.originCoordinate.x, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(nodeCenter.x, cluster.originCoordinate.y, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(cluster.contentRect.minX, 0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(cluster.contentRect.minY, 0, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(cluster.contentRect.maxX, 9, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(cluster.contentRect.maxY, 9, accuracy: 0.001)
    }

}
