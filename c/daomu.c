#include <stdio.h>
#include <malloc.h>
#include <math.h>
int T=0;
int prime[33]=
{
      0,0,1,1,0,1,0,
	1,0,0,0,1,0,1,
	0,0,0,1,0,1,0,
	0,0,1,0,0,0,0,
	0,1,0,1,0,
};

int IsPrime(int N)
{
	int i,j;
	if(N==2)
		return 1;
	else if(N<2 || N%2==0)
		return 0;
	else{
		j=(int)sqrt(N+1);
		for(i=3;i<=j;i+=2)
			if(N%i==0)
				return 0;
	}
	return 1;
}

//判断当前序列是否满足条件
int IsOk(int a[],int lastIndex,int curValue)
{
	int i;
	if(lastIndex<0)
		return 1;
	if(!((curValue+a[lastIndex])&1))
		return 0;
	if(!IsPrime(a[lastIndex]+curValue))
		return 0;
	for(i=0;i<=lastIndex;i++)
		if(a[i]==curValue)
			return 0;
	return 1;
}

void PrimeCircle(int a[],int n,int t)
{
	int i;
	if(t==n){
		if(prime[a[0]+a[n-1]])
			T++;
	}
	else{
		for(i=1;i<=n;i++){
			a[t]=i;
			if(IsOk(a,t-1,i))
				PrimeCircle(a,n,t+1);
		}
	}
}

int main()
{
	int N;
	scanf("%d",&N);
	if(N%2==0){
		int *a=(int *)malloc(N*sizeof(int));
		PrimeCircle(a,N,0);
	}	
	printf("%d\n",T);
	return 0;
}
