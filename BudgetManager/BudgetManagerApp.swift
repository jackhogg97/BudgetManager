//
//  BudgetManagerApp.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import LocalAuthentication
import SwiftUI

@main
struct BudgetManagerApp: App {
  @Environment(\.modelContext) var context
  @State private var isUnlocked = false

  var body: some Scene {
    WindowGroup {
      ZStack {
        if isUnlocked {
          MainView(context: context)
        } else {
          VStack {
            Image(systemName: "lock.square")
              .resizable()
              .frame(maxWidth: 100.0, maxHeight: 100.0)
            Button("Retry") {
              authenticate()
            }
          }
        }
      }
      .onAppear(perform: authenticate)
    }
  }

  func authenticate() {
    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      let reason = "Unlock to view your budgets"

      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
        if success {
          isUnlocked = true
        }
      }
    } else {
      // no biometrics
    }
  }
}
