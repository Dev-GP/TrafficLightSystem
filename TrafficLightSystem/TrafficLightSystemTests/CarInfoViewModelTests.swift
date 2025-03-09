//
//  CarInfoViewModelTests.swift
//  TrafficLightSystemTests
//
//  Created by Georgi Penchev on 10.03.25.
//

import XCTest
@testable import TrafficLightSystem

final class CarInfoViewModelTests: XCTestCase {
    
    var vm: CarInfoView.CarInfoViewModel?
    
    override func setUpWithError() throws {
        vm = CarInfoView.CarInfoViewModel()
    }

    override func tearDownWithError() throws {
        vm = nil
    }
    
    func testCarinfoView_isValid_when_carModel_isEmpty_shouldBeFalse() {
        // Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        let carModel: String = ""
        
        // When
        vm.carModel = carModel
        vm.validate()
        
        // Then
        XCTAssertFalse(vm.isValid)
    }
    
    func testCarinfoView_isValid_when_carModel_isShorter_Then_3_Chars_shouldBeFalse() {
        // Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        let carModel: String = "12"
        
        // When
        vm.carModel = carModel
        vm.validate()
        
        // Then
        XCTAssertFalse(vm.isValid)
    }
    
    func testCarinfoView_isValid_when_carModel_isLonger_Then_3_Chars_shouldBeTrue() {
        // Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        let carModel: String = "1234"
        
        // When
        vm.carModel = carModel
        vm.validate()
        
        // Then
        XCTAssertTrue(vm.isValid)
    }
    
    func testCarinfoView_carModel_isEmptyOnStart_shouldBeTrue() {
        // Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        
        // When
        
        // Then
        XCTAssertTrue(vm.carModel.isEmpty)
    }


    func testCarInfoViewModel_onRapidInput_isValid() {
        // Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        
        // When
        measure {
            for i in 0..<100 {
                vm.carModel = "\(i)"
                vm.validate()
            }
        }
        
        // Then
        XCTAssertEqual(vm.isValid, vm.carModel.count >= 3 ? true : false, "Validation should remain stable under repeated calls.")
    }

}
