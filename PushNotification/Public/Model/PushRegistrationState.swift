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
struct PushRegistrationState {
    
    let supported: Bool
    let deviceToken: Data?
    
    static var unknown: PushRegistrationState {
        
        return PushRegistrationState(supported: true, deviceToken: nil)
    }

    var description: String {
        
        if !supported { return "not supported by device!" }
        
        var components = [String]()
        if !supported { components.append("not supported by device!") }
        if let token = deviceToken { components.append("token: \(token.hexString)") }
        return components.joined(separator: ";")
    }
}
