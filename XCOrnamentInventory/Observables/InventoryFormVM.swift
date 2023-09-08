//
//  InventoryFormVM.swift
//  XCOrnamentInventory
//
//  Created by Brenda Saavedra Cantu on 08/09/23.
//

import FirebaseStorage
import FirebaseFirestore
import Foundation
import SwiftUI
import QuickLookThumbnailing

class InventoryFormVM: ObservableObject {
    
    let db = Firestore.firestore()
    let formType: FormType
    
    let id: String
    @Published var name = ""
    @Published var quantity = 0
    @Published var usdzURL: URL?
    @Published var thumbnailURL: URL?
    
    
    @Published var loadingState = LoadingType.none
    @Published var error: String?
    
    var navigationTitle: String {
        switch formType {
        case .add:
            return "Add Item"
        case .edit:
            return "Edit Item"
        }
    }
    
    init (formType: FormType = .add) {
        self.formType = formType
        switch formType {
        case .add:
            id = UUID().uuidString
        case .edit(let inventoryItem):
            id = inventoryItem.id
            name = inventoryItem.name
            quantity = inventoryItem.quantity
            if let usdzURL = inventoryItem.usdzURL {
                self.usdzURL = usdzURL
            }
            if let thumbnailURL = inventoryItem.thumbnailURL {
                self.thumbnailURL = thumbnailURL
            }
        }
    }
    
    func save() throws {
        loadingState = .savingItem
        
        defer {
            loadingState = .none
        }
        
        var item: InventoryItem
        switch formType {
        case .add:
            item = .init(id: id, name: name, quantity: quantity)
        case .edit(let inventoryItem):
            item = inventoryItem
            item.name = name
            item.quantity = quantity
        }
        item.usdzLink = usdzURL?.absoluteString
        item.thumbnailLink = thumbnailURL?.absoluteString
        
        do {
            try db.document("items/\(item.id)")
                .setData(from: item, merge: false)
        } catch {
            self.error = error.localizedDescription
            throw error
        }
    }
}

enum FormType: Identifiable {
    
    case add
    case edit(InventoryItem)
    
    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let inventoryItem):
            return "edit-\(inventoryItem.id)"
        }
    }
}

enum LoadingType: Equatable {
    
    case none
    case savingItem
    
}
