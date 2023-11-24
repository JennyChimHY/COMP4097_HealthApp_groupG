//
//  StepDataView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI

struct StepDataView: View {
    @State var todayStep: Int = 250 //@State: dynamic data
    @State var accumulateStep: Int = 3000
    @State var distance: Float = 0.3
    @State var calories: Int = 30
    
    var body: some View {
        VStack {
            Text("Welcome abc!").padding()
                .font(.title)
            Text("Today's Steps: \(todayStep)").padding()

                .font(.system(size: 30, weight: .bold))
            Text("Accumulated Steps: \(accumulateStep) ").padding()
                .font(.system(size: 30))
            
            //TODO: gen a chart each 30 mins
            
            Spacer()
            
            Text("Distance Obtained: \(round(distance*10)/10.0) Km")
            Text("Calories Burnt: \(calories) cal.")
            
            Spacer()
            
        }.padding()
        
        
        
    }
}

//TODO: CoreData:
//daily steps
//accumulate steps
//redemption??

extension StepDataView {
    //TODO: a function to calculate the km and calories
    
    func increaseStep() {
        todayStep = todayStep + 2
    }
    
    func calculateDistance() {
        
//        return 0
    }
    
    func calculateCalories() {
        
    }
}
struct StepDataView_Previews: PreviewProvider {
    static var previews: some View {
        StepDataView()
    }
}
