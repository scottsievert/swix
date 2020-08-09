//
//  knn.m
//  swix
//
//  Created by Scott Sievert on 7/1/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

#import <opencv2/core/core.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/ml/ml.hpp>

#import "OpenCV.h"
using namespace cv;

void copy(Mat x, double * y, int N);
@implementation CVWrapper
+ (void) pointerTest{
    // to test whether a matrix copies to the pointer
    // makes sense; the raw values have to be stored somewhere
    // it does not make sense that repeat( , 1, r, ) vs repeat( , r , 1) has a difference in shared data
    int N = 3;
    int r = 2;
    double * x = (double *)malloc(sizeof(double)* N);
    double * y = (double *)malloc(sizeof(double)* N * r);
    for (int i=0; i<N; i++) x[i] = i;
    Mat xMat(N, 1, CV_64F, x);
    Mat yMat(N * r, 1, CV_64F, y);

    repeat(xMat, r, 1, yMat);
    
    std::cout << yMat << std::endl;
    for (int i=0; i<N * r; i++) printf("%f, ", y[i]);
    printf("\n");
}
+ (void) flip:(double*)x into:(double*)y how:(NSString*)how M:(int)M N:(int)N{
    Mat xMat(M, N, CV_64F, x);
    Mat yMat(M, N, CV_64F, y);
    int direction=0;
    if ([how isEqualToString:@"ud"]) direction=0;
    if ([how isEqualToString:@"lr"]) direction=1;
    
    flip(xMat, yMat, direction);
}
+ (void) repeat:(double *)x to:(double *)y
            n_x:(int)n_x n_repeat:(int)n_repeat{
    Mat xMat(n_x, 1, CV_64F, x);
    Mat yMat(n_x * n_repeat, 1, CV_64F, y);
    
    repeat(xMat, n_repeat, 1, yMat);
}
+ (void) solve:(double *)A b:(double*)b x:(double*)x m:(int)m n:(int)n{
    Mat Amat(m, n, CV_64F, A);
    Mat bMat(m, 1, CV_64F, b);
    Mat xMat(n, 1, CV_64F, x);
    solve(Amat, bMat, xMat);
}
+ (void) compare:(double*)x with:(double*)y
           using:(NSString*)op into:(double*)z ofLength:(int)N{
    // this isn't working.
    // instead, I can do threshold(abs(x - y), 1e-9)
    
    // threshold: vDSP_vthrscD
    // abs can be vectorized, - vectorized
    Mat xMat(1, N, CV_64F, x);
    Mat yMat(1, N, CV_64F, y);
    Mat zMat;
    if      ([op isEqualToString:@"<"  ]) {zMat = xMat < yMat;}
    else if ([op isEqualToString:@">"  ]) {zMat = xMat > yMat;}
    else if ([op isEqualToString:@"<=" ]) {zMat = xMat <= yMat;}
    else if ([op isEqualToString:@">=" ]) {zMat = xMat >= yMat;}
    else if ([op isEqualToString:@"==" ]) {zMat = xMat == yMat;}
    else if ([op isEqualToString:@"!=="]) {compare(xMat, yMat, zMat, CMP_NE);}
    else printf("*** Careful! Your operation isn't recognized!\n");
    matArgWhereConvert(zMat, z, N);
}
+ (void) compare:(double*)x withDouble:(double)y
           using:(NSString*)op into:(double*)z ofLength:(int)N{
    
    // this isn't working.
    // instead, I can do threshold(abs(x - y), 1e-9)
    
    // threshold: vDSP_vthrscD
    Mat xMat(1, N, CV_64F, x);
    Mat zMat;
    if      ([op isEqualToString:@"<"  ]) {zMat = xMat < y;}
    else if ([op isEqualToString:@">"  ]) {zMat = xMat > y;}
    else if ([op isEqualToString:@"<=" ]) {zMat = xMat <= y;}
    else if ([op isEqualToString:@">=" ]) {zMat = xMat >= y;}
    else if ([op isEqualToString:@"==" ]) {zMat = xMat == y;}
    else if ([op isEqualToString:@"!=="]) {compare(xMat, y, zMat, CMP_NE);}
    else printf("*** Careful! Your operation isn't recognized!\n");
    matArgWhereConvert(zMat, z, N);
}

+ (void) argmax:(double*)x N:(int)N max:(int *)max{
    Mat xMat(N, 1, CV_64F, x);
    minMaxIdx(xMat, NULL, NULL, NULL, max);
}
+ (void) argmin:(double*)x N:(int)N min:(int *)min{
    Mat xMat(N, 1, CV_64F, x);
    minMaxIdx(xMat, NULL, NULL, min, NULL);
}
+ (void) argsort:(double*)x N:(int)N into:(int*)y{
    Mat xMat(N, 1, CV_64F, x);
    Mat yMat(N, 1, CV_32S, y);
    sortIdx(xMat, yMat, CV_SORT_ASCENDING + CV_SORT_EVERY_COLUMN);
}
+ (void) pow:(double*)x N:(int)N power:(double)power into:(double*)y{
    Mat xMat(N,1,CV_64F, x);
    Mat yMat(N,1,CV_64F, y);
    pow(xMat, power, yMat);
}
+ (void) shuffle:(double*)x n:(int)n{
    Mat xMat(n, 1, CV_64F, x);
    randShuffle(xMat);
}
+ (void) det:(double*)x n:(int)N m:(int)M result:(double*)result{
    Mat xMat(N, M, CV_64F, x);
    double r = determinant(xMat);
    *result = r;
}

void matArgWhereConvert(Mat x, double * y, int N){
    if  (!x.isContinuous()){
        printf("Careful! The OpenCV::Mat-->double* conversion didn't go well as x is not continuous in memory! (message printed from swix/objc/opencv.mm:matArgWhereConvert)\n");
    }
    uchar* ptr = x.data;
    // integer to double conversion
    vDSP_vfltu8D(ptr, 1, y, 1, N);
}
void copy(double* x, double * y, int N){
    cblas_dcopy(N, x, 1, y, 1);
}
@end


