# Understanding Swift Performance

## 💎 배경

> Swift에는 다양한 코드 재사용 및 역동성을 위한 다양한 퍼스트 클래스 유형과 다양한 추상화 메커니즘이 존재한다. 그렇다면 작업에 적합한 도구를 선택하려면 무엇을 고려하는게 좋을까?
> 

## 💎 해결방안

> **Swift의 다양한 추상화 메커니즘의 모델링 의미를 고려한다. 세부적으로 성능은 다음의 세 가지 요소로 그 척도를 가늠할 수 있다.**
> 

- **성능 영향 요인**
    - **Memory Allocation**
        - Stack
            
            ![스크린샷 2023-04-26 오후 6.44.24.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/bb965371-a3a6-4252-958a-b0ce276624cd/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.44.24.png)
            
            - Stack의 끝에서만 추가(push) 및 제거(pop)
            - 따라서, Stack Pointer 증감을 통한 할당 및 해제
                - Stack Pointer를 약간만 줄여 공간을 함으로써 메모리 할당하는 구조
                - 매우 빠른 속도
            - 작동방식
                
                ![스크린샷 2023-04-26 오후 6.45.41.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d784ee1d-d4fd-4241-bc8c-d4b9d807c142/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.45.41.png)
                
                ![스크린샷 2023-04-26 오후 6.46.16.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/12884884-e7dc-46dc-ba33-d0c7300c752f/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.46.16.png)
                
        - Heap
            
            ![스크린샷 2023-04-26 오후 6.44.44.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a6ea5e73-67cb-4fcb-bf9c-c805d96b9def/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.44.44.png)
            
            - Advanced Data Structure
                - Stack과 달리 Dynamic Lifetime
            - Stack보단 비효율적
                - 메모리 할당을 위해 적절한 크기의 사용하지 않은 블럭을 찾기 위해 Heap Data Structure 검색
                - 메모리 할당 해제를 위해 해당 메모리를 적절한 위치에 재삽입
                - 이는 Stack에서 정수 할당보다 복잡한 작업이나 그렇게 큰 비용은 X
                - 오히려, **무결성 보호**를 위한 lock 또는 기타 동기화 메커니즘이 큰 비용 초래 → Thread Safety Overhead
            - 작동방식
                
                ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/af89420b-b25e-4d58-a0d7-b660c5905421/Untitled.png)
                
                ![스크린샷 2023-04-26 오후 6.47.38.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8a98fbeb-afe4-478e-b7b6-da8bbea4f7cd/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.47.38.png)
                
                ![스크린샷 2023-04-26 오후 6.48.11.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/053eb001-e54c-469b-aac4-316115d9f2f3/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.48.11.png)
                
                ![스크린샷 2023-04-26 오후 6.47.56.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/840c46e6-47ca-4218-a8b1-f99fca2b9640/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.47.56.png)
                
    - **Reference Counting**
        - No
            - Struct
                
                ![스크린샷 2023-04-26 오후 7.14.17.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/47c007c9-53ef-49da-a697-9ff395258d10/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.14.17.png)
                
                - No Reference Counting
                - 작동방식
                    
                    ![스크린샷 2023-04-26 오후 7.03.51.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b46514d3-0cd9-4f79-9a36-279f58c3456b/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.03.51.png)
                    
            - Struct containing references
                
                ![스크린샷 2023-04-26 오후 7.13.15.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7f00d1e7-e0b1-4610-bc2a-70174a83327a/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.13.15.png)
                
                ![스크린샷 2023-04-26 오후 7.13.19.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f700926d-4ad3-48ef-9399-e301daf12893/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.13.19.png)
                
                - struct 내부 reference 타입 프로퍼티에 비례하여 ref count 비용 발생
                - 따라서, reference 타입의 프로퍼티를 value 타입으로 변경하는 Modeling Technique로 Reference Counting 비용을 줄일 수 있도록 노력
                - 작동방식
                    
                    ![스크린샷 2023-04-26 오후 7.05.30.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/305b6277-c74d-41e1-bced-e7fa0cffe550/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.05.30.png)
                    
                    - String은 Value Semantics지만, 내부 storage로 class타입 가짐
                    - UIFont는 애초에 class 타입
                    
                    ![스크린샷 2023-04-26 오후 7.05.36.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ac76645d-8e3d-4a8d-8fd0-08b9e2e1bf3d/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.05.36.png)
                    
                    ![스크린샷 2023-04-26 오후 7.05.46.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3648f527-d11c-4c3d-b3f6-9abe1ebe833d/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.05.46.png)
                    
        - Yes
            
            ![스크린샷 2023-04-26 오후 7.14.32.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9c74f658-59ce-4776-a450-e184543a83d5/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.14.32.png)
            
            ![스크린샷 2023-04-26 오후 6.57.09.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/04c73ecc-53c6-44a1-9b9e-b995c7a4328f/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_6.57.09.png)
            
            - 증가 및 감소 실행을 위한 몇가지 간접 참조 존재
            - Heap Allocation과 마찬가지로 Thread Safety Overhead
                - 여러 스레드의 힙 인스턴스에 참조를 추가하거나 제거할 수 있기 때문
                - 스레드 안전성을 고려 필요
                - 실제로 참조 수를 Atomically(=Thread Safe) 증가 및 감소
            - 작동방식
                - Class
                    
                    ![스크린샷 2023-04-26 오후 7.00.02.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/63f6d1b2-8cc4-4cf2-8031-ca350f4c4972/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.00.02.png)
                    
                    ![스크린샷 2023-04-26 오후 7.01.22.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/97002e32-06c3-4027-b35b-f01e2164a2f9/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.01.22.png)
                    
                    ![스크린샷 2023-04-26 오후 7.01.43.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4ee4a799-d7c5-4c19-9dea-dc16c6fb2161/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.01.43.png)
                    
                    ![스크린샷 2023-04-26 오후 7.01.55.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b7629af9-93d9-400b-860f-491897624889/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.01.55.png)
                    
                
    - **Method Dispatch**(메서드 호출)
        - Static(컴파일 시 호출)
            
            ![스크린샷 2023-04-26 오후 7.19.45.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3d48d2bf-43f3-4e8a-aa7e-dba0abb96aae/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.19.45.png)
            
            - 런타임에 구현부로 바로 이동 가능
            - 컴파일러가 실세 구현에 대한 가시성을 가짐
            - 즉, 메소드 인라이닝(Method Inlining) 등과 같이 코드 최적화 가능
                
                > 메소드 인라이닝
                **→** 메소드를 호출 할 때 해당 메소드로 이동하지 않고 메소드의 결과값을 바로 반환하여 성능을 향상 시키는 것입니다.
                > 
        - Dynamic(런타임 시 호출)
            
            ![스크린샷 2023-04-26 오후 7.25.02.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/83c754a7-244e-4a00-8e5e-3a29188ed727/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.25.02.png)
            
            - 어떤 구현으로 이동할지 컴파일 타임에서 알 수 없음
            - 따라서, 런타임에 실제 구현 조회한 다음 해당 구현으로 jump
            - 동적 디스패치 자체로는 indirection은 한번이므로 비용이 많이 들지 않음
            - 그러나, 컴파일러의 가시성을 차단하므로 정적 디스패치에서의 최적화 효과는 기대할 수 없어 비용을 높게 측정
            - **Polymorphism(다형성)과 같은 강력한 기능을 가능케 함**

