
obj/user/tst_syscalls_2_slave2:     file format elf32-i386


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
  800031:	e8 33 00 00 00       	call   800069 <libmain>
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
	//[2] Invalid Range (Above USER_LIMIT)
	sys_allocate_user_mem(USER_LIMIT,10);
  80003e:	83 ec 08             	sub    $0x8,%esp
  800041:	6a 0a                	push   $0xa
  800043:	68 00 00 80 ef       	push   $0xef800000
  800048:	e8 92 18 00 00       	call   8018df <sys_allocate_user_mem>
  80004d:	83 c4 10             	add    $0x10,%esp
	inctst();
  800050:	e8 c2 16 00 00       	call   801717 <inctst>
	panic("tst system calls #2 failed: sys_allocate_user_mem is called with invalid params\nThe env must be killed and shouldn't return here.");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 80 1b 80 00       	push   $0x801b80
  80005d:	6a 0a                	push   $0xa
  80005f:	68 02 1c 80 00       	push   $0x801c02
  800064:	e8 37 01 00 00       	call   8001a0 <_panic>

00800069 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006f:	e8 65 15 00 00       	call   8015d9 <sys_getenvindex>
  800074:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80007a:	89 d0                	mov    %edx,%eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	01 c0                	add    %eax,%eax
  800083:	01 d0                	add    %edx,%eax
  800085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80008c:	01 d0                	add    %edx,%eax
  80008e:	c1 e0 04             	shl    $0x4,%eax
  800091:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800096:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009b:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a0:	8a 40 5c             	mov    0x5c(%eax),%al
  8000a3:	84 c0                	test   %al,%al
  8000a5:	74 0d                	je     8000b4 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	83 c0 5c             	add    $0x5c,%eax
  8000af:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b8:	7e 0a                	jle    8000c4 <libmain+0x5b>
		binaryname = argv[0];
  8000ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bd:	8b 00                	mov    (%eax),%eax
  8000bf:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ca:	ff 75 08             	pushl  0x8(%ebp)
  8000cd:	e8 66 ff ff ff       	call   800038 <_main>
  8000d2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000d5:	e8 0c 13 00 00       	call   8013e6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 38 1c 80 00       	push   $0x801c38
  8000e2:	e8 76 03 00 00       	call   80045d <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8000f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fa:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	52                   	push   %edx
  800104:	50                   	push   %eax
  800105:	68 60 1c 80 00       	push   $0x801c60
  80010a:	e8 4e 03 00 00       	call   80045d <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800112:	a1 20 30 80 00       	mov    0x803020,%eax
  800117:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800128:	a1 20 30 80 00       	mov    0x803020,%eax
  80012d:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800133:	51                   	push   %ecx
  800134:	52                   	push   %edx
  800135:	50                   	push   %eax
  800136:	68 88 1c 80 00       	push   $0x801c88
  80013b:	e8 1d 03 00 00       	call   80045d <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800143:	a1 20 30 80 00       	mov    0x803020,%eax
  800148:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	50                   	push   %eax
  800152:	68 e0 1c 80 00       	push   $0x801ce0
  800157:	e8 01 03 00 00       	call   80045d <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	68 38 1c 80 00       	push   $0x801c38
  800167:	e8 f1 02 00 00       	call   80045d <cprintf>
  80016c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80016f:	e8 8c 12 00 00       	call   801400 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800174:	e8 19 00 00 00       	call   800192 <exit>
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	6a 00                	push   $0x0
  800187:	e8 19 14 00 00       	call   8015a5 <sys_destroy_env>
  80018c:	83 c4 10             	add    $0x10,%esp
}
  80018f:	90                   	nop
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <exit>:

void
exit(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800198:	e8 6e 14 00 00       	call   80160b <sys_exit_env>
}
  80019d:	90                   	nop
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001a6:	8d 45 10             	lea    0x10(%ebp),%eax
  8001a9:	83 c0 04             	add    $0x4,%eax
  8001ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001af:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	74 16                	je     8001ce <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001b8:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	50                   	push   %eax
  8001c1:	68 f4 1c 80 00       	push   $0x801cf4
  8001c6:	e8 92 02 00 00       	call   80045d <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001ce:	a1 00 30 80 00       	mov    0x803000,%eax
  8001d3:	ff 75 0c             	pushl  0xc(%ebp)
  8001d6:	ff 75 08             	pushl  0x8(%ebp)
  8001d9:	50                   	push   %eax
  8001da:	68 f9 1c 80 00       	push   $0x801cf9
  8001df:	e8 79 02 00 00       	call   80045d <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8001e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f0:	50                   	push   %eax
  8001f1:	e8 fc 01 00 00       	call   8003f2 <vcprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	68 15 1d 80 00       	push   $0x801d15
  800203:	e8 ea 01 00 00       	call   8003f2 <vcprintf>
  800208:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80020b:	e8 82 ff ff ff       	call   800192 <exit>

	// should not return here
	while (1) ;
  800210:	eb fe                	jmp    800210 <_panic+0x70>

