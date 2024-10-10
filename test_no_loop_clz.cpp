#include<stdio.h>
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

int main(int argc, char const *argv[])
{
    int test_data[20] = {
        2, 14227, 22674, 28864, 
        31649, 20975, 22181, 11350, 
        20409, 18526, 1399, 10944, 
        28693, 24509, 29763, 25829, 
        15952, 20041, 12062, 27150
    };
    int golden[20] = {
        30, 18, 17, 17, 
        17, 17, 17, 18, 
        17, 17, 21, 18, 
        17, 17, 17, 17, 
        18, 17, 18, 17
    };
    bool pass = true;
    for (int i = 0; i <= 19; i++)
    {
        if (no_for_loop_clz(test_data[i]) != golden[i]){
            pass = false;
        }
    }
    if (pass){
        printf("All test data passed!");
    }
    else{
        printf("Something wrong!");
    }
    return 0;
}