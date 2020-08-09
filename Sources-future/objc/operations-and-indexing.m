//
//  indexing.m
//  swix
//
//  Created by Scott Sievert on 7/13/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <stdint.h>
void test(){
    int N = 1000;
    double * x = (double*)malloc(sizeof(double) * N);
    double * y = (double*)malloc(sizeof(double) * N);
    for (int i=0; i<N; i++){ x[i] = i; y[i] = 0;}
    
    dispatch_apply(N, dispatch_get_global_queue(0, 0), ^(size_t i){
        y[i] = x[i]+1;
    });
    
    for (int i=0; i<N; i++){
        double value = x[i]+1 - y[i];
        if (!(value==0)){
            printf("%.2e, ", value);
        }
    }
    printf("\n");
}

// UNOPTIMIZED
void index_xa_b_objc(double* x, double* a, double* b, int N){
    int * j = (int *)malloc(sizeof(int) * N);
    vDSP_vfix32D(a, 1, j, 1, N); // double to int
    
    for (int i=0; i<N; i++){
        x[j[i]] = b[i];
    }
    free(j);
}

// OPTIMIZED
double* zeros_objc(int N){
    double * x = (double *)malloc(sizeof(double) * N);
    double value = 0.0;
    vDSP_vfillD(&value, x, 1, N);
    return x;
}
























