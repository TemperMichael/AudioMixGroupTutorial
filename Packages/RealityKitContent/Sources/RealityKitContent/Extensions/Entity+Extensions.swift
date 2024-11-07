//
//  Entity+Extensions.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 07.11.24.
//

import RealityKit

public extension Entity {
    
    var particleEmitterComponent: ParticleEmitterComponent? {
        get { components[ParticleEmitterComponent.self] }
        set { components[ParticleEmitterComponent.self] = newValue }
    }
    
    func forEachDescendant(_ closure: (Entity) -> Void) {
        for child in children {
            closure(child)
            child.forEachDescendant(closure)
        }
    }
}
