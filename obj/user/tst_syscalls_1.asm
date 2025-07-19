
obj/user/tst_syscalls_1:     file format elf32-i386


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
  800031:	e8 8a 00 00 00       	call   8000c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct implementation of system calls
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 cb 16 00 00       	call   80170e <rsttst>
	void * ret = sys_sbrk(10);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 0a                	push   $0xa
  800048:	e8 b2 18 00 00       	call   8018ff <sys_sbrk>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (ret != (void*)-1)
  800053:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  800057:	74 14                	je     80006d <_main+0x35>
		panic("tst system calls #1 failed: sys_sbrk is not handled correctly");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 e0 1b 80 00       	push   $0x801be0
  800061:	6a 0a                	push   $0xa
  800063:	68 1e 1c 80 00       	push   $0x801c1e
  800068:	e8 8a 01 00 00       	call   8001f7 <_panic>
	sys_allocate_user_mem(100,10);
  80006d:	83 ec 08             	sub    $0x8,%esp
  800070:	6a 0a                	push   $0xa
  800072:	6a 64                	push   $0x64
  800074:	e8 bd 18 00 00       	call   801936 <sys_allocate_user_mem>
  800079:	83 c4 10             	add    $0x10,%esp
	sys_free_user_mem(100, 10);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	6a 0a                	push   $0xa
  800081:	6a 64                	push   $0x64
  800083:	e8 92 18 00 00       	call   80191a <sys_free_user_mem>
  800088:	83 c4 10             	add    $0x10,%esp
	int ret2 = gettst();
  80008b:	e8 f8 16 00 00       	call   801788 <gettst>
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret2 != 2)
  800093:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800097:	74 14                	je     8000ad <_main+0x75>
		panic("tst system calls #1 failed: sys_allocate_user_mem and/or sys_free_user_mem are not handled correctly");
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 34 1c 80 00       	push   $0x801c34
  8000a1:	6a 0f                	push   $0xf
  8000a3:	68 1e 1c 80 00       	push   $0x801c1e
  8000a8:	e8 4a 01 00 00       	call   8001f7 <_panic>
	cprintf("Congratulations... tst system calls #1 completed successfully");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 9c 1c 80 00       	push   $0x801c9c
  8000b5:	e8 fa 03 00 00       	call   8004b4 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
}
  8000bd:	90                   	nop
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c6:	e8 65 15 00 00       	call   801630 <sys_getenvindex>
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d1:	89 d0                	mov    %edx,%eax
  8000d3:	c1 e0 03             	shl    $0x3,%eax
  8000d6:	01 d0                	add    %edx,%eax
  8000d8:	01 c0                	add    %eax,%eax
  8000da:	01 d0                	add    %edx,%eax
  8000dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000e3:	01 d0                	add    %edx,%eax
  8000e5:	c1 e0 04             	shl    $0x4,%eax
  8000e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ed:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f7:	8a 40 5c             	mov    0x5c(%eax),%al
  8000fa:	84 c0                	test   %al,%al
  8000fc:	74 0d                	je     80010b <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800103:	83 c0 5c             	add    $0x5c,%eax
  800106:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010f:	7e 0a                	jle    80011b <libmain+0x5b>
		binaryname = argv[0];
  800111:	8b 45 0c             	mov    0xc(%ebp),%eax
  800114:	8b 00                	mov    (%eax),%eax
  800116:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	ff 75 0c             	pushl  0xc(%ebp)
  800121:	ff 75 08             	pushl  0x8(%ebp)
  800124:	e8 0f ff ff ff       	call   800038 <_main>
  800129:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80012c:	e8 0c 13 00 00       	call   80143d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800131:	83 ec 0c             	sub    $0xc,%esp
  800134:	68 f4 1c 80 00       	push   $0x801cf4
  800139:	e8 76 03 00 00       	call   8004b4 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800141:	a1 20 30 80 00       	mov    0x803020,%eax
  800146:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	52                   	push   %edx
  80015b:	50                   	push   %eax
  80015c:	68 1c 1d 80 00       	push   $0x801d1c
  800161:	e8 4e 03 00 00       	call   8004b4 <cprintf>
  800166:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800169:	a1 20 30 80 00       	mov    0x803020,%eax
  80016e:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800174:	a1 20 30 80 00       	mov    0x803020,%eax
  800179:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80018a:	51                   	push   %ecx
  80018b:	52                   	push   %edx
  80018c:	50                   	push   %eax
  80018d:	68 44 1d 80 00       	push   $0x801d44
  800192:	e8 1d 03 00 00       	call   8004b4 <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001a5:	83 ec 08             	sub    $0x8,%esp
  8001a8:	50                   	push   %eax
  8001a9:	68 9c 1d 80 00       	push   $0x801d9c
  8001ae:	e8 01 03 00 00       	call   8004b4 <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 f4 1c 80 00       	push   $0x801cf4
  8001be:	e8 f1 02 00 00       	call   8004b4 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001c6:	e8 8c 12 00 00       	call   801457 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001cb:	e8 19 00 00 00       	call   8001e9 <exit>
}
  8001d0:	90                   	nop
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	6a 00                	push   $0x0
  8001de:	e8 19 14 00 00       	call   8015fc <sys_destroy_env>
  8001e3:	83 c4 10             	add    $0x10,%esp
}
  8001e6:	90                   	nop
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <exit>:

void
exit(void)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ef:	e8 6e 14 00 00       	call   801662 <sys_exit_env>
}
  8001f4:	90                   	nop
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001fd:	8d 45 10             	lea    0x10(%ebp),%eax
  800200:	83 c0 04             	add    $0x4,%eax
  800203:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800206:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	74 16                	je     800225 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80020f:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 b0 1d 80 00       	push   $0x801db0
  80021d:	e8 92 02 00 00       	call   8004b4 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800225:	a1 00 30 80 00       	mov    0x803000,%eax
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	50                   	push   %eax
  800231:	68 b5 1d 80 00       	push   $0x801db5
  800236:	e8 79 02 00 00       	call   8004b4 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80023e:	8b 45 10             	mov    0x10(%ebp),%eax
  800241:	83 ec 08             	sub    $0x8,%esp
  800244:	ff 75 f4             	pushl  -0xc(%ebp)
  800247:	50                   	push   %eax
  800248:	e8 fc 01 00 00       	call   800449 <vcprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800250:	83 ec 08             	sub    $0x8,%esp
  800253:	6a 00                	push   $0x0
  800255:	68 d1 1d 80 00       	push   $0x801dd1
  80025a:	e8 ea 01 00 00       	call   800449 <vcprintf>
  80025f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800262:	e8 82 ff ff ff       	call   8001e9 <exit>

	// should not return here
	while (1) ;
  800267:	eb fe                	jmp    800267 <_panic+0x70>

