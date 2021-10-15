//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct PasswordModel: Hashable, Identifiable {

     var id: UUID
     var name: String
    var password: String
    var code: Int32


    
    init() {
        self.id = UUID()
        self.name = ""
        self.password = ""
        self.code = 0
    }
}



class GetPasswords: ObservableObject {
    @Published var items = [PasswordModel]()

    init() {
        self.items = [

        ]
    }
}
