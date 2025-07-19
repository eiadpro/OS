
obj/user/tst_syscalls_2:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 6f 15 00 00       	call   8015b2 <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 20 30 80 00       	mov    0x803020,%eax
  800048:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  80004e:	a1 20 30 80 00       	mov    0x803020,%eax
  800053:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 20 30 80 00       	mov    0x803020,%eax
  800060:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 40 1b 80 00       	push   $0x801b40
  80006e:	e8 f3 13 00 00       	call   801466 <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 00 14 00 00       	call   801484 <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 20 30 80 00       	mov    0x803020,%eax
  80008c:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  800092:	a1 20 30 80 00       	mov    0x803020,%eax
  800097:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a4:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 4c 1b 80 00       	push   $0x801b4c
  8000b2:	e8 af 13 00 00       	call   801466 <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c3:	e8 bc 13 00 00       	call   801484 <sys_run_env>
  8000c8:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d0:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  8000d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000db:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8000e1:	89 c1                	mov    %eax,%ecx
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8000ee:	52                   	push   %edx
  8000ef:	51                   	push   %ecx
  8000f0:	50                   	push   %eax
  8000f1:	68 58 1b 80 00       	push   $0x801b58
  8000f6:	e8 6b 13 00 00       	call   801466 <sys_create_env>
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	e8 78 13 00 00       	call   801484 <sys_run_env>
  80010c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 10 27 00 00       	push   $0x2710
  800117:	e8 f3 16 00 00       	call   80180f <env_sleep>
  80011c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80011f:	e8 08 15 00 00       	call   80162c <gettst>
  800124:	85 c0                	test   %eax,%eax
  800126:	74 12                	je     80013a <_main+0x102>
		cprintf("\ntst_syscalls_2 Failed.\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 64 1b 80 00       	push   $0x801b64
  800130:	e8 23 02 00 00       	call   800358 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");

}
  800138:	eb 10                	jmp    80014a <_main+0x112>
	env_sleep(10000);

	if (gettst() != 0)
		cprintf("\ntst_syscalls_2 Failed.\n");
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 80 1b 80 00       	push   $0x801b80
  800142:	e8 11 02 00 00       	call   800358 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp

}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800153:	e8 7c 13 00 00       	call   8014d4 <sys_getenvindex>
  800158:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80015b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80015e:	89 d0                	mov    %edx,%eax
  800160:	c1 e0 03             	shl    $0x3,%eax
  800163:	01 d0                	add    %edx,%eax
  800165:	01 c0                	add    %eax,%eax
  800167:	01 d0                	add    %edx,%eax
  800169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800170:	01 d0                	add    %edx,%eax
  800172:	c1 e0 04             	shl    $0x4,%eax
  800175:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8a 40 5c             	mov    0x5c(%eax),%al
  800187:	84 c0                	test   %al,%al
  800189:	74 0d                	je     800198 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80018b:	a1 20 30 80 00       	mov    0x803020,%eax
  800190:	83 c0 5c             	add    $0x5c,%eax
  800193:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019c:	7e 0a                	jle    8001a8 <libmain+0x5b>
		binaryname = argv[0];
  80019e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a1:	8b 00                	mov    (%eax),%eax
  8001a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a8:	83 ec 08             	sub    $0x8,%esp
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	ff 75 08             	pushl  0x8(%ebp)
  8001b1:	e8 82 fe ff ff       	call   800038 <_main>
  8001b6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b9:	e8 23 11 00 00       	call   8012e1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 d8 1b 80 00       	push   $0x801bd8
  8001c6:	e8 8d 01 00 00       	call   800358 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d3:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8001d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001de:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	52                   	push   %edx
  8001e8:	50                   	push   %eax
  8001e9:	68 00 1c 80 00       	push   $0x801c00
  8001ee:	e8 65 01 00 00       	call   800358 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fb:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80020c:	a1 20 30 80 00       	mov    0x803020,%eax
  800211:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800217:	51                   	push   %ecx
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 28 1c 80 00       	push   $0x801c28
  80021f:	e8 34 01 00 00       	call   800358 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	50                   	push   %eax
  800236:	68 80 1c 80 00       	push   $0x801c80
  80023b:	e8 18 01 00 00       	call   800358 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	68 d8 1b 80 00       	push   $0x801bd8
  80024b:	e8 08 01 00 00       	call   800358 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800253:	e8 a3 10 00 00       	call   8012fb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800258:	e8 19 00 00 00       	call   800276 <exit>
}
  80025d:	90                   	nop
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    

00800260 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	6a 00                	push   $0x0
  80026b:	e8 30 12 00 00       	call   8014a0 <sys_destroy_env>
  800270:	83 c4 10             	add    $0x10,%esp
}
  800273:	90                   	nop
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <exit>:

void
exit(void)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027c:	e8 85 12 00 00       	call   801506 <sys_exit_env>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80028a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028d:	8b 00                	mov    (%eax),%eax
  80028f:	8d 48 01             	lea    0x1(%eax),%ecx
  800292:	8b 55 0c             	mov    0xc(%ebp),%edx
  800295:	89 0a                	mov    %ecx,(%edx)
  800297:	8b 55 08             	mov    0x8(%ebp),%edx
  80029a:	88 d1                	mov    %dl,%cl
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a6:	8b 00                	mov    (%eax),%eax
  8002a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ad:	75 2c                	jne    8002db <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002af:	a0 24 30 80 00       	mov    0x803024,%al
  8002b4:	0f b6 c0             	movzbl %al,%eax
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	8b 12                	mov    (%edx),%edx
  8002bc:	89 d1                	mov    %edx,%ecx
  8002be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c1:	83 c2 08             	add    $0x8,%edx
  8002c4:	83 ec 04             	sub    $0x4,%esp
  8002c7:	50                   	push   %eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	e8 b9 0e 00 00       	call   801188 <sys_cputs>
  8002cf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	8b 40 04             	mov    0x4(%eax),%eax
  8002e1:	8d 50 01             	lea    0x1(%eax),%edx
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002ea:	90                   	nop
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fd:	00 00 00 
	b.cnt = 0;
  800300:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800307:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80030a:	ff 75 0c             	pushl  0xc(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800316:	50                   	push   %eax
  800317:	68 84 02 80 00       	push   $0x800284
  80031c:	e8 11 02 00 00       	call   800532 <vprintfmt>
  800321:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800324:	a0 24 30 80 00       	mov    0x803024,%al
  800329:	0f b6 c0             	movzbl %al,%eax
  80032c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	50                   	push   %eax
  800336:	52                   	push   %edx
  800337:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033d:	83 c0 08             	add    $0x8,%eax
  800340:	50                   	push   %eax
  800341:	e8 42 0e 00 00       	call   801188 <sys_cputs>
  800346:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800349:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800350:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800356:	c9                   	leave  
  800357:	c3                   	ret    

00800358 <cprintf>:

int cprintf(const char *fmt, ...) {
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80035e:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800365:	8d 45 0c             	lea    0xc(%ebp),%eax
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	ff 75 f4             	pushl  -0xc(%ebp)
  800374:	50                   	push   %eax
  800375:	e8 73 ff ff ff       	call   8002ed <vcprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
  80037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80038b:	e8 51 0f 00 00       	call   8012e1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800390:	8d 45 0c             	lea    0xc(%ebp),%eax
  800393:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	ff 75 f4             	pushl  -0xc(%ebp)
  80039f:	50                   	push   %eax
  8003a0:	e8 48 ff ff ff       	call   8002ed <vcprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ab:	e8 4b 0f 00 00       	call   8012fb <sys_enable_interrupt>
	return cnt;
  8003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    

008003b5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 14             	sub    $0x14,%esp
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d3:	77 55                	ja     80042a <printnum+0x75>
  8003d5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d8:	72 05                	jb     8003df <printnum+0x2a>
  8003da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003dd:	77 4b                	ja     80042a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003df:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003e2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	52                   	push   %edx
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003f5:	e8 ca 14 00 00       	call   8018c4 <__udivdi3>
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	ff 75 20             	pushl  0x20(%ebp)
  800403:	53                   	push   %ebx
  800404:	ff 75 18             	pushl  0x18(%ebp)
  800407:	52                   	push   %edx
  800408:	50                   	push   %eax
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 a1 ff ff ff       	call   8003b5 <printnum>
  800414:	83 c4 20             	add    $0x20,%esp
  800417:	eb 1a                	jmp    800433 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	ff 75 0c             	pushl  0xc(%ebp)
  80041f:	ff 75 20             	pushl  0x20(%ebp)
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	ff d0                	call   *%eax
  800427:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042a:	ff 4d 1c             	decl   0x1c(%ebp)
  80042d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800431:	7f e6                	jg     800419 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800433:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800436:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800441:	53                   	push   %ebx
  800442:	51                   	push   %ecx
  800443:	52                   	push   %edx
  800444:	50                   	push   %eax
  800445:	e8 8a 15 00 00       	call   8019d4 <__umoddi3>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	05 b4 1e 80 00       	add    $0x801eb4,%eax
  800452:	8a 00                	mov    (%eax),%al
  800454:	0f be c0             	movsbl %al,%eax
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 0c             	pushl  0xc(%ebp)
  80045d:	50                   	push   %eax
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	ff d0                	call   *%eax
  800463:	83 c4 10             	add    $0x10,%esp
}
  800466:	90                   	nop
  800467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800473:	7e 1c                	jle    800491 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 08             	lea    0x8(%eax),%edx
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	83 e8 08             	sub    $0x8,%eax
  80048a:	8b 50 04             	mov    0x4(%eax),%edx
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	eb 40                	jmp    8004d1 <getuint+0x65>
	else if (lflag)
  800491:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800495:	74 1e                	je     8004b5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	8d 50 04             	lea    0x4(%eax),%edx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	89 10                	mov    %edx,(%eax)
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	83 e8 04             	sub    $0x4,%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b3:	eb 1c                	jmp    8004d1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	8d 50 04             	lea    0x4(%eax),%edx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	89 10                	mov    %edx,(%eax)
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 e8 04             	sub    $0x4,%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d1:	5d                   	pop    %ebp
  8004d2:	c3                   	ret    

008004d3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004da:	7e 1c                	jle    8004f8 <getint+0x25>
		return va_arg(*ap, long long);
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	8d 50 08             	lea    0x8(%eax),%edx
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	89 10                	mov    %edx,(%eax)
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	83 e8 08             	sub    $0x8,%eax
  8004f1:	8b 50 04             	mov    0x4(%eax),%edx
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	eb 38                	jmp    800530 <getint+0x5d>
	else if (lflag)
  8004f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fc:	74 1a                	je     800518 <getint+0x45>
		return va_arg(*ap, long);
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	8d 50 04             	lea    0x4(%eax),%edx
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	89 10                	mov    %edx,(%eax)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	83 e8 04             	sub    $0x4,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	99                   	cltd   
  800516:	eb 18                	jmp    800530 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 50 04             	lea    0x4(%eax),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 10                	mov    %edx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	83 e8 04             	sub    $0x4,%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	99                   	cltd   
}
  800530:	5d                   	pop    %ebp
  800531:	c3                   	ret    

