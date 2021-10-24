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
        @State var delete: Bool = false
        @State var accountSelected : AccountModel = AccountModel()
        @State var transaction : TransactionModel = TransactionModel()
        
        @State var currencies = GetCurrencies()
        @ObservedObject var fetchCurrencies = FetchCurrencies()
        @ObservedObject var fetchTransactions = FetchTransactions()
        @ObservedObject var fetchAccounts = FetchAccounts()
        @ObservedObject var fetchCategories = FetchCategories()
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State var now = Date()
        @State private var counter = 0
        
        @ObservedObject var transferTypes = GetTransactionTypes(type: "Account")
        
        @State var accounts = GetAccounts()
        @State var categories = GetCategories()
        
        @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var accountsFetch: FetchedResults<Account>
        
        @Binding var totalAccounts: Double
        @Binding var totalGoalAccounts: Double
        @Binding var incomes: Double
        @Binding var expenses: Double
        @Binding var hideData: Bool
     
        @Binding var isShowingToast: Bool
        @Binding var toastMessasge: String
        @Binding var toastError: Bool
        
        func onAppear () {
            self.categories.items = fetchCategories.fetch(viewContext: viewContext)
            self.accounts.items = fetchAccounts.fetch(viewContext: viewContext)
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
                                            self.accountSelected = AccountModel()
                                            self.transaction = TransactionModel()
                                            self.accountSelected.iconContent = "bank"
                                            self.accountSelected.iconColor = "blue"
                                            self.accountSelected.type = "saving"
                                            self.accountSelected.currency = settings.currency
                                            self.accountSelected.symbol = settings.symbol
                                            self.isShowingNew = true
                                        }) {
                                            
                                            CommandButton(content: "plus.circle")
                                        }
                                        .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                         
                                          
                                                           if(self.$accountSelected.name.wrappedValue != "") {
                                                               if(self.$accountSelected.amount.wrappedValue > 0) {
                                                                   self.transaction.name =  self.transferTypes.names[0]
                                                                   self.transaction.account = self.$accountSelected.name.wrappedValue
                                                                    self.transaction.amount = self.$accountSelected.amount.wrappedValue
                                                                    self.transaction.symbol = self.$accountSelected.symbol.wrappedValue
                                                                   self.transaction.currency = self.$accountSelected.currency.wrappedValue
                                                                    self.transaction.iconContent = self.$accountSelected.iconContent.wrappedValue
                                                                    self.transaction.iconColor = self.$accountSelected.iconColor.wrappedValue
                                                                    self.transaction.category = 0
                                                                    self.transaction.timestamp = Date()
                                                                    saveTransaction(transaction: self.transaction)
                                                               }
                                                            addAccount(account: self.$accountSelected.wrappedValue)
                                                           }
                                                

                                            }) {
                                                AccountAddView(account: self.$accountSelected, transaction: self.$transaction, currencies: self.$currencies)
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
                                                                        self.accountSelected = map(account: item)
                                                                          self.transaction = TransactionModel()
                                                                          self.transaction.initialAmount = self.$accountSelected.amount.wrappedValue
                                                                          self.transaction.type = LocalizedStringKey("Expense").toString()
                                                                          self.transaction.category = 99
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

                                                                          }
                                                                          
                                                                      }
                                                                      .sheet(isPresented: self.$isShowing, onDismiss: {
                                                                          
                                                                          
                                                                          if(self.delete) {
                                                                              self.transaction.name =  self.transferTypes.names[1]
                                                                              self.transaction.account = self.$accountSelected.name.wrappedValue
                                                                              self.transaction.amount = self.$accountSelected.amount.wrappedValue
                                                                              self.transaction.symbol = self.$accountSelected.symbol.wrappedValue
                                                                              self.transaction.currency = self.$accountSelected.currency.wrappedValue
                                                                              self.transaction.iconContent = self.$accountSelected.iconContent.wrappedValue
                                                                              self.transaction.iconColor = self.$accountSelected.iconColor.wrappedValue
                                                                              self.transaction.timestamp = Date()
                                                                              saveTransaction(transaction: self.transaction)
                                                                              deleteAccount(account: self.$accountSelected.wrappedValue)
                                                                          } else {
                                                                            
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
                                                                                  
                                                                                  saveTransaction(transaction: self.transaction)
                                                                              }
                                                                              updateAccount(account: self.$accountSelected.wrappedValue)
                                                                              if(transaction.type == LocalizedStringKey("Transfer").toString()) {
                                                                                  transferAccount(destination: self.$transaction.destinationId.wrappedValue, amount: self.$transaction.amount.wrappedValue, currencyFrom: self.$accountSelected.currency.wrappedValue)
                                                                              }

                                                                          }

                                                                      }) {
                                                                        
                                                                          AccountUpdateView(account: self.$accountSelected, transaction: self.$transaction, modal: self.$isShowing, delete: self.$delete, currencies: self.$currencies, accounts: $accounts, categories: $categories)
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
                   
                    self.fetchTransactions.addTransactions(viewContext: viewContext, transaction: transaction)
                    self.expenses = abs(fetchTransactions.fetchExpenses(viewContext: viewContext))
                    self.incomes = fetchTransactions.fetchIncomes(viewContext: viewContext)
                }
            
          
            getTotals()
        }
        
        private func addAccount(account: AccountModel)
        {
          
                withAnimation {
                    
                    let newAccount = Account(context: viewContext)
                      newAccount.id = UUID()
                      newAccount.name = account.name
                    newAccount.amount = account.amount
                    newAccount.symbol = account.symbol
                    newAccount.currency = account.currency
                    newAccount.iconColor = account.iconColor
                    newAccount.iconContent = account.iconContent
                    newAccount.type = account.type
                    newAccount.ignoreGoal = account.ignoreGoal
                    

          SaveContext()
                    
                    self.accounts.items = fetchAccounts.fetch(viewContext: viewContext)
                }
            
            getTotals()

        }
        
        private func updateAccount(account: AccountModel)
        {
          
              
            do {
                    let request: NSFetchRequest<Account> = Account.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", account.id as CVarArg)
                    
                    let savedAccount = try  self.viewContext.fetch(request)[0]
                    
                    savedAccount.name = account.name
                if(self.$accountSelected.wrappedValue.type != "crypto") {
                    savedAccount.amount = account.amount
                }
                savedAccount.symbol = account.symbol
                savedAccount.currency = account.currency
                savedAccount.amount = account.amount
                savedAccount.iconColor = account.iconColor
                savedAccount.iconContent = account.iconContent
                savedAccount.type = account.type
                savedAccount.ignoreGoal = account.ignoreGoal
                
                
            } catch {
                print(error)
            }

          SaveContext()
            getTotals()

        }
        
        private func transferAccount(destination: UUID, amount: Double, currencyFrom: String)
        {
          
              
            do {
                    let request: NSFetchRequest<Account> = Account.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", destination as CVarArg)
                    
                    let savedAccount = try  self.viewContext.fetch(request)[0]
                
                let amountConverted: Double = currencies.convert(currencyFrom: currencyFrom, currencyTo: savedAccount.currency!, value: amount)
                    
                savedAccount.amount = savedAccount.amount + amountConverted
                
                
                
            } catch {
                print(error)
            }

          SaveContext()
            getTotals()

        }
        
        private func deleteAccount(account: AccountModel)
        {
           var existOne = false
            
            
            for index in 0..<self.accountsFetch.count {

                if(self.accountsFetch[index].id != account.id) {
                    if(self.accountsFetch[index].type == "saving" || self.accountsFetch[index].type == "checking" || self.accountsFetch[index].type == "cash") {
                        existOne = true
                    }
                }
                
             }
            
            
            if(existOne) {
                withAnimation {
                    
                    let request: NSFetchRequest<Account> = Account.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", account.id as CVarArg)
                   

                        do {
                            let savedAccounts = try  self.viewContext.fetch(request)
                            
                            for account in savedAccounts {
                                self.viewContext.delete(account)
                            }
                            try self.viewContext.save()
                        } catch {
                            print(error)
                        }
                    
                }

            getTotals()
            } else {
                self.toastMessasge = "At least one bank or cash account must be created"
                self.isShowingToast = true
                self.toastError = true
            }
        }
        
        private func SaveContext () {
        do {

      try viewContext.save()
            

            }
                                
        
        catch {
          
        }
        }
        
        private func map(account: Account) -> AccountModel
        {
            var accountModel = AccountModel()
            
            accountModel.id = account.id!
            accountModel.name = account.name ?? ""
            accountModel.symbol = account.symbol ?? ""
            accountModel.currency = account.currency ?? ""
            accountModel.amount = account.amount
            accountModel.iconColor = account.iconColor ?? ""
            accountModel.iconContent = account.iconContent ?? ""
            accountModel.type = account.type!
            accountModel.ignoreGoal = account.ignoreGoal

            return accountModel
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

    
    
    
    
 
   
  
