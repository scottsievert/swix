//
//  Regression.swift
//  swix
//
//  Created by Thomas Kilian on 22.10.16.
//  Copyright © 2016 com.scott. All rights reserved.
//

import XCTest

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
        let l = ones(N)
        let o = zeros(N)

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
        XCTAssert((array(1, 2, 3)^2) ~== array(1, 4, 9))
        
        // MODULO
        XCTAssert(array(1, 3.14, 2.1)%1.0 ~== array(0, 0.14, 0.1))
        XCTAssert(array(1, 2, 6) % 5 ~== array(1, 2, 1))
        print("ok")
    }

    func testComparison(){
        //     true:  <, >, <=, >=, ==, !==
        let x = array(0, 3,  3,  4,  5,  7)
        let y = array(1, 2,  3,  4,  5,  6)
        
        // matrix <op> matrix
        XCTAssert((x < y) ~== array(1, 0, 0, 0, 0, 0))
        XCTAssert((x > y) ~== array(0, 1, 0, 0, 0, 1))
        XCTAssert((x <= y) ~== array(1, 0, 1, 1, 1, 0))
        XCTAssert((x >= y) ~== array(0, 1, 1, 1, 1, 1))
        XCTAssert((x == y) ~== array(0, 0, 1, 1, 1, 0))
        XCTAssert((x !== y) ~== array(1, 1, 0, 0, 0, 1))
        
        // double <op> matrix
        XCTAssert((4 < x) ~== array(0, 0, 0, 0, 1, 1))
        XCTAssert((4 > x) ~== array(1, 1, 1, 0, 0, 0))
        XCTAssert((4 >= x) ~== array(1, 1, 1, 1, 0, 0))
        XCTAssert((4 <= x) ~== array(0, 0, 0, 1, 1, 1))
        
        // matrix <op> ouble
        XCTAssert((x > 4) ~== array(0, 0, 0, 0, 1, 1))
        XCTAssert((x < 4) ~== array(1, 1, 1, 0, 0, 0))
        XCTAssert((x <= 4) ~== array(1, 1, 1, 1, 0, 0))
        XCTAssert((x >= 4) ~== array(0, 0, 0, 1, 1, 1))
    }

    func testFunctions(){
        var x = array(-1, 0, 1)
        
        XCTAssert(abs(x) ~== array(1, 0, 1))
        XCTAssert(sign(x+0.1) ~== array(-1, 1, 1))
        XCTAssert(sum(x+1)     == 3)
        XCTAssert(cumsum(x+1) ~== array(0, 1, 3))
        XCTAssert(pow(x+1, power: 2) ~== array(0, 1, 4))
        XCTAssert(((x+1)^2)   ~== array(0, 1, 4))
        XCTAssert(variance(ones(4)) == 0)
        XCTAssert(std(ones(4)) == 0)
        XCTAssert(mean(x) == 0)
        XCTAssert(abs(mean(rand(1000)) - 0.5) < 0.1)
        XCTAssert(abs(mean(randn(1000))) < 0.1)
        XCTAssert(abs(std(randn(1000)) - 1) < 0.2)
        var y = randn((100,100))
        XCTAssert(abs(mean(y.flat)) < 0.1)
        y = rand((100, 100))
        XCTAssert(abs(mean(y.flat) - 0.5) < 0.1)
        
        XCTAssert(`repeat`(array(0, 1), N: 2) ~== array(0, 1, 0, 1))
        XCTAssert(`repeat`(array(0, 1), N: 2, axis:1) ~== array(0, 0, 1, 1))
        
        //        var xC = zeros_like(x)
// copy(vector) as function is not available here
//        var xC = copy(x)
//        XCTAssert(xC ~== x.copy())
//        
        XCTAssert(array("0 1 2; 3 4 5") ~== arange(6).reshape((2,3)))
        
        var z1 = array(0, 1)
        var z2 = array(2, 3)
        var (z11, z22) = meshgrid(z1, y: z2)
        XCTAssert(z11 ~== array(0, 0, 1, 1).reshape((2,2)))
        XCTAssert(z22 ~== array(2, 3, 2, 3).reshape((2,2)))
        
        XCTAssert(x.min() == min(x))
        XCTAssert(x.min() == -1)
        
        XCTAssert(x.max() == max(x))
        XCTAssert(x.max() == 1)
        
// copy(vector) as function is not available here
//        XCTAssert(x.copy() ~== copy(x))
        XCTAssert(x.copy() ~== array(-1, 0, 1))
        
        XCTAssert(arange(4).reshape((2,2)).copy() ~== arange(4).reshape((2,2)))
        
        var z = array(-3, -2, -1, 0, 1, 2, 3)
        XCTAssert(z[argwhere(z < 0)] ~== array(-3, -2, -1))
        XCTAssert((z < 0) ~== array(1, 1, 1, 0, 0, 0, 0))
        
        XCTAssert(sin(array(1, 2, 3, 4)) ~== array(sin(1), sin(2), sin(3), sin(4)))
        //        func f(x:Double)->Double {return x+1}
        //        XCTAssert(apply_function(f,arange(100)) ~== (arange(100)+1))
        var x5 = arange(5)
        var y5 = array(1, 5, 3, 2, 6)
        XCTAssert(max(x5, y: y5) ~== array(1, 5, 3, 3, 6))
        XCTAssert(min(x5, y: y5) ~== array(0, 1, 2, 2, 4))
        
        var mx5 = arange(4).reshape((2,2))
        var my5 = array(4, 2, 1, 0).reshape((2,2))
        XCTAssert(min(mx5, y: my5) ~== array(0, 1, 1, 0).reshape((2,2)))
        XCTAssert(reverse(y5) ~== array(6, 2, 3, 5, 1))
        
        XCTAssert(sort(y5) ~== array(1, 2, 3, 5, 6))
        
        seed(2)
        var xR = rand(100)
        seed(2)
        var yR = rand(100)
        XCTAssert(max(abs(xR - yR)) < 1e-6)
        
        func helper_test(){
            let x = arange(2*3).reshape((2,3))
            XCTAssert(fliplr(x) ~== array(2, 1, 0, 5, 4, 3).reshape((2,3)))
            XCTAssert(flipud(x) ~== array(3, 4, 5, 0, 1, 2).reshape((2,3)))
        }
        helper_test()
    }

    func test2D(){
        var x = arange(9).reshape((3,3))
        XCTAssert(x.T ~== transpose(x))
        XCTAssert(x.I ~== inv(x))
        XCTAssert(x["diag"] ~== array(0, 4, 8))
        var y = x.copy()
        y["diag"] = array(1, 5, 9)
        XCTAssert(y ~== array(1, 1, 2, 3, 5, 5, 6, 7, 9).reshape((3,3)))
        XCTAssert(eye(2) ~== array(1, 0, 0, 1).reshape((2,2)))
        
        XCTAssert(x[0..<2, 0..<2] ~== array(0, 1, 3, 4).reshape((2,2)))
        var z2 = x.copy()
        z2[0..<2, 0..<2] = array(1, 2, 3, 4).reshape((2,2))
        XCTAssert(z2[0..<2, 0..<2] ~== array(1, 2, 3, 4).reshape((2,2)))
        
        XCTAssert(x.flat[array(1, 4, 5, 6)] ~== x[array(1, 4, 5, 6)])
        y = x.copy()
        y[array(1, 4, 5, 6)] = ones(4)
        XCTAssert(y ~== array(0, 1, 2, 3, 1, 1, 1, 7, 8).reshape((3,3)))
        
        let z = arange(3*4).reshape((3,4))
        XCTAssert(sum(z, axis:0) ~== array(12, 15, 18, 21))
        XCTAssert(sum(z, axis:1) ~== array(6, 22, 38))
        
        let d1 = x.dot(y)
        let d2 = x.dot(y)
        let d3 = dot(x, y: y)
        XCTAssert(d1 ~== d2)
        XCTAssert(d1 ~== d3)
    }

    func testMatrix(){
        let x = randn((4,4))
        XCTAssert(eye(4).dot(eye(4)) ~== eye(4))
        XCTAssert(x.dot(x.I) ~== eye(4))
        let (u,v) = meshgrid(array(0,1), y: array(2,3))
        XCTAssert(u ~== `repeat`(array(0,1), N: 2).reshape((2,2)).T)
        XCTAssert(v ~== `repeat`(array(2,3), N: 2).reshape((2,2)))
        
        let A = arange(3*3).reshape((3, 3))
        XCTAssert(abs(A.max() - 8) < 1e-3)
        XCTAssert(abs(A.min() - 0) < 1e-3)
    }

    func testVectorIniting(){
        // testing zeros and array
        XCTAssert(zeros(4) ~== array(0,0,0,0))
        XCTAssert(ones(4) ~== (zeros(4)+1))
        XCTAssert(zeros_like(ones(4)) ~== zeros(4))
        XCTAssert(arange(4) ~== array(0, 1, 2, 3))
        XCTAssert(arange(2, max: 4) ~== array(2, 3))
        XCTAssert(linspace(0,max: 1,num:3) ~== array(0, 0.5, 1))
        XCTAssert(`repeat`(arange(2), N: 2) ~== array(0,1,0,1))
//        XCTAssert(copy(arange(4)) ~== arange(4))
        XCTAssert(asarray(0..<2) ~== array(0, 1))
//        XCTAssert(copy(arange(3)) ~== array(0, 1, 2))
        //XCTAssert(sum((rand(3) - array(0.516, 0.294, 0.727)) < 1e-2) == 3)
        
        let N = 1e4.int
        seed(42)
        let x = rand(N)
        
        seed(42)
        var y = rand(N)
        XCTAssert(x ~== y)
        
        seed(29)
        y = rand(N)
        XCTAssert(!(x ~== y))
        
        seed(42)
        y = rand(N)
        XCTAssert(x ~== y)
        
        XCTAssert(abs(x.mean() - 0.5) < 1e-1)
        XCTAssert(abs(variance(x) - 1/12) < 1e-1)
    }
    
    func testVectors(){
        // testing the file vector.swift
        var x_idx = zeros(4)
        x_idx[0..<2] <- 2
        XCTAssert(x_idx ~== array(2, 2, 0, 0))
        XCTAssert(arange(4).reshape((2,2)) ~== array("0 1; 2 3"))
        XCTAssert(arange(4).copy() ~== arange(4))
        var x = array(4, 2, 3, 1)
        x.sort()
        XCTAssert(x ~== array(1, 2, 3, 4))
        XCTAssert(x.min() == 1)
        XCTAssert(x.max() == 4)
        XCTAssert(x.mean() == 2.5)
        XCTAssert(x["all"] ~== array(1, 2, 3, 4))
        x[0] = 0
        XCTAssert(x[0] == 0)
        x[0..<2] = array(1, 3)
        XCTAssert(x[0..<2] ~== array(1, 3))
        x[arange(2)] = array(4, 1)
        XCTAssert(x[arange(2)] ~== array(4, 1))
        
        let y = array(5, 2, 4, 3, 1)
        XCTAssert((y < 2) ~== array(0, 0, 0, 0, 1))
        XCTAssert(reverse(y) ~== array(1, 3, 4, 2, 5))
        XCTAssert(sort(y) ~== array(1, 2, 3, 4, 5))
        XCTAssert(delete(y, idx: array(0, 1)) ~== array(4, 3, 1))
        XCTAssert(asarray([0, 1, 2]) ~== array(0, 1, 2))
        XCTAssert(asarray(0..<2) ~== array(0, 1))
        XCTAssert(concat(array(1, 2), y: array(3, 4)) ~== (arange(4)+1))
        XCTAssert(clip(y, a_min: 2, a_max: 4) ~== array(4, 2, 4, 3, 2))
        XCTAssert(delete(y, idx: array(0, 1)) ~== array(4,3,1))
        XCTAssert(`repeat`(array(0,1),N: 2) ~== array(0,1,0,1))
        XCTAssert(`repeat`(array(0, 1),N:2, axis:1) ~== array(0,0,1,1))
        XCTAssert(argmax(array(1,4,2,5)) == 3)
        XCTAssert(argmin(array(1,4,2,5)) == 0)
        XCTAssert(argsort(array(1,4,2,5)) ~== array(0, 2, 1, 3))
        
        XCTAssert(arange(4) ~== array(0, 1, 2, 3))
        let xO = array(1, 2, 3)
        let yO = array(1, 2, 3) + 3
        XCTAssert(outer(xO, y: yO) ~== array(4, 5, 6, 8, 10, 12, 12, 15, 18).reshape((3,3)))
        let xR1 = array(1.1, 1.2, 1.3)
        let xR2 = array(1, 1, 1)
        XCTAssert(remainder(xR1, x2: xR2) ~== array(0.1, 0.2, 0.3))
        XCTAssert(xR1 % 1.0 ~== array(0.1, 0.2, 0.3))
        XCTAssert(1.0 % xR1 ~== ones(3))
        XCTAssert(arange(4)[-1] == 3.0)
        
        let xR = arange(4*4).reshape((4,4))
        XCTAssert(rank(xR) == 2.0)
        
        XCTAssert(pow(array(1,2,3,4), power: 2) ~== array(1,4,9,16))
        XCTAssert(pow(ones(4)*2, y: ones(4)*2) ~== array(4, 4, 4, 4))
        XCTAssert(pow(-1, y: array(1, 2, 3, 4)) ~== array(-1, 1, -1, 1))
        XCTAssert(norm(array(1,1,1), ord:2) == sqrt(3))
        XCTAssert(norm(array(1,0,1), ord:1) == 2)
        XCTAssert(norm(array(4,0,0), ord:0) == 1)
        XCTAssert(norm(array(4,0,0), ord:-1) == 4)
        XCTAssert(norm(array(4,2,-3), ord:inf) == 4)
        XCTAssert(norm(array(4,2,-3), ord:-inf) == 2)
        
        XCTAssert(sign(array(-3, 4, 5)) ~== array(-1, 1, 1))
        XCTAssert(floor(array(1.1, 1.2, 1.6)) ~== array(1, 1, 1))
        XCTAssert(round(array(1.1, 1.2, 1.6)) ~== array(1, 1, 2))
        XCTAssert(ceil(array(1.2, 1.5, 1.8)) ~== ones(3)*2)
        XCTAssert(log10(ones(4) * 10) ~== ones(4))
        XCTAssert(log2(ones(4) * 2) ~== ones(4))
        XCTAssert(log(ones(4) * e) ~== ones(4))
        XCTAssert(exp2(ones(4)*2) ~== ones(4) * 4)
        XCTAssert(exp(ones(4)*2) ~== ones(4)*e*e)
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
        XCTAssert(!isNumber(zeros(2)))
        //        XCTAssert(!isNumber("3.14"))
    }  

    func testSetTheory(){
        func in1d_test(){
            let test = array(0, 1, 2, 5, 0)
            let states = array(0, 2)
            let mask = in1d(test, y:states)
            XCTAssert(mask ~== array(1, 0, 1, 0, 1))
        }
        func intersection_test(){
            let x = array(1, 2, 3, 4, -1, -1)
            let y = array(1, 2, 3, 5, -1, -1)
            let a = intersection(x, y:y)
            let b = union(x, y:y)
            XCTAssert(a ~== array(-1, 1, 2, 3))
            XCTAssert(b ~== array(-1, 1, 2, 3, 4, 5))
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
            var x = arange(4)
            let y = x[0..<2]
            XCTAssert(y ~== arange(2))
            
            var z = zeros(4)
            z[0..<2] = ones(2)
            XCTAssert(z ~== array(1, 1, 0, 0))
//            print("x[0..<2] = ones(2) and y = z[3..<8] works in the 1d case!")
        }
        func argwhere_test(){
            var x = zeros(N)
            let y = zeros(N)
            x[0..<5] = ones(5)
            let i = argwhere(abs(x-y) < 1e-9)
            XCTAssert(i ~== array(5, 6, 7, 8, 9))
            x[argwhere(x<2)] = ones(argwhere(x<2).n)
            XCTAssert(x ~== ones(N))
//            print("can use argwhere. x[argwhere(x<2)]=zeros(argwhere(x<2).n)  works for both 1d and 2d.")
        }
        func matrix2d_indexing_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            x[0..<2, 0..<2] = array("4 3; 2 6")
            XCTAssert(x ~== array("4 3 3; 2 6 6; 7 8 9"))
//            print("can use x[1, 0..<2] or x[0..<2, 0..<2] to also index")
        }
        func matrix2d_indexing_matrix_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            XCTAssert(x[array(0, 1, 2, 3, 4, 5)] ~== array(1, 2, 3, 4, 5, 6))
