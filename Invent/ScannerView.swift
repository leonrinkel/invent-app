//
//  ScannerView.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var isScanning: Bool = true
    @State var scannedItems: [DraftItem] = []
    
    var body: some View {
        ScannerViewController(isScanning: $isScanning, scannedItems: $scannedItems)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                if !scannedItems.isEmpty {
                    ToolbarItem(placement: .confirmationAction) {
                        NavigationLink {
                            BulkAddList(draftItems: $scannedItems)
                        } label: {
                            Text("Continue")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Text("Scanned \(scannedItems.count) Items")
                        .font(.callout)
                }
            }
            .navigationTitle("Scan Items")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScannerView()
        }
    }
}
