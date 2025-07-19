
obj/user/tst_syscalls_2_slave3:     file format elf32-i386


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
  800031:	e8 36 00 00 00       	call   80006c <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	//[2] Invalid Range (Cross USER_LIMIT)
	sys_free_user_mem(USER_LIMIT - PAGE_SIZE, PAGE_SIZE + 10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	68 0a 10 00 00       	push   $0x100a
  800046:	68 00 f0 7f ef       	push   $0xef7ff000
  80004b:	e8 76 18 00 00       	call   8018c6 <sys_free_user_mem>
  800050:	83 c4 10             	add    $0x10,%esp
	inctst();
  800053:	e8 c2 16 00 00       	call   80171a <inctst>
	panic("tst system calls #2 failed: sys_free_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 80 1b 80 00       	push   $0x801b80
  800060:	6a 0a                	push   $0xa
  800062:	68 fe 1b 80 00       	push   $0x801bfe
  800067:	e8 37 01 00 00       	call   8001a3 <_panic>

0080006c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800072:	e8 65 15 00 00       	call   8015dc <sys_getenvindex>
  800077:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80007a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80008f:	01 d0                	add    %edx,%eax
  800091:	c1 e0 04             	shl    $0x4,%eax
  800094:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800099:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009e:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a3:	8a 40 5c             	mov    0x5c(%eax),%al
  8000a6:	84 c0                	test   %al,%al
  8000a8:	74 0d                	je     8000b7 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	83 c0 5c             	add    $0x5c,%eax
  8000b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bb:	7e 0a                	jle    8000c7 <libmain+0x5b>
		binaryname = argv[0];
  8000bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	ff 75 0c             	pushl  0xc(%ebp)
  8000cd:	ff 75 08             	pushl  0x8(%ebp)
  8000d0:	e8 63 ff ff ff       	call   800038 <_main>
  8000d5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d8:	e8 0c 13 00 00       	call   8013e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 34 1c 80 00       	push   $0x801c34
  8000e5:	e8 76 03 00 00       	call   800460 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f2:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fd:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	52                   	push   %edx
  800107:	50                   	push   %eax
  800108:	68 5c 1c 80 00       	push   $0x801c5c
  80010d:	e8 4e 03 00 00       	call   800460 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800115:	a1 20 30 80 00       	mov    0x803020,%eax
  80011a:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800120:	a1 20 30 80 00       	mov    0x803020,%eax
  800125:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80012b:	a1 20 30 80 00       	mov    0x803020,%eax
  800130:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800136:	51                   	push   %ecx
  800137:	52                   	push   %edx
  800138:	50                   	push   %eax
  800139:	68 84 1c 80 00       	push   $0x801c84
  80013e:	e8 1d 03 00 00       	call   800460 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	68 dc 1c 80 00       	push   $0x801cdc
  80015a:	e8 01 03 00 00       	call   800460 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 34 1c 80 00       	push   $0x801c34
  80016a:	e8 f1 02 00 00       	call   800460 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800172:	e8 8c 12 00 00       	call   801403 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800177:	e8 19 00 00 00       	call   800195 <exit>
}
  80017c:	90                   	nop
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 19 14 00 00       	call   8015a8 <sys_destroy_env>
  80018f:	83 c4 10             	add    $0x10,%esp
}
  800192:	90                   	nop
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <exit>:

void
exit(void)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019b:	e8 6e 14 00 00       	call   80160e <sys_exit_env>
}
  8001a0:	90                   	nop
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8001ac:	83 c0 04             	add    $0x4,%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001b2:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	74 16                	je     8001d1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001bb:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 f0 1c 80 00       	push   $0x801cf0
  8001c9:	e8 92 02 00 00       	call   800460 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d1:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d6:	ff 75 0c             	pushl  0xc(%ebp)
  8001d9:	ff 75 08             	pushl  0x8(%ebp)
  8001dc:	50                   	push   %eax
  8001dd:	68 f5 1c 80 00       	push   $0x801cf5
  8001e2:	e8 79 02 00 00       	call   800460 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f3:	50                   	push   %eax
  8001f4:	e8 fc 01 00 00       	call   8003f5 <vcprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	68 11 1d 80 00       	push   $0x801d11
  800206:	e8 ea 01 00 00       	call   8003f5 <vcprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020e:	e8 82 ff ff ff       	call   800195 <exit>

	// should not return here
	while (1) ;
  800213:	eb fe                	jmp    800213 <_panic+0x70>