- **Polymorphism**
    - **Class**
        
        ![스크린샷 2023-04-26 오후 7.39.37.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5444f1a1-5d93-4cb8-bdbc-72494e9ce983/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.39.37.png)
        
        - 컴파일러는 class에 대한 타입 정보를 가지고 있음
        
        ![스크린샷 2023-04-26 오후 7.40.40.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3de30c3b-2b0e-4e27-99ef-d5ff362510de/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.40.40.png)
        
        ![스크린샷 2023-04-26 오후 7.41.04.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ff8d9710-f226-4d42-b5aa-389b24d9f7de/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.41.04.png)
        
        - 이 정보에는 class의 가상 함수에 대한 포인터를 가진 **가상 메서드 테이블(V-Table)**이 포함
        - 이 테이블은 클래스의 정적 메모리에 저장
        
        ![스크린샷 2023-04-26 오후 7.41.45.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/790a7435-97af-4b1d-9bf9-ac8bb8fe2eee/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.41.45.png)
        
        ![스크린샷 2023-04-26 오후 7.41.52.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/92e8cad1-053d-493b-a293-898a80022e91/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.41.52.png)
        
        - 실제 코드에서 특정 가상 함수를 호출할 때, 컴파일러는 해당 클래스의 타입 정보를 통해 V-Table에서 올바른 구현을 찾아 호출
            - `d.type.vtable.draw(d)`
            - 즉, 구현을 찾기 위해 V-Table을 통해 조회하는 것을 엿볼 수 있음
        - 이를 통해 다형성을 구현
        - 그렇다고, 모든 클래스에 동적 디스패치가 필요한 것은 X
            - 클래스를 subclass로 분류하지 않으려는 경우, **final class**로 표시하여 의도 전달 가능
    - **Protocol**
        - 프로토콜은 V-Table이 존재하지 않음에도 다형성을 어떻게 구현할까?
            
            ![스크린샷 2023-04-26 오후 8.52.50.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e73198ff-f390-4d55-a1b1-b785180c2e03/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.52.50.png)
            
            ![스크린샷 2023-04-26 오후 8.53.06.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1774c714-61d7-4a8b-bd59-a65f42a2ed7e/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.53.06.png)
            
        - **Existential Container**
            
            ![스크린샷 2023-04-26 오후 8.52.18.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a544f258-ac85-4951-9d4b-f30a7bdac758/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.52.18.png)
            
            ![스크린샷 2023-04-26 오후 8.52.24.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d7fd7061-7be5-4759-8c2e-9d6055a68016/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.52.24.png)
            
            - Existential Container는 프로토콜 타입을 나타내는 런타임 객체
            - 프로토콜을 채택하는 모든 타입이 해당 프로토콜을 채택한 것처럼 보이게끔 만듦
            - Existential Container는 값을 저장하고, 해당 값을 사용하는 코드를 작성하기 위해 VWT와 PWT와 함께 사용
            - Inline Value Buffer → 3 words
                - 32bit CPU → 1 word = 32bit
                - 64bit CPU → 1 word = 64bit
                - 3 words 초과시 heap에 저장
                - VWT 참조
                - PWT 참조
        - **Value Witness Table(VWT)**
            
            ![스크린샷 2023-04-26 오후 8.52.35.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c610c1f2-423f-4582-9712-1075d84056a4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.52.35.png)
            
            - VWT는 타입이 저장된 메모리 영역의 레이아웃을 나타냄
            - 이를 통해 Swift 컴파일러는 메모리를 효율적으로 사용하고, 코드를 최적화 가능
            - Protocol을 구현하는 타입마다 존재
            - Existential Container 내 메타데이터 영역의 VWT에 포인터를 가지고 있어서 copy가 되더라도 VWT 데이터를 계속 가져갈 수 있음
        - **Protocol Witness Table(PWT)**
            - PWT는 프로토콜이 구현되는 방식을 설명하는 테이블
            - 프로토콜의 각 요구사항에 대한 구현체를 가리키는 **함수 포인터**를 저장
            - 즉, 프로토콜을 채택한 타입이 프로토콜의 요구사항을 충족시키기 위해 구현한 **함수**를 PWT에 등록
            - 그러면 Existential Container는 해당 PWT를 가리키고, 이를 통해 **프로토콜을 구현한 함수를 호출** 가능
        - 작동방식
            - Existential Container 생성
                
                ![스크린샷 2023-04-26 오후 9.09.00.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/6d249a65-dd72-4262-b1a2-447b613569c6/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.09.00.png)
                
            - VWT가 메모리 레이아웃을 정의
                
                ![스크린샷 2023-04-26 오후 9.09.10.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0382a04e-e531-4282-99fc-2d0015119af4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.09.10.png)
                
            - PWT가 프로토콜을 구현하는 방식을 정의
                
                ![스크린샷 2023-04-26 오후 9.09.20.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fecb2f6b-f76f-4c13-b10c-a1d230a955a7/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.09.20.png)
                
            - VWT를 통해 Value Buffer에 들어갈 수 있는지 구분
            - 3 words 이내인 Point 타입 인스턴스는 Existential Container에 값 모두 저장
                
                ![스크린샷 2023-04-26 오후 9.15.04.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/dbe9a87a-f7cd-4523-ac22-100868421b4d/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.15.04.png)
                
            - 3 words를 초과한 Line 타입 인스턴스는 Heap 할당하여 값 저장
            - Existential Container에 해당 레퍼런스 저장
                
                ![스크린샷 2023-04-26 오후 9.15.11.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1a1bc0f4-aa46-47e3-a6de-f1c8509729e4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.15.11.png)
                
            - PWT를 통해 method dispatch
                
                ![스크린샷 2023-04-26 오후 9.15.17.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/471e4799-ae61-40fa-baab-8630dc733d32/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.15.17.png)
                
                ![스크린샷 2023-04-26 오후 9.15.37.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/50ef0f1b-9b5b-4f30-b285-e1e229e7ea7e/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.15.37.png)
                
                ![스크린샷 2023-04-26 오후 9.15.50.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fad04600-2248-4a09-b844-0bd1c482d619/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.15.50.png)
                
                ![스크린샷 2023-04-26 오후 9.16.01.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/28f389a5-1824-45a4-a2e8-9484409b97ac/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.16.01.png)
                
            - 할당 해제
                
                ![스크린샷 2023-04-26 오후 9.16.10.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5844efb0-be5b-4979-8b7e-ff05378f115e/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.16.10.png)
                
                ![스크린샷 2023-04-26 오후 9.16.19.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3e09cc5f-e787-4e9a-bc5a-0c60eeaa9669/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.16.19.png)
                
                ![스크린샷 2023-04-26 오후 9.16.27.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/afb6fd15-bf10-47fa-b868-aaaea7573d68/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.16.27.png)
                
                ![스크린샷 2023-04-26 오후 9.16.37.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/13048106-426c-46a0-a10a-fdc6fd0ef596/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.16.37.png)
                
            

