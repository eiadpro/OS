
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 e0 19 80 00       	push   $0x8019e0
  80005b:	e8 5a 02 00 00       	call   8002ba <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 e3 19 80 00       	push   $0x8019e3
  800092:	e8 23 02 00 00       	call   8002ba <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000b5:	e8 7c 13 00 00       	call   801436 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	c1 e0 03             	shl    $0x3,%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	01 c0                	add    %eax,%eax
  8000c9:	01 d0                	add    %edx,%eax
  8000cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d2:	01 d0                	add    %edx,%eax
  8000d4:	c1 e0 04             	shl    $0x4,%eax
  8000d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dc:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e1:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e6:	8a 40 5c             	mov    0x5c(%eax),%al
  8000e9:	84 c0                	test   %al,%al
  8000eb:	74 0d                	je     8000fa <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000ed:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f2:	83 c0 5c             	add    $0x5c,%eax
  8000f5:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000fe:	7e 0a                	jle    80010a <libmain+0x5b>
		binaryname = argv[0];
  800100:	8b 45 0c             	mov    0xc(%ebp),%eax
  800103:	8b 00                	mov    (%eax),%eax
  800105:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	ff 75 0c             	pushl  0xc(%ebp)
  800110:	ff 75 08             	pushl  0x8(%ebp)
  800113:	e8 20 ff ff ff       	call   800038 <_main>
  800118:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80011b:	e8 23 11 00 00       	call   801243 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 00 1a 80 00       	push   $0x801a00
  800128:	e8 8d 01 00 00       	call   8002ba <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800130:	a1 20 20 80 00       	mov    0x802020,%eax
  800135:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80013b:	a1 20 20 80 00       	mov    0x802020,%eax
  800140:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	52                   	push   %edx
  80014a:	50                   	push   %eax
  80014b:	68 28 1a 80 00       	push   $0x801a28
  800150:	e8 65 01 00 00       	call   8002ba <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800158:	a1 20 20 80 00       	mov    0x802020,%eax
  80015d:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800163:	a1 20 20 80 00       	mov    0x802020,%eax
  800168:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80016e:	a1 20 20 80 00       	mov    0x802020,%eax
  800173:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800179:	51                   	push   %ecx
  80017a:	52                   	push   %edx
  80017b:	50                   	push   %eax
  80017c:	68 50 1a 80 00       	push   $0x801a50
  800181:	e8 34 01 00 00       	call   8002ba <cprintf>
  800186:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800189:	a1 20 20 80 00       	mov    0x802020,%eax
  80018e:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	50                   	push   %eax
  800198:	68 a8 1a 80 00       	push   $0x801aa8
  80019d:	e8 18 01 00 00       	call   8002ba <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	68 00 1a 80 00       	push   $0x801a00
  8001ad:	e8 08 01 00 00       	call   8002ba <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001b5:	e8 a3 10 00 00       	call   80125d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001ba:	e8 19 00 00 00       	call   8001d8 <exit>
}
  8001bf:	90                   	nop
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	6a 00                	push   $0x0
  8001cd:	e8 30 12 00 00       	call   801402 <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
}
  8001d5:	90                   	nop
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <exit>:

void
exit(void)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001de:	e8 85 12 00 00       	call   801468 <sys_exit_env>
}
  8001e3:	90                   	nop
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	8b 00                	mov    (%eax),%eax
  8001f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f7:	89 0a                	mov    %ecx,(%edx)
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	88 d1                	mov    %dl,%cl
  8001fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800201:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800205:	8b 45 0c             	mov    0xc(%ebp),%eax
  800208:	8b 00                	mov    (%eax),%eax
  80020a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020f:	75 2c                	jne    80023d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800211:	a0 24 20 80 00       	mov    0x802024,%al
  800216:	0f b6 c0             	movzbl %al,%eax
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	8b 12                	mov    (%edx),%edx
  80021e:	89 d1                	mov    %edx,%ecx
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	83 c2 08             	add    $0x8,%edx
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	50                   	push   %eax
  80022a:	51                   	push   %ecx
  80022b:	52                   	push   %edx
  80022c:	e8 b9 0e 00 00       	call   8010ea <sys_cputs>
  800231:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	8b 40 04             	mov    0x4(%eax),%eax
  800243:	8d 50 01             	lea    0x1(%eax),%edx
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
  800249:	89 50 04             	mov    %edx,0x4(%eax)
}
  80024c:	90                   	nop
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800258:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025f:	00 00 00 
	b.cnt = 0;
  800262:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800269:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80026c:	ff 75 0c             	pushl  0xc(%ebp)
  80026f:	ff 75 08             	pushl  0x8(%ebp)
  800272:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	68 e6 01 80 00       	push   $0x8001e6
  80027e:	e8 11 02 00 00       	call   800494 <vprintfmt>
  800283:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800286:	a0 24 20 80 00       	mov    0x802024,%al
  80028b:	0f b6 c0             	movzbl %al,%eax
  80028e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	50                   	push   %eax
  800298:	52                   	push   %edx
  800299:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029f:	83 c0 08             	add    $0x8,%eax
  8002a2:	50                   	push   %eax
  8002a3:	e8 42 0e 00 00       	call   8010ea <sys_cputs>
  8002a8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ab:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <cprintf>:

int cprintf(const char *fmt, ...) {
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c0:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002c7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d6:	50                   	push   %eax
  8002d7:	e8 73 ff ff ff       	call   80024f <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002ed:	e8 51 0f 00 00       	call   801243 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800301:	50                   	push   %eax
  800302:	e8 48 ff ff ff       	call   80024f <vcprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80030d:	e8 4b 0f 00 00       	call   80125d <sys_enable_interrupt>
	return cnt;
  800312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	53                   	push   %ebx
  80031b:	83 ec 14             	sub    $0x14,%esp
  80031e:	8b 45 10             	mov    0x10(%ebp),%eax
  800321:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800324:	8b 45 14             	mov    0x14(%ebp),%eax
  800327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032a:	8b 45 18             	mov    0x18(%ebp),%eax
  80032d:	ba 00 00 00 00       	mov    $0x0,%edx
  800332:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800335:	77 55                	ja     80038c <printnum+0x75>
  800337:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033a:	72 05                	jb     800341 <printnum+0x2a>
  80033c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033f:	77 4b                	ja     80038c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800341:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800344:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800347:	8b 45 18             	mov    0x18(%ebp),%eax
  80034a:	ba 00 00 00 00       	mov    $0x0,%edx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	ff 75 f4             	pushl  -0xc(%ebp)
  800354:	ff 75 f0             	pushl  -0x10(%ebp)
  800357:	e8 18 14 00 00       	call   801774 <__udivdi3>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 20             	pushl  0x20(%ebp)
  800365:	53                   	push   %ebx
  800366:	ff 75 18             	pushl  0x18(%ebp)
  800369:	52                   	push   %edx
  80036a:	50                   	push   %eax
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	ff 75 08             	pushl  0x8(%ebp)
  800371:	e8 a1 ff ff ff       	call   800317 <printnum>
  800376:	83 c4 20             	add    $0x20,%esp
  800379:	eb 1a                	jmp    800395 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	ff 75 0c             	pushl  0xc(%ebp)
  800381:	ff 75 20             	pushl  0x20(%ebp)
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	ff d0                	call   *%eax
  800389:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038c:	ff 4d 1c             	decl   0x1c(%ebp)
  80038f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800393:	7f e6                	jg     80037b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800398:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a3:	53                   	push   %ebx
  8003a4:	51                   	push   %ecx
  8003a5:	52                   	push   %edx
  8003a6:	50                   	push   %eax
  8003a7:	e8 d8 14 00 00       	call   801884 <__umoddi3>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	05 d4 1c 80 00       	add    $0x801cd4,%eax
  8003b4:	8a 00                	mov    (%eax),%al
  8003b6:	0f be c0             	movsbl %al,%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	ff d0                	call   *%eax
  8003c5:	83 c4 10             	add    $0x10,%esp
}
  8003c8:	90                   	nop
  8003c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d5:	7e 1c                	jle    8003f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 08             	lea    0x8(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 08             	sub    $0x8,%eax
  8003ec:	8b 50 04             	mov    0x4(%eax),%edx
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	eb 40                	jmp    800433 <getuint+0x65>
	else if (lflag)
  8003f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f7:	74 1e                	je     800417 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 04             	sub    $0x4,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	ba 00 00 00 00       	mov    $0x0,%edx
  800415:	eb 1c                	jmp    800433 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	8d 50 04             	lea    0x4(%eax),%edx
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	89 10                	mov    %edx,(%eax)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	83 e8 04             	sub    $0x4,%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800438:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80043c:	7e 1c                	jle    80045a <getint+0x25>
		return va_arg(*ap, long long);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	8d 50 08             	lea    0x8(%eax),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	89 10                	mov    %edx,(%eax)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	83 e8 08             	sub    $0x8,%eax
  800453:	8b 50 04             	mov    0x4(%eax),%edx
  800456:	8b 00                	mov    (%eax),%eax
  800458:	eb 38                	jmp    800492 <getint+0x5d>
	else if (lflag)
  80045a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80045e:	74 1a                	je     80047a <getint+0x45>
		return va_arg(*ap, long);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 50 04             	lea    0x4(%eax),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 10                	mov    %edx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 e8 04             	sub    $0x4,%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	99                   	cltd   
  800478:	eb 18                	jmp    800492 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	8d 50 04             	lea    0x4(%eax),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	89 10                	mov    %edx,(%eax)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	83 e8 04             	sub    $0x4,%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	99                   	cltd   
}
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    

