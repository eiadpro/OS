
obj/user/tst_invalid_access_slave1:     file format elf32-i386


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
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[1] Kernel address
	uint32 *ptr = (uint32*)(KERNEL_STACK_TOP - 12) ;
  80003e:	c7 45 f4 f4 ff bf ef 	movl   $0xefbffff4,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 c2 16 00 00       	call   801715 <inctst>
	panic("tst invalid access failed:Attempt to access kernel location.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 80 1b 80 00       	push   $0x801b80
  80005b:	6a 0e                	push   $0xe
  80005d:	68 f0 1b 80 00       	push   $0x801bf0
  800062:	e8 37 01 00 00       	call   80019e <_panic>

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
  80006d:	e8 65 15 00 00       	call   8015d7 <sys_getenvindex>
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
  800094:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8a 40 5c             	mov    0x5c(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0d                	je     8000b2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000aa:	83 c0 5c             	add    $0x5c,%eax
  8000ad:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b6:	7e 0a                	jle    8000c2 <libmain+0x5b>
		binaryname = argv[0];
  8000b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 68 ff ff ff       	call   800038 <_main>
  8000d0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d3:	e8 0c 13 00 00       	call   8013e4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 2c 1c 80 00       	push   $0x801c2c
  8000e0:	e8 76 03 00 00       	call   80045b <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ed:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f8:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	52                   	push   %edx
  800102:	50                   	push   %eax
  800103:	68 54 1c 80 00       	push   $0x801c54
  800108:	e8 4e 03 00 00       	call   80045b <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80011b:	a1 20 30 80 00       	mov    0x803020,%eax
  800120:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800131:	51                   	push   %ecx
  800132:	52                   	push   %edx
  800133:	50                   	push   %eax
  800134:	68 7c 1c 80 00       	push   $0x801c7c
  800139:	e8 1d 03 00 00       	call   80045b <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800141:	a1 20 30 80 00       	mov    0x803020,%eax
  800146:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	68 d4 1c 80 00       	push   $0x801cd4
  800155:	e8 01 03 00 00       	call   80045b <cprintf>
  80015a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 2c 1c 80 00       	push   $0x801c2c
  800165:	e8 f1 02 00 00       	call   80045b <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80016d:	e8 8c 12 00 00       	call   8013fe <sys_enable_interrupt>

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
  800185:	e8 19 14 00 00       	call   8015a3 <sys_destroy_env>
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
  800196:	e8 6e 14 00 00       	call   801609 <sys_exit_env>
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a7:	83 c0 04             	add    $0x4,%eax
  8001aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001ad:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	74 16                	je     8001cc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b6:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	50                   	push   %eax
  8001bf:	68 e8 1c 80 00       	push   $0x801ce8
  8001c4:	e8 92 02 00 00       	call   80045b <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001cc:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	50                   	push   %eax
  8001d8:	68 ed 1c 80 00       	push   $0x801ced
  8001dd:	e8 79 02 00 00       	call   80045b <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ee:	50                   	push   %eax
  8001ef:	e8 fc 01 00 00       	call   8003f0 <vcprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	6a 00                	push   $0x0
  8001fc:	68 09 1d 80 00       	push   $0x801d09
  800201:	e8 ea 01 00 00       	call   8003f0 <vcprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800209:	e8 82 ff ff ff       	call   800190 <exit>

	// should not return here
	while (1) ;
  80020e:	eb fe                	jmp    80020e <_panic+0x70>

00800210 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800216:	a1 20 30 80 00       	mov    0x803020,%eax
  80021b:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	39 c2                	cmp    %eax,%edx
  800226:	74 14                	je     80023c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	68 0c 1d 80 00       	push   $0x801d0c
  800230:	6a 26                	push   $0x26
  800232:	68 58 1d 80 00       	push   $0x801d58
  800237:	e8 62 ff ff ff       	call   80019e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800243:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024a:	e9 c5 00 00 00       	jmp    800314 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80024f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800259:	8b 45 08             	mov    0x8(%ebp),%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8b 00                	mov    (%eax),%eax
  800260:	85 c0                	test   %eax,%eax
  800262:	75 08                	jne    80026c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800264:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800267:	e9 a5 00 00 00       	jmp    800311 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800273:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027a:	eb 69                	jmp    8002e5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027c:	a1 20 30 80 00       	mov    0x803020,%eax
  800281:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800287:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028a:	89 d0                	mov    %edx,%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	01 d0                	add    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 c8                	add    %ecx,%eax
  800295:	8a 40 04             	mov    0x4(%eax),%al
  800298:	84 c0                	test   %al,%al
  80029a:	75 46                	jne    8002e2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029c:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a1:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002aa:	89 d0                	mov    %edx,%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	01 d0                	add    %edx,%eax
  8002b0:	c1 e0 03             	shl    $0x3,%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	01 c8                	add    %ecx,%eax
  8002d3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d5:	39 c2                	cmp    %eax,%edx
  8002d7:	75 09                	jne    8002e2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e0:	eb 15                	jmp    8002f7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e2:	ff 45 e8             	incl   -0x18(%ebp)
  8002e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ea:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8002f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f3:	39 c2                	cmp    %eax,%edx
  8002f5:	77 85                	ja     80027c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fb:	75 14                	jne    800311 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 64 1d 80 00       	push   $0x801d64
  800305:	6a 3a                	push   $0x3a
  800307:	68 58 1d 80 00       	push   $0x801d58
  80030c:	e8 8d fe ff ff       	call   80019e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800311:	ff 45 f0             	incl   -0x10(%ebp)
  800314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800317:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031a:	0f 8c 2f ff ff ff    	jl     80024f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800320:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800327:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80032e:	eb 26                	jmp    800356 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800330:	a1 20 30 80 00       	mov    0x803020,%eax
  800335:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80033b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033e:	89 d0                	mov    %edx,%eax
  800340:	01 c0                	add    %eax,%eax
  800342:	01 d0                	add    %edx,%eax
  800344:	c1 e0 03             	shl    $0x3,%eax
  800347:	01 c8                	add    %ecx,%eax
  800349:	8a 40 04             	mov    0x4(%eax),%al
  80034c:	3c 01                	cmp    $0x1,%al
  80034e:	75 03                	jne    800353 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800350:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800353:	ff 45 e0             	incl   -0x20(%ebp)
  800356:	a1 20 30 80 00       	mov    0x803020,%eax
  80035b:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	77 c8                	ja     800330 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80036e:	74 14                	je     800384 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 b8 1d 80 00       	push   $0x801db8
  800378:	6a 44                	push   $0x44
  80037a:	68 58 1d 80 00       	push   $0x801d58
  80037f:	e8 1a fe ff ff       	call   80019e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800384:	90                   	nop
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	8d 48 01             	lea    0x1(%eax),%ecx
  800395:	8b 55 0c             	mov    0xc(%ebp),%edx
  800398:	89 0a                	mov    %ecx,(%edx)
  80039a:	8b 55 08             	mov    0x8(%ebp),%edx
  80039d:	88 d1                	mov    %dl,%cl
  80039f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b0:	75 2c                	jne    8003de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b2:	a0 24 30 80 00       	mov    0x803024,%al
  8003b7:	0f b6 c0             	movzbl %al,%eax
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	8b 12                	mov    (%edx),%edx
  8003bf:	89 d1                	mov    %edx,%ecx
  8003c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c4:	83 c2 08             	add    $0x8,%edx
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	50                   	push   %eax
  8003cb:	51                   	push   %ecx
  8003cc:	52                   	push   %edx
  8003cd:	e8 b9 0e 00 00       	call   80128b <sys_cputs>
  8003d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e1:	8b 40 04             	mov    0x4(%eax),%eax
  8003e4:	8d 50 01             	lea    0x1(%eax),%edx
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800400:	00 00 00 
	b.cnt = 0;
  800403:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040d:	ff 75 0c             	pushl  0xc(%ebp)
  800410:	ff 75 08             	pushl  0x8(%ebp)
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	68 87 03 80 00       	push   $0x800387
  80041f:	e8 11 02 00 00       	call   800635 <vprintfmt>
  800424:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800427:	a0 24 30 80 00       	mov    0x803024,%al
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	50                   	push   %eax
  800439:	52                   	push   %edx
  80043a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800440:	83 c0 08             	add    $0x8,%eax
  800443:	50                   	push   %eax
  800444:	e8 42 0e 00 00       	call   80128b <sys_cputs>
  800449:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044c:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800453:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800459:	c9                   	leave  
  80045a:	c3                   	ret    

0080045b <cprintf>:

int cprintf(const char *fmt, ...) {
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800461:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800468:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	ff 75 f4             	pushl  -0xc(%ebp)
  800477:	50                   	push   %eax
  800478:	e8 73 ff ff ff       	call   8003f0 <vcprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800483:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800486:	c9                   	leave  
  800487:	c3                   	ret    

00800488 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048e:	e8 51 0f 00 00       	call   8013e4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800493:	8d 45 0c             	lea    0xc(%ebp),%eax
  800496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 48 ff ff ff       	call   8003f0 <vcprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ae:	e8 4b 0f 00 00       	call   8013fe <sys_enable_interrupt>
	return cnt;
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	53                   	push   %ebx
  8004bc:	83 ec 14             	sub    $0x14,%esp
  8004bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d6:	77 55                	ja     80052d <printnum+0x75>
  8004d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004db:	72 05                	jb     8004e2 <printnum+0x2a>
  8004dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e0:	77 4b                	ja     80052d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8004eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f0:	52                   	push   %edx
  8004f1:	50                   	push   %eax
  8004f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f8:	e8 17 14 00 00       	call   801914 <__udivdi3>
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	ff 75 20             	pushl  0x20(%ebp)
  800506:	53                   	push   %ebx
  800507:	ff 75 18             	pushl  0x18(%ebp)
  80050a:	52                   	push   %edx
  80050b:	50                   	push   %eax
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	e8 a1 ff ff ff       	call   8004b8 <printnum>
  800517:	83 c4 20             	add    $0x20,%esp
  80051a:	eb 1a                	jmp    800536 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	ff 75 0c             	pushl  0xc(%ebp)
  800522:	ff 75 20             	pushl  0x20(%ebp)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	ff d0                	call   *%eax
  80052a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052d:	ff 4d 1c             	decl   0x1c(%ebp)
  800530:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800534:	7f e6                	jg     80051c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800536:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800539:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800544:	53                   	push   %ebx
  800545:	51                   	push   %ecx
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	e8 d7 14 00 00       	call   801a24 <__umoddi3>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	05 34 20 80 00       	add    $0x802034,%eax
  800555:	8a 00                	mov    (%eax),%al
  800557:	0f be c0             	movsbl %al,%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 0c             	pushl  0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	ff d0                	call   *%eax
  800566:	83 c4 10             	add    $0x10,%esp
}
  800569:	90                   	nop
  80056a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800572:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800576:	7e 1c                	jle    800594 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	8d 50 08             	lea    0x8(%eax),%edx
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	89 10                	mov    %edx,(%eax)
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	83 e8 08             	sub    $0x8,%eax
  80058d:	8b 50 04             	mov    0x4(%eax),%edx
  800590:	8b 00                	mov    (%eax),%eax
  800592:	eb 40                	jmp    8005d4 <getuint+0x65>
	else if (lflag)
  800594:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800598:	74 1e                	je     8005b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	8d 50 04             	lea    0x4(%eax),%edx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	89 10                	mov    %edx,(%eax)
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	83 e8 04             	sub    $0x4,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b6:	eb 1c                	jmp    8005d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	8d 50 04             	lea    0x4(%eax),%edx
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	89 10                	mov    %edx,(%eax)
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dd:	7e 1c                	jle    8005fb <getint+0x25>
		return va_arg(*ap, long long);
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 08             	lea    0x8(%eax),%edx
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	83 e8 08             	sub    $0x8,%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	eb 38                	jmp    800633 <getint+0x5d>
	else if (lflag)
  8005fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ff:	74 1a                	je     80061b <getint+0x45>
		return va_arg(*ap, long);
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	89 10                	mov    %edx,(%eax)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	83 e8 04             	sub    $0x4,%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	99                   	cltd   
  800619:	eb 18                	jmp    800633 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	8d 50 04             	lea    0x4(%eax),%edx
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	89 10                	mov    %edx,(%eax)
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	83 e8 04             	sub    $0x4,%eax
  800630:	8b 00                	mov    (%eax),%eax
  800632:	99                   	cltd   
}
  800633:	5d                   	pop    %ebp
  800634:	c3                   	ret    

00800635 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	56                   	push   %esi
  800639:	53                   	push   %ebx
  80063a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063d:	eb 17                	jmp    800656 <vprintfmt+0x21>
			if (ch == '\0')
  80063f:	85 db                	test   %ebx,%ebx
  800641:	0f 84 af 03 00 00    	je     8009f6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	ff 75 0c             	pushl  0xc(%ebp)
  80064d:	53                   	push   %ebx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	ff d0                	call   *%eax
  800653:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	8d 50 01             	lea    0x1(%eax),%edx
  80065c:	89 55 10             	mov    %edx,0x10(%ebp)
  80065f:	8a 00                	mov    (%eax),%al
  800661:	0f b6 d8             	movzbl %al,%ebx
  800664:	83 fb 25             	cmp    $0x25,%ebx
  800667:	75 d6                	jne    80063f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800669:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800674:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800682:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	8d 50 01             	lea    0x1(%eax),%edx
  80068f:	89 55 10             	mov    %edx,0x10(%ebp)
  800692:	8a 00                	mov    (%eax),%al
  800694:	0f b6 d8             	movzbl %al,%ebx
  800697:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069a:	83 f8 55             	cmp    $0x55,%eax
  80069d:	0f 87 2b 03 00 00    	ja     8009ce <vprintfmt+0x399>
  8006a3:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b0:	eb d7                	jmp    800689 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b6:	eb d1                	jmp    800689 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c2:	89 d0                	mov    %edx,%eax
  8006c4:	c1 e0 02             	shl    $0x2,%eax
  8006c7:	01 d0                	add    %edx,%eax
  8006c9:	01 c0                	add    %eax,%eax
  8006cb:	01 d8                	add    %ebx,%eax
  8006cd:	83 e8 30             	sub    $0x30,%eax
  8006d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	8a 00                	mov    (%eax),%al
  8006d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006db:	83 fb 2f             	cmp    $0x2f,%ebx
  8006de:	7e 3e                	jle    80071e <vprintfmt+0xe9>
  8006e0:	83 fb 39             	cmp    $0x39,%ebx
  8006e3:	7f 39                	jg     80071e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e8:	eb d5                	jmp    8006bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 c0 04             	add    $0x4,%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fe:	eb 1f                	jmp    80071f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800704:	79 83                	jns    800689 <vprintfmt+0x54>
				width = 0;
  800706:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070d:	e9 77 ff ff ff       	jmp    800689 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800712:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800719:	e9 6b ff ff ff       	jmp    800689 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800723:	0f 89 60 ff ff ff    	jns    800689 <vprintfmt+0x54>
				width = precision, precision = -1;
  800729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800736:	e9 4e ff ff ff       	jmp    800689 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073e:	e9 46 ff ff ff       	jmp    800689 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 c0 04             	add    $0x4,%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	83 e8 04             	sub    $0x4,%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	50                   	push   %eax
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
			break;
  800763:	e9 89 02 00 00       	jmp    8009f1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 c0 04             	add    $0x4,%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	83 e8 04             	sub    $0x4,%eax
  800777:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800779:	85 db                	test   %ebx,%ebx
  80077b:	79 02                	jns    80077f <vprintfmt+0x14a>
				err = -err;
  80077d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077f:	83 fb 64             	cmp    $0x64,%ebx
  800782:	7f 0b                	jg     80078f <vprintfmt+0x15a>
  800784:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  80078b:	85 f6                	test   %esi,%esi
  80078d:	75 19                	jne    8007a8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078f:	53                   	push   %ebx
  800790:	68 45 20 80 00       	push   $0x802045
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	e8 5e 02 00 00       	call   8009fe <printfmt>
  8007a0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a3:	e9 49 02 00 00       	jmp    8009f1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a8:	56                   	push   %esi
  8007a9:	68 4e 20 80 00       	push   $0x80204e
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 45 02 00 00       	call   8009fe <printfmt>
  8007b9:	83 c4 10             	add    $0x10,%esp
			break;
  8007bc:	e9 30 02 00 00       	jmp    8009f1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 30                	mov    (%eax),%esi
  8007d2:	85 f6                	test   %esi,%esi
  8007d4:	75 05                	jne    8007db <vprintfmt+0x1a6>
				p = "(null)";
  8007d6:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	7e 6d                	jle    80084e <vprintfmt+0x219>
  8007e1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e5:	74 67                	je     80084e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	50                   	push   %eax
  8007ee:	56                   	push   %esi
  8007ef:	e8 0c 03 00 00       	call   800b00 <strnlen>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fa:	eb 16                	jmp    800812 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	50                   	push   %eax
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080f:	ff 4d e4             	decl   -0x1c(%ebp)
  800812:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800816:	7f e4                	jg     8007fc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800818:	eb 34                	jmp    80084e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081e:	74 1c                	je     80083c <vprintfmt+0x207>
  800820:	83 fb 1f             	cmp    $0x1f,%ebx
  800823:	7e 05                	jle    80082a <vprintfmt+0x1f5>
  800825:	83 fb 7e             	cmp    $0x7e,%ebx
  800828:	7e 12                	jle    80083c <vprintfmt+0x207>
					putch('?', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	6a 3f                	push   $0x3f
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	eb 0f                	jmp    80084b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	53                   	push   %ebx
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084b:	ff 4d e4             	decl   -0x1c(%ebp)
  80084e:	89 f0                	mov    %esi,%eax
  800850:	8d 70 01             	lea    0x1(%eax),%esi
  800853:	8a 00                	mov    (%eax),%al
  800855:	0f be d8             	movsbl %al,%ebx
  800858:	85 db                	test   %ebx,%ebx
  80085a:	74 24                	je     800880 <vprintfmt+0x24b>
  80085c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800860:	78 b8                	js     80081a <vprintfmt+0x1e5>
  800862:	ff 4d e0             	decl   -0x20(%ebp)
  800865:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800869:	79 af                	jns    80081a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086b:	eb 13                	jmp    800880 <vprintfmt+0x24b>
				putch(' ', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 20                	push   $0x20
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087d:	ff 4d e4             	decl   -0x1c(%ebp)
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	7f e7                	jg     80086d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800886:	e9 66 01 00 00       	jmp    8009f1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 e8             	pushl  -0x18(%ebp)
  800891:	8d 45 14             	lea    0x14(%ebp),%eax
  800894:	50                   	push   %eax
  800895:	e8 3c fd ff ff       	call   8005d6 <getint>
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	79 23                	jns    8008d0 <vprintfmt+0x29b>
				putch('-', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	6a 2d                	push   $0x2d
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c3:	f7 d8                	neg    %eax
  8008c5:	83 d2 00             	adc    $0x0,%edx
  8008c8:	f7 da                	neg    %edx
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d7:	e9 bc 00 00 00       	jmp    800998 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e5:	50                   	push   %eax
  8008e6:	e8 84 fc ff ff       	call   80056f <getuint>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fb:	e9 98 00 00 00       	jmp    800998 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	6a 58                	push   $0x58
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	ff 75 0c             	pushl  0xc(%ebp)
  800916:	6a 58                	push   $0x58
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
  80091d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	6a 58                	push   $0x58
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
			break;
  800930:	e9 bc 00 00 00       	jmp    8009f1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 30                	push   $0x30
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 78                	push   $0x78
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 c0 04             	add    $0x4,%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 e8 04             	sub    $0x4,%eax
  800964:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800970:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800977:	eb 1f                	jmp    800998 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 e8             	pushl  -0x18(%ebp)
  80097f:	8d 45 14             	lea    0x14(%ebp),%eax
  800982:	50                   	push   %eax
  800983:	e8 e7 fb ff ff       	call   80056f <getuint>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800991:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800998:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099f:	83 ec 04             	sub    $0x4,%esp
  8009a2:	52                   	push   %edx
  8009a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 00 fb ff ff       	call   8004b8 <printnum>
  8009b8:	83 c4 20             	add    $0x20,%esp
			break;
  8009bb:	eb 34                	jmp    8009f1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	53                   	push   %ebx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
			break;
  8009cc:	eb 23                	jmp    8009f1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	6a 25                	push   $0x25
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	ff d0                	call   *%eax
  8009db:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009de:	ff 4d 10             	decl   0x10(%ebp)
  8009e1:	eb 03                	jmp    8009e6 <vprintfmt+0x3b1>
  8009e3:	ff 4d 10             	decl   0x10(%ebp)
  8009e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e9:	48                   	dec    %eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	3c 25                	cmp    $0x25,%al
  8009ee:	75 f3                	jne    8009e3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009f0:	90                   	nop
		}
	}
  8009f1:	e9 47 fc ff ff       	jmp    80063d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fa:	5b                   	pop    %ebx
  8009fb:	5e                   	pop    %esi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a04:	8d 45 10             	lea    0x10(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	ff 75 f4             	pushl  -0xc(%ebp)
  800a13:	50                   	push   %eax
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	e8 16 fc ff ff       	call   800635 <vprintfmt>
  800a1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a22:	90                   	nop
  800a23:	c9                   	leave  
  800a24:	c3                   	ret    

00800a25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8b 40 08             	mov    0x8(%eax),%eax
  800a2e:	8d 50 01             	lea    0x1(%eax),%edx
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	8b 10                	mov    (%eax),%edx
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8b 40 04             	mov    0x4(%eax),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	73 12                	jae    800a58 <sprintputch+0x33>
		*b->buf++ = ch;
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	8b 00                	mov    (%eax),%eax
  800a4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a51:	89 0a                	mov    %ecx,(%edx)
  800a53:	8b 55 08             	mov    0x8(%ebp),%edx
  800a56:	88 10                	mov    %dl,(%eax)
}
  800a58:	90                   	nop
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	01 d0                	add    %edx,%eax
  800a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a80:	74 06                	je     800a88 <vsnprintf+0x2d>
  800a82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a86:	7f 07                	jg     800a8f <vsnprintf+0x34>
		return -E_INVAL;
  800a88:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8d:	eb 20                	jmp    800aaf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8f:	ff 75 14             	pushl  0x14(%ebp)
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 25 0a 80 00       	push   $0x800a25
  800a9e:	e8 92 fb ff ff       	call   800635 <vprintfmt>
  800aa3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab7:	8d 45 10             	lea    0x10(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac6:	50                   	push   %eax
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 89 ff ff ff       	call   800a5b <vsnprintf>
  800ad2:	83 c4 10             	add    $0x10,%esp
  800ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aea:	eb 06                	jmp    800af2 <strlen+0x15>
		n++;
  800aec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aef:	ff 45 08             	incl   0x8(%ebp)
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	84 c0                	test   %al,%al
  800af9:	75 f1                	jne    800aec <strlen+0xf>
		n++;
	return n;
  800afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0d:	eb 09                	jmp    800b18 <strnlen+0x18>
		n++;
  800b0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b12:	ff 45 08             	incl   0x8(%ebp)
  800b15:	ff 4d 0c             	decl   0xc(%ebp)
  800b18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1c:	74 09                	je     800b27 <strnlen+0x27>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	75 e8                	jne    800b0f <strnlen+0xf>
		n++;
	return n;
  800b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b38:	90                   	nop
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8d 50 01             	lea    0x1(%eax),%edx
  800b3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4b:	8a 12                	mov    (%edx),%dl
  800b4d:	88 10                	mov    %dl,(%eax)
  800b4f:	8a 00                	mov    (%eax),%al
  800b51:	84 c0                	test   %al,%al
  800b53:	75 e4                	jne    800b39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b58:	c9                   	leave  
  800b59:	c3                   	ret    

00800b5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6d:	eb 1f                	jmp    800b8e <strncpy+0x34>
		*dst++ = *src;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8d 50 01             	lea    0x1(%eax),%edx
  800b75:	89 55 08             	mov    %edx,0x8(%ebp)
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	8a 12                	mov    (%edx),%dl
  800b7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	84 c0                	test   %al,%al
  800b86:	74 03                	je     800b8b <strncpy+0x31>
			src++;
  800b88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8b:	ff 45 fc             	incl   -0x4(%ebp)
  800b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b94:	72 d9                	jb     800b6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bab:	74 30                	je     800bdd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bad:	eb 16                	jmp    800bc5 <strlcpy+0x2a>
			*dst++ = *src++;
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8d 50 01             	lea    0x1(%eax),%edx
  800bb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc1:	8a 12                	mov    (%edx),%dl
  800bc3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc5:	ff 4d 10             	decl   0x10(%ebp)
  800bc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcc:	74 09                	je     800bd7 <strlcpy+0x3c>
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	84 c0                	test   %al,%al
  800bd5:	75 d8                	jne    800baf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be3:	29 c2                	sub    %eax,%edx
  800be5:	89 d0                	mov    %edx,%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bec:	eb 06                	jmp    800bf4 <strcmp+0xb>
		p++, q++;
  800bee:	ff 45 08             	incl   0x8(%ebp)
  800bf1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	84 c0                	test   %al,%al
  800bfb:	74 0e                	je     800c0b <strcmp+0x22>
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 10                	mov    (%eax),%dl
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	38 c2                	cmp    %al,%dl
  800c09:	74 e3                	je     800bee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	0f b6 d0             	movzbl %al,%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 c0             	movzbl %al,%eax
  800c1b:	29 c2                	sub    %eax,%edx
  800c1d:	89 d0                	mov    %edx,%eax
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c24:	eb 09                	jmp    800c2f <strncmp+0xe>
		n--, p++, q++;
  800c26:	ff 4d 10             	decl   0x10(%ebp)
  800c29:	ff 45 08             	incl   0x8(%ebp)
  800c2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c33:	74 17                	je     800c4c <strncmp+0x2b>
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	74 0e                	je     800c4c <strncmp+0x2b>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8a 10                	mov    (%eax),%dl
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	38 c2                	cmp    %al,%dl
  800c4a:	74 da                	je     800c26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c50:	75 07                	jne    800c59 <strncmp+0x38>
		return 0;
  800c52:	b8 00 00 00 00       	mov    $0x0,%eax
  800c57:	eb 14                	jmp    800c6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	0f b6 d0             	movzbl %al,%edx
  800c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	0f b6 c0             	movzbl %al,%eax
  800c69:	29 c2                	sub    %eax,%edx
  800c6b:	89 d0                	mov    %edx,%eax
}
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7b:	eb 12                	jmp    800c8f <strchr+0x20>
		if (*s == c)
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c85:	75 05                	jne    800c8c <strchr+0x1d>
			return (char *) s;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	eb 11                	jmp    800c9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8c:	ff 45 08             	incl   0x8(%ebp)
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	84 c0                	test   %al,%al
  800c96:	75 e5                	jne    800c7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 04             	sub    $0x4,%esp
  800ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cab:	eb 0d                	jmp    800cba <strfind+0x1b>
		if (*s == c)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb5:	74 0e                	je     800cc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 ea                	jne    800cad <strfind+0xe>
  800cc3:	eb 01                	jmp    800cc6 <strfind+0x27>
		if (*s == c)
			break;
  800cc5:	90                   	nop
	return (char *) s;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdd:	eb 0e                	jmp    800ced <memset+0x22>
		*p++ = c;
  800cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce2:	8d 50 01             	lea    0x1(%eax),%edx
  800ce5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ceb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ced:	ff 4d f8             	decl   -0x8(%ebp)
  800cf0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf4:	79 e9                	jns    800cdf <memset+0x14>
		*p++ = c;

	return v;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0d:	eb 16                	jmp    800d25 <memcpy+0x2a>
		*d++ = *s++;
  800d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d12:	8d 50 01             	lea    0x1(%eax),%edx
  800d15:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d21:	8a 12                	mov    (%edx),%dl
  800d23:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	75 dd                	jne    800d0f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4f:	73 50                	jae    800da1 <memmove+0x6a>
  800d51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	01 d0                	add    %edx,%eax
  800d59:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5c:	76 43                	jbe    800da1 <memmove+0x6a>
		s += n;
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d64:	8b 45 10             	mov    0x10(%ebp),%eax
  800d67:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d6a:	eb 10                	jmp    800d7c <memmove+0x45>
			*--d = *--s;
  800d6c:	ff 4d f8             	decl   -0x8(%ebp)
  800d6f:	ff 4d fc             	decl   -0x4(%ebp)
  800d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d75:	8a 10                	mov    (%eax),%dl
  800d77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d82:	89 55 10             	mov    %edx,0x10(%ebp)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	75 e3                	jne    800d6c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d89:	eb 23                	jmp    800dae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8e:	8d 50 01             	lea    0x1(%eax),%edx
  800d91:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9d:	8a 12                	mov    (%edx),%dl
  800d9f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da7:	89 55 10             	mov    %edx,0x10(%ebp)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	75 dd                	jne    800d8b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc5:	eb 2a                	jmp    800df1 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	8a 10                	mov    (%eax),%dl
  800dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	38 c2                	cmp    %al,%dl
  800dd3:	74 16                	je     800deb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	0f b6 d0             	movzbl %al,%edx
  800ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 c0             	movzbl %al,%eax
  800de5:	29 c2                	sub    %eax,%edx
  800de7:	89 d0                	mov    %edx,%eax
  800de9:	eb 18                	jmp    800e03 <memcmp+0x50>
		s1++, s2++;
  800deb:	ff 45 fc             	incl   -0x4(%ebp)
  800dee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df1:	8b 45 10             	mov    0x10(%ebp),%eax
  800df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	75 c9                	jne    800dc7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	01 d0                	add    %edx,%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e16:	eb 15                	jmp    800e2d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f b6 d0             	movzbl %al,%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	0f b6 c0             	movzbl %al,%eax
  800e26:	39 c2                	cmp    %eax,%edx
  800e28:	74 0d                	je     800e37 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e33:	72 e3                	jb     800e18 <memfind+0x13>
  800e35:	eb 01                	jmp    800e38 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e37:	90                   	nop
	return (void *) s;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e51:	eb 03                	jmp    800e56 <strtol+0x19>
		s++;
  800e53:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3c 20                	cmp    $0x20,%al
  800e5d:	74 f4                	je     800e53 <strtol+0x16>
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 09                	cmp    $0x9,%al
  800e66:	74 eb                	je     800e53 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 2b                	cmp    $0x2b,%al
  800e6f:	75 05                	jne    800e76 <strtol+0x39>
		s++;
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	eb 13                	jmp    800e89 <strtol+0x4c>
	else if (*s == '-')
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3c 2d                	cmp    $0x2d,%al
  800e7d:	75 0a                	jne    800e89 <strtol+0x4c>
		s++, neg = 1;
  800e7f:	ff 45 08             	incl   0x8(%ebp)
  800e82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 06                	je     800e95 <strtol+0x58>
  800e8f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e93:	75 20                	jne    800eb5 <strtol+0x78>
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	3c 30                	cmp    $0x30,%al
  800e9c:	75 17                	jne    800eb5 <strtol+0x78>
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	40                   	inc    %eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	3c 78                	cmp    $0x78,%al
  800ea6:	75 0d                	jne    800eb5 <strtol+0x78>
		s += 2, base = 16;
  800ea8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb3:	eb 28                	jmp    800edd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb9:	75 15                	jne    800ed0 <strtol+0x93>
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	3c 30                	cmp    $0x30,%al
  800ec2:	75 0c                	jne    800ed0 <strtol+0x93>
		s++, base = 8;
  800ec4:	ff 45 08             	incl   0x8(%ebp)
  800ec7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ece:	eb 0d                	jmp    800edd <strtol+0xa0>
	else if (base == 0)
  800ed0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed4:	75 07                	jne    800edd <strtol+0xa0>
		base = 10;
  800ed6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3c 2f                	cmp    $0x2f,%al
  800ee4:	7e 19                	jle    800eff <strtol+0xc2>
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 39                	cmp    $0x39,%al
  800eed:	7f 10                	jg     800eff <strtol+0xc2>
			dig = *s - '0';
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f be c0             	movsbl %al,%eax
  800ef7:	83 e8 30             	sub    $0x30,%eax
  800efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efd:	eb 42                	jmp    800f41 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	3c 60                	cmp    $0x60,%al
  800f06:	7e 19                	jle    800f21 <strtol+0xe4>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 7a                	cmp    $0x7a,%al
  800f0f:	7f 10                	jg     800f21 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f be c0             	movsbl %al,%eax
  800f19:	83 e8 57             	sub    $0x57,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1f:	eb 20                	jmp    800f41 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 40                	cmp    $0x40,%al
  800f28:	7e 39                	jle    800f63 <strtol+0x126>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 5a                	cmp    $0x5a,%al
  800f31:	7f 30                	jg     800f63 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	0f be c0             	movsbl %al,%eax
  800f3b:	83 e8 37             	sub    $0x37,%eax
  800f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f47:	7d 19                	jge    800f62 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5d:	e9 7b ff ff ff       	jmp    800edd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f62:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f67:	74 08                	je     800f71 <strtol+0x134>
		*endptr = (char *) s;
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f75:	74 07                	je     800f7e <strtol+0x141>
  800f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7a:	f7 d8                	neg    %eax
  800f7c:	eb 03                	jmp    800f81 <strtol+0x144>
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <ltostr>:

void
ltostr(long value, char *str)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f90:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9b:	79 13                	jns    800fb0 <ltostr+0x2d>
	{
		neg = 1;
  800f9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800faa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb8:	99                   	cltd   
  800fb9:	f7 f9                	idiv   %ecx
  800fbb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc1:	8d 50 01             	lea    0x1(%eax),%edx
  800fc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc7:	89 c2                	mov    %eax,%edx
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	01 d0                	add    %edx,%eax
  800fce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd1:	83 c2 30             	add    $0x30,%edx
  800fd4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fde:	f7 e9                	imul   %ecx
  800fe0:	c1 fa 02             	sar    $0x2,%edx
  800fe3:	89 c8                	mov    %ecx,%eax
  800fe5:	c1 f8 1f             	sar    $0x1f,%eax
  800fe8:	29 c2                	sub    %eax,%edx
  800fea:	89 d0                	mov    %edx,%eax
  800fec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff7:	f7 e9                	imul   %ecx
  800ff9:	c1 fa 02             	sar    $0x2,%edx
  800ffc:	89 c8                	mov    %ecx,%eax
  800ffe:	c1 f8 1f             	sar    $0x1f,%eax
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 d0                	mov    %edx,%eax
  801005:	c1 e0 02             	shl    $0x2,%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	01 c0                	add    %eax,%eax
  80100c:	29 c1                	sub    %eax,%ecx
  80100e:	89 ca                	mov    %ecx,%edx
  801010:	85 d2                	test   %edx,%edx
  801012:	75 9c                	jne    800fb0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	48                   	dec    %eax
  80101f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801022:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801026:	74 3d                	je     801065 <ltostr+0xe2>
		start = 1 ;
  801028:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102f:	eb 34                	jmp    801065 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801031:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 c2                	add    %eax,%edx
  801046:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	01 c8                	add    %ecx,%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	01 c2                	add    %eax,%edx
  80105a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105d:	88 02                	mov    %al,(%edx)
		start++ ;
  80105f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801062:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801068:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106b:	7c c4                	jl     801031 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	01 d0                	add    %edx,%eax
  801075:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801078:	90                   	nop
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801081:	ff 75 08             	pushl  0x8(%ebp)
  801084:	e8 54 fa ff ff       	call   800add <strlen>
  801089:	83 c4 04             	add    $0x4,%esp
  80108c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108f:	ff 75 0c             	pushl  0xc(%ebp)
  801092:	e8 46 fa ff ff       	call   800add <strlen>
  801097:	83 c4 04             	add    $0x4,%esp
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ab:	eb 17                	jmp    8010c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	01 c2                	add    %eax,%edx
  8010b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	01 c8                	add    %ecx,%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
  8010c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ca:	7c e1                	jl     8010ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010da:	eb 1f                	jmp    8010fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	8d 50 01             	lea    0x1(%eax),%edx
  8010e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e5:	89 c2                	mov    %eax,%edx
  8010e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ea:	01 c2                	add    %eax,%edx
  8010ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 c8                	add    %ecx,%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f8:	ff 45 f8             	incl   -0x8(%ebp)
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801101:	7c d9                	jl     8010dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801103:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	c6 00 00             	movb   $0x0,(%eax)
}
  80110e:	90                   	nop
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801114:	8b 45 14             	mov    0x14(%ebp),%eax
  801117:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111d:	8b 45 14             	mov    0x14(%ebp),%eax
  801120:	8b 00                	mov    (%eax),%eax
  801122:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	01 d0                	add    %edx,%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801134:	eb 0c                	jmp    801142 <strsplit+0x31>
			*string++ = 0;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 08             	mov    %edx,0x8(%ebp)
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	84 c0                	test   %al,%al
  801149:	74 18                	je     801163 <strsplit+0x52>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f be c0             	movsbl %al,%eax
  801153:	50                   	push   %eax
  801154:	ff 75 0c             	pushl  0xc(%ebp)
  801157:	e8 13 fb ff ff       	call   800c6f <strchr>
  80115c:	83 c4 08             	add    $0x8,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 d3                	jne    801136 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	84 c0                	test   %al,%al
  80116a:	74 5a                	je     8011c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116c:	8b 45 14             	mov    0x14(%ebp),%eax
  80116f:	8b 00                	mov    (%eax),%eax
  801171:	83 f8 0f             	cmp    $0xf,%eax
  801174:	75 07                	jne    80117d <strsplit+0x6c>
		{
			return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	eb 66                	jmp    8011e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117d:	8b 45 14             	mov    0x14(%ebp),%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	8d 48 01             	lea    0x1(%eax),%ecx
  801185:	8b 55 14             	mov    0x14(%ebp),%edx
  801188:	89 0a                	mov    %ecx,(%edx)
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 c2                	add    %eax,%edx
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119b:	eb 03                	jmp    8011a0 <strsplit+0x8f>
			string++;
  80119d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	84 c0                	test   %al,%al
  8011a7:	74 8b                	je     801134 <strsplit+0x23>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	e8 b5 fa ff ff       	call   800c6f <strchr>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	74 dc                	je     80119d <strsplit+0x8c>
			string++;
	}
  8011c1:	e9 6e ff ff ff       	jmp    801134 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ca:	8b 00                	mov    (%eax),%eax
  8011cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f2:	eb 4c                	jmp    801240 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8011f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 40                	cmp    $0x40,%al
  801200:	7e 27                	jle    801229 <str2lower+0x44>
  801202:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 d0                	add    %edx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3c 5a                	cmp    $0x5a,%al
  80120e:	7f 19                	jg     801229 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801210:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	01 d0                	add    %edx,%eax
  801218:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	01 ca                	add    %ecx,%edx
  801220:	8a 12                	mov    (%edx),%dl
  801222:	83 c2 20             	add    $0x20,%edx
  801225:	88 10                	mov    %dl,(%eax)
  801227:	eb 14                	jmp    80123d <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801229:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 c8                	add    %ecx,%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80123d:	ff 45 fc             	incl   -0x4(%ebp)
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	e8 95 f8 ff ff       	call   800add <strlen>
  801248:	83 c4 04             	add    $0x4,%esp
  80124b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124e:	7f a4                	jg     8011f4 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801250:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	57                   	push   %edi
  801264:	56                   	push   %esi
  801265:	53                   	push   %ebx
  801266:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801272:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801275:	8b 7d 18             	mov    0x18(%ebp),%edi
  801278:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80127b:	cd 30                	int    $0x30
  80127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	5b                   	pop    %ebx
  801287:	5e                   	pop    %esi
  801288:	5f                   	pop    %edi
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 04             	sub    $0x4,%esp
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801297:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	52                   	push   %edx
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	50                   	push   %eax
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 b2 ff ff ff       	call   801260 <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
}
  8012b1:	90                   	nop
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 01                	push   $0x1
  8012c3:	e8 98 ff ff ff       	call   801260 <syscall>
  8012c8:	83 c4 18             	add    $0x18,%esp
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	52                   	push   %edx
  8012dd:	50                   	push   %eax
  8012de:	6a 05                	push   $0x5
  8012e0:	e8 7b ff ff ff       	call   801260 <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	56                   	push   %esi
  8012ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	51                   	push   %ecx
  801301:	52                   	push   %edx
  801302:	50                   	push   %eax
  801303:	6a 06                	push   $0x6
  801305:	e8 56 ff ff ff       	call   801260 <syscall>
  80130a:	83 c4 18             	add    $0x18,%esp
}
  80130d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	52                   	push   %edx
  801324:	50                   	push   %eax
  801325:	6a 07                	push   $0x7
  801327:	e8 34 ff ff ff       	call   801260 <syscall>
  80132c:	83 c4 18             	add    $0x18,%esp
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	6a 08                	push   $0x8
  801342:	e8 19 ff ff ff       	call   801260 <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 09                	push   $0x9
  80135b:	e8 00 ff ff ff       	call   801260 <syscall>
  801360:	83 c4 18             	add    $0x18,%esp
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 0a                	push   $0xa
  801374:	e8 e7 fe ff ff       	call   801260 <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 0b                	push   $0xb
  80138d:	e8 ce fe ff ff       	call   801260 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 0c                	push   $0xc
  8013a6:	e8 b5 fe ff ff       	call   801260 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	ff 75 08             	pushl  0x8(%ebp)
  8013be:	6a 0d                	push   $0xd
  8013c0:	e8 9b fe ff ff       	call   801260 <syscall>
  8013c5:	83 c4 18             	add    $0x18,%esp
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 0e                	push   $0xe
  8013d9:	e8 82 fe ff ff       	call   801260 <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	90                   	nop
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 11                	push   $0x11
  8013f3:	e8 68 fe ff ff       	call   801260 <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
}
  8013fb:	90                   	nop
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 12                	push   $0x12
  80140d:	e8 4e fe ff ff       	call   801260 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	90                   	nop
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <sys_cputc>:


