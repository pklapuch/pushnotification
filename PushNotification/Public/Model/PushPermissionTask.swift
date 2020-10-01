//
//  PushPermissionTask.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public class PushPermissionTask {

    private let queue = DispatchQueue(label: "pn_perm_service")
    private var onSuccess: PushPermissionTaskSuccess?
    private var onFailure: PushPermissionTaskFailure?
    
    private weak var systemDelegate: PushSetupSystemProtocol?
    private weak var providerDelegate: PushProviderBindingProtocol?
    
    private var binding = PushBindingStage()
    private var authorization = PushAuthorizationStage()
    private var settings = PushSettingsStage()
    
    public init(system: PushSetupSystemProtocol?, provider: PushProviderBindingProtocol) {
        
        self.systemDelegate = system
        self.providerDelegate = provider
    }
    
    private func updateState() {
        
        guard let systemDelegate = systemDelegate else { notify(Error.delegateNotSet); return }
        guard let providerDelegate = providerDelegate else { notify(Error.delegateNotSet); return }
        
        guard !bind(providerDelegate) else { return }
        guard !requestAuthorizationStatus(systemDelegate) else { return }
        guard !requestNotificationSettings(systemDelegate) else { return }
        
        let state = PushPermissionState(granted: authorization.isGranted,
                                        authorized: settings.isAuthorized)
        
        PushNotification.log?.apiLog(message: "PN service has completed: \(state.description)", type: .debug)
        notifyCompletion(state)
    }
    
    private func bind(_ provider: PushProviderBindingProtocol) -> Bool {
        
        if binding.isBinding { return true }
        guard !binding.isBinded else { return false }

        binding.isBinding = true
        provider.setPushSystemPermissionEventDelegate(self) { [weak self] in
            
            self?.queue.async {
                
                self?.binding.isBinding = false
                self?.binding.isBinded = true
                self?.updateState()
            }
        }
        
        return true
    }
    
    private func requestAuthorizationStatus(_ delegate: PushSetupSystemProtocol) -> Bool {
        
        if (authorization.didRequest && !authorization.didComplete) { return true }
        guard !authorization.didRequest else { return false }
        
        PushNotification.log?.apiLog(message: "PN: -> request authorization status", type: .debug)
        authorization.didRequest = true
        
        DispatchQueue.main.async { delegate.requestAuthorizationStatus() }
        return true
    }
    
    private func requestNotificationSettings(_ delegate: PushSetupSystemProtocol) -> Bool {
        
        if (settings.didRequest && !settings.didComplete) { return true }
        guard !settings.didRequest else { return false }
        
        PushNotification.log?.apiLog(message: "PN: -> request notification settings", type: .debug)
        settings.didRequest = true
        DispatchQueue.main.async { delegate.requestNotificationSettings() }
        return true
    }
    
    private func notify(_ error: Swift.Error) {
        
        onFailure?(error)
    }
    
    private func notifyCompletion(_ state: PushPermissionState) {
        
        onSuccess?(state)
    }
}

extension PushPermissionTask: PushSystemPermissionEventProtocol {
        
    public func didReceiveAuthorization(_ granted: Bool , error: Swift.Error?) {
        
        queue.async {
        
            if let error = error {
             
                PushNotification.log?.apiLog(message: "PN: << authorization status -> error: \(error.localizedDescription)", type: .error)
                self.authorization.didComplete = true
                self.authorization.error = error
                self.notify(error)
                
            } else {
            
                PushNotification.log?.apiLog(message: "PN: << granted: \(granted)", type: .debug)
                self.authorization.didComplete = true
                self.authorization.isGranted = granted
            }
            
            self.updateState()
        }
    }
    
    public func didReceiveSettings(_ settings: NotificationSettingsProtocol) {
        
        queue.async {
        
            PushNotification.log?.apiLog(message: "PN: << notifications: \(settings.authorizationStatusDescription)", type: .debug)
            self.settings.didComplete = true
            self.settings.isAuthorized = settings.isAuthorized
            self.updateState()
        }
    }
}

extension PushPermissionTask: PushPermissionTaskProtocol {
    
    public func start(onSuccess: @escaping PushPermissionTaskSuccess, onFailure: @escaping PushPermissionTaskFailure) {
        
        queue.async {
            
            self.onSuccess = onSuccess
            self.onFailure = onFailure
            self.updateState()
        }
    }
}

extension PushPermissionTask {
    
    enum Error: CustomNSError {
        
        case invalidState
        
        case delegateNotSet
    }
}
