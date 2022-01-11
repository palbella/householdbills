//
//  CryptoFetch.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/22/21.
//

import SwiftUI
import CoreData

class CryptocurrencyData: ObservableObject {
    @Published var items = [CryptocurrencyModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
  
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [CryptocurrencyModel]{
        
        do {
            let savedRecords = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedRecords.count {
                self.items.append(map(crypto: savedRecords[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    
    func addCrypto(crypto: CryptocurrencyModel)
   {
     
           withAnimation {
            
               let newCrypto = Cryptocurrency(context: viewContext)
               newCrypto.id = UUID()
               newCrypto.accountId = crypto.accountId
               newCrypto.name = crypto.name
               newCrypto.amount = crypto.amount
               newCrypto.symbol = crypto.symbol
               newCrypto.avgPurchase = crypto.avgPurchase
               newCrypto.price = crypto.price
               newCrypto.notificated = false
               newCrypto.notificationPriceUp = crypto.notificationPriceUp
               newCrypto.notificationPriceDown = crypto.notificationPriceDown

     SaveContext()
           }
       GetMarketCriptocurrencies(viewContext: viewContext).run()
//       getTotals()

   }
    
    
    func updateCrypto(crypto: CryptocurrencyModel)
    {
      
          
        do {
                let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", crypto.id as CVarArg)
                
                let savedCrypto = try  self.viewContext.fetch(request)[0]
                
            savedCrypto.name = crypto.name
            savedCrypto.accountId = crypto.accountId
            savedCrypto.amount = crypto.amount
            savedCrypto.symbol = crypto.symbol
            savedCrypto.amount = crypto.amount
            savedCrypto.avgPurchase = crypto.avgPurchase
            savedCrypto.price = crypto.price
            savedCrypto.notificated = false
            savedCrypto.notificationPriceUp = crypto.notificationPriceUp
            savedCrypto.notificationPriceDown = crypto.notificationPriceDown
            
        } catch {
            print(error)
        }

      SaveContext()
        GetMarketCriptocurrencies(viewContext: viewContext).run()

    }
    
    func deleteCrypto(crypto: CryptocurrencyModel)
    {
            withAnimation {
                
                let request: NSFetchRequest<Cryptocurrency> = Cryptocurrency.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", crypto.id as CVarArg)

                    do {
                        let savedCryptos = try  self.viewContext.fetch(request)
                        
                        for crypto in savedCryptos {
                            self.viewContext.delete(crypto)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
SaveContext()
        GetMarketCriptocurrencies(viewContext: viewContext).run()
//        getTotals()
       
    }
    
    
    func map(crypto: Cryptocurrency) -> CryptocurrencyModel
    {
        var cryptoModel = CryptocurrencyModel()
        
        cryptoModel.id = crypto.id!
        cryptoModel.name = crypto.name ?? ""
        cryptoModel.symbol = crypto.symbol ?? ""
        cryptoModel.amount = crypto.amount
        cryptoModel.accountId = crypto.accountId!
        cryptoModel.avgPurchase = crypto.avgPurchase
        cryptoModel.price = crypto.price
        cryptoModel.notificated = crypto.notificated
        cryptoModel.notificationPriceUp = crypto.notificationPriceUp
        cryptoModel.notificationPriceDown = crypto.notificationPriceDown

        return cryptoModel
    }
    
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func stringToEntityMap(crypto: CryptocurrencyModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = crypto.id.uuidString
        fields.field2 = crypto.name
        fields.field3 = crypto.symbol
        fields.field4 = String(crypto.amount)
        fields.field6 = crypto.accountId.uuidString
        fields.field7 = String(crypto.avgPurchase)
        fields.field8 = String(crypto.price)
        fields.field9 = String(crypto.notificated)
        fields.field10 = String(crypto.notificationPriceUp)
        fields.field11 = String(crypto.notificationPriceDown)
        

        return fields
    }
   
}
