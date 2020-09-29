//
//  PushPermissionTaskProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

typealias PushPermissionTaskSuccess = (PushPermissionState) -> Void
typealias PushPermissionTaskFailure = (Swift.Error) -> Void

protocol PushPermissionTaskProtocol: class {

    func start(onSuccess:@escaping PushPermissionTaskSuccess,
               onFailure:@escaping PushPermissionTaskFailure)
}
