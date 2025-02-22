// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:source_span/src/utils.dart';

main() {
  group('binary search', () {
    test('empty', () {
      expect(binarySearch([], (x) => true), -1);
    });

    test('single element', () {
      expect(binarySearch([1], (x) => true), 0);
      expect(binarySearch([1], (x) => false), 1);
    });

    test('no matches', () {
      var list = [1, 2, 3, 4, 5, 6, 7];
      expect(binarySearch(list, (x) => false), list.length);
    });

    test('all match', () {
      var list = [1, 2, 3, 4, 5, 6, 7];
      expect(binarySearch(list, (x) => true), 0);
    });

    test('compare with linear search', () {
      for (int size = 0; size < 100; size++) {
        var list = [];
        for (int i = 0; i < size; i++) {
          list.add(i);
        }
        for (int pos = 0; pos <= size; pos++) {
          expect(binarySearch(list, (x) => x >= pos),
              _linearSearch(list, (x) => x >= pos));
        }
      }
    });
  });

  group('find line start', () {
    test('skip entries in wrong column', () {
      var context = '0_bb\n1_bbb\n2b____\n3bbb\n';
      var index = findLineStart(context, 'b', 1);
      expect(index, 11);
      expect(context.substring(index - 1, index + 3), '\n2b_');
    });

    test('end of line column for empty text', () {
      var context = '0123\n56789\nabcdefgh\n';
      var index = findLineStart(context, '', 5);
      expect(index, 5);
      expect(context[index], '5');
    });

    test('column at the end of the file for empty text', () {
      var context = '0\n2\n45\n';
      var index = findLineStart(context, '', 2);
      expect(index, 4);
      expect(context[index], '4');

      context = '0\n2\n45';
      index = findLineStart(context, '', 2);
      expect(index, 4);
    });

    test('found on the first line', () {
      var context = '0\n2\n45\n';
      var index = findLineStart(context, '0', 0);
      expect(index, 0);
    });

    test('not found', () {
      var context = '0\n2\n45\n';
      var index = findLineStart(context, '0', 1);
      expect(index, isNull);
    });
  });
}

_linearSearch(list, predicate) {
  if (list.length == 0) return -1;
  for (int i = 0; i < list.length; i++) {
    if (predicate(list[i])) return i;
  }
  return list.length;
}
