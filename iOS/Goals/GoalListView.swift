//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct GoalListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var isShowingPlanning: Bool = false
    @State var delete: Bool = false

    @State var goalSelected : GoalModel = GoalModel()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var transactionData = TransactionData()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var now = Date()
    
    @ObservedObject var goals = GetGoals()
    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Goal")
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var goalsFetch: FetchedResults<Goal>
    
    @Binding var totalGoals: Double
    @Binding var hideData: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Section(header:
                        HStack {
                            VStack{
                                Spacer()
                            Text("GOALS")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            }
                            Spacer()
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Button(action: {
                                        self.isShowingPlanning = true
                                    }) {
                                        
                                        CommandButton(content: "rectangle.split.3x3")
                                    }
                                    .sheet(isPresented: self.$isShowingPlanning, onDismiss: {
                                        
                                   
                                        }) {
                                        GoalPlanningView()
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 12)
                                    
                                    Button(action: {
                                        self.goalSelected = GoalModel()
                                        self.transaction = TransactionModel()
                                        self.goalSelected.iconContent = "vacation"
                                        self.goalSelected.iconColor = "yellow"
                                        self.goalSelected.currency = settings.currency
                                        self.goalSelected.symbol = settings.symbol
                                        self.isShowingNew = true
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                        
                                        if(self.$goalSelected.name.wrappedValue != "") {
                                            self.transaction.name = self.transferTypes.names[3] + " " + self.$goalSelected.name.wrappedValue
                                            self.transaction.amount = self.$goalSelected.amount.wrappedValue
                                            self.transaction.symbol = self.$goalSelected.symbol.wrappedValue
                                            self.transaction.iconContent = self.$goalSelected.iconContent.wrappedValue
                                            self.transaction.iconColor = self.$goalSelected.iconColor.wrappedValue
                                            self.transaction.timestamp = Date()
                                            saveTransaction(transaction: self.transaction)
                                         addGoal(goal: self.$goalSelected.wrappedValue)
                                        }
                                          
                                        }) {
                                        GoalAddView(goal: self.$goalSelected, transaction: self.$transaction, currencies: self.$currencies)
                                            .environmentObject(self.ui)
                                                .environmentObject(self.settings)
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 17)
                                    .padding(.bottom, 12)
                                }
                               
                            }
                            
                         
                           
                        }
                      
                        
            ) {

                Divider()
                
               
                
                ForEach(self.goalsFetch.indexed(), id: \.1.id) { index, item in
                    
                    let percent = item.amount < item.target ? item.amount * 100 / item.target: 100
                    
                    let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                    
                    
                                        Button(action: {
                                            self.goalSelected = map(goal: item)
                                            self.transaction = TransactionModel()
                                            self.delete = false
                                            self.isShowing = true
                                        }) {

                                            
                                            VStack (spacing: 0) {
                                                HStack (spacing: 0) {
                                                    Icon(content: item.iconContent!, color: getColor(color: item.iconColor!)).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                    
                                                    
                                                    VStack (spacing: 0) {
                                                        Spacer()
                                                        HStack (spacing: 0) {
                                                            Text(item.name!)
                                                            .font(.system(size: 15))
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                            .frame(alignment: .leading)
                                                        
                                                        Spacer()
                                                            ProgressView(item.symbol! + " " + String(format: "%.2f", item.target), value: percent, total: 100)
                                                            .font(.system(size: 10))
                                                            .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                                                            .frame(width: 60)
                                                        
                                                            if(!self.hideData) {
                                                                Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                        .foregroundColor(fontColor)
                                                        .font(.system(size: 15))
                                                        .frame(minWidth: 130, alignment: .trailing)
                                                            } else {
                                                                Text(item.symbol! + "---").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                        .foregroundColor(fontColor)
                                                        .font(.system(size: 15))
                                                        .frame(minWidth: 130, alignment: .trailing)
                                                            }
                                                            
                                                  

                                                        
                                                    }
                                                        Spacer()
                                                     
                                                        
                                                    }
                                            }
                                            .frame(maxWidth: .infinity)
                                           
                                                
                                              
                                            }
                                            
                                            
                                        }
                                        .sheet(isPresented: self.$isShowing, onDismiss: {
                                            
                                            if(self.delete) {
                                                deleteGoal(goal: self.$goalSelected.wrappedValue)
                                            } else {

                                                updateGoal(goal: self.$goalSelected.wrappedValue)
                                            }
                                            
                                            
                                        }) {
                                            GoalUpdateView(goal: self.$goalSelected, transaction: self.$transaction, modal: self.$isShowing, delete: self.$delete, currencies: self.$currencies)
                                                .environmentObject(self.ui)
                                                    .environmentObject(self.settings)
                    
                      }
                    
                }
                                .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                 
                
             
                
                Divider()
            
        }
            
     
    }
        .onAppear {
         
            self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
            getTotals()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            getTotals()
        
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            getTotals()
            }
