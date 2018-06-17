CC = gcc
LD = gcc
NASM = nasm 
IO = -f elf -d ELF_TYPE
CFLAGS =  -c -m32
LFLAGS = -m32
NASMFLAGS = -f elf -F stabs

PROG = fibonacci

OBJS = asm_io.o $(PROG).o

default: $(PROG)

$(PROG): $(OBJS) 
	$(LD) $(LFLAGS) $(OBJS)  -o $(PROG)

asm_io.o: asm_io.asm
	$(NASM) $(IO) asm_io.asm

$(PROG).o: $(PROG).asm asm_io.inc
	$(NASM) $(NASMFLAGS) $(PROG).asm

clean:
	rm -rf *.o *~

real_clean:
	 rm -rf *.o $(PROG) *~

