//
//  StockData.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/23/21.
//

import SwiftUI
import CoreData

class StockData: ObservableObject {
    @Published var items = [StockModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
  
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [StockModel]{
        
        do {
            let savedRecords = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedRecords.count {
                self.items.append(map(stock: savedRecords[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    
    func addStock(stock: StockModel)
    {
      
            withAnimation {
              
                let newStock = Stock(context: viewContext)
                newStock.id = UUID()
                newStock.accountId = stock.accountId
                newStock.name = stock.name
                newStock.amount = stock.amount
                newStock.symbol = stock.symbol
                newStock.avgPurchase = stock.avgPurchase
                newStock.price = stock.price
                newStock.notificated = false
                newStock.notificationPriceUp = stock.notificationPriceUp
                newStock.notificationPriceDown = stock.notificationPriceDown

      SaveContext()
            }
        GetMarketStocks(viewContext: viewContext).run()


    }
    
    
     func updateStock(stock: StockModel)
    {
      
          
        do {
                let request: NSFetchRequest<Stock> = Stock.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", stock.id as CVarArg)
                
                let savedStock = try  self.viewContext.fetch(request)[0]
                
            savedStock.name = stock.name
            savedStock.accountId = stock.accountId
            savedStock.amount = stock.amount
            savedStock.symbol = stock.symbol
            savedStock.amount = stock.amount
            savedStock.avgPurchase = stock.avgPurchase
            savedStock.price = stock.price
            savedStock.notificated = false
            savedStock.notificationPriceUp = stock.notificationPriceUp
            savedStock.notificationPriceDown = stock.notificationPriceDown
            
            
        } catch {
            print(error)
        }

      SaveContext()
        GetMarketStocks(viewContext: viewContext).run()


    }
    
     func deleteStock(stock: StockModel)
    {
            withAnimation {
                
                let request: NSFetchRequest<Stock> = Stock.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", stock.id as CVarArg)

                    do {
                        let savedStocks = try  self.viewContext.fetch(request)
                        
                        for stock in savedStocks {
                            self.viewContext.delete(stock)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
SaveContext()
        GetMarketStocks(viewContext: viewContext).run()

       
    }
    
    
    func map(stock: Stock) -> StockModel
    {
        var stockModel = StockModel()
        
        stockModel.id = stock.id!
        stockModel.name = stock.name ?? ""
        stockModel.symbol = stock.symbol ?? ""
        stockModel.amount = stock.amount
        stockModel.accountId = stock.accountId!
        stockModel.avgPurchase = stock.avgPurchase
        stockModel.price = stock.price
        stockModel.notificated = stock.notificated
        stockModel.notificationPriceUp = stock.notificationPriceUp
        stockModel.notificationPriceDown = stock.notificationPriceDown
        stockModel.exchange = stock.exchange!
        stockModel.dividend = stock.dividend
        stockModel.dividendPercent = stock.dividendPercent

        return stockModel
    }
    
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func stringToEntityMap(stock: StockModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = stock.id.uuidString
        fields.field2 = stock.name
        fields.field3 = stock.symbol
        fields.field4 = String(stock.amount)
        fields.field5 = stock.accountId.uuidString
        fields.field6 = String(stock.avgPurchase)
        fields.field7 = String(stock.price)
        fields.field8 = String(stock.notificated)
        fields.field9 = String(stock.notificationPriceUp)
        fields.field10 = String(stock.notificationPriceDown)
        

        return fields
    }
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedStock = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateDouble(value: array[3].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[5].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[6].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[8].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[9].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateBoolean(value: array[7].trimmingCharacters(in: .whitespacesAndNewlines))
                
                if(savedStock.count < 1 && validator) {
                    
                    let newStock = Stock(context: viewContext)
                    newStock.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newStock.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newStock.symbol = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    newStock.amount = Double(array[3].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newStock.accountId = UUID(uuidString: array[4].trimmingCharacters(in: .whitespacesAndNewlines))
                    newStock.avgPurchase = Double(array[5].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newStock.price = Double(array[6].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newStock.notificated = (array[7].trimmingCharacters(in: .whitespacesAndNewlines) as NSString).boolValue
                    newStock.notificationPriceUp = Double(array[8].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newStock.notificationPriceDown = Double(array[9].trimmingCharacters(in: .whitespacesAndNewlines))!

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}