void
sys_cputc(const char c)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801424:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	50                   	push   %eax
  801431:	6a 13                	push   $0x13
  801433:	e8 28 fe ff ff       	call   801260 <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 14                	push   $0x14
  80144d:	e8 0e fe ff ff       	call   801260 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	50                   	push   %eax
  801468:	6a 15                	push   $0x15
  80146a:	e8 f1 fd ff ff       	call   801260 <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	52                   	push   %edx
  801484:	50                   	push   %eax
  801485:	6a 18                	push   $0x18
  801487:	e8 d4 fd ff ff       	call   801260 <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801494:	8b 55 0c             	mov    0xc(%ebp),%edx
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	52                   	push   %edx
  8014a1:	50                   	push   %eax
  8014a2:	6a 16                	push   $0x16
  8014a4:	e8 b7 fd ff ff       	call   801260 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	52                   	push   %edx
  8014bf:	50                   	push   %eax
  8014c0:	6a 17                	push   $0x17
  8014c2:	e8 99 fd ff ff       	call   801260 <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	90                   	nop
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	51                   	push   %ecx
  8014e6:	52                   	push   %edx
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	6a 19                	push   $0x19
  8014ed:	e8 6e fd ff ff       	call   801260 <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 1a                	push   $0x1a
  80150a:	e8 51 fd ff ff       	call   801260 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801517:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	51                   	push   %ecx
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 1b                	push   $0x1b
  801529:	e8 32 fd ff ff       	call   801260 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801536:	8b 55 0c             	mov    0xc(%ebp),%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	52                   	push   %edx
  801543:	50                   	push   %eax
  801544:	6a 1c                	push   $0x1c
  801546:	e8 15 fd ff ff       	call   801260 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 1d                	push   $0x1d
  80155f:	e8 fc fc ff ff       	call   801260 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	6a 00                	push   $0x0
  801571:	ff 75 14             	pushl  0x14(%ebp)
  801574:	ff 75 10             	pushl  0x10(%ebp)
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	6a 1e                	push   $0x1e
  80157d:	e8 de fc ff ff       	call   801260 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	50                   	push   %eax
  801596:	6a 1f                	push   $0x1f
  801598:	e8 c3 fc ff ff       	call   801260 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	50                   	push   %eax
  8015b2:	6a 20                	push   $0x20
  8015b4:	e8 a7 fc ff ff       	call   801260 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 02                	push   $0x2
  8015cd:	e8 8e fc ff ff       	call   801260 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 03                	push   $0x3
  8015e6:	e8 75 fc ff ff       	call   801260 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 04                	push   $0x4
  8015ff:	e8 5c fc ff ff       	call   801260 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_exit_env>:


void sys_exit_env(void)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 21                	push   $0x21
  801618:	e8 43 fc ff ff       	call   801260 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	90                   	nop
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801629:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80162c:	8d 50 04             	lea    0x4(%eax),%edx
  80162f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	52                   	push   %edx
  801639:	50                   	push   %eax
  80163a:	6a 22                	push   $0x22
  80163c:	e8 1f fc ff ff       	call   801260 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
	return result;
  801644:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801647:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164d:	89 01                	mov    %eax,(%ecx)
  80164f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	c9                   	leave  
  801656:	c2 04 00             	ret    $0x4

00801659 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	ff 75 10             	pushl  0x10(%ebp)
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	6a 10                	push   $0x10
  80166b:	e8 f0 fb ff ff       	call   801260 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
	return ;
  801673:	90                   	nop
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_rcr2>:
uint32 sys_rcr2()
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 23                	push   $0x23
  801685:	e8 d6 fb ff ff       	call   801260 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80169b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	50                   	push   %eax
  8016a8:	6a 24                	push   $0x24
  8016aa:	e8 b1 fb ff ff       	call   801260 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <rsttst>:
void rsttst()
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 26                	push   $0x26
  8016c4:	e8 97 fb ff ff       	call   801260 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cc:	90                   	nop
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016db:	8b 55 18             	mov    0x18(%ebp),%edx
  8016de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	ff 75 10             	pushl  0x10(%ebp)
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 25                	push   $0x25
  8016ef:	e8 6c fb ff ff       	call   801260 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f7:	90                   	nop
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <chktst>:
void chktst(uint32 n)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	6a 27                	push   $0x27
  80170a:	e8 51 fb ff ff       	call   801260 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
	return ;
  801712:	90                   	nop
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <inctst>:

void inctst()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 28                	push   $0x28
  801724:	e8 37 fb ff ff       	call   801260 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return ;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <gettst>:
uint32 gettst()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 29                	push   $0x29
  80173e:	e8 1d fb ff ff       	call   801260 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 2a                	push   $0x2a
  80175a:	e8 01 fb ff ff       	call   801260 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
  801762:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801765:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801769:	75 07                	jne    801772 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80176b:	b8 01 00 00 00       	mov    $0x1,%eax
  801770:	eb 05                	jmp    801777 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 2a                	push   $0x2a
  80178b:	e8 d0 fa ff ff       	call   801260 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
  801793:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801796:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80179a:	75 07                	jne    8017a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80179c:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a1:	eb 05                	jmp    8017a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 2a                	push   $0x2a
  8017bc:	e8 9f fa ff ff       	call   801260 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
  8017c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017c7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017cb:	75 07                	jne    8017d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d2:	eb 05                	jmp    8017d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 2a                	push   $0x2a
  8017ed:	e8 6e fa ff ff       	call   801260 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
  8017f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017f8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017fc:	75 07                	jne    801805 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801803:	eb 05                	jmp    80180a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	ff 75 08             	pushl  0x8(%ebp)
  80181a:	6a 2b                	push   $0x2b
  80181c:	e8 3f fa ff ff       	call   801260 <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
	return ;
  801824:	90                   	nop
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80182b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	53                   	push   %ebx
  80183a:	51                   	push   %ecx
  80183b:	52                   	push   %edx
  80183c:	50                   	push   %eax
  80183d:	6a 2c                	push   $0x2c
  80183f:	e8 1c fa ff ff       	call   801260 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 2d                	push   $0x2d
  80185f:	e8 fc f9 ff ff       	call   801260 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80186c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	51                   	push   %ecx
  801878:	ff 75 10             	pushl  0x10(%ebp)
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 2e                	push   $0x2e
  80187f:	e8 dc f9 ff ff       	call   801260 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 10             	pushl  0x10(%ebp)
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	ff 75 08             	pushl  0x8(%ebp)
  801899:	6a 0f                	push   $0xf
  80189b:	e8 c0 f9 ff ff       	call   801260 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a3:	90                   	nop
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	50                   	push   %eax
  8018b5:	6a 2f                	push   $0x2f
  8018b7:	e8 a4 f9 ff ff       	call   801260 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp

}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 30                	push   $0x30
  8018d2:	e8 89 f9 ff ff       	call   801260 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp

}
  8018da:	90                   	nop
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 31                	push   $0x31
  8018ee:	e8 6d f9 ff ff       	call   801260 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp

}
  8018f6:	90                   	nop
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 32                	push   $0x32
  801908:	e8 53 f9 ff ff       	call   801260 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    
  801912:	66 90                	xchg   %ax,%ax

