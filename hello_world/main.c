#include <stdio.h>
#include <time.h>

int main(void)
{

    int i;
    double time_spent = 0.0;
    clock_t() begin = clock();

    for(i = 0; i < 3; i++)
    {
        printf("Get me that thing done\n");
    }

    clock_t() end = clock();
    time_spent += (double)(end - start) / CLOCKS_PER_SEC;

    printf("Spent time: %d\n", time_spent);
    return 0;
}
