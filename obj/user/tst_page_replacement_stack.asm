
obj/user/tst_page_replacement_stack:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 14 a0 00 00    	sub    $0xa014,%esp
	int8 arr[PAGE_SIZE*10];

	uint32 kilo = 1024;
  800042:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)

//	cprintf("envID = %d\n",envID);

	int freePages = sys_calculate_free_frames();
  800049:	e8 c6 13 00 00       	call   801414 <sys_calculate_free_frames>
  80004e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800051:	e8 09 14 00 00       	call   80145f <sys_pf_calculate_allocated_pages>
  800056:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800060:	eb 15                	jmp    800077 <_main+0x3f>
		arr[i] = -1 ;
  800062:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c6 00 ff             	movb   $0xff,(%eax)

	int freePages = sys_calculate_free_frames();
	int usedDiskPages = sys_pf_calculate_allocated_pages();

	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800070:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  800077:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  80007e:	7e e2                	jle    800062 <_main+0x2a>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 40 1c 80 00       	push   $0x801c40
  800088:	e8 96 04 00 00       	call   800523 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800097:	eb 2c                	jmp    8000c5 <_main+0x8d>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");
  800099:	8d 95 e8 5f ff ff    	lea    -0xa018(%ebp),%edx
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	01 d0                	add    %edx,%eax
  8000a4:	8a 00                	mov    (%eax),%al
  8000a6:	3c ff                	cmp    $0xff,%al
  8000a8:	74 14                	je     8000be <_main+0x86>
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	68 78 1c 80 00       	push   $0x801c78
  8000b2:	6a 1a                	push   $0x1a
  8000b4:	68 a8 1c 80 00       	push   $0x801ca8
  8000b9:	e8 a8 01 00 00       	call   800266 <_panic>
		arr[i] = -1 ;


	cprintf("checking REPLACEMENT fault handling of STACK pages... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000be:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8000c5:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8000cc:	7e cb                	jle    800099 <_main+0x61>
			if( arr[i] != -1) panic("modified stack page(s) not restored correctly");

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  10) panic("Unexpected extra/less pages have been added to page file");
  8000ce:	e8 8c 13 00 00       	call   80145f <sys_pf_calculate_allocated_pages>
  8000d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000d6:	83 f8 0a             	cmp    $0xa,%eax
  8000d9:	74 14                	je     8000ef <_main+0xb7>
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	68 cc 1c 80 00       	push   $0x801ccc
  8000e3:	6a 1c                	push   $0x1c
  8000e5:	68 a8 1c 80 00       	push   $0x801ca8
  8000ea:	e8 77 01 00 00       	call   800266 <_panic>

		if( (freePages - (sys_calculate_free_frames() + sys_calculate_modified_frames())) != 0 ) panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8000ef:	e8 20 13 00 00       	call   801414 <sys_calculate_free_frames>
  8000f4:	89 c3                	mov    %eax,%ebx
  8000f6:	e8 32 13 00 00       	call   80142d <sys_calculate_modified_frames>
  8000fb:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 08 1d 80 00       	push   $0x801d08
  80010d:	6a 1e                	push   $0x1e
  80010f:	68 a8 1c 80 00       	push   $0x801ca8
  800114:	e8 4d 01 00 00       	call   800266 <_panic>
	}//consider tables of PF, disk pages

	cprintf("Congratulations: stack pages created, modified and read successfully!\n\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 6c 1d 80 00       	push   $0x801d6c
  800121:	e8 fd 03 00 00       	call   800523 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp


	return;
  800129:	90                   	nop
}
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800135:	e8 65 15 00 00       	call   80169f <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	01 c0                	add    %eax,%eax
  800149:	01 d0                	add    %edx,%eax
  80014b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800152:	01 d0                	add    %edx,%eax
  800154:	c1 e0 04             	shl    $0x4,%eax
  800157:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800161:	a1 20 30 80 00       	mov    0x803020,%eax
  800166:	8a 40 5c             	mov    0x5c(%eax),%al
  800169:	84 c0                	test   %al,%al
  80016b:	74 0d                	je     80017a <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80016d:	a1 20 30 80 00       	mov    0x803020,%eax
  800172:	83 c0 5c             	add    $0x5c,%eax
  800175:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017e:	7e 0a                	jle    80018a <libmain+0x5b>
		binaryname = argv[0];
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 00                	mov    (%eax),%eax
  800185:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 0c             	pushl  0xc(%ebp)
  800190:	ff 75 08             	pushl  0x8(%ebp)
  800193:	e8 a0 fe ff ff       	call   800038 <_main>
  800198:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80019b:	e8 0c 13 00 00       	call   8014ac <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 cc 1d 80 00       	push   $0x801dcc
  8001a8:	e8 76 03 00 00       	call   800523 <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b5:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8001bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c0:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	52                   	push   %edx
  8001ca:	50                   	push   %eax
  8001cb:	68 f4 1d 80 00       	push   $0x801df4
  8001d0:	e8 4e 03 00 00       	call   800523 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8001e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e8:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8001ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f3:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8001f9:	51                   	push   %ecx
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	68 1c 1e 80 00       	push   $0x801e1c
  800201:	e8 1d 03 00 00       	call   800523 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800209:	a1 20 30 80 00       	mov    0x803020,%eax
  80020e:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	50                   	push   %eax
  800218:	68 74 1e 80 00       	push   $0x801e74
  80021d:	e8 01 03 00 00       	call   800523 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 cc 1d 80 00       	push   $0x801dcc
  80022d:	e8 f1 02 00 00       	call   800523 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800235:	e8 8c 12 00 00       	call   8014c6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80023a:	e8 19 00 00 00       	call   800258 <exit>
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	6a 00                	push   $0x0
  80024d:	e8 19 14 00 00       	call   80166b <sys_destroy_env>
  800252:	83 c4 10             	add    $0x10,%esp
}
  800255:	90                   	nop
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <exit>:

void
exit(void)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80025e:	e8 6e 14 00 00       	call   8016d1 <sys_exit_env>
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80026c:	8d 45 10             	lea    0x10(%ebp),%eax
  80026f:	83 c0 04             	add    $0x4,%eax
  800272:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800275:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80027a:	85 c0                	test   %eax,%eax
  80027c:	74 16                	je     800294 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80027e:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	50                   	push   %eax
  800287:	68 88 1e 80 00       	push   $0x801e88
  80028c:	e8 92 02 00 00       	call   800523 <cprintf>
  800291:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800294:	a1 00 30 80 00       	mov    0x803000,%eax
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	ff 75 08             	pushl  0x8(%ebp)
  80029f:	50                   	push   %eax
  8002a0:	68 8d 1e 80 00       	push   $0x801e8d
  8002a5:	e8 79 02 00 00       	call   800523 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	50                   	push   %eax
  8002b7:	e8 fc 01 00 00       	call   8004b8 <vcprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	6a 00                	push   $0x0
  8002c4:	68 a9 1e 80 00       	push   $0x801ea9
  8002c9:	e8 ea 01 00 00       	call   8004b8 <vcprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002d1:	e8 82 ff ff ff       	call   800258 <exit>

	// should not return here
	while (1) ;
  8002d6:	eb fe                	jmp    8002d6 <_panic+0x70>

