//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct BudgetListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingBudgetPlanning: Bool = false
    @State var isShowingNewBudgetPlanning: Bool = false
    @State var delete: Bool = false
   
    
    @State var budgetSelected : BudgetModel = BudgetModel()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var fetchTransactions = FetchTransactions()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchAccounts = FetchAccounts()

    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Budget")
    
    @ObservedObject var budgets = GetBudgets()
    @State var categories = GetCategories()
    @State var accounts = GetAccounts()
    
    @State var isPlanning : Bool = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var budgetsFetch: FetchedResults<Budget>

    @Binding var totalBudgets: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    @Binding var hideData: Bool
    
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
                                        self.transaction = TransactionModel()
                                        self.budgetSelected.iconContent = "camera"
                                        self.budgetSelected.iconColor = "red"
                                        self.budgetSelected.currency = settings.currency
                                        self.budgetSelected.symbol = settings.symbol
                                        self.isShowingNewBudgetPlanning = true
                                    }) {

                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNewBudgetPlanning, onDismiss: {
                                        if(self.$budgetSelected.name.wrappedValue != "") {
                                            self.transaction.name =  self.transferTypes.names[0]
                                            self.transaction.account = self.$budgetSelected.name.wrappedValue
                                            self.transaction.amount = self.$budgetSelected.amount.wrappedValue
                                            self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
                                            self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
                                            self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
                                            self.transaction.timestamp = Date()
                                            saveTransaction(transaction: self.transaction)
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
                                                self.transaction = TransactionModel()
                                                self.transaction.type = LocalizedStringKey("Budget Adjustment").toString()
                                                self.transaction.initialAmount = self.$budgetSelected.amount.wrappedValue
                                                self.transaction.category = 1
                                                self.delete = false
                                                self.isShowingBudgetPlanning = true
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
                                                            if(!self.hideData) {
                                                                Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15))
                                                            } else {
                                                                Text(item.symbol! + "---").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15))
                                                            }
                                                            


                                                        }
                                                            Spacer()
                                                           

                                                        }
                                                }
                                                .frame(maxWidth: .infinity)



                                                }

                                            }
                                            .sheet(isPresented: self.$isShowingBudgetPlanning, onDismiss: {

                                                if(self.delete) {
                                                    self.transaction.name =  self.transferTypes.names[1]
                                                    self.transaction.account = self.$budgetSelected.name.wrappedValue
                                                    self.transaction.amount = self.$budgetSelected.amount.wrappedValue
                                                    self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
                                                    self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
                                                    self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
                                                    self.transaction.timestamp = Date()
                                                    saveTransaction(transaction: self.transaction)
                                                    deleteBudget(budget: self.$budgetSelected.wrappedValue)
                                                } else {
                                                    if(self.$transaction.amount.wrappedValue > 0 && (self.$transaction.type.wrappedValue == LocalizedStringKey("Expense").toString() || self.$transaction.type.wrappedValue == LocalizedStringKey("Income").toString())) {
                                                        self.transaction.name =  self.transferTypes.names[2]
                                                        self.transaction.account = self.$budgetSelected.name.wrappedValue
                                                        self.transaction.amount = self.$transaction.amount.wrappedValue
                                                        if(transaction.type == LocalizedStringKey("Expense").toString()) {
                                                            self.$transaction.amount.wrappedValue = self.$transaction.amount.wrappedValue * -1
                                                        }
                                                        self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
                                                        self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
                                                        self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
                                                        self.transaction.timestamp = Date()
                                                        saveTransaction(transaction: self.transaction)
                                                        
                                                        accountAdjustment(destination: self.$transaction.destinationId.wrappedValue, amount: self.$transaction.amount.wrappedValue)
                                                        
                                                    }
                                                    updateBudget(budget: self.$budgetSelected.wrappedValue)
                                                }


                                            }) {
                                               BudgetUpdateView(budget: self.$budgetSelected, transaction: self.$transaction, modal: self.$isShowingBudgetPlanning, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories, isPlanning: $isPlanning)
                                                .environmentObject(self.ui)



                          }

                    }
                                    .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)


                   

                    Divider()


            }



        }
            .onAppear {
                self.categories.items = fetchCategories.fetch(viewContext: viewContext)
                self.accounts.items = fetchAccounts.fetch(viewContext: viewContext)
                self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
                getTotals()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                getTotals()

            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                getTotals()
                }
//            .onReceive(timer) { _ in
//                getbudgets()
//                       self.now = Date()
//                   }
          
        
     
    }
    
    private func saveTransaction(transaction: TransactionModel)
    {
      
            withAnimation {
               
                self.fetchTransactions.addTransactions(viewContext: viewContext, transaction: transaction)
                self.expenses = abs(fetchTransactions.fetchExpenses(viewContext: viewContext))
                self.incomes = fetchTransactions.fetchIncomes(viewContext: viewContext)
            }
        getTotals()
    }
    
    private func getTotals()
    {
        self.totalBudgets = 0
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        self.budgets.items = [BudgetModel]()
        
        do {
            let savedBudgets =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedBudgets.count {

                                let amount: Double = currencies.convert(currencyFrom: self.budgetsFetch[index].currency!, currencyTo: settings.currency, value: self.budgetsFetch[index].amount)
                                
                                self.totalBudgets = self.totalBudgets + amount
                                    }
        } catch {
           
        }

    }
    
    private func addBudget(budget: BudgetModel)
    {
      
            withAnimation {
             
                let newBudget = Budget(context: viewContext)
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
    
    private func updateBudget(budget: BudgetModel)
    {
      
          
        do {
                let request: NSFetchRequest<Budget> = Budget.fetchRequest()
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
    
    private func deleteBudget(budget: BudgetModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<Budget> = Budget.fetchRequest()
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
    
    private func accountAdjustment(destination: UUID, amount: Double)
    {
      
          
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", destination as CVarArg)
                
                let savedAccount = try  self.viewContext.fetch(request)[0]
                
            savedAccount.amount = savedAccount.amount + amount
            
            
            
        } catch {
            print(error)
        }

      SaveContext()
        getTotals()

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    private func map(budget: Budget) -> BudgetModel
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


//#if DEBUG
//struct BudgetsDashboardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        BudgetsView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//
//    }
//}
//#endif

