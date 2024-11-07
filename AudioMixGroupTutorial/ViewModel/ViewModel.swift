//
//  ViewModel.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import SwiftUI
import RealityKit

@MainActor
@Observable
class ViewModel {
    
    var root = Entity()
    var userDefaults = UserDefaultsManager.shared
}
