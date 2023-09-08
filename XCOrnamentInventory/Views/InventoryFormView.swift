//
//  InventoryFormView.swift
//  XCOrnamentInventory
//
//  Created by Brenda Saavedra Cantu on 08/09/23.
//

import SwiftUI

struct InventoryFormView: View {
    
    @StateObject var vm = InventoryFormVM()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            List {
                inputSection
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel"){
                    dismiss()
                }
                .disabled(vm.loadingState != .none)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    do {
                        try vm.save()
                        dismiss()
                    } catch {}
                }
                .disabled(vm.loadingState != .none || vm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .alert(isPresented: .init(get: { vm.error != nil }, set: { _ in
            vm.error = nil
        }), error: "An error has ocurred", actions: { _ in }, message: { _ in
            Text(vm.error ?? "")
        })
        .navigationTitle(vm.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var inputSection: some View {
        Section {
            TextField("Name", text: $vm.name)
            Stepper("Quantity: \(vm.quantity)", value: $vm.quantity)
        }
        .disabled(vm.loadingState != .none)
    }
}

#Preview {
    NavigationStack {
        InventoryFormView()
    }
}
