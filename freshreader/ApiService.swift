//
//  ApiService.swift
//  freshreader
//
//  Created by Maxime Vaillancourt on 2020-08-09.
//  Copyright © 2020 Freshreader. All rights reserved.
//

import Foundation

struct SavedItem: Decodable, Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let url: URL
    let created_at: String
}

class ApiService {
    func getSavedItemsForAccount(accountNumber: String, successHandler: @escaping ([SavedItem]) -> ()) {
        let accountNumber = "7873191227987914"
        
        // guard let url = URL(string: "http://freshreader.app/api/v1/users/\(accountNumber)") else { return }
        
        guard let url = URL(string: "http://freshreader.app/api/v1/articles") else { return }
        
        let apiAuthToken = "47a9c74bdc53648f88d9ea80c6f0ef2554f2a261d19c3cab28820472c43bfa0b"

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let test = "Token token=\"\(apiAuthToken)\", account_number=\"\(accountNumber)\""
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
}
