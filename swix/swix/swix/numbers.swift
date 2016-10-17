//
//  constants.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

// should point to the swift folder
let PYTHON_PATH = "~/anaconda/bin/ipython"

// only used in `imshow` and `savefig`
let S2_PREFIX = "\(NSHomeDirectory())/Developer/swix/swix/swix/swix/"


// how close is close?
let S2_THRESHOLD = 1e-9

// The random seed
var SWIX_SEED:__CLPK_integer = 42

// various important constants
public var pi = 3.1415926535897932384626433832795028841971693993751058
public var π = pi
public var tau = 2 * pi
public var τ = tau
public var phi = (1.0 + sqrt(5))/2
public var φ = phi
public var e = exp(1.double)
public var euler = 0.57721566490153286060651209008240243104215933593992

// largest possible value
public var inf = Double.infinity
public var nan = Double.nan

// smallest possible difference
public var DOUBLE_EPSILON = DBL_EPSILON
public var FLOAT_EPSILON = FLT_EPSILON

public func close(_ x: Double, y: Double)->Bool{
    return abs(x-y) < S2_THRESHOLD
}
public func ~= (x:Double, y:Double)->Bool{
    return close(x, y: y)
}
public func rad2deg(_ x:Double)->Double{
    return (x * 180.0) / pi
}
public func deg2rad(_ x:Double)->Double{
    return (x * pi) / 180.0
}
public func max(_ x:Double, y:Double)->Double{
    return x < y ? y : x
}
public func min(_ x:Double, y:Double)->Double{
    return x < y ? x : y
}
public func factorial(_ n:Double)->Double{
    let y = arange(n)+1
    return prod(y)
}
public func binom(_ n:Double, k:Double)->Double{
    // similar to scipy.special.binom
    let i = arange(k)+1
    let result = (n+1-i) / i
    return prod(result)
}

// use 3.double or 3.14.int or N.int
extension Int{
    public var stride:vDSP_Stride {return vDSP_Stride(self)}
    public var length:vDSP_Length {return vDSP_Length(self)}
    public var int:Int {return Int(self)}
    public var cint:CInt {return CInt(self)}
    public var float:Float {return Float(self)}
    public var double:Double {return Double(self)}
}
extension Double{
    public var int:Int {return Int(self)}
    public var float:Float {return Float(self)}
    public var double:Double {return Double(self)}
    public var cdouble:CDouble {return CDouble(self)}
}
extension CInt{
    public var int:Int {return Int(self)}
    public var float:Float {return Float(self)}
    public var double:Double {return Double(self)}
}
extension Float{
    public var int:Int {return Int(self)}
    public var cfloat:CFloat {return CFloat(self)}
    public var float:Float {return Float(self)}
    public var double:Double {return Double(self)}

}
extension String {
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    public var nsstring:NSString {return NSString(string:self)}
}

public func / (lhs: Int, rhs: Int) -> Double{
    return lhs.double / rhs.double}
public func / (lhs: Double, rhs: Int) -> Double{
    return lhs / rhs.double}

// a quick hack to get what I want
public func isNumber(_ x: Double)   ->Bool{return true}
public func isNumber(_ x: Float)    ->Bool{return true}
public func isNumber(_ x: Int)      ->Bool{return true}
public func isNumber(_ x: CInt)     ->Bool{return true}
public func isNumber(_ x: vector)   ->Bool{return false}
public func isNumber(_ x: matrix) ->Bool{return false}
public func isNumber(_ x: AnyObject)->Bool{return false}









