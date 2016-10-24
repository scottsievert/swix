//
//  twoD-initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// this module provides a convenience wrapper to create various vectors

public func zeros(_ shape: (Int, Int)) -> Matrix{ return Matrix(zeros:shape) }
public func zeros_like(_ x: Matrix) -> Matrix{ return Matrix(zerosLike:x) }
public func ones_like(_ x: Matrix) -> Matrix{ return Matrix(onesLike:x) }
public func ones(_ shape: (Int, Int)) -> Matrix{ return Matrix(ones:shape) }
public func eye(_ N: Int) -> Matrix{ return Matrix(eye:N) }
public func diag(_ x:Vector)->Matrix{ return Matrix(diag:x) }
public func randn(_ N: (Int, Int), mean: Double=0, sigma: Double=1) -> Matrix{ return Matrix(randn:N, mean:mean, sigma:sigma) }
public func rand(_ N: (Int, Int)) -> Matrix{ return Matrix(rand:N) }
public func reshape(_ x: Vector, shape:(Int, Int))->Matrix{ return x.reshape(shape) }
public func array(_ matlab_like_string: String)->Matrix{  return Matrix(matlab_like_string) }