00800269 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80026f:	a1 20 30 80 00       	mov    0x803020,%eax
  800274:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	39 c2                	cmp    %eax,%edx
  80027f:	74 14                	je     800295 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	68 d4 1d 80 00       	push   $0x801dd4
  800289:	6a 26                	push   $0x26
  80028b:	68 20 1e 80 00       	push   $0x801e20
  800290:	e8 62 ff ff ff       	call   8001f7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800295:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80029c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002a3:	e9 c5 00 00 00       	jmp    80036d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b5:	01 d0                	add    %edx,%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	75 08                	jne    8002c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002c0:	e9 a5 00 00 00       	jmp    80036a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d3:	eb 69                	jmp    80033e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	c1 e0 03             	shl    $0x3,%eax
  8002ec:	01 c8                	add    %ecx,%eax
  8002ee:	8a 40 04             	mov    0x4(%eax),%al
  8002f1:	84 c0                	test   %al,%al
  8002f3:	75 46                	jne    80033b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002fa:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800300:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800303:	89 d0                	mov    %edx,%eax
  800305:	01 c0                	add    %eax,%eax
  800307:	01 d0                	add    %edx,%eax
  800309:	c1 e0 03             	shl    $0x3,%eax
  80030c:	01 c8                	add    %ecx,%eax
  80030e:	8b 00                	mov    (%eax),%eax
  800310:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800313:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800316:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80031b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80031d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800320:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 c8                	add    %ecx,%eax
  80032c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80032e:	39 c2                	cmp    %eax,%edx
  800330:	75 09                	jne    80033b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800332:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800339:	eb 15                	jmp    800350 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033b:	ff 45 e8             	incl   -0x18(%ebp)
  80033e:	a1 20 30 80 00       	mov    0x803020,%eax
  800343:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80034c:	39 c2                	cmp    %eax,%edx
  80034e:	77 85                	ja     8002d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800350:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800354:	75 14                	jne    80036a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 2c 1e 80 00       	push   $0x801e2c
  80035e:	6a 3a                	push   $0x3a
  800360:	68 20 1e 80 00       	push   $0x801e20
  800365:	e8 8d fe ff ff       	call   8001f7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80036a:	ff 45 f0             	incl   -0x10(%ebp)
  80036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800370:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800373:	0f 8c 2f ff ff ff    	jl     8002a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800379:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800380:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800387:	eb 26                	jmp    8003af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800389:	a1 20 30 80 00       	mov    0x803020,%eax
  80038e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800394:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800397:	89 d0                	mov    %edx,%eax
  800399:	01 c0                	add    %eax,%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 03             	shl    $0x3,%eax
  8003a0:	01 c8                	add    %ecx,%eax
  8003a2:	8a 40 04             	mov    0x4(%eax),%al
  8003a5:	3c 01                	cmp    $0x1,%al
  8003a7:	75 03                	jne    8003ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ac:	ff 45 e0             	incl   -0x20(%ebp)
  8003af:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b4:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8003ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	77 c8                	ja     800389 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c7:	74 14                	je     8003dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	68 80 1e 80 00       	push   $0x801e80
  8003d1:	6a 44                	push   $0x44
  8003d3:	68 20 1e 80 00       	push   $0x801e20
  8003d8:	e8 1a fe ff ff       	call   8001f7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003dd:	90                   	nop
  8003de:	c9                   	leave  
  8003df:	c3                   	ret    

008003e0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f1:	89 0a                	mov    %ecx,(%edx)
  8003f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f6:	88 d1                	mov    %dl,%cl
  8003f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	3d ff 00 00 00       	cmp    $0xff,%eax
  800409:	75 2c                	jne    800437 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80040b:	a0 24 30 80 00       	mov    0x803024,%al
  800410:	0f b6 c0             	movzbl %al,%eax
  800413:	8b 55 0c             	mov    0xc(%ebp),%edx
  800416:	8b 12                	mov    (%edx),%edx
  800418:	89 d1                	mov    %edx,%ecx
  80041a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041d:	83 c2 08             	add    $0x8,%edx
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	50                   	push   %eax
  800424:	51                   	push   %ecx
  800425:	52                   	push   %edx
  800426:	e8 b9 0e 00 00       	call   8012e4 <sys_cputs>
  80042b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80042e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043a:	8b 40 04             	mov    0x4(%eax),%eax
  80043d:	8d 50 01             	lea    0x1(%eax),%edx
  800440:	8b 45 0c             	mov    0xc(%ebp),%eax
  800443:	89 50 04             	mov    %edx,0x4(%eax)
}
  800446:	90                   	nop
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800452:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800459:	00 00 00 
	b.cnt = 0;
  80045c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800463:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800466:	ff 75 0c             	pushl  0xc(%ebp)
  800469:	ff 75 08             	pushl  0x8(%ebp)
  80046c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800472:	50                   	push   %eax
  800473:	68 e0 03 80 00       	push   $0x8003e0
  800478:	e8 11 02 00 00       	call   80068e <vprintfmt>
  80047d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800480:	a0 24 30 80 00       	mov    0x803024,%al
  800485:	0f b6 c0             	movzbl %al,%eax
  800488:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	50                   	push   %eax
  800492:	52                   	push   %edx
  800493:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800499:	83 c0 08             	add    $0x8,%eax
  80049c:	50                   	push   %eax
  80049d:	e8 42 0e 00 00       	call   8012e4 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004a5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004ba:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8004c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d0:	50                   	push   %eax
  8004d1:	e8 73 ff ff ff       	call   800449 <vcprintf>
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004e7:	e8 51 0f 00 00       	call   80143d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fb:	50                   	push   %eax
  8004fc:	e8 48 ff ff ff       	call   800449 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800507:	e8 4b 0f 00 00       	call   801457 <sys_enable_interrupt>
	return cnt;
  80050c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	53                   	push   %ebx
  800515:	83 ec 14             	sub    $0x14,%esp
  800518:	8b 45 10             	mov    0x10(%ebp),%eax
  80051b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800524:	8b 45 18             	mov    0x18(%ebp),%eax
  800527:	ba 00 00 00 00       	mov    $0x0,%edx
  80052c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80052f:	77 55                	ja     800586 <printnum+0x75>
  800531:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800534:	72 05                	jb     80053b <printnum+0x2a>
  800536:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800539:	77 4b                	ja     800586 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80053b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80053e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800541:	8b 45 18             	mov    0x18(%ebp),%eax
  800544:	ba 00 00 00 00       	mov    $0x0,%edx
  800549:	52                   	push   %edx
  80054a:	50                   	push   %eax
  80054b:	ff 75 f4             	pushl  -0xc(%ebp)
  80054e:	ff 75 f0             	pushl  -0x10(%ebp)
  800551:	e8 16 14 00 00       	call   80196c <__udivdi3>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	ff 75 20             	pushl  0x20(%ebp)
  80055f:	53                   	push   %ebx
  800560:	ff 75 18             	pushl  0x18(%ebp)
  800563:	52                   	push   %edx
  800564:	50                   	push   %eax
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	ff 75 08             	pushl  0x8(%ebp)
  80056b:	e8 a1 ff ff ff       	call   800511 <printnum>
  800570:	83 c4 20             	add    $0x20,%esp
  800573:	eb 1a                	jmp    80058f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 0c             	pushl  0xc(%ebp)
  80057b:	ff 75 20             	pushl  0x20(%ebp)
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	ff d0                	call   *%eax
  800583:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800586:	ff 4d 1c             	decl   0x1c(%ebp)
  800589:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80058d:	7f e6                	jg     800575 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80058f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800592:	bb 00 00 00 00       	mov    $0x0,%ebx
  800597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80059d:	53                   	push   %ebx
  80059e:	51                   	push   %ecx
  80059f:	52                   	push   %edx
  8005a0:	50                   	push   %eax
  8005a1:	e8 d6 14 00 00       	call   801a7c <__umoddi3>
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	05 f4 20 80 00       	add    $0x8020f4,%eax
  8005ae:	8a 00                	mov    (%eax),%al
  8005b0:	0f be c0             	movsbl %al,%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	ff d0                	call   *%eax
  8005bf:	83 c4 10             	add    $0x10,%esp
}
  8005c2:	90                   	nop
  8005c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005cf:	7e 1c                	jle    8005ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	8d 50 08             	lea    0x8(%eax),%edx
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	89 10                	mov    %edx,(%eax)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	83 e8 08             	sub    $0x8,%eax
  8005e6:	8b 50 04             	mov    0x4(%eax),%edx
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	eb 40                	jmp    80062d <getuint+0x65>
	else if (lflag)
  8005ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f1:	74 1e                	je     800611 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	8d 50 04             	lea    0x4(%eax),%edx
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	89 10                	mov    %edx,(%eax)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	83 e8 04             	sub    $0x4,%eax
  800608:	8b 00                	mov    (%eax),%eax
  80060a:	ba 00 00 00 00       	mov    $0x0,%edx
  80060f:	eb 1c                	jmp    80062d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	8d 50 04             	lea    0x4(%eax),%edx
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	89 10                	mov    %edx,(%eax)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80062d:	5d                   	pop    %ebp
  80062e:	c3                   	ret    

