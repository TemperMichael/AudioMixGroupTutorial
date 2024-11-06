//
//  ContentView.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
        .toolbar {
            sliders
        }
    }
    
    var sliders: some ToolbarContent {
        ToolbarItem(placement: .bottomOrnament) {
            @Bindable var bindableViewModel = viewModel
            
            HStack(spacing: 100) {
                CustomSlider(text: "Music Volume",
                             value: $bindableViewModel.userDefaults.musicVolume)
                
                CustomSlider(text: "Sound Volume",
                             value: $bindableViewModel.userDefaults.soundVolume)
            }
            .frame(width: 600)
            .padding()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(ViewModel())
}
