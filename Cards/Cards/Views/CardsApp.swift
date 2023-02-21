//
//  CardsApp.swift
//  Cards
//
//  Created by Kenyon
//

import SwiftUI

@main
struct CardsApp: App {
      @StateObject var viewState = ViewState()

  var body: some Scene {
    WindowGroup {
      CardsView()
        .environmentObject(viewState)
    }
  }
}
