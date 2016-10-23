//
//  Regression.swift
//  swix
//
//  Created by Thomas Kilian on 22.10.16.
//  Copyright © 2016 com.scott. All rights reserved.
//

import XCTest
import SwixO

class SwixTest: XCTestCase {

    let N:Int = 10

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOperators() {
        // l and o similar to 1 and 0
        let l = Vector(ones:N)
        let o = Vector(zeros:N)

        // Similarity
        XCTAssert(l ~== l)
        var mix = o
        mix[0] = 1
        XCTAssert(!(l ~== mix))
        mix[0] = 1e-7
        XCTAssert(l ~== l)

        // PLUS
        XCTAssert((o+1.double) ~== l)
        XCTAssert((1.double+o) ~== l)
        XCTAssert((l+o) ~== l)
        
        // MINUS
        XCTAssert((l - o) ~== l)
        XCTAssert((l - 1) ~== o)
        XCTAssert((1 - o) ~== l)
        
        // MULTIPLY
        XCTAssert(((o+1) * l) ~== l)
        XCTAssert((l * 1) ~== l)
        XCTAssert((1 * l) ~== l)
        
        // DIVIDE
        XCTAssert(((l+1)/2) ~== l)
        XCTAssert((o/l) ~== o)
        XCTAssert((1 / l) ~== l)
        
        // POW
        XCTAssert((Vector(numbers:1, 2, 3)^2) ~== Vector(numbers:1, 4, 9))
        
        // MODULO
        XCTAssert(Vector(numbers:1, 3.14, 2.1)%1.0 ~== Vector(numbers:0, 0.14, 0.1))
        XCTAssert(Vector(numbers:1, 2, 6) % 5 ~== Vector(numbers:1, 2, 1))
    }

    func testComparison(){
        //     true:  <, >, <=, >=, ==, !==
        let x = Vector(numbers:0, 3,  3,  4,  5,  7)
        let y = Vector(numbers:1, 2,  3,  4,  5,  6)
        
        // matrix <op> matrix
        XCTAssert((x < y) ~== Vector(numbers:1, 0, 0, 0, 0, 0))
        XCTAssert((x > y) ~== Vector(numbers:0, 1, 0, 0, 0, 1))
        XCTAssert((x <= y) ~== Vector(numbers:1, 0, 1, 1, 1, 0))
        XCTAssert((x >= y) ~== Vector(numbers:0, 1, 1, 1, 1, 1))
        XCTAssert((x == y) ~== Vector(numbers:0, 0, 1, 1, 1, 0))
        XCTAssert((x !== y) ~== Vector(numbers:1, 1, 0, 0, 0, 1))
        
        // double <op> matrix
        XCTAssert((4 < x) ~== Vector(numbers:0, 0, 0, 0, 1, 1))
        XCTAssert((4 > x) ~== Vector(numbers:1, 1, 1, 0, 0, 0))
        XCTAssert((4 >= x) ~== Vector(numbers:1, 1, 1, 1, 0, 0))
        XCTAssert((4 <= x) ~== Vector(numbers:0, 0, 0, 1, 1, 1))
        
        // matrix <op> ouble
        XCTAssert((x > 4) ~== Vector(numbers:0, 0, 0, 0, 1, 1))
        XCTAssert((x < 4) ~== Vector(numbers:1, 1, 1, 0, 0, 0))
        XCTAssert((x <= 4) ~== Vector(numbers:1, 1, 1, 1, 0, 0))
        XCTAssert((x >= 4) ~== Vector(numbers:0, 0, 0, 1, 1, 1))
    }

