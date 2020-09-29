//
//  Error+NSError.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

extension Swift.Error {
    
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
