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

    var body: some View {
        VStack {
            Text("Your Goal") // Title "Your Goal"
                .font(.title)
                .padding()
            
            Text("Average: \(calculateAverageSteps()) steps")
            
            Spacer().frame(height: 30)
            
            Chart {
                RuleMark(y: .value("step", 10000))
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
            .onAppear {
                viewModel.fetchData(loggedInUserID: loggedInUserID)
            }
        }
    }
    
    func calculateAverageSteps() -> Int {
            let totalSteps = viewModel.data.reduce(0) { $0 + $1.steps }
            return viewModel.data.isEmpty ? 0 : totalSteps / viewModel.data.count
        }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
