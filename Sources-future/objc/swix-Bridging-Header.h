//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// for speedy mathematical functions
#import <Accelerate/Accelerate.h>

// for the machine learning
#import "OpenCV.h"

// for various easier/faster-in-c operations
void index_xa_b_objc(double * x, double*a, double*b, int N);
void svd_objc(double * xx, int m, int n, double* sigma, double* vt, double* u, int compute_uv);
void test();



