import Foundation


/// Error that occurred during deserialiation
///
/// - missing: A required key was missing from the dictionary
/// - invalid: <#invalid description#>
/// - type: The expected type differred than what was deserialized
public enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
    case type
}


extension Dictionary where Key: KeyDescription {
    public func extract<T>(key: Key) throws -> T {
        guard (self[key] != nil) else {
            throw SerializationError.missing(key.name())
        }
        guard let result = self[key] as? T else {
            throw SerializationError.type
        }        
        
        return result
    }
    
    
    // Note - This needs to have a different name as the compiler is tripped up with "Ambiguous" when using the optional return variant
    /// <#Description#>
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    public func extractOptional<T>(key: Key) -> T? {
        guard (self[key] != nil) else {
            return nil
        }
        guard let result = self[key] as? T else {
            return nil
        }
        
        return result
    }
}



// MARK: - Helper extension used for printing key names in errors where a key is missing
public protocol KeyDescription: Hashable {
    func name() -> String
}

// MARK: - If something fails to implement this we handle it with the following
extension KeyDescription {
    func name() -> String {
        return "Unknown name"
    }
}


// MARK: - Default implementation for String of KeyDescription
extension String: KeyDescription  {
    public func name() -> String {
        return self
    }
    
    public func testing() {
        print("testing")
    }
}