> **지역 변수가 복사되는 방식과 프로토콜 유형의 값에 대해 메서드 디스패치가 작동하는 방식을 다루어 보았으니 Stored Property에 대해서도 알아보자!**
> 

- **Protocol Type Stored Properties**
    - **일반적인 경우**
        - 두 개의 Existential Container를 둘러싸는 struct의 inline에 저장
            
            ![스크린샷 2023-04-26 오후 9.32.06.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/70a7bf97-944a-4146-888d-16fdf666a3e6/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.32.06.png)
            
        - 초기화
            
            ![스크린샷 2023-04-26 오후 10.03.05.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c4dc0895-6982-4316-992e-d5cbcb11fc0f/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.03.05.png)
            
        - 동적 다형성 지원
            
            ![스크린샷 2023-04-26 오후 10.03.58.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/84dfeba8-968d-4c05-9b65-233edd28b8fc/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.03.58.png)
            
        
    - **Expensive Copies of Large Values**
        - 문제상황
            - Large Value 생성
                
                ![스크린샷 2023-04-26 오후 10.06.24.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/291a51dd-4562-424d-a7fa-2e152cc8fab1/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.06.24.png)
                
                - 두 개의 heap 할당 발생
            - Copy로 인하여 heap 할당에 많은 비용 발생
                
                ![스크린샷 2023-04-26 오후 10.09.03.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f5674c07-12d8-4153-8f57-ec175e1e3ead/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.09.03.png)
                
        - 해결방안: **Indirect Storage**
            - 이를 해결하기 위해 Indirect Storage 적용
            - reference는 1 word로 value buffer에 fit하므로, 같은 값을 참조하도록 변경
            - 추가된 비용은 refCount 뿐이므로 비용 절감 효과
                - 비용: Heap 할당 → ref Count 증가
            - 실제 existential container에서 넘어갈 때 생성된 heap이 아니라 LineStorage에 대한 레퍼런스만 저장
                
                ![스크린샷 2023-04-26 오후 10.11.28.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/49b2ebb9-4b2e-41eb-82ce-45a9864fc1c7/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.11.28.png)
                
                - 그러나, 상태 공유 문제 발생
                    
                    ![스크린샷 2023-04-26 오후 10.13.08.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/59649fd8-321d-42ca-924d-9391218ea0fe/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.13.08.png)
                    
                
        
        > **Expensive Copies of Large Values에서 참조를 통해 비용을 절감하였으나, 우리가 원하는 value semantics를 구현하기 위해서는 어떤 조치를 취해야 할까?**
        > 
        - 해결방안: **Indirect Storage with Copy On Write(COW)**
            - Line 구조체 내부에 직접 저장소를 구현하는 대신 LineStorage라는 클래스를 만들어서 이 저장소를 참조하도록 함
                
                ![스크린샷 2023-04-26 오후 10.36.48.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/21499d17-136e-4c58-8bb8-e88bfa48f2b1/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.36.48.png)
                
                ![스크린샷 2023-04-26 오후 10.37.05.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b7ed0c6a-75ba-44c7-a3ea-994dcbb74706/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.37.05.png)
                
            - 이로써, 값을 읽는 경우 해당 스토리지 내부의 값을 읽으면 되고, 값을 수정하려는 경우 먼저 참조 횟수를 확인한 다음, 1보다 큰 경우 라인 스토리지의 복사본을 만들어 이를 변경하도록 함
                
                ![스크린샷 2023-04-26 오후 10.37.34.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0917bec8-e3f7-4c70-95c8-150d686c9f8f/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.37.34.png)
                
                ![스크린샷 2022-07-24 오후 8.11.53.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5c24fba2-e504-495d-8d50-aaf59353c6fa/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-07-24_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_8.11.53.png)
                
            - 이 방법을 사용하면 참조만 복사되고, 참조 횟수 증가하므로, 힙 할당보다 훨씬 저렴하게 작동
                
                ![스크린샷 2023-04-26 오후 10.38.46.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c23fbd39-88f2-4d41-9bd0-b31cd5b29889/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.38.46.png)
                
        

