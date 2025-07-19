
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 19 01 00 00       	call   80014f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x800000, 0x801000, 0x802000, 0x803000,											//Code & Data
		0xeebfd000, /*0xedbfd000 will be created during the call of sys_check_WS_list*/ //Stack
} ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 20 00       	push   $0x200000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 ff 18 00 00       	call   801951 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 60 1c 80 00       	push   $0x801c60
  800066:	6a 1b                	push   $0x1b
  800068:	68 d4 1c 80 00       	push   $0x801cd4
  80006d:	e8 14 02 00 00       	call   800286 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 bd 13 00 00       	call   801434 <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 00 14 00 00       	call   80147f <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  800082:	a0 7f e0 80 00       	mov    0x80e07f,%al
  800087:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  80008a:	a0 7f f0 80 00       	mov    0x80f07f,%al
  80008f:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800099:	eb 4a                	jmp    8000e5 <_main+0xad>
	{
		arr[i] = -1 ;
  80009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009e:	05 80 30 80 00       	add    $0x803080,%eax
  8000a3:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr + garbage5;
  8000a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 c2                	mov    %al,%dl
  8000af:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b2:	01 d0                	add    %edx,%eax
  8000b4:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *ptr2 + garbage4;
  8000b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	88 c2                	mov    %al,%dl
  8000c0:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	88 45 f7             	mov    %al,-0x9(%ebp)
		ptr++ ; ptr2++ ;
  8000c8:	a1 00 30 80 00       	mov    0x803000,%eax
  8000cd:	40                   	inc    %eax
  8000ce:	a3 00 30 80 00       	mov    %eax,0x803000
  8000d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d8:	40                   	inc    %eax
  8000d9:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000de:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000e5:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000ec:	7e ad                	jle    80009b <_main+0x63>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8000ee:	e8 8c 13 00 00       	call   80147f <sys_pf_calculate_allocated_pages>
  8000f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 f8 1c 80 00       	push   $0x801cf8
  800100:	6a 3b                	push   $0x3b
  800102:	68 d4 1c 80 00       	push   $0x801cd4
  800107:	e8 7a 01 00 00       	call   800286 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  80010c:	e8 23 13 00 00       	call   801434 <sys_calculate_free_frames>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	e8 35 13 00 00       	call   80144d <sys_calculate_modified_frames>
  800118:	01 d8                	add    %ebx,%eax
  80011a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  80011d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800120:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800123:	74 14                	je     800139 <_main+0x101>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	68 64 1d 80 00       	push   $0x801d64
  80012d:	6a 3f                	push   $0x3f
  80012f:	68 d4 1c 80 00       	push   $0x801cd4
  800134:	e8 4d 01 00 00       	call   800286 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] is completed successfully.\n");
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	68 c8 1d 80 00       	push   $0x801dc8
  800141:	e8 fd 03 00 00       	call   800543 <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
	return;
  800149:	90                   	nop
}
  80014a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800155:	e8 65 15 00 00       	call   8016bf <sys_getenvindex>
  80015a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80015d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800160:	89 d0                	mov    %edx,%eax
  800162:	c1 e0 03             	shl    $0x3,%eax
  800165:	01 d0                	add    %edx,%eax
  800167:	01 c0                	add    %eax,%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800172:	01 d0                	add    %edx,%eax
  800174:	c1 e0 04             	shl    $0x4,%eax
  800177:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017c:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800181:	a1 60 30 80 00       	mov    0x803060,%eax
  800186:	8a 40 5c             	mov    0x5c(%eax),%al
  800189:	84 c0                	test   %al,%al
  80018b:	74 0d                	je     80019a <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80018d:	a1 60 30 80 00       	mov    0x803060,%eax
  800192:	83 c0 5c             	add    $0x5c,%eax
  800195:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019e:	7e 0a                	jle    8001aa <libmain+0x5b>
		binaryname = argv[0];
  8001a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a3:	8b 00                	mov    (%eax),%eax
  8001a5:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// call user main routine
	_main(argc, argv);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	e8 80 fe ff ff       	call   800038 <_main>
  8001b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001bb:	e8 0c 13 00 00       	call   8014cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	68 34 1e 80 00       	push   $0x801e34
  8001c8:	e8 76 03 00 00       	call   800543 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d0:	a1 60 30 80 00       	mov    0x803060,%eax
  8001d5:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8001db:	a1 60 30 80 00       	mov    0x803060,%eax
  8001e0:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	52                   	push   %edx
  8001ea:	50                   	push   %eax
  8001eb:	68 5c 1e 80 00       	push   $0x801e5c
  8001f0:	e8 4e 03 00 00       	call   800543 <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f8:	a1 60 30 80 00       	mov    0x803060,%eax
  8001fd:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800203:	a1 60 30 80 00       	mov    0x803060,%eax
  800208:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80020e:	a1 60 30 80 00       	mov    0x803060,%eax
  800213:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800219:	51                   	push   %ecx
  80021a:	52                   	push   %edx
  80021b:	50                   	push   %eax
  80021c:	68 84 1e 80 00       	push   $0x801e84
  800221:	e8 1d 03 00 00       	call   800543 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800229:	a1 60 30 80 00       	mov    0x803060,%eax
  80022e:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	50                   	push   %eax
  800238:	68 dc 1e 80 00       	push   $0x801edc
  80023d:	e8 01 03 00 00       	call   800543 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	68 34 1e 80 00       	push   $0x801e34
  80024d:	e8 f1 02 00 00       	call   800543 <cprintf>
  800252:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800255:	e8 8c 12 00 00       	call   8014e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80025a:	e8 19 00 00 00       	call   800278 <exit>
}
  80025f:	90                   	nop
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	6a 00                	push   $0x0
  80026d:	e8 19 14 00 00       	call   80168b <sys_destroy_env>
  800272:	83 c4 10             	add    $0x10,%esp
}
  800275:	90                   	nop
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <exit>:

void
exit(void)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027e:	e8 6e 14 00 00       	call   8016f1 <sys_exit_env>
}
  800283:	90                   	nop
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80028c:	8d 45 10             	lea    0x10(%ebp),%eax
  80028f:	83 c0 04             	add    $0x4,%eax
  800292:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800295:	a1 6c f1 80 00       	mov    0x80f16c,%eax
  80029a:	85 c0                	test   %eax,%eax
  80029c:	74 16                	je     8002b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029e:	a1 6c f1 80 00       	mov    0x80f16c,%eax
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	50                   	push   %eax
  8002a7:	68 f0 1e 80 00       	push   $0x801ef0
  8002ac:	e8 92 02 00 00       	call   800543 <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b4:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	ff 75 08             	pushl  0x8(%ebp)
  8002bf:	50                   	push   %eax
  8002c0:	68 f5 1e 80 00       	push   $0x801ef5
  8002c5:	e8 79 02 00 00       	call   800543 <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d6:	50                   	push   %eax
  8002d7:	e8 fc 01 00 00       	call   8004d8 <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	68 11 1f 80 00       	push   $0x801f11
  8002e9:	e8 ea 01 00 00       	call   8004d8 <vcprintf>
  8002ee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f1:	e8 82 ff ff ff       	call   800278 <exit>

	// should not return here
	while (1) ;
  8002f6:	eb fe                	jmp    8002f6 <_panic+0x70>

