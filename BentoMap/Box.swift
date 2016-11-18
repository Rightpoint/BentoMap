//
//  Box.swift
// BentoMap
//
//  Created by Michael Skiba on 2/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// A workaround because Swift structs do not
/// allow recursive value types
class Box<T> {

    var value: T

    init(value: T) {
        self.value = value
    }

}