    func testFunctions(){
        var x = Vector(numbers:-1, 0, 1)
        
        XCTAssert(x.abs() ~== Vector(numbers:1, 0, 1))
        XCTAssert((x+0.1).sign() ~== Vector(numbers:-1, 1, 1))
        XCTAssert((x+1).sum()     == 3)
        XCTAssert((x+1).cumsum() ~== Vector(numbers:0, 1, 3))
        XCTAssert((x+1).pow(2) ~== Vector(numbers:0, 1, 4))
        XCTAssert(((x+1)^2)   ~== Vector(numbers:0, 1, 4))
        XCTAssert(Vector(ones:4).variance() == 0)
        XCTAssert(Vector(ones:4).std() == 0)
        XCTAssert(x.mean() == 0)
        XCTAssert(abs(Vector(rand:1000).mean() - 0.5) < 0.1)
        XCTAssert(abs(Vector(randn:1000).mean()) < 0.1)
        XCTAssert(abs(Vector(randn:1000).std() - 1) < 0.2)
        var y = Matrix(randn:(100,100))
        XCTAssert(abs(y.flat.mean()) < 0.1)
        y = Matrix(rand:(100, 100))
        XCTAssert(abs(y.flat.mean() - 0.5) < 0.1)
        
        XCTAssert(Vector(numbers:0, 1).`repeat`(2) ~== Vector(numbers:0, 1, 0, 1))
        XCTAssert(Vector(numbers:0, 1).`repeat`(2, axis:1) ~== Vector(numbers:0, 0, 1, 1))
        
        //        var xC = Vector(zerosLike:x)
// copy(vector) as function is not available here
//        var xC = copy(x)
//        XCTAssert(xC ~== x.copy())
//        
        XCTAssert(Matrix("0 1 2; 3 4 5") ~== Vector(arange:6).reshape((2,3)))
        
        var z1 = Vector(numbers:0, 1)
        var z2 = Vector(numbers:2, 3)
        var (z11, z22) = meshgrid(z1, y: z2)
        XCTAssert(z11 ~== Vector(numbers:0, 0, 1, 1).reshape((2,2)))
        XCTAssert(z22 ~== Vector(numbers:2, 3, 2, 3).reshape((2,2)))
        
        //F        XCTAssert(x.min() == min(x))
        XCTAssert(x.min() == -1)
        
        //F        XCTAssert(x.max() == max(x))
        XCTAssert(x.max() == 1)
        
// copy(vector) as function is not available here
//        XCTAssert(x.copy() ~== copy(x))
        XCTAssert(x.copy() ~== Vector(numbers:-1, 0, 1))
        
        XCTAssert(Vector(arange:4).reshape((2,2)).copy() ~== Vector(arange:4).reshape((2,2)))
        
        var z = Vector(numbers:-3, -2, -1, 0, 1, 2, 3)
        XCTAssert(z[(z < 0).argwhere()] ~== Vector(numbers:-3, -2, -1))
        XCTAssert((z < 0) ~== Vector(numbers:1, 1, 1, 0, 0, 0, 0))
        
        XCTAssert((Vector(numbers:1, 2, 3, 4)).sin() ~== Vector(numbers:sin(1), sin(2), sin(3), sin(4)))
        //        func f(x:Double)->Double {return x+1}
        //        XCTAssert(apply_function(f,Vector(arange:100)) ~== (Vector(arange:100)+1))
        var x5 = Vector(arange:5)
        var y5 = Vector(numbers:1, 5, 3, 2, 6)
        XCTAssert(x5.max(y5) ~== Vector(numbers:1, 5, 3, 3, 6))
        XCTAssert(x5.min(y5) ~== Vector(numbers:0, 1, 2, 2, 4))
        
        var mx5 = Vector(arange:4).reshape((2,2))
        var my5 = Vector(numbers:4, 2, 1, 0).reshape((2,2))
        XCTAssert(mx5.min(my5) ~== Vector(numbers:0, 1, 1, 0).reshape((2,2)))
        XCTAssert(y5.reverse() ~== Vector(numbers:6, 2, 3, 5, 1))
        
        XCTAssert(y5.sorted() ~== Vector(numbers:1, 2, 3, 5, 6))
        
        Vector.seed(2)
        var xR = Vector(rand:100)
        Vector.seed(2)
        var yR = Vector(rand:100)
        XCTAssert(((xR - yR).abs()).max() < 1e-6)
        
        func helper_test(){
            let x = Vector(arange:2*3).reshape((2,3))
            XCTAssert(x.fliplr() ~== Vector(numbers:2, 1, 0, 5, 4, 3).reshape((2,3)))
            XCTAssert(x.flipud() ~== Vector(numbers:3, 4, 5, 0, 1, 2).reshape((2,3)))
        }
        helper_test()
    }

