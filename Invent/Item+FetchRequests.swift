//
//  Item+FetchRequests.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import CoreData

extension Item {
    static var fetchRecentItems: NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.fetchLimit = 5
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.addedAt, ascending: false)]
        return request
    }
}
