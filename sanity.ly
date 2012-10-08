<html>
<head>
<title>Lily Sanity Test</title>
</head>
<body>
<@lily
integer test_id = 1
integer fail_count = 0

method test_basic_assignments():integer
{
    method method1():integer {
        method method2():integer {
            method method3():integer {
                method method4():integer {
                    method method4():integer {
                        return 1
                    }
                    return 1
                }
                return 1
            }
            return 1
        }
        return 1
    }
    # Test valid assignments.
    integer a = 1
    number b = 2.0
    str c = "c"
    object o = "o"

    # Decl list test.
    integer dl1, dl2, dl3, dl4

    # Objects can be assigned any value.
    o = 1
    o = 2.0
    # Make sure that strings don't reference leak.
    c = "c"
    c = "cc"
    o = "o"
    o = "oo"

    printfmt("#%i: Testing basic assignments...ok.\n", test_id)
    test_id = test_id + 1

    return 1
}

method test_jumps():integer
{
    integer a, ok

    a = 1
    printfmt("#%i: Testing jumps...", test_id)
    test_id = test_id + 1

    if a == a: {
        print("ok.\n")
    else:
        print("failed.\n")
        # Make sure jumps aren't miswired...again.
        fail_count = fail_count + 1
    }

    return 1
}

method test_manyargs (integer a, integer b, integer c, integer d,
    integer e, integer f):integer
{
    printfmt("#%i: 8-arg call...ok.\n", test_id)
    test_id = test_id + 1

    return a
}

method test_printfmt():integer
{
    integer a = 1
    number b = 12.34
    str c = "abcd"

    printfmt("#%i: Testing printfmt:...(check results)\n", test_id)
    test_id = test_id + 1

    printfmt("    integer a (1)     is %i.\n", a)
    printfmt("    number  b (12.34) is %n.\n", b)
    printfmt("    str     c (abcd)  is %s.\n", c)
    # Make sure varargs calls are taking the extra ones too.
    printfmt("    a, b, c are %i, %n, %s.\n", a, b, c)

    return 1
}

method test_obj_call():integer
{
    object o

    method sample_ocall(object a, object b):integer
    {
        return 1
    }

    sample_ocall("a", "a")
    sample_ocall(1, 1)
    sample_ocall(1.1, 1.1)
    sample_ocall(o, o)

    printfmt("#%i: Testing autocast of object calls...ok.\n", test_id)
    test_id = test_id + 1

    return 1
}

method test_oo():integer
{
    str a = "a"
    integer i

    printfmt("#%i: Testing oo calls...", test_id)
    test_id = test_id + 1

    if a.concat("a") == "aa": {
        # Check that oo works with regular binary ops.
        i = a.concat("a").concat("a") < "bb"
        print("ok.\n")
    else:
        fail_count = fail_count + 1
        print("failed.\n")
    }

    return 1
}

method test_utf8():integer
{
    str h3llö = "hello"
    str ustr = "á"

    printfmt("#%i: Testing concat with utf8...", test_id)
    test_id  = test_id + 1

    if ustr.concat("á") == "áá": {
        print("ok.\n")
    else:
        print("failed.\n")
        fail_count = fail_count + 1
    }

    return 1
}

method test_escapes():integer
{
    str s = "\\a\\b\\\\c\\d\\"
    str s2 = "Hello, world.\n"
    str s3 = ""

    printfmt("#%i: Testing escape string...%s.\n", test_id, s)
    test_id = test_id + 1

    return 1
}

