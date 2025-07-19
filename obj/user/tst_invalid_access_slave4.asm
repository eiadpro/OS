
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
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
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 c2 16 00 00       	call   801740 <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 c0 1b 80 00       	push   $0x801bc0
  800086:	6a 18                	push   $0x18
  800088:	68 5c 1c 80 00       	push   $0x801c5c
  80008d:	e8 37 01 00 00       	call   8001c9 <_panic>

00800092 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800098:	e8 65 15 00 00       	call   801602 <sys_getenvindex>
  80009d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a3:	89 d0                	mov    %edx,%eax
  8000a5:	c1 e0 03             	shl    $0x3,%eax
  8000a8:	01 d0                	add    %edx,%eax
  8000aa:	01 c0                	add    %eax,%eax
  8000ac:	01 d0                	add    %edx,%eax
  8000ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000b5:	01 d0                	add    %edx,%eax
  8000b7:	c1 e0 04             	shl    $0x4,%eax
  8000ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c9:	8a 40 5c             	mov    0x5c(%eax),%al
  8000cc:	84 c0                	test   %al,%al
  8000ce:	74 0d                	je     8000dd <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d5:	83 c0 5c             	add    $0x5c,%eax
  8000d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e1:	7e 0a                	jle    8000ed <libmain+0x5b>
		binaryname = argv[0];
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	e8 3d ff ff ff       	call   800038 <_main>
  8000fb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000fe:	e8 0c 13 00 00       	call   80140f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 98 1c 80 00       	push   $0x801c98
  80010b:	e8 76 03 00 00       	call   800486 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80011e:	a1 20 30 80 00       	mov    0x803020,%eax
  800123:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	52                   	push   %edx
  80012d:	50                   	push   %eax
  80012e:	68 c0 1c 80 00       	push   $0x801cc0
  800133:	e8 4e 03 00 00       	call   800486 <cprintf>
  800138:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80013b:	a1 20 30 80 00       	mov    0x803020,%eax
  800140:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80015c:	51                   	push   %ecx
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	68 e8 1c 80 00       	push   $0x801ce8
  800164:	e8 1d 03 00 00       	call   800486 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80016c:	a1 20 30 80 00       	mov    0x803020,%eax
  800171:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	68 40 1d 80 00       	push   $0x801d40
  800180:	e8 01 03 00 00       	call   800486 <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	68 98 1c 80 00       	push   $0x801c98
  800190:	e8 f1 02 00 00       	call   800486 <cprintf>
  800195:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800198:	e8 8c 12 00 00       	call   801429 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80019d:	e8 19 00 00 00       	call   8001bb <exit>
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	6a 00                	push   $0x0
  8001b0:	e8 19 14 00 00       	call   8015ce <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <exit>:

void
exit(void)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001c1:	e8 6e 14 00 00       	call   801634 <sys_exit_env>
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8001cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8001d2:	83 c0 04             	add    $0x4,%eax
  8001d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8001d8:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	74 16                	je     8001f7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8001e1:	a1 2c 31 80 00       	mov    0x80312c,%eax
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	50                   	push   %eax
  8001ea:	68 54 1d 80 00       	push   $0x801d54
  8001ef:	e8 92 02 00 00       	call   800486 <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001f7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001fc:	ff 75 0c             	pushl  0xc(%ebp)
  8001ff:	ff 75 08             	pushl  0x8(%ebp)
  800202:	50                   	push   %eax
  800203:	68 59 1d 80 00       	push   $0x801d59
  800208:	e8 79 02 00 00       	call   800486 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800210:	8b 45 10             	mov    0x10(%ebp),%eax
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	ff 75 f4             	pushl  -0xc(%ebp)
  800219:	50                   	push   %eax
  80021a:	e8 fc 01 00 00       	call   80041b <vcprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	6a 00                	push   $0x0
  800227:	68 75 1d 80 00       	push   $0x801d75
  80022c:	e8 ea 01 00 00       	call   80041b <vcprintf>
  800231:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800234:	e8 82 ff ff ff       	call   8001bb <exit>

	// should not return here
	while (1) ;
  800239:	eb fe                	jmp    800239 <_panic+0x70>

0080023b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024f:	39 c2                	cmp    %eax,%edx
  800251:	74 14                	je     800267 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	68 78 1d 80 00       	push   $0x801d78
  80025b:	6a 26                	push   $0x26
  80025d:	68 c4 1d 80 00       	push   $0x801dc4
  800262:	e8 62 ff ff ff       	call   8001c9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80026e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800275:	e9 c5 00 00 00       	jmp    80033f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80027a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	01 d0                	add    %edx,%eax
  800289:	8b 00                	mov    (%eax),%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	75 08                	jne    800297 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80028f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800292:	e9 a5 00 00 00       	jmp    80033c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800297:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80029e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002a5:	eb 69                	jmp    800310 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ac:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002b5:	89 d0                	mov    %edx,%eax
  8002b7:	01 c0                	add    %eax,%eax
  8002b9:	01 d0                	add    %edx,%eax
  8002bb:	c1 e0 03             	shl    $0x3,%eax
  8002be:	01 c8                	add    %ecx,%eax
  8002c0:	8a 40 04             	mov    0x4(%eax),%al
  8002c3:	84 c0                	test   %al,%al
  8002c5:	75 46                	jne    80030d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8002c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cc:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002d5:	89 d0                	mov    %edx,%eax
  8002d7:	01 c0                	add    %eax,%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c1 e0 03             	shl    $0x3,%eax
  8002de:	01 c8                	add    %ecx,%eax
  8002e0:	8b 00                	mov    (%eax),%eax
  8002e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ed:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8002ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	01 c8                	add    %ecx,%eax
  8002fe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800300:	39 c2                	cmp    %eax,%edx
  800302:	75 09                	jne    80030d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800304:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80030b:	eb 15                	jmp    800322 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80030d:	ff 45 e8             	incl   -0x18(%ebp)
  800310:	a1 20 30 80 00       	mov    0x803020,%eax
  800315:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80031b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	77 85                	ja     8002a7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800326:	75 14                	jne    80033c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	68 d0 1d 80 00       	push   $0x801dd0
  800330:	6a 3a                	push   $0x3a
  800332:	68 c4 1d 80 00       	push   $0x801dc4
  800337:	e8 8d fe ff ff       	call   8001c9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80033c:	ff 45 f0             	incl   -0x10(%ebp)
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800345:	0f 8c 2f ff ff ff    	jl     80027a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80034b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800359:	eb 26                	jmp    800381 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80035b:	a1 20 30 80 00       	mov    0x803020,%eax
  800360:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800366:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8a 40 04             	mov    0x4(%eax),%al
  800377:	3c 01                	cmp    $0x1,%al
  800379:	75 03                	jne    80037e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80037b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037e:	ff 45 e0             	incl   -0x20(%ebp)
  800381:	a1 20 30 80 00       	mov    0x803020,%eax
  800386:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80038c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	77 c8                	ja     80035b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800396:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800399:	74 14                	je     8003af <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80039b:	83 ec 04             	sub    $0x4,%esp
  80039e:	68 24 1e 80 00       	push   $0x801e24
  8003a3:	6a 44                	push   $0x44
  8003a5:	68 c4 1d 80 00       	push   $0x801dc4
  8003aa:	e8 1a fe ff ff       	call   8001c9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003af:	90                   	nop
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	89 0a                	mov    %ecx,(%edx)
  8003c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c8:	88 d1                	mov    %dl,%cl
  8003ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003db:	75 2c                	jne    800409 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003dd:	a0 24 30 80 00       	mov    0x803024,%al
  8003e2:	0f b6 c0             	movzbl %al,%eax
  8003e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003e8:	8b 12                	mov    (%edx),%edx
  8003ea:	89 d1                	mov    %edx,%ecx
  8003ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ef:	83 c2 08             	add    $0x8,%edx
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	50                   	push   %eax
  8003f6:	51                   	push   %ecx
  8003f7:	52                   	push   %edx
  8003f8:	e8 b9 0e 00 00       	call   8012b6 <sys_cputs>
  8003fd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800400:	8b 45 0c             	mov    0xc(%ebp),%eax
  800403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040c:	8b 40 04             	mov    0x4(%eax),%eax
  80040f:	8d 50 01             	lea    0x1(%eax),%edx
  800412:	8b 45 0c             	mov    0xc(%ebp),%eax
  800415:	89 50 04             	mov    %edx,0x4(%eax)
}
  800418:	90                   	nop
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800424:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80042b:	00 00 00 
	b.cnt = 0;
  80042e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800435:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800438:	ff 75 0c             	pushl  0xc(%ebp)
  80043b:	ff 75 08             	pushl  0x8(%ebp)
  80043e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800444:	50                   	push   %eax
  800445:	68 b2 03 80 00       	push   $0x8003b2
  80044a:	e8 11 02 00 00       	call   800660 <vprintfmt>
  80044f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800452:	a0 24 30 80 00       	mov    0x803024,%al
  800457:	0f b6 c0             	movzbl %al,%eax
  80045a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	50                   	push   %eax
  800464:	52                   	push   %edx
  800465:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80046b:	83 c0 08             	add    $0x8,%eax
  80046e:	50                   	push   %eax
  80046f:	e8 42 0e 00 00       	call   8012b6 <sys_cputs>
  800474:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800477:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80047e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <cprintf>:

int cprintf(const char *fmt, ...) {
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80048c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800493:	8d 45 0c             	lea    0xc(%ebp),%eax
  800496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a2:	50                   	push   %eax
  8004a3:	e8 73 ff ff ff       	call   80041b <vcprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8004b9:	e8 51 0f 00 00       	call   80140f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004be:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8004cd:	50                   	push   %eax
  8004ce:	e8 48 ff ff ff       	call   80041b <vcprintf>
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004d9:	e8 4b 0f 00 00       	call   801429 <sys_enable_interrupt>
	return cnt;
  8004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	53                   	push   %ebx
  8004e7:	83 ec 14             	sub    $0x14,%esp
  8004ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800501:	77 55                	ja     800558 <printnum+0x75>
  800503:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800506:	72 05                	jb     80050d <printnum+0x2a>
  800508:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80050b:	77 4b                	ja     800558 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80050d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800510:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800513:	8b 45 18             	mov    0x18(%ebp),%eax
  800516:	ba 00 00 00 00       	mov    $0x0,%edx
  80051b:	52                   	push   %edx
  80051c:	50                   	push   %eax
  80051d:	ff 75 f4             	pushl  -0xc(%ebp)
  800520:	ff 75 f0             	pushl  -0x10(%ebp)
  800523:	e8 18 14 00 00       	call   801940 <__udivdi3>
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	ff 75 20             	pushl  0x20(%ebp)
  800531:	53                   	push   %ebx
  800532:	ff 75 18             	pushl  0x18(%ebp)
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	e8 a1 ff ff ff       	call   8004e3 <printnum>
  800542:	83 c4 20             	add    $0x20,%esp
  800545:	eb 1a                	jmp    800561 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 0c             	pushl  0xc(%ebp)
  80054d:	ff 75 20             	pushl  0x20(%ebp)
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	ff d0                	call   *%eax
  800555:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800558:	ff 4d 1c             	decl   0x1c(%ebp)
  80055b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80055f:	7f e6                	jg     800547 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800561:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800564:	bb 00 00 00 00       	mov    $0x0,%ebx
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80056f:	53                   	push   %ebx
  800570:	51                   	push   %ecx
  800571:	52                   	push   %edx
  800572:	50                   	push   %eax
  800573:	e8 d8 14 00 00       	call   801a50 <__umoddi3>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	05 94 20 80 00       	add    $0x802094,%eax
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f be c0             	movsbl %al,%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 0c             	pushl  0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	ff d0                	call   *%eax
  800591:	83 c4 10             	add    $0x10,%esp
}
  800594:	90                   	nop
  800595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800598:	c9                   	leave  
  800599:	c3                   	ret    

0080059a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80059d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a1:	7e 1c                	jle    8005bf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	8d 50 08             	lea    0x8(%eax),%edx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 10                	mov    %edx,(%eax)
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	83 e8 08             	sub    $0x8,%eax
  8005b8:	8b 50 04             	mov    0x4(%eax),%edx
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	eb 40                	jmp    8005ff <getuint+0x65>
	else if (lflag)
  8005bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c3:	74 1e                	je     8005e3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	89 10                	mov    %edx,(%eax)
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	eb 1c                	jmp    8005ff <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 10                	mov    %edx,(%eax)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	83 e8 04             	sub    $0x4,%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005ff:	5d                   	pop    %ebp
  800600:	c3                   	ret    

