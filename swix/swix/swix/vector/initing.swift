//
//  initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

// SLOW PARTS: array(doubles), read_csv, write_csv. not a huge deal -- hopefully not used in final code
// this module provides a convenience wrapper to create various vectors

public func zeros(_ N: Int) -> Vector{ return Vector(zeros: N) }
public func zeros_like(_ x: Vector) -> Vector{ return Vector(zeros: x.n) }
public func ones_like(_ x: Vector) -> Vector{ return Vector(ones: x.n) }
public func ones(_ N: Int) -> Vector{ return Vector(ones: N) }
public func arange(_ max: Double, x exclusive:Bool = true) -> Vector{ return Vector(min:0, max:max, x:exclusive) }
public func arange(_ max: Int, x exclusive:Bool = true) -> Vector{ return Vector(arange:max, exclusive:exclusive) }
public func range(_ min:Double, max:Double, step:Double) -> Vector{ return Vector(min:0, max:max, step:step) }
public func arange(_ min: Double, max: Double, x exclusive: Bool = true) -> Vector{ return Vector(min:0, max:max, x:exclusive) }
public func linspace(_ min: Double, max: Double, num: Int=50) -> Vector{ return Vector(min:0, max:max, num:num) }
public func array(_ numbers: Double...) -> Vector{ return Vector(asarray:numbers) }
public func asarray(_ x: [Double]) -> Vector{ return Vector(asarray:x) }
public func asarray(_ seq: Range<Int>) -> Vector { return Vector(asarray:seq) }
public func copy(_ x: Vector) -> Vector{ return x.copy() }
public func seed(_ n:Int){ Vector.seed(n) }
public func rand(_ N: Int, distro:String="uniform") -> Vector{ return Vector(rand:N, distro:distro) }
public func randn(_ N: Int, mean: Double=0, sigma: Double=1) -> Vector{ return Vector(randn:N, mean:mean, sigma:sigma) }
public func randperm(_ N:Int)->Vector{ return Vector(randperm:N) }
