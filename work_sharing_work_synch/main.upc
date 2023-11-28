#include <stdio.h>
#include <upc.h>

#define TBL_SZ 12

int main()
{
    static shared int fahrenheit[TBL_SZ]; // declared a global farh variable
    static shared int step=10; //a shared step
    int celsius, i;

    upc_forall(i=0;i<TBL_SZ;i++;i)
    {
        //Computation done by affinity
        celsius=step*i;
        fahrenheit[i]=celsius*(9.0/5.0)+32;
    }

    upc_barrier; //Wait till all threads reach this point
    if(MYTHREAD==0)
    {

        for(i=0;i<TBL_SZ;i++)
        {
            celsius=step*i;
            printf("%d \t %d \n",
            fahrenheit[i], celsius);
        }

    }
}
