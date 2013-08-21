#include <stdio.h>
#include <malloc.h>

int  *narrow(int *a,int len)
{
  int i,min,tmp_min;
	min=a[0];
	tmp_min=0;
	for(i=0;i<len;i++){
		if(min>a[i+1]){
			min=a[i+1];
			tmp_min=i+1;
		}
	}
	if(tmp_min==0){
		a[0]+=a[1];
		for(i=1;i<len;i++)
			a[i]=a[i+1];
	}
	else if(tmp_min==len){
		a[len-1]=a[len-1]+a[len];
	}
	else{
		if(a[tmp_min-1]>=a[tmp_min+1]){
			a[tmp_min]+=a[tmp_min+1];
			for(i=tmp_min+1;i<len;i++)
				a[i]=a[i+1];
		}
		else{
			a[tmp_min-1]+=a[tmp_min];
			for(i=tmp_min;i<len;i++)
				a[i]=a[i+1];
		}
	}
	
	return a;
}

int max(int *a,int len)
{
	int i,max;
	max=a[0];
	for(i=0;i<len;i++){
		if(max<a[i+1])
			max=a[i+1];
	}
	
	return max;
}

int main()
{
int T,N,M,i,j;
int *res;
scanf("%d",&T);
res=(int *)malloc(T*sizeof(int));
for(i=0;i<T;i++){
	int *a;
	scanf("%d %d",&N,&M);
	a=(int *)malloc(N*sizeof(int));
	for(j=0;j<N;j++)
		scanf("%d",&a[j]);
	for(j=0;j<N-M;j++){
		a=narrow(a,N);
		N-=1;
	}
	res[i]=max(a,N);
	
	for(i=0;i<N;i++)
		printf("%d\n",a[i]);
}
for(i=0;i<T;i++)
	printf("%d\n",res[i]);

return 0;
}
