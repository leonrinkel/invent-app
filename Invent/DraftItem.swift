//
//  DraftItem.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import Foundation

struct DraftItem: Identifiable {
    var id: UUID = UUID()
    var addedAt: Date = Date()
    var desc: String = ""
    var manuf: String = ""
    var partNo: String = ""
}
