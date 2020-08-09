//
//  initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// the matrix definition and related functions go here

// SLOW PARTS: x[Vector, Vector] set

public struct Vector {
    let n: Int // the number of elements
    var count: Int // ditto
    var grid: [Double] // the raw values
    public init(n: Int) {
        self.n = n
        self.count = n
        grid = Array(repeating: 0.0, count: n)
    }
    /* func reshape(_ shape: (Int,Int)) -> matrix{ */
        /* // reshape to a matrix of size. */
        /* var (mm, nn) = shape */
        /* if mm == -1 {mm = n / nn} */
        /* if nn == -1 {nn = n / mm} */
        /* assert(mm * nn == n, "Number of elements must not change.") */
        /* var y:matrix = zeros((mm, nn)) */
        /* y.flat = self */
        /* return y */
    /* } */
    public func copy() -> Vector{
        // return a new array just like this one
        let y = zeros(n)
        cblas_dcopy(CInt(self.n), !self, 1.cint, !y, CInt(1))
        return y
    }
    public func sort(){
        // sort this array *in place*
        vDSP_vsortD(!self, vDSP_Length(self.n), CInt(1))
    }
    public func indexIsValidForRow(_ index: Int) -> Bool {
        // making sure this index is valid
        return index >= 0 && index < n
    }
    public func min() -> Double{
        // return the minimum
        var m:CDouble=0
        vDSP_minvD(!self, 1.stride, &m, self.n.length)
        return Double(m)
    }
    public func max() -> Double{
        // return the maximum
        var m:CDouble=0
        vDSP_maxvD(!self, 1.stride, &m, self.n.length)
        return m
    }
    public func mean() -> Double{
        // return the mean
        return sum(self) / Double(n)
    }
    subscript(index:String)->Vector{
        // assumed to be x["all"]. returns every element
        get {
            assert(index == "all", "Currently only \"all\" is supported")
            return self
        }
        set {
            assert(index == "all", "Currently only \"all\" is supported")
            self[0..<n] = newValue
        }
    }
    subscript(index: Int) -> Double {
        // x[0] -> Double. access a single element
        get {
            var newIndex:Int = index
            if newIndex < 0 {newIndex = self.n + index}
            assert(indexIsValidForRow(newIndex), "Index out of range")
            return grid[newIndex]
        }
        set {
            var newIndex:Int = index
            if newIndex < 0 {newIndex = self.n + index}
            assert(indexIsValidForRow(newIndex), "Index out of range")
            grid[newIndex] = newValue
        }
    }
    subscript(r: Range<Int>) -> Vector {
        // x[0..<N]. Access a range of values.
        get {
            // assumes that r is not [0, 1, 2, 3...] not [0, 2, 4...]
            return self[asarray(r)]
        }
        set {
            self[asarray(r)].grid = newValue.grid}
    }
    subscript(i: Vector) -> Vector {
        // x[arange(2)]. access a range of values; x[0..<2] depends on this.
        get {
            // Vector has fractional parts, and those parts get truncated
            var idx:Vector
            if i.n > 0 {
                if i.n == self.n && i.max() < 1.5 {
                    // assumed to be boolean
                    idx = argwhere(i > 0.5)
                }
                else {
                    // it's just indexes
                    idx = i.copy()
                }
                if idx.max() < 0 {
                    // negative indexing
                    idx += Double(n)
                }
                if (idx.n > 0){
                    assert((Int(idx.max()) < self.n) && (idx.min() >= 0), "An index is out of bounds")
                    let y = zeros(idx.n)
                    vDSP_vindexD(!self, !idx, 1.stride, !y, 1.stride, idx.n.length)
                    return y
                }
            }
            return array()
        }
        set {
            var idx:Vector// = oidx.copy()
            if i.n > 0{
                if i.n == self.n && i.max() < 1.5{
                    // assumed to be boolean
                    idx = argwhere(i > 0.5)
                }
                else {
                    // it's just indexes
                    idx = i.copy()
                }
                if idx.n > 0{
                    if idx.max() < 0 {idx += Double(n) }
                    assert((Int(idx.max()) < self.n) && (idx.min() >= 0), "An index is out of bounds")
                    /* index_xa_b_objc(!self, !idx, !newValue, */
                    /* CInt(idx.n)) */
                }
            }
        }
    }
}