008002d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002de:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e3:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	39 c2                	cmp    %eax,%edx
  8002ee:	74 14                	je     800304 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	68 ac 1e 80 00       	push   $0x801eac
  8002f8:	6a 26                	push   $0x26
  8002fa:	68 f8 1e 80 00       	push   $0x801ef8
  8002ff:	e8 62 ff ff ff       	call   800266 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80030b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800312:	e9 c5 00 00 00       	jmp    8003dc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80031a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	01 d0                	add    %edx,%eax
  800326:	8b 00                	mov    (%eax),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	75 08                	jne    800334 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80032c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80032f:	e9 a5 00 00 00       	jmp    8003d9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800334:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80033b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800342:	eb 69                	jmp    8003ad <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800344:	a1 20 30 80 00       	mov    0x803020,%eax
  800349:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80034f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800352:	89 d0                	mov    %edx,%eax
  800354:	01 c0                	add    %eax,%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	c1 e0 03             	shl    $0x3,%eax
  80035b:	01 c8                	add    %ecx,%eax
  80035d:	8a 40 04             	mov    0x4(%eax),%al
  800360:	84 c0                	test   %al,%al
  800362:	75 46                	jne    8003aa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80036f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800372:	89 d0                	mov    %edx,%eax
  800374:	01 c0                	add    %eax,%eax
  800376:	01 d0                	add    %edx,%eax
  800378:	c1 e0 03             	shl    $0x3,%eax
  80037b:	01 c8                	add    %ecx,%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80038c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c8                	add    %ecx,%eax
  80039b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039d:	39 c2                	cmp    %eax,%edx
  80039f:	75 09                	jne    8003aa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003a8:	eb 15                	jmp    8003bf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003aa:	ff 45 e8             	incl   -0x18(%ebp)
  8003ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b2:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8003b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003bb:	39 c2                	cmp    %eax,%edx
  8003bd:	77 85                	ja     800344 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c3:	75 14                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003c5:	83 ec 04             	sub    $0x4,%esp
  8003c8:	68 04 1f 80 00       	push   $0x801f04
  8003cd:	6a 3a                	push   $0x3a
  8003cf:	68 f8 1e 80 00       	push   $0x801ef8
  8003d4:	e8 8d fe ff ff       	call   800266 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003d9:	ff 45 f0             	incl   -0x10(%ebp)
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e2:	0f 8c 2f ff ff ff    	jl     800317 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f6:	eb 26                	jmp    80041e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fd:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800403:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800406:	89 d0                	mov    %edx,%eax
  800408:	01 c0                	add    %eax,%eax
  80040a:	01 d0                	add    %edx,%eax
  80040c:	c1 e0 03             	shl    $0x3,%eax
  80040f:	01 c8                	add    %ecx,%eax
  800411:	8a 40 04             	mov    0x4(%eax),%al
  800414:	3c 01                	cmp    $0x1,%al
  800416:	75 03                	jne    80041b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800418:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041b:	ff 45 e0             	incl   -0x20(%ebp)
  80041e:	a1 20 30 80 00       	mov    0x803020,%eax
  800423:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042c:	39 c2                	cmp    %eax,%edx
  80042e:	77 c8                	ja     8003f8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800433:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800436:	74 14                	je     80044c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	68 58 1f 80 00       	push   $0x801f58
  800440:	6a 44                	push   $0x44
  800442:	68 f8 1e 80 00       	push   $0x801ef8
  800447:	e8 1a fe ff ff       	call   800266 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044c:	90                   	nop
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    

