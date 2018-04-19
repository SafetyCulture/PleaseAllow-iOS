# Swift Guidlines

**Preferred**
```swift

```

**Not Prferred**
```swift

```



### Commandments

#### 1. Use (Parentheses) only if necessary

```swift
func transformVariable(_ variable: SomeVariable, completion: (TransformedVariable) ->  Void)) {
    let result: TransformedVariable = variable.transformed
    completion(result)
}
```

**Preferred**
```swift
transformVariable(myVar) { transformed in
bouce(transformed)
}
```

**Not Preferred**
```swift
transformVariable(myVar, completion: { (transformed) in
    bouce(transformed)
})
```


#### 2. Make Functions as human readable as possible  
**Preferred**
```swift
func extractRecord(with id: ID, from array: Array) -> Record {
// Return record
}

let record = extractRecord(with: someRecordID, from: someArray)
```

**Not Prferred**
```swift
func extractRecordWithID(id: ID, fromArray array: Array) -> Record {
// Return record
}

let record = extractRecordWithID(id: someRecordID, fromArray: someArray)
```
