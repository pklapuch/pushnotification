//
//  PushNotificationLogging.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public enum PNLoggingType {
    
    case debug
    
    case info
    
    case error
}

public protocol PNLogging {
    
    func apiLog(message: String, type: PNLoggingType)
}
