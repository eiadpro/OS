
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1c 80 00       	push   $0x801cc0
  800057:	e8 10 0a 00 00       	call   800a6c <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 62 0e 00 00       	call   800ed4 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 de 1c 80 00       	push   $0x801cde
  800097:	e8 7d 02 00 00       	call   800319 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e7:	e8 82 15 00 00       	call   80166e <sys_getenvindex>
  8000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	c1 e0 03             	shl    $0x3,%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	01 c0                	add    %eax,%eax
  8000fb:	01 d0                	add    %edx,%eax
  8000fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800104:	01 d0                	add    %edx,%eax
  800106:	c1 e0 04             	shl    $0x4,%eax
  800109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8a 40 5c             	mov    0x5c(%eax),%al
  80011b:	84 c0                	test   %al,%al
  80011d:	74 0d                	je     80012c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80011f:	a1 20 30 80 00       	mov    0x803020,%eax
  800124:	83 c0 5c             	add    $0x5c,%eax
  800127:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800130:	7e 0a                	jle    80013c <libmain+0x5b>
		binaryname = argv[0];
  800132:	8b 45 0c             	mov    0xc(%ebp),%eax
  800135:	8b 00                	mov    (%eax),%eax
  800137:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	e8 ee fe ff ff       	call   800038 <_main>
  80014a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80014d:	e8 29 13 00 00       	call   80147b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	68 0c 1d 80 00       	push   $0x801d0c
  80015a:	e8 8d 01 00 00       	call   8002ec <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800162:	a1 20 30 80 00       	mov    0x803020,%eax
  800167:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80016d:	a1 20 30 80 00       	mov    0x803020,%eax
  800172:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	52                   	push   %edx
  80017c:	50                   	push   %eax
  80017d:	68 34 1d 80 00       	push   $0x801d34
  800182:	e8 65 01 00 00       	call   8002ec <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018a:	a1 20 30 80 00       	mov    0x803020,%eax
  80018f:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800195:	a1 20 30 80 00       	mov    0x803020,%eax
  80019a:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8001a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a5:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8001ab:	51                   	push   %ecx
  8001ac:	52                   	push   %edx
  8001ad:	50                   	push   %eax
  8001ae:	68 5c 1d 80 00       	push   $0x801d5c
  8001b3:	e8 34 01 00 00       	call   8002ec <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	50                   	push   %eax
  8001ca:	68 b4 1d 80 00       	push   $0x801db4
  8001cf:	e8 18 01 00 00       	call   8002ec <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 0c 1d 80 00       	push   $0x801d0c
  8001df:	e8 08 01 00 00       	call   8002ec <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001e7:	e8 a9 12 00 00       	call   801495 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001ec:	e8 19 00 00 00       	call   80020a <exit>
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	e8 36 14 00 00       	call   80163a <sys_destroy_env>
  800204:	83 c4 10             	add    $0x10,%esp
}
  800207:	90                   	nop
  800208:	c9                   	leave  
  800209:	c3                   	ret    

0080020a <exit>:

void
exit(void)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800210:	e8 8b 14 00 00       	call   8016a0 <sys_exit_env>
}
  800215:	90                   	nop
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80021e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800221:	8b 00                	mov    (%eax),%eax
  800223:	8d 48 01             	lea    0x1(%eax),%ecx
  800226:	8b 55 0c             	mov    0xc(%ebp),%edx
  800229:	89 0a                	mov    %ecx,(%edx)
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	88 d1                	mov    %dl,%cl
  800230:	8b 55 0c             	mov    0xc(%ebp),%edx
  800233:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800241:	75 2c                	jne    80026f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800243:	a0 24 30 80 00       	mov    0x803024,%al
  800248:	0f b6 c0             	movzbl %al,%eax
  80024b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024e:	8b 12                	mov    (%edx),%edx
  800250:	89 d1                	mov    %edx,%ecx
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
  800255:	83 c2 08             	add    $0x8,%edx
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	50                   	push   %eax
  80025c:	51                   	push   %ecx
  80025d:	52                   	push   %edx
  80025e:	e8 bf 10 00 00       	call   801322 <sys_cputs>
  800263:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
  800269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	8b 40 04             	mov    0x4(%eax),%eax
  800275:	8d 50 01             	lea    0x1(%eax),%edx
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80027e:	90                   	nop
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80028a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800291:	00 00 00 
	b.cnt = 0;
  800294:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80029e:	ff 75 0c             	pushl  0xc(%ebp)
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002aa:	50                   	push   %eax
  8002ab:	68 18 02 80 00       	push   $0x800218
  8002b0:	e8 11 02 00 00       	call   8004c6 <vprintfmt>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b8:	a0 24 30 80 00       	mov    0x803024,%al
  8002bd:	0f b6 c0             	movzbl %al,%eax
  8002c0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	50                   	push   %eax
  8002ca:	52                   	push   %edx
  8002cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d1:	83 c0 08             	add    $0x8,%eax
  8002d4:	50                   	push   %eax
  8002d5:	e8 48 10 00 00       	call   801322 <sys_cputs>
  8002da:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002dd:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <cprintf>:

int cprintf(const char *fmt, ...) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	ff 75 f4             	pushl  -0xc(%ebp)
  800308:	50                   	push   %eax
  800309:	e8 73 ff ff ff       	call   800281 <vcprintf>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80031f:	e8 57 11 00 00       	call   80147b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800324:	8d 45 0c             	lea    0xc(%ebp),%eax
  800327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	83 ec 08             	sub    $0x8,%esp
  800330:	ff 75 f4             	pushl  -0xc(%ebp)
  800333:	50                   	push   %eax
  800334:	e8 48 ff ff ff       	call   800281 <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80033f:	e8 51 11 00 00       	call   801495 <sys_enable_interrupt>
	return cnt;
  800344:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800347:	c9                   	leave  
  800348:	c3                   	ret    

00800349 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	53                   	push   %ebx
  80034d:	83 ec 14             	sub    $0x14,%esp
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035c:	8b 45 18             	mov    0x18(%ebp),%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
  800364:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800367:	77 55                	ja     8003be <printnum+0x75>
  800369:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036c:	72 05                	jb     800373 <printnum+0x2a>
  80036e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800371:	77 4b                	ja     8003be <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800373:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800376:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800379:	8b 45 18             	mov    0x18(%ebp),%eax
  80037c:	ba 00 00 00 00       	mov    $0x0,%edx
  800381:	52                   	push   %edx
  800382:	50                   	push   %eax
  800383:	ff 75 f4             	pushl  -0xc(%ebp)
  800386:	ff 75 f0             	pushl  -0x10(%ebp)
  800389:	e8 be 16 00 00       	call   801a4c <__udivdi3>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	ff 75 20             	pushl  0x20(%ebp)
  800397:	53                   	push   %ebx
  800398:	ff 75 18             	pushl  0x18(%ebp)
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	e8 a1 ff ff ff       	call   800349 <printnum>
  8003a8:	83 c4 20             	add    $0x20,%esp
  8003ab:	eb 1a                	jmp    8003c7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	ff 75 0c             	pushl  0xc(%ebp)
  8003b3:	ff 75 20             	pushl  0x20(%ebp)
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	ff d0                	call   *%eax
  8003bb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003be:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c5:	7f e6                	jg     8003ad <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d5:	53                   	push   %ebx
  8003d6:	51                   	push   %ecx
  8003d7:	52                   	push   %edx
  8003d8:	50                   	push   %eax
  8003d9:	e8 7e 17 00 00       	call   801b5c <__umoddi3>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  8003e6:	8a 00                	mov    (%eax),%al
  8003e8:	0f be c0             	movsbl %al,%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	50                   	push   %eax
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	ff d0                	call   *%eax
  8003f7:	83 c4 10             	add    $0x10,%esp
}
  8003fa:	90                   	nop
  8003fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800403:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800407:	7e 1c                	jle    800425 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	8b 00                	mov    (%eax),%eax
  80040e:	8d 50 08             	lea    0x8(%eax),%edx
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	89 10                	mov    %edx,(%eax)
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	83 e8 08             	sub    $0x8,%eax
  80041e:	8b 50 04             	mov    0x4(%eax),%edx
  800421:	8b 00                	mov    (%eax),%eax
  800423:	eb 40                	jmp    800465 <getuint+0x65>
	else if (lflag)
  800425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800429:	74 1e                	je     800449 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	8d 50 04             	lea    0x4(%eax),%edx
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	89 10                	mov    %edx,(%eax)
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	83 e8 04             	sub    $0x4,%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
  800447:	eb 1c                	jmp    800465 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	8d 50 04             	lea    0x4(%eax),%edx
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	89 10                	mov    %edx,(%eax)
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	83 e8 04             	sub    $0x4,%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046e:	7e 1c                	jle    80048c <getint+0x25>
		return va_arg(*ap, long long);
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	8d 50 08             	lea    0x8(%eax),%edx
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	89 10                	mov    %edx,(%eax)
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	83 e8 08             	sub    $0x8,%eax
  800485:	8b 50 04             	mov    0x4(%eax),%edx
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	eb 38                	jmp    8004c4 <getint+0x5d>
	else if (lflag)
  80048c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800490:	74 1a                	je     8004ac <getint+0x45>
		return va_arg(*ap, long);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	8d 50 04             	lea    0x4(%eax),%edx
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 10                	mov    %edx,(%eax)
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 e8 04             	sub    $0x4,%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	99                   	cltd   
  8004aa:	eb 18                	jmp    8004c4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	8d 50 04             	lea    0x4(%eax),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	83 e8 04             	sub    $0x4,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
}
  8004c4:	5d                   	pop    %ebp
  8004c5:	c3                   	ret    

