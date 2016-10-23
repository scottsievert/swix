//
//  twoD-math.swift
//  swix
//
//  Created by Scott Sievert on 7/10/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

extension Matrix {
    func apply_function(_ function: Vector.VectorFunction)->Matrix{
        var z = Matrix(zerosLike:self)
        z.flat = self.flat.apply_function(function)
        return z
    }
    
    // MARK: - TRIG
    public func sin() -> Matrix{
        return apply_function(.sin)
    }
    public func cos() -> Matrix{
        return apply_function(.cos)
    }
    public func tan() -> Matrix{
        return apply_function(.tan)
    }
    public func tanh() -> Matrix {
        return apply_function(.tanh)
    }
    
    // MARK: - BASIC INFO
    public func abs() -> Matrix{
        return apply_function(.abs)
    }
    public func sign() -> Matrix{
        return apply_function(.sign)
    }
    
    // MARK: - POWER FUNCTION
    public func pow(_ power: Double) -> Matrix{
        let y = self.flat.pow(power)
        var z = Matrix(zerosLike:self)
        z.flat = y
        return z
    }
    public func sqrt() -> Matrix{
        return apply_function(.sqrt)
    }
    
    // MARK: - ROUND
    public func floor() -> Matrix{
        return apply_function(.floor)
    }
    public func ceil() -> Matrix{
        return apply_function(.ceil)
    }
    public func round() -> Matrix{
        return apply_function(.round)
    }
    
    // MARK: - LOG
    public func log() -> Matrix{
        return apply_function(.log)
    }
    
    // MARK: - BASIC STATS
    public func min(_ y:Matrix)->Matrix{
        var z = Matrix(zerosLike:self)
        z.flat = self.flat.min(y.flat)
        return z
    }
    public func max(_ y:Matrix)->Matrix{
        var z = Matrix(zerosLike:self)
        z.flat = self.flat.max(y.flat)
        return z
    }
    
    
    // MARK: - AXIS
    public func sum(axis:Int = -1) -> Vector{
        // arg dim: indicating what dimension you want to sum over. For example, if dim==0, then it'll sum over dimension 0 -- it will add all the numbers in the 0th dimension, x[0..<x.shape.0, i]
        assert(axis==0 || axis==1, "if you want to sum over the entire matrix, call `sum(x.flat)`.")
        if axis==1{
            let n = shape.1
            let m = Matrix(ones:(n,1))
            return (self.dot(m)).flat
        }
        else if axis==0 {
            let n = shape.0
            let m = Matrix(ones:(1,n))
            return (m.dot(self)).flat
        }
        
        // the program will never get below this line
        assert(false)
        return Vector(zeros:1)
    }
    public func prod(axis:Int = -1) -> Vector{
        assert(axis==0 || axis==1, "if you want to sum over the entire matrix, call `sum(x.flat)`.")
        let y = self.log()
        let z = y.sum(axis:axis)
        return z.exp()
    }
    public func mean(_ x:Matrix, axis:Int = -1) -> Vector{
        assert(axis==0 || axis==1, "If you want to find the average of the whole matrix call `mean(x.flat)`")
        let div = axis==0 ? x.shape.0 : x.shape.1
        return x.sum(axis:axis) / div.double
    }
}

public func meshgrid(_ x: Vector, y:Vector) -> (Matrix, Matrix){
    assert(x.n > 0 && y.n > 0, "If these matrices are empty meshgrid fails")
    let z1 = y.`repeat`(x.n).reshape((x.n, y.n))
    let z2 = x.`repeat`(y.n, axis: 1).reshape((x.n, y.n))
    return (z2, z1)
}
