# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #
"""Defines core value traits.

These are Mojo built-ins, so you don't need to import them.
"""


trait Movable:
    """The Movable trait denotes a type whose value can be moved.

    Implement the `Movable` trait on `Foo` which requires the `__moveinit__`
    method:

    ```mojo
    struct Foo(Movable):
        fn __init__(inout self):
            pass

        fn __moveinit__(inout self, owned existing: Self):
            print("moving")
    ```

    You can now use the ^ suffix to move the object instead of copying
    it inside generic functions:

    ```mojo
    fn return_foo[T: Movable](owned foo: T) -> T:
        return foo^

    let foo = Foo()
    let res = return_foo(foo^)
    ```

    ```plaintext
    moving
    ```
    """

    fn __moveinit__(inout self, owned existing: Self, /):
        """Create a new instance of the value by moving the value of another.

        Args:
            existing: The value to move.
        """
        ...


trait Copyable:
    """The Copyable trait denotes a type whose value can be copied.

    Example implementing the `Copyable` trait on `Foo` which requires the `__copyinit__`
    method:

    ```mojo
    struct Foo(Copyable):
        var s: String

        fn __init__(inout self, s: String):
            self.s = s

        fn __copyinit__(inout self, other: Self):
            print("copying value")
            self.s = other.s
    ```

    You can now copy objects inside a generic function:

    ```mojo
    fn copy_return[T: Copyable](foo: T) -> T:
        let copy = foo
        return copy

    let foo = Foo("test")
    let res = copy_return(foo)
    ```

    ```plaintext
    copying value
    ```
    """

    fn __copyinit__(inout self, existing: Self, /):
        """Create a new instance of the value by copying an existing one.

        Args:
            existing: The value to copy.
        """
        ...
