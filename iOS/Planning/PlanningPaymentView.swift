//
//  PlanningPaymentView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/5/21.
//

import SwiftUI
import CoreData

struct PlanningPaymentBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var save: Bool = false
    @State var delete: Bool = false
    
    @State var paymentSelected : PaymentModel = PaymentModel()
    @State var transaction : TransactionModel = TransactionModel()

    @State var currencies = GetCurrencies()
    @State var accounts = GetAccounts ()
    @State var categories = GetCategories()
    @ObservedObject var fetchCurrencies = CurrencyData()
    @ObservedObject var fetchAccounts = AccountData()
    @ObservedObject var fetchCategories = FetchCategories()
    
    @State var monthlyPaymentData = MonthlyPaymentData()
    
    @ObservedObject var payments = GetMontlyPayments()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var paymentsFetch: FetchedResults<MonthlyPayment>

    
    @Binding var totalPayments: Double
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var showSubscribe: Bool
    
    func onAppear() {
        
        self.categories.items = fetchCategories.fetch(viewContext: viewContext)
        self.accounts.items = fetchAccounts.fetch()
        self.currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
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
                                    self.paymentSelected.iconContent = "lightbulb"
                                    self.paymentSelected.iconColor = "red"
                                    self.paymentSelected.currency = settings.currency
                                    self.paymentSelected.symbol = settings.symbol
                                    self.isShowingNew = true
                                    self.save = false
                                    } else {
                                       
                                        self.showSubscribe = true
                                    }
                                }) {

                                    CommandButton(content: "plus.circle")
                                }
                                .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                    if(settings.fastApply || self.save) {
                                    if(self.$paymentSelected.name.wrappedValue != "") {
                                        monthlyPaymentData.addPayment(payment: self.$paymentSelected.wrappedValue)
                                        getTotals()
                                    }
                                    }

                                    }) {
                                        PaymentAddView(payment: self.$paymentSelected, transaction: self.$transaction, currencies: self.$currencies, accounts: self.$accounts, categories: $categories, modal: self.$isShowingNew, save: self.$save, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
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
                                            self.paymentSelected = monthlyPaymentData.map(payment: item)
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
                                                            
                                                            if(!item.isGoal) {
                                                                Text("")
                                                            } else {
                                                                Text("Goal deposit")
                                                                    .font(.system(size: 12))
                                                                    .fixedSize(horizontal: false, vertical: true)
                                                                    .frame(maxWidth: 50, alignment: .center)
                                                                    .multilineTextAlignment(.center)
                                                                    .padding(2)
                                                                    
                                                            }
                                                          

                                                            Text(item.symbol! + " " + String(format: "%.2f", abs(item.amount))).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                    .foregroundColor(colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor)
                                                    .font(.system(size: 15)) //, weight: .heavy
                                                    .frame(minWidth: 130, alignment: .trailing)


                                                    }
                                                        Spacer()
                                                     

                                                    }
                                            }
                                            .frame(maxWidth: .infinity)



                                            }

                                        }
                                        .sheet(isPresented: self.$isShowing, onDismiss: {

                                            if(self.delete == true) {
                                                monthlyPaymentData.deletePayment(payment: self.$paymentSelected.wrappedValue)
                                                getTotals()
                                            } else {
                                                if(settings.fastApply || self.save) {
                                                monthlyPaymentData.updatePayment(payment: self.$paymentSelected.wrappedValue)
                                                getTotals()
                                                }
                                            }



                                        }) {
                                            PaymentUpdateView(payment: self.$paymentSelected, transaction: self.$transaction, modal: self.$isShowing, save: self.$save, delete: self.$delete, currencies: self.$currencies, accounts: self.$accounts, categories: self.$categories, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
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
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            getTotals()
//        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//            getTotals()
//            }
      
        
    }
    
    func getTotals()
    {
        let fetchRequest: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
        self.totalPayments = 0
        
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
