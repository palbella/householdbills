//
//  CurrencyTask.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData

struct CurrencyTask {
    @State var viewContext: NSManagedObjectContext
    
    let request: NSFetchRequest<Currency> = Currency.fetchRequest()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func run() {
        do {
            
            let savedCurrencies = try  viewContext.fetch(request)
            var query : String = ""

                            for index in 0..<savedCurrencies.count {
                              
                                    if(index != 0) {
                                        query = query + ","
                                    }
                                    query = query + savedCurrencies[index].code!.lowercased()
                                
                            }
            
            guard let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=tether&vs_currencies=" + query) else {
                print("Invalid url...")
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                var cotizations : [String: Any]?
                
                do{
                    if(data != nil) {
                        cotizations = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        
                        if(cotizations == nil) {
                            return
                        }
                        
                        for index in 0..<savedCurrencies.count {
                          
                            let cotization = cotizations!["tether"] as? [String: Any]
                            let cot = cotization![savedCurrencies[index].code!.lowercased()]
                            
                            if(cot != nil) {
                                savedCurrencies[index].rate = cot as! Double
                                SaveContext ()
                            }
                        }
                        
                    }
                }catch {
                    
                }
               
            }.resume()
                
        } catch {
            
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
