//
//  initing.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate
import Swift

// SLOW PARTS: array(doubles), read_csv, write_csv. not a huge deal -- hopefully not used in final code


func zeros(_ N: Int) -> vector{
    // N zeros
    return vector(n: N)
}
func zeros_like(_ x: vector) -> vector{
    // make an array like the other array
   return zeros(x.n)
}
func ones_like(_ x: vector) -> vector{
    // make an array like the other array
    return zeros_like(x) + 1
}
func ones(_ N: Int) -> vector{
    // N ones
    return vector(n: N)+1
}
func arange(_ max: Double, x exclusive:Bool = true) -> vector{
    // 0..<max
    return arange(0, max: max, x:exclusive)
}
func arange(_ max: Int, x exclusive:Bool = true) -> vector{
    // 0..<max
    return arange(0, max: max.double, x:exclusive)
}
func range(_ min:Double, max:Double, step:Double) -> vector{
    // min, min+step, min+2*step..., max-step, max
    return linspace(min, max: max, num:1+((max-min)/step).int)
}
func arange(_ min: Double, max: Double, x exclusive: Bool = true) -> vector{
    // min...max
    var pad = 0
    if !exclusive {pad = 1}
    let N = max.int - min.int + pad
    let x = zeros(N)
    var o = CDouble(min)
    var l = CDouble(1)
    vDSP_vrampD(&o, &l, !x, 1.stride, N.length)
    return x
}
func linspace(_ min: Double, max: Double, num: Int=50) -> vector{
    // 0...1
    let x = zeros(num+0)
    var min  = CDouble(min)
    var step = CDouble((max-min).double/(num-1).double)
    vDSP_vrampD(&min, &step, !x, 1.stride, x.n.length)
    return x
}
func array(_ numbers: Double...) -> vector{
    // array(1, 2, 3, 4) -> arange(4)+1
    // okay to leave unoptimized, only used for testing
    var x = zeros(numbers.count)
    var i = 0
    for number in numbers{
        x[i] = number
        i += 1
    }
    return x
}
func asarray(_ x: [Double]) -> vector{
    // convert a grid of double's to an array
    var y = zeros(x.count)
    y.grid = x
    return y
}
func asarray(_ seq: Range<Int>) -> vector {
    // make a range a grid of arrays
    // improve with [1]
    // [1]:https://gist.github.com/nubbel/d5a3639bea96ad568cf2
    let start:Double = seq.lowerBound.double * 1.0
    let end:Double   = seq.upperBound.double * 1.0
    return arange(start, max: end, x:true)
}

func copy(_ x: vector) -> vector{
    // copy the value
    return x.copy()
}

func seed(_ n:Int){
    SWIX_SEED = __CLPK_integer(n)
}

func rand(_ N: Int, distro:String="uniform") -> vector{
    let x = zeros(N)
    var i:__CLPK_integer = 1
    if distro=="normal" {i = __CLPK_integer(3)}
    var seed:Array<__CLPK_integer> = [SWIX_SEED, 2, 3, 5]
    var nn:__CLPK_integer  = __CLPK_integer(N)
    dlarnv_(&i, &seed, &nn, !x)
    SWIX_SEED = seed[0]
    return x
}
func randn(_ N: Int, mean: Double=0, sigma: Double=1) -> vector{
    return (rand(N, distro:"normal") * sigma) + mean;
}
func randperm(_ N:Int)->vector{
    let x = arange(N)
    let y = shuffle(x)
    return y
}




