0080044f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	8d 48 01             	lea    0x1(%eax),%ecx
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	89 0a                	mov    %ecx,(%edx)
  800462:	8b 55 08             	mov    0x8(%ebp),%edx
  800465:	88 d1                	mov    %dl,%cl
  800467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	3d ff 00 00 00       	cmp    $0xff,%eax
  800478:	75 2c                	jne    8004a6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047a:	a0 24 30 80 00       	mov    0x803024,%al
  80047f:	0f b6 c0             	movzbl %al,%eax
  800482:	8b 55 0c             	mov    0xc(%ebp),%edx
  800485:	8b 12                	mov    (%edx),%edx
  800487:	89 d1                	mov    %edx,%ecx
  800489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048c:	83 c2 08             	add    $0x8,%edx
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	50                   	push   %eax
  800493:	51                   	push   %ecx
  800494:	52                   	push   %edx
  800495:	e8 b9 0e 00 00       	call   801353 <sys_cputs>
  80049a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a9:	8b 40 04             	mov    0x4(%eax),%eax
  8004ac:	8d 50 01             	lea    0x1(%eax),%edx
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c8:	00 00 00 
	b.cnt = 0;
  8004cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 08             	pushl  0x8(%ebp)
  8004db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	68 4f 04 80 00       	push   $0x80044f
  8004e7:	e8 11 02 00 00       	call   8006fd <vprintfmt>
  8004ec:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ef:	a0 24 30 80 00       	mov    0x803024,%al
  8004f4:	0f b6 c0             	movzbl %al,%eax
  8004f7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	50                   	push   %eax
  800501:	52                   	push   %edx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 42 0e 00 00       	call   801353 <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 73 ff ff ff       	call   8004b8 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800556:	e8 51 0f 00 00       	call   8014ac <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80055e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	ff 75 f4             	pushl  -0xc(%ebp)
  80056a:	50                   	push   %eax
  80056b:	e8 48 ff ff ff       	call   8004b8 <vcprintf>
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800576:	e8 4b 0f 00 00       	call   8014c6 <sys_enable_interrupt>
	return cnt;
  80057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80057e:	c9                   	leave  
  80057f:	c3                   	ret    

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	53                   	push   %ebx
  800584:	83 ec 14             	sub    $0x14,%esp
  800587:	8b 45 10             	mov    0x10(%ebp),%eax
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800593:	8b 45 18             	mov    0x18(%ebp),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80059e:	77 55                	ja     8005f5 <printnum+0x75>
  8005a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a3:	72 05                	jb     8005aa <printnum+0x2a>
  8005a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005a8:	77 4b                	ja     8005f5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	52                   	push   %edx
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c0:	e8 17 14 00 00       	call   8019dc <__udivdi3>
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	83 ec 04             	sub    $0x4,%esp
  8005cb:	ff 75 20             	pushl  0x20(%ebp)
  8005ce:	53                   	push   %ebx
  8005cf:	ff 75 18             	pushl  0x18(%ebp)
  8005d2:	52                   	push   %edx
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	e8 a1 ff ff ff       	call   800580 <printnum>
  8005df:	83 c4 20             	add    $0x20,%esp
  8005e2:	eb 1a                	jmp    8005fe <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 20             	pushl  0x20(%ebp)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	ff d0                	call   *%eax
  8005f2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f5:	ff 4d 1c             	decl   0x1c(%ebp)
  8005f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fc:	7f e6                	jg     8005e4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fe:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800601:	bb 00 00 00 00       	mov    $0x0,%ebx
  800606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060c:	53                   	push   %ebx
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	50                   	push   %eax
  800610:	e8 d7 14 00 00       	call   801aec <__umoddi3>
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	05 d4 21 80 00       	add    $0x8021d4,%eax
  80061d:	8a 00                	mov    (%eax),%al
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	ff d0                	call   *%eax
  80062e:	83 c4 10             	add    $0x10,%esp
}
  800631:	90                   	nop
  800632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80063e:	7e 1c                	jle    80065c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	8d 50 08             	lea    0x8(%eax),%edx
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	89 10                	mov    %edx,(%eax)
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	83 e8 08             	sub    $0x8,%eax
  800655:	8b 50 04             	mov    0x4(%eax),%edx
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	eb 40                	jmp    80069c <getuint+0x65>
	else if (lflag)
  80065c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800660:	74 1e                	je     800680 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	8d 50 04             	lea    0x4(%eax),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	89 10                	mov    %edx,(%eax)
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 e8 04             	sub    $0x4,%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	eb 1c                	jmp    80069c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	8d 50 04             	lea    0x4(%eax),%edx
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	89 10                	mov    %edx,(%eax)
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	83 e8 04             	sub    $0x4,%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a5:	7e 1c                	jle    8006c3 <getint+0x25>
		return va_arg(*ap, long long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 08             	lea    0x8(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 08             	sub    $0x8,%eax
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	eb 38                	jmp    8006fb <getint+0x5d>
	else if (lflag)
  8006c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c7:	74 1a                	je     8006e3 <getint+0x45>
		return va_arg(*ap, long);
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	8d 50 04             	lea    0x4(%eax),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	89 10                	mov    %edx,(%eax)
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	83 e8 04             	sub    $0x4,%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	99                   	cltd   
  8006e1:	eb 18                	jmp    8006fb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	8d 50 04             	lea    0x4(%eax),%edx
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 10                	mov    %edx,(%eax)
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	99                   	cltd   
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	56                   	push   %esi
  800701:	53                   	push   %ebx
  800702:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800705:	eb 17                	jmp    80071e <vprintfmt+0x21>
			if (ch == '\0')
  800707:	85 db                	test   %ebx,%ebx
  800709:	0f 84 af 03 00 00    	je     800abe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	53                   	push   %ebx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071e:	8b 45 10             	mov    0x10(%ebp),%eax
  800721:	8d 50 01             	lea    0x1(%eax),%edx
  800724:	89 55 10             	mov    %edx,0x10(%ebp)
  800727:	8a 00                	mov    (%eax),%al
  800729:	0f b6 d8             	movzbl %al,%ebx
  80072c:	83 fb 25             	cmp    $0x25,%ebx
  80072f:	75 d6                	jne    800707 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800731:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800735:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800743:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800751:	8b 45 10             	mov    0x10(%ebp),%eax
  800754:	8d 50 01             	lea    0x1(%eax),%edx
  800757:	89 55 10             	mov    %edx,0x10(%ebp)
  80075a:	8a 00                	mov    (%eax),%al
  80075c:	0f b6 d8             	movzbl %al,%ebx
  80075f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800762:	83 f8 55             	cmp    $0x55,%eax
  800765:	0f 87 2b 03 00 00    	ja     800a96 <vprintfmt+0x399>
  80076b:	8b 04 85 f8 21 80 00 	mov    0x8021f8(,%eax,4),%eax
  800772:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800778:	eb d7                	jmp    800751 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80077e:	eb d1                	jmp    800751 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079b:	8b 45 10             	mov    0x10(%ebp),%eax
  80079e:	8a 00                	mov    (%eax),%al
  8007a0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a6:	7e 3e                	jle    8007e6 <vprintfmt+0xe9>
  8007a8:	83 fb 39             	cmp    $0x39,%ebx
  8007ab:	7f 39                	jg     8007e6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ad:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b0:	eb d5                	jmp    800787 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c6:	eb 1f                	jmp    8007e7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	79 83                	jns    800751 <vprintfmt+0x54>
				width = 0;
  8007ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d5:	e9 77 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e1:	e9 6b ff ff ff       	jmp    800751 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007eb:	0f 89 60 ff ff ff    	jns    800751 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007fe:	e9 4e ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800803:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800806:	e9 46 ff ff ff       	jmp    800751 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	83 c0 04             	add    $0x4,%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	50                   	push   %eax
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			break;
  80082b:	e9 89 02 00 00       	jmp    800ab9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	83 c0 04             	add    $0x4,%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	83 e8 04             	sub    $0x4,%eax
  80083f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800841:	85 db                	test   %ebx,%ebx
  800843:	79 02                	jns    800847 <vprintfmt+0x14a>
				err = -err;
  800845:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800847:	83 fb 64             	cmp    $0x64,%ebx
  80084a:	7f 0b                	jg     800857 <vprintfmt+0x15a>
  80084c:	8b 34 9d 40 20 80 00 	mov    0x802040(,%ebx,4),%esi
  800853:	85 f6                	test   %esi,%esi
  800855:	75 19                	jne    800870 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800857:	53                   	push   %ebx
  800858:	68 e5 21 80 00       	push   $0x8021e5
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 5e 02 00 00       	call   800ac6 <printfmt>
  800868:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086b:	e9 49 02 00 00       	jmp    800ab9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800870:	56                   	push   %esi
  800871:	68 ee 21 80 00       	push   $0x8021ee
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	ff 75 08             	pushl  0x8(%ebp)
  80087c:	e8 45 02 00 00       	call   800ac6 <printfmt>
  800881:	83 c4 10             	add    $0x10,%esp
			break;
  800884:	e9 30 02 00 00       	jmp    800ab9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	83 c0 04             	add    $0x4,%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 e8 04             	sub    $0x4,%eax
  800898:	8b 30                	mov    (%eax),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 05                	jne    8008a3 <vprintfmt+0x1a6>
				p = "(null)";
  80089e:	be f1 21 80 00       	mov    $0x8021f1,%esi
			if (width > 0 && padc != '-')
  8008a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a7:	7e 6d                	jle    800916 <vprintfmt+0x219>
  8008a9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ad:	74 67                	je     800916 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	50                   	push   %eax
  8008b6:	56                   	push   %esi
  8008b7:	e8 0c 03 00 00       	call   800bc8 <strnlen>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c2:	eb 16                	jmp    8008da <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	7f e4                	jg     8008c4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e0:	eb 34                	jmp    800916 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e6:	74 1c                	je     800904 <vprintfmt+0x207>
  8008e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008eb:	7e 05                	jle    8008f2 <vprintfmt+0x1f5>
  8008ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f0:	7e 12                	jle    800904 <vprintfmt+0x207>
					putch('?', putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	6a 3f                	push   $0x3f
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	ff d0                	call   *%eax
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	eb 0f                	jmp    800913 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800913:	ff 4d e4             	decl   -0x1c(%ebp)
  800916:	89 f0                	mov    %esi,%eax
  800918:	8d 70 01             	lea    0x1(%eax),%esi
  80091b:	8a 00                	mov    (%eax),%al
  80091d:	0f be d8             	movsbl %al,%ebx
  800920:	85 db                	test   %ebx,%ebx
  800922:	74 24                	je     800948 <vprintfmt+0x24b>
  800924:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800928:	78 b8                	js     8008e2 <vprintfmt+0x1e5>
  80092a:	ff 4d e0             	decl   -0x20(%ebp)
  80092d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800931:	79 af                	jns    8008e2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800933:	eb 13                	jmp    800948 <vprintfmt+0x24b>
				putch(' ', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 20                	push   $0x20
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	7f e7                	jg     800935 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80094e:	e9 66 01 00 00       	jmp    800ab9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 e8             	pushl  -0x18(%ebp)
  800959:	8d 45 14             	lea    0x14(%ebp),%eax
  80095c:	50                   	push   %eax
  80095d:	e8 3c fd ff ff       	call   80069e <getint>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800971:	85 d2                	test   %edx,%edx
  800973:	79 23                	jns    800998 <vprintfmt+0x29b>
				putch('-', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	6a 2d                	push   $0x2d
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098b:	f7 d8                	neg    %eax
  80098d:	83 d2 00             	adc    $0x0,%edx
  800990:	f7 da                	neg    %edx
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800998:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80099f:	e9 bc 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009aa:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ad:	50                   	push   %eax
  8009ae:	e8 84 fc ff ff       	call   800637 <getuint>
  8009b3:	83 c4 10             	add    $0x10,%esp
  8009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009bc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c3:	e9 98 00 00 00       	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	6a 58                	push   $0x58
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	ff d0                	call   *%eax
  8009d5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			break;
  8009f8:	e9 bc 00 00 00       	jmp    800ab9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	6a 30                	push   $0x30
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 78                	push   $0x78
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 c0 04             	add    $0x4,%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 e8 04             	sub    $0x4,%eax
  800a2c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a38:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 e8             	pushl  -0x18(%ebp)
  800a47:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4a:	50                   	push   %eax
  800a4b:	e8 e7 fb ff ff       	call   800637 <getuint>
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a56:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a60:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	52                   	push   %edx
  800a6b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a72:	ff 75 f0             	pushl  -0x10(%ebp)
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 00 fb ff ff       	call   800580 <printnum>
  800a80:	83 c4 20             	add    $0x20,%esp
			break;
  800a83:	eb 34                	jmp    800ab9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	53                   	push   %ebx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			break;
  800a94:	eb 23                	jmp    800ab9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 25                	push   $0x25
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa6:	ff 4d 10             	decl   0x10(%ebp)
  800aa9:	eb 03                	jmp    800aae <vprintfmt+0x3b1>
  800aab:	ff 4d 10             	decl   0x10(%ebp)
  800aae:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab1:	48                   	dec    %eax
  800ab2:	8a 00                	mov    (%eax),%al
  800ab4:	3c 25                	cmp    $0x25,%al
  800ab6:	75 f3                	jne    800aab <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ab8:	90                   	nop
		}
	}
  800ab9:	e9 47 fc ff ff       	jmp    800705 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800abe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800acc:	8d 45 10             	lea    0x10(%ebp),%eax
  800acf:	83 c0 04             	add    $0x4,%eax
  800ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  800adb:	50                   	push   %eax
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 16 fc ff ff       	call   8006fd <vprintfmt>
  800ae7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aea:	90                   	nop
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 08             	mov    0x8(%eax),%eax
  800af6:	8d 50 01             	lea    0x1(%eax),%edx
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	8b 10                	mov    (%eax),%edx
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	8b 40 04             	mov    0x4(%eax),%eax
  800b0a:	39 c2                	cmp    %eax,%edx
  800b0c:	73 12                	jae    800b20 <sprintputch+0x33>
		*b->buf++ = ch;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	8d 48 01             	lea    0x1(%eax),%ecx
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	89 0a                	mov    %ecx,(%edx)
  800b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1e:	88 10                	mov    %dl,(%eax)
}
  800b20:	90                   	nop
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	01 d0                	add    %edx,%eax
  800b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b48:	74 06                	je     800b50 <vsnprintf+0x2d>
  800b4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4e:	7f 07                	jg     800b57 <vsnprintf+0x34>
		return -E_INVAL;
  800b50:	b8 03 00 00 00       	mov    $0x3,%eax
  800b55:	eb 20                	jmp    800b77 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b57:	ff 75 14             	pushl  0x14(%ebp)
  800b5a:	ff 75 10             	pushl  0x10(%ebp)
  800b5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b60:	50                   	push   %eax
  800b61:	68 ed 0a 80 00       	push   $0x800aed
  800b66:	e8 92 fb ff ff       	call   8006fd <vprintfmt>
  800b6b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b7f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b82:	83 c0 04             	add    $0x4,%eax
  800b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b88:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8e:	50                   	push   %eax
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	ff 75 08             	pushl  0x8(%ebp)
  800b95:	e8 89 ff ff ff       	call   800b23 <vsnprintf>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 06                	jmp    800bba <strlen+0x15>
		n++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	84 c0                	test   %al,%al
  800bc1:	75 f1                	jne    800bb4 <strlen+0xf>
		n++;
	return n;
  800bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd5:	eb 09                	jmp    800be0 <strnlen+0x18>
		n++;
  800bd7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bda:	ff 45 08             	incl   0x8(%ebp)
  800bdd:	ff 4d 0c             	decl   0xc(%ebp)
  800be0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be4:	74 09                	je     800bef <strnlen+0x27>
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	84 c0                	test   %al,%al
  800bed:	75 e8                	jne    800bd7 <strnlen+0xf>
		n++;
	return n;
  800bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c00:	90                   	nop
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8d 50 01             	lea    0x1(%eax),%edx
  800c07:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c13:	8a 12                	mov    (%edx),%dl
  800c15:	88 10                	mov    %dl,(%eax)
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 e4                	jne    800c01 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c35:	eb 1f                	jmp    800c56 <strncpy+0x34>
		*dst++ = *src;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8d 50 01             	lea    0x1(%eax),%edx
  800c3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	8a 12                	mov    (%edx),%dl
  800c45:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	74 03                	je     800c53 <strncpy+0x31>
			src++;
  800c50:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c53:	ff 45 fc             	incl   -0x4(%ebp)
  800c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c59:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5c:	72 d9                	jb     800c37 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c73:	74 30                	je     800ca5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c75:	eb 16                	jmp    800c8d <strlcpy+0x2a>
			*dst++ = *src++;
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8d 50 01             	lea    0x1(%eax),%edx
  800c7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c83:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c86:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c89:	8a 12                	mov    (%edx),%dl
  800c8b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8d:	ff 4d 10             	decl   0x10(%ebp)
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 09                	je     800c9f <strlcpy+0x3c>
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	84 c0                	test   %al,%al
  800c9d:	75 d8                	jne    800c77 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cab:	29 c2                	sub    %eax,%edx
  800cad:	89 d0                	mov    %edx,%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb4:	eb 06                	jmp    800cbc <strcmp+0xb>
		p++, q++;
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 0e                	je     800cd3 <strcmp+0x22>
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 10                	mov    (%eax),%dl
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	38 c2                	cmp    %al,%dl
  800cd1:	74 e3                	je     800cb6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	0f b6 d0             	movzbl %al,%edx
  800cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 c0             	movzbl %al,%eax
  800ce3:	29 c2                	sub    %eax,%edx
  800ce5:	89 d0                	mov    %edx,%eax
}
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cec:	eb 09                	jmp    800cf7 <strncmp+0xe>
		n--, p++, q++;
  800cee:	ff 4d 10             	decl   0x10(%ebp)
  800cf1:	ff 45 08             	incl   0x8(%ebp)
  800cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfb:	74 17                	je     800d14 <strncmp+0x2b>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	84 c0                	test   %al,%al
  800d04:	74 0e                	je     800d14 <strncmp+0x2b>
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 10                	mov    (%eax),%dl
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	38 c2                	cmp    %al,%dl
  800d12:	74 da                	je     800cee <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d18:	75 07                	jne    800d21 <strncmp+0x38>
		return 0;
  800d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1f:	eb 14                	jmp    800d35 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 04             	sub    $0x4,%esp
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d43:	eb 12                	jmp    800d57 <strchr+0x20>
		if (*s == c)
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4d:	75 05                	jne    800d54 <strchr+0x1d>
			return (char *) s;
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	eb 11                	jmp    800d65 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d54:	ff 45 08             	incl   0x8(%ebp)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 e5                	jne    800d45 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 04             	sub    $0x4,%esp
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d73:	eb 0d                	jmp    800d82 <strfind+0x1b>
		if (*s == c)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7d:	74 0e                	je     800d8d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7f:	ff 45 08             	incl   0x8(%ebp)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	75 ea                	jne    800d75 <strfind+0xe>
  800d8b:	eb 01                	jmp    800d8e <strfind+0x27>
		if (*s == c)
			break;
  800d8d:	90                   	nop
	return (char *) s;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800da2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da5:	eb 0e                	jmp    800db5 <memset+0x22>
		*p++ = c;
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	8d 50 01             	lea    0x1(%eax),%edx
  800dad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db5:	ff 4d f8             	decl   -0x8(%ebp)
  800db8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbc:	79 e9                	jns    800da7 <memset+0x14>
		*p++ = c;

	return v;
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd5:	eb 16                	jmp    800ded <memcpy+0x2a>
		*d++ = *s++;
  800dd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df3:	89 55 10             	mov    %edx,0x10(%ebp)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	75 dd                	jne    800dd7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e17:	73 50                	jae    800e69 <memmove+0x6a>
  800e19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	01 d0                	add    %edx,%eax
  800e21:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e24:	76 43                	jbe    800e69 <memmove+0x6a>
		s += n;
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e32:	eb 10                	jmp    800e44 <memmove+0x45>
			*--d = *--s;
  800e34:	ff 4d f8             	decl   -0x8(%ebp)
  800e37:	ff 4d fc             	decl   -0x4(%ebp)
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e44:	8b 45 10             	mov    0x10(%ebp),%eax
  800e47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	75 e3                	jne    800e34 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e51:	eb 23                	jmp    800e76 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e56:	8d 50 01             	lea    0x1(%eax),%edx
  800e59:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e62:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e65:	8a 12                	mov    (%edx),%dl
  800e67:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	75 dd                	jne    800e53 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8d:	eb 2a                	jmp    800eb9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e92:	8a 10                	mov    (%eax),%dl
  800e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	38 c2                	cmp    %al,%dl
  800e9b:	74 16                	je     800eb3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	0f b6 d0             	movzbl %al,%edx
  800ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 c0             	movzbl %al,%eax
  800ead:	29 c2                	sub    %eax,%edx
  800eaf:	89 d0                	mov    %edx,%eax
  800eb1:	eb 18                	jmp    800ecb <memcmp+0x50>
		s1++, s2++;
  800eb3:	ff 45 fc             	incl   -0x4(%ebp)
  800eb6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	75 c9                	jne    800e8f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	01 d0                	add    %edx,%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ede:	eb 15                	jmp    800ef5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	0f b6 c0             	movzbl %al,%eax
  800eee:	39 c2                	cmp    %eax,%edx
  800ef0:	74 0d                	je     800eff <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efb:	72 e3                	jb     800ee0 <memfind+0x13>
  800efd:	eb 01                	jmp    800f00 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eff:	90                   	nop
	return (void *) s;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f19:	eb 03                	jmp    800f1e <strtol+0x19>
		s++;
  800f1b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 20                	cmp    $0x20,%al
  800f25:	74 f4                	je     800f1b <strtol+0x16>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 09                	cmp    $0x9,%al
  800f2e:	74 eb                	je     800f1b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 2b                	cmp    $0x2b,%al
  800f37:	75 05                	jne    800f3e <strtol+0x39>
		s++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	eb 13                	jmp    800f51 <strtol+0x4c>
	else if (*s == '-')
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 2d                	cmp    $0x2d,%al
  800f45:	75 0a                	jne    800f51 <strtol+0x4c>
		s++, neg = 1;
  800f47:	ff 45 08             	incl   0x8(%ebp)
  800f4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	74 06                	je     800f5d <strtol+0x58>
  800f57:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5b:	75 20                	jne    800f7d <strtol+0x78>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	3c 30                	cmp    $0x30,%al
  800f64:	75 17                	jne    800f7d <strtol+0x78>
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	40                   	inc    %eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 78                	cmp    $0x78,%al
  800f6e:	75 0d                	jne    800f7d <strtol+0x78>
		s += 2, base = 16;
  800f70:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f74:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7b:	eb 28                	jmp    800fa5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f81:	75 15                	jne    800f98 <strtol+0x93>
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3c 30                	cmp    $0x30,%al
  800f8a:	75 0c                	jne    800f98 <strtol+0x93>
		s++, base = 8;
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f96:	eb 0d                	jmp    800fa5 <strtol+0xa0>
	else if (base == 0)
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 07                	jne    800fa5 <strtol+0xa0>
		base = 10;
  800f9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3c 2f                	cmp    $0x2f,%al
  800fac:	7e 19                	jle    800fc7 <strtol+0xc2>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 39                	cmp    $0x39,%al
  800fb5:	7f 10                	jg     800fc7 <strtol+0xc2>
			dig = *s - '0';
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f be c0             	movsbl %al,%eax
  800fbf:	83 e8 30             	sub    $0x30,%eax
  800fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc5:	eb 42                	jmp    801009 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	3c 60                	cmp    $0x60,%al
  800fce:	7e 19                	jle    800fe9 <strtol+0xe4>
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3c 7a                	cmp    $0x7a,%al
  800fd7:	7f 10                	jg     800fe9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f be c0             	movsbl %al,%eax
  800fe1:	83 e8 57             	sub    $0x57,%eax
  800fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe7:	eb 20                	jmp    801009 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 40                	cmp    $0x40,%al
  800ff0:	7e 39                	jle    80102b <strtol+0x126>
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	3c 5a                	cmp    $0x5a,%al
  800ff9:	7f 30                	jg     80102b <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f be c0             	movsbl %al,%eax
  801003:	83 e8 37             	sub    $0x37,%eax
  801006:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100f:	7d 19                	jge    80102a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801017:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101b:	89 c2                	mov    %eax,%edx
  80101d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801020:	01 d0                	add    %edx,%eax
  801022:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801025:	e9 7b ff ff ff       	jmp    800fa5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102f:	74 08                	je     801039 <strtol+0x134>
		*endptr = (char *) s;
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801039:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103d:	74 07                	je     801046 <strtol+0x141>
  80103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801042:	f7 d8                	neg    %eax
  801044:	eb 03                	jmp    801049 <strtol+0x144>
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <ltostr>:

void
ltostr(long value, char *str)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801058:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801063:	79 13                	jns    801078 <ltostr+0x2d>
	{
		neg = 1;
  801065:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801072:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801075:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801080:	99                   	cltd   
  801081:	f7 f9                	idiv   %ecx
  801083:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8d 50 01             	lea    0x1(%eax),%edx
  80108c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108f:	89 c2                	mov    %eax,%edx
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	01 d0                	add    %edx,%eax
  801096:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801099:	83 c2 30             	add    $0x30,%edx
  80109c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a6:	f7 e9                	imul   %ecx
  8010a8:	c1 fa 02             	sar    $0x2,%edx
  8010ab:	89 c8                	mov    %ecx,%eax
  8010ad:	c1 f8 1f             	sar    $0x1f,%eax
  8010b0:	29 c2                	sub    %eax,%edx
  8010b2:	89 d0                	mov    %edx,%eax
  8010b4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ba:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010bf:	f7 e9                	imul   %ecx
  8010c1:	c1 fa 02             	sar    $0x2,%edx
  8010c4:	89 c8                	mov    %ecx,%eax
  8010c6:	c1 f8 1f             	sar    $0x1f,%eax
  8010c9:	29 c2                	sub    %eax,%edx
  8010cb:	89 d0                	mov    %edx,%eax
  8010cd:	c1 e0 02             	shl    $0x2,%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	01 c0                	add    %eax,%eax
  8010d4:	29 c1                	sub    %eax,%ecx
  8010d6:	89 ca                	mov    %ecx,%edx
  8010d8:	85 d2                	test   %edx,%edx
  8010da:	75 9c                	jne    801078 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e6:	48                   	dec    %eax
  8010e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ee:	74 3d                	je     80112d <ltostr+0xe2>
		start = 1 ;
  8010f0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f7:	eb 34                	jmp    80112d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c8                	add    %ecx,%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 c2                	add    %eax,%edx
  801122:	8a 45 eb             	mov    -0x15(%ebp),%al
  801125:	88 02                	mov    %al,(%edx)
		start++ ;
  801127:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801133:	7c c4                	jl     8010f9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801135:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801140:	90                   	nop
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 54 fa ff ff       	call   800ba5 <strlen>
  801151:	83 c4 04             	add    $0x4,%esp
  801154:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	e8 46 fa ff ff       	call   800ba5 <strlen>
  80115f:	83 c4 04             	add    $0x4,%esp
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801173:	eb 17                	jmp    80118c <strcconcat+0x49>
		final[s] = str1[s] ;
  801175:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 c2                	add    %eax,%edx
  80117d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	01 c8                	add    %ecx,%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801189:	ff 45 fc             	incl   -0x4(%ebp)
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801192:	7c e1                	jl     801175 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801194:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a2:	eb 1f                	jmp    8011c3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a7:	8d 50 01             	lea    0x1(%eax),%edx
  8011aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c0:	ff 45 f8             	incl   -0x8(%ebp)
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c9:	7c d9                	jl     8011a4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d6:	90                   	nop
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e8:	8b 00                	mov    (%eax),%eax
  8011ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fc:	eb 0c                	jmp    80120a <strsplit+0x31>
			*string++ = 0;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8d 50 01             	lea    0x1(%eax),%edx
  801204:	89 55 08             	mov    %edx,0x8(%ebp)
  801207:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	84 c0                	test   %al,%al
  801211:	74 18                	je     80122b <strsplit+0x52>
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f be c0             	movsbl %al,%eax
  80121b:	50                   	push   %eax
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	e8 13 fb ff ff       	call   800d37 <strchr>
  801224:	83 c4 08             	add    $0x8,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	75 d3                	jne    8011fe <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 5a                	je     80128e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801234:	8b 45 14             	mov    0x14(%ebp),%eax
  801237:	8b 00                	mov    (%eax),%eax
  801239:	83 f8 0f             	cmp    $0xf,%eax
  80123c:	75 07                	jne    801245 <strsplit+0x6c>
		{
			return 0;
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
  801243:	eb 66                	jmp    8012ab <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801245:	8b 45 14             	mov    0x14(%ebp),%eax
  801248:	8b 00                	mov    (%eax),%eax
  80124a:	8d 48 01             	lea    0x1(%eax),%ecx
  80124d:	8b 55 14             	mov    0x14(%ebp),%edx
  801250:	89 0a                	mov    %ecx,(%edx)
  801252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 c2                	add    %eax,%edx
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801263:	eb 03                	jmp    801268 <strsplit+0x8f>
			string++;
  801265:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	84 c0                	test   %al,%al
  80126f:	74 8b                	je     8011fc <strsplit+0x23>
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	0f be c0             	movsbl %al,%eax
  801279:	50                   	push   %eax
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	e8 b5 fa ff ff       	call   800d37 <strchr>
  801282:	83 c4 08             	add    $0x8,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	74 dc                	je     801265 <strsplit+0x8c>
			string++;
	}
  801289:	e9 6e ff ff ff       	jmp    8011fc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80128f:	8b 45 14             	mov    0x14(%ebp),%eax
  801292:	8b 00                	mov    (%eax),%eax
  801294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	01 d0                	add    %edx,%eax
  8012a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8012b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ba:	eb 4c                	jmp    801308 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 40                	cmp    $0x40,%al
  8012c8:	7e 27                	jle    8012f1 <str2lower+0x44>
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	3c 5a                	cmp    $0x5a,%al
  8012d6:	7f 19                	jg     8012f1 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8012d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	01 d0                	add    %edx,%eax
  8012e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e6:	01 ca                	add    %ecx,%edx
  8012e8:	8a 12                	mov    (%edx),%dl
  8012ea:	83 c2 20             	add    $0x20,%edx
  8012ed:	88 10                	mov    %dl,(%eax)
  8012ef:	eb 14                	jmp    801305 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8012f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	01 c2                	add    %eax,%edx
  8012f9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	01 c8                	add    %ecx,%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801305:	ff 45 fc             	incl   -0x4(%ebp)
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	e8 95 f8 ff ff       	call   800ba5 <strlen>
  801310:	83 c4 04             	add    $0x4,%esp
  801313:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801316:	7f a4                	jg     8012bc <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	57                   	push   %edi
  80132c:	56                   	push   %esi
  80132d:	53                   	push   %ebx
  80132e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8b 55 0c             	mov    0xc(%ebp),%edx
  801337:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80133a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80133d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801340:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801343:	cd 30                	int    $0x30
  801345:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801348:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    

00801353 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	8b 45 10             	mov    0x10(%ebp),%eax
  80135c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80135f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	52                   	push   %edx
  80136b:	ff 75 0c             	pushl  0xc(%ebp)
  80136e:	50                   	push   %eax
  80136f:	6a 00                	push   $0x0
  801371:	e8 b2 ff ff ff       	call   801328 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	90                   	nop
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sys_cgetc>:

int
sys_cgetc(void)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 01                	push   $0x1
  80138b:	e8 98 ff ff ff       	call   801328 <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	50                   	push   %eax
  8013a6:	6a 05                	push   $0x5
  8013a8:	e8 7b ff ff ff       	call   801328 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	56                   	push   %esi
  8013b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8013ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	51                   	push   %ecx
  8013c9:	52                   	push   %edx
  8013ca:	50                   	push   %eax
  8013cb:	6a 06                	push   $0x6
  8013cd:	e8 56 ff ff ff       	call   801328 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	52                   	push   %edx
  8013ec:	50                   	push   %eax
  8013ed:	6a 07                	push   $0x7
  8013ef:	e8 34 ff ff ff       	call   801328 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	6a 08                	push   $0x8
  80140a:	e8 19 ff ff ff       	call   801328 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 09                	push   $0x9
  801423:	e8 00 ff ff ff       	call   801328 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 0a                	push   $0xa
  80143c:	e8 e7 fe ff ff       	call   801328 <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 0b                	push   $0xb
  801455:	e8 ce fe ff ff       	call   801328 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 0c                	push   $0xc
  80146e:	e8 b5 fe ff ff       	call   801328 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	6a 0d                	push   $0xd
  801488:	e8 9b fe ff ff       	call   801328 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 0e                	push   $0xe
  8014a1:	e8 82 fe ff ff       	call   801328 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 11                	push   $0x11
  8014bb:	e8 68 fe ff ff       	call   801328 <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	90                   	nop
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 12                	push   $0x12
  8014d5:	e8 4e fe ff ff       	call   801328 <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	90                   	nop
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	50                   	push   %eax
  8014f9:	6a 13                	push   $0x13
  8014fb:	e8 28 fe ff ff       	call   801328 <syscall>
  801500:	83 c4 18             	add    $0x18,%esp
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 14                	push   $0x14
  801515:	e8 0e fe ff ff       	call   801328 <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	90                   	nop
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	50                   	push   %eax
  801530:	6a 15                	push   $0x15
  801532:	e8 f1 fd ff ff       	call   801328 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80153f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	52                   	push   %edx
  80154c:	50                   	push   %eax
  80154d:	6a 18                	push   $0x18
  80154f:	e8 d4 fd ff ff       	call   801328 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	50                   	push   %eax
  80156a:	6a 16                	push   $0x16
  80156c:	e8 b7 fd ff ff       	call   801328 <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	90                   	nop
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80157a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	52                   	push   %edx
  801587:	50                   	push   %eax
  801588:	6a 17                	push   $0x17
  80158a:	e8 99 fd ff ff       	call   801328 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	90                   	nop
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
  80159e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015a1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	6a 00                	push   $0x0
  8015ad:	51                   	push   %ecx
  8015ae:	52                   	push   %edx
  8015af:	ff 75 0c             	pushl  0xc(%ebp)
  8015b2:	50                   	push   %eax
  8015b3:	6a 19                	push   $0x19
  8015b5:	e8 6e fd ff ff       	call   801328 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	6a 1a                	push   $0x1a
  8015d2:	e8 51 fd ff ff       	call   801328 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	51                   	push   %ecx
  8015ed:	52                   	push   %edx
  8015ee:	50                   	push   %eax
  8015ef:	6a 1b                	push   $0x1b
  8015f1:	e8 32 fd ff ff       	call   801328 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	52                   	push   %edx
  80160b:	50                   	push   %eax
  80160c:	6a 1c                	push   $0x1c
  80160e:	e8 15 fd ff ff       	call   801328 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 1d                	push   $0x1d
  801627:	e8 fc fc ff ff       	call   801328 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	ff 75 14             	pushl  0x14(%ebp)
  80163c:	ff 75 10             	pushl  0x10(%ebp)
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	50                   	push   %eax
  801643:	6a 1e                	push   $0x1e
  801645:	e8 de fc ff ff       	call   801328 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	50                   	push   %eax
  80165e:	6a 1f                	push   $0x1f
  801660:	e8 c3 fc ff ff       	call   801328 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	90                   	nop
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	50                   	push   %eax
  80167a:	6a 20                	push   $0x20
  80167c:	e8 a7 fc ff ff       	call   801328 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 02                	push   $0x2
  801695:	e8 8e fc ff ff       	call   801328 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 03                	push   $0x3
  8016ae:	e8 75 fc ff ff       	call   801328 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 04                	push   $0x4
  8016c7:	e8 5c fc ff ff       	call   801328 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_exit_env>:


void sys_exit_env(void)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 21                	push   $0x21
  8016e0:	e8 43 fc ff ff       	call   801328 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f4:	8d 50 04             	lea    0x4(%eax),%edx
  8016f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	52                   	push   %edx
  801701:	50                   	push   %eax
  801702:	6a 22                	push   $0x22
  801704:	e8 1f fc ff ff       	call   801328 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
	return result;
  80170c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801712:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801715:	89 01                	mov    %eax,(%ecx)
  801717:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	c9                   	leave  
  80171e:	c2 04 00             	ret    $0x4

00801721 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	ff 75 10             	pushl  0x10(%ebp)
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	6a 10                	push   $0x10
  801733:	e8 f0 fb ff ff       	call   801328 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
	return ;
  80173b:	90                   	nop
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_rcr2>:
uint32 sys_rcr2()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 23                	push   $0x23
  80174d:	e8 d6 fb ff ff       	call   801328 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801763:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	50                   	push   %eax
  801770:	6a 24                	push   $0x24
  801772:	e8 b1 fb ff ff       	call   801328 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
	return ;
  80177a:	90                   	nop
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <rsttst>:
void rsttst()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 26                	push   $0x26
  80178c:	e8 97 fb ff ff       	call   801328 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a3:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017aa:	52                   	push   %edx
  8017ab:	50                   	push   %eax
  8017ac:	ff 75 10             	pushl  0x10(%ebp)
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	ff 75 08             	pushl  0x8(%ebp)
  8017b5:	6a 25                	push   $0x25
  8017b7:	e8 6c fb ff ff       	call   801328 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bf:	90                   	nop
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <chktst>:
void chktst(uint32 n)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	6a 27                	push   $0x27
  8017d2:	e8 51 fb ff ff       	call   801328 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017da:	90                   	nop
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <inctst>:

void inctst()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 28                	push   $0x28
  8017ec:	e8 37 fb ff ff       	call   801328 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f4:	90                   	nop
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <gettst>:
uint32 gettst()
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 29                	push   $0x29
  801806:	e8 1d fb ff ff       	call   801328 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 2a                	push   $0x2a
  801822:	e8 01 fb ff ff       	call   801328 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
  80182a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80182d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801831:	75 07                	jne    80183a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801833:	b8 01 00 00 00       	mov    $0x1,%eax
  801838:	eb 05                	jmp    80183f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 2a                	push   $0x2a
  801853:	e8 d0 fa ff ff       	call   801328 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
  80185b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80185e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801862:	75 07                	jne    80186b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801864:	b8 01 00 00 00       	mov    $0x1,%eax
  801869:	eb 05                	jmp    801870 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 2a                	push   $0x2a
  801884:	e8 9f fa ff ff       	call   801328 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
  80188c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80188f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801893:	75 07                	jne    80189c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	eb 05                	jmp    8018a1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 2a                	push   $0x2a
  8018b5:	e8 6e fa ff ff       	call   801328 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
  8018bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8018c0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8018c4:	75 07                	jne    8018cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8018c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cb:	eb 05                	jmp    8018d2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	6a 2b                	push   $0x2b
  8018e4:	e8 3f fa ff ff       	call   801328 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ec:	90                   	nop
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	53                   	push   %ebx
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 2c                	push   $0x2c
  801907:	e8 1c fa ff ff       	call   801328 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 2d                	push   $0x2d
  801927:	e8 fc f9 ff ff       	call   801328 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801934:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	51                   	push   %ecx
  801940:	ff 75 10             	pushl  0x10(%ebp)
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 2e                	push   $0x2e
  801947:	e8 dc f9 ff ff       	call   801328 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	ff 75 10             	pushl  0x10(%ebp)
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	6a 0f                	push   $0xf
  801963:	e8 c0 f9 ff ff       	call   801328 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
	return ;
  80196b:	90                   	nop
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	50                   	push   %eax
  80197d:	6a 2f                	push   $0x2f
  80197f:	e8 a4 f9 ff ff       	call   801328 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp

}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 30                	push   $0x30
  80199a:	e8 89 f9 ff ff       	call   801328 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp

}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 31                	push   $0x31
  8019b6:	e8 6d f9 ff ff       	call   801328 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp

}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 32                	push   $0x32
  8019d0:	e8 53 f9 ff ff       	call   801328 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    
  8019da:	66 90                	xchg   %ax,%ax

