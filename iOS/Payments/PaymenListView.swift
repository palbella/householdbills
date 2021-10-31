//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct PaymentListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var delete: Bool = false
   
    @State var paymentSelected : PaymentModel = PaymentModel()
    @State var transaction : TransactionModel = TransactionModel()
    @State var categories = GetCategories()
    
    @State var currencies = GetCurrencies()
    @State var accounts = GetAccounts ()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var transactionData = TransactionData()
    @ObservedObject var fetchAccounts = AccountData()
    @ObservedObject var fetchCategories = FetchCategories()

    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Payment")
    
    @ObservedObject var payments = GetPayments()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var paymentsFetch: FetchedResults<Payment>
    
    @Binding var totalPayments: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    @Binding var hideData: Bool
    
    
    func onAppear() {
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
        getTotals()
    }
    
    var body: some View {
        
        
            
            VStack(spacing: 0) {

                Section(header:
                            HStack {
                                VStack{
                                    Spacer()
                                Text("PAYMENTS")
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
                                        self.paymentSelected = PaymentModel()
                                        self.transaction = TransactionModel()
                                        self.paymentSelected.iconContent = "lightbulb"
                                        self.paymentSelected.iconColor = "red"
                                        self.paymentSelected.currency = settings.currency
                                        self.paymentSelected.symbol = settings.symbol
                                        self.isShowingNew = true
                                    }) {

                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {

                                        if(self.$paymentSelected.name.wrappedValue != "") {
                                         addPayment(payment: self.$paymentSelected.wrappedValue)
                                        }

                                        }) {
                                            PaymentAddView(payment: self.$paymentSelected, transaction: self.$transaction, currencies: self.$currencies, accounts: $accounts, categories: self.$categories)
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

                 

                    ForEach(self.paymentsFetch.indexed(), id: \.1.id) { index, item in


                                            Button(action: {
                                                self.paymentSelected = map(payment: item)
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
                                                             


                                                                Button(action: {
                                                                    self.paymentSelected = map(payment: item)
                                                                    self.paymentSelected.isPaid = true
                                                                    updatePayment(payment: self.$paymentSelected.wrappedValue)
                                                                }) {

                                                                    if(item.isPaid) {
                                                                        Text("Paid")
                                                                            .frame(minWidth: 60)
                                                                            .font(.system(size: 12))
                                                                            .background(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                                                            .cornerRadius(40)
                                                                            .foregroundColor(.white)
                                                                            .padding(2)
                                                                            .overlay(
                                                                                RoundedRectangle(cornerRadius: 40)
                                                                                    .stroke(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor, lineWidth: 1 )
                                                                            )
                                                                    } else {
                                                                        if(!item.isGoal) {
                                                                            Text("PAY")
                                                                                .frame(minWidth: 60)
                                                                                .font(.system(size: 12))
                                                                                .background(colorScheme != .dark ? Color.red: Color.red)
                                                                                .cornerRadius(40)
                                                                                .foregroundColor(.white)
                                                                                .padding(2)
                                                                                .overlay(
                                                                                    RoundedRectangle(cornerRadius: 40)
                                                                                        .stroke(colorScheme != .dark ? Color.red: Color.red, lineWidth: 1 )
                                                                                )
                                                                        } else {
                                                                            Text("DEPOSIT")
                                                                                .frame(minWidth: 60)
                                                                                .font(.system(size: 12))
                                                                                .background(colorScheme != .dark ? Color.yellow: Color.yellow)
                                                                                .cornerRadius(40)
                                                                                .foregroundColor(.white)
                                                                                .padding(2)
                                                                                .overlay(
                                                                                    RoundedRectangle(cornerRadius: 40)
                                                                                        .stroke(colorScheme != .dark ? Color.yellow: Color.yellow, lineWidth: 1 )
                                                                                )
                                                                        }
                                                                    }

                                                                }
                                                                .font(.system(size: 10))
                                                                .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                .frame(width: 70, height: 29)
                                                                

                                                                if(!self.hideData) {
                                                                    Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15)) //, weight: .heavy
                                                            .frame(minWidth: 130, alignment: .trailing)
                                                                } else {
                                                                    Text(item.symbol! + "---").padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                            .font(.system(size: 15)) //, weight: .heavy
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

                                                if(self.delete == true) {
                                                    deletePayment(payment: self.$paymentSelected.wrappedValue)
                                                } else {
                                                    updatePayment(payment: self.$paymentSelected.wrappedValue)
                                                }



                                            }) {
                                                PaymentUpdateView(payment: self.$paymentSelected, transaction: self.$transaction, modal: self.$isShowing, delete: self.$delete, currencies: self.$currencies, accounts: self.$accounts, categories: self.$categories)
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
    
    
    
    
    private func saveTransaction(transaction: TransactionModel)
    {
      
            withAnimation {
               
                self.transactionData.addTransactions(transaction: transaction)
            }
        getTotals()
    }
    
    private func getTotals()
    {
        self.totalPayments = 0
        let fetchRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
        
        do {
            let savedPayments =  try viewContext.fetch(fetchRequest)
       
                            for index in 0..<savedPayments.count {
                                if(self.paymentsFetch[index].isPaid != true) {
                                let amount: Double = currencies.convert(currencyFrom: self.paymentsFetch[index].currency!, currencyTo: settings.currency, value: self.paymentsFetch[index].amount)

                                self.totalPayments = self.totalPayments + amount
                                }
                                    }
        } catch {
            print(error)
        }

    }
    
    
    private func addPayment(payment: PaymentModel)
    {
      
            withAnimation {

                let newPayment = Payment(context: viewContext)
                newPayment.id = UUID()
                newPayment.name = payment.name
                newPayment.amount = payment.amount
                newPayment.symbol = payment.symbol
                newPayment.currency = payment.currency
                if(payment.isGoal == true && payment.goalId == nil) {
                    newPayment.isGoal = false
                } else {
                    newPayment.isGoal = payment.isGoal
                }
                newPayment.isPaid = payment.isPaid
                newPayment.goalId = payment.goalId
                newPayment.iconColor = payment.iconColor
                newPayment.iconContent = payment.iconContent
                newPayment.account = payment.account
                newPayment.category = payment.category
                newPayment.order = payment.order
                newPayment.priority = payment.priority
                newPayment.notificated = payment.notificated
                newPayment.notificationDay = payment.notificationDay
               

      SaveContext()
            }
        
        getTotals()

    }
    
    private func updatePayment(payment: PaymentModel)
    {
        var payStatusChanged: Bool = false
          
        do {
                let request: NSFetchRequest<Payment> = Payment.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.id as CVarArg)
                
                let savedPayment = try  self.viewContext.fetch(request)[0]
                
            payStatusChanged = savedPayment.isPaid != payment.isPaid
            
                savedPayment.name = payment.name
            savedPayment.amount = payment.amount
            savedPayment.symbol = payment.symbol
            savedPayment.currency = payment.currency
            savedPayment.amount = payment.amount
            savedPayment.isPaid = payment.isPaid
            if(payment.isGoal == true && payment.goalId == nil) {
                savedPayment.isGoal = false
            } else {
                savedPayment.isGoal = payment.isGoal
            }
            savedPayment.goalId = payment.goalId
            savedPayment.iconColor = payment.iconColor
            savedPayment.iconContent = payment.iconContent
            savedPayment.account = payment.account
            savedPayment.category = payment.category
            savedPayment.order = payment.order
            savedPayment.priority = payment.priority
            savedPayment.notificated = payment.notificated
            savedPayment.notificationDay = payment.notificationDay
        
            
            SaveContext()
            
            if(payStatusChanged) {
                
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.account as CVarArg)
              
                let savedAccount = try  self.viewContext.fetch(request)[0]
                
                
                var amount: Double = currencies.convert(currencyFrom: self.$paymentSelected.currency.wrappedValue, currencyTo: savedAccount.currency!, value: abs(self.$paymentSelected.amount.wrappedValue))
                
                
                if(payment.isPaid) {
                    amount = amount * -1
                }

                
                self.transaction.name = self.$paymentSelected.name.wrappedValue
                self.transaction.account = savedAccount.name!
                self.transaction.symbol = self.$paymentSelected.symbol.wrappedValue
                self.transaction.currency = self.$paymentSelected.currency.wrappedValue
                self.transaction.iconContent = self.$paymentSelected.iconContent.wrappedValue
                self.transaction.iconColor = self.$paymentSelected.iconColor.wrappedValue
                self.transaction.timestamp = Date()
                self.transaction.amount = amount
                saveTransaction(transaction: self.transaction)
                SaveContext()
                
                savedAccount.amount = savedAccount.amount + amount
                SaveContext()
                
                self.expenses = abs(transactionData.fetchExpenses())
                self.incomes = transactionData.fetchIncomes()
                
                if(payment.isGoal == true) {
                    let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", payment.goalId! as CVarArg)
                  
                    let savedGoal = try  self.viewContext.fetch(request)[0]
                    
                    var goalAmount: Double = currencies.convert(currencyFrom: self.$paymentSelected.currency.wrappedValue, currencyTo: savedGoal.currency!, value: abs(self.$paymentSelected.amount.wrappedValue))
                    
                    if(payment.isPaid == false) {
                        goalAmount = goalAmount * -1
                    }
                    
                    savedGoal.amount = savedGoal.amount + goalAmount
                    SaveContext()
                }
            }
            
            
            
        } catch {
            print(error)
        }

      SaveContext()
        getTotals()

    }
    
    private func deletePayment(payment: PaymentModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<Payment> = Payment.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.id as CVarArg)
               

                    do {
                        let savedPayments = try  self.viewContext.fetch(request)
                        
                        for payment in savedPayments {
                            self.viewContext.delete(payment)
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
        print(error)
    }
    }
    
    private func map(payment: Payment) -> PaymentModel
    {
        var paymentModel = PaymentModel()
        
        paymentModel.id = payment.id!
        paymentModel.name = payment.name ?? ""
        paymentModel.symbol = payment.symbol ?? ""
        paymentModel.currency = payment.currency ?? ""
        paymentModel.amount = payment.amount
        paymentModel.isPaid = payment.isPaid
        paymentModel.isGoal = payment.isGoal
        if(payment.goalId != nil) {
            paymentModel.goalId = payment.goalId!
        }
        paymentModel.iconColor = payment.iconColor ?? ""
        paymentModel.iconContent = payment.iconContent ?? ""
        paymentModel.account = payment.account!
        paymentModel.notificationDay = payment.notificationDay
        paymentModel.notificated = payment.notificated

        return paymentModel
    }
    

}


//#if DEBUG
//struct PaymentsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//       
//        PaymentsView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        
//    }
//}
//#endif
