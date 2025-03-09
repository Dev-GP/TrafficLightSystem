//
//  TrafficLightView.swift
//  TrafficLightSystem
//
//  Created by Georgi Penchev on 10.03.25.
//
import SwiftUI
struct TrafficLightView: View {
    
    let carModel: String
    let lightDiameter: CGFloat
    let lights: [LightModel]
    
    @StateObject var vm: TrafficLightViewModel
    
    init(carModel: String,
         lightDiameter: CGFloat = 150,
         lights: [LightModel] = [LightModel(color: .red, duration: 4), LightModel(color: .orange, duration: 1), LightModel(color: .green, duration: 4)]) {
        
        self.carModel = carModel
        self.lightDiameter = lightDiameter
        self.lights = lights
        
        _vm = StateObject(wrappedValue: TrafficLightViewModel(lights: lights))
        
    }
    
    var body: some View {
        VStack {
            ForEach(vm.lights.indices, id: \.self) { index in
                LightView(light: vm.lights[index], isActive: index == vm.activeLightIndex, diameter: lightDiameter)
            }
        }
        .navigationTitle(carModel)
        .onAppear{
            vm.startTrafficLight()
        }
        .onDisappear {
            vm.stopTrafficLight()
        }
    }
    
    class TrafficLightViewModel: ObservableObject {
        let lights: [LightModel]
        
        @Published var activeLightIndex: Int? = nil
        @Published private var trafficTask: Task<Void, Never>?
        
        var isTrafficTaskRunning: Bool { trafficTask != nil }
        
        init(lights: [LightModel]) {
            self.lights = lights
        }
        
        
        func startTrafficLight() {
            trafficTask = Task {
                var step = 1
                var current = 0
                let lightsCount = lights.count
                
                while true {
                    if current == -1 || current == lightsCount{
                        step = step * (-1)
                        current = current == -1 ? 1 : lightsCount - 2
                    }
                    
                    await setActiveLight(toIndex: current)
                    
                    current += step
                }
            }
        }
        
        func stopTrafficLight() {
            trafficTask?.cancel()
            trafficTask = nil
        }
        
        func setActiveLight(toIndex index: Int) async {
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    activeLightIndex = index
                }
            }
            try? await Task.sleep(nanoseconds: UInt64(lights[index].duration * 1000000000))
        }
        
    }
    
}

struct LightModel{
    let color: Color
    let duration: TimeInterval
}


