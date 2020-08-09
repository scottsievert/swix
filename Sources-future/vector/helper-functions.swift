//
//  helper-functions.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

// NORM
func norm(_ x: vector, ord:Double=2) -> Double{
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
func count_nonzero(_ x:vector)->Double{
    return sum(abs(x) > S2_THRESHOLD)
}

// modifying elements of the array
func clip(_ a:vector, a_min:Double, a_max:Double)->vector{
    // clip the matrix
    var y = a.copy()
    y[argwhere(a < a_min)] <- a_min
    y[argwhere(a > a_max)] <- a_max
    return y
}
func reverse(_ x:vector) -> vector{
    // reverse the array
    let y = x.copy()
    vDSP_vrvrsD(!y, 1.stride, y.n.length)
    return y
}
func delete(_ x:vector, idx:vector) -> vector{
    // delete select elements
    var i = ones(x.n)
    i[idx] *= 0
    let y = x[argwhere(i)]
    return y
}
func `repeat`(_ x: vector, N:Int, axis:Int=0) -> vector{
    // repeat the array element wise or as a whole array
    var y = zeros((N, x.n))
    
    // wrapping using OpenCV
    CVWrapper.`repeat`(!x, to:!y, n_x:x.n.cint, n_repeat:N.cint)
    
    if axis==0{}
    else if axis==1 { y = y.T}
    return y.flat
}

// SORTING and the like
func sort(_ x:vector)->vector{
    // sort the array and return a new array
    let y = x.copy()
    y.sort()
    return y
}
func unique(_ x:vector)->vector{
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
func shuffle(_ x:vector)->vector{
    // randomly shuffle the array
    let y = x.copy()
    CVWrapper.shuffle(!y, n:y.n.cint)
    return y
}

// SETS
func intersection(_ x: vector, y:vector)->vector{
    return unique(x[argwhere(in1d(x, y: y))])
}
func union(_ x:vector, y:vector)->vector{
    return unique(concat(x, y: y))
}
func in1d(_ x: vector, y:vector)->vector{
    if (x.n > 0 && y.n > 0){
        let (xx, yy) = meshgrid(x, y: y)
        let i = abs(xx-yy) < S2_THRESHOLD
        let j = (sum(i, axis:1)) > 0.5
        return 0+j
    }
    return array()
}
func concat(_ x:vector, y:vector)->vector{
    // concatenate two matrices
    var z = zeros(x.n + y.n)
    z[0..<x.n] = x
    z[x.n..<y.n+x.n] = y
    return z
}

// ARG
func argmax(_ x:vector)->Int{
    // find the location of the max
    var m:CInt = 0
    CVWrapper.argmax(!x, n: x.n.cint, max: &m)
    return Int(m)
}
func argmin(_ x:vector)->Int{
    // find the location of the min
    var m:CInt = 0
    CVWrapper.argmin(!x, n: x.n.cint, min: &m)
    return Int(m)
}
func argsort(_ x:vector)->vector{
    // sort the array but use integers
    
    // the array of integers that OpenCV needs
    var y:[CInt] = Array(repeating: 0, count: x.n)
    // calling opencv's sortidx
    CVWrapper.argsort(!x, n: x.n.cint, into:&y)
    // the integer-->double conversion
    let z = zeros_like(x)
    vDSP_vflt32D(&y, 1.stride, !z, 1.stride, x.n.length)
    return z
}
func argwhere(_ idx: vector) -> vector{
    // counts non-zero elements, return array of doubles (which can be indexed!).
    let i = arange(idx.n)
    let args = zeros(sum(idx).int)
    vDSP_vcmprsD(!i, 1.stride, !idx, 1.stride, !args, 1.stride, idx.n.length)
    return args
}


// LOGICAL
func logical_and(_ x:vector, y:vector)->vector{
    return x * y
}
func logical_or(_ x:vector, y:vector)->vector{
    var i = x + y
    let j = argwhere(i > 0.5)
    i[j] <- 1.0
    return i
}
func logical_not(_ x:vector)->vector{
    return 1-x
}
func logical_xor(_ x:vector, y:vector)->vector{
    let i = x + y
    let j = (i < 1.5) && (i > 0.5)
    return j
}

// PRINTING
func println(_ x: vector, prefix:String="array([", postfix:String="])", newline:String="\n", format:String="%.3f", seperator:String=", ", printAllElements:Bool=false){
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
func print(_ x: vector, prefix:String="vector([", postfix:String="])", format:String="%.3f", printWholeMatrix:Bool=false){
    println(x, prefix:prefix, postfix:postfix, newline:"\n", format:format, printAllElements:printWholeMatrix)
}



