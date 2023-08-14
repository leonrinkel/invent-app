//
//  BulkAddItemRow.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct BulkAddItemRow: View {
    @Binding var item: DraftItem

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Manufacturer", text: $item.manuf)
                .autocorrectionDisabled()
            TextField("Part Number", text: $item.partNo)
                .autocorrectionDisabled()
            TextField("Description", text: $item.desc, axis: .vertical)
                .lineLimit(5)
        }
    }
}

struct BulkAddItemRow_Previews: PreviewProvider {
    static var previews: some View {
        BulkAddItemRow(item: .constant(DraftItem(partNo: "nRF52840-QFAA-F-R7")))
    }
}
