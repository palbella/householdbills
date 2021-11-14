//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class TransactionData: ObservableObject {
    
    @Published var transactions = GetTransactions()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    @ObservedObject var fetchCurrencies = CurrencyData()

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var transactionsFetch: FetchedResults<Transaction>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var monthsFetch: FetchedResults<Month>

    let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()

    
    init() {
    }

    func fetchIncomes() -> Double{
        var total: Double = 0
        
        do {
            let results : NSArray = try viewContext.fetch(currentMonthTransactionsFetch()) as NSArray

                            for index in 0..<results.count {
                         
                                let transaction = map(transaction: results[index] as! Transaction)
                                
                                if (transaction.amount >= 0) {
                                    total = total + transaction.amount
                                }
                                
                       }
        } catch {

        }
        return total
    }
    
    func fetchExpenses() -> Double{
        var total: Double = 0
        do {
            let results : NSArray = try viewContext.fetch(currentMonthTransactionsFetch()) as NSArray

                            for index in 0..<results.count {
                                
                                let transaction = map(transaction: results[index] as! Transaction)
                         
                                if (transaction.amount < 0) {
                                    total = total + transaction.amount
                                }
                                
                       }
        } catch {

        }
        return total
    }
    
    func currentMonthTransactionsFetch() -> NSFetchRequest<Transaction> {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentMonth: String = String(Date().get(.month))
        let currentYear: String = String(Date().get(.year))
        let startDate:NSDate = dateFormatter.date(from: currentYear + "-" + currentMonth + "-1")! as NSDate
        let endDate:NSDate = dateFormatter.date(from: currentYear + "-" + currentMonth + "-30")! as NSDate


            let predicate1 = NSPredicate(format: "%@ <= timestamp AND %@ >= timestamp", argumentArray: [startDate, endDate])

        let predicate = NSCompoundPredicate(type: .or, subpredicates: [predicate1])
            // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        return fetchRequest
    }
    
    func fetch(filters: TransactionFiltersModel) -> GetTransactions{

        do {
        let fetchMonthRequest: NSFetchRequest<Month> = Month.fetchRequest()
            fetchMonthRequest.predicate = NSPredicate(format: "%@ <= startDate AND %@ >= startDate", argumentArray: [filters.startDate, filters.endDate])
            fetchMonthRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Month.startDate, ascending: false)
            ]
        let months : NSArray = try viewContext.fetch(fetchMonthRequest) as NSArray
            
            self.transactions.months = [MonthModel]()
                            for index in 0..<months.count {
                                self.transactions.months.append(mapMonth(month: months[index] as! Month))
                                    }
            
        } catch {
            
        }

        for monthIndex in 0..<self.transactions.months.count {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()

        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"


            var dateComponentsRate = DateComponents()
            dateComponentsRate.year = Int(self.transactions.months[monthIndex].year)
            dateComponentsRate.month = Int(self.transactions.months[monthIndex].month)
            let calendar = Calendar.current
            let dateRange = calendar.date(from: dateComponentsRate)!

            let range = calendar.range(of: .day, in: .month, for: dateRange)!
            let numDays = range.count
            
            let startDate:NSDate = dateFormatter.date(from: String(self.transactions.months[monthIndex].year) + "-" + String(self.transactions.months[monthIndex].month) + "-1")! as NSDate
            var endDate:NSDate = dateFormatter.date(from: String(self.transactions.months[monthIndex].year) + "-" + String(self.transactions.months[monthIndex].month) + "-" + String(numDays))! as NSDate
            
            var dateComponent = DateComponents()
            dateComponent.day = 1
            
           
            endDate = Calendar.current.date(byAdding: dateComponent, to: endDate as Date)!  as NSDate
            endDate = removeTimeStamp(fromDate: endDate as Date) as NSDate
            
            var filtersEndDate = filters.endDate.addingTimeInterval(86400)
            filtersEndDate = removeTimeStamp(fromDate: filtersEndDate)

            var query = "%@ <= timestamp AND %@ >= timestamp AND %@ <= timestamp AND %@ >= timestamp"
            
            if(filters.account != "") {
                query = query + " AND account CONTAINS[c] %@ "
            } else {
                query = query + " AND %@ == '' "
            }
            if(filters.name != "") {
                query = query + " AND name CONTAINS[c] %@ "
            } else {
                query = query + " AND %@ == '' "
            }
            if(filters.category != 99) {
                query = query + " AND category == " + String(filters.category)
            }
            

            let predicate1 = NSPredicate(format: query, argumentArray: [startDate, endDate, filters.startDate, filtersEndDate, filters.account, filters.name])

        let predicate = NSCompoundPredicate(type: .or, subpredicates: [predicate1])
            // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]


        do {
            let results : NSArray = try viewContext.fetch(fetchRequest) as NSArray

            self.transactions.months[monthIndex].items = [TransactionModel]()
                            for index in 0..<results.count {
                                self.transactions.months[monthIndex].items.append(map(transaction: results[index] as! Transaction))
                                    }
        } catch {

        }
        }

        return self.transactions

    }
    
    func getMonth(date: Date) -> Month? {
        
        var month : Month? = nil
        
        do {
        let fetchMonthRequest: NSFetchRequest<Month> = Month.fetchRequest()
            fetchMonthRequest.predicate = NSPredicate(format: "%@ == month AND %@ == year", argumentArray: [Int32(date.get(.month)), Int32(date.get(.year))])
        let months : NSArray = try viewContext.fetch(fetchMonthRequest) as NSArray
            
            month = months[0] as? Month
           
        } catch {
            
        }
        
        return month
    }
    
    
    func addTransactions(transaction: TransactionModel) {
        
        if(transaction.amount == 0) {
            return
        }
        
        
        
        let newTransaction = Transaction(context: viewContext)
//        let id = findNextId(in: self.transactionsFetch)
        
        newTransaction.id = UUID()
        newTransaction.name = transaction.name
        newTransaction.account = transaction.account
        newTransaction.amount = transaction.amount
        newTransaction.symbol = transaction.symbol
        newTransaction.currency = transaction.currency
        newTransaction.iconColor = transaction.iconColor
        newTransaction.iconContent = transaction.iconContent
        newTransaction.category = transaction.category
        newTransaction.month = getMonth(date: Date()) != nil ? getMonth(date: Date())!.id : nil
        newTransaction.timestamp = Date()
        

        SaveContext()
        
        if(transaction.type == LocalizedStringKey("Expense").toString() && transaction.budget != nil) {
            budgetTransaction(destination: transaction.budget!, amount: transaction.amount, currencyFrom: transaction.currency)
        }
    }

    func map(transaction: Transaction) -> TransactionModel
    {
        var transactionModel = TransactionModel()

        transactionModel.id = transaction.id!
        transactionModel.timestamp = transaction.timestamp
        transactionModel.name = transaction.name ?? ""
        transactionModel.account = transaction.account ?? ""
        transactionModel.symbol = transaction.symbol ?? ""
        transactionModel.currency = transaction.currency ?? ""
        transactionModel.amount = transaction.amount
        transactionModel.iconColor = transaction.iconColor ?? ""
        transactionModel.iconContent = transaction.iconContent ?? ""
        transactionModel.category = transaction.category

        return transactionModel
    }
    
    func mapMonth(month: Month) -> MonthModel
    {
        var monthModel = MonthModel()

        monthModel.id = month.id!
        monthModel.timestamp = month.timestamp!
        monthModel.name = month.name ?? ""
        monthModel.initialAmount = month.initialAmount
        monthModel.finalAmount = month.finalAmount
        monthModel.month = month.month
        monthModel.year = month.year

        return monthModel
    }
    
    func budgetTransaction(destination: UUID, amount: Double, currencyFrom: String)
    {
        let currencies = GetCurrencies()
        currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
       
        do {
                let request: NSFetchRequest<Budget> = Budget.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", destination as CVarArg)
                
                let savedBudget = try  self.viewContext.fetch(request)[0]
            
            let amountConverted: Double = currencies.convert(currencyFrom: currencyFrom, currencyTo: savedBudget.currency!, value: abs(amount))
                
            savedBudget.amount = savedBudget.amount - amountConverted
            
            
            
        } catch {
            print(error)
        }

      SaveContext()
  

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    
//    private func findNextId(in array: FetchedResults<Transaction>) -> Int
//    {
//        var result = 0
//        for (_, value) in array.enumerated()
//        {
//            if value.id > result {
//                result = Int(value.id)
//            }
//        }
//
//        return result + 1
//    }


}
