//
//  ViewModel.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
@Observable
class ViewModel {
    
    var root = Entity()
    var plane: Entity? { root.findEntity(named: planePrefabName) }

    var userDefaults = UserDefaultsManager.shared
    var isPlaneFlying: Bool { planeState == .flying }
    
    private var planeState: PlaneState = .flying
    private var playbackControllers: [AnimationPlaybackController] = []
    
    // Instead of using Behaviors in RCP to start the animations, we start them in code
    // for references to their playback controllers to pause and resume the animations
    func saveAndStartAnimations() {
        guard let plane, let sceneRoot = root.children.first?.children.first else { return }
        startAnimation(for: plane)
        startAnimation(for: sceneRoot, named: planeLoopAnimationName)
        startAnimation(for: sceneRoot, named: worldLoopAnimationName, saveAnimation: false)
    }

    func setPlaneState(to state: PlaneState) {
        guard let plane else { return }
        planeState = state
        
        playbackControllers.forEach({ isPlaneFlying ? $0.resume() : $0.pause() })
        
        plane.forEachDescendant {
            $0.particleEmitterComponent?.isEmitting = isPlaneFlying
        }
    }
    
    private func startAnimation(for entity: Entity, named name: String? = nil, saveAnimation: Bool = true) {
        for animation in entity.availableAnimations.filter({ $0.name == name || name == nil }) {
            guard let configuredAnimation = try? AnimationResource.generate(with: animation.repeat().definition) else {
                continue
            }
            
            let playbackController = entity.playAnimation(configuredAnimation)
            
            if saveAnimation {
                playbackControllers.append(playbackController)
            }
        }
    }
}
