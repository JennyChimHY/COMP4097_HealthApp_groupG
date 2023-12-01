//
//  GoalView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by Tak Ting Ho on 24/11/2023.
//

import SwiftUI
import Charts
import CoreData

struct StepData : Identifiable{
    var id = UUID()
    var date: String
    var steps: Int
}

class GoalViewModel: ObservableObject {
    @Published var data: [StepData] = []
    @Published var goal: Int = 0
    
    func generateRandomSteps() -> Int {
            return Int.random(in: 1...12000)
        }

    func fetchData(loggedInUserID: String) {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", loggedInUserID)
        
        do {
            let healths = try viewContext.fetch(fetchRequest)
            if let health = healths.first {
                let dailyStep = Int(health.dailyStep)
                let userGoal = Int(health.goal)
                
                self.goal = userGoal
                
                self.data = [
                    .init(date: "Sun", steps: 1298),
                    .init(date: "Mon", steps: 11728),
                    .init(date: "Tue", steps: 10263),
                    .init(date: "Wed", steps: 18839),
                    .init(date: "Thu", steps: 10326),
                    .init(date: "Fri", steps: dailyStep),
                    .init(date: "Sat", steps: 0),
                ]
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
}

struct GoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("loggedInUserID") var loggedInUserID = ""
    @StateObject var viewModel = GoalViewModel()
    
    //@State var viewContext = PersistenceController.shared.container.viewContext
    @State private var goalText = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var refreshFlag = false
    
    var body: some View {
        VStack {
            Text("Your Goal")
                .font(.title)
                .padding()
            
            Text("Average: \(calculateAverageSteps()) steps")
            
            Spacer().frame(height: 30)
            
            Chart {
                RuleMark(y: .value("goal", viewModel.goal))
                    .foregroundStyle(Color.gray)
                ForEach(viewModel.data) { day in
                    BarMark(
                        x: .value("date", day.date),
                        y: .value("step", day.steps)
                    )
                }
            }
            .padding(20)
            .frame(width: UIScreen.main.bounds.width - 40, height: 400)
            
            Spacer().frame(height: 30)
            
            Text("Set a new Goal?")
            
            HStack{
                TextField("Enter Goal", text: $goalText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    updateGoal(loggedInUserID: loggedInUserID, newGoal: goalText)
                }, label: {
                    Text("Submit")
                        .padding(20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onAppear {
                            viewModel.fetchData(loggedInUserID: loggedInUserID)
                        }
                })
            }
        }
        .onAppear {
            viewModel.fetchData(loggedInUserID: loggedInUserID)
        }
    }
}

extension GoalView{
    
    func calculateAverageSteps() -> Int {
            let totalSteps = viewModel.data.reduce(0) { $0 + $1.steps }
            return viewModel.data.isEmpty ? 0 : totalSteps / viewModel.data.count
        }
    
    func updateGoal(loggedInUserID: String, newGoal: String) {
        if let goalValue = Int(newGoal) {
            let viewContext = PersistenceController.shared.container.viewContext
            
            let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "userID == %@", loggedInUserID)
            
            do {
                let healths = try viewContext.fetch(fetchRequest)
                if let health = healths.first {
                    print("before: \(health.goal)")
                    health.goal = Int32(goalValue)
                    try viewContext.save()
                    viewModel.fetchData(loggedInUserID: loggedInUserID)
                    print("after: \(health.goal)")
                    refreshFlag.toggle()
                    showAlert = true
                    alertTitle = "Goal Update Success!"
                }
            } catch let error as NSError {
                print("Fetch error: \(error), \(error.userInfo)")
            }
        } else {
            alertTitle = "Please enter a valid number for the goal."
            showAlert = true
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
