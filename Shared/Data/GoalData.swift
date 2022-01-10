//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class GoalData: ObservableObject {
    @Published var items = [GoalModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Goal> = Goal.fetchRequest()
  
    @ObservedObject var fetchCurrencies = CurrencyData()
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [GoalModel]{
        
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
    
    func addGoal(goal: GoalModel)
    {
      
            withAnimation {
               
                let newGoal = Goal(context: viewContext)
                newGoal.id = UUID()
                newGoal.name = goal.name
                newGoal.amount = goal.amount
                newGoal.target = goal.target
                newGoal.symbol = goal.symbol
                newGoal.currency = goal.currency
                newGoal.iconColor = goal.iconColor
                newGoal.iconContent = goal.iconContent
                

      SaveContext()
            }
   
    }
    
    func updateGoal(goal: GoalModel)
    {
      
          
        do {
                let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
                
                let savedGoal = try  self.viewContext.fetch(request)[0]
                
                savedGoal.name = goal.name
            savedGoal.amount = goal.amount
            savedGoal.symbol = goal.symbol
            savedGoal.currency = goal.currency
            savedGoal.amount = goal.amount
            savedGoal.target = goal.target
            savedGoal.iconColor = goal.iconColor
            savedGoal.iconContent = goal.iconContent
            
            
        } catch {
            print(error)
        }

      SaveContext()
   

    }
    
    func deleteGoal(goal: GoalModel)
    {

            withAnimation {
                
                let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", goal.id as CVarArg)
               

                    do {
                        let savedGoals = try  self.viewContext.fetch(request)
                        
                        for goal in savedGoals {
                            self.viewContext.delete(goal)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }
  
    }
    
    func upjustmentGoal(id: UUID, amount: Double, currencyFrom: String)
    {
        let currencies = GetCurrencies()
        currencies.items = fetchCurrencies.fetch()
          
        do {
                let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                let savedGoal = try  self.viewContext.fetch(request)[0]
                
            savedGoal.amount = savedGoal.amount + currencies.convert(currencyFrom: currencyFrom, currencyTo: savedGoal.currency!, value: amount)
            
            
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
    
    func map(goal: Goal) -> GoalModel
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
