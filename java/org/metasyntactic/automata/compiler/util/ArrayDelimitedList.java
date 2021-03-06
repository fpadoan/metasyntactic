// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic.automata.compiler.util;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ArrayDelimitedList<TExpression, TDelimiter> implements DelimitedList<TExpression, TDelimiter> {
  private final List<TExpression> elements;
  private final List<TDelimiter> delimiters;

  public ArrayDelimitedList(List<TExpression> elements, List<TDelimiter> delimiters) {
    this.elements = elements;
    this.delimiters = delimiters;
  }

  public List<TExpression> getElements() {
    return elements;
  }

  public List<TDelimiter> getDelimiters() {
    return delimiters;
  }

  public void addTo(List<Object> list) {
    for (int i = 0; i < elements.size(); i++) {
      list.add(elements.get(i));
      if (i < delimiters.size()) {
        list.add(delimiters.get(i));
      }
    }
  }
}
