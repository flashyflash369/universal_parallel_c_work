#include <stdio.h>
#include <upc.h>

shared int a[THREADS][THREADS];
shared int b[THREADS], c[THREADS];

int main(void)
{
    int i, j;

    //Distribute matrix computation in a round robin fashion
    //With default block size of one
    upc_forall(i = 0; i < THREADS; i++; i)
    {
        c[i] = 0;
        for(j = 0; j < THREADS; j++)
        {
            c[i] +=  a[i][j] * b[j];
        }
    }

    return 0;
}


/*

The default layout in the shared space in the case of running with 3 threads in shown below:

At first glance at the layout will show that for computing each c[] element, there will be
more remote access than local accesses. For example, in case  c[0], only a[0][0] and b[0] are
local input operands; the remaining four are not. Luckily, this default distribution can be
altered to better fit the need of an application and improve locality exploitation in the
underlying computations.

For Example:

shared[4] int a[16];

The block size and totla number of threads 'THREADS' determine the affinity of each data element
to threads as follows: Element i of a blocked array has an affinity to thread:

[i/blocksize] mod THREADS

Thus, the declaration
shared[3] int x[12];

has a layout qualifier of 3, which means that array entries will be blocked and distributed
across the threads in blocks of three in round-robin fashion. The resulting layout
for THREADS = 3 is show in figure 2.6.
*/
