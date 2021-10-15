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
    @State var delete: Bool = false
    
    @State var paymentSelected : PaymentModel = PaymentModel()
    @State var transaction : TransactionModel = TransactionModel()

    @State var currencies = GetCurrencies()
    @State var accounts = GetAccounts ()
    @State var categories = GetCategories()
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    @ObservedObject var fetchAccounts = FetchAccounts()
    @ObservedObject var fetchCategories = FetchCategories()
    
    @ObservedObject var payments = GetMontlyPayments()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var paymentsFetch: FetchedResults<MonthlyPayment>

    
    @Binding var totalPayments: Double
    
    func onAppear() {
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
                                        PaymentAddView(payment: self.$paymentSelected, transaction: self.$transaction, currencies: self.$currencies, accounts: self.$accounts, categories: $categories)
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
                
                let amount: Double = currencies.convert(currencyFrom: self.paymentsFetch[index].currency!, currencyTo: settings.currency, value: self.paymentsFetch[index].amount)

                self.totalPayments = self.totalPayments + amount
                    }
        } catch {
            print(error)
        }

    }
    
  
    
    func addPayment(payment: PaymentModel)
    {
      
            withAnimation {

                let newPayment = MonthlyPayment(context: viewContext)
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
                newPayment.category = payment.category
                newPayment.account = payment.account
                newPayment.notificationDay = payment.notificationDay
                newPayment.notificated = false

      SaveContext()
            }
        getTotals()
    }
    
    func updatePayment(payment: PaymentModel)
    {
       
          
        do {
                let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.id as CVarArg)
                
                let savedPayment = try  self.viewContext.fetch(request)[0]
           
            savedPayment.name = payment.name
        savedPayment.amount = payment.amount
        savedPayment.symbol = payment.symbol
        savedPayment.currency = payment.currency
        savedPayment.account = payment.account
        savedPayment.isPaid = payment.isPaid
            if(payment.isGoal == true && payment.goalId == nil) {
                savedPayment.isGoal = false
            } else {
                savedPayment.isGoal = payment.isGoal
            }
        savedPayment.goalId = payment.goalId
        savedPayment.iconColor = payment.iconColor
        savedPayment.iconContent = payment.iconContent
            savedPayment.category = payment.category
            savedPayment.notificated = false
            savedPayment.notificationDay = payment.notificationDay
            
        } catch {
            print(error)
        }

      SaveContext()
        getTotals()

    }
    
    func deletePayment(payment: PaymentModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
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
    
    func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
        print(error)
    }
    }
    
    func map(payment: MonthlyPayment) -> PaymentModel
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

        return paymentModel
    }
    

}
