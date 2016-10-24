//
//  SwixTestF.swift
//  swix
//
//  Created by Thomas Kilian on 24.10.16.
//  Copyright © 2016 com.scott. All rights reserved.
//

import XCTest
import SwixF

class SwixTestF: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVectorFunctions() {
        let z = zeros(3)
        XCTAssert(z ~== Vector(zeros:3))
        XCTAssert(z ~== zeros_like(z))

        let o = ones(3)
        XCTAssert(o ~== Vector(ones:3))
        XCTAssert(o ~== ones_like(o))

        let up2 = Vector(numbers:0, 1, 2)
        let up3 = Vector(numbers:0, 1, 2, 3)
        XCTAssert(arange(3) ~== up2)
        XCTAssert(arange(3, x:false) ~== up3)
        XCTAssert(arange(3.1) ~== up2)
        XCTAssert(range(0, max:2, step:1) ~== up2)
        XCTAssert(arange(0, max:3) ~== up2)
        XCTAssert(arange(0, max:3, x:false) ~== up3)
        XCTAssert(linspace(0, max:2, num:3) ~== up2)
        XCTAssert(array(0, 1, 2) ~== up2)
        XCTAssert(asarray([0, 1, 2]) ~== up2)
        XCTAssert(asarray(0..<3) ~== up2)
        XCTAssert(SwixF.copy(up2) ~== up2)
        seed(42)
        XCTAssert(rand(10).n == 10)
        _ = randn(10)
        _ = randperm(10)
    }
    
    func testMatrixFunctions() {
        let z = Matrix(zeros:(2,2))
        XCTAssert(zeros((2,2)) ~== z)
        XCTAssert(zeros_like(z) ~== z)

        let o = Matrix(ones:(2,2))
        XCTAssert(ones((2,2)) ~== o)
        XCTAssert(ones_like(z) ~== o)
        
        XCTAssert(eye(2) ~== Matrix(eye:2))
        let v = Vector(ones:2)
        XCTAssert(diag(v) ~== Matrix(diag:v))
        
        XCTAssert(randn((2,2)).shape == (2,2))
        _ = rand((2,2))

        XCTAssert(reshape(Vector(zeros:4), shape:(1,4)).shape == (1,4))
        XCTAssert(array("1 2; 3 4") ~== Matrix("1 2; 3 4"))
    }

}
