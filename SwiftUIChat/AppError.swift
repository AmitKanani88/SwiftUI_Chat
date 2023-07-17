//
//  AppError.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//

import Foundation

enum AppError: Error {
    case gettingJwtFailed
    case gettingChannelsListFailed
    case notAuthenticated
    case eThreeNotInitialized
    case invalidUrl
    case messagingNotInitialized
    case invalidResponse
}
