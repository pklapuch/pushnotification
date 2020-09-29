//
//  PushPermissionState.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

/**
Represents last known app/system remote notifications state
State is refreshed: on app launch and on PN authorization changes
 */
struct PushPermissionState {
    
    let granted: Bool
    let authorized: Bool
    
    static var unknown: PushPermissionState {
        
        return PushPermissionState(granted: false,
                                   authorized: false)
    }

    var description: String {
        
        var components = [String]()
        if !granted { components.append("not granted!") }
        if !authorized { components.append("not authorized!") }
        
        return components.joined(separator: ";")
    }
}