00801914 <__udivdi3>:
  801914:	55                   	push   %ebp
  801915:	57                   	push   %edi
  801916:	56                   	push   %esi
  801917:	53                   	push   %ebx
  801918:	83 ec 1c             	sub    $0x1c,%esp
  80191b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80191f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801927:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192b:	89 ca                	mov    %ecx,%edx
  80192d:	89 f8                	mov    %edi,%eax
  80192f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801933:	85 f6                	test   %esi,%esi
  801935:	75 2d                	jne    801964 <__udivdi3+0x50>
  801937:	39 cf                	cmp    %ecx,%edi
  801939:	77 65                	ja     8019a0 <__udivdi3+0x8c>
  80193b:	89 fd                	mov    %edi,%ebp
  80193d:	85 ff                	test   %edi,%edi
  80193f:	75 0b                	jne    80194c <__udivdi3+0x38>
  801941:	b8 01 00 00 00       	mov    $0x1,%eax
  801946:	31 d2                	xor    %edx,%edx
  801948:	f7 f7                	div    %edi
  80194a:	89 c5                	mov    %eax,%ebp
  80194c:	31 d2                	xor    %edx,%edx
  80194e:	89 c8                	mov    %ecx,%eax
  801950:	f7 f5                	div    %ebp
  801952:	89 c1                	mov    %eax,%ecx
  801954:	89 d8                	mov    %ebx,%eax
  801956:	f7 f5                	div    %ebp
  801958:	89 cf                	mov    %ecx,%edi
  80195a:	89 fa                	mov    %edi,%edx
  80195c:	83 c4 1c             	add    $0x1c,%esp
  80195f:	5b                   	pop    %ebx
  801960:	5e                   	pop    %esi
  801961:	5f                   	pop    %edi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    
  801964:	39 ce                	cmp    %ecx,%esi
  801966:	77 28                	ja     801990 <__udivdi3+0x7c>
  801968:	0f bd fe             	bsr    %esi,%edi
  80196b:	83 f7 1f             	xor    $0x1f,%edi
  80196e:	75 40                	jne    8019b0 <__udivdi3+0x9c>
  801970:	39 ce                	cmp    %ecx,%esi
  801972:	72 0a                	jb     80197e <__udivdi3+0x6a>
  801974:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801978:	0f 87 9e 00 00 00    	ja     801a1c <__udivdi3+0x108>
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	89 fa                	mov    %edi,%edx
  801985:	83 c4 1c             	add    $0x1c,%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5f                   	pop    %edi
  80198b:	5d                   	pop    %ebp
  80198c:	c3                   	ret    
  80198d:	8d 76 00             	lea    0x0(%esi),%esi
  801990:	31 ff                	xor    %edi,%edi
  801992:	31 c0                	xor    %eax,%eax
  801994:	89 fa                	mov    %edi,%edx
  801996:	83 c4 1c             	add    $0x1c,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    
  80199e:	66 90                	xchg   %ax,%ax
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	f7 f7                	div    %edi
  8019a4:	31 ff                	xor    %edi,%edi
  8019a6:	89 fa                	mov    %edi,%edx
  8019a8:	83 c4 1c             	add    $0x1c,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    
  8019b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019b5:	89 eb                	mov    %ebp,%ebx
  8019b7:	29 fb                	sub    %edi,%ebx
  8019b9:	89 f9                	mov    %edi,%ecx
  8019bb:	d3 e6                	shl    %cl,%esi
  8019bd:	89 c5                	mov    %eax,%ebp
  8019bf:	88 d9                	mov    %bl,%cl
  8019c1:	d3 ed                	shr    %cl,%ebp
  8019c3:	89 e9                	mov    %ebp,%ecx
  8019c5:	09 f1                	or     %esi,%ecx
  8019c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019cb:	89 f9                	mov    %edi,%ecx
  8019cd:	d3 e0                	shl    %cl,%eax
  8019cf:	89 c5                	mov    %eax,%ebp
  8019d1:	89 d6                	mov    %edx,%esi
  8019d3:	88 d9                	mov    %bl,%cl
  8019d5:	d3 ee                	shr    %cl,%esi
  8019d7:	89 f9                	mov    %edi,%ecx
  8019d9:	d3 e2                	shl    %cl,%edx
  8019db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019df:	88 d9                	mov    %bl,%cl
  8019e1:	d3 e8                	shr    %cl,%eax
  8019e3:	09 c2                	or     %eax,%edx
  8019e5:	89 d0                	mov    %edx,%eax
  8019e7:	89 f2                	mov    %esi,%edx
  8019e9:	f7 74 24 0c          	divl   0xc(%esp)
  8019ed:	89 d6                	mov    %edx,%esi
  8019ef:	89 c3                	mov    %eax,%ebx
  8019f1:	f7 e5                	mul    %ebp
  8019f3:	39 d6                	cmp    %edx,%esi
  8019f5:	72 19                	jb     801a10 <__udivdi3+0xfc>
  8019f7:	74 0b                	je     801a04 <__udivdi3+0xf0>
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	31 ff                	xor    %edi,%edi
  8019fd:	e9 58 ff ff ff       	jmp    80195a <__udivdi3+0x46>
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a08:	89 f9                	mov    %edi,%ecx
  801a0a:	d3 e2                	shl    %cl,%edx
  801a0c:	39 c2                	cmp    %eax,%edx
  801a0e:	73 e9                	jae    8019f9 <__udivdi3+0xe5>
  801a10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a13:	31 ff                	xor    %edi,%edi
  801a15:	e9 40 ff ff ff       	jmp    80195a <__udivdi3+0x46>
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	31 c0                	xor    %eax,%eax
  801a1e:	e9 37 ff ff ff       	jmp    80195a <__udivdi3+0x46>
  801a23:	90                   	nop

