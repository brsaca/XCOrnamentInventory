//
//  InventoryListVM.swift
//  XCOrnamentInventory
//
//  Created by Brenda Saavedra Cantu on 07/09/23.
//

import FirebaseFirestore
import Foundation
import SwiftUI

class InventoryListVM: ObservableObject {
    
    @Published var items = [InventoryItem]()
    
    @MainActor
    func listenToItems() {
        Firestore.firestore().collection("items")
            .order(by: "name")
            .limit(toLast: 100)
            .addSnapshotListener{ snapshot, error in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                let docs = snapshot.documents
                
                let items = docs.compactMap {
                    return try? $0.data(as: InventoryItem.self)
                }
                
                withAnimation{
                    self.items = items
                }
            }
    }
    
}
