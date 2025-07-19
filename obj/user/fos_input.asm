
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 60 1d 80 00       	push   $0x801d60
  80005e:	e8 03 0a 00 00       	call   800a66 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 55 0e 00 00       	call   800ece <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 17 19 00 00       	call   8019a3 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 7c 1d 80 00       	push   $0x801d7c
  80009e:	e8 c3 09 00 00       	call   800a66 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 15 0e 00 00       	call   800ece <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 99 1d 80 00       	push   $0x801d99
  8000d0:	e8 3e 02 00 00       	call   800313 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 82 15 00 00       	call   801668 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 03             	shl    $0x3,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000fe:	01 d0                	add    %edx,%eax
  800100:	c1 e0 04             	shl    $0x4,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010d:	a1 20 30 80 00       	mov    0x803020,%eax
  800112:	8a 40 5c             	mov    0x5c(%eax),%al
  800115:	84 c0                	test   %al,%al
  800117:	74 0d                	je     800126 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	83 c0 5c             	add    $0x5c,%eax
  800121:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012a:	7e 0a                	jle    800136 <libmain+0x5b>
		binaryname = argv[0];
  80012c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012f:	8b 00                	mov    (%eax),%eax
  800131:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	e8 f4 fe ff ff       	call   800038 <_main>
  800144:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800147:	e8 29 13 00 00       	call   801475 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 cc 1d 80 00       	push   $0x801dcc
  800154:	e8 8d 01 00 00       	call   8002e6 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015c:	a1 20 30 80 00       	mov    0x803020,%eax
  800161:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800167:	a1 20 30 80 00       	mov    0x803020,%eax
  80016c:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	68 f4 1d 80 00       	push   $0x801df4
  80017c:	e8 65 01 00 00       	call   8002e6 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800184:	a1 20 30 80 00       	mov    0x803020,%eax
  800189:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8001a5:	51                   	push   %ecx
  8001a6:	52                   	push   %edx
  8001a7:	50                   	push   %eax
  8001a8:	68 1c 1e 80 00       	push   $0x801e1c
  8001ad:	e8 34 01 00 00       	call   8002e6 <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ba:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 74 1e 80 00       	push   $0x801e74
  8001c9:	e8 18 01 00 00       	call   8002e6 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 cc 1d 80 00       	push   $0x801dcc
  8001d9:	e8 08 01 00 00       	call   8002e6 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001e1:	e8 a9 12 00 00       	call   80148f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001e6:	e8 19 00 00 00       	call   800204 <exit>
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	e8 36 14 00 00       	call   801634 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
}
  800201:	90                   	nop
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <exit>:

void
exit(void)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020a:	e8 8b 14 00 00       	call   80169a <sys_exit_env>
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	8b 00                	mov    (%eax),%eax
  80021d:	8d 48 01             	lea    0x1(%eax),%ecx
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	89 0a                	mov    %ecx,(%edx)
  800225:	8b 55 08             	mov    0x8(%ebp),%edx
  800228:	88 d1                	mov    %dl,%cl
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023b:	75 2c                	jne    800269 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80023d:	a0 24 30 80 00       	mov    0x803024,%al
  800242:	0f b6 c0             	movzbl %al,%eax
  800245:	8b 55 0c             	mov    0xc(%ebp),%edx
  800248:	8b 12                	mov    (%edx),%edx
  80024a:	89 d1                	mov    %edx,%ecx
  80024c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024f:	83 c2 08             	add    $0x8,%edx
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	50                   	push   %eax
  800256:	51                   	push   %ecx
  800257:	52                   	push   %edx
  800258:	e8 bf 10 00 00       	call   80131c <sys_cputs>
  80025d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	8b 40 04             	mov    0x4(%eax),%eax
  80026f:	8d 50 01             	lea    0x1(%eax),%edx
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	89 50 04             	mov    %edx,0x4(%eax)
}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800284:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028b:	00 00 00 
	b.cnt = 0;
  80028e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800295:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 08             	pushl  0x8(%ebp)
  80029e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a4:	50                   	push   %eax
  8002a5:	68 12 02 80 00       	push   $0x800212
  8002aa:	e8 11 02 00 00       	call   8004c0 <vprintfmt>
  8002af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b2:	a0 24 30 80 00       	mov    0x803024,%al
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	50                   	push   %eax
  8002c4:	52                   	push   %edx
  8002c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cb:	83 c0 08             	add    $0x8,%eax
  8002ce:	50                   	push   %eax
  8002cf:	e8 48 10 00 00       	call   80131c <sys_cputs>
  8002d4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ec:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800302:	50                   	push   %eax
  800303:	e8 73 ff ff ff       	call   80027b <vcprintf>
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800319:	e8 57 11 00 00       	call   801475 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80031e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800324:	8b 45 08             	mov    0x8(%ebp),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	ff 75 f4             	pushl  -0xc(%ebp)
  80032d:	50                   	push   %eax
  80032e:	e8 48 ff ff ff       	call   80027b <vcprintf>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800339:	e8 51 11 00 00       	call   80148f <sys_enable_interrupt>
	return cnt;
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800341:	c9                   	leave  
  800342:	c3                   	ret    