    func test2D(){
        var x = Vector(arange:9).reshape((3,3))
        XCTAssert(x.T ~== x.transpose())
        XCTAssert(x.I ~== x.inv())
        XCTAssert(x["diag"] ~== Vector(numbers:0, 4, 8))
        var y = x.copy()
        y["diag"] = Vector(numbers:1, 5, 9)
        XCTAssert(y ~== Vector(numbers:1, 1, 2, 3, 5, 5, 6, 7, 9).reshape((3,3)))
        XCTAssert(Matrix(eye:2) ~== Vector(numbers:1, 0, 0, 1).reshape((2,2)))
        
        XCTAssert(x[0..<2, 0..<2] ~== Vector(numbers:0, 1, 3, 4).reshape((2,2)))
        var z2 = x.copy()
        z2[0..<2, 0..<2] = Vector(numbers:1, 2, 3, 4).reshape((2,2))
        XCTAssert(z2[0..<2, 0..<2] ~== Vector(numbers:1, 2, 3, 4).reshape((2,2)))
        
        XCTAssert(x.flat[Vector(numbers:1, 4, 5, 6)] ~== x[Vector(numbers:1, 4, 5, 6)])
        y = x.copy()
        y[Vector(numbers:1, 4, 5, 6)] = Vector(ones:4)
        XCTAssert(y ~== Vector(numbers:0, 1, 2, 3, 1, 1, 1, 7, 8).reshape((3,3)))
        
        let z = Vector(arange:3*4).reshape((3,4))
        XCTAssert(z.sum(axis:0) ~== Vector(numbers:12, 15, 18, 21))
        XCTAssert(z.sum(axis:1) ~== Vector(numbers:6, 22, 38))
        
        let d1 = x.dot(y)
        let d2 = x.dot(y)
        let d3 = x.dot(y)
        XCTAssert(d1 ~== d2)
        XCTAssert(d1 ~== d3)
    }

    func testMatrix(){
        let x = Matrix(randn:(4,4))
        XCTAssert(Matrix(eye:4).dot(Matrix(eye:4)) ~== Matrix(eye:4))
        XCTAssert(x.dot(x.I) ~== Matrix(eye:4))
        let (u,v) = meshgrid(Vector(numbers:0,1), y: Vector(numbers:2,3))
        XCTAssert(u ~== Vector(numbers:0,1).`repeat`(2).reshape((2,2)).T)
        XCTAssert(v ~== Vector(numbers:2,3).`repeat`(2).reshape((2,2)))
        
        let A = Vector(arange:3*3).reshape((3, 3))
        XCTAssert(abs(A.max() - 8) < 1e-3)
        XCTAssert(abs(A.min() - 0) < 1e-3)
    }

    func testVectorIniting(){
        // testing zeros and array
        XCTAssert(Vector(zeros:4) ~== Vector(numbers:0,0,0,0))
        XCTAssert(Vector(ones:4) ~== (Vector(zeros:4)+1))
        XCTAssert(Vector(zerosLike:Vector(ones:4)) ~== Vector(zeros:4))
        XCTAssert(Vector(arange:4) ~== Vector(numbers:0, 1, 2, 3))
        XCTAssert(Vector(min:2, max: 4) ~== Vector(numbers:2, 3))
        XCTAssert(Vector(min:0, max: 1, num:3) ~== Vector(numbers:0, 0.5, 1))
        XCTAssert(Vector(arange:2).`repeat`(2) ~== Vector(numbers:0,1,0,1))
//        XCTAssert(copy(Vector(arange:4)) ~== Vector(arange:4))
        XCTAssert(Vector(asarray:0..<2) ~== Vector(numbers:0, 1))
//        XCTAssert(copy(Vector(arange:3)) ~== Vector(numbers:0, 1, 2))
        //XCTAssert(sum((Vector(rand:3) - Vector(numbers:0.516, 0.294, 0.727)) < 1e-2) == 3)
        
        let N = 1e4.int
        Vector.seed(42)
        let x = Vector(rand:N)
        
        Vector.seed(42)
        var y = Vector(rand:N)
        XCTAssert(x ~== y)
        
        Vector.seed(29)
        y = Vector(rand:N)
        XCTAssert(!(x ~== y))
        
        Vector.seed(42)
        y = Vector(rand:N)
        XCTAssert(x ~== y)
        
        XCTAssert(abs(x.mean() - 0.5) < 1e-1)
        XCTAssert(abs(x.variance() - 1/12) < 1e-1)
    }
    
