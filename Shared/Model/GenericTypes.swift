//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct TransactionType: Hashable, Identifiable {

     var id: Int
     var name: String
    var type: String

    init(id: Int, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.type = ""
    }
}




class GetTransactionTypes: ObservableObject {
    @Published var items = [String]()
    @Published var names = [String]()

    init(type: String) {
        self.items = []
        
        if(type == "Account") {
            self.items = [
                LocalizedStringKey("Income").toString(),
                LocalizedStringKey("Expense").toString(),
                LocalizedStringKey("Transfer").toString()]
        }
        
        if(type == "Budget") {
            self.items = [
                LocalizedStringKey("Budget Adjustment").toString(),
                LocalizedStringKey("Income").toString(),
                LocalizedStringKey("Expense").toString()]
        }
        
        self.names = [
            LocalizedStringKey("Account Initial Balance").toString(),
            LocalizedStringKey("Account Closed Balance").toString(),
            LocalizedStringKey("Adjustment").toString(),
            LocalizedStringKey("Goal Initial Amount").toString(),
            LocalizedStringKey("Purchases").toString()
        ]
    }
}




class GetYesNo: ObservableObject {
    @Published var items = [String]()

    init() {
        self.items = [LocalizedStringKey("No").toString(), LocalizedStringKey("Yes").toString()]
        
    }
}


class GetPriorities: ObservableObject {
    @Published var items = [String]()

    init() {
        self.items = [
            "1", "2","3", "4","5", "6","7", "8","9", "10",
            "11", "12","13", "14","15", "16","17", "18","19", "20",
            "21", "22","23", "24","25", "26","27", "28","29", "30",
            "31", "32","33", "34","35", "36","37", "38","39", "40",
            "41", "42","43", "44","45", "46","47", "48","49", "50"]
        
    }
}

class GetDays: ObservableObject {
    @Published var items = [String]()

    init() {
        self.items = [
            "None", "1", "2","3", "4","5", "6","7", "8","9", "10",
            "11", "12","13", "14","15", "16","17", "18","19", "20",
            "21", "22","23", "24","25", "26","27", "28","29", "30",
            "31"]
        
    }
}


class GetGroups: ObservableObject {
    @Published var items = [String]()

    init() {
        self.items = [
            "", "A", "B", "C","D", "E"]
        
    }
}


struct BalanceChartModel: Hashable {

     var date: Date?
     var balance: Double?


    init() {
        self.date = nil
        self.balance = nil
    }
}
