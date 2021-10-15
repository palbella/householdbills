//
//  AccountModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/27/21.
//

import SwiftUI
import CoreData




class FetchCategories: ObservableObject {
    @Published var items = [CategoryModel]()
   

    let request: NSFetchRequest<Category> = Category.fetchRequest()
  
    
    
    init() {
        self.items = []
    }
    
    func fetch(viewContext: NSManagedObjectContext) ->  [CategoryModel]{
        
        do {
        let savedCategories = try  viewContext.fetch(request)
        self.items = []
            
            for i in 0..<savedCategories.count {
                self.items.append(map(category: savedCategories[i]))
            }
            
        } catch {
            
        }
    
        return self.items
    }
    
    private func map(category: Category) -> CategoryModel
    {
        var categoryModel = CategoryModel()
        
        categoryModel.id = category.id
        categoryModel.name = LocalizedStringKey(category.name ?? "").toString()
        categoryModel.iconColor = category.iconColor ?? ""
        categoryModel.iconContent = category.iconContent ?? ""

        return categoryModel
    }
    
   
}