> **Protocol Type 중간 정리

1. Dynamic Polymorphism 제공
2. PWT, VWT, Existential Container를 통해 프로토콜과 함께 값 유형을 사용할 수 있으며, 프로토콜 유형의 배열 내부에 다양한 타입 제공 가능
3. Large Value일 경우 Heap Allocation 발생 → Indirect Storage & COW를 통해 해결 가능**
> 

- **Generic**
    - **Static Polymorphism(=Parametric Polymorphism) (↔ Dynamic Polymorphism)**
        
        ![스크린샷 2023-04-26 오후 10.56.43.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/de3e50b7-965a-439c-94ca-46fe50d87142/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.56.43.png)
        
        - 호출 컨텍스트당 하나의 타입을 사용
        - 즉, 메서드가 일반 매개변수를 가지고 있을 때, 이 매개변수는 호출되는 컨텍스트에서 사용되는 타입으로 바인딩
        - 이는 곧, Parametric Polymorphism라고도 불리며, 매개변수를 따라 call chain 아래로 대체되는 것을 의미
        - 컴파일 시점에 호출하는 곳마다 타입이 정해져 있음
        - 런타임 시점에 변경 X
        - 특수화(specialization) 가능 의미
        - 작동방식
            
            ![스크린샷 2023-04-26 오후 11.12.38.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/44c0757c-3ca7-4016-aa33-70ab498e29b2/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.12.38.png)
            
            - Swift 내부에서는, VWT와 PWT를 사용하여 프로토콜 타입과 값 타입 모두에 대한 하나의 공유 구현(shared implementation)을 가짐
            - 하지만, 호출 컨텍스트당 하나의 타입을 가지므로, **Existential Container 존재 X**
            - 대신, 호출 사이트에서 사용되는 Point와 같은 타입의 VWT PWT을 모두 추가 인수로 전달
            - 그러면 함수를 실행하는 동안, Swift는 VWT을 사용하여 변수에 필요한 버퍼를 heap에 할당하고 할당 소스에서 대상으로 복사
            - 마찬가지로, 메서드를 실행할 때도 전달된 PWT을 사용하고, 테이블에서 고정 오프셋의 메서드를 찾아 구현부로 이동
            
            > **Existential Container가 없는데, Swift는 로컬 매개변수에 필요한 메모리를 어떻게 할당할까?**
            > 
            
            ![스크린샷 2023-04-26 오후 11.16.13.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/946dcb37-d943-43fb-88a2-e8443cc330e6/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.16.13.png)
            
            - Swift는 valueBuffer라는 스택에 메모리를 할당하여 로컬 변수에 필요한 메모리를 할당
            - valueBuffer는 작은 메모리 크기의 값에 적합
            
            ![스크린샷 2023-04-26 오후 11.17.40.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/348e7ae2-5c83-4f2d-86b5-18d5c9d0dfb5/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.17.40.png)
            
            - 큰 값은 다시 힙에 저장되며, **로컬 existential container 내부에** 해당 메모리에 대한 포인터를 저장
    - **Specialization**
        - Static Polymorphism을 통해 컴파일러가 최적화 수행 가능
        - 예를 들어, Point와 Line 클래스가 있고 Point를 인자로 받는 drawACopy 함수가 있다면, Swift는 호출 사이트에서 사용되는 타입별로 버전을 생성하여 해당 유형에 특정한 함수 버전을 생성
            
            ![스크린샷 2023-04-26 오후 11.34.09.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e3673440-5462-4f6f-8245-12abd558034f/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.34.09.png)
            
            ![스크린샷 2023-04-26 오후 11.34.15.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2e913ec7-547b-41a2-8a40-64b7725f244c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.34.15.png)
            
            ![스크린샷 2023-04-26 오후 11.34.32.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d9d08bd2-fc93-499d-9661-f58700cec509/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.34.32.png)
            
        - 이를 통해 빠른 코드 실행이 가능
        - 또한, 코드 크기를 줄일 수 있음
            - 사용할 수 없는 정적 타이핑 정보가 공격적인 컴파일러 최적화를 가능하게 하기 때문
                
                ![스크린샷 2023-04-26 오후 11.34.42.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e7dc9ee6-088e-40d7-9b1f-25e288fdc970/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.34.42.png)
                
                ![스크린샷 2023-04-26 오후 11.34.52.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/d3b1e2ab-d98a-4dea-a4bc-eb39d6e10908/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.34.52.png)
                
                ![스크린샷 2023-04-26 오후 11.35.05.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f11b6157-7611-4715-80fe-dafed9057bbb/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.35.05.png)
                
        - Specialization 가능 요건
            
            ![스크린샷 2023-04-26 오후 11.40.42.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fa4bb84c-1226-4c5a-babf-1dcb90b3208c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.40.42.png)
            
            - 해당 호출 사이트에서 사용되는 유형을 유추할 수 있어야 함
            - 이를 위해서는 로컬 변수를 확인하고 초기화로 돌아가서 해당 유형을 확인
            - 또한, 해당 함수를 Specialize하기 위해서는 사용 가능한 Generic 함수와 함께 해당 함수를 사용하는 모든 타입에 대한 정의가 필요
            
            ![스크린샷 2023-04-26 오후 11.43.46.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/7e44d8f9-37bd-4a91-8954-d33bf7dcb9dd/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.43.46.png)
            
            - Whole Module Optimization을 통해 범위를 늘리는 것도 방법
    

