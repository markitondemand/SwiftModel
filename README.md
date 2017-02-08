MDSwiftModel
===========
# Version #
0.1

# Attributions #
Original idea and implementation with NSDictionary by Drew Christensen

Modified and updated to work with Dictionary by Michael Leber

# Questions
## What is this? ##
This is a way to help create Swift model classes and structs from JSON object data. It is an alternative to some found online (i.e. ObjectMapper), and is grown in house to ensure better maintenance.

## How do I use this? ##
Currently this is implemented as an extension on the Swift "Dictionary" struct. Their are a few methods aimed at safely extracting values of the correct type(s) to your functions and throwing errors that make sense in the event any issues arise. This also supports creating any Enum that supports RawRepresentable directly from the dictionary.

The way to use this is to create an extension on your model class that has an initializer with the form `init(jsonDict: Dictionary<String, Any>) throws`, than call the appropriate Dictionary extension methods you need in the constructor. All throws will be propogated up to something like your web service class where you can then handle  errors. 

Please take a look at Legislator.swift, Legislator+JSON.swift and SunlightWebService.swift for some detailed example usage


# Future Enhancements Needed ##
- Baseline trasnformers to transform raw JSON to Swift objects. (Doing this will likely result in the removal of the "extractURL" and "extractEnum" methods and just use the "extract" method. This will convert to the expected type using a transformer, or raise an error of "no transformation avaialble for xyz, please provide your own")
    - maybe even `extract(key: Key, usingStrategy:(closure here that takes the extracted "U" value and returns "T" transformed value) -> T)`
    - String->URL
- String->Color (decide on format, e.g. 'RRGGBB')
    - String->Date (MSDate, and / or ISO Date if possible to support both)
    - Ability to add your own for project specific types of transforming
- Support for cascading sub objects.
    - e.g. if a dictionary contains an array of sub dictionaries, set it up so the sub objects are all created when the root object is created
- Possibly support serializing an object that adopts a certain protocol back to a JSON dictionary / string (less important, but would be nice if we ever need to POST some complex JSON data)

# What not to implement #
- Do not implement a mapping model that maps property names to JSON keys, just use the "init" method in your own model object to extract the keys you need with your own rules there. The mapping model leads to some pretty odd code requiring introspection of the property / variable name. 
