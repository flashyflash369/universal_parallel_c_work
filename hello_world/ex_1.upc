#include <upc.h>
#include <stdio.h>
#include <time.h>

int main(int argc, char **argv){

    time_t start, end;
    double seconds;

    time(&start);
	printf("Thread %d of %d: Hello World\n", MYTHREAD, THREADS);
    sleep(2);

    upc_barrier;
    if(MYTHREAD == 0)
    {
        time(&end);
        seconds = difftime(end, start);

        printf("Time spent: %f\n", seconds);
    }

	return 0;
}

