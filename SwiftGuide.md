# Swift Guidlines

### Commandments

1. Use Parentheses only if necessary

```swift
func transformVariable(with variable: SomeVariable, completion: (TransformedVariable) ->  Void)) {
    let result: TransformedVariable = variable.transformed
    completion(result)
}
```

```swift
// Don't
transformVariable(myVar, completion: { (transformed) in
    bouce(transformed)
})

// Do
transformVariable(myVar) { transformed in
    bouce(transformed)
}
```
