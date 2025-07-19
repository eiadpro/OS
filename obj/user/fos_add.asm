
obj/user/fos_add:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 60 00 00 00       	call   800096 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	int i1=0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 c0 19 80 00       	push   $0x8019c0
  800058:	e8 26 0c 00 00       	call   800c83 <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 c2 19 80 00       	push   $0x8019c2
  80006f:	e8 0f 0c 00 00       	call   800c83 <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 c4 19 80 00       	push   $0x8019c4
  80008b:	e8 3e 02 00 00       	call   8002ce <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");
	return;
  800093:	90                   	nop
}
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80009c:	e8 7c 13 00 00       	call   80141d <sys_getenvindex>
  8000a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a7:	89 d0                	mov    %edx,%eax
  8000a9:	c1 e0 03             	shl    $0x3,%eax
  8000ac:	01 d0                	add    %edx,%eax
  8000ae:	01 c0                	add    %eax,%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	c1 e0 04             	shl    $0x4,%eax
  8000be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c3:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000cd:	8a 40 5c             	mov    0x5c(%eax),%al
  8000d0:	84 c0                	test   %al,%al
  8000d2:	74 0d                	je     8000e1 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000d4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d9:	83 c0 5c             	add    $0x5c,%eax
  8000dc:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e5:	7e 0a                	jle    8000f1 <libmain+0x5b>
		binaryname = argv[0];
  8000e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	ff 75 0c             	pushl  0xc(%ebp)
  8000f7:	ff 75 08             	pushl  0x8(%ebp)
  8000fa:	e8 39 ff ff ff       	call   800038 <_main>
  8000ff:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800102:	e8 23 11 00 00       	call   80122a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 f8 19 80 00       	push   $0x8019f8
  80010f:	e8 8d 01 00 00       	call   8002a1 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800117:	a1 20 20 80 00       	mov    0x802020,%eax
  80011c:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800122:	a1 20 20 80 00       	mov    0x802020,%eax
  800127:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80012d:	83 ec 04             	sub    $0x4,%esp
  800130:	52                   	push   %edx
  800131:	50                   	push   %eax
  800132:	68 20 1a 80 00       	push   $0x801a20
  800137:	e8 65 01 00 00       	call   8002a1 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80013f:	a1 20 20 80 00       	mov    0x802020,%eax
  800144:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80014a:	a1 20 20 80 00       	mov    0x802020,%eax
  80014f:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800155:	a1 20 20 80 00       	mov    0x802020,%eax
  80015a:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800160:	51                   	push   %ecx
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	68 48 1a 80 00       	push   $0x801a48
  800168:	e8 34 01 00 00       	call   8002a1 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800170:	a1 20 20 80 00       	mov    0x802020,%eax
  800175:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	68 a0 1a 80 00       	push   $0x801aa0
  800184:	e8 18 01 00 00       	call   8002a1 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 f8 19 80 00       	push   $0x8019f8
  800194:	e8 08 01 00 00       	call   8002a1 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80019c:	e8 a3 10 00 00       	call   801244 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001a1:	e8 19 00 00 00       	call   8001bf <exit>
}
  8001a6:	90                   	nop
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	e8 30 12 00 00       	call   8013e9 <sys_destroy_env>
  8001b9:	83 c4 10             	add    $0x10,%esp
}
  8001bc:	90                   	nop
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <exit>:

void
exit(void)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001c5:	e8 85 12 00 00       	call   80144f <sys_exit_env>
}
  8001ca:	90                   	nop
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	8b 00                	mov    (%eax),%eax
  8001d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8001db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001de:	89 0a                	mov    %ecx,(%edx)
  8001e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e3:	88 d1                	mov    %dl,%cl
  8001e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	8b 00                	mov    (%eax),%eax
  8001f1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f6:	75 2c                	jne    800224 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001f8:	a0 24 20 80 00       	mov    0x802024,%al
  8001fd:	0f b6 c0             	movzbl %al,%eax
  800200:	8b 55 0c             	mov    0xc(%ebp),%edx
  800203:	8b 12                	mov    (%edx),%edx
  800205:	89 d1                	mov    %edx,%ecx
  800207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020a:	83 c2 08             	add    $0x8,%edx
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	50                   	push   %eax
  800211:	51                   	push   %ecx
  800212:	52                   	push   %edx
  800213:	e8 b9 0e 00 00       	call   8010d1 <sys_cputs>
  800218:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	8b 40 04             	mov    0x4(%eax),%eax
  80022a:	8d 50 01             	lea    0x1(%eax),%edx
  80022d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800230:	89 50 04             	mov    %edx,0x4(%eax)
}
  800233:	90                   	nop
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	68 cd 01 80 00       	push   $0x8001cd
  800265:	e8 11 02 00 00       	call   80047b <vprintfmt>
  80026a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80026d:	a0 24 20 80 00       	mov    0x802024,%al
  800272:	0f b6 c0             	movzbl %al,%eax
  800275:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	50                   	push   %eax
  80027f:	52                   	push   %edx
  800280:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800286:	83 c0 08             	add    $0x8,%eax
  800289:	50                   	push   %eax
  80028a:	e8 42 0e 00 00       	call   8010d1 <sys_cputs>
  80028f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800292:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800299:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002a7:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 73 ff ff ff       	call   800236 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002d4:	e8 51 0f 00 00       	call   80122a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e8:	50                   	push   %eax
  8002e9:	e8 48 ff ff ff       	call   800236 <vcprintf>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002f4:	e8 4b 0f 00 00       	call   801244 <sys_enable_interrupt>
	return cnt;
  8002f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	53                   	push   %ebx
  800302:	83 ec 14             	sub    $0x14,%esp
  800305:	8b 45 10             	mov    0x10(%ebp),%eax
  800308:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80030b:	8b 45 14             	mov    0x14(%ebp),%eax
  80030e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800311:	8b 45 18             	mov    0x18(%ebp),%eax
  800314:	ba 00 00 00 00       	mov    $0x0,%edx
  800319:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80031c:	77 55                	ja     800373 <printnum+0x75>
  80031e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800321:	72 05                	jb     800328 <printnum+0x2a>
  800323:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800326:	77 4b                	ja     800373 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800328:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80032b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80032e:	8b 45 18             	mov    0x18(%ebp),%eax
  800331:	ba 00 00 00 00       	mov    $0x0,%edx
  800336:	52                   	push   %edx
  800337:	50                   	push   %eax
  800338:	ff 75 f4             	pushl  -0xc(%ebp)
  80033b:	ff 75 f0             	pushl  -0x10(%ebp)
  80033e:	e8 15 14 00 00       	call   801758 <__udivdi3>
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	83 ec 04             	sub    $0x4,%esp
  800349:	ff 75 20             	pushl  0x20(%ebp)
  80034c:	53                   	push   %ebx
  80034d:	ff 75 18             	pushl  0x18(%ebp)
  800350:	52                   	push   %edx
  800351:	50                   	push   %eax
  800352:	ff 75 0c             	pushl  0xc(%ebp)
  800355:	ff 75 08             	pushl  0x8(%ebp)
  800358:	e8 a1 ff ff ff       	call   8002fe <printnum>
  80035d:	83 c4 20             	add    $0x20,%esp
  800360:	eb 1a                	jmp    80037c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 20             	pushl  0x20(%ebp)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	ff d0                	call   *%eax
  800370:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800373:	ff 4d 1c             	decl   0x1c(%ebp)
  800376:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80037a:	7f e6                	jg     800362 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80037f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80038a:	53                   	push   %ebx
  80038b:	51                   	push   %ecx
  80038c:	52                   	push   %edx
  80038d:	50                   	push   %eax
  80038e:	e8 d5 14 00 00       	call   801868 <__umoddi3>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  80039b:	8a 00                	mov    (%eax),%al
  80039d:	0f be c0             	movsbl %al,%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	ff 75 0c             	pushl  0xc(%ebp)
  8003a6:	50                   	push   %eax
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	ff d0                	call   *%eax
  8003ac:	83 c4 10             	add    $0x10,%esp
}
  8003af:	90                   	nop
  8003b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    

