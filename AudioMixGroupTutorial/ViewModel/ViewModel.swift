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
    private var audioPlaybackControllers: [String: AudioPlaybackController] = [:]
    
    // Instead of using Behaviors in RCP to start the animations, we start them in code
    // for references to their playback controllers to pause and resume the animations
    func saveAndStartAnimations() {
        guard let plane, let sceneRoot = root.children.first?.children.first else { return }
        startAnimation(for: plane)
        startAnimation(for: sceneRoot, named: planeLoopAnimationName)
        startAnimation(for: sceneRoot, named: worldLoopAnimationName, saveAnimation: false)
        
        setPlaneState(to: .flying)
    }

    func setPlaneState(to state: PlaneState) {
        guard let plane else { return }
        planeState = state
        
        switch planeState {
        case .stopped:
            playbackControllers.forEach({ $0.speed = 0.5 })

            audioPlaybackControllers[planeFlyingAudioName]?.fade(to: -.infinity, duration: 1)
            
            if let stopSound = plane.audioLibraryComponent?.resources[planeStopAudioName] {
                let stopPlayerController = plane.playAudio(stopSound)
                stopPlayerController.completionHandler = { [weak self] in
                    self?.playbackControllers.forEach({ $0.pause() })
                }
            }
        case .flying:
            playbackControllers.forEach({ $0.resume() })

            if let flyingSound = plane.audioLibraryComponent?.resources[planeFlyingAudioName],
               let startSound = plane.audioLibraryComponent?.resources[planeStartAudioName] {
                let flyingAudioController = plane.prepareAudio(flyingSound)
                flyingAudioController.gain = -.infinity
                flyingAudioController.play()
                flyingAudioController.fade(to: 0, duration: 8)
                
                audioPlaybackControllers[planeFlyingAudioName] = flyingAudioController
                
                let startSoundPlayer = plane.playAudio(startSound)
                startSoundPlayer.completionHandler = { [weak self] in
                    self?.playbackControllers.forEach({ $0.speed = 1 })
                }
            }
        }

        
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
            playbackController.speed = 0.5
            
            if saveAnimation {
                playbackControllers.append(playbackController)
            }
        }
    }
}
