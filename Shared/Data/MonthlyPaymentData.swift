//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class MonthlyPaymentData: ObservableObject {
    @Published var items = [PaymentModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [PaymentModel]{
        
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
    
    
   
    func addPayment(payment: PaymentModel)
    {
      
            withAnimation {

                let newPayment = MonthlyPayment(context: viewContext)
                newPayment.id = UUID()
                newPayment.name = payment.name
                newPayment.amount = payment.amount
                newPayment.symbol = payment.symbol
                newPayment.currency = payment.currency
                if(payment.isGoal == true && payment.goalId == nil) {
                    newPayment.isGoal = false
                } else {
                    newPayment.isGoal = payment.isGoal
                }
                newPayment.isPaid = payment.isPaid
                newPayment.goalId = payment.goalId
                newPayment.iconColor = payment.iconColor
                newPayment.iconContent = payment.iconContent
                newPayment.category = payment.category
                newPayment.account = payment.account
                newPayment.notificationDay = payment.notificationDay
                newPayment.notificated = false

      SaveContext()
            }
     
    }
    
    func updatePayment(payment: PaymentModel)
    {
       
          
        do {
                let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.id as CVarArg)
                
                let savedPayment = try  self.viewContext.fetch(request)[0]
           
            savedPayment.name = payment.name
        savedPayment.amount = payment.amount
        savedPayment.symbol = payment.symbol
        savedPayment.currency = payment.currency
        savedPayment.account = payment.account
        savedPayment.isPaid = payment.isPaid
            if(payment.isGoal == true && payment.goalId == nil) {
                savedPayment.isGoal = false
            } else {
                savedPayment.isGoal = payment.isGoal
            }
        savedPayment.goalId = payment.goalId
        savedPayment.iconColor = payment.iconColor
        savedPayment.iconContent = payment.iconContent
            savedPayment.category = payment.category
            savedPayment.notificated = false
            savedPayment.notificationDay = payment.notificationDay
            
        } catch {
            print(error)
        }

      SaveContext()
     

    }
    
    func deletePayment(payment: PaymentModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", payment.id as CVarArg)
               

                    do {
                        let savedPayments = try  self.viewContext.fetch(request)
                        
                        for payment in savedPayments {
                            self.viewContext.delete(payment)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
       
    
    }
    
    func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
        print(error)
    }
    }
    
    func map(payment: MonthlyPayment) -> PaymentModel
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
        paymentModel.account = payment.account!
        paymentModel.notificationDay = payment.notificationDay
        paymentModel.notificated = payment.notificated
        paymentModel.category = payment.category

        return paymentModel
    }
    

    func stringToEntityMap(payment: PaymentModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = payment.id.uuidString
        fields.field2 = payment.name
        fields.field3 = payment.symbol
        fields.field4 = payment.currency
        fields.field5 = String(payment.amount)
        fields.field6 = payment.iconColor
        fields.field7 = payment.iconContent
        fields.field8 = String(payment.isPaid)
        fields.field8 = String(payment.isGoal)
        if(payment.goalId != nil) {
            fields.field8 = payment.goalId!.uuidString
        }
        fields.field9 = payment.account.uuidString
        fields.field10 = String(payment.notificationDay)
        fields.field10 = String(payment.notificated)
        fields.field10 = String(payment.category)

        return fields
    }
   
}
