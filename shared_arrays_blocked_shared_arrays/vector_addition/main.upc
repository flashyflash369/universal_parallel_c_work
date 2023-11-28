#include <stdio.h>
#include <upc.h>


#define N 10 * THREADS

shared int v1[N], v2[N], v1plusv2[N];


int main()
{
	int i;
	upc_forall(i = 0; i < N; i++; i)
	{
		v1plusv2[i] = v1[i] + v2[i];
	}

}

/*

In this example, two vectors v1 and v2 are added to produce the vector v1plusv2. By default, v1
v2 and v1plusv2 are distributed across the threads in a round-robin fashion. The last field in
the upc_forall is the affinity field and says that iteration i should be executed on thread
i % THREADS. Thus, iterations are also distributed in round-robin fashion accross the threads.
which will ensure that each thread manipulates only the shared data that are available locally.

*/
