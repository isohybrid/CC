#define __USE_BSD             /* Using BSD IP header */
#define __FAVOR_BSD           /* Using BSD TCP header */

#include <pcap.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <netinet/ip.h>       /* Internet Protocol */
#include <netinet/tcp.h>      /* Transmission Control Protocol */

#define MAXBYTES2CAPTURE 2048

long TotalBytes = 0;

int main()
{
  int count = 0;
  struct ip *iphdr = NULL;
  struct tcphdr *tcphdr = NULL;
  struct bfp_program filter;
  struct pcap_pkthdr pkthdr;
  const unsigned char *packet = NULL;
  // pcap_t *device = NULL;

  char errBuf[PCAP_ERRBUF_SIZE], * devStr = NULL;
  memset(errBuf, 0, PCAP_ERRBUF_SIZE);

  if (argc != 2){
    printf("Usage: portraffic <interface>\n");
    exit(1);
  }

  /* get a device */
  /*
  devStr = pcap_lookupdev(errBuf);

  if(devStr)
    printf("device: %s\n", devStr);
  else{
    printf("error: %s\n", errBuf);
    exit(1);
  }
  */

  /* open a device */
  /*
  device = pcap_open_live(devStr, 65535, 1, 0, errBuf);

  if(!device){
    printf("error: pcap_open_live(): %s\n", errBuf);
    exit(1);
  }
  */
  device = pcap_open_live(argv[1], MAXBYTES2CAPTURE, 1, 512, errBuf);

  pcap_compile(device, &filter, "tcp", 1, mask);

  /* wait a packet to arrive */
  while(1){
    struct pcap_pkthdr packet;
    const u_char *pktStr = pcap_next(device, &packet);

    if(!pktStr){
      printf("did not capture a packet!\n");
      exit(1);
    }
    /* get the port */
    /* Assuming is Ethernet! */
    iphdr = (struct ip *)(packet+14);
    /* Assuming no IP options! */
    tcphdr = (struct tcphdr *)(packet+14+20);
    printf("------------------------------------------------\n");
    printf("Received Packet:         %d\n", ++count);
    printf("DST IP:                  %s\n", inet_ntoa(iphdr->ip_dst));
    printf("SRC IP:                  %s\n", inet_ntoa(iphdr->ip_src));
    printf("SRC PORT:                %d\n", ntohs(tcphdr->th_sport));
    printf("DST PORT:                %d\n", ntohs(tcphdr->th_dport));
    printf("------------------------------------------------\n");

    TotalBytes += packet.len;

    printf("Packet length:        %d\n", packet.len);
    printf("number of bytes:      %d\n", packet.caplen);
    printf("Recieved time:        %s\n", ctime((const time_t *)&packet.ts.tv_sec));
    printf("total bytes:          %ld\n", TotalBytes);
  }

  pcap_close(device);

  return 0;
}
