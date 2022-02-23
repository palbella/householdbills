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
            
            if(api.api != "https://api.url.example?token=$stock$") {
                saved.stockAPI = api.api
            } else {
                saved.stockAPI = ""
            }
            
            if(api.response != "[anyProperty][propertyPrice]") {
                saved.stockResponse = api.response
            } else {
                saved.stockResponse = ""
            }
            
            if(api.request != "{ json: { example: 'request body' } }") {
                saved.stockRequest = api.request
            } else {
                saved.stockRequest = ""
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
                model.api = "https://api.url.example?token=$stock$"
            }
            if(model.response == "") {
                model.response = "[anyProperty][propertyPrice]"
            }
            if(model.request == "") {
                model.request = ""
            }
            
            if(model.type == "Yahoo!") {
                model.api = "https://yfapi.net/v6/finance/quote?region=US&lang=en&symbols=$stock$"
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
