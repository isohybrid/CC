#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
  open("/tmp/foo", O_CREAT|O_RDONLY);
  sleep(1200);
  return 0;
}
