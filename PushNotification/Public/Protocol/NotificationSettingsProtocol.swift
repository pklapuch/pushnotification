//
//  NotificationSettingsProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

protocol NotificationSettingsProtocol {

    var isAuthorized: Bool { get }
    
    var authorizationStatusDescription: String { get }
}