008003b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003bc:	7e 1c                	jle    8003da <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	8d 50 08             	lea    0x8(%eax),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	89 10                	mov    %edx,(%eax)
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	83 e8 08             	sub    $0x8,%eax
  8003d3:	8b 50 04             	mov    0x4(%eax),%edx
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	eb 40                	jmp    80041a <getuint+0x65>
	else if (lflag)
  8003da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003de:	74 1e                	je     8003fe <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	8d 50 04             	lea    0x4(%eax),%edx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	89 10                	mov    %edx,(%eax)
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 e8 04             	sub    $0x4,%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	eb 1c                	jmp    80041a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	8d 50 04             	lea    0x4(%eax),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	89 10                	mov    %edx,(%eax)
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	83 e8 04             	sub    $0x4,%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041a:	5d                   	pop    %ebp
  80041b:	c3                   	ret    

0080041c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800423:	7e 1c                	jle    800441 <getint+0x25>
		return va_arg(*ap, long long);
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	8d 50 08             	lea    0x8(%eax),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 10                	mov    %edx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	83 e8 08             	sub    $0x8,%eax
  80043a:	8b 50 04             	mov    0x4(%eax),%edx
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	eb 38                	jmp    800479 <getint+0x5d>
	else if (lflag)
  800441:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800445:	74 1a                	je     800461 <getint+0x45>
		return va_arg(*ap, long);
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	8d 50 04             	lea    0x4(%eax),%edx
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	83 e8 04             	sub    $0x4,%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	99                   	cltd   
  80045f:	eb 18                	jmp    800479 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	8d 50 04             	lea    0x4(%eax),%edx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 10                	mov    %edx,(%eax)
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	83 e8 04             	sub    $0x4,%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	99                   	cltd   
}
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    

0080047b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	56                   	push   %esi
  80047f:	53                   	push   %ebx
  800480:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800483:	eb 17                	jmp    80049c <vprintfmt+0x21>
			if (ch == '\0')
  800485:	85 db                	test   %ebx,%ebx
  800487:	0f 84 af 03 00 00    	je     80083c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 0c             	pushl  0xc(%ebp)
  800493:	53                   	push   %ebx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	ff d0                	call   *%eax
  800499:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a5:	8a 00                	mov    (%eax),%al
  8004a7:	0f b6 d8             	movzbl %al,%ebx
  8004aa:	83 fb 25             	cmp    $0x25,%ebx
  8004ad:	75 d6                	jne    800485 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004af:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004b3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d2:	8d 50 01             	lea    0x1(%eax),%edx
  8004d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d8:	8a 00                	mov    (%eax),%al
  8004da:	0f b6 d8             	movzbl %al,%ebx
  8004dd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004e0:	83 f8 55             	cmp    $0x55,%eax
  8004e3:	0f 87 2b 03 00 00    	ja     800814 <vprintfmt+0x399>
  8004e9:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  8004f0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004f2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004f6:	eb d7                	jmp    8004cf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004fc:	eb d1                	jmp    8004cf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800505:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800508:	89 d0                	mov    %edx,%eax
  80050a:	c1 e0 02             	shl    $0x2,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	01 c0                	add    %eax,%eax
  800511:	01 d8                	add    %ebx,%eax
  800513:	83 e8 30             	sub    $0x30,%eax
  800516:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800519:	8b 45 10             	mov    0x10(%ebp),%eax
  80051c:	8a 00                	mov    (%eax),%al
  80051e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800521:	83 fb 2f             	cmp    $0x2f,%ebx
  800524:	7e 3e                	jle    800564 <vprintfmt+0xe9>
  800526:	83 fb 39             	cmp    $0x39,%ebx
  800529:	7f 39                	jg     800564 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80052e:	eb d5                	jmp    800505 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	83 c0 04             	add    $0x4,%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	83 e8 04             	sub    $0x4,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800544:	eb 1f                	jmp    800565 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800546:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054a:	79 83                	jns    8004cf <vprintfmt+0x54>
				width = 0;
  80054c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800553:	e9 77 ff ff ff       	jmp    8004cf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800558:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80055f:	e9 6b ff ff ff       	jmp    8004cf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800564:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800569:	0f 89 60 ff ff ff    	jns    8004cf <vprintfmt+0x54>
				width = precision, precision = -1;
  80056f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800572:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800575:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80057c:	e9 4e ff ff ff       	jmp    8004cf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800581:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800584:	e9 46 ff ff ff       	jmp    8004cf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	83 c0 04             	add    $0x4,%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	83 e8 04             	sub    $0x4,%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	ff 75 0c             	pushl  0xc(%ebp)
  8005a0:	50                   	push   %eax
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	ff d0                	call   *%eax
  8005a6:	83 c4 10             	add    $0x10,%esp
			break;
  8005a9:	e9 89 02 00 00       	jmp    800837 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	83 c0 04             	add    $0x4,%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	83 e8 04             	sub    $0x4,%eax
  8005bd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005bf:	85 db                	test   %ebx,%ebx
  8005c1:	79 02                	jns    8005c5 <vprintfmt+0x14a>
				err = -err;
  8005c3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005c5:	83 fb 64             	cmp    $0x64,%ebx
  8005c8:	7f 0b                	jg     8005d5 <vprintfmt+0x15a>
  8005ca:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005d1:	85 f6                	test   %esi,%esi
  8005d3:	75 19                	jne    8005ee <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005d5:	53                   	push   %ebx
  8005d6:	68 e5 1c 80 00       	push   $0x801ce5
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	ff 75 08             	pushl  0x8(%ebp)
  8005e1:	e8 5e 02 00 00       	call   800844 <printfmt>
  8005e6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005e9:	e9 49 02 00 00       	jmp    800837 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ee:	56                   	push   %esi
  8005ef:	68 ee 1c 80 00       	push   $0x801cee
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 45 02 00 00       	call   800844 <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			break;
  800602:	e9 30 02 00 00       	jmp    800837 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	83 c0 04             	add    $0x4,%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 30                	mov    (%eax),%esi
  800618:	85 f6                	test   %esi,%esi
  80061a:	75 05                	jne    800621 <vprintfmt+0x1a6>
				p = "(null)";
  80061c:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	7e 6d                	jle    800694 <vprintfmt+0x219>
  800627:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80062b:	74 67                	je     800694 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80062d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	50                   	push   %eax
  800634:	56                   	push   %esi
  800635:	e8 0c 03 00 00       	call   800946 <strnlen>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800640:	eb 16                	jmp    800658 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800642:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	50                   	push   %eax
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800655:	ff 4d e4             	decl   -0x1c(%ebp)
  800658:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065c:	7f e4                	jg     800642 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065e:	eb 34                	jmp    800694 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800660:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800664:	74 1c                	je     800682 <vprintfmt+0x207>
  800666:	83 fb 1f             	cmp    $0x1f,%ebx
  800669:	7e 05                	jle    800670 <vprintfmt+0x1f5>
  80066b:	83 fb 7e             	cmp    $0x7e,%ebx
  80066e:	7e 12                	jle    800682 <vprintfmt+0x207>
					putch('?', putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	6a 3f                	push   $0x3f
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	ff d0                	call   *%eax
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	eb 0f                	jmp    800691 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	53                   	push   %ebx
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	ff d0                	call   *%eax
  80068e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800691:	ff 4d e4             	decl   -0x1c(%ebp)
  800694:	89 f0                	mov    %esi,%eax
  800696:	8d 70 01             	lea    0x1(%eax),%esi
  800699:	8a 00                	mov    (%eax),%al
  80069b:	0f be d8             	movsbl %al,%ebx
  80069e:	85 db                	test   %ebx,%ebx
  8006a0:	74 24                	je     8006c6 <vprintfmt+0x24b>
  8006a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a6:	78 b8                	js     800660 <vprintfmt+0x1e5>
  8006a8:	ff 4d e0             	decl   -0x20(%ebp)
  8006ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006af:	79 af                	jns    800660 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b1:	eb 13                	jmp    8006c6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	6a 20                	push   $0x20
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ca:	7f e7                	jg     8006b3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006cc:	e9 66 01 00 00       	jmp    800837 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8006d7:	8d 45 14             	lea    0x14(%ebp),%eax
  8006da:	50                   	push   %eax
  8006db:	e8 3c fd ff ff       	call   80041c <getint>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ef:	85 d2                	test   %edx,%edx
  8006f1:	79 23                	jns    800716 <vprintfmt+0x29b>
				putch('-', putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	6a 2d                	push   $0x2d
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800709:	f7 d8                	neg    %eax
  80070b:	83 d2 00             	adc    $0x0,%edx
  80070e:	f7 da                	neg    %edx
  800710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800713:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800716:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80071d:	e9 bc 00 00 00       	jmp    8007de <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 e8             	pushl  -0x18(%ebp)
  800728:	8d 45 14             	lea    0x14(%ebp),%eax
  80072b:	50                   	push   %eax
  80072c:	e8 84 fc ff ff       	call   8003b5 <getuint>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800737:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80073a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800741:	e9 98 00 00 00       	jmp    8007de <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 58                	push   $0x58
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	6a 58                	push   $0x58
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	6a 58                	push   $0x58
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
			break;
  800776:	e9 bc 00 00 00       	jmp    800837 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	6a 30                	push   $0x30
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	6a 78                	push   $0x78
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	83 c0 04             	add    $0x4,%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007b6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007bd:	eb 1f                	jmp    8007de <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	e8 e7 fb ff ff       	call   8003b5 <getuint>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007de:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	52                   	push   %edx
  8007e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 00 fb ff ff       	call   8002fe <printnum>
  8007fe:	83 c4 20             	add    $0x20,%esp
			break;
  800801:	eb 34                	jmp    800837 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	53                   	push   %ebx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
			break;
  800812:	eb 23                	jmp    800837 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	6a 25                	push   $0x25
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800824:	ff 4d 10             	decl   0x10(%ebp)
  800827:	eb 03                	jmp    80082c <vprintfmt+0x3b1>
  800829:	ff 4d 10             	decl   0x10(%ebp)
  80082c:	8b 45 10             	mov    0x10(%ebp),%eax
  80082f:	48                   	dec    %eax
  800830:	8a 00                	mov    (%eax),%al
  800832:	3c 25                	cmp    $0x25,%al
  800834:	75 f3                	jne    800829 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800836:	90                   	nop
		}
	}
  800837:	e9 47 fc ff ff       	jmp    800483 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80083c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80083d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80084a:	8d 45 10             	lea    0x10(%ebp),%eax
  80084d:	83 c0 04             	add    $0x4,%eax
  800850:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800853:	8b 45 10             	mov    0x10(%ebp),%eax
  800856:	ff 75 f4             	pushl  -0xc(%ebp)
  800859:	50                   	push   %eax
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	ff 75 08             	pushl  0x8(%ebp)
  800860:	e8 16 fc ff ff       	call   80047b <vprintfmt>
  800865:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800868:	90                   	nop
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800871:	8b 40 08             	mov    0x8(%eax),%eax
  800874:	8d 50 01             	lea    0x1(%eax),%edx
  800877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800880:	8b 10                	mov    (%eax),%edx
  800882:	8b 45 0c             	mov    0xc(%ebp),%eax
  800885:	8b 40 04             	mov    0x4(%eax),%eax
  800888:	39 c2                	cmp    %eax,%edx
  80088a:	73 12                	jae    80089e <sprintputch+0x33>
		*b->buf++ = ch;
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 48 01             	lea    0x1(%eax),%ecx
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	89 0a                	mov    %ecx,(%edx)
  800899:	8b 55 08             	mov    0x8(%ebp),%edx
  80089c:	88 10                	mov    %dl,(%eax)
}
  80089e:	90                   	nop
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	01 d0                	add    %edx,%eax
  8008b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008c6:	74 06                	je     8008ce <vsnprintf+0x2d>
  8008c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cc:	7f 07                	jg     8008d5 <vsnprintf+0x34>
		return -E_INVAL;
  8008ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8008d3:	eb 20                	jmp    8008f5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d5:	ff 75 14             	pushl  0x14(%ebp)
  8008d8:	ff 75 10             	pushl  0x10(%ebp)
  8008db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	68 6b 08 80 00       	push   $0x80086b
  8008e4:	e8 92 fb ff ff       	call   80047b <vprintfmt>
  8008e9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fd:	8d 45 10             	lea    0x10(%ebp),%eax
  800900:	83 c0 04             	add    $0x4,%eax
  800903:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	ff 75 f4             	pushl  -0xc(%ebp)
  80090c:	50                   	push   %eax
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	ff 75 08             	pushl  0x8(%ebp)
  800913:	e8 89 ff ff ff       	call   8008a1 <vsnprintf>
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80091e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800921:	c9                   	leave  
  800922:	c3                   	ret    

