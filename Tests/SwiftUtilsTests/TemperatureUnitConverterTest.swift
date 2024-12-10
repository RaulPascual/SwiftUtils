//
//  TemperatureUnitConverterTests.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 10/12/24.
//

import XCTest
@testable import SwiftUtilities

final class TemperatureUnitConverterTests: XCTestCase {
    var sut: TemperatureUnitConverter!
    
    override func setUp() {
        super.setUp()
        sut = TemperatureUnitConverter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCelsiusToFahrenheit() {
        let result = sut.celsiusToFahrenheit(0)
        XCTAssertEqual(result, 32.0, accuracy: 0.001, "0°C should be 32°F")
        
        let result2 = sut.celsiusToFahrenheit(100)
        XCTAssertEqual(result2, 212.0, accuracy: 0.001, "100°C should be 212°F")
    }
    
    func testCelsiusToKelvin() {
        let result = sut.celsiusToKelvin(0)
        XCTAssertEqual(result, 273.15, accuracy: 0.001, "0°C should be 273.15K")
        
        let result2 = sut.celsiusToKelvin(-273.15)
        XCTAssertEqual(result2, 0.0, accuracy: 0.001, "-273.15°C should be 0K")
    }
    
    func testFahrenheitToCelsius() {
        let result = sut.fahrenheitToCelsius(32)
        XCTAssertEqual(result, 0.0, accuracy: 0.001, "32°F should be 0°C")
        
        let result2 = sut.fahrenheitToCelsius(212)
        XCTAssertEqual(result2, 100.0, accuracy: 0.001, "212°F should be 100°C")
    }
    
    func testFahrenheitToKelvin() {
        let result = sut.fahrenheitToKelvin(32)
        XCTAssertEqual(result, 273.15, accuracy: 0.001, "32°F should be 273.15K")
        
        let result2 = sut.fahrenheitToKelvin(-459.67)
        XCTAssertEqual(result2, 0.0, accuracy: 0.001, "-459.67°F should be 0K")
    }
    
    func testKelvinToCelsius() {
        let result = sut.kelvinToCelsius(273.15)
        XCTAssertEqual(result, 0.0, accuracy: 0.001, "273.15K should be 0°C")
        
        let result2 = sut.kelvinToCelsius(0)
        XCTAssertEqual(result2, -273.15, accuracy: 0.001, "0K should be -273.15°C")
    }
    
    func testKelvinToFahrenheit() {
        let result = sut.kelvinToFahrenheit(273.15)
        XCTAssertEqual(result, 32.0, accuracy: 0.001, "273.15K should be 32°F")
        
        let result2 = sut.kelvinToFahrenheit(0)
        XCTAssertEqual(result2, -459.67, accuracy: 0.001, "0K should be -459.67°F")
    }
    
    func testGenericConversion() {
        let result = sut.convertTemperature(value: 25, from: .celsius, to: .kelvin)
        XCTAssertEqual(result, 298.15, accuracy: 0.001, "25°C should be 298.15K")
        
        let result2 = sut.convertTemperature(value: 300, from: .kelvin, to: .fahrenheit)
        XCTAssertEqual(result2, 80.33, accuracy: 0.01, "300K should be approximately 80.33°F")
        
        let result3 = sut.convertTemperature(value: 98.6, from: .fahrenheit, to: .celsius)
        XCTAssertEqual(result3, 37.0, accuracy: 0.1, "98.6°F should be 37.0°C")
    }
}
