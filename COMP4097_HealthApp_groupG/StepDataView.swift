//
//  StepDataView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI

struct StepDataView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("loggedInUserID") var loggedInUserID = ""
    @State var totalDistance: Double = 0
    @State var totalCaloriesBurnt: Double = 0
    
    @FetchRequest(entity: Health.entity(), sortDescriptors: [])
    var healths: FetchedResults<Health>
    
    
    var body: some View {
            
        List(healths.filter { $0.userID == loggedInUserID }) { health in
            
            Text("Welcome \(health.username ?? "abc") !").padding()
                .font(.title)
            
            VStack {
                
                Text("Today's Steps: \(Int(health.dailyStep))").padding()
                
                    .font(.system(size: 30, weight: .bold))
                Text("Accumulated Steps: \(Int(health.accumulateStep))").padding()
                    .font(.system(size: 30))
                
                //TODO: gen a chart each 30 mins
                //no history record
                
                Spacer()
                
                Text("Distance Obtained: \(String(format: "%.2f", totalDistance)) Km").onAppear() {
                    calculateDistance(steps: Double(health.dailyStep))
                }
                Text("Calories Burnt: \(String(format: "%.2f", totalCaloriesBurnt)) cal.").onAppear() {
                    calculateCalories(health: health)
                }
                
                Spacer()
            }
            
        }.frame()
    }
}

extension StepDataView {
    //TODO: a function to calculate the km and calories
    
//    func increaseStep() {
//        todayStep = todayStep + 2
//    }
    
    func calculateDistance(steps: Double) {
        print("calculateDistance")
        
        let averageStepLength: Double = 0.75
        totalDistance = (steps * averageStepLength) / 1000
    }
    
    func calculateCalories(health: Health) {
        print("calculateCalories")
        
        
        // Step 1: Calculate the Basal Metabolic Rate (BMR)
     
//        let weightKG: Double = 55  //55 kg
//        let heightCM: Double = 160 //160 cm
//        let age: Double = 21
//        let gender: String = "F"  //female
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
