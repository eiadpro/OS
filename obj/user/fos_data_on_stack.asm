
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 80 19 80 00       	push   $0x801980
  800049:	e8 3e 02 00 00       	call   80028c <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 7c 13 00 00       	call   8013db <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 03             	shl    $0x3,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	01 c0                	add    %eax,%eax
  80006e:	01 d0                	add    %edx,%eax
  800070:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800077:	01 d0                	add    %edx,%eax
  800079:	c1 e0 04             	shl    $0x4,%eax
  80007c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800081:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800086:	a1 20 20 80 00       	mov    0x802020,%eax
  80008b:	8a 40 5c             	mov    0x5c(%eax),%al
  80008e:	84 c0                	test   %al,%al
  800090:	74 0d                	je     80009f <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800092:	a1 20 20 80 00       	mov    0x802020,%eax
  800097:	83 c0 5c             	add    $0x5c,%eax
  80009a:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a3:	7e 0a                	jle    8000af <libmain+0x5b>
		binaryname = argv[0];
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	ff 75 0c             	pushl  0xc(%ebp)
  8000b5:	ff 75 08             	pushl  0x8(%ebp)
  8000b8:	e8 7b ff ff ff       	call   800038 <_main>
  8000bd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000c0:	e8 23 11 00 00       	call   8011e8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 bc 19 80 00       	push   $0x8019bc
  8000cd:	e8 8d 01 00 00       	call   80025f <cprintf>
  8000d2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000d5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000da:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000e0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	52                   	push   %edx
  8000ef:	50                   	push   %eax
  8000f0:	68 e4 19 80 00       	push   $0x8019e4
  8000f5:	e8 65 01 00 00       	call   80025f <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000fd:	a1 20 20 80 00       	mov    0x802020,%eax
  800102:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800108:	a1 20 20 80 00       	mov    0x802020,%eax
  80010d:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800113:	a1 20 20 80 00       	mov    0x802020,%eax
  800118:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80011e:	51                   	push   %ecx
  80011f:	52                   	push   %edx
  800120:	50                   	push   %eax
  800121:	68 0c 1a 80 00       	push   $0x801a0c
  800126:	e8 34 01 00 00       	call   80025f <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80012e:	a1 20 20 80 00       	mov    0x802020,%eax
  800133:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	50                   	push   %eax
  80013d:	68 64 1a 80 00       	push   $0x801a64
  800142:	e8 18 01 00 00       	call   80025f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 bc 19 80 00       	push   $0x8019bc
  800152:	e8 08 01 00 00       	call   80025f <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80015a:	e8 a3 10 00 00       	call   801202 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80015f:	e8 19 00 00 00       	call   80017d <exit>
}
  800164:	90                   	nop
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	6a 00                	push   $0x0
  800172:	e8 30 12 00 00       	call   8013a7 <sys_destroy_env>
  800177:	83 c4 10             	add    $0x10,%esp
}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <exit>:

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800183:	e8 85 12 00 00       	call   80140d <sys_exit_env>
}
  800188:	90                   	nop
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	8d 48 01             	lea    0x1(%eax),%ecx
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 0a                	mov    %ecx,(%edx)
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	88 d1                	mov    %dl,%cl
  8001a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 2c                	jne    8001e2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001b6:	a0 24 20 80 00       	mov    0x802024,%al
  8001bb:	0f b6 c0             	movzbl %al,%eax
  8001be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c1:	8b 12                	mov    (%edx),%edx
  8001c3:	89 d1                	mov    %edx,%ecx
  8001c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c8:	83 c2 08             	add    $0x8,%edx
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	50                   	push   %eax
  8001cf:	51                   	push   %ecx
  8001d0:	52                   	push   %edx
  8001d1:	e8 b9 0e 00 00       	call   80108f <sys_cputs>
  8001d6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	8b 40 04             	mov    0x4(%eax),%eax
  8001e8:	8d 50 01             	lea    0x1(%eax),%edx
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800204:	00 00 00 
	b.cnt = 0;
  800207:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800211:	ff 75 0c             	pushl  0xc(%ebp)
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	68 8b 01 80 00       	push   $0x80018b
  800223:	e8 11 02 00 00       	call   800439 <vprintfmt>
  800228:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80022b:	a0 24 20 80 00       	mov    0x802024,%al
  800230:	0f b6 c0             	movzbl %al,%eax
  800233:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	50                   	push   %eax
  80023d:	52                   	push   %edx
  80023e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800244:	83 c0 08             	add    $0x8,%eax
  800247:	50                   	push   %eax
  800248:	e8 42 0e 00 00       	call   80108f <sys_cputs>
  80024d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800250:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800257:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <cprintf>:

int cprintf(const char *fmt, ...) {
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800265:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80026c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80026f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	ff 75 f4             	pushl  -0xc(%ebp)
  80027b:	50                   	push   %eax
  80027c:	e8 73 ff ff ff       	call   8001f4 <vcprintf>
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800287:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800292:	e8 51 0f 00 00       	call   8011e8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800297:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a6:	50                   	push   %eax
  8002a7:	e8 48 ff ff ff       	call   8001f4 <vcprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002b2:	e8 4b 0f 00 00       	call   801202 <sys_enable_interrupt>
	return cnt;
  8002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 14             	sub    $0x14,%esp
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002da:	77 55                	ja     800331 <printnum+0x75>
  8002dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002df:	72 05                	jb     8002e6 <printnum+0x2a>
  8002e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e4:	77 4b                	ja     800331 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f4:	52                   	push   %edx
  8002f5:	50                   	push   %eax
  8002f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8002fc:	e8 17 14 00 00       	call   801718 <__udivdi3>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 20             	pushl  0x20(%ebp)
  80030a:	53                   	push   %ebx
  80030b:	ff 75 18             	pushl  0x18(%ebp)
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 a1 ff ff ff       	call   8002bc <printnum>
  80031b:	83 c4 20             	add    $0x20,%esp
  80031e:	eb 1a                	jmp    80033a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 20             	pushl  0x20(%ebp)
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	ff d0                	call   *%eax
  80032e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800331:	ff 4d 1c             	decl   0x1c(%ebp)
  800334:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800338:	7f e6                	jg     800320 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800348:	53                   	push   %ebx
  800349:	51                   	push   %ecx
  80034a:	52                   	push   %edx
  80034b:	50                   	push   %eax
  80034c:	e8 d7 14 00 00       	call   801828 <__umoddi3>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	05 94 1c 80 00       	add    $0x801c94,%eax
  800359:	8a 00                	mov    (%eax),%al
  80035b:	0f be c0             	movsbl %al,%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	ff d0                	call   *%eax
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800376:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037a:	7e 1c                	jle    800398 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	8d 50 08             	lea    0x8(%eax),%edx
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	89 10                	mov    %edx,(%eax)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	83 e8 08             	sub    $0x8,%eax
  800391:	8b 50 04             	mov    0x4(%eax),%edx
  800394:	8b 00                	mov    (%eax),%eax
  800396:	eb 40                	jmp    8003d8 <getuint+0x65>
	else if (lflag)
  800398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80039c:	74 1e                	je     8003bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	8d 50 04             	lea    0x4(%eax),%edx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	89 10                	mov    %edx,(%eax)
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	83 e8 04             	sub    $0x4,%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ba:	eb 1c                	jmp    8003d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	8d 50 04             	lea    0x4(%eax),%edx
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	89 10                	mov    %edx,(%eax)
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 e8 04             	sub    $0x4,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e1:	7e 1c                	jle    8003ff <getint+0x25>
		return va_arg(*ap, long long);
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	8d 50 08             	lea    0x8(%eax),%edx
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	83 e8 08             	sub    $0x8,%eax
  8003f8:	8b 50 04             	mov    0x4(%eax),%edx
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	eb 38                	jmp    800437 <getint+0x5d>
	else if (lflag)
  8003ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800403:	74 1a                	je     80041f <getint+0x45>
		return va_arg(*ap, long);
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	8d 50 04             	lea    0x4(%eax),%edx
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	89 10                	mov    %edx,(%eax)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	83 e8 04             	sub    $0x4,%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	99                   	cltd   
  80041d:	eb 18                	jmp    800437 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 10                	mov    %edx,(%eax)
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	83 e8 04             	sub    $0x4,%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
}
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	56                   	push   %esi
  80043d:	53                   	push   %ebx
  80043e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800441:	eb 17                	jmp    80045a <vprintfmt+0x21>
			if (ch == '\0')
  800443:	85 db                	test   %ebx,%ebx
  800445:	0f 84 af 03 00 00    	je     8007fa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	53                   	push   %ebx
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	ff d0                	call   *%eax
  800457:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8d 50 01             	lea    0x1(%eax),%edx
  800460:	89 55 10             	mov    %edx,0x10(%ebp)
  800463:	8a 00                	mov    (%eax),%al
  800465:	0f b6 d8             	movzbl %al,%ebx
  800468:	83 fb 25             	cmp    $0x25,%ebx
  80046b:	75 d6                	jne    800443 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80046d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800471:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800478:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80047f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800486:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 45 10             	mov    0x10(%ebp),%eax
  800490:	8d 50 01             	lea    0x1(%eax),%edx
  800493:	89 55 10             	mov    %edx,0x10(%ebp)
  800496:	8a 00                	mov    (%eax),%al
  800498:	0f b6 d8             	movzbl %al,%ebx
  80049b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80049e:	83 f8 55             	cmp    $0x55,%eax
  8004a1:	0f 87 2b 03 00 00    	ja     8007d2 <vprintfmt+0x399>
  8004a7:	8b 04 85 b8 1c 80 00 	mov    0x801cb8(,%eax,4),%eax
  8004ae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b4:	eb d7                	jmp    80048d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004ba:	eb d1                	jmp    80048d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c6:	89 d0                	mov    %edx,%eax
  8004c8:	c1 e0 02             	shl    $0x2,%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	01 c0                	add    %eax,%eax
  8004cf:	01 d8                	add    %ebx,%eax
  8004d1:	83 e8 30             	sub    $0x30,%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	8a 00                	mov    (%eax),%al
  8004dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004df:	83 fb 2f             	cmp    $0x2f,%ebx
  8004e2:	7e 3e                	jle    800522 <vprintfmt+0xe9>
  8004e4:	83 fb 39             	cmp    $0x39,%ebx
  8004e7:	7f 39                	jg     800522 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ec:	eb d5                	jmp    8004c3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	83 c0 04             	add    $0x4,%eax
  8004f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	83 e8 04             	sub    $0x4,%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800502:	eb 1f                	jmp    800523 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800508:	79 83                	jns    80048d <vprintfmt+0x54>
				width = 0;
  80050a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800511:	e9 77 ff ff ff       	jmp    80048d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800516:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051d:	e9 6b ff ff ff       	jmp    80048d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800522:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800523:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800527:	0f 89 60 ff ff ff    	jns    80048d <vprintfmt+0x54>
				width = precision, precision = -1;
  80052d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800533:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80053a:	e9 4e ff ff ff       	jmp    80048d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800542:	e9 46 ff ff ff       	jmp    80048d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 c0 04             	add    $0x4,%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	83 e8 04             	sub    $0x4,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	ff 75 0c             	pushl  0xc(%ebp)
  80055e:	50                   	push   %eax
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	ff d0                	call   *%eax
  800564:	83 c4 10             	add    $0x10,%esp
			break;
  800567:	e9 89 02 00 00       	jmp    8007f5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 c0 04             	add    $0x4,%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 e8 04             	sub    $0x4,%eax
  80057b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80057d:	85 db                	test   %ebx,%ebx
  80057f:	79 02                	jns    800583 <vprintfmt+0x14a>
				err = -err;
  800581:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800583:	83 fb 64             	cmp    $0x64,%ebx
  800586:	7f 0b                	jg     800593 <vprintfmt+0x15a>
  800588:	8b 34 9d 00 1b 80 00 	mov    0x801b00(,%ebx,4),%esi
  80058f:	85 f6                	test   %esi,%esi
  800591:	75 19                	jne    8005ac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800593:	53                   	push   %ebx
  800594:	68 a5 1c 80 00       	push   $0x801ca5
  800599:	ff 75 0c             	pushl  0xc(%ebp)
  80059c:	ff 75 08             	pushl  0x8(%ebp)
  80059f:	e8 5e 02 00 00       	call   800802 <printfmt>
  8005a4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005a7:	e9 49 02 00 00       	jmp    8007f5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ac:	56                   	push   %esi
  8005ad:	68 ae 1c 80 00       	push   $0x801cae
  8005b2:	ff 75 0c             	pushl  0xc(%ebp)
  8005b5:	ff 75 08             	pushl  0x8(%ebp)
  8005b8:	e8 45 02 00 00       	call   800802 <printfmt>
  8005bd:	83 c4 10             	add    $0x10,%esp
			break;
  8005c0:	e9 30 02 00 00       	jmp    8007f5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 c0 04             	add    $0x4,%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	83 e8 04             	sub    $0x4,%eax
  8005d4:	8b 30                	mov    (%eax),%esi
  8005d6:	85 f6                	test   %esi,%esi
  8005d8:	75 05                	jne    8005df <vprintfmt+0x1a6>
				p = "(null)";
  8005da:	be b1 1c 80 00       	mov    $0x801cb1,%esi
			if (width > 0 && padc != '-')
  8005df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e3:	7e 6d                	jle    800652 <vprintfmt+0x219>
  8005e5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e9:	74 67                	je     800652 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	50                   	push   %eax
  8005f2:	56                   	push   %esi
  8005f3:	e8 0c 03 00 00       	call   800904 <strnlen>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005fe:	eb 16                	jmp    800616 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800600:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	50                   	push   %eax
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	ff d0                	call   *%eax
  800610:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	ff 4d e4             	decl   -0x1c(%ebp)
  800616:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061a:	7f e4                	jg     800600 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061c:	eb 34                	jmp    800652 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80061e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800622:	74 1c                	je     800640 <vprintfmt+0x207>
  800624:	83 fb 1f             	cmp    $0x1f,%ebx
  800627:	7e 05                	jle    80062e <vprintfmt+0x1f5>
  800629:	83 fb 7e             	cmp    $0x7e,%ebx
  80062c:	7e 12                	jle    800640 <vprintfmt+0x207>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	ff d0                	call   *%eax
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	eb 0f                	jmp    80064f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	53                   	push   %ebx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	ff d0                	call   *%eax
  80064c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064f:	ff 4d e4             	decl   -0x1c(%ebp)
  800652:	89 f0                	mov    %esi,%eax
  800654:	8d 70 01             	lea    0x1(%eax),%esi
  800657:	8a 00                	mov    (%eax),%al
  800659:	0f be d8             	movsbl %al,%ebx
  80065c:	85 db                	test   %ebx,%ebx
  80065e:	74 24                	je     800684 <vprintfmt+0x24b>
  800660:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800664:	78 b8                	js     80061e <vprintfmt+0x1e5>
  800666:	ff 4d e0             	decl   -0x20(%ebp)
  800669:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066d:	79 af                	jns    80061e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066f:	eb 13                	jmp    800684 <vprintfmt+0x24b>
				putch(' ', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	6a 20                	push   $0x20
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800681:	ff 4d e4             	decl   -0x1c(%ebp)
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	7f e7                	jg     800671 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80068a:	e9 66 01 00 00       	jmp    8007f5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 e8             	pushl  -0x18(%ebp)
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	50                   	push   %eax
  800699:	e8 3c fd ff ff       	call   8003da <getint>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ad:	85 d2                	test   %edx,%edx
  8006af:	79 23                	jns    8006d4 <vprintfmt+0x29b>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	6a 2d                	push   $0x2d
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c7:	f7 d8                	neg    %eax
  8006c9:	83 d2 00             	adc    $0x0,%edx
  8006cc:	f7 da                	neg    %edx
  8006ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006db:	e9 bc 00 00 00       	jmp    80079c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	e8 84 fc ff ff       	call   800373 <getuint>
  8006ef:	83 c4 10             	add    $0x10,%esp
  8006f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006ff:	e9 98 00 00 00       	jmp    80079c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 58                	push   $0x58
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 58                	push   $0x58
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	6a 58                	push   $0x58
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
			break;
  800734:	e9 bc 00 00 00       	jmp    8007f5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 30                	push   $0x30
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	6a 78                	push   $0x78
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800774:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80077b:	eb 1f                	jmp    80079c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 e8             	pushl  -0x18(%ebp)
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	e8 e7 fb ff ff       	call   800373 <getuint>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800792:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800795:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80079c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	83 ec 04             	sub    $0x4,%esp
  8007a6:	52                   	push   %edx
  8007a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 00 fb ff ff       	call   8002bc <printnum>
  8007bc:	83 c4 20             	add    $0x20,%esp
			break;
  8007bf:	eb 34                	jmp    8007f5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			break;
  8007d0:	eb 23                	jmp    8007f5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 25                	push   $0x25
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e2:	ff 4d 10             	decl   0x10(%ebp)
  8007e5:	eb 03                	jmp    8007ea <vprintfmt+0x3b1>
  8007e7:	ff 4d 10             	decl   0x10(%ebp)
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	48                   	dec    %eax
  8007ee:	8a 00                	mov    (%eax),%al
  8007f0:	3c 25                	cmp    $0x25,%al
  8007f2:	75 f3                	jne    8007e7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007f4:	90                   	nop
		}
	}
  8007f5:	e9 47 fc ff ff       	jmp    800441 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007fa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007fe:	5b                   	pop    %ebx
  8007ff:	5e                   	pop    %esi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800808:	8d 45 10             	lea    0x10(%ebp),%eax
  80080b:	83 c0 04             	add    $0x4,%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	50                   	push   %eax
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	ff 75 08             	pushl  0x8(%ebp)
  80081e:	e8 16 fc ff ff       	call   800439 <vprintfmt>
  800823:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800826:	90                   	nop
  800827:	c9                   	leave  
  800828:	c3                   	ret    

