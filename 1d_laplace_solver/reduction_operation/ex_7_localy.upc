#include <upc.h>
#include <upc_collective.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>
#define TOTALSIZE 100
#define EPSILON 0.000001

shared [TOTALSIZE] double x[TOTALSIZE*THREADS];
shared [TOTALSIZE] double x_new[TOTALSIZE*THREADS];
shared [TOTALSIZE] double b[TOTALSIZE*THREADS];
shared double diff[THREADS];
shared double diffmax;

void init(){
    int i;

    for( i = 0; i < TOTALSIZE*THREADS; i++ ){
        b[i] = 0;
        x[i] = 0;
    }

    b[1] = 1.0;
    b[TOTALSIZE*THREADS-2] = 1.0;
}

int main(){
    int j;
    int iter = 0;
    float execTime;

    struct timeval ts_start, ts_end;

    int i;//Will be used to determine diffmax
    if( MYTHREAD == 0 )
        init();

    upc_barrier;

    gettimeofday(&ts_start, NULL);

    while( 1 ){
        iter++;
        diff[MYTHREAD] = 0.0;

        upc_forall( j=1; j<TOTALSIZE*THREADS-1; j++; &x_new[j] ){
            x_new[j] = 0.5 * ( x[j-1] + x[j+1] + b[j] );

            if( diff[MYTHREAD] < x_new[j] - x[j] )
                diff[MYTHREAD] = x_new[j] - x[j];
        }

        // Each thread as a local value for diff
        // The maximum of those values should be used to check
        // the convergence.

        diffmax = diff[0];
        upc_barrier;

        if(MYTHREAD == 0)
        {
            for(i = 1; i <THREADS; i++)
                if(diffmax < diff[i])
                    diffmax = diff[i];


            // diffmax = max(diff[0..THREADS - 1])

            printf("diff max = %f \n", diffmax);
        }

        if( diffmax <= EPSILON )
            break;
        if( iter > 10000 )
            break;

        upc_forall( j=0; j<TOTALSIZE*THREADS; j++; &x_new[j] ){
            x[j] = x_new[j];
        }
        upc_barrier;
    }

    gettimeofday(&ts_end, NULL);


    // You can display the results here :
    if( MYTHREAD == 0 ){

        execTime = ts_end.tv_sec + (ts_end.tv_usec / 1000000.0);

        execTime -= ts_start.tv_sec + (ts_start.tv_usec / 1000000.0);
        for(j=0; j<TOTALSIZE*THREADS; j++){
            printf("%f\t", x_new[j]);
        }
        printf("\n");

        printf("Execution time: %.3lf\n", execTime);
    }


    return 0;
}


