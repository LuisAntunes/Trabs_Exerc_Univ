var(id(n,var,int), int_literal(26): int).

fun(sub, [arg(i1, int), arg(i2, int)],
  body([], 
    nil,
    minus(id(i1,arg,int): int, id(i2,arg,int): int): int)).

fun(fibonacci, [arg(n, int)],
  body([
      var(id(r,local,int), nil)
    ], 
    if(
      or(
        eq(id(n,arg,int): int, int_literal(0): int): bool,
        eq(id(n,arg,int): int, int_literal(1): int): bool): bool, 
      assign(id(r,local,int), id(n,arg,int): int), 
      assign(id(r,local,int),
        plus(
          call(fibonacci, [
            minus(id(n,arg,int): int, int_literal(1): int): int]): int,
          call(fibonacci, [
            call(sub, [
              id(n,arg,int): int, int_literal(2): int]): int]): int): int)),
    id(r,local,int): int)).

fun(main, [],
  body([
      var(id(fib,local,int), call(fibonacci, [id(n,var,int): int]): int)
    ], [
      print(id(fib,local,int): int),
      print(
        call(fibonacci, [
          plus(int_literal(14): int,
            times(int_literal(3): int,
              int_literal(4): int): int): int]): int),
      print(int_literal(121393): int)
    ],
    int_literal(0): int)).
