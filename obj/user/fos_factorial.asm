
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 1c 80 00       	push   $0x801ca0
  800057:	e8 fa 09 00 00       	call   800a56 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 4c 0e 00 00       	call   800ebe <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 b7 1c 80 00       	push   $0x801cb7
  800097:	e8 67 02 00 00       	call   800303 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000d1:	e8 82 15 00 00       	call   801658 <sys_getenvindex>
  8000d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000dc:	89 d0                	mov    %edx,%eax
  8000de:	c1 e0 03             	shl    $0x3,%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	01 c0                	add    %eax,%eax
  8000e5:	01 d0                	add    %edx,%eax
  8000e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ee:	01 d0                	add    %edx,%eax
  8000f0:	c1 e0 04             	shl    $0x4,%eax
  8000f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800102:	8a 40 5c             	mov    0x5c(%eax),%al
  800105:	84 c0                	test   %al,%al
  800107:	74 0d                	je     800116 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800109:	a1 20 30 80 00       	mov    0x803020,%eax
  80010e:	83 c0 5c             	add    $0x5c,%eax
  800111:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011a:	7e 0a                	jle    800126 <libmain+0x5b>
		binaryname = argv[0];
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	8b 00                	mov    (%eax),%eax
  800121:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	ff 75 0c             	pushl  0xc(%ebp)
  80012c:	ff 75 08             	pushl  0x8(%ebp)
  80012f:	e8 04 ff ff ff       	call   800038 <_main>
  800134:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800137:	e8 29 13 00 00       	call   801465 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	68 e4 1c 80 00       	push   $0x801ce4
  800144:	e8 8d 01 00 00       	call   8002d6 <cprintf>
  800149:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800157:	a1 20 30 80 00       	mov    0x803020,%eax
  80015c:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	68 0c 1d 80 00       	push   $0x801d0c
  80016c:	e8 65 01 00 00       	call   8002d6 <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800174:	a1 20 30 80 00       	mov    0x803020,%eax
  800179:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80018a:	a1 20 30 80 00       	mov    0x803020,%eax
  80018f:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800195:	51                   	push   %ecx
  800196:	52                   	push   %edx
  800197:	50                   	push   %eax
  800198:	68 34 1d 80 00       	push   $0x801d34
  80019d:	e8 34 01 00 00       	call   8002d6 <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001aa:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	50                   	push   %eax
  8001b4:	68 8c 1d 80 00       	push   $0x801d8c
  8001b9:	e8 18 01 00 00       	call   8002d6 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 e4 1c 80 00       	push   $0x801ce4
  8001c9:	e8 08 01 00 00       	call   8002d6 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d1:	e8 a9 12 00 00       	call   80147f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001d6:	e8 19 00 00 00       	call   8001f4 <exit>
}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	6a 00                	push   $0x0
  8001e9:	e8 36 14 00 00       	call   801624 <sys_destroy_env>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <exit>:

void
exit(void)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fa:	e8 8b 14 00 00       	call   80168a <sys_exit_env>
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	8b 00                	mov    (%eax),%eax
  80020d:	8d 48 01             	lea    0x1(%eax),%ecx
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	89 0a                	mov    %ecx,(%edx)
  800215:	8b 55 08             	mov    0x8(%ebp),%edx
  800218:	88 d1                	mov    %dl,%cl
  80021a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022b:	75 2c                	jne    800259 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80022d:	a0 24 30 80 00       	mov    0x803024,%al
  800232:	0f b6 c0             	movzbl %al,%eax
  800235:	8b 55 0c             	mov    0xc(%ebp),%edx
  800238:	8b 12                	mov    (%edx),%edx
  80023a:	89 d1                	mov    %edx,%ecx
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	83 c2 08             	add    $0x8,%edx
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	50                   	push   %eax
  800246:	51                   	push   %ecx
  800247:	52                   	push   %edx
  800248:	e8 bf 10 00 00       	call   80130c <sys_cputs>
  80024d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025c:	8b 40 04             	mov    0x4(%eax),%eax
  80025f:	8d 50 01             	lea    0x1(%eax),%edx
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
  800265:	89 50 04             	mov    %edx,0x4(%eax)
}
  800268:	90                   	nop
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800274:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027b:	00 00 00 
	b.cnt = 0;
  80027e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800285:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800288:	ff 75 0c             	pushl  0xc(%ebp)
  80028b:	ff 75 08             	pushl  0x8(%ebp)
  80028e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800294:	50                   	push   %eax
  800295:	68 02 02 80 00       	push   $0x800202
  80029a:	e8 11 02 00 00       	call   8004b0 <vprintfmt>
  80029f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a2:	a0 24 30 80 00       	mov    0x803024,%al
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	50                   	push   %eax
  8002b4:	52                   	push   %edx
  8002b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002bb:	83 c0 08             	add    $0x8,%eax
  8002be:	50                   	push   %eax
  8002bf:	e8 48 10 00 00       	call   80130c <sys_cputs>
  8002c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002c7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002dc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f2:	50                   	push   %eax
  8002f3:	e8 73 ff ff ff       	call   80026b <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800309:	e8 57 11 00 00       	call   801465 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800311:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800314:	8b 45 08             	mov    0x8(%ebp),%eax
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	ff 75 f4             	pushl  -0xc(%ebp)
  80031d:	50                   	push   %eax
  80031e:	e8 48 ff ff ff       	call   80026b <vcprintf>
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800329:	e8 51 11 00 00       	call   80147f <sys_enable_interrupt>
	return cnt;
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	53                   	push   %ebx
  800337:	83 ec 14             	sub    $0x14,%esp
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800340:	8b 45 14             	mov    0x14(%ebp),%eax
  800343:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800346:	8b 45 18             	mov    0x18(%ebp),%eax
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800351:	77 55                	ja     8003a8 <printnum+0x75>
  800353:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800356:	72 05                	jb     80035d <printnum+0x2a>
  800358:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035b:	77 4b                	ja     8003a8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800360:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800363:	8b 45 18             	mov    0x18(%ebp),%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	ff 75 f4             	pushl  -0xc(%ebp)
  800370:	ff 75 f0             	pushl  -0x10(%ebp)
  800373:	e8 bc 16 00 00       	call   801a34 <__udivdi3>
  800378:	83 c4 10             	add    $0x10,%esp
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	ff 75 20             	pushl  0x20(%ebp)
  800381:	53                   	push   %ebx
  800382:	ff 75 18             	pushl  0x18(%ebp)
  800385:	52                   	push   %edx
  800386:	50                   	push   %eax
  800387:	ff 75 0c             	pushl  0xc(%ebp)
  80038a:	ff 75 08             	pushl  0x8(%ebp)
  80038d:	e8 a1 ff ff ff       	call   800333 <printnum>
  800392:	83 c4 20             	add    $0x20,%esp
  800395:	eb 1a                	jmp    8003b1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	ff 75 0c             	pushl  0xc(%ebp)
  80039d:	ff 75 20             	pushl  0x20(%ebp)
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	ff d0                	call   *%eax
  8003a5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003af:	7f e6                	jg     800397 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003bf:	53                   	push   %ebx
  8003c0:	51                   	push   %ecx
  8003c1:	52                   	push   %edx
  8003c2:	50                   	push   %eax
  8003c3:	e8 7c 17 00 00       	call   801b44 <__umoddi3>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  8003d0:	8a 00                	mov    (%eax),%al
  8003d2:	0f be c0             	movsbl %al,%eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 0c             	pushl  0xc(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	ff d0                	call   *%eax
  8003e1:	83 c4 10             	add    $0x10,%esp
}
  8003e4:	90                   	nop
  8003e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

008003ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f1:	7e 1c                	jle    80040f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	8d 50 08             	lea    0x8(%eax),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	89 10                	mov    %edx,(%eax)
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	83 e8 08             	sub    $0x8,%eax
  800408:	8b 50 04             	mov    0x4(%eax),%edx
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	eb 40                	jmp    80044f <getuint+0x65>
	else if (lflag)
  80040f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800413:	74 1e                	je     800433 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	89 10                	mov    %edx,(%eax)
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	83 e8 04             	sub    $0x4,%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	ba 00 00 00 00       	mov    $0x0,%edx
  800431:	eb 1c                	jmp    80044f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	8d 50 04             	lea    0x4(%eax),%edx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	83 e8 04             	sub    $0x4,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80044f:	5d                   	pop    %ebp
  800450:	c3                   	ret    