00800532 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	56                   	push   %esi
  800536:	53                   	push   %ebx
  800537:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053a:	eb 17                	jmp    800553 <vprintfmt+0x21>
			if (ch == '\0')
  80053c:	85 db                	test   %ebx,%ebx
  80053e:	0f 84 af 03 00 00    	je     8008f3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	ff 75 0c             	pushl  0xc(%ebp)
  80054a:	53                   	push   %ebx
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	ff d0                	call   *%eax
  800550:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 50 01             	lea    0x1(%eax),%edx
  800559:	89 55 10             	mov    %edx,0x10(%ebp)
  80055c:	8a 00                	mov    (%eax),%al
  80055e:	0f b6 d8             	movzbl %al,%ebx
  800561:	83 fb 25             	cmp    $0x25,%ebx
  800564:	75 d6                	jne    80053c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800566:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80056a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800571:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800578:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80057f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800586:	8b 45 10             	mov    0x10(%ebp),%eax
  800589:	8d 50 01             	lea    0x1(%eax),%edx
  80058c:	89 55 10             	mov    %edx,0x10(%ebp)
  80058f:	8a 00                	mov    (%eax),%al
  800591:	0f b6 d8             	movzbl %al,%ebx
  800594:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800597:	83 f8 55             	cmp    $0x55,%eax
  80059a:	0f 87 2b 03 00 00    	ja     8008cb <vprintfmt+0x399>
  8005a0:	8b 04 85 d8 1e 80 00 	mov    0x801ed8(,%eax,4),%eax
  8005a7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005ad:	eb d7                	jmp    800586 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005af:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005b3:	eb d1                	jmp    800586 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	c1 e0 02             	shl    $0x2,%eax
  8005c4:	01 d0                	add    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d8                	add    %ebx,%eax
  8005ca:	83 e8 30             	sub    $0x30,%eax
  8005cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d3:	8a 00                	mov    (%eax),%al
  8005d5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005db:	7e 3e                	jle    80061b <vprintfmt+0xe9>
  8005dd:	83 fb 39             	cmp    $0x39,%ebx
  8005e0:	7f 39                	jg     80061b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005e5:	eb d5                	jmp    8005bc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	83 e8 04             	sub    $0x4,%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005fb:	eb 1f                	jmp    80061c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800601:	79 83                	jns    800586 <vprintfmt+0x54>
				width = 0;
  800603:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80060a:	e9 77 ff ff ff       	jmp    800586 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80060f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800616:	e9 6b ff ff ff       	jmp    800586 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80061b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80061c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800620:	0f 89 60 ff ff ff    	jns    800586 <vprintfmt+0x54>
				width = precision, precision = -1;
  800626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800629:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80062c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800633:	e9 4e ff ff ff       	jmp    800586 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800638:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80063b:	e9 46 ff ff ff       	jmp    800586 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	83 c0 04             	add    $0x4,%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	83 e8 04             	sub    $0x4,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 0c             	pushl  0xc(%ebp)
  800657:	50                   	push   %eax
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
			break;
  800660:	e9 89 02 00 00       	jmp    8008ee <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	83 c0 04             	add    $0x4,%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	83 e8 04             	sub    $0x4,%eax
  800674:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800676:	85 db                	test   %ebx,%ebx
  800678:	79 02                	jns    80067c <vprintfmt+0x14a>
				err = -err;
  80067a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80067c:	83 fb 64             	cmp    $0x64,%ebx
  80067f:	7f 0b                	jg     80068c <vprintfmt+0x15a>
  800681:	8b 34 9d 20 1d 80 00 	mov    0x801d20(,%ebx,4),%esi
  800688:	85 f6                	test   %esi,%esi
  80068a:	75 19                	jne    8006a5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80068c:	53                   	push   %ebx
  80068d:	68 c5 1e 80 00       	push   $0x801ec5
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	ff 75 08             	pushl  0x8(%ebp)
  800698:	e8 5e 02 00 00       	call   8008fb <printfmt>
  80069d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a0:	e9 49 02 00 00       	jmp    8008ee <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006a5:	56                   	push   %esi
  8006a6:	68 ce 1e 80 00       	push   $0x801ece
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 08             	pushl  0x8(%ebp)
  8006b1:	e8 45 02 00 00       	call   8008fb <printfmt>
  8006b6:	83 c4 10             	add    $0x10,%esp
			break;
  8006b9:	e9 30 02 00 00       	jmp    8008ee <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	83 c0 04             	add    $0x4,%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	83 e8 04             	sub    $0x4,%eax
  8006cd:	8b 30                	mov    (%eax),%esi
  8006cf:	85 f6                	test   %esi,%esi
  8006d1:	75 05                	jne    8006d8 <vprintfmt+0x1a6>
				p = "(null)";
  8006d3:	be d1 1e 80 00       	mov    $0x801ed1,%esi
			if (width > 0 && padc != '-')
  8006d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006dc:	7e 6d                	jle    80074b <vprintfmt+0x219>
  8006de:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006e2:	74 67                	je     80074b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	50                   	push   %eax
  8006eb:	56                   	push   %esi
  8006ec:	e8 0c 03 00 00       	call   8009fd <strnlen>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f7:	eb 16                	jmp    80070f <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	ff d0                	call   *%eax
  800709:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070c:	ff 4d e4             	decl   -0x1c(%ebp)
  80070f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800713:	7f e4                	jg     8006f9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800715:	eb 34                	jmp    80074b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071b:	74 1c                	je     800739 <vprintfmt+0x207>
  80071d:	83 fb 1f             	cmp    $0x1f,%ebx
  800720:	7e 05                	jle    800727 <vprintfmt+0x1f5>
  800722:	83 fb 7e             	cmp    $0x7e,%ebx
  800725:	7e 12                	jle    800739 <vprintfmt+0x207>
					putch('?', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	6a 3f                	push   $0x3f
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	eb 0f                	jmp    800748 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	53                   	push   %ebx
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	ff d0                	call   *%eax
  800745:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800748:	ff 4d e4             	decl   -0x1c(%ebp)
  80074b:	89 f0                	mov    %esi,%eax
  80074d:	8d 70 01             	lea    0x1(%eax),%esi
  800750:	8a 00                	mov    (%eax),%al
  800752:	0f be d8             	movsbl %al,%ebx
  800755:	85 db                	test   %ebx,%ebx
  800757:	74 24                	je     80077d <vprintfmt+0x24b>
  800759:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075d:	78 b8                	js     800717 <vprintfmt+0x1e5>
  80075f:	ff 4d e0             	decl   -0x20(%ebp)
  800762:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800766:	79 af                	jns    800717 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800768:	eb 13                	jmp    80077d <vprintfmt+0x24b>
				putch(' ', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	6a 20                	push   $0x20
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80077a:	ff 4d e4             	decl   -0x1c(%ebp)
  80077d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800781:	7f e7                	jg     80076a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800783:	e9 66 01 00 00       	jmp    8008ee <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 e8             	pushl  -0x18(%ebp)
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	50                   	push   %eax
  800792:	e8 3c fd ff ff       	call   8004d3 <getint>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a6:	85 d2                	test   %edx,%edx
  8007a8:	79 23                	jns    8007cd <vprintfmt+0x29b>
				putch('-', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	6a 2d                	push   $0x2d
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
  8007b7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c0:	f7 d8                	neg    %eax
  8007c2:	83 d2 00             	adc    $0x0,%edx
  8007c5:	f7 da                	neg    %edx
  8007c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007cd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d4:	e9 bc 00 00 00       	jmp    800895 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007df:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e2:	50                   	push   %eax
  8007e3:	e8 84 fc ff ff       	call   80046c <getuint>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 98 00 00 00       	jmp    800895 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 58                	push   $0x58
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 bc 00 00 00       	jmp    8008ee <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 30                	push   $0x30
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	6a 78                	push   $0x78
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	ff d0                	call   *%eax
  80084f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800863:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80086d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800874:	eb 1f                	jmp    800895 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	ff 75 e8             	pushl  -0x18(%ebp)
  80087c:	8d 45 14             	lea    0x14(%ebp),%eax
  80087f:	50                   	push   %eax
  800880:	e8 e7 fb ff ff       	call   80046c <getuint>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80088e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800895:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089c:	83 ec 04             	sub    $0x4,%esp
  80089f:	52                   	push   %edx
  8008a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008a3:	50                   	push   %eax
  8008a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	ff 75 08             	pushl  0x8(%ebp)
  8008b0:	e8 00 fb ff ff       	call   8003b5 <printnum>
  8008b5:	83 c4 20             	add    $0x20,%esp
			break;
  8008b8:	eb 34                	jmp    8008ee <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	53                   	push   %ebx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	ff d0                	call   *%eax
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	eb 23                	jmp    8008ee <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	6a 25                	push   $0x25
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008db:	ff 4d 10             	decl   0x10(%ebp)
  8008de:	eb 03                	jmp    8008e3 <vprintfmt+0x3b1>
  8008e0:	ff 4d 10             	decl   0x10(%ebp)
  8008e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e6:	48                   	dec    %eax
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	3c 25                	cmp    $0x25,%al
  8008eb:	75 f3                	jne    8008e0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008ed:	90                   	nop
		}
	}
  8008ee:	e9 47 fc ff ff       	jmp    80053a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5e                   	pop    %esi
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800901:	8d 45 10             	lea    0x10(%ebp),%eax
  800904:	83 c0 04             	add    $0x4,%eax
  800907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090a:	8b 45 10             	mov    0x10(%ebp),%eax
  80090d:	ff 75 f4             	pushl  -0xc(%ebp)
  800910:	50                   	push   %eax
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	ff 75 08             	pushl  0x8(%ebp)
  800917:	e8 16 fc ff ff       	call   800532 <vprintfmt>
  80091c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091f:	90                   	nop
  800920:	c9                   	leave  
  800921:	c3                   	ret    

00800922 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 40 08             	mov    0x8(%eax),%eax
  80092b:	8d 50 01             	lea    0x1(%eax),%edx
  80092e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800931:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
  800937:	8b 10                	mov    (%eax),%edx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 40 04             	mov    0x4(%eax),%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	73 12                	jae    800955 <sprintputch+0x33>
		*b->buf++ = ch;
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	8d 48 01             	lea    0x1(%eax),%ecx
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	89 0a                	mov    %ecx,(%edx)
  800950:	8b 55 08             	mov    0x8(%ebp),%edx
  800953:	88 10                	mov    %dl,(%eax)
}
  800955:	90                   	nop
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800964:	8b 45 0c             	mov    0xc(%ebp),%eax
  800967:	8d 50 ff             	lea    -0x1(%eax),%edx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800979:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097d:	74 06                	je     800985 <vsnprintf+0x2d>
  80097f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800983:	7f 07                	jg     80098c <vsnprintf+0x34>
		return -E_INVAL;
  800985:	b8 03 00 00 00       	mov    $0x3,%eax
  80098a:	eb 20                	jmp    8009ac <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098c:	ff 75 14             	pushl  0x14(%ebp)
  80098f:	ff 75 10             	pushl  0x10(%ebp)
  800992:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800995:	50                   	push   %eax
  800996:	68 22 09 80 00       	push   $0x800922
  80099b:	e8 92 fb ff ff       	call   800532 <vprintfmt>
  8009a0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b7:	83 c0 04             	add    $0x4,%eax
  8009ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c3:	50                   	push   %eax
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	ff 75 08             	pushl  0x8(%ebp)
  8009ca:	e8 89 ff ff ff       	call   800958 <vsnprintf>
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e7:	eb 06                	jmp    8009ef <strlen+0x15>
		n++;
  8009e9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ec:	ff 45 08             	incl   0x8(%ebp)
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8a 00                	mov    (%eax),%al
  8009f4:	84 c0                	test   %al,%al
  8009f6:	75 f1                	jne    8009e9 <strlen+0xf>
		n++;
	return n;
  8009f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 09                	jmp    800a15 <strnlen+0x18>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	ff 4d 0c             	decl   0xc(%ebp)
  800a15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a19:	74 09                	je     800a24 <strnlen+0x27>
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	84 c0                	test   %al,%al
  800a22:	75 e8                	jne    800a0c <strnlen+0xf>
		n++;
	return n;
  800a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a35:	90                   	nop
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8d 50 01             	lea    0x1(%eax),%edx
  800a3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a45:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a48:	8a 12                	mov    (%edx),%dl
  800a4a:	88 10                	mov    %dl,(%eax)
  800a4c:	8a 00                	mov    (%eax),%al
  800a4e:	84 c0                	test   %al,%al
  800a50:	75 e4                	jne    800a36 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a6a:	eb 1f                	jmp    800a8b <strncpy+0x34>
		*dst++ = *src;
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	8d 50 01             	lea    0x1(%eax),%edx
  800a72:	89 55 08             	mov    %edx,0x8(%ebp)
  800a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a78:	8a 12                	mov    (%edx),%dl
  800a7a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	8a 00                	mov    (%eax),%al
  800a81:	84 c0                	test   %al,%al
  800a83:	74 03                	je     800a88 <strncpy+0x31>
			src++;
  800a85:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a88:	ff 45 fc             	incl   -0x4(%ebp)
  800a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a91:	72 d9                	jb     800a6c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa8:	74 30                	je     800ada <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aaa:	eb 16                	jmp    800ac2 <strlcpy+0x2a>
			*dst++ = *src++;
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8d 50 01             	lea    0x1(%eax),%edx
  800ab2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800abb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800abe:	8a 12                	mov    (%edx),%dl
  800ac0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac2:	ff 4d 10             	decl   0x10(%ebp)
  800ac5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac9:	74 09                	je     800ad4 <strlcpy+0x3c>
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	84 c0                	test   %al,%al
  800ad2:	75 d8                	jne    800aac <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ada:	8b 55 08             	mov    0x8(%ebp),%edx
  800add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae0:	29 c2                	sub    %eax,%edx
  800ae2:	89 d0                	mov    %edx,%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae9:	eb 06                	jmp    800af1 <strcmp+0xb>
		p++, q++;
  800aeb:	ff 45 08             	incl   0x8(%ebp)
  800aee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	74 0e                	je     800b08 <strcmp+0x22>
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8a 10                	mov    (%eax),%dl
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	38 c2                	cmp    %al,%dl
  800b06:	74 e3                	je     800aeb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	0f b6 d0             	movzbl %al,%edx
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	29 c2                	sub    %eax,%edx
  800b1a:	89 d0                	mov    %edx,%eax
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b21:	eb 09                	jmp    800b2c <strncmp+0xe>
		n--, p++, q++;
  800b23:	ff 4d 10             	decl   0x10(%ebp)
  800b26:	ff 45 08             	incl   0x8(%ebp)
  800b29:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b30:	74 17                	je     800b49 <strncmp+0x2b>
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	84 c0                	test   %al,%al
  800b39:	74 0e                	je     800b49 <strncmp+0x2b>
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8a 10                	mov    (%eax),%dl
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	38 c2                	cmp    %al,%dl
  800b47:	74 da                	je     800b23 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4d:	75 07                	jne    800b56 <strncmp+0x38>
		return 0;
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	eb 14                	jmp    800b6a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	0f b6 d0             	movzbl %al,%edx
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	0f b6 c0             	movzbl %al,%eax
  800b66:	29 c2                	sub    %eax,%edx
  800b68:	89 d0                	mov    %edx,%eax
}
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b78:	eb 12                	jmp    800b8c <strchr+0x20>
		if (*s == c)
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b82:	75 05                	jne    800b89 <strchr+0x1d>
			return (char *) s;
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	eb 11                	jmp    800b9a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b89:	ff 45 08             	incl   0x8(%ebp)
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8a 00                	mov    (%eax),%al
  800b91:	84 c0                	test   %al,%al
  800b93:	75 e5                	jne    800b7a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 04             	sub    $0x4,%esp
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba8:	eb 0d                	jmp    800bb7 <strfind+0x1b>
		if (*s == c)
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb2:	74 0e                	je     800bc2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb4:	ff 45 08             	incl   0x8(%ebp)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	84 c0                	test   %al,%al
  800bbe:	75 ea                	jne    800baa <strfind+0xe>
  800bc0:	eb 01                	jmp    800bc3 <strfind+0x27>
		if (*s == c)
			break;
  800bc2:	90                   	nop
	return (char *) s;
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bda:	eb 0e                	jmp    800bea <memset+0x22>
		*p++ = c;
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bea:	ff 4d f8             	decl   -0x8(%ebp)
  800bed:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf1:	79 e9                	jns    800bdc <memset+0x14>
		*p++ = c;

	return v;
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c0a:	eb 16                	jmp    800c22 <memcpy+0x2a>
		*d++ = *s++;
  800c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0f:	8d 50 01             	lea    0x1(%eax),%edx
  800c12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c1e:	8a 12                	mov    (%edx),%dl
  800c20:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c22:	8b 45 10             	mov    0x10(%ebp),%eax
  800c25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c28:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2b:	85 c0                	test   %eax,%eax
  800c2d:	75 dd                	jne    800c0c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c4c:	73 50                	jae    800c9e <memmove+0x6a>
  800c4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 d0                	add    %edx,%eax
  800c56:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c59:	76 43                	jbe    800c9e <memmove+0x6a>
		s += n;
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c61:	8b 45 10             	mov    0x10(%ebp),%eax
  800c64:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c67:	eb 10                	jmp    800c79 <memmove+0x45>
			*--d = *--s;
  800c69:	ff 4d f8             	decl   -0x8(%ebp)
  800c6c:	ff 4d fc             	decl   -0x4(%ebp)
  800c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c72:	8a 10                	mov    (%eax),%dl
  800c74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c77:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c79:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c82:	85 c0                	test   %eax,%eax
  800c84:	75 e3                	jne    800c69 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c86:	eb 23                	jmp    800cab <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8b:	8d 50 01             	lea    0x1(%eax),%edx
  800c8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c97:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	85 c0                	test   %eax,%eax
  800ca9:	75 dd                	jne    800c88 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc2:	eb 2a                	jmp    800cee <memcmp+0x3e>
		if (*s1 != *s2)
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc7:	8a 10                	mov    (%eax),%dl
  800cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	38 c2                	cmp    %al,%dl
  800cd0:	74 16                	je     800ce8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 d0             	movzbl %al,%edx
  800cda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 c0             	movzbl %al,%eax
  800ce2:	29 c2                	sub    %eax,%edx
  800ce4:	89 d0                	mov    %edx,%eax
  800ce6:	eb 18                	jmp    800d00 <memcmp+0x50>
		s1++, s2++;
  800ce8:	ff 45 fc             	incl   -0x4(%ebp)
  800ceb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf4:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	75 c9                	jne    800cc4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	01 d0                	add    %edx,%eax
  800d10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d13:	eb 15                	jmp    800d2a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 d0             	movzbl %al,%edx
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	0f b6 c0             	movzbl %al,%eax
  800d23:	39 c2                	cmp    %eax,%edx
  800d25:	74 0d                	je     800d34 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d27:	ff 45 08             	incl   0x8(%ebp)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d30:	72 e3                	jb     800d15 <memfind+0x13>
  800d32:	eb 01                	jmp    800d35 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d34:	90                   	nop
	return (void *) s;
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4e:	eb 03                	jmp    800d53 <strtol+0x19>
		s++;
  800d50:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	3c 20                	cmp    $0x20,%al
  800d5a:	74 f4                	je     800d50 <strtol+0x16>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3c 09                	cmp    $0x9,%al
  800d63:	74 eb                	je     800d50 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	3c 2b                	cmp    $0x2b,%al
  800d6c:	75 05                	jne    800d73 <strtol+0x39>
		s++;
  800d6e:	ff 45 08             	incl   0x8(%ebp)
  800d71:	eb 13                	jmp    800d86 <strtol+0x4c>
	else if (*s == '-')
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3c 2d                	cmp    $0x2d,%al
  800d7a:	75 0a                	jne    800d86 <strtol+0x4c>
		s++, neg = 1;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8a:	74 06                	je     800d92 <strtol+0x58>
  800d8c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d90:	75 20                	jne    800db2 <strtol+0x78>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 30                	cmp    $0x30,%al
  800d99:	75 17                	jne    800db2 <strtol+0x78>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	40                   	inc    %eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3c 78                	cmp    $0x78,%al
  800da3:	75 0d                	jne    800db2 <strtol+0x78>
		s += 2, base = 16;
  800da5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db0:	eb 28                	jmp    800dda <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	75 15                	jne    800dcd <strtol+0x93>
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3c 30                	cmp    $0x30,%al
  800dbf:	75 0c                	jne    800dcd <strtol+0x93>
		s++, base = 8;
  800dc1:	ff 45 08             	incl   0x8(%ebp)
  800dc4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dcb:	eb 0d                	jmp    800dda <strtol+0xa0>
	else if (base == 0)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	75 07                	jne    800dda <strtol+0xa0>
		base = 10;
  800dd3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	3c 2f                	cmp    $0x2f,%al
  800de1:	7e 19                	jle    800dfc <strtol+0xc2>
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	3c 39                	cmp    $0x39,%al
  800dea:	7f 10                	jg     800dfc <strtol+0xc2>
			dig = *s - '0';
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	0f be c0             	movsbl %al,%eax
  800df4:	83 e8 30             	sub    $0x30,%eax
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dfa:	eb 42                	jmp    800e3e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3c 60                	cmp    $0x60,%al
  800e03:	7e 19                	jle    800e1e <strtol+0xe4>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	3c 7a                	cmp    $0x7a,%al
  800e0c:	7f 10                	jg     800e1e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	0f be c0             	movsbl %al,%eax
  800e16:	83 e8 57             	sub    $0x57,%eax
  800e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1c:	eb 20                	jmp    800e3e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	3c 40                	cmp    $0x40,%al
  800e25:	7e 39                	jle    800e60 <strtol+0x126>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3c 5a                	cmp    $0x5a,%al
  800e2e:	7f 30                	jg     800e60 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f be c0             	movsbl %al,%eax
  800e38:	83 e8 37             	sub    $0x37,%eax
  800e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e41:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e44:	7d 19                	jge    800e5f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e46:	ff 45 08             	incl   0x8(%ebp)
  800e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e50:	89 c2                	mov    %eax,%edx
  800e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e55:	01 d0                	add    %edx,%eax
  800e57:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e5a:	e9 7b ff ff ff       	jmp    800dda <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e5f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e64:	74 08                	je     800e6e <strtol+0x134>
		*endptr = (char *) s;
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e72:	74 07                	je     800e7b <strtol+0x141>
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	f7 d8                	neg    %eax
  800e79:	eb 03                	jmp    800e7e <strtol+0x144>
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <ltostr>:

void
ltostr(long value, char *str)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e98:	79 13                	jns    800ead <ltostr+0x2d>
	{
		neg = 1;
  800e9a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ea7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eaa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb5:	99                   	cltd   
  800eb6:	f7 f9                	idiv   %ecx
  800eb8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ebb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec4:	89 c2                	mov    %eax,%edx
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	01 d0                	add    %edx,%eax
  800ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ece:	83 c2 30             	add    $0x30,%edx
  800ed1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800edb:	f7 e9                	imul   %ecx
  800edd:	c1 fa 02             	sar    $0x2,%edx
  800ee0:	89 c8                	mov    %ecx,%eax
  800ee2:	c1 f8 1f             	sar    $0x1f,%eax
  800ee5:	29 c2                	sub    %eax,%edx
  800ee7:	89 d0                	mov    %edx,%eax
  800ee9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ef4:	f7 e9                	imul   %ecx
  800ef6:	c1 fa 02             	sar    $0x2,%edx
  800ef9:	89 c8                	mov    %ecx,%eax
  800efb:	c1 f8 1f             	sar    $0x1f,%eax
  800efe:	29 c2                	sub    %eax,%edx
  800f00:	89 d0                	mov    %edx,%eax
  800f02:	c1 e0 02             	shl    $0x2,%eax
  800f05:	01 d0                	add    %edx,%eax
  800f07:	01 c0                	add    %eax,%eax
  800f09:	29 c1                	sub    %eax,%ecx
  800f0b:	89 ca                	mov    %ecx,%edx
  800f0d:	85 d2                	test   %edx,%edx
  800f0f:	75 9c                	jne    800ead <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1b:	48                   	dec    %eax
  800f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f23:	74 3d                	je     800f62 <ltostr+0xe2>
		start = 1 ;
  800f25:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f2c:	eb 34                	jmp    800f62 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	01 d0                	add    %edx,%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	01 c2                	add    %eax,%edx
  800f43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	01 c8                	add    %ecx,%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	01 c2                	add    %eax,%edx
  800f57:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f5a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f5c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f5f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f68:	7c c4                	jl     800f2e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f6a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	01 d0                	add    %edx,%eax
  800f72:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f75:	90                   	nop
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f7e:	ff 75 08             	pushl  0x8(%ebp)
  800f81:	e8 54 fa ff ff       	call   8009da <strlen>
  800f86:	83 c4 04             	add    $0x4,%esp
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f8c:	ff 75 0c             	pushl  0xc(%ebp)
  800f8f:	e8 46 fa ff ff       	call   8009da <strlen>
  800f94:	83 c4 04             	add    $0x4,%esp
  800f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa8:	eb 17                	jmp    800fc1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800faa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	01 c2                	add    %eax,%edx
  800fb2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	01 c8                	add    %ecx,%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fbe:	ff 45 fc             	incl   -0x4(%ebp)
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc7:	7c e1                	jl     800faa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fd0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fd7:	eb 1f                	jmp    800ff8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdc:	8d 50 01             	lea    0x1(%eax),%edx
  800fdf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	01 c2                	add    %eax,%edx
  800fe9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	01 c8                	add    %ecx,%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ff5:	ff 45 f8             	incl   -0x8(%ebp)
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ffe:	7c d9                	jl     800fd9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801000:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801003:	8b 45 10             	mov    0x10(%ebp),%eax
  801006:	01 d0                	add    %edx,%eax
  801008:	c6 00 00             	movb   $0x0,(%eax)
}
  80100b:	90                   	nop
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801011:	8b 45 14             	mov    0x14(%ebp),%eax
  801014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80101a:	8b 45 14             	mov    0x14(%ebp),%eax
  80101d:	8b 00                	mov    (%eax),%eax
  80101f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801031:	eb 0c                	jmp    80103f <strsplit+0x31>
			*string++ = 0;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8d 50 01             	lea    0x1(%eax),%edx
  801039:	89 55 08             	mov    %edx,0x8(%ebp)
  80103c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	74 18                	je     801060 <strsplit+0x52>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f be c0             	movsbl %al,%eax
  801050:	50                   	push   %eax
  801051:	ff 75 0c             	pushl  0xc(%ebp)
  801054:	e8 13 fb ff ff       	call   800b6c <strchr>
  801059:	83 c4 08             	add    $0x8,%esp
  80105c:	85 c0                	test   %eax,%eax
  80105e:	75 d3                	jne    801033 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	84 c0                	test   %al,%al
  801067:	74 5a                	je     8010c3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801069:	8b 45 14             	mov    0x14(%ebp),%eax
  80106c:	8b 00                	mov    (%eax),%eax
  80106e:	83 f8 0f             	cmp    $0xf,%eax
  801071:	75 07                	jne    80107a <strsplit+0x6c>
		{
			return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
  801078:	eb 66                	jmp    8010e0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80107a:	8b 45 14             	mov    0x14(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 48 01             	lea    0x1(%eax),%ecx
  801082:	8b 55 14             	mov    0x14(%ebp),%edx
  801085:	89 0a                	mov    %ecx,(%edx)
  801087:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80108e:	8b 45 10             	mov    0x10(%ebp),%eax
  801091:	01 c2                	add    %eax,%edx
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801098:	eb 03                	jmp    80109d <strsplit+0x8f>
			string++;
  80109a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	84 c0                	test   %al,%al
  8010a4:	74 8b                	je     801031 <strsplit+0x23>
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	0f be c0             	movsbl %al,%eax
  8010ae:	50                   	push   %eax
  8010af:	ff 75 0c             	pushl  0xc(%ebp)
  8010b2:	e8 b5 fa ff ff       	call   800b6c <strchr>
  8010b7:	83 c4 08             	add    $0x8,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	74 dc                	je     80109a <strsplit+0x8c>
			string++;
	}
  8010be:	e9 6e ff ff ff       	jmp    801031 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010c3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c7:	8b 00                	mov    (%eax),%eax
  8010c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8010e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ef:	eb 4c                	jmp    80113d <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8010f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 40                	cmp    $0x40,%al
  8010fd:	7e 27                	jle    801126 <str2lower+0x44>
  8010ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	01 d0                	add    %edx,%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 5a                	cmp    $0x5a,%al
  80110b:	7f 19                	jg     801126 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80110d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111b:	01 ca                	add    %ecx,%edx
  80111d:	8a 12                	mov    (%edx),%dl
  80111f:	83 c2 20             	add    $0x20,%edx
  801122:	88 10                	mov    %dl,(%eax)
  801124:	eb 14                	jmp    80113a <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801126:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	01 c2                	add    %eax,%edx
  80112e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	01 c8                	add    %ecx,%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80113a:	ff 45 fc             	incl   -0x4(%ebp)
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	e8 95 f8 ff ff       	call   8009da <strlen>
  801145:	83 c4 04             	add    $0x4,%esp
  801148:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80114b:	7f a4                	jg     8010f1 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  80114d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80116f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801172:	8b 7d 18             	mov    0x18(%ebp),%edi
  801175:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801178:	cd 30                	int    $0x30
  80117a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80117d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801194:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	52                   	push   %edx
  8011a0:	ff 75 0c             	pushl  0xc(%ebp)
  8011a3:	50                   	push   %eax
  8011a4:	6a 00                	push   $0x0
  8011a6:	e8 b2 ff ff ff       	call   80115d <syscall>
  8011ab:	83 c4 18             	add    $0x18,%esp
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 01                	push   $0x1
  8011c0:	e8 98 ff ff ff       	call   80115d <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	52                   	push   %edx
  8011da:	50                   	push   %eax
  8011db:	6a 05                	push   $0x5
  8011dd:	e8 7b ff ff ff       	call   80115d <syscall>
  8011e2:	83 c4 18             	add    $0x18,%esp
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
  8011fd:	51                   	push   %ecx
  8011fe:	52                   	push   %edx
  8011ff:	50                   	push   %eax
  801200:	6a 06                	push   $0x6
  801202:	e8 56 ff ff ff       	call   80115d <syscall>
  801207:	83 c4 18             	add    $0x18,%esp
}
  80120a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	52                   	push   %edx
  801221:	50                   	push   %eax
  801222:	6a 07                	push   $0x7
  801224:	e8 34 ff ff ff       	call   80115d <syscall>
  801229:	83 c4 18             	add    $0x18,%esp
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	ff 75 08             	pushl  0x8(%ebp)
  80123d:	6a 08                	push   $0x8
  80123f:	e8 19 ff ff ff       	call   80115d <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 09                	push   $0x9
  801258:	e8 00 ff ff ff       	call   80115d <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 0a                	push   $0xa
  801271:	e8 e7 fe ff ff       	call   80115d <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 0b                	push   $0xb
  80128a:	e8 ce fe ff ff       	call   80115d <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 0c                	push   $0xc
  8012a3:	e8 b5 fe ff ff       	call   80115d <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	ff 75 08             	pushl  0x8(%ebp)
  8012bb:	6a 0d                	push   $0xd
  8012bd:	e8 9b fe ff ff       	call   80115d <syscall>
  8012c2:	83 c4 18             	add    $0x18,%esp
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 0e                	push   $0xe
  8012d6:	e8 82 fe ff ff       	call   80115d <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	90                   	nop
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 11                	push   $0x11
  8012f0:	e8 68 fe ff ff       	call   80115d <syscall>
  8012f5:	83 c4 18             	add    $0x18,%esp
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 12                	push   $0x12
  80130a:	e8 4e fe ff ff       	call   80115d <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	90                   	nop
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_cputc>:


void
sys_cputc(const char c)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 04             	sub    $0x4,%esp
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801321:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	50                   	push   %eax
  80132e:	6a 13                	push   $0x13
  801330:	e8 28 fe ff ff       	call   80115d <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	90                   	nop
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 14                	push   $0x14
  80134a:	e8 0e fe ff ff       	call   80115d <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	90                   	nop
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	50                   	push   %eax
  801365:	6a 15                	push   $0x15
  801367:	e8 f1 fd ff ff       	call   80115d <syscall>
  80136c:	83 c4 18             	add    $0x18,%esp
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	52                   	push   %edx
  801381:	50                   	push   %eax
  801382:	6a 18                	push   $0x18
  801384:	e8 d4 fd ff ff       	call   80115d <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801391:	8b 55 0c             	mov    0xc(%ebp),%edx
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	52                   	push   %edx
  80139e:	50                   	push   %eax
  80139f:	6a 16                	push   $0x16
  8013a1:	e8 b7 fd ff ff       	call   80115d <syscall>
  8013a6:	83 c4 18             	add    $0x18,%esp
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	52                   	push   %edx
  8013bc:	50                   	push   %eax
  8013bd:	6a 17                	push   $0x17
  8013bf:	e8 99 fd ff ff       	call   80115d <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	90                   	nop
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 04             	sub    $0x4,%esp
  8013d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013d6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	6a 00                	push   $0x0
  8013e2:	51                   	push   %ecx
  8013e3:	52                   	push   %edx
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	50                   	push   %eax
  8013e8:	6a 19                	push   $0x19
  8013ea:	e8 6e fd ff ff       	call   80115d <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	52                   	push   %edx
  801404:	50                   	push   %eax
  801405:	6a 1a                	push   $0x1a
  801407:	e8 51 fd ff ff       	call   80115d <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801414:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	51                   	push   %ecx
  801422:	52                   	push   %edx
  801423:	50                   	push   %eax
  801424:	6a 1b                	push   $0x1b
  801426:	e8 32 fd ff ff       	call   80115d <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	6a 1c                	push   $0x1c
  801443:	e8 15 fd ff ff       	call   80115d <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 1d                	push   $0x1d
  80145c:	e8 fc fc ff ff       	call   80115d <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	6a 00                	push   $0x0
  80146e:	ff 75 14             	pushl  0x14(%ebp)
  801471:	ff 75 10             	pushl  0x10(%ebp)
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	50                   	push   %eax
  801478:	6a 1e                	push   $0x1e
  80147a:	e8 de fc ff ff       	call   80115d <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	50                   	push   %eax
  801493:	6a 1f                	push   $0x1f
  801495:	e8 c3 fc ff ff       	call   80115d <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	90                   	nop
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	50                   	push   %eax
  8014af:	6a 20                	push   $0x20
  8014b1:	e8 a7 fc ff ff       	call   80115d <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 02                	push   $0x2
  8014ca:	e8 8e fc ff ff       	call   80115d <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 03                	push   $0x3
  8014e3:	e8 75 fc ff ff       	call   80115d <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 04                	push   $0x4
  8014fc:	e8 5c fc ff ff       	call   80115d <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_exit_env>:


void sys_exit_env(void)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 21                	push   $0x21
  801515:	e8 43 fc ff ff       	call   80115d <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	90                   	nop
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801526:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801529:	8d 50 04             	lea    0x4(%eax),%edx
  80152c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	52                   	push   %edx
  801536:	50                   	push   %eax
  801537:	6a 22                	push   $0x22
  801539:	e8 1f fc ff ff       	call   80115d <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
	return result;
  801541:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801544:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154a:	89 01                	mov    %eax,(%ecx)
  80154c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	c9                   	leave  
  801553:	c2 04 00             	ret    $0x4

00801556 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	ff 75 10             	pushl  0x10(%ebp)
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	ff 75 08             	pushl  0x8(%ebp)
  801566:	6a 10                	push   $0x10
  801568:	e8 f0 fb ff ff       	call   80115d <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
	return ;
  801570:	90                   	nop
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_rcr2>:
uint32 sys_rcr2()
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 23                	push   $0x23
  801582:	e8 d6 fb ff ff       	call   80115d <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801598:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	50                   	push   %eax
  8015a5:	6a 24                	push   $0x24
  8015a7:	e8 b1 fb ff ff       	call   80115d <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8015af:	90                   	nop
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <rsttst>:
void rsttst()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 26                	push   $0x26
  8015c1:	e8 97 fb ff ff       	call   80115d <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c9:	90                   	nop
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015d8:	8b 55 18             	mov    0x18(%ebp),%edx
  8015db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015df:	52                   	push   %edx
  8015e0:	50                   	push   %eax
  8015e1:	ff 75 10             	pushl  0x10(%ebp)
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	6a 25                	push   $0x25
  8015ec:	e8 6c fb ff ff       	call   80115d <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f4:	90                   	nop
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <chktst>:
void chktst(uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	6a 27                	push   $0x27
  801607:	e8 51 fb ff ff       	call   80115d <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
	return ;
  80160f:	90                   	nop
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <inctst>:

void inctst()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 28                	push   $0x28
  801621:	e8 37 fb ff ff       	call   80115d <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return ;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <gettst>:
uint32 gettst()
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 29                	push   $0x29
  80163b:	e8 1d fb ff ff       	call   80115d <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 2a                	push   $0x2a
  801657:	e8 01 fb ff ff       	call   80115d <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
  80165f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801662:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801666:	75 07                	jne    80166f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801668:	b8 01 00 00 00       	mov    $0x1,%eax
  80166d:	eb 05                	jmp    801674 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 2a                	push   $0x2a
  801688:	e8 d0 fa ff ff       	call   80115d <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
  801690:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801693:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801697:	75 07                	jne    8016a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801699:	b8 01 00 00 00       	mov    $0x1,%eax
  80169e:	eb 05                	jmp    8016a5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 2a                	push   $0x2a
  8016b9:	e8 9f fa ff ff       	call   80115d <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
  8016c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016c4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016c8:	75 07                	jne    8016d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8016cf:	eb 05                	jmp    8016d6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 2a                	push   $0x2a
  8016ea:	e8 6e fa ff ff       	call   80115d <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016f9:	75 07                	jne    801702 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801700:	eb 05                	jmp    801707 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	6a 2b                	push   $0x2b
  801719:	e8 3f fa ff ff       	call   80115d <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
	return ;
  801721:	90                   	nop
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801728:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	6a 00                	push   $0x0
  801736:	53                   	push   %ebx
  801737:	51                   	push   %ecx
  801738:	52                   	push   %edx
  801739:	50                   	push   %eax
  80173a:	6a 2c                	push   $0x2c
  80173c:	e8 1c fa ff ff       	call   80115d <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	6a 2d                	push   $0x2d
  80175c:	e8 fc f9 ff ff       	call   80115d <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801769:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	6a 00                	push   $0x0
  801774:	51                   	push   %ecx
  801775:	ff 75 10             	pushl  0x10(%ebp)
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 2e                	push   $0x2e
  80177c:	e8 dc f9 ff ff       	call   80115d <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 10             	pushl  0x10(%ebp)
  801790:	ff 75 0c             	pushl  0xc(%ebp)
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	6a 0f                	push   $0xf
  801798:	e8 c0 f9 ff ff       	call   80115d <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	50                   	push   %eax
  8017b2:	6a 2f                	push   $0x2f
  8017b4:	e8 a4 f9 ff ff       	call   80115d <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp

}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	6a 30                	push   $0x30
  8017cf:	e8 89 f9 ff ff       	call   80115d <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp

}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	6a 31                	push   $0x31
  8017eb:	e8 6d f9 ff ff       	call   80115d <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp

}
  8017f3:	90                   	nop
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 32                	push   $0x32
  801805:	e8 53 f9 ff ff       	call   80115d <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801815:	8b 55 08             	mov    0x8(%ebp),%edx
  801818:	89 d0                	mov    %edx,%eax
  80181a:	c1 e0 02             	shl    $0x2,%eax
  80181d:	01 d0                	add    %edx,%eax
  80181f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801826:	01 d0                	add    %edx,%eax
  801828:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182f:	01 d0                	add    %edx,%eax
  801831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801838:	01 d0                	add    %edx,%eax
  80183a:	c1 e0 04             	shl    $0x4,%eax
  80183d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801847:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	50                   	push   %eax
  80184e:	e8 cd fc ff ff       	call   801520 <sys_get_virtual_time>
  801853:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801856:	eb 41                	jmp    801899 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801858:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	50                   	push   %eax
  80185f:	e8 bc fc ff ff       	call   801520 <sys_get_virtual_time>
  801864:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801867:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80186a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186d:	29 c2                	sub    %eax,%edx
  80186f:	89 d0                	mov    %edx,%eax
  801871:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801874:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187a:	89 d1                	mov    %edx,%ecx
  80187c:	29 c1                	sub    %eax,%ecx
  80187e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801884:	39 c2                	cmp    %eax,%edx
  801886:	0f 97 c0             	seta   %al
  801889:	0f b6 c0             	movzbl %al,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 c8                	mov    %ecx,%eax
  801890:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801893:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801896:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80189f:	72 b7                	jb     801858 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018b1:	eb 03                	jmp    8018b6 <busy_wait+0x12>
  8018b3:	ff 45 fc             	incl   -0x4(%ebp)
  8018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018bc:	72 f5                	jb     8018b3 <busy_wait+0xf>
	return i;
  8018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    
  8018c3:	90                   	nop