00800212 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800218:	a1 20 30 80 00       	mov    0x803020,%eax
  80021d:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
  800226:	39 c2                	cmp    %eax,%edx
  800228:	74 14                	je     80023e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	68 18 1d 80 00       	push   $0x801d18
  800232:	6a 26                	push   $0x26
  800234:	68 64 1d 80 00       	push   $0x801d64
  800239:	e8 62 ff ff ff       	call   8001a0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80023e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800245:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80024c:	e9 c5 00 00 00       	jmp    800316 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	85 c0                	test   %eax,%eax
  800264:	75 08                	jne    80026e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800266:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800269:	e9 a5 00 00 00       	jmp    800313 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80026e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800275:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80027c:	eb 69                	jmp    8002e7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80027e:	a1 20 30 80 00       	mov    0x803020,%eax
  800283:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800289:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80028c:	89 d0                	mov    %edx,%eax
  80028e:	01 c0                	add    %eax,%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	c1 e0 03             	shl    $0x3,%eax
  800295:	01 c8                	add    %ecx,%eax
  800297:	8a 40 04             	mov    0x4(%eax),%al
  80029a:	84 c0                	test   %al,%al
  80029c:	75 46                	jne    8002e4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80029e:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002ac:	89 d0                	mov    %edx,%eax
  8002ae:	01 c0                	add    %eax,%eax
  8002b0:	01 d0                	add    %edx,%eax
  8002b2:	c1 e0 03             	shl    $0x3,%eax
  8002b5:	01 c8                	add    %ecx,%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	01 c8                	add    %ecx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	75 09                	jne    8002e4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8002db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8002e2:	eb 15                	jmp    8002f9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002e4:	ff 45 e8             	incl   -0x18(%ebp)
  8002e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ec:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8002f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	77 85                	ja     80027e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8002f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002fd:	75 14                	jne    800313 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 70 1d 80 00       	push   $0x801d70
  800307:	6a 3a                	push   $0x3a
  800309:	68 64 1d 80 00       	push   $0x801d64
  80030e:	e8 8d fe ff ff       	call   8001a0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800313:	ff 45 f0             	incl   -0x10(%ebp)
  800316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800319:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80031c:	0f 8c 2f ff ff ff    	jl     800251 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800322:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800330:	eb 26                	jmp    800358 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800332:	a1 20 30 80 00       	mov    0x803020,%eax
  800337:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80033d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800340:	89 d0                	mov    %edx,%eax
  800342:	01 c0                	add    %eax,%eax
  800344:	01 d0                	add    %edx,%eax
  800346:	c1 e0 03             	shl    $0x3,%eax
  800349:	01 c8                	add    %ecx,%eax
  80034b:	8a 40 04             	mov    0x4(%eax),%al
  80034e:	3c 01                	cmp    $0x1,%al
  800350:	75 03                	jne    800355 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800352:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800355:	ff 45 e0             	incl   -0x20(%ebp)
  800358:	a1 20 30 80 00       	mov    0x803020,%eax
  80035d:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800366:	39 c2                	cmp    %eax,%edx
  800368:	77 c8                	ja     800332 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800370:	74 14                	je     800386 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 c4 1d 80 00       	push   $0x801dc4
  80037a:	6a 44                	push   $0x44
  80037c:	68 64 1d 80 00       	push   $0x801d64
  800381:	e8 1a fe ff ff       	call   8001a0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800386:	90                   	nop
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 48 01             	lea    0x1(%eax),%ecx
  800397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039a:	89 0a                	mov    %ecx,(%edx)
  80039c:	8b 55 08             	mov    0x8(%ebp),%edx
  80039f:	88 d1                	mov    %dl,%cl
  8003a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b2:	75 2c                	jne    8003e0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b4:	a0 24 30 80 00       	mov    0x803024,%al
  8003b9:	0f b6 c0             	movzbl %al,%eax
  8003bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bf:	8b 12                	mov    (%edx),%edx
  8003c1:	89 d1                	mov    %edx,%ecx
  8003c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c6:	83 c2 08             	add    $0x8,%edx
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	50                   	push   %eax
  8003cd:	51                   	push   %ecx
  8003ce:	52                   	push   %edx
  8003cf:	e8 b9 0e 00 00       	call   80128d <sys_cputs>
  8003d4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	8b 40 04             	mov    0x4(%eax),%eax
  8003e6:	8d 50 01             	lea    0x1(%eax),%edx
  8003e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ec:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ef:	90                   	nop
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    

008003f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800402:	00 00 00 
	b.cnt = 0;
  800405:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	68 89 03 80 00       	push   $0x800389
  800421:	e8 11 02 00 00       	call   800637 <vprintfmt>
  800426:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800429:	a0 24 30 80 00       	mov    0x803024,%al
  80042e:	0f b6 c0             	movzbl %al,%eax
  800431:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	50                   	push   %eax
  80043b:	52                   	push   %edx
  80043c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800442:	83 c0 08             	add    $0x8,%eax
  800445:	50                   	push   %eax
  800446:	e8 42 0e 00 00       	call   80128d <sys_cputs>
  80044b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800455:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <cprintf>:

int cprintf(const char *fmt, ...) {
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800463:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80046a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 f4             	pushl  -0xc(%ebp)
  800479:	50                   	push   %eax
  80047a:	e8 73 ff ff ff       	call   8003f2 <vcprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800490:	e8 51 0f 00 00       	call   8013e6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800495:	8d 45 0c             	lea    0xc(%ebp),%eax
  800498:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a4:	50                   	push   %eax
  8004a5:	e8 48 ff ff ff       	call   8003f2 <vcprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004b0:	e8 4b 0f 00 00       	call   801400 <sys_enable_interrupt>
	return cnt;
  8004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	53                   	push   %ebx
  8004be:	83 ec 14             	sub    $0x14,%esp
  8004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d8:	77 55                	ja     80052f <printnum+0x75>
  8004da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004dd:	72 05                	jb     8004e4 <printnum+0x2a>
  8004df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e2:	77 4b                	ja     80052f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f2:	52                   	push   %edx
  8004f3:	50                   	push   %eax
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004fa:	e8 15 14 00 00       	call   801914 <__udivdi3>
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	83 ec 04             	sub    $0x4,%esp
  800505:	ff 75 20             	pushl  0x20(%ebp)
  800508:	53                   	push   %ebx
  800509:	ff 75 18             	pushl  0x18(%ebp)
  80050c:	52                   	push   %edx
  80050d:	50                   	push   %eax
  80050e:	ff 75 0c             	pushl  0xc(%ebp)
  800511:	ff 75 08             	pushl  0x8(%ebp)
  800514:	e8 a1 ff ff ff       	call   8004ba <printnum>
  800519:	83 c4 20             	add    $0x20,%esp
  80051c:	eb 1a                	jmp    800538 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	ff 75 20             	pushl  0x20(%ebp)
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	ff d0                	call   *%eax
  80052c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052f:	ff 4d 1c             	decl   0x1c(%ebp)
  800532:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800536:	7f e6                	jg     80051e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800538:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80053b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800546:	53                   	push   %ebx
  800547:	51                   	push   %ecx
  800548:	52                   	push   %edx
  800549:	50                   	push   %eax
  80054a:	e8 d5 14 00 00       	call   801a24 <__umoddi3>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	05 34 20 80 00       	add    $0x802034,%eax
  800557:	8a 00                	mov    (%eax),%al
  800559:	0f be c0             	movsbl %al,%eax
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	ff 75 0c             	pushl  0xc(%ebp)
  800562:	50                   	push   %eax
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	ff d0                	call   *%eax
  800568:	83 c4 10             	add    $0x10,%esp
}
  80056b:	90                   	nop
  80056c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800574:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800578:	7e 1c                	jle    800596 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80057a:	8b 45 08             	mov    0x8(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	8d 50 08             	lea    0x8(%eax),%edx
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	89 10                	mov    %edx,(%eax)
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	83 e8 08             	sub    $0x8,%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	eb 40                	jmp    8005d6 <getuint+0x65>
	else if (lflag)
  800596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059a:	74 1e                	je     8005ba <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	8d 50 04             	lea    0x4(%eax),%edx
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	89 10                	mov    %edx,(%eax)
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 e8 04             	sub    $0x4,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	eb 1c                	jmp    8005d6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	8d 50 04             	lea    0x4(%eax),%edx
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	89 10                	mov    %edx,(%eax)
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	83 e8 04             	sub    $0x4,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d6:	5d                   	pop    %ebp
  8005d7:	c3                   	ret    

008005d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005df:	7e 1c                	jle    8005fd <getint+0x25>
		return va_arg(*ap, long long);
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	8d 50 08             	lea    0x8(%eax),%edx
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	89 10                	mov    %edx,(%eax)
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	83 e8 08             	sub    $0x8,%eax
  8005f6:	8b 50 04             	mov    0x4(%eax),%edx
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	eb 38                	jmp    800635 <getint+0x5d>
	else if (lflag)
  8005fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800601:	74 1a                	je     80061d <getint+0x45>
		return va_arg(*ap, long);
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	8d 50 04             	lea    0x4(%eax),%edx
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 10                	mov    %edx,(%eax)
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	8b 00                	mov    (%eax),%eax
  800615:	83 e8 04             	sub    $0x4,%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	99                   	cltd   
  80061b:	eb 18                	jmp    800635 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	8d 50 04             	lea    0x4(%eax),%edx
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	89 10                	mov    %edx,(%eax)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	83 e8 04             	sub    $0x4,%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	99                   	cltd   
}
  800635:	5d                   	pop    %ebp
  800636:	c3                   	ret    

