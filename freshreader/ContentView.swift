//
//  ContentView.swift
//  freshreader
//
//  Created by Maxime Vaillancourt on 2020-08-09.
//  Copyright © 2020 Freshreader. All rights reserved.
//

import SwiftUI

// DONE create a method to get the list of saved items
// have a definition of how a list item is defined (JSON parse to SavedItem object)
// bind the list of saved items to the SwiftUI master view

struct ContentView: View {
    @State private var savedItems = [SavedItem]()
    
    var body: some View {
        NavigationView {
            MasterView(savedItems: $savedItems)
                .navigationBarTitle(Text("Reading list"))
                .navigationBarItems(
                    leading: EditButton()
                    // trailing: Button(
                    //     action: {
                    //         withAnimation { self.savedItems.insert(Date(), at: 0) }
                    //     }
                    // ) {
                    //     Image(systemName: "plus")
                    // }
                )
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var savedItems: [SavedItem]
    
    private let apiService = ApiService()
    
    func loadData() {
        apiService.getSavedItemsForAccount(successHandler: { (listOfSavedItems) -> Void in
            DispatchQueue.main.async {
                self.savedItems = listOfSavedItems
            }
        })
    }

    var body: some View {
        List {
            ForEach(savedItems, id: \.self) { savedItem in
                HStack() {
                    VStack(alignment: .leading) {
                        Text("\(savedItem.title)")
                        Text("\(savedItem.url.host!)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }.onTapGesture {
                    if let url = URL(string: savedItem.url.absoluteString) {
                        UIApplication.shared.open(url)
                    }
                }
            }.onDelete { indices in
                indices.forEach {
                    let index = $0
                    let savedItemId = self.savedItems[$0].id
                    
                    self.apiService.deleteSavedItem(savedItemId: savedItemId) { (deleteSucceeded) in
                        if deleteSucceeded {
                            print("deleted!")
                            self.savedItems.remove(at: index)
                        } else {
                            print("unable to remove")
                        }
                    }
                }
            }
        }.onAppear(perform: loadData)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
