//
//  PushRegistratorTaskProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public typealias PushRegistratorTaskSuccess = (PushRegistrationState) -> Void
public typealias PushRegistratorTaskFailure = (Swift.Error) -> Void

public protocol PushRegistratorTaskProtocol {
    
    func start(onSuccess:@escaping PushRegistratorTaskSuccess,
               onFailure:@escaping PushRegistratorTaskFailure)
}
