//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class CarData: ObservableObject {
    @Published var items = [CarModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let request: NSFetchRequest<Car> = Car.fetchRequest()
  
    
    init() {
        self.items = []
    }
    
    func fetch() ->  [CarModel]{
        
        do {
        let savedCars = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedCars.count {
                self.items.append(map(car: savedCars[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
  
    func addCar(car: CarModel)
    {
      
            withAnimation {
               
                let newCar = Car(context: viewContext)
                newCar.id = UUID()
                newCar.name = car.name
                newCar.symbol = car.symbol
                newCar.amount = car.amount
                newCar.iconColor = car.iconColor
                newCar.iconContent = car.iconContent
                newCar.alert = car.alert
                

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
    
    func map(car: Car) -> CarModel
    {
        var carModel = CarModel()
        
        carModel.id = car.id!
        carModel.name = car.name!
        carModel.symbol = car.symbol!
        carModel.amount = car.amount
        carModel.iconColor = car.iconColor!
        carModel.iconContent = car.iconContent!
        carModel.alert = car.alert

        return carModel
    }
    
    func stringToEntityMap(car: CarModel) -> CSVFields
    {
        var fields = CSVFields()
        
        fields.field1 = car.id.uuidString
        fields.field2 = car.name
        fields.field3 = car.symbol
        fields.field4 = String(car.amount)
        fields.field5 = car.iconColor
        fields.field6 = car.iconContent
        fields.field7 = String(car.alert)

        return fields
    }
    
    
    func entityToStringMap (line: String)
    {
        let array = line.components(separatedBy: ",")
        if(array.count == 20) {
            
            do {
                    let request: NSFetchRequest<Car> = Car.fetchRequest()
                    request.predicate = NSPredicate(format: "id = %@", array[0].trimmingCharacters(in: .whitespacesAndNewlines) as CVarArg)
                let savedCar = try  self.viewContext.fetch(request)
                
                var validator = ExportImportTask().validateInt(value: array[5].trimmingCharacters(in: .whitespacesAndNewlines))
                validator = validator && ExportImportTask().validateBoolean(value: array[8].trimmingCharacters(in: .whitespacesAndNewlines))
              
               
                
                if(savedCar.count < 1 && validator) {
                    
                    let newCar = Car(context: viewContext)
                    newCar.id = UUID(uuidString: array[0].trimmingCharacters(in: .whitespacesAndNewlines))
                    newCar.name = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    newCar.symbol = array[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    newCar.amount = Int32(array[3].trimmingCharacters(in: .whitespacesAndNewlines))!
                    newCar.iconColor = array[4].trimmingCharacters(in: .whitespacesAndNewlines)
                    newCar.iconContent = array[5].trimmingCharacters(in: .whitespacesAndNewlines)
                    newCar.alert = Bool(array[6].trimmingCharacters(in: .whitespacesAndNewlines))!

          SaveContext()
                }
                
            } catch {
                print(error)
            }
            
        }
    }
   
}
