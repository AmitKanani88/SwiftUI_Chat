//
//  ClassInboxList.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//

import Foundation

struct ClassInboxList : Codable {
    
    let code : Int?
    let data : ClassInboxData?
    let event : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data
        case event = "event"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(ClassInboxData.self, forKey: .data)
        event = try values.decodeIfPresent(String.self, forKey: .event)
    }
    
}

struct ClassInboxData : Codable {
    
    let userList : [ClassInboxUserList]?
    let unreadCount : Int?
    let messages: String?
    
    enum CodingKeys: String, CodingKey {
        case userList = "userList"
        case unreadCount = "unreadCount"
        case messages = "messages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userList = try values.decodeIfPresent([ClassInboxUserList].self, forKey: .userList)
        unreadCount = try values.decodeIfPresent(Int.self, forKey: .unreadCount)
        messages = try values.decodeIfPresent(String.self, forKey: .messages)
    }
    
}

struct ClassInboxUserList : Codable {
    static func == (lhs: ClassInboxUserList, rhs: ClassInboxUserList) -> Bool {
        return true
    }
    
    
    let profilePhoto : String?
    let userId : String?
    let lastMessage : ClassInboxLastMessage?
    let name : String?
    let unreadCount : Int?
    
    enum CodingKeys: String, CodingKey {
        case profilePhoto = "ProfilePhoto"
        case userId = "UserId"
        case lastMessage = "lastMessage"
        case name = "name"
        case unreadCount = "unreadCount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profilePhoto = try values.decodeIfPresent(String.self, forKey: .profilePhoto)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        lastMessage = try values.decodeIfPresent(ClassInboxLastMessage.self, forKey: .lastMessage)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        unreadCount = try values.decodeIfPresent(Int.self, forKey: .unreadCount)
    }
    
}

struct ClassInboxLastMessage : Codable {
    
    let id : String?
    let isRead : Bool?
    let text : String?
    let isOnline : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isRead = "is_read"
        case text = "text"
        case isOnline = "is_online"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)

    }
    
}
