import Foundation


/// Error that occurred during deserialiation
///
/// - missing: A required key was missing from the dictionary. The exepcted key will be passed in the error
/// - invalid:
/// - type: The expected type differs from what was deserialized from the dictionary. e.g. (you expect an integer, but a String is deserialized. this error will be raised)
public enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
    // TOOD: pass the expected and actual types back
    case type
}

// TODO: Build trasnformers that can automagically try to transform the JSON type to a Generic type (i.e. ideally this can detect, JSON has a String and is being set to a URL property, try to URLize it.
extension Dictionary where Key: KeyDescription {
    
    
    /// Extracts a raw JSON type from the dictionary. If
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func extract<T>(key: Key) throws -> T {
        guard (self[key] != nil) else {
            throw SerializationError.missing(key.name)
        }
        guard let result = self[key] as? T else {
            throw SerializationError.type
        }        
        
        return result
    }
    
    
    /// Optionally extracts a raw type. If the value cann
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
    
    
    /// Extracts a value and attempts to create a URL out of it. If the key is missing, or 
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func extractURL(key: Key) throws -> URL {
        let value: String = try self.extract(key: key)
        
        guard let URL = URL(string: value) else {
            throw SerializationError.type
        }
        
        return URL
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    public func extractOptionalURL(key: Key) -> URL? {
        guard let value: String = self.extractOptional(key: key) else {
            return nil
        }
        
        guard let URL = URL(string: value) else {
            return nil
        }
        
        return URL
    }
    
    /// Attempt to extract an Enum from the JSON directly. This will attempt to create an Enum value, otherwise a SerializationError will be thrown
    ///
    /// - Parameter key: The key to extract
    /// - Returns: An initialized enum value.
    /// - Throws: Throws a SerializationError
    func extractEnum<T: RawRepresentable>(key: Key) throws -> T {
        let paramRaw: T.RawValue = try self.extract(key: key)
        guard let param = T(rawValue :paramRaw) else {
            throw SerializationError.invalid(key.name, paramRaw)
        }
        return param
    }
    
    
    /// Attempt to extract an Enum fro mthe JSON directly. This will attempt to create an Enum value, otherwise nil will be returned
    ///
    /// - Parameter key: The key to extract
    /// - Returns: A created Enum value, or nil if no enum could be found or created
    func extractOptionalEnum<T: RawRepresentable>(key: Key) -> T? {
        guard let paramRaw: T.RawValue = self.extractOptional(key: key) else {
            return nil
        }
        guard let param = T(rawValue :paramRaw) else {
            return nil
        }
        return param
    }
}

//extension Dictionary where Key: KeyDescription, Value: Transformable {
//    public func extractTransformed<Result>(key: Key) throws -> Result {
//        
//        let value: Value = try self.extract(key: key)
//        
////        let transformedValue = value.transformFromJSON()
//        if let transformable = value.transformFromJSON() as? Result {
//            // TOOD: clean up errors
//            return transformable
//        }
//        throw SerializationError.type
//    }
//}

// MARK: - Helper extension used for printing key names in errors where a key is missing
public protocol KeyDescription: Hashable {
    /// Return the name of the JSON key
    var name: String { get }
}

public protocol Transformable {
    associatedtype Object
//    associatedtype JSON
    func transformFromJSON() -> Object
//    func transformToJSON() -> JSON
}

// MARK: - If something fails to implement this we handle it with the following
extension KeyDescription {
    public var name: String {
        get { return "Unknown name" }
    }
}


// MARK: - Default implementation for String of KeyDescription
extension String: KeyDescription {
    public var name: String {
        get { return self }
    }
}
    