00800637 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
  80063c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063f:	eb 17                	jmp    800658 <vprintfmt+0x21>
			if (ch == '\0')
  800641:	85 db                	test   %ebx,%ebx
  800643:	0f 84 af 03 00 00    	je     8009f8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	53                   	push   %ebx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	ff d0                	call   *%eax
  800655:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800658:	8b 45 10             	mov    0x10(%ebp),%eax
  80065b:	8d 50 01             	lea    0x1(%eax),%edx
  80065e:	89 55 10             	mov    %edx,0x10(%ebp)
  800661:	8a 00                	mov    (%eax),%al
  800663:	0f b6 d8             	movzbl %al,%ebx
  800666:	83 fb 25             	cmp    $0x25,%ebx
  800669:	75 d6                	jne    800641 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80066b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800676:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800684:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8b 45 10             	mov    0x10(%ebp),%eax
  80068e:	8d 50 01             	lea    0x1(%eax),%edx
  800691:	89 55 10             	mov    %edx,0x10(%ebp)
  800694:	8a 00                	mov    (%eax),%al
  800696:	0f b6 d8             	movzbl %al,%ebx
  800699:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80069c:	83 f8 55             	cmp    $0x55,%eax
  80069f:	0f 87 2b 03 00 00    	ja     8009d0 <vprintfmt+0x399>
  8006a5:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  8006ac:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b2:	eb d7                	jmp    80068b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b8:	eb d1                	jmp    80068b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c4:	89 d0                	mov    %edx,%eax
  8006c6:	c1 e0 02             	shl    $0x2,%eax
  8006c9:	01 d0                	add    %edx,%eax
  8006cb:	01 c0                	add    %eax,%eax
  8006cd:	01 d8                	add    %ebx,%eax
  8006cf:	83 e8 30             	sub    $0x30,%eax
  8006d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d8:	8a 00                	mov    (%eax),%al
  8006da:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006dd:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e0:	7e 3e                	jle    800720 <vprintfmt+0xe9>
  8006e2:	83 fb 39             	cmp    $0x39,%ebx
  8006e5:	7f 39                	jg     800720 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006ea:	eb d5                	jmp    8006c1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 c0 04             	add    $0x4,%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	83 e8 04             	sub    $0x4,%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800700:	eb 1f                	jmp    800721 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	79 83                	jns    80068b <vprintfmt+0x54>
				width = 0;
  800708:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070f:	e9 77 ff ff ff       	jmp    80068b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800714:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80071b:	e9 6b ff ff ff       	jmp    80068b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800720:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800721:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800725:	0f 89 60 ff ff ff    	jns    80068b <vprintfmt+0x54>
				width = precision, precision = -1;
  80072b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800731:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800738:	e9 4e ff ff ff       	jmp    80068b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800740:	e9 46 ff ff ff       	jmp    80068b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	83 c0 04             	add    $0x4,%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	83 e8 04             	sub    $0x4,%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	50                   	push   %eax
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
			break;
  800765:	e9 89 02 00 00       	jmp    8009f3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 e8 04             	sub    $0x4,%eax
  800779:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80077b:	85 db                	test   %ebx,%ebx
  80077d:	79 02                	jns    800781 <vprintfmt+0x14a>
				err = -err;
  80077f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800781:	83 fb 64             	cmp    $0x64,%ebx
  800784:	7f 0b                	jg     800791 <vprintfmt+0x15a>
  800786:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  80078d:	85 f6                	test   %esi,%esi
  80078f:	75 19                	jne    8007aa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800791:	53                   	push   %ebx
  800792:	68 45 20 80 00       	push   $0x802045
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	ff 75 08             	pushl  0x8(%ebp)
  80079d:	e8 5e 02 00 00       	call   800a00 <printfmt>
  8007a2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a5:	e9 49 02 00 00       	jmp    8009f3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007aa:	56                   	push   %esi
  8007ab:	68 4e 20 80 00       	push   $0x80204e
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	e8 45 02 00 00       	call   800a00 <printfmt>
  8007bb:	83 c4 10             	add    $0x10,%esp
			break;
  8007be:	e9 30 02 00 00       	jmp    8009f3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 c0 04             	add    $0x4,%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	83 e8 04             	sub    $0x4,%eax
  8007d2:	8b 30                	mov    (%eax),%esi
  8007d4:	85 f6                	test   %esi,%esi
  8007d6:	75 05                	jne    8007dd <vprintfmt+0x1a6>
				p = "(null)";
  8007d8:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8007dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e1:	7e 6d                	jle    800850 <vprintfmt+0x219>
  8007e3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e7:	74 67                	je     800850 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	50                   	push   %eax
  8007f0:	56                   	push   %esi
  8007f1:	e8 0c 03 00 00       	call   800b02 <strnlen>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007fc:	eb 16                	jmp    800814 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	50                   	push   %eax
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800811:	ff 4d e4             	decl   -0x1c(%ebp)
  800814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800818:	7f e4                	jg     8007fe <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081a:	eb 34                	jmp    800850 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80081c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800820:	74 1c                	je     80083e <vprintfmt+0x207>
  800822:	83 fb 1f             	cmp    $0x1f,%ebx
  800825:	7e 05                	jle    80082c <vprintfmt+0x1f5>
  800827:	83 fb 7e             	cmp    $0x7e,%ebx
  80082a:	7e 12                	jle    80083e <vprintfmt+0x207>
					putch('?', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	6a 3f                	push   $0x3f
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	eb 0f                	jmp    80084d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	53                   	push   %ebx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084d:	ff 4d e4             	decl   -0x1c(%ebp)
  800850:	89 f0                	mov    %esi,%eax
  800852:	8d 70 01             	lea    0x1(%eax),%esi
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
  80085a:	85 db                	test   %ebx,%ebx
  80085c:	74 24                	je     800882 <vprintfmt+0x24b>
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	78 b8                	js     80081c <vprintfmt+0x1e5>
  800864:	ff 4d e0             	decl   -0x20(%ebp)
  800867:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80086b:	79 af                	jns    80081c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086d:	eb 13                	jmp    800882 <vprintfmt+0x24b>
				putch(' ', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	6a 20                	push   $0x20
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087f:	ff 4d e4             	decl   -0x1c(%ebp)
  800882:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800886:	7f e7                	jg     80086f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800888:	e9 66 01 00 00       	jmp    8009f3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 e8             	pushl  -0x18(%ebp)
  800893:	8d 45 14             	lea    0x14(%ebp),%eax
  800896:	50                   	push   %eax
  800897:	e8 3c fd ff ff       	call   8005d8 <getint>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	79 23                	jns    8008d2 <vprintfmt+0x29b>
				putch('-', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	6a 2d                	push   $0x2d
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	ff d0                	call   *%eax
  8008bc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c5:	f7 d8                	neg    %eax
  8008c7:	83 d2 00             	adc    $0x0,%edx
  8008ca:	f7 da                	neg    %edx
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d9:	e9 bc 00 00 00       	jmp    80099a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e7:	50                   	push   %eax
  8008e8:	e8 84 fc ff ff       	call   800571 <getuint>
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fd:	e9 98 00 00 00       	jmp    80099a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 58                	push   $0x58
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 58                	push   $0x58
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	6a 58                	push   $0x58
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	ff d0                	call   *%eax
  80092f:	83 c4 10             	add    $0x10,%esp
			break;
  800932:	e9 bc 00 00 00       	jmp    8009f3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 30                	push   $0x30
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	6a 78                	push   $0x78
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800972:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800979:	eb 1f                	jmp    80099a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 e8             	pushl  -0x18(%ebp)
  800981:	8d 45 14             	lea    0x14(%ebp),%eax
  800984:	50                   	push   %eax
  800985:	e8 e7 fb ff ff       	call   800571 <getuint>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800990:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800993:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80099a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a1:	83 ec 04             	sub    $0x4,%esp
  8009a4:	52                   	push   %edx
  8009a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a8:	50                   	push   %eax
  8009a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 00 fb ff ff       	call   8004ba <printnum>
  8009ba:	83 c4 20             	add    $0x20,%esp
			break;
  8009bd:	eb 34                	jmp    8009f3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	ff d0                	call   *%eax
  8009cb:	83 c4 10             	add    $0x10,%esp
			break;
  8009ce:	eb 23                	jmp    8009f3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 25                	push   $0x25
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e0:	ff 4d 10             	decl   0x10(%ebp)
  8009e3:	eb 03                	jmp    8009e8 <vprintfmt+0x3b1>
  8009e5:	ff 4d 10             	decl   0x10(%ebp)
  8009e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009eb:	48                   	dec    %eax
  8009ec:	8a 00                	mov    (%eax),%al
  8009ee:	3c 25                	cmp    $0x25,%al
  8009f0:	75 f3                	jne    8009e5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009f2:	90                   	nop
		}
	}
  8009f3:	e9 47 fc ff ff       	jmp    80063f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fc:	5b                   	pop    %ebx
  8009fd:	5e                   	pop    %esi
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a06:	8d 45 10             	lea    0x10(%ebp),%eax
  800a09:	83 c0 04             	add    $0x4,%eax
  800a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a12:	ff 75 f4             	pushl  -0xc(%ebp)
  800a15:	50                   	push   %eax
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	ff 75 08             	pushl  0x8(%ebp)
  800a1c:	e8 16 fc ff ff       	call   800637 <vprintfmt>
  800a21:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2d:	8b 40 08             	mov    0x8(%eax),%eax
  800a30:	8d 50 01             	lea    0x1(%eax),%edx
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	8b 10                	mov    (%eax),%edx
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	8b 40 04             	mov    0x4(%eax),%eax
  800a44:	39 c2                	cmp    %eax,%edx
  800a46:	73 12                	jae    800a5a <sprintputch+0x33>
		*b->buf++ = ch;
  800a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a53:	89 0a                	mov    %ecx,(%edx)
  800a55:	8b 55 08             	mov    0x8(%ebp),%edx
  800a58:	88 10                	mov    %dl,(%eax)
}
  800a5a:	90                   	nop
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a82:	74 06                	je     800a8a <vsnprintf+0x2d>
  800a84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a88:	7f 07                	jg     800a91 <vsnprintf+0x34>
		return -E_INVAL;
  800a8a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8f:	eb 20                	jmp    800ab1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a91:	ff 75 14             	pushl  0x14(%ebp)
  800a94:	ff 75 10             	pushl  0x10(%ebp)
  800a97:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9a:	50                   	push   %eax
  800a9b:	68 27 0a 80 00       	push   $0x800a27
  800aa0:	e8 92 fb ff ff       	call   800637 <vprintfmt>
  800aa5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab1:	c9                   	leave  
  800ab2:	c3                   	ret    