//        .onReceive(timer) { _ in
//            getGoals()
//                   self.now = Date()
//               }
       
        
     
    }
    
    private func getTotals()
    {
        self.totalGoals = 0
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        self.goals.items = [GoalModel]()
        
        do {
            let savedGoals =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedGoals.count {

                                let amount: Double = currencies.convert(currencyFrom: self.goalsFetch[index].currency!, currencyTo: settings.currency, value: self.goalsFetch[index].amount)
                                
                                self.totalGoals = self.totalGoals + amount
                                    }
        } catch {
           
        }

    }
    
    private func saveTransaction(transaction: TransactionModel)
    {
      
            withAnimation {
               
                self.transactionData.addTransactions(transaction: transaction)
            }
        getTotals()
    }
    
    private func addGoal(goal: GoalModel)
    {
      
            withAnimation {
               
                let newGoal = Goal(context: viewContext)
                newGoal.id = UUID()
                newGoal.name = goal.name
                newGoal.amount = goal.amount
                newGoal.target = goal.target
                newGoal.symbol = goal.symbol
                newGoal.currency = goal.currency
                newGoal.iconColor = goal.iconColor
                newGoal.iconContent = goal.iconContent
                

      SaveContext()
            }
        getTotals()
    }
    
    private func updateGoal(goal: GoalModel)
    {
      
          
        do {
                let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
                
                let savedGoal = try  self.viewContext.fetch(request)[0]
                
                savedGoal.name = goal.name
            savedGoal.amount = goal.amount
            savedGoal.symbol = goal.symbol
            savedGoal.currency = goal.currency
            savedGoal.amount = goal.amount
            savedGoal.target = goal.target
            savedGoal.iconColor = goal.iconColor
            savedGoal.iconContent = goal.iconContent
            
            
        } catch {
            print(error)
        }

      SaveContext()
        getTotals()

    }
    
    private func deleteGoal(goal: GoalModel)
    {

            withAnimation {
                
                let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
               

                    do {
                        let savedGoals = try  self.viewContext.fetch(request)
                        
                        for goal in savedGoals {
                            self.viewContext.delete(goal)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
        getTotals()
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    private func map(goal: Goal) -> GoalModel
    {
        var goalModel = GoalModel()
        
        goalModel.id = goal.id!
        goalModel.name = goal.name ?? ""
        goalModel.symbol = goal.symbol ?? ""
        goalModel.currency = goal.currency ?? ""
        goalModel.amount = goal.amount
        goalModel.target = goal.target
        goalModel.iconColor = goal.iconColor ?? ""
        goalModel.iconContent = goal.iconContent ?? ""

        return goalModel
    }
    
   
}


//#if DEBUG
//struct GoalsView_Previews: PreviewProvider {
//    
//    static var viewContext = PersistenceController.preview.container.viewContext
//    
//    static var previews: some View {
//       
//        GoalListView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//        
//    }
//}
//#endif
