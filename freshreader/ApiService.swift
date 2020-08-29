//
//  ApiService.swift
//  freshreader
//
//  Created by Maxime Vaillancourt on 2020-08-09.
//  Copyright © 2020 Freshreader. All rights reserved.
//

import Foundation
import KeychainSwift

struct SavedItem: Decodable, Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let url: URL
    let created_at: String
}

class ApiService {
    func getSavedItemsForAccount(successHandler: @escaping ([SavedItem]) -> ()) {
        // let accountNumber = "9705295212295412"

        let keychain = KeychainSwift()
        let accountNumber = keychain.get("accountNumber")
        
        // guard let url = URL(string: "http://freshreader.app/api/v1/users/\(accountNumber)") else { return }
        
        guard let url = URL(string: "http://freshreader.app/api/v1/articles") else { return }
        
        let apiAuthToken = "16954968ad84204037fabeb586e58f7fa634d2b4cb88e32615fe58b89e567a11"

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let test = "Token token=\"\(apiAuthToken)\", account_number=\"\(accountNumber ?? "bleh")\""
        request.setValue(test, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) {(jsonData, response, error) in
            
            // if let _error = error { return }
            // guard let _response = response else { return }
            guard let jsonData = jsonData else { return }
            
            print(String(data: jsonData, encoding: .utf8)!)
            
            let savedItems: [SavedItem] = try! JSONDecoder().decode(Array<SavedItem>.self, from: jsonData)
            successHandler(savedItems)
        }
        task.resume()
    }
    
    func deleteSavedItem(savedItemId: Int, successHandler: @escaping (Bool) -> ()) {
        let keychain = KeychainSwift()
        let accountNumber = keychain.get("accountNumber")
        
        guard let url = URL(string: "http://freshreader.app/api/v1/articles/\(savedItemId)") else { return }
        
        let apiAuthToken = "16954968ad84204037fabeb586e58f7fa634d2b4cb88e32615fe58b89e567a11"

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let test = "Token token=\"\(apiAuthToken)\", account_number=\"\(accountNumber ?? "bleh")\""
        request.setValue(test, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) {(jsonData, response, error) in
            
            if let _error = error {
                successHandler(false);
                return
            }
            
            guard let _response = response else {
                successHandler(false);
                return
            }
            
            guard let jsonData = jsonData else {
                successHandler(false);
                return
            }
            
            successHandler(true);
        }

        task.resume()
    }
}
