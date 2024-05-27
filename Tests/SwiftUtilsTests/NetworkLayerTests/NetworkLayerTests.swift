//
//  NetworkLayerTests.swift
//  
//
//  Created by Raul on 27/5/24.
//

import XCTest
@testable import SwiftUtils

final class NetworkLayerTests: XCTestCase {

    func test1() async {
        let testBusiness = TestBusiness()
        let result = await testBusiness.getRacesResultsBySeason(season: "2024")
        
        switch result {
        case .success(let success):
            XCTAssertNotNil(success.races)
        case .failure(_):
            return
        }
    }

}

class TestBusiness: HTTPClient {
    func getRacesResultsBySeason(season: String) async -> Result<Races, RequestError> {
        let result = await sendRequest(enableDebug: true,
                                       endpoint: CurrentCalendarEndpoint.currentDriverStandings(year: season),
                                       responseModel: Races.self)
            return result
    }
}
