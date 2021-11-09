//
//  InitialDataTask.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/20/21.
//

import SwiftUI
import CoreData


struct InitialData {
    @State var viewContext: NSManagedObjectContext
  
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
    }
    
    func run(password: String, name: String, email: String) {
        initialSettings(password: password, name: name, email: email)
        initialDataCards()
        initialDataCategories()
        initialCurrencies()
        initialMonth()
        initialAccount()
        initialMigration()
    }
    
    
    func initialSettings(password: String, name: String, email: String) {

        
        let newSetting = Settings(context: viewContext)
        
        newSetting.password = password
        newSetting.email = email
        newSetting.name = name
        newSetting.symbol = "$"
        newSetting.unit = "Km"
        newSetting.currency = "USD"
        newSetting.subscribed = false
        newSetting.showMonthBalance = true
        newSetting.dayChangeMonth = 28
        newSetting.monthIncome = 0
        
        
        SaveContext()
       
    }
    
    
    func initialMonth() {

        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM y"
        
        let newMonth = Month(context: viewContext)
        
        newMonth.id = UUID()
        newMonth.name = formatter.string(from: today)
        newMonth.initialAmount = 0
        newMonth.finalAmount = 0
        newMonth.month = Int32(Date().get(.month))
        newMonth.year = Int32(Date().get(.year))
        newMonth.timestamp = Date()
        newMonth.current = true
        
        
        SaveContext()
       
    }
    
    func initialAccount() {
        
        let accountId = UUID()
        let newAccount = Account(context: viewContext)
        
        newAccount.id = accountId
        newAccount.name = LocalizedStringKey("Bank").toString()
        newAccount.amount = 0
        newAccount.currency = "USD"
        newAccount.symbol = "$"
        newAccount.type = "saving"
        newAccount.iconColor = "blue"
        newAccount.iconContent = "bank"
        newAccount.timestamp = Date()
        
        
        SaveContext()
        
        
        let newMonthlyPayment = MonthlyPayment(context: viewContext)
        
        newMonthlyPayment.id = UUID()
        newMonthlyPayment.name = LocalizedStringKey("Internet").toString()
        newMonthlyPayment.amount = 0
        newMonthlyPayment.currency = "USD"
        newMonthlyPayment.symbol = "$"
        newMonthlyPayment.iconColor = "red"
        newMonthlyPayment.iconContent = "wifi"
        newMonthlyPayment.account = accountId
        newMonthlyPayment.timestamp = Date()
        
        
        SaveContext()
        
        
        let newPayment = Payment(context: viewContext)
        
        newPayment.id = UUID()
        newPayment.name = LocalizedStringKey("Internet").toString()
        newPayment.amount = 0
        newPayment.currency = "USD"
        newPayment.symbol = "$"
        newPayment.iconColor = "red"
        newPayment.iconContent = "wifi"
        newPayment.account = accountId
        newPayment.timestamp = Date()
        newPayment.monthlyId = newMonthlyPayment.id
        
        
        SaveContext()
        
        
        let newMonthlyBudget = MonthlyBudget(context: viewContext)
        
        newMonthlyBudget.id = UUID()
        newMonthlyBudget.name = LocalizedStringKey("Bars & Restaurants").toString()
        newMonthlyBudget.amount = 0
        newMonthlyBudget.currency = "USD"
        newMonthlyBudget.symbol = "$"
        newMonthlyBudget.iconColor = "red"
        newMonthlyBudget.iconContent = "bar"
        newMonthlyBudget.timestamp = Date()
        
        
        SaveContext()
        
        
        let newBudget = Budget(context: viewContext)
        
        newBudget.id = UUID()
        newBudget.name = LocalizedStringKey("Bars & Restaurants").toString()
        newBudget.amount = 0
        newBudget.currency = "USD"
        newBudget.symbol = "$"
        newBudget.iconColor = "red"
        newBudget.iconContent = "bar"
        newBudget.timestamp = Date()
        newBudget.monthlyId = newMonthlyBudget.id
        
        
        SaveContext()
        
      
        let newMonthlyPurchase = MonthlyPurchase(context: viewContext)
        
        newMonthlyPurchase.id = UUID()
        newMonthlyPurchase.name = LocalizedStringKey("Food & Groceries").toString()
        newMonthlyPurchase.amount = 0
        newMonthlyPurchase.currency = "USD"
        newMonthlyPurchase.symbol = "$"
        newMonthlyPurchase.iconColor = "red"
        newMonthlyPurchase.iconContent = "cart"
        newMonthlyPurchase.timestamp = Date()
        
        
        SaveContext()
        
        let newPurchase = Purchase(context: viewContext)
        
        newPurchase.id = UUID()
        newPurchase.name = LocalizedStringKey("Food & Groceries").toString()
        newPurchase.amount = 0
        newPurchase.currency = "USD"
        newPurchase.symbol = "$"
        newPurchase.iconColor = "red"
        newPurchase.iconContent = "cart"
        newPurchase.timestamp = Date()
        newPurchase.monthlyId = newMonthlyPurchase.id
        
        
        SaveContext()
        
      
       
    }
    
    
    
    func initialCurrencies() {

        
        let newCurrencyUSD = Currency(context: viewContext)
        
        newCurrencyUSD.id = 0
        newCurrencyUSD.symbol = "$"
        newCurrencyUSD.code = "USD"
        newCurrencyUSD.name = "Dollar (United States)"
        newCurrencyUSD.rate = 1
        newCurrencyUSD.update = false
        newCurrencyUSD.selected = true
        
        SaveContext()
        
        let newCurrencyEUR = Currency(context: viewContext)
        
        newCurrencyEUR.id = 1
        newCurrencyEUR.symbol = "€"
        newCurrencyEUR.code = "EUR"
        newCurrencyEUR.name = "Euro (Europe)"
        newCurrencyEUR.rate = 0.85
        newCurrencyEUR.update = false
        newCurrencyEUR.selected = true
        
        SaveContext()
        
        
        let newCurrencyGBP = Currency(context: viewContext)
        
        newCurrencyGBP.id = 2
        newCurrencyGBP.symbol = "£"
        newCurrencyGBP.code = "GBP"
        newCurrencyGBP.name = "Pound (British)"
        newCurrencyGBP.rate = 0.73
        newCurrencyGBP.update = false
        newCurrencyGBP.selected = false
        
        SaveContext()
        
        let newCurrencyCNY = Currency(context: viewContext)
        
        newCurrencyCNY.id = 3
        newCurrencyCNY.symbol = "¥"
        newCurrencyCNY.code = "CNY"
        newCurrencyCNY.name = "Yuan (Chinese)"
        newCurrencyCNY.rate = 6.43
        newCurrencyCNY.update = false
        newCurrencyCNY.selected = false
        
        SaveContext()
        
        
        let newCurrencyCUS = Currency(context: viewContext)
        
        newCurrencyCUS.id = 4
        newCurrencyCUS.symbol = "$"
        newCurrencyCUS.code = "CUSTOM"
        newCurrencyCUS.name = "Custom (Generic)"
        newCurrencyCUS.rate = 1
        newCurrencyCUS.update = false
        newCurrencyCUS.selected = false
        
        SaveContext()
        
        let newCurrencyARS = Currency(context: viewContext)
        
        newCurrencyARS.id = 5
        newCurrencyARS.symbol = "$"
        newCurrencyARS.code = "ARS"
        newCurrencyARS.name = "Peso (Argentine)"
        newCurrencyARS.rate = 180
        newCurrencyARS.update = false
        newCurrencyARS.selected = false
        
        SaveContext()
        
        let newCurrencyAUD = Currency(context: viewContext)
        
        newCurrencyAUD.id = 6
        newCurrencyAUD.symbol = "$"
        newCurrencyAUD.code = "AUD"
        newCurrencyAUD.name = "Dollar (Australian)"
        newCurrencyAUD.rate = 73.1
        newCurrencyAUD.update = false
        newCurrencyAUD.selected = false
        
        SaveContext()
       
        
        let newCurrencyBOB = Currency(context: viewContext)
        
        newCurrencyBOB.id = 7
        newCurrencyBOB.symbol = "Bs."
        newCurrencyBOB.code = "BOB"
        newCurrencyBOB.name = "Boliviano (Bolivian)"
        newCurrencyBOB.rate = 6.92
        newCurrencyBOB.update = false
        newCurrencyBOB.selected = false
        
        SaveContext()
        
        let newCurrencyBRL = Currency(context: viewContext)
        
        newCurrencyBRL.id = 8
        newCurrencyBRL.symbol = "R$"
        newCurrencyBRL.code = "BRL"
        newCurrencyBRL.name = "Real (Brazilian)"
        newCurrencyBRL.rate = 5.51
        newCurrencyBRL.update = false
        newCurrencyBRL.selected = false
        
        SaveContext()
        
        let newCurrencyCAD = Currency(context: viewContext)
        
        newCurrencyCAD.id = 9
        newCurrencyCAD.symbol = "$"
        newCurrencyCAD.code = "CAD"
        newCurrencyCAD.name = "Dollar (Canadian)"
        newCurrencyCAD.rate = 1.24
        newCurrencyCAD.update = false
        newCurrencyCAD.selected = false
        
        SaveContext()
        
        let newCurrencyCLP = Currency(context: viewContext)
        
        newCurrencyCLP.id = 10
        newCurrencyCLP.symbol = "$"
        newCurrencyCLP.code = "CPL"
        newCurrencyCLP.name = "Peso (Chilean)"
        newCurrencyCLP.rate = 815.21
        newCurrencyCLP.update = false
        newCurrencyCLP.selected = false
        
        SaveContext()
        
        let newCurrencyCOP = Currency(context: viewContext)
        
        newCurrencyCOP.id = 11
        newCurrencyCOP.symbol = "$"
        newCurrencyCOP.code = "COP"
        newCurrencyCOP.name = "Peso (Colombian)"
        newCurrencyCOP.rate = 3740
        newCurrencyCOP.update = false
        newCurrencyCOP.selected = false
        
        SaveContext()
        
        let newCurrencyCRC = Currency(context: viewContext)
        
        newCurrencyCRC.id = 12
        newCurrencyCRC.symbol = "₡"
        newCurrencyCRC.code = "CRC"
        newCurrencyCRC.name = "Colon (Costa Rican)"
        newCurrencyCRC.rate = 624.78
        newCurrencyCRC.update = false
        newCurrencyCRC.selected = false
        
        SaveContext()
        
        
        let newCurrencyJPY = Currency(context: viewContext)
        
        newCurrencyJPY.id = 13
        newCurrencyJPY.symbol = "¥"
        newCurrencyJPY.code = "JPY"
        newCurrencyJPY.name = "Yen (Japanese)"
        newCurrencyJPY.rate = 113.53
        newCurrencyJPY.update = false
        newCurrencyJPY.selected = false
        
        SaveContext()
        
        
        let newCurrencyMXN = Currency(context: viewContext)
        
        newCurrencyMXN.id = 14
        newCurrencyMXN.symbol = "$"
        newCurrencyMXN.code = "MXN"
        newCurrencyMXN.name = "Peso (Mexican)"
        newCurrencyMXN.rate = 20.56
        newCurrencyMXN.update = false
        newCurrencyMXN.selected = false
        
        SaveContext()
        
        let newCurrencyNZD = Currency(context: viewContext)
        
        newCurrencyNZD.id = 15
        newCurrencyNZD.symbol = "$"
        newCurrencyNZD.code = "NZD"
        newCurrencyNZD.name = "Dollar (New Zealand)"
        newCurrencyNZD.rate = 1.43
        newCurrencyNZD.update = false
        newCurrencyNZD.selected = false
        
        SaveContext()
        
        
        let newCurrencyPYG = Currency(context: viewContext)
        
        newCurrencyPYG.id = 16
        newCurrencyPYG.symbol = "₲"
        newCurrencyPYG.code = "PYG"
        newCurrencyPYG.name = "Guarani (Paraguayan)"
        newCurrencyPYG.rate = 6878.98
        newCurrencyPYG.update = false
        newCurrencyPYG.selected = false
        
        SaveContext()
        
        let newCurrencyHKD = Currency(context: viewContext)
        
        newCurrencyHKD.id = 17
        newCurrencyHKD.symbol = "$"
        newCurrencyHKD.code = "HKD"
        newCurrencyHKD.name = "Dollar (Hong Kong)"
        newCurrencyHKD.rate = 7.78
        newCurrencyHKD.update = false
        newCurrencyHKD.selected = false
        
        SaveContext()
        
        let newCurrencyINR = Currency(context: viewContext)
        
        newCurrencyINR.id = 18
        newCurrencyINR.symbol = "₹"
        newCurrencyINR.code = "INR"
        newCurrencyINR.name = "Rupee (Indian)"
        newCurrencyINR.rate = 75.26
        newCurrencyINR.update = false
        newCurrencyINR.selected = false
        
        SaveContext()
        
        let newCurrencyPEN = Currency(context: viewContext)
        
        newCurrencyPEN.id = 19
        newCurrencyPEN.symbol = "S/."
        newCurrencyPEN.code = "PEN"
        newCurrencyPEN.name = "Sol (Peruvian)"
        newCurrencyPEN.rate = 4.03
        newCurrencyPEN.update = false
        newCurrencyPEN.selected = false
        
        SaveContext()
        
        let newCurrencyRUB = Currency(context: viewContext)
        
        newCurrencyRUB.id = 20
        newCurrencyRUB.symbol = "₽"
        newCurrencyRUB.code = "RUB"
        newCurrencyRUB.name = "Ruble (Russian)"
        newCurrencyRUB.rate = 72.04
        newCurrencyRUB.update = false
        newCurrencyRUB.selected = false
        
        SaveContext()
        
    }
    
    
    func initialDataCards()
    {
        
        let newCardBalance = Card(context: viewContext)
      
        newCardBalance.name = "Month Available Balance"
        newCardBalance.id = 0
        newCardBalance.order = 0
        newCardBalance.visible = true
     
 SaveContext()
        
        let newCardAccount = Card(context: viewContext)
      
        newCardAccount.name = "Accounts"
        newCardAccount.id = 1
        newCardAccount.order = 1
        newCardAccount.visible = true
     
 SaveContext()
        
        let newCardGoal = Card(context: viewContext)
      
        newCardGoal.name = "Goals"
        newCardGoal.id = 2
        newCardGoal.order = 2
        newCardGoal.visible = true
     
 SaveContext()
        
        let newCardBudget = Card(context: viewContext)
      
        newCardBudget.name = "Budgets"
        newCardBudget.id = 3
        newCardBudget.order = 3
        newCardBudget.visible = true
     
 SaveContext()
        
        let newCardPayment = Card(context: viewContext)
      
        newCardPayment.name = "Payments"
        newCardPayment.id = 4
        newCardPayment.order = 4
        newCardPayment.visible = true
     
 SaveContext()
        
        
        
        let newCardPurchase = Card(context: viewContext)
      
        newCardPurchase.name = "Purchases"
        newCardPurchase.id = 5
        newCardPurchase.order = 5
        newCardPurchase.visible = true
     
 SaveContext()
        
        let newCardCars = Card(context: viewContext)
      
        newCardCars.name = "Cars"
        newCardCars.id = 6
        newCardCars.order = 6
        newCardCars.visible = true
     
 SaveContext()
        
        let newCardTask = Card(context: viewContext)
      
        newCardTask.name = "Tasks"
        newCardTask.id = 7
        newCardTask.order = 7
        newCardTask.visible = true
     
 SaveContext()
        
        let newCardChart = Card(context: viewContext)
      
        newCardChart.name = "Chart"
        newCardChart.id = 8
        newCardChart.order = 8
        newCardChart.visible = true
     
 SaveContext()
        
    }
    
    func initialDataCategories()
    {
        
        let newCategory = Category(context: viewContext)
        newCategory.name = "ALL"
        newCategory.id = 99
        newCategory.iconColor = "blue"
        newCategory.iconContent = "pencil"
        SaveContext()
        
        let newCategoryA = Category(context: viewContext)
        newCategoryA.name = "Services"
        newCategoryA.id = 0
        newCategoryA.iconColor = "gray"
        newCategoryA.iconContent = "gear"
        SaveContext()
        
        let newCategoryB = Category(context: viewContext)
        newCategoryB.name = "Others"
        newCategoryB.id = 1
        newCategoryB.iconColor = "brown"
        newCategoryB.iconContent = "paperclip"
        SaveContext()
        
        let newCategoryC = Category(context: viewContext)
        newCategoryC.name = "Market & Food"
        newCategoryC.id = 2
        newCategoryC.iconColor = "red"
        newCategoryC.iconContent = "cart"
        SaveContext()
        
        let newCategoryD = Category(context: viewContext)
        newCategoryD.name = "Shopping"
        newCategoryD.id = 3
        newCategoryD.iconColor = "red"
        newCategoryD.iconContent = "camera.on.rectangle"
        SaveContext()
        
        let newCategoryE = Category(context: viewContext)
        newCategoryE.name = "Transport"
        newCategoryE.id = 4
        newCategoryE.iconColor = "blue"
        newCategoryE.iconContent = "station"
        SaveContext()
        
        let newCategoryF = Category(context: viewContext)
        newCategoryF.name = "Technology"
        newCategoryF.id = 5
        newCategoryF.iconColor = "yellow"
        newCategoryF.iconContent = "devices"
        SaveContext()
        
        let newCategoryG = Category(context: viewContext)
        newCategoryG.name = "Home"
        newCategoryG.id = 6
        newCategoryG.iconColor = "purple"
        newCategoryG.iconContent = "house"
        SaveContext()
        
        let newCategoryH = Category(context: viewContext)
        newCategoryH.name = "Subscriptions"
        newCategoryH.id = 7
        newCategoryH.iconColor = "red"
        newCategoryH.iconContent = "icloud"
        SaveContext()
        
        let newCategoryI = Category(context: viewContext)
        newCategoryI.name = "Gastronomy"
        newCategoryI.id = 8
        newCategoryI.iconColor = "yellow"
        newCategoryI.iconContent = "restaurant"
        SaveContext()
        
        let newCategoryJ = Category(context: viewContext)
        newCategoryJ.name = "ATM"
        newCategoryJ.id = 9
        newCategoryJ.iconColor = "blue"
        newCategoryJ.iconContent = "dollarsign.circle"
        SaveContext()
        
        let newCategoryK = Category(context: viewContext)
        newCategoryK.name = "Personal Care"
        newCategoryK.id = 10
        newCategoryK.iconColor = "green"
        newCategoryK.iconContent = "health"
        SaveContext()
        
        let newCategoryL = Category(context: viewContext)
        newCategoryL.name = "Travels"
        newCategoryL.id = 11
        newCategoryL.iconColor = "orange"
        newCategoryL.iconContent = "airplane"
        SaveContext()
        
        let newCategoryM = Category(context: viewContext)
        newCategoryM.name = "Clothing"
        newCategoryM.id = 12
        newCategoryM.iconColor = "gray"
        newCategoryM.iconContent = "barcode"
        SaveContext()
        
        let newCategoryN = Category(context: viewContext)
        newCategoryN.name = "Entertainment"
        newCategoryN.id = 13
        newCategoryN.iconColor = "yellow"
        newCategoryN.iconContent = "gamecontroller"
        SaveContext()
        
        let newCategoryO = Category(context: viewContext)
        newCategoryO.name = "Bars"
        newCategoryO.id = 14
        newCategoryO.iconColor = "purple"
        newCategoryO.iconContent = "bar"
        SaveContext()
        
        let newCategoryP = Category(context: viewContext)
        newCategoryP.name = "Friends"
        newCategoryP.id = 15
        newCategoryP.iconColor = "darkBlue"
        newCategoryP.iconContent = "smiley"
        SaveContext()
        
        let newCategoryQ = Category(context: viewContext)
        newCategoryQ.name = "Pets"
        newCategoryQ.id = 16
        newCategoryQ.iconColor = "brown"
        newCategoryQ.iconContent = "pets"
        SaveContext()
        
        let newCategoryR = Category(context: viewContext)
        newCategoryR.name = "Family"
        newCategoryR.id = 17
        newCategoryR.iconColor = "lightRed"
        newCategoryR.iconContent = "wc"
        SaveContext()
        
        let newCategoryS = Category(context: viewContext)
        newCategoryS.name = "Children"
        newCategoryS.id = 18
        newCategoryS.iconColor = "brown"
        newCategoryS.iconContent = "children"
        SaveContext()
        
        let newCategoryT = Category(context: viewContext)
        newCategoryT.name = "Car"
        newCategoryT.id = 19
        newCategoryT.iconColor = "green"
        newCategoryT.iconContent = "car"
        SaveContext()
        
        let newCategoryU = Category(context: viewContext)
        newCategoryU.name = "Donation"
        newCategoryU.id = 20
        newCategoryU.iconColor = "orange"
        newCategoryU.iconContent = "dongsign.circle"
        SaveContext()
        
        let newCategoryV = Category(context: viewContext)
        newCategoryV.name = "Hobbies"
        newCategoryV.id = 21
        newCategoryV.iconColor = "blue"
        newCategoryV.iconContent = "camera"
        SaveContext()
        
        let newCategoryW = Category(context: viewContext)
        newCategoryW.name = "Delivery"
        newCategoryW.id = 22
        newCategoryW.iconColor = "red"
        newCategoryW.iconContent = "shuttle"
        SaveContext()
        
        let newCategoryX = Category(context: viewContext)
        newCategoryX.name = "Education"
        newCategoryX.id = 23
        newCategoryX.iconColor = "blue"
        newCategoryX.iconContent = "education"
        SaveContext()
        
        let newCategoryY = Category(context: viewContext)
        newCategoryY.name = "Sports"
        newCategoryY.id = 24
        newCategoryY.iconColor = "green"
        newCategoryY.iconContent = "sportscourt"
        SaveContext()
        
        let newCategoryZ = Category(context: viewContext)
        newCategoryZ.name = "Work"
        newCategoryZ.id = 25
        newCategoryZ.iconColor = "darkBlue"
        newCategoryZ.iconContent = "briefcase"
        SaveContext()
        
      
        
    }
    
    func initialMigration() {
        let newMigration = Migration(context: viewContext)
        newMigration.version = 1.0
        newMigration.number = 1
        newMigration.id = UUID()
        newMigration.date = Date()
      
        SaveContext()
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
}
