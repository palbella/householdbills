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
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var save: Bool = false
    @State var delete: Bool = false
   
    
    @State var budgetSelected : BudgetModel = BudgetModel()
    @State var transaction : TransactionModel = TransactionModel()
    
    @State var currencies = GetCurrencies()
    @ObservedObject var fetchCurrencies = CurrencyData()
    @ObservedObject var transactionData = TransactionData()
    @ObservedObject var fetchCategories = FetchCategories()
    @ObservedObject var fetchAccounts = AccountData()

    @State var budgetData : BudgetData = BudgetData()
    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Budget")
    
    @State var tutorial: TutorialData = TutorialData()
    
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
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var showSubscribe: Bool
    @Binding var showTutorialBudget: Bool
    
    @Binding var totalAccounts: Double
    @Binding var totalGoalAccounts: Double
    
    func onAppear() {
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
        self.currencies.items = fetchCurrencies.fetch()
        getTotals()
    }
    
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
                                        if(settings.subscribed || self.budgetsFetch.count < 1) {
                                        self.budgetSelected = BudgetModel()
                                        self.transaction = TransactionModel()
                                        self.budgetSelected.iconContent = "camera"
                                        self.budgetSelected.iconColor = "red"
                                        self.budgetSelected.currency = settings.currency
                                        self.budgetSelected.symbol = settings.symbol
                                        self.isShowingNew = true
                                            self.save = false
                                        } else {
                                           
                                            self.showSubscribe = true
                                        }
                                    }) {

                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                    
                                        
                                        self.onAdd()

                                        }) {
                                        BudgetAddView(budget: self.$budgetSelected, transaction: self.$transaction, currencies: self.$currencies, modal: self.$isShowingNew, save: self.$save, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
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
                                                if(settings.subscribed || index < 1) {
                                                    self.budgetSelected = budgetData.map(budget: item)
                                                self.transaction = TransactionModel()
                                                self.transaction.type = LocalizedStringKey("Budget Adjustment").toString()
                                                self.transaction.initialAmount = self.$budgetSelected.amount.wrappedValue
                                                self.transaction.category = 1
                                                self.delete = false
                                                    self.save = false
                                                self.isShowing = true
                                                } else {
                                                   
                                                    self.showSubscribe = true
                                                }
                                            }) {

                                                VStack (spacing: 0) {
                                                    CommandAnimationBorder(animation: self.$showTutorialBudget)
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
                                                    CommandAnimationBorder(animation: self.$showTutorialBudget)
                                                .frame(maxWidth: .infinity)



                                                }

                                            }
                                            .sheet(isPresented: self.$isShowing, onDismiss: {
                                           

                                                if(self.delete) {
                                                    self.onDelete()
                                                } else {
                                                    self.onUpdate()
                                                }


                                            }) {
                                               BudgetUpdateView(budget: self.$budgetSelected, transaction: self.$transaction, modal: self.$isShowing, save: self.$save, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories, isPlanning: $isPlanning, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                                .environmentObject(self.ui)



                          }

                    }
                                    .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)


                   

                    Divider()


            }



        }
            .onAppear {
                self.onAppear()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                getTotals()

            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                getTotals()
                }
     
    }
    
    func onAdd() {
        if(settings.fastApply || self.save) {
        if(self.$budgetSelected.name.wrappedValue != "") {
            self.transaction.name =  self.transferTypes.names[0]
            self.transaction.account = self.$budgetSelected.name.wrappedValue
            self.transaction.amount = self.$budgetSelected.amount.wrappedValue
            self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
            self.transaction.currency = self.$budgetSelected.currency.wrappedValue
            self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
            self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
            self.transaction.timestamp = Date()
            saveTransaction(transaction: self.transaction)
            budgetData.addBudget(budget: self.$budgetSelected.wrappedValue)
            getTotals()
        } else {
            self.toastMessasge = LocalizedStringKey("Name is required").toString()
            self.isShowingToast = true
            self.toastError = true
        }
        }
    }
    
    func onUpdate() {
        if(settings.fastApply || self.save) {
            
            self.transaction.name =  self.transferTypes.names[2]
            self.transaction.account = self.$budgetSelected.name.wrappedValue
            self.transaction.amount = self.$transaction.amount.wrappedValue
            if(transaction.type == LocalizedStringKey("Expense").toString()) {
                self.$transaction.amount.wrappedValue = self.$transaction.amount.wrappedValue * -1
            }
            self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
            self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
            self.transaction.currency = self.$budgetSelected.currency.wrappedValue
            self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
            self.transaction.timestamp = Date()
            saveTransaction(transaction: self.transaction)
            
        if(self.$transaction.amount.wrappedValue > 0 && (self.$transaction.type.wrappedValue == LocalizedStringKey("Expense").toString() || self.$transaction.type.wrappedValue == LocalizedStringKey("Income").toString())) {
           
            budgetData.accountAdjustment(destination: self.$transaction.destinationId.wrappedValue, amount: self.$transaction.amount.wrappedValue)
            
        }
            
            tutorial.saveTutorial(name: "dashboard", tutorialStep: 1)
            self.showTutorialBudget = false
            
            budgetData.updateBudget(budget: self.$budgetSelected.wrappedValue)
            getTotals()
        }
    }
    
    func onDelete() {
        self.transaction.name =  self.transferTypes.names[1]
        self.transaction.account = self.$budgetSelected.name.wrappedValue
        self.transaction.amount = self.$budgetSelected.amount.wrappedValue
        self.transaction.symbol = self.$budgetSelected.symbol.wrappedValue
        self.transaction.iconContent = self.$budgetSelected.iconContent.wrappedValue
        self.transaction.iconColor = self.$budgetSelected.iconColor.wrappedValue
        self.transaction.timestamp = Date()
        saveTransaction(transaction: self.transaction)
        budgetData.deleteBudget(budget: self.$budgetSelected.wrappedValue)
        getTotals()
    }
    
    private func saveTransaction(transaction: TransactionModel)
    {
      
            withAnimation {
               
                self.transactionData.addTransactions(transaction: transaction)
                self.expenses = abs(transactionData.fetchExpenses())
                self.incomes = transactionData.fetchIncomes()
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
        getTotalAccounts()

    }
    
    private func getTotalAccounts()
    {
        self.totalAccounts = 0
        self.totalGoalAccounts = 0
        
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        do {
            let savedAccounts =  try viewContext.fetch(fetchRequest)

                            for index in 0..<savedAccounts.count {

                                let amount: Double = currencies.convert(currencyFrom: savedAccounts[index].currency!, currencyTo: settings.currency, value: savedAccounts[index].amount)
                                
                                self.totalAccounts = self.totalAccounts + amount
                                if(!savedAccounts[index].ignoreGoal) {
                                self.totalGoalAccounts = self.totalGoalAccounts + amount
                                }
                             }
            
            self.totalAccounts = round(self.totalAccounts * 100) / 100
            self.totalGoalAccounts = round(self.totalGoalAccounts * 100) / 100

        } catch {

        }



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

