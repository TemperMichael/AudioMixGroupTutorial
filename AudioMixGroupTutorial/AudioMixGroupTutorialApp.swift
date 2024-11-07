//
//  AudioMixGroupTutorialApp.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI

let defaultVolumeSize = Size3D(width: 1500, height: 1500, depth: 1500)

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
        .defaultSize(defaultVolumeSize)
    }
}
