//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchBudgets: ObservableObject {
    @Published var items = [BudgetModel]()
   

    let request: NSFetchRequest<Budget> = Budget.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext) ->  [BudgetModel]{
        
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
    
    private func map(budget: Budget) -> BudgetModel
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
