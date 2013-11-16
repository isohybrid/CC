all: test.c
	gcc -g -Wall -o test test.c -lpcap
	gcc -g -Wall -o capture capture.c -lpcap
	gcc -g -Wall -o portraffic portraffic.c -lpcap
clean:
	rm -rf *.o test capture sum portraffic
