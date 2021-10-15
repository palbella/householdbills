//
//  Service.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData




struct GetCarAlerts {
    @State var viewContext: NSManagedObjectContext
    
//    let request: NSFetchRequest<Car> = Car.fetchRequest()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
    }
    
    func run() {
        calculateCarAlerts ()
    }
    
 
    func calculateCarAlerts () {
        

        do {
            
            let carRequest: NSFetchRequest<Car> = Car.fetchRequest()
            let serviceRequest: NSFetchRequest<CarService> = CarService.fetchRequest()
 
            let savedCars = try  viewContext.fetch(carRequest)
            let savedServices = try  viewContext.fetch(serviceRequest)
            
            for i in 0..<savedCars.count {
                
                let carServiceRequest: NSFetchRequest<CarServices> = CarServices.fetchRequest()
                carServiceRequest.predicate = NSPredicate(format: "carId == %@", savedCars[i].id! as CVarArg)
                
                let savedCarServices = try  viewContext.fetch(carServiceRequest)
              
                
                savedCars[i].alert = false
                
                for ii in 0..<savedCarServices.count {
                    
                    for iii in 0..<savedServices.count {
                        
                        if(savedCarServices[ii].serviceId == savedServices[iii].id) {
                            savedCarServices[ii].month = savedServices[iii].months
                            savedCarServices[ii].amountService = savedServices[iii].amount
                            
                            if(savedCarServices[ii].date == nil) {
                                savedCarServices[ii].date = Date()
                            }
                            
                            SaveContext()
                        }
                        
                    }
                    
                    //calculate
                    
                    let next = (savedCarServices[ii].amount + savedCarServices[ii].amountService)
                    
                    let progress =
                        savedCars[i].amount >= next ?
                    0 :
                        next - savedCars[i].amount
                    
                    var percent: Int32 = 0
                    
                    if(savedCarServices[ii].amountService > 0) {
                        percent = 100 - (progress * 100 / savedCarServices[ii].amountService)
                    } else {
                        percent = 100
                    }
                    
                    let nextMonth = (Calendar.current.date(byAdding: .month, value: Int(savedCarServices[ii].month), to: savedCarServices[ii].date!)!)
                    
                 
                    
                    let progressMonth =
                        Date() >= nextMonth ?
                        Int32(savedCarServices[ii].month) :
                        Int32(savedCarServices[ii].month) - Int32(Calendar.current.dateComponents([.month], from: Date(), to: nextMonth).month!)
                    
                    var percentMonth: Int32 = 0
                    
                    if(savedCarServices[ii].month > 0) {
                        percentMonth = progressMonth * 100 / savedCarServices[ii].month
                    } else {
                        percentMonth = 100
                    }
                    
                    if(percent > 99 || percentMonth > 99) {
                        savedCars[i].alert = true
                    }

                }
                
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


