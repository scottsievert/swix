//
//  conversion.swift
//  swix
//
//  Created by Scott Sievert on 7/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

prefix func ! (x: Vector) -> UnsafeMutablePointer<Double> {
    return x.unsafeMutablePointer()
}
prefix func ! (x: Matrix) -> UnsafeMutablePointer<Double> {
    return x.flat.unsafeMutablePointer()
}

