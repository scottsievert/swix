//
//  svm.m
//  swix
//
//  Created by Scott Sievert on 7/16/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenCV.h"
#import "swix-Bridging-Header.h"
using namespace cv;

void doubleToFloat(double * x, float * y, int N){
    vDSP_vdpsp(x, 1, y, 1, N);
}

// #### STATE VECTOR MACHINE
@implementation cvSVM : NSObject
CvSVM ocvSVM;
CvSVMParams params;
int N; // number of variables
int M; // number of responses
void copy_float_to_double(float* x, double* y, int N){
    vDSP_vspdp(x, 1, y, 1, N);
}
void copy_float(float* x, float * y, int N){
    cblas_scopy(N, x, 1, y, 1);
}
-(void)setParams:(NSString*)svm_type kernel:(NSString*)kernel nu:(float)nu{
    if ([svm_type isEqualToString:@"C_SVC"])
        { params.svm_type = CvSVM::C_SVC; }
    else if ([svm_type isEqualToString:@"ONE_CLASS"])
        { params.svm_type = CvSVM::ONE_CLASS;}
    else if ([svm_type isEqualToString:@"NU_SVC"])
        { params.svm_type = CvSVM::NU_SVC;}
    else if ([svm_type isEqualToString:@"NU_SVR"])
        { params.svm_type = CvSVM::NU_SVR;}
    
    if ([kernel isEqualToString:@"LINEAR"])
        { params.kernel_type = CvSVM::LINEAR;}
    else if ([kernel isEqualToString:@"SIGMOID"])
        { params.kernel_type = CvSVM::SIGMOID;}
    
    params.nu = nu;
}
-(NSObject*)init{
    params.svm_type    = CvSVM::C_SVC;
    params.kernel_type = CvSVM::LINEAR;
    params.term_crit   = cvTermCriteria(CV_TERMCRIT_ITER, 100, 1e-6);
    return self;
}
-(void) train:(double *)x targets:(double *)targets m:(int)M n:(int)N{
    // M is the number of responses or rows; N is columns or variables
    float * x2 = (float *)malloc(sizeof(float) * M * N);
    float * t2 = (float *)malloc(sizeof(float) * M);
    doubleToFloat(x, x2, M*N);
    doubleToFloat(targets, t2, M*1);
    Mat xMat(M, N, CV_32FC1, x2);
    Mat tMat(M, 1, CV_32FC1, t2);
    Mat x3 = Mat();
    ocvSVM.train(xMat, tMat, x3, x3, params);
}
- (float) predict:(double *)x n:(int)N{
    float * x2 = (float *)malloc(sizeof(float) * 1 * N);
    doubleToFloat(x, x2, N);
    Mat xMat(1, N, CV_32FC1, x2);
    float targetPredict = ocvSVM.predict(xMat);
    return targetPredict;
}
- (double*) predict:(double*)x into:(double*)y m:(int)M n:(int)N{
    float * x2 = (float *)malloc(sizeof(float) * M * N);
    doubleToFloat(x, x2, M*N);
    float* y2 = (float *)malloc(sizeof(float) * M);
    Mat xMat(M, N, CV_32FC1, x2);
    Mat yMat(M, 1, CV_32FC1, y2);
    
    ocvSVM.predict(xMat, yMat);
    copy_float_to_double(y2, y, M);
    return y;
}
@end

// #### STATE VECTOR MACHINE
@implementation kNN : NSObject
int kN;
int kM;

CvKNearest cvknn;

-(NSObject*)init{
    return self;
}

- (void) train:(double *)x targets:(double *)tar m:(int)M n:(int)N{
    float * x2 = (float *)malloc(sizeof(float) * M * N);
    float * t2 = (float *)malloc(sizeof(float) * M * 1);
    Mat x3(M, N, CV_32FC1, x2);
    Mat t3(M, 1, CV_32FC1, t2);
    
    cvknn.train(x3, t3);
}
- (double) predict:(double *)x n:(int)N k:(int)k{
    float * x2 = (float *)malloc(sizeof(float) * N * 1);
    Mat x3(1, N, CV_32FC1, x2);
    Mat results(1, 1, CV_32FC1);
    float targetPredict = -3.14;
    targetPredict = cvknn.find_nearest(x3, k, &results);
    
    std::cout << results << std::endl;
    std::cout << results.at<double>(0,0) << std::endl;
    return results.at<double>(0,0);
}
@end