00800451 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800454:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800458:	7e 1c                	jle    800476 <getint+0x25>
		return va_arg(*ap, long long);
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	8d 50 08             	lea    0x8(%eax),%edx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	89 10                	mov    %edx,(%eax)
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	83 e8 08             	sub    $0x8,%eax
  80046f:	8b 50 04             	mov    0x4(%eax),%edx
  800472:	8b 00                	mov    (%eax),%eax
  800474:	eb 38                	jmp    8004ae <getint+0x5d>
	else if (lflag)
  800476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047a:	74 1a                	je     800496 <getint+0x45>
		return va_arg(*ap, long);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 50 04             	lea    0x4(%eax),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 10                	mov    %edx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	83 e8 04             	sub    $0x4,%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	99                   	cltd   
  800494:	eb 18                	jmp    8004ae <getint+0x5d>
	else
		return va_arg(*ap, int);
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	8d 50 04             	lea    0x4(%eax),%edx
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 10                	mov    %edx,(%eax)
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	83 e8 04             	sub    $0x4,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	99                   	cltd   
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	56                   	push   %esi
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b8:	eb 17                	jmp    8004d1 <vprintfmt+0x21>
			if (ch == '\0')
  8004ba:	85 db                	test   %ebx,%ebx
  8004bc:	0f 84 af 03 00 00    	je     800871 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	ff 75 0c             	pushl  0xc(%ebp)
  8004c8:	53                   	push   %ebx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	ff d0                	call   *%eax
  8004ce:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d4:	8d 50 01             	lea    0x1(%eax),%edx
  8004d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8004da:	8a 00                	mov    (%eax),%al
  8004dc:	0f b6 d8             	movzbl %al,%ebx
  8004df:	83 fb 25             	cmp    $0x25,%ebx
  8004e2:	75 d6                	jne    8004ba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004e4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 45 10             	mov    0x10(%ebp),%eax
  800507:	8d 50 01             	lea    0x1(%eax),%edx
  80050a:	89 55 10             	mov    %edx,0x10(%ebp)
  80050d:	8a 00                	mov    (%eax),%al
  80050f:	0f b6 d8             	movzbl %al,%ebx
  800512:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800515:	83 f8 55             	cmp    $0x55,%eax
  800518:	0f 87 2b 03 00 00    	ja     800849 <vprintfmt+0x399>
  80051e:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  800525:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800527:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80052b:	eb d7                	jmp    800504 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80052d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800531:	eb d1                	jmp    800504 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80053a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053d:	89 d0                	mov    %edx,%eax
  80053f:	c1 e0 02             	shl    $0x2,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	01 c0                	add    %eax,%eax
  800546:	01 d8                	add    %ebx,%eax
  800548:	83 e8 30             	sub    $0x30,%eax
  80054b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80054e:	8b 45 10             	mov    0x10(%ebp),%eax
  800551:	8a 00                	mov    (%eax),%al
  800553:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800556:	83 fb 2f             	cmp    $0x2f,%ebx
  800559:	7e 3e                	jle    800599 <vprintfmt+0xe9>
  80055b:	83 fb 39             	cmp    $0x39,%ebx
  80055e:	7f 39                	jg     800599 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800560:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800563:	eb d5                	jmp    80053a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	83 c0 04             	add    $0x4,%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 e8 04             	sub    $0x4,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800579:	eb 1f                	jmp    80059a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80057b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057f:	79 83                	jns    800504 <vprintfmt+0x54>
				width = 0;
  800581:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800588:	e9 77 ff ff ff       	jmp    800504 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80058d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800594:	e9 6b ff ff ff       	jmp    800504 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800599:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80059a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059e:	0f 89 60 ff ff ff    	jns    800504 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b1:	e9 4e ff ff ff       	jmp    800504 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b9:	e9 46 ff ff ff       	jmp    800504 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 c0 04             	add    $0x4,%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	ff d0                	call   *%eax
  8005db:	83 c4 10             	add    $0x10,%esp
			break;
  8005de:	e9 89 02 00 00       	jmp    80086c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 c0 04             	add    $0x4,%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	83 e8 04             	sub    $0x4,%eax
  8005f2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005f4:	85 db                	test   %ebx,%ebx
  8005f6:	79 02                	jns    8005fa <vprintfmt+0x14a>
				err = -err;
  8005f8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005fa:	83 fb 64             	cmp    $0x64,%ebx
  8005fd:	7f 0b                	jg     80060a <vprintfmt+0x15a>
  8005ff:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  800606:	85 f6                	test   %esi,%esi
  800608:	75 19                	jne    800623 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80060a:	53                   	push   %ebx
  80060b:	68 c5 1f 80 00       	push   $0x801fc5
  800610:	ff 75 0c             	pushl  0xc(%ebp)
  800613:	ff 75 08             	pushl  0x8(%ebp)
  800616:	e8 5e 02 00 00       	call   800879 <printfmt>
  80061b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80061e:	e9 49 02 00 00       	jmp    80086c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800623:	56                   	push   %esi
  800624:	68 ce 1f 80 00       	push   $0x801fce
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	ff 75 08             	pushl  0x8(%ebp)
  80062f:	e8 45 02 00 00       	call   800879 <printfmt>
  800634:	83 c4 10             	add    $0x10,%esp
			break;
  800637:	e9 30 02 00 00       	jmp    80086c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 c0 04             	add    $0x4,%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	83 e8 04             	sub    $0x4,%eax
  80064b:	8b 30                	mov    (%eax),%esi
  80064d:	85 f6                	test   %esi,%esi
  80064f:	75 05                	jne    800656 <vprintfmt+0x1a6>
				p = "(null)";
  800651:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  800656:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065a:	7e 6d                	jle    8006c9 <vprintfmt+0x219>
  80065c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800660:	74 67                	je     8006c9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	50                   	push   %eax
  800669:	56                   	push   %esi
  80066a:	e8 12 05 00 00       	call   800b81 <strnlen>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800675:	eb 16                	jmp    80068d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800677:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	50                   	push   %eax
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	ff d0                	call   *%eax
  800687:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80068a:	ff 4d e4             	decl   -0x1c(%ebp)
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800691:	7f e4                	jg     800677 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800693:	eb 34                	jmp    8006c9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800695:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800699:	74 1c                	je     8006b7 <vprintfmt+0x207>
  80069b:	83 fb 1f             	cmp    $0x1f,%ebx
  80069e:	7e 05                	jle    8006a5 <vprintfmt+0x1f5>
  8006a0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006a3:	7e 12                	jle    8006b7 <vprintfmt+0x207>
					putch('?', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	6a 3f                	push   $0x3f
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	ff d0                	call   *%eax
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	eb 0f                	jmp    8006c6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	53                   	push   %ebx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c9:	89 f0                	mov    %esi,%eax
  8006cb:	8d 70 01             	lea    0x1(%eax),%esi
  8006ce:	8a 00                	mov    (%eax),%al
  8006d0:	0f be d8             	movsbl %al,%ebx
  8006d3:	85 db                	test   %ebx,%ebx
  8006d5:	74 24                	je     8006fb <vprintfmt+0x24b>
  8006d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006db:	78 b8                	js     800695 <vprintfmt+0x1e5>
  8006dd:	ff 4d e0             	decl   -0x20(%ebp)
  8006e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e4:	79 af                	jns    800695 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e6:	eb 13                	jmp    8006fb <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	6a 20                	push   $0x20
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	ff d0                	call   *%eax
  8006f5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7f e7                	jg     8006e8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800701:	e9 66 01 00 00       	jmp    80086c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 e8             	pushl  -0x18(%ebp)
  80070c:	8d 45 14             	lea    0x14(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	e8 3c fd ff ff       	call   800451 <getint>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80071e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800724:	85 d2                	test   %edx,%edx
  800726:	79 23                	jns    80074b <vprintfmt+0x29b>
				putch('-', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	6a 2d                	push   $0x2d
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073e:	f7 d8                	neg    %eax
  800740:	83 d2 00             	adc    $0x0,%edx
  800743:	f7 da                	neg    %edx
  800745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800748:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80074b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800752:	e9 bc 00 00 00       	jmp    800813 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 e8             	pushl  -0x18(%ebp)
  80075d:	8d 45 14             	lea    0x14(%ebp),%eax
  800760:	50                   	push   %eax
  800761:	e8 84 fc ff ff       	call   8003ea <getuint>
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80076f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800776:	e9 98 00 00 00       	jmp    800813 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	6a 58                	push   $0x58
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	6a 58                	push   $0x58
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	6a 58                	push   $0x58
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
			break;
  8007ab:	e9 bc 00 00 00       	jmp    80086c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	6a 30                	push   $0x30
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	ff d0                	call   *%eax
  8007bd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	6a 78                	push   $0x78
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	83 c0 04             	add    $0x4,%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 e8 04             	sub    $0x4,%eax
  8007df:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f2:	eb 1f                	jmp    800813 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fd:	50                   	push   %eax
  8007fe:	e8 e7 fb ff ff       	call   8003ea <getuint>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800809:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80080c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800813:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	52                   	push   %edx
  80081e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800821:	50                   	push   %eax
  800822:	ff 75 f4             	pushl  -0xc(%ebp)
  800825:	ff 75 f0             	pushl  -0x10(%ebp)
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 00 fb ff ff       	call   800333 <printnum>
  800833:	83 c4 20             	add    $0x20,%esp
			break;
  800836:	eb 34                	jmp    80086c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	53                   	push   %ebx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			break;
  800847:	eb 23                	jmp    80086c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	6a 25                	push   $0x25
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
  800856:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800859:	ff 4d 10             	decl   0x10(%ebp)
  80085c:	eb 03                	jmp    800861 <vprintfmt+0x3b1>
  80085e:	ff 4d 10             	decl   0x10(%ebp)
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	48                   	dec    %eax
  800865:	8a 00                	mov    (%eax),%al
  800867:	3c 25                	cmp    $0x25,%al
  800869:	75 f3                	jne    80085e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80086b:	90                   	nop
		}
	}
  80086c:	e9 47 fc ff ff       	jmp    8004b8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800871:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800872:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80087f:	8d 45 10             	lea    0x10(%ebp),%eax
  800882:	83 c0 04             	add    $0x4,%eax
  800885:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800888:	8b 45 10             	mov    0x10(%ebp),%eax
  80088b:	ff 75 f4             	pushl  -0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 16 fc ff ff       	call   8004b0 <vprintfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80089d:	90                   	nop
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	8b 40 08             	mov    0x8(%eax),%eax
  8008a9:	8d 50 01             	lea    0x1(%eax),%edx
  8008ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008af:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 10                	mov    (%eax),%edx
  8008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ba:	8b 40 04             	mov    0x4(%eax),%eax
  8008bd:	39 c2                	cmp    %eax,%edx
  8008bf:	73 12                	jae    8008d3 <sprintputch+0x33>
		*b->buf++ = ch;
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 0a                	mov    %ecx,(%edx)
  8008ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d1:	88 10                	mov    %dl,(%eax)
}
  8008d3:	90                   	nop
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	01 d0                	add    %edx,%eax
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008fb:	74 06                	je     800903 <vsnprintf+0x2d>
  8008fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800901:	7f 07                	jg     80090a <vsnprintf+0x34>
		return -E_INVAL;
  800903:	b8 03 00 00 00       	mov    $0x3,%eax
  800908:	eb 20                	jmp    80092a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090a:	ff 75 14             	pushl  0x14(%ebp)
  80090d:	ff 75 10             	pushl  0x10(%ebp)
  800910:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800913:	50                   	push   %eax
  800914:	68 a0 08 80 00       	push   $0x8008a0
  800919:	e8 92 fb ff ff       	call   8004b0 <vprintfmt>
  80091e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800924:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800932:	8d 45 10             	lea    0x10(%ebp),%eax
  800935:	83 c0 04             	add    $0x4,%eax
  800938:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80093b:	8b 45 10             	mov    0x10(%ebp),%eax
  80093e:	ff 75 f4             	pushl  -0xc(%ebp)
  800941:	50                   	push   %eax
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 89 ff ff ff       	call   8008d6 <vsnprintf>
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800953:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80095e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800962:	74 13                	je     800977 <readline+0x1f>
		cprintf("%s", prompt);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	68 30 21 80 00       	push   $0x802130
  80096f:	e8 62 f9 ff ff       	call   8002d6 <cprintf>
  800974:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800977:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80097e:	83 ec 0c             	sub    $0xc,%esp
  800981:	6a 00                	push   $0x0
  800983:	e8 a1 10 00 00       	call   801a29 <iscons>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80098e:	e8 48 10 00 00       	call   8019db <getchar>
  800993:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800996:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80099a:	79 22                	jns    8009be <readline+0x66>
			if (c != -E_EOF)
  80099c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009a0:	0f 84 ad 00 00 00    	je     800a53 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ac:	68 33 21 80 00       	push   $0x802133
  8009b1:	e8 20 f9 ff ff       	call   8002d6 <cprintf>
  8009b6:	83 c4 10             	add    $0x10,%esp
			return;
  8009b9:	e9 95 00 00 00       	jmp    800a53 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009be:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009c2:	7e 34                	jle    8009f8 <readline+0xa0>
  8009c4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009cb:	7f 2b                	jg     8009f8 <readline+0xa0>
			if (echoing)
  8009cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d1:	74 0e                	je     8009e1 <readline+0x89>
				cputchar(c);
  8009d3:	83 ec 0c             	sub    $0xc,%esp
  8009d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8009d9:	e8 b5 0f 00 00       	call   801993 <cputchar>
  8009de:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e4:	8d 50 01             	lea    0x1(%eax),%edx
  8009e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009ea:	89 c2                	mov    %eax,%edx
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	01 d0                	add    %edx,%eax
  8009f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009f4:	88 10                	mov    %dl,(%eax)
  8009f6:	eb 56                	jmp    800a4e <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8009f8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8009fc:	75 1f                	jne    800a1d <readline+0xc5>
  8009fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a02:	7e 19                	jle    800a1d <readline+0xc5>
			if (echoing)
  800a04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a08:	74 0e                	je     800a18 <readline+0xc0>
				cputchar(c);
  800a0a:	83 ec 0c             	sub    $0xc,%esp
  800a0d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a10:	e8 7e 0f 00 00       	call   801993 <cputchar>
  800a15:	83 c4 10             	add    $0x10,%esp

			i--;
  800a18:	ff 4d f4             	decl   -0xc(%ebp)
  800a1b:	eb 31                	jmp    800a4e <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a1d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a21:	74 0a                	je     800a2d <readline+0xd5>
  800a23:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a27:	0f 85 61 ff ff ff    	jne    80098e <readline+0x36>
			if (echoing)
  800a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a31:	74 0e                	je     800a41 <readline+0xe9>
				cputchar(c);
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	ff 75 ec             	pushl  -0x14(%ebp)
  800a39:	e8 55 0f 00 00       	call   801993 <cputchar>
  800a3e:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	01 d0                	add    %edx,%eax
  800a49:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a4c:	eb 06                	jmp    800a54 <readline+0xfc>
		}
	}
  800a4e:	e9 3b ff ff ff       	jmp    80098e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a53:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a5c:	e8 04 0a 00 00       	call   801465 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a65:	74 13                	je     800a7a <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	68 30 21 80 00       	push   $0x802130
  800a72:	e8 5f f8 ff ff       	call   8002d6 <cprintf>
  800a77:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a81:	83 ec 0c             	sub    $0xc,%esp
  800a84:	6a 00                	push   $0x0
  800a86:	e8 9e 0f 00 00       	call   801a29 <iscons>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a91:	e8 45 0f 00 00       	call   8019db <getchar>
  800a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a9d:	79 23                	jns    800ac2 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800a9f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aa3:	74 13                	je     800ab8 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 ec             	pushl  -0x14(%ebp)
  800aab:	68 33 21 80 00       	push   $0x802133
  800ab0:	e8 21 f8 ff ff       	call   8002d6 <cprintf>
  800ab5:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ab8:	e8 c2 09 00 00       	call   80147f <sys_enable_interrupt>
			return;
  800abd:	e9 9a 00 00 00       	jmp    800b5c <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ac6:	7e 34                	jle    800afc <atomic_readline+0xa6>
  800ac8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800acf:	7f 2b                	jg     800afc <atomic_readline+0xa6>
			if (echoing)
  800ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ad5:	74 0e                	je     800ae5 <atomic_readline+0x8f>
				cputchar(c);
  800ad7:	83 ec 0c             	sub    $0xc,%esp
  800ada:	ff 75 ec             	pushl  -0x14(%ebp)
  800add:	e8 b1 0e 00 00       	call   801993 <cputchar>
  800ae2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae8:	8d 50 01             	lea    0x1(%eax),%edx
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	01 d0                	add    %edx,%eax
  800af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af8:	88 10                	mov    %dl,(%eax)
  800afa:	eb 5b                	jmp    800b57 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800afc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b00:	75 1f                	jne    800b21 <atomic_readline+0xcb>
  800b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b06:	7e 19                	jle    800b21 <atomic_readline+0xcb>
			if (echoing)
  800b08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b0c:	74 0e                	je     800b1c <atomic_readline+0xc6>
				cputchar(c);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 ec             	pushl  -0x14(%ebp)
  800b14:	e8 7a 0e 00 00       	call   801993 <cputchar>
  800b19:	83 c4 10             	add    $0x10,%esp
			i--;
  800b1c:	ff 4d f4             	decl   -0xc(%ebp)
  800b1f:	eb 36                	jmp    800b57 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b21:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b25:	74 0a                	je     800b31 <atomic_readline+0xdb>
  800b27:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b2b:	0f 85 60 ff ff ff    	jne    800a91 <atomic_readline+0x3b>
			if (echoing)
  800b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b35:	74 0e                	je     800b45 <atomic_readline+0xef>
				cputchar(c);
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3d:	e8 51 0e 00 00       	call   801993 <cputchar>
  800b42:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b50:	e8 2a 09 00 00       	call   80147f <sys_enable_interrupt>
			return;
  800b55:	eb 05                	jmp    800b5c <atomic_readline+0x106>
		}
	}
  800b57:	e9 35 ff ff ff       	jmp    800a91 <atomic_readline+0x3b>
}
  800b5c:	c9                   	leave  
  800b5d:	c3                   	ret    

