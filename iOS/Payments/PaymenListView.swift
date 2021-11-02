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

    @State var paymentData = PaymentData ()
    
    @ObservedObject var transferTypes = GetTransactionTypes(type: "Payment")
    
    @ObservedObject var payments = GetPayments()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var paymentsFetch: FetchedResults<Payment>
    
    @Binding var totalPayments: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    @Binding var hideData: Bool
    
    @Binding var showSubscribe: Bool
    
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
                                        if(settings.subscribed || self.paymentsFetch.count < 2) {
                                        self.paymentSelected = PaymentModel()
                                        self.transaction = TransactionModel()
                                        self.paymentSelected.iconContent = "lightbulb"
                                        self.paymentSelected.iconColor = "red"
                                        self.paymentSelected.currency = settings.currency
                                        self.paymentSelected.symbol = settings.symbol
                                        self.isShowingNew = true
                                        } else {
                                           
                                            self.showSubscribe = true
                                        }
                                    }) {

                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {

                                        if(self.$paymentSelected.name.wrappedValue != "") {
                                            paymentData.addPayment(payment: self.$paymentSelected.wrappedValue)
                                            getTotals()
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
                                                if(settings.subscribed || index < 1) {
                                                    self.paymentSelected = paymentData.map(payment: item)
                                                self.transaction = TransactionModel()
                                                self.delete = false
                                                self.isShowing = true
                                                } else {
                                                   
                                                    self.showSubscribe = true
                                                }
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
                                                                    self.paymentSelected = paymentData.map(payment: item)
                                                                    self.paymentSelected.isPaid = true
                                                                    paymentData.updatePayment(payment: self.$paymentSelected.wrappedValue, transactionParam: self.$transaction.wrappedValue)
                                                                    getTotals()
                                                                    self.expenses = abs(transactionData.fetchExpenses())
                                                                    self.incomes = transactionData.fetchIncomes()
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
                                                    paymentData.deletePayment(payment: self.$paymentSelected.wrappedValue)
                                                    getTotals()
                                                } else {
                                                    paymentData.updatePayment(payment: self.$paymentSelected.wrappedValue, transactionParam: self.$transaction.wrappedValue)
                                                    getTotals()
                                                    self.expenses = abs(transactionData.fetchExpenses())
                                                    self.incomes = transactionData.fetchIncomes()
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