008004c6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	56                   	push   %esi
  8004ca:	53                   	push   %ebx
  8004cb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ce:	eb 17                	jmp    8004e7 <vprintfmt+0x21>
			if (ch == '\0')
  8004d0:	85 db                	test   %ebx,%ebx
  8004d2:	0f 84 af 03 00 00    	je     800887 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	53                   	push   %ebx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	ff d0                	call   *%eax
  8004e4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ea:	8d 50 01             	lea    0x1(%eax),%edx
  8004ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f0:	8a 00                	mov    (%eax),%al
  8004f2:	0f b6 d8             	movzbl %al,%ebx
  8004f5:	83 fb 25             	cmp    $0x25,%ebx
  8004f8:	75 d6                	jne    8004d0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004fa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800505:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800513:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 45 10             	mov    0x10(%ebp),%eax
  80051d:	8d 50 01             	lea    0x1(%eax),%edx
  800520:	89 55 10             	mov    %edx,0x10(%ebp)
  800523:	8a 00                	mov    (%eax),%al
  800525:	0f b6 d8             	movzbl %al,%ebx
  800528:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80052b:	83 f8 55             	cmp    $0x55,%eax
  80052e:	0f 87 2b 03 00 00    	ja     80085f <vprintfmt+0x399>
  800534:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  80053b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80053d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800541:	eb d7                	jmp    80051a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800543:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800547:	eb d1                	jmp    80051a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800549:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800550:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800553:	89 d0                	mov    %edx,%eax
  800555:	c1 e0 02             	shl    $0x2,%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	01 c0                	add    %eax,%eax
  80055c:	01 d8                	add    %ebx,%eax
  80055e:	83 e8 30             	sub    $0x30,%eax
  800561:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800564:	8b 45 10             	mov    0x10(%ebp),%eax
  800567:	8a 00                	mov    (%eax),%al
  800569:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80056c:	83 fb 2f             	cmp    $0x2f,%ebx
  80056f:	7e 3e                	jle    8005af <vprintfmt+0xe9>
  800571:	83 fb 39             	cmp    $0x39,%ebx
  800574:	7f 39                	jg     8005af <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800576:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800579:	eb d5                	jmp    800550 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 c0 04             	add    $0x4,%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	83 e8 04             	sub    $0x4,%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80058f:	eb 1f                	jmp    8005b0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800591:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800595:	79 83                	jns    80051a <vprintfmt+0x54>
				width = 0;
  800597:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80059e:	e9 77 ff ff ff       	jmp    80051a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005aa:	e9 6b ff ff ff       	jmp    80051a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005af:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b4:	0f 89 60 ff ff ff    	jns    80051a <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c7:	e9 4e ff ff ff       	jmp    80051a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005cf:	e9 46 ff ff ff       	jmp    80051a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 c0 04             	add    $0x4,%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 e8 04             	sub    $0x4,%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	ff 75 0c             	pushl  0xc(%ebp)
  8005eb:	50                   	push   %eax
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	ff d0                	call   *%eax
  8005f1:	83 c4 10             	add    $0x10,%esp
			break;
  8005f4:	e9 89 02 00 00       	jmp    800882 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	83 c0 04             	add    $0x4,%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	83 e8 04             	sub    $0x4,%eax
  800608:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80060a:	85 db                	test   %ebx,%ebx
  80060c:	79 02                	jns    800610 <vprintfmt+0x14a>
				err = -err;
  80060e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800610:	83 fb 64             	cmp    $0x64,%ebx
  800613:	7f 0b                	jg     800620 <vprintfmt+0x15a>
  800615:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  80061c:	85 f6                	test   %esi,%esi
  80061e:	75 19                	jne    800639 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800620:	53                   	push   %ebx
  800621:	68 05 20 80 00       	push   $0x802005
  800626:	ff 75 0c             	pushl  0xc(%ebp)
  800629:	ff 75 08             	pushl  0x8(%ebp)
  80062c:	e8 5e 02 00 00       	call   80088f <printfmt>
  800631:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800634:	e9 49 02 00 00       	jmp    800882 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800639:	56                   	push   %esi
  80063a:	68 0e 20 80 00       	push   $0x80200e
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	ff 75 08             	pushl  0x8(%ebp)
  800645:	e8 45 02 00 00       	call   80088f <printfmt>
  80064a:	83 c4 10             	add    $0x10,%esp
			break;
  80064d:	e9 30 02 00 00       	jmp    800882 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	83 c0 04             	add    $0x4,%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	83 e8 04             	sub    $0x4,%eax
  800661:	8b 30                	mov    (%eax),%esi
  800663:	85 f6                	test   %esi,%esi
  800665:	75 05                	jne    80066c <vprintfmt+0x1a6>
				p = "(null)";
  800667:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  80066c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800670:	7e 6d                	jle    8006df <vprintfmt+0x219>
  800672:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800676:	74 67                	je     8006df <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	50                   	push   %eax
  80067f:	56                   	push   %esi
  800680:	e8 12 05 00 00       	call   800b97 <strnlen>
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80068b:	eb 16                	jmp    8006a3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80068d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 0c             	pushl  0xc(%ebp)
  800697:	50                   	push   %eax
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	ff d0                	call   *%eax
  80069d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a7:	7f e4                	jg     80068d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a9:	eb 34                	jmp    8006df <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006af:	74 1c                	je     8006cd <vprintfmt+0x207>
  8006b1:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b4:	7e 05                	jle    8006bb <vprintfmt+0x1f5>
  8006b6:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b9:	7e 12                	jle    8006cd <vprintfmt+0x207>
					putch('?', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	6a 3f                	push   $0x3f
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	eb 0f                	jmp    8006dc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	53                   	push   %ebx
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006df:	89 f0                	mov    %esi,%eax
  8006e1:	8d 70 01             	lea    0x1(%eax),%esi
  8006e4:	8a 00                	mov    (%eax),%al
  8006e6:	0f be d8             	movsbl %al,%ebx
  8006e9:	85 db                	test   %ebx,%ebx
  8006eb:	74 24                	je     800711 <vprintfmt+0x24b>
  8006ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f1:	78 b8                	js     8006ab <vprintfmt+0x1e5>
  8006f3:	ff 4d e0             	decl   -0x20(%ebp)
  8006f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fa:	79 af                	jns    8006ab <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fc:	eb 13                	jmp    800711 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 0c             	pushl  0xc(%ebp)
  800704:	6a 20                	push   $0x20
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	ff d0                	call   *%eax
  80070b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070e:	ff 4d e4             	decl   -0x1c(%ebp)
  800711:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800715:	7f e7                	jg     8006fe <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800717:	e9 66 01 00 00       	jmp    800882 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 e8             	pushl  -0x18(%ebp)
  800722:	8d 45 14             	lea    0x14(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	e8 3c fd ff ff       	call   800467 <getint>
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800731:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	85 d2                	test   %edx,%edx
  80073c:	79 23                	jns    800761 <vprintfmt+0x29b>
				putch('-', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	6a 2d                	push   $0x2d
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	ff d0                	call   *%eax
  80074b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80074e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800754:	f7 d8                	neg    %eax
  800756:	83 d2 00             	adc    $0x0,%edx
  800759:	f7 da                	neg    %edx
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800761:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800768:	e9 bc 00 00 00       	jmp    800829 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 e8             	pushl  -0x18(%ebp)
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
  800776:	50                   	push   %eax
  800777:	e8 84 fc ff ff       	call   800400 <getuint>
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800782:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800785:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078c:	e9 98 00 00 00       	jmp    800829 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	6a 58                	push   $0x58
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 58                	push   $0x58
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 0c             	pushl  0xc(%ebp)
  8007b7:	6a 58                	push   $0x58
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
			break;
  8007c1:	e9 bc 00 00 00       	jmp    800882 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	6a 30                	push   $0x30
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	6a 78                	push   $0x78
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	83 c0 04             	add    $0x4,%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800801:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800808:	eb 1f                	jmp    800829 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 e8             	pushl  -0x18(%ebp)
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	e8 e7 fb ff ff       	call   800400 <getuint>
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800822:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800829:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80082d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800830:	83 ec 04             	sub    $0x4,%esp
  800833:	52                   	push   %edx
  800834:	ff 75 e4             	pushl  -0x1c(%ebp)
  800837:	50                   	push   %eax
  800838:	ff 75 f4             	pushl  -0xc(%ebp)
  80083b:	ff 75 f0             	pushl  -0x10(%ebp)
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	ff 75 08             	pushl  0x8(%ebp)
  800844:	e8 00 fb ff ff       	call   800349 <printnum>
  800849:	83 c4 20             	add    $0x20,%esp
			break;
  80084c:	eb 34                	jmp    800882 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	53                   	push   %ebx
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	eb 23                	jmp    800882 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 25                	push   $0x25
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086f:	ff 4d 10             	decl   0x10(%ebp)
  800872:	eb 03                	jmp    800877 <vprintfmt+0x3b1>
  800874:	ff 4d 10             	decl   0x10(%ebp)
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	48                   	dec    %eax
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	3c 25                	cmp    $0x25,%al
  80087f:	75 f3                	jne    800874 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800881:	90                   	nop
		}
	}
  800882:	e9 47 fc ff ff       	jmp    8004ce <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800887:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800895:	8d 45 10             	lea    0x10(%ebp),%eax
  800898:	83 c0 04             	add    $0x4,%eax
  80089b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80089e:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a4:	50                   	push   %eax
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 16 fc ff ff       	call   8004c6 <vprintfmt>
  8008b0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008b3:	90                   	nop
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    

008008b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	8b 40 08             	mov    0x8(%eax),%eax
  8008bf:	8d 50 01             	lea    0x1(%eax),%edx
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	8b 10                	mov    (%eax),%edx
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	8b 40 04             	mov    0x4(%eax),%eax
  8008d3:	39 c2                	cmp    %eax,%edx
  8008d5:	73 12                	jae    8008e9 <sprintputch+0x33>
		*b->buf++ = ch;
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	89 0a                	mov    %ecx,(%edx)
  8008e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e7:	88 10                	mov    %dl,(%eax)
}
  8008e9:	90                   	nop
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800911:	74 06                	je     800919 <vsnprintf+0x2d>
  800913:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800917:	7f 07                	jg     800920 <vsnprintf+0x34>
		return -E_INVAL;
  800919:	b8 03 00 00 00       	mov    $0x3,%eax
  80091e:	eb 20                	jmp    800940 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800920:	ff 75 14             	pushl  0x14(%ebp)
  800923:	ff 75 10             	pushl  0x10(%ebp)
  800926:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800929:	50                   	push   %eax
  80092a:	68 b6 08 80 00       	push   $0x8008b6
  80092f:	e8 92 fb ff ff       	call   8004c6 <vprintfmt>
  800934:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800948:	8d 45 10             	lea    0x10(%ebp),%eax
  80094b:	83 c0 04             	add    $0x4,%eax
  80094e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800951:	8b 45 10             	mov    0x10(%ebp),%eax
  800954:	ff 75 f4             	pushl  -0xc(%ebp)
  800957:	50                   	push   %eax
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 89 ff ff ff       	call   8008ec <vsnprintf>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800969:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800974:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800978:	74 13                	je     80098d <readline+0x1f>
		cprintf("%s", prompt);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 08             	pushl  0x8(%ebp)
  800980:	68 70 21 80 00       	push   $0x802170
  800985:	e8 62 f9 ff ff       	call   8002ec <cprintf>
  80098a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80098d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800994:	83 ec 0c             	sub    $0xc,%esp
  800997:	6a 00                	push   $0x0
  800999:	e8 a1 10 00 00       	call   801a3f <iscons>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009a4:	e8 48 10 00 00       	call   8019f1 <getchar>
  8009a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b0:	79 22                	jns    8009d4 <readline+0x66>
			if (c != -E_EOF)
  8009b2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009b6:	0f 84 ad 00 00 00    	je     800a69 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8009c2:	68 73 21 80 00       	push   $0x802173
  8009c7:	e8 20 f9 ff ff       	call   8002ec <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
			return;
  8009cf:	e9 95 00 00 00       	jmp    800a69 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009d4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009d8:	7e 34                	jle    800a0e <readline+0xa0>
  8009da:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009e1:	7f 2b                	jg     800a0e <readline+0xa0>
			if (echoing)
  8009e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009e7:	74 0e                	je     8009f7 <readline+0x89>
				cputchar(c);
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ef:	e8 b5 0f 00 00       	call   8019a9 <cputchar>
  8009f4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fa:	8d 50 01             	lea    0x1(%eax),%edx
  8009fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a00:	89 c2                	mov    %eax,%edx
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	01 d0                	add    %edx,%eax
  800a07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a0a:	88 10                	mov    %dl,(%eax)
  800a0c:	eb 56                	jmp    800a64 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a0e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a12:	75 1f                	jne    800a33 <readline+0xc5>
  800a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a18:	7e 19                	jle    800a33 <readline+0xc5>
			if (echoing)
  800a1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a1e:	74 0e                	je     800a2e <readline+0xc0>
				cputchar(c);
  800a20:	83 ec 0c             	sub    $0xc,%esp
  800a23:	ff 75 ec             	pushl  -0x14(%ebp)
  800a26:	e8 7e 0f 00 00       	call   8019a9 <cputchar>
  800a2b:	83 c4 10             	add    $0x10,%esp

			i--;
  800a2e:	ff 4d f4             	decl   -0xc(%ebp)
  800a31:	eb 31                	jmp    800a64 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a33:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a37:	74 0a                	je     800a43 <readline+0xd5>
  800a39:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a3d:	0f 85 61 ff ff ff    	jne    8009a4 <readline+0x36>
			if (echoing)
  800a43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a47:	74 0e                	je     800a57 <readline+0xe9>
				cputchar(c);
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	ff 75 ec             	pushl  -0x14(%ebp)
  800a4f:	e8 55 0f 00 00       	call   8019a9 <cputchar>
  800a54:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a62:	eb 06                	jmp    800a6a <readline+0xfc>
		}
	}
  800a64:	e9 3b ff ff ff       	jmp    8009a4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a69:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a72:	e8 04 0a 00 00       	call   80147b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7b:	74 13                	je     800a90 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	68 70 21 80 00       	push   $0x802170
  800a88:	e8 5f f8 ff ff       	call   8002ec <cprintf>
  800a8d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 9e 0f 00 00       	call   801a3f <iscons>
  800aa1:	83 c4 10             	add    $0x10,%esp
  800aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa7:	e8 45 0f 00 00       	call   8019f1 <getchar>
  800aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab3:	79 23                	jns    800ad8 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800ab5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab9:	74 13                	je     800ace <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac1:	68 73 21 80 00       	push   $0x802173
  800ac6:	e8 21 f8 ff ff       	call   8002ec <cprintf>
  800acb:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ace:	e8 c2 09 00 00       	call   801495 <sys_enable_interrupt>
			return;
  800ad3:	e9 9a 00 00 00       	jmp    800b72 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800adc:	7e 34                	jle    800b12 <atomic_readline+0xa6>
  800ade:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ae5:	7f 2b                	jg     800b12 <atomic_readline+0xa6>
			if (echoing)
  800ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aeb:	74 0e                	je     800afb <atomic_readline+0x8f>
				cputchar(c);
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	ff 75 ec             	pushl  -0x14(%ebp)
  800af3:	e8 b1 0e 00 00       	call   8019a9 <cputchar>
  800af8:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	01 d0                	add    %edx,%eax
  800b0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b0e:	88 10                	mov    %dl,(%eax)
  800b10:	eb 5b                	jmp    800b6d <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b12:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b16:	75 1f                	jne    800b37 <atomic_readline+0xcb>
  800b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b1c:	7e 19                	jle    800b37 <atomic_readline+0xcb>
			if (echoing)
  800b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b22:	74 0e                	je     800b32 <atomic_readline+0xc6>
				cputchar(c);
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2a:	e8 7a 0e 00 00       	call   8019a9 <cputchar>
  800b2f:	83 c4 10             	add    $0x10,%esp
			i--;
  800b32:	ff 4d f4             	decl   -0xc(%ebp)
  800b35:	eb 36                	jmp    800b6d <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b37:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b3b:	74 0a                	je     800b47 <atomic_readline+0xdb>
  800b3d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b41:	0f 85 60 ff ff ff    	jne    800aa7 <atomic_readline+0x3b>
			if (echoing)
  800b47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4b:	74 0e                	je     800b5b <atomic_readline+0xef>
				cputchar(c);
  800b4d:	83 ec 0c             	sub    $0xc,%esp
  800b50:	ff 75 ec             	pushl  -0x14(%ebp)
  800b53:	e8 51 0e 00 00       	call   8019a9 <cputchar>
  800b58:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b66:	e8 2a 09 00 00       	call   801495 <sys_enable_interrupt>
			return;
  800b6b:	eb 05                	jmp    800b72 <atomic_readline+0x106>
		}
	}
  800b6d:	e9 35 ff ff ff       	jmp    800aa7 <atomic_readline+0x3b>
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b81:	eb 06                	jmp    800b89 <strlen+0x15>
		n++;
  800b83:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b86:	ff 45 08             	incl   0x8(%ebp)
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8a 00                	mov    (%eax),%al
  800b8e:	84 c0                	test   %al,%al
  800b90:	75 f1                	jne    800b83 <strlen+0xf>
		n++;
	return n;
  800b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba4:	eb 09                	jmp    800baf <strnlen+0x18>
		n++;
  800ba6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba9:	ff 45 08             	incl   0x8(%ebp)
  800bac:	ff 4d 0c             	decl   0xc(%ebp)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 09                	je     800bbe <strnlen+0x27>
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	84 c0                	test   %al,%al
  800bbc:	75 e8                	jne    800ba6 <strnlen+0xf>
		n++;
	return n;
  800bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bcf:	90                   	nop
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8d 50 01             	lea    0x1(%eax),%edx
  800bd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bdf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be2:	8a 12                	mov    (%edx),%dl
  800be4:	88 10                	mov    %dl,(%eax)
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 e4                	jne    800bd0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c04:	eb 1f                	jmp    800c25 <strncpy+0x34>
		*dst++ = *src;
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8d 50 01             	lea    0x1(%eax),%edx
  800c0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c12:	8a 12                	mov    (%edx),%dl
  800c14:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	74 03                	je     800c22 <strncpy+0x31>
			src++;
  800c1f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c22:	ff 45 fc             	incl   -0x4(%ebp)
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c28:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c2b:	72 d9                	jb     800c06 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c42:	74 30                	je     800c74 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c44:	eb 16                	jmp    800c5c <strlcpy+0x2a>
			*dst++ = *src++;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8d 50 01             	lea    0x1(%eax),%edx
  800c4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c55:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c58:	8a 12                	mov    (%edx),%dl
  800c5a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c5c:	ff 4d 10             	decl   0x10(%ebp)
  800c5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c63:	74 09                	je     800c6e <strlcpy+0x3c>
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	84 c0                	test   %al,%al
  800c6c:	75 d8                	jne    800c46 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	29 c2                	sub    %eax,%edx
  800c7c:	89 d0                	mov    %edx,%eax
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c83:	eb 06                	jmp    800c8b <strcmp+0xb>
		p++, q++;
  800c85:	ff 45 08             	incl   0x8(%ebp)
  800c88:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	84 c0                	test   %al,%al
  800c92:	74 0e                	je     800ca2 <strcmp+0x22>
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 10                	mov    (%eax),%dl
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	38 c2                	cmp    %al,%dl
  800ca0:	74 e3                	je     800c85 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	0f b6 d0             	movzbl %al,%edx
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	0f b6 c0             	movzbl %al,%eax
  800cb2:	29 c2                	sub    %eax,%edx
  800cb4:	89 d0                	mov    %edx,%eax
}
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cbb:	eb 09                	jmp    800cc6 <strncmp+0xe>
		n--, p++, q++;
  800cbd:	ff 4d 10             	decl   0x10(%ebp)
  800cc0:	ff 45 08             	incl   0x8(%ebp)
  800cc3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 17                	je     800ce3 <strncmp+0x2b>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strncmp+0x2b>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 da                	je     800cbd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	75 07                	jne    800cf0 <strncmp+0x38>
		return 0;
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cee:	eb 14                	jmp    800d04 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	0f b6 d0             	movzbl %al,%edx
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	0f b6 c0             	movzbl %al,%eax
  800d00:	29 c2                	sub    %eax,%edx
  800d02:	89 d0                	mov    %edx,%eax
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 04             	sub    $0x4,%esp
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d12:	eb 12                	jmp    800d26 <strchr+0x20>
		if (*s == c)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d1c:	75 05                	jne    800d23 <strchr+0x1d>
			return (char *) s;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	eb 11                	jmp    800d34 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	75 e5                	jne    800d14 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 04             	sub    $0x4,%esp
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d42:	eb 0d                	jmp    800d51 <strfind+0x1b>
		if (*s == c)
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4c:	74 0e                	je     800d5c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d4e:	ff 45 08             	incl   0x8(%ebp)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	75 ea                	jne    800d44 <strfind+0xe>
  800d5a:	eb 01                	jmp    800d5d <strfind+0x27>
		if (*s == c)
			break;
  800d5c:	90                   	nop
	return (char *) s;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d74:	eb 0e                	jmp    800d84 <memset+0x22>
		*p++ = c;
  800d76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d84:	ff 4d f8             	decl   -0x8(%ebp)
  800d87:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d8b:	79 e9                	jns    800d76 <memset+0x14>
		*p++ = c;

	return v;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800da4:	eb 16                	jmp    800dbc <memcpy+0x2a>
		*d++ = *s++;
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da9:	8d 50 01             	lea    0x1(%eax),%edx
  800dac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800daf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db8:	8a 12                	mov    (%edx),%dl
  800dba:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc5:	85 c0                	test   %eax,%eax
  800dc7:	75 dd                	jne    800da6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de6:	73 50                	jae    800e38 <memmove+0x6a>
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	01 d0                	add    %edx,%eax
  800df0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df3:	76 43                	jbe    800e38 <memmove+0x6a>
		s += n;
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e01:	eb 10                	jmp    800e13 <memmove+0x45>
			*--d = *--s;
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	ff 4d fc             	decl   -0x4(%ebp)
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8a 10                	mov    (%eax),%dl
  800e0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e11:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e19:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	75 e3                	jne    800e03 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e20:	eb 23                	jmp    800e45 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e31:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e34:	8a 12                	mov    (%edx),%dl
  800e36:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	75 dd                	jne    800e22 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e5c:	eb 2a                	jmp    800e88 <memcmp+0x3e>
		if (*s1 != *s2)
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8a 10                	mov    (%eax),%dl
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	38 c2                	cmp    %al,%dl
  800e6a:	74 16                	je     800e82 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	0f b6 d0             	movzbl %al,%edx
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	0f b6 c0             	movzbl %al,%eax
  800e7c:	29 c2                	sub    %eax,%edx
  800e7e:	89 d0                	mov    %edx,%eax
  800e80:	eb 18                	jmp    800e9a <memcmp+0x50>
		s1++, s2++;
  800e82:	ff 45 fc             	incl   -0x4(%ebp)
  800e85:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	75 c9                	jne    800e5e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	01 d0                	add    %edx,%eax
  800eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ead:	eb 15                	jmp    800ec4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 d0             	movzbl %al,%edx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	39 c2                	cmp    %eax,%edx
  800ebf:	74 0d                	je     800ece <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eca:	72 e3                	jb     800eaf <memfind+0x13>
  800ecc:	eb 01                	jmp    800ecf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ece:	90                   	nop
	return (void *) s;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee8:	eb 03                	jmp    800eed <strtol+0x19>
		s++;
  800eea:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	3c 20                	cmp    $0x20,%al
  800ef4:	74 f4                	je     800eea <strtol+0x16>
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3c 09                	cmp    $0x9,%al
  800efd:	74 eb                	je     800eea <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 2b                	cmp    $0x2b,%al
  800f06:	75 05                	jne    800f0d <strtol+0x39>
		s++;
  800f08:	ff 45 08             	incl   0x8(%ebp)
  800f0b:	eb 13                	jmp    800f20 <strtol+0x4c>
	else if (*s == '-')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 2d                	cmp    $0x2d,%al
  800f14:	75 0a                	jne    800f20 <strtol+0x4c>
		s++, neg = 1;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f24:	74 06                	je     800f2c <strtol+0x58>
  800f26:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f2a:	75 20                	jne    800f4c <strtol+0x78>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 30                	cmp    $0x30,%al
  800f33:	75 17                	jne    800f4c <strtol+0x78>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	40                   	inc    %eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	3c 78                	cmp    $0x78,%al
  800f3d:	75 0d                	jne    800f4c <strtol+0x78>
		s += 2, base = 16;
  800f3f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f43:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f4a:	eb 28                	jmp    800f74 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 15                	jne    800f67 <strtol+0x93>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 30                	cmp    $0x30,%al
  800f59:	75 0c                	jne    800f67 <strtol+0x93>
		s++, base = 8;
  800f5b:	ff 45 08             	incl   0x8(%ebp)
  800f5e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f65:	eb 0d                	jmp    800f74 <strtol+0xa0>
	else if (base == 0)
  800f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6b:	75 07                	jne    800f74 <strtol+0xa0>
		base = 10;
  800f6d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 2f                	cmp    $0x2f,%al
  800f7b:	7e 19                	jle    800f96 <strtol+0xc2>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 39                	cmp    $0x39,%al
  800f84:	7f 10                	jg     800f96 <strtol+0xc2>
			dig = *s - '0';
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f be c0             	movsbl %al,%eax
  800f8e:	83 e8 30             	sub    $0x30,%eax
  800f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f94:	eb 42                	jmp    800fd8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 60                	cmp    $0x60,%al
  800f9d:	7e 19                	jle    800fb8 <strtol+0xe4>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3c 7a                	cmp    $0x7a,%al
  800fa6:	7f 10                	jg     800fb8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	0f be c0             	movsbl %al,%eax
  800fb0:	83 e8 57             	sub    $0x57,%eax
  800fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb6:	eb 20                	jmp    800fd8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 40                	cmp    $0x40,%al
  800fbf:	7e 39                	jle    800ffa <strtol+0x126>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 5a                	cmp    $0x5a,%al
  800fc8:	7f 30                	jg     800ffa <strtol+0x126>
			dig = *s - 'A' + 10;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 37             	sub    $0x37,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fde:	7d 19                	jge    800ff9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fe0:	ff 45 08             	incl   0x8(%ebp)
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fea:	89 c2                	mov    %eax,%edx
  800fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff4:	e9 7b ff ff ff       	jmp    800f74 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ff9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ffa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffe:	74 08                	je     801008 <strtol+0x134>
		*endptr = (char *) s;
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801008:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100c:	74 07                	je     801015 <strtol+0x141>
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	f7 d8                	neg    %eax
  801013:	eb 03                	jmp    801018 <strtol+0x144>
  801015:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801018:	c9                   	leave  
  801019:	c3                   	ret    

