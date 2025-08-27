include ./file

var x :i32  # Toplevel variable declaration

proc main *() :i32=
  var arr :array[42, int]  # Unbounded array (conceptually)
  var y :i32 = 0  # Variable declaration with assignment
  while x < 43:
    x = x + 2   # Increment
    x = x - 1   # Decrement
    arr[x] = y  # Store value
    y = arr[x]  # Retrieve value
    if x == 42:
      break
    if x != 42: y = y + 1
  return x

