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

func rank(_ x:matrix)->Double{
    let (_, S, _) = svd(x, compute_uv:false)
    let m:Double = (x.shape.0 < x.shape.1 ? x.shape.1 : x.shape.0).double
    let tol = S.max() * m * DOUBLE_EPSILON
    return sum(S > tol)
}
func dot(_ x: matrix, y: matrix) -> matrix{
    return x.dot(y)
}
func dot(_ A: matrix, x: vector) -> vector{
    return A.dot(x)
}
func svd(_ x: matrix, compute_uv:Bool=true) -> (matrix, vector, matrix){
    let (m, n) = x.shape
    let nS = m < n ? m : n // number singular values
    let sigma = zeros(nS)
    let vt = zeros((n,n))
    var u = zeros((m,m))

    var xx = zeros_like(x)
    xx.flat = x.flat
    xx = xx.T
    let c_uv:CInt = compute_uv==true ? 1 : 0
    svd_objc(!xx, m.cint, n.cint, !sigma, !vt, !u, c_uv)
    
    // to get the svd result to match Python
    let v = transpose(vt)
    u = transpose(u)

    return (u, sigma, v)
}
func pinv(_ x:matrix)->matrix{
    var (u, s, v) = svd(x)
    let m = u.shape.0
    let n = v.shape.1
    let ma = m < n ? n : m
    let cutoff = DOUBLE_EPSILON * ma.double * max(s)
    let i = s > cutoff
    let ipos = argwhere(i)
    s[ipos] = 1 / s[ipos]
    let ineg = argwhere(1-i)
    s[ineg] = zeros_like(ineg)
    var z = zeros((n, m))
    z["diag"] = s
    let res = v.T.dot(z).dot(u.T)
    return res
}
func inv(_ x: matrix) -> matrix{
    assert(x.shape.0 == x.shape.1, "To take an inverse of a matrix, the matrix must be square. If you want the inverse of a rectangular matrix, use psuedoinverse.")
    let y = x.copy()
    let (M, N) = x.shape
    
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
func solve(_ A: matrix, b: vector) -> vector{
    let (m, n) = A.shape
    assert(b.n == m, "Ax = b, A.rows == b.n. Sizes must match which makes sense mathematically")
    assert(n == m, "Matrix must be square -- dictated by OpenCV")
    let x = zeros(n)
    CVWrapper.solve(!A, b:!b, x:!x, m:m.cint, n:n.cint)
    return x
}
func eig(_ x: matrix)->vector{
    // matrix, value, vectors
    let (m, n) = x.shape
    assert(m == n, "Input must be square")
    
    let value_real = zeros(m)
    let value_imag = zeros(n)
    var vector = zeros((n,n))
    
    var work:[Double] = Array(repeating: 0.0, count: n*n)
    var lwork = __CLPK_integer(4 * n)
    var info = __CLPK_integer(1)
    
    // don't compute right or left eigenvectors
    let job = "N"
    var jobvl = (job.cString(using: String.Encoding.utf8)?[0])!
    var jobvr = (job.cString(using: String.Encoding.utf8)?[0])!
    
    work[0] = Double(lwork)
    var nc = __CLPK_integer(n)
    dgeev_(&jobvl, &jobvr, &nc, !x, &nc,
        !value_real, !value_imag, !vector, &nc, !vector, &nc,
        &work, &lwork, &info)
    
    vector = vector.T
    
    return value_real
}









