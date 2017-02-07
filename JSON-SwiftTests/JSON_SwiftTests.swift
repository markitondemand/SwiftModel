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
        

        let card = self.defaultCard()!
        
        XCTAssertEqual(card.backColor, "Red")
        XCTAssertEqual(card.deckSize, 52)
    }
    
    func testMissingRequiredKeys() {
        let missing = ["backColor": "Red"]
        
        do {
            let _ = try Card(json: missing)
        }
        catch SerializationError.missing(let key) {
            XCTAssertEqual(key, "size")
        }
        catch {
            XCTFail("Incorrect error thrown")
        }
    }
    
    func testTransformsValueToEnum() {
        var json: [String: Any] = ["webSite": "http://www.google.com",
                    "backColor": "Red",
                    "size": 52,
                    "suit":"Hearts"]
        
        
        let transformed: Card.Suit = try! json.extractEnum(key: "suit")
        XCTAssertEqual(transformed, Card.Suit.Hearts)
        
        json = ["webSite": "http://www.google.com",
                 "backColor": "Red",
                 "size": 52,
                 "suit":"Trapazoids"]
        
    }
    
    
    func defaultCard() -> Card? {

        
        let json = ["backColor": "Red",
                    "size": 52,
                    "webSite": "http://www.cardgames.com",
                    "suit": "hearts"] as [String : Any]
        let card: Card!
        
        do {
            card = try Card(json: json)
            return card
        }
        catch {
            XCTFail("caught an error - \(error)")
            return nil
        }
    }
}

class Card {
    enum Suit: String {
        case Hearts
        case Diamonds
        case Clubs
        case Spades
    }
    
    // Optional
    let backColor: String?
    // Non optional
    let deckSize: Int
    let webSite: URL
    let suit: Suit
    
    
    init(json: Dictionary<String, Any>) throws {
        backColor = json.extractOptional(key: "backColor")
        deckSize = try json.extract(key: "size")
        webSite = try json.extractTransformedToURL(key: "webSite")
        suit = try json.extractEnum(key: "suit")
    }
}
