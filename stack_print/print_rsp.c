#include <unistd.h>

int main()
{
  char buf[]={'a','b','c','1','2','3','\n'};
  write(STDOUT_FILENO,buf,7);
  return 0;
}
