# mini.nim | Minimalist subset of Nim
> What is the most minimal set of Nim features
> that would achieve a Turing Complete language?

## TODO
```md
# Required
- [ ] Literal Value (int)
- [ ] State (variables/assignment)
- [ ] Assignment and basic arithmetic (+ and -)
- [ ] Operations to check conditions (== and !=)
- [ ] Conditional Execution (if statements)
- [ ] Looping Construct (while)
- [ ] Unbounded Memory (conceptually): (arrays)
# Nim Inherited
- [ ] Meaningful Indentation
# Quality of Life features
- [ ] Includes
- [ ] Functions
  - [ ] return
    - [ ] Literal
    - [ ] Identifier
- [ ] Comments
```

## Turing Completeness
Turing Completeness, as understood by this language, can be achieved by:
- Ability to store state
- Ability to make decisions based on that state
- Ability to loop/repeat actions based on the state
- Minimal operations to modify that state
- Minimal operations to check conditions

### 1. Literal Value (int)
Ability to represent data  
_Without literal values, you can't represent input or constants_  
```nim
0
```

### 2. State (variables/assignment)
Ability to store state  
_Without state storage, you can't remember computation results_  
```nim
var x = 0   # Variable declaration with assignment
```

### 3. Assignment and basic arithmetic (+ and -)
Ability to modify state  
_Without state modification, you can't progress in calculations_  
```nim
x = x + 1   # Increment
x = x - 1   # Decrement
```

### 4. Operations to check conditions (== and !=)
Ability to make decisions based on that state  
_Without condition checking, you can't control program flow_  
```nim
x == 0
y != 0
```

### 5. Conditional Execution (if statements)
Ability to branch based on current state  
_Without branching, you can't make decisions_  
```nim
if x == 0:
  # code block
```

### 6. Looping Construct (while)
Ability to loop/repeat actions based on the state  
_Without loops, you can't handle arbitrary computations_  
```nim
while x != 0:
  # code block
```

### 7. Unbounded Memory (conceptually): (arrays)
Ability to handle arbitrarily large problems  
_Without (conceptually) unbounded memory access, you can't handle arbitrarily large computations_  
```nim
var arr: array[N, int]  # Unbounded array (conceptually)
arr[x] = y              # Store value
y = arr[x]              # Retrieve value
```
### 8. Quality of Life features
#### Functions
_note: Implemented to describe a main function_
_Could be avoided by treating the entire file as the body of the main function._
#### Comments
#### Includes

## Differences with Nim
`mini.nim` has its own compiler pipeline, written from scratch.  
Instead of using a Nim backend,  
this compiler generates human-readable C code.  

## Differences with [Minim](https://github.com/heysokam/minim)
### Design
The architecture of `minim` is the exact same as `mini.nim`,  
but this compiler is heavily restricted to the most minimal subset of the language possible.  
_I'd recommend using `minim` instead for any mildly complex projects._  
`mini.nim` aims to be as minimal as humanly possible, by design.  
### Implementation
While Minim is written in Zig, this compiler is written in pure C.  
Minim has minimal allocations and uses Data Oriented Design.  
`mini.nim`, on the other hand, freely allocates memory inside each object field that represents either a list or a list-of-lists.  
_eg: Proc.arguments_ 

