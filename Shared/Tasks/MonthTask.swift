//
//  Service.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct MonthBalance {
    @State var viewContext: NSManagedObjectContext
    
    @ObservedObject var fetchAccounts = FetchAccounts()
    @State var accounts = GetAccounts()
    @ObservedObject var fetchPayments = FetchPayments()
    @State var payments = GetPayments()
    @ObservedObject var fetchBudgets = FetchBudgets()
    @State var budgets = GetBudgets()
    @ObservedObject var fetchGoals = FetchGoals()
    @State var goals = GetGoals()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
    }
    
    func run(totalBalance: Double, dayChangeMonth: Int32) {
        
        self.accounts.items = fetchAccounts.fetch(viewContext: viewContext)
        self.payments.items = fetchPayments.fetch(viewContext: viewContext)
        self.budgets.items = fetchBudgets.fetch(viewContext: viewContext)
        self.goals.items = fetchGoals.fetch(viewContext: viewContext)
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
                if(savedPayments[ii].name == savedMonthyPayments[i].name) {
                    exist = true
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
                if(savedBudgets[ii].name == savedMonthyBudgets[i].name) {
                    exist = true
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
            SaveContext()
            }
        }
        } catch {
            
        }
        
    }
 
    func calculateMonth (totalBalance: Double, dayChangeMonth: Int32) {
    
//            @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
//            var paymentsFetch: FetchedResults<Payment>
//            @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
//            var budgetsFetch: FetchedResults<Budget>
        
        let dateFormarter = DateFormatter()
        dateFormarter.dateFormat = "MMM y"
        
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
       

        do {
            var nextMonth: Date? = Date()
            
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
            if(Date().get(.day) > dayChangeMonth) {
                nextMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
            } else {
                nextMonth = Date()
            }
            
            
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            currentMonth.current = false
            currentMonth.finalAmount = totalBalance
            SaveContext()
            let newMonth = Month(context: viewContext)
            newMonth.current = true
            newMonth.id = UUID()
            newMonth.initialAmount = currentMonth.finalAmount
            newMonth.timestamp = nextMonth
            newMonth.month = Int32(Date().get(.month))
            newMonth.year = Int32(Date().get(.year))
            newMonth.name = dateFormarter.string(from: newMonth.timestamp!)
            
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
                SaveContext()
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


