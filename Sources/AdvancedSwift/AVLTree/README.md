## AVLTree

AVL 트리는 노드 삽입 또는 삭제 시 균형을 자동으로 유지합니다.

모든 노드의 왼쪽과 오른쪽 서브트리 높이 차이는 1이하로 유지됩니다.

이로 인해 탐색, 삽입, 삭제 연산을 O(log n)시간 복잡도로 수행합니다.

### Create

트리의 노드의 값으로 사용가능한 `Value`제네릭은 `Comparable`프로토콜을 채택하는 모든 요소가 사용가능합니다.
```swift
let tree = AVLTree<Int>()
```

### Read

아래 함수들을 사용하여 가장 트리내부 값들을 추출할 수 있습니다.

매개변수로 nil값을 전달하는 경우 정렬된 전체 리스트를 반환합니다.
```swift
// 가장 작은 수부터 오름차순 추출
func getAscendingList(maxCount: Int? = nil) -> [Value]

// 가장 큰 수부터 내림차순 추출
func getDiscendingList(maxCount: Int? = nil) -> [Value]
```

해당 자료구조는 `Sequence`프로토콜을 준수하기 때문에 `for-in`문을 사용할 수 있습니다.

매 순회마다 복제된 트리와 함께 새로운 이터레이터를 반환하기 때문에 순회의 독립성이 지켜집니다.

기본적으로 반환되는 이터레이터는 오름차순 이터레이터 이지만 `setter`함수를 사용해 사용되는 순회전략을 수정할 수 있습니다.

※ setTraversalStrategy로 변경한 전략은 이후에도 유지됩니다.

```swift
for element in tree {
    // default, ASC
}

for element in tree.setTraversalStrategy(InOrderLeftStrategy()) {
    ...
}

for element in tree.setTraversalStrategy(InOrderRightStrategy()) {
    ...
}

```


### Delete

아래 함수에 삭제를 원하는 값을 전달하여 노드를 삭제할 수 있습니다.

반환 값인 `MemoryLeakChecker`인스턴스의 경우 해당 노드가 존재하지 않는 경우 `nil`을 반환합니다.
`MemoryLeakChecker`의경우 삭제대상노드를 weak참조하는 객체로 노드가 올바르게 삭제되었는지 확인하기 위한 용도입니다.

※ 테스트코드를 작성하여 메모리 누수가 발생하지 않음을 확인하였습니다.

```swift
@discardableResult
func remove(_ value: Value) -> MemoryLeakChecker?

let checker = tree.isReleased()
checker.isReleased() // true - 메모리 해제됨, false - 메모리 누수
```
