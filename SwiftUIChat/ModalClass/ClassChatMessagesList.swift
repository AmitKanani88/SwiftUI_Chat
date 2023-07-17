//
//  ClassChatMessagesList.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//

import Foundation

struct ClassChatMessages : Codable {
    
    let code : Int?
    let data : ClassChatMessagesData?
    let event : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data
        case event = "event"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(ClassChatMessagesData.self, forKey: .data)
        event = try values.decodeIfPresent(String.self, forKey: .event)
    }
    
}

struct ClassChatMessagesData : Codable {
    
    let messageList : [ClassChatMessagesMessageList]?
    let messageInfo : ClassChatMessagesMessageInfo?
    
    enum CodingKeys: String, CodingKey {
        case messageList = "messageList"
        case messageInfo = "messageInfo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        messageList = try values.decodeIfPresent([ClassChatMessagesMessageList].self, forKey: .messageList)
        messageInfo = try values.decodeIfPresent(ClassChatMessagesMessageInfo.self, forKey: .messageInfo)
    }
    
}

struct ClassChatMessagesMessageList : Codable {
    
    let v : Int?
    let id : String?
    let createdAt : String?
    let isDeleted : Bool?
    let isRead : Bool?
    let receiver : ClassChatMessagesReceiver?
    let sender : ClassChatMessagesSender?
    let text : String?
    let files : [String]?
    let updatedAt : String?
    let isSender: Bool?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt = "createdAt"
        case isDeleted = "is_deleted"
        case isRead = "is_read"
        case receiver
        case sender
        case text = "text"
        case updatedAt = "updatedAt"
        case isSender = "isSender"
        case files = "files"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead)
        receiver = try values.decodeIfPresent(ClassChatMessagesReceiver.self, forKey: .receiver)
        sender = try values.decodeIfPresent(ClassChatMessagesSender.self, forKey: .sender)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        isSender = try values.decodeIfPresent(Bool.self, forKey: .isSender)
        files = try values.decodeIfPresent([String].self, forKey: .files)
    }
}

struct ClassChatMessagesMessageInfo : Codable {
    
    let v : Int?
    let id : String?
    let createdAt : String?
    let isDeleted : Bool?
    let isRead : Bool?
    let receiver : String?
    let receiverProfilePic : String?
    let sender : String?
    let senderProfilePic : String?
    let text : String?
    let files : [String]?
    let updatedAt : String?
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt = "createdAt"
        case isDeleted = "is_deleted"
        case isRead = "is_read"
        case receiver = "receiver"
        case receiverProfilePic = "receiver_profilePhoto"
        case sender = "sender"
        case senderProfilePic = "sender_profilePhoto"
        case text = "text"
        case files = "files"
        case updatedAt = "updatedAt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isRead = try values.decodeIfPresent(Bool.self, forKey: .isRead)
        receiver = try values.decodeIfPresent(String.self, forKey: .receiver)
        receiverProfilePic = try values.decodeIfPresent(String.self, forKey: .receiverProfilePic)
        sender = try values.decodeIfPresent(String.self, forKey: .sender)
        senderProfilePic = try values.decodeIfPresent(String.self, forKey: .senderProfilePic)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        files = try values.decodeIfPresent([String].self, forKey: .files)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct ClassChatMessagesReceiver : Codable {
    
    let profilePhoto : String?
    let name : String?
    let receiver : String?
    
    enum CodingKeys: String, CodingKey {
        case profilePhoto = "ProfilePhoto"
        case name = "name"
        case receiver = "receiver"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profilePhoto = try values.decodeIfPresent(String.self, forKey: .profilePhoto)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        receiver = try values.decodeIfPresent(String.self, forKey: .receiver)
    }
    
}

struct ClassChatMessagesSender : Codable {
    
    let profilePhoto : String?
    let name : String?
    let sender : String?
    
    enum CodingKeys: String, CodingKey {
        case profilePhoto = "ProfilePhoto"
        case name = "name"
        case sender = "sender"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profilePhoto = try values.decodeIfPresent(String.self, forKey: .profilePhoto)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sender = try values.decodeIfPresent(String.self, forKey: .sender)
    }
    
}