00800601 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800604:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800608:	7e 1c                	jle    800626 <getint+0x25>
		return va_arg(*ap, long long);
  80060a:	8b 45 08             	mov    0x8(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	8d 50 08             	lea    0x8(%eax),%edx
  800612:	8b 45 08             	mov    0x8(%ebp),%eax
  800615:	89 10                	mov    %edx,(%eax)
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	83 e8 08             	sub    $0x8,%eax
  80061f:	8b 50 04             	mov    0x4(%eax),%edx
  800622:	8b 00                	mov    (%eax),%eax
  800624:	eb 38                	jmp    80065e <getint+0x5d>
	else if (lflag)
  800626:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062a:	74 1a                	je     800646 <getint+0x45>
		return va_arg(*ap, long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 04             	lea    0x4(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 04             	sub    $0x4,%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	99                   	cltd   
  800644:	eb 18                	jmp    80065e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	8d 50 04             	lea    0x4(%eax),%edx
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	89 10                	mov    %edx,(%eax)
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	83 e8 04             	sub    $0x4,%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	99                   	cltd   
}
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    

00800660 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	56                   	push   %esi
  800664:	53                   	push   %ebx
  800665:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800668:	eb 17                	jmp    800681 <vprintfmt+0x21>
			if (ch == '\0')
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	0f 84 af 03 00 00    	je     800a21 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	ff 75 0c             	pushl  0xc(%ebp)
  800678:	53                   	push   %ebx
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800681:	8b 45 10             	mov    0x10(%ebp),%eax
  800684:	8d 50 01             	lea    0x1(%eax),%edx
  800687:	89 55 10             	mov    %edx,0x10(%ebp)
  80068a:	8a 00                	mov    (%eax),%al
  80068c:	0f b6 d8             	movzbl %al,%ebx
  80068f:	83 fb 25             	cmp    $0x25,%ebx
  800692:	75 d6                	jne    80066a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800694:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800698:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80069f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b7:	8d 50 01             	lea    0x1(%eax),%edx
  8006ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f b6 d8             	movzbl %al,%ebx
  8006c2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006c5:	83 f8 55             	cmp    $0x55,%eax
  8006c8:	0f 87 2b 03 00 00    	ja     8009f9 <vprintfmt+0x399>
  8006ce:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  8006d5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006d7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006db:	eb d7                	jmp    8006b4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006dd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e1:	eb d1                	jmp    8006b4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ed:	89 d0                	mov    %edx,%eax
  8006ef:	c1 e0 02             	shl    $0x2,%eax
  8006f2:	01 d0                	add    %edx,%eax
  8006f4:	01 c0                	add    %eax,%eax
  8006f6:	01 d8                	add    %ebx,%eax
  8006f8:	83 e8 30             	sub    $0x30,%eax
  8006fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	8a 00                	mov    (%eax),%al
  800703:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800706:	83 fb 2f             	cmp    $0x2f,%ebx
  800709:	7e 3e                	jle    800749 <vprintfmt+0xe9>
  80070b:	83 fb 39             	cmp    $0x39,%ebx
  80070e:	7f 39                	jg     800749 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800710:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800713:	eb d5                	jmp    8006ea <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	83 c0 04             	add    $0x4,%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800729:	eb 1f                	jmp    80074a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80072b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072f:	79 83                	jns    8006b4 <vprintfmt+0x54>
				width = 0;
  800731:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800738:	e9 77 ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80073d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800744:	e9 6b ff ff ff       	jmp    8006b4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800749:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80074a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074e:	0f 89 60 ff ff ff    	jns    8006b4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800757:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800761:	e9 4e ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800766:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800769:	e9 46 ff ff ff       	jmp    8006b4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	83 c0 04             	add    $0x4,%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	83 e8 04             	sub    $0x4,%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	50                   	push   %eax
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
			break;
  80078e:	e9 89 02 00 00       	jmp    800a1c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	83 c0 04             	add    $0x4,%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	79 02                	jns    8007aa <vprintfmt+0x14a>
				err = -err;
  8007a8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007aa:	83 fb 64             	cmp    $0x64,%ebx
  8007ad:	7f 0b                	jg     8007ba <vprintfmt+0x15a>
  8007af:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  8007b6:	85 f6                	test   %esi,%esi
  8007b8:	75 19                	jne    8007d3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007ba:	53                   	push   %ebx
  8007bb:	68 a5 20 80 00       	push   $0x8020a5
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	ff 75 08             	pushl  0x8(%ebp)
  8007c6:	e8 5e 02 00 00       	call   800a29 <printfmt>
  8007cb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ce:	e9 49 02 00 00       	jmp    800a1c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007d3:	56                   	push   %esi
  8007d4:	68 ae 20 80 00       	push   $0x8020ae
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	e8 45 02 00 00       	call   800a29 <printfmt>
  8007e4:	83 c4 10             	add    $0x10,%esp
			break;
  8007e7:	e9 30 02 00 00       	jmp    800a1c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 c0 04             	add    $0x4,%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 e8 04             	sub    $0x4,%eax
  8007fb:	8b 30                	mov    (%eax),%esi
  8007fd:	85 f6                	test   %esi,%esi
  8007ff:	75 05                	jne    800806 <vprintfmt+0x1a6>
				p = "(null)";
  800801:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080a:	7e 6d                	jle    800879 <vprintfmt+0x219>
  80080c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800810:	74 67                	je     800879 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	50                   	push   %eax
  800819:	56                   	push   %esi
  80081a:	e8 0c 03 00 00       	call   800b2b <strnlen>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800825:	eb 16                	jmp    80083d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800827:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80083a:	ff 4d e4             	decl   -0x1c(%ebp)
  80083d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800841:	7f e4                	jg     800827 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800843:	eb 34                	jmp    800879 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800845:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800849:	74 1c                	je     800867 <vprintfmt+0x207>
  80084b:	83 fb 1f             	cmp    $0x1f,%ebx
  80084e:	7e 05                	jle    800855 <vprintfmt+0x1f5>
  800850:	83 fb 7e             	cmp    $0x7e,%ebx
  800853:	7e 12                	jle    800867 <vprintfmt+0x207>
					putch('?', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 3f                	push   $0x3f
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	eb 0f                	jmp    800876 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	53                   	push   %ebx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	89 f0                	mov    %esi,%eax
  80087b:	8d 70 01             	lea    0x1(%eax),%esi
  80087e:	8a 00                	mov    (%eax),%al
  800880:	0f be d8             	movsbl %al,%ebx
  800883:	85 db                	test   %ebx,%ebx
  800885:	74 24                	je     8008ab <vprintfmt+0x24b>
  800887:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088b:	78 b8                	js     800845 <vprintfmt+0x1e5>
  80088d:	ff 4d e0             	decl   -0x20(%ebp)
  800890:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800894:	79 af                	jns    800845 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800896:	eb 13                	jmp    8008ab <vprintfmt+0x24b>
				putch(' ', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	6a 20                	push   $0x20
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7f e7                	jg     800898 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b1:	e9 66 01 00 00       	jmp    800a1c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bf:	50                   	push   %eax
  8008c0:	e8 3c fd ff ff       	call   800601 <getint>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	79 23                	jns    8008fb <vprintfmt+0x29b>
				putch('-', putdat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	6a 2d                	push   $0x2d
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ee:	f7 d8                	neg    %eax
  8008f0:	83 d2 00             	adc    $0x0,%edx
  8008f3:	f7 da                	neg    %edx
  8008f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008fb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800902:	e9 bc 00 00 00       	jmp    8009c3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	ff 75 e8             	pushl  -0x18(%ebp)
  80090d:	8d 45 14             	lea    0x14(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	e8 84 fc ff ff       	call   80059a <getuint>
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80091f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800926:	e9 98 00 00 00       	jmp    8009c3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	6a 58                	push   $0x58
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	ff d0                	call   *%eax
  800938:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	6a 58                	push   $0x58
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	ff d0                	call   *%eax
  800948:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	6a 58                	push   $0x58
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	ff d0                	call   *%eax
  800958:	83 c4 10             	add    $0x10,%esp
			break;
  80095b:	e9 bc 00 00 00       	jmp    800a1c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	6a 30                	push   $0x30
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	6a 78                	push   $0x78
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	ff d0                	call   *%eax
  80097d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	83 c0 04             	add    $0x4,%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
  800989:	8b 45 14             	mov    0x14(%ebp),%eax
  80098c:	83 e8 04             	sub    $0x4,%eax
  80098f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800991:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80099b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a2:	eb 1f                	jmp    8009c3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ad:	50                   	push   %eax
  8009ae:	e8 e7 fb ff ff       	call   80059a <getuint>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	52                   	push   %edx
  8009ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d1:	50                   	push   %eax
  8009d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 00 fb ff ff       	call   8004e3 <printnum>
  8009e3:	83 c4 20             	add    $0x20,%esp
			break;
  8009e6:	eb 34                	jmp    800a1c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			break;
  8009f7:	eb 23                	jmp    800a1c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 25                	push   $0x25
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a09:	ff 4d 10             	decl   0x10(%ebp)
  800a0c:	eb 03                	jmp    800a11 <vprintfmt+0x3b1>
  800a0e:	ff 4d 10             	decl   0x10(%ebp)
  800a11:	8b 45 10             	mov    0x10(%ebp),%eax
  800a14:	48                   	dec    %eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	3c 25                	cmp    $0x25,%al
  800a19:	75 f3                	jne    800a0e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a1b:	90                   	nop
		}
	}
  800a1c:	e9 47 fc ff ff       	jmp    800668 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a21:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a25:	5b                   	pop    %ebx
  800a26:	5e                   	pop    %esi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a32:	83 c0 04             	add    $0x4,%eax
  800a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a38:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3e:	50                   	push   %eax
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 16 fc ff ff       	call   800660 <vprintfmt>
  800a4a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a4d:	90                   	nop
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8b 40 08             	mov    0x8(%eax),%eax
  800a59:	8d 50 01             	lea    0x1(%eax),%edx
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a65:	8b 10                	mov    (%eax),%edx
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8b 40 04             	mov    0x4(%eax),%eax
  800a6d:	39 c2                	cmp    %eax,%edx
  800a6f:	73 12                	jae    800a83 <sprintputch+0x33>
		*b->buf++ = ch;
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	8d 48 01             	lea    0x1(%eax),%ecx
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 0a                	mov    %ecx,(%edx)
  800a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a81:	88 10                	mov    %dl,(%eax)
}
  800a83:	90                   	nop
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	01 d0                	add    %edx,%eax
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aab:	74 06                	je     800ab3 <vsnprintf+0x2d>
  800aad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab1:	7f 07                	jg     800aba <vsnprintf+0x34>
		return -E_INVAL;
  800ab3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab8:	eb 20                	jmp    800ada <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aba:	ff 75 14             	pushl  0x14(%ebp)
  800abd:	ff 75 10             	pushl  0x10(%ebp)
  800ac0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac3:	50                   	push   %eax
  800ac4:	68 50 0a 80 00       	push   $0x800a50
  800ac9:	e8 92 fb ff ff       	call   800660 <vprintfmt>
  800ace:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae5:	83 c0 04             	add    $0x4,%eax
  800ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800aee:	ff 75 f4             	pushl  -0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 89 ff ff ff       	call   800a86 <vsnprintf>
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b06:	c9                   	leave  
  800b07:	c3                   	ret    

00800b08 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b15:	eb 06                	jmp    800b1d <strlen+0x15>
		n++;
  800b17:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b1a:	ff 45 08             	incl   0x8(%ebp)
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 f1                	jne    800b17 <strlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b38:	eb 09                	jmp    800b43 <strnlen+0x18>
		n++;
  800b3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3d:	ff 45 08             	incl   0x8(%ebp)
  800b40:	ff 4d 0c             	decl   0xc(%ebp)
  800b43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b47:	74 09                	je     800b52 <strnlen+0x27>
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	84 c0                	test   %al,%al
  800b50:	75 e8                	jne    800b3a <strnlen+0xf>
		n++;
	return n;
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b63:	90                   	nop
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8d 50 01             	lea    0x1(%eax),%edx
  800b6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b73:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b76:	8a 12                	mov    (%edx),%dl
  800b78:	88 10                	mov    %dl,(%eax)
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	84 c0                	test   %al,%al
  800b7e:	75 e4                	jne    800b64 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b98:	eb 1f                	jmp    800bb9 <strncpy+0x34>
		*dst++ = *src;
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ba0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba6:	8a 12                	mov    (%edx),%dl
  800ba8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	84 c0                	test   %al,%al
  800bb1:	74 03                	je     800bb6 <strncpy+0x31>
			src++;
  800bb3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
  800bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bbf:	72 d9                	jb     800b9a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd6:	74 30                	je     800c08 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bd8:	eb 16                	jmp    800bf0 <strlcpy+0x2a>
			*dst++ = *src++;
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8d 50 01             	lea    0x1(%eax),%edx
  800be0:	89 55 08             	mov    %edx,0x8(%ebp)
  800be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bec:	8a 12                	mov    (%edx),%dl
  800bee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bf0:	ff 4d 10             	decl   0x10(%ebp)
  800bf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf7:	74 09                	je     800c02 <strlcpy+0x3c>
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 d8                	jne    800bda <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0e:	29 c2                	sub    %eax,%edx
  800c10:	89 d0                	mov    %edx,%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c17:	eb 06                	jmp    800c1f <strcmp+0xb>
		p++, q++;
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	84 c0                	test   %al,%al
  800c26:	74 0e                	je     800c36 <strcmp+0x22>
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8a 10                	mov    (%eax),%dl
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	38 c2                	cmp    %al,%dl
  800c34:	74 e3                	je     800c19 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	0f b6 d0             	movzbl %al,%edx
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	0f b6 c0             	movzbl %al,%eax
  800c46:	29 c2                	sub    %eax,%edx
  800c48:	89 d0                	mov    %edx,%eax
}
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c4f:	eb 09                	jmp    800c5a <strncmp+0xe>
		n--, p++, q++;
  800c51:	ff 4d 10             	decl   0x10(%ebp)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5e:	74 17                	je     800c77 <strncmp+0x2b>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	74 0e                	je     800c77 <strncmp+0x2b>
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 10                	mov    (%eax),%dl
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	38 c2                	cmp    %al,%dl
  800c75:	74 da                	je     800c51 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	75 07                	jne    800c84 <strncmp+0x38>
		return 0;
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c82:	eb 14                	jmp    800c98 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	0f b6 d0             	movzbl %al,%edx
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 c0             	movzbl %al,%eax
  800c94:	29 c2                	sub    %eax,%edx
  800c96:	89 d0                	mov    %edx,%eax
}
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 04             	sub    $0x4,%esp
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca6:	eb 12                	jmp    800cba <strchr+0x20>
		if (*s == c)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb0:	75 05                	jne    800cb7 <strchr+0x1d>
			return (char *) s;
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	eb 11                	jmp    800cc8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e5                	jne    800ca8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cd6:	eb 0d                	jmp    800ce5 <strfind+0x1b>
		if (*s == c)
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ce0:	74 0e                	je     800cf0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ce2:	ff 45 08             	incl   0x8(%ebp)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 ea                	jne    800cd8 <strfind+0xe>
  800cee:	eb 01                	jmp    800cf1 <strfind+0x27>
		if (*s == c)
			break;
  800cf0:	90                   	nop
	return (char *) s;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d08:	eb 0e                	jmp    800d18 <memset+0x22>
		*p++ = c;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	8d 50 01             	lea    0x1(%eax),%edx
  800d10:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d16:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d18:	ff 4d f8             	decl   -0x8(%ebp)
  800d1b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d1f:	79 e9                	jns    800d0a <memset+0x14>
		*p++ = c;

	return v;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d38:	eb 16                	jmp    800d50 <memcpy+0x2a>
		*d++ = *s++;
  800d3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d3d:	8d 50 01             	lea    0x1(%eax),%edx
  800d40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d49:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d4c:	8a 12                	mov    (%edx),%dl
  800d4e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d56:	89 55 10             	mov    %edx,0x10(%ebp)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	75 dd                	jne    800d3a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d7a:	73 50                	jae    800dcc <memmove+0x6a>
  800d7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	01 d0                	add    %edx,%eax
  800d84:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d87:	76 43                	jbe    800dcc <memmove+0x6a>
		s += n;
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d95:	eb 10                	jmp    800da7 <memmove+0x45>
			*--d = *--s;
  800d97:	ff 4d f8             	decl   -0x8(%ebp)
  800d9a:	ff 4d fc             	decl   -0x4(%ebp)
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da0:	8a 10                	mov    (%eax),%dl
  800da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dad:	89 55 10             	mov    %edx,0x10(%ebp)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	75 e3                	jne    800d97 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db4:	eb 23                	jmp    800dd9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd2:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	75 dd                	jne    800db6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800df0:	eb 2a                	jmp    800e1c <memcmp+0x3e>
		if (*s1 != *s2)
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	8a 10                	mov    (%eax),%dl
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	38 c2                	cmp    %al,%dl
  800dfe:	74 16                	je     800e16 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	0f b6 d0             	movzbl %al,%edx
  800e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	0f b6 c0             	movzbl %al,%eax
  800e10:	29 c2                	sub    %eax,%edx
  800e12:	89 d0                	mov    %edx,%eax
  800e14:	eb 18                	jmp    800e2e <memcmp+0x50>
		s1++, s2++;
  800e16:	ff 45 fc             	incl   -0x4(%ebp)
  800e19:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e22:	89 55 10             	mov    %edx,0x10(%ebp)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	75 c9                	jne    800df2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 d0                	add    %edx,%eax
  800e3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e41:	eb 15                	jmp    800e58 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	0f b6 d0             	movzbl %al,%edx
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	0f b6 c0             	movzbl %al,%eax
  800e51:	39 c2                	cmp    %eax,%edx
  800e53:	74 0d                	je     800e62 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e5e:	72 e3                	jb     800e43 <memfind+0x13>
  800e60:	eb 01                	jmp    800e63 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e62:	90                   	nop
	return (void *) s;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e7c:	eb 03                	jmp    800e81 <strtol+0x19>
		s++;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 20                	cmp    $0x20,%al
  800e88:	74 f4                	je     800e7e <strtol+0x16>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 09                	cmp    $0x9,%al
  800e91:	74 eb                	je     800e7e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	3c 2b                	cmp    $0x2b,%al
  800e9a:	75 05                	jne    800ea1 <strtol+0x39>
		s++;
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	eb 13                	jmp    800eb4 <strtol+0x4c>
	else if (*s == '-')
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	3c 2d                	cmp    $0x2d,%al
  800ea8:	75 0a                	jne    800eb4 <strtol+0x4c>
		s++, neg = 1;
  800eaa:	ff 45 08             	incl   0x8(%ebp)
  800ead:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	74 06                	je     800ec0 <strtol+0x58>
  800eba:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ebe:	75 20                	jne    800ee0 <strtol+0x78>
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	3c 30                	cmp    $0x30,%al
  800ec7:	75 17                	jne    800ee0 <strtol+0x78>
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	40                   	inc    %eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3c 78                	cmp    $0x78,%al
  800ed1:	75 0d                	jne    800ee0 <strtol+0x78>
		s += 2, base = 16;
  800ed3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ed7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ede:	eb 28                	jmp    800f08 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ee0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee4:	75 15                	jne    800efb <strtol+0x93>
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 30                	cmp    $0x30,%al
  800eed:	75 0c                	jne    800efb <strtol+0x93>
		s++, base = 8;
  800eef:	ff 45 08             	incl   0x8(%ebp)
  800ef2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ef9:	eb 0d                	jmp    800f08 <strtol+0xa0>
	else if (base == 0)
  800efb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eff:	75 07                	jne    800f08 <strtol+0xa0>
		base = 10;
  800f01:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 2f                	cmp    $0x2f,%al
  800f0f:	7e 19                	jle    800f2a <strtol+0xc2>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 39                	cmp    $0x39,%al
  800f18:	7f 10                	jg     800f2a <strtol+0xc2>
			dig = *s - '0';
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	0f be c0             	movsbl %al,%eax
  800f22:	83 e8 30             	sub    $0x30,%eax
  800f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f28:	eb 42                	jmp    800f6c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 60                	cmp    $0x60,%al
  800f31:	7e 19                	jle    800f4c <strtol+0xe4>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 7a                	cmp    $0x7a,%al
  800f3a:	7f 10                	jg     800f4c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	0f be c0             	movsbl %al,%eax
  800f44:	83 e8 57             	sub    $0x57,%eax
  800f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f4a:	eb 20                	jmp    800f6c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 40                	cmp    $0x40,%al
  800f53:	7e 39                	jle    800f8e <strtol+0x126>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	3c 5a                	cmp    $0x5a,%al
  800f5c:	7f 30                	jg     800f8e <strtol+0x126>
			dig = *s - 'A' + 10;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f be c0             	movsbl %al,%eax
  800f66:	83 e8 37             	sub    $0x37,%eax
  800f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f72:	7d 19                	jge    800f8d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f7e:	89 c2                	mov    %eax,%edx
  800f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f83:	01 d0                	add    %edx,%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f88:	e9 7b ff ff ff       	jmp    800f08 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f8d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	74 08                	je     800f9c <strtol+0x134>
		*endptr = (char *) s;
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fa0:	74 07                	je     800fa9 <strtol+0x141>
  800fa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa5:	f7 d8                	neg    %eax
  800fa7:	eb 03                	jmp    800fac <strtol+0x144>
  800fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fac:	c9                   	leave  
  800fad:	c3                   	ret    

00800fae <ltostr>:

void
ltostr(long value, char *str)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fc6:	79 13                	jns    800fdb <ltostr+0x2d>
	{
		neg = 1;
  800fc8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fd5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fd8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fe3:	99                   	cltd   
  800fe4:	f7 f9                	idiv   %ecx
  800fe6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	8d 50 01             	lea    0x1(%eax),%edx
  800fef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	01 d0                	add    %edx,%eax
  800ff9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ffc:	83 c2 30             	add    $0x30,%edx
  800fff:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801001:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801004:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801009:	f7 e9                	imul   %ecx
  80100b:	c1 fa 02             	sar    $0x2,%edx
  80100e:	89 c8                	mov    %ecx,%eax
  801010:	c1 f8 1f             	sar    $0x1f,%eax
  801013:	29 c2                	sub    %eax,%edx
  801015:	89 d0                	mov    %edx,%eax
  801017:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80101a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801022:	f7 e9                	imul   %ecx
  801024:	c1 fa 02             	sar    $0x2,%edx
  801027:	89 c8                	mov    %ecx,%eax
  801029:	c1 f8 1f             	sar    $0x1f,%eax
  80102c:	29 c2                	sub    %eax,%edx
  80102e:	89 d0                	mov    %edx,%eax
  801030:	c1 e0 02             	shl    $0x2,%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	01 c0                	add    %eax,%eax
  801037:	29 c1                	sub    %eax,%ecx
  801039:	89 ca                	mov    %ecx,%edx
  80103b:	85 d2                	test   %edx,%edx
  80103d:	75 9c                	jne    800fdb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80103f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	48                   	dec    %eax
  80104a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80104d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801051:	74 3d                	je     801090 <ltostr+0xe2>
		start = 1 ;
  801053:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80105a:	eb 34                	jmp    801090 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 d0                	add    %edx,%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	01 c2                	add    %eax,%edx
  801071:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 c8                	add    %ecx,%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80107d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	01 c2                	add    %eax,%edx
  801085:	8a 45 eb             	mov    -0x15(%ebp),%al
  801088:	88 02                	mov    %al,(%edx)
		start++ ;
  80108a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80108d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801093:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801096:	7c c4                	jl     80105c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801098:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010a3:	90                   	nop
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010ac:	ff 75 08             	pushl  0x8(%ebp)
  8010af:	e8 54 fa ff ff       	call   800b08 <strlen>
  8010b4:	83 c4 04             	add    $0x4,%esp
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	e8 46 fa ff ff       	call   800b08 <strlen>
  8010c2:	83 c4 04             	add    $0x4,%esp
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d6:	eb 17                	jmp    8010ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8010d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	01 c8                	add    %ecx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ec:	ff 45 fc             	incl   -0x4(%ebp)
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f5:	7c e1                	jl     8010d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801105:	eb 1f                	jmp    801126 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801110:	89 c2                	mov    %eax,%edx
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	01 c2                	add    %eax,%edx
  801117:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 c8                	add    %ecx,%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801123:	ff 45 f8             	incl   -0x8(%ebp)
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	7c d9                	jl     801107 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80112e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	c6 00 00             	movb   $0x0,(%eax)
}
  801139:	90                   	nop
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801148:	8b 45 14             	mov    0x14(%ebp),%eax
  80114b:	8b 00                	mov    (%eax),%eax
  80114d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80115f:	eb 0c                	jmp    80116d <strsplit+0x31>
			*string++ = 0;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	84 c0                	test   %al,%al
  801174:	74 18                	je     80118e <strsplit+0x52>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	50                   	push   %eax
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	e8 13 fb ff ff       	call   800c9a <strchr>
  801187:	83 c4 08             	add    $0x8,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	75 d3                	jne    801161 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	84 c0                	test   %al,%al
  801195:	74 5a                	je     8011f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801197:	8b 45 14             	mov    0x14(%ebp),%eax
  80119a:	8b 00                	mov    (%eax),%eax
  80119c:	83 f8 0f             	cmp    $0xf,%eax
  80119f:	75 07                	jne    8011a8 <strsplit+0x6c>
		{
			return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	eb 66                	jmp    80120e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ab:	8b 00                	mov    (%eax),%eax
  8011ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8011b3:	89 0a                	mov    %ecx,(%edx)
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	01 c2                	add    %eax,%edx
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c6:	eb 03                	jmp    8011cb <strsplit+0x8f>
			string++;
  8011c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 8b                	je     80115f <strsplit+0x23>
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	0f be c0             	movsbl %al,%eax
  8011dc:	50                   	push   %eax
  8011dd:	ff 75 0c             	pushl  0xc(%ebp)
  8011e0:	e8 b5 fa ff ff       	call   800c9a <strchr>
  8011e5:	83 c4 08             	add    $0x8,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	74 dc                	je     8011c8 <strsplit+0x8c>
			string++;
	}
  8011ec:	e9 6e ff ff ff       	jmp    80115f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f5:	8b 00                	mov    (%eax),%eax
  8011f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801209:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121d:	eb 4c                	jmp    80126b <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3c 40                	cmp    $0x40,%al
  80122b:	7e 27                	jle    801254 <str2lower+0x44>
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	3c 5a                	cmp    $0x5a,%al
  801239:	7f 19                	jg     801254 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
  801249:	01 ca                	add    %ecx,%edx
  80124b:	8a 12                	mov    (%edx),%dl
  80124d:	83 c2 20             	add    $0x20,%edx
  801250:	88 10                	mov    %dl,(%eax)
  801252:	eb 14                	jmp    801268 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801254:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	01 c2                	add    %eax,%edx
  80125c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 c8                	add    %ecx,%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801268:	ff 45 fc             	incl   -0x4(%ebp)
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	e8 95 f8 ff ff       	call   800b08 <strlen>
  801273:	83 c4 04             	add    $0x4,%esp
  801276:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801279:	7f a4                	jg     80121f <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  80127b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012a6:	cd 30                	int    $0x30
  8012a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    

008012b6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	83 ec 04             	sub    $0x4,%esp
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	52                   	push   %edx
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	50                   	push   %eax
  8012d2:	6a 00                	push   $0x0
  8012d4:	e8 b2 ff ff ff       	call   80128b <syscall>
  8012d9:	83 c4 18             	add    $0x18,%esp
}
  8012dc:	90                   	nop
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_cgetc>:

int
sys_cgetc(void)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 01                	push   $0x1
  8012ee:	e8 98 ff ff ff       	call   80128b <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	6a 05                	push   $0x5
  80130b:	e8 7b ff ff ff       	call   80128b <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	56                   	push   %esi
  801319:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80131a:	8b 75 18             	mov    0x18(%ebp),%esi
  80131d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801320:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	51                   	push   %ecx
  80132c:	52                   	push   %edx
  80132d:	50                   	push   %eax
  80132e:	6a 06                	push   $0x6
  801330:	e8 56 ff ff ff       	call   80128b <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80133b:	5b                   	pop    %ebx
  80133c:	5e                   	pop    %esi
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    

0080133f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801342:	8b 55 0c             	mov    0xc(%ebp),%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	52                   	push   %edx
  80134f:	50                   	push   %eax
  801350:	6a 07                	push   $0x7
  801352:	e8 34 ff ff ff       	call   80128b <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	ff 75 08             	pushl  0x8(%ebp)
  80136b:	6a 08                	push   $0x8
  80136d:	e8 19 ff ff ff       	call   80128b <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 09                	push   $0x9
  801386:	e8 00 ff ff ff       	call   80128b <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 0a                	push   $0xa
  80139f:	e8 e7 fe ff ff       	call   80128b <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 0b                	push   $0xb
  8013b8:	e8 ce fe ff ff       	call   80128b <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 0c                	push   $0xc
  8013d1:	e8 b5 fe ff ff       	call   80128b <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	ff 75 08             	pushl  0x8(%ebp)
  8013e9:	6a 0d                	push   $0xd
  8013eb:	e8 9b fe ff ff       	call   80128b <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 0e                	push   $0xe
  801404:	e8 82 fe ff ff       	call   80128b <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 11                	push   $0x11
  80141e:	e8 68 fe ff ff       	call   80128b <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 12                	push   $0x12
  801438:	e8 4e fe ff ff       	call   80128b <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_cputc>:


