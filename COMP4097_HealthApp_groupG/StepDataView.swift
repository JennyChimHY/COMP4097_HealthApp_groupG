//
//  StepDataView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI

struct StepDataView: View {
    //    @State var todayStep: Int = 250 //@State: dynamic data
    //    @State var accumulateStep: Int = 3000
   var distance: Float = 0.3 // @State
   var calories: Int = 30 // @State 
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let user_id: String = "002"
    
    @FetchRequest(entity: Health.entity(), sortDescriptors: [])
    var healths: FetchedResults<Health>
    
    
    var body: some View {
            
        List(healths.filter { $0.userID == user_id }) { health in
            
            Text("Welcome \(health.username ?? "abc") !").padding()
                .font(.title)
            
            VStack {
                
                Text("Today's Steps: \(health.dailyStep)").padding()
                
                    .font(.system(size: 30, weight: .bold))
                Text("Accumulated Steps: \(health.accumulateStep) ").padding()
                    .font(.system(size: 30))
                
                //TODO: gen a chart each 30 mins
                //no history record
                
                Spacer()
                
                Text("Distance Obtained: \(distance) Km") //round(health.dailyStep*10)/10.0
                Text("Calories Burnt: \(calories) cal.")
                
                Spacer()
            }
            
        }.frame()
//            .onAppear() {
//                calculateDistance()  //TODO: pass param health.dailyStep
//                calculateCalories() //TODO: pass param health.dailyStep
//            }
    }
}

extension StepDataView {
    //TODO: a function to calculate the km and calories
    
//    func increaseStep() {
//        todayStep = todayStep + 2
//    }
    
    func calculateDistance() {
        print("calculateDistance")
//        return 0
    }
    
    func calculateCalories() {
        print("calculateCalories")
    }
}
struct StepDataView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        StepDataView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