    func testVectors(){
        // testing the file vector.swift
        var x_idx = Vector(zeros:4)
        x_idx[0..<2] <- 2
        XCTAssert(x_idx ~== Vector(numbers:2, 2, 0, 0))
        XCTAssert(Vector(arange:4).reshape((2,2)) ~== Matrix("0 1; 2 3"))
        XCTAssert(Vector(arange:4).copy() ~== Vector(arange:4))
        var x = Vector(numbers:4, 2, 3, 1)
        x.sort()
        XCTAssert(x ~== Vector(numbers:1, 2, 3, 4))
        XCTAssert(x.min() == 1)
        XCTAssert(x.max() == 4)
        XCTAssert(x.mean() == 2.5)
        XCTAssert(x["all"] ~== Vector(numbers:1, 2, 3, 4))
        x[0] = 0
        XCTAssert(x[0] == 0)
        x[0..<2] = Vector(numbers:1, 3)
        XCTAssert(x[0..<2] ~== Vector(numbers:1, 3))
        x[Vector(arange:2)] = Vector(numbers:4, 1)
        XCTAssert(x[Vector(arange:2)] ~== Vector(numbers:4, 1))
        
        let y = Vector(numbers:5, 2, 4, 3, 1)
        XCTAssert((y < 2) ~== Vector(numbers:0, 0, 0, 0, 1))
        XCTAssert(y.reverse() ~== Vector(numbers:1, 3, 4, 2, 5))
        XCTAssert(y.sorted() ~== Vector(numbers:1, 2, 3, 4, 5))
        XCTAssert(y.delete(idx: Vector(numbers:0, 1)) ~== Vector(numbers:4, 3, 1))
        XCTAssert(Vector(asarray:[0, 1, 2]) ~== Vector(numbers:0, 1, 2))
        XCTAssert(Vector(asarray:0..<2) ~== Vector(numbers:0, 1))
        XCTAssert(Vector(numbers:1, 2).concat(Vector(numbers:3, 4)) ~== (Vector(arange:4)+1))
        XCTAssert(y.clip(a_min: 2, a_max: 4) ~== Vector(numbers:4, 2, 4, 3, 2))
        XCTAssert(y.delete(idx: Vector(numbers:0, 1)) ~== Vector(numbers:4,3,1))
        XCTAssert(Vector(numbers:0,1).`repeat`(2) ~== Vector(numbers:0,1,0,1))
        XCTAssert(Vector(numbers:0, 1).`repeat`(2, axis:1) ~== Vector(numbers:0,0,1,1))
        XCTAssert(Vector(numbers:1,4,2,5).argmax() == 3)
        XCTAssert(Vector(numbers:1,4,2,5).argmin() == 0)
        XCTAssert(Vector(numbers:1,4,2,5).argsort() ~== Vector(numbers:0, 2, 1, 3))
        
        XCTAssert(Vector(arange:4) ~== Vector(numbers:0, 1, 2, 3))
        let xO = Vector(numbers:1, 2, 3)
        let yO = Vector(numbers:1, 2, 3) + 3
        XCTAssert(outer(xO, y: yO) ~== Vector(numbers:4, 5, 6, 8, 10, 12, 12, 15, 18).reshape((3,3)))
        let xR1 = Vector(numbers:1.1, 1.2, 1.3)
        let xR2 = Vector(numbers:1, 1, 1)
        XCTAssert(xR1.remainder(xR2) ~== Vector(numbers:0.1, 0.2, 0.3))
        XCTAssert(xR1 % 1.0 ~== Vector(numbers:0.1, 0.2, 0.3))
        XCTAssert(1.0 % xR1 ~== Vector(ones:3))
        XCTAssert(Vector(arange:4)[-1] == 3.0)
        
        let xR = Vector(arange:4*4).reshape((4,4))
        XCTAssert(xR.rank() == 2.0)
        
        XCTAssert(Vector(numbers:1,2,3,4).pow(2) ~== Vector(numbers:1,4,9,16))
        XCTAssert((Vector(ones:4)*2).pow(Vector(ones:4)*2) ~== Vector(numbers:4, 4, 4, 4))
        XCTAssert((-1).pow(Vector(numbers:1, 2, 3, 4)) ~== Vector(numbers:-1, 1, -1, 1))
        XCTAssert(Vector(numbers:1,1,1).norm(ord:2) == sqrt(3))
        XCTAssert(Vector(numbers:1,0,1).norm(ord:1) == 2)
        XCTAssert(Vector(numbers:4,0,0).norm(ord:0) == 1)
        XCTAssert(Vector(numbers:4,0,0).norm(ord:-1) == 4)
        XCTAssert(Vector(numbers:4,2,-3).norm(ord:inf) == 4)
        XCTAssert(Vector(numbers:4,2,-3).norm(ord:-inf) == 2)
        
        XCTAssert(Vector(numbers:-3, 4, 5).sign() ~== Vector(numbers:-1, 1, 1))
        XCTAssert(Vector(numbers:1.1, 1.2, 1.6).floor() ~== Vector(numbers:1, 1, 1))
        XCTAssert(Vector(numbers:1.1, 1.2, 1.6).round() ~== Vector(numbers:1, 1, 2))
        XCTAssert(Vector(numbers:1.2, 1.5, 1.8).ceil() ~== Vector(ones:3)*2)
        XCTAssert((Vector(ones:4) * 10).log10() ~== Vector(ones:4))
        XCTAssert((Vector(ones:4) * 2).log2() ~== Vector(ones:4))
        XCTAssert((Vector(ones:4) * e).log() ~== Vector(ones:4))
        XCTAssert((Vector(ones:4)*2).exp2() ~== Vector(ones:4) * 4)
        XCTAssert((Vector(ones:4)*2).exp() ~== Vector(ones:4)*e*e)
    }


