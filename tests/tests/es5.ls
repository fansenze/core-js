{isFunction, isNumber, isString} = Object
test 'Object.getOwnPropertyDescriptor' !->
  {getOwnPropertyDescriptor} = Object
  ok isFunction getOwnPropertyDescriptor
  deepEqual getOwnPropertyDescriptor(q:42, \q), {+writable, +enumerable, +configurable, value: 42}
  ok getOwnPropertyDescriptor({}, \toString) is void
test 'Object.defineProperty' !->
  ok isFunction Object.defineProperty
  ok (rez = Object.defineProperty src = {}, \q, value: 42) is src
  ok rez.q is 42
test 'Object.defineProperties' !->
  ok isFunction Object.defineProperties
  ok (rez = Object.defineProperties src = {}, q: {value: 42}, w: value: 33) is src
  ok rez.q is 42 and rez.w is 33
test 'Object.getPrototypeOf' !->
  {create, getPrototypeOf} = Object
  ok isFunction getPrototypeOf
  ok getPrototypeOf({}) is Object::
  ok getPrototypeOf(new class fn) is fn::
  ok getPrototypeOf(create obj = q:1) is obj
  ok getPrototypeOf(create null) is null
  ok getPrototypeOf(getPrototypeOf {}) is null
test 'Object.getOwnPropertyNames' !->
  {getOwnPropertyNames} = Object
  ok isFunction getOwnPropertyNames
  fn1 = (@w = 2)->
  fn2 = (@toString = 2)->
  fn1::q = fn2::q = 1
  deepEqual getOwnPropertyNames([1 2 3]), <[0 1 2 length]>
  deepEqual getOwnPropertyNames(new fn1 1), <[w]>
  deepEqual getOwnPropertyNames(new fn2 1), <[toString]>
  ok \toString in getOwnPropertyNames Array::
  ok \toString in getOwnPropertyNames Object::
  ok \constructor in getOwnPropertyNames Object::
test 'Object.create' !->
  {create, getPrototypeOf, getPropertyNames, isObject, isPrototype} = Object
  ok isFunction create
  ok isPrototype obj = q:1, create(obj)
  ok create(obj)q is 1
  fn = -> @a = 1
  ok create(new fn) instanceof fn
  ok fn:: is getPrototypeOf getPrototypeOf create new fn
  ok create(new fn)a is 1
  ok create({}, {a:value:42})a is 42
  ok isObject obj = create null w: value:2
  ok \toString not of obj
  ok obj.w is 2
  deepEqual getPropertyNames(create null), []
test 'Object.keys' !->
  {keys} = Object
  ok isFunction keys
  fn1 = (@w = 2)->
  fn2 = (@toString = 2)->
  fn1::q = fn2::q = 1
  deepEqual keys([1,2,3]), <[0 1 2]>
  deepEqual keys(new fn1 1), <[w]>
  deepEqual keys(new fn2 1), <[toString]>
  ok \join not in keys Array::
test 'Function.prototype.bind' !->
  ok isFunction Function::bind
  ok 42   is (-> @a)bind(obj = a: 42)!
  ok void is new ((->)bind obj)!a
  ok 42   is (-> it)bind(null 42)!
test 'Array.isArray' !->
  {isArray} = Array
  ok isFunction isArray
  ok not isArray {}
  ok not isArray do -> &
  ok isArray []
test 'Array::indexOf' !->
  ok isFunction Array::indexOf
  ok 0  is [1 1 1]indexOf 1
  ok -1 is [1 2 3]indexOf 1 1
  ok 1  is [1 2 3]indexOf 2 1
  ok -1 is [NaN]indexOf NaN
  ok 3  is Array(2)concat([1 2 3])indexOf 2
test 'Array::lastIndexOf' !->
  ok isFunction Array::lastIndexOf
  ok 2  is [1 1 1]lastIndexOf 1
  ok -1 is [1 2 3]lastIndexOf 3 1
  ok 1  is [1 2 3]lastIndexOf 2 1
  ok -1 is [NaN]lastIndexOf NaN
  ok 1  is [1 2 3]concat(Array 2)lastIndexOf 2
test 'Array::every' !->
  ok isFunction(Array::every)
  (a = [1])every (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  ok [1 2 3]every isNumber
  ok [1 2 3]every (<4)
  ok not [1 2 3]every (<3)
  ok not [1 2 3]every isString
  ok [1 2 3]every (-> +@ is 1 ), 1
  rez = ''
  [1 2 3]every -> rez += &1
  ok rez is \012
  ok (arr = [1 2 3])every -> &2 is arr
test 'Array::some' !->
  ok isFunction Array::some
  (a = [1])some (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  ok [1 \2 3]some isNumber
  ok [1 2 3]some (<3)
  ok not [1 2 3]some (<0)
  ok not [1 2 3]some isString
  ok not [1 2 3]some (-> +@ isnt 1), 1
  rez = ''
  [1 2 3]some -> rez += &1; no
  ok rez is \012
  ok not (arr = [1 2 3])some -> &2 isnt arr
test 'Array::forEach' !->
  ok isFunction Array::forEach
  (a = [1])forEach (val, key, that)!->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  rez = ''
  [1 2 3]forEach !-> rez += it
  ok rez is \123
  rez = ''
  [1 2 3]forEach !-> rez += &1
  ok rez is \012
  rez = ''
  [1 2 3]forEach !-> rez += &2
  ok rez is '1,2,31,2,31,2,3'
  rez=''
  [1 2 3]forEach (!->rez+=@), 1
  ok rez is \111
  rez = ''
  arr = []
  arr.5 = ''
  arr.forEach (, k)!-> rez += k
  ok rez is \5
test 'Array::map' !->
  ok isFunction Array::map
  (a = [1])map (val, key, that)->
    ok val  is 1
    ok key  is 0
    ok that is a
    ok @    is ctx
  , ctx = {}
  deepEqual [2 3 4] [1 2 3]map (+ 1)
  deepEqual [1 3 5] [1 2 3]map ( + )
  deepEqual [2 2 2] [1 2 3]map (-> +@), 2 
test 'Array::filter' !->
  ok isFunction Array::filter
  (a = [1])filter (val, key, that)->
    ok val is 1
    ok key is 0
    ok that is a
    ok @ is ctx
  , ctx = {}
  deepEqual [1 2 3 4 5] [1 2 3 \q {} 4 on 5]filter isNumber
test 'Array::reduce' !->
  ok isFunction Array::reduce
  ok -5 is [5 4 3 2 1]reduce (-)
  (a = [1])reduce (memo, val, key, that)->
    ok memo is 42
    ok val  is 1
    ok key  is 0
    ok that is a
  , 42
  [42 43]reduce ->
    ok it is 42
test 'Array::reduceRight' !->
  ok isFunction Array::reduceRight
  ok -5 is [1 2 3 4 5]reduceRight (-)
  (a = [1])reduceRight (memo, val, key, that)->
    ok memo is 42
    ok val  is 1
    ok key  is 0
    ok that is a
  , 42
  [42 43]reduceRight ->
    ok it is 43
test 'String.prototype.trim' !->
  ok \trim of String::
  ok '   q w e \n  'trim! is 'q w e'
test 'Date.now' !->
  {now} = Date
  ok isFunction now
  ok +new Date - now! < 10