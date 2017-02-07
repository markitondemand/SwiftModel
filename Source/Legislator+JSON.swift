import Foundation

extension Legislator {

    public init(jsonDict: Dictionary<String, Any>) throws {
        
        // 1 - required JSON object parameters
        self.firstName = try jsonDict.extract(key: "first_name")
        self.inOffice = try jsonDict.extract(key: "in_office")
        self.lastName = try jsonDict.extract(key: "last_name")
        
        
        // 2 - required two-step parameter
        self.chamber = try jsonDict.extractEnum(key: "chamber")
        self.party = try jsonDict.extractEnum(key: "party")
        
        
        // 3 - optional JSON object parameter
        self.district = jsonDict.extractOptional(key: "district")

        
        // 4 - optional two-step parameter
        self.website = try jsonDict.extractOptionalURL(key: "website")
    }
}