00800923 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800929:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800930:	eb 06                	jmp    800938 <strlen+0x15>
		n++;
  800932:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800935:	ff 45 08             	incl   0x8(%ebp)
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	8a 00                	mov    (%eax),%al
  80093d:	84 c0                	test   %al,%al
  80093f:	75 f1                	jne    800932 <strlen+0xf>
		n++;
	return n;
  800941:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800953:	eb 09                	jmp    80095e <strnlen+0x18>
		n++;
  800955:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800958:	ff 45 08             	incl   0x8(%ebp)
  80095b:	ff 4d 0c             	decl   0xc(%ebp)
  80095e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800962:	74 09                	je     80096d <strnlen+0x27>
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8a 00                	mov    (%eax),%al
  800969:	84 c0                	test   %al,%al
  80096b:	75 e8                	jne    800955 <strnlen+0xf>
		n++;
	return n;
  80096d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80097e:	90                   	nop
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8d 50 01             	lea    0x1(%eax),%edx
  800985:	89 55 08             	mov    %edx,0x8(%ebp)
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80098e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800991:	8a 12                	mov    (%edx),%dl
  800993:	88 10                	mov    %dl,(%eax)
  800995:	8a 00                	mov    (%eax),%al
  800997:	84 c0                	test   %al,%al
  800999:	75 e4                	jne    80097f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80099b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80099e:	c9                   	leave  
  80099f:	c3                   	ret    

