//
//  MainView.swift
//  Household Bills
//
//  Created by Pablo Albella on 8/15/21.
//

import UIKit
import BackgroundTasks



class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
        completionHandler(.newData)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           if #available(iOS 13, *) {
               BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.householdbills.schedule.task", using: nil) { task in
                  
                   BackgroundThreadTask().run()
                   
                   task.setTaskCompleted(success: true)
                   BackgroundThreadTask().scheduleAppRefresh()
               }
           }
        
        BackgroundThreadTask().scheduleAppRefresh()

        return true
       }
    

    
    func sceneDidEnterBackground(_ application: UIApplication) {
     
        if #available(iOS 13, *) {
            NotificationTask().run(title: "BackTriger", subtitle: "back")

            BackgroundThreadTask().scheduleAppRefresh()
       
        }
    }


}
