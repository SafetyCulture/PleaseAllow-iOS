# Swift Guidlines

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
func extractRecord(with id: ID, from dataSource: DataSource) -> Record? {
    let records = dataSource.records
    return records.first { $0.id == ID }
}

let record = extractRecord(with: recordID, from: dataSource)
```

**Not Preferred**
```swift
func extractRecordWithID(id: ID, fromDataSource dataSource: DataSource) -> Record? {
    let records = dataSource.records
    return records.first { $0.id == ID }
}

let record = extractRecordWithID(id: recordID, fromDataSource: dataSource)
```


**Preferred**
```swift

```

**Not Preferred**
```swift

```


