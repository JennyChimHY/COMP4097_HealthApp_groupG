//
//  COMP4097_HealthApp_groupGApp.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 17/11/2023.
//

import SwiftUI
import CoreData

@main
struct COMP4097_HealthApp_groupGApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("shouldSeedData") var shouldSeedData: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: seedData)
        }
    }
}

extension COMP4097_HealthApp_groupGApp {
    private func seedData() {
           if !shouldSeedData { return }

        let healths: [[String: Any]] = [
                  ["id": "1", "userID": "001", "username": "Alan", "password": "123456", "dailyStep": 2000, "accumulateStep": 10000000, "redemmedStep": 0, "goal": 10000, "weightKG" : 70.0, "heightCM" : 180.0, "age" : 21, "gender" : "M"],
                  ["id": "2", "userID": "002", "username": "Jenny", "password": "123456", "dailyStep": 10000, "accumulateStep": 2000000, "redemmedStep": 0, "goal": 5000, "weightKG" : 50.0, "heightCM" : 160.0, "age" : 21, "gender" : "F"],
                  ["id": "3", "userID": "003", "username": "Martin", "password": "123456", "dailyStep": 5000, "accumulateStep": 5000000, "redemmedStep": 0, "goal": 10000, "weightKG" : 80.0, "heightCM" : 180.0, "age" : 35, "gender" : "M"],
                  ["id": "4", "userID": "004", "username": "Kenny", "password": "123456", "dailyStep": 20000, "accumulateStep": 3000000, "redemmedStep": 0, "goal": 15000, "weightKG" : 80.0, "heightCM" : 180.0, "age" : 35, "gender" : "M"]
                 ]

        let viewContext = persistenceController.container.viewContext
           viewContext.automaticallyMergesChangesFromParent = true

           viewContext.performAndWait {
               let insertRequest = NSBatchInsertRequest(entity: Health.entity(), objects: healths)

               let result = try? viewContext.execute(insertRequest) as? NSBatchInsertResult

               if let status = result?.result as? Int, status == 1 {
                   print("Data Seeded")
                   shouldSeedData = false
               }
           }
       }
}
