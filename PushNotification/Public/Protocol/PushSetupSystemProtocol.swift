//
//  PushSetupSystemProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public protocol PushSetupSystemProtocol: class {

    var isRegisteredForRemoteNotifications: Bool { get }
    
    func requestAuthorizationStatus()
    
    func requestNotificationSettings()
    
    func registerForRemoteNotifications()
}
