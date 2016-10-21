//
//  io.swift
//  swix
//
//  Created by Scott Sievert on 11/7/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

// vector binary
func write_binary(_ x:vector, filename:String){
    let N = x.n
    let data = Data(bytes: x.grid, count:N*MemoryLayout<Double>.size)
    try? data.write(to: URL(fileURLWithPath: filename), options: [])
}
func read_binary(_ filename:String) -> vector{
    let read = try? Data(contentsOf: URL(fileURLWithPath: filename))
    try? read?.write(to:URL(fileURLWithPath:filename+"x"), options:[])
    let l:Int! = read?.count
    let sD:Int = MemoryLayout<Double>.size
    let count = (l.double / sD.double)
    
    let y = zeros(count.int)
    (read as NSData?)?.getBytes(!y, length: count.int*MemoryLayout<Double>.size)
    return y
}

// matrix binary
func write_binary(_ x:matrix, filename:String){
    let y = concat(array(x.shape.0.double, x.shape.1.double), y: x.flat)
    write_binary(y, filename:filename)
}
func read_binary(_ filename:String)->matrix{
    var a:vector = read_binary(filename)
    let (w, h) = (a[0], a[1])
    return reshape(a[2..<a.n], shape: (w.int,h.int))
}

// vector csv
func write_csv(_ x:vector, filename:String){
    // write the array to CSV
    var seperator=","
    var str = ""
    for i in 0..<x.n{
        seperator = i == x.n-1 ? "" : ","
        str += String(format: "\(x[i])"+seperator)
    }
    str += "\n"
    do {
        try str.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
    } catch {
        Swift.print("File probably wasn't recognized")
    }
    
}
func read_csv(_ filename:String) -> vector{
    var x: String?
    do {
        x = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)
    } catch _ {
        x = nil
    }
    var array:[Double] = []
    var columns:Int = 0
    var z = x!.components(separatedBy: ",")
    columns = 0
    for i in 0..<z.count{
        let num = z[i]
        array.append(num.doubleValue)
        columns += 1
    }
    var done = zeros(1 * columns)
    done.grid = array
    return done
}

class CSVFile{
    var data: matrix
    var header: [String]
    init(data: matrix, header: [String]){
        self.data = data
        self.header = header
    }
}

// for matrix csv
func read_csv(_ filename:String, header_present:Bool=true, _ rowWithoutMissingValues: Int=1) -> CSVFile{
    var x: String?
    do {
        x = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)
    } catch _ {
        x = nil
    }
    //There are three types of line breaks: \r, \n and \r\n. All change to \n.
    x=x!.replacingOccurrences(of: "\r\n",with: "\n")  //Remove \r if \r\n
    x=x!.replacingOccurrences(of: "\r",with: "\n")  //Change \r if there is any
    var y = x!.components(separatedBy: "\n")
    let rows = y.count-1
    var array:[Double] = []
    var columns:Int = 0
    var startrow:Int = 0    //The first row of the data
    if (header_present) { startrow = 1 }
    
    var categorical_col:[Int]=[]    //Record the columns which are categorical variables

    let test = y[rowWithoutMissingValues + startrow - 1].components(separatedBy: ",") //Use first row to detect which columns are categorical
    categorical_col = Array(repeating: -1, count: test.count)
    columns=0
    for testtext in test{
        if(Double(testtext) == nil){
        categorical_col[columns]=0    //If column j is categorical, then categorical_col[j] = 0; otherwise -1.
        }
        columns=columns+1
    }
    var factor = [String:Int]() //Dictionary to map categorical levels -> integer
    var levels = Set<String>()  //Set to store all categorical levels
    for i in startrow..<rows{
        let z = y[i].components(separatedBy: ",")
        columns = 0
        for text in z{
            if(Double(text) != nil)
            {
                array.append(Double(text)!)
            }
            else
            {
                let name=String(columns)+text   //In case two columns have same categorical levels, we add prefix
                if(levels.contains(name))
                {
                    array.append(Double(factor[name]!)) //If in this column we have already seen this level, then use it
                }
                else{   //Otherwise, we add a level to this column
                    factor[name]=categorical_col[columns]
                    levels.insert(name)
                    categorical_col[columns]=categorical_col[columns]+1 //Each column will record how many levels it has already encountered.
                    array.append(Double(factor[name]!))
                }
            }
            columns += 1
        }
    }
    
    var done = zeros((rows - startrow, columns))
    
    done.flat.grid = array
    
    if (header_present==true){
        return CSVFile(data: done, header: y[0].components(separatedBy: ","))
    }
    else{
         return CSVFile(data: done, header: [""])
    }
}

func write_csv(_ csv:CSVFile, filename:String){
    write_csv(csv.data, filename:filename, header:csv.header)
}

func write_csv(_ x:matrix, filename:String, header:[String] = [""]){
    var seperator=","
    var str = ""
    var i:Int=1
    if (header != [""]){
        for vname in header{
            if(i<header.count){
                str=str+vname+","
                i=i+1
            }
            else{
                str=str+vname+"\n"
            }
        }
    }
    for i in 0..<x.shape.0{
        for j in 0..<x.shape.1{
            seperator = j == x.shape.1-1 ? "" : ","
            str += String(format: "\(x[i, j])"+seperator)
        }
        str += "\n"
    }
    do {
        try str.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
    } catch {
        Swift.print("Error writing to CSV: filename probably wasn't recognized.")
    }
}

