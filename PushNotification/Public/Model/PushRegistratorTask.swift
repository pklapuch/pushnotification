//
//  PushRegistratorTask.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

public class PushRegistratorTask: NSObject {
    
    fileprivate struct PushErrorCode {
        
        static let notSupported = 3010
    }
    
    public enum SimulationMode {
        
        case none
        
        case simulate(token: Data)
    }

    private let queue = DispatchQueue(label: "pn_service")
    private var onSuccess: PushRegistratorTaskSuccess?
    private var onFailure: PushRegistratorTaskFailure?
    
    private weak var systemDelegate: PushSetupSystemProtocol?
    private weak var providerDelegate: PushProviderBindingProtocol?
    
    private var supported = true
    private var binding = PushBindingStage()
    private var authorization = PushAuthorizationStage()
    private var settings = PushSettingsStage()
    private var registration = PushRegisterStage()
    
    public var simulationMode = SimulationMode.none
    private(set) var didComplete: Bool = false
    
    public init(system: PushSetupSystemProtocol?, provider: PushProviderBindingProtocol) {
        
        self.systemDelegate = system
        self.providerDelegate = provider
    }
    
    private func updateState() {
        
        guard let systemDelegate = systemDelegate else { notify(Error.delegateNotSet); return }
        guard let providerDelegate = providerDelegate else { notify(Error.delegateNotSet); return }
        
        guard !bind(providerDelegate) else { return }
        guard !register(systemDelegate) else { return }
        
        let state = PushRegistrationState(supported: supported, deviceToken: registration.token)
        
        PushNotification.log?.apiLog(message: "PN service has completed: \(state.description)", type: .debug)
        didComplete = true
        notifyCompletion(state)
    }
    
    private func bind(_ provider: PushProviderBindingProtocol) -> Bool {
        
        if binding.isBinding { return true }
        guard !binding.isBinded else { return false }

        binding.isBinding = true
        provider.setPushSystemRegisterEventDelegate(self) { [weak self] in
            
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
    
    private func register(_ delegate: PushSetupSystemProtocol) -> Bool {

        if (registration.didRequest && !registration.didComplete) { return true }
        guard !registration.didRequest else { return false }

        PushNotification.log?.apiLog(message: "PN: -> register for remote notifications", type: .debug)
        registration.didRequest = true
        DispatchQueue.main.async { delegate.registerForRemoteNotifications() }
        return true
    }

    private func notify(_ error: Swift.Error) {
        
        onFailure?(error)
    }
    
    private func notifyCompletion(_ state: PushRegistrationState) {
        
        onSuccess?(state)
    }
}

extension PushRegistratorTask: PushSystemRegisterEventProtocol {
      
    public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        
        queue.async {
        
            PushNotification.log?.apiLog(message: "PN: << did register for remote notifications", type: .debug)
            self.registration.didComplete = true
            self.registration.token = deviceToken
            self.updateState()
        }
    }
    
    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Swift.Error) {
        
        queue.async {
            
            self.registration.didComplete = true
            
            if (error.code == PushErrorCode.notSupported) {
                
                switch self.simulationMode {
                
                case .none:
                    
                    PushNotification.log?.apiLog(message: "PN: << unable to register -> unsupported by device", type: .error)
                    self.supported = false
                    self.updateState()
                    
                case .simulate(token: let token):
                    
                    self.registration.token = token
                    self.supported = false
                    self.updateState()
                }
     
            } else {
                
                PushNotification.log?.apiLog(message: "PN: << failed to register remote notifications: \(error.localizedDescription)", type: .debug)
                self.notify(error)
            }
        }
    }
}

extension PushRegistratorTask: PushRegistratorTaskProtocol {
    
    public func start(onSuccess:@escaping PushRegistratorTaskSuccess, onFailure:@escaping PushRegistratorTaskFailure) {
      
        self.queue.async {
      
            self.onSuccess = onSuccess
            self.onFailure = onFailure
            self.updateState()
        }
    }
}

extension PushRegistratorTask {
    
    enum Error: CustomNSError {
        
        case invalidState
        
        case delegateNotSet
    }
}
