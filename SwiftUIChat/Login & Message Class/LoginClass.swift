//
//  LoginClass.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//

import Foundation

struct LoginClass: Codable {
    
    var message      : String?  = nil
    var isSuccess    : Bool?    = nil
    var accessToken  : String?  = nil
    var refreshToken : String?  = nil
    var profile      : Profile? = Profile()
    var authToken : String?  = nil
    enum CodingKeys: String, CodingKey {
        
        case message      = "message"
        case isSuccess    = "isSuccess"
        case accessToken  = "accessToken"
        case refreshToken = "refreshToken"
        case profile      = "profile"
        case authToken = "authToken"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        message      = try values.decodeIfPresent(String.self  , forKey: .message      )
        isSuccess    = try values.decodeIfPresent(Bool.self    , forKey: .isSuccess    )
        accessToken  = try values.decodeIfPresent(String.self  , forKey: .accessToken  )
        refreshToken = try values.decodeIfPresent(String.self  , forKey: .refreshToken )
        profile      = try values.decodeIfPresent(Profile.self , forKey: .profile      )
        authToken      = try values.decodeIfPresent(String.self , forKey: .authToken   )
    }
    
    init() {
        
    }
    
}
