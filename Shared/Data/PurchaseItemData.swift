//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class PurchaseItemData: ObservableObject {
    @Published var items = [PurchaseItemModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [PurchaseItemModel]{
        
        do {
        let savedPurchases = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedPurchases.count {
                self.items.append(map(purchaseItem: savedPurchases[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    
    func saveName (id: UUID, value: String) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.name = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
    }
    
    func saveUnit (id: UUID, value: String) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.unit = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
    
    }
    
    func saveAmount (id: UUID, value: Double) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.amount = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
      
    }
    
    func savePrice (id: UUID, value: Double) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.price = value
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
      
    }
    
    
    func purchase (id: UUID) {
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                for item in saved {
                 
                    item.purchased = !item.purchased
                    SaveContext()
                }
                
            } catch {
                print(error)
            }
        
 
    }
    
    func delete (id: UUID) {
        
        
        let request: NSFetchRequest<PurchaseItem> = PurchaseItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

            do {
                let saved = try  self.viewContext.fetch(request)
                
                    self.viewContext.delete(saved[0])
                    SaveContext()
                
                
            } catch {
                print(error)
            }
        
    
    }
    
    func add (purchaseId: UUID) {
        
        let newItem = PurchaseItem(context: viewContext)
        newItem.id = UUID()
        newItem.name = "Item"
        newItem.price = 0
        newItem.amount = 0
        newItem.unit = "u"
        newItem.purchaseId = purchaseId
     
     
SaveContext()
      
    }
   
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func map(purchaseItem: PurchaseItem) -> PurchaseItemModel
    {
        var purchaseItemModel = PurchaseItemModel()
        
        purchaseItemModel.id = purchaseItem.id!
        purchaseItemModel.name = purchaseItem.name ?? ""
        purchaseItemModel.unit = purchaseItem.unit ?? ""
        purchaseItemModel.price = purchaseItem.price
        purchaseItemModel.amount = purchaseItem.amount
   

        return purchaseItemModel
    }
    

    
   
}
