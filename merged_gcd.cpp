#include <stdio.h>
#include <stdint.h>
uint32_t trailing_zeros(uint32_t x) {
    // reverse bits in x
    x = (x >> 1)  & 0x55555555 | (x & 0x55555555) << 1;
    x = (x >> 2)  & 0x33333333 | (x & 0x33333333) << 2;
    x = (x >> 4)  & 0x0F0F0F0F | (x & 0x0F0F0F0F) << 4;
    x = (x >> 8)  & 0x00FF00FF | (x & 0x00FF00FF) << 8;
    x = (x >> 16) & 0x0000FFFF | (x & 0x0000FFFF) << 16;

    // count leadnig zeros
    uint32_t count = 0;
    if(x == 0){
        return 32;
    }
    if(x <= 0x0000FFFF){
        count += 16; 
        x <<= 16;
    }
    if (x <= 0x00FFFFFF){
        count +=  8;
        x <<= 8;
    } 
    if (x <= 0x0FFFFFFF){
        count +=  4;
        x <<= 4;
    } 
    if (x <= 0x3FFFFFFF){
        count +=  2;
        x <<= 2;
    } 
    if (x <= 0x7FFFFFFF){
        count ++;
    } 
    return count;
}

uint32_t gcd(uint32_t u, uint32_t v) {
    // Base cases: gcd(n, 0) = gcd(0, n) = n
    if (u == 0) return v;
    if (v == 0) return u;

    // Using identities 2 and 3:
    // gcd(2^i * u, 2^j * v) = 2^k * gcd(u, v) with u, v odd and k = min(i, j)
    // 2^k is the greatest power of two that divides both 2^i * u and 2^j * v
    int i = trailing_zeros(u);
    u >>= i;
    int j = trailing_zeros(v);
    v >>= j;
    int k = (i < j) ? i : j;

    while (1) {
        // Swap if necessary so u <= v
        if (u > v) {
            int temp = u;
            u = v;
            v = temp;
        }

        // Identity 4: gcd(u, v) = gcd(u, v - u) as u <= v and u, v are both odd
        v -= u;
        // v is now even

        if (v == 0) {
            // Identity 1: gcd(u, 0) = u
            // The shift by k is necessary to add back the 2^k factor that was removed before the loop
            return u << k;
        }

        // Identity 3: gcd(u, 2^j * v) = gcd(u, v) as u is odd
        v >>= trailing_zeros(v);
    }
}