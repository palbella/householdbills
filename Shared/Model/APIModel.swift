//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct APIModel: Hashable {

     var api: String
    var request: String
    var response: String
    var type: String
    var typeApi: String

    
    init() {
        self.api = ""
        self.request = ""
        self.response = ""
        self.type = ""
        self.typeApi = ""
        
    }
}


