//
//  Persistence.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for _ in 0..<1 {
            let newItem = Health(context: viewContext)  //Entity Name
            newItem.id = "2" //String()
            newItem.userID = "002" //String()
            newItem.username = "Jenny" //String()
            newItem.password = "123456" //String()
            newItem.dailyStep = 10000 //Int32()
            newItem.accumulateStep = 200000 //Int32()
            newItem.redemmedStep = 0 //Int32()
            newItem.goal = 5000 //Int32()
        }
//        let healths: [[String: Any]] = [
//         ["id": "1", "userID": "001", "username": "Alan", "password": "123456", "dailyStep": 2000, "accumulateStep": 240000, "redemmedStep": 0, "goal": 10000],
//         ["id": "2", "userID": "002", "username": "Jenny", "password": "123456", "dailyStep": 10000, "accumulateStep": 200000, "redemmedStep": 0, "goal": 5000],
//         ["id": "3", "userID": "003", "username": "Martin", "password": "123456", "dailyStep": 5000, "accumulateStep": 500000, "redemmedStep": 0, "goal": 10000],
//         ["id": "4", "userID": "004", "username": "Kenny", "password": "123456", "dailyStep": 20000, "accumulateStep": 300000, "redemmedStep": 0, "goal": 15000]
//        ]
        
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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HealthData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
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
    }
}
