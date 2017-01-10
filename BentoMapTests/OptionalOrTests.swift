//
//  OptionalOrTests.swift
// BentoMap
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BentoMap

class OptionalOrTests: XCTestCase {
    func testOptionalOr() {
        let truePairs: [(Bool?, Bool?)] = [
            (true, true),
            (true, false),
            (false, true),
            (true, nil),
            (nil, true),
        ]
        for (lhs, rhs) in truePairs {
            XCTAssert(lhs ||? rhs, "Should be true")
            if let unwrappedLeft = lhs {
                XCTAssert(unwrappedLeft ||? rhs, "Should be true")
            }
            if let unwrappedRight = rhs {
                XCTAssert(lhs ||? unwrappedRight, "Should be true")
            }
            if let unwrappedLeft = lhs, let unwrappedRight = rhs {
                XCTAssert(unwrappedLeft ||? unwrappedRight, "Should be true")
            }
        }

        let falsePairs: [(Bool?, Bool?)] = [
            (false, false),
            (nil, false),
            (false, nil),
            (nil, nil),
        ]
        for (lhs, rhs) in falsePairs {
            XCTAssertFalse(lhs ||? rhs, "Should be false")
            if let unwrappedLeft = lhs {
                XCTAssertFalse(unwrappedLeft ||? rhs, "Should be false")
            }
            if let unwrappedRight = rhs {
                XCTAssertFalse(lhs ||? unwrappedRight, "Should be false")
            }
            if let unwrappedLeft = lhs, let unwrappedRight = rhs {
                XCTAssertFalse(unwrappedLeft ||? unwrappedRight, "Should be false")
            }
        }
    }
}
