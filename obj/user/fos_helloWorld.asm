
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 a0 19 80 00       	push   $0x8019a0
  800046:	e8 54 02 00 00       	call   80029f <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 8d 19 80 00       	mov    0x80198d,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 c8 19 80 00       	push   $0x8019c8
  80005c:	e8 3e 02 00 00       	call   80029f <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 7c 13 00 00       	call   8013ee <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 03             	shl    $0x3,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	01 c0                	add    %eax,%eax
  800081:	01 d0                	add    %edx,%eax
  800083:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80008a:	01 d0                	add    %edx,%eax
  80008c:	c1 e0 04             	shl    $0x4,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 20 20 80 00       	mov    0x802020,%eax
  80009e:	8a 40 5c             	mov    0x5c(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0d                	je     8000b2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000aa:	83 c0 5c             	add    $0x5c,%eax
  8000ad:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b6:	7e 0a                	jle    8000c2 <libmain+0x5b>
		binaryname = argv[0];
  8000b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 68 ff ff ff       	call   800038 <_main>
  8000d0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d3:	e8 23 11 00 00       	call   8011fb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 f4 19 80 00       	push   $0x8019f4
  8000e0:	e8 8d 01 00 00       	call   800272 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ed:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000f3:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f8:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	52                   	push   %edx
  800102:	50                   	push   %eax
  800103:	68 1c 1a 80 00       	push   $0x801a1c
  800108:	e8 65 01 00 00       	call   800272 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800110:	a1 20 20 80 00       	mov    0x802020,%eax
  800115:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80011b:	a1 20 20 80 00       	mov    0x802020,%eax
  800120:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800126:	a1 20 20 80 00       	mov    0x802020,%eax
  80012b:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800131:	51                   	push   %ecx
  800132:	52                   	push   %edx
  800133:	50                   	push   %eax
  800134:	68 44 1a 80 00       	push   $0x801a44
  800139:	e8 34 01 00 00       	call   800272 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800141:	a1 20 20 80 00       	mov    0x802020,%eax
  800146:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	68 9c 1a 80 00       	push   $0x801a9c
  800155:	e8 18 01 00 00       	call   800272 <cprintf>
  80015a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 f4 19 80 00       	push   $0x8019f4
  800165:	e8 08 01 00 00       	call   800272 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80016d:	e8 a3 10 00 00       	call   801215 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800172:	e8 19 00 00 00       	call   800190 <exit>
}
  800177:	90                   	nop
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 30 12 00 00       	call   8013ba <sys_destroy_env>
  80018a:	83 c4 10             	add    $0x10,%esp
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <exit>:

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800196:	e8 85 12 00 00       	call   801420 <sys_exit_env>
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	8b 00                	mov    (%eax),%eax
  8001a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001af:	89 0a                	mov    %ecx,(%edx)
  8001b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b4:	88 d1                	mov    %dl,%cl
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c0:	8b 00                	mov    (%eax),%eax
  8001c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c7:	75 2c                	jne    8001f5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c9:	a0 24 20 80 00       	mov    0x802024,%al
  8001ce:	0f b6 c0             	movzbl %al,%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	8b 12                	mov    (%edx),%edx
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	83 c2 08             	add    $0x8,%edx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	50                   	push   %eax
  8001e2:	51                   	push   %ecx
  8001e3:	52                   	push   %edx
  8001e4:	e8 b9 0e 00 00       	call   8010a2 <sys_cputs>
  8001e9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f8:	8b 40 04             	mov    0x4(%eax),%eax
  8001fb:	8d 50 01             	lea    0x1(%eax),%edx
  8001fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800201:	89 50 04             	mov    %edx,0x4(%eax)
}
  800204:	90                   	nop
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800210:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800217:	00 00 00 
	b.cnt = 0;
  80021a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800221:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800224:	ff 75 0c             	pushl  0xc(%ebp)
  800227:	ff 75 08             	pushl  0x8(%ebp)
  80022a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800230:	50                   	push   %eax
  800231:	68 9e 01 80 00       	push   $0x80019e
  800236:	e8 11 02 00 00       	call   80044c <vprintfmt>
  80023b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80023e:	a0 24 20 80 00       	mov    0x802024,%al
  800243:	0f b6 c0             	movzbl %al,%eax
  800246:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	50                   	push   %eax
  800250:	52                   	push   %edx
  800251:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800257:	83 c0 08             	add    $0x8,%eax
  80025a:	50                   	push   %eax
  80025b:	e8 42 0e 00 00       	call   8010a2 <sys_cputs>
  800260:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800263:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80026a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <cprintf>:

int cprintf(const char *fmt, ...) {
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800278:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80027f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	ff 75 f4             	pushl  -0xc(%ebp)
  80028e:	50                   	push   %eax
  80028f:	e8 73 ff ff ff       	call   800207 <vcprintf>
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80029a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002a5:	e8 51 0f 00 00       	call   8011fb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b9:	50                   	push   %eax
  8002ba:	e8 48 ff ff ff       	call   800207 <vcprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002c5:	e8 4b 0f 00 00       	call   801215 <sys_enable_interrupt>
	return cnt;
  8002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 14             	sub    $0x14,%esp
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ed:	77 55                	ja     800344 <printnum+0x75>
  8002ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f2:	72 05                	jb     8002f9 <printnum+0x2a>
  8002f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002f7:	77 4b                	ja     800344 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ff:	8b 45 18             	mov    0x18(%ebp),%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
  800307:	52                   	push   %edx
  800308:	50                   	push   %eax
  800309:	ff 75 f4             	pushl  -0xc(%ebp)
  80030c:	ff 75 f0             	pushl  -0x10(%ebp)
  80030f:	e8 18 14 00 00       	call   80172c <__udivdi3>
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	ff 75 20             	pushl  0x20(%ebp)
  80031d:	53                   	push   %ebx
  80031e:	ff 75 18             	pushl  0x18(%ebp)
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 a1 ff ff ff       	call   8002cf <printnum>
  80032e:	83 c4 20             	add    $0x20,%esp
  800331:	eb 1a                	jmp    80034d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 0c             	pushl  0xc(%ebp)
  800339:	ff 75 20             	pushl  0x20(%ebp)
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	ff d0                	call   *%eax
  800341:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800344:	ff 4d 1c             	decl   0x1c(%ebp)
  800347:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80034b:	7f e6                	jg     800333 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800350:	bb 00 00 00 00       	mov    $0x0,%ebx
  800355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80035b:	53                   	push   %ebx
  80035c:	51                   	push   %ecx
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	e8 d8 14 00 00       	call   80183c <__umoddi3>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  80036c:	8a 00                	mov    (%eax),%al
  80036e:	0f be c0             	movsbl %al,%eax
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	50                   	push   %eax
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	ff d0                	call   *%eax
  80037d:	83 c4 10             	add    $0x10,%esp
}
  800380:	90                   	nop
  800381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800389:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80038d:	7e 1c                	jle    8003ab <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 50 08             	lea    0x8(%eax),%edx
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 10                	mov    %edx,(%eax)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	83 e8 08             	sub    $0x8,%eax
  8003a4:	8b 50 04             	mov    0x4(%eax),%edx
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	eb 40                	jmp    8003eb <getuint+0x65>
	else if (lflag)
  8003ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003af:	74 1e                	je     8003cf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	8d 50 04             	lea    0x4(%eax),%edx
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	89 10                	mov    %edx,(%eax)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	83 e8 04             	sub    $0x4,%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cd:	eb 1c                	jmp    8003eb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	8d 50 04             	lea    0x4(%eax),%edx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	89 10                	mov    %edx,(%eax)
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	83 e8 04             	sub    $0x4,%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f4:	7e 1c                	jle    800412 <getint+0x25>
		return va_arg(*ap, long long);
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	8d 50 08             	lea    0x8(%eax),%edx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	89 10                	mov    %edx,(%eax)
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	83 e8 08             	sub    $0x8,%eax
  80040b:	8b 50 04             	mov    0x4(%eax),%edx
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	eb 38                	jmp    80044a <getint+0x5d>
	else if (lflag)
  800412:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800416:	74 1a                	je     800432 <getint+0x45>
		return va_arg(*ap, long);
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	8d 50 04             	lea    0x4(%eax),%edx
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	89 10                	mov    %edx,(%eax)
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	83 e8 04             	sub    $0x4,%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	99                   	cltd   
  800430:	eb 18                	jmp    80044a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	8d 50 04             	lea    0x4(%eax),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	89 10                	mov    %edx,(%eax)
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	83 e8 04             	sub    $0x4,%eax
  800447:	8b 00                	mov    (%eax),%eax
  800449:	99                   	cltd   
}
  80044a:	5d                   	pop    %ebp
  80044b:	c3                   	ret    

