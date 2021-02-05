//
//  PushRegistrationState.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

/**
Represents last known app/system remote notifications state
State is refreshed: on app launch and on PN authorization changes
 */
public struct PushRegistrationState {
    
    public let supported: Bool
    public let deviceToken: Data?
    
    public static var unknown: PushRegistrationState {
        
        return PushRegistrationState(supported: true, deviceToken: nil)
    }

    public var description: String {
        
        if !supported { return "not supported by device!" }
        
        var components = [String]()
        if !supported { components.append("not supported by device!") }
        if let token = deviceToken { components.append("token: \(token.count) bytes") }
        return components.joined(separator: ";")
    }
}
