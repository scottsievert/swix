//
//  oneD_math.swift
//  swix
//
//  Created by Scott Sievert on 6/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Accelerate

public func apply_function(_ function: (Double)->Double, x: Vector) -> Vector{ return x.apply_function(function) }

// MIN/MAX
public func min(_ x: Vector) -> Double{ return x.min() }
public func max(_ x: Vector) -> Double{ return x.max() }

// BASIC STATS
public func mean(_ x: Vector) -> Double{ return x.mean() }
public func std(_ x: Vector) -> Double{ return x.std() }
public func variance(_ x: Vector) -> Double{ return x.variance() }

// BASIC INFO
public func sign(_ x: Vector)->Vector{ return x.sign() }
public func sum(_ x: Vector) -> Double{ return x.sum() }
public func remainder(_ x1:Vector, x2:Vector)->Vector{ return x1.remainder(x2) }
public func cumsum(_ x: Vector) -> Vector{ return x.cumsum() }
public func abs(_ x: Vector) -> Vector{ return x.abs() }
public func prod(_ x:Vector)->Double{ return x.prod() }
public func cumprod(_ x:Vector)->Vector{ return x.cumprod() }

// POWER FUNCTIONS
public func pow(_ x:Vector, power:Double)->Vector{ return x.pow(power) }
public func pow(_ x:Vector, y:Vector)->Vector{ return x.pow(y) }
public func pow(_ x:Double, y:Vector)->Vector{ return x.pow(y) }
public func sqrt(_ x: Vector) -> Vector{ return x.sqrt() }
public func exp(_ x:Vector)->Vector{ return x.exp() }
public func exp2(_ x:Vector)->Vector{ return x.exp2() }
public func expm1(_ x:Vector)->Vector{ return x.expm1() }

// ROUND
public func round(_ x:Vector)->Vector{ return x.round() }
public func round(_ x:Vector, decimals:Double)->Vector{ return x.round(decimals) }
public func floor(_ x: Vector) -> Vector{ return x.floor() }
public func ceil(_ x: Vector) -> Vector{ return x.ceil() }

// LOG
public func log10(_ x:Vector)->Vector{ return x.log10() }
public func log2(_ x:Vector)->Vector{ return x.log2() }
public func log(_ x:Vector)->Vector{ return x.log() }

// TRIG
public func sin(_ x: Vector) -> Vector{ return x.sin() }
public func cos(_ x: Vector) -> Vector{ return x.cos() }
public func tan(_ x: Vector) -> Vector{ return x.tan() }
public func tanh(_ x: Vector) -> Vector { return x.tanh() }
