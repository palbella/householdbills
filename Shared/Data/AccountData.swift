//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class AccountData: ObservableObject {
    @Published var items = [AccountModel]()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    @ObservedObject var fetchCurrencies = FetchCurrencies()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var accountsFetch: FetchedResults<Account>

    let request: NSFetchRequest<Account> = Account.fetchRequest()
  

    
    init() {
        self.items = []
       
    }
    
    func fetch() ->  [AccountModel]{
        
        do {
        let savedAccounts = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedAccounts.count {
                self.items.append(map(account: savedAccounts[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    func addAccount(account: AccountModel)
    {
      
            withAnimation {
                
                let newAccount = Account(context: viewContext)
                  newAccount.id = UUID()
                  newAccount.name = account.name
                newAccount.amount = account.amount
                newAccount.symbol = account.symbol
                newAccount.currency = account.currency
                newAccount.iconColor = account.iconColor
                newAccount.iconContent = account.iconContent
                newAccount.type = account.type
                newAccount.ignoreGoal = account.ignoreGoal
                

      SaveContext()
                
               
            }
        
     

    }
    
    func updateAccount(account: AccountModel)
    {
      
          
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", account.id as CVarArg)
                
                let savedAccount = try  self.viewContext.fetch(request)[0]
                
                savedAccount.name = account.name
            if(account.type != "crypto") {
                savedAccount.amount = account.amount
            }
            savedAccount.symbol = account.symbol
            savedAccount.currency = account.currency
            savedAccount.amount = account.amount
            savedAccount.iconColor = account.iconColor
            savedAccount.iconContent = account.iconContent
            savedAccount.type = account.type
            savedAccount.ignoreGoal = account.ignoreGoal
            
            
        } catch {
            print(error)
        }

      SaveContext()
    

    }
    
    func transferAccount(destination: UUID, amount: Double, currencyFrom: String)
    {
        let currencies = GetCurrencies()
        currencies.items = fetchCurrencies.fetch(viewContext: viewContext)
       
        do {
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", destination as CVarArg)
                
                let savedAccount = try  self.viewContext.fetch(request)[0]
            
            let amountConverted: Double = currencies.convert(currencyFrom: currencyFrom, currencyTo: savedAccount.currency!, value: abs(amount))
                
            savedAccount.amount = savedAccount.amount + amountConverted
            
            
            
        } catch {
            print(error)
        }

      SaveContext()
  

    }
    
   
    
    func deleteAccount(account: AccountModel)
    {
      
            withAnimation {
                
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", account.id as CVarArg)
               

                    do {
                        let savedAccounts = try  self.viewContext.fetch(request)
                        
                        for account in savedAccounts {
                            self.viewContext.delete(account)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }
                
            }

        
       
    }
   
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
    func map(account: Account) -> AccountModel
    {
        var accountModel = AccountModel()
        
        accountModel.id = account.id!
        accountModel.name = account.name ?? ""
        accountModel.symbol = account.symbol ?? ""
        accountModel.currency = account.currency ?? ""
        accountModel.amount = account.amount
        accountModel.iconColor = account.iconColor ?? ""
        accountModel.iconContent = account.iconContent ?? ""
        accountModel.type = account.type!
        accountModel.ignoreGoal = account.ignoreGoal

        return accountModel
    }
    
   
}