//            print("x[vector] works and indexes the vector row first")
        }
        func fft_test(){
            let x = arange(8)
            let (yr, yi) = fft(x)
            let x2 = ifft(yr, yi: yi)
            XCTAssert(x2 ~== x)
//            print("fft/ifft works. fft(x) -> (yreal, yimag)")
        }
        func dot_test(){
            let x = eye(3) * 2
            let y = array("1 2 3 1; 4 5 6 1; 7 8 9 1")
            XCTAssert((x.dot(y)) ~== 2*y)
//            print("dot product works with dot(x, y) or x *! y")
            
            let xA = ones(3)
            let A = arange(3*3).reshape((3, 3))
            let yA1 = A.dot(xA)
            let yA2 = dot(A, x: xA)
            XCTAssert(yA1 ~== array(3, 12, 21))
            XCTAssert(yA1 ~== yA2)
        }
        func svd_test(){
            let x = array("1 2; 4 8; 3 5")
            let (uX,sigmaX,vX) = svd(x)
            XCTAssert(uX.flat ~== asarray([-0.20505409130750663, -0.12952354631423885, -0.9701425001453321, -0.82021636523002739, -0.51809418525696493, 0.24253562503633197, -0.53403926245819699, 0.84545967742589923, 1.8318679906315083e-15]))
            XCTAssert (sigmaX ~== asarray([10.902154417681611, 0.37819182041034177]))
            XCTAssert (vX.flat ~== asarray([-0.46670017178899953, -0.88441559781141255, 0.88441559781141255, -0.46670017178899953]))

            let y = array("1 2 3; 4 5 6")
            _ = svd(y) // no further verification needed; computaion passes
            
            let z = array("1 2 3; 4 5 6; 7 8 9")
            _ = svd(z)
            
//            print("svd works and tested by hand for square, fat and skinny matrices against Python")
        }
        func svm_test(){
            let svm = SVM()
            let x = reshape(arange(4*2) , shape: (4, 2))
            let y = array(0, 1, 2, 3)
            
            svm.train(x, y)
            let z = svm.predict(array(2, 3))
            XCTAssert(z == y[1])
//            print("svm works via simple test")
        }
        func inv_test(){
            let x = randn((4,4))
            let y = inv(x)
            XCTAssert((x.dot(y)) ~== eye(4))
//            print("matrix inversion works")
        }
        func solve_test(){
            let A0 = array(1, 2, 3, 4, 2, 1, 4, 6, 7)
            let A = reshape(A0, shape: (3, 3))
            let b = array(1, 2, 5)
            _ = solve(A, b: b)
            XCTAssert((A !/ b) ~== solve(A, b: b))
//            print("solve works, similar to Matlab's \\ operator (and checked by hand). Be careful -- this only works for nxn matrices")
        }
        func eig_test(){
            var x = zeros((3,3))
            x["diag"] = array(1, 2, 3)
            let r = eig(x)
            XCTAssert(r ~== array(1, 2, 3))
//            print("`eig` returns the correct eigenvalues and no eigenvectors.")
        }
        func pinv_test(){
            let x = arange(3*4).reshape((3,4))
            let y = pinv(x)
            XCTAssert(x.dot(y).dot(x) ~== x)
            XCTAssert(x.pI ~== pinv(x))
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
        let data = eye(3)
        
        let csv = CSVFile(data:data, header:header)
        
        let filename = "/tmp/test_2016.csv"
        
        write_csv(csv, filename:filename)
        let y:CSVFile = read_csv(filename, header_present:true)
        
        XCTAssert(y.data ~== data)
        print(y.header == header)

        let x1 = arange(9).reshape((3,3)) * 2
        write_csv(x1, filename: "/tmp/image.csv")
        let y1:matrix = read_csv("/tmp/image.csv", header_present:false).data
        XCTAssert(x1 ~== y1)
        
        let x2 = array(1, 2, 3, 4, 5, 2, 1)
        write_csv(x2, filename:"/tmp/vector.csv")
        let y2:vector = read_csv("/tmp/vector.csv")
        XCTAssert(x2 ~== y2)
        
        let x3 = array(1, 5, 3, 1, 0, -10) * pi
        write_binary(x3, filename:"/tmp/x3.npy")
        let y3:vector = read_binary("/tmp/x3.npy")
        XCTAssert(y3 ~== x3)
        
        let x4 = arange(9).reshape((3,3))
        write_binary(x4, filename:"/tmp/x4.npy")
        let y4:matrix = read_binary("/tmp/x4.npy")
        XCTAssert(y4 ~== x4)
    }

    func testProjectEuler1() {
        self.measure {
            let N = 1e6
            let x = arange(N)
            // seeing where that modulo is 0
            _ = argwhere((abs(x%3) < 1e-9) || (abs(x%5) < 1e-9))
            // println(sum(x[i]))
            // prints 233168.0, the correct answer
        }
    }

    func testProjectEuler10() {
        self.measure {
            // find all primes
            let N = 2e6.int
            var primes = arange(Double(N))
            let top = (sqrt(N.double)).int
            for i in 2 ..< top{
                let max:Int = (N/i)
                let j = arange(2, max: max.double) * i.double
                primes[j] *= 0.0
            }
            // sum(primes) is the correct answer
        }
    }

    func testProjectEuler73() {
        self.measure {
            let N = 1e3
            let i = arange(N)+1
            let (n, d) = meshgrid(i, y: i)
            
            var f = (n / d).flat
            f = unique(f)
            _ = (f > 1/3) && (f < 1/2)
            // println(f[argwhere(j)].n)
        }
    }

    func testSoftThresholding() {
        self.measure {
            let N = 1e2.int
            let j = linspace(-1, max: 1, num:N)
            let (x, y) = meshgrid(j, y: j)
            var z = pow(x, power: 2) + pow(y, power: 2)
            let i = abs(z) < 0.5
            z[argwhere(i)] *= 0
            z[argwhere(1-i)] -= 0.5
        }
    }

    func testPiApprox() {
        self.measure {
            let N = 1e6
            var k = arange(N)
            var pi_approx = 1 / (2*k + 1)
            pi_approx[2*k[0..<(N/2).int]+1] *= -1
            // println(4 * pi_approx)
            // prints 3.14059265383979
        }
    }
}
