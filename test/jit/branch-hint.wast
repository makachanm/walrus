(module
  (func (export "swapped") (param i32 i32) (result i32)
    local.get 0
    (@metadata.code.branch_hint "\01")
    if (result i32)
      local.get 1
      local.get 1
      i32.add
    else
      local.get 1
      local.get 1
      i32.mul
    end
  )

  (func (export "kept") (param i32 i32) (result i32)
    local.get 0
    (@metadata.code.branch_hint "\00")
    if (result i32)
      local.get 1
      local.get 1
      i32.add
    else
      local.get 1
      local.get 1
      i32.mul
    end
  )

  (func (export "nested") (param i32 i32 i32) (result i32)
    local.get 0
    (@metadata.code.branch_hint "\01")
    if (result i32)
      local.get 1
      (@metadata.code.branch_hint "\01")
      if (result i32)
        local.get 2
        i32.const 1
        i32.add
      else
        local.get 2
        i32.const 2
        i32.add
      end
    else
      local.get 1
      (@metadata.code.branch_hint "\00")
      if (result i32)
        local.get 2
        i32.const 3
        i32.add
      else
        local.get 2
        i32.const 4
        i32.add
      end
    end
  )

  (func (export "inloop") (param i32) (result i32)
    (local i32 i32)
    block $out
      loop $top
        local.get 2
        local.get 0
        i32.ge_s
        br_if $out
        local.get 2
        i32.const 1
        i32.and
        (@metadata.code.branch_hint "\01")
        if
          local.get 1
          i32.const 10
          i32.add
          local.set 1
        else
          local.get 1
          i32.const 1
          i32.add
          local.set 1
        end
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br $top
      end
    end
    local.get 1
  )

  (func (export "noelse") (param i32 i32) (result i32)
    local.get 0
    (@metadata.code.branch_hint "\01")
    if
      local.get 1
      i32.const 100
      i32.add
      local.set 1
    end
    local.get 1
  )

  (func (export "elsebr") (param i32 i32) (result i32)
    block $done (result i32)
      local.get 0
      (@metadata.code.branch_hint "\01")
      if (result i32)
        local.get 1
        local.get 1
        i32.add
      else
        local.get 1
        local.get 1
        i32.mul
        br $done
      end
    end
  )
)

(assert_return (invoke "swapped" (i32.const 0) (i32.const 5)) (i32.const 25))
(assert_return (invoke "swapped" (i32.const 1) (i32.const 5)) (i32.const 10))
(assert_return (invoke "kept" (i32.const 0) (i32.const 5)) (i32.const 25))
(assert_return (invoke "kept" (i32.const 1) (i32.const 5)) (i32.const 10))
(assert_return (invoke "nested" (i32.const 1) (i32.const 1) (i32.const 0)) (i32.const 1))
(assert_return (invoke "nested" (i32.const 1) (i32.const 0) (i32.const 0)) (i32.const 2))
(assert_return (invoke "nested" (i32.const 0) (i32.const 1) (i32.const 0)) (i32.const 3))
(assert_return (invoke "nested" (i32.const 0) (i32.const 0) (i32.const 0)) (i32.const 4))
(assert_return (invoke "inloop" (i32.const 0)) (i32.const 0))
(assert_return (invoke "inloop" (i32.const 1)) (i32.const 1))
(assert_return (invoke "inloop" (i32.const 4)) (i32.const 22))
(assert_return (invoke "inloop" (i32.const 5)) (i32.const 23))
(assert_return (invoke "noelse" (i32.const 0) (i32.const 7)) (i32.const 7))
(assert_return (invoke "noelse" (i32.const 1) (i32.const 7)) (i32.const 107))
(assert_return (invoke "elsebr" (i32.const 0) (i32.const 5)) (i32.const 25))
(assert_return (invoke "elsebr" (i32.const 1) (i32.const 5)) (i32.const 10))
