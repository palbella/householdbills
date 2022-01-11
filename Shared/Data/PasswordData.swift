//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class PasswordData: ObservableObject {
    @Published var items = [PasswordModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Password> = Password.fetchRequest()
  
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [PasswordModel]{
        
        do {
        let savedPasswords = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedPasswords.count {
                self.items.append(map(password: savedPasswords[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
  
 
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func map(password: Password) -> PasswordModel
    {
        var passwordModel = PasswordModel()
        
        passwordModel.id = password.id!
        passwordModel.name = password.name!
        passwordModel.password = password.password!

        return passwordModel
    }
    
    func stringToEntityMap(password: PasswordModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = password.id.uuidString
        fields.field2 = password.name
        fields.field3 = password.password
        

        return fields
    }
    
   
}
