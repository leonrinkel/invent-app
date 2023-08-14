//
//  ContentView.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(fetchRequest: Item.fetchRecentItems, animation: .default)
    private var recentItems: FetchedResults<Item>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.addedAt, ascending: true)], animation: .default)
    private var allItems: FetchedResults<Item>
    
    @State private var searchQuery: String = ""
    
    @State private var isAddItemSheetPresented = false
    @State private var isScanItemsSheetPresented = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(recentItems) { item in
                        NavigationLink {
                            ItemDetail(item: item)
                        } label: {
                            ItemRow(item: item)
                        }
                    }
                } header: {
                    Label {
                        Text("Recentry Added")
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
                Section {
                    ForEach(allItems) { item in
                        NavigationLink {
                            ItemDetail(item: item)
                        } label: {
                            ItemRow(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                } header: {
                    Label {
                        Text("All Items")
                    } icon: {
                        Image(systemName: "shippingbox")
                    }
                } footer: {
                    if allItems.count == 1 {
                        Text("\(allItems.count) Item")
                    } else if allItems.count > 1 {
                        Text("\(allItems.count) Items")
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchQuery)
            .onChange(of: searchQuery) { newQuery in
                if newQuery.isEmpty {
                    recentItems.nsPredicate = nil
                    allItems.nsPredicate = nil
                } else {
                    let query = newQuery.trimmingCharacters(in: .whitespaces)
                    let subpredicates = [ "manuf", "partNo", "desc" ].map { field in NSPredicate(format: "%K CONTAINS[c] %@", field, query) }
                    let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
                    recentItems.nsPredicate = compoundPredicate
                    allItems.nsPredicate = compoundPredicate
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        isAddItemSheetPresented.toggle()
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        isScanItemsSheetPresented.toggle()
                    }) {
                        Label("Scan Items", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .navigationTitle("Inventory")
            .sheet(isPresented: $isAddItemSheetPresented) {
                NavigationView { AddItem() }
            }
            .sheet(isPresented: $isScanItemsSheetPresented) {
                NavigationView { ScannerView() }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { allItems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // TODO: Handle error appropriately
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
