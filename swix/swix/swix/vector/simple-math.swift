//
//  oneD_math.swift
//  swix
//
//  Created by Scott Sievert on 6/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Accelerate

extension Vector {
    public func apply_function(_ function: (Double)->Double) -> Vector{
        // apply a function to every element.
        
        // I've tried the below, but it doesn't apply the function to every element (at least in Xcode6b4)
        //var function:Double->Double = sin
        //var x = arange(N)*pi / N
        //var y = zeros(x.count)
        //dispatch_apply(UInt(N), dispatch_get_global_queue(0,0), {(i)->() in
        //    y[Int(i)] = function(x[Int(i)])
        //    })
        
        var y = Vector(zeros:n)
        for i in 0..<n{
            y[i] = function(self[i])
        }
        return y
    }
    enum VectorFunction:Int {
        case abs = 0
        case sign, cumsum, floor, log10, log2, exp2, log, exp, cos, sin, tan, expm1, round, ceil, tanh, sqrt
    }
    func apply_function(_ function: VectorFunction)->Vector{
        // apply select optimized functions
        var y = Vector(zerosLike:self)
        let n = self.n.length
        var count = Int32(self.n)
        switch function {
        case .abs:
            vDSP_vabsD(!self, 1, !y, 1, n)
        case .sign:
            var o = CDouble(0)
            var l = CDouble(1)
            vDSP_vlimD(!self, 1.stride, &o, &l, !y, 1.stride, n)
        case .cumsum:
            var scalar:CDouble = 1
            vDSP_vrsumD(!self, 1.stride, &scalar, !y, 1.stride, n)
        case .floor:
            vvfloor(!y, !self, &count)
        case .log10:
            assert(self.min() > 0, "log must be called with positive values")
            vvlog10(!y, !self, &count)
        case .log2:
            assert(self.min() > 0, "log must be called with positive values")
            vvlog2(!y, !self, &count)
        case .exp2:
            vvexp2(!y, !self, &count)
        case .log:
            assert(self.min() > 0, "log must be called with positive values")
            vvlog(!y, !self, &count)
        case .exp:
            vvexp(!y, !self, &count)
        case .cos:
            vvcos(!y, !self, &count)
        case .sin:
            vvsin(!y, !self, &count)
        case .tan:
            vvtan(!y, !self, &count)
        case .expm1:
            vvexpm1(!y, !self, &count)
        case .round:
            vvnint(!y, !self, &count)
        case .ceil:
            vvceil(!y, !self, &count)
        case .tanh:
            vvtanh(!y, !self, &count)
        case .sqrt:
            y = self^0.5
        }
        return y
    }

// BASIC INFO
    public func sign()->Vector{
        // finds the sign
        return apply_function(.sign)
    }
    public func sum() -> Double{
        // finds the sum of an array
        var ret:CDouble = 0
        vDSP_sveD(!self, 1.stride, &ret, self.n.length)
        return Double(ret)
    }
    public func remainder(_ x2:Vector)->Vector{
        // finds the remainder
        return (self - (self / x2).floor() * x2)
    }
    public func cumsum() -> Vector{
        // the sum of each element before.
        return apply_function(.cumsum)}
    public func abs() -> Vector{
        // absolute value
        return apply_function(.abs)}
    public func prod()->Double{
        var y = self.copy()
        var factor = 1.0
        if y.min() < 0{
            y[(y < 0.0).argwhere()] *= -1.0
            if (self < 0).sum().truncatingRemainder(dividingBy: 2) == 1 {factor = -1}
        }
        return factor * Darwin.exp((y.log() as Vector).sum())
    }
    public func cumprod()->Vector{
        var y = self.copy()
        if y.min() < 0.0{
            let i = y < 0
            y[i.argwhere()] *= -1.0
            let j = 1 - (i.cumsum() % 2.0) < S2_THRESHOLD
            var z = y.log().cumsum().exp()
            z[j.argwhere()] *= -1.0
            return z
        }
        return y.log().cumsum().exp()
    }
    
    
    // BASIC STATS
    public func std() -> Double{
        // standard deviation
        return Darwin.sqrt(self.variance()) }
    public func variance() -> Double{
        // the varianace
        return ((self - self.mean()).pow(2.0) / self.count.double).sum()}
    
    public func sqrt() -> Vector{
        return apply_function(.sqrt)
    }
    public func exp()->Vector{
        return apply_function(.exp)
    }
    public func exp2()->Vector{
        return apply_function(.exp2)
    }
    public func expm1()->Vector{
        return apply_function(.expm1)
    }
    
    // ROUND
    public func round()->Vector{
        return apply_function(.round)
    }
    public func round(_ decimals:Double)->Vector{
        let factor = Darwin.pow(10.0,Double(decimals))
        //        let factor = pow(10, decimals) // compiler bug does not recognize the pow functions >:-(
        return (self*factor).round() / factor
    }
    public func floor() -> Vector{
        return apply_function(.floor)
    }
    public func ceil() -> Vector{
        return apply_function(.ceil)
    }
    
    // POWER FUNCTIONS
    public func pow(_ power:Double)->Vector{
        // take the power. also callable with ^
        let y = Vector(zerosLike:self)
        CVWrapper.pow(!self, n:self.n.cint, power:power, into:!y)
        return y
    }
    public func pow(_ y:Vector)->Vector{
        // take the power. also callable with ^
        let z = Vector(zerosLike:self)
        var num = CInt(self.n)
        vvpow(!z, !y, !self, &num)
        return z
    }
    // LOG
    public func log10()->Vector{
        // log_10
        return apply_function(.log10)
    }
    public func log2()->Vector{
        // log_2
        return apply_function(.log2)
    }
    public func log()->Vector{
        // log_e
        return apply_function(.log)
    }
    
    // TRIG
    public func sin() -> Vector{
        return apply_function(.sin)
    }
    public func cos() -> Vector{
        return apply_function(.cos)
    }
    public func tan() -> Vector{
        return apply_function(.tan)
    }
    public func tanh() -> Vector {
        return apply_function(.tanh)
    }
}

extension Double {
    public func pow(_ y:Vector)->Vector{
        // take the power. also callable with ^
        let xx = Vector(onesLike:y) * self
        return xx.pow(y)
    }
}
