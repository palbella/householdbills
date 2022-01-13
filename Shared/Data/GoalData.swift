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
    
   
    func stringToEntityMap(goal: GoalModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = goal.id.uuidString
        fields.field2 = goal.name
        fields.field3 = goal.symbol
        fields.field4 = goal.currency
        fields.field5 = String(goal.amount)
        fields.field6 = goal.iconColor
        fields.field7 = goal.iconContent
        fields.field8 = String(goal.target)
        
        return fields
    }
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<Goal> = Goal.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedGoal = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateCurrency(currency: array[3].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateColor(color: array[5].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateIcon(icon: array[6].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[7].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[4].trimmingCharacters(in: .whitespacesAndNewlines))
                
                if(savedGoal.count < 1 && validator) {
                    
                    let newGoal = Goal(context: viewContext)
                    newGoal.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newGoal.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newGoal.symbol = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    newGoal.currency = array[3].trimmingCharacters(in: .whitespacesAndNewlines)
                    newGoal.amount = Double(array[4].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newGoal.iconColor = array[5].trimmingCharacters(in: .whitespacesAndNewlines)
                    newGoal.iconContent = array[6].trimmingCharacters(in: .whitespacesAndNewlines)
                    newGoal.target = Double(array[7].trimmingCharacters(in: .whitespacesAndNewlines))!
                  
                    

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}