> **이를 통해 PWT와 VWT를 사용하여 Unspecialization 코드가 작동하는 방식과 컴파일러가 제네릭 함수의 타입별 버전을 생성하는 코드를 Specialization 방법을 살펴봄**
> 

## 💎 요약

![스크린샷 2023-04-27 오전 12.06.08.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/812c834c-129d-4c77-934a-69f38c2b6769/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-27_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_12.06.08.png)

- 프로그래밍에서 엔터티를 추상화할 때, dynamic runtime type requirements가 적은 경우 → static type 검사가 활성화되도록 value type을 사용하는 것이 좋음
- struct
    - value type을 사용하면 상태 공유가 없어지며, 최적화 가능한 코드를 얻을 수 있음 → Value Semantics
- class
    - identity
    - OOP style polymorphism
- Generics
    - static polymorphism
- Protocol
    - 필요한 경우에는 Dynamic Polymorphism을 위해 프로토콜 타입과 값을 결합하여 사용 가능
- **Performance 비교**
    
    ![스크린샷 2023-04-26 오후 7.49.05.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/97db2a3a-f7b8-40d7-a212-2972e05e9cb7/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.49.05.png)
    
    ![스크린샷 2023-04-26 오후 7.48.39.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f9166358-6986-4bb8-8b37-820439bc3d37/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.48.39.png)
    
    ![스크린샷 2023-04-26 오후 7.48.52.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/5705a6ce-dd46-46d6-b5c7-18d136e455b4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_7.48.52.png)
    
    ![스크린샷 2023-04-26 오후 10.43.10.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f2a4e509-9091-41ea-9b70-19cee357412c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.43.10.png)
    
    ![스크린샷 2023-04-26 오후 10.46.15.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/53e4bb8f-a00f-411f-b9c0-d058d1ceeb79/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.46.15.png)
    
    ![스크린샷 2023-04-26 오후 10.46.37.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/68592b53-a9f3-4f43-b2f6-88e5f37c5934/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.46.37.png)
    
    ![스크린샷 2023-04-26 오후 10.48.36.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/997c03ca-6e5b-4b4a-aae0-2943a605e8d5/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10.48.36.png)
    
    ![스크린샷 2023-04-26 오후 11.48.15.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9863a2ba-d175-451d-8b7e-15a316226d54/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.48.15.png)
    
    - struct를 포함한 Specialized Generics
        - struct 타입을 사용하는 것과 동일한 성능
            - 기본적으로 구조체 측면에서 이 함수를 작성한 것과 같기 때문
        - struct 타입의 값을 복사할 때 heap 할당 필요 X
        - struct에 참조가 포함되어 있지 않으면 ref count X
        - 컴파일러 최적화를 가능하게 하고 런타임을 줄이는 static method dispatch
    
    ![스크린샷 2023-04-26 오후 11.57.20.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c3ee50d4-7921-429c-a370-47beaaa36701/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.57.20.png)
    
    - class 타입을 사용하면 class와 유사한 특성을 가짐
        - 인스턴스 생성시 heap 할당
        - 값 전달을 위한 reference counting
        - V-Table을 통한 Dynamic method dispatch
    
    ![스크린샷 2023-04-26 오후 11.58.51.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2b1e6a0c-1905-422d-9b50-3246501a4b74/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_11.58.51.png)
    
    - small value을 포함하는 Unspecialized Generics
        - small value이 스택에 할당된 valueBuffer에 맞기 때문에 로컬 변수에 필요한 heap 할당 X
        - 값에 참조가 포함되어 있지 않으면 ref count X
        - 그러나 PWT을 사용하여 모든 잠재적 호출 사이트에서 하나의 구현을 공유
    
    ![스크린샷 2023-04-27 오전 12.01.11.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/dcd31b6d-b17a-40d1-9fcc-737fa9ea56a4/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-04-27_%E1%84%8B%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB_12.01.11.png)
    
    - large value을 포함하는 Unspecialized Generics
        - large value는 스택에 할당된 valueBuffer에 맞지 않기 때문에 로컬 변수에 필요한 heap 할당
            - Indirect Storage을 통해 해결 가능
        - large value에 참조가 포함되어 있으면 ref count 존재
        - Dynamic dispatch
            - 즉, 코드 전체에서 하나의 일반 구현을 공유

## 💎 참고 자료

- Understanding Swift Performance - Apple Developer

[Understanding Swift Performance - WWDC16 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2016/416/)

- 스위프트 성능 이해하기 - 유용하

[스위프트 성능 이해하기 - 유용하](https://www.youtube.com/watch?v=z1Gf6EosaUQ)
