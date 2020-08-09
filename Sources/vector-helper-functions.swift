//
//  helper-public functions.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// NORM
public func norm(_ x: Vector, ord:Double=2) -> Double{
    // takes the norm of an array
    if ord==2      { return sqrt(sum(pow(x, power: 2)))}
    else if ord==1 { return sum(abs(x))}
    else if ord==0 { return sum(abs(x) > S2_THRESHOLD)}
    else if ord == -1 || ord == -2{
        return pow(sum(abs(x)^ord.double), 1/ord.double)
    }
    else if ord.double ==  inf {return max(abs(x))}
    else if ord.double == -inf {return min(abs(x))}
    assert(false, "type of norm unrecongnized")
    return -1.0}
public func count_nonzero(_ x:Vector)->Double{
    return sum(abs(x) > S2_THRESHOLD)
}

// modifying elements of the array
public func clip(_ a:Vector, a_min:Double, a_max:Double)->Vector{
    // clip the matrix
    var y = a.copy()
    y[argwhere(a < a_min)] <- a_min
    y[argwhere(a > a_max)] <- a_max
    return y
}
public func reverse(_ x:Vector) -> Vector{
    // reverse the array
    let y = x.copy()
    vDSP_vrvrsD(!y, 1.stride, y.n.length)
    return y
}
public func delete(_ x:Vector, idx:Vector) -> Vector{
    // delete select elements
    var i = ones(x.n)
    i[idx] *= 0
    let y = x[argwhere(i)]
    return y
}
/* public func `repeat`(_ x: Vector, N:Int, axis:Int=0) -> Vector{ */
    /* // repeat the array element wise or as a whole array */
    /* var y = zeros((N, x.n)) */
    
    /* // wrapping using OpenCV */
    /* CVWrapper.`repeat`(!x, to:!y, n_x:x.n.cint, n_repeat:N.cint) */
    
    /* if axis==0{} */
    /* else if axis==1 { y = y.T} */
    /* return y.flat */
/* } */

// SORTING and the like
public func sort(_ x:Vector)->Vector{
    // sort the array and return a new array
    let y = x.copy()
    y.sort()
    return y
}
public func unique(_ x:Vector)->Vector{
    var y = sort(x)
    var z = concat(zeros(1), y: y)
    let diff = abs(z[1..<z.n] - z[0..<z.n-1]) > S2_THRESHOLD
    let un = y[argwhere(diff)]
    if abs(min(x)) < S2_THRESHOLD{
        return sort(concat(zeros(1), y: un))
    }
    else{
        return un
    }
}
/* public func shuffle(_ x:Vector)->Vector{ */
    /* // randomly shuffle the array */
    /* let y = x.copy() */
    /* CVWrapper.shuffle(!y, n:y.n.cint) */
    /* return y */
/* } */

// SETS
/* public func intersection(_ x: Vector, y:Vector)->Vector{ */
    /* return unique(x[argwhere(in1d(x, y: y))]) */
/* } */
public func union(_ x:Vector, y:Vector)->Vector{
    return unique(concat(x, y: y))
}
/* public func in1d(_ x: Vector, y:Vector)->Vector{ */
    /* if (x.n > 0 && y.n > 0){ */
        /* let (xx, yy) = meshgrid(x, y: y) */
        /* let i = abs(xx-yy) < S2_THRESHOLD */
        /* let j = (sum(i, axis:1)) > 0.5 */
        /* return 0+j */
    /* } */
    /* return array() */
/* } */
public func concat(_ x:Vector, y:Vector)->Vector{
    // concatenate two matrices
    var z = zeros(x.n + y.n)
    z[0..<x.n] = x
    z[x.n..<y.n+x.n] = y
    return z
}

// ARG
/* public func argmax(_ x:Vector)->Int{ */
    /* // find the location of the max */
    /* var m:CInt = 0 */
    /* CVWrapper.argmax(!x, n: x.n.cint, max: &m) */
    /* return Int(m) */
/* } */
/* public func argmin(_ x:Vector)->Int{ */
    /* // find the location of the min */
    /* var m:CInt = 0 */
    /* CVWrapper.argmin(!x, n: x.n.cint, min: &m) */
    /* return Int(m) */
/* } */
/* public func argsort(_ x:Vector)->Vector{ */
    /* // sort the array but use integers */
    
    /* // the array of integers that OpenCV needs */
    /* var y:[CInt] = Array(repeating: 0, count: x.n) */
    /* // calling opencv's sortidx */
    /* CVWrapper.argsort(!x, n: x.n.cint, into:&y) */
    /* // the integer-->double conversion */
    /* let z = zeros_like(x) */
    /* vDSP_vflt32D(&y, 1.stride, !z, 1.stride, x.n.length) */
    /* return z */
/* } */
public func argwhere(_ idx: Vector) -> Vector{
    // counts non-zero elements, return array of doubles (which can be indexed!).
    let i = arange(idx.n)
    let args = zeros(sum(idx).int)
    vDSP_vcmprsD(!i, 1.stride, !idx, 1.stride, !args, 1.stride, idx.n.length)
    return args
}


// LOGICAL
public func logical_and(_ x:Vector, y:Vector)->Vector{
    return x * y
}
public func logical_or(_ x:Vector, y:Vector)->Vector{
    var i = x + y
    let j = argwhere(i > 0.5)
    i[j] <- 1.0
    return i
}
public func logical_not(_ x:Vector)->Vector{
    return 1-x
}
public func logical_xor(_ x:Vector, y:Vector)->Vector{
    let i = x + y
    let j = (i < 1.5) && (i > 0.5)
    return j
}

// PRINTING
public func println(_ x: Vector, prefix:String="array([", postfix:String="])", newline:String="\n", format:String="%.3f", seperator:String=", ", printAllElements:Bool=false){
    // print the matrix
    print(prefix, terminator: "")
    var suffix = seperator
    var printed = false
    var string:NSString
    for i in 0..<x.n{
        if i==x.n-1 { suffix = "" }
        if printAllElements || (x.n)<16 || i<3 || i>(x.n-4){
            string = NSString(format: (format+suffix) as NSString, x[i])
            print(String(string), terminator:"")
        }
        else if printed == false{
            printed = true
            print("..., ", terminator: "")
        }
    }
    print(postfix, terminator: "")
    print(newline, terminator: "")
}
public func print(_ x: Vector, prefix:String="Vector([", postfix:String="])", format:String="%.3f", printWholeMatrix:Bool=false){
    println(x, prefix:prefix, postfix:postfix, newline:"\n", format:format, printAllElements:printWholeMatrix)
}



