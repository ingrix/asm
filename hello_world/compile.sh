nasm -f elf64 -g -F dwarf -o hello.o hello_world.asm
ld -o hello hello.o
