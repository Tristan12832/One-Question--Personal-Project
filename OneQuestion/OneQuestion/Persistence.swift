//
//  Persistence.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 11/07/2023.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "OneQuestion")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
    
    //MARK: PREVIEW
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let question = Question(context: viewContext)
        question.title = "What's A + B ?"
        question.options = ["A + B", "AB", "C"]
        question.correctOption = 0
        question.isFavorite = false
        question.isWin = false
      

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

    static var testData: [Question]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Question]
    }()
    
}
