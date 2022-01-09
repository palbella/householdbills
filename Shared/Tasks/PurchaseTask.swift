//
//  PurchaseTask.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 1/7/22.
//

import Foundation
import StoreKit

enum IAPProduct : String {
    case year = "householdbills_1499_1y"
}

class IPAService: NSObject {
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
        for transaction in transactions{
            print(transaction.transactionState, transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break;
            case .purchased:
//                Purchase.isBuy = true
                queue.finishTransaction(transaction)
            case .restored:
//                Purchase.isBuy = true
                queue.finishTransaction(transaction)
            default:
                queue.finishTransaction(transaction)
            }
        }
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
