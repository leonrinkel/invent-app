//
//  ScannerViewController.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI
import UIKit
import VisionKit

struct ScannerViewController: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var scannedItems: [DraftItem]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.qr])], qualityLevel: .balanced, recognizesMultipleItems: true, isHighFrameRateTrackingEnabled: true, isHighlightingEnabled: true)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if isScanning {
            // TODO: Handle error
            try? uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
        }
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScannerViewController
        
        init(_ parent: ScannerViewController) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            addedItems.forEach { (item) in
                switch (item) {
                case .barcode(let barcode):
                    if let payload = barcode.payloadStringValue {
                        if parent.scannedItems.first(where: { $0.partNo == payload }) != nil {
                            return
                        }
                        parent.scannedItems.append(DraftItem(partNo: payload))
                    }
                    break
                default:
                    return
                }
            }
        }
    }
}
