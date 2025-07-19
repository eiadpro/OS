
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 80 19 80 00       	push   $0x801980
  800046:	e8 3e 02 00 00       	call   800289 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 7c 13 00 00       	call   8013d8 <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800074:	01 d0                	add    %edx,%eax
  800076:	c1 e0 04             	shl    $0x4,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800083:	a1 20 20 80 00       	mov    0x802020,%eax
  800088:	8a 40 5c             	mov    0x5c(%eax),%al
  80008b:	84 c0                	test   %al,%al
  80008d:	74 0d                	je     80009c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80008f:	a1 20 20 80 00       	mov    0x802020,%eax
  800094:	83 c0 5c             	add    $0x5c,%eax
  800097:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x5b>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	ff 75 0c             	pushl  0xc(%ebp)
  8000b2:	ff 75 08             	pushl  0x8(%ebp)
  8000b5:	e8 7e ff ff ff       	call   800038 <_main>
  8000ba:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000bd:	e8 23 11 00 00       	call   8011e5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 c4 19 80 00       	push   $0x8019c4
  8000ca:	e8 8d 01 00 00       	call   80025c <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000d2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d7:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000dd:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e2:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	52                   	push   %edx
  8000ec:	50                   	push   %eax
  8000ed:	68 ec 19 80 00       	push   $0x8019ec
  8000f2:	e8 65 01 00 00       	call   80025c <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000fa:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ff:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800105:	a1 20 20 80 00       	mov    0x802020,%eax
  80010a:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800110:	a1 20 20 80 00       	mov    0x802020,%eax
  800115:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80011b:	51                   	push   %ecx
  80011c:	52                   	push   %edx
  80011d:	50                   	push   %eax
  80011e:	68 14 1a 80 00       	push   $0x801a14
  800123:	e8 34 01 00 00       	call   80025c <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80012b:	a1 20 20 80 00       	mov    0x802020,%eax
  800130:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	50                   	push   %eax
  80013a:	68 6c 1a 80 00       	push   $0x801a6c
  80013f:	e8 18 01 00 00       	call   80025c <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 c4 19 80 00       	push   $0x8019c4
  80014f:	e8 08 01 00 00       	call   80025c <cprintf>
  800154:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800157:	e8 a3 10 00 00       	call   8011ff <sys_enable_interrupt>

	// exit gracefully
	exit();
  80015c:	e8 19 00 00 00       	call   80017a <exit>
}
  800161:	90                   	nop
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 00                	push   $0x0
  80016f:	e8 30 12 00 00       	call   8013a4 <sys_destroy_env>
  800174:	83 c4 10             	add    $0x10,%esp
}
  800177:	90                   	nop
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <exit>:

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800180:	e8 85 12 00 00       	call   80140a <sys_exit_env>
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	8d 48 01             	lea    0x1(%eax),%ecx
  800196:	8b 55 0c             	mov    0xc(%ebp),%edx
  800199:	89 0a                	mov    %ecx,(%edx)
  80019b:	8b 55 08             	mov    0x8(%ebp),%edx
  80019e:	88 d1                	mov    %dl,%cl
  8001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001aa:	8b 00                	mov    (%eax),%eax
  8001ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b1:	75 2c                	jne    8001df <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001b3:	a0 24 20 80 00       	mov    0x802024,%al
  8001b8:	0f b6 c0             	movzbl %al,%eax
  8001bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001be:	8b 12                	mov    (%edx),%edx
  8001c0:	89 d1                	mov    %edx,%ecx
  8001c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c5:	83 c2 08             	add    $0x8,%edx
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	51                   	push   %ecx
  8001cd:	52                   	push   %edx
  8001ce:	e8 b9 0e 00 00       	call   80108c <sys_cputs>
  8001d3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e2:	8b 40 04             	mov    0x4(%eax),%eax
  8001e5:	8d 50 01             	lea    0x1(%eax),%edx
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001ee:	90                   	nop
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800201:	00 00 00 
	b.cnt = 0;
  800204:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	68 88 01 80 00       	push   $0x800188
  800220:	e8 11 02 00 00       	call   800436 <vprintfmt>
  800225:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800228:	a0 24 20 80 00       	mov    0x802024,%al
  80022d:	0f b6 c0             	movzbl %al,%eax
  800230:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	50                   	push   %eax
  80023a:	52                   	push   %edx
  80023b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800241:	83 c0 08             	add    $0x8,%eax
  800244:	50                   	push   %eax
  800245:	e8 42 0e 00 00       	call   80108c <sys_cputs>
  80024a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80024d:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800254:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    

0080025c <cprintf>:

int cprintf(const char *fmt, ...) {
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800262:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800269:	8d 45 0c             	lea    0xc(%ebp),%eax
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	ff 75 f4             	pushl  -0xc(%ebp)
  800278:	50                   	push   %eax
  800279:	e8 73 ff ff ff       	call   8001f1 <vcprintf>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800284:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80028f:	e8 51 0f 00 00       	call   8011e5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800294:	8d 45 0c             	lea    0xc(%ebp),%eax
  800297:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a3:	50                   	push   %eax
  8002a4:	e8 48 ff ff ff       	call   8001f1 <vcprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002af:	e8 4b 0f 00 00       	call   8011ff <sys_enable_interrupt>
	return cnt;
  8002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 14             	sub    $0x14,%esp
  8002c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8002cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d7:	77 55                	ja     80032e <printnum+0x75>
  8002d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002dc:	72 05                	jb     8002e3 <printnum+0x2a>
  8002de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e1:	77 4b                	ja     80032e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f1:	52                   	push   %edx
  8002f2:	50                   	push   %eax
  8002f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f9:	e8 16 14 00 00       	call   801714 <__udivdi3>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	ff 75 20             	pushl  0x20(%ebp)
  800307:	53                   	push   %ebx
  800308:	ff 75 18             	pushl  0x18(%ebp)
  80030b:	52                   	push   %edx
  80030c:	50                   	push   %eax
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	e8 a1 ff ff ff       	call   8002b9 <printnum>
  800318:	83 c4 20             	add    $0x20,%esp
  80031b:	eb 1a                	jmp    800337 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 20             	pushl  0x20(%ebp)
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	ff d0                	call   *%eax
  80032b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032e:	ff 4d 1c             	decl   0x1c(%ebp)
  800331:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800335:	7f e6                	jg     80031d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800337:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800345:	53                   	push   %ebx
  800346:	51                   	push   %ecx
  800347:	52                   	push   %edx
  800348:	50                   	push   %eax
  800349:	e8 d6 14 00 00       	call   801824 <__umoddi3>
  80034e:	83 c4 10             	add    $0x10,%esp
  800351:	05 94 1c 80 00       	add    $0x801c94,%eax
  800356:	8a 00                	mov    (%eax),%al
  800358:	0f be c0             	movsbl %al,%eax
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	50                   	push   %eax
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	ff d0                	call   *%eax
  800367:	83 c4 10             	add    $0x10,%esp
}
  80036a:	90                   	nop
  80036b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800373:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800377:	7e 1c                	jle    800395 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	8d 50 08             	lea    0x8(%eax),%edx
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 10                	mov    %edx,(%eax)
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	83 e8 08             	sub    $0x8,%eax
  80038e:	8b 50 04             	mov    0x4(%eax),%edx
  800391:	8b 00                	mov    (%eax),%eax
  800393:	eb 40                	jmp    8003d5 <getuint+0x65>
	else if (lflag)
  800395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800399:	74 1e                	je     8003b9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	8d 50 04             	lea    0x4(%eax),%edx
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	89 10                	mov    %edx,(%eax)
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	83 e8 04             	sub    $0x4,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	eb 1c                	jmp    8003d5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	8d 50 04             	lea    0x4(%eax),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 10                	mov    %edx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 e8 04             	sub    $0x4,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    

