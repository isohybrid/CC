#include <stdio.h>
#include <malloc.h>

void solve(long n)
{
	long z,sum;
	sum=0;
	for(z=0;z<=n/5;z++)
		sum+=(n-5*z)/2+1;
	printf("%ld\n",sum);
}

int main()
{
	long T,i;
	long *N;
	scanf("%ld",&T);
	N=(long *)malloc(T*sizeof(long));
	for(i=0;i<T;i++)
		scanf("%ld",&N[i]);
	for(i=0;i<T;i++)
		solve(N[i]);
	return 0;
}
