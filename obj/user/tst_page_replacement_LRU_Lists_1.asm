
obj/user/tst_page_replacement_LRU_Lists_1:     file format elf32-i386


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
  800031:	e8 ec 01 00 00       	call   800222 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp

	//	cprintf("envID = %d\n",envID);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		uint32 actual_active_list[5] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x203000};
  800041:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800044:	bb 98 1f 80 00       	mov    $0x801f98,%ebx
  800049:	ba 05 00 00 00       	mov    $0x5,%edx
  80004e:	89 c7                	mov    %eax,%edi
  800050:	89 de                	mov    %ebx,%esi
  800052:	89 d1                	mov    %edx,%ecx
  800054:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
  800056:	8d 45 a0             	lea    -0x60(%ebp),%eax
  800059:	bb ac 1f 80 00       	mov    $0x801fac,%ebx
  80005e:	ba 05 00 00 00       	mov    $0x5,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 5, 5);
  80006b:	6a 05                	push   $0x5
  80006d:	6a 05                	push   $0x5
  80006f:	8d 45 a0             	lea    -0x60(%ebp),%eax
  800072:	50                   	push   %eax
  800073:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  800076:	50                   	push   %eax
  800077:	e8 66 19 00 00       	call   8019e2 <sys_check_LRU_lists>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  800082:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800086:	75 14                	jne    80009c <_main+0x64>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800088:	83 ec 04             	sub    $0x4,%esp
  80008b:	68 40 1d 80 00       	push   $0x801d40
  800090:	6a 18                	push   $0x18
  800092:	68 c4 1d 80 00       	push   $0x801dc4
  800097:	e8 bd 02 00 00       	call   800359 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80009c:	e8 66 14 00 00       	call   801507 <sys_calculate_free_frames>
  8000a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a4:	e8 a9 14 00 00       	call   801552 <sys_pf_calculate_allocated_pages>
  8000a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000ac:	a0 3f e0 80 00       	mov    0x80e03f,%al
  8000b1:	88 45 d3             	mov    %al,-0x2d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000b4:	a0 3f f0 80 00       	mov    0x80f03f,%al
  8000b9:	88 45 d2             	mov    %al,-0x2e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000c3:	eb 4a                	jmp    80010f <_main+0xd7>
	{
		arr[i] = 'A' ;
  8000c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c8:	05 40 30 80 00       	add    $0x803040,%eax
  8000cd:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr + garbage5;
  8000d0:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d5:	8a 00                	mov    (%eax),%al
  8000d7:	88 c2                	mov    %al,%dl
  8000d9:	8a 45 e7             	mov    -0x19(%ebp),%al
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	88 45 d1             	mov    %al,-0x2f(%ebp)
		garbage5 = *ptr2 + garbage4;
  8000e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e6:	8a 00                	mov    (%eax),%al
  8000e8:	88 c2                	mov    %al,%dl
  8000ea:	8a 45 d1             	mov    -0x2f(%ebp),%al
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	88 45 e7             	mov    %al,-0x19(%ebp)
		ptr++ ; ptr2++ ;
  8000f2:	a1 00 30 80 00       	mov    0x803000,%eax
  8000f7:	40                   	inc    %eax
  8000f8:	a3 00 30 80 00       	mov    %eax,0x803000
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	40                   	inc    %eax
  800103:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800108:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  80010f:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800116:	7e ad                	jle    8000c5 <_main+0x8d>
		ptr++ ; ptr2++ ;
	}

	//===================

	cprintf("Checking Allocation in Mem & Page File... \n");
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 ec 1d 80 00       	push   $0x801dec
  800120:	e8 f1 04 00 00       	call   800616 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800128:	e8 25 14 00 00       	call   801552 <sys_pf_calculate_allocated_pages>
  80012d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800130:	74 14                	je     800146 <_main+0x10e>
  800132:	83 ec 04             	sub    $0x4,%esp
  800135:	68 18 1e 80 00       	push   $0x801e18
  80013a:	6a 35                	push   $0x35
  80013c:	68 c4 1d 80 00       	push   $0x801dc4
  800141:	e8 13 02 00 00       	call   800359 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800146:	e8 bc 13 00 00       	call   801507 <sys_calculate_free_frames>
  80014b:	89 c3                	mov    %eax,%ebx
  80014d:	e8 ce 13 00 00       	call   801520 <sys_calculate_modified_frames>
  800152:	01 d8                	add    %ebx,%eax
  800154:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800157:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80015a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80015d:	74 14                	je     800173 <_main+0x13b>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	68 84 1e 80 00       	push   $0x801e84
  800167:	6a 39                	push   $0x39
  800169:	68 c4 1d 80 00       	push   $0x801dc4
  80016e:	e8 e6 01 00 00       	call   800359 <_panic>
	}

	cprintf("\nChecking CONTENT in Mem ... \n");
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 e8 1e 80 00       	push   $0x801ee8
  80017b:	e8 96 04 00 00       	call   800616 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800183:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80018a:	eb 29                	jmp    8001b5 <_main+0x17d>
			if( arr[i] != 'A') panic("Modified page(s) not restored correctly");
  80018c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80018f:	05 40 30 80 00       	add    $0x803040,%eax
  800194:	8a 00                	mov    (%eax),%al
  800196:	3c 41                	cmp    $0x41,%al
  800198:	74 14                	je     8001ae <_main+0x176>
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	68 08 1f 80 00       	push   $0x801f08
  8001a2:	6a 3f                	push   $0x3f
  8001a4:	68 c4 1d 80 00       	push   $0x801dc4
  8001a9:	e8 ab 01 00 00       	call   800359 <_panic>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
	}

	cprintf("\nChecking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8001ae:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  8001b5:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  8001bc:	7e ce                	jle    80018c <_main+0x154>
			if( arr[i] != 'A') panic("Modified page(s) not restored correctly");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8001be:	e8 8f 13 00 00       	call   801552 <sys_pf_calculate_allocated_pages>
  8001c3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c6:	74 14                	je     8001dc <_main+0x1a4>
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	68 18 1e 80 00       	push   $0x801e18
  8001d0:	6a 40                	push   $0x40
  8001d2:	68 c4 1d 80 00       	push   $0x801dc4
  8001d7:	e8 7d 01 00 00       	call   800359 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8001dc:	e8 26 13 00 00       	call   801507 <sys_calculate_free_frames>
  8001e1:	89 c3                	mov    %eax,%ebx
  8001e3:	e8 38 13 00 00       	call   801520 <sys_calculate_modified_frames>
  8001e8:	01 d8                	add    %ebx,%eax
  8001ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  8001ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001f0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001f3:	74 14                	je     800209 <_main+0x1d1>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	68 84 1e 80 00       	push   $0x801e84
  8001fd:	6a 44                	push   $0x44
  8001ff:	68 c4 1d 80 00       	push   $0x801dc4
  800204:	e8 50 01 00 00       	call   800359 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] using APRROXIMATED LRU is completed successfully.\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 30 1f 80 00       	push   $0x801f30
  800211:	e8 00 04 00 00       	call   800616 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	return;
  800219:	90                   	nop
}
  80021a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5f                   	pop    %edi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    

00800222 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800228:	e8 65 15 00 00       	call   801792 <sys_getenvindex>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800233:	89 d0                	mov    %edx,%eax
  800235:	c1 e0 03             	shl    $0x3,%eax
  800238:	01 d0                	add    %edx,%eax
  80023a:	01 c0                	add    %eax,%eax
  80023c:	01 d0                	add    %edx,%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	01 d0                	add    %edx,%eax
  800247:	c1 e0 04             	shl    $0x4,%eax
  80024a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80024f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800254:	a1 20 30 80 00       	mov    0x803020,%eax
  800259:	8a 40 5c             	mov    0x5c(%eax),%al
  80025c:	84 c0                	test   %al,%al
  80025e:	74 0d                	je     80026d <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	83 c0 5c             	add    $0x5c,%eax
  800268:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80026d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800271:	7e 0a                	jle    80027d <libmain+0x5b>
		binaryname = argv[0];
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
  800276:	8b 00                	mov    (%eax),%eax
  800278:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	ff 75 0c             	pushl  0xc(%ebp)
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	e8 ad fd ff ff       	call   800038 <_main>
  80028b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80028e:	e8 0c 13 00 00       	call   80159f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	68 d8 1f 80 00       	push   $0x801fd8
  80029b:	e8 76 03 00 00       	call   800616 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a8:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8002ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b3:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	52                   	push   %edx
  8002bd:	50                   	push   %eax
  8002be:	68 00 20 80 00       	push   $0x802000
  8002c3:	e8 4e 03 00 00       	call   800616 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d0:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8002d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002db:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8002e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e6:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	50                   	push   %eax
  8002ef:	68 28 20 80 00       	push   $0x802028
  8002f4:	e8 1d 03 00 00       	call   800616 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800301:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	50                   	push   %eax
  80030b:	68 80 20 80 00       	push   $0x802080
  800310:	e8 01 03 00 00       	call   800616 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	68 d8 1f 80 00       	push   $0x801fd8
  800320:	e8 f1 02 00 00       	call   800616 <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800328:	e8 8c 12 00 00       	call   8015b9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80032d:	e8 19 00 00 00       	call   80034b <exit>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	6a 00                	push   $0x0
  800340:	e8 19 14 00 00       	call   80175e <sys_destroy_env>
  800345:	83 c4 10             	add    $0x10,%esp
}
  800348:	90                   	nop
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <exit>:

void
exit(void)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800351:	e8 6e 14 00 00       	call   8017c4 <sys_exit_env>
}
  800356:	90                   	nop
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80035f:	8d 45 10             	lea    0x10(%ebp),%eax
  800362:	83 c0 04             	add    $0x4,%eax
  800365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800368:	a1 2c f1 80 00       	mov    0x80f12c,%eax
  80036d:	85 c0                	test   %eax,%eax
  80036f:	74 16                	je     800387 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800371:	a1 2c f1 80 00       	mov    0x80f12c,%eax
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	50                   	push   %eax
  80037a:	68 94 20 80 00       	push   $0x802094
  80037f:	e8 92 02 00 00       	call   800616 <cprintf>
  800384:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800387:	a1 08 30 80 00       	mov    0x803008,%eax
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 08             	pushl  0x8(%ebp)
  800392:	50                   	push   %eax
  800393:	68 99 20 80 00       	push   $0x802099
  800398:	e8 79 02 00 00       	call   800616 <cprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a9:	50                   	push   %eax
  8003aa:	e8 fc 01 00 00       	call   8005ab <vcprintf>
  8003af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	6a 00                	push   $0x0
  8003b7:	68 b5 20 80 00       	push   $0x8020b5
  8003bc:	e8 ea 01 00 00       	call   8005ab <vcprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003c4:	e8 82 ff ff ff       	call   80034b <exit>

	// should not return here
	while (1) ;
  8003c9:	eb fe                	jmp    8003c9 <_panic+0x70>

008003cb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d6:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	74 14                	je     8003f7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 b8 20 80 00       	push   $0x8020b8
  8003eb:	6a 26                	push   $0x26
  8003ed:	68 04 21 80 00       	push   $0x802104
  8003f2:	e8 62 ff ff ff       	call   800359 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800405:	e9 c5 00 00 00       	jmp    8004cf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80040a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	85 c0                	test   %eax,%eax
  80041d:	75 08                	jne    800427 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80041f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800422:	e9 a5 00 00 00       	jmp    8004cc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800427:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800435:	eb 69                	jmp    8004a0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800437:	a1 20 30 80 00       	mov    0x803020,%eax
  80043c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800442:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800445:	89 d0                	mov    %edx,%eax
  800447:	01 c0                	add    %eax,%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	c1 e0 03             	shl    $0x3,%eax
  80044e:	01 c8                	add    %ecx,%eax
  800450:	8a 40 04             	mov    0x4(%eax),%al
  800453:	84 c0                	test   %al,%al
  800455:	75 46                	jne    80049d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800457:	a1 20 30 80 00       	mov    0x803020,%eax
  80045c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800462:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800465:	89 d0                	mov    %edx,%eax
  800467:	01 c0                	add    %eax,%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	c1 e0 03             	shl    $0x3,%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800475:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80047d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800482:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800490:	39 c2                	cmp    %eax,%edx
  800492:	75 09                	jne    80049d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800494:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80049b:	eb 15                	jmp    8004b2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049d:	ff 45 e8             	incl   -0x18(%ebp)
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8004ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	77 85                	ja     800437 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004b6:	75 14                	jne    8004cc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	68 10 21 80 00       	push   $0x802110
  8004c0:	6a 3a                	push   $0x3a
  8004c2:	68 04 21 80 00       	push   $0x802104
  8004c7:	e8 8d fe ff ff       	call   800359 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004cc:	ff 45 f0             	incl   -0x10(%ebp)
  8004cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004d5:	0f 8c 2f ff ff ff    	jl     80040a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e9:	eb 26                	jmp    800511 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	c1 e0 03             	shl    $0x3,%eax
  800502:	01 c8                	add    %ecx,%eax
  800504:	8a 40 04             	mov    0x4(%eax),%al
  800507:	3c 01                	cmp    $0x1,%al
  800509:	75 03                	jne    80050e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80050b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050e:	ff 45 e0             	incl   -0x20(%ebp)
  800511:	a1 20 30 80 00       	mov    0x803020,%eax
  800516:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80051c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051f:	39 c2                	cmp    %eax,%edx
  800521:	77 c8                	ja     8004eb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800526:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800529:	74 14                	je     80053f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	68 64 21 80 00       	push   $0x802164
  800533:	6a 44                	push   $0x44
  800535:	68 04 21 80 00       	push   $0x802104
  80053a:	e8 1a fe ff ff       	call   800359 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80053f:	90                   	nop
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	8d 48 01             	lea    0x1(%eax),%ecx
  800550:	8b 55 0c             	mov    0xc(%ebp),%edx
  800553:	89 0a                	mov    %ecx,(%edx)
  800555:	8b 55 08             	mov    0x8(%ebp),%edx
  800558:	88 d1                	mov    %dl,%cl
  80055a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056b:	75 2c                	jne    800599 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80056d:	a0 24 30 80 00       	mov    0x803024,%al
  800572:	0f b6 c0             	movzbl %al,%eax
  800575:	8b 55 0c             	mov    0xc(%ebp),%edx
  800578:	8b 12                	mov    (%edx),%edx
  80057a:	89 d1                	mov    %edx,%ecx
  80057c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057f:	83 c2 08             	add    $0x8,%edx
  800582:	83 ec 04             	sub    $0x4,%esp
  800585:	50                   	push   %eax
  800586:	51                   	push   %ecx
  800587:	52                   	push   %edx
  800588:	e8 b9 0e 00 00       	call   801446 <sys_cputs>
  80058d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800590:	8b 45 0c             	mov    0xc(%ebp),%eax
  800593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059c:	8b 40 04             	mov    0x4(%eax),%eax
  80059f:	8d 50 01             	lea    0x1(%eax),%edx
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005a8:	90                   	nop
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005bb:	00 00 00 
	b.cnt = 0;
  8005be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d4:	50                   	push   %eax
  8005d5:	68 42 05 80 00       	push   $0x800542
  8005da:	e8 11 02 00 00       	call   8007f0 <vprintfmt>
  8005df:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005e2:	a0 24 30 80 00       	mov    0x803024,%al
  8005e7:	0f b6 c0             	movzbl %al,%eax
  8005ea:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	50                   	push   %eax
  8005f4:	52                   	push   %edx
  8005f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fb:	83 c0 08             	add    $0x8,%eax
  8005fe:	50                   	push   %eax
  8005ff:	e8 42 0e 00 00       	call   801446 <sys_cputs>
  800604:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800607:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80060e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <cprintf>:

int cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800623:	8d 45 0c             	lea    0xc(%ebp),%eax
  800626:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 f4             	pushl  -0xc(%ebp)
  800632:	50                   	push   %eax
  800633:	e8 73 ff ff ff       	call   8005ab <vcprintf>
  800638:	83 c4 10             	add    $0x10,%esp
  80063b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80063e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800641:	c9                   	leave  
  800642:	c3                   	ret    

00800643 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800649:	e8 51 0f 00 00       	call   80159f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80064e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800651:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 f4             	pushl  -0xc(%ebp)
  80065d:	50                   	push   %eax
  80065e:	e8 48 ff ff ff       	call   8005ab <vcprintf>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800669:	e8 4b 0f 00 00       	call   8015b9 <sys_enable_interrupt>
	return cnt;
  80066e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800671:	c9                   	leave  
  800672:	c3                   	ret    

