//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MDSwiftModel

class MDSwiftModelTests: XCTestCase {
    
    func testNoError() {
        let card = self.generateCard(suit: "Hearts", rank: "King")!
        XCTAssertNotNil(card)
    }
    
    func testErrorMissingKey() {
        let missing = ["suit": "Hearts"]
        
        do {
            let _ = try Card(json: missing)
        }
        catch SerializationError.missing(let key) {
            XCTAssertEqual(key, "rank")
        }
        catch {
            XCTFail("Incorrect error thrown")
        }
    }
    
    func testErrorTypeMismatch() {
        let json = ["string": 42]
        do {
            let _: String = try json.extract(key: "string")
        }
        catch SerializationError.typeMismatch {
            // Pass if we get here
            return
        }
        catch {
            XCTFail("Incorrect erorr thrown")
        }
        XCTFail("No error was thrown")
    }
    
    func testErrorInvalid() {
        enum Test: String {
            case Case
        }
        
        let json = ["EnumKey":"Enum"]
        do {
            let _: Test = try json.extractEnum(key: "EnumKey")
        }
        catch SerializationError.invalid(let tuple) {
            XCTAssertEqual(tuple.0, "EnumKey")
            XCTAssertEqual(tuple.1 as! String, "Enum")
            return
        }
        catch {
            XCTFail("Incorrect error thrown")
        }
        XCTFail("No error was thrown")
    }
    
    
    func testTransformsValueToEnum() {
        let json: [String: Any] = ["suit":"Hearts",
                                   "rank":"Unknown"]
        let transformed: Card.Suit = try! json.extractEnum(key: "suit")
        
        XCTAssertEqual(transformed, Card.Suit.Hearts)
        XCTAssertThrowsError(_ = try json.extractEnum(key: "rank") as Card.Rank) { error in
            
        }
        
        let optionalEnum: Card.Rank? = json.extractOptionalEnum(key: "rank")
        XCTAssertNil(optionalEnum)
    }
    
    func testTransformsJSONTypeToURL() {
        let json: [String: Any] = ["URL":"http://www.google.com",
                                   "malformed":123]
        
        XCTAssertEqual(URL(string: "http://www.google.com"), try! json.extractURL(key: "URL"))
        XCTAssertNil(json.extractOptionalURL(key: "malformed"))
    }
    
    func testFallBack() {
        let json: [String: Any] = ["key":"value"]
        
        XCTAssertEqual(json.extract(key: "key", fallBack: "This should not happen"), "value")
        XCTAssertEqual(json.extract(key: "missingKey", fallBack: "This should happen"), "This should happen")
    }
    
}

extension MDSwiftModelTests {
    func generateCard(suit: String, rank: String) -> Card? {
        
        do {
            return try Card(json: ["suit":suit, "rank":rank])
        } catch _ {
            XCTFail("Caught an error.")
        }
        return nil
    }
}

// Assume we have a dictionary that represents a playing card.
/**
{
    {
        "suit": "Hearts",
        "cardValue":"King"
    }
}
*/
class Card {
    enum Suit: String {
        case Hearts
        case Diamonds
        case Clubs
        case Spades
    }
    
    enum Rank: String {
        case Two
        case Three
        case Four
        case Five
        case Six
        case Seven
        case Eight
        case Nine
        case Ten
        case Jack
        case Queen
        case King
        case Ace
        
    }
    
    // Non optional
    let suit: Suit
    let rank: Rank
    
    init(json: Dictionary<String, Any>) throws {
        suit = try json.extractEnum(key: "suit")
        rank = try json.extractEnum(key: "rank")
    }
}