    func testNumbers(){
        XCTAssert(close(0, y: 1e-10) == true)
        XCTAssert(close(0, y: 1e-10) == (1e-10 ~= 0))
        XCTAssert(rad2deg(pi/2) == 90)
        XCTAssert(deg2rad(90) == pi/2)
        XCTAssert(max(0, 1) == 1)
        XCTAssert(min(0, 1) == 0)
        XCTAssert("3.14".floatValue == Float(3.14))
        XCTAssert(3 / 4 == 0.75)
        XCTAssert(3.25 / 4 == 0.8125)
        XCTAssert(isNumber(3))
        XCTAssert(!isNumber(Vector(zeros:2)))
        //        XCTAssert(!isNumber("3.14"))
    }  

    func testSetTheory(){
        func in1d_test(){
            let test = Vector(numbers:0, 1, 2, 5, 0)
            let states = Vector(numbers:0, 2)
            let mask = test.in1d(states)
            XCTAssert(mask ~== Vector(numbers:1, 0, 1, 0, 1))
        }
        func intersection_test(){
            let x = Vector(numbers:1, 2, 3, 4, -1, -1)
            let y = Vector(numbers:1, 2, 3, 5, -1, -1)
            let a = x.intersection(y)
            let b = x.union(y)
            XCTAssert(a ~== Vector(numbers:-1, 1, 2, 3))
            XCTAssert(b ~== Vector(numbers:-1, 1, 2, 3, 4, 5))
        }
        in1d_test()
        intersection_test()
    }

