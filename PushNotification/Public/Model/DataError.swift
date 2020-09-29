//
//  DataError.swift
//  PushNotification
//
//  Created by Pawel Klapuch on 9/28/20.
//

import Foundation

enum DataError: CustomNSError {

    case invalidBase64String
    
    case invalidData
}