0080044c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	56                   	push   %esi
  800450:	53                   	push   %ebx
  800451:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800454:	eb 17                	jmp    80046d <vprintfmt+0x21>
			if (ch == '\0')
  800456:	85 db                	test   %ebx,%ebx
  800458:	0f 84 af 03 00 00    	je     80080d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 0c             	pushl  0xc(%ebp)
  800464:	53                   	push   %ebx
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	ff d0                	call   *%eax
  80046a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046d:	8b 45 10             	mov    0x10(%ebp),%eax
  800470:	8d 50 01             	lea    0x1(%eax),%edx
  800473:	89 55 10             	mov    %edx,0x10(%ebp)
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f b6 d8             	movzbl %al,%ebx
  80047b:	83 fb 25             	cmp    $0x25,%ebx
  80047e:	75 d6                	jne    800456 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800480:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800484:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80048b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800492:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800499:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a3:	8d 50 01             	lea    0x1(%eax),%edx
  8004a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a9:	8a 00                	mov    (%eax),%al
  8004ab:	0f b6 d8             	movzbl %al,%ebx
  8004ae:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b1:	83 f8 55             	cmp    $0x55,%eax
  8004b4:	0f 87 2b 03 00 00    	ja     8007e5 <vprintfmt+0x399>
  8004ba:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  8004c1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004c7:	eb d7                	jmp    8004a0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004cd:	eb d1                	jmp    8004a0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 d0                	mov    %edx,%eax
  8004db:	c1 e0 02             	shl    $0x2,%eax
  8004de:	01 d0                	add    %edx,%eax
  8004e0:	01 c0                	add    %eax,%eax
  8004e2:	01 d8                	add    %ebx,%eax
  8004e4:	83 e8 30             	sub    $0x30,%eax
  8004e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ed:	8a 00                	mov    (%eax),%al
  8004ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f5:	7e 3e                	jle    800535 <vprintfmt+0xe9>
  8004f7:	83 fb 39             	cmp    $0x39,%ebx
  8004fa:	7f 39                	jg     800535 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ff:	eb d5                	jmp    8004d6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	83 c0 04             	add    $0x4,%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	83 e8 04             	sub    $0x4,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800515:	eb 1f                	jmp    800536 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800517:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051b:	79 83                	jns    8004a0 <vprintfmt+0x54>
				width = 0;
  80051d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800524:	e9 77 ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800529:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800530:	e9 6b ff ff ff       	jmp    8004a0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800535:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053a:	0f 89 60 ff ff ff    	jns    8004a0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800546:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80054d:	e9 4e ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800552:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800555:	e9 46 ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 c0 04             	add    $0x4,%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	83 e8 04             	sub    $0x4,%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	ff d0                	call   *%eax
  800577:	83 c4 10             	add    $0x10,%esp
			break;
  80057a:	e9 89 02 00 00       	jmp    800808 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	83 c0 04             	add    $0x4,%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	83 e8 04             	sub    $0x4,%eax
  80058e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800590:	85 db                	test   %ebx,%ebx
  800592:	79 02                	jns    800596 <vprintfmt+0x14a>
				err = -err;
  800594:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800596:	83 fb 64             	cmp    $0x64,%ebx
  800599:	7f 0b                	jg     8005a6 <vprintfmt+0x15a>
  80059b:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005a2:	85 f6                	test   %esi,%esi
  8005a4:	75 19                	jne    8005bf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a6:	53                   	push   %ebx
  8005a7:	68 e5 1c 80 00       	push   $0x801ce5
  8005ac:	ff 75 0c             	pushl  0xc(%ebp)
  8005af:	ff 75 08             	pushl  0x8(%ebp)
  8005b2:	e8 5e 02 00 00       	call   800815 <printfmt>
  8005b7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005ba:	e9 49 02 00 00       	jmp    800808 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005bf:	56                   	push   %esi
  8005c0:	68 ee 1c 80 00       	push   $0x801cee
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	e8 45 02 00 00       	call   800815 <printfmt>
  8005d0:	83 c4 10             	add    $0x10,%esp
			break;
  8005d3:	e9 30 02 00 00       	jmp    800808 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	83 c0 04             	add    $0x4,%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	83 e8 04             	sub    $0x4,%eax
  8005e7:	8b 30                	mov    (%eax),%esi
  8005e9:	85 f6                	test   %esi,%esi
  8005eb:	75 05                	jne    8005f2 <vprintfmt+0x1a6>
				p = "(null)";
  8005ed:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  8005f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f6:	7e 6d                	jle    800665 <vprintfmt+0x219>
  8005f8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005fc:	74 67                	je     800665 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	50                   	push   %eax
  800605:	56                   	push   %esi
  800606:	e8 0c 03 00 00       	call   800917 <strnlen>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800611:	eb 16                	jmp    800629 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800613:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	50                   	push   %eax
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	ff d0                	call   *%eax
  800623:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800626:	ff 4d e4             	decl   -0x1c(%ebp)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062d:	7f e4                	jg     800613 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062f:	eb 34                	jmp    800665 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800631:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800635:	74 1c                	je     800653 <vprintfmt+0x207>
  800637:	83 fb 1f             	cmp    $0x1f,%ebx
  80063a:	7e 05                	jle    800641 <vprintfmt+0x1f5>
  80063c:	83 fb 7e             	cmp    $0x7e,%ebx
  80063f:	7e 12                	jle    800653 <vprintfmt+0x207>
					putch('?', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	6a 3f                	push   $0x3f
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	ff d0                	call   *%eax
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb 0f                	jmp    800662 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	53                   	push   %ebx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	ff d0                	call   *%eax
  80065f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800662:	ff 4d e4             	decl   -0x1c(%ebp)
  800665:	89 f0                	mov    %esi,%eax
  800667:	8d 70 01             	lea    0x1(%eax),%esi
  80066a:	8a 00                	mov    (%eax),%al
  80066c:	0f be d8             	movsbl %al,%ebx
  80066f:	85 db                	test   %ebx,%ebx
  800671:	74 24                	je     800697 <vprintfmt+0x24b>
  800673:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800677:	78 b8                	js     800631 <vprintfmt+0x1e5>
  800679:	ff 4d e0             	decl   -0x20(%ebp)
  80067c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800680:	79 af                	jns    800631 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800682:	eb 13                	jmp    800697 <vprintfmt+0x24b>
				putch(' ', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	6a 20                	push   $0x20
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	ff d0                	call   *%eax
  800691:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800694:	ff 4d e4             	decl   -0x1c(%ebp)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069b:	7f e7                	jg     800684 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80069d:	e9 66 01 00 00       	jmp    800808 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	e8 3c fd ff ff       	call   8003ed <getint>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	79 23                	jns    8006e7 <vprintfmt+0x29b>
				putch('-', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	6a 2d                	push   $0x2d
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006da:	f7 d8                	neg    %eax
  8006dc:	83 d2 00             	adc    $0x0,%edx
  8006df:	f7 da                	neg    %edx
  8006e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006ee:	e9 bc 00 00 00       	jmp    8007af <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fc:	50                   	push   %eax
  8006fd:	e8 84 fc ff ff       	call   800386 <getuint>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800708:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80070b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800712:	e9 98 00 00 00       	jmp    8007af <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 58                	push   $0x58
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	6a 58                	push   $0x58
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	6a 58                	push   $0x58
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	ff d0                	call   *%eax
  800744:	83 c4 10             	add    $0x10,%esp
			break;
  800747:	e9 bc 00 00 00       	jmp    800808 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	6a 30                	push   $0x30
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	6a 78                	push   $0x78
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800787:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80078e:	eb 1f                	jmp    8007af <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 e8             	pushl  -0x18(%ebp)
  800796:	8d 45 14             	lea    0x14(%ebp),%eax
  800799:	50                   	push   %eax
  80079a:	e8 e7 fb ff ff       	call   800386 <getuint>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007af:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b6:	83 ec 04             	sub    $0x4,%esp
  8007b9:	52                   	push   %edx
  8007ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 00 fb ff ff       	call   8002cf <printnum>
  8007cf:	83 c4 20             	add    $0x20,%esp
			break;
  8007d2:	eb 34                	jmp    800808 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	ff d0                	call   *%eax
  8007e0:	83 c4 10             	add    $0x10,%esp
			break;
  8007e3:	eb 23                	jmp    800808 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	6a 25                	push   $0x25
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	ff d0                	call   *%eax
  8007f2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f5:	ff 4d 10             	decl   0x10(%ebp)
  8007f8:	eb 03                	jmp    8007fd <vprintfmt+0x3b1>
  8007fa:	ff 4d 10             	decl   0x10(%ebp)
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	48                   	dec    %eax
  800801:	8a 00                	mov    (%eax),%al
  800803:	3c 25                	cmp    $0x25,%al
  800805:	75 f3                	jne    8007fa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800807:	90                   	nop
		}
	}
  800808:	e9 47 fc ff ff       	jmp    800454 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80080d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80080e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800811:	5b                   	pop    %ebx
  800812:	5e                   	pop    %esi
  800813:	5d                   	pop    %ebp
  800814:	c3                   	ret    

00800815 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800815:	55                   	push   %ebp
  800816:	89 e5                	mov    %esp,%ebp
  800818:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80081b:	8d 45 10             	lea    0x10(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	ff 75 f4             	pushl  -0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 16 fc ff ff       	call   80044c <vprintfmt>
  800836:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800839:	90                   	nop
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800842:	8b 40 08             	mov    0x8(%eax),%eax
  800845:	8d 50 01             	lea    0x1(%eax),%edx
  800848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80084e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800851:	8b 10                	mov    (%eax),%edx
  800853:	8b 45 0c             	mov    0xc(%ebp),%eax
  800856:	8b 40 04             	mov    0x4(%eax),%eax
  800859:	39 c2                	cmp    %eax,%edx
  80085b:	73 12                	jae    80086f <sprintputch+0x33>
		*b->buf++ = ch;
  80085d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	8d 48 01             	lea    0x1(%eax),%ecx
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
  800868:	89 0a                	mov    %ecx,(%edx)
  80086a:	8b 55 08             	mov    0x8(%ebp),%edx
  80086d:	88 10                	mov    %dl,(%eax)
}
  80086f:	90                   	nop
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	8d 50 ff             	lea    -0x1(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	01 d0                	add    %edx,%eax
  800889:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800897:	74 06                	je     80089f <vsnprintf+0x2d>
  800899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089d:	7f 07                	jg     8008a6 <vsnprintf+0x34>
		return -E_INVAL;
  80089f:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a4:	eb 20                	jmp    8008c6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a6:	ff 75 14             	pushl  0x14(%ebp)
  8008a9:	ff 75 10             	pushl  0x10(%ebp)
  8008ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008af:	50                   	push   %eax
  8008b0:	68 3c 08 80 00       	push   $0x80083c
  8008b5:	e8 92 fb ff ff       	call   80044c <vprintfmt>
  8008ba:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008da:	ff 75 f4             	pushl  -0xc(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	ff 75 08             	pushl  0x8(%ebp)
  8008e4:	e8 89 ff ff ff       	call   800872 <vsnprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800901:	eb 06                	jmp    800909 <strlen+0x15>
		n++;
  800903:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	ff 45 08             	incl   0x8(%ebp)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8a 00                	mov    (%eax),%al
  80090e:	84 c0                	test   %al,%al
  800910:	75 f1                	jne    800903 <strlen+0xf>
		n++;
	return n;
  800912:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800924:	eb 09                	jmp    80092f <strnlen+0x18>
		n++;
  800926:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800929:	ff 45 08             	incl   0x8(%ebp)
  80092c:	ff 4d 0c             	decl   0xc(%ebp)
  80092f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800933:	74 09                	je     80093e <strnlen+0x27>
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8a 00                	mov    (%eax),%al
  80093a:	84 c0                	test   %al,%al
  80093c:	75 e8                	jne    800926 <strnlen+0xf>
		n++;
	return n;
  80093e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800941:	c9                   	leave  
  800942:	c3                   	ret    

00800943 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80094f:	90                   	nop
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8d 50 01             	lea    0x1(%eax),%edx
  800956:	89 55 08             	mov    %edx,0x8(%ebp)
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80095f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800962:	8a 12                	mov    (%edx),%dl
  800964:	88 10                	mov    %dl,(%eax)
  800966:	8a 00                	mov    (%eax),%al
  800968:	84 c0                	test   %al,%al
  80096a:	75 e4                	jne    800950 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80096c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80097d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800984:	eb 1f                	jmp    8009a5 <strncpy+0x34>
		*dst++ = *src;
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8d 50 01             	lea    0x1(%eax),%edx
  80098c:	89 55 08             	mov    %edx,0x8(%ebp)
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	8a 12                	mov    (%edx),%dl
  800994:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	8a 00                	mov    (%eax),%al
  80099b:	84 c0                	test   %al,%al
  80099d:	74 03                	je     8009a2 <strncpy+0x31>
			src++;
  80099f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	ff 45 fc             	incl   -0x4(%ebp)
  8009a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009ab:	72 d9                	jb     800986 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c2:	74 30                	je     8009f4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c4:	eb 16                	jmp    8009dc <strlcpy+0x2a>
			*dst++ = *src++;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8d 50 01             	lea    0x1(%eax),%edx
  8009cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d8:	8a 12                	mov    (%edx),%dl
  8009da:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009dc:	ff 4d 10             	decl   0x10(%ebp)
  8009df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e3:	74 09                	je     8009ee <strlcpy+0x3c>
  8009e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 d8                	jne    8009c6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fa:	29 c2                	sub    %eax,%edx
  8009fc:	89 d0                	mov    %edx,%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a03:	eb 06                	jmp    800a0b <strcmp+0xb>
		p++, q++;
  800a05:	ff 45 08             	incl   0x8(%ebp)
  800a08:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	74 0e                	je     800a22 <strcmp+0x22>
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8a 10                	mov    (%eax),%dl
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	38 c2                	cmp    %al,%dl
  800a20:	74 e3                	je     800a05 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	0f b6 d0             	movzbl %al,%edx
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f b6 c0             	movzbl %al,%eax
  800a32:	29 c2                	sub    %eax,%edx
  800a34:	89 d0                	mov    %edx,%eax
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a3b:	eb 09                	jmp    800a46 <strncmp+0xe>
		n--, p++, q++;
  800a3d:	ff 4d 10             	decl   0x10(%ebp)
  800a40:	ff 45 08             	incl   0x8(%ebp)
  800a43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4a:	74 17                	je     800a63 <strncmp+0x2b>
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	84 c0                	test   %al,%al
  800a53:	74 0e                	je     800a63 <strncmp+0x2b>
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8a 10                	mov    (%eax),%dl
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	8a 00                	mov    (%eax),%al
  800a5f:	38 c2                	cmp    %al,%dl
  800a61:	74 da                	je     800a3d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a67:	75 07                	jne    800a70 <strncmp+0x38>
		return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	eb 14                	jmp    800a84 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8a 00                	mov    (%eax),%al
  800a75:	0f b6 d0             	movzbl %al,%edx
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f b6 c0             	movzbl %al,%eax
  800a80:	29 c2                	sub    %eax,%edx
  800a82:	89 d0                	mov    %edx,%eax
}
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 04             	sub    $0x4,%esp
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a92:	eb 12                	jmp    800aa6 <strchr+0x20>
		if (*s == c)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8a 00                	mov    (%eax),%al
  800a99:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a9c:	75 05                	jne    800aa3 <strchr+0x1d>
			return (char *) s;
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	eb 11                	jmp    800ab4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa3:	ff 45 08             	incl   0x8(%ebp)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	84 c0                	test   %al,%al
  800aad:	75 e5                	jne    800a94 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 04             	sub    $0x4,%esp
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac2:	eb 0d                	jmp    800ad1 <strfind+0x1b>
		if (*s == c)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8a 00                	mov    (%eax),%al
  800ac9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800acc:	74 0e                	je     800adc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ace:	ff 45 08             	incl   0x8(%ebp)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	84 c0                	test   %al,%al
  800ad8:	75 ea                	jne    800ac4 <strfind+0xe>
  800ada:	eb 01                	jmp    800add <strfind+0x27>
		if (*s == c)
			break;
  800adc:	90                   	nop
	return (char *) s;
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af4:	eb 0e                	jmp    800b04 <memset+0x22>
		*p++ = c;
  800af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af9:	8d 50 01             	lea    0x1(%eax),%edx
  800afc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b02:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b04:	ff 4d f8             	decl   -0x8(%ebp)
  800b07:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b0b:	79 e9                	jns    800af6 <memset+0x14>
		*p++ = c;

	return v;
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b24:	eb 16                	jmp    800b3c <memcpy+0x2a>
		*d++ = *s++;
  800b26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b29:	8d 50 01             	lea    0x1(%eax),%edx
  800b2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b38:	8a 12                	mov    (%edx),%dl
  800b3a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b42:	89 55 10             	mov    %edx,0x10(%ebp)
  800b45:	85 c0                	test   %eax,%eax
  800b47:	75 dd                	jne    800b26 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b63:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b66:	73 50                	jae    800bb8 <memmove+0x6a>
  800b68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b73:	76 43                	jbe    800bb8 <memmove+0x6a>
		s += n;
  800b75:	8b 45 10             	mov    0x10(%ebp),%eax
  800b78:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b81:	eb 10                	jmp    800b93 <memmove+0x45>
			*--d = *--s;
  800b83:	ff 4d f8             	decl   -0x8(%ebp)
  800b86:	ff 4d fc             	decl   -0x4(%ebp)
  800b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8c:	8a 10                	mov    (%eax),%dl
  800b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b91:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b93:	8b 45 10             	mov    0x10(%ebp),%eax
  800b96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b99:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9c:	85 c0                	test   %eax,%eax
  800b9e:	75 e3                	jne    800b83 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba0:	eb 23                	jmp    800bc5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb4:	8a 12                	mov    (%edx),%dl
  800bb6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	75 dd                	jne    800ba2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bdc:	eb 2a                	jmp    800c08 <memcmp+0x3e>
		if (*s1 != *s2)
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be1:	8a 10                	mov    (%eax),%dl
  800be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	38 c2                	cmp    %al,%dl
  800bea:	74 16                	je     800c02 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	0f b6 d0             	movzbl %al,%edx
  800bf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	0f b6 c0             	movzbl %al,%eax
  800bfc:	29 c2                	sub    %eax,%edx
  800bfe:	89 d0                	mov    %edx,%eax
  800c00:	eb 18                	jmp    800c1a <memcmp+0x50>
		s1++, s2++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
  800c05:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	75 c9                	jne    800bde <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	01 d0                	add    %edx,%eax
  800c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c2d:	eb 15                	jmp    800c44 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	0f b6 d0             	movzbl %al,%edx
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	0f b6 c0             	movzbl %al,%eax
  800c3d:	39 c2                	cmp    %eax,%edx
  800c3f:	74 0d                	je     800c4e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c41:	ff 45 08             	incl   0x8(%ebp)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c4a:	72 e3                	jb     800c2f <memfind+0x13>
  800c4c:	eb 01                	jmp    800c4f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c4e:	90                   	nop
	return (void *) s;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c68:	eb 03                	jmp    800c6d <strtol+0x19>
		s++;
  800c6a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	3c 20                	cmp    $0x20,%al
  800c74:	74 f4                	je     800c6a <strtol+0x16>
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	3c 09                	cmp    $0x9,%al
  800c7d:	74 eb                	je     800c6a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	3c 2b                	cmp    $0x2b,%al
  800c86:	75 05                	jne    800c8d <strtol+0x39>
		s++;
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	eb 13                	jmp    800ca0 <strtol+0x4c>
	else if (*s == '-')
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3c 2d                	cmp    $0x2d,%al
  800c94:	75 0a                	jne    800ca0 <strtol+0x4c>
		s++, neg = 1;
  800c96:	ff 45 08             	incl   0x8(%ebp)
  800c99:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 06                	je     800cac <strtol+0x58>
  800ca6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800caa:	75 20                	jne    800ccc <strtol+0x78>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3c 30                	cmp    $0x30,%al
  800cb3:	75 17                	jne    800ccc <strtol+0x78>
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	40                   	inc    %eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	3c 78                	cmp    $0x78,%al
  800cbd:	75 0d                	jne    800ccc <strtol+0x78>
		s += 2, base = 16;
  800cbf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cca:	eb 28                	jmp    800cf4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd0:	75 15                	jne    800ce7 <strtol+0x93>
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 30                	cmp    $0x30,%al
  800cd9:	75 0c                	jne    800ce7 <strtol+0x93>
		s++, base = 8;
  800cdb:	ff 45 08             	incl   0x8(%ebp)
  800cde:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce5:	eb 0d                	jmp    800cf4 <strtol+0xa0>
	else if (base == 0)
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	75 07                	jne    800cf4 <strtol+0xa0>
		base = 10;
  800ced:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	3c 2f                	cmp    $0x2f,%al
  800cfb:	7e 19                	jle    800d16 <strtol+0xc2>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	3c 39                	cmp    $0x39,%al
  800d04:	7f 10                	jg     800d16 <strtol+0xc2>
			dig = *s - '0';
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f be c0             	movsbl %al,%eax
  800d0e:	83 e8 30             	sub    $0x30,%eax
  800d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d14:	eb 42                	jmp    800d58 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 60                	cmp    $0x60,%al
  800d1d:	7e 19                	jle    800d38 <strtol+0xe4>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 7a                	cmp    $0x7a,%al
  800d26:	7f 10                	jg     800d38 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f be c0             	movsbl %al,%eax
  800d30:	83 e8 57             	sub    $0x57,%eax
  800d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d36:	eb 20                	jmp    800d58 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 40                	cmp    $0x40,%al
  800d3f:	7e 39                	jle    800d7a <strtol+0x126>
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	3c 5a                	cmp    $0x5a,%al
  800d48:	7f 30                	jg     800d7a <strtol+0x126>
			dig = *s - 'A' + 10;
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f be c0             	movsbl %al,%eax
  800d52:	83 e8 37             	sub    $0x37,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5e:	7d 19                	jge    800d79 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d66:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d6f:	01 d0                	add    %edx,%eax
  800d71:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d74:	e9 7b ff ff ff       	jmp    800cf4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d79:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7e:	74 08                	je     800d88 <strtol+0x134>
		*endptr = (char *) s;
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d8c:	74 07                	je     800d95 <strtol+0x141>
  800d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d91:	f7 d8                	neg    %eax
  800d93:	eb 03                	jmp    800d98 <strtol+0x144>
  800d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <ltostr>:

void
ltostr(long value, char *str)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800da7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db2:	79 13                	jns    800dc7 <ltostr+0x2d>
	{
		neg = 1;
  800db4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dcf:	99                   	cltd   
  800dd0:	f7 f9                	idiv   %ecx
  800dd2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dde:	89 c2                	mov    %eax,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800de8:	83 c2 30             	add    $0x30,%edx
  800deb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ded:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df5:	f7 e9                	imul   %ecx
  800df7:	c1 fa 02             	sar    $0x2,%edx
  800dfa:	89 c8                	mov    %ecx,%eax
  800dfc:	c1 f8 1f             	sar    $0x1f,%eax
  800dff:	29 c2                	sub    %eax,%edx
  800e01:	89 d0                	mov    %edx,%eax
  800e03:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0e:	f7 e9                	imul   %ecx
  800e10:	c1 fa 02             	sar    $0x2,%edx
  800e13:	89 c8                	mov    %ecx,%eax
  800e15:	c1 f8 1f             	sar    $0x1f,%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 d0                	mov    %edx,%eax
  800e1c:	c1 e0 02             	shl    $0x2,%eax
  800e1f:	01 d0                	add    %edx,%eax
  800e21:	01 c0                	add    %eax,%eax
  800e23:	29 c1                	sub    %eax,%ecx
  800e25:	89 ca                	mov    %ecx,%edx
  800e27:	85 d2                	test   %edx,%edx
  800e29:	75 9c                	jne    800dc7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e35:	48                   	dec    %eax
  800e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e3d:	74 3d                	je     800e7c <ltostr+0xe2>
		start = 1 ;
  800e3f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e46:	eb 34                	jmp    800e7c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	01 d0                	add    %edx,%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	01 c2                	add    %eax,%edx
  800e5d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	01 c2                	add    %eax,%edx
  800e71:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e74:	88 02                	mov    %al,(%edx)
		start++ ;
  800e76:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e79:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e82:	7c c4                	jl     800e48 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e84:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e8f:	90                   	nop
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e98:	ff 75 08             	pushl  0x8(%ebp)
  800e9b:	e8 54 fa ff ff       	call   8008f4 <strlen>
  800ea0:	83 c4 04             	add    $0x4,%esp
  800ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	e8 46 fa ff ff       	call   8008f4 <strlen>
  800eae:	83 c4 04             	add    $0x4,%esp
  800eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec2:	eb 17                	jmp    800edb <strcconcat+0x49>
		final[s] = str1[s] ;
  800ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	01 c2                	add    %eax,%edx
  800ecc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	01 c8                	add    %ecx,%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ed8:	ff 45 fc             	incl   -0x4(%ebp)
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ede:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee1:	7c e1                	jl     800ec4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef1:	eb 1f                	jmp    800f12 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	8d 50 01             	lea    0x1(%eax),%edx
  800ef9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800efc:	89 c2                	mov    %eax,%edx
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	01 c2                	add    %eax,%edx
  800f03:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	01 c8                	add    %ecx,%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f0f:	ff 45 f8             	incl   -0x8(%ebp)
  800f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f15:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f18:	7c d9                	jl     800ef3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	c6 00 00             	movb   $0x0,(%eax)
}
  800f25:	90                   	nop
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	01 d0                	add    %edx,%eax
  800f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4b:	eb 0c                	jmp    800f59 <strsplit+0x31>
			*string++ = 0;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8d 50 01             	lea    0x1(%eax),%edx
  800f53:	89 55 08             	mov    %edx,0x8(%ebp)
  800f56:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	84 c0                	test   %al,%al
  800f60:	74 18                	je     800f7a <strsplit+0x52>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f be c0             	movsbl %al,%eax
  800f6a:	50                   	push   %eax
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	e8 13 fb ff ff       	call   800a86 <strchr>
  800f73:	83 c4 08             	add    $0x8,%esp
  800f76:	85 c0                	test   %eax,%eax
  800f78:	75 d3                	jne    800f4d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 5a                	je     800fdd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	8b 00                	mov    (%eax),%eax
  800f88:	83 f8 0f             	cmp    $0xf,%eax
  800f8b:	75 07                	jne    800f94 <strsplit+0x6c>
		{
			return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f92:	eb 66                	jmp    800ffa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f94:	8b 45 14             	mov    0x14(%ebp),%eax
  800f97:	8b 00                	mov    (%eax),%eax
  800f99:	8d 48 01             	lea    0x1(%eax),%ecx
  800f9c:	8b 55 14             	mov    0x14(%ebp),%edx
  800f9f:	89 0a                	mov    %ecx,(%edx)
  800fa1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fab:	01 c2                	add    %eax,%edx
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb2:	eb 03                	jmp    800fb7 <strsplit+0x8f>
			string++;
  800fb4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 8b                	je     800f4b <strsplit+0x23>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f be c0             	movsbl %al,%eax
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 0c             	pushl  0xc(%ebp)
  800fcc:	e8 b5 fa ff ff       	call   800a86 <strchr>
  800fd1:	83 c4 08             	add    $0x8,%esp
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	74 dc                	je     800fb4 <strsplit+0x8c>
			string++;
	}
  800fd8:	e9 6e ff ff ff       	jmp    800f4b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fdd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fde:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe1:	8b 00                	mov    (%eax),%eax
  800fe3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	01 d0                	add    %edx,%eax
  800fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ff5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801009:	eb 4c                	jmp    801057 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 40                	cmp    $0x40,%al
  801017:	7e 27                	jle    801040 <str2lower+0x44>
  801019:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	01 d0                	add    %edx,%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 5a                	cmp    $0x5a,%al
  801025:	7f 19                	jg     801040 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801027:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	01 d0                	add    %edx,%eax
  80102f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801032:	8b 55 0c             	mov    0xc(%ebp),%edx
  801035:	01 ca                	add    %ecx,%edx
  801037:	8a 12                	mov    (%edx),%dl
  801039:	83 c2 20             	add    $0x20,%edx
  80103c:	88 10                	mov    %dl,(%eax)
  80103e:	eb 14                	jmp    801054 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801040:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	01 c2                	add    %eax,%edx
  801048:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	01 c8                	add    %ecx,%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801054:	ff 45 fc             	incl   -0x4(%ebp)
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	e8 95 f8 ff ff       	call   8008f4 <strlen>
  80105f:	83 c4 04             	add    $0x4,%esp
  801062:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801065:	7f a4                	jg     80100b <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801067:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
  80107d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801089:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80108c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80108f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801092:	cd 30                	int    $0x30
  801094:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801097:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80109a:	83 c4 10             	add    $0x10,%esp
  80109d:	5b                   	pop    %ebx
  80109e:	5e                   	pop    %esi
  80109f:	5f                   	pop    %edi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    

008010a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 00                	push   $0x0
  8010b9:	52                   	push   %edx
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	50                   	push   %eax
  8010be:	6a 00                	push   $0x0
  8010c0:	e8 b2 ff ff ff       	call   801077 <syscall>
  8010c5:	83 c4 18             	add    $0x18,%esp
}
  8010c8:	90                   	nop
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <sys_cgetc>:

int
sys_cgetc(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 00                	push   $0x0
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 00                	push   $0x0
  8010d8:	6a 01                	push   $0x1
  8010da:	e8 98 ff ff ff       	call   801077 <syscall>
  8010df:	83 c4 18             	add    $0x18,%esp
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 00                	push   $0x0
  8010f1:	6a 00                	push   $0x0
  8010f3:	52                   	push   %edx
  8010f4:	50                   	push   %eax
  8010f5:	6a 05                	push   $0x5
  8010f7:	e8 7b ff ff ff       	call   801077 <syscall>
  8010fc:	83 c4 18             	add    $0x18,%esp
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801106:	8b 75 18             	mov    0x18(%ebp),%esi
  801109:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80110c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80110f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	51                   	push   %ecx
  801118:	52                   	push   %edx
  801119:	50                   	push   %eax
  80111a:	6a 06                	push   $0x6
  80111c:	e8 56 ff ff ff       	call   801077 <syscall>
  801121:	83 c4 18             	add    $0x18,%esp
}
  801124:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80112e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	52                   	push   %edx
  80113b:	50                   	push   %eax
  80113c:	6a 07                	push   $0x7
  80113e:	e8 34 ff ff ff       	call   801077 <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	ff 75 0c             	pushl  0xc(%ebp)
  801154:	ff 75 08             	pushl  0x8(%ebp)
  801157:	6a 08                	push   $0x8
  801159:	e8 19 ff ff ff       	call   801077 <syscall>
  80115e:	83 c4 18             	add    $0x18,%esp
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 09                	push   $0x9
  801172:	e8 00 ff ff ff       	call   801077 <syscall>
  801177:	83 c4 18             	add    $0x18,%esp
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 0a                	push   $0xa
  80118b:	e8 e7 fe ff ff       	call   801077 <syscall>
  801190:	83 c4 18             	add    $0x18,%esp
}
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 0b                	push   $0xb
  8011a4:	e8 ce fe ff ff       	call   801077 <syscall>
  8011a9:	83 c4 18             	add    $0x18,%esp
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 0c                	push   $0xc
  8011bd:	e8 b5 fe ff ff       	call   801077 <syscall>
  8011c2:	83 c4 18             	add    $0x18,%esp
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	ff 75 08             	pushl  0x8(%ebp)
  8011d5:	6a 0d                	push   $0xd
  8011d7:	e8 9b fe ff ff       	call   801077 <syscall>
  8011dc:	83 c4 18             	add    $0x18,%esp
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 0e                	push   $0xe
  8011f0:	e8 82 fe ff ff       	call   801077 <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	90                   	nop
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011fe:	6a 00                	push   $0x0
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 11                	push   $0x11
  80120a:	e8 68 fe ff ff       	call   801077 <syscall>
  80120f:	83 c4 18             	add    $0x18,%esp
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 12                	push   $0x12
  801224:	e8 4e fe ff ff       	call   801077 <syscall>
  801229:	83 c4 18             	add    $0x18,%esp
}
  80122c:	90                   	nop
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <sys_cputc>:


void
sys_cputc(const char c)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80123b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	50                   	push   %eax
  801248:	6a 13                	push   $0x13
  80124a:	e8 28 fe ff ff       	call   801077 <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	90                   	nop
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 14                	push   $0x14
  801264:	e8 0e fe ff ff       	call   801077 <syscall>
  801269:	83 c4 18             	add    $0x18,%esp
}
  80126c:	90                   	nop
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	50                   	push   %eax
  80127f:	6a 15                	push   $0x15
  801281:	e8 f1 fd ff ff       	call   801077 <syscall>
  801286:	83 c4 18             	add    $0x18,%esp
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	52                   	push   %edx
  80129b:	50                   	push   %eax
  80129c:	6a 18                	push   $0x18
  80129e:	e8 d4 fd ff ff       	call   801077 <syscall>
  8012a3:	83 c4 18             	add    $0x18,%esp
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	52                   	push   %edx
  8012b8:	50                   	push   %eax
  8012b9:	6a 16                	push   $0x16
  8012bb:	e8 b7 fd ff ff       	call   801077 <syscall>
  8012c0:	83 c4 18             	add    $0x18,%esp
}
  8012c3:	90                   	nop
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	52                   	push   %edx
  8012d6:	50                   	push   %eax
  8012d7:	6a 17                	push   $0x17
  8012d9:	e8 99 fd ff ff       	call   801077 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	6a 00                	push   $0x0
  8012fc:	51                   	push   %ecx
  8012fd:	52                   	push   %edx
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	50                   	push   %eax
  801302:	6a 19                	push   $0x19
  801304:	e8 6e fd ff ff       	call   801077 <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	52                   	push   %edx
  80131e:	50                   	push   %eax
  80131f:	6a 1a                	push   $0x1a
  801321:	e8 51 fd ff ff       	call   801077 <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80132e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	51                   	push   %ecx
  80133c:	52                   	push   %edx
  80133d:	50                   	push   %eax
  80133e:	6a 1b                	push   $0x1b
  801340:	e8 32 fd ff ff       	call   801077 <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 1c                	push   $0x1c
  80135d:	e8 15 fd ff ff       	call   801077 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 1d                	push   $0x1d
  801376:	e8 fc fc ff ff       	call   801077 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	6a 00                	push   $0x0
  801388:	ff 75 14             	pushl  0x14(%ebp)
  80138b:	ff 75 10             	pushl  0x10(%ebp)
  80138e:	ff 75 0c             	pushl  0xc(%ebp)
  801391:	50                   	push   %eax
  801392:	6a 1e                	push   $0x1e
  801394:	e8 de fc ff ff       	call   801077 <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	50                   	push   %eax
  8013ad:	6a 1f                	push   $0x1f
  8013af:	e8 c3 fc ff ff       	call   801077 <syscall>
  8013b4:	83 c4 18             	add    $0x18,%esp
}
  8013b7:	90                   	nop
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	50                   	push   %eax
  8013c9:	6a 20                	push   $0x20
  8013cb:	e8 a7 fc ff ff       	call   801077 <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 02                	push   $0x2
  8013e4:	e8 8e fc ff ff       	call   801077 <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 03                	push   $0x3
  8013fd:	e8 75 fc ff ff       	call   801077 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 04                	push   $0x4
  801416:	e8 5c fc ff ff       	call   801077 <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_exit_env>:


void sys_exit_env(void)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 21                	push   $0x21
  80142f:	e8 43 fc ff ff       	call   801077 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	90                   	nop
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801440:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801443:	8d 50 04             	lea    0x4(%eax),%edx
  801446:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	52                   	push   %edx
  801450:	50                   	push   %eax
  801451:	6a 22                	push   $0x22
  801453:	e8 1f fc ff ff       	call   801077 <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
	return result;
  80145b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801464:	89 01                	mov    %eax,(%ecx)
  801466:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	c9                   	leave  
  80146d:	c2 04 00             	ret    $0x4

00801470 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	ff 75 10             	pushl  0x10(%ebp)
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	ff 75 08             	pushl  0x8(%ebp)
  801480:	6a 10                	push   $0x10
  801482:	e8 f0 fb ff ff       	call   801077 <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
	return ;
  80148a:	90                   	nop
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_rcr2>:
uint32 sys_rcr2()
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 23                	push   $0x23
  80149c:	e8 d6 fb ff ff       	call   801077 <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	50                   	push   %eax
  8014bf:	6a 24                	push   $0x24
  8014c1:	e8 b1 fb ff ff       	call   801077 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c9:	90                   	nop
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <rsttst>:
void rsttst()
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 26                	push   $0x26
  8014db:	e8 97 fb ff ff       	call   801077 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e3:	90                   	nop
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8014f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014f9:	52                   	push   %edx
  8014fa:	50                   	push   %eax
  8014fb:	ff 75 10             	pushl  0x10(%ebp)
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	6a 25                	push   $0x25
  801506:	e8 6c fb ff ff       	call   801077 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
	return ;
  80150e:	90                   	nop
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <chktst>:
void chktst(uint32 n)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	6a 27                	push   $0x27
  801521:	e8 51 fb ff ff       	call   801077 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
	return ;
  801529:	90                   	nop
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <inctst>:

void inctst()
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 28                	push   $0x28
  80153b:	e8 37 fb ff ff       	call   801077 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
	return ;
  801543:	90                   	nop
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <gettst>:
uint32 gettst()
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 29                	push   $0x29
  801555:	e8 1d fb ff ff       	call   801077 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 2a                	push   $0x2a
  801571:	e8 01 fb ff ff       	call   801077 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
  801579:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80157c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801580:	75 07                	jne    801589 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801582:	b8 01 00 00 00       	mov    $0x1,%eax
  801587:	eb 05                	jmp    80158e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 2a                	push   $0x2a
  8015a2:	e8 d0 fa ff ff       	call   801077 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
  8015aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015b1:	75 07                	jne    8015ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b8:	eb 05                	jmp    8015bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 2a                	push   $0x2a
  8015d3:	e8 9f fa ff ff       	call   801077 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
  8015db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015e2:	75 07                	jne    8015eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e9:	eb 05                	jmp    8015f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 2a                	push   $0x2a
  801604:	e8 6e fa ff ff       	call   801077 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
  80160c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80160f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801613:	75 07                	jne    80161c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801615:	b8 01 00 00 00       	mov    $0x1,%eax
  80161a:	eb 05                	jmp    801621 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	6a 2b                	push   $0x2b
  801633:	e8 3f fa ff ff       	call   801077 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
	return ;
  80163b:	90                   	nop
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801642:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801645:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	6a 00                	push   $0x0
  801650:	53                   	push   %ebx
  801651:	51                   	push   %ecx
  801652:	52                   	push   %edx
  801653:	50                   	push   %eax
  801654:	6a 2c                	push   $0x2c
  801656:	e8 1c fa ff ff       	call   801077 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	52                   	push   %edx
  801673:	50                   	push   %eax
  801674:	6a 2d                	push   $0x2d
  801676:	e8 fc f9 ff ff       	call   801077 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801683:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	51                   	push   %ecx
  80168f:	ff 75 10             	pushl  0x10(%ebp)
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 2e                	push   $0x2e
  801696:	e8 dc f9 ff ff       	call   801077 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 10             	pushl  0x10(%ebp)
  8016aa:	ff 75 0c             	pushl  0xc(%ebp)
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	6a 0f                	push   $0xf
  8016b2:	e8 c0 f9 ff ff       	call   801077 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ba:	90                   	nop
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	50                   	push   %eax
  8016cc:	6a 2f                	push   $0x2f
  8016ce:	e8 a4 f9 ff ff       	call   801077 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp

}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 30                	push   $0x30
  8016e9:	e8 89 f9 ff ff       	call   801077 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp

}
  8016f1:	90                   	nop
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	6a 31                	push   $0x31
  801705:	e8 6d f9 ff ff       	call   801077 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp

}
  80170d:	90                   	nop
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 32                	push   $0x32
  80171f:	e8 53 f9 ff ff       	call   801077 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    
  801729:	66 90                	xchg   %ax,%ax
  80172b:	90                   	nop

