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

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(ViewModel())
}
