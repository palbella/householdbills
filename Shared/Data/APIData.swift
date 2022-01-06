//
//  SettingsData.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/31/21.
//

import SwiftUI
import CoreData

class APIData: ObservableObject {
   
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<API> = API.fetchRequest()
  
    
    init() {
   
    }
    
    func update(api: APIModel)
    {
      
          
        do {
                let request: NSFetchRequest<API> = API.fetchRequest()
                
                let saved = try  self.viewContext.fetch(request)[0]
            
            if(api.api != "http://api.url.example?token=$stock$") {
                saved.stockAPI = api.api
            } else {
                saved.stockAPI = ""
            }
            
            if(api.response != "[anyProperty][propertyPrice]") {
                saved.stockRequest = api.request
            } else {
                saved.stockRequest = ""
            }
            
            if(api.request == "{ json: { example: 'request body' } }") {
                saved.stockResponse = api.response
            } else {
                saved.stockResponse = ""
            }
                
            saved.stockType = api.type
            
        } catch {
            print(error)
        }

      SaveContext()
    

    }
    
    func get() -> APIModel
    {
      
        var model = APIModel()
        do {
                let request: NSFetchRequest<API> = API.fetchRequest()
                
                let saved = try  self.viewContext.fetch(request)[0]
                
          
            
            model.api = (saved.stockAPI == nil ? "" : saved.stockAPI)!
            model.type = saved.stockType!
            model.request = (saved.stockRequest == nil ? "" : saved.stockRequest)!
            model.response = (saved.stockResponse == nil ? "" : saved.stockResponse)! 
            
            if(model.api == "") {
                model.api = "http://api.url.example?token=$stock$"
            }
            if(model.response == "") {
                model.response = "[anyProperty][propertyPrice]"
            }
            if(model.request == "") {
                model.request = "{ json: { example: 'request body' } }"
            }
            
            
            
        } catch {
            print(error)
        }
        return model

    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
}
