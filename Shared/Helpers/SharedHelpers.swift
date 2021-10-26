//
//  Helpers.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI


class EmailHelper: NSObject {
    static let shared = EmailHelper()
    private override init() {}
}



func getMonthName(monthNumber: Int32) -> String {
    
    if (monthNumber == 1) {
        return "January"
    }
    if (monthNumber == 2) {
        return "February"
    }
    if (monthNumber == 3) {
        return "March"
    }
    if (monthNumber == 4) {
        return "April"
    }
    if (monthNumber == 5) {
        return "May"
    }
    if (monthNumber == 6) {
        return "June"
    }
    if (monthNumber == 7) {
        return "July"
    }
    if (monthNumber == 8) {
        return "August"
    }
    if (monthNumber == 9) {
        return "September"
    }
    if (monthNumber == 10) {
        return "October"
    }
    if (monthNumber == 11) {
        return "November"
    }
    if (monthNumber == 12) {
        return "December"
    }
    
    return ""
}



func removeTimeStamp(fromDate: Date) -> Date {
   guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
       fatalError("Failed to strip time from Date object")
   }
   return date
}
