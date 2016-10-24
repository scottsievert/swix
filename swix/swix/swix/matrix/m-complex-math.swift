//
//  twoD-complex-math.swift
//  swix
//
//  Created by Scott Sievert on 7/15/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Swift
import Accelerate

extension Matrix {
    public func rank()->Double{
        let (_, S, _) = self.svd(compute_uv:false)
        let m:Double = (shape.0 < shape.1 ? shape.1 : shape.0).double
        let tol = S.max() * m * DOUBLE_EPSILON
        return (S > tol).sum()
    }
    public func svd(compute_uv:Bool=true) -> (Matrix, Vector, Matrix){
        let (m, n) = shape
        let nS = m < n ? m : n // number singular values
        let sigma = Vector(zeros:nS)
        let vt = Matrix(zeros:(n,n))
        var u = Matrix(zeros:(m,m))
        
        var xx = Matrix(zerosLike:self)
        xx.flat = flat
        xx = xx.T
        let c_uv:CInt = compute_uv ? 1 : 0
        svd_objc(!xx, m.cint, n.cint, !sigma, !vt, !u, c_uv)
        
        // to get the svd result to match Python
        let v = vt.transpose()
        u = u.transpose()
        
        return (u, sigma, v)
    }
    public func pinv()->Matrix{
        var (u, s, v) = svd()
        let m = u.shape.0
        let n = v.shape.1
        let ma = m < n ? n : m
        let cutoff = DOUBLE_EPSILON * ma.double * s.max()
        let i = s > cutoff
        let ipos = i.argwhere()
        s[ipos] = 1 / s[ipos]
        let ineg = (1-i).argwhere()
        s[ineg] = Vector(zerosLike:ineg)
        var z = Matrix(zeros:(n, m))
        z["diag"] = s
        let res = v.T.dot(z).dot(u.T)
        return res
    }
    public func inv() -> Matrix{
        assert(shape.0 == shape.1, "To take an inverse of a matrix, the matrix must be square. If you want the inverse of a rectangular matrix, use psuedoinverse.")
        let y = self.copy()
        let (M, N) = shape
        
        var ipiv:Array<__CLPK_integer> = Array(repeating: 0, count: M*M)
        var lwork:__CLPK_integer = __CLPK_integer(N*N)
        //    var work:[CDouble] = [CDouble](count:lwork, repeatedValue:0)
        var work = [CDouble](repeating: 0.0, count: Int(lwork))
        var info:__CLPK_integer=0
        var nc = __CLPK_integer(N)
        dgetrf_(&nc, &nc, !y, &nc, &ipiv, &info)
        dgetri_(&nc, !y, &nc, &ipiv, &work, &lwork, &info)
        return y
    }
    public func solve(_ b: Vector) -> Vector{
        let (m, n) = shape
        assert(b.n == m, "Ax = b, A.rows == b.n. Sizes must match which makes sense mathematically")
        assert(n == m, "Matrix must be square -- dictated by OpenCV")
        let x = Vector(zeros:n)
        CVWrapper.solve(!self, b:!b, x:!x, m:m.cint, n:n.cint)
        return x
    }
    public func eig()->Vector{
        // matrix, value, Vectors
        let (m, n) = shape
        assert(m == n, "Input must be square")
        
        let value_real = Vector(zeros:m)
        let value_imag = Vector(zeros:n)
        var vector = Matrix(zeros:(n,n))
        
        var work:[Double] = Array(repeating: 0.0, count: n*n)
        var lwork = __CLPK_integer(4 * n)
        var info = __CLPK_integer(1)
        
        // don't compute right or left eigenVectors
        let job = "N"
        var jobvl = (job.cString(using: String.Encoding.utf8)?[0])!
        var jobvr = (job.cString(using: String.Encoding.utf8)?[0])!
        
        work[0] = Double(lwork)
        var nc = __CLPK_integer(n)
        dgeev_(&jobvl, &jobvr, &nc, !self, &nc,
               !value_real, !value_imag, !vector, &nc, !vector, &nc,
               &work, &lwork, &info)
        
        vector = vector.T
        
        return value_real
    }
}