00800673 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
  800676:	53                   	push   %ebx
  800677:	83 ec 14             	sub    $0x14,%esp
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800686:	8b 45 18             	mov    0x18(%ebp),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800691:	77 55                	ja     8006e8 <printnum+0x75>
  800693:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800696:	72 05                	jb     80069d <printnum+0x2a>
  800698:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80069b:	77 4b                	ja     8006e8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80069d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b3:	e8 18 14 00 00       	call   801ad0 <__udivdi3>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	ff 75 20             	pushl  0x20(%ebp)
  8006c1:	53                   	push   %ebx
  8006c2:	ff 75 18             	pushl  0x18(%ebp)
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	ff 75 08             	pushl  0x8(%ebp)
  8006cd:	e8 a1 ff ff ff       	call   800673 <printnum>
  8006d2:	83 c4 20             	add    $0x20,%esp
  8006d5:	eb 1a                	jmp    8006f1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	ff 75 20             	pushl  0x20(%ebp)
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e8:	ff 4d 1c             	decl   0x1c(%ebp)
  8006eb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ef:	7f e6                	jg     8006d7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ff:	53                   	push   %ebx
  800700:	51                   	push   %ecx
  800701:	52                   	push   %edx
  800702:	50                   	push   %eax
  800703:	e8 d8 14 00 00       	call   801be0 <__umoddi3>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	05 d4 23 80 00       	add    $0x8023d4,%eax
  800710:	8a 00                	mov    (%eax),%al
  800712:	0f be c0             	movsbl %al,%eax
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	50                   	push   %eax
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
}
  800724:	90                   	nop
  800725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80072d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800731:	7e 1c                	jle    80074f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 10                	mov    %edx,(%eax)
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 e8 08             	sub    $0x8,%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	eb 40                	jmp    80078f <getuint+0x65>
	else if (lflag)
  80074f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800753:	74 1e                	je     800773 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 04             	lea    0x4(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	ba 00 00 00 00       	mov    $0x0,%edx
  800771:	eb 1c                	jmp    80078f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 04             	lea    0x4(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 04             	sub    $0x4,%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800794:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800798:	7e 1c                	jle    8007b6 <getint+0x25>
		return va_arg(*ap, long long);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 08             	lea    0x8(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 08             	sub    $0x8,%eax
  8007af:	8b 50 04             	mov    0x4(%eax),%edx
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	eb 38                	jmp    8007ee <getint+0x5d>
	else if (lflag)
  8007b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ba:	74 1a                	je     8007d6 <getint+0x45>
		return va_arg(*ap, long);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	99                   	cltd   
  8007d4:	eb 18                	jmp    8007ee <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	8d 50 04             	lea    0x4(%eax),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 10                	mov    %edx,(%eax)
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	83 e8 04             	sub    $0x4,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	99                   	cltd   
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	56                   	push   %esi
  8007f4:	53                   	push   %ebx
  8007f5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f8:	eb 17                	jmp    800811 <vprintfmt+0x21>
			if (ch == '\0')
  8007fa:	85 db                	test   %ebx,%ebx
  8007fc:	0f 84 af 03 00 00    	je     800bb1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	53                   	push   %ebx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800811:	8b 45 10             	mov    0x10(%ebp),%eax
  800814:	8d 50 01             	lea    0x1(%eax),%edx
  800817:	89 55 10             	mov    %edx,0x10(%ebp)
  80081a:	8a 00                	mov    (%eax),%al
  80081c:	0f b6 d8             	movzbl %al,%ebx
  80081f:	83 fb 25             	cmp    $0x25,%ebx
  800822:	75 d6                	jne    8007fa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800824:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800828:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80082f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800836:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80083d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	8d 50 01             	lea    0x1(%eax),%edx
  80084a:	89 55 10             	mov    %edx,0x10(%ebp)
  80084d:	8a 00                	mov    (%eax),%al
  80084f:	0f b6 d8             	movzbl %al,%ebx
  800852:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800855:	83 f8 55             	cmp    $0x55,%eax
  800858:	0f 87 2b 03 00 00    	ja     800b89 <vprintfmt+0x399>
  80085e:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  800865:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800867:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80086b:	eb d7                	jmp    800844 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800871:	eb d1                	jmp    800844 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087d:	89 d0                	mov    %edx,%eax
  80087f:	c1 e0 02             	shl    $0x2,%eax
  800882:	01 d0                	add    %edx,%eax
  800884:	01 c0                	add    %eax,%eax
  800886:	01 d8                	add    %ebx,%eax
  800888:	83 e8 30             	sub    $0x30,%eax
  80088b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80088e:	8b 45 10             	mov    0x10(%ebp),%eax
  800891:	8a 00                	mov    (%eax),%al
  800893:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800896:	83 fb 2f             	cmp    $0x2f,%ebx
  800899:	7e 3e                	jle    8008d9 <vprintfmt+0xe9>
  80089b:	83 fb 39             	cmp    $0x39,%ebx
  80089e:	7f 39                	jg     8008d9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a3:	eb d5                	jmp    80087a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	83 e8 04             	sub    $0x4,%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b9:	eb 1f                	jmp    8008da <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bf:	79 83                	jns    800844 <vprintfmt+0x54>
				width = 0;
  8008c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c8:	e9 77 ff ff ff       	jmp    800844 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008cd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d4:	e9 6b ff ff ff       	jmp    800844 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	0f 89 60 ff ff ff    	jns    800844 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f1:	e9 4e ff ff ff       	jmp    800844 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f9:	e9 46 ff ff ff       	jmp    800844 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
			break;
  80091e:	e9 89 02 00 00       	jmp    800bac <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 c0 04             	add    $0x4,%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 e8 04             	sub    $0x4,%eax
  800932:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800934:	85 db                	test   %ebx,%ebx
  800936:	79 02                	jns    80093a <vprintfmt+0x14a>
				err = -err;
  800938:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093a:	83 fb 64             	cmp    $0x64,%ebx
  80093d:	7f 0b                	jg     80094a <vprintfmt+0x15a>
  80093f:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800946:	85 f6                	test   %esi,%esi
  800948:	75 19                	jne    800963 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094a:	53                   	push   %ebx
  80094b:	68 e5 23 80 00       	push   $0x8023e5
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	ff 75 08             	pushl  0x8(%ebp)
  800956:	e8 5e 02 00 00       	call   800bb9 <printfmt>
  80095b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80095e:	e9 49 02 00 00       	jmp    800bac <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800963:	56                   	push   %esi
  800964:	68 ee 23 80 00       	push   $0x8023ee
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	e8 45 02 00 00       	call   800bb9 <printfmt>
  800974:	83 c4 10             	add    $0x10,%esp
			break;
  800977:	e9 30 02 00 00       	jmp    800bac <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 30                	mov    (%eax),%esi
  80098d:	85 f6                	test   %esi,%esi
  80098f:	75 05                	jne    800996 <vprintfmt+0x1a6>
				p = "(null)";
  800991:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7e 6d                	jle    800a09 <vprintfmt+0x219>
  80099c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a0:	74 67                	je     800a09 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	50                   	push   %eax
  8009a9:	56                   	push   %esi
  8009aa:	e8 0c 03 00 00       	call   800cbb <strnlen>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b5:	eb 16                	jmp    8009cd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	50                   	push   %eax
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d1:	7f e4                	jg     8009b7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d3:	eb 34                	jmp    800a09 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d9:	74 1c                	je     8009f7 <vprintfmt+0x207>
  8009db:	83 fb 1f             	cmp    $0x1f,%ebx
  8009de:	7e 05                	jle    8009e5 <vprintfmt+0x1f5>
  8009e0:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e3:	7e 12                	jle    8009f7 <vprintfmt+0x207>
					putch('?', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 3f                	push   $0x3f
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	eb 0f                	jmp    800a06 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a06:	ff 4d e4             	decl   -0x1c(%ebp)
  800a09:	89 f0                	mov    %esi,%eax
  800a0b:	8d 70 01             	lea    0x1(%eax),%esi
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	0f be d8             	movsbl %al,%ebx
  800a13:	85 db                	test   %ebx,%ebx
  800a15:	74 24                	je     800a3b <vprintfmt+0x24b>
  800a17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1b:	78 b8                	js     8009d5 <vprintfmt+0x1e5>
  800a1d:	ff 4d e0             	decl   -0x20(%ebp)
  800a20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a24:	79 af                	jns    8009d5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a26:	eb 13                	jmp    800a3b <vprintfmt+0x24b>
				putch(' ', putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	6a 20                	push   $0x20
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	ff d0                	call   *%eax
  800a35:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a38:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3f:	7f e7                	jg     800a28 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a41:	e9 66 01 00 00       	jmp    800bac <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4f:	50                   	push   %eax
  800a50:	e8 3c fd ff ff       	call   800791 <getint>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a64:	85 d2                	test   %edx,%edx
  800a66:	79 23                	jns    800a8b <vprintfmt+0x29b>
				putch('-', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 2d                	push   $0x2d
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	f7 d8                	neg    %eax
  800a80:	83 d2 00             	adc    $0x0,%edx
  800a83:	f7 da                	neg    %edx
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a92:	e9 bc 00 00 00       	jmp    800b53 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa0:	50                   	push   %eax
  800aa1:	e8 84 fc ff ff       	call   80072a <getuint>
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aaf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab6:	e9 98 00 00 00       	jmp    800b53 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 58                	push   $0x58
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	6a 58                	push   $0x58
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	6a 58                	push   $0x58
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	ff d0                	call   *%eax
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 bc 00 00 00       	jmp    800bac <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	6a 30                	push   $0x30
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	ff d0                	call   *%eax
  800afd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	6a 78                	push   $0x78
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b32:	eb 1f                	jmp    800b53 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	e8 e7 fb ff ff       	call   80072a <getuint>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b53:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5a:	83 ec 04             	sub    $0x4,%esp
  800b5d:	52                   	push   %edx
  800b5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b61:	50                   	push   %eax
  800b62:	ff 75 f4             	pushl  -0xc(%ebp)
  800b65:	ff 75 f0             	pushl  -0x10(%ebp)
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 00 fb ff ff       	call   800673 <printnum>
  800b73:	83 c4 20             	add    $0x20,%esp
			break;
  800b76:	eb 34                	jmp    800bac <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	53                   	push   %ebx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	ff d0                	call   *%eax
  800b84:	83 c4 10             	add    $0x10,%esp
			break;
  800b87:	eb 23                	jmp    800bac <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	ff 75 0c             	pushl  0xc(%ebp)
  800b8f:	6a 25                	push   $0x25
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b99:	ff 4d 10             	decl   0x10(%ebp)
  800b9c:	eb 03                	jmp    800ba1 <vprintfmt+0x3b1>
  800b9e:	ff 4d 10             	decl   0x10(%ebp)
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	48                   	dec    %eax
  800ba5:	8a 00                	mov    (%eax),%al
  800ba7:	3c 25                	cmp    $0x25,%al
  800ba9:	75 f3                	jne    800b9e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bab:	90                   	nop
		}
	}
  800bac:	e9 47 fc ff ff       	jmp    8007f8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc2:	83 c0 04             	add    $0x4,%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	ff 75 08             	pushl  0x8(%ebp)
  800bd5:	e8 16 fc ff ff       	call   8007f0 <vprintfmt>
  800bda:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bdd:	90                   	nop
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	8b 40 08             	mov    0x8(%eax),%eax
  800be9:	8d 50 01             	lea    0x1(%eax),%edx
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	8b 10                	mov    (%eax),%edx
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	8b 40 04             	mov    0x4(%eax),%eax
  800bfd:	39 c2                	cmp    %eax,%edx
  800bff:	73 12                	jae    800c13 <sprintputch+0x33>
		*b->buf++ = ch;
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	8d 48 01             	lea    0x1(%eax),%ecx
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	89 0a                	mov    %ecx,(%edx)
  800c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c11:	88 10                	mov    %dl,(%eax)
}
  800c13:	90                   	nop
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	01 d0                	add    %edx,%eax
  800c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3b:	74 06                	je     800c43 <vsnprintf+0x2d>
  800c3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c41:	7f 07                	jg     800c4a <vsnprintf+0x34>
		return -E_INVAL;
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	eb 20                	jmp    800c6a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4a:	ff 75 14             	pushl  0x14(%ebp)
  800c4d:	ff 75 10             	pushl  0x10(%ebp)
  800c50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c53:	50                   	push   %eax
  800c54:	68 e0 0b 80 00       	push   $0x800be0
  800c59:	e8 92 fb ff ff       	call   8007f0 <vprintfmt>
  800c5e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c72:	8d 45 10             	lea    0x10(%ebp),%eax
  800c75:	83 c0 04             	add    $0x4,%eax
  800c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c81:	50                   	push   %eax
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	ff 75 08             	pushl  0x8(%ebp)
  800c88:	e8 89 ff ff ff       	call   800c16 <vsnprintf>
  800c8d:	83 c4 10             	add    $0x10,%esp
  800c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca5:	eb 06                	jmp    800cad <strlen+0x15>
		n++;
  800ca7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	ff 45 08             	incl   0x8(%ebp)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	84 c0                	test   %al,%al
  800cb4:	75 f1                	jne    800ca7 <strlen+0xf>
		n++;
	return n;
  800cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc8:	eb 09                	jmp    800cd3 <strnlen+0x18>
		n++;
  800cca:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	ff 45 08             	incl   0x8(%ebp)
  800cd0:	ff 4d 0c             	decl   0xc(%ebp)
  800cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd7:	74 09                	je     800ce2 <strnlen+0x27>
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 e8                	jne    800cca <strnlen+0xf>
		n++;
	return n;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf3:	90                   	nop
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8d 50 01             	lea    0x1(%eax),%edx
  800cfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d06:	8a 12                	mov    (%edx),%dl
  800d08:	88 10                	mov    %dl,(%eax)
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e4                	jne    800cf4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d28:	eb 1f                	jmp    800d49 <strncpy+0x34>
		*dst++ = *src;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8d 50 01             	lea    0x1(%eax),%edx
  800d30:	89 55 08             	mov    %edx,0x8(%ebp)
  800d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d36:	8a 12                	mov    (%edx),%dl
  800d38:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	84 c0                	test   %al,%al
  800d41:	74 03                	je     800d46 <strncpy+0x31>
			src++;
  800d43:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d46:	ff 45 fc             	incl   -0x4(%ebp)
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4f:	72 d9                	jb     800d2a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	74 30                	je     800d98 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d68:	eb 16                	jmp    800d80 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8d 50 01             	lea    0x1(%eax),%edx
  800d70:	89 55 08             	mov    %edx,0x8(%ebp)
  800d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7c:	8a 12                	mov    (%edx),%dl
  800d7e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d80:	ff 4d 10             	decl   0x10(%ebp)
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 09                	je     800d92 <strlcpy+0x3c>
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 d8                	jne    800d6a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9e:	29 c2                	sub    %eax,%edx
  800da0:	89 d0                	mov    %edx,%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800da7:	eb 06                	jmp    800daf <strcmp+0xb>
		p++, q++;
  800da9:	ff 45 08             	incl   0x8(%ebp)
  800dac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	74 0e                	je     800dc6 <strcmp+0x22>
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 10                	mov    (%eax),%dl
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	38 c2                	cmp    %al,%dl
  800dc4:	74 e3                	je     800da9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f b6 d0             	movzbl %al,%edx
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 c0             	movzbl %al,%eax
  800dd6:	29 c2                	sub    %eax,%edx
  800dd8:	89 d0                	mov    %edx,%eax
}
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ddf:	eb 09                	jmp    800dea <strncmp+0xe>
		n--, p++, q++;
  800de1:	ff 4d 10             	decl   0x10(%ebp)
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	74 17                	je     800e07 <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	84 c0                	test   %al,%al
  800df7:	74 0e                	je     800e07 <strncmp+0x2b>
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 10                	mov    (%eax),%dl
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	38 c2                	cmp    %al,%dl
  800e05:	74 da                	je     800de1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0b:	75 07                	jne    800e14 <strncmp+0x38>
		return 0;
  800e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e12:	eb 14                	jmp    800e28 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	0f b6 d0             	movzbl %al,%edx
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	29 c2                	sub    %eax,%edx
  800e26:	89 d0                	mov    %edx,%eax
}
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 04             	sub    $0x4,%esp
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e36:	eb 12                	jmp    800e4a <strchr+0x20>
		if (*s == c)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e40:	75 05                	jne    800e47 <strchr+0x1d>
			return (char *) s;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	eb 11                	jmp    800e58 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	84 c0                	test   %al,%al
  800e51:	75 e5                	jne    800e38 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 04             	sub    $0x4,%esp
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e66:	eb 0d                	jmp    800e75 <strfind+0x1b>
		if (*s == c)
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e70:	74 0e                	je     800e80 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	84 c0                	test   %al,%al
  800e7c:	75 ea                	jne    800e68 <strfind+0xe>
  800e7e:	eb 01                	jmp    800e81 <strfind+0x27>
		if (*s == c)
			break;
  800e80:	90                   	nop
	return (char *) s;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e98:	eb 0e                	jmp    800ea8 <memset+0x22>
		*p++ = c;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ea8:	ff 4d f8             	decl   -0x8(%ebp)
  800eab:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eaf:	79 e9                	jns    800e9a <memset+0x14>
		*p++ = c;

	return v;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ec8:	eb 16                	jmp    800ee0 <memcpy+0x2a>
		*d++ = *s++;
  800eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecd:	8d 50 01             	lea    0x1(%eax),%edx
  800ed0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edc:	8a 12                	mov    (%edx),%dl
  800ede:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	75 dd                	jne    800eca <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f07:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0a:	73 50                	jae    800f5c <memmove+0x6a>
  800f0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f17:	76 43                	jbe    800f5c <memmove+0x6a>
		s += n;
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f25:	eb 10                	jmp    800f37 <memmove+0x45>
			*--d = *--s;
  800f27:	ff 4d f8             	decl   -0x8(%ebp)
  800f2a:	ff 4d fc             	decl   -0x4(%ebp)
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	8a 10                	mov    (%eax),%dl
  800f32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f35:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	75 e3                	jne    800f27 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f44:	eb 23                	jmp    800f69 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f58:	8a 12                	mov    (%edx),%dl
  800f5a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f62:	89 55 10             	mov    %edx,0x10(%ebp)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	75 dd                	jne    800f46 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f80:	eb 2a                	jmp    800fac <memcmp+0x3e>
		if (*s1 != *s2)
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f85:	8a 10                	mov    (%eax),%dl
  800f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	38 c2                	cmp    %al,%dl
  800f8e:	74 16                	je     800fa6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 d0             	movzbl %al,%edx
  800f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 c0             	movzbl %al,%eax
  800fa0:	29 c2                	sub    %eax,%edx
  800fa2:	89 d0                	mov    %edx,%eax
  800fa4:	eb 18                	jmp    800fbe <memcmp+0x50>
		s1++, s2++;
  800fa6:	ff 45 fc             	incl   -0x4(%ebp)
  800fa9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	75 c9                	jne    800f82 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 d0                	add    %edx,%eax
  800fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd1:	eb 15                	jmp    800fe8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 d0             	movzbl %al,%edx
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	0f b6 c0             	movzbl %al,%eax
  800fe1:	39 c2                	cmp    %eax,%edx
  800fe3:	74 0d                	je     800ff2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fe5:	ff 45 08             	incl   0x8(%ebp)
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fee:	72 e3                	jb     800fd3 <memfind+0x13>
  800ff0:	eb 01                	jmp    800ff3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ff2:	90                   	nop
	return (void *) s;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ffe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801005:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80100c:	eb 03                	jmp    801011 <strtol+0x19>
		s++;
  80100e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 20                	cmp    $0x20,%al
  801018:	74 f4                	je     80100e <strtol+0x16>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 09                	cmp    $0x9,%al
  801021:	74 eb                	je     80100e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 2b                	cmp    $0x2b,%al
  80102a:	75 05                	jne    801031 <strtol+0x39>
		s++;
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	eb 13                	jmp    801044 <strtol+0x4c>
	else if (*s == '-')
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 2d                	cmp    $0x2d,%al
  801038:	75 0a                	jne    801044 <strtol+0x4c>
		s++, neg = 1;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801044:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801048:	74 06                	je     801050 <strtol+0x58>
  80104a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80104e:	75 20                	jne    801070 <strtol+0x78>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 30                	cmp    $0x30,%al
  801057:	75 17                	jne    801070 <strtol+0x78>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	40                   	inc    %eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	3c 78                	cmp    $0x78,%al
  801061:	75 0d                	jne    801070 <strtol+0x78>
		s += 2, base = 16;
  801063:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801067:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80106e:	eb 28                	jmp    801098 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801074:	75 15                	jne    80108b <strtol+0x93>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 30                	cmp    $0x30,%al
  80107d:	75 0c                	jne    80108b <strtol+0x93>
		s++, base = 8;
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801089:	eb 0d                	jmp    801098 <strtol+0xa0>
	else if (base == 0)
  80108b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108f:	75 07                	jne    801098 <strtol+0xa0>
		base = 10;
  801091:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 2f                	cmp    $0x2f,%al
  80109f:	7e 19                	jle    8010ba <strtol+0xc2>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 39                	cmp    $0x39,%al
  8010a8:	7f 10                	jg     8010ba <strtol+0xc2>
			dig = *s - '0';
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	0f be c0             	movsbl %al,%eax
  8010b2:	83 e8 30             	sub    $0x30,%eax
  8010b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b8:	eb 42                	jmp    8010fc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 60                	cmp    $0x60,%al
  8010c1:	7e 19                	jle    8010dc <strtol+0xe4>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 7a                	cmp    $0x7a,%al
  8010ca:	7f 10                	jg     8010dc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	0f be c0             	movsbl %al,%eax
  8010d4:	83 e8 57             	sub    $0x57,%eax
  8010d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010da:	eb 20                	jmp    8010fc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 40                	cmp    $0x40,%al
  8010e3:	7e 39                	jle    80111e <strtol+0x126>
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3c 5a                	cmp    $0x5a,%al
  8010ec:	7f 30                	jg     80111e <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	0f be c0             	movsbl %al,%eax
  8010f6:	83 e8 37             	sub    $0x37,%eax
  8010f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801102:	7d 19                	jge    80111d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80110e:	89 c2                	mov    %eax,%edx
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801118:	e9 7b ff ff ff       	jmp    801098 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80111d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80111e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801122:	74 08                	je     80112c <strtol+0x134>
		*endptr = (char *) s;
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	8b 55 08             	mov    0x8(%ebp),%edx
  80112a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80112c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801130:	74 07                	je     801139 <strtol+0x141>
  801132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801135:	f7 d8                	neg    %eax
  801137:	eb 03                	jmp    80113c <strtol+0x144>
  801139:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <ltostr>:

void
ltostr(long value, char *str)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80114b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801156:	79 13                	jns    80116b <ltostr+0x2d>
	{
		neg = 1;
  801158:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801165:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801168:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801173:	99                   	cltd   
  801174:	f7 f9                	idiv   %ecx
  801176:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	8d 50 01             	lea    0x1(%eax),%edx
  80117f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801182:	89 c2                	mov    %eax,%edx
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80118c:	83 c2 30             	add    $0x30,%edx
  80118f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801194:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801199:	f7 e9                	imul   %ecx
  80119b:	c1 fa 02             	sar    $0x2,%edx
  80119e:	89 c8                	mov    %ecx,%eax
  8011a0:	c1 f8 1f             	sar    $0x1f,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ad:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b2:	f7 e9                	imul   %ecx
  8011b4:	c1 fa 02             	sar    $0x2,%edx
  8011b7:	89 c8                	mov    %ecx,%eax
  8011b9:	c1 f8 1f             	sar    $0x1f,%eax
  8011bc:	29 c2                	sub    %eax,%edx
  8011be:	89 d0                	mov    %edx,%eax
  8011c0:	c1 e0 02             	shl    $0x2,%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	01 c0                	add    %eax,%eax
  8011c7:	29 c1                	sub    %eax,%ecx
  8011c9:	89 ca                	mov    %ecx,%edx
  8011cb:	85 d2                	test   %edx,%edx
  8011cd:	75 9c                	jne    80116b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	48                   	dec    %eax
  8011da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e1:	74 3d                	je     801220 <ltostr+0xe2>
		start = 1 ;
  8011e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ea:	eb 34                	jmp    801220 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	01 c2                	add    %eax,%edx
  801201:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c8                	add    %ecx,%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80120d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c2                	add    %eax,%edx
  801215:	8a 45 eb             	mov    -0x15(%ebp),%al
  801218:	88 02                	mov    %al,(%edx)
		start++ ;
  80121a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80121d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801223:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801226:	7c c4                	jl     8011ec <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801228:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	01 d0                	add    %edx,%eax
  801230:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801233:	90                   	nop
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80123c:	ff 75 08             	pushl  0x8(%ebp)
  80123f:	e8 54 fa ff ff       	call   800c98 <strlen>
  801244:	83 c4 04             	add    $0x4,%esp
  801247:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	e8 46 fa ff ff       	call   800c98 <strlen>
  801252:	83 c4 04             	add    $0x4,%esp
  801255:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80125f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801266:	eb 17                	jmp    80127f <strcconcat+0x49>
		final[s] = str1[s] ;
  801268:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 c2                	add    %eax,%edx
  801270:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	01 c8                	add    %ecx,%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80127c:	ff 45 fc             	incl   -0x4(%ebp)
  80127f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801282:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801285:	7c e1                	jl     801268 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801287:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80128e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801295:	eb 1f                	jmp    8012b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801297:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c8                	add    %ecx,%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012b3:	ff 45 f8             	incl   -0x8(%ebp)
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012bc:	7c d9                	jl     801297 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012db:	8b 00                	mov    (%eax),%eax
  8012dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012ef:	eb 0c                	jmp    8012fd <strsplit+0x31>
			*string++ = 0;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8d 50 01             	lea    0x1(%eax),%edx
  8012f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	74 18                	je     80131e <strsplit+0x52>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	0f be c0             	movsbl %al,%eax
  80130e:	50                   	push   %eax
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	e8 13 fb ff ff       	call   800e2a <strchr>
  801317:	83 c4 08             	add    $0x8,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	75 d3                	jne    8012f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	84 c0                	test   %al,%al
  801325:	74 5a                	je     801381 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801327:	8b 45 14             	mov    0x14(%ebp),%eax
  80132a:	8b 00                	mov    (%eax),%eax
  80132c:	83 f8 0f             	cmp    $0xf,%eax
  80132f:	75 07                	jne    801338 <strsplit+0x6c>
		{
			return 0;
  801331:	b8 00 00 00 00       	mov    $0x0,%eax
  801336:	eb 66                	jmp    80139e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801338:	8b 45 14             	mov    0x14(%ebp),%eax
  80133b:	8b 00                	mov    (%eax),%eax
  80133d:	8d 48 01             	lea    0x1(%eax),%ecx
  801340:	8b 55 14             	mov    0x14(%ebp),%edx
  801343:	89 0a                	mov    %ecx,(%edx)
  801345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	01 c2                	add    %eax,%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801356:	eb 03                	jmp    80135b <strsplit+0x8f>
			string++;
  801358:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	84 c0                	test   %al,%al
  801362:	74 8b                	je     8012ef <strsplit+0x23>
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f be c0             	movsbl %al,%eax
  80136c:	50                   	push   %eax
  80136d:	ff 75 0c             	pushl  0xc(%ebp)
  801370:	e8 b5 fa ff ff       	call   800e2a <strchr>
  801375:	83 c4 08             	add    $0x8,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	74 dc                	je     801358 <strsplit+0x8c>
			string++;
	}
  80137c:	e9 6e ff ff ff       	jmp    8012ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801381:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801382:	8b 45 14             	mov    0x14(%ebp),%eax
  801385:	8b 00                	mov    (%eax),%eax
  801387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138e:	8b 45 10             	mov    0x10(%ebp),%eax
  801391:	01 d0                	add    %edx,%eax
  801393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801399:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8013a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ad:	eb 4c                	jmp    8013fb <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8013af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	01 d0                	add    %edx,%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	3c 40                	cmp    $0x40,%al
  8013bb:	7e 27                	jle    8013e4 <str2lower+0x44>
  8013bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 5a                	cmp    $0x5a,%al
  8013c9:	7f 19                	jg     8013e4 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8013cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d9:	01 ca                	add    %ecx,%edx
  8013db:	8a 12                	mov    (%edx),%dl
  8013dd:	83 c2 20             	add    $0x20,%edx
  8013e0:	88 10                	mov    %dl,(%eax)
  8013e2:	eb 14                	jmp    8013f8 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8013e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8013f8:	ff 45 fc             	incl   -0x4(%ebp)
  8013fb:	ff 75 0c             	pushl  0xc(%ebp)
  8013fe:	e8 95 f8 ff ff       	call   800c98 <strlen>
  801403:	83 c4 04             	add    $0x4,%esp
  801406:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801409:	7f a4                	jg     8013af <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  80140b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	01 d0                	add    %edx,%eax
  801413:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	57                   	push   %edi
  80141f:	56                   	push   %esi
  801420:	53                   	push   %ebx
  801421:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801430:	8b 7d 18             	mov    0x18(%ebp),%edi
  801433:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801436:	cd 30                	int    $0x30
  801438:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	5b                   	pop    %ebx
  801442:	5e                   	pop    %esi
  801443:	5f                   	pop    %edi
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	8b 45 10             	mov    0x10(%ebp),%eax
  80144f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801452:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	52                   	push   %edx
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	6a 00                	push   $0x0
  801464:	e8 b2 ff ff ff       	call   80141b <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_cgetc>:

int
sys_cgetc(void)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 01                	push   $0x1
  80147e:	e8 98 ff ff ff       	call   80141b <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	52                   	push   %edx
  801498:	50                   	push   %eax
  801499:	6a 05                	push   $0x5
  80149b:	e8 7b ff ff ff       	call   80141b <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8014ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	51                   	push   %ecx
  8014bc:	52                   	push   %edx
  8014bd:	50                   	push   %eax
  8014be:	6a 06                	push   $0x6
  8014c0:	e8 56 ff ff ff       	call   80141b <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014cb:	5b                   	pop    %ebx
  8014cc:	5e                   	pop    %esi
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	52                   	push   %edx
  8014df:	50                   	push   %eax
  8014e0:	6a 07                	push   $0x7
  8014e2:	e8 34 ff ff ff       	call   80141b <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	6a 08                	push   $0x8
  8014fd:	e8 19 ff ff ff       	call   80141b <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 09                	push   $0x9
  801516:	e8 00 ff ff ff       	call   80141b <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 0a                	push   $0xa
  80152f:	e8 e7 fe ff ff       	call   80141b <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 0b                	push   $0xb
  801548:	e8 ce fe ff ff       	call   80141b <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 0c                	push   $0xc
  801561:	e8 b5 fe ff ff       	call   80141b <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	ff 75 08             	pushl  0x8(%ebp)
  801579:	6a 0d                	push   $0xd
  80157b:	e8 9b fe ff ff       	call   80141b <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 0e                	push   $0xe
  801594:	e8 82 fe ff ff       	call   80141b <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	90                   	nop
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 11                	push   $0x11
  8015ae:	e8 68 fe ff ff       	call   80141b <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 12                	push   $0x12
  8015c8:	e8 4e fe ff ff       	call   80141b <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	50                   	push   %eax
  8015ec:	6a 13                	push   $0x13
  8015ee:	e8 28 fe ff ff       	call   80141b <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 14                	push   $0x14
  801608:	e8 0e fe ff ff       	call   80141b <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	50                   	push   %eax
  801623:	6a 15                	push   $0x15
  801625:	e8 f1 fd ff ff       	call   80141b <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 18                	push   $0x18
  801642:	e8 d4 fd ff ff       	call   80141b <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	52                   	push   %edx
  80165c:	50                   	push   %eax
  80165d:	6a 16                	push   $0x16
  80165f:	e8 b7 fd ff ff       	call   80141b <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80166d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 17                	push   $0x17
  80167d:	e8 99 fd ff ff       	call   80141b <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801694:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801697:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	51                   	push   %ecx
  8016a1:	52                   	push   %edx
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	50                   	push   %eax
  8016a6:	6a 19                	push   $0x19
  8016a8:	e8 6e fd ff ff       	call   80141b <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	52                   	push   %edx
  8016c2:	50                   	push   %eax
  8016c3:	6a 1a                	push   $0x1a
  8016c5:	e8 51 fd ff ff       	call   80141b <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	51                   	push   %ecx
  8016e0:	52                   	push   %edx
  8016e1:	50                   	push   %eax
  8016e2:	6a 1b                	push   $0x1b
  8016e4:	e8 32 fd ff ff       	call   80141b <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	52                   	push   %edx
  8016fe:	50                   	push   %eax
  8016ff:	6a 1c                	push   $0x1c
  801701:	e8 15 fd ff ff       	call   80141b <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 1d                	push   $0x1d
  80171a:	e8 fc fc ff ff       	call   80141b <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	6a 00                	push   $0x0
  80172c:	ff 75 14             	pushl  0x14(%ebp)
  80172f:	ff 75 10             	pushl  0x10(%ebp)
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	50                   	push   %eax
  801736:	6a 1e                	push   $0x1e
  801738:	e8 de fc ff ff       	call   80141b <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	50                   	push   %eax
  801751:	6a 1f                	push   $0x1f
  801753:	e8 c3 fc ff ff       	call   80141b <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	50                   	push   %eax
  80176d:	6a 20                	push   $0x20
  80176f:	e8 a7 fc ff ff       	call   80141b <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 02                	push   $0x2
  801788:	e8 8e fc ff ff       	call   80141b <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 03                	push   $0x3
  8017a1:	e8 75 fc ff ff       	call   80141b <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 04                	push   $0x4
  8017ba:	e8 5c fc ff ff       	call   80141b <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_exit_env>:


void sys_exit_env(void)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 21                	push   $0x21
  8017d3:	e8 43 fc ff ff       	call   80141b <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	90                   	nop
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e7:	8d 50 04             	lea    0x4(%eax),%edx
  8017ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	52                   	push   %edx
  8017f4:	50                   	push   %eax
  8017f5:	6a 22                	push   $0x22
  8017f7:	e8 1f fc ff ff       	call   80141b <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801802:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801805:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801808:	89 01                	mov    %eax,(%ecx)
  80180a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	c9                   	leave  
  801811:	c2 04 00             	ret    $0x4

00801814 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 10             	pushl  0x10(%ebp)
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 10                	push   $0x10
  801826:	e8 f0 fb ff ff       	call   80141b <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return ;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_rcr2>:
uint32 sys_rcr2()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 23                	push   $0x23
  801840:	e8 d6 fb ff ff       	call   80141b <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801856:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	50                   	push   %eax
  801863:	6a 24                	push   $0x24
  801865:	e8 b1 fb ff ff       	call   80141b <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return ;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <rsttst>:
void rsttst()
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 26                	push   $0x26
  80187f:	e8 97 fb ff ff       	call   80141b <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
	return ;
  801887:	90                   	nop
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	8b 45 14             	mov    0x14(%ebp),%eax
  801893:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801896:	8b 55 18             	mov    0x18(%ebp),%edx
  801899:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	ff 75 10             	pushl  0x10(%ebp)
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	6a 25                	push   $0x25
  8018aa:	e8 6c fb ff ff       	call   80141b <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b2:	90                   	nop
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <chktst>:
void chktst(uint32 n)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	6a 27                	push   $0x27
  8018c5:	e8 51 fb ff ff       	call   80141b <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cd:	90                   	nop
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <inctst>:

void inctst()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 28                	push   $0x28
  8018df:	e8 37 fb ff ff       	call   80141b <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e7:	90                   	nop
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <gettst>:
uint32 gettst()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 29                	push   $0x29
  8018f9:	e8 1d fb ff ff       	call   80141b <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 2a                	push   $0x2a
  801915:	e8 01 fb ff ff       	call   80141b <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
  80191d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801920:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801924:	75 07                	jne    80192d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801926:	b8 01 00 00 00       	mov    $0x1,%eax
  80192b:	eb 05                	jmp    801932 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 2a                	push   $0x2a
  801946:	e8 d0 fa ff ff       	call   80141b <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
  80194e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801951:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801955:	75 07                	jne    80195e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801957:	b8 01 00 00 00       	mov    $0x1,%eax
  80195c:	eb 05                	jmp    801963 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80195e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 2a                	push   $0x2a
  801977:	e8 9f fa ff ff       	call   80141b <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
  80197f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801982:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801986:	75 07                	jne    80198f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801988:	b8 01 00 00 00       	mov    $0x1,%eax
  80198d:	eb 05                	jmp    801994 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 2a                	push   $0x2a
  8019a8:	e8 6e fa ff ff       	call   80141b <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
  8019b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019b7:	75 07                	jne    8019c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019be:	eb 05                	jmp    8019c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 2b                	push   $0x2b
  8019d7:	e8 3f fa ff ff       	call   80141b <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	53                   	push   %ebx
  8019f5:	51                   	push   %ecx
  8019f6:	52                   	push   %edx
  8019f7:	50                   	push   %eax
  8019f8:	6a 2c                	push   $0x2c
  8019fa:	e8 1c fa ff ff       	call   80141b <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 2d                	push   $0x2d
  801a1a:	e8 fc f9 ff ff       	call   80141b <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a27:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	51                   	push   %ecx
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 2e                	push   $0x2e
  801a3a:	e8 dc f9 ff ff       	call   80141b <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 10             	pushl  0x10(%ebp)
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	6a 0f                	push   $0xf
  801a56:	e8 c0 f9 ff ff       	call   80141b <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5e:	90                   	nop
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	50                   	push   %eax
  801a70:	6a 2f                	push   $0x2f
  801a72:	e8 a4 f9 ff ff       	call   80141b <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp

}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 30                	push   $0x30
  801a8d:	e8 89 f9 ff ff       	call   80141b <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp

}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 31                	push   $0x31
  801aa9:	e8 6d f9 ff ff       	call   80141b <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp

}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 32                	push   $0x32
  801ac3:	e8 53 f9 ff ff       	call   80141b <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    
  801acd:	66 90                	xchg   %ax,%ax
  801acf:	90                   	nop

