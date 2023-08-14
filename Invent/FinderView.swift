//
//  FinderView.swift
//  Invent
//
//  Created by Leon Rinkel on 14.08.23.
//

import SwiftUI

struct FinderView: View {
    @Environment(\.presentationMode) private var presentationMode

    var item: Item

    var body: some View {
        FinderViewController(item: item)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .navigationTitle("Find Item")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct FinderView_Previews: PreviewProvider {
    static var previews: some View {
        let managedObjectContext = PersistenceController.preview.container.viewContext
        
        let previewItem = Item(context: managedObjectContext)
        previewItem.addedAt = Date()
        previewItem.manuf = "Nordic Semiconductor"
        previewItem.partNo = "nRF52840-QFAA-F-R7"
        previewItem.desc = "RF System on a Chip - SoC Multiprotocol Bluetooth 5.3 SoC supporting Bluetooth Low Energy, Bluetooth mesh, NFC, Thread and Zigbee"
        
        return NavigationView {
            FinderView(item: previewItem)
        }
    }
}
