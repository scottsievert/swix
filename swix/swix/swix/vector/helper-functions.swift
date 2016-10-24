//
//  helper-functions.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

extension Vector {
    // MARK: - NORM
    public func norm(ord:Double=2) -> Double{
        // takes the norm of an array
        if ord==2      { return Darwin.sqrt(self.pow(2).sum()) }
        else if ord==1 { return self.abs().sum() }
        else if ord==0 { return (self.abs() > S2_THRESHOLD).sum() }
        else if ord == -1 || ord == -2{
            return Darwin.pow((self.abs()^ord.double).sum(), 1/ord.double)
        }
        else if ord.double ==  inf {return self.abs().max() }
        else if ord.double == -inf {return self.abs().min() }
        assert(false, "type of norm unrecongnized")
        return -1.0
    }
    public func count_nonzero()->Double{
        return (self.abs() > S2_THRESHOLD).sum()
    }
    
    // MARK: - modifying elements of the array
    public func clip(a_min:Double, a_max:Double)->Vector{
        // clip the matrix
        var y = self.copy()
        y[(self < a_min).argwhere()] <- a_min
        y[(self > a_max).argwhere()] <- a_max
        return y
    }
    public func reverse() -> Vector{
        // reverse the array
        let y = self.copy()
        vDSP_vrvrsD(!y, 1.stride, y.n.length)
        return y
    }
    public func delete(idx:Vector) -> Vector{
        // delete select elements
        var i = Vector(onesLike:self)
        i[idx] *= 0
        let y = self[i.argwhere()]
        return y
    }
    public func `repeat`(_ N:Int, axis:Int=0) -> Vector{
        // repeat the array element wise or as a whole array
        var y = Matrix(zeros:(N, n))
        
        // wrapping using OpenCV
        CVWrapper.`repeat`(!self, to:!y, n_x:n.cint, n_repeat:N.cint)
        
        if axis==0{}
        else if axis==1 { y = y.T}
        return y.flat
    }
    
    // MARK: - SORTING and the like
    public func unique()->Vector{
        let y = self.sorted()
        var z = Vector(zeros:1).concat(y)
        let diff = (z[1..<z.n] - z[0..<z.n-1]).abs() > S2_THRESHOLD
        let un = y[diff.argwhere()]
        let v:Double = self.min()
        let va = Darwin.abs(Int32(v)) //FUCK!
        if va < S2_THRESHOLD{
            return Vector(zeros:1).concat(un).sorted()
        }
        else{
            return un
        }
    }
    public func shuffle(){
        // randomly shuffle the array
        CVWrapper.shuffle(!self, n:n.cint)
    }

    public func shuffled()->Vector{
        // randomly shuffle the array
        let res = self.copy()
        res.shuffle()
        return res
    }
    
    // MARK: - SETS
    public func intersection(_ y:Vector)->Vector{
        return (self[(self.in1d(y)).argwhere()]).unique()
    }
    public func union(_ y:Vector)->Vector{
        return self.concat(y).unique()
    }
    public func in1d(_ y:Vector)->Vector{
        if (self.n > 0 && y.n > 0){
            let (xx, yy) = meshgrid(self, y: y)
            let i = (xx-yy).abs() < S2_THRESHOLD
            let j = (i.sum(axis:1)) > 0.5
            return 0+j
        }
        return Vector(zeros:0)
    }
    public func concat(_ y:Vector)->Vector{
        // concatenate two matrices
        var z = Vector(zeros:self.n + y.n)
        z[0..<self.n] = self
        z[self.n..<y.n+self.n] = y
        return z
    }
    
    // MARK: - ARG
    public func argmax()->Int{
        // find the location of the max
        var m:CInt = 0
        CVWrapper.argmax(!self, n: self.n.cint, max: &m)
        return Int(m)
    }
    public func argmin()->Int{
        // find the location of the min
        var m:CInt = 0
        CVWrapper.argmin(!self, n: self.n.cint, min: &m)
        return Int(m)
    }
    public func argsort()->Vector{
        // sort the array but use integers
        
        // the array of integers that OpenCV needs
        var y:[CInt] = Array(repeating: 0, count: self.n)
        // calling opencv's sortidx
        CVWrapper.argsort(!self, n: self.n.cint, into:&y)
        // the integer-->double conversion
        let z = Vector(zerosLike:self)
        vDSP_vflt32D(&y, 1.stride, !z, 1.stride, self.n.length)
        return z
    }
    public func argwhere() -> Vector{
        // counts non-zero elements, return array of doubles (which can be indexed!).
        let i = Vector(arange:n)
        let args = Vector(zeros:sum().int)
        vDSP_vcmprsD(!i, 1.stride, !self, 1.stride, !args, 1.stride, n.length)
        return args
    }
    
    
    // MARK: - LOGICAL
    public func logical_and(_ y:Vector)->Vector{
        return self * y
    }
    public func logical_or(_ y:Vector)->Vector{
        var i = self + y
        let j = (i > 0.5).argwhere()
        i[j] <- 1.0
        return i
    }
    public func logical_not()->Vector{
        return 1-self
    }
    public func logical_xor(_ y:Vector)->Vector{
        let i = self + y
        let j = (i < 1.5) && (i > 0.5)
        return j
    }
}
