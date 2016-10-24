//
//  math.swift
//  swix
//
//  Created by Scott Sievert on 7/11/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

extension Vector {
    // MARK: - integration
    public func cumtrapz()->Vector{
        // integrate and see the steps at each iteration
        let y = Vector(zerosLike:self)
        var dx:CDouble = 1.0
        vDSP_vtrapzD(!self, 1.stride, &dx, !y, 1.stride, n.length)
        return y
    }
    public func trapz()->Double{
        // integrate and get the final value
        return self.cumtrapz()[-1]
    }
    // MARK: - basic definitions
    public func inner(_ y:Vector)->Double{
        // the inner product. aka dot product, but I use dot product as a short for matrix multiplication
        return (self * y).sum()
    }
    public func outer(_ y:Vector)->Matrix{
        // the outer product.
        let (xm, ym) = meshgrid(self, y: y)
        return xm * ym
    }
    // MARK: - fourier transforms
    public func fft() -> (Vector, Vector){
        var yr = Vector(zeros:n)
        var yi = Vector(zeros:n)
        
        // setup for the accelerate calling
        let radix:FFTRadix = FFTRadix(FFT_RADIX2)
        let pass:vDSP_Length = vDSP_Length((Darwin.log2(n.double)+1.0).int)
        let setup:FFTSetupD = vDSP_create_fftsetupD(pass, radix)!
        let log2n:Int = (Darwin.log2(n.double)+1.0).int
        let z = Vector(zeros:n)
        var x2:DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !self, imagp:!z)
        var y = DSPDoubleSplitComplex(realp:!yr, imagp:!yi)
        let dir = FFTDirection(FFT_FORWARD)
        let stride = 1.stride
        
        // perform the actual computation
        vDSP_fft_zropD(setup, &x2, stride, &y, stride, log2n.length, dir)
        
        // free memory
        vDSP_destroy_fftsetupD(setup)
        
        // this divide seems wrong
        yr /= 2.0
        yi /= 2.0
        return (yr, yi)
    }
    public func ifft(_ yi: Vector) -> Vector{
        var x = Vector(zeros:n)
        
        // setup for the accelerate calling
        let radix:FFTRadix = FFTRadix(FFT_RADIX2)
        let pass:vDSP_Length = vDSP_Length((Darwin.log2(n.double)+1.0).int)
        let setup:FFTSetupD = vDSP_create_fftsetupD(pass, radix)!
        let log2n:Int = (Darwin.log2(n.double)+1.0).int
        let z = Vector(zeros:n)
        var x2:DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !self, imagp:!yi)
        var result:DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !x, imagp:!z)
        let dir = FFTDirection(FFT_INVERSE)
        let stride = 1.stride
        
        // doing the actual computation
        vDSP_fft_zropD(setup, &x2, stride, &result, stride, log2n.length, dir)
        
        // this divide seems wrong
        x /= 16.0
        return x
    }
    public func fftconvolve(_ kernel:Vector)->Vector{
        // convolve two arrays using the fourier transform.
        // zero padding, assuming kernel is smaller than x
        var k_pad = Vector(zerosLike:self)
        k_pad[0..<kernel.n] = kernel
        
        // performing the fft
        let (Kr, Ki) = k_pad.fft()
        let (Xr, Xi) = self.fft()
        
        // computing the multiplication (yes, a hack)
        // (xr+xi*j) * (yr+yi*j) = xr*xi - xi*yi + j*(xi*yr) + j*(yr*xi)
        let Yr = Xr*Kr - Xi*Ki
        let Yi = Xr*Ki + Xi*Kr
        return Yr.ifft(Yi)
    }
}
