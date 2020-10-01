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
public struct PushPermissionState {
    
    public let granted: Bool
    public let authorized: Bool
    
    public init(granted: Bool, authorized: Bool) {
        self.granted = granted
        self.authorized = authorized
    }
    
    public static var unknown: PushPermissionState {
        
        return PushPermissionState(granted: false,
                                   authorized: false)
    }

    public var description: String {
        
        var components = [String]()
        if !granted { components.append("not granted!") }
        if !authorized { components.append("not authorized!") }
        
        return components.joined(separator: ";")
    }
}