008002f8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fe:	a1 60 30 80 00       	mov    0x803060,%eax
  800303:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030c:	39 c2                	cmp    %eax,%edx
  80030e:	74 14                	je     800324 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 14 1f 80 00       	push   $0x801f14
  800318:	6a 26                	push   $0x26
  80031a:	68 60 1f 80 00       	push   $0x801f60
  80031f:	e8 62 ff ff ff       	call   800286 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800324:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800332:	e9 c5 00 00 00       	jmp    8003fc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	01 d0                	add    %edx,%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	85 c0                	test   %eax,%eax
  80034a:	75 08                	jne    800354 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80034c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80034f:	e9 a5 00 00 00       	jmp    8003f9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800354:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800362:	eb 69                	jmp    8003cd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800364:	a1 60 30 80 00       	mov    0x803060,%eax
  800369:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80036f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800372:	89 d0                	mov    %edx,%eax
  800374:	01 c0                	add    %eax,%eax
  800376:	01 d0                	add    %edx,%eax
  800378:	c1 e0 03             	shl    $0x3,%eax
  80037b:	01 c8                	add    %ecx,%eax
  80037d:	8a 40 04             	mov    0x4(%eax),%al
  800380:	84 c0                	test   %al,%al
  800382:	75 46                	jne    8003ca <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800384:	a1 60 30 80 00       	mov    0x803060,%eax
  800389:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80038f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800392:	89 d0                	mov    %edx,%eax
  800394:	01 c0                	add    %eax,%eax
  800396:	01 d0                	add    %edx,%eax
  800398:	c1 e0 03             	shl    $0x3,%eax
  80039b:	01 c8                	add    %ecx,%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003aa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003af:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	01 c8                	add    %ecx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	75 09                	jne    8003ca <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003c1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c8:	eb 15                	jmp    8003df <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ca:	ff 45 e8             	incl   -0x18(%ebp)
  8003cd:	a1 60 30 80 00       	mov    0x803060,%eax
  8003d2:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8003d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	77 85                	ja     800364 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e3:	75 14                	jne    8003f9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	68 6c 1f 80 00       	push   $0x801f6c
  8003ed:	6a 3a                	push   $0x3a
  8003ef:	68 60 1f 80 00       	push   $0x801f60
  8003f4:	e8 8d fe ff ff       	call   800286 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f9:	ff 45 f0             	incl   -0x10(%ebp)
  8003fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800402:	0f 8c 2f ff ff ff    	jl     800337 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800408:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800416:	eb 26                	jmp    80043e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800418:	a1 60 30 80 00       	mov    0x803060,%eax
  80041d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800423:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800426:	89 d0                	mov    %edx,%eax
  800428:	01 c0                	add    %eax,%eax
  80042a:	01 d0                	add    %edx,%eax
  80042c:	c1 e0 03             	shl    $0x3,%eax
  80042f:	01 c8                	add    %ecx,%eax
  800431:	8a 40 04             	mov    0x4(%eax),%al
  800434:	3c 01                	cmp    $0x1,%al
  800436:	75 03                	jne    80043b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800438:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043b:	ff 45 e0             	incl   -0x20(%ebp)
  80043e:	a1 60 30 80 00       	mov    0x803060,%eax
  800443:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800449:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044c:	39 c2                	cmp    %eax,%edx
  80044e:	77 c8                	ja     800418 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800453:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800456:	74 14                	je     80046c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	68 c0 1f 80 00       	push   $0x801fc0
  800460:	6a 44                	push   $0x44
  800462:	68 60 1f 80 00       	push   $0x801f60
  800467:	e8 1a fe ff ff       	call   800286 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046c:	90                   	nop
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 48 01             	lea    0x1(%eax),%ecx
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 0a                	mov    %ecx,(%edx)
  800482:	8b 55 08             	mov    0x8(%ebp),%edx
  800485:	88 d1                	mov    %dl,%cl
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	3d ff 00 00 00       	cmp    $0xff,%eax
  800498:	75 2c                	jne    8004c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049a:	a0 64 30 80 00       	mov    0x803064,%al
  80049f:	0f b6 c0             	movzbl %al,%eax
  8004a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a5:	8b 12                	mov    (%edx),%edx
  8004a7:	89 d1                	mov    %edx,%ecx
  8004a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ac:	83 c2 08             	add    $0x8,%edx
  8004af:	83 ec 04             	sub    $0x4,%esp
  8004b2:	50                   	push   %eax
  8004b3:	51                   	push   %ecx
  8004b4:	52                   	push   %edx
  8004b5:	e8 b9 0e 00 00       	call   801373 <sys_cputs>
  8004ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	8b 40 04             	mov    0x4(%eax),%eax
  8004cc:	8d 50 01             	lea    0x1(%eax),%edx
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d5:	90                   	nop
  8004d6:	c9                   	leave  
  8004d7:	c3                   	ret    

008004d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e8:	00 00 00 
	b.cnt = 0;
  8004eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f5:	ff 75 0c             	pushl  0xc(%ebp)
  8004f8:	ff 75 08             	pushl  0x8(%ebp)
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	68 6f 04 80 00       	push   $0x80046f
  800507:	e8 11 02 00 00       	call   80071d <vprintfmt>
  80050c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80050f:	a0 64 30 80 00       	mov    0x803064,%al
  800514:	0f b6 c0             	movzbl %al,%eax
  800517:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	50                   	push   %eax
  800521:	52                   	push   %edx
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	83 c0 08             	add    $0x8,%eax
  80052b:	50                   	push   %eax
  80052c:	e8 42 0e 00 00       	call   801373 <sys_cputs>
  800531:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800534:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  80053b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800541:	c9                   	leave  
  800542:	c3                   	ret    

00800543 <cprintf>:

