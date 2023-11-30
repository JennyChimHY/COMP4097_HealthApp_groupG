//
//  StepDataView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI
import CoreData

struct StepDataView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("loggedInUserID") var loggedInUserID = ""
    @State var totalDistance: Double = 0
    @State var totalCaloriesBurnt: Double = 0
    
    @State var health: Health? //Health()
    
//    @FetchRequest(entity: Health.entity(), sortDescriptors: [])
//    var healths: FetchedResults<Health>

    var body: some View {
        
        VStack {
            if let h = health {  //ensure the data is fetched in onAppear
                //        List(healths.filter { $0.userID == loggedInUserID }) { health in
                Text("Welcome \(h.username ?? "abc") !").padding()
                    .font(.title)
                
                Image(systemName: "figure.run.circle.fill")
                
                VStack {
                    
                    Text("Today's Steps: \(Int(h.dailyStep))").padding()
                    
                        .font(.system(size: 30, weight: .bold))
                    Text("Accumulated Steps: \(Int(h.accumulateStep))").padding()
                        .font(.system(size: 30))
                    
                    Spacer()
                    
                    Text("Distance Obtained: \(String(format: "%.2f", totalDistance)) Km").onAppear() {
                        calculateDistance(steps: Double(h.dailyStep))
                    }
                    Text("Calories Burnt: \(String(format: "%.2f", totalCaloriesBurnt)) cal.").onAppear() {
                        calculateCalories(health: h)
                    }
                    
                    
                    Spacer()
                }
            }
            }.onAppear(perform: fetchData)
        }
}

extension StepDataView {
    
    private func fetchData() {
        
        print("enter do")
        
        let viewContext = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", loggedInUserID)

        do {
            let healths = try viewContext.fetch(fetchRequest)
            print(try viewContext.fetch(fetchRequest))
            if healths.first != nil {
                health = healths.first  //the 1st record is the target record
                print("enter success")
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        
    }
    
    func calculateDistance(steps: Double) {
        print("calculateDistance")
        
        let averageStepLength: Double = 0.75
        totalDistance = (steps * averageStepLength) / 1000
    }
    
    func calculateCalories(health: Health) {
        print("calculateCalories")
        
        
        
        // Step 1: Calculate the Basal Metabolic Rate (BMR)
        var bmr: Double = 0 //initialize
        
        if health.gender == "F" {
            bmr = 655.1 + (9.563 * health.weightKG) + (1.850 * health.heightCM) - (4.676 * Double(health.age))
        } else if health.gender == "M" {
            bmr = 66.5 + (13.75 * health.weightKG) + (5.003 * health.heightCM) - (6.755 * Double(health.age))
        }

        // Step 2: Calculate calories burned
        let caloriesPerStep: Double = 0.05
        let stepsBurnt: Double = Double(health.dailyStep) * caloriesPerStep

        //Step 3: The calories burned through steps
        totalCaloriesBurnt = bmr + stepsBurnt
    }
}
struct StepDataView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        StepDataView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
