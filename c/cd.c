#include <stdio.h>
#include <string.h>
#include <malloc.h>

char *PWD;
int x;

char *substr(char *p,int i,int j)
{
  char *tmp;
	int k;
	tmp=(char *)malloc((j-i)*sizeof(char));
	for(k=0;k<j-i;k++){
		tmp[k]=p[i+k];
	}
	return tmp;
}

char *less_pwd(char *pwd,int len)
{
	int i;
	char *tmp;
	for(i=len;i>=0;i--){
		if(pwd[i]=='/'){
			tmp=substr(pwd,0,i);
			break;
		}
	}
	return tmp;
}

char *str_check(char *p,int len)
{
	int i;
	char *tmp,*tmp1,*tmp2,*tmp3;
	if(len==2){
		if(p[0]=='.'&&p[1]=='.')
			tmp=less_pwd(PWD,strlen(PWD));
	}
	else{
		for(i=0;i<=len;i++){
			if(p[i]=='.'&&p[i+1]=='.'){
				tmp1=substr(p,0,i-1);
				tmp2=substr(p,i+2,len);
				tmp=less_pwd(PWD,strlen(PWD));
				tmp3=strcat(tmp1,tmp);
				p=strcat(tmp3,tmp2);
			}
		}
	}
	return p;
}

int main()
{
	int T,i,j,len;
	int *m;
	char *p1,*p2;
	p1=p2="";
	x=0;
	scanf("%d",&T);
	m=(int *)malloc(T*sizeof(int));
    char *res[T];
	for(i=0;i<T;i++){
		PWD="/";
		scanf("%d",m[i]);
		for(j=0;j<m[i];j++){
			scanf("%s",p1);
			if(p1[0]=='p'){
				*(res+x)=PWD;
				x++;
			}
			else if(p1[0]=='c'){
				scanf("%s",p2);
				len=strlen(p2);
				p2=str_check(p2,strlen(p2));
				PWD=p2;
				*(res+x)=p2;
				x++;
			}
		}
	}
	i=0;
	while(*(res+i)!="\0"){
		printf("%s\n",res+i);
		i++;
	}
	
	return 0;
}