008003d7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003de:	7e 1c                	jle    8003fc <getint+0x25>
		return va_arg(*ap, long long);
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	8d 50 08             	lea    0x8(%eax),%edx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	89 10                	mov    %edx,(%eax)
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 e8 08             	sub    $0x8,%eax
  8003f5:	8b 50 04             	mov    0x4(%eax),%edx
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	eb 38                	jmp    800434 <getint+0x5d>
	else if (lflag)
  8003fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800400:	74 1a                	je     80041c <getint+0x45>
		return va_arg(*ap, long);
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	8d 50 04             	lea    0x4(%eax),%edx
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 10                	mov    %edx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	83 e8 04             	sub    $0x4,%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	99                   	cltd   
  80041a:	eb 18                	jmp    800434 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 04             	lea    0x4(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 04             	sub    $0x4,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	99                   	cltd   
}
  800434:	5d                   	pop    %ebp
  800435:	c3                   	ret    

00800436 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	56                   	push   %esi
  80043a:	53                   	push   %ebx
  80043b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80043e:	eb 17                	jmp    800457 <vprintfmt+0x21>
			if (ch == '\0')
  800440:	85 db                	test   %ebx,%ebx
  800442:	0f 84 af 03 00 00    	je     8007f7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	ff 75 0c             	pushl  0xc(%ebp)
  80044e:	53                   	push   %ebx
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	ff d0                	call   *%eax
  800454:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800457:	8b 45 10             	mov    0x10(%ebp),%eax
  80045a:	8d 50 01             	lea    0x1(%eax),%edx
  80045d:	89 55 10             	mov    %edx,0x10(%ebp)
  800460:	8a 00                	mov    (%eax),%al
  800462:	0f b6 d8             	movzbl %al,%ebx
  800465:	83 fb 25             	cmp    $0x25,%ebx
  800468:	75 d6                	jne    800440 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80046a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80046e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800475:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80047c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800483:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	8d 50 01             	lea    0x1(%eax),%edx
  800490:	89 55 10             	mov    %edx,0x10(%ebp)
  800493:	8a 00                	mov    (%eax),%al
  800495:	0f b6 d8             	movzbl %al,%ebx
  800498:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80049b:	83 f8 55             	cmp    $0x55,%eax
  80049e:	0f 87 2b 03 00 00    	ja     8007cf <vprintfmt+0x399>
  8004a4:	8b 04 85 b8 1c 80 00 	mov    0x801cb8(,%eax,4),%eax
  8004ab:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b1:	eb d7                	jmp    80048a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004b7:	eb d1                	jmp    80048a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	c1 e0 02             	shl    $0x2,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	01 c0                	add    %eax,%eax
  8004cc:	01 d8                	add    %ebx,%eax
  8004ce:	83 e8 30             	sub    $0x30,%eax
  8004d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d7:	8a 00                	mov    (%eax),%al
  8004d9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004dc:	83 fb 2f             	cmp    $0x2f,%ebx
  8004df:	7e 3e                	jle    80051f <vprintfmt+0xe9>
  8004e1:	83 fb 39             	cmp    $0x39,%ebx
  8004e4:	7f 39                	jg     80051f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e9:	eb d5                	jmp    8004c0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	83 c0 04             	add    $0x4,%eax
  8004f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	83 e8 04             	sub    $0x4,%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004ff:	eb 1f                	jmp    800520 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800501:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800505:	79 83                	jns    80048a <vprintfmt+0x54>
				width = 0;
  800507:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80050e:	e9 77 ff ff ff       	jmp    80048a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800513:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051a:	e9 6b ff ff ff       	jmp    80048a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80051f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800524:	0f 89 60 ff ff ff    	jns    80048a <vprintfmt+0x54>
				width = precision, precision = -1;
  80052a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800530:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800537:	e9 4e ff ff ff       	jmp    80048a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80053f:	e9 46 ff ff ff       	jmp    80048a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	83 c0 04             	add    $0x4,%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	83 e8 04             	sub    $0x4,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 0c             	pushl  0xc(%ebp)
  80055b:	50                   	push   %eax
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	ff d0                	call   *%eax
  800561:	83 c4 10             	add    $0x10,%esp
			break;
  800564:	e9 89 02 00 00       	jmp    8007f2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	83 e8 04             	sub    $0x4,%eax
  800578:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80057a:	85 db                	test   %ebx,%ebx
  80057c:	79 02                	jns    800580 <vprintfmt+0x14a>
				err = -err;
  80057e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 fb 64             	cmp    $0x64,%ebx
  800583:	7f 0b                	jg     800590 <vprintfmt+0x15a>
  800585:	8b 34 9d 00 1b 80 00 	mov    0x801b00(,%ebx,4),%esi
  80058c:	85 f6                	test   %esi,%esi
  80058e:	75 19                	jne    8005a9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800590:	53                   	push   %ebx
  800591:	68 a5 1c 80 00       	push   $0x801ca5
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	ff 75 08             	pushl  0x8(%ebp)
  80059c:	e8 5e 02 00 00       	call   8007ff <printfmt>
  8005a1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005a4:	e9 49 02 00 00       	jmp    8007f2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a9:	56                   	push   %esi
  8005aa:	68 ae 1c 80 00       	push   $0x801cae
  8005af:	ff 75 0c             	pushl  0xc(%ebp)
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 45 02 00 00       	call   8007ff <printfmt>
  8005ba:	83 c4 10             	add    $0x10,%esp
			break;
  8005bd:	e9 30 02 00 00       	jmp    8007f2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	83 c0 04             	add    $0x4,%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 30                	mov    (%eax),%esi
  8005d3:	85 f6                	test   %esi,%esi
  8005d5:	75 05                	jne    8005dc <vprintfmt+0x1a6>
				p = "(null)";
  8005d7:	be b1 1c 80 00       	mov    $0x801cb1,%esi
			if (width > 0 && padc != '-')
  8005dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e0:	7e 6d                	jle    80064f <vprintfmt+0x219>
  8005e2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e6:	74 67                	je     80064f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	50                   	push   %eax
  8005ef:	56                   	push   %esi
  8005f0:	e8 0c 03 00 00       	call   800901 <strnlen>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005fb:	eb 16                	jmp    800613 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005fd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	50                   	push   %eax
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	ff d0                	call   *%eax
  80060d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800610:	ff 4d e4             	decl   -0x1c(%ebp)
  800613:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800617:	7f e4                	jg     8005fd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800619:	eb 34                	jmp    80064f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061f:	74 1c                	je     80063d <vprintfmt+0x207>
  800621:	83 fb 1f             	cmp    $0x1f,%ebx
  800624:	7e 05                	jle    80062b <vprintfmt+0x1f5>
  800626:	83 fb 7e             	cmp    $0x7e,%ebx
  800629:	7e 12                	jle    80063d <vprintfmt+0x207>
					putch('?', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	6a 3f                	push   $0x3f
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
  80063b:	eb 0f                	jmp    80064c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	53                   	push   %ebx
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064c:	ff 4d e4             	decl   -0x1c(%ebp)
  80064f:	89 f0                	mov    %esi,%eax
  800651:	8d 70 01             	lea    0x1(%eax),%esi
  800654:	8a 00                	mov    (%eax),%al
  800656:	0f be d8             	movsbl %al,%ebx
  800659:	85 db                	test   %ebx,%ebx
  80065b:	74 24                	je     800681 <vprintfmt+0x24b>
  80065d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800661:	78 b8                	js     80061b <vprintfmt+0x1e5>
  800663:	ff 4d e0             	decl   -0x20(%ebp)
  800666:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066a:	79 af                	jns    80061b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066c:	eb 13                	jmp    800681 <vprintfmt+0x24b>
				putch(' ', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	6a 20                	push   $0x20
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	ff d0                	call   *%eax
  80067b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067e:	ff 4d e4             	decl   -0x1c(%ebp)
  800681:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800685:	7f e7                	jg     80066e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800687:	e9 66 01 00 00       	jmp    8007f2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	ff 75 e8             	pushl  -0x18(%ebp)
  800692:	8d 45 14             	lea    0x14(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 3c fd ff ff       	call   8003d7 <getint>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006aa:	85 d2                	test   %edx,%edx
  8006ac:	79 23                	jns    8006d1 <vprintfmt+0x29b>
				putch('-', putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	6a 2d                	push   $0x2d
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	ff d0                	call   *%eax
  8006bb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c4:	f7 d8                	neg    %eax
  8006c6:	83 d2 00             	adc    $0x0,%edx
  8006c9:	f7 da                	neg    %edx
  8006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006d8:	e9 bc 00 00 00       	jmp    800799 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e6:	50                   	push   %eax
  8006e7:	e8 84 fc ff ff       	call   800370 <getuint>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006fc:	e9 98 00 00 00       	jmp    800799 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	6a 58                	push   $0x58
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	6a 58                	push   $0x58
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	6a 58                	push   $0x58
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
			break;
  800731:	e9 bc 00 00 00       	jmp    8007f2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	6a 30                	push   $0x30
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	ff d0                	call   *%eax
  800743:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 78                	push   $0x78
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 e8 04             	sub    $0x4,%eax
  800765:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800771:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800778:	eb 1f                	jmp    800799 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 e8             	pushl  -0x18(%ebp)
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	e8 e7 fb ff ff       	call   800370 <getuint>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800792:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800799:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80079d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a0:	83 ec 04             	sub    $0x4,%esp
  8007a3:	52                   	push   %edx
  8007a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 00 fb ff ff       	call   8002b9 <printnum>
  8007b9:	83 c4 20             	add    $0x20,%esp
			break;
  8007bc:	eb 34                	jmp    8007f2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	53                   	push   %ebx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
			break;
  8007cd:	eb 23                	jmp    8007f2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	6a 25                	push   $0x25
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007df:	ff 4d 10             	decl   0x10(%ebp)
  8007e2:	eb 03                	jmp    8007e7 <vprintfmt+0x3b1>
  8007e4:	ff 4d 10             	decl   0x10(%ebp)
  8007e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ea:	48                   	dec    %eax
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	3c 25                	cmp    $0x25,%al
  8007ef:	75 f3                	jne    8007e4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007f1:	90                   	nop
		}
	}
  8007f2:	e9 47 fc ff ff       	jmp    80043e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007f7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007fb:	5b                   	pop    %ebx
  8007fc:	5e                   	pop    %esi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800805:	8d 45 10             	lea    0x10(%ebp),%eax
  800808:	83 c0 04             	add    $0x4,%eax
  80080b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	ff 75 f4             	pushl  -0xc(%ebp)
  800814:	50                   	push   %eax
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	e8 16 fc ff ff       	call   800436 <vprintfmt>
  800820:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800823:	90                   	nop
  800824:	c9                   	leave  
  800825:	c3                   	ret    

00800826 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082c:	8b 40 08             	mov    0x8(%eax),%eax
  80082f:	8d 50 01             	lea    0x1(%eax),%edx
  800832:	8b 45 0c             	mov    0xc(%ebp),%eax
  800835:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083b:	8b 10                	mov    (%eax),%edx
  80083d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800840:	8b 40 04             	mov    0x4(%eax),%eax
  800843:	39 c2                	cmp    %eax,%edx
  800845:	73 12                	jae    800859 <sprintputch+0x33>
		*b->buf++ = ch;
  800847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	8d 48 01             	lea    0x1(%eax),%ecx
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800852:	89 0a                	mov    %ecx,(%edx)
  800854:	8b 55 08             	mov    0x8(%ebp),%edx
  800857:	88 10                	mov    %dl,(%eax)
}
  800859:	90                   	nop
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	01 d0                	add    %edx,%eax
  800873:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800881:	74 06                	je     800889 <vsnprintf+0x2d>
  800883:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800887:	7f 07                	jg     800890 <vsnprintf+0x34>
		return -E_INVAL;
  800889:	b8 03 00 00 00       	mov    $0x3,%eax
  80088e:	eb 20                	jmp    8008b0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800890:	ff 75 14             	pushl  0x14(%ebp)
  800893:	ff 75 10             	pushl  0x10(%ebp)
  800896:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	68 26 08 80 00       	push   $0x800826
  80089f:	e8 92 fb ff ff       	call   800436 <vprintfmt>
  8008a4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008bb:	83 c0 04             	add    $0x4,%eax
  8008be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 89 ff ff ff       	call   80085c <vsnprintf>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    

008008de <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008eb:	eb 06                	jmp    8008f3 <strlen+0x15>
		n++;
  8008ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f0:	ff 45 08             	incl   0x8(%ebp)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8a 00                	mov    (%eax),%al
  8008f8:	84 c0                	test   %al,%al
  8008fa:	75 f1                	jne    8008ed <strlen+0xf>
		n++;
	return n;
  8008fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800907:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80090e:	eb 09                	jmp    800919 <strnlen+0x18>
		n++;
  800910:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	ff 45 08             	incl   0x8(%ebp)
  800916:	ff 4d 0c             	decl   0xc(%ebp)
  800919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091d:	74 09                	je     800928 <strnlen+0x27>
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8a 00                	mov    (%eax),%al
  800924:	84 c0                	test   %al,%al
  800926:	75 e8                	jne    800910 <strnlen+0xf>
		n++;
	return n;
  800928:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800939:	90                   	nop
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8d 50 01             	lea    0x1(%eax),%edx
  800940:	89 55 08             	mov    %edx,0x8(%ebp)
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	8d 4a 01             	lea    0x1(%edx),%ecx
  800949:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80094c:	8a 12                	mov    (%edx),%dl
  80094e:	88 10                	mov    %dl,(%eax)
  800950:	8a 00                	mov    (%eax),%al
  800952:	84 c0                	test   %al,%al
  800954:	75 e4                	jne    80093a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800956:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800967:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80096e:	eb 1f                	jmp    80098f <strncpy+0x34>
		*dst++ = *src;
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 08             	mov    %edx,0x8(%ebp)
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	8a 12                	mov    (%edx),%dl
  80097e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800980:	8b 45 0c             	mov    0xc(%ebp),%eax
  800983:	8a 00                	mov    (%eax),%al
  800985:	84 c0                	test   %al,%al
  800987:	74 03                	je     80098c <strncpy+0x31>
			src++;
  800989:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098c:	ff 45 fc             	incl   -0x4(%ebp)
  80098f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800992:	3b 45 10             	cmp    0x10(%ebp),%eax
  800995:	72 d9                	jb     800970 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800997:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ac:	74 30                	je     8009de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ae:	eb 16                	jmp    8009c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c2:	8a 12                	mov    (%edx),%dl
  8009c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c6:	ff 4d 10             	decl   0x10(%ebp)
  8009c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009cd:	74 09                	je     8009d8 <strlcpy+0x3c>
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	84 c0                	test   %al,%al
  8009d6:	75 d8                	jne    8009b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009de:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e4:	29 c2                	sub    %eax,%edx
  8009e6:	89 d0                	mov    %edx,%eax
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009ed:	eb 06                	jmp    8009f5 <strcmp+0xb>
		p++, q++;
  8009ef:	ff 45 08             	incl   0x8(%ebp)
  8009f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	84 c0                	test   %al,%al
  8009fc:	74 0e                	je     800a0c <strcmp+0x22>
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8a 10                	mov    (%eax),%dl
  800a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	38 c2                	cmp    %al,%dl
  800a0a:	74 e3                	je     8009ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	0f b6 d0             	movzbl %al,%edx
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f b6 c0             	movzbl %al,%eax
  800a1c:	29 c2                	sub    %eax,%edx
  800a1e:	89 d0                	mov    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a25:	eb 09                	jmp    800a30 <strncmp+0xe>
		n--, p++, q++;
  800a27:	ff 4d 10             	decl   0x10(%ebp)
  800a2a:	ff 45 08             	incl   0x8(%ebp)
  800a2d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a34:	74 17                	je     800a4d <strncmp+0x2b>
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8a 00                	mov    (%eax),%al
  800a3b:	84 c0                	test   %al,%al
  800a3d:	74 0e                	je     800a4d <strncmp+0x2b>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 10                	mov    (%eax),%dl
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8a 00                	mov    (%eax),%al
  800a49:	38 c2                	cmp    %al,%dl
  800a4b:	74 da                	je     800a27 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a51:	75 07                	jne    800a5a <strncmp+0x38>
		return 0;
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
  800a58:	eb 14                	jmp    800a6e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8a 00                	mov    (%eax),%al
  800a5f:	0f b6 d0             	movzbl %al,%edx
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	8a 00                	mov    (%eax),%al
  800a67:	0f b6 c0             	movzbl %al,%eax
  800a6a:	29 c2                	sub    %eax,%edx
  800a6c:	89 d0                	mov    %edx,%eax
}
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    

