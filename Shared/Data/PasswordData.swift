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
    
  
    func addPassword(password: PasswordModel)
    {
      
            withAnimation {
               
                let newPassword = Password(context: viewContext)
                newPassword.id = UUID()
                newPassword.name = password.name
                newPassword.password = password.password
               
                

      SaveContext()
            }
   
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
    
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<Password> = Password.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedPassword = try  self.viewContext.fetch(request)
                
                
                if(savedPassword.count < 1) {
                    
                    let newPassword = Password(context: viewContext)
                    newPassword.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newPassword.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newPassword.password = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                   
                    

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}
