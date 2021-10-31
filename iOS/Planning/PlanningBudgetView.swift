//
//  PlanningBudgetView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/5/21.
//

import SwiftUI
import CoreData

struct PlanningBudgetBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var delete: Bool = false
  
    
    @State var budgetSelected : BudgetModel = BudgetModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchAccounts = AccountData()

    @State var categories = GetCategories()
    @ObservedObject var budgets = GetMonthlyBudgets()
    @State var accounts = GetAccounts()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var isPlanning : Bool = true
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var budgetsFetch: FetchedResults<MonthlyBudget>

    @Binding var totalBudgets: Double
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Section(header:
                        HStack {
                            VStack{
                                Spacer()
                            Text("BUDGETS")
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
                                Button(action: {
                                    self.budgetSelected = BudgetModel()
                                    self.budgetSelected.iconContent = "camera"
                                    self.budgetSelected.iconColor = "red"
                                    self.budgetSelected.currency = settings.currency
                                    self.budgetSelected.symbol = settings.symbol
                                    self.isShowingNew = true
                                }) {
                                    
                                    CommandButton(content: "plus.circle")
                                }
                                .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                    if(self.$budgetSelected.name.wrappedValue != "") {
                                     addBudget(budget: self.$budgetSelected.wrappedValue)
                                    }
                                      
                                    }) {
                                    BudgetAddView(budget: self.$budgetSelected, transaction: self.$transaction, currencies: self.$currencies)
                                }
                                .frame(width: 15, height: 15)
                                .padding(.leading, 10)
                                .padding(.trailing, 17)
                                .padding(.bottom, 12)
                            }
                           
                        }
                      
                        
            ) {

                Divider()
                
              
                
                ForEach(self.budgetsFetch.indexed(), id: \.1.id) { index, item in
                    
                    
                                        Button(action: {
                                            self.budgetSelected = map(budget: item)
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
                                                    .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                    .font(.system(size: 15))
                                                        
                                                Spacer()
                                                        Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                    .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                    .font(.system(size: 15))

                                                        
                                                    }
                                                        Spacer()
                                                      
                                                        
                                                    }
                                            }
                                            .frame(maxWidth: .infinity)
                                           
                                                
                                              
                                            }
                                            
                                        }
                                        .sheet(isPresented: self.$isShowing, onDismiss: {
                                            
                                            if(self.delete) {
                                                deleteBudget(budget: self.$budgetSelected.wrappedValue)
                                            } else {

                                                updateBudget(budget: self.$budgetSelected.wrappedValue)
                                            }
                                            
                                           
                                        }) {
                                            BudgetUpdateView(budget: self.$budgetSelected, transaction: self.$transaction, modal: self.$isShowing, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories, isPlanning: $isPlanning)
                                            

                    
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
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            getTotals()
//        
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            getTotals()
//            }
       
    }
    
    func getTotals()
    {
        let fetchRequest: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
        self.totalBudgets = 0
        
        do {
            let savedBudgets =  try viewContext.fetch(fetchRequest)

            for index in 0..<savedBudgets.count {

                let amount: Double = currencies.convert(currencyFrom: self.budgetsFetch[index].currency!, currencyTo: settings.currency, value: self.budgetsFetch[index].amount)
                
                self.totalBudgets = self.totalBudgets + amount
                    }
        } catch {

        }

    }
    
    func addBudget(budget: BudgetModel)
    {
      
            withAnimation {
               
                let newBudget = MonthlyBudget(context: viewContext)
                newBudget.id = UUID()
                newBudget.name = budget.name
                newBudget.amount = budget.amount
                newBudget.symbol = budget.symbol
                newBudget.currency = budget.currency
                newBudget.iconColor = budget.iconColor
                newBudget.iconContent = budget.iconContent

      SaveContext()
            }
        
        getTotals()

    }
    
    func updateBudget(budget: BudgetModel)
    {
      
          
        do {
                let request: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", budget.id as CVarArg)
                
                let savedBudget = try  self.viewContext.fetch(request)[0]
                
            savedBudget.name = budget.name
            savedBudget.amount = budget.amount
            savedBudget.symbol = budget.symbol
            savedBudget.currency = budget.currency
            savedBudget.amount = budget.amount
            savedBudget.iconColor = budget.iconColor
            savedBudget.iconContent = budget.iconContent
            
            
        } catch {
            print(error)
        }

      SaveContext()
            
        getTotals()
    }
    
    func deleteBudget(budget: BudgetModel)
    {
      
            withAnimation {
                
                let request: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", budget.id as CVarArg)
               

                    do {
                        let savedBudgets = try  self.viewContext.fetch(request)
                        
                        for budget in savedBudgets {
                            self.viewContext.delete(budget)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
       
        getTotals()
    }
    
    func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func map(budget: MonthlyBudget) -> BudgetModel
    {
        var budgetModel = BudgetModel()
        
        budgetModel.id = budget.id!
        budgetModel.name = budget.name ?? ""
        budgetModel.symbol = budget.symbol ?? ""
        budgetModel.currency = budget.currency ?? ""
        budgetModel.amount = budget.amount
        budgetModel.iconColor = budget.iconColor ?? ""
        budgetModel.iconContent = budget.iconContent ?? ""

        return budgetModel
    }
    
   
}
