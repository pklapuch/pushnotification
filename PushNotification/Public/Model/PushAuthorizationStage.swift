//
//  PushAuthorizationStage.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

struct PushAuthorizationStage {
    
    var didRequest = false
    var didComplete = false
    var isGranted = false
    var error: Swift.Error?
}