00800829 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	8b 40 08             	mov    0x8(%eax),%eax
  800832:	8d 50 01             	lea    0x1(%eax),%edx
  800835:	8b 45 0c             	mov    0xc(%ebp),%eax
  800838:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083e:	8b 10                	mov    (%eax),%edx
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	8b 40 04             	mov    0x4(%eax),%eax
  800846:	39 c2                	cmp    %eax,%edx
  800848:	73 12                	jae    80085c <sprintputch+0x33>
		*b->buf++ = ch;
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	8d 48 01             	lea    0x1(%eax),%ecx
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
  800855:	89 0a                	mov    %ecx,(%edx)
  800857:	8b 55 08             	mov    0x8(%ebp),%edx
  80085a:	88 10                	mov    %dl,(%eax)
}
  80085c:	90                   	nop
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	01 d0                	add    %edx,%eax
  800876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800880:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800884:	74 06                	je     80088c <vsnprintf+0x2d>
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	7f 07                	jg     800893 <vsnprintf+0x34>
		return -E_INVAL;
  80088c:	b8 03 00 00 00       	mov    $0x3,%eax
  800891:	eb 20                	jmp    8008b3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800893:	ff 75 14             	pushl  0x14(%ebp)
  800896:	ff 75 10             	pushl  0x10(%ebp)
  800899:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089c:	50                   	push   %eax
  80089d:	68 29 08 80 00       	push   $0x800829
  8008a2:	e8 92 fb ff ff       	call   800439 <vprintfmt>
  8008a7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 89 ff ff ff       	call   80085f <vsnprintf>
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008ee:	eb 06                	jmp    8008f6 <strlen+0x15>
		n++;
  8008f0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	ff 45 08             	incl   0x8(%ebp)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8a 00                	mov    (%eax),%al
  8008fb:	84 c0                	test   %al,%al
  8008fd:	75 f1                	jne    8008f0 <strlen+0xf>
		n++;
	return n;
  8008ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800911:	eb 09                	jmp    80091c <strnlen+0x18>
		n++;
  800913:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800916:	ff 45 08             	incl   0x8(%ebp)
  800919:	ff 4d 0c             	decl   0xc(%ebp)
  80091c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800920:	74 09                	je     80092b <strnlen+0x27>
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8a 00                	mov    (%eax),%al
  800927:	84 c0                	test   %al,%al
  800929:	75 e8                	jne    800913 <strnlen+0xf>
		n++;
	return n;
  80092b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80093c:	90                   	nop
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8d 50 01             	lea    0x1(%eax),%edx
  800943:	89 55 08             	mov    %edx,0x8(%ebp)
  800946:	8b 55 0c             	mov    0xc(%ebp),%edx
  800949:	8d 4a 01             	lea    0x1(%edx),%ecx
  80094c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80094f:	8a 12                	mov    (%edx),%dl
  800951:	88 10                	mov    %dl,(%eax)
  800953:	8a 00                	mov    (%eax),%al
  800955:	84 c0                	test   %al,%al
  800957:	75 e4                	jne    80093d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800959:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80096a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800971:	eb 1f                	jmp    800992 <strncpy+0x34>
		*dst++ = *src;
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8d 50 01             	lea    0x1(%eax),%edx
  800979:	89 55 08             	mov    %edx,0x8(%ebp)
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	8a 12                	mov    (%edx),%dl
  800981:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8a 00                	mov    (%eax),%al
  800988:	84 c0                	test   %al,%al
  80098a:	74 03                	je     80098f <strncpy+0x31>
			src++;
  80098c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098f:	ff 45 fc             	incl   -0x4(%ebp)
  800992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800995:	3b 45 10             	cmp    0x10(%ebp),%eax
  800998:	72 d9                	jb     800973 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80099a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009af:	74 30                	je     8009e1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009b1:	eb 16                	jmp    8009c9 <strlcpy+0x2a>
			*dst++ = *src++;
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8d 50 01             	lea    0x1(%eax),%edx
  8009b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c5:	8a 12                	mov    (%edx),%dl
  8009c7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c9:	ff 4d 10             	decl   0x10(%ebp)
  8009cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d0:	74 09                	je     8009db <strlcpy+0x3c>
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8a 00                	mov    (%eax),%al
  8009d7:	84 c0                	test   %al,%al
  8009d9:	75 d8                	jne    8009b3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e7:	29 c2                	sub    %eax,%edx
  8009e9:	89 d0                	mov    %edx,%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009f0:	eb 06                	jmp    8009f8 <strcmp+0xb>
		p++, q++;
  8009f2:	ff 45 08             	incl   0x8(%ebp)
  8009f5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8a 00                	mov    (%eax),%al
  8009fd:	84 c0                	test   %al,%al
  8009ff:	74 0e                	je     800a0f <strcmp+0x22>
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8a 10                	mov    (%eax),%dl
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	38 c2                	cmp    %al,%dl
  800a0d:	74 e3                	je     8009f2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8a 00                	mov    (%eax),%al
  800a14:	0f b6 d0             	movzbl %al,%edx
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f b6 c0             	movzbl %al,%eax
  800a1f:	29 c2                	sub    %eax,%edx
  800a21:	89 d0                	mov    %edx,%eax
}
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a28:	eb 09                	jmp    800a33 <strncmp+0xe>
		n--, p++, q++;
  800a2a:	ff 4d 10             	decl   0x10(%ebp)
  800a2d:	ff 45 08             	incl   0x8(%ebp)
  800a30:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a37:	74 17                	je     800a50 <strncmp+0x2b>
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	74 0e                	je     800a50 <strncmp+0x2b>
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8a 10                	mov    (%eax),%dl
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	38 c2                	cmp    %al,%dl
  800a4e:	74 da                	je     800a2a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a54:	75 07                	jne    800a5d <strncmp+0x38>
		return 0;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	eb 14                	jmp    800a71 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	0f b6 d0             	movzbl %al,%edx
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	0f b6 c0             	movzbl %al,%eax
  800a6d:	29 c2                	sub    %eax,%edx
  800a6f:	89 d0                	mov    %edx,%eax
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a7f:	eb 12                	jmp    800a93 <strchr+0x20>
		if (*s == c)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a89:	75 05                	jne    800a90 <strchr+0x1d>
			return (char *) s;
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	eb 11                	jmp    800aa1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a90:	ff 45 08             	incl   0x8(%ebp)
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	84 c0                	test   %al,%al
  800a9a:	75 e5                	jne    800a81 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa1:	c9                   	leave  
  800aa2:	c3                   	ret    

