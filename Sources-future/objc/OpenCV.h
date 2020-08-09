//
//  fft.m
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

#import <opencv2/opencv.hpp>
#import <opencv2/core/core.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/ml/ml.hpp>

@interface CVWrapper : NSObject
+ (void) pointerTest;
+ (void) repeat:(double *)x to:(double*)y n_x:(int)Nx n_repeat:(int)Nrepeat;
+ (void) solve:(double *)A b:(double*)b x:(double*)x m:(int)m n:(int)n;
+ (void) compare:(double*)x with:(double*)y using:(NSString*)op into:(double*)z ofLength:(int)N;
+ (void) compare:(double*)x withDouble:(double)y
           using:(NSString*)op into:(double*)z ofLength:(int)N;
+ (void) flip:(double*)x into:(double*)y how:(NSString*)how M:(int)M N:(int)N;
+ (void) argmax:(double*)x N:(int)N max:(int*)max;
+ (void) argmin:(double*)x N:(int)N min:(int*)min;
+ (void) argsort:(double*)x N:(int)N into:(int*)y;
+ (void) pow:(double*)x N:(int)N power:(double)power into:(double*)y;
+ (void) shuffle:(double*)x n:(int)n;
+ (void) det:(double*)x n:(int)N m:(int)M result:(double*)result;

@end

// #### SVM (svm.mm)
@interface cvSVM : NSObject{
}
- (void) train:(double *)x targets:(double *)targets m:(int)M n:(int)N;
- (float) predict:(double *)x n:(int)N;
- (double*) predict:(double*)x into:(double*)y m:(int)M n:(int)N;
-(void)setParams:(NSString*)svm_type kernel:(NSString*)kernel nu:(float)nu;
@end

// #### k nearest neighbors (knn.mm)
@interface kNN : NSObject{
}
- (void) train:(double *)x targets:(double *)tar m:(int)M n:(int)N;
- (double) predict:(double *)x n:(int)N k:(int)k;
@end
