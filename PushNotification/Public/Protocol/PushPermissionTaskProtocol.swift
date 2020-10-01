//
//  PushPermissionTaskProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public typealias PushPermissionTaskSuccess = (PushPermissionState) -> Void
public typealias PushPermissionTaskFailure = (Swift.Error) -> Void

public protocol PushPermissionTaskProtocol: class {

    func start(onSuccess:@escaping PushPermissionTaskSuccess,
               onFailure:@escaping PushPermissionTaskFailure)
}
