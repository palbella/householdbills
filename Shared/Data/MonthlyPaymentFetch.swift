//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchMonthlyPayments: ObservableObject {
    @Published var items = [PaymentModel]()
   

    let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext) ->  [PaymentModel]{
        
        do {
        let savedPayments = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedPayments.count {
                self.items.append(map(payment: savedPayments[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    private func map(payment: MonthlyPayment) -> PaymentModel
    {
        var paymentModel = PaymentModel()
        
        paymentModel.id = payment.id!
        paymentModel.name = payment.name ?? ""
        paymentModel.symbol = payment.symbol ?? ""
        paymentModel.currency = payment.currency ?? ""
        paymentModel.amount = payment.amount
        paymentModel.isPaid = payment.isPaid
        paymentModel.isGoal = payment.isGoal
        if(payment.goalId != nil) {
            paymentModel.goalId = payment.goalId!
        }
        paymentModel.iconColor = payment.iconColor ?? ""
        paymentModel.iconContent = payment.iconContent ?? ""

        return paymentModel
    }
    
   
}