    func testComplex(){
        func scalar_test(){
            let x:Int = 1
            let y:Double = 4
            let z:Double = x + y
            XCTAssert(z == 5)
//            print("Int(1)+Double(1)==2 through ScalarArithmetic")
        }
        func swift_complex_test(){
            //            var x = 1.0 + 1.0.i
            //            XCTAssert(abs(x) == sqrt(2))
            //            print("scalar (not vector) complex number usage works using swift-complex.")
        }
        func range_test(){
            var x = Vector(arange:4)
            let y = x[0..<2]
            XCTAssert(y ~== Vector(arange:2))
            
            var z = Vector(zeros:4)
            z[0..<2] = Vector(ones:2)
            XCTAssert(z ~== Vector(numbers:1, 1, 0, 0))
//            print("x[0..<2] = Vector(ones:2) and y = z[3..<8] works in the 1d case!")
        }
        func argwhere_test(){
            var x = Vector(zeros:N)
            let y = Vector(zeros:N)
            x[0..<5] = Vector(ones:5)
            let i = ((x-y).abs() < 1e-9).argwhere()
            XCTAssert(i ~== Vector(numbers:5, 6, 7, 8, 9))
            x[(x<2).argwhere()] = Vector(ones:(x<2).argwhere().n)
            XCTAssert(x ~== Vector(ones:N))
//            print("can use argwhere. x[argwhere(x<2)]=Vector(zeros:argwhere(x<2).n)  works for both 1d and 2d.")
        }
        func matrix2d_indexing_test(){
            var x = Matrix("1 2 3; 4 5 6; 7 8 9")
            x[0..<2, 0..<2] = Matrix("4 3; 2 6")
            XCTAssert(x ~== Matrix("4 3 3; 2 6 6; 7 8 9"))
//            print("can use x[1, 0..<2] or x[0..<2, 0..<2] to also index")
        }
        func matrix2d_indexing_matrix_test(){
            var x = Matrix("1 2 3; 4 5 6; 7 8 9")
            XCTAssert(x[Vector(numbers:0, 1, 2, 3, 4, 5)] ~== Vector(numbers:1, 2, 3, 4, 5, 6))
//            print("x[vector] works and indexes the vector row first")
        }
        func fft_test(){
            let x = Vector(arange:8)
            let (yr, yi) = fft(x)
            let x2 = ifft(yr, yi: yi)
            XCTAssert(x2 ~== x)
//            print("fft/ifft works. fft(x) -> (yreal, yimag)")
        }
        func dot_test(){
            let x = Matrix(eye:3) * 2
            let y = Matrix("1 2 3 1; 4 5 6 1; 7 8 9 1")
            XCTAssert((x.dot(y)) ~== 2*y)
//            print("dot product works with dot(x, y) or x *! y")
            
            let xA = Vector(ones:3)
            let A = Vector(arange:3*3).reshape((3, 3))
            let yA1 = A.dot(xA)
            let yA2 = A.dot(xA)
            XCTAssert(yA1 ~== Vector(numbers:3, 12, 21))
            XCTAssert(yA1 ~== yA2)
        }
        func svd_test(){
            let x = Matrix("1 2; 4 8; 3 5")
            let (uX,sigmaX,vX) = x.svd()
            XCTAssert(uX.flat ~== Vector(asarray:[-0.20505409130750663, -0.12952354631423885, -0.9701425001453321, -0.82021636523002739, -0.51809418525696493, 0.24253562503633197, -0.53403926245819699, 0.84545967742589923, 1.8318679906315083e-15]))
            XCTAssert (sigmaX ~== Vector(asarray:[10.902154417681611, 0.37819182041034177]))
            XCTAssert (vX.flat ~== Vector(asarray:[-0.46670017178899953, -0.88441559781141255, 0.88441559781141255, -0.46670017178899953]))

            let y = Matrix("1 2 3; 4 5 6")
            _ = y.svd() // no further verification needed; computaion passes
            
            let z = Matrix("1 2 3; 4 5 6; 7 8 9")
            _ = z.svd()
            
//            print("svd works and tested by hand for square, fat and skinny matrices against Python")
        }
        func svm_test(){
            let svm = SVM()
            let x = Vector(arange:4*2).reshape((4, 2))
            let y = Vector(numbers:0, 1, 2, 3)
            
            svm.train(x, y)
            let z = svm.predict(Vector(numbers:2, 3))
            XCTAssert(z == y[1])
//            print("svm works via simple test")
        }
        func inv_test(){
            let x = Matrix(randn:(4,4))
            let y = x.inv()
            XCTAssert((x.dot(y)) ~== Matrix(eye:4))
//            print("matrix inversion works")
        }
        func solve_test(){
            let A0 = Vector(numbers:1, 2, 3, 4, 2, 1, 4, 6, 7)
            let A = A0.reshape((3, 3))
            let b = Vector(numbers:1, 2, 5)
            _ = A.solve(b)
            XCTAssert((A !/ b) ~== A.solve(b))
//            print("solve works, similar to Matlab's \\ operator (and checked by hand). Be careful -- this only works for nxn matrices")
        }
        func eig_test(){
            var x = Matrix(zeros:(3,3))
            x["diag"] = Vector(numbers:1, 2, 3)
            let r = x.eig()
            XCTAssert(r ~== Vector(numbers:1, 2, 3))
//            print("`eig` returns the correct eigenvalues and no eigenvectors.")
        }
        func pinv_test(){
            let x = Vector(arange:3*4).reshape((3,4))
            let y = x.pinv()
            XCTAssert(x.dot(y).dot(x) ~== x)
            XCTAssert(x.pI ~== x.pinv())
//            print("pseudo-inverse works")
        }
        swift_complex_test()
        scalar_test()
        range_test()
        argwhere_test()
        matrix2d_indexing_test()
        matrix2d_indexing_matrix_test()
        fft_test()
        dot_test()
        svd_test()
        svm_test()
        inv_test()
        solve_test()
        eig_test()
        pinv_test()
    }

