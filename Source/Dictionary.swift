import Foundation


/// Error that occurred during deserialiation
///
/// - missing: A required key was missing from the dictionary. The exepcted key will be passed in the error
/// - invalid: Currently, this is sent if it is not possible to create an associated enum value from the input JSON. The key and value from the JSON are sent in the error
/// - type: The expected type differs from what was deserialized from the dictionary. e.g. (you expect an integer, but a String is deserialized. this error will be raised)
public enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
    // TOOD: pass the expected and actual types back
    case typeMismatch
}

// TODO: Build trasnformers that can automagically try to transform the JSON type to a Generic type (i.e. ideally this can detect, JSON has a String and is being set to a URL property, try to URLize it.
extension Dictionary where Key: JSONKey {
    
    
    /// Extracts a raw JSON type from the dictionary. If
    ///
    /// - Parameter key: The key to extract
    /// - Returns: The native JSON value, if possible. If the type does not match, or the value is missing a SerializationError is thrown
    /// - Throws: If the key is missing, SerializationError,missing is thrown passing the key, if the type does not match SerializationError.type is thrown
    public func extract<T>(key: Key) throws -> T {
        guard let result = self[key] else {
            throw SerializationError.missing(key.name)
        }
        guard let typedResult = result as? T else {
            throw SerializationError.typeMismatch
        }        
        
        return typedResult
    }
    
    
    /// Optionally extracts a raw type. If the value cann
    ///
    /// - Parameter key: The key to extract
    /// - Returns: The native JSON value, or nil if the type does not match, or the value is missing
    public func extractOptional<T>(key: Key) -> T? {
        guard (self[key] != nil) else {
            return nil
        }
        guard let result = self[key] as? T else {
            return nil
        }
        
        return result
    }
    
    /// Attempts to extract value from the dictionary. If no value is found, or the type does not match the "fallBack" value is returned instead. This can be used instead of the optional or throwable variants
    ///
    /// - Parameters:
    ///   - key: The key to extract
    ///   - fallBack: The fallBack value to use in case no value can be found for the given key
    /// - Returns: The extracted value, or the fallBack value.
    func extract<T>(key: Key, fallBack: T) -> T {
        guard let param = self[key] as? T else {
            return fallBack
        }
        return param
    }
    
    
    /// Extracts a value and attempts to create a URL out of it. If the key is missing, or a URL cannot be generated a SerializationError is thrown
    ///
    /// - Parameter key: The key to extract
    /// - Returns: A URL formed from a String in the JSON
    /// - Throws: SerializationError if a URL could not be created
    public func extractURL(key: Key) throws -> URL {
        let value: String = try self.extract(key: key)
        
        guard let URL = URL(string: value) else {
            throw SerializationError.typeMismatch
        }
        
        return URL
    }
    
    
    /// Extracts a value and attempts to create a URL out of it. If the key is missing, or aURL cannot be generated nil is returned
    ///
    /// - Parameter key: The key to extract
    /// - Returns: A valid URL, or nil if a URL could not be created
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
    public func extractEnum<T: RawRepresentable>(key: Key) throws -> T {
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
    public func extractOptionalEnum<T: RawRepresentable>(key: Key) -> T? {
        guard let paramRaw: T.RawValue = self.extractOptional(key: key) else {
            return nil
        }
        guard let param = T(rawValue :paramRaw) else {
            return nil
        }
        return param
    }
}


// MARK: - JSONKey Extension
public protocol JSONKey: Hashable {
    /// Access the name of the JSON key
    var name: String { get }
}

// Base implementation
extension JSONKey {
    public var name: String {
        get { return "Unknown Key" }
    }
}

// Default implementaiton for String adopting JSONKey
extension String: JSONKey {
    public var name: String {
        get { return self }
    }
}
    
