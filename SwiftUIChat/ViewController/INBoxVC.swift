//
//  INBoxVC.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//
import SwiftUI
import Kingfisher


struct INBoxVC: View {
    @State var objInboxList: ClassInboxList?
    @State var arrInboxList: [ClassInboxUserList] = []
    @State private var isShowing = false
    
    var body: some View {
        NavigationView {
            List {
                if arrInboxList.count > 0 {
                    ForEach(0..<arrInboxList.count-1,id: \.self ) { index  in
                        if let element = arrInboxList[index] {
                            NavigationLink {
                                ChatVC(arrInbox: element)
                            } label: {
                                HStack {
                                    if let imageUrl = element.profilePhoto {
                                        KFImage(URL(string: imageUrl)).resizable()
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(30)
                                    }
                                
                                    if let name = element.name {
                                        Text(" \(name)")
                                    }
                                }
                            }

                        }
                    }
                } else {
                    Button {
                        print("Count \(arrInboxList)")
                    } label: {
                        Text("No data found")
                    }
                }
            }.onAppear(perform: {
                _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        SocketIOManager.shared.getInboxList(completion: {[self] objInbox in
                            if objInbox.data?.userList != nil {
                                objInboxList = objInbox
                                arrInboxList = objInbox.data!.userList!
                                print("arrInboxList",objInbox)
                            } else {
                                print("objInbox Nil")
                            }
                        })
                    if arrInboxList.count > 0 {
                        timer.invalidate()
                        print("Timer fired!")
                    }
                }
                
            })
//            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Chat Screen")
            .padding(0)
            .navigationBarTitleDisplayMode(.automatic)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        INBoxVC()
    }
}