int cprintf(const char *fmt, ...) {
  800543:	55                   	push   %ebp
  800544:	89 e5                	mov    %esp,%ebp
  800546:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800549:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  800550:	8d 45 0c             	lea    0xc(%ebp),%eax
  800553:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 f4             	pushl  -0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	e8 73 ff ff ff       	call   8004d8 <vcprintf>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800576:	e8 51 0f 00 00       	call   8014cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	50                   	push   %eax
  80058b:	e8 48 ff ff ff       	call   8004d8 <vcprintf>
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800596:	e8 4b 0f 00 00       	call   8014e6 <sys_enable_interrupt>
	return cnt;
  80059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	53                   	push   %ebx
  8005a4:	83 ec 14             	sub    $0x14,%esp
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005be:	77 55                	ja     800615 <printnum+0x75>
  8005c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c3:	72 05                	jb     8005ca <printnum+0x2a>
  8005c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c8:	77 4b                	ja     800615 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	52                   	push   %edx
  8005d9:	50                   	push   %eax
  8005da:	ff 75 f4             	pushl  -0xc(%ebp)
  8005dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e0:	e8 17 14 00 00       	call   8019fc <__udivdi3>
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	ff 75 20             	pushl  0x20(%ebp)
  8005ee:	53                   	push   %ebx
  8005ef:	ff 75 18             	pushl  0x18(%ebp)
  8005f2:	52                   	push   %edx
  8005f3:	50                   	push   %eax
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 a1 ff ff ff       	call   8005a0 <printnum>
  8005ff:	83 c4 20             	add    $0x20,%esp
  800602:	eb 1a                	jmp    80061e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	ff 75 20             	pushl  0x20(%ebp)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	ff d0                	call   *%eax
  800612:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800615:	ff 4d 1c             	decl   0x1c(%ebp)
  800618:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061c:	7f e6                	jg     800604 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800621:	bb 00 00 00 00       	mov    $0x0,%ebx
  800626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062c:	53                   	push   %ebx
  80062d:	51                   	push   %ecx
  80062e:	52                   	push   %edx
  80062f:	50                   	push   %eax
  800630:	e8 d7 14 00 00       	call   801b0c <__umoddi3>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	05 34 22 80 00       	add    $0x802234,%eax
  80063d:	8a 00                	mov    (%eax),%al
  80063f:	0f be c0             	movsbl %al,%eax
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	50                   	push   %eax
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	ff d0                	call   *%eax
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065e:	7e 1c                	jle    80067c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	8d 50 08             	lea    0x8(%eax),%edx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	89 10                	mov    %edx,(%eax)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	83 e8 08             	sub    $0x8,%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	eb 40                	jmp    8006bc <getuint+0x65>
	else if (lflag)
  80067c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800680:	74 1e                	je     8006a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	eb 1c                	jmp    8006bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	8d 50 04             	lea    0x4(%eax),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	89 10                	mov    %edx,(%eax)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	83 e8 04             	sub    $0x4,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c5:	7e 1c                	jle    8006e3 <getint+0x25>
		return va_arg(*ap, long long);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 08             	lea    0x8(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 08             	sub    $0x8,%eax
  8006dc:	8b 50 04             	mov    0x4(%eax),%edx
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	eb 38                	jmp    80071b <getint+0x5d>
	else if (lflag)
  8006e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e7:	74 1a                	je     800703 <getint+0x45>
		return va_arg(*ap, long);
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	8d 50 04             	lea    0x4(%eax),%edx
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	89 10                	mov    %edx,(%eax)
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	83 e8 04             	sub    $0x4,%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	99                   	cltd   
  800701:	eb 18                	jmp    80071b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	99                   	cltd   
}
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    

0080071d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	56                   	push   %esi
  800721:	53                   	push   %ebx
  800722:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	eb 17                	jmp    80073e <vprintfmt+0x21>
			if (ch == '\0')
  800727:	85 db                	test   %ebx,%ebx
  800729:	0f 84 af 03 00 00    	je     800ade <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	53                   	push   %ebx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	8d 50 01             	lea    0x1(%eax),%edx
  800744:	89 55 10             	mov    %edx,0x10(%ebp)
  800747:	8a 00                	mov    (%eax),%al
  800749:	0f b6 d8             	movzbl %al,%ebx
  80074c:	83 fb 25             	cmp    $0x25,%ebx
  80074f:	75 d6                	jne    800727 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800751:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800755:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800763:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	8d 50 01             	lea    0x1(%eax),%edx
  800777:	89 55 10             	mov    %edx,0x10(%ebp)
  80077a:	8a 00                	mov    (%eax),%al
  80077c:	0f b6 d8             	movzbl %al,%ebx
  80077f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800782:	83 f8 55             	cmp    $0x55,%eax
  800785:	0f 87 2b 03 00 00    	ja     800ab6 <vprintfmt+0x399>
  80078b:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  800792:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800794:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800798:	eb d7                	jmp    800771 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079e:	eb d1                	jmp    800771 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007aa:	89 d0                	mov    %edx,%eax
  8007ac:	c1 e0 02             	shl    $0x2,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	01 c0                	add    %eax,%eax
  8007b3:	01 d8                	add    %ebx,%eax
  8007b5:	83 e8 30             	sub    $0x30,%eax
  8007b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007be:	8a 00                	mov    (%eax),%al
  8007c0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c6:	7e 3e                	jle    800806 <vprintfmt+0xe9>
  8007c8:	83 fb 39             	cmp    $0x39,%ebx
  8007cb:	7f 39                	jg     800806 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d0:	eb d5                	jmp    8007a7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 c0 04             	add    $0x4,%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	83 e8 04             	sub    $0x4,%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e6:	eb 1f                	jmp    800807 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	79 83                	jns    800771 <vprintfmt+0x54>
				width = 0;
  8007ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f5:	e9 77 ff ff ff       	jmp    800771 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800801:	e9 6b ff ff ff       	jmp    800771 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800806:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	0f 89 60 ff ff ff    	jns    800771 <vprintfmt+0x54>
				width = precision, precision = -1;
  800811:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800817:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081e:	e9 4e ff ff ff       	jmp    800771 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800823:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800826:	e9 46 ff ff ff       	jmp    800771 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 c0 04             	add    $0x4,%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	83 e8 04             	sub    $0x4,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			break;
  80084b:	e9 89 02 00 00       	jmp    800ad9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800861:	85 db                	test   %ebx,%ebx
  800863:	79 02                	jns    800867 <vprintfmt+0x14a>
				err = -err;
  800865:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800867:	83 fb 64             	cmp    $0x64,%ebx
  80086a:	7f 0b                	jg     800877 <vprintfmt+0x15a>
  80086c:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  800873:	85 f6                	test   %esi,%esi
  800875:	75 19                	jne    800890 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800877:	53                   	push   %ebx
  800878:	68 45 22 80 00       	push   $0x802245
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 08             	pushl  0x8(%ebp)
  800883:	e8 5e 02 00 00       	call   800ae6 <printfmt>
  800888:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088b:	e9 49 02 00 00       	jmp    800ad9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800890:	56                   	push   %esi
  800891:	68 4e 22 80 00       	push   $0x80224e
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 45 02 00 00       	call   800ae6 <printfmt>
  8008a1:	83 c4 10             	add    $0x10,%esp
			break;
  8008a4:	e9 30 02 00 00       	jmp    800ad9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 c0 04             	add    $0x4,%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 e8 04             	sub    $0x4,%eax
  8008b8:	8b 30                	mov    (%eax),%esi
  8008ba:	85 f6                	test   %esi,%esi
  8008bc:	75 05                	jne    8008c3 <vprintfmt+0x1a6>
				p = "(null)";
  8008be:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	7e 6d                	jle    800936 <vprintfmt+0x219>
  8008c9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008cd:	74 67                	je     800936 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	50                   	push   %eax
  8008d6:	56                   	push   %esi
  8008d7:	e8 0c 03 00 00       	call   800be8 <strnlen>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e2:	eb 16                	jmp    8008fa <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fe:	7f e4                	jg     8008e4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800900:	eb 34                	jmp    800936 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800902:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800906:	74 1c                	je     800924 <vprintfmt+0x207>
  800908:	83 fb 1f             	cmp    $0x1f,%ebx
  80090b:	7e 05                	jle    800912 <vprintfmt+0x1f5>
  80090d:	83 fb 7e             	cmp    $0x7e,%ebx
  800910:	7e 12                	jle    800924 <vprintfmt+0x207>
					putch('?', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 3f                	push   $0x3f
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
  800922:	eb 0f                	jmp    800933 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800933:	ff 4d e4             	decl   -0x1c(%ebp)
  800936:	89 f0                	mov    %esi,%eax
  800938:	8d 70 01             	lea    0x1(%eax),%esi
  80093b:	8a 00                	mov    (%eax),%al
  80093d:	0f be d8             	movsbl %al,%ebx
  800940:	85 db                	test   %ebx,%ebx
  800942:	74 24                	je     800968 <vprintfmt+0x24b>
  800944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800948:	78 b8                	js     800902 <vprintfmt+0x1e5>
  80094a:	ff 4d e0             	decl   -0x20(%ebp)
  80094d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800951:	79 af                	jns    800902 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	eb 13                	jmp    800968 <vprintfmt+0x24b>
				putch(' ', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 20                	push   $0x20
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	ff d0                	call   *%eax
  800962:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	ff 4d e4             	decl   -0x1c(%ebp)
  800968:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096c:	7f e7                	jg     800955 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096e:	e9 66 01 00 00       	jmp    800ad9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 e8             	pushl  -0x18(%ebp)
  800979:	8d 45 14             	lea    0x14(%ebp),%eax
  80097c:	50                   	push   %eax
  80097d:	e8 3c fd ff ff       	call   8006be <getint>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800988:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800991:	85 d2                	test   %edx,%edx
  800993:	79 23                	jns    8009b8 <vprintfmt+0x29b>
				putch('-', putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	6a 2d                	push   $0x2d
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ab:	f7 d8                	neg    %eax
  8009ad:	83 d2 00             	adc    $0x0,%edx
  8009b0:	f7 da                	neg    %edx
  8009b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009bf:	e9 bc 00 00 00       	jmp    800a80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8009cd:	50                   	push   %eax
  8009ce:	e8 84 fc ff ff       	call   800657 <getuint>
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e3:	e9 98 00 00 00       	jmp    800a80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	6a 58                	push   $0x58
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	ff d0                	call   *%eax
  800a15:	83 c4 10             	add    $0x10,%esp
			break;
  800a18:	e9 bc 00 00 00       	jmp    800ad9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 30                	push   $0x30
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 78                	push   $0x78
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 c0 04             	add    $0x4,%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	83 e8 04             	sub    $0x4,%eax
  800a4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a5f:	eb 1f                	jmp    800a80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 e8             	pushl  -0x18(%ebp)
  800a67:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6a:	50                   	push   %eax
  800a6b:	e8 e7 fb ff ff       	call   800657 <getuint>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a87:	83 ec 04             	sub    $0x4,%esp
  800a8a:	52                   	push   %edx
  800a8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a92:	ff 75 f0             	pushl  -0x10(%ebp)
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 00 fb ff ff       	call   8005a0 <printnum>
  800aa0:	83 c4 20             	add    $0x20,%esp
			break;
  800aa3:	eb 34                	jmp    800ad9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa5:	83 ec 08             	sub    $0x8,%esp
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	53                   	push   %ebx
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			break;
  800ab4:	eb 23                	jmp    800ad9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	6a 25                	push   $0x25
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	eb 03                	jmp    800ace <vprintfmt+0x3b1>
  800acb:	ff 4d 10             	decl   0x10(%ebp)
  800ace:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad1:	48                   	dec    %eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	3c 25                	cmp    $0x25,%al
  800ad6:	75 f3                	jne    800acb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad8:	90                   	nop
		}
	}
  800ad9:	e9 47 fc ff ff       	jmp    800725 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ade:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aec:	8d 45 10             	lea    0x10(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	ff 75 f4             	pushl  -0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 16 fc ff ff       	call   80071d <vprintfmt>
  800b07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0a:	90                   	nop
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 40 08             	mov    0x8(%eax),%eax
  800b16:	8d 50 01             	lea    0x1(%eax),%edx
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 10                	mov    (%eax),%edx
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8b 40 04             	mov    0x4(%eax),%eax
  800b2a:	39 c2                	cmp    %eax,%edx
  800b2c:	73 12                	jae    800b40 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	8d 48 01             	lea    0x1(%eax),%ecx
  800b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b39:	89 0a                	mov    %ecx,(%edx)
  800b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3e:	88 10                	mov    %dl,(%eax)
}
  800b40:	90                   	nop
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
  800b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b68:	74 06                	je     800b70 <vsnprintf+0x2d>
  800b6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6e:	7f 07                	jg     800b77 <vsnprintf+0x34>
		return -E_INVAL;
  800b70:	b8 03 00 00 00       	mov    $0x3,%eax
  800b75:	eb 20                	jmp    800b97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b77:	ff 75 14             	pushl  0x14(%ebp)
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b80:	50                   	push   %eax
  800b81:	68 0d 0b 80 00       	push   $0x800b0d
  800b86:	e8 92 fb ff ff       	call   80071d <vprintfmt>
  800b8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	50                   	push   %eax
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 89 ff ff ff       	call   800b43 <vsnprintf>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd2:	eb 06                	jmp    800bda <strlen+0x15>
		n++;
  800bd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 f1                	jne    800bd4 <strlen+0xf>
		n++;
	return n;
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 09                	jmp    800c00 <strnlen+0x18>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	ff 4d 0c             	decl   0xc(%ebp)
  800c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c04:	74 09                	je     800c0f <strnlen+0x27>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	75 e8                	jne    800bf7 <strnlen+0xf>
		n++;
	return n;
  800c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c20:	90                   	nop
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c33:	8a 12                	mov    (%edx),%dl
  800c35:	88 10                	mov    %dl,(%eax)
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e4                	jne    800c21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c55:	eb 1f                	jmp    800c76 <strncpy+0x34>
		*dst++ = *src;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8d 50 01             	lea    0x1(%eax),%edx
  800c5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	8a 12                	mov    (%edx),%dl
  800c65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	74 03                	je     800c73 <strncpy+0x31>
			src++;
  800c70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c73:	ff 45 fc             	incl   -0x4(%ebp)
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7c:	72 d9                	jb     800c57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c93:	74 30                	je     800cc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c95:	eb 16                	jmp    800cad <strlcpy+0x2a>
			*dst++ = *src++;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca9:	8a 12                	mov    (%edx),%dl
  800cab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cad:	ff 4d 10             	decl   0x10(%ebp)
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	74 09                	je     800cbf <strlcpy+0x3c>
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	75 d8                	jne    800c97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	29 c2                	sub    %eax,%edx
  800ccd:	89 d0                	mov    %edx,%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd4:	eb 06                	jmp    800cdc <strcmp+0xb>
		p++, q++;
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 0e                	je     800cf3 <strcmp+0x22>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 10                	mov    (%eax),%dl
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	38 c2                	cmp    %al,%dl
  800cf1:	74 e3                	je     800cd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f b6 d0             	movzbl %al,%edx
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 c0             	movzbl %al,%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0c:	eb 09                	jmp    800d17 <strncmp+0xe>
		n--, p++, q++;
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	ff 45 08             	incl   0x8(%ebp)
  800d14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	74 17                	je     800d34 <strncmp+0x2b>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 0e                	je     800d34 <strncmp+0x2b>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 10                	mov    (%eax),%dl
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	38 c2                	cmp    %al,%dl
  800d32:	74 da                	je     800d0e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 07                	jne    800d41 <strncmp+0x38>
		return 0;
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	eb 14                	jmp    800d55 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d0             	movzbl %al,%edx
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f b6 c0             	movzbl %al,%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 04             	sub    $0x4,%esp
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d63:	eb 12                	jmp    800d77 <strchr+0x20>
		if (*s == c)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6d:	75 05                	jne    800d74 <strchr+0x1d>
			return (char *) s;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	eb 11                	jmp    800d85 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d74:	ff 45 08             	incl   0x8(%ebp)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	75 e5                	jne    800d65 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d93:	eb 0d                	jmp    800da2 <strfind+0x1b>
		if (*s == c)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9d:	74 0e                	je     800dad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	84 c0                	test   %al,%al
  800da9:	75 ea                	jne    800d95 <strfind+0xe>
  800dab:	eb 01                	jmp    800dae <strfind+0x27>
		if (*s == c)
			break;
  800dad:	90                   	nop
	return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc5:	eb 0e                	jmp    800dd5 <memset+0x22>
		*p++ = c;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd5:	ff 4d f8             	decl   -0x8(%ebp)
  800dd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddc:	79 e9                	jns    800dc7 <memset+0x14>
		*p++ = c;

	return v;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df5:	eb 16                	jmp    800e0d <memcpy+0x2a>
		*d++ = *s++;
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e06:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e09:	8a 12                	mov    (%edx),%dl
  800e0b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	75 dd                	jne    800df7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	73 50                	jae    800e89 <memmove+0x6a>
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
  800e41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e44:	76 43                	jbe    800e89 <memmove+0x6a>
		s += n;
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e52:	eb 10                	jmp    800e64 <memmove+0x45>
			*--d = *--s;
  800e54:	ff 4d f8             	decl   -0x8(%ebp)
  800e57:	ff 4d fc             	decl   -0x4(%ebp)
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5d:	8a 10                	mov    (%eax),%dl
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 e3                	jne    800e54 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e71:	eb 23                	jmp    800e96 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	8d 50 01             	lea    0x1(%eax),%edx
  800e79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e85:	8a 12                	mov    (%edx),%dl
  800e87:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	75 dd                	jne    800e73 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ead:	eb 2a                	jmp    800ed9 <memcmp+0x3e>
		if (*s1 != *s2)
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	8a 10                	mov    (%eax),%dl
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	38 c2                	cmp    %al,%dl
  800ebb:	74 16                	je     800ed3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 c0             	movzbl %al,%eax
  800ecd:	29 c2                	sub    %eax,%edx
  800ecf:	89 d0                	mov    %edx,%eax
  800ed1:	eb 18                	jmp    800eeb <memcmp+0x50>
		s1++, s2++;
  800ed3:	ff 45 fc             	incl   -0x4(%ebp)
  800ed6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	75 c9                	jne    800eaf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	01 d0                	add    %edx,%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800efe:	eb 15                	jmp    800f15 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d0             	movzbl %al,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	39 c2                	cmp    %eax,%edx
  800f10:	74 0d                	je     800f1f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f12:	ff 45 08             	incl   0x8(%ebp)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1b:	72 e3                	jb     800f00 <memfind+0x13>
  800f1d:	eb 01                	jmp    800f20 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f1f:	90                   	nop
	return (void *) s;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f39:	eb 03                	jmp    800f3e <strtol+0x19>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 20                	cmp    $0x20,%al
  800f45:	74 f4                	je     800f3b <strtol+0x16>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 09                	cmp    $0x9,%al
  800f4e:	74 eb                	je     800f3b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2b                	cmp    $0x2b,%al
  800f57:	75 05                	jne    800f5e <strtol+0x39>
		s++;
  800f59:	ff 45 08             	incl   0x8(%ebp)
  800f5c:	eb 13                	jmp    800f71 <strtol+0x4c>
	else if (*s == '-')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 2d                	cmp    $0x2d,%al
  800f65:	75 0a                	jne    800f71 <strtol+0x4c>
		s++, neg = 1;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 06                	je     800f7d <strtol+0x58>
  800f77:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7b:	75 20                	jne    800f9d <strtol+0x78>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 30                	cmp    $0x30,%al
  800f84:	75 17                	jne    800f9d <strtol+0x78>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	40                   	inc    %eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 78                	cmp    $0x78,%al
  800f8e:	75 0d                	jne    800f9d <strtol+0x78>
		s += 2, base = 16;
  800f90:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f94:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9b:	eb 28                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 15                	jne    800fb8 <strtol+0x93>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 30                	cmp    $0x30,%al
  800faa:	75 0c                	jne    800fb8 <strtol+0x93>
		s++, base = 8;
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb6:	eb 0d                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0)
  800fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbc:	75 07                	jne    800fc5 <strtol+0xa0>
		base = 10;
  800fbe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 2f                	cmp    $0x2f,%al
  800fcc:	7e 19                	jle    800fe7 <strtol+0xc2>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 39                	cmp    $0x39,%al
  800fd5:	7f 10                	jg     800fe7 <strtol+0xc2>
			dig = *s - '0';
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be c0             	movsbl %al,%eax
  800fdf:	83 e8 30             	sub    $0x30,%eax
  800fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe5:	eb 42                	jmp    801029 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 60                	cmp    $0x60,%al
  800fee:	7e 19                	jle    801009 <strtol+0xe4>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 7a                	cmp    $0x7a,%al
  800ff7:	7f 10                	jg     801009 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be c0             	movsbl %al,%eax
  801001:	83 e8 57             	sub    $0x57,%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801007:	eb 20                	jmp    801029 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 40                	cmp    $0x40,%al
  801010:	7e 39                	jle    80104b <strtol+0x126>
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 5a                	cmp    $0x5a,%al
  801019:	7f 30                	jg     80104b <strtol+0x126>
			dig = *s - 'A' + 10;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f be c0             	movsbl %al,%eax
  801023:	83 e8 37             	sub    $0x37,%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102f:	7d 19                	jge    80104a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801037:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801045:	e9 7b ff ff ff       	jmp    800fc5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104f:	74 08                	je     801059 <strtol+0x134>
		*endptr = (char *) s;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801059:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105d:	74 07                	je     801066 <strtol+0x141>
  80105f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801062:	f7 d8                	neg    %eax
  801064:	eb 03                	jmp    801069 <strtol+0x144>
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <ltostr>:

void
ltostr(long value, char *str)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801078:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80107f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801083:	79 13                	jns    801098 <ltostr+0x2d>
	{
		neg = 1;
  801085:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801092:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801095:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a0:	99                   	cltd   
  8010a1:	f7 f9                	idiv   %ecx
  8010a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	01 d0                	add    %edx,%eax
  8010b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b9:	83 c2 30             	add    $0x30,%edx
  8010bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c6:	f7 e9                	imul   %ecx
  8010c8:	c1 fa 02             	sar    $0x2,%edx
  8010cb:	89 c8                	mov    %ecx,%eax
  8010cd:	c1 f8 1f             	sar    $0x1f,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010df:	f7 e9                	imul   %ecx
  8010e1:	c1 fa 02             	sar    $0x2,%edx
  8010e4:	89 c8                	mov    %ecx,%eax
  8010e6:	c1 f8 1f             	sar    $0x1f,%eax
  8010e9:	29 c2                	sub    %eax,%edx
  8010eb:	89 d0                	mov    %edx,%eax
  8010ed:	c1 e0 02             	shl    $0x2,%eax
  8010f0:	01 d0                	add    %edx,%eax
  8010f2:	01 c0                	add    %eax,%eax
  8010f4:	29 c1                	sub    %eax,%ecx
  8010f6:	89 ca                	mov    %ecx,%edx
  8010f8:	85 d2                	test   %edx,%edx
  8010fa:	75 9c                	jne    801098 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801103:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801106:	48                   	dec    %eax
  801107:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110e:	74 3d                	je     80114d <ltostr+0xe2>
		start = 1 ;
  801110:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801117:	eb 34                	jmp    80114d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	01 c2                	add    %eax,%edx
  80112e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	01 c8                	add    %ecx,%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	01 c2                	add    %eax,%edx
  801142:	8a 45 eb             	mov    -0x15(%ebp),%al
  801145:	88 02                	mov    %al,(%edx)
		start++ ;
  801147:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801150:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801153:	7c c4                	jl     801119 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801155:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801160:	90                   	nop
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801169:	ff 75 08             	pushl  0x8(%ebp)
  80116c:	e8 54 fa ff ff       	call   800bc5 <strlen>
  801171:	83 c4 04             	add    $0x4,%esp
  801174:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	e8 46 fa ff ff       	call   800bc5 <strlen>
  80117f:	83 c4 04             	add    $0x4,%esp
  801182:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801193:	eb 17                	jmp    8011ac <strcconcat+0x49>
		final[s] = str1[s] ;
  801195:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801198:	8b 45 10             	mov    0x10(%ebp),%eax
  80119b:	01 c2                	add    %eax,%edx
  80119d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	01 c8                	add    %ecx,%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011a9:	ff 45 fc             	incl   -0x4(%ebp)
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b2:	7c e1                	jl     801195 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c2:	eb 1f                	jmp    8011e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011cd:	89 c2                	mov    %eax,%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e0:	ff 45 f8             	incl   -0x8(%ebp)
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e9:	7c d9                	jl     8011c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f6:	90                   	nop
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121c:	eb 0c                	jmp    80122a <strsplit+0x31>
			*string++ = 0;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 08             	mov    %edx,0x8(%ebp)
  801227:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	84 c0                	test   %al,%al
  801231:	74 18                	je     80124b <strsplit+0x52>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	50                   	push   %eax
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	e8 13 fb ff ff       	call   800d57 <strchr>
  801244:	83 c4 08             	add    $0x8,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	75 d3                	jne    80121e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	84 c0                	test   %al,%al
  801252:	74 5a                	je     8012ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801254:	8b 45 14             	mov    0x14(%ebp),%eax
  801257:	8b 00                	mov    (%eax),%eax
  801259:	83 f8 0f             	cmp    $0xf,%eax
  80125c:	75 07                	jne    801265 <strsplit+0x6c>
		{
			return 0;
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
  801263:	eb 66                	jmp    8012cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801265:	8b 45 14             	mov    0x14(%ebp),%eax
  801268:	8b 00                	mov    (%eax),%eax
  80126a:	8d 48 01             	lea    0x1(%eax),%ecx
  80126d:	8b 55 14             	mov    0x14(%ebp),%edx
  801270:	89 0a                	mov    %ecx,(%edx)
  801272:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	01 c2                	add    %eax,%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801283:	eb 03                	jmp    801288 <strsplit+0x8f>
			string++;
  801285:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	84 c0                	test   %al,%al
  80128f:	74 8b                	je     80121c <strsplit+0x23>
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	0f be c0             	movsbl %al,%eax
  801299:	50                   	push   %eax
  80129a:	ff 75 0c             	pushl  0xc(%ebp)
  80129d:	e8 b5 fa ff ff       	call   800d57 <strchr>
  8012a2:	83 c4 08             	add    $0x8,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	74 dc                	je     801285 <strsplit+0x8c>
			string++;
	}
  8012a9:	e9 6e ff ff ff       	jmp    80121c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012af:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b2:	8b 00                	mov    (%eax),%eax
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 4c                	jmp    801328 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8012dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	01 d0                	add    %edx,%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 40                	cmp    $0x40,%al
  8012e8:	7e 27                	jle    801311 <str2lower+0x44>
  8012ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	3c 5a                	cmp    $0x5a,%al
  8012f6:	7f 19                	jg     801311 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8012f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	01 d0                	add    %edx,%eax
  801300:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	01 ca                	add    %ecx,%edx
  801308:	8a 12                	mov    (%edx),%dl
  80130a:	83 c2 20             	add    $0x20,%edx
  80130d:	88 10                	mov    %dl,(%eax)
  80130f:	eb 14                	jmp    801325 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801311:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	01 c2                	add    %eax,%edx
  801319:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	01 c8                	add    %ecx,%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 95 f8 ff ff       	call   800bc5 <strlen>
  801330:	83 c4 04             	add    $0x4,%esp
  801333:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801336:	7f a4                	jg     8012dc <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801338:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	01 d0                	add    %edx,%eax
  801340:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	57                   	push   %edi
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
  80134e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80135d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801360:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801363:	cd 30                	int    $0x30
  801365:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801368:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	5b                   	pop    %ebx
  80136f:	5e                   	pop    %esi
  801370:	5f                   	pop    %edi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80137f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	52                   	push   %edx
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	50                   	push   %eax
  80138f:	6a 00                	push   $0x0
  801391:	e8 b2 ff ff ff       	call   801348 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	90                   	nop
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_cgetc>:

int
sys_cgetc(void)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 01                	push   $0x1
  8013ab:	e8 98 ff ff ff       	call   801348 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	52                   	push   %edx
  8013c5:	50                   	push   %eax
  8013c6:	6a 05                	push   $0x5
  8013c8:	e8 7b ff ff ff       	call   801348 <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	56                   	push   %esi
  8013d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8013da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	56                   	push   %esi
  8013e7:	53                   	push   %ebx
  8013e8:	51                   	push   %ecx
  8013e9:	52                   	push   %edx
  8013ea:	50                   	push   %eax
  8013eb:	6a 06                	push   $0x6
  8013ed:	e8 56 ff ff ff       	call   801348 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f8:	5b                   	pop    %ebx
  8013f9:	5e                   	pop    %esi
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	52                   	push   %edx
  80140c:	50                   	push   %eax
  80140d:	6a 07                	push   $0x7
  80140f:	e8 34 ff ff ff       	call   801348 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	6a 08                	push   $0x8
  80142a:	e8 19 ff ff ff       	call   801348 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 09                	push   $0x9
  801443:	e8 00 ff ff ff       	call   801348 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 0a                	push   $0xa
  80145c:	e8 e7 fe ff ff       	call   801348 <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 0b                	push   $0xb
  801475:	e8 ce fe ff ff       	call   801348 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 0c                	push   $0xc
  80148e:	e8 b5 fe ff ff       	call   801348 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	6a 0d                	push   $0xd
  8014a8:	e8 9b fe ff ff       	call   801348 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 0e                	push   $0xe
  8014c1:	e8 82 fe ff ff       	call   801348 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 11                	push   $0x11
  8014db:	e8 68 fe ff ff       	call   801348 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 12                	push   $0x12
  8014f5:	e8 4e fe ff ff       	call   801348 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_cputc>:


void
sys_cputc(const char c)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80150c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	50                   	push   %eax
  801519:	6a 13                	push   $0x13
  80151b:	e8 28 fe ff ff       	call   801348 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	90                   	nop
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 14                	push   $0x14
  801535:	e8 0e fe ff ff       	call   801348 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	50                   	push   %eax
  801550:	6a 15                	push   $0x15
  801552:	e8 f1 fd ff ff       	call   801348 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	52                   	push   %edx
  80156c:	50                   	push   %eax
  80156d:	6a 18                	push   $0x18
  80156f:	e8 d4 fd ff ff       	call   801348 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	6a 16                	push   $0x16
  80158c:	e8 b7 fd ff ff       	call   801348 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80159a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	6a 17                	push   $0x17
  8015aa:	e8 99 fd ff ff       	call   801348 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	51                   	push   %ecx
  8015ce:	52                   	push   %edx
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	50                   	push   %eax
  8015d3:	6a 19                	push   $0x19
  8015d5:	e8 6e fd ff ff       	call   801348 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	52                   	push   %edx
  8015ef:	50                   	push   %eax
  8015f0:	6a 1a                	push   $0x1a
  8015f2:	e8 51 fd ff ff       	call   801348 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	51                   	push   %ecx
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	6a 1b                	push   $0x1b
  801611:	e8 32 fd ff ff       	call   801348 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 1c                	push   $0x1c
  80162e:	e8 15 fd ff ff       	call   801348 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 1d                	push   $0x1d
  801647:	e8 fc fc ff ff       	call   801348 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	ff 75 14             	pushl  0x14(%ebp)
  80165c:	ff 75 10             	pushl  0x10(%ebp)
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	50                   	push   %eax
  801663:	6a 1e                	push   $0x1e
  801665:	e8 de fc ff ff       	call   801348 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	50                   	push   %eax
  80167e:	6a 1f                	push   $0x1f
  801680:	e8 c3 fc ff ff       	call   801348 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	50                   	push   %eax
  80169a:	6a 20                	push   $0x20
  80169c:	e8 a7 fc ff ff       	call   801348 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 02                	push   $0x2
  8016b5:	e8 8e fc ff ff       	call   801348 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 03                	push   $0x3
  8016ce:	e8 75 fc ff ff       	call   801348 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 04                	push   $0x4
  8016e7:	e8 5c fc ff ff       	call   801348 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_exit_env>:


void sys_exit_env(void)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 21                	push   $0x21
  801700:	e8 43 fc ff ff       	call   801348 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801711:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801714:	8d 50 04             	lea    0x4(%eax),%edx
  801717:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 22                	push   $0x22
  801724:	e8 1f fc ff ff       	call   801348 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return result;
  80172c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801732:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801735:	89 01                	mov    %eax,(%ecx)
  801737:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	c9                   	leave  
  80173e:	c2 04 00             	ret    $0x4

00801741 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	ff 75 10             	pushl  0x10(%ebp)
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	ff 75 08             	pushl  0x8(%ebp)
  801751:	6a 10                	push   $0x10
  801753:	e8 f0 fb ff ff       	call   801348 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
	return ;
  80175b:	90                   	nop
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_rcr2>:
uint32 sys_rcr2()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 23                	push   $0x23
  80176d:	e8 d6 fb ff ff       	call   801348 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801783:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	50                   	push   %eax
  801790:	6a 24                	push   $0x24
  801792:	e8 b1 fb ff ff       	call   801348 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
	return ;
  80179a:	90                   	nop
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <rsttst>:
void rsttst()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 26                	push   $0x26
  8017ac:	e8 97 fb ff ff       	call   801348 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017c3:	8b 55 18             	mov    0x18(%ebp),%edx
  8017c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ca:	52                   	push   %edx
  8017cb:	50                   	push   %eax
  8017cc:	ff 75 10             	pushl  0x10(%ebp)
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	6a 25                	push   $0x25
  8017d7:	e8 6c fb ff ff       	call   801348 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017df:	90                   	nop
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <chktst>:
void chktst(uint32 n)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	6a 27                	push   $0x27
  8017f2:	e8 51 fb ff ff       	call   801348 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fa:	90                   	nop
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <inctst>:

void inctst()
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 28                	push   $0x28
  80180c:	e8 37 fb ff ff       	call   801348 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
	return ;
  801814:	90                   	nop
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <gettst>:
uint32 gettst()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 29                	push   $0x29
  801826:	e8 1d fb ff ff       	call   801348 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 2a                	push   $0x2a
  801842:	e8 01 fb ff ff       	call   801348 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
  80184a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80184d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801851:	75 07                	jne    80185a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801853:	b8 01 00 00 00       	mov    $0x1,%eax
  801858:	eb 05                	jmp    80185f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 2a                	push   $0x2a
  801873:	e8 d0 fa ff ff       	call   801348 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
  80187b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80187e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801882:	75 07                	jne    80188b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801884:	b8 01 00 00 00       	mov    $0x1,%eax
  801889:	eb 05                	jmp    801890 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 2a                	push   $0x2a
  8018a4:	e8 9f fa ff ff       	call   801348 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
  8018ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8018af:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8018b3:	75 07                	jne    8018bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8018b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ba:	eb 05                	jmp    8018c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 2a                	push   $0x2a
  8018d5:	e8 6e fa ff ff       	call   801348 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
  8018dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018e0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018e4:	75 07                	jne    8018ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018eb:	eb 05                	jmp    8018f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	6a 2b                	push   $0x2b
  801904:	e8 3f fa ff ff       	call   801348 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
	return ;
  80190c:	90                   	nop
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801913:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801916:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	53                   	push   %ebx
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 2c                	push   $0x2c
  801927:	e8 1c fa ff ff       	call   801348 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 2d                	push   $0x2d
  801947:	e8 fc f9 ff ff       	call   801348 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801954:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	51                   	push   %ecx
  801960:	ff 75 10             	pushl  0x10(%ebp)
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 2e                	push   $0x2e
  801967:	e8 dc f9 ff ff       	call   801348 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	ff 75 10             	pushl  0x10(%ebp)
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 0f                	push   $0xf
  801983:	e8 c0 f9 ff ff       	call   801348 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	50                   	push   %eax
  80199d:	6a 2f                	push   $0x2f
  80199f:	e8 a4 f9 ff ff       	call   801348 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp

}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 30                	push   $0x30
  8019ba:	e8 89 f9 ff ff       	call   801348 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp

}
  8019c2:	90                   	nop
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 31                	push   $0x31
  8019d6:	e8 6d f9 ff ff       	call   801348 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp

}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 32                	push   $0x32
  8019f0:	e8 53 f9 ff ff       	call   801348 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    
  8019fa:	66 90                	xchg   %ax,%ax