00800b5e <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6b:	eb 06                	jmp    800b73 <strlen+0x15>
		n++;
  800b6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b70:	ff 45 08             	incl   0x8(%ebp)
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	84 c0                	test   %al,%al
  800b7a:	75 f1                	jne    800b6d <strlen+0xf>
		n++;
	return n;
  800b7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8e:	eb 09                	jmp    800b99 <strnlen+0x18>
		n++;
  800b90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b93:	ff 45 08             	incl   0x8(%ebp)
  800b96:	ff 4d 0c             	decl   0xc(%ebp)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 09                	je     800ba8 <strnlen+0x27>
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	75 e8                	jne    800b90 <strnlen+0xf>
		n++;
	return n;
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bb9:	90                   	nop
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8d 50 01             	lea    0x1(%eax),%edx
  800bc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bcc:	8a 12                	mov    (%edx),%dl
  800bce:	88 10                	mov    %dl,(%eax)
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 e4                	jne    800bba <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800be7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bee:	eb 1f                	jmp    800c0f <strncpy+0x34>
		*dst++ = *src;
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8d 50 01             	lea    0x1(%eax),%edx
  800bf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfc:	8a 12                	mov    (%edx),%dl
  800bfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	74 03                	je     800c0c <strncpy+0x31>
			src++;
  800c09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
  800c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c15:	72 d9                	jb     800bf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2c:	74 30                	je     800c5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c2e:	eb 16                	jmp    800c46 <strlcpy+0x2a>
			*dst++ = *src++;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 08             	mov    %edx,0x8(%ebp)
  800c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c46:	ff 4d 10             	decl   0x10(%ebp)
  800c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4d:	74 09                	je     800c58 <strlcpy+0x3c>
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	75 d8                	jne    800c30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c64:	29 c2                	sub    %eax,%edx
  800c66:	89 d0                	mov    %edx,%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c6d:	eb 06                	jmp    800c75 <strcmp+0xb>
		p++, q++;
  800c6f:	ff 45 08             	incl   0x8(%ebp)
  800c72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	74 0e                	je     800c8c <strcmp+0x22>
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 10                	mov    (%eax),%dl
  800c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	38 c2                	cmp    %al,%dl
  800c8a:	74 e3                	je     800c6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 d0             	movzbl %al,%edx
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	0f b6 c0             	movzbl %al,%eax
  800c9c:	29 c2                	sub    %eax,%edx
  800c9e:	89 d0                	mov    %edx,%eax
}
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ca5:	eb 09                	jmp    800cb0 <strncmp+0xe>
		n--, p++, q++;
  800ca7:	ff 4d 10             	decl   0x10(%ebp)
  800caa:	ff 45 08             	incl   0x8(%ebp)
  800cad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	74 17                	je     800ccd <strncmp+0x2b>
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	74 0e                	je     800ccd <strncmp+0x2b>
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 10                	mov    (%eax),%dl
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	38 c2                	cmp    %al,%dl
  800ccb:	74 da                	je     800ca7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ccd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd1:	75 07                	jne    800cda <strncmp+0x38>
		return 0;
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd8:	eb 14                	jmp    800cee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 d0             	movzbl %al,%edx
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 c0             	movzbl %al,%eax
  800cea:	29 c2                	sub    %eax,%edx
  800cec:	89 d0                	mov    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cfc:	eb 12                	jmp    800d10 <strchr+0x20>
		if (*s == c)
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d06:	75 05                	jne    800d0d <strchr+0x1d>
			return (char *) s;
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	eb 11                	jmp    800d1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 e5                	jne    800cfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1e:	c9                   	leave  
  800d1f:	c3                   	ret    

