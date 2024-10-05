/* leetcode 1318 Minimum Flips to Make a OR b Equal to c */
/* https://leetcode.com/problems/minimum-flips-to-make-a-or-b-equal-to-c/description/?envType=problem-list-v2&envId=bit-manipulation */

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
    
  int maxBit = 31 - __builtin_clz(maxNum(a, b, c));

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