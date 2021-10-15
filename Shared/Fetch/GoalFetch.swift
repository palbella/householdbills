//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchGoals: ObservableObject {
    @Published var items = [GoalModel]()
   

    let request: NSFetchRequest<Goal> = Goal.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext) ->  [GoalModel]{
        
        do {
        let savedGoals = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedGoals.count {
                self.items.append(map(goal: savedGoals[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    private func map(goal: Goal) -> GoalModel
    {
        var goalModel = GoalModel()
        
        goalModel.id = goal.id!
        goalModel.name = goal.name ?? ""
        goalModel.symbol = goal.symbol ?? ""
        goalModel.currency = goal.currency ?? ""
        goalModel.amount = goal.amount
        goalModel.target = goal.target
        goalModel.iconColor = goal.iconColor ?? ""
        goalModel.iconContent = goal.iconContent ?? ""

        return goalModel
    }
    
   
}
