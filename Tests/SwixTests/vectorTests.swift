import Swix
import XCTest

class VectorTests: XCTestCase {
    func initTests() {
        print("What?")
        // testing zeros and array
         XCTAssertTrue(zeros(4) ~== array(0,0,0,0)) 
         XCTAssertTrue(ones(4) ~== (zeros(4)+1)) 
         XCTAssertTrue(zeros_like(ones(4)) ~== zeros(4)) 
         XCTAssertTrue(arange(4) ~== array(0, 1, 2, 3)) 
         XCTAssertTrue(arange(2, max: 4) ~== array(2, 3)) 
         XCTAssertTrue(linspace(0,max: 1,num:3) ~== array(0, 0.5, 1)) 
//         XCTAssertTrue(`repeat`(arange(2), N: 2) ~== array(0,1,0,1)) 
//         XCTAssertTrue(copy(arange(4)) ~== arange(4))
         XCTAssertTrue(asarray(0..<2) ~== array(0, 1))
//         XCTAssertTrue(copy(arange(3)) ~== array(0, 1, 2)) 
        /* XCTAssertTrue(sum((rand(3) - array(0.516, 0.294, 0.727)) < 1e-2) == 3) */
        
        /* let N = 1e4.int */
        /* seed(42) */
        /* let x = rand(N) */
        
        /* seed(42) */
        /* var y = rand(N) */
        /* XCTAssertTrue(x ~== y) */
        
        /* seed(29) */
        /* y = rand(N) */
        /* XCTAssertTrue(!(x ~== y)) */
        
        /* seed(42) */
        /* y = rand(N) */
        /* XCTAssertTrue(x ~== y) */
        
        /* XCTAssertTrue(abs(x.mean() - 0.5) < 1e-1) */
        /* XCTAssertTrue(abs(variance(x) - 1/12) < 1e-1) */
    }

}


//    func vectorSwiftTests(){
//        // testing the file vector.swift
//        var x_idx = zeros(4)
//        x_idx[0..<2] <- 2
//        XCTAssertTrue(x_idx ~== array(2, 2, 0, 0))
//        XCTAssertTrue(arange(4).reshape((2,2)) ~== array("0 1; 2 3"))
//        XCTAssertTrue(arange(4).copy() ~== arange(4))
//        var x = array(4, 2, 3, 1)
//        x.sort()
//        XCTAssertTrue(x ~== array(1, 2, 3, 4))
//        XCTAssertTrue(x.min() == 1)
//        XCTAssertTrue(x.max() == 4)
//        XCTAssertTrue(x.mean() == 2.5)
//        XCTAssertTrue(x["all"] ~== array(1, 2, 3, 4))
//        x[0] = 0
//        XCTAssertTrue(x[0] == 0)
//        x[0..<2] = array(1, 3)
//        XCTAssertTrue(x[0..<2] ~== array(1, 3))
//        x[arange(2)] = array(4, 1)
//        XCTAssertTrue(x[arange(2)] ~== array(4, 1))
//
//        let y = array(5, 2, 4, 3, 1)
//        XCTAssertTrue((y < 2) ~== array(0, 0, 0, 0, 1))
//        XCTAssertTrue(reverse(y) ~== array(1, 3, 4, 2, 5))
//        XCTAssertTrue(sort(y) ~== array(1, 2, 3, 4, 5))
//        XCTAssertTrue(delete(y, idx: array(0, 1)) ~== array(4, 3, 1))
//        XCTAssertTrue(asarray([0, 1, 2]) ~== array(0, 1, 2))
//        XCTAssertTrue(asarray(0..<2) ~== array(0, 1))
//        XCTAssertTrue(concat(array(1, 2), y: array(3, 4)) ~== (arange(4)+1))
//        XCTAssertTrue(clip(y, a_min: 2, a_max: 4) ~== array(4, 2, 4, 3, 2))
//        XCTAssertTrue(delete(y, idx: array(0, 1)) ~== array(4,3,1))
//        XCTAssertTrue(`repeat`(array(0,1),N: 2) ~== array(0,1,0,1))
//        XCTAssertTrue(`repeat`(array(0, 1),N:2, axis:1) ~== array(0,0,1,1))
//        XCTAssertTrue(argmax(array(1,4,2,5)) == 3)
//        XCTAssertTrue(argmin(array(1,4,2,5)) == 0)
//        XCTAssertTrue(argsort(array(1,4,2,5)) ~== array(0, 2, 1, 3))
//
//        XCTAssertTrue(arange(4) ~== array(0, 1, 2, 3))
//        let xO = array(1, 2, 3)
//        let yO = array(1, 2, 3) + 3
//        XCTAssertTrue(outer(xO, y: yO) ~== array(4, 5, 6, 8, 10, 12, 12, 15, 18).reshape((3,3)))
//        let xR1 = array(1.1, 1.2, 1.3)
//        let xR2 = array(1, 1, 1)
//        XCTAssertTrue(remainder(xR1, x2: xR2) ~== array(0.1, 0.2, 0.3))
//        XCTAssertTrue(xR1 % 1.0 ~== array(0.1, 0.2, 0.3))
//        XCTAssertTrue(1.0 % xR1 ~== ones(3))
//        XCTAssertTrue(arange(4)[-1] == 3.0)
//
//        let xR = arange(4*4).reshape((4,4))
//        XCTAssertTrue(rank(xR) == 2.0)
//
//        XCTAssertTrue(pow(array(1,2,3,4), power: 2) ~== array(1,4,9,16))
//        XCTAssertTrue(pow(ones(4)*2, y: ones(4)*2) ~== array(4, 4, 4, 4))
//        XCTAssertTrue(pow(-1, y: array(1, 2, 3, 4)) ~== array(-1, 1, -1, 1))
//        XCTAssertTrue(norm(array(1,1,1), ord:2) == sqrt(3))
//        XCTAssertTrue(norm(array(1,0,1), ord:1) == 2)
//        XCTAssertTrue(norm(array(4,0,0), ord:0) == 1)
//        XCTAssertTrue(norm(array(4,0,0), ord:-1) == 4)
//        XCTAssertTrue(norm(array(4,2,-3), ord:inf) == 4)
//        XCTAssertTrue(norm(array(4,2,-3), ord:-inf) == 2)
//
//        XCTAssertTrue(sign(array(-3, 4, 5)) ~== array(-1, 1, 1))
//        XCTAssertTrue(floor(array(1.1, 1.2, 1.6)) ~== array(1, 1, 1))
//        XCTAssertTrue(round(array(1.1, 1.2, 1.6)) ~== array(1, 1, 2))
//        XCTAssertTrue(ceil(array(1.2, 1.5, 1.8)) ~== ones(3)*2)
//        XCTAssertTrue(log10(ones(4) * 10) ~== ones(4))
//        XCTAssertTrue(log2(ones(4) * 2) ~== ones(4))
//        XCTAssertTrue(log(ones(4) * e) ~== ones(4))
//        XCTAssertTrue(exp2(ones(4)*2) ~== ones(4) * 4)
//        XCTAssertTrue(exp(ones(4)*2) ~== ones(4)*e*e)
//    }
