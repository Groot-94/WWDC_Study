# WWDC2020) Unsafe Swift

표준 라이브러리는 타입, 프로토콜, 메서드, 프로퍼티 등 다양한 구조를 제공합니다.

단 이들 중 명시적으로 "unsafe"로 표시 됩니다.

![](https://hackmd.io/_uploads/HJfuEe0In.png)

이것은 무엇을 의미할까

- 안전한 구조와 안전하지 않은 구조 사이의 구분은 그들이 제공하는 인터페이스에서 명확하지 않습니다.
- 구현이 유효하지 않은 입력을 처리하는 방식에 발생

표준 라이브러리에 있는 대부분의 작업은 실행 전 입력을 검증하므로 오류에 있어서 안정적으로 포착되고 보고 됩니다.

### Swift의 Optional 타입의 강제 언래핑 연산자

이 값이 잘못되면 런타임 오류 발생

![](https://hackmd.io/_uploads/S1RVSgCUn.png)

강제로 nil값을 풀려고 하는 것은 오류이지만 그 결과는 아래처럼 되어 있습니다.
 따라서 안전하지 않은 작업은 적어도 일부 입력에 대해서 기대치를 위반하는 동작이 보여야 합니다.
 
![](https://hackmd.io/_uploads/rknGIg0L2.png)

예를 들어 unsafely언래핑인 경우 강제 언래핑과 마찬가지로 기본 값이 nil이 아니어야 합니다.

하지만 최적화가 활성화된 상태로 컴파일이 되면 이 프로퍼티는 해당 요구사항을 확인하지 않습니다. nil이 아닌 값으로만 호출하고 직접 읽어낸다는 것을 신뢰 합니다.

만약 nil이 들어간다면??

충돌이 일어나거나 쓰레기 값을 반환할 수 있습니다. 결과가 계속 바뀌는 것이죠.

요점은 이 프로퍼티를 사용하게 되면 해당 요구 사항에 대해 충족할 책임을 진다는 것 입니다.

이것을 위반 시 결과는 예측 불가이며, 디버깅하기 어렵습니다.

이것은 표준 라이브러리에 있는 안전하지 않은 유형 및 작업의 전형적인 프로퍼티 입니다.

"안전하지 않은" 접두사는 위험 기호처럼 명명 규칙 입니다. 

코드에 내재된 위험을 경고하는 것이죠.

일반적으로 Unsafe를 사용하는 사례는 두 종류 입니다.
- C, Object-C와의 상호 운용성
- 런타임 성능이나 프로그램 실행에서의 세밀한 제어

![](https://hackmd.io/_uploads/r1GaDgAI3.png)

옵셔널의 `unsafelyUnwarpped` 프러퍼티는 두 번쨰 범주에 속합니다. nil 값에 대한 불필요한 검사를 제거할 수 있습니다.
옵셔널 검사의 작은 비용이 여전히 해로운 영향을 끼침, 그래서 nil값에 대해 검사가 불필요한 경우 넘길 수 있습니다.

![](https://hackmd.io/_uploads/Hk2tdeC8n.png)

Safe한 API가 no crashed를 의미하는 것이 아닌 그 반대 입니다.

Swift 표준 라이브러리는 C언어의 포인터와 거의 동일한 수준의 (Unsafe) 포인터 타입을 제공합니다.

![](https://hackmd.io/_uploads/Sy7L5lC83.png)

메모리 이야기 부터 먼저 하자면.

Swift는 플랫 메모리 모델을 사용합니다.

![](https://hackmd.io/_uploads/ByRwqxCL2.png)

메모리는 개별적으로 주소 지정이 가능한 8바이트의 플랫한 주소 공간으로 취급하고, 각 바이트에는 일반적으로 16진수 값으로 고유한 주소가 있습니다.

런타임에서, 주소 공간은 앱의 실행 상태를 나타내는 데이터들로 채워집니다.

![](https://hackmd.io/_uploads/rkLhclR83.png)

- 앱의 실행 가능한 바이너리
- import하고 있는 모든 라이브러리와 프레임워크
- 임시 변수, 함수의 파라미터 등에 대한 스택
- 클래스 인스턴스 스토리지를 포함한 동적 할당 메모리
- 이미지 파일 등 읽기 전용 리소스 파일

각 개별항목은 앱이 실행되면서 메모리 상태가 계속 변화합니다. 할당하고 사라지면서 일반적으로 Swift에서는 수동으로 메모리 관리할 필요가 없습니다.

오히려 수동으로 메모리 관리하게 되면 Unsafe포인터가 필요한 low-level한 작업들을 제공합니다. 따라서 Unsafe한 API이기 떄문에 제어에는 책임이 따릅니다.

주의해서 사용하지 않으면 오히려 앱을 망칠 수 있습니다.

![](https://hackmd.io/_uploads/ByVjox0L2.png)

정수 값에 대한 저장 공간을 동적으로 할당 시 직접적인 포인터가 제공됩니다. 

포인터는 메모리에 대한 제어를 제공하지만 관리를 하지 않습니다. 즉 메모리 위치가 추적이 불가능해 어떤일이 발생하는지 모르게 됩니다.

![](https://hackmd.io/_uploads/HJG1he0I2.png)

메모리 초기화하고 할당 해제를 했는데도 포인터가 무효화되었는지 유효화되었는지 모릅니다. 포인터 자체가 자기 자신이 상태를 모르기 떄문에 역참조가 일어날 수 있습니다.

운이 좋다면 할당 해제가 되어 바로 충돌이 일어 날 수 있습니다. 하지만 보장할 수 없습니다.

그리고 포인터의 동작은 Unsafe하기 떄문에 후속 동작이 보장되지 않습니다. 그래서 동일한 주소를 재사용하여 다른 값을 저장할 수 있고, 다른 데이터를 조작할 수 있게 되어 손상 될 수 있습니다.

![](https://hackmd.io/_uploads/HJzY2g0Ih.png)

하지만 Xcode의 Address Sanitizer라는 도구를 통해 이러한 문제를 디버깅할 수 있습니다.

---

그럼 포인터를 왜 써야하나 이러한 문제점이 있는데

가장 큰 이유는 C, Objectivce-C와 같은 언어와의 상호 운용성을 제공하기 떄문입니다. 이러한 언어에서는 포인터 인자를 사용하기 떄문에 Swift에서 호출할 수 있으려면 Swift값에 대한 포인터를 생성하는 방법을 알아야 합니다. 

C언어 API는 이러한 매핑을 통해 Swift로 번역됩니다.

![](https://hackmd.io/_uploads/H1nGTxR8h.png)

예를 들면 정수 값 버퍼를 처리하는 이러한 C언어 함수를 Swift로 이렇게 구현할 수 있습니다.

![](https://hackmd.io/_uploads/HynV6eCUn.png)

사용예시를 살펴보자.

static 메서드인 allocate()를 통해 동적 버퍼를 생성하고, 버퍼의 요소를 특정 값으로 설정 합니다. 

설정이 끝나면 C함수에 대응하는 process_integers를 사용하여 초기화된 버퍼에 대한 포인터를 전달할 수 있습니다.

이 소멸과 할당 해제 과정까지 모든 단계가 Unsafe합니다.

단계적으로 나눠서 잠재적인 위험은 다음과 같습니다.

- 할당 단계
    - 버퍼의 생명주기는 관리되지 않으므로 수동으로 할당 해제해야합니다. 그렇지 않으면 메모리 누수로 영원히 남아있게 됩니다.

- 초기화 단계
    - 지정된 위치의 주소가 할당한 버퍼 내에 있는지 자동으로 확인하지 않습니다.
    - 주소를 잘못 지정 시 다른 동작을 할 수 있습니다.

- 함수 호출 단계
    - 버퍼의 소유권을 알아야 합니다.
    - 함수 호출 기간 동안만 액세스하고 유지할 것인지, 할당 해제등을 시도하지 않는다고 가정합니다.

- 소멸 단계
    - 메모리가 올바르게 초기화된 경우입니다.

- 할당 해제 단계
    - 메모리 공간이 할당되어 있고, 소멸 상태에 있는 메모리만 할당 해제할 수 있습니다.


이러한 이유가 표준 라이브러리가 UnsafeBufferPointer를 제공하는 이유 입니다.

개별 값에 대한 포인터가 아니라 메모리 영역으로 작업해야할 떄 유용합니다.

버퍼를 시작위치, 길이 값의 쌍으로 모델링합니다. 이를 통해 버퍼의 경계를 사용할 수 있어 Out of Bounds 문제를 확인할 수 있습니다.

![](https://hackmd.io/_uploads/Sy_HJZ0I3.png)

Swift의 표준 컬렉션은 이러한 Unsafe 메서드를 사용한 버퍼 포인터를 사용하여 저장 공간 버퍼에 임시적인 접근을 제공합니다.

![](https://hackmd.io/_uploads/HJj_y-CI3.png)

그리고 개별 값에 대한 임시 포인터를 얻을 수 있으며 C함수에 매개변수로 전달할 수 있습니다.

![](https://hackmd.io/_uploads/B1T9ybCL3.png)

Swift 코드에서 C함수로 포인터를 전달하는 예시 입니다.

이러한 방법들이 여전히 나중에 메모리액세스에서 예상치 못한 동작이 발생할 수 있다는 것은 명심해야 합니다.

![](https://hackmd.io/_uploads/By1xl-AL3.png)

Swift의 암시적인 값-포인터 변환 목록 입니다.

![](https://hackmd.io/_uploads/HJZzgW0L2.png)

더 복잡한 C언어 예시입니다. systcl 함수는 여러 포인터와 값들을 매개변수로 사용 합니다.

![](https://hackmd.io/_uploads/BkAXxb0Ln.png)

대응되는 Swift 코드를 사용하여 함수를 호출하는 모습입니다. 여기에 중요한 점은 모두 Unsafe 함수를 사용하기 때문에 이들을 단일 함수로 호출하는 것만으로도 유효성검사를 통해 위험을 방지하는데 도움이 됩니다.

![](https://hackmd.io/_uploads/Sk2seWCLh.png)

이러한 클로저 형태는 포인터의 수명을 더욱 알 수 있습니다. 위에 경고창은 정의되지 않은 동작이므로 경고를 생성합니다.

![](https://hackmd.io/_uploads/Byo0e-A8h.png)

추가적인 개선은 새로운 초기화 구문을 제공합니다. 이 방법 사용 시 초기화 되지 않은 저장 공간에 데이터를 복사하여 생성하기 때문에 임시 버퍼를 할당할 필요가 없습니다.