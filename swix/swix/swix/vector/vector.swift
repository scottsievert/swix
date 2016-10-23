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

public struct Vector:CustomStringConvertible {
    public let n: Int // the number of elements
    public var count: Int { return n } // ditto
    public var grid: [Double] // the raw values

    // MARK: - init
    public init(zeros: Int) {
        self.n = zeros
        grid = Array(repeating: 0.0, count: n)
    }

    public init(zerosLike:Vector){
        self.init(zeros:zerosLike.n)
    }

    public init(ones: Int) {
        self.n = ones
        grid = Array(repeating: 1.0, count: n)
    }
    
    public init(onesLike: Vector) {
        self.n = onesLike.n
        grid = Array(repeating: 1.0, count: n)
    }
    
    public init(min:Double, max:Double, step:Double){
        // min, min+step, min+2*step..., max-step, max
        self.init(min:min, max:max, num:1+((max-min)/step).int)
    }

    public init(min: Double, max: Double, num: Int) {
        // 0...1
        n = num
        grid = Array(repeating: 0.0, count: n)

        var min  = CDouble(min)
        var step = CDouble((max-min).double/(num-1).double)
        vDSP_vrampD(&min, &step, !self, 1.stride, n.length)
    }

    public init(rand: Int, distro:String="uniform"){
        n = rand
        grid = Array(repeating: 0.0, count: n)

        var i:__CLPK_integer = 1
        if distro=="normal" {i = __CLPK_integer(3)}
        var seed:Array<__CLPK_integer> = [SWIX_SEED, 2, 3, 5]
        var nn:__CLPK_integer  = __CLPK_integer(n)
        dlarnv_(&i, &seed, &nn, !self)
        SWIX_SEED = seed[0]
    }
    
    public init(randn: Int, mean: Double=0, sigma: Double=1) {
        self.init(rand:randn, distro:"normal")
        self *= sigma
        self += mean
    }

    public init(randperm:Int) {
        self.init(arange:randperm)
        shuffle()
    }

    public init(numbers: Double...) {
    // array(1, 2, 3, 4) -> arange(4)+1
    // okay to leave unoptimized, only used for testing
        self.init(zeros:numbers.count)
        var i = 0
        for number in numbers{
            grid[i] = number
            i += 1
        }
    }
    
    public init(min: Double, max: Double, x exclusive: Bool = true) {
        // min...max
        let pad = exclusive ? 0 : 1
        self.init(zeros:max.int - min.int + pad)
        var o = CDouble(min)
        var l = CDouble(1)
        vDSP_vrampD(&o, &l, !self, 1.stride, n.length)
    }

    public init(arange:Int, exclusive:Bool = true) {
        // 0..<max
        self.init(min:0, max: arange.double, x:exclusive)
    }
    
    public init(arange:Double, exclusive:Bool = true) {
        // 0..<max
        self.init(min:0, max: arange, x:exclusive)
    }
    

    public init(asarray: [Double]) {
        // convert a grid of double's to an array
        self.init(zeros:asarray.count)
        grid = asarray
    }

    public init(asarray: Range<Int>) {
        // make a range a grid of arrays
        // improve with [1]
        // [1]:https://gist.github.com/nubbel/d5a3639bea96ad568cf2
        let start:Double = asarray.lowerBound.double * 1.0
        let end:Double   = asarray.upperBound.double * 1.0
        self.init(min:start, max: end, x:true)
    }
    
    public func copy(_ x: Vector) -> Vector{
        // copy the value
        return x.copy()
    }
    
    public static func seed(_ n:Int){
        SWIX_SEED = __CLPK_integer(n)
    }
    
    public func copy() -> Vector{
        // return a new array just like this one
        let y = Vector(zeros:n)
        cblas_dcopy(self.n.cint, !self, 1.cint, !y, 1.cint)
        return y
    }
    public func sort(){
        // sort this array *in place*
        vDSP_vsortD(!self, self.n.length, 1.cint)
    }
    public func sorted()->Vector{
        let res = self.copy()
        vDSP_vsortD(!res, n.length, 1.cint)
        return res
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
        return self.sum() / n
    }
    public subscript(index:String)->Vector{
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
    public subscript(index: Int) -> Double {
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
    public subscript(r: Range<Int>) -> Vector {
        // x[0..<N]. Access a range of values.
        get {
            // assumes that r is not [0, 1, 2, 3...] not [0, 2, 4...]
            return self[Vector(asarray:r)]
        }
        set {
            self[Vector(asarray:r)].grid = newValue.grid}
    }
    public subscript(i: Vector) -> Vector {
        // x[arange(2)]. access a range of values; x[0..<2] depends on this.
        get {
            // Vector has fractional parts, and those parts get truncated
            var idx:Vector
            if i.n > 0 {
                if i.n == self.n && i.max() < 1.5 {
                    // assumed to be boolean
                    idx = (i > 0.5).argwhere()
                }
                else {
                    // it's just indexes
                    idx = i.copy()
                }
                if idx.max() < 0 {
                    // negative indexing
                    idx += n.double
                }
                if (idx.n > 0){
                    assert((idx.max().int < self.n) && (idx.min() >= 0), "An index is out of bounds")
                    let y = Vector(zeros:idx.n)
                    vDSP_vindexD(!self, !idx, 1.stride, !y, 1.stride, idx.n.length)
                    return y
                }
            }
            return Vector(zeros:0)
        }
        set {
            var idx:Vector// = oidx.copy()
            if i.n > 0{
                if i.n == self.n && i.max() < 1.5{
                    // assumed to be boolean
                    idx = (i > 0.5).argwhere()
                }
                else {
                    // it's just indexes
                    idx = i.copy()
                }
                if idx.n > 0{
                    if idx.max() < 0 {idx += n.double }
                    assert((idx.max().int < self.n) && (idx.min() >= 0), "An index is out of bounds")
                    index_xa_b_objc(!self, !idx, !newValue, idx.n.cint)
                }
            }
        }
    }

    public func max(_ y:Vector)->Vector{
        // finds the max of two arrays element wise
        assert(n == y.n)
        let z = Vector(zerosLike:self)
        vDSP_vmaxD(!self, 1.stride, !y, 1.stride, !z, 1.stride, n.length)
        return z
    }
    public func min(_ y:Vector)->Vector{
        // finds the min of two arrays element wise
        assert(n == y.n)
        let z = Vector(zerosLike:self)
        vDSP_vminD(!self, 1.stride, !y, 1.stride, !z, 1.stride, n.length)
        return z
    }

    public var description:String {
        var res = "Vector(["
        var separator = ""
        var printed = false
        
        for i in 0..<n{
            if (n)<16 || i<3 || i>(n-4) {
                res += String(format:separator + "%.3f", grid[i])
                separator = ", "
            }
            else if !printed {
                printed = true
                res += ", ..."
            }
            separator = ", "
        }
        return res + "])"
    }
}

