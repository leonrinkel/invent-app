//
//  Persistence.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Invent")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: Handle the error appropriately
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newItem1 = Item(context: viewContext)
        newItem1.addedAt = Date()
        newItem1.manuf = "Nordic Semiconductor"
        newItem1.partNo = "nRF52840-QFAA-F-R7"
        newItem1.desc = "RF System on a Chip - SoC Multiprotocol Bluetooth 5.3 SoC supporting Bluetooth Low Energy, Bluetooth mesh, NFC, Thread and Zigbee"
        
        let newItem2 = Item(context: viewContext)
        newItem2.addedAt = Date()
        newItem2.manuf = "Texas Instruments"
        newItem2.partNo = "TPS25990ARQPR"
        newItem2.desc = "Power Management Specialised - PMIC 2.9-V to 16-V, 0.79-mohm, 60-A eFuse with digital telemetry controller"
        
        let newItem3 = Item(context: viewContext)
        newItem3.addedAt = Date()
        newItem3.manuf = "Murata Electronics"
        newItem3.partNo = "GRM188R61A106KAALD"
        newItem3.desc = "Multilayer Ceramic Capacitors MLCC - SMD/SMT 10UF 10V 10% 0603"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
