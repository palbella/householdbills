//
//  PurchaseTask.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 1/7/22.
//

import Foundation
import StoreKit
import CoreData
import SwiftUI

enum IAPProduct : String {
    case year = "householdbills_1499_1y"
}

class IPAService: NSObject {
    
    var settings: UserSettings = UserSettings()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
    
    static var shared = IPAService()
    var products = [SKProduct]()
    var paymentQueue = SKPaymentQueue.default()
    private override init() {
       
    }
    
 
    
    func getProduct(){
       
          let products : Set = [IAPProduct.year.rawValue]
          let request = SKProductsRequest(productIdentifiers: products)
          request.delegate = self
          request.start()
        paymentQueue.add(self)
          paymentQueue.restoreCompletedTransactions()
      }
    
    func purchase(product:IAPProduct){
        guard let productToPurchase = products.first(where: {$0.productIdentifier == product.rawValue}) else {
            return
         }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func subscriptionVerification(settings: UserSettings) {
        self.settings = settings
        
        do {
            
//            var dateComponent = DateComponents()
//            dateComponent.month = -1
//
//            let pastMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
            
        let savedSettings =  try viewContext.fetch(fetchRequest)
            
            if(savedSettings[0].subscriptionVerification != nil) {
                self.handleSubscription(dateTransaction: savedSettings[0].subscriptionVerification)
//                if(savedSettings[0].subscriptionVerification! < pastMonth!) {
//                    print("Restoring products ...")
//                    SKPaymentQueue.default().restoreCompletedTransactions()
//                }
            } else {
                print("Restoring products ...")
//                SKPaymentQueue.default().restoreCompletedTransactions()
            }
           
        } catch {
        }
    }
    
    func handleSubscription(dateTransaction: Date?) {
        do {
            var dateComponent = DateComponents()
            dateComponent.year = -1
            let pastYear = Calendar.current.date(byAdding: dateComponent, to: Date())
            
            let savedSettings =  try viewContext.fetch(fetchRequest)
            
            savedSettings[0].subscriptionVerification = Date()
            savedSettings[0].subscriptionDate = dateTransaction
            
            if(dateTransaction == nil || dateTransaction! < pastYear!) {
                savedSettings[0].subscribed = false
                settings.subscribed = false
            } else {
                savedSettings[0].subscribed = true
                settings.subscribed = true
            }
            
            try viewContext.save()
            
        } catch {
        }
    }
    
    func lastDateTransaction (lastDateTransaction: Date?, transaction: SKPaymentTransaction) -> Date? {
        
        var lastDate: Date? = lastDateTransaction
        
        if(transaction.payment.productIdentifier == IAPProduct.year.rawValue) {
            if(lastDate == nil) {
                lastDate = transaction.transactionDate
            } else {
                if(lastDate! < transaction.transactionDate!) {
                    lastDate = transaction.transactionDate
                }
            }
        }
        
        return lastDate
    }
    
  
}


extension IPAService: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products{
        print(product.productIdentifier)
    }
        products = response.products
    }
}


extension IPAService:SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        var dateTransaction: Date? = nil
        
        for transaction in transactions{
            print(transaction.transactionState, transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break;
            case .purchased:
                dateTransaction = lastDateTransaction(lastDateTransaction: dateTransaction, transaction: transaction)
                queue.finishTransaction(transaction)
            case .restored:
                dateTransaction = lastDateTransaction(lastDateTransaction: dateTransaction, transaction: transaction)
                queue.finishTransaction(transaction)
            default:
                queue.finishTransaction(transaction)
            }
        }
      
        self.handleSubscription(dateTransaction: dateTransaction)
        
    }
    
   func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    
   }
}


extension SKPaymentTransactionState{
    func status() -> String{
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        @unknown default:
            return "unknown"
        }
    }
}






//private func refreshReceipt(){
//    let request = SKReceiptRefreshRequest(receiptProperties: nil)
//    request.delegate = self
//    request.start()
//}
//
//func requestDidFinish(_ request: SKRequest) {
//    if request is SKReceiptRefreshRequest {
//        refreshSubscriptionsStatus(callback: self.successBlock ?? {}, failure: self.failureBlock ?? {_ in})
//    }
//}
//
//func request(_ request: SKRequest, didFailWithError error: Error){
//        if request is SKReceiptRefreshRequest {
//            self.refreshSubscriptionFailureBlock?(error)
//            self.cleanUpRefeshReceiptBlocks()
//        }
//        print("error: \(error.localizedDescription)")
//}
