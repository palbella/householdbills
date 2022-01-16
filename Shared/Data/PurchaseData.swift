//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class PurchaseData: ObservableObject {
    @Published var items = [PurchaseModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [PurchaseModel]{
        
        do {
        let savedPurchases = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedPurchases.count {
                self.items.append(map(purchase: savedPurchases[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    func addPurchase(purchase: PurchaseModel)
    {
      
            withAnimation {
             
                let newPurchase = Purchase(context: viewContext)
                newPurchase.id = UUID()
                newPurchase.name = purchase.name
                newPurchase.amount = purchase.amount
                newPurchase.symbol = purchase.symbol
                newPurchase.currency = purchase.currency
                newPurchase.iconColor = purchase.iconColor
                newPurchase.iconContent = purchase.iconContent
                newPurchase.account = purchase.account
                newPurchase.category = purchase.category
                

      SaveContext()
            }
   
    }
    
    func updatePurchase(purchase: PurchaseModel)
    {
      
          
        do {
                let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", purchase.id as CVarArg)
                
                let savedPurchase = try  self.viewContext.fetch(request)[0]
                
            savedPurchase.name = purchase.name
            savedPurchase.amount = purchase.amount
            savedPurchase.symbol = purchase.symbol
            savedPurchase.currency = purchase.currency
            savedPurchase.amount = purchase.amount
            savedPurchase.iconColor = purchase.iconColor
            savedPurchase.iconContent = purchase.iconContent
            savedPurchase.account = purchase.account
            savedPurchase.category = purchase.category
            
            
        } catch {
            print(error)
        }

      SaveContext()
       

    }
    
    func deletePurchase(purchase: PurchaseModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", purchase.id as CVarArg)
               

                    do {
                        let savedPurchases = try  self.viewContext.fetch(request)
                        
                        for purchase in savedPurchases {
                            self.viewContext.delete(purchase)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
   
  
    }
    
    func accountAdjustment(destination: UUID?, amount: Double)
    {
      
        if(destination == nil) {
            return
        }
          
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", destination! as CVarArg)
                
            let account = try self.viewContext.fetch(request)
            if(account.count > 0) {
                let savedAccount = account[0]
                
                savedAccount.amount = savedAccount.amount + amount
            }
        
            
            
            
        } catch {
            print(error)
        }

      SaveContext()
    

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func map(purchase: Purchase) -> PurchaseModel
    {
        var purchaseModel = PurchaseModel()
        
        purchaseModel.id = purchase.id!
        purchaseModel.name = purchase.name ?? ""
        purchaseModel.symbol = purchase.symbol ?? ""
        purchaseModel.currency = purchase.currency ?? ""
        purchaseModel.amount = purchase.amount
        purchaseModel.iconColor = purchase.iconColor ?? ""
        purchaseModel.iconContent = purchase.iconContent ?? ""
        purchaseModel.account = purchase.account
        purchaseModel.category = purchase.category

        return purchaseModel
    }
    
    func stringToEntityMap(purchase: PurchaseModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = purchase.id.uuidString
        fields.field2 = purchase.name
        fields.field3 = purchase.symbol
        fields.field4 = purchase.currency
        fields.field5 = String(purchase.amount)
        fields.field6 = purchase.iconColor
        fields.field7 = purchase.iconContent
        if(purchase.account != nil) {
            fields.field8 = purchase.account!.uuidString
        } else {
            fields.field8 = ""
        }
        fields.field9 = String(purchase.category)
        

        return fields
    }
    
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedPurchase = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateCurrency(currency: array[3].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateColor(color: array[5].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateIcon(icon: array[6].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateInt(value: array[8].trimmingCharacters(in: .whitespacesAndNewlines))
               
                
                if(savedPurchase.count < 1 && validator) {
                    
                    let newPurchase = Purchase(context: viewContext)
                    newPurchase.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newPurchase.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newPurchase.symbol = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    newPurchase.currency = array[3].trimmingCharacters(in: .whitespacesAndNewlines)
                    newPurchase.amount = Double(array[4].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newPurchase.iconColor = array[5].trimmingCharacters(in: .whitespacesAndNewlines)
                    newPurchase.iconContent = array[6].trimmingCharacters(in: .whitespacesAndNewlines)
                    if(array[7].trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                        newPurchase.account =  UUID(uuidString: array[7].trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    newPurchase.category = Int32(array[8].trimmingCharacters(in: .whitespacesAndNewlines))!
                   
                    

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
    
    
   
}
