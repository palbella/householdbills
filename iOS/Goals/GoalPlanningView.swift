//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct GoalPlanningView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var goals = GetGoals()
    @ObservedObject var planningGoals = GetGoals()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var goalsFetch: FetchedResults<Goal>
    @State var goalSelected: UUID = UUID()
    @State var goalSelectedName: String = ""
    
    var body: some View {
        
       
        VStack  {
            
            HeaderTabView(title: "Goal Planning")
            
            ScrollView(.vertical, showsIndicators: false) {
            
            Section(header:
                        
                        VStack {
                           
                            Text("GOALS")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                            .font(.system(size: 12))
                Divider()
                   
                           
                    }
                      
                        
            ) {
                
                
                ForEach(self.goals.items.indexed(), id: \.1.id) { index, item in
                    let percent = item.amount < item.target ? item.amount * 100 / item.target: 100

                    Button(action: {
                        self.goalSelected = item.id
                        self.goalSelectedName = " - " + item.name
                    }) {
                        HStack (spacing: 0) {
                            Icon(content: item.iconContent, color: getColor(color: item.iconColor)).padding(5).padding(.leading, 5).padding(.trailing, 5)
                            
                            
                            VStack (spacing: 0) {
                               
                                HStack (spacing: 0) {
                                    Text(item.name)
                                    .font(.system(size: 15))
                                    .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                    .frame(alignment: .leading)
                                
                                Spacer()
                                    ProgressView(item.symbol + " " + String(format: "%.2f", item.target), value: percent, total: 100)
                                    .font(.system(size: 10))
                                    .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                    .frame(width: 60)
                                
                      
                                    Text(item.symbol + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                            .font(.system(size: 15))
                            .frame(minWidth: 130, alignment: .trailing)
                          

                                
                            }
                              
                                
                            }
                    }
                    .frame(maxWidth: .infinity)
                    }
                    
                }

            }
            Section(header:
                        
                        VStack {
                           
                Text("PLANNING" + self.goalSelectedName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                            .font(.system(size: 12))
                Divider()
                   
                           
                    }
                      
                        
            ) {
                
                ForEach(self.planningGoals.items.indexed(), id: \.1.id) { index, item in
                    
                    if(item.id == self.goalSelected) {
                   
                        
                        if(item.planning.count > 0) {
                            ForEach(item.planning) { plan in


                            let percent = plan.amount < item.target ? plan.amount * 100 / item.target: 100



                                HStack (spacing: 0) {
                                    Icon(content: item.iconContent, color: getColor(color: item.iconColor)).padding(5).padding(.leading, 5).padding(.trailing, 5)


                                    VStack (spacing: 0) {

                                        HStack (spacing: 0) {
                                            Text(String(plan.amount))
                                            .font(.system(size: 15))
                                            .frame(alignment: .leading)

                                        Spacer()
                                            ProgressView(item.symbol + " " + String(format: "%.2f", item.target), value: percent, total: 100)
                                            .font(.system(size: 10))
                                            .frame(width: 60)


                                            Text(plan.planningMonth).padding(5).padding(.leading, 5).padding(.trailing, 5)

                                    .font(.system(size: 15))
                                    .frame(minWidth: 130, alignment: .trailing)



                                    }


                                    }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        } else {
                            Text("You need to create payments with goal deposits on the monthly planning tab.")
                                .padding()
                                .multilineTextAlignment(.center)
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                        }
                        
                   
                    }
                }

                
            }
            Spacer()
         
     
         
        }
        }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        .onAppear {
            getGoals()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getGoals()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getGoals()
            }
      
        
     
    }
    
    private func getGoals()
    {
        @ObservedObject var monthlyPaymentData = MonthlyPaymentData()
        @State var payments = GetPayments()
        
        payments.items = monthlyPaymentData.fetch()
        
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        self.goals.items = [GoalModel]()
        self.planningGoals.items = [GoalModel]()

        do {
            let savedGoals =  try viewContext.fetch(fetchRequest)

                            for index in 0..<savedGoals.count {
                                
                                var amount: Double = 0
                                for i in 0..<payments.items.count {
                                    if(payments.items[i].goalId == self.goalsFetch[index].id) {
                                        amount = amount + payments.items[i].amount
                                    }
                                }
                             
                                self.goals.items.append(map(goal: self.goalsFetch[index]))
                                
                                var planning = map(goal: self.goalsFetch[index])
                                if(amount > 0) {
                                    
                                    var date = Date()
                                    var dateComponent = DateComponents()
                                    dateComponent.month = 1
                                    let dateFormarterLabel = DateFormatter()
                                    dateFormarterLabel.dateFormat = "MMM y"

                                
                                    var totalAmount = self.goalsFetch[index].target - self.goalsFetch[index].amount
                                    var max : Int = 120
                             
                                while (totalAmount > 0 && max > 0) {
                                    date = Calendar.current.date(byAdding: dateComponent, to: date)!
                                  
                                    totalAmount = totalAmount - amount
                                    var plan = GoalModel()
                                    plan.planningMonth = dateFormarterLabel.string(from: date)
                                    plan.amount = self.goalsFetch[index].target - totalAmount
                                    planning.planning.append(plan)
                                 max = max - 1
                                }
                                
                               
                                
                                }
                                self.planningGoals.items.append(planning)
                            }
        } catch {

        }

    }
    

    
    private func map(goal: Goal) -> GoalModel
    {
        var goalModel = GoalModel()
        
        goalModel.id = goal.id!
        goalModel.name = goal.name ?? ""
        goalModel.symbol = goal.symbol ?? ""
        goalModel.amount = goal.amount
        goalModel.target = goal.target
        goalModel.iconColor = goal.iconColor ?? ""
        goalModel.iconContent = goal.iconContent ?? ""

        return goalModel
    }
    
   
    
}


//#if DEBUG
//struct GoalPlanningView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        GoalPlanningView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif


