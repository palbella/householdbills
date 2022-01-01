    //
    //  DashboardBodyView.swift
    //  HouseholdBills (iOS)
    //
    //  Created by Pablo Albella on 8/17/21.
    //

    import SwiftUI
    import CoreData

    struct AccountListView: View {
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject var settings: UserSettings
        @EnvironmentObject var ui: AppUI
        @Environment(\.managedObjectContext) private var viewContext
        
        
        @State var isShowing: Bool = false
        @State var isShowingNew: Bool = false
        @State var save: Bool = false
        @State var delete: Bool = false
        @State var accountSelected : AccountModel = AccountModel()
        @State var transaction : TransactionModel = TransactionModel()
        
        @State var currencies = GetCurrencies()
        @ObservedObject var fetchCurrencies = CurrencyData()
        @ObservedObject var transactionData = TransactionData()
        @ObservedObject var accountData = AccountData()
        @ObservedObject var budgetData = BudgetData()
        @ObservedObject var fetchCategories = FetchCategories()
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State var now = Date()
        @State private var counter = 0
        
        @ObservedObject var transferTypes = GetTransactionTypes(type: "Account")
        
        @State var accounts = GetAccounts()
        @State var categories = GetCategories()
        @State var budgets = GetBudgets()
        
        @State var tutorial: TutorialData = TutorialData()
        
        @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "group", ascending: true), NSSortDescriptor(key: "name", ascending: true)])
        var accountsFetch: FetchedResults<Account>
        
        @Binding var totalAccounts: Double
        @Binding var totalGoalAccounts: Double
        @Binding var incomes: Double
        @Binding var expenses: Double
        @Binding var hideData: Bool
     
        @Binding var isShowingToast: Bool
        @Binding var toastMessasge: String
        @Binding var toastError: Bool
        
        @Binding var showSubscribe: Bool
        @Binding var showTutorialBank: Bool
        
        
        func onAppear () {
            
            self.categories.items = fetchCategories.fetch(viewContext: viewContext)
            self.accounts.items = accountData.fetch()
            self.budgets.items = budgetData.fetch()
            self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
            getTotals()
        }
        
        var body: some View {
            
           
                VStack(spacing: 0) {
                    
                    Section(header:
                                HStack {
                                    VStack{
                                        Spacer()
                                    Text("ACCOUNTS")
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
                                            if(settings.subscribed || self.accountsFetch.count < 1) {
                                            self.accountSelected = AccountModel()
                                            self.transaction = TransactionModel()
                                            self.accountSelected.iconContent = "bank"
                                            self.accountSelected.iconColor = "blue"
                                            self.accountSelected.type = "saving"
                                            self.accountSelected.currency = settings.currency
                                            self.accountSelected.symbol = settings.symbol
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
                                                AccountAddView(account: self.$accountSelected, transaction: self.$transaction, currencies: self.$currencies, modal: self.$isShowingNew, save: self.$save, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                                .environmentObject(self.ui)
                                                    .environmentObject(self.settings)
                                            
                                        }
                                        .frame(width: 15, height: 15)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 17)
                                        .padding(.bottom, 12)
                                    }
                                   
                                }
                              
                                
                    ) {

                        Divider()
                        
                       
                        
                       
                                              ForEach(self.accountsFetch.indexed(), id: \.1.id) { index, item in
                                                  
                                                  
                                                  
                                                  let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                                                  
                                                                      Button(action: {
                                                                          if(settings.subscribed || index < 1) {
                                                                          self.accountSelected = self.accountData.map(account: item)
                                                                          self.transaction = TransactionModel()
                                                                          self.transaction.initialAmount = self.$accountSelected.amount.wrappedValue
                                                                          self.transaction.type = LocalizedStringKey("Expense").toString()
                                                                          self.transaction.category = 99
                                                                          self.delete = false
                                                                              self.save = false
                                                                          self.isShowing = true
                                                                          } else {
                                                                              
                                                                              self.showSubscribe = true
                                                                          }
                                                                      }) {
                                                                          
                                                                          VStack (spacing: 0) {
                                                                              CommandAnimationBorder(animation: self.$showTutorialBank)
                                                                              HStack (spacing: 0) {
                                                                                Icon(content: item.iconContent!, color: getColor(color: item.iconColor!)).padding(5).padding(.leading, 5).padding(.trailing, 5)

                                                                                  VStack (spacing: 0) {
                                                                                      Spacer()
                                                                                  HStack (spacing: 0) {
                                                                                    Text(item.name!)
                                                                                  .font(.system(size: 15))
                                                                                  .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                                                                              Spacer()
                                                                                    if(!self.hideData) {
                                                                                        Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                                                      .foregroundColor(fontColor)
                                                                                      .font(.system(size: 15))
                                                                                    } else {
                                                                                        Text(item.symbol! + "---").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                                                      .foregroundColor(fontColor)
                                                                                      .font(.system(size: 15))
                                                                                    }
                                                                                    


                                                                                  }
                                                                                      Spacer()
                                                                                   

                                                                                  }
                                                                          }
                                                                          .frame(maxWidth: .infinity)
                                                                              CommandAnimationBorder(animation: self.$showTutorialBank)
                                                                          }
                                                                          
                                                                      }
                                                                      .sheet(isPresented: self.$isShowing, onDismiss: {
                                                                         
                                                                          
                                                                          if(self.delete) {
                                                                              
                                                                              self.onDelete()
                                                                              
                                                                          } else {
                                                                            
                                                                              self.onUpdate()
                                                                              
                                                                          }

                                                                      }) {
                                                                        
                                                                          AccountUpdateView(account: self.$accountSelected, transaction: self.$transaction, modal: self.$isShowing, save: self.$save, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories, budgets: $budgets, showSubscribe: self.$showSubscribe, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                                                                              .environmentObject(self.ui)
                                                                            .environmentObject(self.settings)
                                                                        
                                                                          
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
            if(self.$accountSelected.name.wrappedValue != "") {
                if(self.$accountSelected.amount.wrappedValue > 0) {
                    self.transaction.name =  self.transferTypes.names[0]
                    self.transaction.account = self.$accountSelected.name.wrappedValue
                     self.transaction.amount = self.$accountSelected.amount.wrappedValue
                     self.transaction.symbol = self.$accountSelected.symbol.wrappedValue
                    self.transaction.currency = self.$accountSelected.currency.wrappedValue
                     self.transaction.iconContent = self.$accountSelected.iconContent.wrappedValue
                     self.transaction.iconColor = self.$accountSelected.iconColor.wrappedValue
                     self.transaction.category = 99
                     self.transaction.timestamp = Date()
                     saveTransaction(transaction: self.transaction)
                }
                self.accountData.addAccount(account: self.$accountSelected.wrappedValue)
                self.accounts.items = self.accountData.fetch()
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
            if(self.$accountSelected.type.wrappedValue == "crypto") {
                GetMarketCriptocurrencies(viewContext: viewContext).run()
            }
            
            if(self.$accountSelected.type.wrappedValue == "stock") {
                GetMarketStocks(viewContext: viewContext).run()
            }
            
              if(self.$transaction.amount.wrappedValue > 0) {
                  self.transaction.name =  self.transferTypes.names[2]
                  self.transaction.account = self.$accountSelected.name.wrappedValue
                  self.transaction.amount = self.$transaction.amount.wrappedValue
                  if(transaction.type == LocalizedStringKey("Expense").toString() || transaction.type == LocalizedStringKey("Transfer").toString()) {
                      self.$transaction.amount.wrappedValue = self.$transaction.amount.wrappedValue * -1
                  }
                  self.transaction.symbol = self.$accountSelected.symbol.wrappedValue
                  self.transaction.iconContent = self.$accountSelected.iconContent.wrappedValue
                  self.transaction.iconColor = self.$accountSelected.iconColor.wrappedValue
                  self.transaction.timestamp = Date()
                  self.transaction.currency = self.$accountSelected.currency.wrappedValue
                  
                  saveTransaction(transaction: self.transaction)
                  tutorial.saveTutorial(name: "dashboard", tutorialStep: 0)
                  self.showTutorialBank = false
              }
              self.accountData.updateAccount(account: self.$accountSelected.wrappedValue)
              if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                  self.accountData.transferAccount(destination: self.$transaction.destinationId.wrappedValue, amount: self.$transaction.amount.wrappedValue, currencyFrom: self.$accountSelected.currency.wrappedValue)
              }
                getTotals()
            }
        }
        
        func onDelete() {
            var existOne = false
             
             
             for index in 0..<self.accountsFetch.count {

                 if(self.accountsFetch[index].id != self.$accountSelected.wrappedValue.id) {
                     if(self.accountsFetch[index].type == "saving" || self.accountsFetch[index].type == "checking" || self.accountsFetch[index].type == "cash") {
                         existOne = true
                     }
                 }
                 
              }
             
             
             if(existOne) {
                self.transaction.name =  self.transferTypes.names[1]
                self.transaction.account = self.$accountSelected.name.wrappedValue
                self.transaction.amount = self.$accountSelected.amount.wrappedValue * -1
                self.transaction.symbol = self.$accountSelected.symbol.wrappedValue
                self.transaction.currency = self.$accountSelected.currency.wrappedValue
                self.transaction.iconContent = self.$accountSelected.iconContent.wrappedValue
                self.transaction.iconColor = self.$accountSelected.iconColor.wrappedValue
                self.transaction.timestamp = Date()
                saveTransaction(transaction: self.transaction)
                self.accountData.deleteAccount(account: self.$accountSelected.wrappedValue)
                getTotals()
             } else {
                 self.toastMessasge = "At least one bank or cash account must be created"
                 self.isShowingToast = true
                 self.toastError = true
             }
        }
        
        private func getTotals()
        {
            self.totalAccounts = 0
            self.totalGoalAccounts = 0
            
            
            let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

            do {
                let savedAccounts =  try viewContext.fetch(fetchRequest)

                                for index in 0..<savedAccounts.count {

                                    let amount: Double = currencies.convert(currencyFrom: self.accountsFetch[index].currency!, currencyTo: settings.currency, value: self.accountsFetch[index].amount)
                                    
                                    self.totalAccounts = self.totalAccounts + amount
                                    if(!self.accountsFetch[index].ignoreGoal) {
                                    self.totalGoalAccounts = self.totalGoalAccounts + amount
                                    }
                                 }
                
                self.totalAccounts = round(self.totalAccounts * 100) / 100
                self.totalGoalAccounts = round(self.totalGoalAccounts * 100) / 100

            } catch {

            }



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
        
    
        
      
    }


//    #if DEBUG
//    struct AccountsView_Previews: PreviewProvider {
//
//        static var viewContext = PersistenceController.preview.container.viewContext
//
//
//        static var previews: some View {
//
//
//            AccountListView().environmentObject(UserSettings())
//                    .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//        }
//    }
//    #endif

    
    
    
    
 
   
  
