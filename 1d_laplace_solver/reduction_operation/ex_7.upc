#include <upc.h>
// #include <upc_collective.h>   It is recommended that you use
//          the collectives for this exercise...
#include <stdio.h>
#include <math.h>

#define TOTALSIZE 5
#define EPSILON 0.000001

shared [TOTALSIZE] double x[TOTALSIZE*THREADS];
shared [TOTALSIZE] double x_new[TOTALSIZE*THREADS];
shared [TOTALSIZE] double b[TOTALSIZE*THREADS];
shared double diff[THREADS];
shared double diffmax;

void max();


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

    if( MYTHREAD == 0 )
        init();

    upc_barrier;

    while( 1 ){
        iter++;
        diff[MYTHREAD] = 0.0;


        upc_forall( j=1; j<TOTALSIZE*THREADS-1; j++; &x_new[j]){
            x_new[j] = 0.5 * ( x[j-1] + x[j+1] + b[j] );
            printf("x new j: %d and x[j]: %d in thread: %d\n", x_new[j], x[j], MYTHREAD);


            if( diff[MYTHREAD] < x_new[j] - x[j] )
            {
                diff[MYTHREAD] = x_new[j] - x[j];
            }

            printf("%d\n", diff[j]);
        }

        // Each thread as a local value for diff
        // The maximum of those values should be used to check
        // the convergence.


        //max();
        //diffmax = max(&diff);

        printf("diff max = %f \n", diffmax);

        if( diffmax <= EPSILON )
            break;
        if( iter > 10000 )
            break;

        upc_forall( j=0; j<TOTALSIZE*THREADS; j++; &x_new[j] ){
            x[j] = x_new[j];
        }
        upc_barrier;
    }

    /* You can display the results here :
    if( MYTHREAD == 0 ){
        for(j=0; j<TOTALSIZE*THREADS; j++){
            printf("%f\t", x_new[j]);
        }
        printf("\n");
    }
    */

    return 0;
}


void max()
{
    double diff_max = diff[1];
    int i = 2;
    upc_forall(i; i < (THREADS*TOTALSIZE - 1); i++; i)
    {
        printf("%d\n",diff[i]);
        if(diff[i] > diff_max)
        {
            diff_max = diff[i];
        }
    }
}
/*
shared double max(shared double *diff)
{
    double  max_value = diff[1];
    upc_forall(i = 1; i < THREADS * TOTALSIZE - 1; i++; i)
    {
        if(diff[i] > max_value)
        {
            max_value = diff[i];
        }
    }

    return max_value;
}
*/

