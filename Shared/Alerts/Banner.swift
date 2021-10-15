//
//  BannerView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI

struct BannerView: View {
  let message: String
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.red)
      Text(message)
        .foregroundColor(.white)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.top, 20)
    }.frame(height: 100)
  }
}

struct Banner: ViewModifier {
  let message: String
  @Binding private var isShowing: Bool
  @ObservedObject private var dismissable: DismissableViewModel
  
  init(isShowing: Binding<Bool>, message: String) {
    self.message = message
    self._isShowing = isShowing
    self.dismissable = DismissableViewModel(isShowing: isShowing.wrappedValue)
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: .top) {
      content
        .zIndex(1)
      if dismissable.isShowing {
        BannerView(message: message)
          .transition(.move(edge: .top))
          .zIndex(2)
          .edgesIgnoringSafeArea(.top)
          .gesture(DragGesture()
                    .onChanged { gesture in
                      guard dismissable.isShowing, gesture.translation.height < 0 else { return }
                      withAnimation {
                        dismissable.isShowing = false
                      }
                    }
          )
      }
    }
    .onReceive(dismissable.$isShowing, perform: { showing in
      self.isShowing = showing
    })
  }
}

struct Banner_Previews: PreviewProvider {
  static var previews: some View {
    Rectangle()
      .fill(Color.white)
      .modifier(Banner(isShowing: .constant(true), message: "Error message goes here Error message goes here Error message goes here "))
  }
}
