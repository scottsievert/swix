//
//  fullTests.swift
//  swix
//
//  Created by Scott Sievert on 7/18/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

class swixTests {
    var N:Int
    init(run_io_tests:Bool=false){
        print("running many simple tests")
        self.N = 10
        operatorTests()
        print("   operators work as expected")
        comparisonTests()
        print("   comparisons work as expected")
        functionTests()
        print("   simple functions work as expected")
        twoDTests()
        print("   matrix convience elements work as expected")
        if run_io_tests {
            readWriteTests()
            print("   {read,write}_{binary,csv}, savefig work like Python... at least on OSX")
        }
        complexTests()
        
        numberTests()
        _ = vectorTests()
        matrixTests()
        set_theory_tests()
    }
    func set_theory_tests(){
        func in1d_test(){
            let test = array(0, 1, 2, 5, 0)
            let states = array(0, 2)
            let mask = in1d(test, y:states)
            assert(mask ~== array(1, 0, 1, 0, 1))
        }
        func intersection_test(){
            let x = array(1, 2, 3, 4, -1, -1)
            let y = array(1, 2, 3, 5, -1, -1)
            let a = intersection(x, y:y)
            let b = union(x, y:y)
            assert(a ~== array(-1, 1, 2, 3))
            assert(b ~== array(-1, 1, 2, 3, 4, 5))
        }
        in1d_test()
        intersection_test()
        print("set function works like set theory ")
    }
    func complexTests(){
        func scalar_test(){
            let x:Int = 1
            let y:Double = 4
            let z:Double = x + y
            assert(z == 5)
            print("Int(1)+Double(1)==2 through ScalarArithmetic")
        }
        func swift_complex_test(){
//            var x = 1.0 + 1.0.i
//            assert(abs(x) == sqrt(2))
//            print("scalar (not vector) complex number usage works using swift-complex.")
        }
        func range_test(){
            var x = arange(4)
            let y = x[0..<2]
            assert(y ~== arange(2))
            
            var z = zeros(4)
            z[0..<2] = ones(2)
            assert(z ~== array(1, 1, 0, 0))
            print("x[0..<2] = ones(2) and y = z[3..<8] works in the 1d case!")
        }
        func argwhere_test(){
            var x = zeros(N)
            let y = zeros(N)
            x[0..<5] = ones(5)
            let i = argwhere(abs(x-y) < 1e-9)
            assert(i ~== array(5, 6, 7, 8, 9))
            x[argwhere(x<2)] = ones(argwhere(x<2).n)
            print("can use argwhere. x[argwhere(x<2)]=zeros(argwhere(x<2).n)  works for both 1d and 2d.")
        }
        func matrix2d_indexing_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            x[0..<2, 0..<2] = array("4 3; 2 6")
            assert(x ~== array("4 3 3; 2 6 6; 7 8 9"))
            print("can use x[1, 0..<2] or x[0..<2, 0..<2] to also index")
        }
        func matrix2d_indexing_matrix_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            assert(x[array(0, 1, 2, 3, 4, 5)] ~== array(1, 2, 3, 4, 5, 6))
            print("x[vector] works and indexes the vector row first")
        }
        func fft_test(){
            let x = arange(8)
            let (yr, yi) = fft(x)
            let x2 = ifft(yr, yi: yi)
            assert(x2 ~== x)
            print("fft/ifft works. fft(x) -> (yreal, yimag)")
        }
        func dot_test(){
            let x = eye(3) * 2
            let y = array("1 2 3 1; 4 5 6 1; 7 8 9 1")
            assert((x.dot(y)) ~== 2*y)
            print("dot product works with dot(x, y) or x *! y")
            
            let xA = ones(3)
            let A = arange(3*3).reshape((3, 3))
            let yA1 = A.dot(xA)
            let yA2 = dot(A, x: xA)
            assert(yA1 ~== array(3, 12, 21))
            assert(yA1 ~== yA2)
        }
        func svd_test(){
            let x = array("1 2; 4 8; 3 5")
            _ = svd(x)
            
            let y = array("1 2 3; 4 5 6")
            _ = svd(y)
            
            let z = array("1 2 3; 4 5 6; 7 8 9")
            _ = svd(z)
            
            print("svd works and tested by hand for square, fat and skinny matrices against Python")
        }
        func svm_test(){
            let svm = SVM()
            let x = reshape(arange(4*2) , shape: (4, 2))
            let y = array(0, 1, 2, 3)
            
            svm.train(x, y)
            let z = svm.predict(array(2, 3))
            assert(z == y[1])
            print("svm works via simple test")
        }
        func inv_test(){
            let x = randn((4,4))
            let y = inv(x)
            assert((x.dot(y)) ~== eye(4))
            print("matrix inversion works")
        }
        func solve_test(){
            let A0 = array(1, 2, 3, 4, 2, 1, 4, 6, 7)
            let A = reshape(A0, shape: (3, 3))
            let b = array(1, 2, 5)
            _ = solve(A, b: b)
            assert((A !/ b) ~== solve(A, b: b))
            print("solve works, similar to Matlab's \\ operator (and checked by hand). Be careful -- this only works for nxn matrices")
        }
        func eig_test(){
            var x = zeros((3,3))
            x["diag"] = array(1, 2, 3)
            let r = eig(x)
            assert(r ~== array(1, 2, 3))
            print("`eig` returns the correct eigenvalues and no eigenvectors.")
        }
        func pinv_test(){
            let x = arange(3*4).reshape((3,4))
            let y = pinv(x)
            assert(x.dot(y).dot(x) ~== x)
            assert(x.pI ~== pinv(x))
            print("pseudo-inverse works")
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
    func numberTests(){
        assert(close(0, y: 1e-10) == true)
        assert(close(0, y: 1e-10) == (1e-10 ~= 0))
        assert(rad2deg(pi/2) == 90)
        assert(deg2rad(90) == pi/2)
        assert(max(0, 1) == 1)
        assert(min(0, 1) == 0)
//        assert("3.14".floatValue == 3.14)
        assert(3 / 4 == 0.75)
        assert(3.25 / 4 == 0.8125)
        assert(isNumber(3))
        assert(!isNumber(zeros(2)))
//        assert(!isNumber("3.14"))
    }
    class vectorTests{
        init(){
            initingTests()
            vectorSwiftTests()
        }
        func initingTests(){
            // testing zeros and array
            assert(zeros(4) ~== array(0,0,0,0))
            assert(ones(4) ~== (zeros(4)+1))
            assert(zeros_like(ones(4)) ~== zeros(4))
            assert(arange(4) ~== array(0, 1, 2, 3))
            assert(arange(2, max: 4) ~== array(2, 3))
            assert(linspace(0,max: 1,num:3) ~== array(0, 0.5, 1))
            assert(`repeat`(arange(2), N: 2) ~== array(0,1,0,1))
            assert(copy(arange(4)) ~== arange(4))
            assert(asarray(0..<2) ~== array(0, 1))
            assert(copy(arange(3)) ~== array(0, 1, 2))
            //assert(sum((rand(3) - array(0.516, 0.294, 0.727)) < 1e-2) == 3)
            
            let N = 1e4.int
            seed(42)
            let x = rand(N)
            
            seed(42)
            var y = rand(N)
            assert(x ~== y)
            
            seed(29)
            y = rand(N)
            assert(!(x ~== y))
            
            seed(42)
            y = rand(N)
            assert(x ~== y)
            
            assert(abs(x.mean() - 0.5) < 1e-1)
            assert(abs(variance(x) - 1/12) < 1e-1)
        }
        func vectorSwiftTests(){
            // testing the file vector.swift
            var x_idx = zeros(4)
            x_idx[0..<2] <- 2
            assert(x_idx ~== array(2, 2, 0, 0))
            assert(arange(4).reshape((2,2)) ~== array("0 1; 2 3"))
            assert(arange(4).copy() ~== arange(4))
            var x = array(4, 2, 3, 1)
            x.sort()
            assert(x ~== array(1, 2, 3, 4))
            assert(x.min() == 1)
            assert(x.max() == 4)
            assert(x.mean() == 2.5)
            assert(x["all"] ~== array(1, 2, 3, 4))
            x[0] = 0
            assert(x[0] == 0)
            x[0..<2] = array(1, 3)
            assert(x[0..<2] ~== array(1, 3))
            x[arange(2)] = array(4, 1)
            assert(x[arange(2)] ~== array(4, 1))
            
            let y = array(5, 2, 4, 3, 1)
            assert((y < 2) ~== array(0, 0, 0, 0, 1))
            assert(reverse(y) ~== array(1, 3, 4, 2, 5))
            assert(sort(y) ~== array(1, 2, 3, 4, 5))
            assert(delete(y, idx: array(0, 1)) ~== array(4, 3, 1))
            assert(asarray([0, 1, 2]) ~== array(0, 1, 2))
            assert(asarray(0..<2) ~== array(0, 1))
            assert(concat(array(1, 2), y: array(3, 4)) ~== (arange(4)+1))
            assert(clip(y, a_min: 2, a_max: 4) ~== array(4, 2, 4, 3, 2))
            assert(delete(y, idx: array(0, 1)) ~== array(4,3,1))
            assert(`repeat`(array(0,1),N: 2) ~== array(0,1,0,1))
            assert(`repeat`(array(0, 1),N:2, axis:1) ~== array(0,0,1,1))
            assert(argmax(array(1,4,2,5)) == 3)
            assert(argmin(array(1,4,2,5)) == 0)
            assert(argsort(array(1,4,2,5)) ~== array(0, 2, 1, 3))

            assert(arange(4) ~== array(0, 1, 2, 3))
            let xO = array(1, 2, 3)
            let yO = array(1, 2, 3) + 3
            assert(outer(xO, y: yO) ~== array(4, 5, 6, 8, 10, 12, 12, 15, 18).reshape((3,3)))
            let xR1 = array(1.1, 1.2, 1.3)
            let xR2 = array(1, 1, 1)
            assert(remainder(xR1, x2: xR2) ~== array(0.1, 0.2, 0.3))
            assert(xR1 % 1.0 ~== array(0.1, 0.2, 0.3))
            assert(1.0 % xR1 ~== ones(3))
            assert(arange(4)[-1] == 3.0)
            
            let xR = arange(4*4).reshape((4,4))
            assert(rank(xR) == 2.0)
            
            assert(pow(array(1,2,3,4), power: 2) ~== array(1,4,9,16))
            assert(pow(ones(4)*2, y: ones(4)*2) ~== array(4, 4, 4, 4))
            assert(pow(-1, y: array(1, 2, 3, 4)) ~== array(-1, 1, -1, 1))
            assert(norm(array(1,1,1), ord:2) == sqrt(3))
            assert(norm(array(1,0,1), ord:1) == 2)
            assert(norm(array(4,0,0), ord:0) == 1)
            assert(norm(array(4,0,0), ord:-1) == 4)
            assert(norm(array(4,2,-3), ord:inf) == 4)
            assert(norm(array(4,2,-3), ord:-inf) == 2)
            
            assert(sign(array(-3, 4, 5)) ~== array(-1, 1, 1))
            assert(floor(array(1.1, 1.2, 1.6)) ~== array(1, 1, 1))
            assert(round(array(1.1, 1.2, 1.6)) ~== array(1, 1, 2))
            assert(ceil(array(1.2, 1.5, 1.8)) ~== ones(3)*2)
            assert(log10(ones(4) * 10) ~== ones(4))
            assert(log2(ones(4) * 2) ~== ones(4))
            assert(log(ones(4) * e) ~== ones(4))
            assert(exp2(ones(4)*2) ~== ones(4) * 4)
            assert(exp(ones(4)*2) ~== ones(4)*e*e)
        }
    }
    func matrixTests(){
        let x = randn((4,4))
        assert(eye(4).dot(eye(4)) ~== eye(4))
        assert(x.dot(x.I) ~== eye(4))
        let (u,v) = meshgrid(array(0,1), y: array(2,3))
        assert(u ~== `repeat`(array(0,1), N: 2).reshape((2,2)).T)
        assert(v ~== `repeat`(array(2,3), N: 2).reshape((2,2)))
        
        let A = arange(3*3).reshape((3, 3))
        assert(abs(A.max() - 8) < 1e-3)
        assert(abs(A.min() - 0) < 1e-3)
    }
    
    func readWriteTests(){
        let x1 = arange(9).reshape((3,3)) * 2
        write_csv(x1, filename: "/tmp/image.csv")
        let y1:matrix = read_csv("/tmp/image.csv", header_present:false).data
        assert(x1 ~== y1)
        
        let x2 = array(1, 2, 3, 4, 5, 2, 1)
        write_csv(x2, filename:"/tmp/vector.csv")
        let y2:vector = read_csv("/tmp/vector.csv")
        assert(x2 ~== y2)
        
        let x3 = array(1, 5, 3, 1, 0, -10) * pi
        write_binary(x3, filename:"/tmp/x3.npy")
        let y3:vector = read_binary("/tmp/x3.npy")
        assert(y3 ~== x3)
        
        let x4 = arange(9).reshape((3,3))
        write_binary(x4, filename:"/tmp/x4.npy")
        let y4:matrix = read_binary("/tmp/x4.npy")
        assert(y4 ~== x4)
    }
    func twoDTests(){
        var x = arange(9).reshape((3,3))
        assert(x.T ~== transpose(x))
        assert(x.I ~== inv(x))
        assert(x["diag"] ~== array(0, 4, 8))
        var y = x.copy()
        y["diag"] = array(1, 5, 9)
        assert(y ~== array(1, 1, 2, 3, 5, 5, 6, 7, 9).reshape((3,3)))
        assert(eye(2) ~== array(1, 0, 0, 1).reshape((2,2)))
        
        assert(x[0..<2, 0..<2] ~== array(0, 1, 3, 4).reshape((2,2)))
        var z2 = x.copy()
        z2[0..<2, 0..<2] = array(1, 2, 3, 4).reshape((2,2))
        assert(z2[0..<2, 0..<2] ~== array(1, 2, 3, 4).reshape((2,2)))
        
        assert(x.flat[array(1, 4, 5, 6)] ~== x[array(1, 4, 5, 6)])
        y = x.copy()
        y[array(1, 4, 5, 6)] = ones(4)
        assert(y ~== array(0, 1, 2, 3, 1, 1, 1, 7, 8).reshape((3,3)))
        
        let z = arange(3*4).reshape((3,4))
        assert(sum(z, axis:0) ~== array(12, 15, 18, 21))
        assert(sum(z, axis:1) ~== array(6, 22, 38))
        
        let d1 = x.dot(y)
        let d2 = x.dot(y)
        let d3 = dot(x, y: y)
        assert(d1 ~== d2)
        assert(d1 ~== d3)
    }
    func functionTests(){
        var x = array(-1, 0, 1)
        
        assert(abs(x) ~== array(1, 0, 1))
        assert(sign(x+0.1) ~== array(-1, 1, 1))
        assert(sum(x+1)     == 3)
        assert(cumsum(x+1) ~== array(0, 1, 3))
        assert(pow(x+1, power: 2) ~== array(0, 1, 4))
        assert(((x+1)^2)   ~== array(0, 1, 4))
        assert(variance(ones(4)) == 0)
        assert(std(ones(4)) == 0)
        assert(mean(x) == 0)
        assert(abs(mean(rand(1000)) - 0.5) < 0.1)
        assert(abs(mean(randn(1000))) < 0.1)
        assert(abs(std(randn(1000)) - 1) < 0.2)
        var y = randn((100,100))
        assert(abs(mean(y.flat)) < 0.1)
        y = rand((100, 100))
        assert(abs(mean(y.flat) - 0.5) < 0.1)
        
        assert(`repeat`(array(0, 1), N: 2) ~== array(0, 1, 0, 1))
        assert(`repeat`(array(0, 1), N: 2, axis:1) ~== array(0, 0, 1, 1))
        
//        var xC = zeros_like(x)
        var xC = copy(x)
        assert(xC ~== x.copy())
        
        assert(array("0 1 2; 3 4 5") ~== arange(6).reshape((2,3)))
        
        var z1 = array(0, 1)
        var z2 = array(2, 3)
        var (z11, z22) = meshgrid(z1, y: z2)
        assert(z11 ~== array(0, 0, 1, 1).reshape((2,2)))
        assert(z22 ~== array(2, 3, 2, 3).reshape((2,2)))
        
        assert(x.min() == min(x))
        assert(x.min() == -1)
        
        assert(x.max() == max(x))
        assert(x.max() == 1)
        
        assert(x.copy() ~== copy(x))
        assert(x.copy() ~== array(-1, 0, 1))
        
        assert(arange(4).reshape((2,2)).copy() ~== arange(4).reshape((2,2)))
        
        var z = array(-3, -2, -1, 0, 1, 2, 3)
        assert(z[argwhere(z < 0)] ~== array(-3, -2, -1))
        assert((z < 0) ~== array(1, 1, 1, 0, 0, 0, 0))
        
        assert(sin(array(1, 2, 3, 4)) ~== array(sin(1), sin(2), sin(3), sin(4)))
//        func f(x:Double)->Double {return x+1}
//        assert(apply_function(f,arange(100)) ~== (arange(100)+1))
        var x5 = arange(5)
        var y5 = array(1, 5, 3, 2, 6)
        assert(max(x5, y: y5) ~== array(1, 5, 3, 3, 6))
        assert(min(x5, y: y5) ~== array(0, 1, 2, 2, 4))
        
        var mx5 = arange(4).reshape((2,2))
        var my5 = array(4, 2, 1, 0).reshape((2,2))
        assert(min(mx5, y: my5) ~== array(0, 1, 1, 0).reshape((2,2)))
        assert(reverse(y5) ~== array(6, 2, 3, 5, 1))
        
        assert(sort(y5) ~== array(1, 2, 3, 5, 6))
        
        seed(2)
        var xR = rand(100)
        seed(2)
        var yR = rand(100)
        assert(max(abs(xR - yR)) < 1e-6)
        
        func helper_test(){
            let x = arange(2*3).reshape((2,3))
            assert(fliplr(x) ~== array(2, 1, 0, 5, 4, 3).reshape((2,3)))
            assert(flipud(x) ~== array(3, 4, 5, 0, 1, 2).reshape((2,3)))
        }
        helper_test()
    }
    func operatorTests(){
        // l and o similar to 1 and 0
        let l = ones(N)
        let o = zeros(N)
        
        // PLUS
        assert((o+1.double) ~== l)
        assert((1.double+o) ~== l)
        assert((l+o) ~== l)
        
        // MINUS
        assert((l - o) ~== l)
        assert((l - 1) ~== o)
        assert((1 - o) ~== l)
        
        // MULTIPLY
        assert(((o+1) * l) ~== l)
        assert((l * 1) ~== l)
        assert((1 * l) ~== l)
        
        // DIVIDE
        assert(((l+1)/2) ~== l)
        assert((o/l) ~== o)
        assert((1 / l) ~== l)
        
        // POW
        assert((array(1, 2, 3)^2) ~== array(1, 4, 9))
        
        // MODULO
        assert(array(1, 3.14, 2.1)%1.0 ~== array(0, 0.14, 0.1))
        assert(array(1, 2, 6) % 5 ~== array(1, 2, 1))
    }
    func comparisonTests(){
        //     true:  <, >, <=, >=, ==, !==
        let x = array(0, 3,  3,  4,  5,  7)
        let y = array(1, 2,  3,  4,  5,  6)
        
        // matrix <op> matrix
        assert((x < y) ~== array(1, 0, 0, 0, 0, 0))
        assert((x > y) ~== array(0, 1, 0, 0, 0, 1))
        assert((x <= y) ~== array(1, 0, 1, 1, 1, 0))
        assert((x >= y) ~== array(0, 1, 1, 1, 1, 1))
        assert((x == y) ~== array(0, 0, 1, 1, 1, 0))
        assert((x !== y) ~== array(1, 1, 0, 0, 0, 1))
        
        // double <op> matrix
        assert((4 < x) ~== array(0, 0, 0, 0, 1, 1))
        assert((4 > x) ~== array(1, 1, 1, 0, 0, 0))
        assert((4 >= x) ~== array(1, 1, 1, 1, 0, 0))
        assert((4 <= x) ~== array(0, 0, 0, 1, 1, 1))
        
        // matrix <op> ouble
        assert((x > 4) ~== array(0, 0, 0, 0, 1, 1))
        assert((x < 4) ~== array(1, 1, 1, 0, 0, 0))
        assert((x <= 4) ~== array(1, 1, 1, 1, 0, 0))
        assert((x >= 4) ~== array(0, 0, 0, 1, 1, 1))
    }
}












