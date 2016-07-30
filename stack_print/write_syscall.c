#include <stdio.h>
#include <unistd.h>

unsigned long long find_start()
{
  __asm__("movq %rsp,%rax");
}

int main()
{
  printf("0x%p\n",find_start());
  return 0;
}