008019fc <__udivdi3>:
  8019fc:	55                   	push   %ebp
  8019fd:	57                   	push   %edi
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 1c             	sub    $0x1c,%esp
  801a03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a13:	89 ca                	mov    %ecx,%edx
  801a15:	89 f8                	mov    %edi,%eax
  801a17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a1b:	85 f6                	test   %esi,%esi
  801a1d:	75 2d                	jne    801a4c <__udivdi3+0x50>
  801a1f:	39 cf                	cmp    %ecx,%edi
  801a21:	77 65                	ja     801a88 <__udivdi3+0x8c>
  801a23:	89 fd                	mov    %edi,%ebp
  801a25:	85 ff                	test   %edi,%edi
  801a27:	75 0b                	jne    801a34 <__udivdi3+0x38>
  801a29:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2e:	31 d2                	xor    %edx,%edx
  801a30:	f7 f7                	div    %edi
  801a32:	89 c5                	mov    %eax,%ebp
  801a34:	31 d2                	xor    %edx,%edx
  801a36:	89 c8                	mov    %ecx,%eax
  801a38:	f7 f5                	div    %ebp
  801a3a:	89 c1                	mov    %eax,%ecx
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	f7 f5                	div    %ebp
  801a40:	89 cf                	mov    %ecx,%edi
  801a42:	89 fa                	mov    %edi,%edx
  801a44:	83 c4 1c             	add    $0x1c,%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    
  801a4c:	39 ce                	cmp    %ecx,%esi
  801a4e:	77 28                	ja     801a78 <__udivdi3+0x7c>
  801a50:	0f bd fe             	bsr    %esi,%edi
  801a53:	83 f7 1f             	xor    $0x1f,%edi
  801a56:	75 40                	jne    801a98 <__udivdi3+0x9c>
  801a58:	39 ce                	cmp    %ecx,%esi
  801a5a:	72 0a                	jb     801a66 <__udivdi3+0x6a>
  801a5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a60:	0f 87 9e 00 00 00    	ja     801b04 <__udivdi3+0x108>
  801a66:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6b:	89 fa                	mov    %edi,%edx
  801a6d:	83 c4 1c             	add    $0x1c,%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    
  801a75:	8d 76 00             	lea    0x0(%esi),%esi
  801a78:	31 ff                	xor    %edi,%edi
  801a7a:	31 c0                	xor    %eax,%eax
  801a7c:	89 fa                	mov    %edi,%edx
  801a7e:	83 c4 1c             	add    $0x1c,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5f                   	pop    %edi
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	f7 f7                	div    %edi
  801a8c:	31 ff                	xor    %edi,%edi
  801a8e:	89 fa                	mov    %edi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a9d:	89 eb                	mov    %ebp,%ebx
  801a9f:	29 fb                	sub    %edi,%ebx
  801aa1:	89 f9                	mov    %edi,%ecx
  801aa3:	d3 e6                	shl    %cl,%esi
  801aa5:	89 c5                	mov    %eax,%ebp
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 ed                	shr    %cl,%ebp
  801aab:	89 e9                	mov    %ebp,%ecx
  801aad:	09 f1                	or     %esi,%ecx
  801aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ab3:	89 f9                	mov    %edi,%ecx
  801ab5:	d3 e0                	shl    %cl,%eax
  801ab7:	89 c5                	mov    %eax,%ebp
  801ab9:	89 d6                	mov    %edx,%esi
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 ee                	shr    %cl,%esi
  801abf:	89 f9                	mov    %edi,%ecx
  801ac1:	d3 e2                	shl    %cl,%edx
  801ac3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 e8                	shr    %cl,%eax
  801acb:	09 c2                	or     %eax,%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	89 f2                	mov    %esi,%edx
  801ad1:	f7 74 24 0c          	divl   0xc(%esp)
  801ad5:	89 d6                	mov    %edx,%esi
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	f7 e5                	mul    %ebp
  801adb:	39 d6                	cmp    %edx,%esi
  801add:	72 19                	jb     801af8 <__udivdi3+0xfc>
  801adf:	74 0b                	je     801aec <__udivdi3+0xf0>
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	31 ff                	xor    %edi,%edi
  801ae5:	e9 58 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af0:	89 f9                	mov    %edi,%ecx
  801af2:	d3 e2                	shl    %cl,%edx
  801af4:	39 c2                	cmp    %eax,%edx
  801af6:	73 e9                	jae    801ae1 <__udivdi3+0xe5>
  801af8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801afb:	31 ff                	xor    %edi,%edi
  801afd:	e9 40 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b02:	66 90                	xchg   %ax,%ax
  801b04:	31 c0                	xor    %eax,%eax
  801b06:	e9 37 ff ff ff       	jmp    801a42 <__udivdi3+0x46>
  801b0b:	90                   	nop

