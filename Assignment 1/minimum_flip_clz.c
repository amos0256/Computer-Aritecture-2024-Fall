/* leetcode 1318 Minimum Flips to Make a OR b Equal to c */
/* https://leetcode.com/problems/minimum-flips-to-make-a-or-b-equal-to-c/description/?envType=problem-list-v2&envId=bit-manipulation */
#include <stdio.h>
#include <stdint.h>

static inline int my_clz(uint32_t x) {
  int count = 0;
  for (int i = 31; i >= 0; --i) {
    if (x & (1U << i))
      break;
    count++;
  }
    return count;
}

int minFlips(int a, int b, int c) {
  int flips = 0;
    
  int maxBit = 31 - my_clz(a | b | c);

  for (int i = 0; i <= maxBit; i++) {
    int bitA = (a >> i) & 1;
    int bitB = (b >> i) & 1;
    int bitC = (c >> i) & 1;

    if (bitC == 0) {
      flips += bitA + bitB;
    }
    else {
      if (bitA == 0 && bitB == 0) {
        flips += 1;
      }
    }
  }

  return flips;
}

int main(void) {
  // examples
  int a[3] = {1, 51041, 143165576};
  int b[3] = {2, 65280, 715827882};
  int c[3] = {3, 716177407, 1};
  // expected output:
  // example 1: 0
  // example 2: 14
  // example 3: 23

  for (int i = 0; i < 3; i++) {
    printf("Minimum flips is %d.\n", minFlips(a[i], b[i], c[i]));
  }

  return 0;
}