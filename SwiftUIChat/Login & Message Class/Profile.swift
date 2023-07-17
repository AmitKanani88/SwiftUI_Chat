//
//  Profile.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//
import Foundation

struct Profile: Codable {

  var username : String? = nil

  enum CodingKeys: String, CodingKey {

    case username = "username"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    username = try values.decodeIfPresent(String.self , forKey: .username )
 
  }

  init() {

  }

}
