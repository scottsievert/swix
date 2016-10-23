//
//  oneD-functions.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(_ lhs:Vector, operation:String, rhs:Vector) -> Vector{
    assert(lhs.n == rhs.n, "Sizes must match!")
    
    // see [1] on how to integrate Swift and accelerate
    // [1]:https://github.com/haginile/SwiftAccelerate
    var result = lhs.copy()
    let N = lhs.n
    switch operation {
    case "+":
        cblas_daxpy(N.cint, 1.0.cdouble, !rhs, 1.cint, !result, 1.cint)
    case "-":
        cblas_daxpy(N.cint, -1.0.cdouble, !rhs, 1.cint, !result, 1.cint)
    case "*":
        vDSP_vmulD(!lhs, 1, !rhs, 1, !result, 1, lhs.n.length)
    case "/":
        vDSP_vdivD(!rhs, 1, !lhs, 1, !result, 1, lhs.n.length)
    case "%":
        result = lhs.remainder(rhs)
    case "<", ">", ">=", "<=":
        result = Vector(zerosLike:lhs)
        CVWrapper.compare(!lhs, with: !rhs, using: operation.nsstring as String, into: !result, ofLength: lhs.n.cint)
        // since opencv uses images which use 8-bit values
        result /= 255
    case "==":
        return (lhs-rhs).abs() < S2_THRESHOLD
    case "!==":
        return (lhs-rhs).abs() > S2_THRESHOLD
    default:
        assert(false, "operation not recongized!")
    }
    return result
}
func make_operator(_ lhs:Vector, operation:String, rhs:Double) -> Vector{
    var array = Vector(zerosLike:lhs)
    var right = [rhs]
    if operation == "%"{
        // unoptimized. for loop in c
        let r = Vector(zerosLike:lhs) + rhs
        array = lhs.remainder(r)
    } else if operation == "*"{
        var C:CDouble = 0
        var mul = CDouble(rhs)
        vDSP_vsmsaD(!lhs, 1.stride, &mul, &C, !array, 1.stride, lhs.n.length)
    }
    else if operation == "+"
        {vDSP_vsaddD(!lhs, 1, &right, !array, 1, lhs.n.length)}
    else if operation=="/"
        {vDSP_vsdivD(!lhs, 1, &right, !array, 1, lhs.n.length)}
    else if operation=="-"
    {array = make_operator(lhs, operation: "-", rhs: Vector(onesLike:lhs)*rhs)}
    else if operation=="<" || operation==">" || operation=="<=" || operation==">="{
        CVWrapper.compare(!lhs, with:rhs.cdouble, using:operation.nsstring as String, into:!array, ofLength:lhs.n.cint)
        array /= 255
    }
    else {assert(false, "operation not recongnized! Error with the speedup?")}
    return array
}
func make_operator(_ lhs:Double, operation:String, rhs:Vector) -> Vector{
    var array = Vector(zerosLike:rhs) // lhs[i], rhs[i]
    let l = Vector(onesLike:rhs) * lhs
    if operation == "*"
        {array = make_operator(rhs, operation: "*", rhs: lhs)}
    else if operation=="%"{
        let l = Vector(zerosLike:rhs) + lhs
        array = l.remainder(rhs)
    }
    else if operation == "+"{
        array = make_operator(rhs, operation: "+", rhs: lhs)}
    else if operation=="-"
        {array = -1 * make_operator(rhs, operation: "-", rhs: lhs)}
    else if operation=="/"{
        array = make_operator(l, operation: "/", rhs: rhs)}
    else if operation=="<"{
        array = make_operator(rhs, operation: ">", rhs: lhs)}
    else if operation==">"{
        array = make_operator(rhs, operation: "<", rhs: lhs)}
    else if operation=="<="{
        array = make_operator(rhs, operation: ">=", rhs: lhs)}
    else if operation==">="{
        array = make_operator(rhs, operation: "<=", rhs: lhs)}
    else {assert(false, "Operator not reconginzed")}
    return array
}

// DOUBLE ASSIGNMENT
infix operator <- : AssignmentPrecedence
public func <- (lhs:inout Vector, rhs:Double){
    lhs = Vector(onesLike:lhs) * rhs
}

// EQUALITY
infix operator ~== : ComparisonPrecedence
public func ~== (lhs: Vector, rhs: Vector) -> Bool{
    assert(lhs.n == rhs.n, "`~==` only works on arrays of equal size")
    return (lhs - rhs).abs().max() <= 1e-6
}
public func == (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "==", rhs: rhs)}
public func !== (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "!==", rhs: rhs)}

// NICE ARITHMETIC
public func += (x: inout Vector, right: Double){
    x = x + right}
public func *= (x: inout Vector, right: Double){
    x = x * right}
public func -= (x: inout Vector, right: Double){
    x = x - right}
public func /= (x: inout Vector, right: Double){
    x = x / right}

// MOD
public func % (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
public func % (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
public func % (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
// POW
public func ^ (lhs: Vector, rhs: Double) -> Vector{
    return lhs.pow(rhs)}
public func ^ (lhs: Vector, rhs: Vector) -> Vector{
    return lhs.pow(rhs)}
public func ^ (lhs: Double, rhs: Vector) -> Vector{
    return lhs.pow(rhs)}
// PLUS
public func + (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Int, rhs: Double) -> Double{ return Double(lhs) + rhs }
public func + (lhs: Double, rhs: Int) -> Double{ return Double(rhs) + lhs }
// MINUS
public func - (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
// TIMES
public func * (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
// DIVIDE
public func / (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "/", rhs: rhs)
    }
public func / (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "/", rhs: rhs)}
public func / (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "/", rhs: rhs)}
// LESS THAN
public func < (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
// GREATER THAN
public func > (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
public func >= (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
public func <= (lhs: Vector, rhs: Double) -> Vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: Vector, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: Double, rhs: Vector) -> Vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
// LOGICAL AND
public func && (lhs: Vector, rhs: Vector) -> Vector{
    return lhs.logical_and(rhs)}
// LOGICAL OR
public func || (lhs: Vector, rhs: Vector) -> Vector {
    return lhs.logical_or(rhs)
}
