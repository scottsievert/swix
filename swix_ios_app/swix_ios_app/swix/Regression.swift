//
//  Regression.swift
//  swix
//
//  Created by Erk EKİN on 15/07/15. /// 📬 erkekin@hacettepe.edu.tr ///
//  Copyright (c) 2015 com.scott. All rights reserved.
//
import UIKit

/*

To get the usage please take a look at EERegressionTests.swift
erk

*/

infix operator *! {associativity none precedence 140}
func *! (lhs: matrix, rhs: matrix) -> matrix{
    return dot(lhs, y: rhs)}

extension matrix{
    
    func cbind(Y:matrix) -> matrix{
        
        var A = matrix(columns: Y.rows, rows: self.columns + Y.columns)
        A.flat = concat(transpose(self).flat, y: transpose(Y).flat)
        
        return transpose(A)
        
    }
    
}

class Regression {
    
    var betalar:ndarray = ndarray(n: 0)
    var degree:Int = 1
    // var model:()->()?
    
    init(X:matrix, Y:matrix, degree:Int){
        
        self.degree = degree
        betalar = self.findBetas(X, Y: Y, degree: degree)
        
    }
    
    init(){}
    
    private func findBetas(X:matrix, Y:matrix, degree:Int) -> ndarray {
        
        assert(degree>0, "Degree should be higher than zero")
        assert(X.rows == Y.rows, "Sizes of input arguments do not match")
        assert(Y.columns == 1, "Columns of Y should be 1")
        
        //      |1  x01 x02 x0n|      |y0|
        //      |1  x11 x12 x1n|      |y1|
        //  X = |1  x21 x22 x2n|  Y = |y2|  ß = (X'X)^-1 * X'Y'
        //      |1  x31 x32 x3n|      |y3|
        //      |1  x41 x42 x4n|      |y4|
        //      |1  xm1 xm2 xmn|      |ym|
        
        var newX = X
        
        if degree > 1{
            
            for i in 2...degree{
                
                var degreeOfX = matrix(columns: 1, rows: X.rows)
                degreeOfX.flat.grid = X.flat.grid.map({pow($0, Double(i))})
                
                newX = newX.cbind(degreeOfX)
                
            }
            
        }
        
        var onesVector = matrix(columns: 1, rows: Y.rows)
        onesVector.flat = ones(newX.rows)
        
        let onedXNew = onesVector.cbind(newX)
        
        let betas = solve(transpose(onedXNew)*!onedXNew, b: (transpose(onedXNew)*!Y).flat) //let betas = solve(X'X, X'Y')
        
        return betas
        
    }
    
    func predict(X:matrix) -> matrix{
        
        var ß = matrix(columns: 1, rows: betalar.count)
        ß.flat = betalar
        
        var newX = X
        
        if degree > 1{
            for i in 2...degree{
                
                var degreeOfX = matrix(columns: 1, rows: X.rows)
                degreeOfX.flat.grid = X.flat.grid.map({pow($0, Double(i))})
                
                newX = newX.cbind(degreeOfX)
                
            }
            
        }
        
        var onesVector = matrix(columns: 1, rows: newX.rows)
        onesVector.flat = ones(newX.rows)
        
        let onedXNew = onesVector.cbind(newX)
        
        return onedXNew *! ß
        
    }
    
}