00800343 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	53                   	push   %ebx
  800347:	83 ec 14             	sub    $0x14,%esp
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800356:	8b 45 18             	mov    0x18(%ebp),%eax
  800359:	ba 00 00 00 00       	mov    $0x0,%edx
  80035e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800361:	77 55                	ja     8003b8 <printnum+0x75>
  800363:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800366:	72 05                	jb     80036d <printnum+0x2a>
  800368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036b:	77 4b                	ja     8003b8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800370:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800373:	8b 45 18             	mov    0x18(%ebp),%eax
  800376:	ba 00 00 00 00       	mov    $0x0,%edx
  80037b:	52                   	push   %edx
  80037c:	50                   	push   %eax
  80037d:	ff 75 f4             	pushl  -0xc(%ebp)
  800380:	ff 75 f0             	pushl  -0x10(%ebp)
  800383:	e8 70 17 00 00       	call   801af8 <__udivdi3>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	83 ec 04             	sub    $0x4,%esp
  80038e:	ff 75 20             	pushl  0x20(%ebp)
  800391:	53                   	push   %ebx
  800392:	ff 75 18             	pushl  0x18(%ebp)
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	ff 75 0c             	pushl  0xc(%ebp)
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 a1 ff ff ff       	call   800343 <printnum>
  8003a2:	83 c4 20             	add    $0x20,%esp
  8003a5:	eb 1a                	jmp    8003c1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	ff 75 0c             	pushl  0xc(%ebp)
  8003ad:	ff 75 20             	pushl  0x20(%ebp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	ff d0                	call   *%eax
  8003b5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003bf:	7f e6                	jg     8003a7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cf:	53                   	push   %ebx
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	e8 30 18 00 00       	call   801c08 <__umoddi3>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	05 b4 20 80 00       	add    $0x8020b4,%eax
  8003e0:	8a 00                	mov    (%eax),%al
  8003e2:	0f be c0             	movsbl %al,%eax
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	ff 75 0c             	pushl  0xc(%ebp)
  8003eb:	50                   	push   %eax
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	ff d0                	call   *%eax
  8003f1:	83 c4 10             	add    $0x10,%esp
}
  8003f4:	90                   	nop
  8003f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800401:	7e 1c                	jle    80041f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	8d 50 08             	lea    0x8(%eax),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	89 10                	mov    %edx,(%eax)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	83 e8 08             	sub    $0x8,%eax
  800418:	8b 50 04             	mov    0x4(%eax),%edx
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	eb 40                	jmp    80045f <getuint+0x65>
	else if (lflag)
  80041f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800423:	74 1e                	je     800443 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 10                	mov    %edx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	83 e8 04             	sub    $0x4,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	eb 1c                	jmp    80045f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 04             	lea    0x4(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 04             	sub    $0x4,%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800464:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800468:	7e 1c                	jle    800486 <getint+0x25>
		return va_arg(*ap, long long);
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	8d 50 08             	lea    0x8(%eax),%edx
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	89 10                	mov    %edx,(%eax)
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	83 e8 08             	sub    $0x8,%eax
  80047f:	8b 50 04             	mov    0x4(%eax),%edx
  800482:	8b 00                	mov    (%eax),%eax
  800484:	eb 38                	jmp    8004be <getint+0x5d>
	else if (lflag)
  800486:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048a:	74 1a                	je     8004a6 <getint+0x45>
		return va_arg(*ap, long);
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	8d 50 04             	lea    0x4(%eax),%edx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	89 10                	mov    %edx,(%eax)
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	83 e8 04             	sub    $0x4,%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	99                   	cltd   
  8004a4:	eb 18                	jmp    8004be <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	8d 50 04             	lea    0x4(%eax),%edx
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 10                	mov    %edx,(%eax)
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	83 e8 04             	sub    $0x4,%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	99                   	cltd   
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	56                   	push   %esi
  8004c4:	53                   	push   %ebx
  8004c5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c8:	eb 17                	jmp    8004e1 <vprintfmt+0x21>
			if (ch == '\0')
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	0f 84 af 03 00 00    	je     800881 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	53                   	push   %ebx
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	ff d0                	call   *%eax
  8004de:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	8d 50 01             	lea    0x1(%eax),%edx
  8004e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ea:	8a 00                	mov    (%eax),%al
  8004ec:	0f b6 d8             	movzbl %al,%ebx
  8004ef:	83 fb 25             	cmp    $0x25,%ebx
  8004f2:	75 d6                	jne    8004ca <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80050d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	8d 50 01             	lea    0x1(%eax),%edx
  80051a:	89 55 10             	mov    %edx,0x10(%ebp)
  80051d:	8a 00                	mov    (%eax),%al
  80051f:	0f b6 d8             	movzbl %al,%ebx
  800522:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800525:	83 f8 55             	cmp    $0x55,%eax
  800528:	0f 87 2b 03 00 00    	ja     800859 <vprintfmt+0x399>
  80052e:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  800535:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800537:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80053b:	eb d7                	jmp    800514 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800541:	eb d1                	jmp    800514 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800543:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	89 d0                	mov    %edx,%eax
  80054f:	c1 e0 02             	shl    $0x2,%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d8                	add    %ebx,%eax
  800558:	83 e8 30             	sub    $0x30,%eax
  80055b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80055e:	8b 45 10             	mov    0x10(%ebp),%eax
  800561:	8a 00                	mov    (%eax),%al
  800563:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800566:	83 fb 2f             	cmp    $0x2f,%ebx
  800569:	7e 3e                	jle    8005a9 <vprintfmt+0xe9>
  80056b:	83 fb 39             	cmp    $0x39,%ebx
  80056e:	7f 39                	jg     8005a9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800570:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800573:	eb d5                	jmp    80054a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 c0 04             	add    $0x4,%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 e8 04             	sub    $0x4,%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800589:	eb 1f                	jmp    8005aa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80058b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058f:	79 83                	jns    800514 <vprintfmt+0x54>
				width = 0;
  800591:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800598:	e9 77 ff ff ff       	jmp    800514 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80059d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a4:	e9 6b ff ff ff       	jmp    800514 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ae:	0f 89 60 ff ff ff    	jns    800514 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c1:	e9 4e ff ff ff       	jmp    800514 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c9:	e9 46 ff ff ff       	jmp    800514 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	83 c0 04             	add    $0x4,%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 e8 04             	sub    $0x4,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	ff d0                	call   *%eax
  8005eb:	83 c4 10             	add    $0x10,%esp
			break;
  8005ee:	e9 89 02 00 00       	jmp    80087c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	83 c0 04             	add    $0x4,%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	83 e8 04             	sub    $0x4,%eax
  800602:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800604:	85 db                	test   %ebx,%ebx
  800606:	79 02                	jns    80060a <vprintfmt+0x14a>
				err = -err;
  800608:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060a:	83 fb 64             	cmp    $0x64,%ebx
  80060d:	7f 0b                	jg     80061a <vprintfmt+0x15a>
  80060f:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  800616:	85 f6                	test   %esi,%esi
  800618:	75 19                	jne    800633 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80061a:	53                   	push   %ebx
  80061b:	68 c5 20 80 00       	push   $0x8020c5
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	e8 5e 02 00 00       	call   800889 <printfmt>
  80062b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80062e:	e9 49 02 00 00       	jmp    80087c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800633:	56                   	push   %esi
  800634:	68 ce 20 80 00       	push   $0x8020ce
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 08             	pushl  0x8(%ebp)
  80063f:	e8 45 02 00 00       	call   800889 <printfmt>
  800644:	83 c4 10             	add    $0x10,%esp
			break;
  800647:	e9 30 02 00 00       	jmp    80087c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	83 c0 04             	add    $0x4,%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 e8 04             	sub    $0x4,%eax
  80065b:	8b 30                	mov    (%eax),%esi
  80065d:	85 f6                	test   %esi,%esi
  80065f:	75 05                	jne    800666 <vprintfmt+0x1a6>
				p = "(null)";
  800661:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066a:	7e 6d                	jle    8006d9 <vprintfmt+0x219>
  80066c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800670:	74 67                	je     8006d9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	50                   	push   %eax
  800679:	56                   	push   %esi
  80067a:	e8 12 05 00 00       	call   800b91 <strnlen>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800685:	eb 16                	jmp    80069d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800687:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	50                   	push   %eax
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	ff d0                	call   *%eax
  800697:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069a:	ff 4d e4             	decl   -0x1c(%ebp)
  80069d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a1:	7f e4                	jg     800687 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a3:	eb 34                	jmp    8006d9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a9:	74 1c                	je     8006c7 <vprintfmt+0x207>
  8006ab:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ae:	7e 05                	jle    8006b5 <vprintfmt+0x1f5>
  8006b0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b3:	7e 12                	jle    8006c7 <vprintfmt+0x207>
					putch('?', putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	6a 3f                	push   $0x3f
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	ff d0                	call   *%eax
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	eb 0f                	jmp    8006d6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d9:	89 f0                	mov    %esi,%eax
  8006db:	8d 70 01             	lea    0x1(%eax),%esi
  8006de:	8a 00                	mov    (%eax),%al
  8006e0:	0f be d8             	movsbl %al,%ebx
  8006e3:	85 db                	test   %ebx,%ebx
  8006e5:	74 24                	je     80070b <vprintfmt+0x24b>
  8006e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006eb:	78 b8                	js     8006a5 <vprintfmt+0x1e5>
  8006ed:	ff 4d e0             	decl   -0x20(%ebp)
  8006f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f4:	79 af                	jns    8006a5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f6:	eb 13                	jmp    80070b <vprintfmt+0x24b>
				putch(' ', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	6a 20                	push   $0x20
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800708:	ff 4d e4             	decl   -0x1c(%ebp)
  80070b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070f:	7f e7                	jg     8006f8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800711:	e9 66 01 00 00       	jmp    80087c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 e8             	pushl  -0x18(%ebp)
  80071c:	8d 45 14             	lea    0x14(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	e8 3c fd ff ff       	call   800461 <getint>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800734:	85 d2                	test   %edx,%edx
  800736:	79 23                	jns    80075b <vprintfmt+0x29b>
				putch('-', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	6a 2d                	push   $0x2d
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	ff d0                	call   *%eax
  800745:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074e:	f7 d8                	neg    %eax
  800750:	83 d2 00             	adc    $0x0,%edx
  800753:	f7 da                	neg    %edx
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800758:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80075b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800762:	e9 bc 00 00 00       	jmp    800823 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 e8             	pushl  -0x18(%ebp)
  80076d:	8d 45 14             	lea    0x14(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	e8 84 fc ff ff       	call   8003fa <getuint>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80077f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800786:	e9 98 00 00 00       	jmp    800823 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	6a 58                	push   $0x58
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 bc 00 00 00       	jmp    80087c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	6a 30                	push   $0x30
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	6a 78                	push   $0x78
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	ff d0                	call   *%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	83 c0 04             	add    $0x4,%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	83 e8 04             	sub    $0x4,%eax
  8007ef:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800802:	eb 1f                	jmp    800823 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 e8             	pushl  -0x18(%ebp)
  80080a:	8d 45 14             	lea    0x14(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	e8 e7 fb ff ff       	call   8003fa <getuint>
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80081c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800823:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	52                   	push   %edx
  80082e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800831:	50                   	push   %eax
  800832:	ff 75 f4             	pushl  -0xc(%ebp)
  800835:	ff 75 f0             	pushl  -0x10(%ebp)
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	e8 00 fb ff ff       	call   800343 <printnum>
  800843:	83 c4 20             	add    $0x20,%esp
			break;
  800846:	eb 34                	jmp    80087c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
			break;
  800857:	eb 23                	jmp    80087c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 25                	push   $0x25
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800869:	ff 4d 10             	decl   0x10(%ebp)
  80086c:	eb 03                	jmp    800871 <vprintfmt+0x3b1>
  80086e:	ff 4d 10             	decl   0x10(%ebp)
  800871:	8b 45 10             	mov    0x10(%ebp),%eax
  800874:	48                   	dec    %eax
  800875:	8a 00                	mov    (%eax),%al
  800877:	3c 25                	cmp    $0x25,%al
  800879:	75 f3                	jne    80086e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80087b:	90                   	nop
		}
	}
  80087c:	e9 47 fc ff ff       	jmp    8004c8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800881:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800885:	5b                   	pop    %ebx
  800886:	5e                   	pop    %esi
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80088f:	8d 45 10             	lea    0x10(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800898:	8b 45 10             	mov    0x10(%ebp),%eax
  80089b:	ff 75 f4             	pushl  -0xc(%ebp)
  80089e:	50                   	push   %eax
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	ff 75 08             	pushl  0x8(%ebp)
  8008a5:	e8 16 fc ff ff       	call   8004c0 <vprintfmt>
  8008aa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008ad:	90                   	nop
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b6:	8b 40 08             	mov    0x8(%eax),%eax
  8008b9:	8d 50 01             	lea    0x1(%eax),%edx
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	8b 10                	mov    (%eax),%edx
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 40 04             	mov    0x4(%eax),%eax
  8008cd:	39 c2                	cmp    %eax,%edx
  8008cf:	73 12                	jae    8008e3 <sprintputch+0x33>
		*b->buf++ = ch;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 0a                	mov    %ecx,(%edx)
  8008de:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e1:	88 10                	mov    %dl,(%eax)
}
  8008e3:	90                   	nop
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	01 d0                	add    %edx,%eax
  8008fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80090b:	74 06                	je     800913 <vsnprintf+0x2d>
  80090d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800911:	7f 07                	jg     80091a <vsnprintf+0x34>
		return -E_INVAL;
  800913:	b8 03 00 00 00       	mov    $0x3,%eax
  800918:	eb 20                	jmp    80093a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80091a:	ff 75 14             	pushl  0x14(%ebp)
  80091d:	ff 75 10             	pushl  0x10(%ebp)
  800920:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800923:	50                   	push   %eax
  800924:	68 b0 08 80 00       	push   $0x8008b0
  800929:	e8 92 fb ff ff       	call   8004c0 <vprintfmt>
  80092e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800931:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800934:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800937:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800942:	8d 45 10             	lea    0x10(%ebp),%eax
  800945:	83 c0 04             	add    $0x4,%eax
  800948:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80094b:	8b 45 10             	mov    0x10(%ebp),%eax
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	ff 75 08             	pushl  0x8(%ebp)
  800958:	e8 89 ff ff ff       	call   8008e6 <vsnprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800963:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80096e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800972:	74 13                	je     800987 <readline+0x1f>
		cprintf("%s", prompt);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	68 30 22 80 00       	push   $0x802230
  80097f:	e8 62 f9 ff ff       	call   8002e6 <cprintf>
  800984:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80098e:	83 ec 0c             	sub    $0xc,%esp
  800991:	6a 00                	push   $0x0
  800993:	e8 55 11 00 00       	call   801aed <iscons>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80099e:	e8 fc 10 00 00       	call   801a9f <getchar>
  8009a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009aa:	79 22                	jns    8009ce <readline+0x66>
			if (c != -E_EOF)
  8009ac:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009b0:	0f 84 ad 00 00 00    	je     800a63 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8009bc:	68 33 22 80 00       	push   $0x802233
  8009c1:	e8 20 f9 ff ff       	call   8002e6 <cprintf>
  8009c6:	83 c4 10             	add    $0x10,%esp
			return;
  8009c9:	e9 95 00 00 00       	jmp    800a63 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009ce:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009d2:	7e 34                	jle    800a08 <readline+0xa0>
  8009d4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009db:	7f 2b                	jg     800a08 <readline+0xa0>
			if (echoing)
  8009dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009e1:	74 0e                	je     8009f1 <readline+0x89>
				cputchar(c);
  8009e3:	83 ec 0c             	sub    $0xc,%esp
  8009e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e9:	e8 69 10 00 00       	call   801a57 <cputchar>
  8009ee:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f4:	8d 50 01             	lea    0x1(%eax),%edx
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009fa:	89 c2                	mov    %eax,%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	01 d0                	add    %edx,%eax
  800a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a04:	88 10                	mov    %dl,(%eax)
  800a06:	eb 56                	jmp    800a5e <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a08:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a0c:	75 1f                	jne    800a2d <readline+0xc5>
  800a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a12:	7e 19                	jle    800a2d <readline+0xc5>
			if (echoing)
  800a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a18:	74 0e                	je     800a28 <readline+0xc0>
				cputchar(c);
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a20:	e8 32 10 00 00       	call   801a57 <cputchar>
  800a25:	83 c4 10             	add    $0x10,%esp

			i--;
  800a28:	ff 4d f4             	decl   -0xc(%ebp)
  800a2b:	eb 31                	jmp    800a5e <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a2d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a31:	74 0a                	je     800a3d <readline+0xd5>
  800a33:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a37:	0f 85 61 ff ff ff    	jne    80099e <readline+0x36>
			if (echoing)
  800a3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a41:	74 0e                	je     800a51 <readline+0xe9>
				cputchar(c);
  800a43:	83 ec 0c             	sub    $0xc,%esp
  800a46:	ff 75 ec             	pushl  -0x14(%ebp)
  800a49:	e8 09 10 00 00       	call   801a57 <cputchar>
  800a4e:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a5c:	eb 06                	jmp    800a64 <readline+0xfc>
		}
	}
  800a5e:	e9 3b ff ff ff       	jmp    80099e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a63:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a6c:	e8 04 0a 00 00       	call   801475 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a75:	74 13                	je     800a8a <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	68 30 22 80 00       	push   $0x802230
  800a82:	e8 5f f8 ff ff       	call   8002e6 <cprintf>
  800a87:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a91:	83 ec 0c             	sub    $0xc,%esp
  800a94:	6a 00                	push   $0x0
  800a96:	e8 52 10 00 00       	call   801aed <iscons>
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa1:	e8 f9 0f 00 00       	call   801a9f <getchar>
  800aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aad:	79 23                	jns    800ad2 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aaf:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab3:	74 13                	je     800ac8 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 ec             	pushl  -0x14(%ebp)
  800abb:	68 33 22 80 00       	push   $0x802233
  800ac0:	e8 21 f8 ff ff       	call   8002e6 <cprintf>
  800ac5:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ac8:	e8 c2 09 00 00       	call   80148f <sys_enable_interrupt>
			return;
  800acd:	e9 9a 00 00 00       	jmp    800b6c <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad6:	7e 34                	jle    800b0c <atomic_readline+0xa6>
  800ad8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800adf:	7f 2b                	jg     800b0c <atomic_readline+0xa6>
			if (echoing)
  800ae1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ae5:	74 0e                	je     800af5 <atomic_readline+0x8f>
				cputchar(c);
  800ae7:	83 ec 0c             	sub    $0xc,%esp
  800aea:	ff 75 ec             	pushl  -0x14(%ebp)
  800aed:	e8 65 0f 00 00       	call   801a57 <cputchar>
  800af2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b08:	88 10                	mov    %dl,(%eax)
  800b0a:	eb 5b                	jmp    800b67 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b0c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b10:	75 1f                	jne    800b31 <atomic_readline+0xcb>
  800b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b16:	7e 19                	jle    800b31 <atomic_readline+0xcb>
			if (echoing)
  800b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1c:	74 0e                	je     800b2c <atomic_readline+0xc6>
				cputchar(c);
  800b1e:	83 ec 0c             	sub    $0xc,%esp
  800b21:	ff 75 ec             	pushl  -0x14(%ebp)
  800b24:	e8 2e 0f 00 00       	call   801a57 <cputchar>
  800b29:	83 c4 10             	add    $0x10,%esp
			i--;
  800b2c:	ff 4d f4             	decl   -0xc(%ebp)
  800b2f:	eb 36                	jmp    800b67 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b31:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b35:	74 0a                	je     800b41 <atomic_readline+0xdb>
  800b37:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b3b:	0f 85 60 ff ff ff    	jne    800aa1 <atomic_readline+0x3b>
			if (echoing)
  800b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b45:	74 0e                	je     800b55 <atomic_readline+0xef>
				cputchar(c);
  800b47:	83 ec 0c             	sub    $0xc,%esp
  800b4a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4d:	e8 05 0f 00 00       	call   801a57 <cputchar>
  800b52:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	01 d0                	add    %edx,%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b60:	e8 2a 09 00 00       	call   80148f <sys_enable_interrupt>
			return;
  800b65:	eb 05                	jmp    800b6c <atomic_readline+0x106>
		}
	}
  800b67:	e9 35 ff ff ff       	jmp    800aa1 <atomic_readline+0x3b>
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b7b:	eb 06                	jmp    800b83 <strlen+0x15>
		n++;
  800b7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b80:	ff 45 08             	incl   0x8(%ebp)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	75 f1                	jne    800b7d <strlen+0xf>
		n++;
	return n;
  800b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 09                	jmp    800ba9 <strnlen+0x18>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	ff 4d 0c             	decl   0xc(%ebp)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 09                	je     800bb8 <strnlen+0x27>
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e8                	jne    800ba0 <strnlen+0xf>
		n++;
	return n;
  800bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bc9:	90                   	nop
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8d 50 01             	lea    0x1(%eax),%edx
  800bd0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bdc:	8a 12                	mov    (%edx),%dl
  800bde:	88 10                	mov    %dl,(%eax)
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e4                	jne    800bca <strcpy+0xd>
		/* do nothing */;
	return ret;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfe:	eb 1f                	jmp    800c1f <strncpy+0x34>
		*dst++ = *src;
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 08             	mov    %edx,0x8(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	8a 12                	mov    (%edx),%dl
  800c0e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	84 c0                	test   %al,%al
  800c17:	74 03                	je     800c1c <strncpy+0x31>
			src++;
  800c19:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c1c:	ff 45 fc             	incl   -0x4(%ebp)
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c22:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c25:	72 d9                	jb     800c00 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3c:	74 30                	je     800c6e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c3e:	eb 16                	jmp    800c56 <strlcpy+0x2a>
			*dst++ = *src++;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 08             	mov    %edx,0x8(%ebp)
  800c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c52:	8a 12                	mov    (%edx),%dl
  800c54:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c56:	ff 4d 10             	decl   0x10(%ebp)
  800c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5d:	74 09                	je     800c68 <strlcpy+0x3c>
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	75 d8                	jne    800c40 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c74:	29 c2                	sub    %eax,%edx
  800c76:	89 d0                	mov    %edx,%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c7d:	eb 06                	jmp    800c85 <strcmp+0xb>
		p++, q++;
  800c7f:	ff 45 08             	incl   0x8(%ebp)
  800c82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	84 c0                	test   %al,%al
  800c8c:	74 0e                	je     800c9c <strcmp+0x22>
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 10                	mov    (%eax),%dl
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	38 c2                	cmp    %al,%dl
  800c9a:	74 e3                	je     800c7f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	0f b6 d0             	movzbl %al,%edx
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 c0             	movzbl %al,%eax
  800cac:	29 c2                	sub    %eax,%edx
  800cae:	89 d0                	mov    %edx,%eax
}
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cb5:	eb 09                	jmp    800cc0 <strncmp+0xe>
		n--, p++, q++;
  800cb7:	ff 4d 10             	decl   0x10(%ebp)
  800cba:	ff 45 08             	incl   0x8(%ebp)
  800cbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc4:	74 17                	je     800cdd <strncmp+0x2b>
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	84 c0                	test   %al,%al
  800ccd:	74 0e                	je     800cdd <strncmp+0x2b>
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 10                	mov    (%eax),%dl
  800cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	38 c2                	cmp    %al,%dl
  800cdb:	74 da                	je     800cb7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce1:	75 07                	jne    800cea <strncmp+0x38>
		return 0;
  800ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce8:	eb 14                	jmp    800cfe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	0f b6 d0             	movzbl %al,%edx
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	0f b6 c0             	movzbl %al,%eax
  800cfa:	29 c2                	sub    %eax,%edx
  800cfc:	89 d0                	mov    %edx,%eax
}
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 04             	sub    $0x4,%esp
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d0c:	eb 12                	jmp    800d20 <strchr+0x20>
		if (*s == c)
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d16:	75 05                	jne    800d1d <strchr+0x1d>
			return (char *) s;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	eb 11                	jmp    800d2e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	84 c0                	test   %al,%al
  800d27:	75 e5                	jne    800d0e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 04             	sub    $0x4,%esp
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3c:	eb 0d                	jmp    800d4b <strfind+0x1b>
		if (*s == c)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d46:	74 0e                	je     800d56 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	75 ea                	jne    800d3e <strfind+0xe>
  800d54:	eb 01                	jmp    800d57 <strfind+0x27>
		if (*s == c)
			break;
  800d56:	90                   	nop
	return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d6e:	eb 0e                	jmp    800d7e <memset+0x22>
		*p++ = c;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d73:	8d 50 01             	lea    0x1(%eax),%edx
  800d76:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d7e:	ff 4d f8             	decl   -0x8(%ebp)
  800d81:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d85:	79 e9                	jns    800d70 <memset+0x14>
		*p++ = c;

	return v;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d9e:	eb 16                	jmp    800db6 <memcpy+0x2a>
		*d++ = *s++;
  800da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da3:	8d 50 01             	lea    0x1(%eax),%edx
  800da6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800da9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800daf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db2:	8a 12                	mov    (%edx),%dl
  800db4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800db6:	8b 45 10             	mov    0x10(%ebp),%eax
  800db9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbc:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	75 dd                	jne    800da0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de0:	73 50                	jae    800e32 <memmove+0x6a>
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8b 45 10             	mov    0x10(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
  800dea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ded:	76 43                	jbe    800e32 <memmove+0x6a>
		s += n;
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dfb:	eb 10                	jmp    800e0d <memmove+0x45>
			*--d = *--s;
  800dfd:	ff 4d f8             	decl   -0x8(%ebp)
  800e00:	ff 4d fc             	decl   -0x4(%ebp)
  800e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e06:	8a 10                	mov    (%eax),%dl
  800e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	75 e3                	jne    800dfd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e1a:	eb 23                	jmp    800e3f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	8d 50 01             	lea    0x1(%eax),%edx
  800e22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2e:	8a 12                	mov    (%edx),%dl
  800e30:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e32:	8b 45 10             	mov    0x10(%ebp),%eax
  800e35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e38:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	75 dd                	jne    800e1c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e56:	eb 2a                	jmp    800e82 <memcmp+0x3e>
		if (*s1 != *s2)
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	8a 10                	mov    (%eax),%dl
  800e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	38 c2                	cmp    %al,%dl
  800e64:	74 16                	je     800e7c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f b6 d0             	movzbl %al,%edx
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	0f b6 c0             	movzbl %al,%eax
  800e76:	29 c2                	sub    %eax,%edx
  800e78:	89 d0                	mov    %edx,%eax
  800e7a:	eb 18                	jmp    800e94 <memcmp+0x50>
		s1++, s2++;
  800e7c:	ff 45 fc             	incl   -0x4(%ebp)
  800e7f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e82:	8b 45 10             	mov    0x10(%ebp),%eax
  800e85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e88:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	75 c9                	jne    800e58 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	01 d0                	add    %edx,%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ea7:	eb 15                	jmp    800ebe <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f b6 d0             	movzbl %al,%edx
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	0f b6 c0             	movzbl %al,%eax
  800eb7:	39 c2                	cmp    %eax,%edx
  800eb9:	74 0d                	je     800ec8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ec4:	72 e3                	jb     800ea9 <memfind+0x13>
  800ec6:	eb 01                	jmp    800ec9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ec8:	90                   	nop
	return (void *) s;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800edb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee2:	eb 03                	jmp    800ee7 <strtol+0x19>
		s++;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	3c 20                	cmp    $0x20,%al
  800eee:	74 f4                	je     800ee4 <strtol+0x16>
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3c 09                	cmp    $0x9,%al
  800ef7:	74 eb                	je     800ee4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 2b                	cmp    $0x2b,%al
  800f00:	75 05                	jne    800f07 <strtol+0x39>
		s++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	eb 13                	jmp    800f1a <strtol+0x4c>
	else if (*s == '-')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 2d                	cmp    $0x2d,%al
  800f0e:	75 0a                	jne    800f1a <strtol+0x4c>
		s++, neg = 1;
  800f10:	ff 45 08             	incl   0x8(%ebp)
  800f13:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 06                	je     800f26 <strtol+0x58>
  800f20:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f24:	75 20                	jne    800f46 <strtol+0x78>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 30                	cmp    $0x30,%al
  800f2d:	75 17                	jne    800f46 <strtol+0x78>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	40                   	inc    %eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 78                	cmp    $0x78,%al
  800f37:	75 0d                	jne    800f46 <strtol+0x78>
		s += 2, base = 16;
  800f39:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f3d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f44:	eb 28                	jmp    800f6e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4a:	75 15                	jne    800f61 <strtol+0x93>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 30                	cmp    $0x30,%al
  800f53:	75 0c                	jne    800f61 <strtol+0x93>
		s++, base = 8;
  800f55:	ff 45 08             	incl   0x8(%ebp)
  800f58:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f5f:	eb 0d                	jmp    800f6e <strtol+0xa0>
	else if (base == 0)
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	75 07                	jne    800f6e <strtol+0xa0>
		base = 10;
  800f67:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 2f                	cmp    $0x2f,%al
  800f75:	7e 19                	jle    800f90 <strtol+0xc2>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 39                	cmp    $0x39,%al
  800f7e:	7f 10                	jg     800f90 <strtol+0xc2>
			dig = *s - '0';
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be c0             	movsbl %al,%eax
  800f88:	83 e8 30             	sub    $0x30,%eax
  800f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f8e:	eb 42                	jmp    800fd2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 60                	cmp    $0x60,%al
  800f97:	7e 19                	jle    800fb2 <strtol+0xe4>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 7a                	cmp    $0x7a,%al
  800fa0:	7f 10                	jg     800fb2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	0f be c0             	movsbl %al,%eax
  800faa:	83 e8 57             	sub    $0x57,%eax
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb0:	eb 20                	jmp    800fd2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 40                	cmp    $0x40,%al
  800fb9:	7e 39                	jle    800ff4 <strtol+0x126>
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	3c 5a                	cmp    $0x5a,%al
  800fc2:	7f 30                	jg     800ff4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	0f be c0             	movsbl %al,%eax
  800fcc:	83 e8 37             	sub    $0x37,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fd8:	7d 19                	jge    800ff3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	01 d0                	add    %edx,%eax
  800feb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fee:	e9 7b ff ff ff       	jmp    800f6e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ff3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ff4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ff8:	74 08                	je     801002 <strtol+0x134>
		*endptr = (char *) s;
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801002:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801006:	74 07                	je     80100f <strtol+0x141>
  801008:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100b:	f7 d8                	neg    %eax
  80100d:	eb 03                	jmp    801012 <strtol+0x144>
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <ltostr>:

void
ltostr(long value, char *str)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80102c:	79 13                	jns    801041 <ltostr+0x2d>
	{
		neg = 1;
  80102e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80103b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80103e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801049:	99                   	cltd   
  80104a:	f7 f9                	idiv   %ecx
  80104c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	8d 50 01             	lea    0x1(%eax),%edx
  801055:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801058:	89 c2                	mov    %eax,%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801062:	83 c2 30             	add    $0x30,%edx
  801065:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801067:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80106f:	f7 e9                	imul   %ecx
  801071:	c1 fa 02             	sar    $0x2,%edx
  801074:	89 c8                	mov    %ecx,%eax
  801076:	c1 f8 1f             	sar    $0x1f,%eax
  801079:	29 c2                	sub    %eax,%edx
  80107b:	89 d0                	mov    %edx,%eax
  80107d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801083:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801088:	f7 e9                	imul   %ecx
  80108a:	c1 fa 02             	sar    $0x2,%edx
  80108d:	89 c8                	mov    %ecx,%eax
  80108f:	c1 f8 1f             	sar    $0x1f,%eax
  801092:	29 c2                	sub    %eax,%edx
  801094:	89 d0                	mov    %edx,%eax
  801096:	c1 e0 02             	shl    $0x2,%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	01 c0                	add    %eax,%eax
  80109d:	29 c1                	sub    %eax,%ecx
  80109f:	89 ca                	mov    %ecx,%edx
  8010a1:	85 d2                	test   %edx,%edx
  8010a3:	75 9c                	jne    801041 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	48                   	dec    %eax
  8010b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 3d                	je     8010f6 <ltostr+0xe2>
		start = 1 ;
  8010b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c0:	eb 34                	jmp    8010f6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	01 c2                	add    %eax,%edx
  8010d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	01 c8                	add    %ecx,%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010ee:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010fc:	7c c4                	jl     8010c2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	01 d0                	add    %edx,%eax
  801106:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801109:	90                   	nop
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801112:	ff 75 08             	pushl  0x8(%ebp)
  801115:	e8 54 fa ff ff       	call   800b6e <strlen>
  80111a:	83 c4 04             	add    $0x4,%esp
  80111d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801120:	ff 75 0c             	pushl  0xc(%ebp)
  801123:	e8 46 fa ff ff       	call   800b6e <strlen>
  801128:	83 c4 04             	add    $0x4,%esp
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80112e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113c:	eb 17                	jmp    801155 <strcconcat+0x49>
		final[s] = str1[s] ;
  80113e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	01 c2                	add    %eax,%edx
  801146:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	01 c8                	add    %ecx,%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801152:	ff 45 fc             	incl   -0x4(%ebp)
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80115b:	7c e1                	jl     80113e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80115d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801164:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80116b:	eb 1f                	jmp    80118c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801170:	8d 50 01             	lea    0x1(%eax),%edx
  801173:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801176:	89 c2                	mov    %eax,%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 c2                	add    %eax,%edx
  80117d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	01 c8                	add    %ecx,%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801189:	ff 45 f8             	incl   -0x8(%ebp)
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c d9                	jl     80116d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801194:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c5:	eb 0c                	jmp    8011d3 <strsplit+0x31>
			*string++ = 0;
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8d 50 01             	lea    0x1(%eax),%edx
  8011cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	84 c0                	test   %al,%al
  8011da:	74 18                	je     8011f4 <strsplit+0x52>
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	0f be c0             	movsbl %al,%eax
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	e8 13 fb ff ff       	call   800d00 <strchr>
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	75 d3                	jne    8011c7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 5a                	je     801257 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	8b 00                	mov    (%eax),%eax
  801202:	83 f8 0f             	cmp    $0xf,%eax
  801205:	75 07                	jne    80120e <strsplit+0x6c>
		{
			return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	eb 66                	jmp    801274 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	8b 00                	mov    (%eax),%eax
  801213:	8d 48 01             	lea    0x1(%eax),%ecx
  801216:	8b 55 14             	mov    0x14(%ebp),%edx
  801219:	89 0a                	mov    %ecx,(%edx)
  80121b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	01 c2                	add    %eax,%edx
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122c:	eb 03                	jmp    801231 <strsplit+0x8f>
			string++;
  80122e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	74 8b                	je     8011c5 <strsplit+0x23>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	50                   	push   %eax
  801243:	ff 75 0c             	pushl  0xc(%ebp)
  801246:	e8 b5 fa ff ff       	call   800d00 <strchr>
  80124b:	83 c4 08             	add    $0x8,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	74 dc                	je     80122e <strsplit+0x8c>
			string++;
	}
  801252:	e9 6e ff ff ff       	jmp    8011c5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801257:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801264:	8b 45 10             	mov    0x10(%ebp),%eax
  801267:	01 d0                	add    %edx,%eax
  801269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80126f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80127c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801283:	eb 4c                	jmp    8012d1 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801285:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 40                	cmp    $0x40,%al
  801291:	7e 27                	jle    8012ba <str2lower+0x44>
  801293:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 5a                	cmp    $0x5a,%al
  80129f:	7f 19                	jg     8012ba <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8012a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	01 d0                	add    %edx,%eax
  8012a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	01 ca                	add    %ecx,%edx
  8012b1:	8a 12                	mov    (%edx),%dl
  8012b3:	83 c2 20             	add    $0x20,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
  8012b8:	eb 14                	jmp    8012ce <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8012ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	01 c2                	add    %eax,%edx
  8012c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 c8                	add    %ecx,%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8012ce:	ff 45 fc             	incl   -0x4(%ebp)
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 95 f8 ff ff       	call   800b6e <strlen>
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012df:	7f a4                	jg     801285 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8012e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	57                   	push   %edi
  8012f5:	56                   	push   %esi
  8012f6:	53                   	push   %ebx
  8012f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801303:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801306:	8b 7d 18             	mov    0x18(%ebp),%edi
  801309:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80130c:	cd 30                	int    $0x30
  80130e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801311:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	5b                   	pop    %ebx
  801318:	5e                   	pop    %esi
  801319:	5f                   	pop    %edi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801328:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	52                   	push   %edx
  801334:	ff 75 0c             	pushl  0xc(%ebp)
  801337:	50                   	push   %eax
  801338:	6a 00                	push   $0x0
  80133a:	e8 b2 ff ff ff       	call   8012f1 <syscall>
  80133f:	83 c4 18             	add    $0x18,%esp
}
  801342:	90                   	nop
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <sys_cgetc>:

int
sys_cgetc(void)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 01                	push   $0x1
  801354:	e8 98 ff ff ff       	call   8012f1 <syscall>
  801359:	83 c4 18             	add    $0x18,%esp
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801361:	8b 55 0c             	mov    0xc(%ebp),%edx
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	52                   	push   %edx
  80136e:	50                   	push   %eax
  80136f:	6a 05                	push   $0x5
  801371:	e8 7b ff ff ff       	call   8012f1 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801380:	8b 75 18             	mov    0x18(%ebp),%esi
  801383:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801386:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	51                   	push   %ecx
  801392:	52                   	push   %edx
  801393:	50                   	push   %eax
  801394:	6a 06                	push   $0x6
  801396:	e8 56 ff ff ff       	call   8012f1 <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	52                   	push   %edx
  8013b5:	50                   	push   %eax
  8013b6:	6a 07                	push   $0x7
  8013b8:	e8 34 ff ff ff       	call   8012f1 <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	6a 08                	push   $0x8
  8013d3:	e8 19 ff ff ff       	call   8012f1 <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 09                	push   $0x9
  8013ec:	e8 00 ff ff ff       	call   8012f1 <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 0a                	push   $0xa
  801405:	e8 e7 fe ff ff       	call   8012f1 <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 0b                	push   $0xb
  80141e:	e8 ce fe ff ff       	call   8012f1 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 0c                	push   $0xc
  801437:	e8 b5 fe ff ff       	call   8012f1 <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	ff 75 08             	pushl  0x8(%ebp)
  80144f:	6a 0d                	push   $0xd
  801451:	e8 9b fe ff ff       	call   8012f1 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 0e                	push   $0xe
  80146a:	e8 82 fe ff ff       	call   8012f1 <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	90                   	nop
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 11                	push   $0x11
  801484:	e8 68 fe ff ff       	call   8012f1 <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	90                   	nop
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 12                	push   $0x12
  80149e:	e8 4e fe ff ff       	call   8012f1 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	50                   	push   %eax
  8014c2:	6a 13                	push   $0x13
  8014c4:	e8 28 fe ff ff       	call   8012f1 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 14                	push   $0x14
  8014de:	e8 0e fe ff ff       	call   8012f1 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	90                   	nop
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	50                   	push   %eax
  8014f9:	6a 15                	push   $0x15
  8014fb:	e8 f1 fd ff ff       	call   8012f1 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 18                	push   $0x18
  801518:	e8 d4 fd ff ff       	call   8012f1 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	52                   	push   %edx
  801532:	50                   	push   %eax
  801533:	6a 16                	push   $0x16
  801535:	e8 b7 fd ff ff       	call   8012f1 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	52                   	push   %edx
  801550:	50                   	push   %eax
  801551:	6a 17                	push   $0x17
  801553:	e8 99 fd ff ff       	call   8012f1 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
}
  80155b:	90                   	nop
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	8b 45 10             	mov    0x10(%ebp),%eax
  801567:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80156a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80156d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	51                   	push   %ecx
  801577:	52                   	push   %edx
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	50                   	push   %eax
  80157c:	6a 19                	push   $0x19
  80157e:	e8 6e fd ff ff       	call   8012f1 <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	52                   	push   %edx
  801598:	50                   	push   %eax
  801599:	6a 1a                	push   $0x1a
  80159b:	e8 51 fd ff ff       	call   8012f1 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	51                   	push   %ecx
  8015b6:	52                   	push   %edx
  8015b7:	50                   	push   %eax
  8015b8:	6a 1b                	push   $0x1b
  8015ba:	e8 32 fd ff ff       	call   8012f1 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	52                   	push   %edx
  8015d4:	50                   	push   %eax
  8015d5:	6a 1c                	push   $0x1c
  8015d7:	e8 15 fd ff ff       	call   8012f1 <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 1d                	push   $0x1d
  8015f0:	e8 fc fc ff ff       	call   8012f1 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	ff 75 14             	pushl  0x14(%ebp)
  801605:	ff 75 10             	pushl  0x10(%ebp)
  801608:	ff 75 0c             	pushl  0xc(%ebp)
  80160b:	50                   	push   %eax
  80160c:	6a 1e                	push   $0x1e
  80160e:	e8 de fc ff ff       	call   8012f1 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	50                   	push   %eax
  801627:	6a 1f                	push   $0x1f
  801629:	e8 c3 fc ff ff       	call   8012f1 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	90                   	nop
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	50                   	push   %eax
  801643:	6a 20                	push   $0x20
  801645:	e8 a7 fc ff ff       	call   8012f1 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 02                	push   $0x2
  80165e:	e8 8e fc ff ff       	call   8012f1 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 03                	push   $0x3
  801677:	e8 75 fc ff ff       	call   8012f1 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 04                	push   $0x4
  801690:	e8 5c fc ff ff       	call   8012f1 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_exit_env>:


void sys_exit_env(void)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 21                	push   $0x21
  8016a9:	e8 43 fc ff ff       	call   8012f1 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	90                   	nop
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016bd:	8d 50 04             	lea    0x4(%eax),%edx
  8016c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	6a 22                	push   $0x22
  8016cd:	e8 1f fc ff ff       	call   8012f1 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
	return result;
  8016d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016de:	89 01                	mov    %eax,(%ecx)
  8016e0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	c9                   	leave  
  8016e7:	c2 04 00             	ret    $0x4

008016ea <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	ff 75 10             	pushl  0x10(%ebp)
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	6a 10                	push   $0x10
  8016fc:	e8 f0 fb ff ff       	call   8012f1 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
	return ;
  801704:	90                   	nop
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_rcr2>:
uint32 sys_rcr2()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 23                	push   $0x23
  801716:	e8 d6 fb ff ff       	call   8012f1 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80172c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	50                   	push   %eax
  801739:	6a 24                	push   $0x24
  80173b:	e8 b1 fb ff ff       	call   8012f1 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return ;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <rsttst>:
void rsttst()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 26                	push   $0x26
  801755:	e8 97 fb ff ff       	call   8012f1 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
	return ;
  80175d:	90                   	nop
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	8b 45 14             	mov    0x14(%ebp),%eax
  801769:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80176c:	8b 55 18             	mov    0x18(%ebp),%edx
  80176f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	ff 75 10             	pushl  0x10(%ebp)
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	6a 25                	push   $0x25
  801780:	e8 6c fb ff ff       	call   8012f1 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
	return ;
  801788:	90                   	nop
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <chktst>:
void chktst(uint32 n)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	6a 27                	push   $0x27
  80179b:	e8 51 fb ff ff       	call   8012f1 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a3:	90                   	nop
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <inctst>:

void inctst()
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 28                	push   $0x28
  8017b5:	e8 37 fb ff ff       	call   8012f1 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bd:	90                   	nop
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <gettst>:
uint32 gettst()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 29                	push   $0x29
  8017cf:	e8 1d fb ff ff       	call   8012f1 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 2a                	push   $0x2a
  8017eb:	e8 01 fb ff ff       	call   8012f1 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
  8017f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017f6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017fa:	75 07                	jne    801803 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801801:	eb 05                	jmp    801808 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 2a                	push   $0x2a
  80181c:	e8 d0 fa ff ff       	call   8012f1 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
  801824:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801827:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80182b:	75 07                	jne    801834 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80182d:	b8 01 00 00 00       	mov    $0x1,%eax
  801832:	eb 05                	jmp    801839 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 2a                	push   $0x2a
  80184d:	e8 9f fa ff ff       	call   8012f1 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801858:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80185c:	75 07                	jne    801865 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80185e:	b8 01 00 00 00       	mov    $0x1,%eax
  801863:	eb 05                	jmp    80186a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 2a                	push   $0x2a
  80187e:	e8 6e fa ff ff       	call   8012f1 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
  801886:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801889:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80188d:	75 07                	jne    801896 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80188f:	b8 01 00 00 00       	mov    $0x1,%eax
  801894:	eb 05                	jmp    80189b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	6a 2b                	push   $0x2b
  8018ad:	e8 3f fa ff ff       	call   8012f1 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b5:	90                   	nop
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	53                   	push   %ebx
  8018cb:	51                   	push   %ecx
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	6a 2c                	push   $0x2c
  8018d0:	e8 1c fa ff ff       	call   8012f1 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	6a 2d                	push   $0x2d
  8018f0:	e8 fc f9 ff ff       	call   8012f1 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	51                   	push   %ecx
  801909:	ff 75 10             	pushl  0x10(%ebp)
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 2e                	push   $0x2e
  801910:	e8 dc f9 ff ff       	call   8012f1 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 10             	pushl  0x10(%ebp)
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	6a 0f                	push   $0xf
  80192c:	e8 c0 f9 ff ff       	call   8012f1 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return ;
  801934:	90                   	nop
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	50                   	push   %eax
  801946:	6a 2f                	push   $0x2f
  801948:	e8 a4 f9 ff ff       	call   8012f1 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp

}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 30                	push   $0x30
  801963:	e8 89 f9 ff ff       	call   8012f1 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp

}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 31                	push   $0x31
  80197f:	e8 6d f9 ff ff       	call   8012f1 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp

}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_hard_limit>:
uint32 sys_hard_limit(){
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 32                	push   $0x32
  801999:	e8 53 f9 ff ff       	call   8012f1 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8019a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ac:	89 d0                	mov    %edx,%eax
  8019ae:	c1 e0 02             	shl    $0x2,%eax
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019cc:	01 d0                	add    %edx,%eax
  8019ce:	c1 e0 04             	shl    $0x4,%eax
  8019d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8019d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8019db:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	50                   	push   %eax
  8019e2:	e8 cd fc ff ff       	call   8016b4 <sys_get_virtual_time>
  8019e7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8019ea:	eb 41                	jmp    801a2d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8019ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	50                   	push   %eax
  8019f3:	e8 bc fc ff ff       	call   8016b4 <sys_get_virtual_time>
  8019f8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a01:	29 c2                	sub    %eax,%edx
  801a03:	89 d0                	mov    %edx,%eax
  801a05:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0e:	89 d1                	mov    %edx,%ecx
  801a10:	29 c1                	sub    %eax,%ecx
  801a12:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a18:	39 c2                	cmp    %eax,%edx
  801a1a:	0f 97 c0             	seta   %al
  801a1d:	0f b6 c0             	movzbl %al,%eax
  801a20:	29 c1                	sub    %eax,%ecx
  801a22:	89 c8                	mov    %ecx,%eax
  801a24:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a33:	72 b7                	jb     8019ec <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a35:	90                   	nop
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801a3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801a45:	eb 03                	jmp    801a4a <busy_wait+0x12>
  801a47:	ff 45 fc             	incl   -0x4(%ebp)
  801a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a50:	72 f5                	jb     801a47 <busy_wait+0xf>
	return i;
  801a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a63:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	50                   	push   %eax
  801a6b:	e8 39 fa ff ff       	call   8014a9 <sys_cputc>
  801a70:	83 c4 10             	add    $0x10,%esp
}
  801a73:	90                   	nop
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801a7c:	e8 f4 f9 ff ff       	call   801475 <sys_disable_interrupt>
	char c = ch;
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a87:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a8b:	83 ec 0c             	sub    $0xc,%esp
  801a8e:	50                   	push   %eax
  801a8f:	e8 15 fa ff ff       	call   8014a9 <sys_cputc>
  801a94:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801a97:	e8 f3 f9 ff ff       	call   80148f <sys_enable_interrupt>
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <getchar>:

int
getchar(void)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801aac:	eb 08                	jmp    801ab6 <getchar+0x17>
	{
		c = sys_cgetc();
  801aae:	e8 92 f8 ff ff       	call   801345 <sys_cgetc>
  801ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aba:	74 f2                	je     801aae <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <atomic_getchar>:

int
atomic_getchar(void)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801ac7:	e8 a9 f9 ff ff       	call   801475 <sys_disable_interrupt>
	int c=0;
  801acc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801ad3:	eb 08                	jmp    801add <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801ad5:	e8 6b f8 ff ff       	call   801345 <sys_cgetc>
  801ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ae1:	74 f2                	je     801ad5 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801ae3:	e8 a7 f9 ff ff       	call   80148f <sys_enable_interrupt>
	return c;
  801ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <iscons>:

int iscons(int fdnum)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801af0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    
  801af7:	90                   	nop

00801af8 <__udivdi3>:
  801af8:	55                   	push   %ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b0f:	89 ca                	mov    %ecx,%edx
  801b11:	89 f8                	mov    %edi,%eax
  801b13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b17:	85 f6                	test   %esi,%esi
  801b19:	75 2d                	jne    801b48 <__udivdi3+0x50>
  801b1b:	39 cf                	cmp    %ecx,%edi
  801b1d:	77 65                	ja     801b84 <__udivdi3+0x8c>
  801b1f:	89 fd                	mov    %edi,%ebp
  801b21:	85 ff                	test   %edi,%edi
  801b23:	75 0b                	jne    801b30 <__udivdi3+0x38>
  801b25:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	f7 f7                	div    %edi
  801b2e:	89 c5                	mov    %eax,%ebp
  801b30:	31 d2                	xor    %edx,%edx
  801b32:	89 c8                	mov    %ecx,%eax
  801b34:	f7 f5                	div    %ebp
  801b36:	89 c1                	mov    %eax,%ecx
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	f7 f5                	div    %ebp
  801b3c:	89 cf                	mov    %ecx,%edi
  801b3e:	89 fa                	mov    %edi,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	39 ce                	cmp    %ecx,%esi
  801b4a:	77 28                	ja     801b74 <__udivdi3+0x7c>
  801b4c:	0f bd fe             	bsr    %esi,%edi
  801b4f:	83 f7 1f             	xor    $0x1f,%edi
  801b52:	75 40                	jne    801b94 <__udivdi3+0x9c>
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	72 0a                	jb     801b62 <__udivdi3+0x6a>
  801b58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b5c:	0f 87 9e 00 00 00    	ja     801c00 <__udivdi3+0x108>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	89 fa                	mov    %edi,%edx
  801b69:	83 c4 1c             	add    $0x1c,%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5e                   	pop    %esi
  801b6e:	5f                   	pop    %edi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    
  801b71:	8d 76 00             	lea    0x0(%esi),%esi
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	31 c0                	xor    %eax,%eax
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	83 c4 1c             	add    $0x1c,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	f7 f7                	div    %edi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	89 fa                	mov    %edi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b99:	89 eb                	mov    %ebp,%ebx
  801b9b:	29 fb                	sub    %edi,%ebx
  801b9d:	89 f9                	mov    %edi,%ecx
  801b9f:	d3 e6                	shl    %cl,%esi
  801ba1:	89 c5                	mov    %eax,%ebp
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 ed                	shr    %cl,%ebp
  801ba7:	89 e9                	mov    %ebp,%ecx
  801ba9:	09 f1                	or     %esi,%ecx
  801bab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801baf:	89 f9                	mov    %edi,%ecx
  801bb1:	d3 e0                	shl    %cl,%eax
  801bb3:	89 c5                	mov    %eax,%ebp
  801bb5:	89 d6                	mov    %edx,%esi
  801bb7:	88 d9                	mov    %bl,%cl
  801bb9:	d3 ee                	shr    %cl,%esi
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e2                	shl    %cl,%edx
  801bbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 e8                	shr    %cl,%eax
  801bc7:	09 c2                	or     %eax,%edx
  801bc9:	89 d0                	mov    %edx,%eax
  801bcb:	89 f2                	mov    %esi,%edx
  801bcd:	f7 74 24 0c          	divl   0xc(%esp)
  801bd1:	89 d6                	mov    %edx,%esi
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	f7 e5                	mul    %ebp
  801bd7:	39 d6                	cmp    %edx,%esi
  801bd9:	72 19                	jb     801bf4 <__udivdi3+0xfc>
  801bdb:	74 0b                	je     801be8 <__udivdi3+0xf0>
  801bdd:	89 d8                	mov    %ebx,%eax
  801bdf:	31 ff                	xor    %edi,%edi
  801be1:	e9 58 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bec:	89 f9                	mov    %edi,%ecx
  801bee:	d3 e2                	shl    %cl,%edx
  801bf0:	39 c2                	cmp    %eax,%edx
  801bf2:	73 e9                	jae    801bdd <__udivdi3+0xe5>
  801bf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bf7:	31 ff                	xor    %edi,%edi
  801bf9:	e9 40 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	31 c0                	xor    %eax,%eax
  801c02:	e9 37 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801c07:	90                   	nop

00801c08 <__umoddi3>:
  801c08:	55                   	push   %ebp
  801c09:	57                   	push   %edi
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 1c             	sub    $0x1c,%esp
  801c0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c27:	89 f3                	mov    %esi,%ebx
  801c29:	89 fa                	mov    %edi,%edx
  801c2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2f:	89 34 24             	mov    %esi,(%esp)
  801c32:	85 c0                	test   %eax,%eax
  801c34:	75 1a                	jne    801c50 <__umoddi3+0x48>
  801c36:	39 f7                	cmp    %esi,%edi
  801c38:	0f 86 a2 00 00 00    	jbe    801ce0 <__umoddi3+0xd8>
  801c3e:	89 c8                	mov    %ecx,%eax
  801c40:	89 f2                	mov    %esi,%edx
  801c42:	f7 f7                	div    %edi
  801c44:	89 d0                	mov    %edx,%eax
  801c46:	31 d2                	xor    %edx,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 f0                	cmp    %esi,%eax
  801c52:	0f 87 ac 00 00 00    	ja     801d04 <__umoddi3+0xfc>
  801c58:	0f bd e8             	bsr    %eax,%ebp
  801c5b:	83 f5 1f             	xor    $0x1f,%ebp
  801c5e:	0f 84 ac 00 00 00    	je     801d10 <__umoddi3+0x108>
  801c64:	bf 20 00 00 00       	mov    $0x20,%edi
  801c69:	29 ef                	sub    %ebp,%edi
  801c6b:	89 fe                	mov    %edi,%esi
  801c6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c71:	89 e9                	mov    %ebp,%ecx
  801c73:	d3 e0                	shl    %cl,%eax
  801c75:	89 d7                	mov    %edx,%edi
  801c77:	89 f1                	mov    %esi,%ecx
  801c79:	d3 ef                	shr    %cl,%edi
  801c7b:	09 c7                	or     %eax,%edi
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e2                	shl    %cl,%edx
  801c81:	89 14 24             	mov    %edx,(%esp)
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	d3 e0                	shl    %cl,%eax
  801c88:	89 c2                	mov    %eax,%edx
  801c8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c8e:	d3 e0                	shl    %cl,%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c98:	89 f1                	mov    %esi,%ecx
  801c9a:	d3 e8                	shr    %cl,%eax
  801c9c:	09 d0                	or     %edx,%eax
  801c9e:	d3 eb                	shr    %cl,%ebx
  801ca0:	89 da                	mov    %ebx,%edx
  801ca2:	f7 f7                	div    %edi
  801ca4:	89 d3                	mov    %edx,%ebx
  801ca6:	f7 24 24             	mull   (%esp)
  801ca9:	89 c6                	mov    %eax,%esi
  801cab:	89 d1                	mov    %edx,%ecx
  801cad:	39 d3                	cmp    %edx,%ebx
  801caf:	0f 82 87 00 00 00    	jb     801d3c <__umoddi3+0x134>
  801cb5:	0f 84 91 00 00 00    	je     801d4c <__umoddi3+0x144>
  801cbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cbf:	29 f2                	sub    %esi,%edx
  801cc1:	19 cb                	sbb    %ecx,%ebx
  801cc3:	89 d8                	mov    %ebx,%eax
  801cc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cc9:	d3 e0                	shl    %cl,%eax
  801ccb:	89 e9                	mov    %ebp,%ecx
  801ccd:	d3 ea                	shr    %cl,%edx
  801ccf:	09 d0                	or     %edx,%eax
  801cd1:	89 e9                	mov    %ebp,%ecx
  801cd3:	d3 eb                	shr    %cl,%ebx
  801cd5:	89 da                	mov    %ebx,%edx
  801cd7:	83 c4 1c             	add    $0x1c,%esp
  801cda:	5b                   	pop    %ebx
  801cdb:	5e                   	pop    %esi
  801cdc:	5f                   	pop    %edi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    
  801cdf:	90                   	nop
  801ce0:	89 fd                	mov    %edi,%ebp
  801ce2:	85 ff                	test   %edi,%edi
  801ce4:	75 0b                	jne    801cf1 <__umoddi3+0xe9>
  801ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f7                	div    %edi
  801cef:	89 c5                	mov    %eax,%ebp
  801cf1:	89 f0                	mov    %esi,%eax
  801cf3:	31 d2                	xor    %edx,%edx
  801cf5:	f7 f5                	div    %ebp
  801cf7:	89 c8                	mov    %ecx,%eax
  801cf9:	f7 f5                	div    %ebp
  801cfb:	89 d0                	mov    %edx,%eax
  801cfd:	e9 44 ff ff ff       	jmp    801c46 <__umoddi3+0x3e>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	89 c8                	mov    %ecx,%eax
  801d06:	89 f2                	mov    %esi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	3b 04 24             	cmp    (%esp),%eax
  801d13:	72 06                	jb     801d1b <__umoddi3+0x113>
  801d15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d19:	77 0f                	ja     801d2a <__umoddi3+0x122>
  801d1b:	89 f2                	mov    %esi,%edx
  801d1d:	29 f9                	sub    %edi,%ecx
  801d1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d23:	89 14 24             	mov    %edx,(%esp)
  801d26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d2e:	8b 14 24             	mov    (%esp),%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d 76 00             	lea    0x0(%esi),%esi
  801d3c:	2b 04 24             	sub    (%esp),%eax
  801d3f:	19 fa                	sbb    %edi,%edx
  801d41:	89 d1                	mov    %edx,%ecx
  801d43:	89 c6                	mov    %eax,%esi
  801d45:	e9 71 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d50:	72 ea                	jb     801d3c <__umoddi3+0x134>
  801d52:	89 d9                	mov    %ebx,%ecx
  801d54:	e9 62 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
