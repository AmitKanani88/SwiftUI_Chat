//
//  ChatVC.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//

import SwiftUI
import Kingfisher
import Combine
import UIKit
import VirgilE3Kit
import Alamofire
struct ChatVC: View {
    var arrInbox:ClassInboxUserList?
    
    var userName: String = ""
    
    let alice = Device(withIdentity: "HB")

    var aliceLookup: FindUsersResult?
    
    @State var receiverId: String = ""
    @State var receiverName: String = ""
    @State var typingMessage: String = ""
    
    @State var message:[Messages] = []
    
    let userId = UserDefaultKeys.userDefaults.string(forKey: UserDefaultKeys.UD_UserId)
    @State var arrMessagesList: [ClassChatMessagesMessageList]?
    @State var arrayMessages:[ClassChatMessagesMessageList] = []
    @State var getMessageFirstTime:Bool = true
    @State var isSentBtnTapped:Bool = false
    @State var isMessageSent: Bool = false
    
    @State private var image: Image? = Image("karthick")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldScrollToBottom = false
    
    @State private var isChatVCopen = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    if arrayMessages.count > 0 {
                        ForEach(0..<arrayMessages.count, id: \.self) { index in
                            MessageView(currentMessage: arrayMessages[index],userId: userId ?? "")
                        }.listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        
                    }
                }.padding(-20)
                
                HStack {
//                    Button {
//                        shouldPresentActionScheet = true
//                    } label: {
//                        Image(systemName: "plus").padding(10)
//                    }

                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(40))
                        .cornerRadius(0)
                        .padding(12)
                    Button(action: sendMessage) {
                        Text("Send")
                            .padding(10)
                    }
                }.frame(minHeight: CGFloat(50))
            }.navigationBarHidden(true)
                .sheet(isPresented: $shouldPresentImagePicker) {
                                ImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = true
                            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = false
                            }), ActionSheet.Button.cancel()])
                        }
        }
        
        .onAppear {
            
//            // Create the URL request
//            let url = URL(string: "https://63de-2405-201-200c-823f-5106-90ac-5586-738a.ngrok-free.app/load-chat")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let token = UserDefaults.standard.string(forKey: "authToken")
//            print("token ")
//            request.setValue("\(token!)", forHTTPHeaderField: "Authorization")
//
//            // Create a URLSessionDataTask and send the request
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                    return
//                }
//
//                // Process the response
//                if let data = data {
//                    let modal = try? JSONDecoder().decode(AllChatClass.self, from: data)
//                    print("Modal :- \(response?.description)")
////                    message = (modal?.messages)!
//                    print("\(modal?.messages)")
//                    print("User Name \(userName)")
//                }
//            }
//
//            task.resume()
            
           // MARK: -
            receiverId = arrInbox?.userId ?? ""
            receiverName = arrInbox?.name ?? ""
            isChatVCopen = true
            SocketIOManager.shared.getChatMessagesList(receiverId: arrInbox?.userId ?? "") { [self] arrMessages in

                if getMessageFirstTime {
                    print("============> CJISDJFIRHJJKFRHR")
                    getMessageFirstTime = false
                    arrMessagesList = arrMessages.data?.messageList
                    arrayMessages = arrMessagesList ?? []
//                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                        if self.isChatVCopen {
//                            self.scrollToBottomOfList()
//                        }
//                    }
                } else {
                    if isSentBtnTapped == false {
                        if self.isChatVCopen {
                        let senderDict: [String: String] = [
                            "ProfilePhoto": "\(arrMessages.data?.messageInfo?.senderProfilePic ?? "")",
                            "sender": "\(arrMessages.data?.messageInfo?.sender ?? "")"
                        ]

                        let msgDict: [String: Any] = [
                            "text": arrMessages.data?.messageInfo?.text ?? "",
                            "isSender": false,
                            "sender" : senderDict,
                            "files" : arrMessages.data?.messageInfo?.files ?? [],
                            "_id": arrMessages.data?.messageInfo?.id ?? ""
                        ]

                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: msgDict, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let objMessage = try decoder.decode(ClassChatMessagesMessageList.self, from: jsonData)
                            print("CHAT123456 objMessage-------->>>>",objMessage)
                            arrayMessages.append(objMessage)
//                            if self.isChatVCopen {
//                                self.scrollToBottomOfList()
//                            }
//                            shouldScrollToBottom = true
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                        }
                    }
                }

            }
//
        }
        .onDisappear(perform: {
            isChatVCopen = false
        })
        .onReceive(scrollToBottomPublisher, perform: { _ in
            
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("\(receiverName)")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    private func scrollToBottomOfList() {
        DispatchQueue.main.async {
            let lastIndex = arrayMessages.count - 1
            guard lastIndex >= 0 else { return }
            
            let indexPath = IndexPath(row: lastIndex, section: 0)
            let hostingController = UIApplication.shared.windows.first?.rootViewController
            let tableView = findTableView(in: hostingController?.view)
            
            tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            shouldScrollToBottom = false
        }
    }
    private func findTableView(in view: UIView?) -> UITableView? {
        if let tableView = view as? UITableView {
            return tableView
        }
        
        for subview in view?.subviews ?? [] {
            if let tableView = findTableView(in: subview) {
                return tableView
            }
        }
        
        return nil
    }
    private var scrollToBottomPublisher: AnyPublisher<Void, Never> {
        Just(())
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    func sendMessage() {
        let message = typingMessage
        isMessageSent = false
        shouldScrollToBottom = true
        scrollToBottomOfList()
//        isSentBtnTapped = true
        SocketIOManager.shared.sendNewMessage(receiverId: arrInbox?.userId ?? "", message: message) { sent in
            typingMessage = ""
            if isMessageSent == false {
                isMessageSent = true
//                let msgDict: [String: Any] = [
//                    "text": sent.data?.messageInfo?.text ?? "",
//                    "isSender": true,
//                    "_id": sent.data?.messageInfo?.id ?? "",
//                ]

//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: msgDict, options: .prettyPrinted)
//                    let decoder = JSONDecoder()
//                    let objMessage = try decoder.decode(ClassChatMessagesMessageList.self, from: jsonData)
//                    print("CHAT objMessage-------->>>>",objMessage)
//                    arrayMessages.append(objMessage)
                    isSentBtnTapped = false
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
        }
    }
}

//struct ChatVC_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatVC(arrInboxList: Binding<String>)
//    }
//}

struct MessageView : View {
    var currentMessage: ClassChatMessagesMessageList
    var userId: String
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if currentMessage.sender?.sender != userId {
                KFImage(URL(string: currentMessage.sender?.profilePhoto ?? "")).resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                if currentMessage.text != "" {
                    ContentMessageView(contentMessage: currentMessage.text ?? "",isCurrentUser:  false)
                }
                else if !(currentMessage.files?.isEmpty ?? false) {
                    ImageMessageView(imageUrl: currentMessage.files?[0] ?? "", isCurrentUser: currentMessage.isSender ?? false)
                }
            
            } else {
                Spacer()
                if currentMessage.text != "" {
                    ContentMessageView(contentMessage: currentMessage.text ?? "",isCurrentUser:  false)
                }
                else if !(currentMessage.files?.isEmpty ?? false) {
                    ImageMessageView(imageUrl: currentMessage.files?[0] ?? "", isCurrentUser: currentMessage.isSender ?? false)
                }
                KFImage(URL(string: currentMessage.sender?.profilePhoto ?? "")).resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            
        }
    }
}

struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10)
    }
}

struct ImageMessageView: View {
    var imageUrl: String
    var isCurrentUser: Bool
    @State private var shouldPresent = false
    var body: some View {
        
        KFImage(URL(string: imageUrl)).resizable()
            .frame(width: 100, height: 100)
            .padding(10)
            .cornerRadius(10)
            .onTapGesture {
                shouldPresent = true
            }
            .sheet(isPresented: $shouldPresent) {
                      ImageView(imageUrl: imageUrl)
                    }
//        Text(contentMessage)
//            .padding(10)
//            .foregroundColor(isCurrentUser ? Color.white : Color.black)
//            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
//            .cornerRadius(10)
    }
}
struct ImageView: View {
    var imageUrl: String
    @State private var shouldPresent = false
    var body: some View {
        VStack {
            KFImage(URL(string: imageUrl))
//                .frame(width: 220, height: 400)
                .padding(10)
                .cornerRadius(10)
                
        }
       

//        Text(contentMessage)
//            .padding(10)
//            .foregroundColor(isCurrentUser ? Color.white : Color.black)
//            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
//            .cornerRadius(10)
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Image?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: Image?
    @Binding var isPresented: Bool
    
    init(image: Binding<Image?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            self.image = Image(uiImage: image)
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}
