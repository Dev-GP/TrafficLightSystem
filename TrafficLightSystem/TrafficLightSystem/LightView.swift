//
//  LightView.swift
//  TrafficLightSystem
//
//  Created by Georgi Penchev on 10.03.25.
//


import SwiftUI

struct LightView: View{
    let light: LightModel
    let isActive: Bool
    var diameter: CGFloat
    
    init(light: LightModel, isActive: Bool, diameter: CGFloat = 150) {
        self.light = light
        self.isActive = isActive
        self.diameter = diameter
    }
    
    var body: some View{
        Circle()
            .fill(.black)
            .fill(isActive ? light.color : light.color.opacity(0.7))
            .frame(width: diameter, height: diameter)
    }
}
