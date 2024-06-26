# ===----------------------------------------------------------------------=== #
# Copyright (c) 2024, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #
# RUN: %mojo -debug-level full %s

from collections import Set

from testing import *


fn test_stringable() raises:
    assert_equal("float32", str(DType.float32))
    assert_equal("int64", str(DType.int64))


fn test_key_element() raises:
    var set = Set[DType]()
    set.add(DType.bool)
    set.add(DType.int64)

    assert_false(DType.float32 in set)
    assert_true(DType.int64 in set)


fn main() raises:
    test_stringable()
    test_key_element()