0080172c <__udivdi3>:
  80172c:	55                   	push   %ebp
  80172d:	57                   	push   %edi
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	83 ec 1c             	sub    $0x1c,%esp
  801733:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801737:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80173b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80173f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801743:	89 ca                	mov    %ecx,%edx
  801745:	89 f8                	mov    %edi,%eax
  801747:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80174b:	85 f6                	test   %esi,%esi
  80174d:	75 2d                	jne    80177c <__udivdi3+0x50>
  80174f:	39 cf                	cmp    %ecx,%edi
  801751:	77 65                	ja     8017b8 <__udivdi3+0x8c>
  801753:	89 fd                	mov    %edi,%ebp
  801755:	85 ff                	test   %edi,%edi
  801757:	75 0b                	jne    801764 <__udivdi3+0x38>
  801759:	b8 01 00 00 00       	mov    $0x1,%eax
  80175e:	31 d2                	xor    %edx,%edx
  801760:	f7 f7                	div    %edi
  801762:	89 c5                	mov    %eax,%ebp
  801764:	31 d2                	xor    %edx,%edx
  801766:	89 c8                	mov    %ecx,%eax
  801768:	f7 f5                	div    %ebp
  80176a:	89 c1                	mov    %eax,%ecx
  80176c:	89 d8                	mov    %ebx,%eax
  80176e:	f7 f5                	div    %ebp
  801770:	89 cf                	mov    %ecx,%edi
  801772:	89 fa                	mov    %edi,%edx
  801774:	83 c4 1c             	add    $0x1c,%esp
  801777:	5b                   	pop    %ebx
  801778:	5e                   	pop    %esi
  801779:	5f                   	pop    %edi
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    
  80177c:	39 ce                	cmp    %ecx,%esi
  80177e:	77 28                	ja     8017a8 <__udivdi3+0x7c>
  801780:	0f bd fe             	bsr    %esi,%edi
  801783:	83 f7 1f             	xor    $0x1f,%edi
  801786:	75 40                	jne    8017c8 <__udivdi3+0x9c>
  801788:	39 ce                	cmp    %ecx,%esi
  80178a:	72 0a                	jb     801796 <__udivdi3+0x6a>
  80178c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801790:	0f 87 9e 00 00 00    	ja     801834 <__udivdi3+0x108>
  801796:	b8 01 00 00 00       	mov    $0x1,%eax
  80179b:	89 fa                	mov    %edi,%edx
  80179d:	83 c4 1c             	add    $0x1c,%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5f                   	pop    %edi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    
  8017a5:	8d 76 00             	lea    0x0(%esi),%esi
  8017a8:	31 ff                	xor    %edi,%edi
  8017aa:	31 c0                	xor    %eax,%eax
  8017ac:	89 fa                	mov    %edi,%edx
  8017ae:	83 c4 1c             	add    $0x1c,%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5e                   	pop    %esi
  8017b3:	5f                   	pop    %edi
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    
  8017b6:	66 90                	xchg   %ax,%ax
  8017b8:	89 d8                	mov    %ebx,%eax
  8017ba:	f7 f7                	div    %edi
  8017bc:	31 ff                	xor    %edi,%edi
  8017be:	89 fa                	mov    %edi,%edx
  8017c0:	83 c4 1c             	add    $0x1c,%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5e                   	pop    %esi
  8017c5:	5f                   	pop    %edi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    
  8017c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017cd:	89 eb                	mov    %ebp,%ebx
  8017cf:	29 fb                	sub    %edi,%ebx
  8017d1:	89 f9                	mov    %edi,%ecx
  8017d3:	d3 e6                	shl    %cl,%esi
  8017d5:	89 c5                	mov    %eax,%ebp
  8017d7:	88 d9                	mov    %bl,%cl
  8017d9:	d3 ed                	shr    %cl,%ebp
  8017db:	89 e9                	mov    %ebp,%ecx
  8017dd:	09 f1                	or     %esi,%ecx
  8017df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017e3:	89 f9                	mov    %edi,%ecx
  8017e5:	d3 e0                	shl    %cl,%eax
  8017e7:	89 c5                	mov    %eax,%ebp
  8017e9:	89 d6                	mov    %edx,%esi
  8017eb:	88 d9                	mov    %bl,%cl
  8017ed:	d3 ee                	shr    %cl,%esi
  8017ef:	89 f9                	mov    %edi,%ecx
  8017f1:	d3 e2                	shl    %cl,%edx
  8017f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017f7:	88 d9                	mov    %bl,%cl
  8017f9:	d3 e8                	shr    %cl,%eax
  8017fb:	09 c2                	or     %eax,%edx
  8017fd:	89 d0                	mov    %edx,%eax
  8017ff:	89 f2                	mov    %esi,%edx
  801801:	f7 74 24 0c          	divl   0xc(%esp)
  801805:	89 d6                	mov    %edx,%esi
  801807:	89 c3                	mov    %eax,%ebx
  801809:	f7 e5                	mul    %ebp
  80180b:	39 d6                	cmp    %edx,%esi
  80180d:	72 19                	jb     801828 <__udivdi3+0xfc>
  80180f:	74 0b                	je     80181c <__udivdi3+0xf0>
  801811:	89 d8                	mov    %ebx,%eax
  801813:	31 ff                	xor    %edi,%edi
  801815:	e9 58 ff ff ff       	jmp    801772 <__udivdi3+0x46>
  80181a:	66 90                	xchg   %ax,%ax
  80181c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801820:	89 f9                	mov    %edi,%ecx
  801822:	d3 e2                	shl    %cl,%edx
  801824:	39 c2                	cmp    %eax,%edx
  801826:	73 e9                	jae    801811 <__udivdi3+0xe5>
  801828:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80182b:	31 ff                	xor    %edi,%edi
  80182d:	e9 40 ff ff ff       	jmp    801772 <__udivdi3+0x46>
  801832:	66 90                	xchg   %ax,%ax
  801834:	31 c0                	xor    %eax,%eax
  801836:	e9 37 ff ff ff       	jmp    801772 <__udivdi3+0x46>
  80183b:	90                   	nop

