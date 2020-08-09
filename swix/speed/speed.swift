//
//  speed.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

// should be run while optimized!
class SpeedTests {
    init(){
        time(pe1, name:"Project Euler 1")
        time(pe10, name:"Project Euler 10")
        time(soft_thresholding, name:"Soft thresholding")
        time(pi_approx, name:"Pi approximation")
    }
}
func time(f:()->(), name:String="function"){
    var start = NSDate()
    f()
    println(NSString(format:"\(name) time (s): %.4f", -1 * start.timeIntervalSinceNow))
}
func pe1(){
    var N = 1e6
    var x = arange(N)
    // seeing where that modulo is 0
    var i = argwhere((abs(x%3) < 1e-9) || (abs(x%5) < 1e-9))
    // println(sum(x[i]))
    // prints 233168.0, the correct answer
}
func pe10(){
    // find all primes
    var N = 2e6.int
    var primes = arange(N)
    for i in 2..<sqrt(N).int{
        var max:Int = (N/i)
        var j = arange(2, max) * i.double
        primes[j] *= 0.0
    }
    // sum(primes) is the correct answer
}
func soft_thresholding(){
    let N = 1e2.int
    var j = linspace(-1, 1, num:N)
    var (x, y) = meshgrid(j, j)
    var z = pow(x, 2) + pow(y, 2)
    var i = abs(z) < 0.5
    z[argwhere(i)] *= 0
    z[argwhere(1-i)] -= 0.5
}
func pi_approx(){
    var N = 1e6
    var k = arange(N)
    var pi_approx = 1 / (2*k + 1)
    pi_approx[2*k[0..<(N/2).int]+1] *= -1
    // println(4 * pi_approx)
    // prints 3.14059265383979
}