0080062f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80062f:	55                   	push   %ebp
  800630:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800632:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800636:	7e 1c                	jle    800654 <getint+0x25>
		return va_arg(*ap, long long);
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	8d 50 08             	lea    0x8(%eax),%edx
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	89 10                	mov    %edx,(%eax)
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	83 e8 08             	sub    $0x8,%eax
  80064d:	8b 50 04             	mov    0x4(%eax),%edx
  800650:	8b 00                	mov    (%eax),%eax
  800652:	eb 38                	jmp    80068c <getint+0x5d>
	else if (lflag)
  800654:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800658:	74 1a                	je     800674 <getint+0x45>
		return va_arg(*ap, long);
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	8d 50 04             	lea    0x4(%eax),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	89 10                	mov    %edx,(%eax)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	8b 00                	mov    (%eax),%eax
  80066c:	83 e8 04             	sub    $0x4,%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	99                   	cltd   
  800672:	eb 18                	jmp    80068c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	8d 50 04             	lea    0x4(%eax),%edx
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	89 10                	mov    %edx,(%eax)
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	83 e8 04             	sub    $0x4,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	99                   	cltd   
}
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    

0080068e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	56                   	push   %esi
  800692:	53                   	push   %ebx
  800693:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800696:	eb 17                	jmp    8006af <vprintfmt+0x21>
			if (ch == '\0')
  800698:	85 db                	test   %ebx,%ebx
  80069a:	0f 84 af 03 00 00    	je     800a4f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006af:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8006b8:	8a 00                	mov    (%eax),%al
  8006ba:	0f b6 d8             	movzbl %al,%ebx
  8006bd:	83 fb 25             	cmp    $0x25,%ebx
  8006c0:	75 d6                	jne    800698 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8006c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e5:	8d 50 01             	lea    0x1(%eax),%edx
  8006e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8006eb:	8a 00                	mov    (%eax),%al
  8006ed:	0f b6 d8             	movzbl %al,%ebx
  8006f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006f3:	83 f8 55             	cmp    $0x55,%eax
  8006f6:	0f 87 2b 03 00 00    	ja     800a27 <vprintfmt+0x399>
  8006fc:	8b 04 85 18 21 80 00 	mov    0x802118(,%eax,4),%eax
  800703:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800705:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800709:	eb d7                	jmp    8006e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80070b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80070f:	eb d1                	jmp    8006e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800711:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800718:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80071b:	89 d0                	mov    %edx,%eax
  80071d:	c1 e0 02             	shl    $0x2,%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	01 c0                	add    %eax,%eax
  800724:	01 d8                	add    %ebx,%eax
  800726:	83 e8 30             	sub    $0x30,%eax
  800729:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800734:	83 fb 2f             	cmp    $0x2f,%ebx
  800737:	7e 3e                	jle    800777 <vprintfmt+0xe9>
  800739:	83 fb 39             	cmp    $0x39,%ebx
  80073c:	7f 39                	jg     800777 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80073e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800741:	eb d5                	jmp    800718 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	83 c0 04             	add    $0x4,%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	83 e8 04             	sub    $0x4,%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800757:	eb 1f                	jmp    800778 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800759:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075d:	79 83                	jns    8006e2 <vprintfmt+0x54>
				width = 0;
  80075f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800766:	e9 77 ff ff ff       	jmp    8006e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80076b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800772:	e9 6b ff ff ff       	jmp    8006e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800777:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800778:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077c:	0f 89 60 ff ff ff    	jns    8006e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800788:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80078f:	e9 4e ff ff ff       	jmp    8006e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800794:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800797:	e9 46 ff ff ff       	jmp    8006e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	83 c0 04             	add    $0x4,%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	83 e8 04             	sub    $0x4,%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
			break;
  8007bc:	e9 89 02 00 00       	jmp    800a4a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007d2:	85 db                	test   %ebx,%ebx
  8007d4:	79 02                	jns    8007d8 <vprintfmt+0x14a>
				err = -err;
  8007d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007d8:	83 fb 64             	cmp    $0x64,%ebx
  8007db:	7f 0b                	jg     8007e8 <vprintfmt+0x15a>
  8007dd:	8b 34 9d 60 1f 80 00 	mov    0x801f60(,%ebx,4),%esi
  8007e4:	85 f6                	test   %esi,%esi
  8007e6:	75 19                	jne    800801 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007e8:	53                   	push   %ebx
  8007e9:	68 05 21 80 00       	push   $0x802105
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 5e 02 00 00       	call   800a57 <printfmt>
  8007f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007fc:	e9 49 02 00 00       	jmp    800a4a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800801:	56                   	push   %esi
  800802:	68 0e 21 80 00       	push   $0x80210e
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 45 02 00 00       	call   800a57 <printfmt>
  800812:	83 c4 10             	add    $0x10,%esp
			break;
  800815:	e9 30 02 00 00       	jmp    800a4a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 c0 04             	add    $0x4,%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	83 e8 04             	sub    $0x4,%eax
  800829:	8b 30                	mov    (%eax),%esi
  80082b:	85 f6                	test   %esi,%esi
  80082d:	75 05                	jne    800834 <vprintfmt+0x1a6>
				p = "(null)";
  80082f:	be 11 21 80 00       	mov    $0x802111,%esi
			if (width > 0 && padc != '-')
  800834:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800838:	7e 6d                	jle    8008a7 <vprintfmt+0x219>
  80083a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80083e:	74 67                	je     8008a7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	50                   	push   %eax
  800847:	56                   	push   %esi
  800848:	e8 0c 03 00 00       	call   800b59 <strnlen>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800853:	eb 16                	jmp    80086b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800855:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	50                   	push   %eax
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	ff d0                	call   *%eax
  800865:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800868:	ff 4d e4             	decl   -0x1c(%ebp)
  80086b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086f:	7f e4                	jg     800855 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800871:	eb 34                	jmp    8008a7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800873:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800877:	74 1c                	je     800895 <vprintfmt+0x207>
  800879:	83 fb 1f             	cmp    $0x1f,%ebx
  80087c:	7e 05                	jle    800883 <vprintfmt+0x1f5>
  80087e:	83 fb 7e             	cmp    $0x7e,%ebx
  800881:	7e 12                	jle    800895 <vprintfmt+0x207>
					putch('?', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	6a 3f                	push   $0x3f
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	eb 0f                	jmp    8008a4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	53                   	push   %ebx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	ff d0                	call   *%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008a7:	89 f0                	mov    %esi,%eax
  8008a9:	8d 70 01             	lea    0x1(%eax),%esi
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f be d8             	movsbl %al,%ebx
  8008b1:	85 db                	test   %ebx,%ebx
  8008b3:	74 24                	je     8008d9 <vprintfmt+0x24b>
  8008b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b9:	78 b8                	js     800873 <vprintfmt+0x1e5>
  8008bb:	ff 4d e0             	decl   -0x20(%ebp)
  8008be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008c2:	79 af                	jns    800873 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008c4:	eb 13                	jmp    8008d9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	6a 20                	push   $0x20
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	ff d0                	call   *%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008dd:	7f e7                	jg     8008c6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008df:	e9 66 01 00 00       	jmp    800a4a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	e8 3c fd ff ff       	call   80062f <getint>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800902:	85 d2                	test   %edx,%edx
  800904:	79 23                	jns    800929 <vprintfmt+0x29b>
				putch('-', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 2d                	push   $0x2d
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091c:	f7 d8                	neg    %eax
  80091e:	83 d2 00             	adc    $0x0,%edx
  800921:	f7 da                	neg    %edx
  800923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800926:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800929:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800930:	e9 bc 00 00 00       	jmp    8009f1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 e8             	pushl  -0x18(%ebp)
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
  80093e:	50                   	push   %eax
  80093f:	e8 84 fc ff ff       	call   8005c8 <getuint>
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80094d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800954:	e9 98 00 00 00       	jmp    8009f1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	6a 58                	push   $0x58
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	ff d0                	call   *%eax
  800966:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	6a 58                	push   $0x58
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	ff d0                	call   *%eax
  800976:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	6a 58                	push   $0x58
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
			break;
  800989:	e9 bc 00 00 00       	jmp    800a4a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	6a 30                	push   $0x30
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	ff d0                	call   *%eax
  80099b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	6a 78                	push   $0x78
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	ff d0                	call   *%eax
  8009ab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	83 c0 04             	add    $0x4,%eax
  8009b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 e8 04             	sub    $0x4,%eax
  8009bd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8009c9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009d0:	eb 1f                	jmp    8009f1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009db:	50                   	push   %eax
  8009dc:	e8 e7 fb ff ff       	call   8005c8 <getuint>
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009ea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009f1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f8:	83 ec 04             	sub    $0x4,%esp
  8009fb:	52                   	push   %edx
  8009fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ff:	50                   	push   %eax
  800a00:	ff 75 f4             	pushl  -0xc(%ebp)
  800a03:	ff 75 f0             	pushl  -0x10(%ebp)
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	e8 00 fb ff ff       	call   800511 <printnum>
  800a11:	83 c4 20             	add    $0x20,%esp
			break;
  800a14:	eb 34                	jmp    800a4a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			break;
  800a25:	eb 23                	jmp    800a4a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 25                	push   $0x25
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a37:	ff 4d 10             	decl   0x10(%ebp)
  800a3a:	eb 03                	jmp    800a3f <vprintfmt+0x3b1>
  800a3c:	ff 4d 10             	decl   0x10(%ebp)
  800a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a42:	48                   	dec    %eax
  800a43:	8a 00                	mov    (%eax),%al
  800a45:	3c 25                	cmp    $0x25,%al
  800a47:	75 f3                	jne    800a3c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a49:	90                   	nop
		}
	}
  800a4a:	e9 47 fc ff ff       	jmp    800696 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a4f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a5d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a66:	8b 45 10             	mov    0x10(%ebp),%eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 16 fc ff ff       	call   80068e <vprintfmt>
  800a78:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a7b:	90                   	nop
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8b 40 08             	mov    0x8(%eax),%eax
  800a87:	8d 50 01             	lea    0x1(%eax),%edx
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	8b 10                	mov    (%eax),%edx
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	8b 40 04             	mov    0x4(%eax),%eax
  800a9b:	39 c2                	cmp    %eax,%edx
  800a9d:	73 12                	jae    800ab1 <sprintputch+0x33>
		*b->buf++ = ch;
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	89 0a                	mov    %ecx,(%edx)
  800aac:	8b 55 08             	mov    0x8(%ebp),%edx
  800aaf:	88 10                	mov    %dl,(%eax)
}
  800ab1:	90                   	nop
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	01 d0                	add    %edx,%eax
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ace:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ad5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ad9:	74 06                	je     800ae1 <vsnprintf+0x2d>
  800adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adf:	7f 07                	jg     800ae8 <vsnprintf+0x34>
		return -E_INVAL;
  800ae1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae6:	eb 20                	jmp    800b08 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae8:	ff 75 14             	pushl  0x14(%ebp)
  800aeb:	ff 75 10             	pushl  0x10(%ebp)
  800aee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af1:	50                   	push   %eax
  800af2:	68 7e 0a 80 00       	push   $0x800a7e
  800af7:	e8 92 fb ff ff       	call   80068e <vprintfmt>
  800afc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b10:	8d 45 10             	lea    0x10(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 89 ff ff ff       	call   800ab4 <vsnprintf>
  800b2b:	83 c4 10             	add    $0x10,%esp
  800b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b43:	eb 06                	jmp    800b4b <strlen+0x15>
		n++;
  800b45:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b48:	ff 45 08             	incl   0x8(%ebp)
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 f1                	jne    800b45 <strlen+0xf>
		n++;
	return n;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b66:	eb 09                	jmp    800b71 <strnlen+0x18>
		n++;
  800b68:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b6b:	ff 45 08             	incl   0x8(%ebp)
  800b6e:	ff 4d 0c             	decl   0xc(%ebp)
  800b71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b75:	74 09                	je     800b80 <strnlen+0x27>
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	84 c0                	test   %al,%al
  800b7e:	75 e8                	jne    800b68 <strnlen+0xf>
		n++;
	return n;
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b91:	90                   	nop
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8d 50 01             	lea    0x1(%eax),%edx
  800b98:	89 55 08             	mov    %edx,0x8(%ebp)
  800b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ba4:	8a 12                	mov    (%edx),%dl
  800ba6:	88 10                	mov    %dl,(%eax)
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	84 c0                	test   %al,%al
  800bac:	75 e4                	jne    800b92 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc6:	eb 1f                	jmp    800be7 <strncpy+0x34>
		*dst++ = *src;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8d 50 01             	lea    0x1(%eax),%edx
  800bce:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	8a 12                	mov    (%edx),%dl
  800bd6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	8a 00                	mov    (%eax),%al
  800bdd:	84 c0                	test   %al,%al
  800bdf:	74 03                	je     800be4 <strncpy+0x31>
			src++;
  800be1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be4:	ff 45 fc             	incl   -0x4(%ebp)
  800be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bea:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bed:	72 d9                	jb     800bc8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c04:	74 30                	je     800c36 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c06:	eb 16                	jmp    800c1e <strlcpy+0x2a>
			*dst++ = *src++;
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1a:	8a 12                	mov    (%edx),%dl
  800c1c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c1e:	ff 4d 10             	decl   0x10(%ebp)
  800c21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c25:	74 09                	je     800c30 <strlcpy+0x3c>
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 d8                	jne    800c08 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	29 c2                	sub    %eax,%edx
  800c3e:	89 d0                	mov    %edx,%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c45:	eb 06                	jmp    800c4d <strcmp+0xb>
		p++, q++;
  800c47:	ff 45 08             	incl   0x8(%ebp)
  800c4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8a 00                	mov    (%eax),%al
  800c52:	84 c0                	test   %al,%al
  800c54:	74 0e                	je     800c64 <strcmp+0x22>
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8a 10                	mov    (%eax),%dl
  800c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	38 c2                	cmp    %al,%dl
  800c62:	74 e3                	je     800c47 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	0f b6 d0             	movzbl %al,%edx
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 c0             	movzbl %al,%eax
  800c74:	29 c2                	sub    %eax,%edx
  800c76:	89 d0                	mov    %edx,%eax
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c7d:	eb 09                	jmp    800c88 <strncmp+0xe>
		n--, p++, q++;
  800c7f:	ff 4d 10             	decl   0x10(%ebp)
  800c82:	ff 45 08             	incl   0x8(%ebp)
  800c85:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8c:	74 17                	je     800ca5 <strncmp+0x2b>
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 0e                	je     800ca5 <strncmp+0x2b>
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 10                	mov    (%eax),%dl
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	38 c2                	cmp    %al,%dl
  800ca3:	74 da                	je     800c7f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca9:	75 07                	jne    800cb2 <strncmp+0x38>
		return 0;
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb0:	eb 14                	jmp    800cc6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	0f b6 d0             	movzbl %al,%edx
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	0f b6 c0             	movzbl %al,%eax
  800cc2:	29 c2                	sub    %eax,%edx
  800cc4:	89 d0                	mov    %edx,%eax
}
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd4:	eb 12                	jmp    800ce8 <strchr+0x20>
		if (*s == c)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cde:	75 05                	jne    800ce5 <strchr+0x1d>
			return (char *) s;
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	eb 11                	jmp    800cf6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 e5                	jne    800cd6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d04:	eb 0d                	jmp    800d13 <strfind+0x1b>
		if (*s == c)
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d0e:	74 0e                	je     800d1e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d10:	ff 45 08             	incl   0x8(%ebp)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 ea                	jne    800d06 <strfind+0xe>
  800d1c:	eb 01                	jmp    800d1f <strfind+0x27>
		if (*s == c)
			break;
  800d1e:	90                   	nop
	return (char *) s;
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d36:	eb 0e                	jmp    800d46 <memset+0x22>
		*p++ = c;
  800d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3b:	8d 50 01             	lea    0x1(%eax),%edx
  800d3e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d44:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d46:	ff 4d f8             	decl   -0x8(%ebp)
  800d49:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d4d:	79 e9                	jns    800d38 <memset+0x14>
		*p++ = c;

	return v;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d66:	eb 16                	jmp    800d7e <memcpy+0x2a>
		*d++ = *s++;
  800d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6b:	8d 50 01             	lea    0x1(%eax),%edx
  800d6e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d77:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d7a:	8a 12                	mov    (%edx),%dl
  800d7c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d84:	89 55 10             	mov    %edx,0x10(%ebp)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	75 dd                	jne    800d68 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da8:	73 50                	jae    800dfa <memmove+0x6a>
  800daa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	01 d0                	add    %edx,%eax
  800db2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800db5:	76 43                	jbe    800dfa <memmove+0x6a>
		s += n;
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dba:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800dc3:	eb 10                	jmp    800dd5 <memmove+0x45>
			*--d = *--s;
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	ff 4d fc             	decl   -0x4(%ebp)
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dce:	8a 10                	mov    (%eax),%dl
  800dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	75 e3                	jne    800dc5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de2:	eb 23                	jmp    800e07 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de7:	8d 50 01             	lea    0x1(%eax),%edx
  800dea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ded:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df6:	8a 12                	mov    (%edx),%dl
  800df8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e00:	89 55 10             	mov    %edx,0x10(%ebp)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	75 dd                	jne    800de4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e1e:	eb 2a                	jmp    800e4a <memcmp+0x3e>
		if (*s1 != *s2)
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	8a 10                	mov    (%eax),%dl
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	38 c2                	cmp    %al,%dl
  800e2c:	74 16                	je     800e44 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f b6 d0             	movzbl %al,%edx
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	0f b6 c0             	movzbl %al,%eax
  800e3e:	29 c2                	sub    %eax,%edx
  800e40:	89 d0                	mov    %edx,%eax
  800e42:	eb 18                	jmp    800e5c <memcmp+0x50>
		s1++, s2++;
  800e44:	ff 45 fc             	incl   -0x4(%ebp)
  800e47:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e50:	89 55 10             	mov    %edx,0x10(%ebp)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 c9                	jne    800e20 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	01 d0                	add    %edx,%eax
  800e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e6f:	eb 15                	jmp    800e86 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 d0             	movzbl %al,%edx
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	0f b6 c0             	movzbl %al,%eax
  800e7f:	39 c2                	cmp    %eax,%edx
  800e81:	74 0d                	je     800e90 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e83:	ff 45 08             	incl   0x8(%ebp)
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e8c:	72 e3                	jb     800e71 <memfind+0x13>
  800e8e:	eb 01                	jmp    800e91 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e90:	90                   	nop
	return (void *) s;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ea3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eaa:	eb 03                	jmp    800eaf <strtol+0x19>
		s++;
  800eac:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	3c 20                	cmp    $0x20,%al
  800eb6:	74 f4                	je     800eac <strtol+0x16>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3c 09                	cmp    $0x9,%al
  800ebf:	74 eb                	je     800eac <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3c 2b                	cmp    $0x2b,%al
  800ec8:	75 05                	jne    800ecf <strtol+0x39>
		s++;
  800eca:	ff 45 08             	incl   0x8(%ebp)
  800ecd:	eb 13                	jmp    800ee2 <strtol+0x4c>
	else if (*s == '-')
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	3c 2d                	cmp    $0x2d,%al
  800ed6:	75 0a                	jne    800ee2 <strtol+0x4c>
		s++, neg = 1;
  800ed8:	ff 45 08             	incl   0x8(%ebp)
  800edb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	74 06                	je     800eee <strtol+0x58>
  800ee8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800eec:	75 20                	jne    800f0e <strtol+0x78>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 30                	cmp    $0x30,%al
  800ef5:	75 17                	jne    800f0e <strtol+0x78>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	40                   	inc    %eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	3c 78                	cmp    $0x78,%al
  800eff:	75 0d                	jne    800f0e <strtol+0x78>
		s += 2, base = 16;
  800f01:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f05:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f0c:	eb 28                	jmp    800f36 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f12:	75 15                	jne    800f29 <strtol+0x93>
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	3c 30                	cmp    $0x30,%al
  800f1b:	75 0c                	jne    800f29 <strtol+0x93>
		s++, base = 8;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f27:	eb 0d                	jmp    800f36 <strtol+0xa0>
	else if (base == 0)
  800f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2d:	75 07                	jne    800f36 <strtol+0xa0>
		base = 10;
  800f2f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	3c 2f                	cmp    $0x2f,%al
  800f3d:	7e 19                	jle    800f58 <strtol+0xc2>
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 39                	cmp    $0x39,%al
  800f46:	7f 10                	jg     800f58 <strtol+0xc2>
			dig = *s - '0';
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	0f be c0             	movsbl %al,%eax
  800f50:	83 e8 30             	sub    $0x30,%eax
  800f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f56:	eb 42                	jmp    800f9a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	3c 60                	cmp    $0x60,%al
  800f5f:	7e 19                	jle    800f7a <strtol+0xe4>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 7a                	cmp    $0x7a,%al
  800f68:	7f 10                	jg     800f7a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f be c0             	movsbl %al,%eax
  800f72:	83 e8 57             	sub    $0x57,%eax
  800f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f78:	eb 20                	jmp    800f9a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 40                	cmp    $0x40,%al
  800f81:	7e 39                	jle    800fbc <strtol+0x126>
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3c 5a                	cmp    $0x5a,%al
  800f8a:	7f 30                	jg     800fbc <strtol+0x126>
			dig = *s - 'A' + 10;
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f be c0             	movsbl %al,%eax
  800f94:	83 e8 37             	sub    $0x37,%eax
  800f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fa0:	7d 19                	jge    800fbb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fa2:	ff 45 08             	incl   0x8(%ebp)
  800fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fac:	89 c2                	mov    %eax,%edx
  800fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb1:	01 d0                	add    %edx,%eax
  800fb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fb6:	e9 7b ff ff ff       	jmp    800f36 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fbb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	74 08                	je     800fca <strtol+0x134>
		*endptr = (char *) s;
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fce:	74 07                	je     800fd7 <strtol+0x141>
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	f7 d8                	neg    %eax
  800fd5:	eb 03                	jmp    800fda <strtol+0x144>
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <ltostr>:

void
ltostr(long value, char *str)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fe9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ff0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff4:	79 13                	jns    801009 <ltostr+0x2d>
	{
		neg = 1;
  800ff6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801000:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801003:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801006:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801011:	99                   	cltd   
  801012:	f7 f9                	idiv   %ecx
  801014:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101a:	8d 50 01             	lea    0x1(%eax),%edx
  80101d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	01 d0                	add    %edx,%eax
  801027:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80102a:	83 c2 30             	add    $0x30,%edx
  80102d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80102f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801032:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801037:	f7 e9                	imul   %ecx
  801039:	c1 fa 02             	sar    $0x2,%edx
  80103c:	89 c8                	mov    %ecx,%eax
  80103e:	c1 f8 1f             	sar    $0x1f,%eax
  801041:	29 c2                	sub    %eax,%edx
  801043:	89 d0                	mov    %edx,%eax
  801045:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801050:	f7 e9                	imul   %ecx
  801052:	c1 fa 02             	sar    $0x2,%edx
  801055:	89 c8                	mov    %ecx,%eax
  801057:	c1 f8 1f             	sar    $0x1f,%eax
  80105a:	29 c2                	sub    %eax,%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	c1 e0 02             	shl    $0x2,%eax
  801061:	01 d0                	add    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	29 c1                	sub    %eax,%ecx
  801067:	89 ca                	mov    %ecx,%edx
  801069:	85 d2                	test   %edx,%edx
  80106b:	75 9c                	jne    801009 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80106d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801074:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801077:	48                   	dec    %eax
  801078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80107b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80107f:	74 3d                	je     8010be <ltostr+0xe2>
		start = 1 ;
  801081:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801088:	eb 34                	jmp    8010be <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80108a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109d:	01 c2                	add    %eax,%edx
  80109f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	01 c8                	add    %ecx,%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	01 c2                	add    %eax,%edx
  8010b3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010b6:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010bb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010c4:	7c c4                	jl     80108a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010d1:	90                   	nop
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010da:	ff 75 08             	pushl  0x8(%ebp)
  8010dd:	e8 54 fa ff ff       	call   800b36 <strlen>
  8010e2:	83 c4 04             	add    $0x4,%esp
  8010e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e8:	ff 75 0c             	pushl  0xc(%ebp)
  8010eb:	e8 46 fa ff ff       	call   800b36 <strlen>
  8010f0:	83 c4 04             	add    $0x4,%esp
  8010f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801104:	eb 17                	jmp    80111d <strcconcat+0x49>
		final[s] = str1[s] ;
  801106:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	01 c8                	add    %ecx,%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801120:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801123:	7c e1                	jl     801106 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801125:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801133:	eb 1f                	jmp    801154 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801135:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80113e:	89 c2                	mov    %eax,%edx
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	01 c2                	add    %eax,%edx
  801145:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 c8                	add    %ecx,%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801151:	ff 45 f8             	incl   -0x8(%ebp)
  801154:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801157:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80115a:	7c d9                	jl     801135 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80115c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	01 d0                	add    %edx,%eax
  801164:	c6 00 00             	movb   $0x0,(%eax)
}
  801167:	90                   	nop
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80116d:	8b 45 14             	mov    0x14(%ebp),%eax
  801170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801176:	8b 45 14             	mov    0x14(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	01 d0                	add    %edx,%eax
  801187:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80118d:	eb 0c                	jmp    80119b <strsplit+0x31>
			*string++ = 0;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8d 50 01             	lea    0x1(%eax),%edx
  801195:	89 55 08             	mov    %edx,0x8(%ebp)
  801198:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	74 18                	je     8011bc <strsplit+0x52>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	0f be c0             	movsbl %al,%eax
  8011ac:	50                   	push   %eax
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	e8 13 fb ff ff       	call   800cc8 <strchr>
  8011b5:	83 c4 08             	add    $0x8,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	75 d3                	jne    80118f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	84 c0                	test   %al,%al
  8011c3:	74 5a                	je     80121f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	83 f8 0f             	cmp    $0xf,%eax
  8011cd:	75 07                	jne    8011d6 <strsplit+0x6c>
		{
			return 0;
  8011cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d4:	eb 66                	jmp    80123c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	8d 48 01             	lea    0x1(%eax),%ecx
  8011de:	8b 55 14             	mov    0x14(%ebp),%edx
  8011e1:	89 0a                	mov    %ecx,(%edx)
  8011e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	01 c2                	add    %eax,%edx
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f4:	eb 03                	jmp    8011f9 <strsplit+0x8f>
			string++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	84 c0                	test   %al,%al
  801200:	74 8b                	je     80118d <strsplit+0x23>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f be c0             	movsbl %al,%eax
  80120a:	50                   	push   %eax
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	e8 b5 fa ff ff       	call   800cc8 <strchr>
  801213:	83 c4 08             	add    $0x8,%esp
  801216:	85 c0                	test   %eax,%eax
  801218:	74 dc                	je     8011f6 <strsplit+0x8c>
			string++;
	}
  80121a:	e9 6e ff ff ff       	jmp    80118d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80121f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122c:	8b 45 10             	mov    0x10(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801237:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124b:	eb 4c                	jmp    801299 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80124d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 40                	cmp    $0x40,%al
  801259:	7e 27                	jle    801282 <str2lower+0x44>
  80125b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 d0                	add    %edx,%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	3c 5a                	cmp    $0x5a,%al
  801267:	7f 19                	jg     801282 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801269:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	01 ca                	add    %ecx,%edx
  801279:	8a 12                	mov    (%edx),%dl
  80127b:	83 c2 20             	add    $0x20,%edx
  80127e:	88 10                	mov    %dl,(%eax)
  801280:	eb 14                	jmp    801296 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	01 c2                	add    %eax,%edx
  80128a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 c8                	add    %ecx,%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801296:	ff 45 fc             	incl   -0x4(%ebp)
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	e8 95 f8 ff ff       	call   800b36 <strlen>
  8012a1:	83 c4 04             	add    $0x4,%esp
  8012a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012a7:	7f a4                	jg     80124d <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8012a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	01 d0                	add    %edx,%eax
  8012b1:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012d4:	cd 30                	int    $0x30
  8012d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	52                   	push   %edx
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	50                   	push   %eax
  801300:	6a 00                	push   $0x0
  801302:	e8 b2 ff ff ff       	call   8012b9 <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	90                   	nop
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <sys_cgetc>:

int
sys_cgetc(void)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 01                	push   $0x1
  80131c:	e8 98 ff ff ff       	call   8012b9 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	52                   	push   %edx
  801336:	50                   	push   %eax
  801337:	6a 05                	push   $0x5
  801339:	e8 7b ff ff ff       	call   8012b9 <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	56                   	push   %esi
  801347:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801348:	8b 75 18             	mov    0x18(%ebp),%esi
  80134b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80134e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801351:	8b 55 0c             	mov    0xc(%ebp),%edx
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	51                   	push   %ecx
  80135a:	52                   	push   %edx
  80135b:	50                   	push   %eax
  80135c:	6a 06                	push   $0x6
  80135e:	e8 56 ff ff ff       	call   8012b9 <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	52                   	push   %edx
  80137d:	50                   	push   %eax
  80137e:	6a 07                	push   $0x7
  801380:	e8 34 ff ff ff       	call   8012b9 <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	ff 75 0c             	pushl  0xc(%ebp)
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	6a 08                	push   $0x8
  80139b:	e8 19 ff ff ff       	call   8012b9 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 09                	push   $0x9
  8013b4:	e8 00 ff ff ff       	call   8012b9 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 0a                	push   $0xa
  8013cd:	e8 e7 fe ff ff       	call   8012b9 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 0b                	push   $0xb
  8013e6:	e8 ce fe ff ff       	call   8012b9 <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 0c                	push   $0xc
  8013ff:	e8 b5 fe ff ff       	call   8012b9 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	ff 75 08             	pushl  0x8(%ebp)
  801417:	6a 0d                	push   $0xd
  801419:	e8 9b fe ff ff       	call   8012b9 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 0e                	push   $0xe
  801432:	e8 82 fe ff ff       	call   8012b9 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	90                   	nop
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 11                	push   $0x11
  80144c:	e8 68 fe ff ff       	call   8012b9 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 12                	push   $0x12
  801466:	e8 4e fe ff ff       	call   8012b9 <syscall>
  80146b:	83 c4 18             	add    $0x18,%esp
}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_cputc>:


void
sys_cputc(const char c)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80147d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	50                   	push   %eax
  80148a:	6a 13                	push   $0x13
  80148c:	e8 28 fe ff ff       	call   8012b9 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	90                   	nop
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 14                	push   $0x14
  8014a6:	e8 0e fe ff ff       	call   8012b9 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	50                   	push   %eax
  8014c1:	6a 15                	push   $0x15
  8014c3:	e8 f1 fd ff ff       	call   8012b9 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	52                   	push   %edx
  8014dd:	50                   	push   %eax
  8014de:	6a 18                	push   $0x18
  8014e0:	e8 d4 fd ff ff       	call   8012b9 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	52                   	push   %edx
  8014fa:	50                   	push   %eax
  8014fb:	6a 16                	push   $0x16
  8014fd:	e8 b7 fd ff ff       	call   8012b9 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	52                   	push   %edx
  801518:	50                   	push   %eax
  801519:	6a 17                	push   $0x17
  80151b:	e8 99 fd ff ff       	call   8012b9 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	90                   	nop
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 04             	sub    $0x4,%esp
  80152c:	8b 45 10             	mov    0x10(%ebp),%eax
  80152f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801532:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801535:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	6a 00                	push   $0x0
  80153e:	51                   	push   %ecx
  80153f:	52                   	push   %edx
  801540:	ff 75 0c             	pushl  0xc(%ebp)
  801543:	50                   	push   %eax
  801544:	6a 19                	push   $0x19
  801546:	e8 6e fd ff ff       	call   8012b9 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	52                   	push   %edx
  801560:	50                   	push   %eax
  801561:	6a 1a                	push   $0x1a
  801563:	e8 51 fd ff ff       	call   8012b9 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801570:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801573:	8b 55 0c             	mov    0xc(%ebp),%edx
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	51                   	push   %ecx
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	6a 1b                	push   $0x1b
  801582:	e8 32 fd ff ff       	call   8012b9 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	52                   	push   %edx
  80159c:	50                   	push   %eax
  80159d:	6a 1c                	push   $0x1c
  80159f:	e8 15 fd ff ff       	call   8012b9 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 1d                	push   $0x1d
  8015b8:	e8 fc fc ff ff       	call   8012b9 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	ff 75 14             	pushl  0x14(%ebp)
  8015cd:	ff 75 10             	pushl  0x10(%ebp)
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	50                   	push   %eax
  8015d4:	6a 1e                	push   $0x1e
  8015d6:	e8 de fc ff ff       	call   8012b9 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	50                   	push   %eax
  8015ef:	6a 1f                	push   $0x1f
  8015f1:	e8 c3 fc ff ff       	call   8012b9 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	50                   	push   %eax
  80160b:	6a 20                	push   $0x20
  80160d:	e8 a7 fc ff ff       	call   8012b9 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 02                	push   $0x2
  801626:	e8 8e fc ff ff       	call   8012b9 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 03                	push   $0x3
  80163f:	e8 75 fc ff ff       	call   8012b9 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 04                	push   $0x4
  801658:	e8 5c fc ff ff       	call   8012b9 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_exit_env>:


void sys_exit_env(void)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 21                	push   $0x21
  801671:	e8 43 fc ff ff       	call   8012b9 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	90                   	nop
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801682:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801685:	8d 50 04             	lea    0x4(%eax),%edx
  801688:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 22                	push   $0x22
  801695:	e8 1f fc ff ff       	call   8012b9 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
	return result;
  80169d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a6:	89 01                	mov    %eax,(%ecx)
  8016a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	c9                   	leave  
  8016af:	c2 04 00             	ret    $0x4

008016b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	ff 75 10             	pushl  0x10(%ebp)
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	6a 10                	push   $0x10
  8016c4:	e8 f0 fb ff ff       	call   8012b9 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cc:	90                   	nop
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 23                	push   $0x23
  8016de:	e8 d6 fb ff ff       	call   8012b9 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	50                   	push   %eax
  801701:	6a 24                	push   $0x24
  801703:	e8 b1 fb ff ff       	call   8012b9 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return ;
  80170b:	90                   	nop
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <rsttst>:
void rsttst()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 26                	push   $0x26
  80171d:	e8 97 fb ff ff       	call   8012b9 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
	return ;
  801725:	90                   	nop
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801734:	8b 55 18             	mov    0x18(%ebp),%edx
  801737:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80173b:	52                   	push   %edx
  80173c:	50                   	push   %eax
  80173d:	ff 75 10             	pushl  0x10(%ebp)
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	6a 25                	push   $0x25
  801748:	e8 6c fb ff ff       	call   8012b9 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
	return ;
  801750:	90                   	nop
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <chktst>:
void chktst(uint32 n)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	ff 75 08             	pushl  0x8(%ebp)
  801761:	6a 27                	push   $0x27
  801763:	e8 51 fb ff ff       	call   8012b9 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
	return ;
  80176b:	90                   	nop
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <inctst>:

void inctst()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 28                	push   $0x28
  80177d:	e8 37 fb ff ff       	call   8012b9 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return ;
  801785:	90                   	nop
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <gettst>:
uint32 gettst()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 29                	push   $0x29
  801797:	e8 1d fb ff ff       	call   8012b9 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 2a                	push   $0x2a
  8017b3:	e8 01 fb ff ff       	call   8012b9 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
  8017bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017be:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017c2:	75 07                	jne    8017cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c9:	eb 05                	jmp    8017d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 2a                	push   $0x2a
  8017e4:	e8 d0 fa ff ff       	call   8012b9 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
  8017ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017ef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017f3:	75 07                	jne    8017fc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fa:	eb 05                	jmp    801801 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 2a                	push   $0x2a
  801815:	e8 9f fa ff ff       	call   8012b9 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
  80181d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801820:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801824:	75 07                	jne    80182d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801826:	b8 01 00 00 00       	mov    $0x1,%eax
  80182b:	eb 05                	jmp    801832 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80182d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 2a                	push   $0x2a
  801846:	e8 6e fa ff ff       	call   8012b9 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
  80184e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801851:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801855:	75 07                	jne    80185e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801857:	b8 01 00 00 00       	mov    $0x1,%eax
  80185c:	eb 05                	jmp    801863 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	6a 2b                	push   $0x2b
  801875:	e8 3f fa ff ff       	call   8012b9 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
	return ;
  80187d:	90                   	nop
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801884:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801887:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	53                   	push   %ebx
  801893:	51                   	push   %ecx
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 2c                	push   $0x2c
  801898:	e8 1c fa ff ff       	call   8012b9 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 2d                	push   $0x2d
  8018b8:	e8 fc f9 ff ff       	call   8012b9 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	51                   	push   %ecx
  8018d1:	ff 75 10             	pushl  0x10(%ebp)
  8018d4:	52                   	push   %edx
  8018d5:	50                   	push   %eax
  8018d6:	6a 2e                	push   $0x2e
  8018d8:	e8 dc f9 ff ff       	call   8012b9 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 10             	pushl  0x10(%ebp)
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	ff 75 08             	pushl  0x8(%ebp)
  8018f2:	6a 0f                	push   $0xf
  8018f4:	e8 c0 f9 ff ff       	call   8012b9 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fc:	90                   	nop
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	50                   	push   %eax
  80190e:	6a 2f                	push   $0x2f
  801910:	e8 a4 f9 ff ff       	call   8012b9 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp

}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	6a 30                	push   $0x30
  80192b:	e8 89 f9 ff ff       	call   8012b9 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp

}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 31                	push   $0x31
  801947:	e8 6d f9 ff ff       	call   8012b9 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp

}
  80194f:	90                   	nop
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 32                	push   $0x32
  801961:	e8 53 f9 ff ff       	call   8012b9 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    
  80196b:	90                   	nop

