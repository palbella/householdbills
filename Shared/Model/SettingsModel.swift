//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct SettingsModel: Hashable {

     var subscribed: Bool
     var symbol: String
    var currency: String
    var currencyUpdate: Bool
    var dayChangeMonth: Int32
    var unit: String
    var notificationCrypto: Bool
    var notificationStock: Bool
    var notificationPayment: Bool
    var notificationService: Bool
    var showMonthBalance: Bool


    
    init() {
        self.symbol = ""
        self.currency = ""
        self.unit = ""
        self.dayChangeMonth = 0
        self.subscribed = false
        self.currencyUpdate = false
        self.notificationCrypto = false
        self.notificationStock = false
        self.notificationPayment = false
        self.notificationService = false
        self.showMonthBalance = false
    }
}