0080183c <__umoddi3>:
  80183c:	55                   	push   %ebp
  80183d:	57                   	push   %edi
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 1c             	sub    $0x1c,%esp
  801843:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801847:	8b 74 24 34          	mov    0x34(%esp),%esi
  80184b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80184f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801853:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801857:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80185b:	89 f3                	mov    %esi,%ebx
  80185d:	89 fa                	mov    %edi,%edx
  80185f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801863:	89 34 24             	mov    %esi,(%esp)
  801866:	85 c0                	test   %eax,%eax
  801868:	75 1a                	jne    801884 <__umoddi3+0x48>
  80186a:	39 f7                	cmp    %esi,%edi
  80186c:	0f 86 a2 00 00 00    	jbe    801914 <__umoddi3+0xd8>
  801872:	89 c8                	mov    %ecx,%eax
  801874:	89 f2                	mov    %esi,%edx
  801876:	f7 f7                	div    %edi
  801878:	89 d0                	mov    %edx,%eax
  80187a:	31 d2                	xor    %edx,%edx
  80187c:	83 c4 1c             	add    $0x1c,%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5f                   	pop    %edi
  801882:	5d                   	pop    %ebp
  801883:	c3                   	ret    
  801884:	39 f0                	cmp    %esi,%eax
  801886:	0f 87 ac 00 00 00    	ja     801938 <__umoddi3+0xfc>
  80188c:	0f bd e8             	bsr    %eax,%ebp
  80188f:	83 f5 1f             	xor    $0x1f,%ebp
  801892:	0f 84 ac 00 00 00    	je     801944 <__umoddi3+0x108>
  801898:	bf 20 00 00 00       	mov    $0x20,%edi
  80189d:	29 ef                	sub    %ebp,%edi
  80189f:	89 fe                	mov    %edi,%esi
  8018a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018a5:	89 e9                	mov    %ebp,%ecx
  8018a7:	d3 e0                	shl    %cl,%eax
  8018a9:	89 d7                	mov    %edx,%edi
  8018ab:	89 f1                	mov    %esi,%ecx
  8018ad:	d3 ef                	shr    %cl,%edi
  8018af:	09 c7                	or     %eax,%edi
  8018b1:	89 e9                	mov    %ebp,%ecx
  8018b3:	d3 e2                	shl    %cl,%edx
  8018b5:	89 14 24             	mov    %edx,(%esp)
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	d3 e0                	shl    %cl,%eax
  8018bc:	89 c2                	mov    %eax,%edx
  8018be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018c2:	d3 e0                	shl    %cl,%eax
  8018c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018cc:	89 f1                	mov    %esi,%ecx
  8018ce:	d3 e8                	shr    %cl,%eax
  8018d0:	09 d0                	or     %edx,%eax
  8018d2:	d3 eb                	shr    %cl,%ebx
  8018d4:	89 da                	mov    %ebx,%edx
  8018d6:	f7 f7                	div    %edi
  8018d8:	89 d3                	mov    %edx,%ebx
  8018da:	f7 24 24             	mull   (%esp)
  8018dd:	89 c6                	mov    %eax,%esi
  8018df:	89 d1                	mov    %edx,%ecx
  8018e1:	39 d3                	cmp    %edx,%ebx
  8018e3:	0f 82 87 00 00 00    	jb     801970 <__umoddi3+0x134>
  8018e9:	0f 84 91 00 00 00    	je     801980 <__umoddi3+0x144>
  8018ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018f3:	29 f2                	sub    %esi,%edx
  8018f5:	19 cb                	sbb    %ecx,%ebx
  8018f7:	89 d8                	mov    %ebx,%eax
  8018f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018fd:	d3 e0                	shl    %cl,%eax
  8018ff:	89 e9                	mov    %ebp,%ecx
  801901:	d3 ea                	shr    %cl,%edx
  801903:	09 d0                	or     %edx,%eax
  801905:	89 e9                	mov    %ebp,%ecx
  801907:	d3 eb                	shr    %cl,%ebx
  801909:	89 da                	mov    %ebx,%edx
  80190b:	83 c4 1c             	add    $0x1c,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5e                   	pop    %esi
  801910:	5f                   	pop    %edi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    
  801913:	90                   	nop
  801914:	89 fd                	mov    %edi,%ebp
  801916:	85 ff                	test   %edi,%edi
  801918:	75 0b                	jne    801925 <__umoddi3+0xe9>
  80191a:	b8 01 00 00 00       	mov    $0x1,%eax
  80191f:	31 d2                	xor    %edx,%edx
  801921:	f7 f7                	div    %edi
  801923:	89 c5                	mov    %eax,%ebp
  801925:	89 f0                	mov    %esi,%eax
  801927:	31 d2                	xor    %edx,%edx
  801929:	f7 f5                	div    %ebp
  80192b:	89 c8                	mov    %ecx,%eax
  80192d:	f7 f5                	div    %ebp
  80192f:	89 d0                	mov    %edx,%eax
  801931:	e9 44 ff ff ff       	jmp    80187a <__umoddi3+0x3e>
  801936:	66 90                	xchg   %ax,%ax
  801938:	89 c8                	mov    %ecx,%eax
  80193a:	89 f2                	mov    %esi,%edx
  80193c:	83 c4 1c             	add    $0x1c,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    
  801944:	3b 04 24             	cmp    (%esp),%eax
  801947:	72 06                	jb     80194f <__umoddi3+0x113>
  801949:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80194d:	77 0f                	ja     80195e <__umoddi3+0x122>
  80194f:	89 f2                	mov    %esi,%edx
  801951:	29 f9                	sub    %edi,%ecx
  801953:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801957:	89 14 24             	mov    %edx,(%esp)
  80195a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801962:	8b 14 24             	mov    (%esp),%edx
  801965:	83 c4 1c             	add    $0x1c,%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5f                   	pop    %edi
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    
  80196d:	8d 76 00             	lea    0x0(%esi),%esi
  801970:	2b 04 24             	sub    (%esp),%eax
  801973:	19 fa                	sbb    %edi,%edx
  801975:	89 d1                	mov    %edx,%ecx
  801977:	89 c6                	mov    %eax,%esi
  801979:	e9 71 ff ff ff       	jmp    8018ef <__umoddi3+0xb3>
  80197e:	66 90                	xchg   %ax,%ax
  801980:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801984:	72 ea                	jb     801970 <__umoddi3+0x134>
  801986:	89 d9                	mov    %ebx,%ecx
  801988:	e9 62 ff ff ff       	jmp    8018ef <__umoddi3+0xb3>
