//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI
import CoreData


struct CarUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var car: CarModel
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var delete: Bool
    
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @ObservedObject var units = GetUnits()
    
    @State var initialAmount: Int32 = 0
    @State var initialAmountFlag: Bool = false
    
    @State var onSettings: Bool = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var servicesFetch: FetchedResults<CarServices>
    
    @Binding var services: [CarServiceModel]
    
    @State var load: Bool = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    
    
    init(car: Binding<CarModel>, modal: Binding<Bool>, save: Binding<Bool>, delete: Binding<Bool>, services: Binding<[CarServiceModel]>, isShowingToast: Binding<Bool>, toastMessasge: Binding<String>, toastError: Binding<Bool>) {
           self._car = car
          
        self._modal = modal
        self._save = save
        self._delete = delete
        self._services = services
        self._isShowingToast = isShowingToast
        self._toastMessasge = toastMessasge
        self._toastError = toastError
        self.initialAmount = car.amount.wrappedValue
        
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    static let dateFormat: DateFormatter = {
           let formatter = DateFormatter()
           formatter.setLocalizedDateFormatFromTemplate("yyyy MMMM")
           return formatter
       }()
    
    var body: some View {
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
        
        NavigationView {
            
    
            
        VStack(spacing: 0) {
           
            HeaderTabTitleView(title: car.name)
           
            Form {
                

                
                VStack(spacing: 0){
                    
                    let fontAmount = car.amount >= 0 ? colorScheme != .dark ? ui.lightItemFontAmountColor: ui.darkItemFontAmountColor : colorScheme != .dark ? ui.lightItemNegativeFontAmountColor: ui.darkItemNegativeFontAmountColor

//                    let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
//                    let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
                    
                    NumericField(
                        "Amount", symbol: car.symbol,
                                value: Binding(get: {
                                    return Decimal(car.amount) as NSDecimalNumber
                                }, set: { number in
                                    var result: Double = 0
                                    if(number != nil) {
                                        result = Double(truncating: number!.int32Value as NSNumber).truncate(places: 0)
                                    }

                                    car.amount = Int32(result)
                                }),
                        foregroundColor: UIColor(fontAmount),
                        font: ui.subtitle,
                        textAlignment: .center
                            )
                    .padding()
                   
                    if(load == true)
                    {
                        ForEach(self.services.indexed(), id: \.1) { index, item in
                           
                        Section(header:
                                    HStack {
                                        VStack{
                                       
                                            Text(self.services[index].name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 15)
                                        .padding(.leading, 10)
                                        .padding(.bottom, 5)
                                        .font(.system(size: 15).bold())
                                            Divider()
                                        }
                               
                                       
                                    }
                                  
                        ) {
                            NumericInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Last Service " + settings.unit, value: self.$services[index].amount, symbol: self.$settings.unit)
                            DateInput(labelColor: labelColor, fontColor: fontColor, iconContent: "", iconColor: .blue, label: "Last Service Date", value: self.$services[index].date)
                            
                            Text("")
                            
                            HStack (spacing: 0) {
                                Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                   

                            Text("Next Service " + settings.unit)
                                .foregroundColor(labelColor)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 15))

                            Spacer()
                                Text(String(self.$services[index].amount.wrappedValue + self.$services[index].serviceAmount.wrappedValue))
                                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                                .multilineTextAlignment(.leading)
                                    .font(.system(size: 12))
                                    .fixedSize(horizontal: false, vertical: true)
                        }
                            
                            HStack (spacing: 0) {
                                Icon(content: "info", color: Color.blue).padding(5).padding(.leading, 5).padding(.trailing, 5)
                              

                            Text("Next Service Date")
                                .foregroundColor(labelColor)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 15))

                            Spacer()

                                Text("\(Calendar.current.date(byAdding: .month, value: Int(self.$services[index].months.wrappedValue), to: self.$services[index].date.wrappedValue)!, formatter: Self.dateFormat)")
                                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                                .multilineTextAlignment(.leading)
                                    .font(.system(size: 12))
                                    .fixedSize(horizontal: false, vertical: true)
                        }
                            
                            HStack {
                            
                                let next = (self.$services[index].amount.wrappedValue + self.$services[index].serviceAmount.wrappedValue)
                                
                                let progress =
                                    self.$car.amount.wrappedValue >= next ?
                                0 :
                                    next - self.$car.amount.wrappedValue
                                
                                let percent = self.$services[index].serviceAmount.wrappedValue != 0 ? 100 - (progress * 100 / self.$services[index].serviceAmount.wrappedValue) : 100
                                
                                let nextMonth = (Calendar.current.date(byAdding: .month, value: Int(self.$services[index].months.wrappedValue), to: self.$services[index].date.wrappedValue)!)
                                
                             
                                
                                let progressMonth =
                                    Date() >= nextMonth ?
                                    Int32(self.$services[index].months.wrappedValue) :
                                    Int32(self.$services[index].months.wrappedValue) - Int32(Calendar.current.dateComponents([.month], from: Date(), to: nextMonth).month!)
                                
                                let percentMonth = self.$services[index].months.wrappedValue != 0 ? progressMonth * 100 / self.$services[index].months.wrappedValue : 100
                                
                                
                            ProgressView(settings.unit, value: Double(percent), total: 100)
                            .font(.system(size: 10))
                            .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                                .padding()
                                
                                ProgressView("Months", value: Double(percentMonth), total: 100)
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                                    .padding()
                                
                            }
                           

                        }
                            Text("")
                                .padding(.bottom, 20)
                    }
                }

               
                   
                  }
                
                }
            
            
            Divider()
            NavigationLink(destination:
                            CarSettingsView(car: self.$car, modal: self.$modal, delete: self.$delete, onSettings: self.$onSettings)
            ) {
                Text("Car Settings")
            }
            .padding()
            .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            
               
                       }
        .background(NavigationConfigurator { nc in
            let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                        nc.navigationBar.barTintColor = UIColor(color)
                    })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if(settings.fastApply == true) {
                Text(car.name)
                    .font(ui.title)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if(settings.fastApply != true) {
                                    Button("Done") {
                                        if(self.car.name != "") {
                                            self.modal = false
                                            self.save = true
                                        } else {
                                            self.toastMessasge = LocalizedStringKey("Name is required").toString()
                                            self.isShowingToast = true
                                            self.toastError = true
                                        }
                                    }
                }
                                }
        }
        .onAppear(){
            self.onAppear()
            GetServices ()
        }

            
        }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
        .modifier(Toast(isShowing: $isShowingToast, message: self.toastMessasge, isError: self.$toastError))
        
        }
    
    
    private func GetServices () {
        
        let request: NSFetchRequest<CarService> = CarService.fetchRequest()
        
        let requestCar: NSFetchRequest<CarServices> = CarServices.fetchRequest()
        requestCar.predicate = NSPredicate(format: "carId == %@", car.id as CVarArg)
        
        
        do{
            
            if(onSettings == true) {
                return
            }
            let savedServices = try  self.viewContext.fetch(request)
            let savedCarServices = try  self.viewContext.fetch(requestCar)
            
            for service in savedServices {
                var exist = false
                for carService in savedCarServices {
                    if(carService.serviceId == service.id) {
                        exist = true
                        let date = carService.date ?? Date()
                        let serv = CarServiceModel(
                            id: carService.id!,
                            name: carService.name!,
                            months: service.months,
                            amount: carService.amount,
                            serviceAmount: service.amount,
                            date: date)
                        self.services.append(serv)
                    }
                }
                if(exist == false) {
                
                    withAnimation {
                       
                        let newService = CarServices(context: viewContext)
                        newService.id = UUID()
                        newService.name = service.name
                        newService.amountService = service.amount
                        newService.month = service.months
                        newService.serviceId = service.id
                        newService.carId = car.id
                        newService.date = nil
                        let serv = CarServiceModel(
                            id: newService.id!,
                            name: service.name!,
                            months: service.months, 
                            amount: 0,
                            serviceAmount: service.amount,
                            date: Date())
                        self.services.append(serv)

              SaveContext()
                    }
                }
                
            }
           
            
            for carService in savedCarServices {
                var exist = false
                for service in savedServices {
                    if(carService.serviceId == service.id) {
                        exist = true
                    }
                }
                if(exist == false) {

                    self.viewContext.delete(carService)
                    SaveContext()
                }
            }
           
            self.load = true
            
        } catch {
            print(error)
        }
        
    }
    
    
    func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
  
}
   



