/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:math';

final _random = new Random();

class MazeFactory {
  static int NB_ROW = 7;
  static int NB_COL = 7;

  static const int TOP = 1;
  static const int RIGHT = 2;
  static const int BOTTOM = 4;
  static const int LEFT = 8;
  static const int CLOSE = 15;


  var mazeCells = List<List>.generate(NB_ROW,
      (i) => List<dynamic>.generate(NB_COL, (index) => null, growable: false),
      growable: false);

  (int, int) getWay(int i, int j) {
    var ways = List<dynamic>.generate(4, (index) => null, growable: false);
    int nb = 0;
    if (i > 0 && mazeCells[j][i - 1] == CLOSE) ways[nb++] = LEFT;
    if (i < (NB_COL - 1) && mazeCells[j][i + 1] == CLOSE) ways[nb++] = RIGHT;
    if (j > 0 && mazeCells[j - 1][i] == CLOSE) ways[nb++] = TOP;
    if (j < (NB_ROW - 1) && mazeCells[j + 1][i] == CLOSE) ways[nb++] = BOTTOM;
    if (nb > 0) return (ways[_random.nextInt(nb)], nb);
    return (0, 0);
  }

  void makeMaze(nbCol, nbRow) {
    NB_ROW = nbRow;
    NB_COL = nbCol;
    mazeCells = List<List>.generate(NB_ROW,
            (i) => List<dynamic>.generate(NB_COL, (index) => null, growable: false),
        growable: false);

    List<int> nodes = [];
    for (int i = 0; i < NB_COL; i++) {
      for (int j = 0; j < NB_ROW; j++) {
        mazeCells[j][i] = CLOSE;
      }
    }
    nodes.add(_random.nextInt(NB_COL * NB_ROW));

    int node = 0;
    int x = 0;
    int i = 0;
    int j = 0;
    int nb = 0;
    int way = TOP;
    bool start = true;
    while (nodes.isNotEmpty) {
      node = _random.nextInt(nodes.length);
      x = nodes[node];
      i = x % NB_COL;
      j = x ~/ NB_COL;
      nb;
      way = TOP;
      start = true;

      while (way > 0) {
        var (new_way, new_nb) = getWay(i, j);
        way = new_way;
        nb = new_nb;

        if (nb < 1) {
          if (start) {
            nodes.removeAt(node);
          } else {
            nodes.removeLast();
          }
        }
        start = false;
        switch (way) {
          case 0:
            break;
          case LEFT:
            mazeCells[j][i] &= ~LEFT;
            mazeCells[j][i - 1] &= ~RIGHT;
            i--;
            nodes.add(j * NB_COL + i);
            break;
          case RIGHT:
            mazeCells[j][i] &= ~RIGHT;
            mazeCells[j][i + 1] &= ~LEFT;
            i++;
            nodes.add(j * NB_COL + i);
            break;
          case BOTTOM:
            mazeCells[j][i] &= ~BOTTOM;
            mazeCells[j + 1][i] &= ~TOP;
            j++;
            nodes.add(j * NB_COL + i);
            break;
          case TOP:
            mazeCells[j][i] &= ~TOP;
            mazeCells[j - 1][i] &= ~BOTTOM;
            j--;
            nodes.add(j * NB_COL + i);
            break;
        }
      }
    }
  }
}