00801ad0 <__udivdi3>:
  801ad0:	55                   	push   %ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801adb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801adf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ae3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ae7:	89 ca                	mov    %ecx,%edx
  801ae9:	89 f8                	mov    %edi,%eax
  801aeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aef:	85 f6                	test   %esi,%esi
  801af1:	75 2d                	jne    801b20 <__udivdi3+0x50>
  801af3:	39 cf                	cmp    %ecx,%edi
  801af5:	77 65                	ja     801b5c <__udivdi3+0x8c>
  801af7:	89 fd                	mov    %edi,%ebp
  801af9:	85 ff                	test   %edi,%edi
  801afb:	75 0b                	jne    801b08 <__udivdi3+0x38>
  801afd:	b8 01 00 00 00       	mov    $0x1,%eax
  801b02:	31 d2                	xor    %edx,%edx
  801b04:	f7 f7                	div    %edi
  801b06:	89 c5                	mov    %eax,%ebp
  801b08:	31 d2                	xor    %edx,%edx
  801b0a:	89 c8                	mov    %ecx,%eax
  801b0c:	f7 f5                	div    %ebp
  801b0e:	89 c1                	mov    %eax,%ecx
  801b10:	89 d8                	mov    %ebx,%eax
  801b12:	f7 f5                	div    %ebp
  801b14:	89 cf                	mov    %ecx,%edi
  801b16:	89 fa                	mov    %edi,%edx
  801b18:	83 c4 1c             	add    $0x1c,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	77 28                	ja     801b4c <__udivdi3+0x7c>
  801b24:	0f bd fe             	bsr    %esi,%edi
  801b27:	83 f7 1f             	xor    $0x1f,%edi
  801b2a:	75 40                	jne    801b6c <__udivdi3+0x9c>
  801b2c:	39 ce                	cmp    %ecx,%esi
  801b2e:	72 0a                	jb     801b3a <__udivdi3+0x6a>
  801b30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b34:	0f 87 9e 00 00 00    	ja     801bd8 <__udivdi3+0x108>
  801b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3f:	89 fa                	mov    %edi,%edx
  801b41:	83 c4 1c             	add    $0x1c,%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5f                   	pop    %edi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    
  801b49:	8d 76 00             	lea    0x0(%esi),%esi
  801b4c:	31 ff                	xor    %edi,%edi
  801b4e:	31 c0                	xor    %eax,%eax
  801b50:	89 fa                	mov    %edi,%edx
  801b52:	83 c4 1c             	add    $0x1c,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    
  801b5a:	66 90                	xchg   %ax,%ax
  801b5c:	89 d8                	mov    %ebx,%eax
  801b5e:	f7 f7                	div    %edi
  801b60:	31 ff                	xor    %edi,%edi
  801b62:	89 fa                	mov    %edi,%edx
  801b64:	83 c4 1c             	add    $0x1c,%esp
  801b67:	5b                   	pop    %ebx
  801b68:	5e                   	pop    %esi
  801b69:	5f                   	pop    %edi
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    
  801b6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b71:	89 eb                	mov    %ebp,%ebx
  801b73:	29 fb                	sub    %edi,%ebx
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	d3 e6                	shl    %cl,%esi
  801b79:	89 c5                	mov    %eax,%ebp
  801b7b:	88 d9                	mov    %bl,%cl
  801b7d:	d3 ed                	shr    %cl,%ebp
  801b7f:	89 e9                	mov    %ebp,%ecx
  801b81:	09 f1                	or     %esi,%ecx
  801b83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b87:	89 f9                	mov    %edi,%ecx
  801b89:	d3 e0                	shl    %cl,%eax
  801b8b:	89 c5                	mov    %eax,%ebp
  801b8d:	89 d6                	mov    %edx,%esi
  801b8f:	88 d9                	mov    %bl,%cl
  801b91:	d3 ee                	shr    %cl,%esi
  801b93:	89 f9                	mov    %edi,%ecx
  801b95:	d3 e2                	shl    %cl,%edx
  801b97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9b:	88 d9                	mov    %bl,%cl
  801b9d:	d3 e8                	shr    %cl,%eax
  801b9f:	09 c2                	or     %eax,%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	f7 74 24 0c          	divl   0xc(%esp)
  801ba9:	89 d6                	mov    %edx,%esi
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	f7 e5                	mul    %ebp
  801baf:	39 d6                	cmp    %edx,%esi
  801bb1:	72 19                	jb     801bcc <__udivdi3+0xfc>
  801bb3:	74 0b                	je     801bc0 <__udivdi3+0xf0>
  801bb5:	89 d8                	mov    %ebx,%eax
  801bb7:	31 ff                	xor    %edi,%edi
  801bb9:	e9 58 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bc4:	89 f9                	mov    %edi,%ecx
  801bc6:	d3 e2                	shl    %cl,%edx
  801bc8:	39 c2                	cmp    %eax,%edx
  801bca:	73 e9                	jae    801bb5 <__udivdi3+0xe5>
  801bcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bcf:	31 ff                	xor    %edi,%edi
  801bd1:	e9 40 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	31 c0                	xor    %eax,%eax
  801bda:	e9 37 ff ff ff       	jmp    801b16 <__udivdi3+0x46>
  801bdf:	90                   	nop

