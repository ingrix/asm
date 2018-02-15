#include <unistd.h>
#include <stdio.h>

void print_stack_pos()
{
  int i = 0;
  printf("stack at %p\n",&i);
}

void print_break_pos()
{
  void* brkpos = sbrk(0);
  printf("brk at %p\n",brkpos);
}

int main()
{
  print_stack_pos();
  print_break_pos();
  return 0;
}