0080101a <ltostr>:

void
ltostr(long value, char *str)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801020:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801027:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	79 13                	jns    801047 <ltostr+0x2d>
	{
		neg = 1;
  801034:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801041:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801044:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80104f:	99                   	cltd   
  801050:	f7 f9                	idiv   %ecx
  801052:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801055:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801058:	8d 50 01             	lea    0x1(%eax),%edx
  80105b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801068:	83 c2 30             	add    $0x30,%edx
  80106b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80106d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801070:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801075:	f7 e9                	imul   %ecx
  801077:	c1 fa 02             	sar    $0x2,%edx
  80107a:	89 c8                	mov    %ecx,%eax
  80107c:	c1 f8 1f             	sar    $0x1f,%eax
  80107f:	29 c2                	sub    %eax,%edx
  801081:	89 d0                	mov    %edx,%eax
  801083:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801086:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801089:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108e:	f7 e9                	imul   %ecx
  801090:	c1 fa 02             	sar    $0x2,%edx
  801093:	89 c8                	mov    %ecx,%eax
  801095:	c1 f8 1f             	sar    $0x1f,%eax
  801098:	29 c2                	sub    %eax,%edx
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	c1 e0 02             	shl    $0x2,%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	01 c0                	add    %eax,%eax
  8010a3:	29 c1                	sub    %eax,%ecx
  8010a5:	89 ca                	mov    %ecx,%edx
  8010a7:	85 d2                	test   %edx,%edx
  8010a9:	75 9c                	jne    801047 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	48                   	dec    %eax
  8010b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010bd:	74 3d                	je     8010fc <ltostr+0xe2>
		start = 1 ;
  8010bf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c6:	eb 34                	jmp    8010fc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 c2                	add    %eax,%edx
  8010dd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	01 c8                	add    %ecx,%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	01 c2                	add    %eax,%edx
  8010f1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f4:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801102:	7c c4                	jl     8010c8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801104:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80110f:	90                   	nop
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801118:	ff 75 08             	pushl  0x8(%ebp)
  80111b:	e8 54 fa ff ff       	call   800b74 <strlen>
  801120:	83 c4 04             	add    $0x4,%esp
  801123:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801126:	ff 75 0c             	pushl  0xc(%ebp)
  801129:	e8 46 fa ff ff       	call   800b74 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801134:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80113b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801142:	eb 17                	jmp    80115b <strcconcat+0x49>
		final[s] = str1[s] ;
  801144:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 c2                	add    %eax,%edx
  80114c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	01 c8                	add    %ecx,%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801158:	ff 45 fc             	incl   -0x4(%ebp)
  80115b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801161:	7c e1                	jl     801144 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801163:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801171:	eb 1f                	jmp    801192 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801176:	8d 50 01             	lea    0x1(%eax),%edx
  801179:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	01 c2                	add    %eax,%edx
  801183:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 c8                	add    %ecx,%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80118f:	ff 45 f8             	incl   -0x8(%ebp)
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801195:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801198:	7c d9                	jl     801173 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119d:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a5:	90                   	nop
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b7:	8b 00                	mov    (%eax),%eax
  8011b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011cb:	eb 0c                	jmp    8011d9 <strsplit+0x31>
			*string++ = 0;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8d 50 01             	lea    0x1(%eax),%edx
  8011d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	84 c0                	test   %al,%al
  8011e0:	74 18                	je     8011fa <strsplit+0x52>
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	0f be c0             	movsbl %al,%eax
  8011ea:	50                   	push   %eax
  8011eb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ee:	e8 13 fb ff ff       	call   800d06 <strchr>
  8011f3:	83 c4 08             	add    $0x8,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	75 d3                	jne    8011cd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	84 c0                	test   %al,%al
  801201:	74 5a                	je     80125d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801203:	8b 45 14             	mov    0x14(%ebp),%eax
  801206:	8b 00                	mov    (%eax),%eax
  801208:	83 f8 0f             	cmp    $0xf,%eax
  80120b:	75 07                	jne    801214 <strsplit+0x6c>
		{
			return 0;
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
  801212:	eb 66                	jmp    80127a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801214:	8b 45 14             	mov    0x14(%ebp),%eax
  801217:	8b 00                	mov    (%eax),%eax
  801219:	8d 48 01             	lea    0x1(%eax),%ecx
  80121c:	8b 55 14             	mov    0x14(%ebp),%edx
  80121f:	89 0a                	mov    %ecx,(%edx)
  801221:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801228:	8b 45 10             	mov    0x10(%ebp),%eax
  80122b:	01 c2                	add    %eax,%edx
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801232:	eb 03                	jmp    801237 <strsplit+0x8f>
			string++;
  801234:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	84 c0                	test   %al,%al
  80123e:	74 8b                	je     8011cb <strsplit+0x23>
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	50                   	push   %eax
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	e8 b5 fa ff ff       	call   800d06 <strchr>
  801251:	83 c4 08             	add    $0x8,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	74 dc                	je     801234 <strsplit+0x8c>
			string++;
	}
  801258:	e9 6e ff ff ff       	jmp    8011cb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 d0                	add    %edx,%eax
  80126f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801275:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801289:	eb 4c                	jmp    8012d7 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 40                	cmp    $0x40,%al
  801297:	7e 27                	jle    8012c0 <str2lower+0x44>
  801299:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 5a                	cmp    $0x5a,%al
  8012a5:	7f 19                	jg     8012c0 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8012a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b5:	01 ca                	add    %ecx,%edx
  8012b7:	8a 12                	mov    (%edx),%dl
  8012b9:	83 c2 20             	add    $0x20,%edx
  8012bc:	88 10                	mov    %dl,(%eax)
  8012be:	eb 14                	jmp    8012d4 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8012c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	01 c2                	add    %eax,%edx
  8012c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 c8                	add    %ecx,%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8012d4:	ff 45 fc             	incl   -0x4(%ebp)
  8012d7:	ff 75 0c             	pushl  0xc(%ebp)
  8012da:	e8 95 f8 ff ff       	call   800b74 <strlen>
  8012df:	83 c4 04             	add    $0x4,%esp
  8012e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012e5:	7f a4                	jg     80128b <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8012e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	57                   	push   %edi
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801309:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80130f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801312:	cd 30                	int    $0x30
  801314:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80132e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	52                   	push   %edx
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	50                   	push   %eax
  80133e:	6a 00                	push   $0x0
  801340:	e8 b2 ff ff ff       	call   8012f7 <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_cgetc>:

int
sys_cgetc(void)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 01                	push   $0x1
  80135a:	e8 98 ff ff ff       	call   8012f7 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	52                   	push   %edx
  801374:	50                   	push   %eax
  801375:	6a 05                	push   $0x5
  801377:	e8 7b ff ff ff       	call   8012f7 <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801386:	8b 75 18             	mov    0x18(%ebp),%esi
  801389:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80138c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
  801397:	51                   	push   %ecx
  801398:	52                   	push   %edx
  801399:	50                   	push   %eax
  80139a:	6a 06                	push   $0x6
  80139c:	e8 56 ff ff ff       	call   8012f7 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	52                   	push   %edx
  8013bb:	50                   	push   %eax
  8013bc:	6a 07                	push   $0x7
  8013be:	e8 34 ff ff ff       	call   8012f7 <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	ff 75 08             	pushl  0x8(%ebp)
  8013d7:	6a 08                	push   $0x8
  8013d9:	e8 19 ff ff ff       	call   8012f7 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 09                	push   $0x9
  8013f2:	e8 00 ff ff ff       	call   8012f7 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 0a                	push   $0xa
  80140b:	e8 e7 fe ff ff       	call   8012f7 <syscall>
  801410:	83 c4 18             	add    $0x18,%esp
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 0b                	push   $0xb
  801424:	e8 ce fe ff ff       	call   8012f7 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 0c                	push   $0xc
  80143d:	e8 b5 fe ff ff       	call   8012f7 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	6a 0d                	push   $0xd
  801457:	e8 9b fe ff ff       	call   8012f7 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 0e                	push   $0xe
  801470:	e8 82 fe ff ff       	call   8012f7 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 11                	push   $0x11
  80148a:	e8 68 fe ff ff       	call   8012f7 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 12                	push   $0x12
  8014a4:	e8 4e fe ff ff       	call   8012f7 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_cputc>:


void
sys_cputc(const char c)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	50                   	push   %eax
  8014c8:	6a 13                	push   $0x13
  8014ca:	e8 28 fe ff ff       	call   8012f7 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 14                	push   $0x14
  8014e4:	e8 0e fe ff ff       	call   8012f7 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	50                   	push   %eax
  8014ff:	6a 15                	push   $0x15
  801501:	e8 f1 fd ff ff       	call   8012f7 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80150e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	52                   	push   %edx
  80151b:	50                   	push   %eax
  80151c:	6a 18                	push   $0x18
  80151e:	e8 d4 fd ff ff       	call   8012f7 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	52                   	push   %edx
  801538:	50                   	push   %eax
  801539:	6a 16                	push   $0x16
  80153b:	e8 b7 fd ff ff       	call   8012f7 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	90                   	nop
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	52                   	push   %edx
  801556:	50                   	push   %eax
  801557:	6a 17                	push   $0x17
  801559:	e8 99 fd ff ff       	call   8012f7 <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801570:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801573:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	51                   	push   %ecx
  80157d:	52                   	push   %edx
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	50                   	push   %eax
  801582:	6a 19                	push   $0x19
  801584:	e8 6e fd ff ff       	call   8012f7 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	52                   	push   %edx
  80159e:	50                   	push   %eax
  80159f:	6a 1a                	push   $0x1a
  8015a1:	e8 51 fd ff ff       	call   8012f7 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	51                   	push   %ecx
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	6a 1b                	push   $0x1b
  8015c0:	e8 32 fd ff ff       	call   8012f7 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 1c                	push   $0x1c
  8015dd:	e8 15 fd ff ff       	call   8012f7 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 1d                	push   $0x1d
  8015f6:	e8 fc fc ff ff       	call   8012f7 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	6a 00                	push   $0x0
  801608:	ff 75 14             	pushl  0x14(%ebp)
  80160b:	ff 75 10             	pushl  0x10(%ebp)
  80160e:	ff 75 0c             	pushl  0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	6a 1e                	push   $0x1e
  801614:	e8 de fc ff ff       	call   8012f7 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	50                   	push   %eax
  80162d:	6a 1f                	push   $0x1f
  80162f:	e8 c3 fc ff ff       	call   8012f7 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	50                   	push   %eax
  801649:	6a 20                	push   $0x20
  80164b:	e8 a7 fc ff ff       	call   8012f7 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 02                	push   $0x2
  801664:	e8 8e fc ff ff       	call   8012f7 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 03                	push   $0x3
  80167d:	e8 75 fc ff ff       	call   8012f7 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 04                	push   $0x4
  801696:	e8 5c fc ff ff       	call   8012f7 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_exit_env>:


void sys_exit_env(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 21                	push   $0x21
  8016af:	e8 43 fc ff ff       	call   8012f7 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	90                   	nop
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c3:	8d 50 04             	lea    0x4(%eax),%edx
  8016c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 22                	push   $0x22
  8016d3:	e8 1f fc ff ff       	call   8012f7 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return result;
  8016db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e4:	89 01                	mov    %eax,(%ecx)
  8016e6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	c9                   	leave  
  8016ed:	c2 04 00             	ret    $0x4

008016f0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	ff 75 10             	pushl  0x10(%ebp)
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	6a 10                	push   $0x10
  801702:	e8 f0 fb ff ff       	call   8012f7 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
	return ;
  80170a:	90                   	nop
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_rcr2>:
uint32 sys_rcr2()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 23                	push   $0x23
  80171c:	e8 d6 fb ff ff       	call   8012f7 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801732:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	50                   	push   %eax
  80173f:	6a 24                	push   $0x24
  801741:	e8 b1 fb ff ff       	call   8012f7 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
	return ;
  801749:	90                   	nop
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <rsttst>:
void rsttst()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 26                	push   $0x26
  80175b:	e8 97 fb ff ff       	call   8012f7 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
	return ;
  801763:	90                   	nop
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	8b 45 14             	mov    0x14(%ebp),%eax
  80176f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801772:	8b 55 18             	mov    0x18(%ebp),%edx
  801775:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801779:	52                   	push   %edx
  80177a:	50                   	push   %eax
  80177b:	ff 75 10             	pushl  0x10(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 25                	push   $0x25
  801786:	e8 6c fb ff ff       	call   8012f7 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return ;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <chktst>:
void chktst(uint32 n)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 27                	push   $0x27
  8017a1:	e8 51 fb ff ff       	call   8012f7 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a9:	90                   	nop
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <inctst>:

void inctst()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 28                	push   $0x28
  8017bb:	e8 37 fb ff ff       	call   8012f7 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c3:	90                   	nop
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <gettst>:
uint32 gettst()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 29                	push   $0x29
  8017d5:	e8 1d fb ff ff       	call   8012f7 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 2a                	push   $0x2a
  8017f1:	e8 01 fb ff ff       	call   8012f7 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
  8017f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017fc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801800:	75 07                	jne    801809 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801802:	b8 01 00 00 00       	mov    $0x1,%eax
  801807:	eb 05                	jmp    80180e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 2a                	push   $0x2a
  801822:	e8 d0 fa ff ff       	call   8012f7 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
  80182a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80182d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801831:	75 07                	jne    80183a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801833:	b8 01 00 00 00       	mov    $0x1,%eax
  801838:	eb 05                	jmp    80183f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 2a                	push   $0x2a
  801853:	e8 9f fa ff ff       	call   8012f7 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
  80185b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80185e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801862:	75 07                	jne    80186b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	eb 05                	jmp    801870 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 2a                	push   $0x2a
  801884:	e8 6e fa ff ff       	call   8012f7 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
  80188c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80188f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801893:	75 07                	jne    80189c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	eb 05                	jmp    8018a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 2b                	push   $0x2b
  8018b3:	e8 3f fa ff ff       	call   8012f7 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	53                   	push   %ebx
  8018d1:	51                   	push   %ecx
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 2c                	push   $0x2c
  8018d6:	e8 1c fa ff ff       	call   8012f7 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 2d                	push   $0x2d
  8018f6:	e8 fc f9 ff ff       	call   8012f7 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801903:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	51                   	push   %ecx
  80190f:	ff 75 10             	pushl  0x10(%ebp)
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 2e                	push   $0x2e
  801916:	e8 dc f9 ff ff       	call   8012f7 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 10             	pushl  0x10(%ebp)
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 0f                	push   $0xf
  801932:	e8 c0 f9 ff ff       	call   8012f7 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
	return ;
  80193a:	90                   	nop
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	50                   	push   %eax
  80194c:	6a 2f                	push   $0x2f
  80194e:	e8 a4 f9 ff ff       	call   8012f7 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp

}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 30                	push   $0x30
  801969:	e8 89 f9 ff ff       	call   8012f7 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp

}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 31                	push   $0x31
  801985:	e8 6d f9 ff ff       	call   8012f7 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp

}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 32                	push   $0x32
  80199f:	e8 53 f9 ff ff       	call   8012f7 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	50                   	push   %eax
  8019bd:	e8 ed fa ff ff       	call   8014af <sys_cputc>
  8019c2:	83 c4 10             	add    $0x10,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019ce:	e8 a8 fa ff ff       	call   80147b <sys_disable_interrupt>
	char c = ch;
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019d9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	50                   	push   %eax
  8019e1:	e8 c9 fa ff ff       	call   8014af <sys_cputc>
  8019e6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019e9:	e8 a7 fa ff ff       	call   801495 <sys_enable_interrupt>
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <getchar>:

int
getchar(void)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019fe:	eb 08                	jmp    801a08 <getchar+0x17>
	{
		c = sys_cgetc();
  801a00:	e8 46 f9 ff ff       	call   80134b <sys_cgetc>
  801a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0c:	74 f2                	je     801a00 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <atomic_getchar>:

int
atomic_getchar(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a19:	e8 5d fa ff ff       	call   80147b <sys_disable_interrupt>
	int c=0;
  801a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a25:	eb 08                	jmp    801a2f <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a27:	e8 1f f9 ff ff       	call   80134b <sys_cgetc>
  801a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a33:	74 f2                	je     801a27 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a35:	e8 5b fa ff ff       	call   801495 <sys_enable_interrupt>
	return c;
  801a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <iscons>:

int iscons(int fdnum)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a42:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    
  801a49:	66 90                	xchg   %ax,%ax
  801a4b:	90                   	nop

00801a4c <__udivdi3>:
  801a4c:	55                   	push   %ebp
  801a4d:	57                   	push   %edi
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 1c             	sub    $0x1c,%esp
  801a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a63:	89 ca                	mov    %ecx,%edx
  801a65:	89 f8                	mov    %edi,%eax
  801a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a6b:	85 f6                	test   %esi,%esi
  801a6d:	75 2d                	jne    801a9c <__udivdi3+0x50>
  801a6f:	39 cf                	cmp    %ecx,%edi
  801a71:	77 65                	ja     801ad8 <__udivdi3+0x8c>
  801a73:	89 fd                	mov    %edi,%ebp
  801a75:	85 ff                	test   %edi,%edi
  801a77:	75 0b                	jne    801a84 <__udivdi3+0x38>
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	31 d2                	xor    %edx,%edx
  801a80:	f7 f7                	div    %edi
  801a82:	89 c5                	mov    %eax,%ebp
  801a84:	31 d2                	xor    %edx,%edx
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	f7 f5                	div    %ebp
  801a8a:	89 c1                	mov    %eax,%ecx
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	f7 f5                	div    %ebp
  801a90:	89 cf                	mov    %ecx,%edi
  801a92:	89 fa                	mov    %edi,%edx
  801a94:	83 c4 1c             	add    $0x1c,%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5f                   	pop    %edi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	77 28                	ja     801ac8 <__udivdi3+0x7c>
  801aa0:	0f bd fe             	bsr    %esi,%edi
  801aa3:	83 f7 1f             	xor    $0x1f,%edi
  801aa6:	75 40                	jne    801ae8 <__udivdi3+0x9c>
  801aa8:	39 ce                	cmp    %ecx,%esi
  801aaa:	72 0a                	jb     801ab6 <__udivdi3+0x6a>
  801aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ab0:	0f 87 9e 00 00 00    	ja     801b54 <__udivdi3+0x108>
  801ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  801abb:	89 fa                	mov    %edi,%edx
  801abd:	83 c4 1c             	add    $0x1c,%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    
  801ac5:	8d 76 00             	lea    0x0(%esi),%esi
  801ac8:	31 ff                	xor    %edi,%edi
  801aca:	31 c0                	xor    %eax,%eax
  801acc:	89 fa                	mov    %edi,%edx
  801ace:	83 c4 1c             	add    $0x1c,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5f                   	pop    %edi
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    
  801ad6:	66 90                	xchg   %ax,%ax
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	f7 f7                	div    %edi
  801adc:	31 ff                	xor    %edi,%edi
  801ade:	89 fa                	mov    %edi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aed:	89 eb                	mov    %ebp,%ebx
  801aef:	29 fb                	sub    %edi,%ebx
  801af1:	89 f9                	mov    %edi,%ecx
  801af3:	d3 e6                	shl    %cl,%esi
  801af5:	89 c5                	mov    %eax,%ebp
  801af7:	88 d9                	mov    %bl,%cl
  801af9:	d3 ed                	shr    %cl,%ebp
  801afb:	89 e9                	mov    %ebp,%ecx
  801afd:	09 f1                	or     %esi,%ecx
  801aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e0                	shl    %cl,%eax
  801b07:	89 c5                	mov    %eax,%ebp
  801b09:	89 d6                	mov    %edx,%esi
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 ee                	shr    %cl,%esi
  801b0f:	89 f9                	mov    %edi,%ecx
  801b11:	d3 e2                	shl    %cl,%edx
  801b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b17:	88 d9                	mov    %bl,%cl
  801b19:	d3 e8                	shr    %cl,%eax
  801b1b:	09 c2                	or     %eax,%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	89 f2                	mov    %esi,%edx
  801b21:	f7 74 24 0c          	divl   0xc(%esp)
  801b25:	89 d6                	mov    %edx,%esi
  801b27:	89 c3                	mov    %eax,%ebx
  801b29:	f7 e5                	mul    %ebp
  801b2b:	39 d6                	cmp    %edx,%esi
  801b2d:	72 19                	jb     801b48 <__udivdi3+0xfc>
  801b2f:	74 0b                	je     801b3c <__udivdi3+0xf0>
  801b31:	89 d8                	mov    %ebx,%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 58 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b40:	89 f9                	mov    %edi,%ecx
  801b42:	d3 e2                	shl    %cl,%edx
  801b44:	39 c2                	cmp    %eax,%edx
  801b46:	73 e9                	jae    801b31 <__udivdi3+0xe5>
  801b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b4b:	31 ff                	xor    %edi,%edi
  801b4d:	e9 40 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b52:	66 90                	xchg   %ax,%ax
  801b54:	31 c0                	xor    %eax,%eax
  801b56:	e9 37 ff ff ff       	jmp    801a92 <__udivdi3+0x46>
  801b5b:	90                   	nop

00801b5c <__umoddi3>:
  801b5c:	55                   	push   %ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b7b:	89 f3                	mov    %esi,%ebx
  801b7d:	89 fa                	mov    %edi,%edx
  801b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b83:	89 34 24             	mov    %esi,(%esp)
  801b86:	85 c0                	test   %eax,%eax
  801b88:	75 1a                	jne    801ba4 <__umoddi3+0x48>
  801b8a:	39 f7                	cmp    %esi,%edi
  801b8c:	0f 86 a2 00 00 00    	jbe    801c34 <__umoddi3+0xd8>
  801b92:	89 c8                	mov    %ecx,%eax
  801b94:	89 f2                	mov    %esi,%edx
  801b96:	f7 f7                	div    %edi
  801b98:	89 d0                	mov    %edx,%eax
  801b9a:	31 d2                	xor    %edx,%edx
  801b9c:	83 c4 1c             	add    $0x1c,%esp
  801b9f:	5b                   	pop    %ebx
  801ba0:	5e                   	pop    %esi
  801ba1:	5f                   	pop    %edi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    
  801ba4:	39 f0                	cmp    %esi,%eax
  801ba6:	0f 87 ac 00 00 00    	ja     801c58 <__umoddi3+0xfc>
  801bac:	0f bd e8             	bsr    %eax,%ebp
  801baf:	83 f5 1f             	xor    $0x1f,%ebp
  801bb2:	0f 84 ac 00 00 00    	je     801c64 <__umoddi3+0x108>
  801bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  801bbd:	29 ef                	sub    %ebp,%edi
  801bbf:	89 fe                	mov    %edi,%esi
  801bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e0                	shl    %cl,%eax
  801bc9:	89 d7                	mov    %edx,%edi
  801bcb:	89 f1                	mov    %esi,%ecx
  801bcd:	d3 ef                	shr    %cl,%edi
  801bcf:	09 c7                	or     %eax,%edi
  801bd1:	89 e9                	mov    %ebp,%ecx
  801bd3:	d3 e2                	shl    %cl,%edx
  801bd5:	89 14 24             	mov    %edx,(%esp)
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	d3 e0                	shl    %cl,%eax
  801bdc:	89 c2                	mov    %eax,%edx
  801bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be2:	d3 e0                	shl    %cl,%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bec:	89 f1                	mov    %esi,%ecx
  801bee:	d3 e8                	shr    %cl,%eax
  801bf0:	09 d0                	or     %edx,%eax
  801bf2:	d3 eb                	shr    %cl,%ebx
  801bf4:	89 da                	mov    %ebx,%edx
  801bf6:	f7 f7                	div    %edi
  801bf8:	89 d3                	mov    %edx,%ebx
  801bfa:	f7 24 24             	mull   (%esp)
  801bfd:	89 c6                	mov    %eax,%esi
  801bff:	89 d1                	mov    %edx,%ecx
  801c01:	39 d3                	cmp    %edx,%ebx
  801c03:	0f 82 87 00 00 00    	jb     801c90 <__umoddi3+0x134>
  801c09:	0f 84 91 00 00 00    	je     801ca0 <__umoddi3+0x144>
  801c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c13:	29 f2                	sub    %esi,%edx
  801c15:	19 cb                	sbb    %ecx,%ebx
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c1d:	d3 e0                	shl    %cl,%eax
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	d3 ea                	shr    %cl,%edx
  801c23:	09 d0                	or     %edx,%eax
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 eb                	shr    %cl,%ebx
  801c29:	89 da                	mov    %ebx,%edx
  801c2b:	83 c4 1c             	add    $0x1c,%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5f                   	pop    %edi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    
  801c33:	90                   	nop
  801c34:	89 fd                	mov    %edi,%ebp
  801c36:	85 ff                	test   %edi,%edi
  801c38:	75 0b                	jne    801c45 <__umoddi3+0xe9>
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	31 d2                	xor    %edx,%edx
  801c41:	f7 f7                	div    %edi
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 f0                	mov    %esi,%eax
  801c47:	31 d2                	xor    %edx,%edx
  801c49:	f7 f5                	div    %ebp
  801c4b:	89 c8                	mov    %ecx,%eax
  801c4d:	f7 f5                	div    %ebp
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	e9 44 ff ff ff       	jmp    801b9a <__umoddi3+0x3e>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	89 c8                	mov    %ecx,%eax
  801c5a:	89 f2                	mov    %esi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	3b 04 24             	cmp    (%esp),%eax
  801c67:	72 06                	jb     801c6f <__umoddi3+0x113>
  801c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c6d:	77 0f                	ja     801c7e <__umoddi3+0x122>
  801c6f:	89 f2                	mov    %esi,%edx
  801c71:	29 f9                	sub    %edi,%ecx
  801c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c77:	89 14 24             	mov    %edx,(%esp)
  801c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c82:	8b 14 24             	mov    (%esp),%edx
  801c85:	83 c4 1c             	add    $0x1c,%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
  801c8d:	8d 76 00             	lea    0x0(%esi),%esi
  801c90:	2b 04 24             	sub    (%esp),%eax
  801c93:	19 fa                	sbb    %edi,%edx
  801c95:	89 d1                	mov    %edx,%ecx
  801c97:	89 c6                	mov    %eax,%esi
  801c99:	e9 71 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ca4:	72 ea                	jb     801c90 <__umoddi3+0x134>
  801ca6:	89 d9                	mov    %ebx,%ecx
  801ca8:	e9 62 ff ff ff       	jmp    801c0f <__umoddi3+0xb3>
