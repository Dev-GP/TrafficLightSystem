//
//  TrafficLightViewModelTests.swift
//  TrafficLightSystemTests
//
//  Created by Georgi Penchev on 10.03.25.
//

import XCTest
@testable import TrafficLightSystem

import SwiftUI

final class TrafficLightViewModelTests: XCTestCase {
    var vm: TrafficLightView.TrafficLightViewModel?
    
    override func setUpWithError() throws {
        let lights: [LightModel] = [LightModel(color: .red, duration: 4), LightModel(color: .orange, duration: 1), LightModel(color: .green, duration: 4)]
        
        vm = TrafficLightView.TrafficLightViewModel(lights: lights)
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    
    func testTrafficLightViewModel_startTask_func_isTaskRunnig_shouldBeTrue() {
        //Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        
        //When
        vm.startTrafficLight()
        
        //Then
        XCTAssertTrue(vm.isTrafficTaskRunning, "Traffic task should be running")
    }

    func testTrafficLightViewModel_stopTask_func_isTaskRunnig_shouldBeFalse() {
        //Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        
        //When
        vm.startTrafficLight()
        XCTAssertTrue(vm.isTrafficTaskRunning, "Traffic task should be running")
        vm.stopTrafficLight()
        //Then
        XCTAssertFalse(vm.isTrafficTaskRunning, "Traffic task should be nil after stopping")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testChangeLightDuration() async {
        //Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        
        for _ in 1...7 {
            let expectation = expectation(description: "ChangeLight completes")
            
            let startTime = Date()
            let index = Int.random(in: 0..<vm.lights.count)
            
            Task {
                await vm.setActiveLight(toIndex: index)
                let elapsedTime = Date().timeIntervalSince(startTime)
                
                XCTAssertEqual(elapsedTime, vm.lights[index].duration, accuracy: 0.1, "Duration should be close to \(vm.lights[index].duration)s")
                
                expectation.fulfill()
            }
            
            await fulfillment(of: [expectation], timeout: vm.lights[index].duration + 0.2)
        }
    }

}
