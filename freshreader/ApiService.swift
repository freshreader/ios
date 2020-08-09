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
        let accountNumber = "9791664447554212"        
        
        guard let url = URL(string: "http://localhost:3000/api/v1/articles") else { return }
        
        let apiAuthToken = "7333cc0b79fb2060b875ac8e458b123f3268d29efe2dacb2abee5cf31efccd7d"
        
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
