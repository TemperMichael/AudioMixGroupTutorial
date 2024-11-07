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
                viewModel.root.addChild(scene)
                viewModel.saveAndStartAnimations()
            }
            
            content.add(viewModel.root)
        }
        .toolbar {
            sliders
        }
        .gesture(tapGesture)
    }
    
    var tapGesture: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { _ in
                viewModel.setPlaneState(to: viewModel.isPlaneFlying ? .stopped : .flying)
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
