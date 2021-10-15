//
//  BackgroundThreadTask.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/1/21.
//

import Foundation
import CoreData
import UserNotifications
import UIKit
import BackgroundTasks

class BackgroundThreadTask: ObservableObject {

    let persistenceController = PersistenceController.shared
    let settingsRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
    let viewContext : NSManagedObjectContext
    
    init() {
        viewContext = persistenceController.container.viewContext
    }
    
    func run() {
        
        do {
        let savedSettings =  try viewContext.fetch(settingsRequest)
           
            if(savedSettings[0].notificationPayment) {
                paymentTask()
            }
            if(savedSettings[0].notificationService) {
                carTask()
            }
            if(savedSettings[0].notificationCrypto) {
                GetMarketCriptocurrencies(viewContext: persistenceController.container.viewContext, notification: true).run()
            }
        
        } catch {
            
        }
        
        
     
    }
    
    
    func paymentTask () {
        do {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        let savedPayments = try  viewContext.fetch(request)
           
            for i in 0..<savedPayments.count {
               
                if(Date().get(.day) >= savedPayments[i].notificationDay && savedPayments[i].notificated != true && savedPayments[i].isPaid != true) {
                    NotificationTask().run(title: "Payment Notification", subtitle: savedPayments[i].name!)
                    savedPayments[i].notificated = true
                    SaveContext ()
                }
            }
            
        } catch {
            
        }
    }
    
    func carTask() {
        GetCarAlerts(viewContext: viewContext).run()
        do {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        let savedCars = try  viewContext.fetch(request)
            
            for i in 0..<savedCars.count {
                if(savedCars[i].alert && savedCars[i].notificated != true) {
                    NotificationTask().run(title: "Car Service", subtitle: savedCars[i].name!)
                    savedCars[i].notificated = true
                    SaveContext ()
                }
            }
            
        } catch {
            
        }
    }
    

    
   
    
    
    @available(iOS 13.0, *)
       func scheduleAppRefresh() {
           
//           BGTaskScheduler.shared.cancelAllTaskRequests()
           
           let request = BGAppRefreshTaskRequest(identifier: "com.householdbills.schedule.task")

           request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 3 ) // Refresh after 3 hours.

           BGTaskScheduler.shared.getPendingTaskRequests { tasks in
               
               if(tasks.count < 2) {
                   do {
                      
                       try BGTaskScheduler.shared.submit(request)
                   } catch {
                       print("Could not schedule app refresh task \(error.localizedDescription)")
                   }
               }
           }
           
          
       }
    
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
        print(error)
    }
    }
}