008019dc <__udivdi3>:
  8019dc:	55                   	push   %ebp
  8019dd:	57                   	push   %edi
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f3:	89 ca                	mov    %ecx,%edx
  8019f5:	89 f8                	mov    %edi,%eax
  8019f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019fb:	85 f6                	test   %esi,%esi
  8019fd:	75 2d                	jne    801a2c <__udivdi3+0x50>
  8019ff:	39 cf                	cmp    %ecx,%edi
  801a01:	77 65                	ja     801a68 <__udivdi3+0x8c>
  801a03:	89 fd                	mov    %edi,%ebp
  801a05:	85 ff                	test   %edi,%edi
  801a07:	75 0b                	jne    801a14 <__udivdi3+0x38>
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	31 d2                	xor    %edx,%edx
  801a10:	f7 f7                	div    %edi
  801a12:	89 c5                	mov    %eax,%ebp
  801a14:	31 d2                	xor    %edx,%edx
  801a16:	89 c8                	mov    %ecx,%eax
  801a18:	f7 f5                	div    %ebp
  801a1a:	89 c1                	mov    %eax,%ecx
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	f7 f5                	div    %ebp
  801a20:	89 cf                	mov    %ecx,%edi
  801a22:	89 fa                	mov    %edi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	39 ce                	cmp    %ecx,%esi
  801a2e:	77 28                	ja     801a58 <__udivdi3+0x7c>
  801a30:	0f bd fe             	bsr    %esi,%edi
  801a33:	83 f7 1f             	xor    $0x1f,%edi
  801a36:	75 40                	jne    801a78 <__udivdi3+0x9c>
  801a38:	39 ce                	cmp    %ecx,%esi
  801a3a:	72 0a                	jb     801a46 <__udivdi3+0x6a>
  801a3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a40:	0f 87 9e 00 00 00    	ja     801ae4 <__udivdi3+0x108>
  801a46:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4b:	89 fa                	mov    %edi,%edx
  801a4d:	83 c4 1c             	add    $0x1c,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    
  801a55:	8d 76 00             	lea    0x0(%esi),%esi
  801a58:	31 ff                	xor    %edi,%edi
  801a5a:	31 c0                	xor    %eax,%eax
  801a5c:	89 fa                	mov    %edi,%edx
  801a5e:	83 c4 1c             	add    $0x1c,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	f7 f7                	div    %edi
  801a6c:	31 ff                	xor    %edi,%edi
  801a6e:	89 fa                	mov    %edi,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a7d:	89 eb                	mov    %ebp,%ebx
  801a7f:	29 fb                	sub    %edi,%ebx
  801a81:	89 f9                	mov    %edi,%ecx
  801a83:	d3 e6                	shl    %cl,%esi
  801a85:	89 c5                	mov    %eax,%ebp
  801a87:	88 d9                	mov    %bl,%cl
  801a89:	d3 ed                	shr    %cl,%ebp
  801a8b:	89 e9                	mov    %ebp,%ecx
  801a8d:	09 f1                	or     %esi,%ecx
  801a8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a93:	89 f9                	mov    %edi,%ecx
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	88 d9                	mov    %bl,%cl
  801a9d:	d3 ee                	shr    %cl,%esi
  801a9f:	89 f9                	mov    %edi,%ecx
  801aa1:	d3 e2                	shl    %cl,%edx
  801aa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 e8                	shr    %cl,%eax
  801aab:	09 c2                	or     %eax,%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	89 f2                	mov    %esi,%edx
  801ab1:	f7 74 24 0c          	divl   0xc(%esp)
  801ab5:	89 d6                	mov    %edx,%esi
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	f7 e5                	mul    %ebp
  801abb:	39 d6                	cmp    %edx,%esi
  801abd:	72 19                	jb     801ad8 <__udivdi3+0xfc>
  801abf:	74 0b                	je     801acc <__udivdi3+0xf0>
  801ac1:	89 d8                	mov    %ebx,%eax
  801ac3:	31 ff                	xor    %edi,%edi
  801ac5:	e9 58 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad0:	89 f9                	mov    %edi,%ecx
  801ad2:	d3 e2                	shl    %cl,%edx
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	73 e9                	jae    801ac1 <__udivdi3+0xe5>
  801ad8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801adb:	31 ff                	xor    %edi,%edi
  801add:	e9 40 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	31 c0                	xor    %eax,%eax
  801ae6:	e9 37 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aeb:	90                   	nop

