//
//  RedeemView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI
import CoreData

struct RedeemView: View {
    
    @AppStorage("loggedInUserID") var loggedInUserID = ""
    @State var viewContext = PersistenceController.shared.container.viewContext
    
    @State var health: Health?
    @State private var refreshFlag = false
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    @State private var presentedParam:[Parameter] = []
    
    var body: some View {
        
        NavigationStack(path: $presentedParam) {
            VStack {
                if let h = health {
                    
                    Text("Available points: \(h.accumulateStep - h.redemmedStep)")
                        .padding(.top, 60)
                        .font(.system(.subheadline, weight: .bold))
                    Text("*Points = Steps Accumulated")
                        .font(.footnote)
                    
                    List(Gift.gifts) { (gift: Gift) in
                        
                        VStack(alignment: .center) { // Align items to the center
                            HStack() {
                                Image(gift.image)
                                    .resizable()
                                    .frame(width: 100.0, height: 100.0)
                                    .cornerRadius(5)
                                
                                VStack() {
                                    
                                    Text("\(gift.title)").font(.headline)
                                    
                                    HStack() {
                                        VStack(alignment: .trailing) {
                                            Text("Required Points: ")
                                            Text("Remaining: ")
                                        }
                                        VStack(alignment: .trailing) {
                                            Text("\(gift.stepRequired)")
                                            Text("\(gift.remaining)")
                                        }
                                    }
                                    
                                    
                                    if ((h.accumulateStep - h.redemmedStep) > 0 && (gift.remaining > 0) && (h.accumulateStep - h.redemmedStep) >= gift.stepRequired) { //safe check
                                        Button(action: {
                                            consume(health: h, gift: gift)
                                        }) {
                                            Text("Redeem")
                                                .font(.subheadline)
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color.blue)
                                                .cornerRadius(8)
                                                .frame(width: 100.0, height: 30.0)
                                        }.padding()
                                        
                                            .alert(alertTitle, isPresented: $showAlert, actions: {
                                                Button("OK") {
                                                    let param = Parameter(healthparam: h, giftparam: gift)
                                                    presentedParam.append(param)
                                                    print("presentedParam")
                                                    print(presentedParam)
                                                }
                                            })
                                        
                                    } else {
                                        Button(action: {}) {
                                            Text("Redeem")
                                                .font(.subheadline)
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(Color.gray)
                                                .cornerRadius(8)
                                                .frame(width: 100.0, height: 30.0)
                                        }.padding()
                                    }
                                }
                            }
                        }.onChange(of: refreshFlag) { _ in
                            // Perform actions when 'refreshFlag' changes
                            fetchData()
                        }
                        
                        
                    }.frame(height: CGFloat(15) * CGFloat(45))
                    
                }
                
            }.onAppear(perform: fetchData)
                .frame(maxWidth: .infinity) // Expand the outer VStack horizontally
        .navigationDestination(for: Parameter.self) { i in
            RedeemDetailView(from: "list", health: i.healthparam, gift: i.giftparam)
        }
        .navigationTitle("Gift Redemption")
    }
    }
}

extension RedeemView {
    
    func fetchData() {
        
        let viewContext = PersistenceController.shared.container.viewContext

        let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", loggedInUserID)

        do {
            let healths = try viewContext.fetch(fetchRequest)
            print(try viewContext.fetch(fetchRequest))
            if healths.first != nil {
                health = healths.first  //the 1st record is the target record
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
    }
    
    func consume(health: Health, gift: Gift) {
        let updateRedemmedStep = Int(health.redemmedStep) + gift.stepRequired
//        gift.remaining = gift.remaining - 1
        viewContext.performAndWait {
            health.redemmedStep = Int32(updateRedemmedStep)
//            health.redemmedStep = 0  //for reset
            try? viewContext.save()
            refreshFlag.toggle() // Toggle the refresh flag to refresh the view
            showAlert = true
            alertTitle = "\(gift.title) Redeem Success!"
        }
    }
    
}

struct Parameter: Hashable {
    
    let healthparam: Health
    let giftparam: Gift
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(healthparam.id)
            hasher.combine(giftparam.id)
        }

        static func == (lhs: Parameter, rhs: Parameter) -> Bool {
            return lhs.healthparam.id == rhs.healthparam.id && lhs.giftparam.id == rhs.giftparam.id
        }

}

struct Gift: Identifiable {
    let id: String
    let title: String
    let image: String
    let stepRequired: Int
    var remaining: Int
}

extension Gift {
    static let gifts: [Gift] = [
        Gift(id: "chicken", title: "Instant Chicken Breast", image: "chicken", stepRequired: 50000, remaining: 1000),
        Gift(id: "towel", title: "Sports Towel", image: "towel", stepRequired: 200000, remaining: 400),
        Gift(id: "bottle", title: "Water Bottles", image: "bottle", stepRequired: 300000, remaining: 200),
        Gift(id: "protein", title: "Protein", image: "protein", stepRequired: 400000, remaining: 100),
        Gift(id: "bag", title: "Sports Bag", image: "bag", stepRequired: 500000, remaining: 50),
        Gift(id: "rope", title: "Training Rope", image: "rope", stepRequired: 550000, remaining: 20)
    ]
}

struct RedeemView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        RedeemView()
    }
}