008018c4 <__udivdi3>:
  8018c4:	55                   	push   %ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018db:	89 ca                	mov    %ecx,%edx
  8018dd:	89 f8                	mov    %edi,%eax
  8018df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018e3:	85 f6                	test   %esi,%esi
  8018e5:	75 2d                	jne    801914 <__udivdi3+0x50>
  8018e7:	39 cf                	cmp    %ecx,%edi
  8018e9:	77 65                	ja     801950 <__udivdi3+0x8c>
  8018eb:	89 fd                	mov    %edi,%ebp
  8018ed:	85 ff                	test   %edi,%edi
  8018ef:	75 0b                	jne    8018fc <__udivdi3+0x38>
  8018f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f6:	31 d2                	xor    %edx,%edx
  8018f8:	f7 f7                	div    %edi
  8018fa:	89 c5                	mov    %eax,%ebp
  8018fc:	31 d2                	xor    %edx,%edx
  8018fe:	89 c8                	mov    %ecx,%eax
  801900:	f7 f5                	div    %ebp
  801902:	89 c1                	mov    %eax,%ecx
  801904:	89 d8                	mov    %ebx,%eax
  801906:	f7 f5                	div    %ebp
  801908:	89 cf                	mov    %ecx,%edi
  80190a:	89 fa                	mov    %edi,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	39 ce                	cmp    %ecx,%esi
  801916:	77 28                	ja     801940 <__udivdi3+0x7c>
  801918:	0f bd fe             	bsr    %esi,%edi
  80191b:	83 f7 1f             	xor    $0x1f,%edi
  80191e:	75 40                	jne    801960 <__udivdi3+0x9c>
  801920:	39 ce                	cmp    %ecx,%esi
  801922:	72 0a                	jb     80192e <__udivdi3+0x6a>
  801924:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801928:	0f 87 9e 00 00 00    	ja     8019cc <__udivdi3+0x108>
  80192e:	b8 01 00 00 00       	mov    $0x1,%eax
  801933:	89 fa                	mov    %edi,%edx
  801935:	83 c4 1c             	add    $0x1c,%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5f                   	pop    %edi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    
  80193d:	8d 76 00             	lea    0x0(%esi),%esi
  801940:	31 ff                	xor    %edi,%edi
  801942:	31 c0                	xor    %eax,%eax
  801944:	89 fa                	mov    %edi,%edx
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
  80194e:	66 90                	xchg   %ax,%ax
  801950:	89 d8                	mov    %ebx,%eax
  801952:	f7 f7                	div    %edi
  801954:	31 ff                	xor    %edi,%edi
  801956:	89 fa                	mov    %edi,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	bd 20 00 00 00       	mov    $0x20,%ebp
  801965:	89 eb                	mov    %ebp,%ebx
  801967:	29 fb                	sub    %edi,%ebx
  801969:	89 f9                	mov    %edi,%ecx
  80196b:	d3 e6                	shl    %cl,%esi
  80196d:	89 c5                	mov    %eax,%ebp
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 ed                	shr    %cl,%ebp
  801973:	89 e9                	mov    %ebp,%ecx
  801975:	09 f1                	or     %esi,%ecx
  801977:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80197b:	89 f9                	mov    %edi,%ecx
  80197d:	d3 e0                	shl    %cl,%eax
  80197f:	89 c5                	mov    %eax,%ebp
  801981:	89 d6                	mov    %edx,%esi
  801983:	88 d9                	mov    %bl,%cl
  801985:	d3 ee                	shr    %cl,%esi
  801987:	89 f9                	mov    %edi,%ecx
  801989:	d3 e2                	shl    %cl,%edx
  80198b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198f:	88 d9                	mov    %bl,%cl
  801991:	d3 e8                	shr    %cl,%eax
  801993:	09 c2                	or     %eax,%edx
  801995:	89 d0                	mov    %edx,%eax
  801997:	89 f2                	mov    %esi,%edx
  801999:	f7 74 24 0c          	divl   0xc(%esp)
  80199d:	89 d6                	mov    %edx,%esi
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	f7 e5                	mul    %ebp
  8019a3:	39 d6                	cmp    %edx,%esi
  8019a5:	72 19                	jb     8019c0 <__udivdi3+0xfc>
  8019a7:	74 0b                	je     8019b4 <__udivdi3+0xf0>
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	31 ff                	xor    %edi,%edi
  8019ad:	e9 58 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019b8:	89 f9                	mov    %edi,%ecx
  8019ba:	d3 e2                	shl    %cl,%edx
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	73 e9                	jae    8019a9 <__udivdi3+0xe5>
  8019c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019c3:	31 ff                	xor    %edi,%edi
  8019c5:	e9 40 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	31 c0                	xor    %eax,%eax
  8019ce:	e9 37 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019d3:	90                   	nop