00800a70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 04             	sub    $0x4,%esp
  800a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a7c:	eb 12                	jmp    800a90 <strchr+0x20>
		if (*s == c)
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8a 00                	mov    (%eax),%al
  800a83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a86:	75 05                	jne    800a8d <strchr+0x1d>
			return (char *) s;
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	eb 11                	jmp    800a9e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8d:	ff 45 08             	incl   0x8(%ebp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	84 c0                	test   %al,%al
  800a97:	75 e5                	jne    800a7e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 04             	sub    $0x4,%esp
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aac:	eb 0d                	jmp    800abb <strfind+0x1b>
		if (*s == c)
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab6:	74 0e                	je     800ac6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ab8:	ff 45 08             	incl   0x8(%ebp)
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 ea                	jne    800aae <strfind+0xe>
  800ac4:	eb 01                	jmp    800ac7 <strfind+0x27>
		if (*s == c)
			break;
  800ac6:	90                   	nop
	return (char *) s;
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aca:	c9                   	leave  
  800acb:	c3                   	ret    

00800acc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  800adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ade:	eb 0e                	jmp    800aee <memset+0x22>
		*p++ = c;
  800ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae3:	8d 50 01             	lea    0x1(%eax),%edx
  800ae6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800aee:	ff 4d f8             	decl   -0x8(%ebp)
  800af1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800af5:	79 e9                	jns    800ae0 <memset+0x14>
		*p++ = c;

	return v;
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b0e:	eb 16                	jmp    800b26 <memcpy+0x2a>
		*d++ = *s++;
  800b10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b13:	8d 50 01             	lea    0x1(%eax),%edx
  800b16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b22:	8a 12                	mov    (%edx),%dl
  800b24:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b26:	8b 45 10             	mov    0x10(%ebp),%eax
  800b29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b2f:	85 c0                	test   %eax,%eax
  800b31:	75 dd                	jne    800b10 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b4d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b50:	73 50                	jae    800ba2 <memmove+0x6a>
  800b52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
  800b5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b5d:	76 43                	jbe    800ba2 <memmove+0x6a>
		s += n;
  800b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b62:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b6b:	eb 10                	jmp    800b7d <memmove+0x45>
			*--d = *--s;
  800b6d:	ff 4d f8             	decl   -0x8(%ebp)
  800b70:	ff 4d fc             	decl   -0x4(%ebp)
  800b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b76:	8a 10                	mov    (%eax),%dl
  800b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b7b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	89 55 10             	mov    %edx,0x10(%ebp)
  800b86:	85 c0                	test   %eax,%eax
  800b88:	75 e3                	jne    800b6d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8a:	eb 23                	jmp    800baf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b8f:	8d 50 01             	lea    0x1(%eax),%edx
  800b92:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b9b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b9e:	8a 12                	mov    (%edx),%dl
  800ba0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bab:	85 c0                	test   %eax,%eax
  800bad:	75 dd                	jne    800b8c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bc6:	eb 2a                	jmp    800bf2 <memcmp+0x3e>
		if (*s1 != *s2)
  800bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcb:	8a 10                	mov    (%eax),%dl
  800bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	38 c2                	cmp    %al,%dl
  800bd4:	74 16                	je     800bec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	0f b6 d0             	movzbl %al,%edx
  800bde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	0f b6 c0             	movzbl %al,%eax
  800be6:	29 c2                	sub    %eax,%edx
  800be8:	89 d0                	mov    %edx,%eax
  800bea:	eb 18                	jmp    800c04 <memcmp+0x50>
		s1++, s2++;
  800bec:	ff 45 fc             	incl   -0x4(%ebp)
  800bef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	75 c9                	jne    800bc8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c12:	01 d0                	add    %edx,%eax
  800c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c17:	eb 15                	jmp    800c2e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	0f b6 d0             	movzbl %al,%edx
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	0f b6 c0             	movzbl %al,%eax
  800c27:	39 c2                	cmp    %eax,%edx
  800c29:	74 0d                	je     800c38 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c2b:	ff 45 08             	incl   0x8(%ebp)
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c34:	72 e3                	jb     800c19 <memfind+0x13>
  800c36:	eb 01                	jmp    800c39 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c38:	90                   	nop
	return (void *) s;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3c:	c9                   	leave  
  800c3d:	c3                   	ret    

00800c3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c4b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c52:	eb 03                	jmp    800c57 <strtol+0x19>
		s++;
  800c54:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	3c 20                	cmp    $0x20,%al
  800c5e:	74 f4                	je     800c54 <strtol+0x16>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	3c 09                	cmp    $0x9,%al
  800c67:	74 eb                	je     800c54 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	3c 2b                	cmp    $0x2b,%al
  800c70:	75 05                	jne    800c77 <strtol+0x39>
		s++;
  800c72:	ff 45 08             	incl   0x8(%ebp)
  800c75:	eb 13                	jmp    800c8a <strtol+0x4c>
	else if (*s == '-')
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	3c 2d                	cmp    $0x2d,%al
  800c7e:	75 0a                	jne    800c8a <strtol+0x4c>
		s++, neg = 1;
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8e:	74 06                	je     800c96 <strtol+0x58>
  800c90:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c94:	75 20                	jne    800cb6 <strtol+0x78>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	3c 30                	cmp    $0x30,%al
  800c9d:	75 17                	jne    800cb6 <strtol+0x78>
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	40                   	inc    %eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	3c 78                	cmp    $0x78,%al
  800ca7:	75 0d                	jne    800cb6 <strtol+0x78>
		s += 2, base = 16;
  800ca9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cb4:	eb 28                	jmp    800cde <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	75 15                	jne    800cd1 <strtol+0x93>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	3c 30                	cmp    $0x30,%al
  800cc3:	75 0c                	jne    800cd1 <strtol+0x93>
		s++, base = 8;
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ccf:	eb 0d                	jmp    800cde <strtol+0xa0>
	else if (base == 0)
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	75 07                	jne    800cde <strtol+0xa0>
		base = 10;
  800cd7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	3c 2f                	cmp    $0x2f,%al
  800ce5:	7e 19                	jle    800d00 <strtol+0xc2>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 39                	cmp    $0x39,%al
  800cee:	7f 10                	jg     800d00 <strtol+0xc2>
			dig = *s - '0';
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	0f be c0             	movsbl %al,%eax
  800cf8:	83 e8 30             	sub    $0x30,%eax
  800cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800cfe:	eb 42                	jmp    800d42 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	3c 60                	cmp    $0x60,%al
  800d07:	7e 19                	jle    800d22 <strtol+0xe4>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 7a                	cmp    $0x7a,%al
  800d10:	7f 10                	jg     800d22 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	0f be c0             	movsbl %al,%eax
  800d1a:	83 e8 57             	sub    $0x57,%eax
  800d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d20:	eb 20                	jmp    800d42 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 40                	cmp    $0x40,%al
  800d29:	7e 39                	jle    800d64 <strtol+0x126>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	3c 5a                	cmp    $0x5a,%al
  800d32:	7f 30                	jg     800d64 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f be c0             	movsbl %al,%eax
  800d3c:	83 e8 37             	sub    $0x37,%eax
  800d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d48:	7d 19                	jge    800d63 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d54:	89 c2                	mov    %eax,%edx
  800d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
  800d5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d5e:	e9 7b ff ff ff       	jmp    800cde <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d63:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	74 08                	je     800d72 <strtol+0x134>
		*endptr = (char *) s;
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d76:	74 07                	je     800d7f <strtol+0x141>
  800d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7b:	f7 d8                	neg    %eax
  800d7d:	eb 03                	jmp    800d82 <strtol+0x144>
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <ltostr>:

void
ltostr(long value, char *str)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9c:	79 13                	jns    800db1 <ltostr+0x2d>
	{
		neg = 1;
  800d9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800db9:	99                   	cltd   
  800dba:	f7 f9                	idiv   %ecx
  800dbc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc2:	8d 50 01             	lea    0x1(%eax),%edx
  800dc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc8:	89 c2                	mov    %eax,%edx
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	01 d0                	add    %edx,%eax
  800dcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dd2:	83 c2 30             	add    $0x30,%edx
  800dd5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dda:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ddf:	f7 e9                	imul   %ecx
  800de1:	c1 fa 02             	sar    $0x2,%edx
  800de4:	89 c8                	mov    %ecx,%eax
  800de6:	c1 f8 1f             	sar    $0x1f,%eax
  800de9:	29 c2                	sub    %eax,%edx
  800deb:	89 d0                	mov    %edx,%eax
  800ded:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800df0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df8:	f7 e9                	imul   %ecx
  800dfa:	c1 fa 02             	sar    $0x2,%edx
  800dfd:	89 c8                	mov    %ecx,%eax
  800dff:	c1 f8 1f             	sar    $0x1f,%eax
  800e02:	29 c2                	sub    %eax,%edx
  800e04:	89 d0                	mov    %edx,%eax
  800e06:	c1 e0 02             	shl    $0x2,%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	01 c0                	add    %eax,%eax
  800e0d:	29 c1                	sub    %eax,%ecx
  800e0f:	89 ca                	mov    %ecx,%edx
  800e11:	85 d2                	test   %edx,%edx
  800e13:	75 9c                	jne    800db1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	48                   	dec    %eax
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e27:	74 3d                	je     800e66 <ltostr+0xe2>
		start = 1 ;
  800e29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e30:	eb 34                	jmp    800e66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	01 c2                	add    %eax,%edx
  800e47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	01 c2                	add    %eax,%edx
  800e5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e5e:	88 02                	mov    %al,(%edx)
		start++ ;
  800e60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c4                	jl     800e32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	01 d0                	add    %edx,%eax
  800e76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e79:	90                   	nop
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e82:	ff 75 08             	pushl  0x8(%ebp)
  800e85:	e8 54 fa ff ff       	call   8008de <strlen>
  800e8a:	83 c4 04             	add    $0x4,%esp
  800e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	e8 46 fa ff ff       	call   8008de <strlen>
  800e98:	83 c4 04             	add    $0x4,%esp
  800e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eac:	eb 17                	jmp    800ec5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb4:	01 c2                	add    %eax,%edx
  800eb6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	01 c8                	add    %ecx,%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec2:	ff 45 fc             	incl   -0x4(%ebp)
  800ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ecb:	7c e1                	jl     800eae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ecd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800edb:	eb 1f                	jmp    800efc <strcconcat+0x80>
		final[s++] = str2[i] ;
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee6:	89 c2                	mov    %eax,%edx
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	01 c2                	add    %eax,%edx
  800eed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	01 c8                	add    %ecx,%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
  800efc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f02:	7c d9                	jl     800edd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	01 d0                	add    %edx,%eax
  800f0c:	c6 00 00             	movb   $0x0,(%eax)
}
  800f0f:	90                   	nop
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f21:	8b 00                	mov    (%eax),%eax
  800f23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
  800f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f35:	eb 0c                	jmp    800f43 <strsplit+0x31>
			*string++ = 0;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	84 c0                	test   %al,%al
  800f4a:	74 18                	je     800f64 <strsplit+0x52>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f be c0             	movsbl %al,%eax
  800f54:	50                   	push   %eax
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	e8 13 fb ff ff       	call   800a70 <strchr>
  800f5d:	83 c4 08             	add    $0x8,%esp
  800f60:	85 c0                	test   %eax,%eax
  800f62:	75 d3                	jne    800f37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 5a                	je     800fc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f70:	8b 00                	mov    (%eax),%eax
  800f72:	83 f8 0f             	cmp    $0xf,%eax
  800f75:	75 07                	jne    800f7e <strsplit+0x6c>
		{
			return 0;
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7c:	eb 66                	jmp    800fe4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	8b 00                	mov    (%eax),%eax
  800f83:	8d 48 01             	lea    0x1(%eax),%ecx
  800f86:	8b 55 14             	mov    0x14(%ebp),%edx
  800f89:	89 0a                	mov    %ecx,(%edx)
  800f8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 c2                	add    %eax,%edx
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9c:	eb 03                	jmp    800fa1 <strsplit+0x8f>
			string++;
  800f9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	84 c0                	test   %al,%al
  800fa8:	74 8b                	je     800f35 <strsplit+0x23>
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be c0             	movsbl %al,%eax
  800fb2:	50                   	push   %eax
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	e8 b5 fa ff ff       	call   800a70 <strchr>
  800fbb:	83 c4 08             	add    $0x8,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	74 dc                	je     800f9e <strsplit+0x8c>
			string++;
	}
  800fc2:	e9 6e ff ff ff       	jmp    800f35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	8b 00                	mov    (%eax),%eax
  800fcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 d0                	add    %edx,%eax
  800fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  800fec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff3:	eb 4c                	jmp    801041 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  800ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 40                	cmp    $0x40,%al
  801001:	7e 27                	jle    80102a <str2lower+0x44>
  801003:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3c 5a                	cmp    $0x5a,%al
  80100f:	7f 19                	jg     80102a <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801011:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80101c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101f:	01 ca                	add    %ecx,%edx
  801021:	8a 12                	mov    (%edx),%dl
  801023:	83 c2 20             	add    $0x20,%edx
  801026:	88 10                	mov    %dl,(%eax)
  801028:	eb 14                	jmp    80103e <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80102a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	01 c2                	add    %eax,%edx
  801032:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	01 c8                	add    %ecx,%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80103e:	ff 45 fc             	incl   -0x4(%ebp)
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 95 f8 ff ff       	call   8008de <strlen>
  801049:	83 c4 04             	add    $0x4,%esp
  80104c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80104f:	7f a4                	jg     800ff5 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	53                   	push   %ebx
  801067:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801070:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801073:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801076:	8b 7d 18             	mov    0x18(%ebp),%edi
  801079:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80107c:	cd 30                	int    $0x30
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801081:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	8b 45 10             	mov    0x10(%ebp),%eax
  801095:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801098:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 00                	push   $0x0
  8010a3:	52                   	push   %edx
  8010a4:	ff 75 0c             	pushl  0xc(%ebp)
  8010a7:	50                   	push   %eax
  8010a8:	6a 00                	push   $0x0
  8010aa:	e8 b2 ff ff ff       	call   801061 <syscall>
  8010af:	83 c4 18             	add    $0x18,%esp
}
  8010b2:	90                   	nop
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010b8:	6a 00                	push   $0x0
  8010ba:	6a 00                	push   $0x0
  8010bc:	6a 00                	push   $0x0
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 01                	push   $0x1
  8010c4:	e8 98 ff ff ff       	call   801061 <syscall>
  8010c9:	83 c4 18             	add    $0x18,%esp
}
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	6a 00                	push   $0x0
  8010d9:	6a 00                	push   $0x0
  8010db:	6a 00                	push   $0x0
  8010dd:	52                   	push   %edx
  8010de:	50                   	push   %eax
  8010df:	6a 05                	push   $0x5
  8010e1:	e8 7b ff ff ff       	call   801061 <syscall>
  8010e6:	83 c4 18             	add    $0x18,%esp
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	56                   	push   %esi
  801100:	53                   	push   %ebx
  801101:	51                   	push   %ecx
  801102:	52                   	push   %edx
  801103:	50                   	push   %eax
  801104:	6a 06                	push   $0x6
  801106:	e8 56 ff ff ff       	call   801061 <syscall>
  80110b:	83 c4 18             	add    $0x18,%esp
}
  80110e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	52                   	push   %edx
  801125:	50                   	push   %eax
  801126:	6a 07                	push   $0x7
  801128:	e8 34 ff ff ff       	call   801061 <syscall>
  80112d:	83 c4 18             	add    $0x18,%esp
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	ff 75 08             	pushl  0x8(%ebp)
  801141:	6a 08                	push   $0x8
  801143:	e8 19 ff ff ff       	call   801061 <syscall>
  801148:	83 c4 18             	add    $0x18,%esp
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801150:	6a 00                	push   $0x0
  801152:	6a 00                	push   $0x0
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 09                	push   $0x9
  80115c:	e8 00 ff ff ff       	call   801061 <syscall>
  801161:	83 c4 18             	add    $0x18,%esp
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801169:	6a 00                	push   $0x0
  80116b:	6a 00                	push   $0x0
  80116d:	6a 00                	push   $0x0
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 0a                	push   $0xa
  801175:	e8 e7 fe ff ff       	call   801061 <syscall>
  80117a:	83 c4 18             	add    $0x18,%esp
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 0b                	push   $0xb
  80118e:	e8 ce fe ff ff       	call   801061 <syscall>
  801193:	83 c4 18             	add    $0x18,%esp
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 0c                	push   $0xc
  8011a7:	e8 b5 fe ff ff       	call   801061 <syscall>
  8011ac:	83 c4 18             	add    $0x18,%esp
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	ff 75 08             	pushl  0x8(%ebp)
  8011bf:	6a 0d                	push   $0xd
  8011c1:	e8 9b fe ff ff       	call   801061 <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 0e                	push   $0xe
  8011da:	e8 82 fe ff ff       	call   801061 <syscall>
  8011df:	83 c4 18             	add    $0x18,%esp
}
  8011e2:	90                   	nop
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 11                	push   $0x11
  8011f4:	e8 68 fe ff ff       	call   801061 <syscall>
  8011f9:	83 c4 18             	add    $0x18,%esp
}
  8011fc:	90                   	nop
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 12                	push   $0x12
  80120e:	e8 4e fe ff ff       	call   801061 <syscall>
  801213:	83 c4 18             	add    $0x18,%esp
}
  801216:	90                   	nop
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <sys_cputc>:


void
sys_cputc(const char c)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801225:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	50                   	push   %eax
  801232:	6a 13                	push   $0x13
  801234:	e8 28 fe ff ff       	call   801061 <syscall>
  801239:	83 c4 18             	add    $0x18,%esp
}
  80123c:	90                   	nop
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801242:	6a 00                	push   $0x0
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 14                	push   $0x14
  80124e:	e8 0e fe ff ff       	call   801061 <syscall>
  801253:	83 c4 18             	add    $0x18,%esp
}
  801256:	90                   	nop
  801257:	c9                   	leave  
  801258:	c3                   	ret    

00801259 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	ff 75 0c             	pushl  0xc(%ebp)
  801268:	50                   	push   %eax
  801269:	6a 15                	push   $0x15
  80126b:	e8 f1 fd ff ff       	call   801061 <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	52                   	push   %edx
  801285:	50                   	push   %eax
  801286:	6a 18                	push   $0x18
  801288:	e8 d4 fd ff ff       	call   801061 <syscall>
  80128d:	83 c4 18             	add    $0x18,%esp
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801295:	8b 55 0c             	mov    0xc(%ebp),%edx
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	52                   	push   %edx
  8012a2:	50                   	push   %eax
  8012a3:	6a 16                	push   $0x16
  8012a5:	e8 b7 fd ff ff       	call   801061 <syscall>
  8012aa:	83 c4 18             	add    $0x18,%esp
}
  8012ad:	90                   	nop
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	52                   	push   %edx
  8012c0:	50                   	push   %eax
  8012c1:	6a 17                	push   $0x17
  8012c3:	e8 99 fd ff ff       	call   801061 <syscall>
  8012c8:	83 c4 18             	add    $0x18,%esp
}
  8012cb:	90                   	nop
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	6a 00                	push   $0x0
  8012e6:	51                   	push   %ecx
  8012e7:	52                   	push   %edx
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	50                   	push   %eax
  8012ec:	6a 19                	push   $0x19
  8012ee:	e8 6e fd ff ff       	call   801061 <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	6a 1a                	push   $0x1a
  80130b:	e8 51 fd ff ff       	call   801061 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801318:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80131b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	51                   	push   %ecx
  801326:	52                   	push   %edx
  801327:	50                   	push   %eax
  801328:	6a 1b                	push   $0x1b
  80132a:	e8 32 fd ff ff       	call   801061 <syscall>
  80132f:	83 c4 18             	add    $0x18,%esp
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	52                   	push   %edx
  801344:	50                   	push   %eax
  801345:	6a 1c                	push   $0x1c
  801347:	e8 15 fd ff ff       	call   801061 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 1d                	push   $0x1d
  801360:	e8 fc fc ff ff       	call   801061 <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	6a 00                	push   $0x0
  801372:	ff 75 14             	pushl  0x14(%ebp)
  801375:	ff 75 10             	pushl  0x10(%ebp)
  801378:	ff 75 0c             	pushl  0xc(%ebp)
  80137b:	50                   	push   %eax
  80137c:	6a 1e                	push   $0x1e
  80137e:	e8 de fc ff ff       	call   801061 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	50                   	push   %eax
  801397:	6a 1f                	push   $0x1f
  801399:	e8 c3 fc ff ff       	call   801061 <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	50                   	push   %eax
  8013b3:	6a 20                	push   $0x20
  8013b5:	e8 a7 fc ff ff       	call   801061 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 02                	push   $0x2
  8013ce:	e8 8e fc ff ff       	call   801061 <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 03                	push   $0x3
  8013e7:	e8 75 fc ff ff       	call   801061 <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 04                	push   $0x4
  801400:	e8 5c fc ff ff       	call   801061 <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <sys_exit_env>:


void sys_exit_env(void)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 21                	push   $0x21
  801419:	e8 43 fc ff ff       	call   801061 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	90                   	nop
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80142a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80142d:	8d 50 04             	lea    0x4(%eax),%edx
  801430:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	52                   	push   %edx
  80143a:	50                   	push   %eax
  80143b:	6a 22                	push   $0x22
  80143d:	e8 1f fc ff ff       	call   801061 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
	return result;
  801445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801448:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144e:	89 01                	mov    %eax,(%ecx)
  801450:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	c9                   	leave  
  801457:	c2 04 00             	ret    $0x4

0080145a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	ff 75 10             	pushl  0x10(%ebp)
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	ff 75 08             	pushl  0x8(%ebp)
  80146a:	6a 10                	push   $0x10
  80146c:	e8 f0 fb ff ff       	call   801061 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
	return ;
  801474:	90                   	nop
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_rcr2>:
uint32 sys_rcr2()
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 23                	push   $0x23
  801486:	e8 d6 fb ff ff       	call   801061 <syscall>
  80148b:	83 c4 18             	add    $0x18,%esp
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80149c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	50                   	push   %eax
  8014a9:	6a 24                	push   $0x24
  8014ab:	e8 b1 fb ff ff       	call   801061 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b3:	90                   	nop
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <rsttst>:
void rsttst()
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 26                	push   $0x26
  8014c5:	e8 97 fb ff ff       	call   801061 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8014cd:	90                   	nop
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8014df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014e3:	52                   	push   %edx
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 10             	pushl  0x10(%ebp)
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	6a 25                	push   $0x25
  8014f0:	e8 6c fb ff ff       	call   801061 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f8:	90                   	nop
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <chktst>:
void chktst(uint32 n)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	ff 75 08             	pushl  0x8(%ebp)
  801509:	6a 27                	push   $0x27
  80150b:	e8 51 fb ff ff       	call   801061 <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
	return ;
  801513:	90                   	nop
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <inctst>:

void inctst()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 28                	push   $0x28
  801525:	e8 37 fb ff ff       	call   801061 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
	return ;
  80152d:	90                   	nop
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <gettst>:
uint32 gettst()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 29                	push   $0x29
  80153f:	e8 1d fb ff ff       	call   801061 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 2a                	push   $0x2a
  80155b:	e8 01 fb ff ff       	call   801061 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
  801563:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801566:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80156a:	75 07                	jne    801573 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80156c:	b8 01 00 00 00       	mov    $0x1,%eax
  801571:	eb 05                	jmp    801578 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 2a                	push   $0x2a
  80158c:	e8 d0 fa ff ff       	call   801061 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
  801594:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801597:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80159b:	75 07                	jne    8015a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80159d:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a2:	eb 05                	jmp    8015a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 2a                	push   $0x2a
  8015bd:	e8 9f fa ff ff       	call   801061 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015c8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015cc:	75 07                	jne    8015d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d3:	eb 05                	jmp    8015da <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 2a                	push   $0x2a
  8015ee:	e8 6e fa ff ff       	call   801061 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
  8015f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015fd:	75 07                	jne    801606 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801604:	eb 05                	jmp    80160b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	6a 2b                	push   $0x2b
  80161d:	e8 3f fa ff ff       	call   801061 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
	return ;
  801625:	90                   	nop
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80162c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	53                   	push   %ebx
  80163b:	51                   	push   %ecx
  80163c:	52                   	push   %edx
  80163d:	50                   	push   %eax
  80163e:	6a 2c                	push   $0x2c
  801640:	e8 1c fa ff ff       	call   801061 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801650:	8b 55 0c             	mov    0xc(%ebp),%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	52                   	push   %edx
  80165d:	50                   	push   %eax
  80165e:	6a 2d                	push   $0x2d
  801660:	e8 fc f9 ff ff       	call   801061 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80166d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	6a 00                	push   $0x0
  801678:	51                   	push   %ecx
  801679:	ff 75 10             	pushl  0x10(%ebp)
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	6a 2e                	push   $0x2e
  801680:	e8 dc f9 ff ff       	call   801061 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	ff 75 10             	pushl  0x10(%ebp)
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	6a 0f                	push   $0xf
  80169c:	e8 c0 f9 ff ff       	call   801061 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a4:	90                   	nop
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	50                   	push   %eax
  8016b6:	6a 2f                	push   $0x2f
  8016b8:	e8 a4 f9 ff ff       	call   801061 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp

}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 30                	push   $0x30
  8016d3:	e8 89 f9 ff ff       	call   801061 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp

}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 31                	push   $0x31
  8016ef:	e8 6d f9 ff ff       	call   801061 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp

}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_hard_limit>:
uint32 sys_hard_limit(){
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 32                	push   $0x32
  801709:	e8 53 f9 ff ff       	call   801061 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    
  801713:	90                   	nop

00801714 <__udivdi3>:
  801714:	55                   	push   %ebp
  801715:	57                   	push   %edi
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 1c             	sub    $0x1c,%esp
  80171b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80171f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801723:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172b:	89 ca                	mov    %ecx,%edx
  80172d:	89 f8                	mov    %edi,%eax
  80172f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801733:	85 f6                	test   %esi,%esi
  801735:	75 2d                	jne    801764 <__udivdi3+0x50>
  801737:	39 cf                	cmp    %ecx,%edi
  801739:	77 65                	ja     8017a0 <__udivdi3+0x8c>
  80173b:	89 fd                	mov    %edi,%ebp
  80173d:	85 ff                	test   %edi,%edi
  80173f:	75 0b                	jne    80174c <__udivdi3+0x38>
  801741:	b8 01 00 00 00       	mov    $0x1,%eax
  801746:	31 d2                	xor    %edx,%edx
  801748:	f7 f7                	div    %edi
  80174a:	89 c5                	mov    %eax,%ebp
  80174c:	31 d2                	xor    %edx,%edx
  80174e:	89 c8                	mov    %ecx,%eax
  801750:	f7 f5                	div    %ebp
  801752:	89 c1                	mov    %eax,%ecx
  801754:	89 d8                	mov    %ebx,%eax
  801756:	f7 f5                	div    %ebp
  801758:	89 cf                	mov    %ecx,%edi
  80175a:	89 fa                	mov    %edi,%edx
  80175c:	83 c4 1c             	add    $0x1c,%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5f                   	pop    %edi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    
  801764:	39 ce                	cmp    %ecx,%esi
  801766:	77 28                	ja     801790 <__udivdi3+0x7c>
  801768:	0f bd fe             	bsr    %esi,%edi
  80176b:	83 f7 1f             	xor    $0x1f,%edi
  80176e:	75 40                	jne    8017b0 <__udivdi3+0x9c>
  801770:	39 ce                	cmp    %ecx,%esi
  801772:	72 0a                	jb     80177e <__udivdi3+0x6a>
  801774:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801778:	0f 87 9e 00 00 00    	ja     80181c <__udivdi3+0x108>
  80177e:	b8 01 00 00 00       	mov    $0x1,%eax
  801783:	89 fa                	mov    %edi,%edx
  801785:	83 c4 1c             	add    $0x1c,%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    
  80178d:	8d 76 00             	lea    0x0(%esi),%esi
  801790:	31 ff                	xor    %edi,%edi
  801792:	31 c0                	xor    %eax,%eax
  801794:	89 fa                	mov    %edi,%edx
  801796:	83 c4 1c             	add    $0x1c,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    
  80179e:	66 90                	xchg   %ax,%ax
  8017a0:	89 d8                	mov    %ebx,%eax
  8017a2:	f7 f7                	div    %edi
  8017a4:	31 ff                	xor    %edi,%edi
  8017a6:	89 fa                	mov    %edi,%edx
  8017a8:	83 c4 1c             	add    $0x1c,%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    
  8017b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8017b5:	89 eb                	mov    %ebp,%ebx
  8017b7:	29 fb                	sub    %edi,%ebx
  8017b9:	89 f9                	mov    %edi,%ecx
  8017bb:	d3 e6                	shl    %cl,%esi
  8017bd:	89 c5                	mov    %eax,%ebp
  8017bf:	88 d9                	mov    %bl,%cl
  8017c1:	d3 ed                	shr    %cl,%ebp
  8017c3:	89 e9                	mov    %ebp,%ecx
  8017c5:	09 f1                	or     %esi,%ecx
  8017c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8017cb:	89 f9                	mov    %edi,%ecx
  8017cd:	d3 e0                	shl    %cl,%eax
  8017cf:	89 c5                	mov    %eax,%ebp
  8017d1:	89 d6                	mov    %edx,%esi
  8017d3:	88 d9                	mov    %bl,%cl
  8017d5:	d3 ee                	shr    %cl,%esi
  8017d7:	89 f9                	mov    %edi,%ecx
  8017d9:	d3 e2                	shl    %cl,%edx
  8017db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017df:	88 d9                	mov    %bl,%cl
  8017e1:	d3 e8                	shr    %cl,%eax
  8017e3:	09 c2                	or     %eax,%edx
  8017e5:	89 d0                	mov    %edx,%eax
  8017e7:	89 f2                	mov    %esi,%edx
  8017e9:	f7 74 24 0c          	divl   0xc(%esp)
  8017ed:	89 d6                	mov    %edx,%esi
  8017ef:	89 c3                	mov    %eax,%ebx
  8017f1:	f7 e5                	mul    %ebp
  8017f3:	39 d6                	cmp    %edx,%esi
  8017f5:	72 19                	jb     801810 <__udivdi3+0xfc>
  8017f7:	74 0b                	je     801804 <__udivdi3+0xf0>
  8017f9:	89 d8                	mov    %ebx,%eax
  8017fb:	31 ff                	xor    %edi,%edi
  8017fd:	e9 58 ff ff ff       	jmp    80175a <__udivdi3+0x46>
  801802:	66 90                	xchg   %ax,%ax
  801804:	8b 54 24 08          	mov    0x8(%esp),%edx
  801808:	89 f9                	mov    %edi,%ecx
  80180a:	d3 e2                	shl    %cl,%edx
  80180c:	39 c2                	cmp    %eax,%edx
  80180e:	73 e9                	jae    8017f9 <__udivdi3+0xe5>
  801810:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801813:	31 ff                	xor    %edi,%edi
  801815:	e9 40 ff ff ff       	jmp    80175a <__udivdi3+0x46>
  80181a:	66 90                	xchg   %ax,%ax
  80181c:	31 c0                	xor    %eax,%eax
  80181e:	e9 37 ff ff ff       	jmp    80175a <__udivdi3+0x46>
  801823:	90                   	nop

00801824 <__umoddi3>:
  801824:	55                   	push   %ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	83 ec 1c             	sub    $0x1c,%esp
  80182b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80182f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801837:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80183b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801843:	89 f3                	mov    %esi,%ebx
  801845:	89 fa                	mov    %edi,%edx
  801847:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80184b:	89 34 24             	mov    %esi,(%esp)
  80184e:	85 c0                	test   %eax,%eax
  801850:	75 1a                	jne    80186c <__umoddi3+0x48>
  801852:	39 f7                	cmp    %esi,%edi
  801854:	0f 86 a2 00 00 00    	jbe    8018fc <__umoddi3+0xd8>
  80185a:	89 c8                	mov    %ecx,%eax
  80185c:	89 f2                	mov    %esi,%edx
  80185e:	f7 f7                	div    %edi
  801860:	89 d0                	mov    %edx,%eax
  801862:	31 d2                	xor    %edx,%edx
  801864:	83 c4 1c             	add    $0x1c,%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
  80186c:	39 f0                	cmp    %esi,%eax
  80186e:	0f 87 ac 00 00 00    	ja     801920 <__umoddi3+0xfc>
  801874:	0f bd e8             	bsr    %eax,%ebp
  801877:	83 f5 1f             	xor    $0x1f,%ebp
  80187a:	0f 84 ac 00 00 00    	je     80192c <__umoddi3+0x108>
  801880:	bf 20 00 00 00       	mov    $0x20,%edi
  801885:	29 ef                	sub    %ebp,%edi
  801887:	89 fe                	mov    %edi,%esi
  801889:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80188d:	89 e9                	mov    %ebp,%ecx
  80188f:	d3 e0                	shl    %cl,%eax
  801891:	89 d7                	mov    %edx,%edi
  801893:	89 f1                	mov    %esi,%ecx
  801895:	d3 ef                	shr    %cl,%edi
  801897:	09 c7                	or     %eax,%edi
  801899:	89 e9                	mov    %ebp,%ecx
  80189b:	d3 e2                	shl    %cl,%edx
  80189d:	89 14 24             	mov    %edx,(%esp)
  8018a0:	89 d8                	mov    %ebx,%eax
  8018a2:	d3 e0                	shl    %cl,%eax
  8018a4:	89 c2                	mov    %eax,%edx
  8018a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018aa:	d3 e0                	shl    %cl,%eax
  8018ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018b4:	89 f1                	mov    %esi,%ecx
  8018b6:	d3 e8                	shr    %cl,%eax
  8018b8:	09 d0                	or     %edx,%eax
  8018ba:	d3 eb                	shr    %cl,%ebx
  8018bc:	89 da                	mov    %ebx,%edx
  8018be:	f7 f7                	div    %edi
  8018c0:	89 d3                	mov    %edx,%ebx
  8018c2:	f7 24 24             	mull   (%esp)
  8018c5:	89 c6                	mov    %eax,%esi
  8018c7:	89 d1                	mov    %edx,%ecx
  8018c9:	39 d3                	cmp    %edx,%ebx
  8018cb:	0f 82 87 00 00 00    	jb     801958 <__umoddi3+0x134>
  8018d1:	0f 84 91 00 00 00    	je     801968 <__umoddi3+0x144>
  8018d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8018db:	29 f2                	sub    %esi,%edx
  8018dd:	19 cb                	sbb    %ecx,%ebx
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8018e5:	d3 e0                	shl    %cl,%eax
  8018e7:	89 e9                	mov    %ebp,%ecx
  8018e9:	d3 ea                	shr    %cl,%edx
  8018eb:	09 d0                	or     %edx,%eax
  8018ed:	89 e9                	mov    %ebp,%ecx
  8018ef:	d3 eb                	shr    %cl,%ebx
  8018f1:	89 da                	mov    %ebx,%edx
  8018f3:	83 c4 1c             	add    $0x1c,%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5f                   	pop    %edi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    
  8018fb:	90                   	nop
  8018fc:	89 fd                	mov    %edi,%ebp
  8018fe:	85 ff                	test   %edi,%edi
  801900:	75 0b                	jne    80190d <__umoddi3+0xe9>
  801902:	b8 01 00 00 00       	mov    $0x1,%eax
  801907:	31 d2                	xor    %edx,%edx
  801909:	f7 f7                	div    %edi
  80190b:	89 c5                	mov    %eax,%ebp
  80190d:	89 f0                	mov    %esi,%eax
  80190f:	31 d2                	xor    %edx,%edx
  801911:	f7 f5                	div    %ebp
  801913:	89 c8                	mov    %ecx,%eax
  801915:	f7 f5                	div    %ebp
  801917:	89 d0                	mov    %edx,%eax
  801919:	e9 44 ff ff ff       	jmp    801862 <__umoddi3+0x3e>
  80191e:	66 90                	xchg   %ax,%ax
  801920:	89 c8                	mov    %ecx,%eax
  801922:	89 f2                	mov    %esi,%edx
  801924:	83 c4 1c             	add    $0x1c,%esp
  801927:	5b                   	pop    %ebx
  801928:	5e                   	pop    %esi
  801929:	5f                   	pop    %edi
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    
  80192c:	3b 04 24             	cmp    (%esp),%eax
  80192f:	72 06                	jb     801937 <__umoddi3+0x113>
  801931:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801935:	77 0f                	ja     801946 <__umoddi3+0x122>
  801937:	89 f2                	mov    %esi,%edx
  801939:	29 f9                	sub    %edi,%ecx
  80193b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80193f:	89 14 24             	mov    %edx,(%esp)
  801942:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801946:	8b 44 24 04          	mov    0x4(%esp),%eax
  80194a:	8b 14 24             	mov    (%esp),%edx
  80194d:	83 c4 1c             	add    $0x1c,%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5f                   	pop    %edi
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    
  801955:	8d 76 00             	lea    0x0(%esi),%esi
  801958:	2b 04 24             	sub    (%esp),%eax
  80195b:	19 fa                	sbb    %edi,%edx
  80195d:	89 d1                	mov    %edx,%ecx
  80195f:	89 c6                	mov    %eax,%esi
  801961:	e9 71 ff ff ff       	jmp    8018d7 <__umoddi3+0xb3>
  801966:	66 90                	xchg   %ax,%ax
  801968:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80196c:	72 ea                	jb     801958 <__umoddi3+0x134>
  80196e:	89 d9                	mov    %ebx,%ecx
  801970:	e9 62 ff ff ff       	jmp    8018d7 <__umoddi3+0xb3>
