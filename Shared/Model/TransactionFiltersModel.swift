//
//  TransactionModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/29/21.
//

import Foundation

struct TransactionFiltersModel: Hashable {

   
     var name: String
    var account: String
    var startDate: Date
    var endDate: Date
    var category: Int32
 
    

    
    init() {
      
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDay: String = String(Date().get(.day))
        let currentMonth: String = String(Date().get(.month))
        let currentYear: Int = Int(Date().get(.year))
        let previousYear: String = String(currentYear - 1)
        let startDate:NSDate = dateFormatter.date(from: previousYear + "-" + currentMonth + "-" + currentDay)! as NSDate
       
        
        self.name = ""
        self.account = ""
        self.startDate = startDate as Date
        self.endDate = Date()
        self.category = 99
    }
    
}




class GetTransactionFilters: ObservableObject {
    @Published var items = [TransactionFiltersModel]()
    

    init() {
        self.items = [
        ]
    }
}
