//
//  Crypto.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData



struct GetMarketCriptocurrencies {
    @State var viewContext: NSManagedObjectContext
    @State var notification: Bool
    
    let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
    
    init(viewContext: NSManagedObjectContext, notification: Bool = false) {
        self.viewContext = viewContext
        if(notification == true) {
            self.notification = true
        } else {
            self.notification = false
        }
    }
    
    func run() {
     
        GetBinanceCriptocurrencies().loadData { [self] (binanceList) in

            GetCoingeckoCriptocurrencies().loadData { [self] (coingeckoList) in
                
                binancePricing(binanceList: binanceList, coingeckoList: coingeckoList, notification: self.notification)
            }
        }
    }
    
    func binancePricing(binanceList:  [CryptocurrencyBinanceModel], coingeckoList: [CryptocurrencyCoingeckoModel], notification: Bool) {
        
        
        do {
 
            let savedCryptos = try  viewContext.fetch(request)

                            for index in 0..<savedCryptos.count {
                                
                                let price = getBinanceCryptoPrice(binanceList: binanceList, symbol: savedCryptos[index].symbol!)
                               
                                if(price > 0) {
                                    if(notification) {
                                       
                                        if(savedCryptos[index].notificationPriceUp != 0 && savedCryptos[index].price > savedCryptos[index].notificationPriceUp && !savedCryptos[index].notificated) {
                                            NotificationTask().run(title: savedCryptos[index].name! + " price alert!", subtitle: String(savedCryptos[index].price))
                                        }
                                        if(savedCryptos[index].notificationPriceDown != 0 && savedCryptos[index].price < savedCryptos[index].notificationPriceDown && !savedCryptos[index].notificated) {
                                            NotificationTask().run(title: savedCryptos[index].name! + " price alert!", subtitle: String(savedCryptos[index].price))
                                        }
                                        savedCryptos[index].notificated = true
                                    }
                                   
                                    savedCryptos[index].price = Double(price)
                                    SaveContext()
                                    
                                    saveTotalAccounts ()
                                }else {
                                    getCoingeckoPrice(coingeckoList: coingeckoList, symbol: savedCryptos[index].symbol!, cryptoId: savedCryptos[index].id!, notification: notification)
                                }
                                
                        }
            
            
        } catch {
            print(error)
        }
        
  
    }
    
    
    func getCoingeckoPrice(coingeckoList: [CryptocurrencyCoingeckoModel], symbol: String, cryptoId: UUID, notification: Bool)
    {
      
     
                                            let coingeckoId = getCoingeckoCryptoId(coingeckoList: coingeckoList, symbol: symbol)
                                            GetCoingeckoCriptocurrenciesPrices().loadData (list: coingeckoId) { [self]  (res) in

                                                let coingeckoPriceObj = res[coingeckoId] as Any?
                                                let coingeckoPrice = (coingeckoPriceObj as AnyObject)["usd"] as Any?
                                                
                                                if(coingeckoPrice != nil) {
                                                    saveCoingeckoPrice(price: coingeckoPrice as! Double, cryptoId: cryptoId, notification: notification)
                                                }
                                               
                                            }

    }
    
    func saveCoingeckoPrice(price: Double, cryptoId: UUID, notification: Bool)
    {
                      
        do {
                                                let savedCryptos = try  viewContext.fetch(request)
                                                                for index in 0..<savedCryptos.count {
                                                                    if(savedCryptos[index].id == cryptoId) {
                                                                        if(notification) {
                                                                            if(savedCryptos[index].price > savedCryptos[index].notificationPriceUp && !savedCryptos[index].notificated) {
                                                                                NotificationTask().run(title: savedCryptos[index].name! + " price alert!", subtitle: String(savedCryptos[index].price))
                                                                            }
                                                                            if(savedCryptos[index].price < savedCryptos[index].notificationPriceDown && !savedCryptos[index].notificated) {
                                                                                NotificationTask().run(title: savedCryptos[index].name! + " price alert!", subtitle: String(savedCryptos[index].price))
                                                                            }
                                                                            savedCryptos[index].notificated = true
                                                                        }
                                                                        savedCryptos[index].price = price
                                                                             SaveContext()
                                                                        
                                                                        saveTotalAccounts ()
                                                                    }
                                                                }
                                               
            
        } catch {
            print(error)
        }
        

    }

    
    func getCoingeckoCryptoId(coingeckoList: [CryptocurrencyCoingeckoModel], symbol: String) -> String
    {
      
        for crypto in  coingeckoList {
            if(crypto.symbol == symbol.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) {
                return crypto.id
            }
        }
        
        return ""

    }
    
