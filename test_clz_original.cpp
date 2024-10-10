#include<stdio.h>
#include<stdint.h>

static int my_clz(uint32_t x) {
    int count = 0;
    for (int i = 31; i >= 0; --i) {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}

int main(int argc, char const *argv[])
{
    int test_data[20] = {
        25448, 14227, 22674, 28864, 
        31649, 20975, 22181, 11350, 
        20409, 18526, 1399, 10944, 
        28693, 24509, 29763, 25829, 
        15952, 20041, 12062, 27150
    };
    int golden[20] = {
        17, 18, 17, 17, 
        17, 17, 17, 18, 
        17, 17, 21, 18, 
        17, 17, 17, 17, 
        18, 17, 18, 17
    };
    bool pass = true;
    for (int i = 0; i <= 19; i++)
    {
        if (my_clz(test_data[i]) != golden[i]){
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