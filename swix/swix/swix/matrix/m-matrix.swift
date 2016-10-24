//
//  matrix2d.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate
public typealias Shape = (rows:Int, columns:Int)
public struct Matrix:CustomStringConvertible {
    var _shape:Shape
    public var rows: Int { return _shape.rows }
    public var columns: Int { return _shape.columns }
    var _count: Int
    public var count: Int { return _count }
    public var shape: Shape { return _shape }
    public var flat:Vector
    public var T:Matrix {return self.transpose()}
    public var I:Matrix {return self.inv()}
    public var pI:Matrix {return self.pinv()}
    public enum MatrixSubscript:Int {
        case diag=0
    }
    
    // MARK: - Init
    public init(columns: Int, rows: Int) {
        _count = rows * columns
        _shape.rows = rows
        _shape.columns = columns
        self.flat = Vector(zeros:_count)
    }

    public init(_ rowVec:[Vector]) {
        _shape.rows = rowVec.count
        assert(rowVec.count > 0, "Can't create a matrix with no row data provided")
        _shape.columns = rowVec[0].count
        assert(rowVec[0].count > 0, "Can't create a matrix with no column data provided")
        for i in 1..<rowVec.count {
            assert(rowVec[i].count == rowVec[0].count, "All matrix rows must have same length")
        }
        _count = _shape.rows * _shape.columns
        flat = Vector(zeros:_count)
        var p = 0
        for i in 0..<self.rows {
            for j in 0..<columns {
                flat[p] = rowVec[i][j]
                p += 1
            }
        }
    }
  
    public init(zeros: (Int, Int)) {
        self.init(columns: zeros.1, rows: zeros.0)
    }
    public init(zerosLike: Matrix) {
        self.init(columns: zerosLike.shape.1, rows: zerosLike.shape.0)
    }
    public init (onesLike: Matrix) {
        self.init(zerosLike:onesLike)
        self += 1
    }
    public init(ones: (Int, Int)) {
        self.init(columns: ones.1, rows: ones.0)
        self += 1
    }
    public init(eye: Int) {
        self.init(columns:eye, rows:eye)
        self["diag"] = Vector(ones:eye)
    }
    public init(diag:Vector) {
        self.init(zeros:(diag.n, diag.n))
        self["diag"] = diag
    }
    public init(randn: (Int, Int), mean: Double=0, sigma: Double=1) {
        self.init(zeros:randn)
        flat = Vector(randn:randn.0 * randn.1, mean:mean, sigma:sigma)
    }
    public init(rand: (Int, Int)) {
        self.init(zeros:rand)
        flat = Vector(rand:rand.0 * rand.1)
    }
    
    /// array("1 2 3; 4 5 6; 7 8 9") works like matlab. note that string format has to be followed to the dot. String parsing has bugs; I'd use arange(9).reshape((3,3)) or something similar
    public init(_ matlab_like_string: String) {
        var rows = matlab_like_string.components(separatedBy: ";")
        let r = rows.count
        var c = 0
        for char in rows[0].characters{
            if char == " " {}
            else {c += 1}
        }
        self.init(zeros:(r, c))
        var start:Int
        var i:Int=0, j:Int=0
        for row in rows{
            var nums = row.components(separatedBy: CharacterSet.whitespaces)
            if nums[0] == ""{start=1}
            else {start=0}
            j = 0
            for n in start..<nums.count{
                self[i, j] = nums[n].floatValue.double
                j += 1
            }
            i += 1
        }
    }
    
    public func copy()->Matrix{
        var y = Matrix(zerosLike:self)
        y.flat = self.flat.copy()
        return y
    }
    
    // MARK: - subscript
    public func indexIsValidForRow(_ r: Int, c: Int) -> Bool {
        return r >= 0 && r < rows && c>=0 && c < columns
    }
    public subscript(i: MatrixSubscript) -> Vector {
        get {
            let size = rows < columns ? rows : columns
            let i = Vector(arange:size)
            return self[i*columns.double + i]
        }
        set {
            let m = shape.0
            let n = shape.1
            let min_mn = m < n ? m : n
            let j = n.double * Vector(arange:min_mn)
            self[j + j/n.double] = newValue
        }
    }
    public subscript(i: String) -> Vector {
        get {
            assert(i == "diag", "Currently the only support x[string] is x[\"diag\"]")
            return self[.diag]
        }
        set {
            assert(i == "diag", "Currently the only support x[string] is x[\"diag\"]")
            self[.diag] = newValue
        }
    }
    