00801aec <__umoddi3>:
  801aec:	55                   	push   %ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 1c             	sub    $0x1c,%esp
  801af3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801af7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b0b:	89 f3                	mov    %esi,%ebx
  801b0d:	89 fa                	mov    %edi,%edx
  801b0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b13:	89 34 24             	mov    %esi,(%esp)
  801b16:	85 c0                	test   %eax,%eax
  801b18:	75 1a                	jne    801b34 <__umoddi3+0x48>
  801b1a:	39 f7                	cmp    %esi,%edi
  801b1c:	0f 86 a2 00 00 00    	jbe    801bc4 <__umoddi3+0xd8>
  801b22:	89 c8                	mov    %ecx,%eax
  801b24:	89 f2                	mov    %esi,%edx
  801b26:	f7 f7                	div    %edi
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	39 f0                	cmp    %esi,%eax
  801b36:	0f 87 ac 00 00 00    	ja     801be8 <__umoddi3+0xfc>
  801b3c:	0f bd e8             	bsr    %eax,%ebp
  801b3f:	83 f5 1f             	xor    $0x1f,%ebp
  801b42:	0f 84 ac 00 00 00    	je     801bf4 <__umoddi3+0x108>
  801b48:	bf 20 00 00 00       	mov    $0x20,%edi
  801b4d:	29 ef                	sub    %ebp,%edi
  801b4f:	89 fe                	mov    %edi,%esi
  801b51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b55:	89 e9                	mov    %ebp,%ecx
  801b57:	d3 e0                	shl    %cl,%eax
  801b59:	89 d7                	mov    %edx,%edi
  801b5b:	89 f1                	mov    %esi,%ecx
  801b5d:	d3 ef                	shr    %cl,%edi
  801b5f:	09 c7                	or     %eax,%edi
  801b61:	89 e9                	mov    %ebp,%ecx
  801b63:	d3 e2                	shl    %cl,%edx
  801b65:	89 14 24             	mov    %edx,(%esp)
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	d3 e0                	shl    %cl,%eax
  801b6c:	89 c2                	mov    %eax,%edx
  801b6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b72:	d3 e0                	shl    %cl,%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7c:	89 f1                	mov    %esi,%ecx
  801b7e:	d3 e8                	shr    %cl,%eax
  801b80:	09 d0                	or     %edx,%eax
  801b82:	d3 eb                	shr    %cl,%ebx
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	f7 f7                	div    %edi
  801b88:	89 d3                	mov    %edx,%ebx
  801b8a:	f7 24 24             	mull   (%esp)
  801b8d:	89 c6                	mov    %eax,%esi
  801b8f:	89 d1                	mov    %edx,%ecx
  801b91:	39 d3                	cmp    %edx,%ebx
  801b93:	0f 82 87 00 00 00    	jb     801c20 <__umoddi3+0x134>
  801b99:	0f 84 91 00 00 00    	je     801c30 <__umoddi3+0x144>
  801b9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ba3:	29 f2                	sub    %esi,%edx
  801ba5:	19 cb                	sbb    %ecx,%ebx
  801ba7:	89 d8                	mov    %ebx,%eax
  801ba9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bad:	d3 e0                	shl    %cl,%eax
  801baf:	89 e9                	mov    %ebp,%ecx
  801bb1:	d3 ea                	shr    %cl,%edx
  801bb3:	09 d0                	or     %edx,%eax
  801bb5:	89 e9                	mov    %ebp,%ecx
  801bb7:	d3 eb                	shr    %cl,%ebx
  801bb9:	89 da                	mov    %ebx,%edx
  801bbb:	83 c4 1c             	add    $0x1c,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    
  801bc3:	90                   	nop
  801bc4:	89 fd                	mov    %edi,%ebp
  801bc6:	85 ff                	test   %edi,%edi
  801bc8:	75 0b                	jne    801bd5 <__umoddi3+0xe9>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	31 d2                	xor    %edx,%edx
  801bd1:	f7 f7                	div    %edi
  801bd3:	89 c5                	mov    %eax,%ebp
  801bd5:	89 f0                	mov    %esi,%eax
  801bd7:	31 d2                	xor    %edx,%edx
  801bd9:	f7 f5                	div    %ebp
  801bdb:	89 c8                	mov    %ecx,%eax
  801bdd:	f7 f5                	div    %ebp
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	e9 44 ff ff ff       	jmp    801b2a <__umoddi3+0x3e>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	89 c8                	mov    %ecx,%eax
  801bea:	89 f2                	mov    %esi,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	3b 04 24             	cmp    (%esp),%eax
  801bf7:	72 06                	jb     801bff <__umoddi3+0x113>
  801bf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bfd:	77 0f                	ja     801c0e <__umoddi3+0x122>
  801bff:	89 f2                	mov    %esi,%edx
  801c01:	29 f9                	sub    %edi,%ecx
  801c03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c07:	89 14 24             	mov    %edx,(%esp)
  801c0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c12:	8b 14 24             	mov    (%esp),%edx
  801c15:	83 c4 1c             	add    $0x1c,%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	2b 04 24             	sub    (%esp),%eax
  801c23:	19 fa                	sbb    %edi,%edx
  801c25:	89 d1                	mov    %edx,%ecx
  801c27:	89 c6                	mov    %eax,%esi
  801c29:	e9 71 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c34:	72 ea                	jb     801c20 <__umoddi3+0x134>
  801c36:	89 d9                	mov    %ebx,%ecx
  801c38:	e9 62 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>
