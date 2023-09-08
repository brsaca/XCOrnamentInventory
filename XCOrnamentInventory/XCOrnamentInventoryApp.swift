//
//  XCOrnamentInventoryApp.swift
//  XCOrnamentInventory
//
//  Created by Brenda Saavedra Cantu on 07/09/23.
//

import SwiftUI

@main
struct XCOrnamentInventoryApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InventoryListView()
            }
        }
    }
}
