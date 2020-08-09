//
//  svm.swift
//  swix
//
//  Created by Scott Sievert on 7/16/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

class SVM {
    // swift --> objc --> objc++ --> c++
    var cvsvm:cvSVM;
    var svm_type:String
    var kernel_type:String
    var N:Int
    var M:Int
    init(){
        self.cvsvm = cvSVM()
        
        
        self.N = -1
        self.M = -1
        
        // with linear svc results, we closely match (and do slightly better than) sk-learn
        self.svm_type = "C_SVC"
        self.kernel_type = "LINEAR"
        setParams(svm_type, kernel_type:kernel_type)
    }
    func setParams(_ svm_type:String, kernel_type:String, nu:Float=0.5){
        // kernel: LINEAR, SIGMOID
        // svm_type: C_SVC, ONE_CLASS, NU_SVC, NU_SVR
        
        // careful: NU_SVR and SIGMOID throws an exception error
        self.cvsvm.setParams(svm_type.nsstring as String, kernel:kernel_type.nsstring as String, nu:nu.cfloat)
    }
    func train(_ responses: matrix, _ targets: vector){
        // convert matrix2d to NSArray
        self.M = responses.shape.0
        self.N = responses.shape.1
        self.cvsvm.train(!responses, targets:!targets, m:self.M.cint, n:self.N.cint)
    }
    func predict(_ response: vector) -> Double{
        assert(self.N == response.count, "Sizes of input arguments do not match: predict.count != trained.count. The varianbles you're trying to predict a result from must match variables you trained off of.")
        let tp = self.cvsvm.predict(!response, n:self.N.cint)
        return tp.double
    }
    func predict(_ responses: matrix) -> vector{
        let y = zeros(responses.shape.0)
        assert(self.N == responses.shape.1, "Sizes must match")
        self.cvsvm.predict(!responses, into:!y, m:responses.shape.0.cint, n:responses.shape.1.cint);
        return y
    }
}
class kNearestNeighbors{
    // finds the nearest neighbor over all points. if want to change, dive into knn.mm and change `int k = cvknn.get_max_k();` in `predict(...)`
    var T:Double
    var knn:kNN;
    var N:Int; // variables
    var M:Int; // responses
    init(){
        assert(false, "Careful! My simple tests failed but it looks like it should work.")
        self.T = 1
        self.knn = kNN()
        self.N = -1
        self.M = -1
    }
    func train(_ responses: matrix, targets: vector){
        self.M = responses.shape.0
        self.N = responses.shape.1
        
        self.knn.train(!responses, targets: !targets, m:self.M.cint, n:self.N.cint)
        
    }
    func predict(_ x: vector, k: Int) -> Double{
        assert(self.N == x.count, "Sizes of input arguments do not match: predict.count != trained.count. The varianbles you're trying to predict a result from must match variables you trained off of.")
        assert(k <= 32, "k <= 32 for performance reasons enforced by OpenCV.")
        let result = self.knn.predict(!x, n:x.n.cint, k:k.cint)
        return result.double;
    }
}

