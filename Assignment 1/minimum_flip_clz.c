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

int maxNum(int a, int b, int c) {
  if (a >= b && a >= c) {
    return a;
  }
  else if (b >= a && b >= c) {
    return b;
  }
  
  return c;
}

int minFlips(int a, int b, int c) {
  int flips = 0;
    
  int maxBit = 31 - my_clz(maxNum(a, b, c));

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
  int a[3] = {143165576, 51041, 1};
  int b[3] = {715827882, 65280, 2};
  int c[3] = {1, 716177407, 3};
  // expected output:
  // example 1: 23
  // example 2: 14
  // example 3: 0

  for (int i = 0; i < 3; i++) {
    printf("Minimum flips is %d.\n", minFlips(a[i], b[i], c[i]));
  }

  return 0;
}