void
sys_cputc(const char c)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80144f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	50                   	push   %eax
  80145c:	6a 13                	push   $0x13
  80145e:	e8 28 fe ff ff       	call   80128b <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	90                   	nop
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 14                	push   $0x14
  801478:	e8 0e fe ff ff       	call   80128b <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	50                   	push   %eax
  801493:	6a 15                	push   $0x15
  801495:	e8 f1 fd ff ff       	call   80128b <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	52                   	push   %edx
  8014af:	50                   	push   %eax
  8014b0:	6a 18                	push   $0x18
  8014b2:	e8 d4 fd ff ff       	call   80128b <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	52                   	push   %edx
  8014cc:	50                   	push   %eax
  8014cd:	6a 16                	push   $0x16
  8014cf:	e8 b7 fd ff ff       	call   80128b <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	90                   	nop
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	52                   	push   %edx
  8014ea:	50                   	push   %eax
  8014eb:	6a 17                	push   $0x17
  8014ed:	e8 99 fd ff ff       	call   80128b <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801504:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801507:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	51                   	push   %ecx
  801511:	52                   	push   %edx
  801512:	ff 75 0c             	pushl  0xc(%ebp)
  801515:	50                   	push   %eax
  801516:	6a 19                	push   $0x19
  801518:	e8 6e fd ff ff       	call   80128b <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801525:	8b 55 0c             	mov    0xc(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	52                   	push   %edx
  801532:	50                   	push   %eax
  801533:	6a 1a                	push   $0x1a
  801535:	e8 51 fd ff ff       	call   80128b <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801542:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	51                   	push   %ecx
  801550:	52                   	push   %edx
  801551:	50                   	push   %eax
  801552:	6a 1b                	push   $0x1b
  801554:	e8 32 fd ff ff       	call   80128b <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	6a 1c                	push   $0x1c
  801571:	e8 15 fd ff ff       	call   80128b <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 1d                	push   $0x1d
  80158a:	e8 fc fc ff ff       	call   80128b <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	ff 75 14             	pushl  0x14(%ebp)
  80159f:	ff 75 10             	pushl  0x10(%ebp)
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	6a 1e                	push   $0x1e
  8015a8:	e8 de fc ff ff       	call   80128b <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	50                   	push   %eax
  8015c1:	6a 1f                	push   $0x1f
  8015c3:	e8 c3 fc ff ff       	call   80128b <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	90                   	nop
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	50                   	push   %eax
  8015dd:	6a 20                	push   $0x20
  8015df:	e8 a7 fc ff ff       	call   80128b <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 02                	push   $0x2
  8015f8:	e8 8e fc ff ff       	call   80128b <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 03                	push   $0x3
  801611:	e8 75 fc ff ff       	call   80128b <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 04                	push   $0x4
  80162a:	e8 5c fc ff ff       	call   80128b <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_exit_env>:


void sys_exit_env(void)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 21                	push   $0x21
  801643:	e8 43 fc ff ff       	call   80128b <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801654:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801657:	8d 50 04             	lea    0x4(%eax),%edx
  80165a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	52                   	push   %edx
  801664:	50                   	push   %eax
  801665:	6a 22                	push   $0x22
  801667:	e8 1f fc ff ff       	call   80128b <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
	return result;
  80166f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801678:	89 01                	mov    %eax,(%ecx)
  80167a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	c9                   	leave  
  801681:	c2 04 00             	ret    $0x4

00801684 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	ff 75 10             	pushl  0x10(%ebp)
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	6a 10                	push   $0x10
  801696:	e8 f0 fb ff ff       	call   80128b <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
	return ;
  80169e:	90                   	nop
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 23                	push   $0x23
  8016b0:	e8 d6 fb ff ff       	call   80128b <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016c6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	50                   	push   %eax
  8016d3:	6a 24                	push   $0x24
  8016d5:	e8 b1 fb ff ff       	call   80128b <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
	return ;
  8016dd:	90                   	nop
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <rsttst>:
void rsttst()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 26                	push   $0x26
  8016ef:	e8 97 fb ff ff       	call   80128b <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f7:	90                   	nop
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 45 14             	mov    0x14(%ebp),%eax
  801703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801706:	8b 55 18             	mov    0x18(%ebp),%edx
  801709:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170d:	52                   	push   %edx
  80170e:	50                   	push   %eax
  80170f:	ff 75 10             	pushl  0x10(%ebp)
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	ff 75 08             	pushl  0x8(%ebp)
  801718:	6a 25                	push   $0x25
  80171a:	e8 6c fb ff ff       	call   80128b <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
	return ;
  801722:	90                   	nop
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <chktst>:
void chktst(uint32 n)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	6a 27                	push   $0x27
  801735:	e8 51 fb ff ff       	call   80128b <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
	return ;
  80173d:	90                   	nop
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <inctst>:

void inctst()
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 28                	push   $0x28
  80174f:	e8 37 fb ff ff       	call   80128b <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
	return ;
  801757:	90                   	nop
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <gettst>:
uint32 gettst()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 29                	push   $0x29
  801769:	e8 1d fb ff ff       	call   80128b <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 2a                	push   $0x2a
  801785:	e8 01 fb ff ff       	call   80128b <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
  80178d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801790:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801794:	75 07                	jne    80179d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801796:	b8 01 00 00 00       	mov    $0x1,%eax
  80179b:	eb 05                	jmp    8017a2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 2a                	push   $0x2a
  8017b6:	e8 d0 fa ff ff       	call   80128b <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
  8017be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017c1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017c5:	75 07                	jne    8017ce <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cc:	eb 05                	jmp    8017d3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 2a                	push   $0x2a
  8017e7:	e8 9f fa ff ff       	call   80128b <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
  8017ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017f2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017f6:	75 07                	jne    8017ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fd:	eb 05                	jmp    801804 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 2a                	push   $0x2a
  801818:	e8 6e fa ff ff       	call   80128b <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801823:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801827:	75 07                	jne    801830 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801829:	b8 01 00 00 00       	mov    $0x1,%eax
  80182e:	eb 05                	jmp    801835 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	6a 2b                	push   $0x2b
  801847:	e8 3f fa ff ff       	call   80128b <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
	return ;
  80184f:	90                   	nop
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801856:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801859:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	53                   	push   %ebx
  801865:	51                   	push   %ecx
  801866:	52                   	push   %edx
  801867:	50                   	push   %eax
  801868:	6a 2c                	push   $0x2c
  80186a:	e8 1c fa ff ff       	call   80128b <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80187a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 2d                	push   $0x2d
  80188a:	e8 fc f9 ff ff       	call   80128b <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801897:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	51                   	push   %ecx
  8018a3:	ff 75 10             	pushl  0x10(%ebp)
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 2e                	push   $0x2e
  8018aa:	e8 dc f9 ff ff       	call   80128b <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	ff 75 10             	pushl  0x10(%ebp)
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	6a 0f                	push   $0xf
  8018c6:	e8 c0 f9 ff ff       	call   80128b <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ce:	90                   	nop
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 2f                	push   $0x2f
  8018e2:	e8 a4 f9 ff ff       	call   80128b <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp

}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	6a 30                	push   $0x30
  8018fd:	e8 89 f9 ff ff       	call   80128b <syscall>
  801902:	83 c4 18             	add    $0x18,%esp

}
  801905:	90                   	nop
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 31                	push   $0x31
  801919:	e8 6d f9 ff ff       	call   80128b <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp

}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 32                	push   $0x32
  801933:	e8 53 f9 ff ff       	call   80128b <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
  80193d:	66 90                	xchg   %ax,%ax
  80193f:	90                   	nop

