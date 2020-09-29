//
//  PushRegistratorTaskProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

typealias PushRegistratorTaskSuccess = (PushRegistrationState) -> Void
typealias PushRegistratorTaskFailure = (Swift.Error) -> Void

protocol PushRegistratorTaskProtocol {
    
    func start(onSuccess:@escaping PushRegistratorTaskSuccess,
               onFailure:@escaping PushRegistratorTaskFailure)
}
