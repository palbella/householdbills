//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class BudgetData: ObservableObject {
    @Published var items = [BudgetModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Budget> = Budget.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [BudgetModel]{
        
        do {
        let savedBudgets = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedBudgets.count {
                self.items.append(map(budget: savedBudgets[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    func addBudget(budget: BudgetModel)
    {
      
            withAnimation {
             
                let newBudget = Budget(context: viewContext)
                newBudget.id = UUID()
                newBudget.name = budget.name
                newBudget.amount = budget.amount
                newBudget.symbol = budget.symbol
                newBudget.currency = budget.currency
                newBudget.iconColor = budget.iconColor
                newBudget.iconContent = budget.iconContent
                

      SaveContext()
            }
   
    }
    
    func updateBudget(budget: BudgetModel)
    {
      
          
        do {
                let request: NSFetchRequest<Budget> = Budget.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", budget.id as CVarArg)
                
                let savedBudget = try  self.viewContext.fetch(request)[0]
                
            savedBudget.name = budget.name
            savedBudget.amount = budget.amount
            savedBudget.symbol = budget.symbol
            savedBudget.currency = budget.currency
            savedBudget.amount = budget.amount
            savedBudget.iconColor = budget.iconColor
            savedBudget.iconContent = budget.iconContent
            
            
        } catch {
            print(error)
        }

      SaveContext()
       

    }
    
    func deleteBudget(budget: BudgetModel)
    {
       
            withAnimation {
                
                let request: NSFetchRequest<Budget> = Budget.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", budget.id as CVarArg)
               

                    do {
                        let savedBudgets = try  self.viewContext.fetch(request)
                        
                        for budget in savedBudgets {
                            self.viewContext.delete(budget)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
   
  
    }
    
    func accountAdjustment(destination: UUID, amount: Double)
    {
      
          
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", destination as CVarArg)
                
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
    
    func map(budget: Budget) -> BudgetModel
    {
        var budgetModel = BudgetModel()
        
        budgetModel.id = budget.id!
        budgetModel.name = budget.name ?? ""
        budgetModel.symbol = budget.symbol ?? ""
        budgetModel.currency = budget.currency ?? ""
        budgetModel.amount = budget.amount
        budgetModel.iconColor = budget.iconColor ?? ""
        budgetModel.iconContent = budget.iconContent ?? ""

        return budgetModel
    }
    

    
   
}
