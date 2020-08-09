//
//  twoD-initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate


func zeros(_ shape: (Int, Int)) -> matrix{
    return matrix(columns: shape.1, rows: shape.0)
}
func zeros_like(_ x: matrix) -> matrix{
    let y:matrix = zeros((x.shape.0, x.shape.1))
    return y
}
func ones_like(_ x: matrix) -> matrix{
    return zeros_like(x) + 1
}
func ones(_ shape: (Int, Int)) -> matrix{
    return zeros(shape)+1
}
func eye(_ N: Int) -> matrix{
    return diag(ones(N))
}
func diag(_ x:vector)->matrix{
    var y = zeros((x.n, x.n))
    y["diag"] = x
    return y
}
func randn(_ N: (Int, Int), mean: Double=0, sigma: Double=1) -> matrix{
    var x = zeros(N)
    let y = randn(N.0 * N.1, mean:mean, sigma:sigma)
    x.flat = y
    return x
}
func rand(_ N: (Int, Int)) -> matrix{
    var x = zeros(N)
    let y = rand(N.0 * N.1)
    x.flat = y
    return x
}
func reshape(_ x: vector, shape:(Int, Int))->matrix{
    return x.reshape(shape)
}
func meshgrid(_ x: vector, y:vector) -> (matrix, matrix){
    assert(x.n > 0 && y.n > 0, "If these matrices are empty meshgrid fails")
    let z1 = reshape(`repeat`(y, N: x.n), shape: (x.n, y.n))
    let z2 = reshape(`repeat`(x, N: y.n, axis: 1), shape: (x.n, y.n))
    return (z2, z1)
}


/// array("1 2 3; 4 5 6; 7 8 9") works like matlab. note that string format has to be followed to the dot. String parsing has bugs; I'd use arange(9).reshape((3,3)) or something similar
func array(_ matlab_like_string: String)->matrix{
    let mls = matlab_like_string
    var rows = mls.components(separatedBy: ";")
    let r = rows.count
    var c = 0
    for char in rows[0].characters{
        if char == " " {}
        else {c += 1}
    }
    var x = zeros((r, c))
    var start:Int
    var i:Int=0, j:Int=0
    for row in rows{
        var nums = row.components(separatedBy: CharacterSet.whitespaces)
        if nums[0] == ""{start=1}
        else {start=0}
        j = 0
        for n in start..<nums.count{
            x[i, j] = nums[n].floatValue.double
            j += 1
        }
        i += 1
    }
    return x
}































