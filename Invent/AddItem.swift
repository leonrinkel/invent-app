//
//  AddItem.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct AddItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var error: NSError?
    @State private var item = DraftItem()
    
    var body: some View {
        Form {
            if let error = error {
                Section {
                    // TODO: Parse error and display more friendly message
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Label {
                                Text("Unresolved Error")
                            } icon: {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        Text("\(error)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section {
                TextField("Manufacturer", text: $item.manuf)
                    .autocorrectionDisabled()
                TextField("Part Number", text: $item.partNo)
                    .autocorrectionDisabled()
                TextField("Description", text: $item.desc, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                DatePicker("Added At", selection: $item.addedAt, displayedComponents: .date)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            if error == nil {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: {
                        // TODO: Check if item with partNumber exists
                        let newItem = Item(context: viewContext)
                        newItem.manuf = item.manuf
                        newItem.partNo = item.partNo
                        newItem.desc = item.desc
                        newItem.addedAt = item.addedAt
                        
                        do {
                            viewContext.prepareForInterfaceBuilder()
                            try viewContext.save()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            self.error = error as NSError
                        }
                    })
                }
            }
        }
        .navigationTitle("New Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddItem()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
