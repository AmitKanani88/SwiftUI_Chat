//
//  Messages.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//
import Foundation

struct Messages: Codable {

  var message  : String? = nil
  var id       : String? = nil
  var type     : String? = nil
  var senderId : String? = nil
  var createdAt : Int? = nil
  enum CodingKeys: String, CodingKey {

    case message  = "message"
    case id       = "id"
    case type     = "type"
    case senderId = "senderId"
    case createdAt = "createdAt"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    message  = try values.decodeIfPresent(String.self , forKey: .message  )
    id       = try values.decodeIfPresent(String.self , forKey: .id       )
    type     = try values.decodeIfPresent(String.self , forKey: .type     )
    senderId = try values.decodeIfPresent(String.self , forKey: .senderId )
    createdAt = try values.decodeIfPresent(Int.self   , forKey: .createdAt)
  }

  init() {

  }

}
