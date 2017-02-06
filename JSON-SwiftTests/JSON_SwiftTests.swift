//
//  JSON_SwiftTests.swift
//  JSON-SwiftTests
//
//  Created by Michael Leber on 2/3/17.
//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MarkitDigitalJSON

class JSON_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoError() {
        let json = ["backColor": "Red", "size": 52] as [String : Any]
        
        let card: Card
        do {
            card = try Card(json: json)
        }
        catch {
            XCTFail("caught an error - \(error)")
            return
        }
        
        
        XCTAssertEqual(card.backColor, "Red")
        XCTAssertEqual(card.deckSize, 52)
    }
    
    func testThrowsMissingRequiredKey() {
    }
}

class Card {
    // Optional
    let backColor: String?
    // Non optional
    let deckSize: Int
    
    init(json: Dictionary<String, Any>) throws {
        backColor = json.extractOptional(key: "backColor")
        deckSize = try json.extract(key: "size")
    }
}