00800494 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	56                   	push   %esi
  800498:	53                   	push   %ebx
  800499:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049c:	eb 17                	jmp    8004b5 <vprintfmt+0x21>
			if (ch == '\0')
  80049e:	85 db                	test   %ebx,%ebx
  8004a0:	0f 84 af 03 00 00    	je     800855 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ac:	53                   	push   %ebx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	ff d0                	call   *%eax
  8004b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b8:	8d 50 01             	lea    0x1(%eax),%edx
  8004bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8004be:	8a 00                	mov    (%eax),%al
  8004c0:	0f b6 d8             	movzbl %al,%ebx
  8004c3:	83 fb 25             	cmp    $0x25,%ebx
  8004c6:	75 d6                	jne    80049e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004eb:	8d 50 01             	lea    0x1(%eax),%edx
  8004ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f1:	8a 00                	mov    (%eax),%al
  8004f3:	0f b6 d8             	movzbl %al,%ebx
  8004f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f9:	83 f8 55             	cmp    $0x55,%eax
  8004fc:	0f 87 2b 03 00 00    	ja     80082d <vprintfmt+0x399>
  800502:	8b 04 85 f8 1c 80 00 	mov    0x801cf8(,%eax,4),%eax
  800509:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80050b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80050f:	eb d7                	jmp    8004e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800511:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800515:	eb d1                	jmp    8004e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800517:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80051e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	c1 e0 02             	shl    $0x2,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	01 c0                	add    %eax,%eax
  80052a:	01 d8                	add    %ebx,%eax
  80052c:	83 e8 30             	sub    $0x30,%eax
  80052f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	8a 00                	mov    (%eax),%al
  800537:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80053a:	83 fb 2f             	cmp    $0x2f,%ebx
  80053d:	7e 3e                	jle    80057d <vprintfmt+0xe9>
  80053f:	83 fb 39             	cmp    $0x39,%ebx
  800542:	7f 39                	jg     80057d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800544:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800547:	eb d5                	jmp    80051e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	83 c0 04             	add    $0x4,%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	83 e8 04             	sub    $0x4,%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80055d:	eb 1f                	jmp    80057e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80055f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800563:	79 83                	jns    8004e8 <vprintfmt+0x54>
				width = 0;
  800565:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80056c:	e9 77 ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800571:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800578:	e9 6b ff ff ff       	jmp    8004e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80057d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80057e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800582:	0f 89 60 ff ff ff    	jns    8004e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800595:	e9 4e ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80059d:	e9 46 ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	83 c0 04             	add    $0x4,%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	83 e8 04             	sub    $0x4,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	ff d0                	call   *%eax
  8005bf:	83 c4 10             	add    $0x10,%esp
			break;
  8005c2:	e9 89 02 00 00       	jmp    800850 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 c0 04             	add    $0x4,%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	83 e8 04             	sub    $0x4,%eax
  8005d6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005d8:	85 db                	test   %ebx,%ebx
  8005da:	79 02                	jns    8005de <vprintfmt+0x14a>
				err = -err;
  8005dc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005de:	83 fb 64             	cmp    $0x64,%ebx
  8005e1:	7f 0b                	jg     8005ee <vprintfmt+0x15a>
  8005e3:	8b 34 9d 40 1b 80 00 	mov    0x801b40(,%ebx,4),%esi
  8005ea:	85 f6                	test   %esi,%esi
  8005ec:	75 19                	jne    800607 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ee:	53                   	push   %ebx
  8005ef:	68 e5 1c 80 00       	push   $0x801ce5
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 5e 02 00 00       	call   80085d <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800602:	e9 49 02 00 00       	jmp    800850 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800607:	56                   	push   %esi
  800608:	68 ee 1c 80 00       	push   $0x801cee
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	ff 75 08             	pushl  0x8(%ebp)
  800613:	e8 45 02 00 00       	call   80085d <printfmt>
  800618:	83 c4 10             	add    $0x10,%esp
			break;
  80061b:	e9 30 02 00 00       	jmp    800850 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 c0 04             	add    $0x4,%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 30                	mov    (%eax),%esi
  800631:	85 f6                	test   %esi,%esi
  800633:	75 05                	jne    80063a <vprintfmt+0x1a6>
				p = "(null)";
  800635:	be f1 1c 80 00       	mov    $0x801cf1,%esi
			if (width > 0 && padc != '-')
  80063a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063e:	7e 6d                	jle    8006ad <vprintfmt+0x219>
  800640:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800644:	74 67                	je     8006ad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	50                   	push   %eax
  80064d:	56                   	push   %esi
  80064e:	e8 0c 03 00 00       	call   80095f <strnlen>
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800659:	eb 16                	jmp    800671 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80065b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80066e:	ff 4d e4             	decl   -0x1c(%ebp)
  800671:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800675:	7f e4                	jg     80065b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800677:	eb 34                	jmp    8006ad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800679:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067d:	74 1c                	je     80069b <vprintfmt+0x207>
  80067f:	83 fb 1f             	cmp    $0x1f,%ebx
  800682:	7e 05                	jle    800689 <vprintfmt+0x1f5>
  800684:	83 fb 7e             	cmp    $0x7e,%ebx
  800687:	7e 12                	jle    80069b <vprintfmt+0x207>
					putch('?', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	6a 3f                	push   $0x3f
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	ff d0                	call   *%eax
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	eb 0f                	jmp    8006aa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	53                   	push   %ebx
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	ff d0                	call   *%eax
  8006a7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	8d 70 01             	lea    0x1(%eax),%esi
  8006b2:	8a 00                	mov    (%eax),%al
  8006b4:	0f be d8             	movsbl %al,%ebx
  8006b7:	85 db                	test   %ebx,%ebx
  8006b9:	74 24                	je     8006df <vprintfmt+0x24b>
  8006bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bf:	78 b8                	js     800679 <vprintfmt+0x1e5>
  8006c1:	ff 4d e0             	decl   -0x20(%ebp)
  8006c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c8:	79 af                	jns    800679 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ca:	eb 13                	jmp    8006df <vprintfmt+0x24b>
				putch(' ', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	6a 20                	push   $0x20
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e3:	7f e7                	jg     8006cc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006e5:	e9 66 01 00 00       	jmp    800850 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	e8 3c fd ff ff       	call   800435 <getint>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800708:	85 d2                	test   %edx,%edx
  80070a:	79 23                	jns    80072f <vprintfmt+0x29b>
				putch('-', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	6a 2d                	push   $0x2d
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80071c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800722:	f7 d8                	neg    %eax
  800724:	83 d2 00             	adc    $0x0,%edx
  800727:	f7 da                	neg    %edx
  800729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80072f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800736:	e9 bc 00 00 00       	jmp    8007f7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 e8             	pushl  -0x18(%ebp)
  800741:	8d 45 14             	lea    0x14(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	e8 84 fc ff ff       	call   8003ce <getuint>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800750:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800753:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075a:	e9 98 00 00 00       	jmp    8007f7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 58                	push   $0x58
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 0c             	pushl  0xc(%ebp)
  800775:	6a 58                	push   $0x58
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	ff d0                	call   *%eax
  80077c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	6a 58                	push   $0x58
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	ff d0                	call   *%eax
  80078c:	83 c4 10             	add    $0x10,%esp
			break;
  80078f:	e9 bc 00 00 00       	jmp    800850 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	6a 30                	push   $0x30
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	6a 78                	push   $0x78
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 e8             	pushl  -0x18(%ebp)
  8007de:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	e8 e7 fb ff ff       	call   8003ce <getuint>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	52                   	push   %edx
  800802:	ff 75 e4             	pushl  -0x1c(%ebp)
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 00 fb ff ff       	call   800317 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
			break;
  80081a:	eb 34                	jmp    800850 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	53                   	push   %ebx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			break;
  80082b:	eb 23                	jmp    800850 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 25                	push   $0x25
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083d:	ff 4d 10             	decl   0x10(%ebp)
  800840:	eb 03                	jmp    800845 <vprintfmt+0x3b1>
  800842:	ff 4d 10             	decl   0x10(%ebp)
  800845:	8b 45 10             	mov    0x10(%ebp),%eax
  800848:	48                   	dec    %eax
  800849:	8a 00                	mov    (%eax),%al
  80084b:	3c 25                	cmp    $0x25,%al
  80084d:	75 f3                	jne    800842 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80084f:	90                   	nop
		}
	}
  800850:	e9 47 fc ff ff       	jmp    80049c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800855:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800856:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800859:	5b                   	pop    %ebx
  80085a:	5e                   	pop    %esi
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800863:	8d 45 10             	lea    0x10(%ebp),%eax
  800866:	83 c0 04             	add    $0x4,%eax
  800869:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80086c:	8b 45 10             	mov    0x10(%ebp),%eax
  80086f:	ff 75 f4             	pushl  -0xc(%ebp)
  800872:	50                   	push   %eax
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 16 fc ff ff       	call   800494 <vprintfmt>
  80087e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800881:	90                   	nop
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088a:	8b 40 08             	mov    0x8(%eax),%eax
  80088d:	8d 50 01             	lea    0x1(%eax),%edx
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
  800893:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800896:	8b 45 0c             	mov    0xc(%ebp),%eax
  800899:	8b 10                	mov    (%eax),%edx
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	8b 40 04             	mov    0x4(%eax),%eax
  8008a1:	39 c2                	cmp    %eax,%edx
  8008a3:	73 12                	jae    8008b7 <sprintputch+0x33>
		*b->buf++ = ch;
  8008a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	89 0a                	mov    %ecx,(%edx)
  8008b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b5:	88 10                	mov    %dl,(%eax)
}
  8008b7:	90                   	nop
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	01 d0                	add    %edx,%eax
  8008d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008df:	74 06                	je     8008e7 <vsnprintf+0x2d>
  8008e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e5:	7f 07                	jg     8008ee <vsnprintf+0x34>
		return -E_INVAL;
  8008e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ec:	eb 20                	jmp    80090e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ee:	ff 75 14             	pushl  0x14(%ebp)
  8008f1:	ff 75 10             	pushl  0x10(%ebp)
  8008f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f7:	50                   	push   %eax
  8008f8:	68 84 08 80 00       	push   $0x800884
  8008fd:	e8 92 fb ff ff       	call   800494 <vprintfmt>
  800902:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800908:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800916:	8d 45 10             	lea    0x10(%ebp),%eax
  800919:	83 c0 04             	add    $0x4,%eax
  80091c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80091f:	8b 45 10             	mov    0x10(%ebp),%eax
  800922:	ff 75 f4             	pushl  -0xc(%ebp)
  800925:	50                   	push   %eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	e8 89 ff ff ff       	call   8008ba <vsnprintf>
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800937:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800949:	eb 06                	jmp    800951 <strlen+0x15>
		n++;
  80094b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80094e:	ff 45 08             	incl   0x8(%ebp)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8a 00                	mov    (%eax),%al
  800956:	84 c0                	test   %al,%al
  800958:	75 f1                	jne    80094b <strlen+0xf>
		n++;
	return n;
  80095a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095d:	c9                   	leave  
  80095e:	c3                   	ret    

0080095f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800965:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80096c:	eb 09                	jmp    800977 <strnlen+0x18>
		n++;
  80096e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800971:	ff 45 08             	incl   0x8(%ebp)
  800974:	ff 4d 0c             	decl   0xc(%ebp)
  800977:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80097b:	74 09                	je     800986 <strnlen+0x27>
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8a 00                	mov    (%eax),%al
  800982:	84 c0                	test   %al,%al
  800984:	75 e8                	jne    80096e <strnlen+0xf>
		n++;
	return n;
  800986:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800997:	90                   	nop
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8d 50 01             	lea    0x1(%eax),%edx
  80099e:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009aa:	8a 12                	mov    (%edx),%dl
  8009ac:	88 10                	mov    %dl,(%eax)
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	84 c0                	test   %al,%al
  8009b2:	75 e4                	jne    800998 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009cc:	eb 1f                	jmp    8009ed <strncpy+0x34>
		*dst++ = *src;
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8d 50 01             	lea    0x1(%eax),%edx
  8009d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	8a 12                	mov    (%edx),%dl
  8009dc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	84 c0                	test   %al,%al
  8009e5:	74 03                	je     8009ea <strncpy+0x31>
			src++;
  8009e7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ea:	ff 45 fc             	incl   -0x4(%ebp)
  8009ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009f3:	72 d9                	jb     8009ce <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a0a:	74 30                	je     800a3c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a0c:	eb 16                	jmp    800a24 <strlcpy+0x2a>
			*dst++ = *src++;
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8d 50 01             	lea    0x1(%eax),%edx
  800a14:	89 55 08             	mov    %edx,0x8(%ebp)
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a1d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a20:	8a 12                	mov    (%edx),%dl
  800a22:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a24:	ff 4d 10             	decl   0x10(%ebp)
  800a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2b:	74 09                	je     800a36 <strlcpy+0x3c>
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8a 00                	mov    (%eax),%al
  800a32:	84 c0                	test   %al,%al
  800a34:	75 d8                	jne    800a0e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a42:	29 c2                	sub    %eax,%edx
  800a44:	89 d0                	mov    %edx,%eax
}
  800a46:	c9                   	leave  
  800a47:	c3                   	ret    