00800215 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80021b:	a1 20 30 80 00       	mov    0x803020,%eax
  800220:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	39 c2                	cmp    %eax,%edx
  80022b:	74 14                	je     800241 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	68 14 1d 80 00       	push   $0x801d14
  800235:	6a 26                	push   $0x26
  800237:	68 60 1d 80 00       	push   $0x801d60
  80023c:	e8 62 ff ff ff       	call   8001a3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800248:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024f:	e9 c5 00 00 00       	jmp    800319 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800257:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	8b 00                	mov    (%eax),%eax
  800265:	85 c0                	test   %eax,%eax
  800267:	75 08                	jne    800271 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800269:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80026c:	e9 a5 00 00 00       	jmp    800316 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800271:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800278:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027f:	eb 69                	jmp    8002ea <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800281:	a1 20 30 80 00       	mov    0x803020,%eax
  800286:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80028c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028f:	89 d0                	mov    %edx,%eax
  800291:	01 c0                	add    %eax,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	c1 e0 03             	shl    $0x3,%eax
  800298:	01 c8                	add    %ecx,%eax
  80029a:	8a 40 04             	mov    0x4(%eax),%al
  80029d:	84 c0                	test   %al,%al
  80029f:	75 46                	jne    8002e7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	c1 e0 03             	shl    $0x3,%eax
  8002b8:	01 c8                	add    %ecx,%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002da:	39 c2                	cmp    %eax,%edx
  8002dc:	75 09                	jne    8002e7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e5:	eb 15                	jmp    8002fc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e7:	ff 45 e8             	incl   -0x18(%ebp)
  8002ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ef:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8002f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f8:	39 c2                	cmp    %eax,%edx
  8002fa:	77 85                	ja     800281 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800300:	75 14                	jne    800316 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	68 6c 1d 80 00       	push   $0x801d6c
  80030a:	6a 3a                	push   $0x3a
  80030c:	68 60 1d 80 00       	push   $0x801d60
  800311:	e8 8d fe ff ff       	call   8001a3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800316:	ff 45 f0             	incl   -0x10(%ebp)
  800319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031f:	0f 8c 2f ff ff ff    	jl     800254 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800325:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800333:	eb 26                	jmp    80035b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800335:	a1 20 30 80 00       	mov    0x803020,%eax
  80033a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800340:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	01 c0                	add    %eax,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	c1 e0 03             	shl    $0x3,%eax
  80034c:	01 c8                	add    %ecx,%eax
  80034e:	8a 40 04             	mov    0x4(%eax),%al
  800351:	3c 01                	cmp    $0x1,%al
  800353:	75 03                	jne    800358 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800355:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800358:	ff 45 e0             	incl   -0x20(%ebp)
  80035b:	a1 20 30 80 00       	mov    0x803020,%eax
  800360:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	39 c2                	cmp    %eax,%edx
  80036b:	77 c8                	ja     800335 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800370:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800373:	74 14                	je     800389 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	68 c0 1d 80 00       	push   $0x801dc0
  80037d:	6a 44                	push   $0x44
  80037f:	68 60 1d 80 00       	push   $0x801d60
  800384:	e8 1a fe ff ff       	call   8001a3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800389:	90                   	nop
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800392:	8b 45 0c             	mov    0xc(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 48 01             	lea    0x1(%eax),%ecx
  80039a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039d:	89 0a                	mov    %ecx,(%edx)
  80039f:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a2:	88 d1                	mov    %dl,%cl
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b5:	75 2c                	jne    8003e3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b7:	a0 24 30 80 00       	mov    0x803024,%al
  8003bc:	0f b6 c0             	movzbl %al,%eax
  8003bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c2:	8b 12                	mov    (%edx),%edx
  8003c4:	89 d1                	mov    %edx,%ecx
  8003c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c9:	83 c2 08             	add    $0x8,%edx
  8003cc:	83 ec 04             	sub    $0x4,%esp
  8003cf:	50                   	push   %eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	e8 b9 0e 00 00       	call   801290 <sys_cputs>
  8003d7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e6:	8b 40 04             	mov    0x4(%eax),%eax
  8003e9:	8d 50 01             	lea    0x1(%eax),%edx
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ef:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003f2:	90                   	nop
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800405:	00 00 00 
	b.cnt = 0;
  800408:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800412:	ff 75 0c             	pushl  0xc(%ebp)
  800415:	ff 75 08             	pushl  0x8(%ebp)
  800418:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041e:	50                   	push   %eax
  80041f:	68 8c 03 80 00       	push   $0x80038c
  800424:	e8 11 02 00 00       	call   80063a <vprintfmt>
  800429:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80042c:	a0 24 30 80 00       	mov    0x803024,%al
  800431:	0f b6 c0             	movzbl %al,%eax
  800434:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	50                   	push   %eax
  80043e:	52                   	push   %edx
  80043f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800445:	83 c0 08             	add    $0x8,%eax
  800448:	50                   	push   %eax
  800449:	e8 42 0e 00 00       	call   801290 <sys_cputs>
  80044e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800451:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800458:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <cprintf>:

int cprintf(const char *fmt, ...) {
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800466:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80046d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800470:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 f4             	pushl  -0xc(%ebp)
  80047c:	50                   	push   %eax
  80047d:	e8 73 ff ff ff       	call   8003f5 <vcprintf>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800488:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048b:	c9                   	leave  
  80048c:	c3                   	ret    

0080048d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800493:	e8 51 0f 00 00       	call   8013e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800498:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	e8 48 ff ff ff       	call   8003f5 <vcprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004b3:	e8 4b 0f 00 00       	call   801403 <sys_enable_interrupt>
	return cnt;
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	53                   	push   %ebx
  8004c1:	83 ec 14             	sub    $0x14,%esp
  8004c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004db:	77 55                	ja     800532 <printnum+0x75>
  8004dd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e0:	72 05                	jb     8004e7 <printnum+0x2a>
  8004e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e5:	77 4b                	ja     800532 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ea:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f5:	52                   	push   %edx
  8004f6:	50                   	push   %eax
  8004f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fd:	e8 16 14 00 00       	call   801918 <__udivdi3>
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	ff 75 20             	pushl  0x20(%ebp)
  80050b:	53                   	push   %ebx
  80050c:	ff 75 18             	pushl  0x18(%ebp)
  80050f:	52                   	push   %edx
  800510:	50                   	push   %eax
  800511:	ff 75 0c             	pushl  0xc(%ebp)
  800514:	ff 75 08             	pushl  0x8(%ebp)
  800517:	e8 a1 ff ff ff       	call   8004bd <printnum>
  80051c:	83 c4 20             	add    $0x20,%esp
  80051f:	eb 1a                	jmp    80053b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 20             	pushl  0x20(%ebp)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	ff d0                	call   *%eax
  80052f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800532:	ff 4d 1c             	decl   0x1c(%ebp)
  800535:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800539:	7f e6                	jg     800521 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800549:	53                   	push   %ebx
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	e8 d6 14 00 00       	call   801a28 <__umoddi3>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	05 34 20 80 00       	add    $0x802034,%eax
  80055a:	8a 00                	mov    (%eax),%al
  80055c:	0f be c0             	movsbl %al,%eax
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	50                   	push   %eax
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	ff d0                	call   *%eax
  80056b:	83 c4 10             	add    $0x10,%esp
}
  80056e:	90                   	nop
  80056f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800577:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057b:	7e 1c                	jle    800599 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	8d 50 08             	lea    0x8(%eax),%edx
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	89 10                	mov    %edx,(%eax)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	83 e8 08             	sub    $0x8,%eax
  800592:	8b 50 04             	mov    0x4(%eax),%edx
  800595:	8b 00                	mov    (%eax),%eax
  800597:	eb 40                	jmp    8005d9 <getuint+0x65>
	else if (lflag)
  800599:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059d:	74 1e                	je     8005bd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059f:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	89 10                	mov    %edx,(%eax)
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	83 e8 04             	sub    $0x4,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	eb 1c                	jmp    8005d9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	8d 50 04             	lea    0x4(%eax),%edx
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	89 10                	mov    %edx,(%eax)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	83 e8 04             	sub    $0x4,%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d9:	5d                   	pop    %ebp
  8005da:	c3                   	ret    

008005db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e2:	7e 1c                	jle    800600 <getint+0x25>
		return va_arg(*ap, long long);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8d 50 08             	lea    0x8(%eax),%edx
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	89 10                	mov    %edx,(%eax)
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	83 e8 08             	sub    $0x8,%eax
  8005f9:	8b 50 04             	mov    0x4(%eax),%edx
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	eb 38                	jmp    800638 <getint+0x5d>
	else if (lflag)
  800600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800604:	74 1a                	je     800620 <getint+0x45>
		return va_arg(*ap, long);
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	89 10                	mov    %edx,(%eax)
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	83 e8 04             	sub    $0x4,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	99                   	cltd   
  80061e:	eb 18                	jmp    800638 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	8d 50 04             	lea    0x4(%eax),%edx
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	89 10                	mov    %edx,(%eax)
  80062d:	8b 45 08             	mov    0x8(%ebp),%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	83 e8 04             	sub    $0x4,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	99                   	cltd   
}
  800638:	5d                   	pop    %ebp
  800639:	c3                   	ret    

