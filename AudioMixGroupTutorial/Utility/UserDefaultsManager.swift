//
//  UserDefaultsManager.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 06.11.24.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    var soundVolume: Float {
        get { UserDefaults.standard.float(forKey: "soundVolume") }
        set { UserDefaults.standard.set(newValue, forKey: "soundVolume") }
    }
    
    var musicVolume: Float {
        get { UserDefaults.standard.float(forKey: "musicVolume") }
        set { UserDefaults.standard.set(newValue, forKey: "musicVolume") }
    }
    
    func register() {
        UserDefaults.standard.register(defaults: ["soundVolume": 1])
        UserDefaults.standard.register(defaults: ["musicVolume": 1])
    }
}
