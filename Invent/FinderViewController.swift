//
//  FinderViewController.swift
//  Invent
//
//  Created by Leon Rinkel on 14.08.23.
//

import SwiftUI
import UIKit
import VisionKit

struct FinderViewController: UIViewControllerRepresentable {
    var item: Item
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.qr])], qualityLevel: .balanced, recognizesMultipleItems: true, isHighFrameRateTrackingEnabled: true, isHighlightingEnabled: false)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // TODO: Handle error
        try? uiViewController.startScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: FinderViewController
        
        class TagStore {
            var idToTag = [UUID: Int]()
            var nextTag = 4269
            
            func findTag(forId id: UUID) -> Int? {
                return idToTag[id]
            }
            
            func newTag(forId id: UUID) -> Int {
                nextTag += 1
                idToTag[id] = nextTag
                return nextTag
            }
            
            func removeTag(forId id: UUID) {
                idToTag.removeValue(forKey: id)
            }
        }
        
        let tagStore = TagStore()
        
        init(_ parent: FinderViewController) {
            self.parent = parent
        }
        
        func overlayBounds(for item: RecognizedItem) -> CGRect? {
            let ax = item.bounds.topLeft.x, ay = item.bounds.topLeft.y
            let bx = item.bounds.bottomLeft.x, by = item.bounds.bottomLeft.y
            let cx = item.bounds.bottomRight.x, cy = item.bounds.bottomRight.y
            let dx = item.bounds.topRight.x, dy = item.bounds.topRight.y
            
            let xs: [CGFloat] = [ax, bx, cx, dx]
            let ys: [CGFloat] = [ay, by, cy, dy]
            
            if let minx = xs.min(), let maxx = xs.max(),
               let miny = ys.min(), let maxy = ys.max() {
                return CGRect(x: minx, y: miny, width: maxx - minx, height: maxy - miny)
            } else { return nil }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            addedItems.forEach { (item) in
                switch (item) {
                case .barcode(let barcode):
                    guard let payload = barcode.payloadStringValue else { return }
                    guard let partNumber = parent.item.partNo else { return }
                    guard let bounds = overlayBounds(for: item) else { return }

                    let view = UIView(frame: bounds)
                    view.alpha = 0.5
                    view.tag = tagStore.newTag(forId: item.id)
                    
                    if payload.lowercased() == partNumber.lowercased() {
                        view.backgroundColor = .systemGreen
                    } else {
                        view.backgroundColor = .systemRed
                    }
                    
                    dataScanner.overlayContainerView.addSubview(view)
                    
                    break

                default:
                    return
                }
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            updatedItems.forEach { (item) in
                guard let bounds = overlayBounds(for: item) else { return }
                guard let tag = tagStore.findTag(forId: item.id) else { return }
                guard let view = dataScanner.overlayContainerView.viewWithTag(tag) else { return }
                view.bounds = bounds
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            removedItems.forEach { (item) in
                guard let tag = tagStore.findTag(forId: item.id) else { return }
                guard let view = dataScanner.overlayContainerView.viewWithTag(tag) else { return }
                view.removeFromSuperview()
                tagStore.removeTag(forId: item.id)
            }
        }
    }
}
