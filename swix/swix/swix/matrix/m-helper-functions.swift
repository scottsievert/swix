//
//  helper-functions.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

extension Matrix {
    public func norm(ord:String="assumed to be 'fro' for Frobenius")->Double{
        if ord == "fro" {return flat.norm(ord: 2)}
        assert(false, "Norm type assumed to be \"fro\" for Forbenius norm!")
        return -1
    }

    // MARK: - NORMs
    public func norm(ord:Double=2)->Double{
        if      ord ==  inf {return self.abs().sum(axis:1).max()}
        else if ord == -inf {return self.abs().sum(axis:1).min()}
        else if ord ==  1   {return self.abs().sum(axis:0).max()}
        else if ord == -1   {return self.abs().sum(axis:0).min()}
        else if ord ==  2 {
            // compute only the largest singular value?
            let (_, s, _) = svd(compute_uv:false)
            return s[0]
        }
        else if ord == -2 {
            // compute only the smallest singular value?
            let (_, s, _) = svd(compute_uv:false)
            return s[-1]
        }
        
        assert(false, "Invalid norm for matrices")
        return -1
    }
    
    public func det()->Double{
        var result:CDouble = 0.0
        CVWrapper.det(!self, n:shape.0.cint, m:shape.1.cint, result:&result)
        return result
    }
    
    // MARK: - basics
    public func argwhere() -> Vector{
        return flat.argwhere()
    }
    public func flipud()->Matrix{
        let y = self.copy()
        CVWrapper.flip(!self, into:!y, how:"ud", m:shape.0.cint, n:shape.1.cint)
        return y
    }
    public func fliplr()->Matrix{
        let y = self.copy()
        CVWrapper.flip(!self, into:!y, how:"lr", m:shape.0.cint, n:shape.1.cint)
        return y
    }
    public func rot90(_ k:Int=1)->Matrix{
        // k is assumed to be less than or equal to 3
        if k == 1 { return self.fliplr().T }
        let y = self.copy()
        if k == 2 { return y.fliplr().flipud() }
        if k == 3 { return self.flipud().T }
        assert(false, "k is assumed to satisfy 1 <= k <= 3")
        return y
    }
    
    // MARK: - modifying matrices, modifying equations
    public func transpose () -> Matrix{
        let (n, m) = shape
        let y = Matrix(zeros:(m, n))
        vDSP_mtransD(!self, 1.stride, !y, 1.stride, m.length, n.length)
        return y
    }
    public func kron(_ B:Matrix)->Matrix{
        // an O(n^4) operation!
        func assign_kron_row(_ A:Matrix, B:Matrix,C:inout Matrix, p:Int, m:Int, m_max:Int){
            var row = (m+0)*(p+0) + p-0
            row = m_max*m + 1*p
            
            let i = Vector(arange:B.shape.1 * A.shape.1)
            let n1 = Vector(arange:A.shape.1)
            let q1 = Vector(arange:B.shape.1)
            let (n, q) = meshgrid(n1, y: q1)
            C[row, i] = A[m, n.flat] * B[p, q.flat]
        }
        var C = Matrix(zeros:(shape.0*B.shape.0, shape.1*B.shape.1))
        for p in 0..<shape.1{
            for m in 0..<B.shape.1{
                assign_kron_row(self, B: B, C: &C, p: p, m: m, m_max: shape.1)
            }
        }
        
        return C
    }
    
    public func tril() -> Vector{
        let (m, n) = shape
        let (mm, nn) = meshgrid(Vector(arange:m), y: Vector(arange:n))
        var i = mm - nn
        let j = (i < 0+S2_THRESHOLD)
        i[j.argwhere()] <- 0
        i[(1-j).argwhere()] <- 1
        return i.argwhere()
    }
    public func triu()->Vector{
        let (m, n) = shape
        let (mm, nn) = meshgrid(Vector(arange:m), y: Vector(arange:n))
        var i = mm - nn
        let j = (i > 0-S2_THRESHOLD)
        i[j.argwhere()] <- 0
        i[(1-j).argwhere()] <- 1
        return i.argwhere()
    }
}
