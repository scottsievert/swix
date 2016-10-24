//
//  twoD-operators.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

func make_operator(_ lhs: Matrix, operation: String, rhs: Matrix)->Matrix{
    assert(lhs.shape.0 == rhs.shape.0, "Sizes must match!")
    assert(lhs.shape.1 == rhs.shape.1, "Sizes must match!")
    
    var result = Matrix(zerosLike:lhs) // real result
    let lhsM = lhs.flat
    let rhsM = rhs.flat
    var resM = Vector(zerosLike:lhsM) // flat Vector
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
func make_operator(_ lhs: Matrix, operation: String, rhs: Double)->Matrix{
    var result = Matrix(zerosLike:lhs) // real result
//    var lhsM = asmatrix(lhs.grid) // flat
    let lhsM = lhs.flat
    var resM = Vector(zerosLike:lhsM) // flat matrix
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
func make_operator(_ lhs: Double, operation: String, rhs: Matrix)->Matrix{
    var result = Matrix(zerosLike:rhs) // real result
//    var rhsM = asmatrix(rhs.grid) // flat
    let rhsM = rhs.flat
    var resM = Vector(zerosLike:rhsM) // flat matrix
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
public func <- (lhs:inout Matrix, rhs:Double){
    lhs = Matrix(ones:(lhs.shape)) * rhs
}

// SOLVE
infix operator !/ : AdditionPrecedence
public func !/ (lhs: Matrix, rhs: Vector) -> Vector{
    return lhs.solve(rhs)}
// EQUALITY
public func ~== (lhs: Matrix, rhs: Matrix) -> Bool{
    return (rhs.flat ~== lhs.flat)}

public func == (lhs: Matrix, rhs: Matrix)->Matrix{
    return (lhs.flat == rhs.flat).reshape(lhs.shape)
}
public func !== (lhs: Matrix, rhs: Matrix)->Matrix{
    return (lhs.flat !== rhs.flat).reshape(lhs.shape)
}

/// ELEMENT WISE OPERATORS
// PLUS
public func + (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}

// MINUS
public func - (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}

// TIMES
public func * (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}

// DIVIDE
public func / (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)
}
public func / (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}
public func / (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}

// NICE ARITHMETIC
public func += (x: inout Matrix, right: Double){
    x = x + right}
public func *= (x: inout Matrix, right: Double){
    x = x * right}
public func -= (x: inout Matrix, right: Double){
    x = x - right}
public func /= (x: inout Matrix, right: Double){
    x = x / right}

// LESS THAN
public func < (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
// GREATER THAN
public func > (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
public func >= (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
public func <= (lhs: Matrix, rhs: Double) -> Matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: Matrix, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: Double, rhs: Matrix) -> Matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
