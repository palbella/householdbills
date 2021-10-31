//
//  SettingsData.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/31/21.
//

import SwiftUI
import CoreData

class SettingsData: ObservableObject {
   
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Settings> = Settings.fetchRequest()
  
    
    init() {
   
    }
    
    func updateSettings(settings: UserSettings)
    {
      
          
        do {
                let request: NSFetchRequest<Settings> = Settings.fetchRequest()
                
                let savedSettings = try  self.viewContext.fetch(request)[0]
                
            savedSettings.name = settings.name
            savedSettings.email = settings.email
            savedSettings.password = settings.password
            savedSettings.passwordQuestion1 = settings.passwordQuestion1
            savedSettings.passwordQuestion2 = settings.passwordQuestion2
            savedSettings.passwordQuestion3 = settings.passwordQuestion3
            savedSettings.passwordAnswer1 = settings.passwordAnswer1
            savedSettings.passwordAnswer2 = settings.passwordAnswer2
            savedSettings.passwordAnswer3 = settings.passwordAnswer3
            
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
    
}
