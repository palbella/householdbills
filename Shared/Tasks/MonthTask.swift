//
//  Service.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct MonthBalance {
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    @ObservedObject var fetchAccounts = AccountData()
    @State var accounts = GetAccounts()
    @ObservedObject var paymentData = PaymentData()
    @State var payments = GetPayments()
    @ObservedObject var budgetData = BudgetData()
    @State var budgets = GetBudgets()
    @ObservedObject var fetchGoals = GoalData()
    @State var goals = GetGoals()
    @ObservedObject var fetchPurchases = PurchaseData()
    @State var purchases = GetPurchases()
    
    
    func run(totalBalance: Double, dayChangeMonth: Int32) {
        
        self.accounts.items = fetchAccounts.fetch()
        self.payments.items = paymentData.fetch()
        self.budgets.items = budgetData.fetch()
        self.goals.items = fetchGoals.fetch()
        self.purchases.items = fetchPurchases.fetch()
        calculateMonth (totalBalance: totalBalance, dayChangeMonth: dayChangeMonth)
    }
    
    func syncMonth () {
        
        do {
        let monthlyPaymentRequest: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
        let savedMonthyPayments = try  viewContext.fetch(monthlyPaymentRequest)
            let paymentRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
            let savedPayments = try  viewContext.fetch(paymentRequest)
        
        
            
        for i in 0..<savedMonthyPayments.count {
            
            var exist = false
            
            for ii in 0..<savedPayments.count {
                if(savedPayments[ii].monthlyId == savedMonthyPayments[i].id) {
                    exist = true
                    
                    if(savedMonthyPayments[i].isPaid != true) {
                        savedPayments[ii].name = savedMonthyPayments[i].name
                        savedPayments[ii].amount = savedMonthyPayments[i].amount
                        savedPayments[ii].symbol = savedMonthyPayments[i].symbol
                        savedPayments[ii].currency = savedMonthyPayments[i].currency
                        savedPayments[ii].isGoal = savedMonthyPayments[i].isGoal
                        savedPayments[ii].goalId = savedMonthyPayments[i].goalId
                    }
                   
                    savedPayments[ii].iconColor = savedMonthyPayments[i].iconColor
                    savedPayments[ii].iconContent = savedMonthyPayments[i].iconContent
                    savedPayments[ii].notificated = false
                    savedPayments[ii].notificationDay = savedMonthyPayments[i].notificationDay
                    savedPayments[ii].order = savedMonthyPayments[i].order
                    savedPayments[ii].priority = savedMonthyPayments[i].priority
                    savedPayments[ii].account = savedMonthyPayments[i].account
                    
                    SaveContext()
                }
            }
            
            if(!exist) {
            let newPayment = Payment(context: viewContext)

            newPayment.id = UUID()
            newPayment.name = savedMonthyPayments[i].name
            newPayment.amount = savedMonthyPayments[i].amount
            newPayment.symbol = savedMonthyPayments[i].symbol
            newPayment.currency = savedMonthyPayments[i].currency
            newPayment.isGoal = savedMonthyPayments[i].isGoal
            newPayment.isPaid = savedMonthyPayments[i].isPaid
            newPayment.goalId = savedMonthyPayments[i].goalId
            newPayment.iconColor = savedMonthyPayments[i].iconColor
            newPayment.iconContent = savedMonthyPayments[i].iconContent
                newPayment.notificated = false
                newPayment.notificationDay = savedMonthyPayments[i].notificationDay
                newPayment.order = savedMonthyPayments[i].order
                newPayment.priority = savedMonthyPayments[i].priority
                newPayment.account = savedMonthyPayments[i].account
                newPayment.monthlyId = savedMonthyPayments[i].id
                
            SaveContext()
            }
        }

        let monthlyBudgetRequest: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
        let savedMonthyBudgets = try  viewContext.fetch(monthlyBudgetRequest)
            let budgetRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
            let savedBudgets = try  viewContext.fetch(budgetRequest)

        for i in 0..<savedMonthyBudgets.count {
            
            var exist = false
            
            for ii in 0..<savedBudgets.count {
                if(savedBudgets[ii].monthlyId == savedMonthyBudgets[i].id) {
                    exist = true
                    
                    savedBudgets[ii].name = savedMonthyBudgets[i].name
                    savedBudgets[ii].amount = savedMonthyBudgets[i].amount
                    savedBudgets[ii].symbol = savedMonthyBudgets[i].symbol
                    savedBudgets[ii].currency = savedMonthyBudgets[i].currency
                    savedBudgets[ii].iconColor = savedMonthyBudgets[i].iconColor
                    savedBudgets[ii].iconContent = savedMonthyBudgets[i].iconContent
                    savedBudgets[ii].order = savedMonthyBudgets[i].order
                    savedBudgets[ii].priority = savedMonthyBudgets[i].priority
                    SaveContext()
                }
            }
            
            if(!exist) {
            let newBudget = Budget(context: viewContext)
           

            newBudget.id = UUID()
            newBudget.name = savedMonthyBudgets[i].name
            newBudget.amount = savedMonthyBudgets[i].amount
            newBudget.symbol = savedMonthyBudgets[i].symbol
            newBudget.currency = savedMonthyBudgets[i].currency
            newBudget.iconColor = savedMonthyBudgets[i].iconColor
            newBudget.iconContent = savedMonthyBudgets[i].iconContent
                newBudget.order = savedMonthyBudgets[i].order
                newBudget.priority = savedMonthyBudgets[i].priority
                newBudget.monthlyId = savedMonthyBudgets[i].id
            SaveContext()
            }
        }
      
        
        let monthlyPurchaseRequest: NSFetchRequest<MonthlyPurchase> = MonthlyPurchase.fetchRequest()
        let savedMonthyPurchases = try  viewContext.fetch(monthlyPurchaseRequest)
            let purchaseRequest: NSFetchRequest<Purchase> = Purchase.fetchRequest()
            let savedPurchases = try  viewContext.fetch(purchaseRequest)
           

        for i in 0..<savedMonthyPurchases.count {
            
            var exist = false
            
            for ii in 0..<savedPurchases.count {
                if(savedPurchases[ii].monthlyId == savedMonthyPurchases[i].id) {
                    exist = true
                    
                    savedPurchases[ii].name = savedMonthyPurchases[i].name
                    savedPurchases[ii].amount = savedMonthyPurchases[i].amount
                    savedPurchases[ii].symbol = savedMonthyPurchases[i].symbol
                    savedPurchases[ii].currency = savedMonthyPurchases[i].currency
                    savedPurchases[ii].iconColor = savedMonthyPurchases[i].iconColor
                    savedPurchases[ii].iconContent = savedMonthyPurchases[i].iconContent
                
                    SaveContext()
                    syncPurchaseItem(id:  savedPurchases[ii].id!, monthlyId: savedMonthyPurchases[i].id!)
                }
            }
            
            if(!exist) {
            let newPurchase = Purchase(context: viewContext)
           

                newPurchase.id = UUID()
                newPurchase.name = savedMonthyPurchases[i].name
                newPurchase.amount = savedMonthyPurchases[i].amount
                newPurchase.symbol = savedMonthyPurchases[i].symbol
                newPurchase.currency = savedMonthyPurchases[i].currency
                newPurchase.iconColor = savedMonthyPurchases[i].iconColor
                newPurchase.iconContent = savedMonthyPurchases[i].iconContent
                newPurchase.monthlyId = savedMonthyPurchases[i].id
             
            SaveContext()
                syncPurchaseItem(id: newPurchase.id!, monthlyId: savedMonthyPurchases[i].id!)
            }
        }
        }
     catch {
        
    }
    }
    
    func syncPurchaseItem(id: UUID, monthlyId: UUID) {
        do {
        let monthlyPurchaseItemRequest: NSFetchRequest<MonthlyPurchaseItem> = MonthlyPurchaseItem.fetchRequest()
        let savedMonthyPurchaseItems = try  viewContext.fetch(monthlyPurchaseItemRequest)
            let purchaseItemRequest: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
            let savedPurchaseItems = try  viewContext.fetch(purchaseItemRequest)
            
            for i in 0..<savedMonthyPurchaseItems.count {
                
                if(savedMonthyPurchaseItems[i].purchaseId == monthlyId)
                {
                var exist = false
                
                for ii in 0..<savedPurchaseItems.count {
                    if(savedPurchaseItems[ii].monthlyId == savedMonthyPurchaseItems[i].id) {
                        exist = true
                        
                        savedPurchaseItems[ii].name = savedMonthyPurchaseItems[i].name
                        savedPurchaseItems[ii].amount = savedMonthyPurchaseItems[i].amount
                        savedPurchaseItems[ii].price = savedMonthyPurchaseItems[i].price
                        savedPurchaseItems[ii].unit = savedMonthyPurchaseItems[i].unit
                  
                    
                        SaveContext()
                       
                    }
                }
                
                if(!exist) {
                let newPurchaseItem = PurchaseItem(context: viewContext)
               

                    newPurchaseItem.id = UUID()
                    newPurchaseItem.name = savedMonthyPurchaseItems[i].name
                    newPurchaseItem.amount = savedMonthyPurchaseItems[i].amount
                    newPurchaseItem.price = savedMonthyPurchaseItems[i].price
                    newPurchaseItem.unit = savedMonthyPurchaseItems[i].unit
                    newPurchaseItem.monthlyId = savedMonthyPurchaseItems[i].id
                    newPurchaseItem.purchaseId = id
                 
                 
                SaveContext()
                  
                }
                }
            }
        
        } catch {
            
        }
    }
 
    
    func createMonth (totalBalance: Double, dayChangeMonth: Int32) {
        
        let dateFormarter = DateFormatter()
        dateFormarter.dateFormat = "MMM y"
        
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
        
        do {
            var nextMonth: Date? = Date()
            
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
            if(Date().get(.day) >= dayChangeMonth) {
                nextMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
            } else {
                nextMonth = Date()
            }
            
            
            var language = Locale.current.languageCode
            if(language == nil || language == "") {
                language = "en"
            }
            if(language == "zh") {
                if(Locale.current.scriptCode != nil) {
                    language = "zh-" + Locale.current.scriptCode!
                } else {
                    language = "zh-Hans"
                }
                
            }
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var dateComponentsRate = DateComponents()
            dateComponentsRate.year = Int(nextMonth!.get(.year))
            dateComponentsRate.month = Int(nextMonth!.get(.month))
            let calendar = Calendar.current
            let dateRange = calendar.date(from: dateComponentsRate)!

            let range = calendar.range(of: .day, in: .month, for: dateRange)!
            let numDays = range.count
            
            var startDate:Date = dateFormatter.date(from: String(nextMonth!.get(.year)) + "-" + String(nextMonth!.get(.month)) + "-1")! as Date
            var endDate:Date = dateFormatter.date(from: String(nextMonth!.get(.year)) + "-" + String(nextMonth!.get(.month)) + "-" + String(numDays))! as Date
            startDate = Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!
            endDate = Calendar.current.date(byAdding: .hour, value: 1, to: endDate)!
            
            
            var cal = Calendar.current
            cal.locale = Locale(identifier: language!)
            
            
            let translatedMonth = cal.shortMonthSymbols[nextMonth!.get(.month) - 1].uppercasingFirst
            
            let currentMonths = try viewContext.fetch(monthRequest)
            var initialAmount:Double = 0
            
            if(currentMonths.count > 0) {
                let currentMonth = try viewContext.fetch(monthRequest)[0]
                currentMonth.current = false
                currentMonth.finalAmount = totalBalance
                initialAmount = currentMonth.finalAmount
                SaveContext()
            }
            
            let newMonth = Month(context: viewContext)
            newMonth.current = true
            newMonth.id = UUID()
            newMonth.initialAmount = initialAmount
            newMonth.timestamp = nextMonth
            newMonth.month = Int32(nextMonth!.get(.month))
            newMonth.year = Int32(nextMonth!.get(.year))
            newMonth.name = translatedMonth + " " + String(nextMonth!.get(.year)) //dateFormarter.string(from: newMonth.timestamp!)
            newMonth.startDate = startDate
            newMonth.endDate = endDate
            
            SaveContext()
        } catch {
            
        }
        
    }
    
    func calculateMonth (totalBalance: Double, dayChangeMonth: Int32) {
    
        createMonth(totalBalance: totalBalance, dayChangeMonth: dayChangeMonth)
        
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
       

        do {
           
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            
            for i in 0..<self.accounts.items.count {
                let newAccountHistory = HistoryAccount(context: viewContext)
                newAccountHistory.id = UUID()
                newAccountHistory.month = currentMonth.id
                newAccountHistory.name = self.accounts.items[i].name
                newAccountHistory.amount = self.accounts.items[i].amount
                newAccountHistory.symbol = self.accounts.items[i].symbol
                SaveContext()
            }
            for i in 0..<self.payments.items.count {
                let newPaymentHistory = HistoryPayment(context: viewContext)
                newPaymentHistory.id = UUID()
                newPaymentHistory.month = currentMonth.id
                newPaymentHistory.name = self.payments.items[i].name
                newPaymentHistory.amount = self.payments.items[i].amount
                newPaymentHistory.symbol = self.payments.items[i].symbol
                SaveContext()
            }
            for i in 0..<self.budgets.items.count {
                let newBudgetHistory = HistoryBudget(context: viewContext)
                newBudgetHistory.id = UUID()
                newBudgetHistory.month = currentMonth.id
                newBudgetHistory.name = self.budgets.items[i].name
                newBudgetHistory.amount = self.budgets.items[i].amount
                newBudgetHistory.symbol = self.budgets.items[i].symbol
                SaveContext()
            }
            for i in 0..<self.purchases.items.count {
                let newPurchaseHistory = HistoryPurchase(context: viewContext)
                newPurchaseHistory.id = UUID()
                newPurchaseHistory.month = currentMonth.id
                newPurchaseHistory.name = self.purchases.items[i].name
                newPurchaseHistory.amount = self.purchases.items[i].amount
                newPurchaseHistory.symbol = self.purchases.items[i].symbol
                SaveContext()
            }
            for i in 0..<self.goals.items.count {
                let newGoalHistory = HistoryGoal(context: viewContext)
                newGoalHistory.id = UUID()
                newGoalHistory.month = currentMonth.id
                newGoalHistory.name = self.goals.items[i].name
                newGoalHistory.amount = self.goals.items[i].amount
                newGoalHistory.symbol = self.goals.items[i].symbol
                SaveContext()
            }
            
            let paymentRequest: NSFetchRequest<Payment> = Payment.fetchRequest()
            let savedPayments = try  viewContext.fetch(paymentRequest)
            
            for i in 0..<savedPayments.count {
                self.viewContext.delete(savedPayments[i])
            }
            
            let budgetRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
            let savedBudgets = try  viewContext.fetch(budgetRequest)
            
            for i in 0..<savedBudgets.count {
                self.viewContext.delete(savedBudgets[i])
            }
            
            let purchaseRequest: NSFetchRequest<Purchase> = Purchase.fetchRequest()
            let savedPurchases = try  viewContext.fetch(purchaseRequest)
            
            for i in 0..<savedPurchases.count {
                self.viewContext.delete(savedPurchases[i])
            }

            
            let monthlyPaymentRequest: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
            let savedMonthyPayments = try  viewContext.fetch(monthlyPaymentRequest)
            
            for i in 0..<savedMonthyPayments.count {
                let newPayment = Payment(context: viewContext)

                newPayment.id = UUID()
                newPayment.name = savedMonthyPayments[i].name
                newPayment.amount = savedMonthyPayments[i].amount
                newPayment.symbol = savedMonthyPayments[i].symbol
                newPayment.currency = savedMonthyPayments[i].currency
                newPayment.isGoal = savedMonthyPayments[i].isGoal
                newPayment.isPaid = savedMonthyPayments[i].isPaid
                newPayment.goalId = savedMonthyPayments[i].goalId
                newPayment.iconColor = savedMonthyPayments[i].iconColor
                newPayment.iconContent = savedMonthyPayments[i].iconContent
                newPayment.notificated = false
                newPayment.notificationDay = savedMonthyPayments[i].notificationDay
                newPayment.order = savedMonthyPayments[i].order
                newPayment.priority = savedMonthyPayments[i].priority
                newPayment.account = savedMonthyPayments[i].account
                newPayment.monthlyId = savedMonthyPayments[i].id
                SaveContext()
            }

            let monthlyBudgetRequest: NSFetchRequest<MonthlyBudget> = MonthlyBudget.fetchRequest()
            let savedMonthyBudgets = try  viewContext.fetch(monthlyBudgetRequest)

            for i in 0..<savedMonthyBudgets.count {
                let newBudget = Budget(context: viewContext)
               

                newBudget.id = UUID()
                newBudget.name = savedMonthyBudgets[i].name
                newBudget.amount = savedMonthyBudgets[i].amount
                newBudget.symbol = savedMonthyBudgets[i].symbol
                newBudget.currency = savedMonthyBudgets[i].currency
                newBudget.iconColor = savedMonthyBudgets[i].iconColor
                newBudget.iconContent = savedMonthyBudgets[i].iconContent
                newBudget.order = savedMonthyBudgets[i].order
                newBudget.priority = savedMonthyBudgets[i].priority
                newBudget.monthlyId = savedMonthyBudgets[i].id
                SaveContext()
            }
            
            let monthlyPurchaseRequest: NSFetchRequest<MonthlyPurchase> = MonthlyPurchase.fetchRequest()
            let savedMonthyPurchases = try  viewContext.fetch(monthlyPurchaseRequest)
            let monthlyPurchaseItemRequest: NSFetchRequest<MonthlyPurchaseItem> = MonthlyPurchaseItem.fetchRequest()
            let savedMonthyPurchaseItems = try  viewContext.fetch(monthlyPurchaseItemRequest)
            

            for i in 0..<savedMonthyPurchases.count {
                let newPurchase = Purchase(context: viewContext)
               

                newPurchase.id = UUID()
                newPurchase.name = savedMonthyPurchases[i].name
                newPurchase.amount = savedMonthyPurchases[i].amount
                newPurchase.symbol = savedMonthyPurchases[i].symbol
                newPurchase.currency = savedMonthyPurchases[i].currency
                newPurchase.iconColor = savedMonthyPurchases[i].iconColor
                newPurchase.iconContent = savedMonthyPurchases[i].iconContent
                newPurchase.monthlyId = savedMonthyPurchases[i].id
               
                SaveContext()
                
                for ii in 0..<savedMonthyPurchaseItems.count {
                    
                    if(savedMonthyPurchaseItems[ii].purchaseId == savedMonthyPurchases[i].id) {
                        let newPurchaseItem = PurchaseItem(context: viewContext)
                        
                        newPurchaseItem.id = UUID()
                        newPurchaseItem.name = savedMonthyPurchaseItems[ii].name
                        newPurchaseItem.amount = savedMonthyPurchaseItems[ii].amount
                        newPurchaseItem.price = savedMonthyPurchaseItems[ii].price
                        newPurchaseItem.unit = savedMonthyPurchaseItems[ii].unit
                        newPurchaseItem.purchaseId = newPurchase.id
                        newPurchaseItem.monthlyId = savedMonthyPurchaseItems[ii].id
                    }
                }
                
                
            }
            
        } catch {
            print(error)
        }
        
    }
    
    
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
}


