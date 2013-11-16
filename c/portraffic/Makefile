all: test.c
	gcc -g -Wall -o test test.c -lpcap
	gcc -g -Wall -o capture capture.c -lpcap
clean:
	rm -rf *.o test capture
