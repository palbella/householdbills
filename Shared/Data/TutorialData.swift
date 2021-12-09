//
//  SettingsData.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/31/21.
//

import SwiftUI
import CoreData

class TutorialData: ObservableObject {
   
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
  
    
    init() {
   
    }
    
    func needTutorial(name: String, tutorialStep:Int32) -> Bool
    {
      
        var result = false;
        
        do {

            let request: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
            
            let tutorial = try self.viewContext.fetch(request)[0]
            
            result = tutorial.step == tutorialStep
            
        } catch {
            print(error)
        }

     return result
    

    }
    
    func saveTutorial(name: String, tutorialStep:Int32)
    {
      
        
        do {

            let request: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", name as CVarArg)
            
            let tutorial = try self.viewContext.fetch(request)[0]
            
            if(tutorialStep == tutorial.step)
            {
                tutorial.step = tutorial.step + 1
                
                SaveContext()
            }
            
        } catch {
            print(error)
        }
    

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
}
