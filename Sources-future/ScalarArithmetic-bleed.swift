
// from https://github.com/seivan/ScalarArithmetic/
// bleeding as of 2014-11-8. Commit on Aug. 15th
// commented out because compile errors. not critical to this release.

import Darwin
import CoreGraphics


protocol FloatingPointMathType {
//  var acos:Self  {get}
//  var asin:Self  {get}
//  var atan:Self  {get}
//  func atan2(x:Self) -> Self
//  var cos:Self   {get}
//  var sin:Self   {get}
//  var tan:Self   {get}
//  var exp:Self   {get}
//  var exp2:Self  {get}
//  var log:Self   {get}
//  var log10:Self {get}
//  var log2:Self  {get}
//  func pow(exponent:Self) -> Self
//  var sqrt:Self  {get}
}


extension Double :  FloatingPointMathType {
//  var abs:Double  { return Double.abs(self)   }
//  var acos:Double { return Darwin.acos(self)  }
//  var asin:Double { return Darwin.asin(self)  }
//  var atan:Double { return Darwin.atan(self)  }
//  func atan2(x:Double) -> Double { return Darwin.atan2(self,x) }
//  var cos:Double  { return Darwin.cos(self)   }
//  var sin:Double  { return Darwin.sin(self)   }
//  var tan:Double  { return Darwin.tan(self)   }
//  var exp:Double  { return Darwin.exp(self)   }
//  var exp2:Double { return Darwin.exp2(self)  }
//  var log:Double  { return Darwin.log(self)   }
//  var log10:Double{ return Darwin.log10(self) }
//  var log2:Double { return Darwin.log2(self)  }
//  func pow(exponent:Double)-> Double { return Darwin.pow(self, exponent) }
//  var sqrt:Double { return Darwin.sqrt(self)  }
  func __conversion() -> CGFloat { return CGFloat(self) }
}



protocol ScalarFloatingPointType {
  var toDouble:Double { get }
  init(_ value:Double)
}

extension CGFloat : ScalarFloatingPointType, FloatingPointMathType {
  var toDouble:Double  { return Double(self)      }
//  var abs:CGFloat      { return self.abs  }
//  var acos:CGFloat     { return Darwin.acos(self) }
//  var asin:CGFloat     { return Darwin.asin(self) }
//  var atan:CGFloat     { return Darwin.atan(self) }
//  func atan2(x:CGFloat) -> CGFloat { return Darwin.atan2(self, x) }
//  var cos:CGFloat      { return Darwin.cos(self)  }
//  var sin:CGFloat      { return Darwin.sin(self)  }
//  var tan:CGFloat      { return Darwin.tan(self)  }
//  var exp:CGFloat      { return Darwin.exp(self)  }
//  var exp2:CGFloat     { return Darwin.exp2(self) }
//  var log:CGFloat      { return Darwin.log(self)  }
//  var log10:CGFloat    { return Darwin.log10(self)}
//  var log2:CGFloat     { return Darwin.log2(self)}
//  func pow(exponent:CGFloat)-> CGFloat { return Darwin.pow(self, exponent) }
//  var sqrt:CGFloat     { return Darwin.sqrt(self) }
  func __conversion() -> Double { return Double(self) }
}

extension Float : ScalarFloatingPointType { var toDouble:Double { return Double(self)      } }

protocol ScalarIntegerType : ScalarFloatingPointType {
   var toInt:Int { get }
}

extension Int : ScalarIntegerType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }
  var toInt:Int { return Int(self) }

}
extension Int16 : ScalarIntegerType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }
  var toInt:Int { return Int(self) }

}
extension Int32 : ScalarIntegerType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }
  var toInt:Int { return Int(self) }

}
extension Int64 : ScalarIntegerType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }
  var toInt:Int { return Int(self) }

}
extension UInt : ScalarFloatingPointType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }

}
extension UInt16  : ScalarFloatingPointType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }

}
extension UInt32 : ScalarFloatingPointType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }
}
extension UInt64 : ScalarFloatingPointType {
  var toDouble:Double { return Double(self) }
  func __conversion() -> Double { return Double(self) }

}





func + <T:ScalarIntegerType>(lhs:T, rhs:Int) -> Int { return lhs + rhs }
func + <T:ScalarIntegerType>(lhs:Int, rhs:T) -> Int { return lhs + rhs.toInt }

func - <T:ScalarIntegerType>(lhs:T, rhs:Int) -> Int { return lhs.toInt - rhs }
func - <T:ScalarIntegerType>(lhs:Int, rhs:T) -> Int { return lhs - rhs.toInt }

func * <T:ScalarIntegerType>(lhs:T, rhs:Int) -> Int { return lhs.toInt * rhs }
func * <T:ScalarIntegerType>(lhs:Int, rhs:T) -> Int { return lhs * rhs.toInt }

