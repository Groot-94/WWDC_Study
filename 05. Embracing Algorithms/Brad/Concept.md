# WWDC2018) 알고리즘 수용

## 주제

프로그램이 실제로 작동하도록 만드는 요소를 이해하고 생각

- 코드에 잠재되어 있는 근본적인 것을 생각해보고 프로그래밍 관행에 대한 새로운 시작을 고민
- 구체적인 코드의 책임, 유지 관리성 및 성능의 원천이기도 한다.

## Example - Shape 프로그램

- 무한한 캔버스에 모양을 배열할 수 있는 프로그램

### 선택 삭제 명령

- `for문`  - 부터 끝까지 반복해야하고, 삭제할 요소를 찾아도, 그것을 제거한다음 끝까지 반복을 계속진행해야함. (별다른 명령어가 없다면)
    - 문제: 보기 흉함
- `while문` - 각 반복에서 카운트를 검사할 수 있음.
    - 문제: 두 개의 연속으로 선택되면 첫 번째 요소를 제거한 후 즉시 다음 요소로 건너뛰게 되어 뛰게 되어 선택한 요소를 제거를 못하는 현상
    - 발생 원인: 요소가 삭제되고 Index가 증가되어 넘어감.
    - 해결방법: else블록으로 버그 처리
- `reversed()` - `remove(at: i)` 다음에 배열의 일부를 변경하기 떄문에 검사할 다음 항목의 반복 제한과 인덱스가 앞쪽으로만 변경이 일어나기 때문에, 만약 뒤로부터 시작되면 충돌이 일어날 일이 없다.
    - 문제: 성능 저하
    - 발생 원인:
        - 요소를 제거하려면 배열의 길이에 비례하는 여러 단계가 필요하다.
        - 배열이 다음 요소를 모두 새 위치로 밀어 넣어야 하므로..
        - 코드가 빠를줄 알았으나, 뒤부터 시작해도 순서n단계를 수행해야하기 떄문에 정방향으로 하든 뒤로 하든 상관이 없다.
        
        → 각 요소에 대해 한 번씩 n 단계를 수행해야하고, 최대 n개의 요소를 선택할 수 있으므로 총 단계수는 n의 제곱에 비례한다.
        큰 수? 50 → 2500, 100 → 10000
        
    - 해결 방법 (1)
        - 모양이 선택된 곳에서 `shapes.removeall` → removeAll n(선형)

> 선형 알고리즘, 2차 알고리즘의 차이
- 2차 알고리즘이 더 좋아보일 수 있지만, 계속해서 보게 되면 언제나 선형 알고리즘이 이기는 지점을 찾을 수 있다.
> 

### `removeAll(where)`

> 일부 메서드(x) →포괄적인 알고리즘
> 
- 변경 가능한 컬렉션에서 제공되는 요소를 재정렬하는 기능과 범위 교체 가능 컬렉션에서 제공되는 길이 및 구로를 변경하는 기능에 따라 달라짐.
- 몇가지 다른 n차 알고리즘으로 만들어짐
    - 1. `halfStablePartition` - 일부 술어를 만족하는 모든 요소를 끝까지 이동하고 해당 접미사가 시작하는 위치를 알려주는 메소드
    - 2. `removeSubrange` - 하위 범위를 삭제해주는 메소드

### `halfStablePartition`

1. 접미사에 속하는 첫 번째 요소의 위치를 찾기 위해 또 다른 알고리즘인 `firstIndex(where)` 를 호출
2. 루프 변수 `j` 를 설정하고 반복해서 앞으로 이동합니다.
3. `j` 가 요소를 한 번만 통과한다면 확실한 내기 입니다.
4. 그것만으로 질서와 복잡성을 알 수 있습니다.  → O(n)   
5. 메서드는 요소를 재정렬해야 하지만 컬렉션의 길이나 구조를 변경하지 않기 때문에 변경 가능한 컬렉션 준수에만 의존합니다.

### Swift 표준 라이브러리에 있는 내용에 익숙해져라

- 문서화된 의미와 성능 특성이 있는 알고리즘 모음이 포함되어 있다.
- 구현을 살펴보고, 많은 것을 배울 수 있지만, 그럴 필요가 없도록 설계되었다.
- 공식문서는 라이브러리를 효과적으로 사용하기 위해 알아야할 모든 것이 있다.

<aside>
👉   **로직에 주석을 추가해도 알고리즘을 사용하면 모든 면에서 코드가 좋아진다**

</aside>

### Shawn Perin 제안한 코드에 대한 지침 포부

> 루프를 작성할 떄마다 알고리즘 호출로 대체하십시오.
하나를 찾을 수 없으면 해당 알고리즘을 직접만들고 루프를 구현으로 이동하십시오.
> 

## 다시 프로젝트

기능: 앞으로 가져오고, 뒤로 보내고, 앞으로 가져오면 선택한 모양이 앞에 있는 모양 위로 건너뜁니다.

목표: 작업이 완료된 후 선택한 모든 요소를 서로 옆에 두는 것

### 앞, 뒤, 가져오기 함수

- 기존: `remove(at:)`O(n) + `inset(at:)`O(n) = O(n2)
- 해결
    - “선택한 도형을 상대적 순서를 유지하면서 이동한다..”
    `stablePartition(isSuffixElementL (Element) → Bool) → Index`
    → O(n log n) 거의 선형과 동일한 취급

### 중간에 삽입을 해야하는 경우

- 기존: 앞쪽에서 선택한 요소의 위치 앞으로 가져가고 그 뒤에 선택된 요소를 모임
- 해결:
    1. 가장 앞에서 선택한 요소를 찾고
    2. 이전 요소에서 시작하는 배열 섹션을 분리해 분할 → 슬라이스 활용 (Shape `[predecessor...]`)
    
    → 필요없는 앞의 부분을 자르고 위의 사용한 알고리즘을 사용 후 다시 붙이는 방법
    

## 제네릭하게 만들기

1. 객체에서 분리하고 Shape 배열로 이동
2. 배열 슬라이스, 인덱스가 0에서 시작하는 않는다는 사실. 
→ 모든 슬라이스의 인덱스는 슬라이스된 기본 컬렉션의 해당 인덱스로 시작합니다.