00800aa3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 04             	sub    $0x4,%esp
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aaf:	eb 0d                	jmp    800abe <strfind+0x1b>
		if (*s == c)
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab9:	74 0e                	je     800ac9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800abb:	ff 45 08             	incl   0x8(%ebp)
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	84 c0                	test   %al,%al
  800ac5:	75 ea                	jne    800ab1 <strfind+0xe>
  800ac7:	eb 01                	jmp    800aca <strfind+0x27>
		if (*s == c)
			break;
  800ac9:	90                   	nop
	return (char *) s;
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ae1:	eb 0e                	jmp    800af1 <memset+0x22>
		*p++ = c;
  800ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae6:	8d 50 01             	lea    0x1(%eax),%edx
  800ae9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aef:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800af1:	ff 4d f8             	decl   -0x8(%ebp)
  800af4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800af8:	79 e9                	jns    800ae3 <memset+0x14>
		*p++ = c;

	return v;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b11:	eb 16                	jmp    800b29 <memcpy+0x2a>
		*d++ = *s++;
  800b13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b16:	8d 50 01             	lea    0x1(%eax),%edx
  800b19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b22:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b25:	8a 12                	mov    (%edx),%dl
  800b27:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b29:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b32:	85 c0                	test   %eax,%eax
  800b34:	75 dd                	jne    800b13 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b53:	73 50                	jae    800ba5 <memmove+0x6a>
  800b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b58:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5b:	01 d0                	add    %edx,%eax
  800b5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b60:	76 43                	jbe    800ba5 <memmove+0x6a>
		s += n;
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b68:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b6e:	eb 10                	jmp    800b80 <memmove+0x45>
			*--d = *--s;
  800b70:	ff 4d f8             	decl   -0x8(%ebp)
  800b73:	ff 4d fc             	decl   -0x4(%ebp)
  800b76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b79:	8a 10                	mov    (%eax),%dl
  800b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b7e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b86:	89 55 10             	mov    %edx,0x10(%ebp)
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	75 e3                	jne    800b70 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8d:	eb 23                	jmp    800bb2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b92:	8d 50 01             	lea    0x1(%eax),%edx
  800b95:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b9e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba1:	8a 12                	mov    (%edx),%dl
  800ba3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bab:	89 55 10             	mov    %edx,0x10(%ebp)
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	75 dd                	jne    800b8f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bc9:	eb 2a                	jmp    800bf5 <memcmp+0x3e>
		if (*s1 != *s2)
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bce:	8a 10                	mov    (%eax),%dl
  800bd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	38 c2                	cmp    %al,%dl
  800bd7:	74 16                	je     800bef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	0f b6 d0             	movzbl %al,%edx
  800be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be4:	8a 00                	mov    (%eax),%al
  800be6:	0f b6 c0             	movzbl %al,%eax
  800be9:	29 c2                	sub    %eax,%edx
  800beb:	89 d0                	mov    %edx,%eax
  800bed:	eb 18                	jmp    800c07 <memcmp+0x50>
		s1++, s2++;
  800bef:	ff 45 fc             	incl   -0x4(%ebp)
  800bf2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	75 c9                	jne    800bcb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	01 d0                	add    %edx,%eax
  800c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c1a:	eb 15                	jmp    800c31 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	0f b6 d0             	movzbl %al,%edx
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	39 c2                	cmp    %eax,%edx
  800c2c:	74 0d                	je     800c3b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c2e:	ff 45 08             	incl   0x8(%ebp)
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c37:	72 e3                	jb     800c1c <memfind+0x13>
  800c39:	eb 01                	jmp    800c3c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c3b:	90                   	nop
	return (void *) s;
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c55:	eb 03                	jmp    800c5a <strtol+0x19>
		s++;
  800c57:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	3c 20                	cmp    $0x20,%al
  800c61:	74 f4                	je     800c57 <strtol+0x16>
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	3c 09                	cmp    $0x9,%al
  800c6a:	74 eb                	je     800c57 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	3c 2b                	cmp    $0x2b,%al
  800c73:	75 05                	jne    800c7a <strtol+0x39>
		s++;
  800c75:	ff 45 08             	incl   0x8(%ebp)
  800c78:	eb 13                	jmp    800c8d <strtol+0x4c>
	else if (*s == '-')
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	3c 2d                	cmp    $0x2d,%al
  800c81:	75 0a                	jne    800c8d <strtol+0x4c>
		s++, neg = 1;
  800c83:	ff 45 08             	incl   0x8(%ebp)
  800c86:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c91:	74 06                	je     800c99 <strtol+0x58>
  800c93:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c97:	75 20                	jne    800cb9 <strtol+0x78>
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	3c 30                	cmp    $0x30,%al
  800ca0:	75 17                	jne    800cb9 <strtol+0x78>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	40                   	inc    %eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	3c 78                	cmp    $0x78,%al
  800caa:	75 0d                	jne    800cb9 <strtol+0x78>
		s += 2, base = 16;
  800cac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cb0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cb7:	eb 28                	jmp    800ce1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbd:	75 15                	jne    800cd4 <strtol+0x93>
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	3c 30                	cmp    $0x30,%al
  800cc6:	75 0c                	jne    800cd4 <strtol+0x93>
		s++, base = 8;
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cd2:	eb 0d                	jmp    800ce1 <strtol+0xa0>
	else if (base == 0)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	75 07                	jne    800ce1 <strtol+0xa0>
		base = 10;
  800cda:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	3c 2f                	cmp    $0x2f,%al
  800ce8:	7e 19                	jle    800d03 <strtol+0xc2>
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	3c 39                	cmp    $0x39,%al
  800cf1:	7f 10                	jg     800d03 <strtol+0xc2>
			dig = *s - '0';
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f be c0             	movsbl %al,%eax
  800cfb:	83 e8 30             	sub    $0x30,%eax
  800cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d01:	eb 42                	jmp    800d45 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 60                	cmp    $0x60,%al
  800d0a:	7e 19                	jle    800d25 <strtol+0xe4>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	3c 7a                	cmp    $0x7a,%al
  800d13:	7f 10                	jg     800d25 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f be c0             	movsbl %al,%eax
  800d1d:	83 e8 57             	sub    $0x57,%eax
  800d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d23:	eb 20                	jmp    800d45 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 40                	cmp    $0x40,%al
  800d2c:	7e 39                	jle    800d67 <strtol+0x126>
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3c 5a                	cmp    $0x5a,%al
  800d35:	7f 30                	jg     800d67 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	0f be c0             	movsbl %al,%eax
  800d3f:	83 e8 37             	sub    $0x37,%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d48:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4b:	7d 19                	jge    800d66 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d4d:	ff 45 08             	incl   0x8(%ebp)
  800d50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d53:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d57:	89 c2                	mov    %eax,%edx
  800d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5c:	01 d0                	add    %edx,%eax
  800d5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d61:	e9 7b ff ff ff       	jmp    800ce1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d66:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6b:	74 08                	je     800d75 <strtol+0x134>
		*endptr = (char *) s;
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d75:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d79:	74 07                	je     800d82 <strtol+0x141>
  800d7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7e:	f7 d8                	neg    %eax
  800d80:	eb 03                	jmp    800d85 <strtol+0x144>
  800d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <ltostr>:

void
ltostr(long value, char *str)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9f:	79 13                	jns    800db4 <ltostr+0x2d>
	{
		neg = 1;
  800da1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800db1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dbc:	99                   	cltd   
  800dbd:	f7 f9                	idiv   %ecx
  800dbf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc5:	8d 50 01             	lea    0x1(%eax),%edx
  800dc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcb:	89 c2                	mov    %eax,%edx
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	01 d0                	add    %edx,%eax
  800dd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dd5:	83 c2 30             	add    $0x30,%edx
  800dd8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800de2:	f7 e9                	imul   %ecx
  800de4:	c1 fa 02             	sar    $0x2,%edx
  800de7:	89 c8                	mov    %ecx,%eax
  800de9:	c1 f8 1f             	sar    $0x1f,%eax
  800dec:	29 c2                	sub    %eax,%edx
  800dee:	89 d0                	mov    %edx,%eax
  800df0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dfb:	f7 e9                	imul   %ecx
  800dfd:	c1 fa 02             	sar    $0x2,%edx
  800e00:	89 c8                	mov    %ecx,%eax
  800e02:	c1 f8 1f             	sar    $0x1f,%eax
  800e05:	29 c2                	sub    %eax,%edx
  800e07:	89 d0                	mov    %edx,%eax
  800e09:	c1 e0 02             	shl    $0x2,%eax
  800e0c:	01 d0                	add    %edx,%eax
  800e0e:	01 c0                	add    %eax,%eax
  800e10:	29 c1                	sub    %eax,%ecx
  800e12:	89 ca                	mov    %ecx,%edx
  800e14:	85 d2                	test   %edx,%edx
  800e16:	75 9c                	jne    800db4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e22:	48                   	dec    %eax
  800e23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e2a:	74 3d                	je     800e69 <ltostr+0xe2>
		start = 1 ;
  800e2c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e33:	eb 34                	jmp    800e69 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	01 d0                	add    %edx,%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	01 c2                	add    %eax,%edx
  800e4a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	01 c8                	add    %ecx,%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	01 c2                	add    %eax,%edx
  800e5e:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e61:	88 02                	mov    %al,(%edx)
		start++ ;
  800e63:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e66:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6f:	7c c4                	jl     800e35 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e71:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	01 d0                	add    %edx,%eax
  800e79:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e7c:	90                   	nop
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e85:	ff 75 08             	pushl  0x8(%ebp)
  800e88:	e8 54 fa ff ff       	call   8008e1 <strlen>
  800e8d:	83 c4 04             	add    $0x4,%esp
  800e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	e8 46 fa ff ff       	call   8008e1 <strlen>
  800e9b:	83 c4 04             	add    $0x4,%esp
  800e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eaf:	eb 17                	jmp    800ec8 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb7:	01 c2                	add    %eax,%edx
  800eb9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	01 c8                	add    %ecx,%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec5:	ff 45 fc             	incl   -0x4(%ebp)
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ece:	7c e1                	jl     800eb1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ede:	eb 1f                	jmp    800eff <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8d 50 01             	lea    0x1(%eax),%edx
  800ee6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee9:	89 c2                	mov    %eax,%edx
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	01 c2                	add    %eax,%edx
  800ef0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	01 c8                	add    %ecx,%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800efc:	ff 45 f8             	incl   -0x8(%ebp)
  800eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f05:	7c d9                	jl     800ee0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	01 d0                	add    %edx,%eax
  800f0f:	c6 00 00             	movb   $0x0,(%eax)
}
  800f12:	90                   	nop
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f18:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f21:	8b 45 14             	mov    0x14(%ebp),%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	01 d0                	add    %edx,%eax
  800f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f38:	eb 0c                	jmp    800f46 <strsplit+0x31>
			*string++ = 0;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8d 50 01             	lea    0x1(%eax),%edx
  800f40:	89 55 08             	mov    %edx,0x8(%ebp)
  800f43:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	84 c0                	test   %al,%al
  800f4d:	74 18                	je     800f67 <strsplit+0x52>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f be c0             	movsbl %al,%eax
  800f57:	50                   	push   %eax
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	e8 13 fb ff ff       	call   800a73 <strchr>
  800f60:	83 c4 08             	add    $0x8,%esp
  800f63:	85 c0                	test   %eax,%eax
  800f65:	75 d3                	jne    800f3a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	84 c0                	test   %al,%al
  800f6e:	74 5a                	je     800fca <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f70:	8b 45 14             	mov    0x14(%ebp),%eax
  800f73:	8b 00                	mov    (%eax),%eax
  800f75:	83 f8 0f             	cmp    $0xf,%eax
  800f78:	75 07                	jne    800f81 <strsplit+0x6c>
		{
			return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	eb 66                	jmp    800fe7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	8b 00                	mov    (%eax),%eax
  800f86:	8d 48 01             	lea    0x1(%eax),%ecx
  800f89:	8b 55 14             	mov    0x14(%ebp),%edx
  800f8c:	89 0a                	mov    %ecx,(%edx)
  800f8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f95:	8b 45 10             	mov    0x10(%ebp),%eax
  800f98:	01 c2                	add    %eax,%edx
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9f:	eb 03                	jmp    800fa4 <strsplit+0x8f>
			string++;
  800fa1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	84 c0                	test   %al,%al
  800fab:	74 8b                	je     800f38 <strsplit+0x23>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f be c0             	movsbl %al,%eax
  800fb5:	50                   	push   %eax
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	e8 b5 fa ff ff       	call   800a73 <strchr>
  800fbe:	83 c4 08             	add    $0x8,%esp
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	74 dc                	je     800fa1 <strsplit+0x8c>
			string++;
	}
  800fc5:	e9 6e ff ff ff       	jmp    800f38 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fca:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	01 d0                	add    %edx,%eax
  800fdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 4c                	jmp    801044 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  800ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	01 d0                	add    %edx,%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 40                	cmp    $0x40,%al
  801004:	7e 27                	jle    80102d <str2lower+0x44>
  801006:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 5a                	cmp    $0x5a,%al
  801012:	7f 19                	jg     80102d <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801014:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	01 d0                	add    %edx,%eax
  80101c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80101f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801022:	01 ca                	add    %ecx,%edx
  801024:	8a 12                	mov    (%edx),%dl
  801026:	83 c2 20             	add    $0x20,%edx
  801029:	88 10                	mov    %dl,(%eax)
  80102b:	eb 14                	jmp    801041 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80102d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	01 c2                	add    %eax,%edx
  801035:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	01 c8                	add    %ecx,%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801041:	ff 45 fc             	incl   -0x4(%ebp)
  801044:	ff 75 0c             	pushl  0xc(%ebp)
  801047:	e8 95 f8 ff ff       	call   8008e1 <strlen>
  80104c:	83 c4 04             	add    $0x4,%esp
  80104f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801052:	7f a4                	jg     800ff8 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801054:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
  80106a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8b 55 0c             	mov    0xc(%ebp),%edx
  801073:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801076:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801079:	8b 7d 18             	mov    0x18(%ebp),%edi
  80107c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80107f:	cd 30                	int    $0x30
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801084:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    

