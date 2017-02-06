import Foundation

public enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension NSDictionary {

    // String, Int, Number, Bool, Dictionary, [Any]
    
    func extract<T>(forKey key: String) throws -> T {
        guard let param = self[key] as? T else {
            throw SerializationError.missing(key)
        }
        return param
    }
    
    func extractOptional<T>(forKey key: String) throws -> T? {
        if let param = self[key] as? T {
            return param
        }
        else {
            return nil
        }
    }
}


extension Dictionary where Key: KeyDescription, Value: AnyObject {
    func extract(key: Key) throws -> Value {
        guard let result = self[key] else {
            throw SerializationError.missing(key.name())
        }
        
        return result
    }
    
    func extract(key: Key) -> Value? {
        return self[key]
    }
}

protocol KeyDescription {
    func name() -> String
}


extension String: KeyDescription  {
    func name() -> String {
        return self
    }
}
