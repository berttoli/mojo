# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #
"""Implement a generic unsafe pointer type.

You can import these APIs from the `memory` package. For example:

```mojo
from memory.anypointer import AnyPointer
```
"""

from sys.info import alignof, sizeof


@register_passable("trivial")
struct AnyPointer[T: Movable]:
    """This is a pointer type that can point to any generic value that is
    movable.

    Parameters:
        T: The pointer element type, which must be movable.
    """

    alias pointer_type = __mlir_type[`!kgen.pointer<:`, Movable, ` `, T, `>`]
    """The underlying pointer type."""
    var value: Self.pointer_type
    """The underlying pointer."""

    @always_inline
    fn __init__() -> Self:
        """Create a null pointer.

        Returns:
            A null pointer.
        """
        return Self {
            value: __mlir_attr[`#interp.pointer<0> : `, Self.pointer_type]
        }

    @staticmethod
    @always_inline
    fn alloc(count: Int) -> Self:
        """Allocate an array with default alignment.

        Args:
            count: The number of elements in the array.

        Returns:
            The pointer to the newly allocated array.
        """
        return Self {
            value: __mlir_op.`pop.aligned_alloc`[_type = Self.pointer_type](
                alignof[T]().value, (sizeof[T]() * count).value
            )
        }

    @always_inline
    fn free(self):
        """Free the memory referenced by the pointer."""
        __mlir_op.`pop.aligned_free`(self.value)

    @always_inline
    fn take_value(self) -> T:
        """Move the value at the pointer out.

        Returns:
            The value at the pointer.
        """
        return __get_address_as_owned_value(self.value)

    @always_inline
    fn emplace_value(self, owned value: T):
        """Emplace a new value into the pointer location.

        Args:
            value: The value to emplace.
        """
        __get_address_as_uninit_lvalue(self.value) = value ^

    @always_inline
    fn __as_index(self) -> Int:
        return __mlir_op.`pop.pointer_to_index`[
            _type = __mlir_type.`!pop.scalar<index>`
        ](self.value)

    @staticmethod
    @always_inline
    fn __from_index(value: Int) -> Self:
        return Self {
            value: __mlir_op.`pop.index_to_pointer`[_type = Self.pointer_type](
                Scalar[DType.index](value).value
            )
        }

    @always_inline
    fn __bool__(self) -> Bool:
        """Return true if the pointer is non-null.

        Returns:
            Whether the pointer is null.
        """
        return self.__as_index() != Self().__as_index()

    @always_inline
    fn __add__(self, offset: Int) -> Self:
        """Return a pointer at an offset from the current one.

        Args:
            offset: The offset index.

        Returns:
            An offset pointer.
        """
        return Self.__from_index(self.__as_index() + offset * sizeof[T]())
