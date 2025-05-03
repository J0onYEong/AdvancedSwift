
##  HashMap

Key-Value 형태로 데이터를 저장하고 업데이트할 수 있는 자료구조입니다.

내부적으로 균형 이진 트리인 [AVLTree](https://github.com/J0onYEong/AdvancedSwift/tree/main/Sources/AdvancedSwift/AVLTree)를 사용하여 정렬 없이도 키 값을 오름차순 또는 내림차순으로 추출할 수 있습니다.

> 💡 **Note**
> HashMap자료구조는 class로 구현된 참조타입입니다. 해당 자료구조를 깊은 복사하고 싶은 경우 인스턴스 매서드 `copy`를 사용하세요.

### Create

생성 시 사용할 Key와 Value 타입을 명시해야 합니다. Key 타입은 내부적으로 비교 연산 및 해시 연산을 위해 아래 프로토콜을 따라야 합니다.
```swift
public typealias HashMapKeyable = Hashable & Comparable

let hashMap = HashMap<String, Int>()
```

### Read

서브스크립트를 사용해 값을 추가할 수 있으며, 읽었을 때 값이 없으면 `nil`을 반환합니다.

```swift
hashMap["Bag"] = 10
hashMap["Apple"] = 12

print(hashMap["Bag"] ?? -1) // 10
```

`keys(order:maxCount:)` 함수를 사용하면 오름차순 또는 내림차순으로 정렬된 키 리스트를 얻을 수 있습니다.
키 추출의 시간 복잡도는 **O(N)**입니다. (N = maxCount)

※ maxCount를 전달하지 않으면 전체 키를 추출합니다.

```swift
hashMap["Bag"] = 10
hashMap["Apple"] = 12

print(hashMap.keys(order: .ASC, maxCount: 2)) // ["Apple", "Bag"]
print(hashMap.keys(order: .DESC)) // ["Bag", "Apple"]

// 다음 연산 프로퍼티들은 기존 딕셔너리의 키/값 추출 방식과 동일합니다.
hashMap.keys
hashMap.values
```

### Update

서브스크립트를 사용해 값을 업데이트할 수 있습니다.
```swift
hashMap["Bag"] = 10
print(hashMap["Bag"] ?? -1) // 10

hashMap["Bag"] = 12
print(hashMap["Bag"] ?? -1) // 12
```

### Delete

특정 키에 해당하는 값을 삭제하려면 `removeValue(forKey:)` 함수를 사용합니다.
```swift
hashMap["Bag"] = 10
hashMap.removeValue("Bag")

print(hashMap["Bag"] ?? -1) // -1
```
전체 데이터를 삭제하려면 `clear()` 함수를 사용하세요.
```swift
hashMap.clear()
```