00801be0 <__umoddi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801beb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bff:	89 f3                	mov    %esi,%ebx
  801c01:	89 fa                	mov    %edi,%edx
  801c03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c07:	89 34 24             	mov    %esi,(%esp)
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	75 1a                	jne    801c28 <__umoddi3+0x48>
  801c0e:	39 f7                	cmp    %esi,%edi
  801c10:	0f 86 a2 00 00 00    	jbe    801cb8 <__umoddi3+0xd8>
  801c16:	89 c8                	mov    %ecx,%eax
  801c18:	89 f2                	mov    %esi,%edx
  801c1a:	f7 f7                	div    %edi
  801c1c:	89 d0                	mov    %edx,%eax
  801c1e:	31 d2                	xor    %edx,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	39 f0                	cmp    %esi,%eax
  801c2a:	0f 87 ac 00 00 00    	ja     801cdc <__umoddi3+0xfc>
  801c30:	0f bd e8             	bsr    %eax,%ebp
  801c33:	83 f5 1f             	xor    $0x1f,%ebp
  801c36:	0f 84 ac 00 00 00    	je     801ce8 <__umoddi3+0x108>
  801c3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c41:	29 ef                	sub    %ebp,%edi
  801c43:	89 fe                	mov    %edi,%esi
  801c45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c49:	89 e9                	mov    %ebp,%ecx
  801c4b:	d3 e0                	shl    %cl,%eax
  801c4d:	89 d7                	mov    %edx,%edi
  801c4f:	89 f1                	mov    %esi,%ecx
  801c51:	d3 ef                	shr    %cl,%edi
  801c53:	09 c7                	or     %eax,%edi
  801c55:	89 e9                	mov    %ebp,%ecx
  801c57:	d3 e2                	shl    %cl,%edx
  801c59:	89 14 24             	mov    %edx,(%esp)
  801c5c:	89 d8                	mov    %ebx,%eax
  801c5e:	d3 e0                	shl    %cl,%eax
  801c60:	89 c2                	mov    %eax,%edx
  801c62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c66:	d3 e0                	shl    %cl,%eax
  801c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c70:	89 f1                	mov    %esi,%ecx
  801c72:	d3 e8                	shr    %cl,%eax
  801c74:	09 d0                	or     %edx,%eax
  801c76:	d3 eb                	shr    %cl,%ebx
  801c78:	89 da                	mov    %ebx,%edx
  801c7a:	f7 f7                	div    %edi
  801c7c:	89 d3                	mov    %edx,%ebx
  801c7e:	f7 24 24             	mull   (%esp)
  801c81:	89 c6                	mov    %eax,%esi
  801c83:	89 d1                	mov    %edx,%ecx
  801c85:	39 d3                	cmp    %edx,%ebx
  801c87:	0f 82 87 00 00 00    	jb     801d14 <__umoddi3+0x134>
  801c8d:	0f 84 91 00 00 00    	je     801d24 <__umoddi3+0x144>
  801c93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c97:	29 f2                	sub    %esi,%edx
  801c99:	19 cb                	sbb    %ecx,%ebx
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ca1:	d3 e0                	shl    %cl,%eax
  801ca3:	89 e9                	mov    %ebp,%ecx
  801ca5:	d3 ea                	shr    %cl,%edx
  801ca7:	09 d0                	or     %edx,%eax
  801ca9:	89 e9                	mov    %ebp,%ecx
  801cab:	d3 eb                	shr    %cl,%ebx
  801cad:	89 da                	mov    %ebx,%edx
  801caf:	83 c4 1c             	add    $0x1c,%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
  801cb7:	90                   	nop
  801cb8:	89 fd                	mov    %edi,%ebp
  801cba:	85 ff                	test   %edi,%edi
  801cbc:	75 0b                	jne    801cc9 <__umoddi3+0xe9>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	31 d2                	xor    %edx,%edx
  801cc5:	f7 f7                	div    %edi
  801cc7:	89 c5                	mov    %eax,%ebp
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	f7 f5                	div    %ebp
  801ccf:	89 c8                	mov    %ecx,%eax
  801cd1:	f7 f5                	div    %ebp
  801cd3:	89 d0                	mov    %edx,%eax
  801cd5:	e9 44 ff ff ff       	jmp    801c1e <__umoddi3+0x3e>
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	89 c8                	mov    %ecx,%eax
  801cde:	89 f2                	mov    %esi,%edx
  801ce0:	83 c4 1c             	add    $0x1c,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5f                   	pop    %edi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    
  801ce8:	3b 04 24             	cmp    (%esp),%eax
  801ceb:	72 06                	jb     801cf3 <__umoddi3+0x113>
  801ced:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cf1:	77 0f                	ja     801d02 <__umoddi3+0x122>
  801cf3:	89 f2                	mov    %esi,%edx
  801cf5:	29 f9                	sub    %edi,%ecx
  801cf7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cfb:	89 14 24             	mov    %edx,(%esp)
  801cfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d02:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d06:	8b 14 24             	mov    (%esp),%edx
  801d09:	83 c4 1c             	add    $0x1c,%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5f                   	pop    %edi
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    
  801d11:	8d 76 00             	lea    0x0(%esi),%esi
  801d14:	2b 04 24             	sub    (%esp),%eax
  801d17:	19 fa                	sbb    %edi,%edx
  801d19:	89 d1                	mov    %edx,%ecx
  801d1b:	89 c6                	mov    %eax,%esi
  801d1d:	e9 71 ff ff ff       	jmp    801c93 <__umoddi3+0xb3>
  801d22:	66 90                	xchg   %ax,%ax
  801d24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d28:	72 ea                	jb     801d14 <__umoddi3+0x134>
  801d2a:	89 d9                	mov    %ebx,%ecx
  801d2c:	e9 62 ff ff ff       	jmp    801c93 <__umoddi3+0xb3>