00801940 <__udivdi3>:
  801940:	55                   	push   %ebp
  801941:	57                   	push   %edi
  801942:	56                   	push   %esi
  801943:	53                   	push   %ebx
  801944:	83 ec 1c             	sub    $0x1c,%esp
  801947:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80194b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80194f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801953:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801957:	89 ca                	mov    %ecx,%edx
  801959:	89 f8                	mov    %edi,%eax
  80195b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80195f:	85 f6                	test   %esi,%esi
  801961:	75 2d                	jne    801990 <__udivdi3+0x50>
  801963:	39 cf                	cmp    %ecx,%edi
  801965:	77 65                	ja     8019cc <__udivdi3+0x8c>
  801967:	89 fd                	mov    %edi,%ebp
  801969:	85 ff                	test   %edi,%edi
  80196b:	75 0b                	jne    801978 <__udivdi3+0x38>
  80196d:	b8 01 00 00 00       	mov    $0x1,%eax
  801972:	31 d2                	xor    %edx,%edx
  801974:	f7 f7                	div    %edi
  801976:	89 c5                	mov    %eax,%ebp
  801978:	31 d2                	xor    %edx,%edx
  80197a:	89 c8                	mov    %ecx,%eax
  80197c:	f7 f5                	div    %ebp
  80197e:	89 c1                	mov    %eax,%ecx
  801980:	89 d8                	mov    %ebx,%eax
  801982:	f7 f5                	div    %ebp
  801984:	89 cf                	mov    %ecx,%edi
  801986:	89 fa                	mov    %edi,%edx
  801988:	83 c4 1c             	add    $0x1c,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    
  801990:	39 ce                	cmp    %ecx,%esi
  801992:	77 28                	ja     8019bc <__udivdi3+0x7c>
  801994:	0f bd fe             	bsr    %esi,%edi
  801997:	83 f7 1f             	xor    $0x1f,%edi
  80199a:	75 40                	jne    8019dc <__udivdi3+0x9c>
  80199c:	39 ce                	cmp    %ecx,%esi
  80199e:	72 0a                	jb     8019aa <__udivdi3+0x6a>
  8019a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019a4:	0f 87 9e 00 00 00    	ja     801a48 <__udivdi3+0x108>
  8019aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019af:	89 fa                	mov    %edi,%edx
  8019b1:	83 c4 1c             	add    $0x1c,%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5f                   	pop    %edi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    
  8019b9:	8d 76 00             	lea    0x0(%esi),%esi
  8019bc:	31 ff                	xor    %edi,%edi
  8019be:	31 c0                	xor    %eax,%eax
  8019c0:	89 fa                	mov    %edi,%edx
  8019c2:	83 c4 1c             	add    $0x1c,%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5f                   	pop    %edi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	f7 f7                	div    %edi
  8019d0:	31 ff                	xor    %edi,%edi
  8019d2:	89 fa                	mov    %edi,%edx
  8019d4:	83 c4 1c             	add    $0x1c,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
  8019dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019e1:	89 eb                	mov    %ebp,%ebx
  8019e3:	29 fb                	sub    %edi,%ebx
  8019e5:	89 f9                	mov    %edi,%ecx
  8019e7:	d3 e6                	shl    %cl,%esi
  8019e9:	89 c5                	mov    %eax,%ebp
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 ed                	shr    %cl,%ebp
  8019ef:	89 e9                	mov    %ebp,%ecx
  8019f1:	09 f1                	or     %esi,%ecx
  8019f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019f7:	89 f9                	mov    %edi,%ecx
  8019f9:	d3 e0                	shl    %cl,%eax
  8019fb:	89 c5                	mov    %eax,%ebp
  8019fd:	89 d6                	mov    %edx,%esi
  8019ff:	88 d9                	mov    %bl,%cl
  801a01:	d3 ee                	shr    %cl,%esi
  801a03:	89 f9                	mov    %edi,%ecx
  801a05:	d3 e2                	shl    %cl,%edx
  801a07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a0b:	88 d9                	mov    %bl,%cl
  801a0d:	d3 e8                	shr    %cl,%eax
  801a0f:	09 c2                	or     %eax,%edx
  801a11:	89 d0                	mov    %edx,%eax
  801a13:	89 f2                	mov    %esi,%edx
  801a15:	f7 74 24 0c          	divl   0xc(%esp)
  801a19:	89 d6                	mov    %edx,%esi
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	f7 e5                	mul    %ebp
  801a1f:	39 d6                	cmp    %edx,%esi
  801a21:	72 19                	jb     801a3c <__udivdi3+0xfc>
  801a23:	74 0b                	je     801a30 <__udivdi3+0xf0>
  801a25:	89 d8                	mov    %ebx,%eax
  801a27:	31 ff                	xor    %edi,%edi
  801a29:	e9 58 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a34:	89 f9                	mov    %edi,%ecx
  801a36:	d3 e2                	shl    %cl,%edx
  801a38:	39 c2                	cmp    %eax,%edx
  801a3a:	73 e9                	jae    801a25 <__udivdi3+0xe5>
  801a3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a3f:	31 ff                	xor    %edi,%edi
  801a41:	e9 40 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a46:	66 90                	xchg   %ax,%ax
  801a48:	31 c0                	xor    %eax,%eax
  801a4a:	e9 37 ff ff ff       	jmp    801986 <__udivdi3+0x46>
  801a4f:	90                   	nop