008009a0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009b3:	eb 1f                	jmp    8009d4 <strncpy+0x34>
		*dst++ = *src;
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8d 50 01             	lea    0x1(%eax),%edx
  8009bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	8a 12                	mov    (%edx),%dl
  8009c3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	84 c0                	test   %al,%al
  8009cc:	74 03                	je     8009d1 <strncpy+0x31>
			src++;
  8009ce:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d1:	ff 45 fc             	incl   -0x4(%ebp)
  8009d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009d7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009da:	72 d9                	jb     8009b5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f1:	74 30                	je     800a23 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009f3:	eb 16                	jmp    800a0b <strlcpy+0x2a>
			*dst++ = *src++;
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8d 50 01             	lea    0x1(%eax),%edx
  8009fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a07:	8a 12                	mov    (%edx),%dl
  800a09:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a0b:	ff 4d 10             	decl   0x10(%ebp)
  800a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a12:	74 09                	je     800a1d <strlcpy+0x3c>
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	84 c0                	test   %al,%al
  800a1b:	75 d8                	jne    8009f5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a23:	8b 55 08             	mov    0x8(%ebp),%edx
  800a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a29:	29 c2                	sub    %eax,%edx
  800a2b:	89 d0                	mov    %edx,%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a32:	eb 06                	jmp    800a3a <strcmp+0xb>
		p++, q++;
  800a34:	ff 45 08             	incl   0x8(%ebp)
  800a37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8a 00                	mov    (%eax),%al
  800a3f:	84 c0                	test   %al,%al
  800a41:	74 0e                	je     800a51 <strcmp+0x22>
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8a 10                	mov    (%eax),%dl
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	38 c2                	cmp    %al,%dl
  800a4f:	74 e3                	je     800a34 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	0f b6 d0             	movzbl %al,%edx
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	29 c2                	sub    %eax,%edx
  800a63:	89 d0                	mov    %edx,%eax
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a6a:	eb 09                	jmp    800a75 <strncmp+0xe>
		n--, p++, q++;
  800a6c:	ff 4d 10             	decl   0x10(%ebp)
  800a6f:	ff 45 08             	incl   0x8(%ebp)
  800a72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a79:	74 17                	je     800a92 <strncmp+0x2b>
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	84 c0                	test   %al,%al
  800a82:	74 0e                	je     800a92 <strncmp+0x2b>
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8a 10                	mov    (%eax),%dl
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	38 c2                	cmp    %al,%dl
  800a90:	74 da                	je     800a6c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a96:	75 07                	jne    800a9f <strncmp+0x38>
		return 0;
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9d:	eb 14                	jmp    800ab3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	0f b6 d0             	movzbl %al,%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	8a 00                	mov    (%eax),%al
  800aac:	0f b6 c0             	movzbl %al,%eax
  800aaf:	29 c2                	sub    %eax,%edx
  800ab1:	89 d0                	mov    %edx,%eax
}
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 04             	sub    $0x4,%esp
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac1:	eb 12                	jmp    800ad5 <strchr+0x20>
		if (*s == c)
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800acb:	75 05                	jne    800ad2 <strchr+0x1d>
			return (char *) s;
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	eb 11                	jmp    800ae3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ad2:	ff 45 08             	incl   0x8(%ebp)
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8a 00                	mov    (%eax),%al
  800ada:	84 c0                	test   %al,%al
  800adc:	75 e5                	jne    800ac3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800af1:	eb 0d                	jmp    800b00 <strfind+0x1b>
		if (*s == c)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800afb:	74 0e                	je     800b0b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800afd:	ff 45 08             	incl   0x8(%ebp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	84 c0                	test   %al,%al
  800b07:	75 ea                	jne    800af3 <strfind+0xe>
  800b09:	eb 01                	jmp    800b0c <strfind+0x27>
		if (*s == c)
			break;
  800b0b:	90                   	nop
	return (char *) s;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b23:	eb 0e                	jmp    800b33 <memset+0x22>
		*p++ = c;
  800b25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b33:	ff 4d f8             	decl   -0x8(%ebp)
  800b36:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b3a:	79 e9                	jns    800b25 <memset+0x14>
		*p++ = c;

	return v;
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b53:	eb 16                	jmp    800b6b <memcpy+0x2a>
		*d++ = *s++;
  800b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b67:	8a 12                	mov    (%edx),%dl
  800b69:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b71:	89 55 10             	mov    %edx,0x10(%ebp)
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 dd                	jne    800b55 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b95:	73 50                	jae    800be7 <memmove+0x6a>
  800b97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	01 d0                	add    %edx,%eax
  800b9f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ba2:	76 43                	jbe    800be7 <memmove+0x6a>
		s += n;
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bb0:	eb 10                	jmp    800bc2 <memmove+0x45>
			*--d = *--s;
  800bb2:	ff 4d f8             	decl   -0x8(%ebp)
  800bb5:	ff 4d fc             	decl   -0x4(%ebp)
  800bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbb:	8a 10                	mov    (%eax),%dl
  800bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bc0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcb:	85 c0                	test   %eax,%eax
  800bcd:	75 e3                	jne    800bb2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bcf:	eb 23                	jmp    800bf4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bdd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800be3:	8a 12                	mov    (%edx),%dl
  800be5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bed:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	75 dd                	jne    800bd1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c0b:	eb 2a                	jmp    800c37 <memcmp+0x3e>
		if (*s1 != *s2)
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c10:	8a 10                	mov    (%eax),%dl
  800c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	38 c2                	cmp    %al,%dl
  800c19:	74 16                	je     800c31 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	0f b6 d0             	movzbl %al,%edx
  800c23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	0f b6 c0             	movzbl %al,%eax
  800c2b:	29 c2                	sub    %eax,%edx
  800c2d:	89 d0                	mov    %edx,%eax
  800c2f:	eb 18                	jmp    800c49 <memcmp+0x50>
		s1++, s2++;
  800c31:	ff 45 fc             	incl   -0x4(%ebp)
  800c34:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c40:	85 c0                	test   %eax,%eax
  800c42:	75 c9                	jne    800c0d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	01 d0                	add    %edx,%eax
  800c59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c5c:	eb 15                	jmp    800c73 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 d0             	movzbl %al,%edx
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	0f b6 c0             	movzbl %al,%eax
  800c6c:	39 c2                	cmp    %eax,%edx
  800c6e:	74 0d                	je     800c7d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c70:	ff 45 08             	incl   0x8(%ebp)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c79:	72 e3                	jb     800c5e <memfind+0x13>
  800c7b:	eb 01                	jmp    800c7e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c7d:	90                   	nop
	return (void *) s;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c90:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c97:	eb 03                	jmp    800c9c <strtol+0x19>
		s++;
  800c99:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	3c 20                	cmp    $0x20,%al
  800ca3:	74 f4                	je     800c99 <strtol+0x16>
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	3c 09                	cmp    $0x9,%al
  800cac:	74 eb                	je     800c99 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	3c 2b                	cmp    $0x2b,%al
  800cb5:	75 05                	jne    800cbc <strtol+0x39>
		s++;
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	eb 13                	jmp    800ccf <strtol+0x4c>
	else if (*s == '-')
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	3c 2d                	cmp    $0x2d,%al
  800cc3:	75 0a                	jne    800ccf <strtol+0x4c>
		s++, neg = 1;
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd3:	74 06                	je     800cdb <strtol+0x58>
  800cd5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cd9:	75 20                	jne    800cfb <strtol+0x78>
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	3c 30                	cmp    $0x30,%al
  800ce2:	75 17                	jne    800cfb <strtol+0x78>
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	40                   	inc    %eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	3c 78                	cmp    $0x78,%al
  800cec:	75 0d                	jne    800cfb <strtol+0x78>
		s += 2, base = 16;
  800cee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cf2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cf9:	eb 28                	jmp    800d23 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	75 15                	jne    800d16 <strtol+0x93>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	3c 30                	cmp    $0x30,%al
  800d08:	75 0c                	jne    800d16 <strtol+0x93>
		s++, base = 8;
  800d0a:	ff 45 08             	incl   0x8(%ebp)
  800d0d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d14:	eb 0d                	jmp    800d23 <strtol+0xa0>
	else if (base == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strtol+0xa0>
		base = 10;
  800d1c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	3c 2f                	cmp    $0x2f,%al
  800d2a:	7e 19                	jle    800d45 <strtol+0xc2>
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3c 39                	cmp    $0x39,%al
  800d33:	7f 10                	jg     800d45 <strtol+0xc2>
			dig = *s - '0';
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f be c0             	movsbl %al,%eax
  800d3d:	83 e8 30             	sub    $0x30,%eax
  800d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d43:	eb 42                	jmp    800d87 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 60                	cmp    $0x60,%al
  800d4c:	7e 19                	jle    800d67 <strtol+0xe4>
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 7a                	cmp    $0x7a,%al
  800d55:	7f 10                	jg     800d67 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	0f be c0             	movsbl %al,%eax
  800d5f:	83 e8 57             	sub    $0x57,%eax
  800d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d65:	eb 20                	jmp    800d87 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3c 40                	cmp    $0x40,%al
  800d6e:	7e 39                	jle    800da9 <strtol+0x126>
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 5a                	cmp    $0x5a,%al
  800d77:	7f 30                	jg     800da9 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f be c0             	movsbl %al,%eax
  800d81:	83 e8 37             	sub    $0x37,%eax
  800d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8d:	7d 19                	jge    800da8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9e:	01 d0                	add    %edx,%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800da3:	e9 7b ff ff ff       	jmp    800d23 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800da8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800da9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dad:	74 08                	je     800db7 <strtol+0x134>
		*endptr = (char *) s;
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800db7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dbb:	74 07                	je     800dc4 <strtol+0x141>
  800dbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc0:	f7 d8                	neg    %eax
  800dc2:	eb 03                	jmp    800dc7 <strtol+0x144>
  800dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <ltostr>:

void
ltostr(long value, char *str)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de1:	79 13                	jns    800df6 <ltostr+0x2d>
	{
		neg = 1;
  800de3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800df0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800df3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dfe:	99                   	cltd   
  800dff:	f7 f9                	idiv   %ecx
  800e01:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e17:	83 c2 30             	add    $0x30,%edx
  800e1a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e24:	f7 e9                	imul   %ecx
  800e26:	c1 fa 02             	sar    $0x2,%edx
  800e29:	89 c8                	mov    %ecx,%eax
  800e2b:	c1 f8 1f             	sar    $0x1f,%eax
  800e2e:	29 c2                	sub    %eax,%edx
  800e30:	89 d0                	mov    %edx,%eax
  800e32:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e38:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e3d:	f7 e9                	imul   %ecx
  800e3f:	c1 fa 02             	sar    $0x2,%edx
  800e42:	89 c8                	mov    %ecx,%eax
  800e44:	c1 f8 1f             	sar    $0x1f,%eax
  800e47:	29 c2                	sub    %eax,%edx
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	c1 e0 02             	shl    $0x2,%eax
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	01 c0                	add    %eax,%eax
  800e52:	29 c1                	sub    %eax,%ecx
  800e54:	89 ca                	mov    %ecx,%edx
  800e56:	85 d2                	test   %edx,%edx
  800e58:	75 9c                	jne    800df6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e64:	48                   	dec    %eax
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e6c:	74 3d                	je     800eab <ltostr+0xe2>
		start = 1 ;
  800e6e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e75:	eb 34                	jmp    800eab <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	01 d0                	add    %edx,%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	01 c2                	add    %eax,%edx
  800e8c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	01 c8                	add    %ecx,%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 c2                	add    %eax,%edx
  800ea0:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ea3:	88 02                	mov    %al,(%edx)
		start++ ;
  800ea5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ea8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eb1:	7c c4                	jl     800e77 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eb3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ebe:	90                   	nop
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ec7:	ff 75 08             	pushl  0x8(%ebp)
  800eca:	e8 54 fa ff ff       	call   800923 <strlen>
  800ecf:	83 c4 04             	add    $0x4,%esp
  800ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	e8 46 fa ff ff       	call   800923 <strlen>
  800edd:	83 c4 04             	add    $0x4,%esp
  800ee0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ee3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef1:	eb 17                	jmp    800f0a <strcconcat+0x49>
		final[s] = str1[s] ;
  800ef3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	01 c2                	add    %eax,%edx
  800efb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	01 c8                	add    %ecx,%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f07:	ff 45 fc             	incl   -0x4(%ebp)
  800f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f10:	7c e1                	jl     800ef3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f20:	eb 1f                	jmp    800f41 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f2b:	89 c2                	mov    %eax,%edx
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	01 c2                	add    %eax,%edx
  800f32:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	01 c8                	add    %ecx,%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f3e:	ff 45 f8             	incl   -0x8(%ebp)
  800f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f47:	7c d9                	jl     800f22 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4f:	01 d0                	add    %edx,%eax
  800f51:	c6 00 00             	movb   $0x0,(%eax)
}
  800f54:	90                   	nop
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	01 d0                	add    %edx,%eax
  800f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f7a:	eb 0c                	jmp    800f88 <strsplit+0x31>
			*string++ = 0;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8d 50 01             	lea    0x1(%eax),%edx
  800f82:	89 55 08             	mov    %edx,0x8(%ebp)
  800f85:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 18                	je     800fa9 <strsplit+0x52>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	0f be c0             	movsbl %al,%eax
  800f99:	50                   	push   %eax
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	e8 13 fb ff ff       	call   800ab5 <strchr>
  800fa2:	83 c4 08             	add    $0x8,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	75 d3                	jne    800f7c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	74 5a                	je     80100c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb5:	8b 00                	mov    (%eax),%eax
  800fb7:	83 f8 0f             	cmp    $0xf,%eax
  800fba:	75 07                	jne    800fc3 <strsplit+0x6c>
		{
			return 0;
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc1:	eb 66                	jmp    801029 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	8b 00                	mov    (%eax),%eax
  800fc8:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcb:	8b 55 14             	mov    0x14(%ebp),%edx
  800fce:	89 0a                	mov    %ecx,(%edx)
  800fd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	01 c2                	add    %eax,%edx
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fe1:	eb 03                	jmp    800fe6 <strsplit+0x8f>
			string++;
  800fe3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	84 c0                	test   %al,%al
  800fed:	74 8b                	je     800f7a <strsplit+0x23>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	50                   	push   %eax
  800ff8:	ff 75 0c             	pushl  0xc(%ebp)
  800ffb:	e8 b5 fa ff ff       	call   800ab5 <strchr>
  801000:	83 c4 08             	add    $0x8,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	74 dc                	je     800fe3 <strsplit+0x8c>
			string++;
	}
  801007:	e9 6e ff ff ff       	jmp    800f7a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80100c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80100d:	8b 45 14             	mov    0x14(%ebp),%eax
  801010:	8b 00                	mov    (%eax),%eax
  801012:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801024:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801038:	eb 4c                	jmp    801086 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80103a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 40                	cmp    $0x40,%al
  801046:	7e 27                	jle    80106f <str2lower+0x44>
  801048:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	01 d0                	add    %edx,%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 5a                	cmp    $0x5a,%al
  801054:	7f 19                	jg     80106f <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801056:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801061:	8b 55 0c             	mov    0xc(%ebp),%edx
  801064:	01 ca                	add    %ecx,%edx
  801066:	8a 12                	mov    (%edx),%dl
  801068:	83 c2 20             	add    $0x20,%edx
  80106b:	88 10                	mov    %dl,(%eax)
  80106d:	eb 14                	jmp    801083 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80106f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	01 c2                	add    %eax,%edx
  801077:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	01 c8                	add    %ecx,%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801083:	ff 45 fc             	incl   -0x4(%ebp)
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	e8 95 f8 ff ff       	call   800923 <strlen>
  80108e:	83 c4 04             	add    $0x4,%esp
  801091:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801094:	7f a4                	jg     80103a <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801096:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010bb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010be:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010c1:	cd 30                	int    $0x30
  8010c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    

008010d1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 04             	sub    $0x4,%esp
  8010d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	6a 00                	push   $0x0
  8010e6:	6a 00                	push   $0x0
  8010e8:	52                   	push   %edx
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	50                   	push   %eax
  8010ed:	6a 00                	push   $0x0
  8010ef:	e8 b2 ff ff ff       	call   8010a6 <syscall>
  8010f4:	83 c4 18             	add    $0x18,%esp
}
  8010f7:	90                   	nop
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010fd:	6a 00                	push   $0x0
  8010ff:	6a 00                	push   $0x0
  801101:	6a 00                	push   $0x0
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	6a 01                	push   $0x1
  801109:	e8 98 ff ff ff       	call   8010a6 <syscall>
  80110e:	83 c4 18             	add    $0x18,%esp
}
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801116:	8b 55 0c             	mov    0xc(%ebp),%edx
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	52                   	push   %edx
  801123:	50                   	push   %eax
  801124:	6a 05                	push   $0x5
  801126:	e8 7b ff ff ff       	call   8010a6 <syscall>
  80112b:	83 c4 18             	add    $0x18,%esp
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	56                   	push   %esi
  801134:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801135:	8b 75 18             	mov    0x18(%ebp),%esi
  801138:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80113b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80113e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	51                   	push   %ecx
  801147:	52                   	push   %edx
  801148:	50                   	push   %eax
  801149:	6a 06                	push   $0x6
  80114b:	e8 56 ff ff ff       	call   8010a6 <syscall>
  801150:	83 c4 18             	add    $0x18,%esp
}
  801153:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80115d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	6a 00                	push   $0x0
  801169:	52                   	push   %edx
  80116a:	50                   	push   %eax
  80116b:	6a 07                	push   $0x7
  80116d:	e8 34 ff ff ff       	call   8010a6 <syscall>
  801172:	83 c4 18             	add    $0x18,%esp
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	ff 75 08             	pushl  0x8(%ebp)
  801186:	6a 08                	push   $0x8
  801188:	e8 19 ff ff ff       	call   8010a6 <syscall>
  80118d:	83 c4 18             	add    $0x18,%esp
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 09                	push   $0x9
  8011a1:	e8 00 ff ff ff       	call   8010a6 <syscall>
  8011a6:	83 c4 18             	add    $0x18,%esp
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 0a                	push   $0xa
  8011ba:	e8 e7 fe ff ff       	call   8010a6 <syscall>
  8011bf:	83 c4 18             	add    $0x18,%esp
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 0b                	push   $0xb
  8011d3:	e8 ce fe ff ff       	call   8010a6 <syscall>
  8011d8:	83 c4 18             	add    $0x18,%esp
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 0c                	push   $0xc
  8011ec:	e8 b5 fe ff ff       	call   8010a6 <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	ff 75 08             	pushl  0x8(%ebp)
  801204:	6a 0d                	push   $0xd
  801206:	e8 9b fe ff ff       	call   8010a6 <syscall>
  80120b:	83 c4 18             	add    $0x18,%esp
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	6a 0e                	push   $0xe
  80121f:	e8 82 fe ff ff       	call   8010a6 <syscall>
  801224:	83 c4 18             	add    $0x18,%esp
}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 11                	push   $0x11
  801239:	e8 68 fe ff ff       	call   8010a6 <syscall>
  80123e:	83 c4 18             	add    $0x18,%esp
}
  801241:	90                   	nop
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 12                	push   $0x12
  801253:	e8 4e fe ff ff       	call   8010a6 <syscall>
  801258:	83 c4 18             	add    $0x18,%esp
}
  80125b:	90                   	nop
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <sys_cputc>:


void
sys_cputc(const char c)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80126a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	50                   	push   %eax
  801277:	6a 13                	push   $0x13
  801279:	e8 28 fe ff ff       	call   8010a6 <syscall>
  80127e:	83 c4 18             	add    $0x18,%esp
}
  801281:	90                   	nop
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 14                	push   $0x14
  801293:	e8 0e fe ff ff       	call   8010a6 <syscall>
  801298:	83 c4 18             	add    $0x18,%esp
}
  80129b:	90                   	nop
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	ff 75 0c             	pushl  0xc(%ebp)
  8012ad:	50                   	push   %eax
  8012ae:	6a 15                	push   $0x15
  8012b0:	e8 f1 fd ff ff       	call   8010a6 <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	52                   	push   %edx
  8012ca:	50                   	push   %eax
  8012cb:	6a 18                	push   $0x18
  8012cd:	e8 d4 fd ff ff       	call   8010a6 <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	6a 16                	push   $0x16
  8012ea:	e8 b7 fd ff ff       	call   8010a6 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	52                   	push   %edx
  801305:	50                   	push   %eax
  801306:	6a 17                	push   $0x17
  801308:	e8 99 fd ff ff       	call   8010a6 <syscall>
  80130d:	83 c4 18             	add    $0x18,%esp
}
  801310:	90                   	nop
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80131f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801322:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	6a 00                	push   $0x0
  80132b:	51                   	push   %ecx
  80132c:	52                   	push   %edx
  80132d:	ff 75 0c             	pushl  0xc(%ebp)
  801330:	50                   	push   %eax
  801331:	6a 19                	push   $0x19
  801333:	e8 6e fd ff ff       	call   8010a6 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801340:	8b 55 0c             	mov    0xc(%ebp),%edx
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	52                   	push   %edx
  80134d:	50                   	push   %eax
  80134e:	6a 1a                	push   $0x1a
  801350:	e8 51 fd ff ff       	call   8010a6 <syscall>
  801355:	83 c4 18             	add    $0x18,%esp
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80135d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801360:	8b 55 0c             	mov    0xc(%ebp),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	51                   	push   %ecx
  80136b:	52                   	push   %edx
  80136c:	50                   	push   %eax
  80136d:	6a 1b                	push   $0x1b
  80136f:	e8 32 fd ff ff       	call   8010a6 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80137c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	52                   	push   %edx
  801389:	50                   	push   %eax
  80138a:	6a 1c                	push   $0x1c
  80138c:	e8 15 fd ff ff       	call   8010a6 <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 1d                	push   $0x1d
  8013a5:	e8 fc fc ff ff       	call   8010a6 <syscall>
  8013aa:	83 c4 18             	add    $0x18,%esp
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	6a 00                	push   $0x0
  8013b7:	ff 75 14             	pushl  0x14(%ebp)
  8013ba:	ff 75 10             	pushl  0x10(%ebp)
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	50                   	push   %eax
  8013c1:	6a 1e                	push   $0x1e
  8013c3:	e8 de fc ff ff       	call   8010a6 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	50                   	push   %eax
  8013dc:	6a 1f                	push   $0x1f
  8013de:	e8 c3 fc ff ff       	call   8010a6 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	50                   	push   %eax
  8013f8:	6a 20                	push   $0x20
  8013fa:	e8 a7 fc ff ff       	call   8010a6 <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 02                	push   $0x2
  801413:	e8 8e fc ff ff       	call   8010a6 <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 03                	push   $0x3
  80142c:	e8 75 fc ff ff       	call   8010a6 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 04                	push   $0x4
  801445:	e8 5c fc ff ff       	call   8010a6 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_exit_env>:


void sys_exit_env(void)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 21                	push   $0x21
  80145e:	e8 43 fc ff ff       	call   8010a6 <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	90                   	nop
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80146f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801472:	8d 50 04             	lea    0x4(%eax),%edx
  801475:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	52                   	push   %edx
  80147f:	50                   	push   %eax
  801480:	6a 22                	push   $0x22
  801482:	e8 1f fc ff ff       	call   8010a6 <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
	return result;
  80148a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80148d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801493:	89 01                	mov    %eax,(%ecx)
  801495:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	c9                   	leave  
  80149c:	c2 04 00             	ret    $0x4

0080149f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	ff 75 10             	pushl  0x10(%ebp)
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	6a 10                	push   $0x10
  8014b1:	e8 f0 fb ff ff       	call   8010a6 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b9:	90                   	nop
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_rcr2>:
uint32 sys_rcr2()
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 23                	push   $0x23
  8014cb:	e8 d6 fb ff ff       	call   8010a6 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014e1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	50                   	push   %eax
  8014ee:	6a 24                	push   $0x24
  8014f0:	e8 b1 fb ff ff       	call   8010a6 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f8:	90                   	nop
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <rsttst>:
void rsttst()
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 26                	push   $0x26
  80150a:	e8 97 fb ff ff       	call   8010a6 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
	return ;
  801512:	90                   	nop
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	8b 45 14             	mov    0x14(%ebp),%eax
  80151e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801521:	8b 55 18             	mov    0x18(%ebp),%edx
  801524:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801528:	52                   	push   %edx
  801529:	50                   	push   %eax
  80152a:	ff 75 10             	pushl  0x10(%ebp)
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	6a 25                	push   $0x25
  801535:	e8 6c fb ff ff       	call   8010a6 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
	return ;
  80153d:	90                   	nop
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <chktst>:
void chktst(uint32 n)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	ff 75 08             	pushl  0x8(%ebp)
  80154e:	6a 27                	push   $0x27
  801550:	e8 51 fb ff ff       	call   8010a6 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
	return ;
  801558:	90                   	nop
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <inctst>:

void inctst()
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 28                	push   $0x28
  80156a:	e8 37 fb ff ff       	call   8010a6 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
	return ;
  801572:	90                   	nop
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <gettst>:
uint32 gettst()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 29                	push   $0x29
  801584:	e8 1d fb ff ff       	call   8010a6 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 2a                	push   $0x2a
  8015a0:	e8 01 fb ff ff       	call   8010a6 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
  8015a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015ab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015af:	75 07                	jne    8015b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b6:	eb 05                	jmp    8015bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 2a                	push   $0x2a
  8015d1:	e8 d0 fa ff ff       	call   8010a6 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
  8015d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015dc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015e0:	75 07                	jne    8015e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e7:	eb 05                	jmp    8015ee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 2a                	push   $0x2a
  801602:	e8 9f fa ff ff       	call   8010a6 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80160d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801611:	75 07                	jne    80161a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801613:	b8 01 00 00 00       	mov    $0x1,%eax
  801618:	eb 05                	jmp    80161f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 2a                	push   $0x2a
  801633:	e8 6e fa ff ff       	call   8010a6 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
  80163b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80163e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801642:	75 07                	jne    80164b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801644:	b8 01 00 00 00       	mov    $0x1,%eax
  801649:	eb 05                	jmp    801650 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	6a 2b                	push   $0x2b
  801662:	e8 3f fa ff ff       	call   8010a6 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
	return ;
  80166a:	90                   	nop
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801671:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801674:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	53                   	push   %ebx
  801680:	51                   	push   %ecx
  801681:	52                   	push   %edx
  801682:	50                   	push   %eax
  801683:	6a 2c                	push   $0x2c
  801685:	e8 1c fa ff ff       	call   8010a6 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801695:	8b 55 0c             	mov    0xc(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 2d                	push   $0x2d
  8016a5:	e8 fc f9 ff ff       	call   8010a6 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	51                   	push   %ecx
  8016be:	ff 75 10             	pushl  0x10(%ebp)
  8016c1:	52                   	push   %edx
  8016c2:	50                   	push   %eax
  8016c3:	6a 2e                	push   $0x2e
  8016c5:	e8 dc f9 ff ff       	call   8010a6 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 0f                	push   $0xf
  8016e1:	e8 c0 f9 ff ff       	call   8010a6 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	50                   	push   %eax
  8016fb:	6a 2f                	push   $0x2f
  8016fd:	e8 a4 f9 ff ff       	call   8010a6 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp

}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	6a 30                	push   $0x30
  801718:	e8 89 f9 ff ff       	call   8010a6 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp

}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	6a 31                	push   $0x31
  801734:	e8 6d f9 ff ff       	call   8010a6 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp

}
  80173c:	90                   	nop
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_hard_limit>:
uint32 sys_hard_limit(){
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 32                	push   $0x32
  80174e:	e8 53 f9 ff ff       	call   8010a6 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <__udivdi3>:
  801758:	55                   	push   %ebp
  801759:	57                   	push   %edi
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 1c             	sub    $0x1c,%esp
  80175f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801763:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801767:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80176b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80176f:	89 ca                	mov    %ecx,%edx
  801771:	89 f8                	mov    %edi,%eax
  801773:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801777:	85 f6                	test   %esi,%esi
  801779:	75 2d                	jne    8017a8 <__udivdi3+0x50>
  80177b:	39 cf                	cmp    %ecx,%edi
  80177d:	77 65                	ja     8017e4 <__udivdi3+0x8c>
  80177f:	89 fd                	mov    %edi,%ebp
  801781:	85 ff                	test   %edi,%edi
  801783:	75 0b                	jne    801790 <__udivdi3+0x38>
  801785:	b8 01 00 00 00       	mov    $0x1,%eax
  80178a:	31 d2                	xor    %edx,%edx
  80178c:	f7 f7                	div    %edi
  80178e:	89 c5                	mov    %eax,%ebp
  801790:	31 d2                	xor    %edx,%edx
  801792:	89 c8                	mov    %ecx,%eax
  801794:	f7 f5                	div    %ebp
  801796:	89 c1                	mov    %eax,%ecx
  801798:	89 d8                	mov    %ebx,%eax
  80179a:	f7 f5                	div    %ebp
  80179c:	89 cf                	mov    %ecx,%edi
  80179e:	89 fa                	mov    %edi,%edx
  8017a0:	83 c4 1c             	add    $0x1c,%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5f                   	pop    %edi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    
  8017a8:	39 ce                	cmp    %ecx,%esi
  8017aa:	77 28                	ja     8017d4 <__udivdi3+0x7c>
  8017ac:	0f bd fe             	bsr    %esi,%edi
  8017af:	83 f7 1f             	xor    $0x1f,%edi
  8017b2:	75 40                	jne    8017f4 <__udivdi3+0x9c>
  8017b4:	39 ce                	cmp    %ecx,%esi
  8017b6:	72 0a                	jb     8017c2 <__udivdi3+0x6a>
  8017b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017bc:	0f 87 9e 00 00 00    	ja     801860 <__udivdi3+0x108>
  8017c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c7:	89 fa                	mov    %edi,%edx
  8017c9:	83 c4 1c             	add    $0x1c,%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5f                   	pop    %edi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    
  8017d1:	8d 76 00             	lea    0x0(%esi),%esi
  8017d4:	31 ff                	xor    %edi,%edi
  8017d6:	31 c0                	xor    %eax,%eax
  8017d8:	89 fa                	mov    %edi,%edx
  8017da:	83 c4 1c             	add    $0x1c,%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5f                   	pop    %edi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    
  8017e2:	66 90                	xchg   %ax,%ax
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	f7 f7                	div    %edi
  8017e8:	31 ff                	xor    %edi,%edi
  8017ea:	89 fa                	mov    %edi,%edx
  8017ec:	83 c4 1c             	add    $0x1c,%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5f                   	pop    %edi
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    
  8017f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017f9:	89 eb                	mov    %ebp,%ebx
  8017fb:	29 fb                	sub    %edi,%ebx
  8017fd:	89 f9                	mov    %edi,%ecx
  8017ff:	d3 e6                	shl    %cl,%esi
  801801:	89 c5                	mov    %eax,%ebp
  801803:	88 d9                	mov    %bl,%cl
  801805:	d3 ed                	shr    %cl,%ebp
  801807:	89 e9                	mov    %ebp,%ecx
  801809:	09 f1                	or     %esi,%ecx
  80180b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80180f:	89 f9                	mov    %edi,%ecx
  801811:	d3 e0                	shl    %cl,%eax
  801813:	89 c5                	mov    %eax,%ebp
  801815:	89 d6                	mov    %edx,%esi
  801817:	88 d9                	mov    %bl,%cl
  801819:	d3 ee                	shr    %cl,%esi
  80181b:	89 f9                	mov    %edi,%ecx
  80181d:	d3 e2                	shl    %cl,%edx
  80181f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801823:	88 d9                	mov    %bl,%cl
  801825:	d3 e8                	shr    %cl,%eax
  801827:	09 c2                	or     %eax,%edx
  801829:	89 d0                	mov    %edx,%eax
  80182b:	89 f2                	mov    %esi,%edx
  80182d:	f7 74 24 0c          	divl   0xc(%esp)
  801831:	89 d6                	mov    %edx,%esi
  801833:	89 c3                	mov    %eax,%ebx
  801835:	f7 e5                	mul    %ebp
  801837:	39 d6                	cmp    %edx,%esi
  801839:	72 19                	jb     801854 <__udivdi3+0xfc>
  80183b:	74 0b                	je     801848 <__udivdi3+0xf0>
  80183d:	89 d8                	mov    %ebx,%eax
  80183f:	31 ff                	xor    %edi,%edi
  801841:	e9 58 ff ff ff       	jmp    80179e <__udivdi3+0x46>
  801846:	66 90                	xchg   %ax,%ax
  801848:	8b 54 24 08          	mov    0x8(%esp),%edx
  80184c:	89 f9                	mov    %edi,%ecx
  80184e:	d3 e2                	shl    %cl,%edx
  801850:	39 c2                	cmp    %eax,%edx
  801852:	73 e9                	jae    80183d <__udivdi3+0xe5>
  801854:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801857:	31 ff                	xor    %edi,%edi
  801859:	e9 40 ff ff ff       	jmp    80179e <__udivdi3+0x46>
  80185e:	66 90                	xchg   %ax,%ax
  801860:	31 c0                	xor    %eax,%eax
  801862:	e9 37 ff ff ff       	jmp    80179e <__udivdi3+0x46>
  801867:	90                   	nop

00801868 <__umoddi3>:
  801868:	55                   	push   %ebp
  801869:	57                   	push   %edi
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
  80186c:	83 ec 1c             	sub    $0x1c,%esp
  80186f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801873:	8b 74 24 34          	mov    0x34(%esp),%esi
  801877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80187b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80187f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801883:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801887:	89 f3                	mov    %esi,%ebx
  801889:	89 fa                	mov    %edi,%edx
  80188b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80188f:	89 34 24             	mov    %esi,(%esp)
  801892:	85 c0                	test   %eax,%eax
  801894:	75 1a                	jne    8018b0 <__umoddi3+0x48>
  801896:	39 f7                	cmp    %esi,%edi
  801898:	0f 86 a2 00 00 00    	jbe    801940 <__umoddi3+0xd8>
  80189e:	89 c8                	mov    %ecx,%eax
  8018a0:	89 f2                	mov    %esi,%edx
  8018a2:	f7 f7                	div    %edi
  8018a4:	89 d0                	mov    %edx,%eax
  8018a6:	31 d2                	xor    %edx,%edx
  8018a8:	83 c4 1c             	add    $0x1c,%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5f                   	pop    %edi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
  8018b0:	39 f0                	cmp    %esi,%eax
  8018b2:	0f 87 ac 00 00 00    	ja     801964 <__umoddi3+0xfc>
  8018b8:	0f bd e8             	bsr    %eax,%ebp
  8018bb:	83 f5 1f             	xor    $0x1f,%ebp
  8018be:	0f 84 ac 00 00 00    	je     801970 <__umoddi3+0x108>
  8018c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8018c9:	29 ef                	sub    %ebp,%edi
  8018cb:	89 fe                	mov    %edi,%esi
  8018cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018d1:	89 e9                	mov    %ebp,%ecx
  8018d3:	d3 e0                	shl    %cl,%eax
  8018d5:	89 d7                	mov    %edx,%edi
  8018d7:	89 f1                	mov    %esi,%ecx
  8018d9:	d3 ef                	shr    %cl,%edi
  8018db:	09 c7                	or     %eax,%edi
  8018dd:	89 e9                	mov    %ebp,%ecx
  8018df:	d3 e2                	shl    %cl,%edx
  8018e1:	89 14 24             	mov    %edx,(%esp)
  8018e4:	89 d8                	mov    %ebx,%eax
  8018e6:	d3 e0                	shl    %cl,%eax
  8018e8:	89 c2                	mov    %eax,%edx
  8018ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ee:	d3 e0                	shl    %cl,%eax
  8018f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f8:	89 f1                	mov    %esi,%ecx
  8018fa:	d3 e8                	shr    %cl,%eax
  8018fc:	09 d0                	or     %edx,%eax
  8018fe:	d3 eb                	shr    %cl,%ebx
  801900:	89 da                	mov    %ebx,%edx
  801902:	f7 f7                	div    %edi
  801904:	89 d3                	mov    %edx,%ebx
  801906:	f7 24 24             	mull   (%esp)
  801909:	89 c6                	mov    %eax,%esi
  80190b:	89 d1                	mov    %edx,%ecx
  80190d:	39 d3                	cmp    %edx,%ebx
  80190f:	0f 82 87 00 00 00    	jb     80199c <__umoddi3+0x134>
  801915:	0f 84 91 00 00 00    	je     8019ac <__umoddi3+0x144>
  80191b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80191f:	29 f2                	sub    %esi,%edx
  801921:	19 cb                	sbb    %ecx,%ebx
  801923:	89 d8                	mov    %ebx,%eax
  801925:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801929:	d3 e0                	shl    %cl,%eax
  80192b:	89 e9                	mov    %ebp,%ecx
  80192d:	d3 ea                	shr    %cl,%edx
  80192f:	09 d0                	or     %edx,%eax
  801931:	89 e9                	mov    %ebp,%ecx
  801933:	d3 eb                	shr    %cl,%ebx
  801935:	89 da                	mov    %ebx,%edx
  801937:	83 c4 1c             	add    $0x1c,%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5f                   	pop    %edi
  80193d:	5d                   	pop    %ebp
  80193e:	c3                   	ret    
  80193f:	90                   	nop
  801940:	89 fd                	mov    %edi,%ebp
  801942:	85 ff                	test   %edi,%edi
  801944:	75 0b                	jne    801951 <__umoddi3+0xe9>
  801946:	b8 01 00 00 00       	mov    $0x1,%eax
  80194b:	31 d2                	xor    %edx,%edx
  80194d:	f7 f7                	div    %edi
  80194f:	89 c5                	mov    %eax,%ebp
  801951:	89 f0                	mov    %esi,%eax
  801953:	31 d2                	xor    %edx,%edx
  801955:	f7 f5                	div    %ebp
  801957:	89 c8                	mov    %ecx,%eax
  801959:	f7 f5                	div    %ebp
  80195b:	89 d0                	mov    %edx,%eax
  80195d:	e9 44 ff ff ff       	jmp    8018a6 <__umoddi3+0x3e>
  801962:	66 90                	xchg   %ax,%ax
  801964:	89 c8                	mov    %ecx,%eax
  801966:	89 f2                	mov    %esi,%edx
  801968:	83 c4 1c             	add    $0x1c,%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
  801970:	3b 04 24             	cmp    (%esp),%eax
  801973:	72 06                	jb     80197b <__umoddi3+0x113>
  801975:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801979:	77 0f                	ja     80198a <__umoddi3+0x122>
  80197b:	89 f2                	mov    %esi,%edx
  80197d:	29 f9                	sub    %edi,%ecx
  80197f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801983:	89 14 24             	mov    %edx,(%esp)
  801986:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80198a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80198e:	8b 14 24             	mov    (%esp),%edx
  801991:	83 c4 1c             	add    $0x1c,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    
  801999:	8d 76 00             	lea    0x0(%esi),%esi
  80199c:	2b 04 24             	sub    (%esp),%eax
  80199f:	19 fa                	sbb    %edi,%edx
  8019a1:	89 d1                	mov    %edx,%ecx
  8019a3:	89 c6                	mov    %eax,%esi
  8019a5:	e9 71 ff ff ff       	jmp    80191b <__umoddi3+0xb3>
  8019aa:	66 90                	xchg   %ax,%ax
  8019ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019b0:	72 ea                	jb     80199c <__umoddi3+0x134>
  8019b2:	89 d9                	mov    %ebx,%ecx
  8019b4:	e9 62 ff ff ff       	jmp    80191b <__umoddi3+0xb3>