func / <T:ScalarIntegerType>(lhs:T, rhs:Int) -> Int { return lhs.toInt / rhs }
func / <T:ScalarIntegerType>(lhs:Int, rhs:T) -> Int { return lhs / rhs.toInt }



//Equality T<===>T
func == <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:U,rhs:T) -> Bool { return (lhs.toDouble == rhs.toDouble) }
func == <T:ScalarFloatingPointType> (lhs:Double,rhs:T) -> Bool { return (lhs == rhs.toDouble) }
func == <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs.toDouble == rhs) }

func != <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:U,rhs:T) -> Bool { return (lhs.toDouble == rhs.toDouble) == false }
func != <T:ScalarFloatingPointType> (lhs:Double,rhs:T) -> Bool { return (lhs == rhs.toDouble) == false }
func != <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs.toDouble == rhs) == false }

func <= <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:T,rhs:U) -> Bool { return (lhs.toDouble <= rhs.toDouble) }
func <= <T:ScalarFloatingPointType> (lhs:Double, rhs:T) -> Bool { return (lhs <= rhs.toDouble) }
func <= <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs.toDouble <= rhs) }

func < <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:T,rhs:U) -> Bool { return (lhs.toDouble <  rhs.toDouble) }
func < <T:ScalarFloatingPointType> (lhs:Double, rhs:T) -> Bool { return (lhs <  rhs.toDouble) }
func < <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs.toDouble <  rhs) }

func >  <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:T,rhs:U) -> Bool { return (lhs <= rhs) == false }
func >  <T:ScalarFloatingPointType> (lhs:Double, rhs:T) -> Bool { return (lhs <= rhs) == false}
func >  <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs <= rhs) == false }

func >= <T:ScalarFloatingPointType, U:ScalarFloatingPointType> (lhs:T,rhs:U) -> Bool { return (lhs < rhs) == false }
func >= <T:ScalarFloatingPointType> (lhs:Double, rhs:T) -> Bool { return (lhs < rhs) == false }
func >= <T:ScalarFloatingPointType> (lhs:T,rhs:Double) -> Bool { return (lhs < rhs) == false }



//SUBTRACTION
func - <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:U, rhs:T) -> Double  {return (lhs.toDouble - rhs.toDouble) }
func - <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> T  { return T(lhs - rhs.toDouble) }
func - <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> T  { return T(lhs.toDouble - rhs) }
func - <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> Double  { return (lhs - rhs.toDouble) }
func - <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> Double  { return (lhs.toDouble - rhs) }
func -= <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:inout T, rhs:U) { lhs = T(lhs.toDouble - rhs.toDouble) }
func -= <T:ScalarFloatingPointType>(lhs:inout Double, rhs:T)  { lhs = lhs - rhs.toDouble }

//ADDITION
func + <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:U, rhs:T) -> Double  {return (lhs.toDouble + rhs.toDouble) }
func + <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> T  { return T(lhs + rhs.toDouble) }
func + <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> T  { return T(lhs.toDouble + rhs) }
func + <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> Double  { return (lhs + rhs.toDouble) }
func + <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> Double  { return (lhs.toDouble + rhs) }
func += <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:inout T, rhs:U) { lhs = T(lhs.toDouble + rhs.toDouble) }
func += <T:ScalarFloatingPointType>(lhs:inout Double, rhs:T)  { lhs = lhs + rhs.toDouble }

//MULTIPLICATION
func * <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:U, rhs:T) -> Double  {return (lhs.toDouble * rhs.toDouble) }
func * <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> T  { return T(lhs * rhs.toDouble) }
func * <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> T  { return T(lhs.toDouble * rhs) }
func * <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> Double  { return (lhs * rhs.toDouble) }
func * <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> Double  { return (lhs.toDouble * rhs) }
func *= <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:inout T, rhs:U) { lhs = T(lhs.toDouble * rhs.toDouble) }
func *= <T:ScalarFloatingPointType>(lhs:inout Double, rhs:T)  { lhs = lhs * rhs.toDouble }

//DIVISION
func / <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:U, rhs:T) -> Double  {return (lhs.toDouble / rhs.toDouble) }
func / <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> T  { return T(lhs / rhs.toDouble) }
func / <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> T  { return T(lhs.toDouble / rhs) }
func / <T:ScalarFloatingPointType>(lhs:Double, rhs:T) -> Double  { return (lhs / rhs.toDouble) }
func / <T:ScalarFloatingPointType>(lhs:T, rhs:Double) -> Double  { return (lhs.toDouble / rhs) }
func /= <T:ScalarFloatingPointType, U:ScalarFloatingPointType>(lhs:inout T, rhs:U) { lhs = T(lhs.toDouble / rhs.toDouble) }
func /= <T:ScalarFloatingPointType>(lhs:inout Double, rhs:T)  { lhs = lhs / rhs.toDouble }


