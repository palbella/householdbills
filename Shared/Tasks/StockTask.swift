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
  
    @State var apiData = APIData()
    
    let request: NSFetchRequest<Stock> = Stock.fetchRequest()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
      
    }
    
    func run() {
        getPricing(notification: false)
    }
    
    
    func getPricing(notification: Bool) {
        
      
        do {
 
            let savedStocks = try  viewContext.fetch(request)

                            for index in 0..<savedStocks.count {
                                
                                getStockPrice(symbol: savedStocks[index].symbol!, stockId: savedStocks[index].id!, notification: notification)
                                
                        }
            
            
        } catch {
            print(error)
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
                    value = prices[properties[1]] as! String
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
            }
            } catch {
                
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
                    
                    total = total + (savedStocks[index].price * savedStocks[index].amount)
                    
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
        let url = api.api.replacingOccurrences(of: "$stock$", with: symbol)
        
           guard let url = URL(string: url) else {
               print("Invalid url...")
               return
           }
           URLSession.shared.dataTask(with: url) { data, response, error in

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
