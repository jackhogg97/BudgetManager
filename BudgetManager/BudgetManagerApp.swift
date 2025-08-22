//
//  BudgetManagerApp.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import LocalAuthentication
import SwiftData
import SwiftUI

@main
struct BudgetManagerApp: App {
  private let container: ModelContainer
  @State private var isUnlocked = false

  init() {
    do {
      container = try ModelContainer(for: Category.self, Transaction.self)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      ZStack {
        if isUnlocked {
          MainView(container.mainContext)
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
