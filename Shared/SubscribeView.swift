//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI

struct SubscribeView: View {
//    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
//    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
  
    
    
    func onAppear() {
   
    }
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack (alignment: .center){
                HStack {
                    Image(systemName: "house")
                    .resizable()
                    .frame(width: 15, height: 13)
                    .foregroundColor(Color.black)
                    
                    Text("Household Bills")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)

                }.padding(.top, 70)
                .padding(.bottom, 10)
           
                .frame(maxWidth: .infinity)
                Text("Subscribe")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                

                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Subscribe")
                    }
                    .padding()
                    .frame(width: geometry.size.width - 40, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }.padding(.bottom, 10)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Maybe Later")
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)
                }


          

                Text("Terms & Subscription")
                    .foregroundColor(Color.white)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .font(.system(size: 8))
                    .multilineTextAlignment(.center)
                Text("Terms & Privacy")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 35)
                    .font(.system(size: 12))
                
            }
            .onAppear() {
                self.onAppear()
            }
        }
        .background(ui.lightPrimaryColor)
        .edgesIgnoringSafeArea(.all)
        
        }


}


#if DEBUG
struct SubscribeView_Previews: PreviewProvider {

    static var previews: some View {

        SubscribeView()
//            .environmentObject(UserSettings())
//                .environmentObject(AppUI())

    }
}
#endif
