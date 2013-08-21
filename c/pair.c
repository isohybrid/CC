#include <stdio.h>
#include <malloc.h>

void quick_sort(long *a,long i,long j)
{
  long m,n,tmp,k;
	m=i;
	n=j;
	k=a[(i+j)/2];
	do{
		while(a[m]<k&&m<j) m++;
		while(a[n]>k&&n>i) n--;
		if(m<=n){
			tmp=a[m];
			a[m]=a[n];
			a[n]=tmp;
			m++;
			n--;
		}
	}while(m<=n);
	if(m<j) quick_sort(a,m,j);
	if(n>i) quick_sort(a,i,n);
}

int main()
{
	long n,k,T,i,j;
	long *res1,*res2,*a;
	scanf("%ld",&T);
	res1=(long *)malloc(T*sizeof(long));
	res2=(long *)malloc(T*sizeof(long));
	for(i=0;i<T;i++){
		scanf("%ld %ld",&n,&k);
		a=(long *)malloc(n*sizeof(long));
		for(j=0;j<n;j++)
			scanf("%ld",&a[j]);
		quick_sort(a,0,n-1);
		if(k==n*n){
			res1[i]=a[n-1];
			res2[i]=a[n-1];
		}
		else{
		res1[i]=a[k/n];
		res2[i]=a[k%n-1];
		}
	}
	for(i=0;i<T;i++)
		printf("%ld %ld\n",res1[i],res2[i]);
		
	return 0;
}