    public subscript(i: Int, j: Int) -> Double {
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
    public subscript(i: Range<Int>, k: Int) -> Vector {
        // x[0..<2, 0]
        get {
            let idx = Vector(asarray:i)
            return self[idx, k]
        }
        set {
            let idx = Vector(asarray:i)
            self[idx, k] = newValue
        }
    }
    public subscript(r: Range<Int>, c: Range<Int>) -> Matrix {
        // x[0..<2, 0..<2]
        get {
            let rr = Vector(asarray:r)
            let cc = Vector(asarray:c)
            return self[rr, cc]
        }
        set {
            let rr = Vector(asarray:r)
            let cc = Vector(asarray:c)
            self[rr, cc] = newValue
        }
    }
    public subscript(i: Int, k: Range<Int>) -> Vector {
        // x[0, 0..<2]
        get {
            let idx = Vector(asarray:k)
            return self[i, idx]
        }
        set {
            let idx = Vector(asarray:k)
            self[i, idx] = newValue
        }
    }
    public subscript(or: Vector, oc: Vector) -> Matrix {
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
            let zz = z.reshape((r.n, c.n))
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
    public subscript(r: Vector) -> Vector {
        // flat indexing
        get {return self.flat[r]}
        set {self.flat[r] = newValue }
    }
    public subscript(i: String, k:Int) -> Vector {
        // x["all", 0]
        get {
            let idx = Vector(arange:shape.0)
            let x:Vector = self.flat[idx * self.columns.double + k.double]
            return x
        }
        set {
            let idx = Vector(arange:shape.0)
            self.flat[idx * self.columns.double + k.double] = newValue
        }
    }
    public subscript(i: Int, k: String) -> Vector {
        // x[0, "all"]
        get {
            assert(k == "all", "Only 'all' supported")
            let idx = Vector(arange:shape.1)
            let x:Vector = self.flat[i.double * self.columns.double + idx]
            return x
        }
        set {
            assert(k == "all", "Only 'all' supported")
            let idx = Vector(arange:shape.1)
            self.flat[i.double * self.columns.double + idx] = newValue
        }
    }
    public subscript(i: Vector, k: Int) -> Vector {
        // x[array(1,2), 0]
        get {
            let idx = i.copy()
            let x:Vector = self.flat[idx * self.columns.double + k.double]
            return x
        }
        set {
            let idx = i.copy()
            self.flat[idx * self.columns.double + k.double] = newValue
        }
    }
    public subscript(i: Matrix) -> Vector {
        // x[x < 5]
        get {
            return self.flat[i.flat]
        }
        set {
            self.flat[i.flat] = newValue
        }
    }
    public subscript(i: Int, k: Vector) -> Vector {
        // x[0, array(1,2)]
        get {
            let x:Vector = self.flat[i.double * self.columns.double + k]
            return x
        }
        set {
            self.flat[i.double * self.columns.double + k] = newValue
        }
    }

    // MARK: - dot
    public func dot(_ y: Matrix) -> Matrix{
        let (Mx, Nx) = self.shape
        let (My, Ny) = y.shape
        assert(Nx == My, "Matrix sizes not compatible for dot product")
        let z = Matrix(zeros:(Mx, Ny))
        cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            Mx.cint, Ny.cint, Nx.cint, 1.0,
            !self, Nx.cint,
            !y, Ny.cint, 1.0,
            !z, Ny.cint)
        return z
    }
    public func dot(_ x: Vector) -> Vector{
        var y = Matrix(zeros:(x.n, 1))
        y.flat = x
        let z = self.dot(y)
        return z.flat
    }
    
    // MARK: - statistics
    public func min(_ axis:Int = -1) -> Double{
        if axis == -1{
            return self.flat.min()
        }
        assert(axis==0 || axis==1, "Axis must be 0 or 1 as matrix only has two dimensions")
        assert(false, "max(x, axis:Int) for maximum of each row is not implemented yet. Use max(A.flat) or A.flat.max() to get the global maximum")

    }
    public func max(_ axis:Int = -1) -> Double{
        if axis == -1 {
            return self.flat.max()
        }
        assert(axis==0 || axis==1, "Axis must be 0 or 1 as matrix only has two dimensions")
        assert(false, "max(x, axis:Int) for maximum of each row is not implemented yet. Use max(A.flat) or A.flat.max() to get the global maximum")
    }
    
    
    // MARK: - debug print
    public var description:String {
        var res = "Matrix((\(shape.0),\(shape.1)), ["
        var printedSpacer = false
        let indent = "   "
        for i in 0..<shape.0{
            res += "\n" + indent

            if shape.0 < 16 || i<4-1 || i>shape.0-4{
                let v = self[i, 0..<shape.1]
                res += v.description
                if i < shape.0-1 { res += "," }
            }
            else if !printedSpacer {
                printedSpacer = true
                res += "\n" + indent + "...,"
            }
        }
        res += "])"
        return res
    }
}

// MARK: -
extension Vector {
    public func reshape(_ shape: (Int,Int)) -> Matrix{
        // reshape to a matrix of size.
        var (mm, nn) = shape
        if mm == -1 {mm = n / nn}
        if nn == -1 {nn = n / mm}
        assert(mm * nn == n, "Number of elements must not change.")
        var y = Matrix(zeros:(mm, nn))
        y.flat = self
        return y
    }
}
