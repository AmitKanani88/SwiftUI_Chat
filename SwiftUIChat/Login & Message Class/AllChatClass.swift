//
//  AllChatClass.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//
import Foundation

struct AllChatClass: Codable {

  var messages  : [Messages]? = []
  var isSuccess : Bool?       = nil

  enum CodingKeys: String, CodingKey {

    case messages  = "messages"
    case isSuccess = "isSuccess"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    messages  = try values.decodeIfPresent([Messages].self , forKey: .messages  )
    isSuccess = try values.decodeIfPresent(Bool.self       , forKey: .isSuccess )
 
  }

  init() {

  }

}
