//
//  Data+Hex.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

extension Data {
    
    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
    
    public static func from(hexString: String) throws -> Data {
        
        guard let data = Data(hexString: hexString) else {
            throw DataError.invalidData
        }
        return data
    }
    
    init?(hexString: String) {
        
        let len = hexString.count / 2
        var data = Data(capacity: len)
        
        for i in 0..<len {
            
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            
            if var num = UInt8(bytes, radix: 16) {
                
                data.append(&num, count: 1)
                
            } else {
                
                return nil
            }
        }
        
        self = data
    }
    
    var hexString: String {
        
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        })).uppercased()
    }
    
    func subdata(in range: ClosedRange<Index>) -> Data {
        
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
}
