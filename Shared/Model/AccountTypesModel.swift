//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct AccountType: Hashable, Identifiable {

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




class GetAccountTypes: ObservableObject {
    @Published var items = [AccountType]()

    init() {
        self.items = [
            AccountType(id: 0, name: LocalizedStringKey("Cash/Wallet").toString(), type: "cash"),
            AccountType(id: 1, name: LocalizedStringKey("Saving Bank Account").toString(), type: "saving"),
            AccountType(id: 2, name: LocalizedStringKey("Checking Bank Account").toString(), type: "checking"),
            AccountType(id: 3, name: LocalizedStringKey("Cryptocurrency Wallet").toString(), type: "crypto"),
            AccountType(id: 4, name: LocalizedStringKey("Stock Investment").toString(), type: "stock"),]
    }
}

