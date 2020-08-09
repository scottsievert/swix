//
//  fft.m
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

void svd_objc(double * xx, int m, int n, double* s, double* vt, double* u, int compute_uv){
    // adapted from the buggy code at http://stackoverflow.com/questions/5047503/lapack-svd-singular-value-decomposition
    
    char job;
    if      (compute_uv == 0) job = 'N';
    else if (compute_uv == 1) job = 'A';
    
    __CLPK_integer lda = (__CLPK_integer)m;
    long numberOfSingularValues = m < n ? m : n;
    
    // Workspace and status variables:
    __CLPK_integer _n = n;
    __CLPK_integer _m = m;
    double* work = (double*)malloc(sizeof(double) * 2);
    __CLPK_integer lwork = -1;
    __CLPK_integer * iwork = (__CLPK_integer *)malloc(sizeof(__CLPK_integer) * 8 * numberOfSingularValues);
    __CLPK_integer info = 0;
    
    // Call dgesdd_ with lwork = -1 to query optimal workspace size:
    dgesdd_(&job, &_m, &_n, xx, &lda, s, u, &_m, vt, &_n, work, &lwork, iwork, &info);
    
    // Optimal workspace size is returned in work[0].
    lwork = work[0];
    free(work);
    work = (double *)malloc(lwork * sizeof(double));
    
    // Call dgesdd_ to do the actual computation:
    dgesdd_(&job, &_m, &_n, xx, &lda, s, u, &_m, vt, &_n, work, &lwork, iwork, &info);
    
    free(work);
    free(iwork);
}