00801b0c <__umoddi3>:
  801b0c:	55                   	push   %ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b17:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b2b:	89 f3                	mov    %esi,%ebx
  801b2d:	89 fa                	mov    %edi,%edx
  801b2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b33:	89 34 24             	mov    %esi,(%esp)
  801b36:	85 c0                	test   %eax,%eax
  801b38:	75 1a                	jne    801b54 <__umoddi3+0x48>
  801b3a:	39 f7                	cmp    %esi,%edi
  801b3c:	0f 86 a2 00 00 00    	jbe    801be4 <__umoddi3+0xd8>
  801b42:	89 c8                	mov    %ecx,%eax
  801b44:	89 f2                	mov    %esi,%edx
  801b46:	f7 f7                	div    %edi
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	31 d2                	xor    %edx,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 f0                	cmp    %esi,%eax
  801b56:	0f 87 ac 00 00 00    	ja     801c08 <__umoddi3+0xfc>
  801b5c:	0f bd e8             	bsr    %eax,%ebp
  801b5f:	83 f5 1f             	xor    $0x1f,%ebp
  801b62:	0f 84 ac 00 00 00    	je     801c14 <__umoddi3+0x108>
  801b68:	bf 20 00 00 00       	mov    $0x20,%edi
  801b6d:	29 ef                	sub    %ebp,%edi
  801b6f:	89 fe                	mov    %edi,%esi
  801b71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 e0                	shl    %cl,%eax
  801b79:	89 d7                	mov    %edx,%edi
  801b7b:	89 f1                	mov    %esi,%ecx
  801b7d:	d3 ef                	shr    %cl,%edi
  801b7f:	09 c7                	or     %eax,%edi
  801b81:	89 e9                	mov    %ebp,%ecx
  801b83:	d3 e2                	shl    %cl,%edx
  801b85:	89 14 24             	mov    %edx,(%esp)
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	d3 e0                	shl    %cl,%eax
  801b8c:	89 c2                	mov    %eax,%edx
  801b8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b98:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9c:	89 f1                	mov    %esi,%ecx
  801b9e:	d3 e8                	shr    %cl,%eax
  801ba0:	09 d0                	or     %edx,%eax
  801ba2:	d3 eb                	shr    %cl,%ebx
  801ba4:	89 da                	mov    %ebx,%edx
  801ba6:	f7 f7                	div    %edi
  801ba8:	89 d3                	mov    %edx,%ebx
  801baa:	f7 24 24             	mull   (%esp)
  801bad:	89 c6                	mov    %eax,%esi
  801baf:	89 d1                	mov    %edx,%ecx
  801bb1:	39 d3                	cmp    %edx,%ebx
  801bb3:	0f 82 87 00 00 00    	jb     801c40 <__umoddi3+0x134>
  801bb9:	0f 84 91 00 00 00    	je     801c50 <__umoddi3+0x144>
  801bbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bc3:	29 f2                	sub    %esi,%edx
  801bc5:	19 cb                	sbb    %ecx,%ebx
  801bc7:	89 d8                	mov    %ebx,%eax
  801bc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bcd:	d3 e0                	shl    %cl,%eax
  801bcf:	89 e9                	mov    %ebp,%ecx
  801bd1:	d3 ea                	shr    %cl,%edx
  801bd3:	09 d0                	or     %edx,%eax
  801bd5:	89 e9                	mov    %ebp,%ecx
  801bd7:	d3 eb                	shr    %cl,%ebx
  801bd9:	89 da                	mov    %ebx,%edx
  801bdb:	83 c4 1c             	add    $0x1c,%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5e                   	pop    %esi
  801be0:	5f                   	pop    %edi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    
  801be3:	90                   	nop
  801be4:	89 fd                	mov    %edi,%ebp
  801be6:	85 ff                	test   %edi,%edi
  801be8:	75 0b                	jne    801bf5 <__umoddi3+0xe9>
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	31 d2                	xor    %edx,%edx
  801bf1:	f7 f7                	div    %edi
  801bf3:	89 c5                	mov    %eax,%ebp
  801bf5:	89 f0                	mov    %esi,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f5                	div    %ebp
  801bfb:	89 c8                	mov    %ecx,%eax
  801bfd:	f7 f5                	div    %ebp
  801bff:	89 d0                	mov    %edx,%eax
  801c01:	e9 44 ff ff ff       	jmp    801b4a <__umoddi3+0x3e>
  801c06:	66 90                	xchg   %ax,%ax
  801c08:	89 c8                	mov    %ecx,%eax
  801c0a:	89 f2                	mov    %esi,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	3b 04 24             	cmp    (%esp),%eax
  801c17:	72 06                	jb     801c1f <__umoddi3+0x113>
  801c19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c1d:	77 0f                	ja     801c2e <__umoddi3+0x122>
  801c1f:	89 f2                	mov    %esi,%edx
  801c21:	29 f9                	sub    %edi,%ecx
  801c23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c27:	89 14 24             	mov    %edx,(%esp)
  801c2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c32:	8b 14 24             	mov    (%esp),%edx
  801c35:	83 c4 1c             	add    $0x1c,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
  801c3d:	8d 76 00             	lea    0x0(%esi),%esi
  801c40:	2b 04 24             	sub    (%esp),%eax
  801c43:	19 fa                	sbb    %edi,%edx
  801c45:	89 d1                	mov    %edx,%ecx
  801c47:	89 c6                	mov    %eax,%esi
  801c49:	e9 71 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c54:	72 ea                	jb     801c40 <__umoddi3+0x134>
  801c56:	89 d9                	mov    %ebx,%ecx
  801c58:	e9 62 ff ff ff       	jmp    801bbf <__umoddi3+0xb3>