00800ab3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab9:	8d 45 10             	lea    0x10(%ebp),%eax
  800abc:	83 c0 04             	add    $0x4,%eax
  800abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac8:	50                   	push   %eax
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 89 ff ff ff       	call   800a5d <vsnprintf>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800add:	c9                   	leave  
  800ade:	c3                   	ret    

00800adf <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aec:	eb 06                	jmp    800af4 <strlen+0x15>
		n++;
  800aee:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af1:	ff 45 08             	incl   0x8(%ebp)
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	84 c0                	test   %al,%al
  800afb:	75 f1                	jne    800aee <strlen+0xf>
		n++;
	return n;
  800afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0f:	eb 09                	jmp    800b1a <strnlen+0x18>
		n++;
  800b11:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b14:	ff 45 08             	incl   0x8(%ebp)
  800b17:	ff 4d 0c             	decl   0xc(%ebp)
  800b1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1e:	74 09                	je     800b29 <strnlen+0x27>
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8a 00                	mov    (%eax),%al
  800b25:	84 c0                	test   %al,%al
  800b27:	75 e8                	jne    800b11 <strnlen+0xf>
		n++;
	return n;
  800b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b3a:	90                   	nop
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	89 55 08             	mov    %edx,0x8(%ebp)
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4d:	8a 12                	mov    (%edx),%dl
  800b4f:	88 10                	mov    %dl,(%eax)
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	84 c0                	test   %al,%al
  800b55:	75 e4                	jne    800b3b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6f:	eb 1f                	jmp    800b90 <strncpy+0x34>
		*dst++ = *src;
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8d 50 01             	lea    0x1(%eax),%edx
  800b77:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7d:	8a 12                	mov    (%edx),%dl
  800b7f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	84 c0                	test   %al,%al
  800b88:	74 03                	je     800b8d <strncpy+0x31>
			src++;
  800b8a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8d:	ff 45 fc             	incl   -0x4(%ebp)
  800b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b93:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b96:	72 d9                	jb     800b71 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bad:	74 30                	je     800bdf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800baf:	eb 16                	jmp    800bc7 <strlcpy+0x2a>
			*dst++ = *src++;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc3:	8a 12                	mov    (%edx),%dl
  800bc5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bce:	74 09                	je     800bd9 <strlcpy+0x3c>
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	84 c0                	test   %al,%al
  800bd7:	75 d8                	jne    800bb1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be5:	29 c2                	sub    %eax,%edx
  800be7:	89 d0                	mov    %edx,%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bee:	eb 06                	jmp    800bf6 <strcmp+0xb>
		p++, q++;
  800bf0:	ff 45 08             	incl   0x8(%ebp)
  800bf3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	74 0e                	je     800c0d <strcmp+0x22>
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8a 10                	mov    (%eax),%dl
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	38 c2                	cmp    %al,%dl
  800c0b:	74 e3                	je     800bf0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f b6 d0             	movzbl %al,%edx
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	0f b6 c0             	movzbl %al,%eax
  800c1d:	29 c2                	sub    %eax,%edx
  800c1f:	89 d0                	mov    %edx,%eax
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c26:	eb 09                	jmp    800c31 <strncmp+0xe>
		n--, p++, q++;
  800c28:	ff 4d 10             	decl   0x10(%ebp)
  800c2b:	ff 45 08             	incl   0x8(%ebp)
  800c2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c35:	74 17                	je     800c4e <strncmp+0x2b>
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	84 c0                	test   %al,%al
  800c3e:	74 0e                	je     800c4e <strncmp+0x2b>
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8a 10                	mov    (%eax),%dl
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	38 c2                	cmp    %al,%dl
  800c4c:	74 da                	je     800c28 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c52:	75 07                	jne    800c5b <strncmp+0x38>
		return 0;
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
  800c59:	eb 14                	jmp    800c6f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	0f b6 d0             	movzbl %al,%edx
  800c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c66:	8a 00                	mov    (%eax),%al
  800c68:	0f b6 c0             	movzbl %al,%eax
  800c6b:	29 c2                	sub    %eax,%edx
  800c6d:	89 d0                	mov    %edx,%eax
}
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 04             	sub    $0x4,%esp
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7d:	eb 12                	jmp    800c91 <strchr+0x20>
		if (*s == c)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c87:	75 05                	jne    800c8e <strchr+0x1d>
			return (char *) s;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	eb 11                	jmp    800c9f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8e:	ff 45 08             	incl   0x8(%ebp)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	84 c0                	test   %al,%al
  800c98:	75 e5                	jne    800c7f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 04             	sub    $0x4,%esp
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cad:	eb 0d                	jmp    800cbc <strfind+0x1b>
		if (*s == c)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb7:	74 0e                	je     800cc7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb9:	ff 45 08             	incl   0x8(%ebp)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 ea                	jne    800caf <strfind+0xe>
  800cc5:	eb 01                	jmp    800cc8 <strfind+0x27>
		if (*s == c)
			break;
  800cc7:	90                   	nop
	return (char *) s;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdf:	eb 0e                	jmp    800cef <memset+0x22>
		*p++ = c;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce4:	8d 50 01             	lea    0x1(%eax),%edx
  800ce7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ced:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cef:	ff 4d f8             	decl   -0x8(%ebp)
  800cf2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf6:	79 e9                	jns    800ce1 <memset+0x14>
		*p++ = c;

	return v;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0f:	eb 16                	jmp    800d27 <memcpy+0x2a>
		*d++ = *s++;
  800d11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d14:	8d 50 01             	lea    0x1(%eax),%edx
  800d17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d20:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d23:	8a 12                	mov    (%edx),%dl
  800d25:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	75 dd                	jne    800d11 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d51:	73 50                	jae    800da3 <memmove+0x6a>
  800d53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
  800d5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5e:	76 43                	jbe    800da3 <memmove+0x6a>
		s += n;
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d6c:	eb 10                	jmp    800d7e <memmove+0x45>
			*--d = *--s;
  800d6e:	ff 4d f8             	decl   -0x8(%ebp)
  800d71:	ff 4d fc             	decl   -0x4(%ebp)
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	8a 10                	mov    (%eax),%dl
  800d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d84:	89 55 10             	mov    %edx,0x10(%ebp)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	75 e3                	jne    800d6e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8b:	eb 23                	jmp    800db0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d90:	8d 50 01             	lea    0x1(%eax),%edx
  800d93:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9f:	8a 12                	mov    (%edx),%dl
  800da1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	75 dd                	jne    800d8d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc7:	eb 2a                	jmp    800df3 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	8a 10                	mov    (%eax),%dl
  800dce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	38 c2                	cmp    %al,%dl
  800dd5:	74 16                	je     800ded <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	0f b6 d0             	movzbl %al,%edx
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	0f b6 c0             	movzbl %al,%eax
  800de7:	29 c2                	sub    %eax,%edx
  800de9:	89 d0                	mov    %edx,%eax
  800deb:	eb 18                	jmp    800e05 <memcmp+0x50>
		s1++, s2++;
  800ded:	ff 45 fc             	incl   -0x4(%ebp)
  800df0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df3:	8b 45 10             	mov    0x10(%ebp),%eax
  800df6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	75 c9                	jne    800dc9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 45 10             	mov    0x10(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e18:	eb 15                	jmp    800e2f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f b6 d0             	movzbl %al,%edx
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	0f b6 c0             	movzbl %al,%eax
  800e28:	39 c2                	cmp    %eax,%edx
  800e2a:	74 0d                	je     800e39 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e2c:	ff 45 08             	incl   0x8(%ebp)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e35:	72 e3                	jb     800e1a <memfind+0x13>
  800e37:	eb 01                	jmp    800e3a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e39:	90                   	nop
	return (void *) s;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e4c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e53:	eb 03                	jmp    800e58 <strtol+0x19>
		s++;
  800e55:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	3c 20                	cmp    $0x20,%al
  800e5f:	74 f4                	je     800e55 <strtol+0x16>
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3c 09                	cmp    $0x9,%al
  800e68:	74 eb                	je     800e55 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	3c 2b                	cmp    $0x2b,%al
  800e71:	75 05                	jne    800e78 <strtol+0x39>
		s++;
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	eb 13                	jmp    800e8b <strtol+0x4c>
	else if (*s == '-')
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 2d                	cmp    $0x2d,%al
  800e7f:	75 0a                	jne    800e8b <strtol+0x4c>
		s++, neg = 1;
  800e81:	ff 45 08             	incl   0x8(%ebp)
  800e84:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8f:	74 06                	je     800e97 <strtol+0x58>
  800e91:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e95:	75 20                	jne    800eb7 <strtol+0x78>
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	3c 30                	cmp    $0x30,%al
  800e9e:	75 17                	jne    800eb7 <strtol+0x78>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	40                   	inc    %eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	3c 78                	cmp    $0x78,%al
  800ea8:	75 0d                	jne    800eb7 <strtol+0x78>
		s += 2, base = 16;
  800eaa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb5:	eb 28                	jmp    800edf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	75 15                	jne    800ed2 <strtol+0x93>
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3c 30                	cmp    $0x30,%al
  800ec4:	75 0c                	jne    800ed2 <strtol+0x93>
		s++, base = 8;
  800ec6:	ff 45 08             	incl   0x8(%ebp)
  800ec9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed0:	eb 0d                	jmp    800edf <strtol+0xa0>
	else if (base == 0)
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	75 07                	jne    800edf <strtol+0xa0>
		base = 10;
  800ed8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	3c 2f                	cmp    $0x2f,%al
  800ee6:	7e 19                	jle    800f01 <strtol+0xc2>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3c 39                	cmp    $0x39,%al
  800eef:	7f 10                	jg     800f01 <strtol+0xc2>
			dig = *s - '0';
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	0f be c0             	movsbl %al,%eax
  800ef9:	83 e8 30             	sub    $0x30,%eax
  800efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eff:	eb 42                	jmp    800f43 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	3c 60                	cmp    $0x60,%al
  800f08:	7e 19                	jle    800f23 <strtol+0xe4>
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 7a                	cmp    $0x7a,%al
  800f11:	7f 10                	jg     800f23 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f be c0             	movsbl %al,%eax
  800f1b:	83 e8 57             	sub    $0x57,%eax
  800f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f21:	eb 20                	jmp    800f43 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 40                	cmp    $0x40,%al
  800f2a:	7e 39                	jle    800f65 <strtol+0x126>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 5a                	cmp    $0x5a,%al
  800f33:	7f 30                	jg     800f65 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	0f be c0             	movsbl %al,%eax
  800f3d:	83 e8 37             	sub    $0x37,%eax
  800f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f46:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f49:	7d 19                	jge    800f64 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f55:	89 c2                	mov    %eax,%edx
  800f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5f:	e9 7b ff ff ff       	jmp    800edf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f64:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f69:	74 08                	je     800f73 <strtol+0x134>
		*endptr = (char *) s;
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f73:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f77:	74 07                	je     800f80 <strtol+0x141>
  800f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7c:	f7 d8                	neg    %eax
  800f7e:	eb 03                	jmp    800f83 <strtol+0x144>
  800f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <ltostr>:

void
ltostr(long value, char *str)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f92:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9d:	79 13                	jns    800fb2 <ltostr+0x2d>
	{
		neg = 1;
  800f9f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800faf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fba:	99                   	cltd   
  800fbb:	f7 f9                	idiv   %ecx
  800fbd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc9:	89 c2                	mov    %eax,%edx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	01 d0                	add    %edx,%eax
  800fd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd3:	83 c2 30             	add    $0x30,%edx
  800fd6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fdb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe0:	f7 e9                	imul   %ecx
  800fe2:	c1 fa 02             	sar    $0x2,%edx
  800fe5:	89 c8                	mov    %ecx,%eax
  800fe7:	c1 f8 1f             	sar    $0x1f,%eax
  800fea:	29 c2                	sub    %eax,%edx
  800fec:	89 d0                	mov    %edx,%eax
  800fee:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ff1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff9:	f7 e9                	imul   %ecx
  800ffb:	c1 fa 02             	sar    $0x2,%edx
  800ffe:	89 c8                	mov    %ecx,%eax
  801000:	c1 f8 1f             	sar    $0x1f,%eax
  801003:	29 c2                	sub    %eax,%edx
  801005:	89 d0                	mov    %edx,%eax
  801007:	c1 e0 02             	shl    $0x2,%eax
  80100a:	01 d0                	add    %edx,%eax
  80100c:	01 c0                	add    %eax,%eax
  80100e:	29 c1                	sub    %eax,%ecx
  801010:	89 ca                	mov    %ecx,%edx
  801012:	85 d2                	test   %edx,%edx
  801014:	75 9c                	jne    800fb2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801020:	48                   	dec    %eax
  801021:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801024:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801028:	74 3d                	je     801067 <ltostr+0xe2>
		start = 1 ;
  80102a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801031:	eb 34                	jmp    801067 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	01 c2                	add    %eax,%edx
  801048:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	01 c8                	add    %ecx,%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	01 c2                	add    %eax,%edx
  80105c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105f:	88 02                	mov    %al,(%edx)
		start++ ;
  801061:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801064:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106d:	7c c4                	jl     801033 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80107a:	90                   	nop
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801083:	ff 75 08             	pushl  0x8(%ebp)
  801086:	e8 54 fa ff ff       	call   800adf <strlen>
  80108b:	83 c4 04             	add    $0x4,%esp
  80108e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801091:	ff 75 0c             	pushl  0xc(%ebp)
  801094:	e8 46 fa ff ff       	call   800adf <strlen>
  801099:	83 c4 04             	add    $0x4,%esp
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ad:	eb 17                	jmp    8010c6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	01 c8                	add    %ecx,%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c3:	ff 45 fc             	incl   -0x4(%ebp)
  8010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010cc:	7c e1                	jl     8010af <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010dc:	eb 1f                	jmp    8010fd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e1:	8d 50 01             	lea    0x1(%eax),%edx
  8010e4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e7:	89 c2                	mov    %eax,%edx
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	01 c2                	add    %eax,%edx
  8010ee:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	01 c8                	add    %ecx,%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010fa:	ff 45 f8             	incl   -0x8(%ebp)
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801100:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801103:	7c d9                	jl     8010de <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	01 d0                	add    %edx,%eax
  80110d:	c6 00 00             	movb   $0x0,(%eax)
}
  801110:	90                   	nop
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801116:	8b 45 14             	mov    0x14(%ebp),%eax
  801119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111f:	8b 45 14             	mov    0x14(%ebp),%eax
  801122:	8b 00                	mov    (%eax),%eax
  801124:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801136:	eb 0c                	jmp    801144 <strsplit+0x31>
			*string++ = 0;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8d 50 01             	lea    0x1(%eax),%edx
  80113e:	89 55 08             	mov    %edx,0x8(%ebp)
  801141:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	74 18                	je     801165 <strsplit+0x52>
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f be c0             	movsbl %al,%eax
  801155:	50                   	push   %eax
  801156:	ff 75 0c             	pushl  0xc(%ebp)
  801159:	e8 13 fb ff ff       	call   800c71 <strchr>
  80115e:	83 c4 08             	add    $0x8,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	75 d3                	jne    801138 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	84 c0                	test   %al,%al
  80116c:	74 5a                	je     8011c8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116e:	8b 45 14             	mov    0x14(%ebp),%eax
  801171:	8b 00                	mov    (%eax),%eax
  801173:	83 f8 0f             	cmp    $0xf,%eax
  801176:	75 07                	jne    80117f <strsplit+0x6c>
		{
			return 0;
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
  80117d:	eb 66                	jmp    8011e5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117f:	8b 45 14             	mov    0x14(%ebp),%eax
  801182:	8b 00                	mov    (%eax),%eax
  801184:	8d 48 01             	lea    0x1(%eax),%ecx
  801187:	8b 55 14             	mov    0x14(%ebp),%edx
  80118a:	89 0a                	mov    %ecx,(%edx)
  80118c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	01 c2                	add    %eax,%edx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119d:	eb 03                	jmp    8011a2 <strsplit+0x8f>
			string++;
  80119f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	84 c0                	test   %al,%al
  8011a9:	74 8b                	je     801136 <strsplit+0x23>
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	0f be c0             	movsbl %al,%eax
  8011b3:	50                   	push   %eax
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	e8 b5 fa ff ff       	call   800c71 <strchr>
  8011bc:	83 c4 08             	add    $0x8,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	74 dc                	je     80119f <strsplit+0x8c>
			string++;
	}
  8011c3:	e9 6e ff ff ff       	jmp    801136 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	8b 00                	mov    (%eax),%eax
  8011ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011e0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8011ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011f4:	eb 4c                	jmp    801242 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8011f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 40                	cmp    $0x40,%al
  801202:	7e 27                	jle    80122b <str2lower+0x44>
  801204:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 5a                	cmp    $0x5a,%al
  801210:	7f 19                	jg     80122b <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801220:	01 ca                	add    %ecx,%edx
  801222:	8a 12                	mov    (%edx),%dl
  801224:	83 c2 20             	add    $0x20,%edx
  801227:	88 10                	mov    %dl,(%eax)
  801229:	eb 14                	jmp    80123f <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80122b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	01 c2                	add    %eax,%edx
  801233:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801236:	8b 45 0c             	mov    0xc(%ebp),%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80123f:	ff 45 fc             	incl   -0x4(%ebp)
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	e8 95 f8 ff ff       	call   800adf <strlen>
  80124a:	83 c4 04             	add    $0x4,%esp
  80124d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801250:	7f a4                	jg     8011f6 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801271:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801277:	8b 7d 18             	mov    0x18(%ebp),%edi
  80127a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80127d:	cd 30                	int    $0x30
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801299:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	50                   	push   %eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 b2 ff ff ff       	call   801262 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 01                	push   $0x1
  8012c5:	e8 98 ff ff ff       	call   801262 <syscall>
  8012ca:	83 c4 18             	add    $0x18,%esp
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	52                   	push   %edx
  8012df:	50                   	push   %eax
  8012e0:	6a 05                	push   $0x5
  8012e2:	e8 7b ff ff ff       	call   801262 <syscall>
  8012e7:	83 c4 18             	add    $0x18,%esp
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	51                   	push   %ecx
  801303:	52                   	push   %edx
  801304:	50                   	push   %eax
  801305:	6a 06                	push   $0x6
  801307:	e8 56 ff ff ff       	call   801262 <syscall>
  80130c:	83 c4 18             	add    $0x18,%esp
}
  80130f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	52                   	push   %edx
  801326:	50                   	push   %eax
  801327:	6a 07                	push   $0x7
  801329:	e8 34 ff ff ff       	call   801262 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	ff 75 0c             	pushl  0xc(%ebp)
  80133f:	ff 75 08             	pushl  0x8(%ebp)
  801342:	6a 08                	push   $0x8
  801344:	e8 19 ff ff ff       	call   801262 <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 09                	push   $0x9
  80135d:	e8 00 ff ff ff       	call   801262 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 0a                	push   $0xa
  801376:	e8 e7 fe ff ff       	call   801262 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 0b                	push   $0xb
  80138f:	e8 ce fe ff ff       	call   801262 <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 0c                	push   $0xc
  8013a8:	e8 b5 fe ff ff       	call   801262 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	ff 75 08             	pushl  0x8(%ebp)
  8013c0:	6a 0d                	push   $0xd
  8013c2:	e8 9b fe ff ff       	call   801262 <syscall>
  8013c7:	83 c4 18             	add    $0x18,%esp
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 0e                	push   $0xe
  8013db:	e8 82 fe ff ff       	call   801262 <syscall>
  8013e0:	83 c4 18             	add    $0x18,%esp
}
  8013e3:	90                   	nop
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 11                	push   $0x11
  8013f5:	e8 68 fe ff ff       	call   801262 <syscall>
  8013fa:	83 c4 18             	add    $0x18,%esp
}
  8013fd:	90                   	nop
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 12                	push   $0x12
  80140f:	e8 4e fe ff ff       	call   801262 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	90                   	nop
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_cputc>:


void
sys_cputc(const char c)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801426:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	50                   	push   %eax
  801433:	6a 13                	push   $0x13
  801435:	e8 28 fe ff ff       	call   801262 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 14                	push   $0x14
  80144f:	e8 0e fe ff ff       	call   801262 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	50                   	push   %eax
  80146a:	6a 15                	push   $0x15
  80146c:	e8 f1 fd ff ff       	call   801262 <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	52                   	push   %edx
  801486:	50                   	push   %eax
  801487:	6a 18                	push   $0x18
  801489:	e8 d4 fd ff ff       	call   801262 <syscall>
  80148e:	83 c4 18             	add    $0x18,%esp
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801496:	8b 55 0c             	mov    0xc(%ebp),%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	52                   	push   %edx
  8014a3:	50                   	push   %eax
  8014a4:	6a 16                	push   $0x16
  8014a6:	e8 b7 fd ff ff       	call   801262 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	52                   	push   %edx
  8014c1:	50                   	push   %eax
  8014c2:	6a 17                	push   $0x17
  8014c4:	e8 99 fd ff ff       	call   801262 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	90                   	nop
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	51                   	push   %ecx
  8014e8:	52                   	push   %edx
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	50                   	push   %eax
  8014ed:	6a 19                	push   $0x19
  8014ef:	e8 6e fd ff ff       	call   801262 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	52                   	push   %edx
  801509:	50                   	push   %eax
  80150a:	6a 1a                	push   $0x1a
  80150c:	e8 51 fd ff ff       	call   801262 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801519:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	51                   	push   %ecx
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	6a 1b                	push   $0x1b
  80152b:	e8 32 fd ff ff       	call   801262 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 1c                	push   $0x1c
  801548:	e8 15 fd ff ff       	call   801262 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 1d                	push   $0x1d
  801561:	e8 fc fc ff ff       	call   801262 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	6a 00                	push   $0x0
  801573:	ff 75 14             	pushl  0x14(%ebp)
  801576:	ff 75 10             	pushl  0x10(%ebp)
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	50                   	push   %eax
  80157d:	6a 1e                	push   $0x1e
  80157f:	e8 de fc ff ff       	call   801262 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	50                   	push   %eax
  801598:	6a 1f                	push   $0x1f
  80159a:	e8 c3 fc ff ff       	call   801262 <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	90                   	nop
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	50                   	push   %eax
  8015b4:	6a 20                	push   $0x20
  8015b6:	e8 a7 fc ff ff       	call   801262 <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 02                	push   $0x2
  8015cf:	e8 8e fc ff ff       	call   801262 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 03                	push   $0x3
  8015e8:	e8 75 fc ff ff       	call   801262 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 04                	push   $0x4
  801601:	e8 5c fc ff ff       	call   801262 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_exit_env>:


void sys_exit_env(void)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 21                	push   $0x21
  80161a:	e8 43 fc ff ff       	call   801262 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	90                   	nop
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80162b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80162e:	8d 50 04             	lea    0x4(%eax),%edx
  801631:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	52                   	push   %edx
  80163b:	50                   	push   %eax
  80163c:	6a 22                	push   $0x22
  80163e:	e8 1f fc ff ff       	call   801262 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
	return result;
  801646:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801649:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164f:	89 01                	mov    %eax,(%ecx)
  801651:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	c9                   	leave  
  801658:	c2 04 00             	ret    $0x4

0080165b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	ff 75 10             	pushl  0x10(%ebp)
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	6a 10                	push   $0x10
  80166d:	e8 f0 fb ff ff       	call   801262 <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
	return ;
  801675:	90                   	nop
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_rcr2>:
uint32 sys_rcr2()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 23                	push   $0x23
  801687:	e8 d6 fb ff ff       	call   801262 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80169d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	50                   	push   %eax
  8016aa:	6a 24                	push   $0x24
  8016ac:	e8 b1 fb ff ff       	call   801262 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b4:	90                   	nop
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <rsttst>:
void rsttst()
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 26                	push   $0x26
  8016c6:	e8 97 fb ff ff       	call   801262 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ce:	90                   	nop
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016dd:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	ff 75 10             	pushl  0x10(%ebp)
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	ff 75 08             	pushl  0x8(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	e8 6c fb ff ff       	call   801262 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f9:	90                   	nop
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <chktst>:
void chktst(uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	6a 27                	push   $0x27
  80170c:	e8 51 fb ff ff       	call   801262 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
	return ;
  801714:	90                   	nop
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <inctst>:

void inctst()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 28                	push   $0x28
  801726:	e8 37 fb ff ff       	call   801262 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
	return ;
  80172e:	90                   	nop
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <gettst>:
uint32 gettst()
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 29                	push   $0x29
  801740:	e8 1d fb ff ff       	call   801262 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 2a                	push   $0x2a
  80175c:	e8 01 fb ff ff       	call   801262 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
  801764:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801767:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80176b:	75 07                	jne    801774 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	eb 05                	jmp    801779 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 2a                	push   $0x2a
  80178d:	e8 d0 fa ff ff       	call   801262 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
  801795:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801798:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80179c:	75 07                	jne    8017a5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80179e:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a3:	eb 05                	jmp    8017aa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 2a                	push   $0x2a
  8017be:	e8 9f fa ff ff       	call   801262 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
  8017c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017c9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017cd:	75 07                	jne    8017d6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d4:	eb 05                	jmp    8017db <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 2a                	push   $0x2a
  8017ef:	e8 6e fa ff ff       	call   801262 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
  8017f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017fa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017fe:	75 07                	jne    801807 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801800:	b8 01 00 00 00       	mov    $0x1,%eax
  801805:	eb 05                	jmp    80180c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	6a 2b                	push   $0x2b
  80181e:	e8 3f fa ff ff       	call   801262 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
	return ;
  801826:	90                   	nop
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80182d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	8b 55 0c             	mov    0xc(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	53                   	push   %ebx
  80183c:	51                   	push   %ecx
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 2c                	push   $0x2c
  801841:	e8 1c fa ff ff       	call   801262 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	6a 2d                	push   $0x2d
  801861:	e8 fc f9 ff ff       	call   801262 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80186e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	51                   	push   %ecx
  80187a:	ff 75 10             	pushl  0x10(%ebp)
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 2e                	push   $0x2e
  801881:	e8 dc f9 ff ff       	call   801262 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	ff 75 10             	pushl  0x10(%ebp)
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	6a 0f                	push   $0xf
  80189d:	e8 c0 f9 ff ff       	call   801262 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a5:	90                   	nop
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	50                   	push   %eax
  8018b7:	6a 2f                	push   $0x2f
  8018b9:	e8 a4 f9 ff ff       	call   801262 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp

}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	6a 30                	push   $0x30
  8018d4:	e8 89 f9 ff ff       	call   801262 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp

}
  8018dc:	90                   	nop
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 31                	push   $0x31
  8018f0:	e8 6d f9 ff ff       	call   801262 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_hard_limit>:
uint32 sys_hard_limit(){
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 32                	push   $0x32
  80190a:	e8 53 f9 ff ff       	call   801262 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

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
