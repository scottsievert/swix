//
//  speed.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

// should be run while optimized!
class swixSpeedTests {
    init(){
        time(pe1, name:"Project Euler 1")
        time(pe10, name:"Project Euler 10")
        time(pe73, name:"Project Euler 73")
        time(pi_approx, name:"Pi approximation")
        time(soft_thresholding, name:"Soft thresholding")
    }
}
func time(_ f:(()->()), name:String="function"){
    let start = Date()
    f()
    print(NSString(format:"\(name) time (s): %.4f" as NSString, -1 * start.timeIntervalSinceNow))
}
func pe1(){
    let N = 1e6
    let x = arange(N)
    // seeing where that modulo is 0
    _ = argwhere((abs(x%3) < 1e-9) || (abs(x%5) < 1e-9))
    // println(sum(x[i]))
    // prints 233168.0, the correct answer
}
func pe10(){
    // find all primes
    let N = 2e6.int
    var primes = arange(Double(N))
    let top = (sqrt(N.double)).int
    for i in 2 ..< top{
        let max:Int = (N/i)
        let j = arange(2, max: max.double) * i.double
        primes[j] *= 0.0
    }
    // sum(primes) is the correct answer
}
func pe73(){
    let N = 1e3
    let i = arange(N)+1
    let (n, d) = meshgrid(i, y: i)
    
    var f = (n / d).flat
    f = unique(f)
    _ = (f > 1/3) && (f < 1/2)
    // println(f[argwhere(j)].n)
}


func soft_thresholding(){
    let N = 1e2.int
    let j = linspace(-1, max: 1, num:N)
    let (x, y) = meshgrid(j, y: j)
    var z = pow(x, power: 2) + pow(y, power: 2)
    let i = abs(z) < 0.5
    z[argwhere(i)] *= 0
    z[argwhere(1-i)] -= 0.5
}



func pi_approx(){
    let N = 1e6
    var k = arange(N)
    var pi_approx = 1 / (2*k + 1)
    pi_approx[2*k[0..<(N/2).int]+1] *= -1
    // println(4 * pi_approx)
    // prints 3.14059265383979
}
