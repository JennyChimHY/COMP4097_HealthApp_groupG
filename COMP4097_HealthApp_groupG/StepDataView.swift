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
            if let h = health {  //ensure the data is fetched while onAppear
          
                HStack() {
                    
                    Image(systemName: "figure.run.circle.fill").resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("Welcome \(h.username ?? "abc") !").padding()
                        .font(.title)
                }
            
                VStack() {
                    
                    Text("Today's Steps: ").font(.largeTitle)
                    
                    Ring(progress: Double(h.dailyStep)/Double(h.goal), lineWidth: 20, processText: "", totalText: "\(h.dailyStep)", leftoverText: "Goal: \(h.goal)")
                        .frame(width: 280, height: 280)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    Text("\(Int(Double(h.dailyStep)/Double(h.goal) * 100))%").font(.title)
                    
                    if (Double(h.dailyStep)/Double(h.goal) > 1.0) {
                        Text("Congratulations!\nYou have achieved your goal today!")
                            .padding(.bottom, 10)
                            .font(.body)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Keep it up!")
                            .padding(.bottom, 10)
                            .font(.body)
                    }
                }
                
                HStack() {
                    VStack(alignment: .leading) {
                        Image(systemName: "sum")
                        Image(systemName: "mappin.and.ellipse")
                        Image(systemName: "flame.fill")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Accumulated Steps: ").font(.body)
                        Text("Distance Obtained: ").font(.body)
                        Text("Calories Burnt: ").font(.body)
                    }
                    
                    VStack(alignment: .trailing) {
                        Text("\(Int(h.accumulateStep))")
                            .font(.body)
                        Text("\(String(format: "%.2f", totalDistance)) Km").onAppear() {
                            calculateDistance(steps: Double(h.dailyStep))
                        }.font(.body)
                        
                        Text("\(String(format: "%.2f", totalCaloriesBurnt)) cal.").onAppear() {
                            calculateCalories(health: h)
                        }.font(.body)
                    }
                }
            }
        }.onAppear(perform: fetchData)
    }
}

extension StepDataView {
    
    private func fetchData() {
        
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


struct Ring: View {
    var progress: Double
    var lineWidth: CGFloat
    var processText: String
    var totalText: String
    var leftoverText: String

    var body: some View {
        ZStack {
            // Background Ring
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.yellow.opacity(0.2))

            // Foreground Ring
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.yellow)
                .rotationEffect(Angle(degrees: -90)) // Start from the top

            // Center Text
            VStack {
                Text(processText)
                    .font(.title)
                    .fontWeight(.bold) // Make the font bold
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(totalText)
                    .font(.system(size: 35)) // Set the desired font size
                    .fontWeight(.bold) // Make the font bold
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(leftoverText)
                    .font(.title)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: 170, height: 170) // Adjust the size of the frame as needed
        }
    }
}


struct StepDataView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        StepDataView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
