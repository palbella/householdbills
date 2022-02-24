//
//  Stock.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct GetMarketStocks {
    @State var viewContext: NSManagedObjectContext
    @State var notification: Bool
    @State var apiData = APIData()
    
    @State var currencies = GetCurrencies()
    @State var fetchCurrencies = CurrencyData()
    
    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
    
    init(viewContext: NSManagedObjectContext, notification: Bool = false) {
        self.viewContext = viewContext
        if(notification == true) {
            self.notification = true
    } else {
            self.notification = false
        }
        self.currencies.items = fetchCurrencies.fetch()
    }
    
    func run() {
       
        getPricing(notification: self.notification)
    }
    
    
    func getPricing(notification: Bool) {
        
      
        do {
            let api = self.apiData.get()
            var stocks = ""
            let savedStocks = try  viewContext.fetch(request)

                            for index in 0..<savedStocks.count {
                                
                                if(api.type != "Yahoo!") {
                                    getStockPrice(symbol: savedStocks[index].symbol!, stockId: savedStocks[index].id!, notification: notification)
                                } else {
                                    if(stocks == "") {
                                        stocks = savedStocks[index].symbol!
                                    } else {
                                        stocks = stocks + "," + savedStocks[index].symbol!
                                    }
                                }
                        }
            
            if(api.type == "Yahoo!") {
                getStockYahooPrice(symbols: stocks, notification: notification)
            }
            
            
        } catch {
            print(error)
        }
        
  
    }
    
    func getStockYahooPrice(symbols: String, notification: Bool)
    {
        GetStockAPI().loadData (symbol: symbols) { [self]  (res) in
            
            do {
          
                let quote = res["quoteResponse"] as? [String: Any?]
                if(quote != nil) {
                 
                    let result = quote!["result"] as? [Any?]
                    if(result != nil) {
                        for index in 0..<result!.count {
                            let record = result![index] as AnyObject
                            
                            let symbol = record["symbol"] as? String
                            let name = record["shortName"] as? String
                            let price = record["regularMarketPrice"] as? Double
                            let exchange = record["exchange"] as? String
                            let dividend = record["trailingAnnualDividendYield"] as? Double
                            let dividendPercent = record["trailingAnnualDividendRate"] as? Double
                            let pe = record["trailingPE"] as? Double

                            
                            saveStockPriceSymbol(price: price ?? 0, symbol: symbol ?? "", name: name ?? "", exchange: exchange ?? "", dividend: dividend ?? 0, dividendPercent: dividendPercent ?? 0, pe: pe ?? 0, notification: notification)
                            
                        }
                    }
                }
                
           
               

//            var price: Double = 0
//
//                if let p = Double(value) {
//                    price = p
//                }
//

//            if(price > 0) {
//            saveStockPrice(price: price, stockId: stockId, notification: notification)
//            } else {
//                saveTotalAccounts ()
//            }
            }
                                               
           }
    }
    
    func getStockPrice(symbol: String, stockId: UUID, notification: Bool)
    {
       
        GetStockAPI().loadData (symbol: symbol) { [self]  (res) in
            
            do {
            let api = self.apiData.get()

            var properties = api.response.components(separatedBy: "][")
                for index in 0..<properties.count {
                    properties[index] = properties[index].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            }
                
                var value: String = ""
                
                if let prices = res[properties[0]] as? [String: Any?] {
                    value = prices[properties[1]] as? String ?? "0"
                } else {
                    if let price = res[properties[0]] as? String {
                        value = price
                    }
                    if let price = res[properties[0]] as? Double {
                        value = String(price)
                    }
                }
                
               

            var price: Double = 0
                
                if let p = Double(value) {
                    price = p
                }
               

            if(price > 0) {
            saveStockPrice(price: price, stockId: stockId, notification: notification)
            } else {
                saveTotalAccounts ()
            }
            }
                                               
           }

    }
    
    func saveStockPrice(price: Double, stockId: UUID, notification: Bool)
    {
                      
        do {
                                                let savedStocks = try  viewContext.fetch(request)
                                                                for index in 0..<savedStocks.count {
                                                                    if(savedStocks[index].id == stockId) {
                                                                        if(notification) {
                                                                            if(savedStocks[index].price > savedStocks[index].notificationPriceUp && !savedStocks[index].notificated) {
                                                                                NotificationTask().run(title: savedStocks[index].name! + " price alert!", subtitle: String(savedStocks[index].price))
                                                                            }
                                                                            if(savedStocks[index].price < savedStocks[index].notificationPriceDown && !savedStocks[index].notificated) {
                                                                                NotificationTask().run(title: savedStocks[index].name! + " price alert!", subtitle: String(savedStocks[index].price))
                                                                            }
                                                                            savedStocks[index].notificated = true
                                                                        }
                                                                        savedStocks[index].price = price
                                                                             SaveContext()
                                                                        
                                                                        saveTotalAccounts ()
                                                                    }
                                                                }
                                               
            
        } catch {
            print(error)
        }
        

    }
    
    func saveStockPriceSymbol(price: Double, symbol: String, name: String, exchange: String, dividend: Double, dividendPercent: Double, pe: Double, notification: Bool)
    {
                      
        do {
                                                let savedStocks = try  viewContext.fetch(request)
                                                                for index in 0..<savedStocks.count {
                                                                    if(savedStocks[index].symbol!.replacingOccurrences(of: " ", with: "") == symbol) {
                                                                        if(notification) {
                                                                            if(savedStocks[index].price > savedStocks[index].notificationPriceUp && !savedStocks[index].notificated) {
                                                                                NotificationTask().run(title: savedStocks[index].name! + " price alert!", subtitle: String(savedStocks[index].price))
                                                                            }
                                                                            if(savedStocks[index].price < savedStocks[index].notificationPriceDown && !savedStocks[index].notificated) {
                                                                                NotificationTask().run(title: savedStocks[index].name! + " price alert!", subtitle: String(savedStocks[index].price))
                                                                            }
                                                                            savedStocks[index].notificated = true
                                                                        }
                                                                        
                                                                       
                                                                        let arrName = name.components(separatedBy: " ")
                                                                        var shortName = arrName[0]
                                                                        for i in 1..<arrName.count {
                                                                            let count = shortName.count + arrName[i].count
                                                                            if(count < 20) {
                                                                                shortName = shortName + " " + arrName[i]
                                                                            }
                                                                        }
                                                                        
                                                                        savedStocks[index].price = price
                                                                        savedStocks[index].name = shortName
                                                                        savedStocks[index].exchange = exchange
                                                                        savedStocks[index].pe = pe
                                                                        savedStocks[index].dividend = dividend
                                                                        savedStocks[index].dividendPercent = dividendPercent
                                                                        
                                                                             SaveContext()
                                                                        
                                                                        saveTotalAccounts ()
                                                                    }
                                                                }
                                               
            
        } catch {
            print(error)
        }
        

    }

    
    
 
    func saveTotalAccounts () {
        
        let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
        let stockRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do {
 
            let savedAccounts = try  viewContext.fetch(accountRequest)
           
            
            for i in 0..<savedAccounts.count {
                if(savedAccounts[i].type == "stock") {
                var total: Double = 0
                
                    stockRequest.predicate = NSPredicate(format: "accountId = %@", savedAccounts[i].id! as CVarArg)
                let savedStocks = try  viewContext.fetch(stockRequest)
                
                for index in 0..<savedStocks.count {
                    
                    let amount: Double = currencies.convert(currencyFrom: "USD", currencyTo: savedAccounts[i].currency!, value: (savedStocks[index].price * savedStocks[index].amount))
                    total = total + amount
                    
            }
                savedAccounts[i].amount = total
                SaveContext()
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


class GetStockAPI: ObservableObject {
    
    var apiData = APIData()
    
    func loadData(symbol: String, completion:@escaping ([String: Any?]) -> ()) {
        let api = self.apiData.get()
        let url = api.api.replacingOccurrences(of: "$stock$", with: symbol).replacingOccurrences(of: " ", with: "")
        let token = api.request
        print(url)
           guard let url = URL(string: url) else {
               print("Invalid url...")
               return
           }
        var request = URLRequest(url: url)
                request.httpMethod = "GET"
        
        if(api.type == "Yahoo!") {
                request.setValue("\(token)", forHTTPHeaderField: "x-api-key")
        }
        
           URLSession.shared.dataTask(with: request) { data, response, error in

//                        let str = String(data: data!, encoding: .utf8)
//                        print(str as Any)
            
            
            var stock : [String: Any]?
            do{
                if(data != nil) {
                    stock = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                }
            }catch {
                stock = [:]
            }
            
               DispatchQueue.main.async {
                completion(stock ?? [:])
               }
           }.resume()
           
       }
}

