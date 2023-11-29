#include <stdio.h>
#include <upc.h>

#define  N 3

shared int pack[N*THREADS];
void init_();

int main(void)
{
    init_();
    upc_barrier;
    upc_forall(int i = 0; i < N*THREADS; i++; i)
    {
        printf("mhthread: %d: %d\n",MYTHREAD,  pack[i]);
    }
}

void init_()
{
    for(int i = 0; i < N*THREADS; i++)
    {
        pack[i] = i;
    }
}