00801a24 <__umoddi3>:
  801a24:	55                   	push   %ebp
  801a25:	57                   	push   %edi
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 1c             	sub    $0x1c,%esp
  801a2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a43:	89 f3                	mov    %esi,%ebx
  801a45:	89 fa                	mov    %edi,%edx
  801a47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a4b:	89 34 24             	mov    %esi,(%esp)
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	75 1a                	jne    801a6c <__umoddi3+0x48>
  801a52:	39 f7                	cmp    %esi,%edi
  801a54:	0f 86 a2 00 00 00    	jbe    801afc <__umoddi3+0xd8>
  801a5a:	89 c8                	mov    %ecx,%eax
  801a5c:	89 f2                	mov    %esi,%edx
  801a5e:	f7 f7                	div    %edi
  801a60:	89 d0                	mov    %edx,%eax
  801a62:	31 d2                	xor    %edx,%edx
  801a64:	83 c4 1c             	add    $0x1c,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5f                   	pop    %edi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    
  801a6c:	39 f0                	cmp    %esi,%eax
  801a6e:	0f 87 ac 00 00 00    	ja     801b20 <__umoddi3+0xfc>
  801a74:	0f bd e8             	bsr    %eax,%ebp
  801a77:	83 f5 1f             	xor    $0x1f,%ebp
  801a7a:	0f 84 ac 00 00 00    	je     801b2c <__umoddi3+0x108>
  801a80:	bf 20 00 00 00       	mov    $0x20,%edi
  801a85:	29 ef                	sub    %ebp,%edi
  801a87:	89 fe                	mov    %edi,%esi
  801a89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a8d:	89 e9                	mov    %ebp,%ecx
  801a8f:	d3 e0                	shl    %cl,%eax
  801a91:	89 d7                	mov    %edx,%edi
  801a93:	89 f1                	mov    %esi,%ecx
  801a95:	d3 ef                	shr    %cl,%edi
  801a97:	09 c7                	or     %eax,%edi
  801a99:	89 e9                	mov    %ebp,%ecx
  801a9b:	d3 e2                	shl    %cl,%edx
  801a9d:	89 14 24             	mov    %edx,(%esp)
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	d3 e0                	shl    %cl,%eax
  801aa4:	89 c2                	mov    %eax,%edx
  801aa6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aaa:	d3 e0                	shl    %cl,%eax
  801aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab4:	89 f1                	mov    %esi,%ecx
  801ab6:	d3 e8                	shr    %cl,%eax
  801ab8:	09 d0                	or     %edx,%eax
  801aba:	d3 eb                	shr    %cl,%ebx
  801abc:	89 da                	mov    %ebx,%edx
  801abe:	f7 f7                	div    %edi
  801ac0:	89 d3                	mov    %edx,%ebx
  801ac2:	f7 24 24             	mull   (%esp)
  801ac5:	89 c6                	mov    %eax,%esi
  801ac7:	89 d1                	mov    %edx,%ecx
  801ac9:	39 d3                	cmp    %edx,%ebx
  801acb:	0f 82 87 00 00 00    	jb     801b58 <__umoddi3+0x134>
  801ad1:	0f 84 91 00 00 00    	je     801b68 <__umoddi3+0x144>
  801ad7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801adb:	29 f2                	sub    %esi,%edx
  801add:	19 cb                	sbb    %ecx,%ebx
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ae5:	d3 e0                	shl    %cl,%eax
  801ae7:	89 e9                	mov    %ebp,%ecx
  801ae9:	d3 ea                	shr    %cl,%edx
  801aeb:	09 d0                	or     %edx,%eax
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 eb                	shr    %cl,%ebx
  801af1:	89 da                	mov    %ebx,%edx
  801af3:	83 c4 1c             	add    $0x1c,%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5f                   	pop    %edi
  801af9:	5d                   	pop    %ebp
  801afa:	c3                   	ret    
  801afb:	90                   	nop
  801afc:	89 fd                	mov    %edi,%ebp
  801afe:	85 ff                	test   %edi,%edi
  801b00:	75 0b                	jne    801b0d <__umoddi3+0xe9>
  801b02:	b8 01 00 00 00       	mov    $0x1,%eax
  801b07:	31 d2                	xor    %edx,%edx
  801b09:	f7 f7                	div    %edi
  801b0b:	89 c5                	mov    %eax,%ebp
  801b0d:	89 f0                	mov    %esi,%eax
  801b0f:	31 d2                	xor    %edx,%edx
  801b11:	f7 f5                	div    %ebp
  801b13:	89 c8                	mov    %ecx,%eax
  801b15:	f7 f5                	div    %ebp
  801b17:	89 d0                	mov    %edx,%eax
  801b19:	e9 44 ff ff ff       	jmp    801a62 <__umoddi3+0x3e>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	89 c8                	mov    %ecx,%eax
  801b22:	89 f2                	mov    %esi,%edx
  801b24:	83 c4 1c             	add    $0x1c,%esp
  801b27:	5b                   	pop    %ebx
  801b28:	5e                   	pop    %esi
  801b29:	5f                   	pop    %edi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    
  801b2c:	3b 04 24             	cmp    (%esp),%eax
  801b2f:	72 06                	jb     801b37 <__umoddi3+0x113>
  801b31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b35:	77 0f                	ja     801b46 <__umoddi3+0x122>
  801b37:	89 f2                	mov    %esi,%edx
  801b39:	29 f9                	sub    %edi,%ecx
  801b3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b3f:	89 14 24             	mov    %edx,(%esp)
  801b42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b4a:	8b 14 24             	mov    (%esp),%edx
  801b4d:	83 c4 1c             	add    $0x1c,%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5e                   	pop    %esi
  801b52:	5f                   	pop    %edi
  801b53:	5d                   	pop    %ebp
  801b54:	c3                   	ret    
  801b55:	8d 76 00             	lea    0x0(%esi),%esi
  801b58:	2b 04 24             	sub    (%esp),%eax
  801b5b:	19 fa                	sbb    %edi,%edx
  801b5d:	89 d1                	mov    %edx,%ecx
  801b5f:	89 c6                	mov    %eax,%esi
  801b61:	e9 71 ff ff ff       	jmp    801ad7 <__umoddi3+0xb3>
  801b66:	66 90                	xchg   %ax,%ax
  801b68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b6c:	72 ea                	jb     801b58 <__umoddi3+0x134>
  801b6e:	89 d9                	mov    %ebx,%ecx
  801b70:	e9 62 ff ff ff       	jmp    801ad7 <__umoddi3+0xb3>
