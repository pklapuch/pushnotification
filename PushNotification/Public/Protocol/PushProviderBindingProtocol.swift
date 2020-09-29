//
//  PushProviderBindingProtocol.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

protocol PushProviderBindingProtocol: class {
    
    func setPushSystemPermissionEventDelegate(_ delegate: PushSystemPermissionEventProtocol,
                                              completion: @escaping () -> Void)

    func setPushSystemRegisterEventDelegate(_ delegate: PushSystemRegisterEventProtocol,
                                            completion: @escaping () -> Void)
}
