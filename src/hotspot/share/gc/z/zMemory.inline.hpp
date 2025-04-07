/*
 * Copyright (c) 2015, 2023, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

#ifndef SHARE_GC_Z_ZMEMORY_INLINE_HPP
#define SHARE_GC_Z_ZMEMORY_INLINE_HPP

#include "gc/z/zMemory.hpp"

#include "gc/z/zAddress.inline.hpp"
#include "gc/z/zList.inline.hpp"
#include "utilities/debug.hpp"

inline ZMemory::ZMemory(zoffset start, size_t size)
  : _start(start),
    _end(to_zoffset_end(start, size)) {}

inline zoffset ZMemory::start() const {
  return _start;
}

inline zoffset_end ZMemory::end() const {
  return _end;
}

inline size_t ZMemory::size() const {
  return end() - start();
}

inline bool ZMemory::operator==(const ZMemory& other) const {
  return _start == other._start && _end == other._end;
}

inline bool ZMemory::operator!=(const ZMemory& other) const {
  return !operator==(other);
}

inline bool ZMemory::contains(const ZMemory& other) const {
  return _start <= other._start && other.end() <= end();
}

inline void ZMemory::shrink_from_front(size_t size) {
  assert(this->size() > size, "Too small");
  _start += size;
}

inline void ZMemory::shrink_from_back(size_t size) {
  assert(this->size() > size, "Too small");
  _end -= size;
}

inline void ZMemory::grow_from_front(size_t size) {
  assert(size_t(start()) >= size, "Too big");
  _start -= size;
}

inline void ZMemory::grow_from_back(size_t size) {
  _end += size;
}

#endif // SHARE_GC_Z_ZMEMORY_INLINE_HPP
