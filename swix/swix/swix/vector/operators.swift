//
//  oneD-functions.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(_ lhs:vector, operation:String, rhs:vector) -> vector{
    assert(lhs.n == rhs.n, "Sizes must match!")
    
    // see [1] on how to integrate Swift and accelerate
    // [1]:https://github.com/haginile/SwiftAccelerate
    var result = lhs.copy()
    let N = lhs.n
    if operation=="+"
        {cblas_daxpy(N.cint, 1.0.cdouble, !rhs, 1.cint, !result, 1.cint);}
    else if operation=="-"
        {cblas_daxpy(N.cint, -1.0.cdouble, !rhs, 1.cint, !result, 1.cint);}
    else if operation=="*"
        {vDSP_vmulD(!lhs, 1, !rhs, 1, !result, 1, lhs.n.length)}
    else if operation=="/"
        {vDSP_vdivD(!rhs, 1, !lhs, 1, !result, 1, lhs.n.length)}
    else if operation=="%"{
        result = remainder(lhs, x2: rhs)
    }
    else if operation=="<" || operation==">" || operation==">=" || operation=="<=" {
        result = zeros(lhs.n)
        CVWrapper.compare(!lhs, with: !rhs, using: operation.nsstring as String, into: !result, ofLength: lhs.n.cint)
        // since opencv uses images which use 8-bit values
        result /= 255
    }
    else if operation == "=="{
        return abs(lhs-rhs) < S2_THRESHOLD
    }
    else if operation == "!=="{
        return abs(lhs-rhs) > S2_THRESHOLD
    }
    else {assert(false, "operation not recongized!")}
    return result
}
func make_operator(_ lhs:vector, operation:String, rhs:Double) -> vector{
    var array = zeros(lhs.n)
    var right = [rhs]
    if operation == "%"{
        // unoptimized. for loop in c
        let r = zeros_like(lhs) + rhs
        array = remainder(lhs, x2: r)
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
        {array = make_operator(lhs, operation: "-", rhs: ones(lhs.n)*rhs)}
    else if operation=="<" || operation==">" || operation=="<=" || operation==">="{
        CVWrapper.compare(!lhs, with:rhs.cdouble, using:operation.nsstring as String, into:!array, ofLength:lhs.n.cint)
        array /= 255
    }
    else {assert(false, "operation not recongnized! Error with the speedup?")}
    return array
}
func make_operator(_ lhs:Double, operation:String, rhs:vector) -> vector{
    var array = zeros(rhs.n) // lhs[i], rhs[i]
    let l = ones(rhs.n) * lhs
    if operation == "*"
        {array = make_operator(rhs, operation: "*", rhs: lhs)}
    else if operation=="%"{
        let l = zeros_like(rhs) + lhs
        array = remainder(l, x2: rhs)
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
infix operator <-
func <- (lhs:inout vector, rhs:Double){
    let assign = ones(lhs.n) * rhs
    lhs = assign
}

// EQUALITY
infix operator ~== : ComparisonPrecedence
func ~== (lhs: vector, rhs: vector) -> Bool{
    assert(lhs.n == rhs.n, "`~==` only works on arrays of equal size")
    return max(abs(lhs - rhs)) > 1e-6 ? false : true;
}
func == (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "==", rhs: rhs)}
func !== (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "!==", rhs: rhs)}

// NICE ARITHMETIC
func += (x: inout vector, right: Double){
    x = x + right}
func *= (x: inout vector, right: Double){
    x = x * right}
func -= (x: inout vector, right: Double){
    x = x - right}
func /= (x: inout vector, right: Double){
    x = x / right}

// MOD
infix operator % : Multiplicative
func % (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
func % (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
func % (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "%", rhs: rhs)}
// POW
infix operator ^ : Multiplicative
func ^ (lhs: vector, rhs: Double) -> vector{
    return pow(lhs, power: rhs)}
func ^ (lhs: vector, rhs: vector) -> vector{
    return pow(lhs, y: rhs)}
func ^ (lhs: Double, rhs: vector) -> vector{
    return pow(lhs, y: rhs)}
// PLUS
infix operator + : Additive
func + (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
func + (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
func + (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "+", rhs: rhs)}
// MINUS
infix operator - : Additive
func - (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
func - (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
func - (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "-", rhs: rhs)}
// TIMES
infix operator * : Multiplicative
func * (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
func * (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
func * (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "*", rhs: rhs)}
// DIVIDE
infix operator / : Multiplicative
func / (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "/", rhs: rhs)
    }
func / (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "/", rhs: rhs)}
func / (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "/", rhs: rhs)}
// LESS THAN
infix operator < : ComparisonPrecedence
func < (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
func < (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
func < (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "<", rhs: rhs)}
// GREATER THAN
infix operator > : ComparisonPrecedence
func > (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
func > (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
func > (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
infix operator >= : ComparisonPrecedence
func >= (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
func >= (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
func >= (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
infix operator <= : ComparisonPrecedence
func <= (lhs: vector, rhs: Double) -> vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
func <= (lhs: vector, rhs: vector) -> vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
func <= (lhs: Double, rhs: vector) -> vector{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
// LOGICAL AND
infix operator && : Additive
func && (lhs: vector, rhs: vector) -> vector{
    return logical_and(lhs, y: rhs)}
// LOGICAL OR
func || (lhs: vector, rhs: vector) -> vector {
    return logical_or(lhs, y: rhs)
}































