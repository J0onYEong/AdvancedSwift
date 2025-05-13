## Heap

전달한 비교 기준에 따라 내부요소들의 계층관계를 유지합니다.

### Create

`Heap`을 형성할 자료형은 제네릭으로 구현되어 있습니다.

해당 자료형이 `Comparable`을 채택하는 경우 `HeapType`을 전달하여 간편하게 힙을 생성할 수 있습니다.


```swift
// Comparable
let minHeap = Heap<Int>(heapType: .min)

// Custom type
let heap = Heap<SomeType>(compare: compare)
```

### Read

`top()`함수를 사용해 루트 요소를 반환받을 수 있습니다.
`popTop()`함수를 통해 루트 요소를 반환과 동시에 삭제할 수 있습니다.

```swift
let top = heap.top()
let top = heap.popTop()
```

### Insert

`insert(_:)`함수를 사용해 요소를 삽입할 수 있습니다.

```swift
heap.insert(element)
```
### Delete

`popTop()`함수혹은 `clear()`함수를 사용하여 내부 요소를 삭제할 수 있습니다.
