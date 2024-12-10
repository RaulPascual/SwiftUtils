//
//  TemperatureUnitConverter.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 10/12/24.
//

import Foundation

public enum TemperatureUnit {
    case celsius
    case fahrenheit
    case kelvin
}

public class TemperatureUnitConverter {
    
    public init() {}
    
    public func convertTemperature(value: Double, from: TemperatureUnit, to: TemperatureUnit) -> Double {
        guard from != to else { return value }
        
        let valueInCelsius: Double
        switch from {
        case .celsius:
            valueInCelsius = value
        case .fahrenheit:
            valueInCelsius = fahrenheitToCelsius(value)
        case .kelvin:
            valueInCelsius = kelvinToCelsius(value)
        }
        
        switch to {
        case .celsius:
            return valueInCelsius
        case .fahrenheit:
            return celsiusToFahrenheit(valueInCelsius)
        case .kelvin:
            return celsiusToKelvin(valueInCelsius)
        }
    }
    
    // Direct conversions: Celsius → Fahrenheit, Kelvin
    public func celsiusToFahrenheit(_ value: Double) -> Double {
        return (value * 9/5) + 32
    }
    
    public func celsiusToKelvin(_ value: Double) -> Double {
        return value + 273.15
    }
    
    // Direct conversions: Fahrenheit → Celsius, Kelvin
    public func fahrenheitToCelsius(_ value: Double) -> Double {
        return (value - 32) * 5/9
    }
    
    public func fahrenheitToKelvin(_ value: Double) -> Double {
        return celsiusToKelvin(fahrenheitToCelsius(value))
    }
    
    // Direct conversions: Kelvin → Celsius, Fahrenheit
    public func kelvinToCelsius(_ value: Double) -> Double {
        return value - 273.15
    }
    
    public func kelvinToFahrenheit(_ value: Double) -> Double {
        return celsiusToFahrenheit(kelvinToCelsius(value))
    }
    
    // Redundant conversions: same units
    public func celsiusToCelsius(_ value: Double) -> Double {
        return value
    }
    
    public func fahrenheitToFahrenheit(_ value: Double) -> Double {
        return value
    }
    
    public func kelvinToKelvin(_ value: Double) -> Double {
        return value
    }
}