method test_nested_if():integer
{
    integer a, ok = 0
    str s = "a"
    a = 1
    printfmt("#%i: Testing nested if...", test_id)
    test_id = test_id + 1

    if a == 1: {
        if a == 1: {
            if a == 1: {
                if a == 1: {
    if a == 1: {
        if a == 1: {
            if a == 1: {
                if a == 1: {
    if a == 1: {
        if a == 1: {
            if a == 1: {
                if a == 1: {
                    ok = 1
                }
            }
        }
    }
                }
            }
        }
    }
                }
            }
        }
    }

    # In Lily, braces are only needed for the start and end of an if. This is a
    # multi-line if test.
    if a == 1: {
        a = 2
        a = 3
    elif a == 2:
        a = 4
        a = 5
    else:
        a = 6
        a = 7
    }

    if ok == 1: {
        print("ok.\n")
    else:
        print("failed.\n")
        fail_count = fail_count + 1
    }

    return 1
}

method test_add():integer
{
    # This tests ast merging.
    integer i1, ok
    str s1, s2

    i1 = "1" >= "1"
    i1 = "1" > "1"
    i1 = "1" < "1"
    i1 = "1" <= "1"
    i1 = "1" == "1"

    method add(integer a, integer b):integer
    {
        return a + b
    }

    i1 = add(1, 1) + add(1, 1)
    printfmt("#%i: Testing add(1, 1) + add(1, 1)...", test_id)
    test_id = test_id + 1

    if i1 == 4: {
        print("ok.\n")
    else:
        print("failed.\n")
        fail_count = fail_count + 1
    }

    return 1
}

method test_assign_decl_list():integer
{
    printfmt("#%i: Testing assigning to decl list...", test_id)
    test_id = test_id + 1

    # First, basic stuff...
    integer a = 1, b = 2, c = 3

    # Now, with binary.
    integer d = a + b, e = a + b

    method add(integer a, integer b):integer
    {
        return a + b
    }

    # Finally, with a call.
    integer f = add(a, b), g = 4

    if f == 3: {
        print("ok.\n")
    else:
        print("failed.\n")
        fail_count = fail_count + 1
    }

    return 1
}

# The parser understands nil to mean not returning anything. But the vm doesn't
# just yet, so don't call it now.
method test_nil_ret():nil
{
    return
}

method oneline_helper():integer
{
    # oneline conditions go through a different path than multiline ones. This
    # tests the single-line path to make sure everything is ok.
    integer a = 1
    if a == 2:
        return 0
    elif a == 3:
        return 0

    if a == 1:
        a = 1
    elif a == 2:
        a = 2
    else:
        a = a

    # Test transitioning from single to multi.
    if a == 1: {
        a = 1
    }

    if "a" == "a":
        a = 1
    else:
        return 0

    return 1
}

method test_oneline_if():integer
{
    printfmt("#%i: Testing one-line conditions...", test_id)
    test_id = test_id + 1

    if oneline_helper() == 1: {
        print("ok.\n")
    else:
        print("failed.\n")
        fail_count = fail_count + 1
    }

    return 1
}

method fib(integer n):integer
{
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fib(n-1) + fib(n-2)
}

method test_fib():integer
{
    printfmt("#%i: Testing fibonacci...(check results)\n", test_id)
    test_id = test_id + 1

    integer fib0 = fib(0)
    integer fib1 = fib(1)
    integer fib2 = fib(2)
    integer fib3 = fib(3)
    integer fib4 = fib(4)
    integer fib5 = fib(5)
    integer fib6 = fib(6)
    integer fib7 = fib(7)
    integer fib8 = fib(8)
    integer fib9 = fib(9)

    printfmt("     fib 0..9 is %i, %i, %i, %i, %i, %i, %i, %i, %i, %i.\n",
             fib0, fib1, fib2, fib3, fib4, fib5, fib6, fib7, fib8, fib9)
    print("     Should be   0, 1, 1, 2, 3, 5, 8, 13, 21, 34.\n")
    return 1
}

test_basic_assignments()
test_jumps()
test_manyargs(1,2,3,4,5,6)
test_printfmt()
test_obj_call()
test_oo()
test_utf8()
test_escapes()
test_nested_if()
test_add()
test_assign_decl_list()
test_oneline_if()
test_fib()

test_id = test_id - 1

printfmt("Tests passed: %i / %i.", test_id , test_id + fail_count)
@>
</body>
</html>
