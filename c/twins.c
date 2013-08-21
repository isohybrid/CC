#include <stdio.h>

void quick_sort(int *a,int i,int j)
{
  int m,n,tmp,k;
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

int solve(int *a,int n)
{
	int i,j,x,y;
	i=0;j=n-1;x=a[i];y=a[j];
	while(j>(i+1)){
		if(x<y){
			i++;
			x+=a[i];
		}
		else{
			j--;
			y+=a[j];
		}
	}
	if(x>=y)
		return n-j+1;
	else
		return n-j;
}

int main()
{
	int T,n,i,a[100];
	scanf("%d",&T);
	int b[T];
	for(i=1;i<=T;i++){
			scanf("%d",&n);
		for(i=0;i<n;i++)
			scanf("%d",&a[i]);
		quick_sort(a,0,n-1);
		b[i]=solve(a,n);
	}
	for(i=1;i<=T;i++)
		printf("%d\n",b[i]);
	return 0;
}
