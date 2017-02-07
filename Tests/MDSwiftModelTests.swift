//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MDSwiftModel

class MDSwiftModelTests: XCTestCase {
    
    func testNoError() {
        let card = self.generateCard(suit: "Hearts", rank: "King")!
        XCTAssertNotNil(card)
    }
    
    func testMissingRequiredKeys() {
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

// Assume we have a dictionary that represents a deck of cards.
/**
{
    "deck": {
        "website": "http://www.cardgames.com", // optional
        "deckBackColor":"Red",
        "cards":[
            {
                "suit": "Hearts",
                "cardValue":"King"
            }
        ]
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
