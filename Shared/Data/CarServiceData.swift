//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class CarServiceData: ObservableObject {
    @Published var items = [ServiceModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<CarService> = CarService.fetchRequest()
  
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [ServiceModel]{
        
        do {
        let savedCarServices = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedCarServices.count {
                self.items.append(map(carService: savedCarServices[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
  
    func addCarService(carService: ServiceModel)
    {
      
            withAnimation {
               
                let newCarService = CarService(context: viewContext)
                newCarService.id = UUID()
                newCarService.name = carService.name
                newCarService.months = carService.months
                newCarService.amount = carService.amount
               
                

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
    
    func map(carService: CarService) -> ServiceModel
    {
        var carServiceModel = ServiceModel()
        
        carServiceModel.id = carService.id!
        carServiceModel.name = carService.name!
        carServiceModel.months = carService.months
        carServiceModel.amount = carService.amount
       

        return carServiceModel
    }
    
    func stringToEntityMap(carService: ServiceModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = carService.id.uuidString
        fields.field2 = carService.name
        fields.field3 = String(carService.months)
        fields.field4 = String(carService.amount)
    

        return fields
    }
    
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<CarService> = CarService.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedCarService = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateDouble(value: array[2].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateDouble(value: array[3].trimmingCharacters(in: .whitespacesAndNewlines))
              
               
                
                if(savedCarService.count < 1 && validator) {
                    
                    let newCarService = CarService(context: viewContext)
                    newCarService.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newCarService.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newCarService.months = Int32(array[2].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newCarService.amount = Int32(array[3].trimmingCharacters(in: .whitespacesAndNewlines))!
               

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}
