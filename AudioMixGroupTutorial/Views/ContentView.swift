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
        GeometryReader3D { geometry in
            RealityView { content in
                if let scene = try? await Entity(named: sceneName, in: realityKitContentBundle) {
                    viewModel.root.addChild(scene)
                    viewModel.saveAndStartAnimations()
                    
                    if let mainAudioMixGroup = try? await Entity(named: mainAudioMixGroupPath,
                                                                 in: realityKitContentBundle).children.first {
                        viewModel.mainAudioMixGroup = mainAudioMixGroup
                        viewModel.updateAudioMixGroup(named: soundAudioMixGroupName,
                                                      to: -50 * (1 - Double(viewModel.userDefaults.soundVolume)))
                        viewModel.updateAudioMixGroup(named: musicAudioMixGroupName,
                                                      to: -50 * (1 - Double(viewModel.userDefaults.musicVolume)))
                        viewModel.root.addChild(viewModel.mainAudioMixGroup)
                    }
                }
                
                content.add(viewModel.root)
            }
            .task {
                if let backgroundMusicEntity = try? await Entity(named: backgroundMusicAudioPath,
                                                                 in: realityKitContentBundle).children.first,
                   let backgroundMusic = backgroundMusicEntity.audioLibraryComponent?.resources[backgroundMusicAudioName] {
                    viewModel.root.playAudio(backgroundMusic)
                }
            }
            .toolbar {
                sliders
            }
            .gesture(tapGesture)
            .volumeSizeHandler(root: viewModel.root,
                               defaultSize: defaultVolumeSize,
                               currentSize: geometry.size)
        }
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
                             value: $bindableViewModel.userDefaults.musicVolume) { _, newValue in
                    viewModel.updateAudioMixGroup(named: musicAudioMixGroupName, to: -50 * (1 - Double(newValue)))
                }
                
                CustomSlider(text: "Sound Volume",
                             value: $bindableViewModel.userDefaults.soundVolume) { _, newValue in
                    viewModel.updateAudioMixGroup(named: soundAudioMixGroupName, to: -50 * (1 - Double(newValue)))
                }
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