    func getBinanceCryptoPrice(binanceList:  [CryptocurrencyBinanceModel], symbol: String) -> Double
    {
     
        for crypto in  binanceList {
            if(crypto.symbol == symbol.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() + "USDT") {
                return Double(crypto.price)!
            }
        }
        
        return 0

    }
    
    func saveTotalAccounts () {
        
        let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
        let cryptoRequest: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
        
        do {
 
            let savedAccounts = try  viewContext.fetch(accountRequest)
           
            
            for i in 0..<savedAccounts.count {
                if(savedAccounts[i].type == "crypto") {
                var total: Double = 0
                
                    cryptoRequest.predicate = NSPredicate(format: "accountId = %@", savedAccounts[i].id! as CVarArg)
                  
                let savedCryptos = try  viewContext.fetch(cryptoRequest)
                
                for index in 0..<savedCryptos.count {
                    
                    total = total + (savedCryptos[index].price * savedCryptos[index].amount)
                    
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





class CryptocurrencyBinanceModel: Decodable {

     var symbol: String
    var price: String

}

class CryptocurrencyCoingeckoModel: Decodable {

     var symbol: String
    var id: String
    var name: String

}


class GetBinanceCriptocurrencies: ObservableObject {
    @Published var items = [CryptocurrencyBinanceModel]()
    
    func loadData(completion:@escaping ([CryptocurrencyBinanceModel]) -> ()) {
           guard let url = URL(string: "https://api.binance.com/api/v3/ticker/price") else {
               print("Invalid url...")
               return
           }
           URLSession.shared.dataTask(with: url) { data, response, error in
            print("Call binance prices")
//            let str = String(data: data!, encoding: .utf8)
//            print(str as Any)

//               print(cryptos)
            var cryptos : [CryptocurrencyBinanceModel]
            do{
                if(data != nil) {
                cryptos = try JSONDecoder().decode([CryptocurrencyBinanceModel].self, from: data!)
                } else {
                    cryptos = []
                }
            }catch {
                cryptos = []
            }
            
            
               DispatchQueue.main.async {
                   completion(cryptos)
               }
           }.resume()
           
       }
}

class GetCoingeckoCriptocurrencies: ObservableObject {
    @Published var items = [CryptocurrencyCoingeckoModel]()
    
    func loadData(completion:@escaping ([CryptocurrencyCoingeckoModel]) -> ()) {
           guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/list") else {
               print("Invalid url...")
               return
           }
           URLSession.shared.dataTask(with: url) { data, response, error in
            print("Call coingecko list")
//                                    let str = String(data: data!, encoding: .utf8)
//                                    print(str as Any)
            var cryptos : [CryptocurrencyCoingeckoModel]
            do{
                if(data != nil) {
                    cryptos = try JSONDecoder().decode([CryptocurrencyCoingeckoModel].self, from: data!)
                } else {
                    cryptos = []
                }
            }catch {
                cryptos = []
            }
               DispatchQueue.main.async {
                   completion(cryptos)
               }
           }.resume()
           
       }
}

class GetCoingeckoCriptocurrenciesPrices: ObservableObject {

    func loadData(list: String, completion:@escaping ([String: Any?]) -> ()) {
           guard let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=" + list + "&vs_currencies=usd") else {
               print("Invalid url...")
               return
           }
           URLSession.shared.dataTask(with: url) { data, response, error in

//                        let str = String(data: data!, encoding: .utf8)
//                        print(str as Any)
            
            
            var cryptos : [String: Any]?
            do{
                if(data != nil) {
                    cryptos = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                }
            }catch {
                cryptos = [:]
            }
            
               DispatchQueue.main.async {
                completion(cryptos ?? [:])
               }
           }.resume()
           
       }
}



//class CryptocurrencyMarketModel: Decodable {
//
//     var binance: [CryptocurrencyBinanceModel]
//    var coingecko: [CryptocurrencyCoingeckoModel]
//
//}


//https://api.coingecko.com/api/v3/coins/list
//https://api.coingecko.com/api/v3/simple/price?ids=solanium&vs_currencies=usd
//https://api.coingecko.com/api/v3/simple/price?ids=dogecoin,solanium&vs_currencies=usd
//https://api.coingecko.com/api/v3/simple/price?ids=tether&vs_currencies=ars,brl,usd
