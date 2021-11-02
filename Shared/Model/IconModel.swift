//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI


struct IconClass: Hashable, Identifiable {

     var id: Int
     var name: String
    var content: String

    init(id: Int, name: String, content: String) {
        self.id = id
        self.name = name
        self.content = content
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.content = ""
    }
}


struct IconColor: Hashable, Identifiable {

     var id: Int
     var name: String
    var content: String

    init(id: Int, name: String, content: String) {
        self.id = id
        self.name = name
        self.content = content
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.content = ""
    }
}


class GetIcons: ObservableObject {
    @Published var items = [IconClass]()

    init() {
        self.items = [
            IconClass(id: 0, name: LocalizedStringKey("Wallet").toString(), content: "wallet"),
            IconClass(id: 1, name: LocalizedStringKey("Bank").toString(), content: "bank"),
            IconClass(id: 2, name: LocalizedStringKey("Bitcoin").toString(), content: "bitcoinsign.circle"),
            IconClass(id: 3, name: LocalizedStringKey("Vacation").toString(), content: "vacation"),
            IconClass(id: 4, name: LocalizedStringKey("Car").toString(), content: "car"),
            IconClass(id: 5, name: LocalizedStringKey("House").toString(), content: "house"),
            IconClass(id: 6, name: LocalizedStringKey("Food & Market").toString(), content: "cart"),
            IconClass(id: 7, name: LocalizedStringKey("Camera").toString(), content: "camera"),
            IconClass(id: 8, name: LocalizedStringKey("Internet").toString(), content: "wifi"),
            IconClass(id: 9, name: LocalizedStringKey("Light").toString(), content: "lightbulb"),
            IconClass(id: 10, name: LocalizedStringKey("Apple").toString(), content: "apple"),
            IconClass(id: 11, name: LocalizedStringKey("Movies").toString(), content: "movies"),
            IconClass(id: 12, name: LocalizedStringKey("Stocks").toString(), content: "stocks"),
            IconClass(id: 13, name: LocalizedStringKey("Phone").toString(), content: "smartphone"),
            IconClass(id: 14, name: LocalizedStringKey("Travel").toString(), content: "airplane"),
            IconClass(id: 15, name: LocalizedStringKey("Entertainment").toString(), content: "gamecontroller"),
            IconClass(id: 16, name: LocalizedStringKey("Chart").toString(), content: "chart.pie"),
            IconClass(id: 17, name: LocalizedStringKey("Gift").toString(), content: "gift"),
            IconClass(id: 18, name: LocalizedStringKey("Education").toString(), content: "education"),
            IconClass(id: 19, name: LocalizedStringKey("Sports").toString(), content: "sportscourt"),
            IconClass(id: 20, name: LocalizedStringKey("Health").toString(), content: "health"),
            IconClass(id: 21, name: LocalizedStringKey("Pets").toString(), content: "pets"),
            IconClass(id: 22, name: LocalizedStringKey("Services").toString(), content: "gear"),
            IconClass(id: 23, name: LocalizedStringKey("Technology").toString(), content: "devices"),
            IconClass(id: 24, name: LocalizedStringKey("Home").toString(), content: "home"),
            IconClass(id: 25, name: LocalizedStringKey("Subscriptions").toString(), content: "icloud"),
            IconClass(id: 26, name: LocalizedStringKey("Gastronomy").toString(), content: "restaurant"),
            IconClass(id: 27, name: LocalizedStringKey("Children").toString(), content: "children"),
            IconClass(id: 28, name: LocalizedStringKey("Donation").toString(), content: "dongsign.circle"),
            IconClass(id: 29, name: LocalizedStringKey("Delivery").toString(), content: "shuttle"),
            IconClass(id: 30, name: LocalizedStringKey("Work").toString(), content: "briefcase"),
            IconClass(id: 31, name: LocalizedStringKey("Electricity").toString(), content: "electricity"),
            IconClass(id: 32, name: LocalizedStringKey("Water").toString(), content: "water"),
            IconClass(id: 33, name: LocalizedStringKey("Fire").toString(), content: "fire"),
            IconClass(id: 34, name: LocalizedStringKey("Credit Card").toString(), content: "creditcard"),
            IconClass(id: 35, name: LocalizedStringKey("Bars").toString(), content: "bar"),
            
        ]
    }
}



class GetColors: ObservableObject {
    @Published var items = [IconColor]()

    init() {
        self.items = [
            IconColor(id: 0, name: LocalizedStringKey("Blue").toString(), content: "blue"),
            IconColor(id: 1, name: LocalizedStringKey("Light Blue").toString(), content: "lightBlue"),
            IconColor(id: 2, name: LocalizedStringKey("Dark Blue").toString(), content: "darkBlue"),
            IconColor(id: 3, name: LocalizedStringKey("Yellow").toString(), content: "yellow"),
            IconColor(id: 4, name: LocalizedStringKey("Red").toString(), content: "red"),
            IconColor(id: 5, name: LocalizedStringKey("Light Red").toString(), content: "lightRed"),
            IconColor(id: 6, name: LocalizedStringKey("Dark Red").toString(), content: "darkRed"),
            IconColor(id: 7, name: LocalizedStringKey("Green").toString(), content: "green"),
            IconColor(id: 8, name: LocalizedStringKey("Orange").toString(), content: "orange"),
            IconColor(id: 9, name: LocalizedStringKey("Purple").toString(), content: "purple"),
            IconColor(id: 10, name: LocalizedStringKey("Gray").toString(), content: "gray"),
            IconColor(id: 11, name: LocalizedStringKey("Brown").toString(), content: "brown"),
            
           
        ]
    }
}
