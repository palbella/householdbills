    //
    //  DashboardBodyView.swift
    //  HouseholdBills (iOS)
    //
    //  Created by Pablo Albella on 8/17/21.
    //

    import SwiftUI
    import CoreData

    struct CarListView: View {
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject var settings: UserSettings
        @EnvironmentObject var ui: AppUI
        @Environment(\.managedObjectContext) private var viewContext
        
        
        @State var isShowing: Bool = false
        @State var isShowingNew: Bool = false
        @State var delete: Bool = false
       
        @State var carSelected : CarModel = CarModel()
        
        @State var services: [CarServiceModel] = []
  
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @State var now = Date()
        
        @ObservedObject var cars = GetCars()
        
        @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var carsFetch: FetchedResults<Car>
        
        @Binding var showSubscribe: Bool
      
        
        var body: some View {
            
           
                VStack(spacing: 0) {
                    
                    Section(header:
                                HStack {
                                    VStack{
                                        Spacer()
                                    Text("CARS")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 15)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 5)
                                    .font(.system(size: 12))
                                    .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                    }
                                    Spacer()
                                    
                                    VStack {
                                        Spacer()
                                        Button(action: {
                                            
                                            if(settings.subscribed || self.carsFetch.count < 1) {
                                                self.carSelected = CarModel()
                                                self.carSelected.iconContent = "car"
                                                self.carSelected.iconColor = "green"
                                                self.carSelected.symbol = settings.unit
                                                self.isShowingNew = true
                                                                      } else {
                                                                         
                                                                          self.showSubscribe = true
                                                                      }
                                            
                                          
                                        }) {
                                            
                                            CommandButton(content: "plus.circle")
                                        }
                                        .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                         
                                          
                                                           if(self.$carSelected.name.wrappedValue != "") {
                                                            addCar(car: self.$carSelected.wrappedValue)
                                                           }
                                                

                                            }) {
                                            CarAddView(car: self.$carSelected)
                                        }
                                        .frame(width: 15, height: 15)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 17)
                                        .padding(.bottom, 12)
                                    }
                                   
                                }
                              
                                
                    ) {

                        Divider()
                        
                      
                        
                        ForEach(self.carsFetch.indexed(), id: \.1.id) { index, item in
                            
                            let fontColor = item.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor
                            
                                                Button(action: {
                                                    self.carSelected = map(car: item)
                                                    self.services = []
                                                    self.delete = false
                                                    self.isShowing = true
                                                }) {
                                                    
                                                    VStack (spacing: 0) {
                                                        HStack (spacing: 0) {
                                                            Icon(content: item.iconContent!, color: getColor(color: item.iconColor!)).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                        
                                                            VStack (spacing: 0) {
                                                                Spacer()
                                                            HStack (spacing: 0) {
                                                                Text(item.name!)
                                                            .font(.system(size: 15))
                                                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                
                                                        Spacer()
                                                                
                                                                if(item.alert) {
                                                                    HStack(spacing: 0) {
                                                                    Text("Service")
                                                                            .frame(minWidth: 60)
                                                                        .font(.system(size: 12))
                                                                        .background(colorScheme != .dark ? Color.red: Color.red)
                                                                        .cornerRadius(40)
                                                                        .foregroundColor(.white)
                                                                        .padding(2)
                                                                        .overlay(
                                                                            RoundedRectangle(cornerRadius: 40)
                                                                                .stroke(colorScheme != .dark ? Color.red: Color.red, lineWidth: 1 )
                                                                        )
                                                                }
                                                                    .frame(width: 70, height: 29)
                                                                }
                                                                
                                                                
                                                                Text(item.symbol! + " " + String(item.amount)).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                            .foregroundColor(fontColor)
                                                            .font(.system(size: 15))
                                                                    .frame(minWidth: 130, alignment: .trailing)

                                                                
                                                            }
                                                                Spacer()
                                                             
                                                                
                                                            }
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                      
                                                    }
                                                    
                                                }
                                                .sheet(isPresented: self.$isShowing, onDismiss: {
                                                    
                                                    
                                                    if(self.delete) {
                                                        deleteCar(car: self.$carSelected.wrappedValue)
                                                    } else {

                                                        updateCar(car: self.$carSelected.wrappedValue)
                                                        GetCarAlerts(viewContext: viewContext).run()
                                                    }

                                                }) {
                                                  
                                                    CarUpdateView(car: self.$carSelected, modal: self.$isShowing, delete: self.$delete, services: self.$services)
                                                        .environmentObject(self.ui)
                                                            .environmentObject(self.settings)
                                                    
                              }
                            
                        }
                                        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                        
                        
                      
                        
                        Divider()
                        
              
                }
                
               
             
            }
                .onAppear {
//                    getCars()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//                    getCars()
                
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
//                    getCars()
                    }
