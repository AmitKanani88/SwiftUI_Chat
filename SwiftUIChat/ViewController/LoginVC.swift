//
//  LoginVC.swift
//  SwiftUIChat
//
//  Created by iMac on 18/06/23.
//

import SwiftUI
import Alamofire
struct LoginVC: View {
    @State var nameText : String = ""
    @State var isTap: Bool = false
    var body: some View {
        VStack {
            TextField("Enter Name", text: $nameText) {
                
            }.padding(10)
                .border(.green, width: 2)
          
            NavigationLink("", isActive: $isTap) {
                ChatVC()
            }.background(Color.pink)
        
            Button {
                let parameters = [
                    "identity": nameText,
                ]
                let jsonData = try? JSONSerialization.data(withJSONObject: parameters)

                // Create the URL request
                let url = URL(string: "https://63de-2405-201-200c-823f-5106-90ac-5586-738a.ngrok-free.app/login")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                // Create a URLSessionDataTask and send the request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    // Process the response
                    if let data = data {
                        let modal = try? JSONDecoder().decode(LoginClass.self, from: data)
                        print("Modal :- \(response?.description)")
                        let accesstoken = UserDefaults.standard.set("\(modal?.accessToken ?? "")", forKey: "accessToken")
                        let userName = UserDefaults.standard.set("\(modal?.profile?.username ?? "")", forKey: "userName")
                        let refreshToken = UserDefaults.standard.set("\(modal?.refreshToken ?? "")", forKey: "refreshToken")
                        let authToken = UserDefaults.standard.set("\(modal?.authToken ?? "")", forKey: "authToken")
                    }
                }

                task.resume()
                print("\(nameText)")
            } label: {
                Text("Sign IN").padding(10)
            }.background(Color.pink)
            
            Text("\(nameText)")
                
        }.padding()
    }
}

struct LoginVC_Previews: PreviewProvider {
    static var previews: some View {
        LoginVC(nameText: "")
    }
}