    func testCsvIO(){
        let header = ["1", "2", "3"]
        let data = Matrix(eye:3)
        
        let csv = CSVFile(data:data, header:header)
        
        let filename = "/tmp/test_2016.csv"
        
        write_csv(csv, filename:filename)
        let y:CSVFile = read_csv(filename, header_present:true)
        
        XCTAssert(y.data ~== data)

        let x1 = Vector(arange:9).reshape((3,3)) * 2
        write_csv(x1, filename: "/tmp/image.csv")
        let y1:Matrix = read_csv("/tmp/image.csv", header_present:false).data
        XCTAssert(x1 ~== y1)
        
        let x2 = Vector(numbers:1, 2, 3, 4, 5, 2, 1)
        write_csv(x2, filename:"/tmp/vector.csv")
        let y2:Vector = read_csv("/tmp/vector.csv")
        XCTAssert(x2 ~== y2)
        
        let x3 = Vector(numbers:1, 5, 3, 1, 0, -10) * pi
        write_binary(x3, filename:"/tmp/x3.npy")
        let y3:Vector = read_binary("/tmp/x3.npy")
        XCTAssert(y3 ~== x3)
        
        let x4 = Vector(arange:9).reshape((3,3))
        write_binary(x4, filename:"/tmp/x4.npy")
        let y4:Matrix = read_binary("/tmp/x4.npy")
        XCTAssert(y4 ~== x4)
    }

    func testProjectEuler1() {
        self.measure {
            let N = 1e6
            let x = Vector(arange:N)
            // seeing where that modulo is 0
            _ = (((x%3).abs() < 1e-9) || ((x%5).abs() < 1e-9)).argwhere()
            // println(sum(x[i]))
            // prints 233168.0, the correct answer
        }
    }

    func testProjectEuler10() {
        self.measure {
            // find all primes
            let N = 2e6.int
            var primes = Vector(arange:Double(N))
            let top = (sqrt(N.double)).int
            for i in 2 ..< top{
                let max:Int = (N/i)
                let j = Vector(min:2, max: max.double) * i.double
                primes[j] *= 0.0
            }
            // sum(primes) is the correct answer
        }
    }

    func testProjectEuler73() {
        self.measure {
            let N = 1e3
            let i = Vector(arange:N)+1
            let (n, d) = meshgrid(i, y: i)
            
            var f = (n / d).flat
            f = f.unique()
            _ = (f > 1/3) && (f < 1/2)
            // println(f[argwhere(j)].n)
        }
    }

    func testSoftThresholding() {
        self.measure {
            let N = 1e2.int
            let j = Vector(min:-1, max: 1, num:N)
            let (x, y) = meshgrid(j, y: j)
            var z = x.pow(2) + y.pow(2)
            let i = z.abs() < 0.5
            z[i.argwhere()] *= 0
            z[(1-i).argwhere()] -= 0.5
        }
    }

    func testPiApprox() {
        self.measure {
            let N = 1e6
            var k = Vector(arange:N)
            var pi_approx = 1 / (2*k + 1)
            pi_approx[2*k[0..<(N/2).int]+1] *= -1
            // println(4 * pi_approx)
            // prints 3.14059265383979
        }
    }
}