008019d4 <__umoddi3>:
  8019d4:	55                   	push   %ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f3:	89 f3                	mov    %esi,%ebx
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fb:	89 34 24             	mov    %esi,(%esp)
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	75 1a                	jne    801a1c <__umoddi3+0x48>
  801a02:	39 f7                	cmp    %esi,%edi
  801a04:	0f 86 a2 00 00 00    	jbe    801aac <__umoddi3+0xd8>
  801a0a:	89 c8                	mov    %ecx,%eax
  801a0c:	89 f2                	mov    %esi,%edx
  801a0e:	f7 f7                	div    %edi
  801a10:	89 d0                	mov    %edx,%eax
  801a12:	31 d2                	xor    %edx,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 f0                	cmp    %esi,%eax
  801a1e:	0f 87 ac 00 00 00    	ja     801ad0 <__umoddi3+0xfc>
  801a24:	0f bd e8             	bsr    %eax,%ebp
  801a27:	83 f5 1f             	xor    $0x1f,%ebp
  801a2a:	0f 84 ac 00 00 00    	je     801adc <__umoddi3+0x108>
  801a30:	bf 20 00 00 00       	mov    $0x20,%edi
  801a35:	29 ef                	sub    %ebp,%edi
  801a37:	89 fe                	mov    %edi,%esi
  801a39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a3d:	89 e9                	mov    %ebp,%ecx
  801a3f:	d3 e0                	shl    %cl,%eax
  801a41:	89 d7                	mov    %edx,%edi
  801a43:	89 f1                	mov    %esi,%ecx
  801a45:	d3 ef                	shr    %cl,%edi
  801a47:	09 c7                	or     %eax,%edi
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 e2                	shl    %cl,%edx
  801a4d:	89 14 24             	mov    %edx,(%esp)
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	d3 e0                	shl    %cl,%eax
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5a:	d3 e0                	shl    %cl,%eax
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a64:	89 f1                	mov    %esi,%ecx
  801a66:	d3 e8                	shr    %cl,%eax
  801a68:	09 d0                	or     %edx,%eax
  801a6a:	d3 eb                	shr    %cl,%ebx
  801a6c:	89 da                	mov    %ebx,%edx
  801a6e:	f7 f7                	div    %edi
  801a70:	89 d3                	mov    %edx,%ebx
  801a72:	f7 24 24             	mull   (%esp)
  801a75:	89 c6                	mov    %eax,%esi
  801a77:	89 d1                	mov    %edx,%ecx
  801a79:	39 d3                	cmp    %edx,%ebx
  801a7b:	0f 82 87 00 00 00    	jb     801b08 <__umoddi3+0x134>
  801a81:	0f 84 91 00 00 00    	je     801b18 <__umoddi3+0x144>
  801a87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a8b:	29 f2                	sub    %esi,%edx
  801a8d:	19 cb                	sbb    %ecx,%ebx
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 e9                	mov    %ebp,%ecx
  801a99:	d3 ea                	shr    %cl,%edx
  801a9b:	09 d0                	or     %edx,%eax
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 eb                	shr    %cl,%ebx
  801aa1:	89 da                	mov    %ebx,%edx
  801aa3:	83 c4 1c             	add    $0x1c,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    
  801aab:	90                   	nop
  801aac:	89 fd                	mov    %edi,%ebp
  801aae:	85 ff                	test   %edi,%edi
  801ab0:	75 0b                	jne    801abd <__umoddi3+0xe9>
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	31 d2                	xor    %edx,%edx
  801ab9:	f7 f7                	div    %edi
  801abb:	89 c5                	mov    %eax,%ebp
  801abd:	89 f0                	mov    %esi,%eax
  801abf:	31 d2                	xor    %edx,%edx
  801ac1:	f7 f5                	div    %ebp
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	f7 f5                	div    %ebp
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	e9 44 ff ff ff       	jmp    801a12 <__umoddi3+0x3e>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 c8                	mov    %ecx,%eax
  801ad2:	89 f2                	mov    %esi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	3b 04 24             	cmp    (%esp),%eax
  801adf:	72 06                	jb     801ae7 <__umoddi3+0x113>
  801ae1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ae5:	77 0f                	ja     801af6 <__umoddi3+0x122>
  801ae7:	89 f2                	mov    %esi,%edx
  801ae9:	29 f9                	sub    %edi,%ecx
  801aeb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aef:	89 14 24             	mov    %edx,(%esp)
  801af2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801afa:	8b 14 24             	mov    (%esp),%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	2b 04 24             	sub    (%esp),%eax
  801b0b:	19 fa                	sbb    %edi,%edx
  801b0d:	89 d1                	mov    %edx,%ecx
  801b0f:	89 c6                	mov    %eax,%esi
  801b11:	e9 71 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b1c:	72 ea                	jb     801b08 <__umoddi3+0x134>
  801b1e:	89 d9                	mov    %ebx,%ecx
  801b20:	e9 62 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