0080063a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	56                   	push   %esi
  80063e:	53                   	push   %ebx
  80063f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800642:	eb 17                	jmp    80065b <vprintfmt+0x21>
			if (ch == '\0')
  800644:	85 db                	test   %ebx,%ebx
  800646:	0f 84 af 03 00 00    	je     8009fb <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	53                   	push   %ebx
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	ff d0                	call   *%eax
  800658:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065b:	8b 45 10             	mov    0x10(%ebp),%eax
  80065e:	8d 50 01             	lea    0x1(%eax),%edx
  800661:	89 55 10             	mov    %edx,0x10(%ebp)
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f b6 d8             	movzbl %al,%ebx
  800669:	83 fb 25             	cmp    $0x25,%ebx
  80066c:	75 d6                	jne    800644 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800672:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800679:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800680:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800687:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068e:	8b 45 10             	mov    0x10(%ebp),%eax
  800691:	8d 50 01             	lea    0x1(%eax),%edx
  800694:	89 55 10             	mov    %edx,0x10(%ebp)
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f b6 d8             	movzbl %al,%ebx
  80069c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069f:	83 f8 55             	cmp    $0x55,%eax
  8006a2:	0f 87 2b 03 00 00    	ja     8009d3 <vprintfmt+0x399>
  8006a8:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006af:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d7                	jmp    80068e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006bb:	eb d1                	jmp    80068e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c7:	89 d0                	mov    %edx,%eax
  8006c9:	c1 e0 02             	shl    $0x2,%eax
  8006cc:	01 d0                	add    %edx,%eax
  8006ce:	01 c0                	add    %eax,%eax
  8006d0:	01 d8                	add    %ebx,%eax
  8006d2:	83 e8 30             	sub    $0x30,%eax
  8006d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006db:	8a 00                	mov    (%eax),%al
  8006dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e3:	7e 3e                	jle    800723 <vprintfmt+0xe9>
  8006e5:	83 fb 39             	cmp    $0x39,%ebx
  8006e8:	7f 39                	jg     800723 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ea:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ed:	eb d5                	jmp    8006c4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	83 c0 04             	add    $0x4,%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	83 e8 04             	sub    $0x4,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800703:	eb 1f                	jmp    800724 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800705:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800709:	79 83                	jns    80068e <vprintfmt+0x54>
				width = 0;
  80070b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800712:	e9 77 ff ff ff       	jmp    80068e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800717:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071e:	e9 6b ff ff ff       	jmp    80068e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800723:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800728:	0f 89 60 ff ff ff    	jns    80068e <vprintfmt+0x54>
				width = precision, precision = -1;
  80072e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800734:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073b:	e9 4e ff ff ff       	jmp    80068e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800740:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800743:	e9 46 ff ff ff       	jmp    80068e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	83 c0 04             	add    $0x4,%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	50                   	push   %eax
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
			break;
  800768:	e9 89 02 00 00       	jmp    8009f6 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	83 c0 04             	add    $0x4,%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	83 e8 04             	sub    $0x4,%eax
  80077c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077e:	85 db                	test   %ebx,%ebx
  800780:	79 02                	jns    800784 <vprintfmt+0x14a>
				err = -err;
  800782:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800784:	83 fb 64             	cmp    $0x64,%ebx
  800787:	7f 0b                	jg     800794 <vprintfmt+0x15a>
  800789:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800790:	85 f6                	test   %esi,%esi
  800792:	75 19                	jne    8007ad <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800794:	53                   	push   %ebx
  800795:	68 45 20 80 00       	push   $0x802045
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	ff 75 08             	pushl  0x8(%ebp)
  8007a0:	e8 5e 02 00 00       	call   800a03 <printfmt>
  8007a5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a8:	e9 49 02 00 00       	jmp    8009f6 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ad:	56                   	push   %esi
  8007ae:	68 4e 20 80 00       	push   $0x80204e
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	e8 45 02 00 00       	call   800a03 <printfmt>
  8007be:	83 c4 10             	add    $0x10,%esp
			break;
  8007c1:	e9 30 02 00 00       	jmp    8009f6 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	83 c0 04             	add    $0x4,%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	83 e8 04             	sub    $0x4,%eax
  8007d5:	8b 30                	mov    (%eax),%esi
  8007d7:	85 f6                	test   %esi,%esi
  8007d9:	75 05                	jne    8007e0 <vprintfmt+0x1a6>
				p = "(null)";
  8007db:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e4:	7e 6d                	jle    800853 <vprintfmt+0x219>
  8007e6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ea:	74 67                	je     800853 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	50                   	push   %eax
  8007f3:	56                   	push   %esi
  8007f4:	e8 0c 03 00 00       	call   800b05 <strnlen>
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ff:	eb 16                	jmp    800817 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800801:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	50                   	push   %eax
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	ff d0                	call   *%eax
  800811:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800814:	ff 4d e4             	decl   -0x1c(%ebp)
  800817:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081b:	7f e4                	jg     800801 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081d:	eb 34                	jmp    800853 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800823:	74 1c                	je     800841 <vprintfmt+0x207>
  800825:	83 fb 1f             	cmp    $0x1f,%ebx
  800828:	7e 05                	jle    80082f <vprintfmt+0x1f5>
  80082a:	83 fb 7e             	cmp    $0x7e,%ebx
  80082d:	7e 12                	jle    800841 <vprintfmt+0x207>
					putch('?', putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	6a 3f                	push   $0x3f
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	eb 0f                	jmp    800850 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	53                   	push   %ebx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800850:	ff 4d e4             	decl   -0x1c(%ebp)
  800853:	89 f0                	mov    %esi,%eax
  800855:	8d 70 01             	lea    0x1(%eax),%esi
  800858:	8a 00                	mov    (%eax),%al
  80085a:	0f be d8             	movsbl %al,%ebx
  80085d:	85 db                	test   %ebx,%ebx
  80085f:	74 24                	je     800885 <vprintfmt+0x24b>
  800861:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800865:	78 b8                	js     80081f <vprintfmt+0x1e5>
  800867:	ff 4d e0             	decl   -0x20(%ebp)
  80086a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086e:	79 af                	jns    80081f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800870:	eb 13                	jmp    800885 <vprintfmt+0x24b>
				putch(' ', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	6a 20                	push   $0x20
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800882:	ff 4d e4             	decl   -0x1c(%ebp)
  800885:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800889:	7f e7                	jg     800872 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088b:	e9 66 01 00 00       	jmp    8009f6 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 e8             	pushl  -0x18(%ebp)
  800896:	8d 45 14             	lea    0x14(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	e8 3c fd ff ff       	call   8005db <getint>
  80089f:	83 c4 10             	add    $0x10,%esp
  8008a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ae:	85 d2                	test   %edx,%edx
  8008b0:	79 23                	jns    8008d5 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 2d                	push   $0x2d
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c8:	f7 d8                	neg    %eax
  8008ca:	83 d2 00             	adc    $0x0,%edx
  8008cd:	f7 da                	neg    %edx
  8008cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008dc:	e9 bc 00 00 00       	jmp    80099d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	e8 84 fc ff ff       	call   800574 <getuint>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800900:	e9 98 00 00 00       	jmp    80099d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 58                	push   $0x58
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	6a 58                	push   $0x58
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	6a 58                	push   $0x58
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
			break;
  800935:	e9 bc 00 00 00       	jmp    8009f6 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	6a 30                	push   $0x30
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	ff d0                	call   *%eax
  800947:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	6a 78                	push   $0x78
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	83 e8 04             	sub    $0x4,%eax
  800969:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800975:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097c:	eb 1f                	jmp    80099d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 e8             	pushl  -0x18(%ebp)
  800984:	8d 45 14             	lea    0x14(%ebp),%eax
  800987:	50                   	push   %eax
  800988:	e8 e7 fb ff ff       	call   800574 <getuint>
  80098d:	83 c4 10             	add    $0x10,%esp
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800993:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800996:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	52                   	push   %edx
  8009a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ab:	50                   	push   %eax
  8009ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8009af:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	ff 75 08             	pushl  0x8(%ebp)
  8009b8:	e8 00 fb ff ff       	call   8004bd <printnum>
  8009bd:	83 c4 20             	add    $0x20,%esp
			break;
  8009c0:	eb 34                	jmp    8009f6 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			break;
  8009d1:	eb 23                	jmp    8009f6 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	6a 25                	push   $0x25
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	ff d0                	call   *%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e3:	ff 4d 10             	decl   0x10(%ebp)
  8009e6:	eb 03                	jmp    8009eb <vprintfmt+0x3b1>
  8009e8:	ff 4d 10             	decl   0x10(%ebp)
  8009eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ee:	48                   	dec    %eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	3c 25                	cmp    $0x25,%al
  8009f3:	75 f3                	jne    8009e8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009f5:	90                   	nop
		}
	}
  8009f6:	e9 47 fc ff ff       	jmp    800642 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a09:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	ff 75 f4             	pushl  -0xc(%ebp)
  800a18:	50                   	push   %eax
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	ff 75 08             	pushl  0x8(%ebp)
  800a1f:	e8 16 fc ff ff       	call   80063a <vprintfmt>
  800a24:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a27:	90                   	nop
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8b 40 08             	mov    0x8(%eax),%eax
  800a33:	8d 50 01             	lea    0x1(%eax),%edx
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8b 10                	mov    (%eax),%edx
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8b 40 04             	mov    0x4(%eax),%eax
  800a47:	39 c2                	cmp    %eax,%edx
  800a49:	73 12                	jae    800a5d <sprintputch+0x33>
		*b->buf++ = ch;
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	8d 48 01             	lea    0x1(%eax),%ecx
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a56:	89 0a                	mov    %ecx,(%edx)
  800a58:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5b:	88 10                	mov    %dl,(%eax)
}
  800a5d:	90                   	nop
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a85:	74 06                	je     800a8d <vsnprintf+0x2d>
  800a87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8b:	7f 07                	jg     800a94 <vsnprintf+0x34>
		return -E_INVAL;
  800a8d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a92:	eb 20                	jmp    800ab4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a94:	ff 75 14             	pushl  0x14(%ebp)
  800a97:	ff 75 10             	pushl  0x10(%ebp)
  800a9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9d:	50                   	push   %eax
  800a9e:	68 2a 0a 80 00       	push   $0x800a2a
  800aa3:	e8 92 fb ff ff       	call   80063a <vprintfmt>
  800aa8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800abc:	8d 45 10             	lea    0x10(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  800acb:	50                   	push   %eax
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 08             	pushl  0x8(%ebp)
  800ad2:	e8 89 ff ff ff       	call   800a60 <vsnprintf>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800add:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aef:	eb 06                	jmp    800af7 <strlen+0x15>
		n++;
  800af1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af4:	ff 45 08             	incl   0x8(%ebp)
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 f1                	jne    800af1 <strlen+0xf>
		n++;
	return n;
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b03:	c9                   	leave  
  800b04:	c3                   	ret    

00800b05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b12:	eb 09                	jmp    800b1d <strnlen+0x18>
		n++;
  800b14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b17:	ff 45 08             	incl   0x8(%ebp)
  800b1a:	ff 4d 0c             	decl   0xc(%ebp)
  800b1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b21:	74 09                	je     800b2c <strnlen+0x27>
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	84 c0                	test   %al,%al
  800b2a:	75 e8                	jne    800b14 <strnlen+0xf>
		n++;
	return n;
  800b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b3d:	90                   	nop
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8d 50 01             	lea    0x1(%eax),%edx
  800b44:	89 55 08             	mov    %edx,0x8(%ebp)
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b50:	8a 12                	mov    (%edx),%dl
  800b52:	88 10                	mov    %dl,(%eax)
  800b54:	8a 00                	mov    (%eax),%al
  800b56:	84 c0                	test   %al,%al
  800b58:	75 e4                	jne    800b3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b72:	eb 1f                	jmp    800b93 <strncpy+0x34>
		*dst++ = *src;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8d 50 01             	lea    0x1(%eax),%edx
  800b7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	8a 12                	mov    (%edx),%dl
  800b82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	84 c0                	test   %al,%al
  800b8b:	74 03                	je     800b90 <strncpy+0x31>
			src++;
  800b8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b90:	ff 45 fc             	incl   -0x4(%ebp)
  800b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b99:	72 d9                	jb     800b74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb0:	74 30                	je     800be2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bb2:	eb 16                	jmp    800bca <strlcpy+0x2a>
			*dst++ = *src++;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8d 50 01             	lea    0x1(%eax),%edx
  800bba:	89 55 08             	mov    %edx,0x8(%ebp)
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc6:	8a 12                	mov    (%edx),%dl
  800bc8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bca:	ff 4d 10             	decl   0x10(%ebp)
  800bcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd1:	74 09                	je     800bdc <strlcpy+0x3c>
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	84 c0                	test   %al,%al
  800bda:	75 d8                	jne    800bb4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be8:	29 c2                	sub    %eax,%edx
  800bea:	89 d0                	mov    %edx,%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf1:	eb 06                	jmp    800bf9 <strcmp+0xb>
		p++, q++;
  800bf3:	ff 45 08             	incl   0x8(%ebp)
  800bf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	74 0e                	je     800c10 <strcmp+0x22>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 10                	mov    (%eax),%dl
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	38 c2                	cmp    %al,%dl
  800c0e:	74 e3                	je     800bf3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	0f b6 d0             	movzbl %al,%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	0f b6 c0             	movzbl %al,%eax
  800c20:	29 c2                	sub    %eax,%edx
  800c22:	89 d0                	mov    %edx,%eax
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c29:	eb 09                	jmp    800c34 <strncmp+0xe>
		n--, p++, q++;
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	ff 45 08             	incl   0x8(%ebp)
  800c31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c38:	74 17                	je     800c51 <strncmp+0x2b>
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	74 0e                	je     800c51 <strncmp+0x2b>
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8a 10                	mov    (%eax),%dl
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	38 c2                	cmp    %al,%dl
  800c4f:	74 da                	je     800c2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	75 07                	jne    800c5e <strncmp+0x38>
		return 0;
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	eb 14                	jmp    800c72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 d0             	movzbl %al,%edx
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	29 c2                	sub    %eax,%edx
  800c70:	89 d0                	mov    %edx,%eax
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c80:	eb 12                	jmp    800c94 <strchr+0x20>
		if (*s == c)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c8a:	75 05                	jne    800c91 <strchr+0x1d>
			return (char *) s;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	eb 11                	jmp    800ca2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 e5                	jne    800c82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 04             	sub    $0x4,%esp
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb0:	eb 0d                	jmp    800cbf <strfind+0x1b>
		if (*s == c)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cba:	74 0e                	je     800cca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 ea                	jne    800cb2 <strfind+0xe>
  800cc8:	eb 01                	jmp    800ccb <strfind+0x27>
		if (*s == c)
			break;
  800cca:	90                   	nop
	return (char *) s;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ce2:	eb 0e                	jmp    800cf2 <memset+0x22>
		*p++ = c;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce7:	8d 50 01             	lea    0x1(%eax),%edx
  800cea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cf2:	ff 4d f8             	decl   -0x8(%ebp)
  800cf5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf9:	79 e9                	jns    800ce4 <memset+0x14>
		*p++ = c;

	return v;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d12:	eb 16                	jmp    800d2a <memcpy+0x2a>
		*d++ = *s++;
  800d14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d17:	8d 50 01             	lea    0x1(%eax),%edx
  800d1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d23:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d26:	8a 12                	mov    (%edx),%dl
  800d28:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d30:	89 55 10             	mov    %edx,0x10(%ebp)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	75 dd                	jne    800d14 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d54:	73 50                	jae    800da6 <memmove+0x6a>
  800d56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	01 d0                	add    %edx,%eax
  800d5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d61:	76 43                	jbe    800da6 <memmove+0x6a>
		s += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d6f:	eb 10                	jmp    800d81 <memmove+0x45>
			*--d = *--s;
  800d71:	ff 4d f8             	decl   -0x8(%ebp)
  800d74:	ff 4d fc             	decl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	8a 10                	mov    (%eax),%dl
  800d7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d87:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	75 e3                	jne    800d71 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8e:	eb 23                	jmp    800db3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d93:	8d 50 01             	lea    0x1(%eax),%edx
  800d96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da2:	8a 12                	mov    (%edx),%dl
  800da4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dac:	89 55 10             	mov    %edx,0x10(%ebp)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	75 dd                	jne    800d90 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db6:	c9                   	leave  
  800db7:	c3                   	ret    

00800db8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dca:	eb 2a                	jmp    800df6 <memcmp+0x3e>
		if (*s1 != *s2)
  800dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 16                	je     800df0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 d0             	movzbl %al,%edx
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 c0             	movzbl %al,%eax
  800dea:	29 c2                	sub    %eax,%edx
  800dec:	89 d0                	mov    %edx,%eax
  800dee:	eb 18                	jmp    800e08 <memcmp+0x50>
		s1++, s2++;
  800df0:	ff 45 fc             	incl   -0x4(%ebp)
  800df3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df6:	8b 45 10             	mov    0x10(%ebp),%eax
  800df9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfc:	89 55 10             	mov    %edx,0x10(%ebp)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	75 c9                	jne    800dcc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	01 d0                	add    %edx,%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e1b:	eb 15                	jmp    800e32 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	0f b6 d0             	movzbl %al,%edx
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	0f b6 c0             	movzbl %al,%eax
  800e2b:	39 c2                	cmp    %eax,%edx
  800e2d:	74 0d                	je     800e3c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e2f:	ff 45 08             	incl   0x8(%ebp)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e38:	72 e3                	jb     800e1d <memfind+0x13>
  800e3a:	eb 01                	jmp    800e3d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e3c:	90                   	nop
	return (void *) s;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e56:	eb 03                	jmp    800e5b <strtol+0x19>
		s++;
  800e58:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	3c 20                	cmp    $0x20,%al
  800e62:	74 f4                	je     800e58 <strtol+0x16>
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	3c 09                	cmp    $0x9,%al
  800e6b:	74 eb                	je     800e58 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	3c 2b                	cmp    $0x2b,%al
  800e74:	75 05                	jne    800e7b <strtol+0x39>
		s++;
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	eb 13                	jmp    800e8e <strtol+0x4c>
	else if (*s == '-')
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	3c 2d                	cmp    $0x2d,%al
  800e82:	75 0a                	jne    800e8e <strtol+0x4c>
		s++, neg = 1;
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e92:	74 06                	je     800e9a <strtol+0x58>
  800e94:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e98:	75 20                	jne    800eba <strtol+0x78>
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	3c 30                	cmp    $0x30,%al
  800ea1:	75 17                	jne    800eba <strtol+0x78>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	40                   	inc    %eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	3c 78                	cmp    $0x78,%al
  800eab:	75 0d                	jne    800eba <strtol+0x78>
		s += 2, base = 16;
  800ead:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb8:	eb 28                	jmp    800ee2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	75 15                	jne    800ed5 <strtol+0x93>
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	3c 30                	cmp    $0x30,%al
  800ec7:	75 0c                	jne    800ed5 <strtol+0x93>
		s++, base = 8;
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed3:	eb 0d                	jmp    800ee2 <strtol+0xa0>
	else if (base == 0)
  800ed5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed9:	75 07                	jne    800ee2 <strtol+0xa0>
		base = 10;
  800edb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	3c 2f                	cmp    $0x2f,%al
  800ee9:	7e 19                	jle    800f04 <strtol+0xc2>
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	3c 39                	cmp    $0x39,%al
  800ef2:	7f 10                	jg     800f04 <strtol+0xc2>
			dig = *s - '0';
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	0f be c0             	movsbl %al,%eax
  800efc:	83 e8 30             	sub    $0x30,%eax
  800eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f02:	eb 42                	jmp    800f46 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 60                	cmp    $0x60,%al
  800f0b:	7e 19                	jle    800f26 <strtol+0xe4>
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 7a                	cmp    $0x7a,%al
  800f14:	7f 10                	jg     800f26 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	0f be c0             	movsbl %al,%eax
  800f1e:	83 e8 57             	sub    $0x57,%eax
  800f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f24:	eb 20                	jmp    800f46 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 40                	cmp    $0x40,%al
  800f2d:	7e 39                	jle    800f68 <strtol+0x126>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 5a                	cmp    $0x5a,%al
  800f36:	7f 30                	jg     800f68 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f be c0             	movsbl %al,%eax
  800f40:	83 e8 37             	sub    $0x37,%eax
  800f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f49:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4c:	7d 19                	jge    800f67 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f4e:	ff 45 08             	incl   0x8(%ebp)
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f58:	89 c2                	mov    %eax,%edx
  800f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5d:	01 d0                	add    %edx,%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f62:	e9 7b ff ff ff       	jmp    800ee2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f67:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6c:	74 08                	je     800f76 <strtol+0x134>
		*endptr = (char *) s;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f7a:	74 07                	je     800f83 <strtol+0x141>
  800f7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7f:	f7 d8                	neg    %eax
  800f81:	eb 03                	jmp    800f86 <strtol+0x144>
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <ltostr>:

void
ltostr(long value, char *str)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa0:	79 13                	jns    800fb5 <ltostr+0x2d>
	{
		neg = 1;
  800fa2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800faf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fbd:	99                   	cltd   
  800fbe:	f7 f9                	idiv   %ecx
  800fc0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc6:	8d 50 01             	lea    0x1(%eax),%edx
  800fc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcc:	89 c2                	mov    %eax,%edx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	01 d0                	add    %edx,%eax
  800fd3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd6:	83 c2 30             	add    $0x30,%edx
  800fd9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fde:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe3:	f7 e9                	imul   %ecx
  800fe5:	c1 fa 02             	sar    $0x2,%edx
  800fe8:	89 c8                	mov    %ecx,%eax
  800fea:	c1 f8 1f             	sar    $0x1f,%eax
  800fed:	29 c2                	sub    %eax,%edx
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ff4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ffc:	f7 e9                	imul   %ecx
  800ffe:	c1 fa 02             	sar    $0x2,%edx
  801001:	89 c8                	mov    %ecx,%eax
  801003:	c1 f8 1f             	sar    $0x1f,%eax
  801006:	29 c2                	sub    %eax,%edx
  801008:	89 d0                	mov    %edx,%eax
  80100a:	c1 e0 02             	shl    $0x2,%eax
  80100d:	01 d0                	add    %edx,%eax
  80100f:	01 c0                	add    %eax,%eax
  801011:	29 c1                	sub    %eax,%ecx
  801013:	89 ca                	mov    %ecx,%edx
  801015:	85 d2                	test   %edx,%edx
  801017:	75 9c                	jne    800fb5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801019:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801023:	48                   	dec    %eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801027:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102b:	74 3d                	je     80106a <ltostr+0xe2>
		start = 1 ;
  80102d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801034:	eb 34                	jmp    80106a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	01 d0                	add    %edx,%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	01 c2                	add    %eax,%edx
  80104b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	01 c8                	add    %ecx,%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	01 c2                	add    %eax,%edx
  80105f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801062:	88 02                	mov    %al,(%edx)
		start++ ;
  801064:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801067:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80106a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801070:	7c c4                	jl     801036 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801072:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	01 d0                	add    %edx,%eax
  80107a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80107d:	90                   	nop
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
  801083:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801086:	ff 75 08             	pushl  0x8(%ebp)
  801089:	e8 54 fa ff ff       	call   800ae2 <strlen>
  80108e:	83 c4 04             	add    $0x4,%esp
  801091:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	e8 46 fa ff ff       	call   800ae2 <strlen>
  80109c:	83 c4 04             	add    $0x4,%esp
  80109f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b0:	eb 17                	jmp    8010c9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	01 c2                	add    %eax,%edx
  8010ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	01 c8                	add    %ecx,%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c6:	ff 45 fc             	incl   -0x4(%ebp)
  8010c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010cf:	7c e1                	jl     8010b2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010df:	eb 1f                	jmp    801100 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e4:	8d 50 01             	lea    0x1(%eax),%edx
  8010e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	01 c2                	add    %eax,%edx
  8010f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	01 c8                	add    %ecx,%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010fd:	ff 45 f8             	incl   -0x8(%ebp)
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801106:	7c d9                	jl     8010e1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	c6 00 00             	movb   $0x0,(%eax)
}
  801113:	90                   	nop
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801119:	8b 45 14             	mov    0x14(%ebp),%eax
  80111c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801122:	8b 45 14             	mov    0x14(%ebp),%eax
  801125:	8b 00                	mov    (%eax),%eax
  801127:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801139:	eb 0c                	jmp    801147 <strsplit+0x31>
			*string++ = 0;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8d 50 01             	lea    0x1(%eax),%edx
  801141:	89 55 08             	mov    %edx,0x8(%ebp)
  801144:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	84 c0                	test   %al,%al
  80114e:	74 18                	je     801168 <strsplit+0x52>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	50                   	push   %eax
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 13 fb ff ff       	call   800c74 <strchr>
  801161:	83 c4 08             	add    $0x8,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	75 d3                	jne    80113b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	84 c0                	test   %al,%al
  80116f:	74 5a                	je     8011cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	83 f8 0f             	cmp    $0xf,%eax
  801179:	75 07                	jne    801182 <strsplit+0x6c>
		{
			return 0;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
  801180:	eb 66                	jmp    8011e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801182:	8b 45 14             	mov    0x14(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 48 01             	lea    0x1(%eax),%ecx
  80118a:	8b 55 14             	mov    0x14(%ebp),%edx
  80118d:	89 0a                	mov    %ecx,(%edx)
  80118f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801196:	8b 45 10             	mov    0x10(%ebp),%eax
  801199:	01 c2                	add    %eax,%edx
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a0:	eb 03                	jmp    8011a5 <strsplit+0x8f>
			string++;
  8011a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	84 c0                	test   %al,%al
  8011ac:	74 8b                	je     801139 <strsplit+0x23>
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	0f be c0             	movsbl %al,%eax
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	e8 b5 fa ff ff       	call   800c74 <strchr>
  8011bf:	83 c4 08             	add    $0x8,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	74 dc                	je     8011a2 <strsplit+0x8c>
			string++;
	}
  8011c6:	e9 6e ff ff ff       	jmp    801139 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cf:	8b 00                	mov    (%eax),%eax
  8011d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8011f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f7:	eb 4c                	jmp    801245 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8011f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3c 40                	cmp    $0x40,%al
  801205:	7e 27                	jle    80122e <str2lower+0x44>
  801207:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	01 d0                	add    %edx,%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 19                	jg     80122e <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801215:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	01 d0                	add    %edx,%eax
  80121d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801220:	8b 55 0c             	mov    0xc(%ebp),%edx
  801223:	01 ca                	add    %ecx,%edx
  801225:	8a 12                	mov    (%edx),%dl
  801227:	83 c2 20             	add    $0x20,%edx
  80122a:	88 10                	mov    %dl,(%eax)
  80122c:	eb 14                	jmp    801242 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80122e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	01 c2                	add    %eax,%edx
  801236:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	01 c8                	add    %ecx,%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801242:	ff 45 fc             	incl   -0x4(%ebp)
  801245:	ff 75 0c             	pushl  0xc(%ebp)
  801248:	e8 95 f8 ff ff       	call   800ae2 <strlen>
  80124d:	83 c4 04             	add    $0x4,%esp
  801250:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801253:	7f a4                	jg     8011f9 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801255:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	57                   	push   %edi
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8b 55 0c             	mov    0xc(%ebp),%edx
  801274:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801277:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80127a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80127d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801280:	cd 30                	int    $0x30
  801282:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801285:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 04             	sub    $0x4,%esp
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80129c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	52                   	push   %edx
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	50                   	push   %eax
  8012ac:	6a 00                	push   $0x0
  8012ae:	e8 b2 ff ff ff       	call   801265 <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 01                	push   $0x1
  8012c8:	e8 98 ff ff ff       	call   801265 <syscall>
  8012cd:	83 c4 18             	add    $0x18,%esp
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	52                   	push   %edx
  8012e2:	50                   	push   %eax
  8012e3:	6a 05                	push   $0x5
  8012e5:	e8 7b ff ff ff       	call   801265 <syscall>
  8012ea:	83 c4 18             	add    $0x18,%esp
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	56                   	push   %esi
  801304:	53                   	push   %ebx
  801305:	51                   	push   %ecx
  801306:	52                   	push   %edx
  801307:	50                   	push   %eax
  801308:	6a 06                	push   $0x6
  80130a:	e8 56 ff ff ff       	call   801265 <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80131c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	52                   	push   %edx
  801329:	50                   	push   %eax
  80132a:	6a 07                	push   $0x7
  80132c:	e8 34 ff ff ff       	call   801265 <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	ff 75 0c             	pushl  0xc(%ebp)
  801342:	ff 75 08             	pushl  0x8(%ebp)
  801345:	6a 08                	push   $0x8
  801347:	e8 19 ff ff ff       	call   801265 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 09                	push   $0x9
  801360:	e8 00 ff ff ff       	call   801265 <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 0a                	push   $0xa
  801379:	e8 e7 fe ff ff       	call   801265 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 0b                	push   $0xb
  801392:	e8 ce fe ff ff       	call   801265 <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 0c                	push   $0xc
  8013ab:	e8 b5 fe ff ff       	call   801265 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	ff 75 08             	pushl  0x8(%ebp)
  8013c3:	6a 0d                	push   $0xd
  8013c5:	e8 9b fe ff ff       	call   801265 <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 0e                	push   $0xe
  8013de:	e8 82 fe ff ff       	call   801265 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 11                	push   $0x11
  8013f8:	e8 68 fe ff ff       	call   801265 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 12                	push   $0x12
  801412:	e8 4e fe ff ff       	call   801265 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
}
  80141a:	90                   	nop
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_cputc>:


void
sys_cputc(const char c)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801429:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	50                   	push   %eax
  801436:	6a 13                	push   $0x13
  801438:	e8 28 fe ff ff       	call   801265 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 14                	push   $0x14
  801452:	e8 0e fe ff ff       	call   801265 <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	50                   	push   %eax
  80146d:	6a 15                	push   $0x15
  80146f:	e8 f1 fd ff ff       	call   801265 <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80147c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	52                   	push   %edx
  801489:	50                   	push   %eax
  80148a:	6a 18                	push   $0x18
  80148c:	e8 d4 fd ff ff       	call   801265 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	52                   	push   %edx
  8014a6:	50                   	push   %eax
  8014a7:	6a 16                	push   $0x16
  8014a9:	e8 b7 fd ff ff       	call   801265 <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	52                   	push   %edx
  8014c4:	50                   	push   %eax
  8014c5:	6a 17                	push   $0x17
  8014c7:	e8 99 fd ff ff       	call   801265 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	51                   	push   %ecx
  8014eb:	52                   	push   %edx
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	50                   	push   %eax
  8014f0:	6a 19                	push   $0x19
  8014f2:	e8 6e fd ff ff       	call   801265 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	52                   	push   %edx
  80150c:	50                   	push   %eax
  80150d:	6a 1a                	push   $0x1a
  80150f:	e8 51 fd ff ff       	call   801265 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80151c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	51                   	push   %ecx
  80152a:	52                   	push   %edx
  80152b:	50                   	push   %eax
  80152c:	6a 1b                	push   $0x1b
  80152e:	e8 32 fd ff ff       	call   801265 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80153b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	6a 1c                	push   $0x1c
  80154b:	e8 15 fd ff ff       	call   801265 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 1d                	push   $0x1d
  801564:	e8 fc fc ff ff       	call   801265 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	ff 75 14             	pushl  0x14(%ebp)
  801579:	ff 75 10             	pushl  0x10(%ebp)
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	50                   	push   %eax
  801580:	6a 1e                	push   $0x1e
  801582:	e8 de fc ff ff       	call   801265 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	50                   	push   %eax
  80159b:	6a 1f                	push   $0x1f
  80159d:	e8 c3 fc ff ff       	call   801265 <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	90                   	nop
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	50                   	push   %eax
  8015b7:	6a 20                	push   $0x20
  8015b9:	e8 a7 fc ff ff       	call   801265 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 02                	push   $0x2
  8015d2:	e8 8e fc ff ff       	call   801265 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 03                	push   $0x3
  8015eb:	e8 75 fc ff ff       	call   801265 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 04                	push   $0x4
  801604:	e8 5c fc ff ff       	call   801265 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_exit_env>:


void sys_exit_env(void)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 21                	push   $0x21
  80161d:	e8 43 fc ff ff       	call   801265 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80162e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801631:	8d 50 04             	lea    0x4(%eax),%edx
  801634:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	52                   	push   %edx
  80163e:	50                   	push   %eax
  80163f:	6a 22                	push   $0x22
  801641:	e8 1f fc ff ff       	call   801265 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return result;
  801649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801652:	89 01                	mov    %eax,(%ecx)
  801654:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	c9                   	leave  
  80165b:	c2 04 00             	ret    $0x4

0080165e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	ff 75 10             	pushl  0x10(%ebp)
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	6a 10                	push   $0x10
  801670:	e8 f0 fb ff ff       	call   801265 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
	return ;
  801678:	90                   	nop
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_rcr2>:
uint32 sys_rcr2()
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 23                	push   $0x23
  80168a:	e8 d6 fb ff ff       	call   801265 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	50                   	push   %eax
  8016ad:	6a 24                	push   $0x24
  8016af:	e8 b1 fb ff ff       	call   801265 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b7:	90                   	nop
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <rsttst>:
void rsttst()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 26                	push   $0x26
  8016c9:	e8 97 fb ff ff       	call   801265 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d1:	90                   	nop
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e7:	52                   	push   %edx
  8016e8:	50                   	push   %eax
  8016e9:	ff 75 10             	pushl  0x10(%ebp)
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	6a 25                	push   $0x25
  8016f4:	e8 6c fb ff ff       	call   801265 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fc:	90                   	nop
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <chktst>:
void chktst(uint32 n)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	6a 27                	push   $0x27
  80170f:	e8 51 fb ff ff       	call   801265 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
	return ;
  801717:	90                   	nop
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <inctst>:

void inctst()
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 28                	push   $0x28
  801729:	e8 37 fb ff ff       	call   801265 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
	return ;
  801731:	90                   	nop
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <gettst>:
uint32 gettst()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 29                	push   $0x29
  801743:	e8 1d fb ff ff       	call   801265 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 2a                	push   $0x2a
  80175f:	e8 01 fb ff ff       	call   801265 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
  801767:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80176a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80176e:	75 07                	jne    801777 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801770:	b8 01 00 00 00       	mov    $0x1,%eax
  801775:	eb 05                	jmp    80177c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 2a                	push   $0x2a
  801790:	e8 d0 fa ff ff       	call   801265 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
  801798:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80179b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80179f:	75 07                	jne    8017a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a6:	eb 05                	jmp    8017ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 2a                	push   $0x2a
  8017c1:	e8 9f fa ff ff       	call   801265 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
  8017c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017d0:	75 07                	jne    8017d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d7:	eb 05                	jmp    8017de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 2a                	push   $0x2a
  8017f2:	e8 6e fa ff ff       	call   801265 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
  8017fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801801:	75 07                	jne    80180a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801803:	b8 01 00 00 00       	mov    $0x1,%eax
  801808:	eb 05                	jmp    80180f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	6a 2b                	push   $0x2b
  801821:	e8 3f fa ff ff       	call   801265 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
	return ;
  801829:	90                   	nop
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801830:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801833:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	53                   	push   %ebx
  80183f:	51                   	push   %ecx
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 2c                	push   $0x2c
  801844:	e8 1c fa ff ff       	call   801265 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 2d                	push   $0x2d
  801864:	e8 fc f9 ff ff       	call   801265 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801871:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801874:	8b 55 0c             	mov    0xc(%ebp),%edx
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	51                   	push   %ecx
  80187d:	ff 75 10             	pushl  0x10(%ebp)
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 2e                	push   $0x2e
  801884:	e8 dc f9 ff ff       	call   801265 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	ff 75 10             	pushl  0x10(%ebp)
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	6a 0f                	push   $0xf
  8018a0:	e8 c0 f9 ff ff       	call   801265 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a8:	90                   	nop
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	50                   	push   %eax
  8018ba:	6a 2f                	push   $0x2f
  8018bc:	e8 a4 f9 ff ff       	call   801265 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp

}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 30                	push   $0x30
  8018d7:	e8 89 f9 ff ff       	call   801265 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp

}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	ff 75 08             	pushl  0x8(%ebp)
  8018f1:	6a 31                	push   $0x31
  8018f3:	e8 6d f9 ff ff       	call   801265 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp

}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_hard_limit>:
uint32 sys_hard_limit(){
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 32                	push   $0x32
  80190d:	e8 53 f9 ff ff       	call   801265 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    
  801917:	90                   	nop

00801918 <__udivdi3>:
  801918:	55                   	push   %ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 1c             	sub    $0x1c,%esp
  80191f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801923:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80192b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192f:	89 ca                	mov    %ecx,%edx
  801931:	89 f8                	mov    %edi,%eax
  801933:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801937:	85 f6                	test   %esi,%esi
  801939:	75 2d                	jne    801968 <__udivdi3+0x50>
  80193b:	39 cf                	cmp    %ecx,%edi
  80193d:	77 65                	ja     8019a4 <__udivdi3+0x8c>
  80193f:	89 fd                	mov    %edi,%ebp
  801941:	85 ff                	test   %edi,%edi
  801943:	75 0b                	jne    801950 <__udivdi3+0x38>
  801945:	b8 01 00 00 00       	mov    $0x1,%eax
  80194a:	31 d2                	xor    %edx,%edx
  80194c:	f7 f7                	div    %edi
  80194e:	89 c5                	mov    %eax,%ebp
  801950:	31 d2                	xor    %edx,%edx
  801952:	89 c8                	mov    %ecx,%eax
  801954:	f7 f5                	div    %ebp
  801956:	89 c1                	mov    %eax,%ecx
  801958:	89 d8                	mov    %ebx,%eax
  80195a:	f7 f5                	div    %ebp
  80195c:	89 cf                	mov    %ecx,%edi
  80195e:	89 fa                	mov    %edi,%edx
  801960:	83 c4 1c             	add    $0x1c,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
  801968:	39 ce                	cmp    %ecx,%esi
  80196a:	77 28                	ja     801994 <__udivdi3+0x7c>
  80196c:	0f bd fe             	bsr    %esi,%edi
  80196f:	83 f7 1f             	xor    $0x1f,%edi
  801972:	75 40                	jne    8019b4 <__udivdi3+0x9c>
  801974:	39 ce                	cmp    %ecx,%esi
  801976:	72 0a                	jb     801982 <__udivdi3+0x6a>
  801978:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80197c:	0f 87 9e 00 00 00    	ja     801a20 <__udivdi3+0x108>
  801982:	b8 01 00 00 00       	mov    $0x1,%eax
  801987:	89 fa                	mov    %edi,%edx
  801989:	83 c4 1c             	add    $0x1c,%esp
  80198c:	5b                   	pop    %ebx
  80198d:	5e                   	pop    %esi
  80198e:	5f                   	pop    %edi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
  801991:	8d 76 00             	lea    0x0(%esi),%esi
  801994:	31 ff                	xor    %edi,%edi
  801996:	31 c0                	xor    %eax,%eax
  801998:	89 fa                	mov    %edi,%edx
  80199a:	83 c4 1c             	add    $0x1c,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5f                   	pop    %edi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    
  8019a2:	66 90                	xchg   %ax,%ax
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	f7 f7                	div    %edi
  8019a8:	31 ff                	xor    %edi,%edi
  8019aa:	89 fa                	mov    %edi,%edx
  8019ac:	83 c4 1c             	add    $0x1c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
  8019b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019b9:	89 eb                	mov    %ebp,%ebx
  8019bb:	29 fb                	sub    %edi,%ebx
  8019bd:	89 f9                	mov    %edi,%ecx
  8019bf:	d3 e6                	shl    %cl,%esi
  8019c1:	89 c5                	mov    %eax,%ebp
  8019c3:	88 d9                	mov    %bl,%cl
  8019c5:	d3 ed                	shr    %cl,%ebp
  8019c7:	89 e9                	mov    %ebp,%ecx
  8019c9:	09 f1                	or     %esi,%ecx
  8019cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019cf:	89 f9                	mov    %edi,%ecx
  8019d1:	d3 e0                	shl    %cl,%eax
  8019d3:	89 c5                	mov    %eax,%ebp
  8019d5:	89 d6                	mov    %edx,%esi
  8019d7:	88 d9                	mov    %bl,%cl
  8019d9:	d3 ee                	shr    %cl,%esi
  8019db:	89 f9                	mov    %edi,%ecx
  8019dd:	d3 e2                	shl    %cl,%edx
  8019df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e3:	88 d9                	mov    %bl,%cl
  8019e5:	d3 e8                	shr    %cl,%eax
  8019e7:	09 c2                	or     %eax,%edx
  8019e9:	89 d0                	mov    %edx,%eax
  8019eb:	89 f2                	mov    %esi,%edx
  8019ed:	f7 74 24 0c          	divl   0xc(%esp)
  8019f1:	89 d6                	mov    %edx,%esi
  8019f3:	89 c3                	mov    %eax,%ebx
  8019f5:	f7 e5                	mul    %ebp
  8019f7:	39 d6                	cmp    %edx,%esi
  8019f9:	72 19                	jb     801a14 <__udivdi3+0xfc>
  8019fb:	74 0b                	je     801a08 <__udivdi3+0xf0>
  8019fd:	89 d8                	mov    %ebx,%eax
  8019ff:	31 ff                	xor    %edi,%edi
  801a01:	e9 58 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a0c:	89 f9                	mov    %edi,%ecx
  801a0e:	d3 e2                	shl    %cl,%edx
  801a10:	39 c2                	cmp    %eax,%edx
  801a12:	73 e9                	jae    8019fd <__udivdi3+0xe5>
  801a14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a17:	31 ff                	xor    %edi,%edi
  801a19:	e9 40 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	31 c0                	xor    %eax,%eax
  801a22:	e9 37 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a27:	90                   	nop

00801a28 <__umoddi3>:
  801a28:	55                   	push   %ebp
  801a29:	57                   	push   %edi
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 1c             	sub    $0x1c,%esp
  801a2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a47:	89 f3                	mov    %esi,%ebx
  801a49:	89 fa                	mov    %edi,%edx
  801a4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a4f:	89 34 24             	mov    %esi,(%esp)
  801a52:	85 c0                	test   %eax,%eax
  801a54:	75 1a                	jne    801a70 <__umoddi3+0x48>
  801a56:	39 f7                	cmp    %esi,%edi
  801a58:	0f 86 a2 00 00 00    	jbe    801b00 <__umoddi3+0xd8>
  801a5e:	89 c8                	mov    %ecx,%eax
  801a60:	89 f2                	mov    %esi,%edx
  801a62:	f7 f7                	div    %edi
  801a64:	89 d0                	mov    %edx,%eax
  801a66:	31 d2                	xor    %edx,%edx
  801a68:	83 c4 1c             	add    $0x1c,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
  801a70:	39 f0                	cmp    %esi,%eax
  801a72:	0f 87 ac 00 00 00    	ja     801b24 <__umoddi3+0xfc>
  801a78:	0f bd e8             	bsr    %eax,%ebp
  801a7b:	83 f5 1f             	xor    $0x1f,%ebp
  801a7e:	0f 84 ac 00 00 00    	je     801b30 <__umoddi3+0x108>
  801a84:	bf 20 00 00 00       	mov    $0x20,%edi
  801a89:	29 ef                	sub    %ebp,%edi
  801a8b:	89 fe                	mov    %edi,%esi
  801a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a91:	89 e9                	mov    %ebp,%ecx
  801a93:	d3 e0                	shl    %cl,%eax
  801a95:	89 d7                	mov    %edx,%edi
  801a97:	89 f1                	mov    %esi,%ecx
  801a99:	d3 ef                	shr    %cl,%edi
  801a9b:	09 c7                	or     %eax,%edi
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 e2                	shl    %cl,%edx
  801aa1:	89 14 24             	mov    %edx,(%esp)
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	d3 e0                	shl    %cl,%eax
  801aa8:	89 c2                	mov    %eax,%edx
  801aaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aae:	d3 e0                	shl    %cl,%eax
  801ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab8:	89 f1                	mov    %esi,%ecx
  801aba:	d3 e8                	shr    %cl,%eax
  801abc:	09 d0                	or     %edx,%eax
  801abe:	d3 eb                	shr    %cl,%ebx
  801ac0:	89 da                	mov    %ebx,%edx
  801ac2:	f7 f7                	div    %edi
  801ac4:	89 d3                	mov    %edx,%ebx
  801ac6:	f7 24 24             	mull   (%esp)
  801ac9:	89 c6                	mov    %eax,%esi
  801acb:	89 d1                	mov    %edx,%ecx
  801acd:	39 d3                	cmp    %edx,%ebx
  801acf:	0f 82 87 00 00 00    	jb     801b5c <__umoddi3+0x134>
  801ad5:	0f 84 91 00 00 00    	je     801b6c <__umoddi3+0x144>
  801adb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801adf:	29 f2                	sub    %esi,%edx
  801ae1:	19 cb                	sbb    %ecx,%ebx
  801ae3:	89 d8                	mov    %ebx,%eax
  801ae5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ae9:	d3 e0                	shl    %cl,%eax
  801aeb:	89 e9                	mov    %ebp,%ecx
  801aed:	d3 ea                	shr    %cl,%edx
  801aef:	09 d0                	or     %edx,%eax
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 eb                	shr    %cl,%ebx
  801af5:	89 da                	mov    %ebx,%edx
  801af7:	83 c4 1c             	add    $0x1c,%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5f                   	pop    %edi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
  801aff:	90                   	nop
  801b00:	89 fd                	mov    %edi,%ebp
  801b02:	85 ff                	test   %edi,%edi
  801b04:	75 0b                	jne    801b11 <__umoddi3+0xe9>
  801b06:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0b:	31 d2                	xor    %edx,%edx
  801b0d:	f7 f7                	div    %edi
  801b0f:	89 c5                	mov    %eax,%ebp
  801b11:	89 f0                	mov    %esi,%eax
  801b13:	31 d2                	xor    %edx,%edx
  801b15:	f7 f5                	div    %ebp
  801b17:	89 c8                	mov    %ecx,%eax
  801b19:	f7 f5                	div    %ebp
  801b1b:	89 d0                	mov    %edx,%eax
  801b1d:	e9 44 ff ff ff       	jmp    801a66 <__umoddi3+0x3e>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	89 c8                	mov    %ecx,%eax
  801b26:	89 f2                	mov    %esi,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	3b 04 24             	cmp    (%esp),%eax
  801b33:	72 06                	jb     801b3b <__umoddi3+0x113>
  801b35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b39:	77 0f                	ja     801b4a <__umoddi3+0x122>
  801b3b:	89 f2                	mov    %esi,%edx
  801b3d:	29 f9                	sub    %edi,%ecx
  801b3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b43:	89 14 24             	mov    %edx,(%esp)
  801b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b4e:	8b 14 24             	mov    (%esp),%edx
  801b51:	83 c4 1c             	add    $0x1c,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
  801b59:	8d 76 00             	lea    0x0(%esi),%esi
  801b5c:	2b 04 24             	sub    (%esp),%eax
  801b5f:	19 fa                	sbb    %edi,%edx
  801b61:	89 d1                	mov    %edx,%ecx
  801b63:	89 c6                	mov    %eax,%esi
  801b65:	e9 71 ff ff ff       	jmp    801adb <__umoddi3+0xb3>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b70:	72 ea                	jb     801b5c <__umoddi3+0x134>
  801b72:	89 d9                	mov    %ebx,%ecx
  801b74:	e9 62 ff ff ff       	jmp    801adb <__umoddi3+0xb3>
