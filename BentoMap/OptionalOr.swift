//
//  OptionalOr.swift
// BentoMap
//
//  Created by Michael Skiba on 7/7/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

infix operator ||?: LogicalDisjunctionPrecedence

func ||? (lhs: Optional<Bool>, rhs: Optional<Bool>) -> Bool {
    return (lhs ?? false) || (rhs ?? false)
}

func ||? (lhs: Bool, rhs: Optional<Bool>) -> Bool {
    return lhs || (rhs ?? false)
}

func ||? (lhs: Optional<Bool>, rhs: Bool) -> Bool {
    return (lhs ?? false) || rhs
}

func ||? (lhs: Bool, rhs: Bool) -> Bool {
    return lhs || rhs
}
