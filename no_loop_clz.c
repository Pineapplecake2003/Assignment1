#include<stdint.h>
uint32_t no_for_loop_clz(uint32_t x){
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