00800d20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 04             	sub    $0x4,%esp
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2c:	eb 0d                	jmp    800d3b <strfind+0x1b>
		if (*s == c)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d36:	74 0e                	je     800d46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	75 ea                	jne    800d2e <strfind+0xe>
  800d44:	eb 01                	jmp    800d47 <strfind+0x27>
		if (*s == c)
			break;
  800d46:	90                   	nop
	return (char *) s;
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d5e:	eb 0e                	jmp    800d6e <memset+0x22>
		*p++ = c;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	8d 50 01             	lea    0x1(%eax),%edx
  800d66:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d6e:	ff 4d f8             	decl   -0x8(%ebp)
  800d71:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d75:	79 e9                	jns    800d60 <memset+0x14>
		*p++ = c;

	return v;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d8e:	eb 16                	jmp    800da6 <memcpy+0x2a>
		*d++ = *s++;
  800d90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d93:	8d 50 01             	lea    0x1(%eax),%edx
  800d96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da2:	8a 12                	mov    (%edx),%dl
  800da4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dac:	89 55 10             	mov    %edx,0x10(%ebp)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	75 dd                	jne    800d90 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db6:	c9                   	leave  
  800db7:	c3                   	ret    

00800db8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd0:	73 50                	jae    800e22 <memmove+0x6a>
  800dd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	01 d0                	add    %edx,%eax
  800dda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ddd:	76 43                	jbe    800e22 <memmove+0x6a>
		s += n;
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800deb:	eb 10                	jmp    800dfd <memmove+0x45>
			*--d = *--s;
  800ded:	ff 4d f8             	decl   -0x8(%ebp)
  800df0:	ff 4d fc             	decl   -0x4(%ebp)
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 e3                	jne    800ded <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e0a:	eb 23                	jmp    800e2f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0f:	8d 50 01             	lea    0x1(%eax),%edx
  800e12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1e:	8a 12                	mov    (%edx),%dl
  800e20:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e28:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	75 dd                	jne    800e0c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e46:	eb 2a                	jmp    800e72 <memcmp+0x3e>
		if (*s1 != *s2)
  800e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4b:	8a 10                	mov    (%eax),%dl
  800e4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	38 c2                	cmp    %al,%dl
  800e54:	74 16                	je     800e6c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	0f b6 d0             	movzbl %al,%edx
  800e5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f b6 c0             	movzbl %al,%eax
  800e66:	29 c2                	sub    %eax,%edx
  800e68:	89 d0                	mov    %edx,%eax
  800e6a:	eb 18                	jmp    800e84 <memcmp+0x50>
		s1++, s2++;
  800e6c:	ff 45 fc             	incl   -0x4(%ebp)
  800e6f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e78:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	75 c9                	jne    800e48 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	01 d0                	add    %edx,%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e97:	eb 15                	jmp    800eae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	0f b6 d0             	movzbl %al,%edx
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	0f b6 c0             	movzbl %al,%eax
  800ea7:	39 c2                	cmp    %eax,%edx
  800ea9:	74 0d                	je     800eb8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eab:	ff 45 08             	incl   0x8(%ebp)
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eb4:	72 e3                	jb     800e99 <memfind+0x13>
  800eb6:	eb 01                	jmp    800eb9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eb8:	90                   	nop
	return (void *) s;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ec4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ecb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed2:	eb 03                	jmp    800ed7 <strtol+0x19>
		s++;
  800ed4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	3c 20                	cmp    $0x20,%al
  800ede:	74 f4                	je     800ed4 <strtol+0x16>
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 09                	cmp    $0x9,%al
  800ee7:	74 eb                	je     800ed4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 2b                	cmp    $0x2b,%al
  800ef0:	75 05                	jne    800ef7 <strtol+0x39>
		s++;
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	eb 13                	jmp    800f0a <strtol+0x4c>
	else if (*s == '-')
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	3c 2d                	cmp    $0x2d,%al
  800efe:	75 0a                	jne    800f0a <strtol+0x4c>
		s++, neg = 1;
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	74 06                	je     800f16 <strtol+0x58>
  800f10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f14:	75 20                	jne    800f36 <strtol+0x78>
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	3c 30                	cmp    $0x30,%al
  800f1d:	75 17                	jne    800f36 <strtol+0x78>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	40                   	inc    %eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 78                	cmp    $0x78,%al
  800f27:	75 0d                	jne    800f36 <strtol+0x78>
		s += 2, base = 16;
  800f29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f34:	eb 28                	jmp    800f5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	75 15                	jne    800f51 <strtol+0x93>
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 30                	cmp    $0x30,%al
  800f43:	75 0c                	jne    800f51 <strtol+0x93>
		s++, base = 8;
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f4f:	eb 0d                	jmp    800f5e <strtol+0xa0>
	else if (base == 0)
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	75 07                	jne    800f5e <strtol+0xa0>
		base = 10;
  800f57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 2f                	cmp    $0x2f,%al
  800f65:	7e 19                	jle    800f80 <strtol+0xc2>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 39                	cmp    $0x39,%al
  800f6e:	7f 10                	jg     800f80 <strtol+0xc2>
			dig = *s - '0';
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f be c0             	movsbl %al,%eax
  800f78:	83 e8 30             	sub    $0x30,%eax
  800f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f7e:	eb 42                	jmp    800fc2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 60                	cmp    $0x60,%al
  800f87:	7e 19                	jle    800fa2 <strtol+0xe4>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 7a                	cmp    $0x7a,%al
  800f90:	7f 10                	jg     800fa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	0f be c0             	movsbl %al,%eax
  800f9a:	83 e8 57             	sub    $0x57,%eax
  800f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa0:	eb 20                	jmp    800fc2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 40                	cmp    $0x40,%al
  800fa9:	7e 39                	jle    800fe4 <strtol+0x126>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 5a                	cmp    $0x5a,%al
  800fb2:	7f 30                	jg     800fe4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f be c0             	movsbl %al,%eax
  800fbc:	83 e8 37             	sub    $0x37,%eax
  800fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fc8:	7d 19                	jge    800fe3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fca:	ff 45 08             	incl   0x8(%ebp)
  800fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd9:	01 d0                	add    %edx,%eax
  800fdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fde:	e9 7b ff ff ff       	jmp    800f5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fe3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fe4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe8:	74 08                	je     800ff2 <strtol+0x134>
		*endptr = (char *) s;
  800fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ff6:	74 07                	je     800fff <strtol+0x141>
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	f7 d8                	neg    %eax
  800ffd:	eb 03                	jmp    801002 <strtol+0x144>
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <ltostr>:

void
ltostr(long value, char *str)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801018:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101c:	79 13                	jns    801031 <ltostr+0x2d>
	{
		neg = 1;
  80101e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80102b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80102e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801039:	99                   	cltd   
  80103a:	f7 f9                	idiv   %ecx
  80103c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801042:	8d 50 01             	lea    0x1(%eax),%edx
  801045:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801048:	89 c2                	mov    %eax,%edx
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801052:	83 c2 30             	add    $0x30,%edx
  801055:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801057:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80105f:	f7 e9                	imul   %ecx
  801061:	c1 fa 02             	sar    $0x2,%edx
  801064:	89 c8                	mov    %ecx,%eax
  801066:	c1 f8 1f             	sar    $0x1f,%eax
  801069:	29 c2                	sub    %eax,%edx
  80106b:	89 d0                	mov    %edx,%eax
  80106d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801070:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801073:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801078:	f7 e9                	imul   %ecx
  80107a:	c1 fa 02             	sar    $0x2,%edx
  80107d:	89 c8                	mov    %ecx,%eax
  80107f:	c1 f8 1f             	sar    $0x1f,%eax
  801082:	29 c2                	sub    %eax,%edx
  801084:	89 d0                	mov    %edx,%eax
  801086:	c1 e0 02             	shl    $0x2,%eax
  801089:	01 d0                	add    %edx,%eax
  80108b:	01 c0                	add    %eax,%eax
  80108d:	29 c1                	sub    %eax,%ecx
  80108f:	89 ca                	mov    %ecx,%edx
  801091:	85 d2                	test   %edx,%edx
  801093:	75 9c                	jne    801031 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	48                   	dec    %eax
  8010a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010a7:	74 3d                	je     8010e6 <ltostr+0xe2>
		start = 1 ;
  8010a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010b0:	eb 34                	jmp    8010e6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	01 d0                	add    %edx,%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	01 c2                	add    %eax,%edx
  8010c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	01 c8                	add    %ecx,%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	01 c2                	add    %eax,%edx
  8010db:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010de:	88 02                	mov    %al,(%edx)
		start++ ;
  8010e0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010e3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ec:	7c c4                	jl     8010b2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010f9:	90                   	nop
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801102:	ff 75 08             	pushl  0x8(%ebp)
  801105:	e8 54 fa ff ff       	call   800b5e <strlen>
  80110a:	83 c4 04             	add    $0x4,%esp
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	e8 46 fa ff ff       	call   800b5e <strlen>
  801118:	83 c4 04             	add    $0x4,%esp
  80111b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80111e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80112c:	eb 17                	jmp    801145 <strcconcat+0x49>
		final[s] = str1[s] ;
  80112e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 c2                	add    %eax,%edx
  801136:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	01 c8                	add    %ecx,%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801142:	ff 45 fc             	incl   -0x4(%ebp)
  801145:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801148:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80114b:	7c e1                	jl     80112e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80114d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801154:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80115b:	eb 1f                	jmp    80117c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80115d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801160:	8d 50 01             	lea    0x1(%eax),%edx
  801163:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801166:	89 c2                	mov    %eax,%edx
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801179:	ff 45 f8             	incl   -0x8(%ebp)
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801182:	7c d9                	jl     80115d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801184:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 d0                	add    %edx,%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
}
  80118f:	90                   	nop
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801195:	8b 45 14             	mov    0x14(%ebp),%eax
  801198:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80119e:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a1:	8b 00                	mov    (%eax),%eax
  8011a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011b5:	eb 0c                	jmp    8011c3 <strsplit+0x31>
			*string++ = 0;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	84 c0                	test   %al,%al
  8011ca:	74 18                	je     8011e4 <strsplit+0x52>
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	0f be c0             	movsbl %al,%eax
  8011d4:	50                   	push   %eax
  8011d5:	ff 75 0c             	pushl  0xc(%ebp)
  8011d8:	e8 13 fb ff ff       	call   800cf0 <strchr>
  8011dd:	83 c4 08             	add    $0x8,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	75 d3                	jne    8011b7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	84 c0                	test   %al,%al
  8011eb:	74 5a                	je     801247 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	83 f8 0f             	cmp    $0xf,%eax
  8011f5:	75 07                	jne    8011fe <strsplit+0x6c>
		{
			return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fc:	eb 66                	jmp    801264 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801201:	8b 00                	mov    (%eax),%eax
  801203:	8d 48 01             	lea    0x1(%eax),%ecx
  801206:	8b 55 14             	mov    0x14(%ebp),%edx
  801209:	89 0a                	mov    %ecx,(%edx)
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 c2                	add    %eax,%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80121c:	eb 03                	jmp    801221 <strsplit+0x8f>
			string++;
  80121e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	84 c0                	test   %al,%al
  801228:	74 8b                	je     8011b5 <strsplit+0x23>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	0f be c0             	movsbl %al,%eax
  801232:	50                   	push   %eax
  801233:	ff 75 0c             	pushl  0xc(%ebp)
  801236:	e8 b5 fa ff ff       	call   800cf0 <strchr>
  80123b:	83 c4 08             	add    $0x8,%esp
  80123e:	85 c0                	test   %eax,%eax
  801240:	74 dc                	je     80121e <strsplit+0x8c>
			string++;
	}
  801242:	e9 6e ff ff ff       	jmp    8011b5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801247:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80125f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80126c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801273:	eb 4c                	jmp    8012c1 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801275:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 40                	cmp    $0x40,%al
  801281:	7e 27                	jle    8012aa <str2lower+0x44>
  801283:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 d0                	add    %edx,%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 5a                	cmp    $0x5a,%al
  80128f:	7f 19                	jg     8012aa <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129f:	01 ca                	add    %ecx,%edx
  8012a1:	8a 12                	mov    (%edx),%dl
  8012a3:	83 c2 20             	add    $0x20,%edx
  8012a6:	88 10                	mov    %dl,(%eax)
  8012a8:	eb 14                	jmp    8012be <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8012aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	01 c2                	add    %eax,%edx
  8012b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c8                	add    %ecx,%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8012be:	ff 45 fc             	incl   -0x4(%ebp)
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 95 f8 ff ff       	call   800b5e <strlen>
  8012c9:	83 c4 04             	add    $0x4,%esp
  8012cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012cf:	7f a4                	jg     801275 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8012d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	57                   	push   %edi
  8012e5:	56                   	push   %esi
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012f9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012fc:	cd 30                	int    $0x30
  8012fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801301:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801318:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	52                   	push   %edx
  801324:	ff 75 0c             	pushl  0xc(%ebp)
  801327:	50                   	push   %eax
  801328:	6a 00                	push   $0x0
  80132a:	e8 b2 ff ff ff       	call   8012e1 <syscall>
  80132f:	83 c4 18             	add    $0x18,%esp
}
  801332:	90                   	nop
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <sys_cgetc>:

int
sys_cgetc(void)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 01                	push   $0x1
  801344:	e8 98 ff ff ff       	call   8012e1 <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801351:	8b 55 0c             	mov    0xc(%ebp),%edx
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	6a 05                	push   $0x5
  801361:	e8 7b ff ff ff       	call   8012e1 <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	c9                   	leave  
  80136a:	c3                   	ret    

0080136b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801370:	8b 75 18             	mov    0x18(%ebp),%esi
  801373:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801376:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	56                   	push   %esi
  801380:	53                   	push   %ebx
  801381:	51                   	push   %ecx
  801382:	52                   	push   %edx
  801383:	50                   	push   %eax
  801384:	6a 06                	push   $0x6
  801386:	e8 56 ff ff ff       	call   8012e1 <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801391:	5b                   	pop    %ebx
  801392:	5e                   	pop    %esi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	50                   	push   %eax
  8013a6:	6a 07                	push   $0x7
  8013a8:	e8 34 ff ff ff       	call   8012e1 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	ff 75 0c             	pushl  0xc(%ebp)
  8013be:	ff 75 08             	pushl  0x8(%ebp)
  8013c1:	6a 08                	push   $0x8
  8013c3:	e8 19 ff ff ff       	call   8012e1 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 09                	push   $0x9
  8013dc:	e8 00 ff ff ff       	call   8012e1 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 0a                	push   $0xa
  8013f5:	e8 e7 fe ff ff       	call   8012e1 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 0b                	push   $0xb
  80140e:	e8 ce fe ff ff       	call   8012e1 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 0c                	push   $0xc
  801427:	e8 b5 fe ff ff       	call   8012e1 <syscall>
  80142c:	83 c4 18             	add    $0x18,%esp
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	ff 75 08             	pushl  0x8(%ebp)
  80143f:	6a 0d                	push   $0xd
  801441:	e8 9b fe ff ff       	call   8012e1 <syscall>
  801446:	83 c4 18             	add    $0x18,%esp
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 0e                	push   $0xe
  80145a:	e8 82 fe ff ff       	call   8012e1 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 11                	push   $0x11
  801474:	e8 68 fe ff ff       	call   8012e1 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	90                   	nop
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 12                	push   $0x12
  80148e:	e8 4e fe ff ff       	call   8012e1 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_cputc>:


void
sys_cputc(const char c)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	50                   	push   %eax
  8014b2:	6a 13                	push   $0x13
  8014b4:	e8 28 fe ff ff       	call   8012e1 <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	90                   	nop
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 14                	push   $0x14
  8014ce:	e8 0e fe ff ff       	call   8012e1 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	90                   	nop
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	6a 15                	push   $0x15
  8014eb:	e8 f1 fd ff ff       	call   8012e1 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	52                   	push   %edx
  801505:	50                   	push   %eax
  801506:	6a 18                	push   $0x18
  801508:	e8 d4 fd ff ff       	call   8012e1 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801515:	8b 55 0c             	mov    0xc(%ebp),%edx
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	52                   	push   %edx
  801522:	50                   	push   %eax
  801523:	6a 16                	push   $0x16
  801525:	e8 b7 fd ff ff       	call   8012e1 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	90                   	nop
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	52                   	push   %edx
  801540:	50                   	push   %eax
  801541:	6a 17                	push   $0x17
  801543:	e8 99 fd ff ff       	call   8012e1 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	90                   	nop
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80155a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80155d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	51                   	push   %ecx
  801567:	52                   	push   %edx
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	50                   	push   %eax
  80156c:	6a 19                	push   $0x19
  80156e:	e8 6e fd ff ff       	call   8012e1 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	50                   	push   %eax
  801589:	6a 1a                	push   $0x1a
  80158b:	e8 51 fd ff ff       	call   8012e1 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801598:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	51                   	push   %ecx
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	6a 1b                	push   $0x1b
  8015aa:	e8 32 fd ff ff       	call   8012e1 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	6a 1c                	push   $0x1c
  8015c7:	e8 15 fd ff ff       	call   8012e1 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 1d                	push   $0x1d
  8015e0:	e8 fc fc ff ff       	call   8012e1 <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	6a 00                	push   $0x0
  8015f2:	ff 75 14             	pushl  0x14(%ebp)
  8015f5:	ff 75 10             	pushl  0x10(%ebp)
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	50                   	push   %eax
  8015fc:	6a 1e                	push   $0x1e
  8015fe:	e8 de fc ff ff       	call   8012e1 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	50                   	push   %eax
  801617:	6a 1f                	push   $0x1f
  801619:	e8 c3 fc ff ff       	call   8012e1 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	50                   	push   %eax
  801633:	6a 20                	push   $0x20
  801635:	e8 a7 fc ff ff       	call   8012e1 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 02                	push   $0x2
  80164e:	e8 8e fc ff ff       	call   8012e1 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 03                	push   $0x3
  801667:	e8 75 fc ff ff       	call   8012e1 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 04                	push   $0x4
  801680:	e8 5c fc ff ff       	call   8012e1 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_exit_env>:


void sys_exit_env(void)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 21                	push   $0x21
  801699:	e8 43 fc ff ff       	call   8012e1 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016ad:	8d 50 04             	lea    0x4(%eax),%edx
  8016b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	6a 22                	push   $0x22
  8016bd:	e8 1f fc ff ff       	call   8012e1 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8016c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ce:	89 01                	mov    %eax,(%ecx)
  8016d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	c9                   	leave  
  8016d7:	c2 04 00             	ret    $0x4

008016da <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	ff 75 10             	pushl  0x10(%ebp)
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	ff 75 08             	pushl  0x8(%ebp)
  8016ea:	6a 10                	push   $0x10
  8016ec:	e8 f0 fb ff ff       	call   8012e1 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f4:	90                   	nop
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 23                	push   $0x23
  801706:	e8 d6 fb ff ff       	call   8012e1 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80171c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	50                   	push   %eax
  801729:	6a 24                	push   $0x24
  80172b:	e8 b1 fb ff ff       	call   8012e1 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
	return ;
  801733:	90                   	nop
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <rsttst>:
void rsttst()
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 26                	push   $0x26
  801745:	e8 97 fb ff ff       	call   8012e1 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
	return ;
  80174d:	90                   	nop
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	8b 45 14             	mov    0x14(%ebp),%eax
  801759:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80175c:	8b 55 18             	mov    0x18(%ebp),%edx
  80175f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801763:	52                   	push   %edx
  801764:	50                   	push   %eax
  801765:	ff 75 10             	pushl  0x10(%ebp)
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	6a 25                	push   $0x25
  801770:	e8 6c fb ff ff       	call   8012e1 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
	return ;
  801778:	90                   	nop
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <chktst>:
void chktst(uint32 n)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	6a 27                	push   $0x27
  80178b:	e8 51 fb ff ff       	call   8012e1 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
	return ;
  801793:	90                   	nop
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <inctst>:

void inctst()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 28                	push   $0x28
  8017a5:	e8 37 fb ff ff       	call   8012e1 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <gettst>:
uint32 gettst()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 29                	push   $0x29
  8017bf:	e8 1d fb ff ff       	call   8012e1 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 2a                	push   $0x2a
  8017db:	e8 01 fb ff ff       	call   8012e1 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
  8017e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017e6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017ea:	75 07                	jne    8017f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f1:	eb 05                	jmp    8017f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 2a                	push   $0x2a
  80180c:	e8 d0 fa ff ff       	call   8012e1 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801817:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80181b:	75 07                	jne    801824 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80181d:	b8 01 00 00 00       	mov    $0x1,%eax
  801822:	eb 05                	jmp    801829 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 2a                	push   $0x2a
  80183d:	e8 9f fa ff ff       	call   8012e1 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
  801845:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801848:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80184c:	75 07                	jne    801855 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80184e:	b8 01 00 00 00       	mov    $0x1,%eax
  801853:	eb 05                	jmp    80185a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 2a                	push   $0x2a
  80186e:	e8 6e fa ff ff       	call   8012e1 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
  801876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801879:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80187d:	75 07                	jne    801886 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80187f:	b8 01 00 00 00       	mov    $0x1,%eax
  801884:	eb 05                	jmp    80188b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	6a 2b                	push   $0x2b
  80189d:	e8 3f fa ff ff       	call   8012e1 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a5:	90                   	nop
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	53                   	push   %ebx
  8018bb:	51                   	push   %ecx
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	6a 2c                	push   $0x2c
  8018c0:	e8 1c fa ff ff       	call   8012e1 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 2d                	push   $0x2d
  8018e0:	e8 fc f9 ff ff       	call   8012e1 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	51                   	push   %ecx
  8018f9:	ff 75 10             	pushl  0x10(%ebp)
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 2e                	push   $0x2e
  801900:	e8 dc f9 ff ff       	call   8012e1 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 10             	pushl  0x10(%ebp)
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 0f                	push   $0xf
  80191c:	e8 c0 f9 ff ff       	call   8012e1 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
	return ;
  801924:	90                   	nop
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	50                   	push   %eax
  801936:	6a 2f                	push   $0x2f
  801938:	e8 a4 f9 ff ff       	call   8012e1 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp

}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 30                	push   $0x30
  801953:	e8 89 f9 ff ff       	call   8012e1 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp

}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 31                	push   $0x31
  80196f:	e8 6d f9 ff ff       	call   8012e1 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp

}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_hard_limit>:
uint32 sys_hard_limit(){
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 32                	push   $0x32
  801989:	e8 53 f9 ff ff       	call   8012e1 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80199f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	50                   	push   %eax
  8019a7:	e8 ed fa ff ff       	call   801499 <sys_cputc>
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019b8:	e8 a8 fa ff ff       	call   801465 <sys_disable_interrupt>
	char c = ch;
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019c3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	50                   	push   %eax
  8019cb:	e8 c9 fa ff ff       	call   801499 <sys_cputc>
  8019d0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019d3:	e8 a7 fa ff ff       	call   80147f <sys_enable_interrupt>
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <getchar>:

int
getchar(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019e8:	eb 08                	jmp    8019f2 <getchar+0x17>
	{
		c = sys_cgetc();
  8019ea:	e8 46 f9 ff ff       	call   801335 <sys_cgetc>
  8019ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f6:	74 f2                	je     8019ea <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8019f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <atomic_getchar>:

int
atomic_getchar(void)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a03:	e8 5d fa ff ff       	call   801465 <sys_disable_interrupt>
	int c=0;
  801a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a0f:	eb 08                	jmp    801a19 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a11:	e8 1f f9 ff ff       	call   801335 <sys_cgetc>
  801a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1d:	74 f2                	je     801a11 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a1f:	e8 5b fa ff ff       	call   80147f <sys_enable_interrupt>
	return c;
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <iscons>:

int iscons(int fdnum)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a2c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    
  801a33:	90                   	nop

00801a34 <__udivdi3>:
  801a34:	55                   	push   %ebp
  801a35:	57                   	push   %edi
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 1c             	sub    $0x1c,%esp
  801a3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4b:	89 ca                	mov    %ecx,%edx
  801a4d:	89 f8                	mov    %edi,%eax
  801a4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a53:	85 f6                	test   %esi,%esi
  801a55:	75 2d                	jne    801a84 <__udivdi3+0x50>
  801a57:	39 cf                	cmp    %ecx,%edi
  801a59:	77 65                	ja     801ac0 <__udivdi3+0x8c>
  801a5b:	89 fd                	mov    %edi,%ebp
  801a5d:	85 ff                	test   %edi,%edi
  801a5f:	75 0b                	jne    801a6c <__udivdi3+0x38>
  801a61:	b8 01 00 00 00       	mov    $0x1,%eax
  801a66:	31 d2                	xor    %edx,%edx
  801a68:	f7 f7                	div    %edi
  801a6a:	89 c5                	mov    %eax,%ebp
  801a6c:	31 d2                	xor    %edx,%edx
  801a6e:	89 c8                	mov    %ecx,%eax
  801a70:	f7 f5                	div    %ebp
  801a72:	89 c1                	mov    %eax,%ecx
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	f7 f5                	div    %ebp
  801a78:	89 cf                	mov    %ecx,%edi
  801a7a:	89 fa                	mov    %edi,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	39 ce                	cmp    %ecx,%esi
  801a86:	77 28                	ja     801ab0 <__udivdi3+0x7c>
  801a88:	0f bd fe             	bsr    %esi,%edi
  801a8b:	83 f7 1f             	xor    $0x1f,%edi
  801a8e:	75 40                	jne    801ad0 <__udivdi3+0x9c>
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	72 0a                	jb     801a9e <__udivdi3+0x6a>
  801a94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a98:	0f 87 9e 00 00 00    	ja     801b3c <__udivdi3+0x108>
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa3:	89 fa                	mov    %edi,%edx
  801aa5:	83 c4 1c             	add    $0x1c,%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5f                   	pop    %edi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    
  801aad:	8d 76 00             	lea    0x0(%esi),%esi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	31 c0                	xor    %eax,%eax
  801ab4:	89 fa                	mov    %edi,%edx
  801ab6:	83 c4 1c             	add    $0x1c,%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5f                   	pop    %edi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	f7 f7                	div    %edi
  801ac4:	31 ff                	xor    %edi,%edi
  801ac6:	89 fa                	mov    %edi,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad5:	89 eb                	mov    %ebp,%ebx
  801ad7:	29 fb                	sub    %edi,%ebx
  801ad9:	89 f9                	mov    %edi,%ecx
  801adb:	d3 e6                	shl    %cl,%esi
  801add:	89 c5                	mov    %eax,%ebp
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ed                	shr    %cl,%ebp
  801ae3:	89 e9                	mov    %ebp,%ecx
  801ae5:	09 f1                	or     %esi,%ecx
  801ae7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aeb:	89 f9                	mov    %edi,%ecx
  801aed:	d3 e0                	shl    %cl,%eax
  801aef:	89 c5                	mov    %eax,%ebp
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	88 d9                	mov    %bl,%cl
  801af5:	d3 ee                	shr    %cl,%esi
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e2                	shl    %cl,%edx
  801afb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 e8                	shr    %cl,%eax
  801b03:	09 c2                	or     %eax,%edx
  801b05:	89 d0                	mov    %edx,%eax
  801b07:	89 f2                	mov    %esi,%edx
  801b09:	f7 74 24 0c          	divl   0xc(%esp)
  801b0d:	89 d6                	mov    %edx,%esi
  801b0f:	89 c3                	mov    %eax,%ebx
  801b11:	f7 e5                	mul    %ebp
  801b13:	39 d6                	cmp    %edx,%esi
  801b15:	72 19                	jb     801b30 <__udivdi3+0xfc>
  801b17:	74 0b                	je     801b24 <__udivdi3+0xf0>
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	31 ff                	xor    %edi,%edi
  801b1d:	e9 58 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b28:	89 f9                	mov    %edi,%ecx
  801b2a:	d3 e2                	shl    %cl,%edx
  801b2c:	39 c2                	cmp    %eax,%edx
  801b2e:	73 e9                	jae    801b19 <__udivdi3+0xe5>
  801b30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 40 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	31 c0                	xor    %eax,%eax
  801b3e:	e9 37 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b43:	90                   	nop

00801b44 <__umoddi3>:
  801b44:	55                   	push   %ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
  801b4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b63:	89 f3                	mov    %esi,%ebx
  801b65:	89 fa                	mov    %edi,%edx
  801b67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6b:	89 34 24             	mov    %esi,(%esp)
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	75 1a                	jne    801b8c <__umoddi3+0x48>
  801b72:	39 f7                	cmp    %esi,%edi
  801b74:	0f 86 a2 00 00 00    	jbe    801c1c <__umoddi3+0xd8>
  801b7a:	89 c8                	mov    %ecx,%eax
  801b7c:	89 f2                	mov    %esi,%edx
  801b7e:	f7 f7                	div    %edi
  801b80:	89 d0                	mov    %edx,%eax
  801b82:	31 d2                	xor    %edx,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	39 f0                	cmp    %esi,%eax
  801b8e:	0f 87 ac 00 00 00    	ja     801c40 <__umoddi3+0xfc>
  801b94:	0f bd e8             	bsr    %eax,%ebp
  801b97:	83 f5 1f             	xor    $0x1f,%ebp
  801b9a:	0f 84 ac 00 00 00    	je     801c4c <__umoddi3+0x108>
  801ba0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba5:	29 ef                	sub    %ebp,%edi
  801ba7:	89 fe                	mov    %edi,%esi
  801ba9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bad:	89 e9                	mov    %ebp,%ecx
  801baf:	d3 e0                	shl    %cl,%eax
  801bb1:	89 d7                	mov    %edx,%edi
  801bb3:	89 f1                	mov    %esi,%ecx
  801bb5:	d3 ef                	shr    %cl,%edi
  801bb7:	09 c7                	or     %eax,%edi
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e2                	shl    %cl,%edx
  801bbd:	89 14 24             	mov    %edx,(%esp)
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	d3 e0                	shl    %cl,%eax
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bca:	d3 e0                	shl    %cl,%eax
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd4:	89 f1                	mov    %esi,%ecx
  801bd6:	d3 e8                	shr    %cl,%eax
  801bd8:	09 d0                	or     %edx,%eax
  801bda:	d3 eb                	shr    %cl,%ebx
  801bdc:	89 da                	mov    %ebx,%edx
  801bde:	f7 f7                	div    %edi
  801be0:	89 d3                	mov    %edx,%ebx
  801be2:	f7 24 24             	mull   (%esp)
  801be5:	89 c6                	mov    %eax,%esi
  801be7:	89 d1                	mov    %edx,%ecx
  801be9:	39 d3                	cmp    %edx,%ebx
  801beb:	0f 82 87 00 00 00    	jb     801c78 <__umoddi3+0x134>
  801bf1:	0f 84 91 00 00 00    	je     801c88 <__umoddi3+0x144>
  801bf7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bfb:	29 f2                	sub    %esi,%edx
  801bfd:	19 cb                	sbb    %ecx,%ebx
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c05:	d3 e0                	shl    %cl,%eax
  801c07:	89 e9                	mov    %ebp,%ecx
  801c09:	d3 ea                	shr    %cl,%edx
  801c0b:	09 d0                	or     %edx,%eax
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 eb                	shr    %cl,%ebx
  801c11:	89 da                	mov    %ebx,%edx
  801c13:	83 c4 1c             	add    $0x1c,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5f                   	pop    %edi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    
  801c1b:	90                   	nop
  801c1c:	89 fd                	mov    %edi,%ebp
  801c1e:	85 ff                	test   %edi,%edi
  801c20:	75 0b                	jne    801c2d <__umoddi3+0xe9>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	31 d2                	xor    %edx,%edx
  801c29:	f7 f7                	div    %edi
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 f0                	mov    %esi,%eax
  801c2f:	31 d2                	xor    %edx,%edx
  801c31:	f7 f5                	div    %ebp
  801c33:	89 c8                	mov    %ecx,%eax
  801c35:	f7 f5                	div    %ebp
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	e9 44 ff ff ff       	jmp    801b82 <__umoddi3+0x3e>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	89 c8                	mov    %ecx,%eax
  801c42:	89 f2                	mov    %esi,%edx
  801c44:	83 c4 1c             	add    $0x1c,%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    
  801c4c:	3b 04 24             	cmp    (%esp),%eax
  801c4f:	72 06                	jb     801c57 <__umoddi3+0x113>
  801c51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c55:	77 0f                	ja     801c66 <__umoddi3+0x122>
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	29 f9                	sub    %edi,%ecx
  801c5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c5f:	89 14 24             	mov    %edx,(%esp)
  801c62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c66:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6a:	8b 14 24             	mov    (%esp),%edx
  801c6d:	83 c4 1c             	add    $0x1c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
  801c75:	8d 76 00             	lea    0x0(%esi),%esi
  801c78:	2b 04 24             	sub    (%esp),%eax
  801c7b:	19 fa                	sbb    %edi,%edx
  801c7d:	89 d1                	mov    %edx,%ecx
  801c7f:	89 c6                	mov    %eax,%esi
  801c81:	e9 71 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c8c:	72 ea                	jb     801c78 <__umoddi3+0x134>
  801c8e:	89 d9                	mov    %ebx,%ecx
  801c90:	e9 62 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