struct CarSettingsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    @Binding var car: CarModel
    @Binding var modal: Bool
    @Binding var delete: Bool
    @Binding var onSettings: Bool
    
    @ObservedObject var icons = GetIcons()
    @ObservedObject var colors = GetColors()
    @ObservedObject var currencies = GetCurrencies()
    @ObservedObject var units = GetUnits()
    
    @State private var showConfirm = false
    
    init(car: Binding<CarModel>, modal: Binding<Bool>, delete: Binding<Bool>, onSettings: Binding<Bool>) {
        self._car = car
        self._modal = modal
        self._delete = delete
        self._onSettings = onSettings
    }

    var body: some View {
       
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
            
        VStack(spacing: 0) {
            HeaderTabTitleView(title: car.name)
                Form {
                    VStack(spacing: 0) {
              
                    TextInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Name", value: $car.name)
                    

              
            }
                    
                    Picker("Icon", selection: $car.iconContent) {
                        ForEach(icons.items) { icon in
                            Text(icon.name).tag(icon.content)
                            }
                                }
                    .padding()
                    
                
                   
                    Picker("Color", selection: $car.iconColor) {
                        ForEach(colors.items) { color in
                            Text(color.name).tag(color.content)
                            }
                                }
                    .padding()
        
                    Picker("Unit", selection: $car.symbol) {
                        ForEach(units.items) { item in
                            Text(item.name).tag(item.content)
                            }
                                }
                    .padding()
                    
                   
            }
               
                 
                
       
       Divider()
  
                                Button(action: {
                                    self.showConfirm = true
                                }) {
                                    Text("Delete Car")
                                       .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                                }
                                .padding()
        
     
        }
        .alert(isPresented: $showConfirm, content: { confirmDelete })
        .onAppear(){
            self.onSettings = true
        }
           
    
}
    
    var confirmDelete: Alert {
        Alert(title: Text("Delete Account?"), message: Text("Are you sure you want to delete this car?"),
            primaryButton: .default (Text("Yes")) {
                self.$delete.wrappedValue = true
                self.$modal.wrappedValue = false
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
    
}







//#if DEBUG
//struct accountView_Previews: PreviewProvider {
// 
// 
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//
//        AccountUpdateView(account: .constant(AccountModel()), transaction: .constant(Transaction()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//            .environment(\.managedObjectContext, viewContext)
//    }
//}
//#endif

