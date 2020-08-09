//
//  twoD-operators.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(_ lhs: matrix, operation: String, rhs: matrix)->matrix{
    assert(lhs.shape.0 == rhs.shape.0, "Sizes must match!")
    assert(lhs.shape.1 == rhs.shape.1, "Sizes must match!")
    
    var result = zeros_like(lhs) // real result
    let lhsM = lhs.flat
    let rhsM = rhs.flat
    var resM:vector = zeros_like(lhsM) // flat vector
    if operation=="+" {resM = lhsM + rhsM}
    else if operation=="-" {resM = lhsM - rhsM}
    else if operation=="*" {resM = lhsM * rhsM}
    else if operation=="/" {resM = lhsM / rhsM}
    else if operation=="<" {resM = lhsM < rhsM}
    else if operation==">" {resM = lhsM > rhsM}
    else if operation==">=" {resM = lhsM >= rhsM}
    else if operation=="<=" {resM = lhsM <= rhsM}
    result.flat.grid = resM.grid
    return result
}
func make_operator(_ lhs: matrix, operation: String, rhs: Double)->matrix{
    var result = zeros_like(lhs) // real result
//    var lhsM = asmatrix(lhs.grid) // flat
    let lhsM = lhs.flat
    var resM:vector = zeros_like(lhsM) // flat matrix
    if operation=="+" {resM = lhsM + rhs}
    else if operation=="-" {resM = lhsM - rhs}
    else if operation=="*" {resM = lhsM * rhs}
    else if operation=="/" {resM = lhsM / rhs}
    else if operation=="<" {resM = lhsM < rhs}
    else if operation==">" {resM = lhsM > rhs}
    else if operation==">=" {resM = lhsM >= rhs}
    else if operation=="<=" {resM = lhsM <= rhs}
    result.flat.grid = resM.grid
    return result
}
func make_operator(_ lhs: Double, operation: String, rhs: matrix)->matrix{
    var result = zeros_like(rhs) // real result
//    var rhsM = asmatrix(rhs.grid) // flat
    let rhsM = rhs.flat
    var resM:vector = zeros_like(rhsM) // flat matrix
    if operation=="+" {resM = lhs + rhsM}
    else if operation=="-" {resM = lhs - rhsM}
    else if operation=="*" {resM = lhs * rhsM}
    else if operation=="/" {resM = lhs / rhsM}
    else if operation=="<" {resM = lhs < rhsM}
    else if operation==">" {resM = lhs > rhsM}
    else if operation==">=" {resM = lhs >= rhsM}
    else if operation=="<=" {resM = lhs <= rhsM}
    result.flat.grid = resM.grid
    return result
}

// DOUBLE ASSIGNMENT
func <- (lhs:inout matrix, rhs:Double){
    let assign = ones((lhs.shape)) * rhs
    lhs = assign
}

// SOLVE
infix operator !/ : Multiplicative
func !/ (lhs: matrix, rhs: vector) -> vector{
    return solve(lhs, b: rhs)}
// EQUALITY
func ~== (lhs: matrix, rhs: matrix) -> Bool{
    return (rhs.flat ~== lhs.flat)}

infix operator == : ComparisonPrecedence
func == (lhs: matrix, rhs: matrix)->matrix{
    return (lhs.flat == rhs.flat).reshape(lhs.shape)
}
infix operator !== : ComparisonPrecedence
func !== (lhs: matrix, rhs: matrix)->matrix{
    return (lhs.flat !== rhs.flat).reshape(lhs.shape)
}

/// ELEMENT WISE OPERATORS
// PLUS
infix operator + : Additive
func + (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
func + (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
func + (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
// MINUS
infix operator - : Additive
func - (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
func - (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
func - (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
// TIMES
infix operator * : Multiplicative
func * (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
func * (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
func * (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
// DIVIDE
infix operator / : Multiplicative
func / (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)
}
func / (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}
func / (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}
// LESS THAN
infix operator < : ComparisonPrecedence
func < (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
func < (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
func < (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
// GREATER THAN
infix operator > : ComparisonPrecedence
func > (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
func > (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
func > (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
infix operator >= : ComparisonPrecedence
func >= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
func >= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
func >= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
infix operator <= : ComparisonPrecedence
func <= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
func <= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
func <= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
