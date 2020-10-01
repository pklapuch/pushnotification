//
//  PushSystemPermissionEventProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public protocol PushSystemPermissionEventProtocol: class {
    
    func didReceiveAuthorization(_ granted: Bool , error: Swift.Error?)
    
    func didReceiveSettings(_ settings: NotificationSettingsProtocol)
}
