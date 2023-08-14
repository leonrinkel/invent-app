//
//  BulkAddList.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct BulkAddList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var error: NSError?
    @Binding var draftItems: [DraftItem]
    
    var body: some View {
        // TODO: Allow to remove items from bulk add list
        List {
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
            ForEach($draftItems) { $item in
                Section {
                    BulkAddItemRow(item: $item)
                }
            }
        }
        .toolbar {
            if error == nil {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: {
                        // TODO: Check if item with partNumber exists
                        for draftItem in draftItems {
                            let newItem = Item(context: viewContext)
                            newItem.manuf = draftItem.manuf
                            newItem.partNo = draftItem.partNo
                            newItem.desc = draftItem.desc
                            newItem.addedAt = draftItem.addedAt
                        }
                        
                        do {
                            try viewContext.save()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            self.error = error as NSError
                        }
                    })
                }
            }
        }
        .navigationTitle("Review Items")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BulkAddList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BulkAddList(draftItems: .constant([
                DraftItem(partNo: "nRF52840-QFAA-F-R7"),
                DraftItem(partNo: "TPS25990ARQPR"),
                DraftItem(partNo: "GRM188R61A106KAALD")
            ]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
