//
//  ItemDetail.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct ItemDetail: View {
    var item: Item
    
   @State private var isFindItemSheetPresented = false

    var body: some View {
        List {
            if let manufacturer = item.manuf, !manufacturer.isEmpty {
                //LabeledContent("Manufacturer", value: manufacturer)
                VStack(alignment: .leading) {
                    Label {
                        Text("Manufacturer")
                            .foregroundColor(.secondary)
                    } icon: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.accentColor)
                    }
                    .padding(.bottom, 3)
                    Text(manufacturer)
                        .textSelection(.enabled)
                        .padding(.leading, 44)
                }
            }
            if let partNumber = item.partNo, !partNumber.isEmpty {
                //LabeledContent("Part Number", value: partNumber)
                VStack(alignment: .leading) {
                    Label {
                        Text("Part Number")
                            .foregroundColor(.secondary)
                    } icon: {
                        Image(systemName: "number")
                    }
                    .padding(.bottom, 3)
                    Text(partNumber)
                        .textSelection(.enabled)
                        .padding(.leading, 44)
                }
            }
            if let description = item.desc, !description.isEmpty {
                //LabeledContent("Description", value: description)
                VStack(alignment: .leading) {
                    Label {
                        Text("Description")
                            .foregroundColor(.secondary)
                    } icon: {
                        Image(systemName: "note.text")
                    }
                    .padding(.bottom, 3)
                    Text(description)
                        .textSelection(.enabled)
                        .padding(.leading, 44)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    isFindItemSheetPresented.toggle()
                }) {
                    Label("Find Item", systemImage: "qrcode.viewfinder")
                }
            }
        }
        .sheet(isPresented: $isFindItemSheetPresented) {
            NavigationView {
                FinderView(item: item)
            }
        }
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        let managedObjectContext = PersistenceController.preview.container.viewContext
        
        let previewItem = Item(context: managedObjectContext)
        previewItem.addedAt = Date()
        previewItem.manuf = "Nordic Semiconductor"
        previewItem.partNo = "nRF52840-QFAA-F-R7"
        previewItem.desc = "RF System on a Chip - SoC Multiprotocol Bluetooth 5.3 SoC supporting Bluetooth Low Energy, Bluetooth mesh, NFC, Thread and Zigbee"
        
        return NavigationView {
            ItemDetail(item: previewItem)
        }
    }
}