//                .onReceive(timer) { _ in
//                    getCars()
//                           self.now = Date()
//                       }
              
              
                
        }
        
        
        

        
        func addCar(car: CarModel)
        {
          
                withAnimation {
                  
                    let newCar = Car(context: viewContext)
                    newCar.id = UUID()
                    newCar.name = car.name
                    newCar.amount = car.amount
                    newCar.symbol = car.symbol
                    newCar.iconColor = car.iconColor
                    newCar.iconContent = car.iconContent
                    newCar.notificated = false
                   

          SaveContext()
                }

        }
        
        func updateCar(car: CarModel)
        {
          
              
            do {
                    let request: NSFetchRequest<Car> = Car.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
                    
                    let savedCar = try  self.viewContext.fetch(request)[0]
                
               
                let requestCar: NSFetchRequest<CarServices> = CarServices.fetchRequest()
                requestCar.predicate = NSPredicate(format: "carId == %@", car.id as CVarArg)
                let savedCarServices = try  self.viewContext.fetch(requestCar)
                    
                savedCar.name = car.name
                savedCar.amount = car.amount
                savedCar.symbol = car.symbol
                savedCar.amount = car.amount
                savedCar.iconColor = car.iconColor
                savedCar.iconContent = car.iconContent
                savedCar.notificated = false
                
                for service in services {
                   
                    for carService in savedCarServices {
                        if(carService.id == service.id) {
                           
                            carService.date = service.date
                            carService.amount = service.amount
                     
                            
                            SaveContext()
                        }
                    }
                   
                    
                }
                
                
            } catch {
                print(error)
            }

          SaveContext()
                

        }
        
        func deleteCar(car: CarModel)
        {
           
                withAnimation {
                    
                    let request: NSFetchRequest<Car> = Car.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
                   
//                    let index = find(id: self.$carSelected.id.wrappedValue, in: self.cars.items)
//                    self.cars.items.remove(at: index)

                        do {
                            let savedCars = try  self.viewContext.fetch(request)
                            
                            for car in savedCars {
                                self.viewContext.delete(car)
                            }
                            try self.viewContext.save()
                        } catch {
                            print(error)
                        }
                    
                }
          
          
        }
        
        func SaveContext () {
        do {

      try viewContext.save()
            

            }
                                
        
        catch {
          
        }
        }
        
        func map(car: Car) -> CarModel
        {
            var carModel = CarModel()
            
            carModel.id = car.id!
            carModel.name = car.name ?? ""
            carModel.symbol = car.symbol ?? ""
            carModel.amount = car.amount
            carModel.alert = car.alert
            carModel.iconColor = car.iconColor ?? ""
            carModel.iconContent = car.iconContent ?? ""

            return carModel
        }
        
  
    }


//    #if DEBUG
//    struct AccountsView_Previews: PreviewProvider {
//
//        static var viewContext = PersistenceController.preview.container.viewContext
//
//
//        static var previews: some View {
//
//
//            AccountListView().environmentObject(UserSettings())
//                    .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//        }
//    }
//    #endif

    
    
    
    
 
   
  
