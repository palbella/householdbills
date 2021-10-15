//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchAccounts: ObservableObject {
    @Published var items = [AccountModel]()
   

    let request: NSFetchRequest<Account> = Account.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext) ->  [AccountModel]{
        
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
    
    private func map(account: Account) -> AccountModel
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
