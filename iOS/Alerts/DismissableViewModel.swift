//
//  DismissableViewModel.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//


import Foundation
import SwiftUI

final class DismissableViewModel: ObservableObject {
  @Published var isShowing: Bool {
    didSet {
      if !isShowing {
        timer?.invalidate()
      }
    }
  }
  private var timer: Timer?
  
  init(isShowing: Bool) {
    self.isShowing = isShowing
    guard isShowing else { return }
    setDismissTimer()
  }
  
  private func setDismissTimer() {
    let timer = Timer.init(fire: Date().addingTimeInterval(2.0), interval: 1.0, repeats: false) { [weak self] _ in
      withAnimation {
        self?.isShowing = false
      }
    }
    self.timer = timer
    RunLoop.main.add(timer, forMode: .default)
  }
}
