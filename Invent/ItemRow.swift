//
//  ItemRow.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct ItemRow: View {
    @ObservedObject var item: Item

    var body: some View {
        VStack(alignment: .leading) {
            if let manufacturer = item.manuf, !manufacturer.isEmpty {
                Text(manufacturer)
                    .font(.footnote)
                    .lineLimit(1)
            }
            if let partNumber = item.partNo, !partNumber.isEmpty {
                Text(partNumber)
                    .font(.headline)
                    .lineLimit(1)
            }
            if let description = item.desc, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let managedObjectContext = PersistenceController.preview.container.viewContext
        
        let previewItem = Item(context: managedObjectContext)
        previewItem.addedAt = Date()
        previewItem.manuf = "Nordic Semiconductor"
        previewItem.partNo = "nRF52840-QFAA-F-R7"
        previewItem.desc = "RF System on a Chip - SoC Multiprotocol Bluetooth 5.3 SoC supporting Bluetooth Low Energy, Bluetooth mesh, NFC, Thread and Zigbee"
        
        return ItemRow(item: previewItem)
    }
}
