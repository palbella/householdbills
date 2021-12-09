//
//  Toast.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI

struct ToastView: View {
  let message: String
    @Binding var isError: Bool
  let onDismissAction: () -> Void
  
  var body: some View {
      
      let color = isError == false ? Color(UIColor(red: 2,green: 179,blue: 0)) : Color.red
      
    HStack {
      Text(message)
        .multilineTextAlignment(.center)
        .font(.subheadline)
        .padding(5)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .foregroundColor(Color.white)
       
        
//        Button(action: {
//            onDismissAction()
//        }) {
//            Icon(content: "multiply", color: color).padding(5).padding(.leading, 5).padding(.trailing, 5)
//        }

    }
    .background(
      Rectangle()
        .fill(color)
        .cornerRadius(5)
        .shadow(color: .black, radius: 0.3, x: 0.0, y: 1.0)
    )
  }
}

struct Toast: ViewModifier {
  let message: String
  @Binding private var isShowing: Bool
    @Binding private var isError: Bool
  @ObservedObject private var dismissable: DismissableViewModel
  
    init(isShowing: Binding<Bool>, message: String, isError: Binding<Bool>) {
    self.message = message
    self._isShowing = isShowing
        self._isError = isError
    self.dismissable = DismissableViewModel(isShowing: isShowing.wrappedValue)
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottom) {
      content
        .zIndex(1.0)
      if dismissable.isShowing {
          ToastView(message: message, isError: $isError) {
          withAnimation {
            dismissable.isShowing = false
          }
        }
        .transition(.move(edge: .bottom))
        .zIndex(2.0)
        .padding(.bottom, 20)
      }
    }
    .onReceive(dismissable.$isShowing, perform: { showing in
      self.isShowing = showing
    })
  }
}

//struct Toast_Previews: PreviewProvider {
//  static var previews: some View {
//    ToastView(message: "There was an error", onDismissAction: {})
//  }
//}
