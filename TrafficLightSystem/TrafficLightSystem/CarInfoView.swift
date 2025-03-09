//
//  ContentView.swift
//  TrafficLightSystem
//
//  Created by Georgi Penchev on 9.03.25.
//

import SwiftUI

import SwiftUI

enum NavPath: Hashable {
    case traficLight
}

struct CarInfoView: View {
    @State private var path: [NavPath] = []
    @StateObject var vm = CarInfoViewModel()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack(alignment: .center){
                HStack{
                    Text("Car model:")
                    TextField("Enter car model", text: $vm.carModel).onChange(of: vm.carModel) {
                        vm.validate()
                    }
                }
                .padding()
                
                Button("Start driving") {
                    path.append(.traficLight)
                }
                .buttonStyle(.bordered)
                .disabled(!vm.isValid)
                .navigationDestination(for: NavPath.self) { path in
                    switch path{
                    case .traficLight: TrafficLightView(carModel: vm.carModel)
                    }
                }
            }
        }
        .navigationTitle("Car Info")
        
    }
    
    class CarInfoViewModel: ObservableObject {
        @Published var carModel: String = ""
        @Published var isValid: Bool = false
        
        func validate() {
            isValid = carModel.count >= 3
        }
    }
}

#Preview {
    CarInfoView()
}
