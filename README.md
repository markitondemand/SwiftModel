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
Currently this library is one extension on the Dictionary class


# Future Enhancements Needed ##
- Baseline trasnformers to transform raw JSON to Swift objects. (Doing this will likely result in the removal of the "extractURL" and "extractEnum" methods and just use the "extract" method. This will convert to the expected type using a transformer, or raise an error of "no transformation avaialble for xyz, please provide your own")
    - String->URL
    - String->Color (decide on format, e.g. 'RRGGBB')
    - String->Date (MSDate, and / or ISO Date if possible to support both)
    - Ability to add your own for project specific types of transforming
- Support for cascading sub objects.
    - e.g. if a dictionary contains an array of sub dictionaries, set it up so the sub objects are all created when the root object is created
- Possibly support serializing an object that adopts a certain protocol back to a JSON dictionary / string (less important, but would be nice if we ever need to POST some complex JSON data)

# What not to implement #
- Do not implement a mapping model that maps property names to JSON keys, just use the "init" method in your own model object to extract the keys you need with your own rules there. The mapping model leads to some pretty odd code requiring introspection of the property / variable name. 
