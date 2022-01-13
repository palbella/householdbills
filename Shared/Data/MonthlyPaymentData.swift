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
        fields.field9 = String(payment.isGoal)
        if(payment.goalId != nil) {
            fields.field10 = payment.goalId!.uuidString
        }
        fields.field11 = payment.account.uuidString
        fields.field12 = String(payment.notificationDay)
        fields.field13 = String(payment.notificated)
        fields.field14 = String(payment.category)

        return fields
    }
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<MonthlyPayment> = MonthlyPayment.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedMonthlyPayment = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateCurrency(currency: array[3].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateColor(color: array[5].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateIcon(icon: array[6].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[4].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateBoolean(value: array[8].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateBoolean(value: array[7].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateBoolean(value: array[12].trimmingCharacters(in: .whitespacesAndNewlines))
                
                if(savedMonthlyPayment.count < 1 && validator) {
                    
                    let newMonthlyPayment = MonthlyPayment(context: viewContext)
                    newMonthlyPayment.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newMonthlyPayment.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newMonthlyPayment.symbol = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    newMonthlyPayment.currency = array[3].trimmingCharacters(in: .whitespacesAndNewlines)
                    newMonthlyPayment.amount = Double(array[4].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newMonthlyPayment.iconColor = array[5].trimmingCharacters(in: .whitespacesAndNewlines)
                    newMonthlyPayment.iconContent = array[6].trimmingCharacters(in: .whitespacesAndNewlines)
                    newMonthlyPayment.isPaid = (array[7].trimmingCharacters(in: .whitespacesAndNewlines) as NSString).boolValue
                    newMonthlyPayment.isGoal = (array[8].trimmingCharacters(in: .whitespacesAndNewlines) as NSString).boolValue
                    newMonthlyPayment.goalId = UUID(uuidString: array[9].trimmingCharacters(in: .whitespacesAndNewlines))
                    newMonthlyPayment.account = UUID(uuidString: array[10].trimmingCharacters(in: .whitespacesAndNewlines))
                    newMonthlyPayment.notificationDay = Int32(array[11].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newMonthlyPayment.notificated = (array[12].trimmingCharacters(in: .whitespacesAndNewlines) as NSString).boolValue
                    newMonthlyPayment.category = Int32(array[13].trimmingCharacters(in: .whitespacesAndNewlines))!
                    

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}
