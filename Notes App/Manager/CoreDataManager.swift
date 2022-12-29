//
//  CoreDataManager.swift
//  Notes App
//
//  Created by Иван Осипов on 29.12.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    var notesArray: [Note] = []
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data Fetch request
    
    func getNote() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        
        do {
            notesArray = try context.fetch(fetchRequest)
            if notesArray.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
                let noteObject = NSManagedObject(entity: entity!, insertInto: context) as! Note
                noteObject.text = "Первая заметка"
                notesArray.append(noteObject)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data Saving note
    
    func save(text: String) {
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
        let noteObject = NSManagedObject(entity: entity!, insertInto: context) as! Note
        noteObject.text = text
        
        do {
            try context.save()
            notesArray.append(noteObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data Edit note
    
    func edit(text: String, index: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        
        do {
            notesArray = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        let note = notesArray[index]
        note.text = text
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Core Data Delete note
    
    func delete(_ object: NSManagedObject, indexPath: IndexPath) {
        let context = persistentContainer.viewContext
        
        context.delete(object)
        notesArray.remove(at: indexPath.row)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

