//
//  AudioMixGroupTutorialApp.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI

@main
struct AudioMixGroupTutorialApp: App {

    @State private var viewModel = ViewModel()
    
    init() {
        UserDefaultsManager.shared.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .windowStyle(.volumetric)
    }
}