0080196c <__udivdi3>:
  80196c:	55                   	push   %ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 1c             	sub    $0x1c,%esp
  801973:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801977:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80197b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80197f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801983:	89 ca                	mov    %ecx,%edx
  801985:	89 f8                	mov    %edi,%eax
  801987:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80198b:	85 f6                	test   %esi,%esi
  80198d:	75 2d                	jne    8019bc <__udivdi3+0x50>
  80198f:	39 cf                	cmp    %ecx,%edi
  801991:	77 65                	ja     8019f8 <__udivdi3+0x8c>
  801993:	89 fd                	mov    %edi,%ebp
  801995:	85 ff                	test   %edi,%edi
  801997:	75 0b                	jne    8019a4 <__udivdi3+0x38>
  801999:	b8 01 00 00 00       	mov    $0x1,%eax
  80199e:	31 d2                	xor    %edx,%edx
  8019a0:	f7 f7                	div    %edi
  8019a2:	89 c5                	mov    %eax,%ebp
  8019a4:	31 d2                	xor    %edx,%edx
  8019a6:	89 c8                	mov    %ecx,%eax
  8019a8:	f7 f5                	div    %ebp
  8019aa:	89 c1                	mov    %eax,%ecx
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	f7 f5                	div    %ebp
  8019b0:	89 cf                	mov    %ecx,%edi
  8019b2:	89 fa                	mov    %edi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	77 28                	ja     8019e8 <__udivdi3+0x7c>
  8019c0:	0f bd fe             	bsr    %esi,%edi
  8019c3:	83 f7 1f             	xor    $0x1f,%edi
  8019c6:	75 40                	jne    801a08 <__udivdi3+0x9c>
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	72 0a                	jb     8019d6 <__udivdi3+0x6a>
  8019cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d0:	0f 87 9e 00 00 00    	ja     801a74 <__udivdi3+0x108>
  8019d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019db:	89 fa                	mov    %edi,%edx
  8019dd:	83 c4 1c             	add    $0x1c,%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    
  8019e5:	8d 76 00             	lea    0x0(%esi),%esi
  8019e8:	31 ff                	xor    %edi,%edi
  8019ea:	31 c0                	xor    %eax,%eax
  8019ec:	89 fa                	mov    %edi,%edx
  8019ee:	83 c4 1c             	add    $0x1c,%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5f                   	pop    %edi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	89 d8                	mov    %ebx,%eax
  8019fa:	f7 f7                	div    %edi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	89 fa                	mov    %edi,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a0d:	89 eb                	mov    %ebp,%ebx
  801a0f:	29 fb                	sub    %edi,%ebx
  801a11:	89 f9                	mov    %edi,%ecx
  801a13:	d3 e6                	shl    %cl,%esi
  801a15:	89 c5                	mov    %eax,%ebp
  801a17:	88 d9                	mov    %bl,%cl
  801a19:	d3 ed                	shr    %cl,%ebp
  801a1b:	89 e9                	mov    %ebp,%ecx
  801a1d:	09 f1                	or     %esi,%ecx
  801a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e0                	shl    %cl,%eax
  801a27:	89 c5                	mov    %eax,%ebp
  801a29:	89 d6                	mov    %edx,%esi
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ee                	shr    %cl,%esi
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e2                	shl    %cl,%edx
  801a33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 e8                	shr    %cl,%eax
  801a3b:	09 c2                	or     %eax,%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	89 f2                	mov    %esi,%edx
  801a41:	f7 74 24 0c          	divl   0xc(%esp)
  801a45:	89 d6                	mov    %edx,%esi
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	f7 e5                	mul    %ebp
  801a4b:	39 d6                	cmp    %edx,%esi
  801a4d:	72 19                	jb     801a68 <__udivdi3+0xfc>
  801a4f:	74 0b                	je     801a5c <__udivdi3+0xf0>
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	31 ff                	xor    %edi,%edi
  801a55:	e9 58 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a5a:	66 90                	xchg   %ax,%ax
  801a5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a60:	89 f9                	mov    %edi,%ecx
  801a62:	d3 e2                	shl    %cl,%edx
  801a64:	39 c2                	cmp    %eax,%edx
  801a66:	73 e9                	jae    801a51 <__udivdi3+0xe5>
  801a68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a6b:	31 ff                	xor    %edi,%edi
  801a6d:	e9 40 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	31 c0                	xor    %eax,%eax
  801a76:	e9 37 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a7b:	90                   	nop