00800a48 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a4b:	eb 06                	jmp    800a53 <strcmp+0xb>
		p++, q++;
  800a4d:	ff 45 08             	incl   0x8(%ebp)
  800a50:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8a 00                	mov    (%eax),%al
  800a58:	84 c0                	test   %al,%al
  800a5a:	74 0e                	je     800a6a <strcmp+0x22>
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8a 10                	mov    (%eax),%dl
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	38 c2                	cmp    %al,%dl
  800a68:	74 e3                	je     800a4d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	0f b6 d0             	movzbl %al,%edx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	0f b6 c0             	movzbl %al,%eax
  800a7a:	29 c2                	sub    %eax,%edx
  800a7c:	89 d0                	mov    %edx,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a83:	eb 09                	jmp    800a8e <strncmp+0xe>
		n--, p++, q++;
  800a85:	ff 4d 10             	decl   0x10(%ebp)
  800a88:	ff 45 08             	incl   0x8(%ebp)
  800a8b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a92:	74 17                	je     800aab <strncmp+0x2b>
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8a 00                	mov    (%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	74 0e                	je     800aab <strncmp+0x2b>
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8a 10                	mov    (%eax),%dl
  800aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	38 c2                	cmp    %al,%dl
  800aa9:	74 da                	je     800a85 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aaf:	75 07                	jne    800ab8 <strncmp+0x38>
		return 0;
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	eb 14                	jmp    800acc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8a 00                	mov    (%eax),%al
  800abd:	0f b6 d0             	movzbl %al,%edx
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	0f b6 c0             	movzbl %al,%eax
  800ac8:	29 c2                	sub    %eax,%edx
  800aca:	89 d0                	mov    %edx,%eax
}
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ada:	eb 12                	jmp    800aee <strchr+0x20>
		if (*s == c)
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8a 00                	mov    (%eax),%al
  800ae1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae4:	75 05                	jne    800aeb <strchr+0x1d>
			return (char *) s;
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	eb 11                	jmp    800afc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aeb:	ff 45 08             	incl   0x8(%ebp)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 e5                	jne    800adc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 04             	sub    $0x4,%esp
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b0a:	eb 0d                	jmp    800b19 <strfind+0x1b>
		if (*s == c)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b14:	74 0e                	je     800b24 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8a 00                	mov    (%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 ea                	jne    800b0c <strfind+0xe>
  800b22:	eb 01                	jmp    800b25 <strfind+0x27>
		if (*s == c)
			break;
  800b24:	90                   	nop
	return (char *) s;
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b36:	8b 45 10             	mov    0x10(%ebp),%eax
  800b39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b3c:	eb 0e                	jmp    800b4c <memset+0x22>
		*p++ = c;
  800b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b41:	8d 50 01             	lea    0x1(%eax),%edx
  800b44:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b4c:	ff 4d f8             	decl   -0x8(%ebp)
  800b4f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b53:	79 e9                	jns    800b3e <memset+0x14>
		*p++ = c;

	return v;
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b6c:	eb 16                	jmp    800b84 <memcpy+0x2a>
		*d++ = *s++;
  800b6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b80:	8a 12                	mov    (%edx),%dl
  800b82:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	75 dd                	jne    800b6e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bae:	73 50                	jae    800c00 <memmove+0x6a>
  800bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb6:	01 d0                	add    %edx,%eax
  800bb8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bbb:	76 43                	jbe    800c00 <memmove+0x6a>
		s += n;
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc9:	eb 10                	jmp    800bdb <memmove+0x45>
			*--d = *--s;
  800bcb:	ff 4d f8             	decl   -0x8(%ebp)
  800bce:	ff 4d fc             	decl   -0x4(%ebp)
  800bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd4:	8a 10                	mov    (%eax),%dl
  800bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bde:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be1:	89 55 10             	mov    %edx,0x10(%ebp)
  800be4:	85 c0                	test   %eax,%eax
  800be6:	75 e3                	jne    800bcb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be8:	eb 23                	jmp    800c0d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bf3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bfc:	8a 12                	mov    (%edx),%dl
  800bfe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	75 dd                	jne    800bea <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c24:	eb 2a                	jmp    800c50 <memcmp+0x3e>
		if (*s1 != *s2)
  800c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c29:	8a 10                	mov    (%eax),%dl
  800c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	38 c2                	cmp    %al,%dl
  800c32:	74 16                	je     800c4a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 d0             	movzbl %al,%edx
  800c3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 c0             	movzbl %al,%eax
  800c44:	29 c2                	sub    %eax,%edx
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	eb 18                	jmp    800c62 <memcmp+0x50>
		s1++, s2++;
  800c4a:	ff 45 fc             	incl   -0x4(%ebp)
  800c4d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	89 55 10             	mov    %edx,0x10(%ebp)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	75 c9                	jne    800c26 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	01 d0                	add    %edx,%eax
  800c72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c75:	eb 15                	jmp    800c8c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	0f b6 d0             	movzbl %al,%edx
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	0f b6 c0             	movzbl %al,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 0d                	je     800c96 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c89:	ff 45 08             	incl   0x8(%ebp)
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c92:	72 e3                	jb     800c77 <memfind+0x13>
  800c94:	eb 01                	jmp    800c97 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c96:	90                   	nop
	return (void *) s;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ca2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb0:	eb 03                	jmp    800cb5 <strtol+0x19>
		s++;
  800cb2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 20                	cmp    $0x20,%al
  800cbc:	74 f4                	je     800cb2 <strtol+0x16>
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3c 09                	cmp    $0x9,%al
  800cc5:	74 eb                	je     800cb2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	3c 2b                	cmp    $0x2b,%al
  800cce:	75 05                	jne    800cd5 <strtol+0x39>
		s++;
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	eb 13                	jmp    800ce8 <strtol+0x4c>
	else if (*s == '-')
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 2d                	cmp    $0x2d,%al
  800cdc:	75 0a                	jne    800ce8 <strtol+0x4c>
		s++, neg = 1;
  800cde:	ff 45 08             	incl   0x8(%ebp)
  800ce1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 06                	je     800cf4 <strtol+0x58>
  800cee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cf2:	75 20                	jne    800d14 <strtol+0x78>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	3c 30                	cmp    $0x30,%al
  800cfb:	75 17                	jne    800d14 <strtol+0x78>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	40                   	inc    %eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	3c 78                	cmp    $0x78,%al
  800d05:	75 0d                	jne    800d14 <strtol+0x78>
		s += 2, base = 16;
  800d07:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d0b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d12:	eb 28                	jmp    800d3c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d18:	75 15                	jne    800d2f <strtol+0x93>
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	3c 30                	cmp    $0x30,%al
  800d21:	75 0c                	jne    800d2f <strtol+0x93>
		s++, base = 8;
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d2d:	eb 0d                	jmp    800d3c <strtol+0xa0>
	else if (base == 0)
  800d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d33:	75 07                	jne    800d3c <strtol+0xa0>
		base = 10;
  800d35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 2f                	cmp    $0x2f,%al
  800d43:	7e 19                	jle    800d5e <strtol+0xc2>
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 39                	cmp    $0x39,%al
  800d4c:	7f 10                	jg     800d5e <strtol+0xc2>
			dig = *s - '0';
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	0f be c0             	movsbl %al,%eax
  800d56:	83 e8 30             	sub    $0x30,%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d5c:	eb 42                	jmp    800da0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 60                	cmp    $0x60,%al
  800d65:	7e 19                	jle    800d80 <strtol+0xe4>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	3c 7a                	cmp    $0x7a,%al
  800d6e:	7f 10                	jg     800d80 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f be c0             	movsbl %al,%eax
  800d78:	83 e8 57             	sub    $0x57,%eax
  800d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7e:	eb 20                	jmp    800da0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 40                	cmp    $0x40,%al
  800d87:	7e 39                	jle    800dc2 <strtol+0x126>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 5a                	cmp    $0x5a,%al
  800d90:	7f 30                	jg     800dc2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f be c0             	movsbl %al,%eax
  800d9a:	83 e8 37             	sub    $0x37,%eax
  800d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da6:	7d 19                	jge    800dc1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dae:	0f af 45 10          	imul   0x10(%ebp),%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dbc:	e9 7b ff ff ff       	jmp    800d3c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dc1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc6:	74 08                	je     800dd0 <strtol+0x134>
		*endptr = (char *) s;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dd4:	74 07                	je     800ddd <strtol+0x141>
  800dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd9:	f7 d8                	neg    %eax
  800ddb:	eb 03                	jmp    800de0 <strtol+0x144>
  800ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <ltostr>:

void
ltostr(long value, char *str)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800def:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dfa:	79 13                	jns    800e0f <ltostr+0x2d>
	{
		neg = 1;
  800dfc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e09:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e0c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e17:	99                   	cltd   
  800e18:	f7 f9                	idiv   %ecx
  800e1a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e26:	89 c2                	mov    %eax,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e30:	83 c2 30             	add    $0x30,%edx
  800e33:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e38:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e3d:	f7 e9                	imul   %ecx
  800e3f:	c1 fa 02             	sar    $0x2,%edx
  800e42:	89 c8                	mov    %ecx,%eax
  800e44:	c1 f8 1f             	sar    $0x1f,%eax
  800e47:	29 c2                	sub    %eax,%edx
  800e49:	89 d0                	mov    %edx,%eax
  800e4b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e51:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e56:	f7 e9                	imul   %ecx
  800e58:	c1 fa 02             	sar    $0x2,%edx
  800e5b:	89 c8                	mov    %ecx,%eax
  800e5d:	c1 f8 1f             	sar    $0x1f,%eax
  800e60:	29 c2                	sub    %eax,%edx
  800e62:	89 d0                	mov    %edx,%eax
  800e64:	c1 e0 02             	shl    $0x2,%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	01 c0                	add    %eax,%eax
  800e6b:	29 c1                	sub    %eax,%ecx
  800e6d:	89 ca                	mov    %ecx,%edx
  800e6f:	85 d2                	test   %edx,%edx
  800e71:	75 9c                	jne    800e0f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7d:	48                   	dec    %eax
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e85:	74 3d                	je     800ec4 <ltostr+0xe2>
		start = 1 ;
  800e87:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e8e:	eb 34                	jmp    800ec4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	01 d0                	add    %edx,%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	01 c2                	add    %eax,%edx
  800ea5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	01 c8                	add    %ecx,%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	01 c2                	add    %eax,%edx
  800eb9:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ebc:	88 02                	mov    %al,(%edx)
		start++ ;
  800ebe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eca:	7c c4                	jl     800e90 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ecc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed7:	90                   	nop
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee0:	ff 75 08             	pushl  0x8(%ebp)
  800ee3:	e8 54 fa ff ff       	call   80093c <strlen>
  800ee8:	83 c4 04             	add    $0x4,%esp
  800eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eee:	ff 75 0c             	pushl  0xc(%ebp)
  800ef1:	e8 46 fa ff ff       	call   80093c <strlen>
  800ef6:	83 c4 04             	add    $0x4,%esp
  800ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800efc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0a:	eb 17                	jmp    800f23 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	01 c2                	add    %eax,%edx
  800f14:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	01 c8                	add    %ecx,%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f20:	ff 45 fc             	incl   -0x4(%ebp)
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f29:	7c e1                	jl     800f0c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f39:	eb 1f                	jmp    800f5a <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f44:	89 c2                	mov    %eax,%edx
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	01 c2                	add    %eax,%edx
  800f4b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	01 c8                	add    %ecx,%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f57:	ff 45 f8             	incl   -0x8(%ebp)
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f60:	7c d9                	jl     800f3b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	c6 00 00             	movb   $0x0,(%eax)
}
  800f6d:	90                   	nop
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f93:	eb 0c                	jmp    800fa1 <strsplit+0x31>
			*string++ = 0;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8d 50 01             	lea    0x1(%eax),%edx
  800f9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	84 c0                	test   %al,%al
  800fa8:	74 18                	je     800fc2 <strsplit+0x52>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be c0             	movsbl %al,%eax
  800fb2:	50                   	push   %eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	e8 13 fb ff ff       	call   800ace <strchr>
  800fbb:	83 c4 08             	add    $0x8,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	75 d3                	jne    800f95 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	84 c0                	test   %al,%al
  800fc9:	74 5a                	je     801025 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fce:	8b 00                	mov    (%eax),%eax
  800fd0:	83 f8 0f             	cmp    $0xf,%eax
  800fd3:	75 07                	jne    800fdc <strsplit+0x6c>
		{
			return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb 66                	jmp    801042 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdf:	8b 00                	mov    (%eax),%eax
  800fe1:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe4:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe7:	89 0a                	mov    %ecx,(%edx)
  800fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 c2                	add    %eax,%edx
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffa:	eb 03                	jmp    800fff <strsplit+0x8f>
			string++;
  800ffc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	84 c0                	test   %al,%al
  801006:	74 8b                	je     800f93 <strsplit+0x23>
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	0f be c0             	movsbl %al,%eax
  801010:	50                   	push   %eax
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	e8 b5 fa ff ff       	call   800ace <strchr>
  801019:	83 c4 08             	add    $0x8,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	74 dc                	je     800ffc <strsplit+0x8c>
			string++;
	}
  801020:	e9 6e ff ff ff       	jmp    800f93 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801025:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8b 00                	mov    (%eax),%eax
  80102b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	01 d0                	add    %edx,%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80103d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801051:	eb 4c                	jmp    80109f <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801053:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	01 d0                	add    %edx,%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 40                	cmp    $0x40,%al
  80105f:	7e 27                	jle    801088 <str2lower+0x44>
  801061:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 5a                	cmp    $0x5a,%al
  80106d:	7f 19                	jg     801088 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80106f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	01 ca                	add    %ecx,%edx
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	83 c2 20             	add    $0x20,%edx
  801084:	88 10                	mov    %dl,(%eax)
  801086:	eb 14                	jmp    80109c <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801088:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	01 c2                	add    %eax,%edx
  801090:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 c8                	add    %ecx,%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80109c:	ff 45 fc             	incl   -0x4(%ebp)
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 95 f8 ff ff       	call   80093c <strlen>
  8010a7:	83 c4 04             	add    $0x4,%esp
  8010aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ad:	7f a4                	jg     801053 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8010af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	57                   	push   %edi
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010da:	cd 30                	int    $0x30
  8010dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 04             	sub    $0x4,%esp
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	6a 00                	push   $0x0
  8010ff:	6a 00                	push   $0x0
  801101:	52                   	push   %edx
  801102:	ff 75 0c             	pushl  0xc(%ebp)
  801105:	50                   	push   %eax
  801106:	6a 00                	push   $0x0
  801108:	e8 b2 ff ff ff       	call   8010bf <syscall>
  80110d:	83 c4 18             	add    $0x18,%esp
}
  801110:	90                   	nop
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <sys_cgetc>:

int
sys_cgetc(void)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801116:	6a 00                	push   $0x0
  801118:	6a 00                	push   $0x0
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 01                	push   $0x1
  801122:	e8 98 ff ff ff       	call   8010bf <syscall>
  801127:	83 c4 18             	add    $0x18,%esp
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	52                   	push   %edx
  80113c:	50                   	push   %eax
  80113d:	6a 05                	push   $0x5
  80113f:	e8 7b ff ff ff       	call   8010bf <syscall>
  801144:	83 c4 18             	add    $0x18,%esp
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80114e:	8b 75 18             	mov    0x18(%ebp),%esi
  801151:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801154:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	51                   	push   %ecx
  801160:	52                   	push   %edx
  801161:	50                   	push   %eax
  801162:	6a 06                	push   $0x6
  801164:	e8 56 ff ff ff       	call   8010bf <syscall>
  801169:	83 c4 18             	add    $0x18,%esp
}
  80116c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801176:	8b 55 0c             	mov    0xc(%ebp),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	52                   	push   %edx
  801183:	50                   	push   %eax
  801184:	6a 07                	push   $0x7
  801186:	e8 34 ff ff ff       	call   8010bf <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	6a 08                	push   $0x8
  8011a1:	e8 19 ff ff ff       	call   8010bf <syscall>
  8011a6:	83 c4 18             	add    $0x18,%esp
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 09                	push   $0x9
  8011ba:	e8 00 ff ff ff       	call   8010bf <syscall>
  8011bf:	83 c4 18             	add    $0x18,%esp
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 0a                	push   $0xa
  8011d3:	e8 e7 fe ff ff       	call   8010bf <syscall>
  8011d8:	83 c4 18             	add    $0x18,%esp
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 0b                	push   $0xb
  8011ec:	e8 ce fe ff ff       	call   8010bf <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 0c                	push   $0xc
  801205:	e8 b5 fe ff ff       	call   8010bf <syscall>
  80120a:	83 c4 18             	add    $0x18,%esp
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801212:	6a 00                	push   $0x0
  801214:	6a 00                	push   $0x0
  801216:	6a 00                	push   $0x0
  801218:	6a 00                	push   $0x0
  80121a:	ff 75 08             	pushl  0x8(%ebp)
  80121d:	6a 0d                	push   $0xd
  80121f:	e8 9b fe ff ff       	call   8010bf <syscall>
  801224:	83 c4 18             	add    $0x18,%esp
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 0e                	push   $0xe
  801238:	e8 82 fe ff ff       	call   8010bf <syscall>
  80123d:	83 c4 18             	add    $0x18,%esp
}
  801240:	90                   	nop
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 11                	push   $0x11
  801252:	e8 68 fe ff ff       	call   8010bf <syscall>
  801257:	83 c4 18             	add    $0x18,%esp
}
  80125a:	90                   	nop
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 12                	push   $0x12
  80126c:	e8 4e fe ff ff       	call   8010bf <syscall>
  801271:	83 c4 18             	add    $0x18,%esp
}
  801274:	90                   	nop
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <sys_cputc>:


void
sys_cputc(const char c)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801283:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	50                   	push   %eax
  801290:	6a 13                	push   $0x13
  801292:	e8 28 fe ff ff       	call   8010bf <syscall>
  801297:	83 c4 18             	add    $0x18,%esp
}
  80129a:	90                   	nop
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 14                	push   $0x14
  8012ac:	e8 0e fe ff ff       	call   8010bf <syscall>
  8012b1:	83 c4 18             	add    $0x18,%esp
}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	ff 75 0c             	pushl  0xc(%ebp)
  8012c6:	50                   	push   %eax
  8012c7:	6a 15                	push   $0x15
  8012c9:	e8 f1 fd ff ff       	call   8010bf <syscall>
  8012ce:	83 c4 18             	add    $0x18,%esp
}
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	52                   	push   %edx
  8012e3:	50                   	push   %eax
  8012e4:	6a 18                	push   $0x18
  8012e6:	e8 d4 fd ff ff       	call   8010bf <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	52                   	push   %edx
  801300:	50                   	push   %eax
  801301:	6a 16                	push   $0x16
  801303:	e8 b7 fd ff ff       	call   8010bf <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
}
  80130b:	90                   	nop
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	52                   	push   %edx
  80131e:	50                   	push   %eax
  80131f:	6a 17                	push   $0x17
  801321:	e8 99 fd ff ff       	call   8010bf <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801338:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80133b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	6a 00                	push   $0x0
  801344:	51                   	push   %ecx
  801345:	52                   	push   %edx
  801346:	ff 75 0c             	pushl  0xc(%ebp)
  801349:	50                   	push   %eax
  80134a:	6a 19                	push   $0x19
  80134c:	e8 6e fd ff ff       	call   8010bf <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801359:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	52                   	push   %edx
  801366:	50                   	push   %eax
  801367:	6a 1a                	push   $0x1a
  801369:	e8 51 fd ff ff       	call   8010bf <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801376:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	51                   	push   %ecx
  801384:	52                   	push   %edx
  801385:	50                   	push   %eax
  801386:	6a 1b                	push   $0x1b
  801388:	e8 32 fd ff ff       	call   8010bf <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
}
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801395:	8b 55 0c             	mov    0xc(%ebp),%edx
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	52                   	push   %edx
  8013a2:	50                   	push   %eax
  8013a3:	6a 1c                	push   $0x1c
  8013a5:	e8 15 fd ff ff       	call   8010bf <syscall>
  8013aa:	83 c4 18             	add    $0x18,%esp
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 1d                	push   $0x1d
  8013be:	e8 fc fc ff ff       	call   8010bf <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	6a 00                	push   $0x0
  8013d0:	ff 75 14             	pushl  0x14(%ebp)
  8013d3:	ff 75 10             	pushl  0x10(%ebp)
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	50                   	push   %eax
  8013da:	6a 1e                	push   $0x1e
  8013dc:	e8 de fc ff ff       	call   8010bf <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	50                   	push   %eax
  8013f5:	6a 1f                	push   $0x1f
  8013f7:	e8 c3 fc ff ff       	call   8010bf <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
}
  8013ff:	90                   	nop
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	50                   	push   %eax
  801411:	6a 20                	push   $0x20
  801413:	e8 a7 fc ff ff       	call   8010bf <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 02                	push   $0x2
  80142c:	e8 8e fc ff ff       	call   8010bf <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 03                	push   $0x3
  801445:	e8 75 fc ff ff       	call   8010bf <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 04                	push   $0x4
  80145e:	e8 5c fc ff ff       	call   8010bf <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_exit_env>:


void sys_exit_env(void)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 21                	push   $0x21
  801477:	e8 43 fc ff ff       	call   8010bf <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801488:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80148b:	8d 50 04             	lea    0x4(%eax),%edx
  80148e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	52                   	push   %edx
  801498:	50                   	push   %eax
  801499:	6a 22                	push   $0x22
  80149b:	e8 1f fc ff ff       	call   8010bf <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8014a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	89 01                	mov    %eax,(%ecx)
  8014ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	c9                   	leave  
  8014b5:	c2 04 00             	ret    $0x4

008014b8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	ff 75 10             	pushl  0x10(%ebp)
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	6a 10                	push   $0x10
  8014ca:	e8 f0 fb ff ff       	call   8010bf <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d2:	90                   	nop
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 23                	push   $0x23
  8014e4:	e8 d6 fb ff ff       	call   8010bf <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	50                   	push   %eax
  801507:	6a 24                	push   $0x24
  801509:	e8 b1 fb ff ff       	call   8010bf <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
	return ;
  801511:	90                   	nop
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <rsttst>:
void rsttst()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 26                	push   $0x26
  801523:	e8 97 fb ff ff       	call   8010bf <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
	return ;
  80152b:	90                   	nop
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	8b 45 14             	mov    0x14(%ebp),%eax
  801537:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80153a:	8b 55 18             	mov    0x18(%ebp),%edx
  80153d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	ff 75 10             	pushl  0x10(%ebp)
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	6a 25                	push   $0x25
  80154e:	e8 6c fb ff ff       	call   8010bf <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
	return ;
  801556:	90                   	nop
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <chktst>:
void chktst(uint32 n)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	ff 75 08             	pushl  0x8(%ebp)
  801567:	6a 27                	push   $0x27
  801569:	e8 51 fb ff ff       	call   8010bf <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
	return ;
  801571:	90                   	nop
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <inctst>:

void inctst()
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 28                	push   $0x28
  801583:	e8 37 fb ff ff       	call   8010bf <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
	return ;
  80158b:	90                   	nop
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <gettst>:
uint32 gettst()
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 29                	push   $0x29
  80159d:	e8 1d fb ff ff       	call   8010bf <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 2a                	push   $0x2a
  8015b9:	e8 01 fb ff ff       	call   8010bf <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
  8015c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015c8:	75 07                	jne    8015d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8015cf:	eb 05                	jmp    8015d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 2a                	push   $0x2a
  8015ea:	e8 d0 fa ff ff       	call   8010bf <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015f5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015f9:	75 07                	jne    801602 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801600:	eb 05                	jmp    801607 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 2a                	push   $0x2a
  80161b:	e8 9f fa ff ff       	call   8010bf <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
  801623:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801626:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80162a:	75 07                	jne    801633 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80162c:	b8 01 00 00 00       	mov    $0x1,%eax
  801631:	eb 05                	jmp    801638 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 2a                	push   $0x2a
  80164c:	e8 6e fa ff ff       	call   8010bf <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
  801654:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801657:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80165b:	75 07                	jne    801664 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80165d:	b8 01 00 00 00       	mov    $0x1,%eax
  801662:	eb 05                	jmp    801669 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	ff 75 08             	pushl  0x8(%ebp)
  801679:	6a 2b                	push   $0x2b
  80167b:	e8 3f fa ff ff       	call   8010bf <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
	return ;
  801683:	90                   	nop
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80168a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	53                   	push   %ebx
  801699:	51                   	push   %ecx
  80169a:	52                   	push   %edx
  80169b:	50                   	push   %eax
  80169c:	6a 2c                	push   $0x2c
  80169e:	e8 1c fa ff ff       	call   8010bf <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	52                   	push   %edx
  8016bb:	50                   	push   %eax
  8016bc:	6a 2d                	push   $0x2d
  8016be:	e8 fc f9 ff ff       	call   8010bf <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	51                   	push   %ecx
  8016d7:	ff 75 10             	pushl  0x10(%ebp)
  8016da:	52                   	push   %edx
  8016db:	50                   	push   %eax
  8016dc:	6a 2e                	push   $0x2e
  8016de:	e8 dc f9 ff ff       	call   8010bf <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	ff 75 10             	pushl  0x10(%ebp)
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	ff 75 08             	pushl  0x8(%ebp)
  8016f8:	6a 0f                	push   $0xf
  8016fa:	e8 c0 f9 ff ff       	call   8010bf <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801702:	90                   	nop
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	50                   	push   %eax
  801714:	6a 2f                	push   $0x2f
  801716:	e8 a4 f9 ff ff       	call   8010bf <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp

}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	6a 30                	push   $0x30
  801731:	e8 89 f9 ff ff       	call   8010bf <syscall>
  801736:	83 c4 18             	add    $0x18,%esp

}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	ff 75 08             	pushl  0x8(%ebp)
  80174b:	6a 31                	push   $0x31
  80174d:	e8 6d f9 ff ff       	call   8010bf <syscall>
  801752:	83 c4 18             	add    $0x18,%esp

}
  801755:	90                   	nop
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 32                	push   $0x32
  801767:	e8 53 f9 ff ff       	call   8010bf <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    
  801771:	66 90                	xchg   %ax,%ax
  801773:	90                   	nop

00801774 <__udivdi3>:
  801774:	55                   	push   %ebp
  801775:	57                   	push   %edi
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
  801778:	83 ec 1c             	sub    $0x1c,%esp
  80177b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80177f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801783:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801787:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178b:	89 ca                	mov    %ecx,%edx
  80178d:	89 f8                	mov    %edi,%eax
  80178f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801793:	85 f6                	test   %esi,%esi
  801795:	75 2d                	jne    8017c4 <__udivdi3+0x50>
  801797:	39 cf                	cmp    %ecx,%edi
  801799:	77 65                	ja     801800 <__udivdi3+0x8c>
  80179b:	89 fd                	mov    %edi,%ebp
  80179d:	85 ff                	test   %edi,%edi
  80179f:	75 0b                	jne    8017ac <__udivdi3+0x38>
  8017a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a6:	31 d2                	xor    %edx,%edx
  8017a8:	f7 f7                	div    %edi
  8017aa:	89 c5                	mov    %eax,%ebp
  8017ac:	31 d2                	xor    %edx,%edx
  8017ae:	89 c8                	mov    %ecx,%eax
  8017b0:	f7 f5                	div    %ebp
  8017b2:	89 c1                	mov    %eax,%ecx
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	f7 f5                	div    %ebp
  8017b8:	89 cf                	mov    %ecx,%edi
  8017ba:	89 fa                	mov    %edi,%edx
  8017bc:	83 c4 1c             	add    $0x1c,%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5e                   	pop    %esi
  8017c1:	5f                   	pop    %edi
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    
  8017c4:	39 ce                	cmp    %ecx,%esi
  8017c6:	77 28                	ja     8017f0 <__udivdi3+0x7c>
  8017c8:	0f bd fe             	bsr    %esi,%edi
  8017cb:	83 f7 1f             	xor    $0x1f,%edi
  8017ce:	75 40                	jne    801810 <__udivdi3+0x9c>
  8017d0:	39 ce                	cmp    %ecx,%esi
  8017d2:	72 0a                	jb     8017de <__udivdi3+0x6a>
  8017d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017d8:	0f 87 9e 00 00 00    	ja     80187c <__udivdi3+0x108>
  8017de:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e3:	89 fa                	mov    %edi,%edx
  8017e5:	83 c4 1c             	add    $0x1c,%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5f                   	pop    %edi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
  8017ed:	8d 76 00             	lea    0x0(%esi),%esi
  8017f0:	31 ff                	xor    %edi,%edi
  8017f2:	31 c0                	xor    %eax,%eax
  8017f4:	89 fa                	mov    %edi,%edx
  8017f6:	83 c4 1c             	add    $0x1c,%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5e                   	pop    %esi
  8017fb:	5f                   	pop    %edi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
  8017fe:	66 90                	xchg   %ax,%ax
  801800:	89 d8                	mov    %ebx,%eax
  801802:	f7 f7                	div    %edi
  801804:	31 ff                	xor    %edi,%edi
  801806:	89 fa                	mov    %edi,%edx
  801808:	83 c4 1c             	add    $0x1c,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    
  801810:	bd 20 00 00 00       	mov    $0x20,%ebp
  801815:	89 eb                	mov    %ebp,%ebx
  801817:	29 fb                	sub    %edi,%ebx
  801819:	89 f9                	mov    %edi,%ecx
  80181b:	d3 e6                	shl    %cl,%esi
  80181d:	89 c5                	mov    %eax,%ebp
  80181f:	88 d9                	mov    %bl,%cl
  801821:	d3 ed                	shr    %cl,%ebp
  801823:	89 e9                	mov    %ebp,%ecx
  801825:	09 f1                	or     %esi,%ecx
  801827:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80182b:	89 f9                	mov    %edi,%ecx
  80182d:	d3 e0                	shl    %cl,%eax
  80182f:	89 c5                	mov    %eax,%ebp
  801831:	89 d6                	mov    %edx,%esi
  801833:	88 d9                	mov    %bl,%cl
  801835:	d3 ee                	shr    %cl,%esi
  801837:	89 f9                	mov    %edi,%ecx
  801839:	d3 e2                	shl    %cl,%edx
  80183b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80183f:	88 d9                	mov    %bl,%cl
  801841:	d3 e8                	shr    %cl,%eax
  801843:	09 c2                	or     %eax,%edx
  801845:	89 d0                	mov    %edx,%eax
  801847:	89 f2                	mov    %esi,%edx
  801849:	f7 74 24 0c          	divl   0xc(%esp)
  80184d:	89 d6                	mov    %edx,%esi
  80184f:	89 c3                	mov    %eax,%ebx
  801851:	f7 e5                	mul    %ebp
  801853:	39 d6                	cmp    %edx,%esi
  801855:	72 19                	jb     801870 <__udivdi3+0xfc>
  801857:	74 0b                	je     801864 <__udivdi3+0xf0>
  801859:	89 d8                	mov    %ebx,%eax
  80185b:	31 ff                	xor    %edi,%edi
  80185d:	e9 58 ff ff ff       	jmp    8017ba <__udivdi3+0x46>
  801862:	66 90                	xchg   %ax,%ax
  801864:	8b 54 24 08          	mov    0x8(%esp),%edx
  801868:	89 f9                	mov    %edi,%ecx
  80186a:	d3 e2                	shl    %cl,%edx
  80186c:	39 c2                	cmp    %eax,%edx
  80186e:	73 e9                	jae    801859 <__udivdi3+0xe5>
  801870:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801873:	31 ff                	xor    %edi,%edi
  801875:	e9 40 ff ff ff       	jmp    8017ba <__udivdi3+0x46>
  80187a:	66 90                	xchg   %ax,%ax
  80187c:	31 c0                	xor    %eax,%eax
  80187e:	e9 37 ff ff ff       	jmp    8017ba <__udivdi3+0x46>
  801883:	90                   	nop