00801a50 <__umoddi3>:
  801a50:	55                   	push   %ebp
  801a51:	57                   	push   %edi
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 1c             	sub    $0x1c,%esp
  801a57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6f:	89 f3                	mov    %esi,%ebx
  801a71:	89 fa                	mov    %edi,%edx
  801a73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	75 1a                	jne    801a98 <__umoddi3+0x48>
  801a7e:	39 f7                	cmp    %esi,%edi
  801a80:	0f 86 a2 00 00 00    	jbe    801b28 <__umoddi3+0xd8>
  801a86:	89 c8                	mov    %ecx,%eax
  801a88:	89 f2                	mov    %esi,%edx
  801a8a:	f7 f7                	div    %edi
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	31 d2                	xor    %edx,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	39 f0                	cmp    %esi,%eax
  801a9a:	0f 87 ac 00 00 00    	ja     801b4c <__umoddi3+0xfc>
  801aa0:	0f bd e8             	bsr    %eax,%ebp
  801aa3:	83 f5 1f             	xor    $0x1f,%ebp
  801aa6:	0f 84 ac 00 00 00    	je     801b58 <__umoddi3+0x108>
  801aac:	bf 20 00 00 00       	mov    $0x20,%edi
  801ab1:	29 ef                	sub    %ebp,%edi
  801ab3:	89 fe                	mov    %edi,%esi
  801ab5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ab9:	89 e9                	mov    %ebp,%ecx
  801abb:	d3 e0                	shl    %cl,%eax
  801abd:	89 d7                	mov    %edx,%edi
  801abf:	89 f1                	mov    %esi,%ecx
  801ac1:	d3 ef                	shr    %cl,%edi
  801ac3:	09 c7                	or     %eax,%edi
  801ac5:	89 e9                	mov    %ebp,%ecx
  801ac7:	d3 e2                	shl    %cl,%edx
  801ac9:	89 14 24             	mov    %edx,(%esp)
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	d3 e0                	shl    %cl,%eax
  801ad0:	89 c2                	mov    %eax,%edx
  801ad2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ad6:	d3 e0                	shl    %cl,%eax
  801ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae0:	89 f1                	mov    %esi,%ecx
  801ae2:	d3 e8                	shr    %cl,%eax
  801ae4:	09 d0                	or     %edx,%eax
  801ae6:	d3 eb                	shr    %cl,%ebx
  801ae8:	89 da                	mov    %ebx,%edx
  801aea:	f7 f7                	div    %edi
  801aec:	89 d3                	mov    %edx,%ebx
  801aee:	f7 24 24             	mull   (%esp)
  801af1:	89 c6                	mov    %eax,%esi
  801af3:	89 d1                	mov    %edx,%ecx
  801af5:	39 d3                	cmp    %edx,%ebx
  801af7:	0f 82 87 00 00 00    	jb     801b84 <__umoddi3+0x134>
  801afd:	0f 84 91 00 00 00    	je     801b94 <__umoddi3+0x144>
  801b03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b07:	29 f2                	sub    %esi,%edx
  801b09:	19 cb                	sbb    %ecx,%ebx
  801b0b:	89 d8                	mov    %ebx,%eax
  801b0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b11:	d3 e0                	shl    %cl,%eax
  801b13:	89 e9                	mov    %ebp,%ecx
  801b15:	d3 ea                	shr    %cl,%edx
  801b17:	09 d0                	or     %edx,%eax
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 eb                	shr    %cl,%ebx
  801b1d:	89 da                	mov    %ebx,%edx
  801b1f:	83 c4 1c             	add    $0x1c,%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5f                   	pop    %edi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    
  801b27:	90                   	nop
  801b28:	89 fd                	mov    %edi,%ebp
  801b2a:	85 ff                	test   %edi,%edi
  801b2c:	75 0b                	jne    801b39 <__umoddi3+0xe9>
  801b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b33:	31 d2                	xor    %edx,%edx
  801b35:	f7 f7                	div    %edi
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	89 f0                	mov    %esi,%eax
  801b3b:	31 d2                	xor    %edx,%edx
  801b3d:	f7 f5                	div    %ebp
  801b3f:	89 c8                	mov    %ecx,%eax
  801b41:	f7 f5                	div    %ebp
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	e9 44 ff ff ff       	jmp    801a8e <__umoddi3+0x3e>
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	89 c8                	mov    %ecx,%eax
  801b4e:	89 f2                	mov    %esi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	3b 04 24             	cmp    (%esp),%eax
  801b5b:	72 06                	jb     801b63 <__umoddi3+0x113>
  801b5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b61:	77 0f                	ja     801b72 <__umoddi3+0x122>
  801b63:	89 f2                	mov    %esi,%edx
  801b65:	29 f9                	sub    %edi,%ecx
  801b67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b6b:	89 14 24             	mov    %edx,(%esp)
  801b6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b76:	8b 14 24             	mov    (%esp),%edx
  801b79:	83 c4 1c             	add    $0x1c,%esp
  801b7c:	5b                   	pop    %ebx
  801b7d:	5e                   	pop    %esi
  801b7e:	5f                   	pop    %edi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    
  801b81:	8d 76 00             	lea    0x0(%esi),%esi
  801b84:	2b 04 24             	sub    (%esp),%eax
  801b87:	19 fa                	sbb    %edi,%edx
  801b89:	89 d1                	mov    %edx,%ecx
  801b8b:	89 c6                	mov    %eax,%esi
  801b8d:	e9 71 ff ff ff       	jmp    801b03 <__umoddi3+0xb3>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b98:	72 ea                	jb     801b84 <__umoddi3+0x134>
  801b9a:	89 d9                	mov    %ebx,%ecx
  801b9c:	e9 62 ff ff ff       	jmp    801b03 <__umoddi3+0xb3>
