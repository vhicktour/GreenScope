//
//  Persistence.swift
//  GreenScope
//
//  Created by Victor Udeh on 11/15/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Preload sample data for previews
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GreenScope") // Ensure this matches your .xcdatamodeld name

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Log the error instead of crashing
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Automatically merge changes from other contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