0080108f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	8b 45 10             	mov    0x10(%ebp),%eax
  801098:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80109b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	6a 00                	push   $0x0
  8010a4:	6a 00                	push   $0x0
  8010a6:	52                   	push   %edx
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	50                   	push   %eax
  8010ab:	6a 00                	push   $0x0
  8010ad:	e8 b2 ff ff ff       	call   801064 <syscall>
  8010b2:	83 c4 18             	add    $0x18,%esp
}
  8010b5:	90                   	nop
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 01                	push   $0x1
  8010c7:	e8 98 ff ff ff       	call   801064 <syscall>
  8010cc:	83 c4 18             	add    $0x18,%esp
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 00                	push   $0x0
  8010e0:	52                   	push   %edx
  8010e1:	50                   	push   %eax
  8010e2:	6a 05                	push   $0x5
  8010e4:	e8 7b ff ff ff       	call   801064 <syscall>
  8010e9:	83 c4 18             	add    $0x18,%esp
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	56                   	push   %esi
  8010f2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	51                   	push   %ecx
  801105:	52                   	push   %edx
  801106:	50                   	push   %eax
  801107:	6a 06                	push   $0x6
  801109:	e8 56 ff ff ff       	call   801064 <syscall>
  80110e:	83 c4 18             	add    $0x18,%esp
}
  801111:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	6a 00                	push   $0x0
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	52                   	push   %edx
  801128:	50                   	push   %eax
  801129:	6a 07                	push   $0x7
  80112b:	e8 34 ff ff ff       	call   801064 <syscall>
  801130:	83 c4 18             	add    $0x18,%esp
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	ff 75 08             	pushl  0x8(%ebp)
  801144:	6a 08                	push   $0x8
  801146:	e8 19 ff ff ff       	call   801064 <syscall>
  80114b:	83 c4 18             	add    $0x18,%esp
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 09                	push   $0x9
  80115f:	e8 00 ff ff ff       	call   801064 <syscall>
  801164:	83 c4 18             	add    $0x18,%esp
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 0a                	push   $0xa
  801178:	e8 e7 fe ff ff       	call   801064 <syscall>
  80117d:	83 c4 18             	add    $0x18,%esp
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 0b                	push   $0xb
  801191:	e8 ce fe ff ff       	call   801064 <syscall>
  801196:	83 c4 18             	add    $0x18,%esp
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 0c                	push   $0xc
  8011aa:	e8 b5 fe ff ff       	call   801064 <syscall>
  8011af:	83 c4 18             	add    $0x18,%esp
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	ff 75 08             	pushl  0x8(%ebp)
  8011c2:	6a 0d                	push   $0xd
  8011c4:	e8 9b fe ff ff       	call   801064 <syscall>
  8011c9:	83 c4 18             	add    $0x18,%esp
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 0e                	push   $0xe
  8011dd:	e8 82 fe ff ff       	call   801064 <syscall>
  8011e2:	83 c4 18             	add    $0x18,%esp
}
  8011e5:	90                   	nop
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 11                	push   $0x11
  8011f7:	e8 68 fe ff ff       	call   801064 <syscall>
  8011fc:	83 c4 18             	add    $0x18,%esp
}
  8011ff:	90                   	nop
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 12                	push   $0x12
  801211:	e8 4e fe ff ff       	call   801064 <syscall>
  801216:	83 c4 18             	add    $0x18,%esp
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_cputc>:


void
sys_cputc(const char c)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801228:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	50                   	push   %eax
  801235:	6a 13                	push   $0x13
  801237:	e8 28 fe ff ff       	call   801064 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 14                	push   $0x14
  801251:	e8 0e fe ff ff       	call   801064 <syscall>
  801256:	83 c4 18             	add    $0x18,%esp
}
  801259:	90                   	nop
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	50                   	push   %eax
  80126c:	6a 15                	push   $0x15
  80126e:	e8 f1 fd ff ff       	call   801064 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	52                   	push   %edx
  801288:	50                   	push   %eax
  801289:	6a 18                	push   $0x18
  80128b:	e8 d4 fd ff ff       	call   801064 <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	50                   	push   %eax
  8012a6:	6a 16                	push   $0x16
  8012a8:	e8 b7 fd ff ff       	call   801064 <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	90                   	nop
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	52                   	push   %edx
  8012c3:	50                   	push   %eax
  8012c4:	6a 17                	push   $0x17
  8012c6:	e8 99 fd ff ff       	call   801064 <syscall>
  8012cb:	83 c4 18             	add    $0x18,%esp
}
  8012ce:	90                   	nop
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012dd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	51                   	push   %ecx
  8012ea:	52                   	push   %edx
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	50                   	push   %eax
  8012ef:	6a 19                	push   $0x19
  8012f1:	e8 6e fd ff ff       	call   801064 <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	52                   	push   %edx
  80130b:	50                   	push   %eax
  80130c:	6a 1a                	push   $0x1a
  80130e:	e8 51 fd ff ff       	call   801064 <syscall>
  801313:	83 c4 18             	add    $0x18,%esp
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80131b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80131e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	51                   	push   %ecx
  801329:	52                   	push   %edx
  80132a:	50                   	push   %eax
  80132b:	6a 1b                	push   $0x1b
  80132d:	e8 32 fd ff ff       	call   801064 <syscall>
  801332:	83 c4 18             	add    $0x18,%esp
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	52                   	push   %edx
  801347:	50                   	push   %eax
  801348:	6a 1c                	push   $0x1c
  80134a:	e8 15 fd ff ff       	call   801064 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 1d                	push   $0x1d
  801363:	e8 fc fc ff ff       	call   801064 <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	6a 00                	push   $0x0
  801375:	ff 75 14             	pushl  0x14(%ebp)
  801378:	ff 75 10             	pushl  0x10(%ebp)
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	50                   	push   %eax
  80137f:	6a 1e                	push   $0x1e
  801381:	e8 de fc ff ff       	call   801064 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	50                   	push   %eax
  80139a:	6a 1f                	push   $0x1f
  80139c:	e8 c3 fc ff ff       	call   801064 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	90                   	nop
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	50                   	push   %eax
  8013b6:	6a 20                	push   $0x20
  8013b8:	e8 a7 fc ff ff       	call   801064 <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 02                	push   $0x2
  8013d1:	e8 8e fc ff ff       	call   801064 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 03                	push   $0x3
  8013ea:	e8 75 fc ff ff       	call   801064 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 04                	push   $0x4
  801403:	e8 5c fc ff ff       	call   801064 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_exit_env>:


void sys_exit_env(void)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 21                	push   $0x21
  80141c:	e8 43 fc ff ff       	call   801064 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	90                   	nop
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80142d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801430:	8d 50 04             	lea    0x4(%eax),%edx
  801433:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	52                   	push   %edx
  80143d:	50                   	push   %eax
  80143e:	6a 22                	push   $0x22
  801440:	e8 1f fc ff ff       	call   801064 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
	return result;
  801448:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	89 01                	mov    %eax,(%ecx)
  801453:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	c9                   	leave  
  80145a:	c2 04 00             	ret    $0x4

