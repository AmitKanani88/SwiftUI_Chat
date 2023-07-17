//
//  SocketIOManager.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//

import Foundation
import SocketIO

final class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    var manager : SocketManager?
    private var socket : SocketIOClient?
    
    var isjoinChat = false
    var isConnected : Bool = false
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    func configureSocketClient() {
        guard let url = URL(string: "https://api.spouze.co/") else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        
        guard let manager = manager else {
            return
        }
    }
    
    func establishConnection() {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        if !isConnected {
            socket.connect()
            socket.on(clientEvent: .connect) { [weak self] (data, ack) in
                print("----------Socket Connected----------")
                self?.isConnected = true
//                if UserDefaultKeys.userDefaults.bool(forKey: UserDefaultKeys.UD_UserLoggedIn) {
                    self?.authenticateSocket()
//                }
            }
            socket.on(clientEvent: .error) { [weak self] (data, ack) in
                print(data)
            }
        }
    }
    
    func closeConnection() {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        if socket.status == .connected {
            socket.emit("disconnected")
            print("----------Socket Disconnected----------")
            self.isConnected = false
        }
    }
    
    func authenticateSocket() {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("authenticate") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("Authentication",dicMessage)
        }
        
        if socket.status == .connected {
            let userId = UserDefaultKeys.userDefaults.string(forKey: UserDefaultKeys.UD_UserId)
            socket.emit("authenticate", ["UserId": userId])
        }
    }
    
    func getInboxList(completion: @escaping(ClassInboxList) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.on("response") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("Got chat list:- \(dicMessage)")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)
                
                let objInboxList = try JSONDecoder().decode(ClassInboxList.self, from: jsonData)
                return completion(objInboxList)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if socket.status == .connected {
            var parameters : [String: Any] = [:]
            parameters["event"] = "getAllChat"
            parameters["data"] = [:]
            socket.emit("request", parameters) {
                print("eventes fsfdj")
            }
        }
    }
    
    func getChatMessagesList(receiverId: String, completion: @escaping(ClassChatMessages) -> Void) {
        guard let socket = manager?.defaultSocket, socket.status == .connected else {
            return
        }
        
        socket.on("response") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("Receive Messages ----->>",dicMessage)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)
                let objMessagesList = try JSONDecoder().decode(ClassChatMessages.self, from: jsonData)
                
                if objMessagesList.data?.messageList == nil {
                    print("--------CALLING AGET------- \(objMessagesList)")
                }
                
                return completion(objMessagesList)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let userId = UserDefaultKeys.userDefaults.string(forKey: UserDefaultKeys.UD_UserId)
        
        if socket.status == .connected {
            var parameters : [String: Any] = [:]
            var param: [String : Any] = [:]
            param["receiver"] = receiverId
            param["sender"] = userId
            param["limit"] = 20
            parameters["data"] = param
            parameters["event"] = "getMessageList"
            socket.emit("request", parameters)
        }
    }

    
    func sendNewMessage(receiverId: String, message: String, files : [String] = [], completion: @escaping(ClassChatMessages) -> Void) {
        guard let socket = manager?.defaultSocket, socket.status == .connected else {
            return
        }
        if socket.status == .connected {
            var parameters : [String: Any] = [:]
            var param: [String : Any] = [:]
            param["receiver"] = receiverId
            param["text"] = message
            param["files"] = files
            parameters["data"] = param
            parameters["event"] = "sendMessage"
            socket.emit("request", parameters)
            
            print("send msg---------->>>",parameters)
            
        }
        
        socket.on("response") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("dicMessage -------->>>",dicMessage)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)
                let objMessagesList = try JSONDecoder().decode(ClassChatMessages.self, from: jsonData)
                return completion(objMessagesList)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getUnreadMessageCount(completion: @escaping(ClassInboxList) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.on("response") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("Got Unread msg list:- \(dicMessage)")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)

                let objUnreadMessages = try JSONDecoder().decode(ClassInboxList.self, from: jsonData)
                return completion(objUnreadMessages)
            } catch {
                print(error.localizedDescription)
            }
        }

        if socket.status == .connected {
            var parameters : [String: Any] = [:]
            parameters["event"] = "getMessageUnreadCount"
            parameters["data"] = [:]
            socket.emit("request", parameters) {
                print("eventes unread messages count")
            }
        }
    }
    
    func readMessages(senderId: String, completion: @escaping(ClassInboxList) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.on("response") { (data, ack) in
            guard let dicMessage = data[0] as? [String:Any] else { return }
            print("Got chat list:- \(dicMessage)")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dicMessage, options: .prettyPrinted)

                let objUnreadMessages = try JSONDecoder().decode(ClassInboxList.self, from: jsonData)
                return completion(objUnreadMessages)
            } catch {
                print(error.localizedDescription)
            }
        }

        if socket.status == .connected {
            var parameters : [String: Any] = [:]
            parameters["event"] = "readMessages"
            parameters["data"] = [:]
            socket.emit("request", parameters) {
                print("read messages")
            }
        }
    }
}


