#include <stdio.h>
#include <time.h>

int main(int argc, char **argv){

    int n = atoi(argv[1]);
    int i;

    if(argc == 1)
    {
        printf("Missing arguments(loop number\n");
        return 1;
    }

    time_t now, later;
    double seconds;

    time(&now);

    for(i = 0; i < n; i++)
    {

        printf("iteratin %d: Hello World\n", i);
        sleep(2);
    }

    time(&later);
    seconds = difftime(later, now);

    printf("Time spent: %f\n", seconds);

	return 0;
}

