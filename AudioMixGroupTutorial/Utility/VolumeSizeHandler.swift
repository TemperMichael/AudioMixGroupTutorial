//
//  VolumeSizeHandler.swift
//  AudioMixGroupTutorial
//
//  Created by Tempuno e.U. on 07.11.24.
//

import SwiftUI
import RealityKit

struct VolumeSizeHandler: ViewModifier {

    var root: Entity
    var defaultSize: Size3D
    var currentSize: Size3D
    
    func body(content: Content) -> some View {
        content
            .onChange(of: currentSize) { oldSize, newSize in
                let newRatio = SIMD3<Float>(
                    x: Float(defaultVolumeSize.width / newSize.width),
                    y: Float(defaultVolumeSize.height / newSize.height),
                    z: Float(defaultVolumeSize.depth / newSize.depth)
                )
                
                root.scale = .one / newRatio
            }
    }
}

extension View {
    
    func volumeSizeHandler(root: Entity, defaultSize: Size3D, currentSize: Size3D) -> some View {
        modifier(VolumeSizeHandler(root: root, defaultSize: defaultSize, currentSize: currentSize))
    }
}