00801884 <__umoddi3>:
  801884:	55                   	push   %ebp
  801885:	57                   	push   %edi
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	83 ec 1c             	sub    $0x1c,%esp
  80188b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80188f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801893:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801897:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80189b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80189f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018a3:	89 f3                	mov    %esi,%ebx
  8018a5:	89 fa                	mov    %edi,%edx
  8018a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ab:	89 34 24             	mov    %esi,(%esp)
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	75 1a                	jne    8018cc <__umoddi3+0x48>
  8018b2:	39 f7                	cmp    %esi,%edi
  8018b4:	0f 86 a2 00 00 00    	jbe    80195c <__umoddi3+0xd8>
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	89 f2                	mov    %esi,%edx
  8018be:	f7 f7                	div    %edi
  8018c0:	89 d0                	mov    %edx,%eax
  8018c2:	31 d2                	xor    %edx,%edx
  8018c4:	83 c4 1c             	add    $0x1c,%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
  8018cc:	39 f0                	cmp    %esi,%eax
  8018ce:	0f 87 ac 00 00 00    	ja     801980 <__umoddi3+0xfc>
  8018d4:	0f bd e8             	bsr    %eax,%ebp
  8018d7:	83 f5 1f             	xor    $0x1f,%ebp
  8018da:	0f 84 ac 00 00 00    	je     80198c <__umoddi3+0x108>
  8018e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8018e5:	29 ef                	sub    %ebp,%edi
  8018e7:	89 fe                	mov    %edi,%esi
  8018e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018ed:	89 e9                	mov    %ebp,%ecx
  8018ef:	d3 e0                	shl    %cl,%eax
  8018f1:	89 d7                	mov    %edx,%edi
  8018f3:	89 f1                	mov    %esi,%ecx
  8018f5:	d3 ef                	shr    %cl,%edi
  8018f7:	09 c7                	or     %eax,%edi
  8018f9:	89 e9                	mov    %ebp,%ecx
  8018fb:	d3 e2                	shl    %cl,%edx
  8018fd:	89 14 24             	mov    %edx,(%esp)
  801900:	89 d8                	mov    %ebx,%eax
  801902:	d3 e0                	shl    %cl,%eax
  801904:	89 c2                	mov    %eax,%edx
  801906:	8b 44 24 08          	mov    0x8(%esp),%eax
  80190a:	d3 e0                	shl    %cl,%eax
  80190c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801910:	8b 44 24 08          	mov    0x8(%esp),%eax
  801914:	89 f1                	mov    %esi,%ecx
  801916:	d3 e8                	shr    %cl,%eax
  801918:	09 d0                	or     %edx,%eax
  80191a:	d3 eb                	shr    %cl,%ebx
  80191c:	89 da                	mov    %ebx,%edx
  80191e:	f7 f7                	div    %edi
  801920:	89 d3                	mov    %edx,%ebx
  801922:	f7 24 24             	mull   (%esp)
  801925:	89 c6                	mov    %eax,%esi
  801927:	89 d1                	mov    %edx,%ecx
  801929:	39 d3                	cmp    %edx,%ebx
  80192b:	0f 82 87 00 00 00    	jb     8019b8 <__umoddi3+0x134>
  801931:	0f 84 91 00 00 00    	je     8019c8 <__umoddi3+0x144>
  801937:	8b 54 24 04          	mov    0x4(%esp),%edx
  80193b:	29 f2                	sub    %esi,%edx
  80193d:	19 cb                	sbb    %ecx,%ebx
  80193f:	89 d8                	mov    %ebx,%eax
  801941:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801945:	d3 e0                	shl    %cl,%eax
  801947:	89 e9                	mov    %ebp,%ecx
  801949:	d3 ea                	shr    %cl,%edx
  80194b:	09 d0                	or     %edx,%eax
  80194d:	89 e9                	mov    %ebp,%ecx
  80194f:	d3 eb                	shr    %cl,%ebx
  801951:	89 da                	mov    %ebx,%edx
  801953:	83 c4 1c             	add    $0x1c,%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    
  80195b:	90                   	nop
  80195c:	89 fd                	mov    %edi,%ebp
  80195e:	85 ff                	test   %edi,%edi
  801960:	75 0b                	jne    80196d <__umoddi3+0xe9>
  801962:	b8 01 00 00 00       	mov    $0x1,%eax
  801967:	31 d2                	xor    %edx,%edx
  801969:	f7 f7                	div    %edi
  80196b:	89 c5                	mov    %eax,%ebp
  80196d:	89 f0                	mov    %esi,%eax
  80196f:	31 d2                	xor    %edx,%edx
  801971:	f7 f5                	div    %ebp
  801973:	89 c8                	mov    %ecx,%eax
  801975:	f7 f5                	div    %ebp
  801977:	89 d0                	mov    %edx,%eax
  801979:	e9 44 ff ff ff       	jmp    8018c2 <__umoddi3+0x3e>
  80197e:	66 90                	xchg   %ax,%ax
  801980:	89 c8                	mov    %ecx,%eax
  801982:	89 f2                	mov    %esi,%edx
  801984:	83 c4 1c             	add    $0x1c,%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5f                   	pop    %edi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    
  80198c:	3b 04 24             	cmp    (%esp),%eax
  80198f:	72 06                	jb     801997 <__umoddi3+0x113>
  801991:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801995:	77 0f                	ja     8019a6 <__umoddi3+0x122>
  801997:	89 f2                	mov    %esi,%edx
  801999:	29 f9                	sub    %edi,%ecx
  80199b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80199f:	89 14 24             	mov    %edx,(%esp)
  8019a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019aa:	8b 14 24             	mov    (%esp),%edx
  8019ad:	83 c4 1c             	add    $0x1c,%esp
  8019b0:	5b                   	pop    %ebx
  8019b1:	5e                   	pop    %esi
  8019b2:	5f                   	pop    %edi
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    
  8019b5:	8d 76 00             	lea    0x0(%esi),%esi
  8019b8:	2b 04 24             	sub    (%esp),%eax
  8019bb:	19 fa                	sbb    %edi,%edx
  8019bd:	89 d1                	mov    %edx,%ecx
  8019bf:	89 c6                	mov    %eax,%esi
  8019c1:	e9 71 ff ff ff       	jmp    801937 <__umoddi3+0xb3>
  8019c6:	66 90                	xchg   %ax,%ax
  8019c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019cc:	72 ea                	jb     8019b8 <__umoddi3+0x134>
  8019ce:	89 d9                	mov    %ebx,%ecx
  8019d0:	e9 62 ff ff ff       	jmp    801937 <__umoddi3+0xb3>