00801a7c <__umoddi3>:
  801a7c:	55                   	push   %ebp
  801a7d:	57                   	push   %edi
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a9b:	89 f3                	mov    %esi,%ebx
  801a9d:	89 fa                	mov    %edi,%edx
  801a9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa3:	89 34 24             	mov    %esi,(%esp)
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	75 1a                	jne    801ac4 <__umoddi3+0x48>
  801aaa:	39 f7                	cmp    %esi,%edi
  801aac:	0f 86 a2 00 00 00    	jbe    801b54 <__umoddi3+0xd8>
  801ab2:	89 c8                	mov    %ecx,%eax
  801ab4:	89 f2                	mov    %esi,%edx
  801ab6:	f7 f7                	div    %edi
  801ab8:	89 d0                	mov    %edx,%eax
  801aba:	31 d2                	xor    %edx,%edx
  801abc:	83 c4 1c             	add    $0x1c,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
  801ac4:	39 f0                	cmp    %esi,%eax
  801ac6:	0f 87 ac 00 00 00    	ja     801b78 <__umoddi3+0xfc>
  801acc:	0f bd e8             	bsr    %eax,%ebp
  801acf:	83 f5 1f             	xor    $0x1f,%ebp
  801ad2:	0f 84 ac 00 00 00    	je     801b84 <__umoddi3+0x108>
  801ad8:	bf 20 00 00 00       	mov    $0x20,%edi
  801add:	29 ef                	sub    %ebp,%edi
  801adf:	89 fe                	mov    %edi,%esi
  801ae1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e0                	shl    %cl,%eax
  801ae9:	89 d7                	mov    %edx,%edi
  801aeb:	89 f1                	mov    %esi,%ecx
  801aed:	d3 ef                	shr    %cl,%edi
  801aef:	09 c7                	or     %eax,%edi
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e2                	shl    %cl,%edx
  801af5:	89 14 24             	mov    %edx,(%esp)
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0c:	89 f1                	mov    %esi,%ecx
  801b0e:	d3 e8                	shr    %cl,%eax
  801b10:	09 d0                	or     %edx,%eax
  801b12:	d3 eb                	shr    %cl,%ebx
  801b14:	89 da                	mov    %ebx,%edx
  801b16:	f7 f7                	div    %edi
  801b18:	89 d3                	mov    %edx,%ebx
  801b1a:	f7 24 24             	mull   (%esp)
  801b1d:	89 c6                	mov    %eax,%esi
  801b1f:	89 d1                	mov    %edx,%ecx
  801b21:	39 d3                	cmp    %edx,%ebx
  801b23:	0f 82 87 00 00 00    	jb     801bb0 <__umoddi3+0x134>
  801b29:	0f 84 91 00 00 00    	je     801bc0 <__umoddi3+0x144>
  801b2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b33:	29 f2                	sub    %esi,%edx
  801b35:	19 cb                	sbb    %ecx,%ebx
  801b37:	89 d8                	mov    %ebx,%eax
  801b39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b3d:	d3 e0                	shl    %cl,%eax
  801b3f:	89 e9                	mov    %ebp,%ecx
  801b41:	d3 ea                	shr    %cl,%edx
  801b43:	09 d0                	or     %edx,%eax
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 eb                	shr    %cl,%ebx
  801b49:	89 da                	mov    %ebx,%edx
  801b4b:	83 c4 1c             	add    $0x1c,%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5f                   	pop    %edi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    
  801b53:	90                   	nop
  801b54:	89 fd                	mov    %edi,%ebp
  801b56:	85 ff                	test   %edi,%edi
  801b58:	75 0b                	jne    801b65 <__umoddi3+0xe9>
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f7                	div    %edi
  801b63:	89 c5                	mov    %eax,%ebp
  801b65:	89 f0                	mov    %esi,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f5                	div    %ebp
  801b6b:	89 c8                	mov    %ecx,%eax
  801b6d:	f7 f5                	div    %ebp
  801b6f:	89 d0                	mov    %edx,%eax
  801b71:	e9 44 ff ff ff       	jmp    801aba <__umoddi3+0x3e>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	89 c8                	mov    %ecx,%eax
  801b7a:	89 f2                	mov    %esi,%edx
  801b7c:	83 c4 1c             	add    $0x1c,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    
  801b84:	3b 04 24             	cmp    (%esp),%eax
  801b87:	72 06                	jb     801b8f <__umoddi3+0x113>
  801b89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b8d:	77 0f                	ja     801b9e <__umoddi3+0x122>
  801b8f:	89 f2                	mov    %esi,%edx
  801b91:	29 f9                	sub    %edi,%ecx
  801b93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b97:	89 14 24             	mov    %edx,(%esp)
  801b9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ba2:	8b 14 24             	mov    (%esp),%edx
  801ba5:	83 c4 1c             	add    $0x1c,%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5f                   	pop    %edi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
  801bad:	8d 76 00             	lea    0x0(%esi),%esi
  801bb0:	2b 04 24             	sub    (%esp),%eax
  801bb3:	19 fa                	sbb    %edi,%edx
  801bb5:	89 d1                	mov    %edx,%ecx
  801bb7:	89 c6                	mov    %eax,%esi
  801bb9:	e9 71 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bc4:	72 ea                	jb     801bb0 <__umoddi3+0x134>
  801bc6:	89 d9                	mov    %ebx,%ecx
  801bc8:	e9 62 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
