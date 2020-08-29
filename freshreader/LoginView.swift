//
//  LoginView.swift
//  freshreader
//
//  Created by Maxime Vaillancourt on 2020-08-29.
//  Copyright © 2020 Freshreader. All rights reserved.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    @State private var accountNumber = ""
    
    func saveAccountNumber() {
        let keychain = KeychainSwift()
        keychain.set(accountNumber, forKey: "accountNumber")
    }
    
    func getAccountNumberFromKeychain() {
        let keychain = KeychainSwift()
        self.accountNumber = keychain.get("accountNumber") ?? ""
    }
    
    func navigateToContentView() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("Login")
                    .fontWeight(.bold)
                    .font(.title)
                TextField("Account number", text: $accountNumber, onCommit: {
                    self.saveAccountNumber()
                })
                NavigationLink(destination: ContentView()) {
                     Text("View reading list")
                }
            }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }.onAppear(perform: getAccountNumberFromKeychain)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
