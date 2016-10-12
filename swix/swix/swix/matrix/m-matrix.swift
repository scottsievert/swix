//
//  matrix2d.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate
struct matrix {
    let n: Int
    var rows: Int
    var columns: Int
    var count: Int
    var shape: (Int, Int)
    var flat:vector
    var T:matrix {return transpose(self)}
    var I:matrix {return inv(self)}
    var pI:matrix {return pinv(self)}
    init(columns: Int, rows: Int) {
        self.n = rows * columns
        self.rows = rows
        self.columns = columns
        self.shape = (rows, columns)
        self.count = n
        self.flat = zeros(rows * columns)
        
    }
    func copy()->matrix{
        var y = zeros_like(self)
        y.flat = self.flat.copy()
        return y
    }
    subscript(i: String) -> vector {
        get {
            assert(i == "diag", "Currently the only support x[string] is x[\"diag\"]")
            let size = rows < columns ? rows : columns
            let i = arange(size)
            return self[i*columns.double + i]
        }
        set {
            assert(i == "diag", "Currently the only support x[string] is x[\"diag\"]")
            let m = shape.0
            let n = shape.1
            let min_mn = m < n ? m : n
            let j = n.double * arange(min_mn)
            self[j + j/n.double] = newValue
        }
    }
    func indexIsValidForRow(_ r: Int, c: Int) -> Bool {
        return r >= 0 && r < rows && c>=0 && c < columns
    }
    func dot(_ y: matrix) -> matrix{
        let (Mx, Nx) = self.shape
        let (My, Ny) = y.shape
        assert(Nx == My, "Matrix sizes not compatible for dot product")
        let z = zeros((Mx, Ny))
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            Mx.cint, Ny.cint, Nx.cint, 1.0,
            !self, Nx.cint,
            !y, Ny.cint, 1.0,
            !z, Ny.cint)
        return z
    }
    func dot(_ x: vector) -> vector{
        var y = zeros((x.n, 1))
        y.flat = x
        let z = self.dot(y)
        return z.flat
    }
    func min(_ axis:Int = -1) -> Double{
        if axis == -1{
            return self.flat.min()
        }
        assert(axis==0 || axis==1, "Axis must be 0 or 1 as matrix only has two dimensions")
        assert(false, "max(x, axis:Int) for maximum of each row is not implemented yet. Use max(A.flat) or A.flat.max() to get the global maximum")

    }
    func max(_ axis:Int = -1) -> Double{
        if axis == -1 {
            return self.flat.max()
        }
        assert(axis==0 || axis==1, "Axis must be 0 or 1 as matrix only has two dimensions")
        assert(false, "max(x, axis:Int) for maximum of each row is not implemented yet. Use max(A.flat) or A.flat.max() to get the global maximum")
    }
    subscript(i: Int, j: Int) -> Double {
        // x[0,0]
        get {
            var nI = i
            var nJ = j
            if nI < 0 {nI = rows + i}
            if nJ < 0 {nJ = rows + j}
            assert(indexIsValidForRow(nI, c:nJ), "Index out of range")
            return flat[nI * columns + nJ]
        }
        set {
            var nI = i
            var nJ = j
            if nI < 0 {nI = rows + i}
            if nJ < 0 {nJ = rows + j}
            assert(indexIsValidForRow(nI, c:nJ), "Index out of range")
            flat[nI * columns + nJ] = newValue
        }
    }
    subscript(i: Range<Int>, k: Int) -> vector {
        // x[0..<2, 0]
        get {
            let idx = asarray(i)
            return self[idx, k]
        }
        set {
            let idx = asarray(i)
            self[idx, k] = newValue
        }
    }
    subscript(r: Range<Int>, c: Range<Int>) -> matrix {
        // x[0..<2, 0..<2]
        get {
            let rr = asarray(r)
            let cc = asarray(c)
            return self[rr, cc]
        }
        set {
            let rr = asarray(r)
            let cc = asarray(c)
            self[rr, cc] = newValue
        }
    }
    subscript(i: Int, k: Range<Int>) -> vector {
        // x[0, 0..<2]
        get {
            let idx = asarray(k)
            return self[i, idx]
        }
        set {
            let idx = asarray(k)
            self[i, idx] = newValue
        }
    }
    subscript(or: vector, oc: vector) -> matrix {
        // the main method.
        // x[array(1,2), array(3,4)]
        get {
            var r = or.copy()
            var c = oc.copy()
            if r.max() < 0.0 {r += 1.0 * rows.double}
            if c.max() < 0.0 {c += 1.0 * columns.double}
            
            let (j, i) = meshgrid(r, y: c)
            let idx = (j.flat*columns.double + i.flat)
            let z = flat[idx]
            let zz = reshape(z, shape: (r.n, c.n))
            return zz
        }
        set {
            var r = or.copy()
            var c = oc.copy()
            if r.max() < 0.0 {r += 1.0 * rows.double}
            if c.max() < 0.0 {c += 1.0 * columns.double}
            if r.n > 0 && c.n > 0{
                let (j, i) = meshgrid(r, y: c)
                let idx = j.flat*columns.double + i.flat
                flat[idx] = newValue.flat
            }
        }
    }
    subscript(r: vector) -> vector {
        // flat indexing
        get {return self.flat[r]}
        set {self.flat[r] = newValue }
    }
    subscript(i: String, k:Int) -> vector {
        // x["all", 0]
        get {
            let idx = arange(shape.0)
            let x:vector = self.flat[idx * self.columns.double + k.double]
            return x
        }
        set {
            let idx = arange(shape.0)
            self.flat[idx * self.columns.double + k.double] = newValue
        }
    }
    subscript(i: Int, k: String) -> vector {
        // x[0, "all"]
        get {
            assert(k == "all", "Only 'all' supported")
            let idx = arange(shape.1)
            let x:vector = self.flat[i.double * self.columns.double + idx]
            return x
        }
        set {
            assert(k == "all", "Only 'all' supported")
            let idx = arange(shape.1)
            self.flat[i.double * self.columns.double + idx] = newValue
        }
    }
    subscript(i: vector, k: Int) -> vector {
        // x[array(1,2), 0]
        get {
            let idx = i.copy()
            let x:vector = self.flat[idx * self.columns.double + k.double]
            return x
        }
        set {
            let idx = i.copy()
            self.flat[idx * self.columns.double + k.double] = newValue
        }
    }
    subscript(i: matrix) -> vector {
        // x[x < 5]
        get {
            return self.flat[i.flat]
        }
        set {
            self.flat[i.flat] = newValue
        }
    }
    subscript(i: Int, k: vector) -> vector {
        // x[0, array(1,2)]
        get {
            let x:vector = self.flat[i.double * self.columns.double + k]
            return x
        }
        set {
            self.flat[i.double * self.columns.double + k] = newValue
        }
    }
}

















