//
//  PushSystemRegisterEventProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

protocol PushSystemRegisterEventProtocol: class {

    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Swift.Error)
}