0080145d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	ff 75 10             	pushl  0x10(%ebp)
  801467:	ff 75 0c             	pushl  0xc(%ebp)
  80146a:	ff 75 08             	pushl  0x8(%ebp)
  80146d:	6a 10                	push   $0x10
  80146f:	e8 f0 fb ff ff       	call   801064 <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
	return ;
  801477:	90                   	nop
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <sys_rcr2>:
uint32 sys_rcr2()
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 23                	push   $0x23
  801489:	e8 d6 fb ff ff       	call   801064 <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80149f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	50                   	push   %eax
  8014ac:	6a 24                	push   $0x24
  8014ae:	e8 b1 fb ff ff       	call   801064 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b6:	90                   	nop
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <rsttst>:
void rsttst()
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 26                	push   $0x26
  8014c8:	e8 97 fb ff ff       	call   801064 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d0:	90                   	nop
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014df:	8b 55 18             	mov    0x18(%ebp),%edx
  8014e2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014e6:	52                   	push   %edx
  8014e7:	50                   	push   %eax
  8014e8:	ff 75 10             	pushl  0x10(%ebp)
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	ff 75 08             	pushl  0x8(%ebp)
  8014f1:	6a 25                	push   $0x25
  8014f3:	e8 6c fb ff ff       	call   801064 <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fb:	90                   	nop
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <chktst>:
void chktst(uint32 n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	6a 27                	push   $0x27
  80150e:	e8 51 fb ff ff       	call   801064 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
	return ;
  801516:	90                   	nop
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <inctst>:

void inctst()
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 28                	push   $0x28
  801528:	e8 37 fb ff ff       	call   801064 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
	return ;
  801530:	90                   	nop
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <gettst>:
uint32 gettst()
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 29                	push   $0x29
  801542:	e8 1d fb ff ff       	call   801064 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 2a                	push   $0x2a
  80155e:	e8 01 fb ff ff       	call   801064 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
  801566:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801569:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80156d:	75 07                	jne    801576 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80156f:	b8 01 00 00 00       	mov    $0x1,%eax
  801574:	eb 05                	jmp    80157b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 2a                	push   $0x2a
  80158f:	e8 d0 fa ff ff       	call   801064 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
  801597:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80159a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80159e:	75 07                	jne    8015a7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a5:	eb 05                	jmp    8015ac <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 2a                	push   $0x2a
  8015c0:	e8 9f fa ff ff       	call   801064 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
  8015c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015cb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015cf:	75 07                	jne    8015d8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d6:	eb 05                	jmp    8015dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 2a                	push   $0x2a
  8015f1:	e8 6e fa ff ff       	call   801064 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
  8015f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015fc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801600:	75 07                	jne    801609 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801602:	b8 01 00 00 00       	mov    $0x1,%eax
  801607:	eb 05                	jmp    80160e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	6a 2b                	push   $0x2b
  801620:	e8 3f fa ff ff       	call   801064 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
	return ;
  801628:	90                   	nop
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80162f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801632:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	53                   	push   %ebx
  80163e:	51                   	push   %ecx
  80163f:	52                   	push   %edx
  801640:	50                   	push   %eax
  801641:	6a 2c                	push   $0x2c
  801643:	e8 1c fa ff ff       	call   801064 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801653:	8b 55 0c             	mov    0xc(%ebp),%edx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	6a 2d                	push   $0x2d
  801663:	e8 fc f9 ff ff       	call   801064 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801670:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	51                   	push   %ecx
  80167c:	ff 75 10             	pushl  0x10(%ebp)
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 2e                	push   $0x2e
  801683:	e8 dc f9 ff ff       	call   801064 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	ff 75 10             	pushl  0x10(%ebp)
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	6a 0f                	push   $0xf
  80169f:	e8 c0 f9 ff ff       	call   801064 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a7:	90                   	nop
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	50                   	push   %eax
  8016b9:	6a 2f                	push   $0x2f
  8016bb:	e8 a4 f9 ff ff       	call   801064 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp

}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	6a 30                	push   $0x30
  8016d6:	e8 89 f9 ff ff       	call   801064 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp

}
  8016de:	90                   	nop
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	6a 31                	push   $0x31
  8016f2:	e8 6d f9 ff ff       	call   801064 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp

}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_hard_limit>:
uint32 sys_hard_limit(){
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 32                	push   $0x32
  80170c:	e8 53 f9 ff ff       	call   801064 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    
  801716:	66 90                	xchg   %ax,%ax

00801718 <__udivdi3>:
  801718:	55                   	push   %ebp
  801719:	57                   	push   %edi
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
  80171c:	83 ec 1c             	sub    $0x1c,%esp
  80171f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801723:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80172b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172f:	89 ca                	mov    %ecx,%edx
  801731:	89 f8                	mov    %edi,%eax
  801733:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801737:	85 f6                	test   %esi,%esi
  801739:	75 2d                	jne    801768 <__udivdi3+0x50>
  80173b:	39 cf                	cmp    %ecx,%edi
  80173d:	77 65                	ja     8017a4 <__udivdi3+0x8c>
  80173f:	89 fd                	mov    %edi,%ebp
  801741:	85 ff                	test   %edi,%edi
  801743:	75 0b                	jne    801750 <__udivdi3+0x38>
  801745:	b8 01 00 00 00       	mov    $0x1,%eax
  80174a:	31 d2                	xor    %edx,%edx
  80174c:	f7 f7                	div    %edi
  80174e:	89 c5                	mov    %eax,%ebp
  801750:	31 d2                	xor    %edx,%edx
  801752:	89 c8                	mov    %ecx,%eax
  801754:	f7 f5                	div    %ebp
  801756:	89 c1                	mov    %eax,%ecx
  801758:	89 d8                	mov    %ebx,%eax
  80175a:	f7 f5                	div    %ebp
  80175c:	89 cf                	mov    %ecx,%edi
  80175e:	89 fa                	mov    %edi,%edx
  801760:	83 c4 1c             	add    $0x1c,%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5f                   	pop    %edi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    
  801768:	39 ce                	cmp    %ecx,%esi
  80176a:	77 28                	ja     801794 <__udivdi3+0x7c>
  80176c:	0f bd fe             	bsr    %esi,%edi
  80176f:	83 f7 1f             	xor    $0x1f,%edi
  801772:	75 40                	jne    8017b4 <__udivdi3+0x9c>
  801774:	39 ce                	cmp    %ecx,%esi
  801776:	72 0a                	jb     801782 <__udivdi3+0x6a>
  801778:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80177c:	0f 87 9e 00 00 00    	ja     801820 <__udivdi3+0x108>
  801782:	b8 01 00 00 00       	mov    $0x1,%eax
  801787:	89 fa                	mov    %edi,%edx
  801789:	83 c4 1c             	add    $0x1c,%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5f                   	pop    %edi
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    
  801791:	8d 76 00             	lea    0x0(%esi),%esi
  801794:	31 ff                	xor    %edi,%edi
  801796:	31 c0                	xor    %eax,%eax
  801798:	89 fa                	mov    %edi,%edx
  80179a:	83 c4 1c             	add    $0x1c,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    
  8017a2:	66 90                	xchg   %ax,%ax
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	f7 f7                	div    %edi
  8017a8:	31 ff                	xor    %edi,%edi
  8017aa:	89 fa                	mov    %edi,%edx
  8017ac:	83 c4 1c             	add    $0x1c,%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
  8017b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017b9:	89 eb                	mov    %ebp,%ebx
  8017bb:	29 fb                	sub    %edi,%ebx
  8017bd:	89 f9                	mov    %edi,%ecx
  8017bf:	d3 e6                	shl    %cl,%esi
  8017c1:	89 c5                	mov    %eax,%ebp
  8017c3:	88 d9                	mov    %bl,%cl
  8017c5:	d3 ed                	shr    %cl,%ebp
  8017c7:	89 e9                	mov    %ebp,%ecx
  8017c9:	09 f1                	or     %esi,%ecx
  8017cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017cf:	89 f9                	mov    %edi,%ecx
  8017d1:	d3 e0                	shl    %cl,%eax
  8017d3:	89 c5                	mov    %eax,%ebp
  8017d5:	89 d6                	mov    %edx,%esi
  8017d7:	88 d9                	mov    %bl,%cl
  8017d9:	d3 ee                	shr    %cl,%esi
  8017db:	89 f9                	mov    %edi,%ecx
  8017dd:	d3 e2                	shl    %cl,%edx
  8017df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017e3:	88 d9                	mov    %bl,%cl
  8017e5:	d3 e8                	shr    %cl,%eax
  8017e7:	09 c2                	or     %eax,%edx
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	89 f2                	mov    %esi,%edx
  8017ed:	f7 74 24 0c          	divl   0xc(%esp)
  8017f1:	89 d6                	mov    %edx,%esi
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	f7 e5                	mul    %ebp
  8017f7:	39 d6                	cmp    %edx,%esi
  8017f9:	72 19                	jb     801814 <__udivdi3+0xfc>
  8017fb:	74 0b                	je     801808 <__udivdi3+0xf0>
  8017fd:	89 d8                	mov    %ebx,%eax
  8017ff:	31 ff                	xor    %edi,%edi
  801801:	e9 58 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  801806:	66 90                	xchg   %ax,%ax
  801808:	8b 54 24 08          	mov    0x8(%esp),%edx
  80180c:	89 f9                	mov    %edi,%ecx
  80180e:	d3 e2                	shl    %cl,%edx
  801810:	39 c2                	cmp    %eax,%edx
  801812:	73 e9                	jae    8017fd <__udivdi3+0xe5>
  801814:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801817:	31 ff                	xor    %edi,%edi
  801819:	e9 40 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  80181e:	66 90                	xchg   %ax,%ax
  801820:	31 c0                	xor    %eax,%eax
  801822:	e9 37 ff ff ff       	jmp    80175e <__udivdi3+0x46>
  801827:	90                   	nop

00801828 <__umoddi3>:
  801828:	55                   	push   %ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 1c             	sub    $0x1c,%esp
  80182f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801833:	8b 74 24 34          	mov    0x34(%esp),%esi
  801837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80183b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80183f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801843:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801847:	89 f3                	mov    %esi,%ebx
  801849:	89 fa                	mov    %edi,%edx
  80184b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80184f:	89 34 24             	mov    %esi,(%esp)
  801852:	85 c0                	test   %eax,%eax
  801854:	75 1a                	jne    801870 <__umoddi3+0x48>
  801856:	39 f7                	cmp    %esi,%edi
  801858:	0f 86 a2 00 00 00    	jbe    801900 <__umoddi3+0xd8>
  80185e:	89 c8                	mov    %ecx,%eax
  801860:	89 f2                	mov    %esi,%edx
  801862:	f7 f7                	div    %edi
  801864:	89 d0                	mov    %edx,%eax
  801866:	31 d2                	xor    %edx,%edx
  801868:	83 c4 1c             	add    $0x1c,%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5f                   	pop    %edi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
  801870:	39 f0                	cmp    %esi,%eax
  801872:	0f 87 ac 00 00 00    	ja     801924 <__umoddi3+0xfc>
  801878:	0f bd e8             	bsr    %eax,%ebp
  80187b:	83 f5 1f             	xor    $0x1f,%ebp
  80187e:	0f 84 ac 00 00 00    	je     801930 <__umoddi3+0x108>
  801884:	bf 20 00 00 00       	mov    $0x20,%edi
  801889:	29 ef                	sub    %ebp,%edi
  80188b:	89 fe                	mov    %edi,%esi
  80188d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801891:	89 e9                	mov    %ebp,%ecx
  801893:	d3 e0                	shl    %cl,%eax
  801895:	89 d7                	mov    %edx,%edi
  801897:	89 f1                	mov    %esi,%ecx
  801899:	d3 ef                	shr    %cl,%edi
  80189b:	09 c7                	or     %eax,%edi
  80189d:	89 e9                	mov    %ebp,%ecx
  80189f:	d3 e2                	shl    %cl,%edx
  8018a1:	89 14 24             	mov    %edx,(%esp)
  8018a4:	89 d8                	mov    %ebx,%eax
  8018a6:	d3 e0                	shl    %cl,%eax
  8018a8:	89 c2                	mov    %eax,%edx
  8018aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ae:	d3 e0                	shl    %cl,%eax
  8018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b8:	89 f1                	mov    %esi,%ecx
  8018ba:	d3 e8                	shr    %cl,%eax
  8018bc:	09 d0                	or     %edx,%eax
  8018be:	d3 eb                	shr    %cl,%ebx
  8018c0:	89 da                	mov    %ebx,%edx
  8018c2:	f7 f7                	div    %edi
  8018c4:	89 d3                	mov    %edx,%ebx
  8018c6:	f7 24 24             	mull   (%esp)
  8018c9:	89 c6                	mov    %eax,%esi
  8018cb:	89 d1                	mov    %edx,%ecx
  8018cd:	39 d3                	cmp    %edx,%ebx
  8018cf:	0f 82 87 00 00 00    	jb     80195c <__umoddi3+0x134>
  8018d5:	0f 84 91 00 00 00    	je     80196c <__umoddi3+0x144>
  8018db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018df:	29 f2                	sub    %esi,%edx
  8018e1:	19 cb                	sbb    %ecx,%ebx
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018e9:	d3 e0                	shl    %cl,%eax
  8018eb:	89 e9                	mov    %ebp,%ecx
  8018ed:	d3 ea                	shr    %cl,%edx
  8018ef:	09 d0                	or     %edx,%eax
  8018f1:	89 e9                	mov    %ebp,%ecx
  8018f3:	d3 eb                	shr    %cl,%ebx
  8018f5:	89 da                	mov    %ebx,%edx
  8018f7:	83 c4 1c             	add    $0x1c,%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5f                   	pop    %edi
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    
  8018ff:	90                   	nop
  801900:	89 fd                	mov    %edi,%ebp
  801902:	85 ff                	test   %edi,%edi
  801904:	75 0b                	jne    801911 <__umoddi3+0xe9>
  801906:	b8 01 00 00 00       	mov    $0x1,%eax
  80190b:	31 d2                	xor    %edx,%edx
  80190d:	f7 f7                	div    %edi
  80190f:	89 c5                	mov    %eax,%ebp
  801911:	89 f0                	mov    %esi,%eax
  801913:	31 d2                	xor    %edx,%edx
  801915:	f7 f5                	div    %ebp
  801917:	89 c8                	mov    %ecx,%eax
  801919:	f7 f5                	div    %ebp
  80191b:	89 d0                	mov    %edx,%eax
  80191d:	e9 44 ff ff ff       	jmp    801866 <__umoddi3+0x3e>
  801922:	66 90                	xchg   %ax,%ax
  801924:	89 c8                	mov    %ecx,%eax
  801926:	89 f2                	mov    %esi,%edx
  801928:	83 c4 1c             	add    $0x1c,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5f                   	pop    %edi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
  801930:	3b 04 24             	cmp    (%esp),%eax
  801933:	72 06                	jb     80193b <__umoddi3+0x113>
  801935:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801939:	77 0f                	ja     80194a <__umoddi3+0x122>
  80193b:	89 f2                	mov    %esi,%edx
  80193d:	29 f9                	sub    %edi,%ecx
  80193f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801943:	89 14 24             	mov    %edx,(%esp)
  801946:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80194e:	8b 14 24             	mov    (%esp),%edx
  801951:	83 c4 1c             	add    $0x1c,%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
  801959:	8d 76 00             	lea    0x0(%esi),%esi
  80195c:	2b 04 24             	sub    (%esp),%eax
  80195f:	19 fa                	sbb    %edi,%edx
  801961:	89 d1                	mov    %edx,%ecx
  801963:	89 c6                	mov    %eax,%esi
  801965:	e9 71 ff ff ff       	jmp    8018db <__umoddi3+0xb3>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801970:	72 ea                	jb     80195c <__umoddi3+0x134>
  801972:	89 d9                	mov    %ebx,%ecx
  801974:	e9 62 ff ff ff       	jmp    8018db <__umoddi3+0xb3>
