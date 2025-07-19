
obj/user/tst_page_replacement_FIFO_2:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
} ;


#define kilo 1024
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	uint32 expectedMidVAs[11] = {
  800044:	8d 45 98             	lea    -0x68(%ebp),%eax
  800047:	bb 40 1f 80 00       	mov    $0x801f40,%ebx
  80004c:	ba 0b 00 00 00       	mov    $0xb,%edx
  800051:	89 c7                	mov    %eax,%edi
  800053:	89 de                	mov    %ebx,%esi
  800055:	89 d1                	mov    %edx,%ecx
  800057:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			0xeebfd000, 																					//Stack
			0x80a000, 0x80b000, 0x804000, 0x80c000,0x807000,0x808000,0x800000,0x801000,0x809000,0x803000,	//Code & Data
	} ;

	uint32 expectedFinalVAs[11] = {
  800059:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80005f:	bb 80 1f 80 00       	mov    $0x801f80,%ebx
  800064:	ba 0b 00 00 00       	mov    $0xb,%edx
  800069:	89 c7                	mov    %eax,%edi
  80006b:	89 de                	mov    %ebx,%esi
  80006d:	89 d1                	mov    %edx,%ecx
  80006f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			0x80b000,0x804000,0x80c000,0x800000,0x801000, //Code & Data
			0xeebfd000, 					 //Stack
			0x803000,0x805000,0x806000,0x807000,0x808000, //Data
	} ;

	char* tempArr = (char*)0x90000000;
  800071:	c7 45 d8 00 00 00 90 	movl   $0x90000000,-0x28(%ebp)
	uint32 tempArrSize = 5*PAGE_SIZE;
  800078:	c7 45 d4 00 50 00 00 	movl   $0x5000,-0x2c(%ebp)
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80007f:	6a 01                	push   $0x1
  800081:	68 00 00 20 00       	push   $0x200000
  800086:	6a 0b                	push   $0xb
  800088:	68 20 30 80 00       	push   $0x803020
  80008d:	e8 ba 19 00 00       	call   801a4c <sys_check_WS_list>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800098:	83 7d d0 01          	cmpl   $0x1,-0x30(%ebp)
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 60 1d 80 00       	push   $0x801d60
  8000a6:	6a 27                	push   $0x27
  8000a8:	68 d4 1d 80 00       	push   $0x801dd4
  8000ad:	e8 cf 02 00 00       	call   800381 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  8000b2:	e8 78 14 00 00       	call   80152f <sys_calculate_free_frames>
  8000b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000ba:	e8 bb 14 00 00       	call   80157a <sys_pf_calculate_allocated_pages>
  8000bf:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1];
  8000c2:	a0 7f e0 80 00       	mov    0x80e07f,%al
  8000c7:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
  8000ca:	a0 7f f0 80 00       	mov    0x80f07f,%al
  8000cf:	88 45 c6             	mov    %al,-0x3a(%ebp)
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000d9:	eb 26                	jmp    800101 <_main+0xc9>
	{
		arr[i] = 'A' ;
  8000db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000de:	05 80 30 80 00       	add    $0x803080,%eax
  8000e3:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		//ptr++ ; ptr2++ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8000e6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000eb:	8a 00                	mov    (%eax),%al
  8000ed:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  8000f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f5:	8a 00                	mov    (%eax),%al
  8000f7:	88 45 e6             	mov    %al,-0x1a(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1];
	char garbage4, garbage5;

	//Writing (Modified)
	int i;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000fa:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  800101:	81 7d e0 ff 9f 00 00 	cmpl   $0x9fff,-0x20(%ebp)
  800108:	7e d1                	jle    8000db <_main+0xa3>
		garbage5 = *ptr2 ;
	}

	//Check FIFO 1
	{
		found = sys_check_WS_list(expectedMidVAs, 11, 0x807000, 1);
  80010a:	6a 01                	push   $0x1
  80010c:	68 00 70 80 00       	push   $0x807000
  800111:	6a 0b                	push   $0xb
  800113:	8d 45 98             	lea    -0x68(%ebp),%eax
  800116:	50                   	push   %eax
  800117:	e8 30 19 00 00       	call   801a4c <sys_check_WS_list>
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (found != 1) panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800122:	83 7d d0 01          	cmpl   $0x1,-0x30(%ebp)
  800126:	74 14                	je     80013c <_main+0x104>
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	68 f8 1d 80 00       	push   $0x801df8
  800130:	6a 46                	push   $0x46
  800132:	68 d4 1d 80 00       	push   $0x801dd4
  800137:	e8 45 02 00 00       	call   800381 <_panic>
	}

	//char* tempArr = malloc(4*PAGE_SIZE);
	sys_allocate_user_mem((uint32)tempArr, tempArrSize);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	ff 75 d4             	pushl  -0x2c(%ebp)
  800145:	50                   	push   %eax
  800146:	e8 75 19 00 00       	call   801ac0 <sys_allocate_user_mem>
  80014b:	83 c4 10             	add    $0x10,%esp
	//cprintf("1\n");

	int c;
	for(c = 0;c < tempArrSize - 1;c++)
  80014e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800155:	eb 0e                	jmp    800165 <_main+0x12d>
	{
		tempArr[c] = 'a';
  800157:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80015a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	c6 00 61             	movb   $0x61,(%eax)
	//char* tempArr = malloc(4*PAGE_SIZE);
	sys_allocate_user_mem((uint32)tempArr, tempArrSize);
	//cprintf("1\n");

	int c;
	for(c = 0;c < tempArrSize - 1;c++)
  800162:	ff 45 dc             	incl   -0x24(%ebp)
  800165:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800168:	8d 50 ff             	lea    -0x1(%eax),%edx
  80016b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016e:	39 c2                	cmp    %eax,%edx
  800170:	77 e5                	ja     800157 <_main+0x11f>
		tempArr[c] = 'a';
	}

	//cprintf("2\n");

	sys_free_user_mem((uint32)tempArr, tempArrSize);
  800172:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 d4             	pushl  -0x2c(%ebp)
  80017b:	50                   	push   %eax
  80017c:	e8 23 19 00 00       	call   801aa4 <sys_free_user_mem>
  800181:	83 c4 10             	add    $0x10,%esp

	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*0 ; i < PAGE_SIZE*6 ; i+=PAGE_SIZE/2)
  800184:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80018b:	eb 26                	jmp    8001b3 <_main+0x17b>
	{
		arr[i] = 'A' ;
  80018d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800190:	05 80 30 80 00       	add    $0x803080,%eax
  800195:	c6 00 41             	movb   $0x41,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  800198:	a1 00 30 80 00       	mov    0x803000,%eax
  80019d:	8a 00                	mov    (%eax),%al
  80019f:	88 45 e7             	mov    %al,-0x19(%ebp)
		garbage5 = *ptr2 ;
  8001a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a7:	8a 00                	mov    (%eax),%al
  8001a9:	88 45 e6             	mov    %al,-0x1a(%ebp)
	sys_free_user_mem((uint32)tempArr, tempArrSize);

	//cprintf("3\n");

	//Check after free either push records up or leave them empty
	for (i = PAGE_SIZE*0 ; i < PAGE_SIZE*6 ; i+=PAGE_SIZE/2)
  8001ac:	81 45 e0 00 08 00 00 	addl   $0x800,-0x20(%ebp)
  8001b3:	81 7d e0 ff 5f 00 00 	cmpl   $0x5fff,-0x20(%ebp)
  8001ba:	7e d1                	jle    80018d <_main+0x155>

	//===================

	//cprintf("Checking PAGE FIFO algorithm after Free and replacement... \n");
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x80b000, 1);
  8001bc:	6a 01                	push   $0x1
  8001be:	68 00 b0 80 00       	push   $0x80b000
  8001c3:	6a 0b                	push   $0xb
  8001c5:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 7b 18 00 00       	call   801a4c <sys_check_WS_list>
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (found != 1) panic("Page FIFO algo failed [AFTER Freeing an Allocated Space].. MAKE SURE to update the last_WS_element & the correct FIFO order after freeing space");
  8001d7:	83 7d d0 01          	cmpl   $0x1,-0x30(%ebp)
  8001db:	74 14                	je     8001f1 <_main+0x1b9>
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	68 44 1e 80 00       	push   $0x801e44
  8001e5:	6a 68                	push   $0x68
  8001e7:	68 d4 1d 80 00       	push   $0x801dd4
  8001ec:	e8 90 01 00 00       	call   800381 <_panic>
	}

	{
		if (garbage4 != *ptr) panic("test failed!");
  8001f1:	a1 00 30 80 00       	mov    0x803000,%eax
  8001f6:	8a 00                	mov    (%eax),%al
  8001f8:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8001fb:	74 14                	je     800211 <_main+0x1d9>
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	68 d4 1e 80 00       	push   $0x801ed4
  800205:	6a 6c                	push   $0x6c
  800207:	68 d4 1d 80 00       	push   $0x801dd4
  80020c:	e8 70 01 00 00       	call   800381 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  800211:	a1 04 30 80 00       	mov    0x803004,%eax
  800216:	8a 00                	mov    (%eax),%al
  800218:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80021b:	74 14                	je     800231 <_main+0x1f9>
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	68 d4 1e 80 00       	push   $0x801ed4
  800225:	6a 6d                	push   $0x6d
  800227:	68 d4 1d 80 00       	push   $0x801dd4
  80022c:	e8 50 01 00 00       	call   800381 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [FIFO 2] is completed successfully.\n");
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	68 e4 1e 80 00       	push   $0x801ee4
  800239:	e8 00 04 00 00       	call   80063e <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	return;
  800241:	90                   	nop
}
  800242:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800245:	5b                   	pop    %ebx
  800246:	5e                   	pop    %esi
  800247:	5f                   	pop    %edi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 65 15 00 00       	call   8017ba <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 60 30 80 00       	mov    0x803060,%eax
  800281:	8a 40 5c             	mov    0x5c(%eax),%al
  800284:	84 c0                	test   %al,%al
  800286:	74 0d                	je     800295 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800288:	a1 60 30 80 00       	mov    0x803060,%eax
  80028d:	83 c0 5c             	add    $0x5c,%eax
  800290:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800299:	7e 0a                	jle    8002a5 <libmain+0x5b>
		binaryname = argv[0];
  80029b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	a3 4c 30 80 00       	mov    %eax,0x80304c

	// call user main routine
	_main(argc, argv);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 0c             	pushl  0xc(%ebp)
  8002ab:	ff 75 08             	pushl  0x8(%ebp)
  8002ae:	e8 85 fd ff ff       	call   800038 <_main>
  8002b3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b6:	e8 0c 13 00 00       	call   8015c7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 c4 1f 80 00       	push   $0x801fc4
  8002c3:	e8 76 03 00 00       	call   80063e <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002cb:	a1 60 30 80 00       	mov    0x803060,%eax
  8002d0:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8002d6:	a1 60 30 80 00       	mov    0x803060,%eax
  8002db:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	52                   	push   %edx
  8002e5:	50                   	push   %eax
  8002e6:	68 ec 1f 80 00       	push   $0x801fec
  8002eb:	e8 4e 03 00 00       	call   80063e <cprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f3:	a1 60 30 80 00       	mov    0x803060,%eax
  8002f8:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8002fe:	a1 60 30 80 00       	mov    0x803060,%eax
  800303:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800309:	a1 60 30 80 00       	mov    0x803060,%eax
  80030e:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800314:	51                   	push   %ecx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	68 14 20 80 00       	push   $0x802014
  80031c:	e8 1d 03 00 00       	call   80063e <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800324:	a1 60 30 80 00       	mov    0x803060,%eax
  800329:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	50                   	push   %eax
  800333:	68 6c 20 80 00       	push   $0x80206c
  800338:	e8 01 03 00 00       	call   80063e <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 c4 1f 80 00       	push   $0x801fc4
  800348:	e8 f1 02 00 00       	call   80063e <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800350:	e8 8c 12 00 00       	call   8015e1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800355:	e8 19 00 00 00       	call   800373 <exit>
}
  80035a:	90                   	nop
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	6a 00                	push   $0x0
  800368:	e8 19 14 00 00       	call   801786 <sys_destroy_env>
  80036d:	83 c4 10             	add    $0x10,%esp
}
  800370:	90                   	nop
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <exit>:

void
exit(void)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800379:	e8 6e 14 00 00       	call   8017ec <sys_exit_env>
}
  80037e:	90                   	nop
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800387:	8d 45 10             	lea    0x10(%ebp),%eax
  80038a:	83 c0 04             	add    $0x4,%eax
  80038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800390:	a1 6c f1 80 00       	mov    0x80f16c,%eax
  800395:	85 c0                	test   %eax,%eax
  800397:	74 16                	je     8003af <_panic+0x2e>
		cprintf("%s: ", argv0);
  800399:	a1 6c f1 80 00       	mov    0x80f16c,%eax
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	50                   	push   %eax
  8003a2:	68 80 20 80 00       	push   $0x802080
  8003a7:	e8 92 02 00 00       	call   80063e <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003af:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8003b4:	ff 75 0c             	pushl  0xc(%ebp)
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	68 85 20 80 00       	push   $0x802085
  8003c0:	e8 79 02 00 00       	call   80063e <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	e8 fc 01 00 00       	call   8005d3 <vcprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	6a 00                	push   $0x0
  8003df:	68 a1 20 80 00       	push   $0x8020a1
  8003e4:	e8 ea 01 00 00       	call   8005d3 <vcprintf>
  8003e9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003ec:	e8 82 ff ff ff       	call   800373 <exit>

	// should not return here
	while (1) ;
  8003f1:	eb fe                	jmp    8003f1 <_panic+0x70>

008003f3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f9:	a1 60 30 80 00       	mov    0x803060,%eax
  8003fe:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800404:	8b 45 0c             	mov    0xc(%ebp),%eax
  800407:	39 c2                	cmp    %eax,%edx
  800409:	74 14                	je     80041f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80040b:	83 ec 04             	sub    $0x4,%esp
  80040e:	68 a4 20 80 00       	push   $0x8020a4
  800413:	6a 26                	push   $0x26
  800415:	68 f0 20 80 00       	push   $0x8020f0
  80041a:	e8 62 ff ff ff       	call   800381 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80041f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800426:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80042d:	e9 c5 00 00 00       	jmp    8004f7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 08                	jne    80044f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800447:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80044a:	e9 a5 00 00 00       	jmp    8004f4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80044f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80045d:	eb 69                	jmp    8004c8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80045f:	a1 60 30 80 00       	mov    0x803060,%eax
  800464:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80046a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80046d:	89 d0                	mov    %edx,%eax
  80046f:	01 c0                	add    %eax,%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	c1 e0 03             	shl    $0x3,%eax
  800476:	01 c8                	add    %ecx,%eax
  800478:	8a 40 04             	mov    0x4(%eax),%al
  80047b:	84 c0                	test   %al,%al
  80047d:	75 46                	jne    8004c5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80047f:	a1 60 30 80 00       	mov    0x803060,%eax
  800484:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80048a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80048d:	89 d0                	mov    %edx,%eax
  80048f:	01 c0                	add    %eax,%eax
  800491:	01 d0                	add    %edx,%eax
  800493:	c1 e0 03             	shl    $0x3,%eax
  800496:	01 c8                	add    %ecx,%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80049d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004a5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004aa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	01 c8                	add    %ecx,%eax
  8004b6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b8:	39 c2                	cmp    %eax,%edx
  8004ba:	75 09                	jne    8004c5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004bc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004c3:	eb 15                	jmp    8004da <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c5:	ff 45 e8             	incl   -0x18(%ebp)
  8004c8:	a1 60 30 80 00       	mov    0x803060,%eax
  8004cd:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8004d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004d6:	39 c2                	cmp    %eax,%edx
  8004d8:	77 85                	ja     80045f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004de:	75 14                	jne    8004f4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	68 fc 20 80 00       	push   $0x8020fc
  8004e8:	6a 3a                	push   $0x3a
  8004ea:	68 f0 20 80 00       	push   $0x8020f0
  8004ef:	e8 8d fe ff ff       	call   800381 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004f4:	ff 45 f0             	incl   -0x10(%ebp)
  8004f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004fd:	0f 8c 2f ff ff ff    	jl     800432 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800503:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800511:	eb 26                	jmp    800539 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800513:	a1 60 30 80 00       	mov    0x803060,%eax
  800518:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80051e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	01 c0                	add    %eax,%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	c1 e0 03             	shl    $0x3,%eax
  80052a:	01 c8                	add    %ecx,%eax
  80052c:	8a 40 04             	mov    0x4(%eax),%al
  80052f:	3c 01                	cmp    $0x1,%al
  800531:	75 03                	jne    800536 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800533:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800536:	ff 45 e0             	incl   -0x20(%ebp)
  800539:	a1 60 30 80 00       	mov    0x803060,%eax
  80053e:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800547:	39 c2                	cmp    %eax,%edx
  800549:	77 c8                	ja     800513 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800551:	74 14                	je     800567 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 50 21 80 00       	push   $0x802150
  80055b:	6a 44                	push   $0x44
  80055d:	68 f0 20 80 00       	push   $0x8020f0
  800562:	e8 1a fe ff ff       	call   800381 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800567:	90                   	nop
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800570:	8b 45 0c             	mov    0xc(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	8d 48 01             	lea    0x1(%eax),%ecx
  800578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057b:	89 0a                	mov    %ecx,(%edx)
  80057d:	8b 55 08             	mov    0x8(%ebp),%edx
  800580:	88 d1                	mov    %dl,%cl
  800582:	8b 55 0c             	mov    0xc(%ebp),%edx
  800585:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800593:	75 2c                	jne    8005c1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800595:	a0 64 30 80 00       	mov    0x803064,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a0:	8b 12                	mov    (%edx),%edx
  8005a2:	89 d1                	mov    %edx,%ecx
  8005a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a7:	83 c2 08             	add    $0x8,%edx
  8005aa:	83 ec 04             	sub    $0x4,%esp
  8005ad:	50                   	push   %eax
  8005ae:	51                   	push   %ecx
  8005af:	52                   	push   %edx
  8005b0:	e8 b9 0e 00 00       	call   80146e <sys_cputs>
  8005b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c4:	8b 40 04             	mov    0x4(%eax),%eax
  8005c7:	8d 50 01             	lea    0x1(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d0:	90                   	nop
  8005d1:	c9                   	leave  
  8005d2:	c3                   	ret    

008005d3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e3:	00 00 00 
	b.cnt = 0;
  8005e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ed:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	ff 75 08             	pushl  0x8(%ebp)
  8005f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fc:	50                   	push   %eax
  8005fd:	68 6a 05 80 00       	push   $0x80056a
  800602:	e8 11 02 00 00       	call   800818 <vprintfmt>
  800607:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80060a:	a0 64 30 80 00       	mov    0x803064,%al
  80060f:	0f b6 c0             	movzbl %al,%eax
  800612:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	50                   	push   %eax
  80061c:	52                   	push   %edx
  80061d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800623:	83 c0 08             	add    $0x8,%eax
  800626:	50                   	push   %eax
  800627:	e8 42 0e 00 00       	call   80146e <sys_cputs>
  80062c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80062f:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  800636:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <cprintf>:

int cprintf(const char *fmt, ...) {
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800644:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  80064b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 f4             	pushl  -0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	e8 73 ff ff ff       	call   8005d3 <vcprintf>
  800660:	83 c4 10             	add    $0x10,%esp
  800663:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800666:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800669:	c9                   	leave  
  80066a:	c3                   	ret    

0080066b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80066b:	55                   	push   %ebp
  80066c:	89 e5                	mov    %esp,%ebp
  80066e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800671:	e8 51 0f 00 00       	call   8015c7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800676:	8d 45 0c             	lea    0xc(%ebp),%eax
  800679:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	ff 75 f4             	pushl  -0xc(%ebp)
  800685:	50                   	push   %eax
  800686:	e8 48 ff ff ff       	call   8005d3 <vcprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800691:	e8 4b 0f 00 00       	call   8015e1 <sys_enable_interrupt>
	return cnt;
  800696:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	53                   	push   %ebx
  80069f:	83 ec 14             	sub    $0x14,%esp
  8006a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b9:	77 55                	ja     800710 <printnum+0x75>
  8006bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006be:	72 05                	jb     8006c5 <printnum+0x2a>
  8006c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c3:	77 4b                	ja     800710 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	52                   	push   %edx
  8006d4:	50                   	push   %eax
  8006d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006db:	e8 18 14 00 00       	call   801af8 <__udivdi3>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	ff 75 20             	pushl  0x20(%ebp)
  8006e9:	53                   	push   %ebx
  8006ea:	ff 75 18             	pushl  0x18(%ebp)
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	e8 a1 ff ff ff       	call   80069b <printnum>
  8006fa:	83 c4 20             	add    $0x20,%esp
  8006fd:	eb 1a                	jmp    800719 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 20             	pushl  0x20(%ebp)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800710:	ff 4d 1c             	decl   0x1c(%ebp)
  800713:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800717:	7f e6                	jg     8006ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800719:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80071c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800727:	53                   	push   %ebx
  800728:	51                   	push   %ecx
  800729:	52                   	push   %edx
  80072a:	50                   	push   %eax
  80072b:	e8 d8 14 00 00       	call   801c08 <__umoddi3>
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	05 b4 23 80 00       	add    $0x8023b4,%eax
  800738:	8a 00                	mov    (%eax),%al
  80073a:	0f be c0             	movsbl %al,%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	ff d0                	call   *%eax
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800755:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800759:	7e 1c                	jle    800777 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	8d 50 08             	lea    0x8(%eax),%edx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	89 10                	mov    %edx,(%eax)
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	83 e8 08             	sub    $0x8,%eax
  800770:	8b 50 04             	mov    0x4(%eax),%edx
  800773:	8b 00                	mov    (%eax),%eax
  800775:	eb 40                	jmp    8007b7 <getuint+0x65>
	else if (lflag)
  800777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077b:	74 1e                	je     80079b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	89 10                	mov    %edx,(%eax)
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	83 e8 04             	sub    $0x4,%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	ba 00 00 00 00       	mov    $0x0,%edx
  800799:	eb 1c                	jmp    8007b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	8d 50 04             	lea    0x4(%eax),%edx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	89 10                	mov    %edx,(%eax)
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	83 e8 04             	sub    $0x4,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c0:	7e 1c                	jle    8007de <getint+0x25>
		return va_arg(*ap, long long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 08             	lea    0x8(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 08             	sub    $0x8,%eax
  8007d7:	8b 50 04             	mov    0x4(%eax),%edx
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	eb 38                	jmp    800816 <getint+0x5d>
	else if (lflag)
  8007de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e2:	74 1a                	je     8007fe <getint+0x45>
		return va_arg(*ap, long);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	8d 50 04             	lea    0x4(%eax),%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 10                	mov    %edx,(%eax)
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	83 e8 04             	sub    $0x4,%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	99                   	cltd   
  8007fc:	eb 18                	jmp    800816 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	8d 50 04             	lea    0x4(%eax),%edx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	89 10                	mov    %edx,(%eax)
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	83 e8 04             	sub    $0x4,%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	99                   	cltd   
}
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	56                   	push   %esi
  80081c:	53                   	push   %ebx
  80081d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800820:	eb 17                	jmp    800839 <vprintfmt+0x21>
			if (ch == '\0')
  800822:	85 db                	test   %ebx,%ebx
  800824:	0f 84 af 03 00 00    	je     800bd9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	53                   	push   %ebx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	8d 50 01             	lea    0x1(%eax),%edx
  80083f:	89 55 10             	mov    %edx,0x10(%ebp)
  800842:	8a 00                	mov    (%eax),%al
  800844:	0f b6 d8             	movzbl %al,%ebx
  800847:	83 fb 25             	cmp    $0x25,%ebx
  80084a:	75 d6                	jne    800822 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80084c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800850:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800857:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80085e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800865:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086c:	8b 45 10             	mov    0x10(%ebp),%eax
  80086f:	8d 50 01             	lea    0x1(%eax),%edx
  800872:	89 55 10             	mov    %edx,0x10(%ebp)
  800875:	8a 00                	mov    (%eax),%al
  800877:	0f b6 d8             	movzbl %al,%ebx
  80087a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80087d:	83 f8 55             	cmp    $0x55,%eax
  800880:	0f 87 2b 03 00 00    	ja     800bb1 <vprintfmt+0x399>
  800886:	8b 04 85 d8 23 80 00 	mov    0x8023d8(,%eax,4),%eax
  80088d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80088f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800893:	eb d7                	jmp    80086c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800895:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800899:	eb d1                	jmp    80086c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	c1 e0 02             	shl    $0x2,%eax
  8008aa:	01 d0                	add    %edx,%eax
  8008ac:	01 c0                	add    %eax,%eax
  8008ae:	01 d8                	add    %ebx,%eax
  8008b0:	83 e8 30             	sub    $0x30,%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	8a 00                	mov    (%eax),%al
  8008bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008be:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c1:	7e 3e                	jle    800901 <vprintfmt+0xe9>
  8008c3:	83 fb 39             	cmp    $0x39,%ebx
  8008c6:	7f 39                	jg     800901 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008cb:	eb d5                	jmp    8008a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 c0 04             	add    $0x4,%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e1:	eb 1f                	jmp    800902 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e7:	79 83                	jns    80086c <vprintfmt+0x54>
				width = 0;
  8008e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f0:	e9 77 ff ff ff       	jmp    80086c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008fc:	e9 6b ff ff ff       	jmp    80086c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800901:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	0f 89 60 ff ff ff    	jns    80086c <vprintfmt+0x54>
				width = precision, precision = -1;
  80090c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800912:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800919:	e9 4e ff ff ff       	jmp    80086c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800921:	e9 46 ff ff ff       	jmp    80086c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	50                   	push   %eax
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			break;
  800946:	e9 89 02 00 00       	jmp    800bd4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 e8 04             	sub    $0x4,%eax
  80095a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80095c:	85 db                	test   %ebx,%ebx
  80095e:	79 02                	jns    800962 <vprintfmt+0x14a>
				err = -err;
  800960:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800962:	83 fb 64             	cmp    $0x64,%ebx
  800965:	7f 0b                	jg     800972 <vprintfmt+0x15a>
  800967:	8b 34 9d 20 22 80 00 	mov    0x802220(,%ebx,4),%esi
  80096e:	85 f6                	test   %esi,%esi
  800970:	75 19                	jne    80098b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800972:	53                   	push   %ebx
  800973:	68 c5 23 80 00       	push   $0x8023c5
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	ff 75 08             	pushl  0x8(%ebp)
  80097e:	e8 5e 02 00 00       	call   800be1 <printfmt>
  800983:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800986:	e9 49 02 00 00       	jmp    800bd4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098b:	56                   	push   %esi
  80098c:	68 ce 23 80 00       	push   $0x8023ce
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	ff 75 08             	pushl  0x8(%ebp)
  800997:	e8 45 02 00 00       	call   800be1 <printfmt>
  80099c:	83 c4 10             	add    $0x10,%esp
			break;
  80099f:	e9 30 02 00 00       	jmp    800bd4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 30                	mov    (%eax),%esi
  8009b5:	85 f6                	test   %esi,%esi
  8009b7:	75 05                	jne    8009be <vprintfmt+0x1a6>
				p = "(null)";
  8009b9:	be d1 23 80 00       	mov    $0x8023d1,%esi
			if (width > 0 && padc != '-')
  8009be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c2:	7e 6d                	jle    800a31 <vprintfmt+0x219>
  8009c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009c8:	74 67                	je     800a31 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	50                   	push   %eax
  8009d1:	56                   	push   %esi
  8009d2:	e8 0c 03 00 00       	call   800ce3 <strnlen>
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009dd:	eb 16                	jmp    8009f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	50                   	push   %eax
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	ff d0                	call   *%eax
  8009ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f9:	7f e4                	jg     8009df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fb:	eb 34                	jmp    800a31 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a01:	74 1c                	je     800a1f <vprintfmt+0x207>
  800a03:	83 fb 1f             	cmp    $0x1f,%ebx
  800a06:	7e 05                	jle    800a0d <vprintfmt+0x1f5>
  800a08:	83 fb 7e             	cmp    $0x7e,%ebx
  800a0b:	7e 12                	jle    800a1f <vprintfmt+0x207>
					putch('?', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 3f                	push   $0x3f
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	eb 0f                	jmp    800a2e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a31:	89 f0                	mov    %esi,%eax
  800a33:	8d 70 01             	lea    0x1(%eax),%esi
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	0f be d8             	movsbl %al,%ebx
  800a3b:	85 db                	test   %ebx,%ebx
  800a3d:	74 24                	je     800a63 <vprintfmt+0x24b>
  800a3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a43:	78 b8                	js     8009fd <vprintfmt+0x1e5>
  800a45:	ff 4d e0             	decl   -0x20(%ebp)
  800a48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4c:	79 af                	jns    8009fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4e:	eb 13                	jmp    800a63 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 20                	push   $0x20
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a60:	ff 4d e4             	decl   -0x1c(%ebp)
  800a63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a67:	7f e7                	jg     800a50 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a69:	e9 66 01 00 00       	jmp    800bd4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 e8             	pushl  -0x18(%ebp)
  800a74:	8d 45 14             	lea    0x14(%ebp),%eax
  800a77:	50                   	push   %eax
  800a78:	e8 3c fd ff ff       	call   8007b9 <getint>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8c:	85 d2                	test   %edx,%edx
  800a8e:	79 23                	jns    800ab3 <vprintfmt+0x29b>
				putch('-', putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	6a 2d                	push   $0x2d
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa6:	f7 d8                	neg    %eax
  800aa8:	83 d2 00             	adc    $0x0,%edx
  800aab:	f7 da                	neg    %edx
  800aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aba:	e9 bc 00 00 00       	jmp    800b7b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac8:	50                   	push   %eax
  800ac9:	e8 84 fc ff ff       	call   800752 <getuint>
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ad7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ade:	e9 98 00 00 00       	jmp    800b7b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	6a 58                	push   $0x58
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	ff d0                	call   *%eax
  800b00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	6a 58                	push   $0x58
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
			break;
  800b13:	e9 bc 00 00 00       	jmp    800bd4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	6a 30                	push   $0x30
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 78                	push   $0x78
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 c0 04             	add    $0x4,%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	83 e8 04             	sub    $0x4,%eax
  800b47:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b53:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b5a:	eb 1f                	jmp    800b7b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b62:	8d 45 14             	lea    0x14(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	e8 e7 fb ff ff       	call   800752 <getuint>
  800b6b:	83 c4 10             	add    $0x10,%esp
  800b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b7b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b82:	83 ec 04             	sub    $0x4,%esp
  800b85:	52                   	push   %edx
  800b86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b89:	50                   	push   %eax
  800b8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b90:	ff 75 0c             	pushl  0xc(%ebp)
  800b93:	ff 75 08             	pushl  0x8(%ebp)
  800b96:	e8 00 fb ff ff       	call   80069b <printnum>
  800b9b:	83 c4 20             	add    $0x20,%esp
			break;
  800b9e:	eb 34                	jmp    800bd4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	53                   	push   %ebx
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
			break;
  800baf:	eb 23                	jmp    800bd4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	6a 25                	push   $0x25
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc1:	ff 4d 10             	decl   0x10(%ebp)
  800bc4:	eb 03                	jmp    800bc9 <vprintfmt+0x3b1>
  800bc6:	ff 4d 10             	decl   0x10(%ebp)
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	48                   	dec    %eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	3c 25                	cmp    $0x25,%al
  800bd1:	75 f3                	jne    800bc6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd3:	90                   	nop
		}
	}
  800bd4:	e9 47 fc ff ff       	jmp    800820 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bd9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800be7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bea:	83 c0 04             	add    $0x4,%eax
  800bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf6:	50                   	push   %eax
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 08             	pushl  0x8(%ebp)
  800bfd:	e8 16 fc ff ff       	call   800818 <vprintfmt>
  800c02:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c05:	90                   	nop
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	8b 40 08             	mov    0x8(%eax),%eax
  800c11:	8d 50 01             	lea    0x1(%eax),%edx
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	8b 10                	mov    (%eax),%edx
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	8b 40 04             	mov    0x4(%eax),%eax
  800c25:	39 c2                	cmp    %eax,%edx
  800c27:	73 12                	jae    800c3b <sprintputch+0x33>
		*b->buf++ = ch;
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8b 00                	mov    (%eax),%eax
  800c2e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c34:	89 0a                	mov    %ecx,(%edx)
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	88 10                	mov    %dl,(%eax)
}
  800c3b:	90                   	nop
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c63:	74 06                	je     800c6b <vsnprintf+0x2d>
  800c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c69:	7f 07                	jg     800c72 <vsnprintf+0x34>
		return -E_INVAL;
  800c6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c70:	eb 20                	jmp    800c92 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c72:	ff 75 14             	pushl  0x14(%ebp)
  800c75:	ff 75 10             	pushl  0x10(%ebp)
  800c78:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c7b:	50                   	push   %eax
  800c7c:	68 08 0c 80 00       	push   $0x800c08
  800c81:	e8 92 fb ff ff       	call   800818 <vprintfmt>
  800c86:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c9a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9d:	83 c0 04             	add    $0x4,%eax
  800ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca9:	50                   	push   %eax
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	ff 75 08             	pushl  0x8(%ebp)
  800cb0:	e8 89 ff ff ff       	call   800c3e <vsnprintf>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccd:	eb 06                	jmp    800cd5 <strlen+0x15>
		n++;
  800ccf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd2:	ff 45 08             	incl   0x8(%ebp)
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	84 c0                	test   %al,%al
  800cdc:	75 f1                	jne    800ccf <strlen+0xf>
		n++;
	return n;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf0:	eb 09                	jmp    800cfb <strnlen+0x18>
		n++;
  800cf2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf5:	ff 45 08             	incl   0x8(%ebp)
  800cf8:	ff 4d 0c             	decl   0xc(%ebp)
  800cfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cff:	74 09                	je     800d0a <strnlen+0x27>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	75 e8                	jne    800cf2 <strnlen+0xf>
		n++;
	return n;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d1b:	90                   	nop
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8d 50 01             	lea    0x1(%eax),%edx
  800d22:	89 55 08             	mov    %edx,0x8(%ebp)
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2e:	8a 12                	mov    (%edx),%dl
  800d30:	88 10                	mov    %dl,(%eax)
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	75 e4                	jne    800d1c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d50:	eb 1f                	jmp    800d71 <strncpy+0x34>
		*dst++ = *src;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8d 50 01             	lea    0x1(%eax),%edx
  800d58:	89 55 08             	mov    %edx,0x8(%ebp)
  800d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5e:	8a 12                	mov    (%edx),%dl
  800d60:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 03                	je     800d6e <strncpy+0x31>
			src++;
  800d6b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d6e:	ff 45 fc             	incl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d77:	72 d9                	jb     800d52 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8e:	74 30                	je     800dc0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d90:	eb 16                	jmp    800da8 <strlcpy+0x2a>
			*dst++ = *src++;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8d 50 01             	lea    0x1(%eax),%edx
  800d98:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da4:	8a 12                	mov    (%edx),%dl
  800da6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800da8:	ff 4d 10             	decl   0x10(%ebp)
  800dab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daf:	74 09                	je     800dba <strlcpy+0x3c>
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	84 c0                	test   %al,%al
  800db8:	75 d8                	jne    800d92 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc6:	29 c2                	sub    %eax,%edx
  800dc8:	89 d0                	mov    %edx,%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dcf:	eb 06                	jmp    800dd7 <strcmp+0xb>
		p++, q++;
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	84 c0                	test   %al,%al
  800dde:	74 0e                	je     800dee <strcmp+0x22>
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 10                	mov    (%eax),%dl
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	38 c2                	cmp    %al,%dl
  800dec:	74 e3                	je     800dd1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 d0             	movzbl %al,%edx
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f b6 c0             	movzbl %al,%eax
  800dfe:	29 c2                	sub    %eax,%edx
  800e00:	89 d0                	mov    %edx,%eax
}
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e07:	eb 09                	jmp    800e12 <strncmp+0xe>
		n--, p++, q++;
  800e09:	ff 4d 10             	decl   0x10(%ebp)
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e16:	74 17                	je     800e2f <strncmp+0x2b>
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	84 c0                	test   %al,%al
  800e1f:	74 0e                	je     800e2f <strncmp+0x2b>
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 10                	mov    (%eax),%dl
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	38 c2                	cmp    %al,%dl
  800e2d:	74 da                	je     800e09 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e33:	75 07                	jne    800e3c <strncmp+0x38>
		return 0;
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	eb 14                	jmp    800e50 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f b6 d0             	movzbl %al,%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f b6 c0             	movzbl %al,%eax
  800e4c:	29 c2                	sub    %eax,%edx
  800e4e:	89 d0                	mov    %edx,%eax
}
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 04             	sub    $0x4,%esp
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5e:	eb 12                	jmp    800e72 <strchr+0x20>
		if (*s == c)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e68:	75 05                	jne    800e6f <strchr+0x1d>
			return (char *) s;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	eb 11                	jmp    800e80 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e6f:	ff 45 08             	incl   0x8(%ebp)
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	84 c0                	test   %al,%al
  800e79:	75 e5                	jne    800e60 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 04             	sub    $0x4,%esp
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8e:	eb 0d                	jmp    800e9d <strfind+0x1b>
		if (*s == c)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e98:	74 0e                	je     800ea8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e9a:	ff 45 08             	incl   0x8(%ebp)
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 ea                	jne    800e90 <strfind+0xe>
  800ea6:	eb 01                	jmp    800ea9 <strfind+0x27>
		if (*s == c)
			break;
  800ea8:	90                   	nop
	return (char *) s;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec0:	eb 0e                	jmp    800ed0 <memset+0x22>
		*p++ = c;
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ece:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed0:	ff 4d f8             	decl   -0x8(%ebp)
  800ed3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ed7:	79 e9                	jns    800ec2 <memset+0x14>
		*p++ = c;

	return v;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef0:	eb 16                	jmp    800f08 <memcpy+0x2a>
		*d++ = *s++;
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	8d 50 01             	lea    0x1(%eax),%edx
  800ef8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800efb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800efe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f01:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f04:	8a 12                	mov    (%edx),%dl
  800f06:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	75 dd                	jne    800ef2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f32:	73 50                	jae    800f84 <memmove+0x6a>
  800f34:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	01 d0                	add    %edx,%eax
  800f3c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f3f:	76 43                	jbe    800f84 <memmove+0x6a>
		s += n;
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f4d:	eb 10                	jmp    800f5f <memmove+0x45>
			*--d = *--s;
  800f4f:	ff 4d f8             	decl   -0x8(%ebp)
  800f52:	ff 4d fc             	decl   -0x4(%ebp)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 e3                	jne    800f4f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f6c:	eb 23                	jmp    800f91 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f71:	8d 50 01             	lea    0x1(%eax),%edx
  800f74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f80:	8a 12                	mov    (%edx),%dl
  800f82:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	75 dd                	jne    800f6e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fa8:	eb 2a                	jmp    800fd4 <memcmp+0x3e>
		if (*s1 != *s2)
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	8a 10                	mov    (%eax),%dl
  800faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	38 c2                	cmp    %al,%dl
  800fb6:	74 16                	je     800fce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f b6 d0             	movzbl %al,%edx
  800fc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f b6 c0             	movzbl %al,%eax
  800fc8:	29 c2                	sub    %eax,%edx
  800fca:	89 d0                	mov    %edx,%eax
  800fcc:	eb 18                	jmp    800fe6 <memcmp+0x50>
		s1++, s2++;
  800fce:	ff 45 fc             	incl   -0x4(%ebp)
  800fd1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fda:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	75 c9                	jne    800faa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff4:	01 d0                	add    %edx,%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ff9:	eb 15                	jmp    801010 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 d0             	movzbl %al,%edx
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	0f b6 c0             	movzbl %al,%eax
  801009:	39 c2                	cmp    %eax,%edx
  80100b:	74 0d                	je     80101a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801016:	72 e3                	jb     800ffb <memfind+0x13>
  801018:	eb 01                	jmp    80101b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80101a:	90                   	nop
	return (void *) s;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80102d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801034:	eb 03                	jmp    801039 <strtol+0x19>
		s++;
  801036:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 20                	cmp    $0x20,%al
  801040:	74 f4                	je     801036 <strtol+0x16>
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 09                	cmp    $0x9,%al
  801049:	74 eb                	je     801036 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2b                	cmp    $0x2b,%al
  801052:	75 05                	jne    801059 <strtol+0x39>
		s++;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	eb 13                	jmp    80106c <strtol+0x4c>
	else if (*s == '-')
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 2d                	cmp    $0x2d,%al
  801060:	75 0a                	jne    80106c <strtol+0x4c>
		s++, neg = 1;
  801062:	ff 45 08             	incl   0x8(%ebp)
  801065:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 06                	je     801078 <strtol+0x58>
  801072:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801076:	75 20                	jne    801098 <strtol+0x78>
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3c 30                	cmp    $0x30,%al
  80107f:	75 17                	jne    801098 <strtol+0x78>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	40                   	inc    %eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 78                	cmp    $0x78,%al
  801089:	75 0d                	jne    801098 <strtol+0x78>
		s += 2, base = 16;
  80108b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80108f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801096:	eb 28                	jmp    8010c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801098:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109c:	75 15                	jne    8010b3 <strtol+0x93>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 30                	cmp    $0x30,%al
  8010a5:	75 0c                	jne    8010b3 <strtol+0x93>
		s++, base = 8;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b1:	eb 0d                	jmp    8010c0 <strtol+0xa0>
	else if (base == 0)
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	75 07                	jne    8010c0 <strtol+0xa0>
		base = 10;
  8010b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 2f                	cmp    $0x2f,%al
  8010c7:	7e 19                	jle    8010e2 <strtol+0xc2>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 39                	cmp    $0x39,%al
  8010d0:	7f 10                	jg     8010e2 <strtol+0xc2>
			dig = *s - '0';
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be c0             	movsbl %al,%eax
  8010da:	83 e8 30             	sub    $0x30,%eax
  8010dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e0:	eb 42                	jmp    801124 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 60                	cmp    $0x60,%al
  8010e9:	7e 19                	jle    801104 <strtol+0xe4>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 7a                	cmp    $0x7a,%al
  8010f2:	7f 10                	jg     801104 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be c0             	movsbl %al,%eax
  8010fc:	83 e8 57             	sub    $0x57,%eax
  8010ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801102:	eb 20                	jmp    801124 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 40                	cmp    $0x40,%al
  80110b:	7e 39                	jle    801146 <strtol+0x126>
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 5a                	cmp    $0x5a,%al
  801114:	7f 30                	jg     801146 <strtol+0x126>
			dig = *s - 'A' + 10;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	83 e8 37             	sub    $0x37,%eax
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	3b 45 10             	cmp    0x10(%ebp),%eax
  80112a:	7d 19                	jge    801145 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80112c:	ff 45 08             	incl   0x8(%ebp)
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	0f af 45 10          	imul   0x10(%ebp),%eax
  801136:	89 c2                	mov    %eax,%edx
  801138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801140:	e9 7b ff ff ff       	jmp    8010c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801145:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801146:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114a:	74 08                	je     801154 <strtol+0x134>
		*endptr = (char *) s;
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801154:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801158:	74 07                	je     801161 <strtol+0x141>
  80115a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115d:	f7 d8                	neg    %eax
  80115f:	eb 03                	jmp    801164 <strtol+0x144>
  801161:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <ltostr>:

void
ltostr(long value, char *str)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80116c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801173:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80117a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117e:	79 13                	jns    801193 <ltostr+0x2d>
	{
		neg = 1;
  801180:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80118d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801190:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80119b:	99                   	cltd   
  80119c:	f7 f9                	idiv   %ecx
  80119e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	8d 50 01             	lea    0x1(%eax),%edx
  8011a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	01 d0                	add    %edx,%eax
  8011b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b4:	83 c2 30             	add    $0x30,%edx
  8011b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c1:	f7 e9                	imul   %ecx
  8011c3:	c1 fa 02             	sar    $0x2,%edx
  8011c6:	89 c8                	mov    %ecx,%eax
  8011c8:	c1 f8 1f             	sar    $0x1f,%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011da:	f7 e9                	imul   %ecx
  8011dc:	c1 fa 02             	sar    $0x2,%edx
  8011df:	89 c8                	mov    %ecx,%eax
  8011e1:	c1 f8 1f             	sar    $0x1f,%eax
  8011e4:	29 c2                	sub    %eax,%edx
  8011e6:	89 d0                	mov    %edx,%eax
  8011e8:	c1 e0 02             	shl    $0x2,%eax
  8011eb:	01 d0                	add    %edx,%eax
  8011ed:	01 c0                	add    %eax,%eax
  8011ef:	29 c1                	sub    %eax,%ecx
  8011f1:	89 ca                	mov    %ecx,%edx
  8011f3:	85 d2                	test   %edx,%edx
  8011f5:	75 9c                	jne    801193 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801201:	48                   	dec    %eax
  801202:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801205:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801209:	74 3d                	je     801248 <ltostr+0xe2>
		start = 1 ;
  80120b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801212:	eb 34                	jmp    801248 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	01 c2                	add    %eax,%edx
  801229:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c8                	add    %ecx,%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801235:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	01 c2                	add    %eax,%edx
  80123d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801240:	88 02                	mov    %al,(%edx)
		start++ ;
  801242:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801245:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80124e:	7c c4                	jl     801214 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801250:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80125b:	90                   	nop
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801264:	ff 75 08             	pushl  0x8(%ebp)
  801267:	e8 54 fa ff ff       	call   800cc0 <strlen>
  80126c:	83 c4 04             	add    $0x4,%esp
  80126f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801272:	ff 75 0c             	pushl  0xc(%ebp)
  801275:	e8 46 fa ff ff       	call   800cc0 <strlen>
  80127a:	83 c4 04             	add    $0x4,%esp
  80127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80128e:	eb 17                	jmp    8012a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801290:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	01 c2                	add    %eax,%edx
  801298:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	01 c8                	add    %ecx,%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012a4:	ff 45 fc             	incl   -0x4(%ebp)
  8012a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ad:	7c e1                	jl     801290 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012bd:	eb 1f                	jmp    8012de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c2:	8d 50 01             	lea    0x1(%eax),%edx
  8012c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012c8:	89 c2                	mov    %eax,%edx
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	01 c2                	add    %eax,%edx
  8012cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 c8                	add    %ecx,%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012db:	ff 45 f8             	incl   -0x8(%ebp)
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e4:	7c d9                	jl     8012bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f1:	90                   	nop
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801300:	8b 45 14             	mov    0x14(%ebp),%eax
  801303:	8b 00                	mov    (%eax),%eax
  801305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130c:	8b 45 10             	mov    0x10(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801317:	eb 0c                	jmp    801325 <strsplit+0x31>
			*string++ = 0;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8d 50 01             	lea    0x1(%eax),%edx
  80131f:	89 55 08             	mov    %edx,0x8(%ebp)
  801322:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 18                	je     801346 <strsplit+0x52>
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	0f be c0             	movsbl %al,%eax
  801336:	50                   	push   %eax
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	e8 13 fb ff ff       	call   800e52 <strchr>
  80133f:	83 c4 08             	add    $0x8,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	75 d3                	jne    801319 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	84 c0                	test   %al,%al
  80134d:	74 5a                	je     8013a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80134f:	8b 45 14             	mov    0x14(%ebp),%eax
  801352:	8b 00                	mov    (%eax),%eax
  801354:	83 f8 0f             	cmp    $0xf,%eax
  801357:	75 07                	jne    801360 <strsplit+0x6c>
		{
			return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
  80135e:	eb 66                	jmp    8013c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 48 01             	lea    0x1(%eax),%ecx
  801368:	8b 55 14             	mov    0x14(%ebp),%edx
  80136b:	89 0a                	mov    %ecx,(%edx)
  80136d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801374:	8b 45 10             	mov    0x10(%ebp),%eax
  801377:	01 c2                	add    %eax,%edx
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80137e:	eb 03                	jmp    801383 <strsplit+0x8f>
			string++;
  801380:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	84 c0                	test   %al,%al
  80138a:	74 8b                	je     801317 <strsplit+0x23>
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	0f be c0             	movsbl %al,%eax
  801394:	50                   	push   %eax
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	e8 b5 fa ff ff       	call   800e52 <strchr>
  80139d:	83 c4 08             	add    $0x8,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	74 dc                	je     801380 <strsplit+0x8c>
			string++;
	}
  8013a4:	e9 6e ff ff ff       	jmp    801317 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ad:	8b 00                	mov    (%eax),%eax
  8013af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8013ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d5:	eb 4c                	jmp    801423 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8013d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 40                	cmp    $0x40,%al
  8013e3:	7e 27                	jle    80140c <str2lower+0x44>
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	3c 5a                	cmp    $0x5a,%al
  8013f1:	7f 19                	jg     80140c <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8013f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	01 d0                	add    %edx,%eax
  8013fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801401:	01 ca                	add    %ecx,%edx
  801403:	8a 12                	mov    (%edx),%dl
  801405:	83 c2 20             	add    $0x20,%edx
  801408:	88 10                	mov    %dl,(%eax)
  80140a:	eb 14                	jmp    801420 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80140c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	01 c2                	add    %eax,%edx
  801414:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 c8                	add    %ecx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801420:	ff 45 fc             	incl   -0x4(%ebp)
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	e8 95 f8 ff ff       	call   800cc0 <strlen>
  80142b:	83 c4 04             	add    $0x4,%esp
  80142e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801431:	7f a4                	jg     8013d7 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801433:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801455:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801458:	8b 7d 18             	mov    0x18(%ebp),%edi
  80145b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80145e:	cd 30                	int    $0x30
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	5b                   	pop    %ebx
  80146a:	5e                   	pop    %esi
  80146b:	5f                   	pop    %edi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80147a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	52                   	push   %edx
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	50                   	push   %eax
  80148a:	6a 00                	push   $0x0
  80148c:	e8 b2 ff ff ff       	call   801443 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
}
  801494:	90                   	nop
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_cgetc>:

int
sys_cgetc(void)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 01                	push   $0x1
  8014a6:	e8 98 ff ff ff       	call   801443 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	52                   	push   %edx
  8014c0:	50                   	push   %eax
  8014c1:	6a 05                	push   $0x5
  8014c3:	e8 7b ff ff ff       	call   801443 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8014d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	56                   	push   %esi
  8014e2:	53                   	push   %ebx
  8014e3:	51                   	push   %ecx
  8014e4:	52                   	push   %edx
  8014e5:	50                   	push   %eax
  8014e6:	6a 06                	push   $0x6
  8014e8:	e8 56 ff ff ff       	call   801443 <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 07                	push   $0x7
  80150a:	e8 34 ff ff ff       	call   801443 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	6a 08                	push   $0x8
  801525:	e8 19 ff ff ff       	call   801443 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 09                	push   $0x9
  80153e:	e8 00 ff ff ff       	call   801443 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 0a                	push   $0xa
  801557:	e8 e7 fe ff ff       	call   801443 <syscall>
  80155c:	83 c4 18             	add    $0x18,%esp
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 0b                	push   $0xb
  801570:	e8 ce fe ff ff       	call   801443 <syscall>
  801575:	83 c4 18             	add    $0x18,%esp
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 0c                	push   $0xc
  801589:	e8 b5 fe ff ff       	call   801443 <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	6a 0d                	push   $0xd
  8015a3:	e8 9b fe ff ff       	call   801443 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 0e                	push   $0xe
  8015bc:	e8 82 fe ff ff       	call   801443 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 11                	push   $0x11
  8015d6:	e8 68 fe ff ff       	call   801443 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 12                	push   $0x12
  8015f0:	e8 4e fe ff ff       	call   801443 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	90                   	nop
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <sys_cputc>:


void
sys_cputc(const char c)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801607:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	50                   	push   %eax
  801614:	6a 13                	push   $0x13
  801616:	e8 28 fe ff ff       	call   801443 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 14                	push   $0x14
  801630:	e8 0e fe ff ff       	call   801443 <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	50                   	push   %eax
  80164b:	6a 15                	push   $0x15
  80164d:	e8 f1 fd ff ff       	call   801443 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	52                   	push   %edx
  801667:	50                   	push   %eax
  801668:	6a 18                	push   $0x18
  80166a:	e8 d4 fd ff ff       	call   801443 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	52                   	push   %edx
  801684:	50                   	push   %eax
  801685:	6a 16                	push   $0x16
  801687:	e8 b7 fd ff ff       	call   801443 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801695:	8b 55 0c             	mov    0xc(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 17                	push   $0x17
  8016a5:	e8 99 fd ff ff       	call   801443 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	90                   	nop
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016bc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	51                   	push   %ecx
  8016c9:	52                   	push   %edx
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	50                   	push   %eax
  8016ce:	6a 19                	push   $0x19
  8016d0:	e8 6e fd ff ff       	call   801443 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	6a 1a                	push   $0x1a
  8016ed:	e8 51 fd ff ff       	call   801443 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	51                   	push   %ecx
  801708:	52                   	push   %edx
  801709:	50                   	push   %eax
  80170a:	6a 1b                	push   $0x1b
  80170c:	e8 32 fd ff ff       	call   801443 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	6a 1c                	push   $0x1c
  801729:	e8 15 fd ff ff       	call   801443 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 1d                	push   $0x1d
  801742:	e8 fc fc ff ff       	call   801443 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	6a 00                	push   $0x0
  801754:	ff 75 14             	pushl  0x14(%ebp)
  801757:	ff 75 10             	pushl  0x10(%ebp)
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	50                   	push   %eax
  80175e:	6a 1e                	push   $0x1e
  801760:	e8 de fc ff ff       	call   801443 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	50                   	push   %eax
  801779:	6a 1f                	push   $0x1f
  80177b:	e8 c3 fc ff ff       	call   801443 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	50                   	push   %eax
  801795:	6a 20                	push   $0x20
  801797:	e8 a7 fc ff ff       	call   801443 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 02                	push   $0x2
  8017b0:	e8 8e fc ff ff       	call   801443 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 03                	push   $0x3
  8017c9:	e8 75 fc ff ff       	call   801443 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 04                	push   $0x4
  8017e2:	e8 5c fc ff ff       	call   801443 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_exit_env>:


void sys_exit_env(void)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 21                	push   $0x21
  8017fb:	e8 43 fc ff ff       	call   801443 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80180c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80180f:	8d 50 04             	lea    0x4(%eax),%edx
  801812:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 22                	push   $0x22
  80181f:	e8 1f fc ff ff       	call   801443 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return result;
  801827:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801830:	89 01                	mov    %eax,(%ecx)
  801832:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	c9                   	leave  
  801839:	c2 04 00             	ret    $0x4

0080183c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 10             	pushl  0x10(%ebp)
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 10                	push   $0x10
  80184e:	e8 f0 fb ff ff       	call   801443 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_rcr2>:
uint32 sys_rcr2()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 23                	push   $0x23
  801868:	e8 d6 fb ff ff       	call   801443 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80187e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	50                   	push   %eax
  80188b:	6a 24                	push   $0x24
  80188d:	e8 b1 fb ff ff       	call   801443 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
	return ;
  801895:	90                   	nop
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <rsttst>:
void rsttst()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 26                	push   $0x26
  8018a7:	e8 97 fb ff ff       	call   801443 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8018af:	90                   	nop
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018be:	8b 55 18             	mov    0x18(%ebp),%edx
  8018c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	ff 75 10             	pushl  0x10(%ebp)
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 25                	push   $0x25
  8018d2:	e8 6c fb ff ff       	call   801443 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018da:	90                   	nop
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <chktst>:
void chktst(uint32 n)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	6a 27                	push   $0x27
  8018ed:	e8 51 fb ff ff       	call   801443 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f5:	90                   	nop
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <inctst>:

void inctst()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 28                	push   $0x28
  801907:	e8 37 fb ff ff       	call   801443 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
	return ;
  80190f:	90                   	nop
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <gettst>:
uint32 gettst()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 29                	push   $0x29
  801921:	e8 1d fb ff ff       	call   801443 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 2a                	push   $0x2a
  80193d:	e8 01 fb ff ff       	call   801443 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
  801945:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801948:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80194c:	75 07                	jne    801955 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80194e:	b8 01 00 00 00       	mov    $0x1,%eax
  801953:	eb 05                	jmp    80195a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 2a                	push   $0x2a
  80196e:	e8 d0 fa ff ff       	call   801443 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
  801976:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801979:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80197d:	75 07                	jne    801986 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80197f:	b8 01 00 00 00       	mov    $0x1,%eax
  801984:	eb 05                	jmp    80198b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 2a                	push   $0x2a
  80199f:	e8 9f fa ff ff       	call   801443 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
  8019a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019aa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019ae:	75 07                	jne    8019b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b5:	eb 05                	jmp    8019bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 2a                	push   $0x2a
  8019d0:	e8 6e fa ff ff       	call   801443 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
  8019d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019db:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019df:	75 07                	jne    8019e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e6:	eb 05                	jmp    8019ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 2b                	push   $0x2b
  8019ff:	e8 3f fa ff ff       	call   801443 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
	return ;
  801a07:	90                   	nop
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	53                   	push   %ebx
  801a1d:	51                   	push   %ecx
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 2c                	push   $0x2c
  801a22:	e8 1c fa ff ff       	call   801443 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	52                   	push   %edx
  801a3f:	50                   	push   %eax
  801a40:	6a 2d                	push   $0x2d
  801a42:	e8 fc f9 ff ff       	call   801443 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	51                   	push   %ecx
  801a5b:	ff 75 10             	pushl  0x10(%ebp)
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 2e                	push   $0x2e
  801a62:	e8 dc f9 ff ff       	call   801443 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 10             	pushl  0x10(%ebp)
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 0f                	push   $0xf
  801a7e:	e8 c0 f9 ff ff       	call   801443 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return ;
  801a86:	90                   	nop
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	50                   	push   %eax
  801a98:	6a 2f                	push   $0x2f
  801a9a:	e8 a4 f9 ff ff       	call   801443 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp

}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	6a 30                	push   $0x30
  801ab5:	e8 89 f9 ff ff       	call   801443 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp

}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 31                	push   $0x31
  801ad1:	e8 6d f9 ff ff       	call   801443 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp

}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_hard_limit>:
uint32 sys_hard_limit(){
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 32                	push   $0x32
  801aeb:	e8 53 f9 ff ff       	call   801443 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    
  801af5:	66 90                	xchg   %ax,%ax
  801af7:	90                   	nop

00801af8 <__udivdi3>:
  801af8:	55                   	push   %ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b0f:	89 ca                	mov    %ecx,%edx
  801b11:	89 f8                	mov    %edi,%eax
  801b13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b17:	85 f6                	test   %esi,%esi
  801b19:	75 2d                	jne    801b48 <__udivdi3+0x50>
  801b1b:	39 cf                	cmp    %ecx,%edi
  801b1d:	77 65                	ja     801b84 <__udivdi3+0x8c>
  801b1f:	89 fd                	mov    %edi,%ebp
  801b21:	85 ff                	test   %edi,%edi
  801b23:	75 0b                	jne    801b30 <__udivdi3+0x38>
  801b25:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	f7 f7                	div    %edi
  801b2e:	89 c5                	mov    %eax,%ebp
  801b30:	31 d2                	xor    %edx,%edx
  801b32:	89 c8                	mov    %ecx,%eax
  801b34:	f7 f5                	div    %ebp
  801b36:	89 c1                	mov    %eax,%ecx
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	f7 f5                	div    %ebp
  801b3c:	89 cf                	mov    %ecx,%edi
  801b3e:	89 fa                	mov    %edi,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	39 ce                	cmp    %ecx,%esi
  801b4a:	77 28                	ja     801b74 <__udivdi3+0x7c>
  801b4c:	0f bd fe             	bsr    %esi,%edi
  801b4f:	83 f7 1f             	xor    $0x1f,%edi
  801b52:	75 40                	jne    801b94 <__udivdi3+0x9c>
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	72 0a                	jb     801b62 <__udivdi3+0x6a>
  801b58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b5c:	0f 87 9e 00 00 00    	ja     801c00 <__udivdi3+0x108>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	89 fa                	mov    %edi,%edx
  801b69:	83 c4 1c             	add    $0x1c,%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5e                   	pop    %esi
  801b6e:	5f                   	pop    %edi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    
  801b71:	8d 76 00             	lea    0x0(%esi),%esi
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	31 c0                	xor    %eax,%eax
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	83 c4 1c             	add    $0x1c,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	f7 f7                	div    %edi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	89 fa                	mov    %edi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b99:	89 eb                	mov    %ebp,%ebx
  801b9b:	29 fb                	sub    %edi,%ebx
  801b9d:	89 f9                	mov    %edi,%ecx
  801b9f:	d3 e6                	shl    %cl,%esi
  801ba1:	89 c5                	mov    %eax,%ebp
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 ed                	shr    %cl,%ebp
  801ba7:	89 e9                	mov    %ebp,%ecx
  801ba9:	09 f1                	or     %esi,%ecx
  801bab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801baf:	89 f9                	mov    %edi,%ecx
  801bb1:	d3 e0                	shl    %cl,%eax
  801bb3:	89 c5                	mov    %eax,%ebp
  801bb5:	89 d6                	mov    %edx,%esi
  801bb7:	88 d9                	mov    %bl,%cl
  801bb9:	d3 ee                	shr    %cl,%esi
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e2                	shl    %cl,%edx
  801bbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 e8                	shr    %cl,%eax
  801bc7:	09 c2                	or     %eax,%edx
  801bc9:	89 d0                	mov    %edx,%eax
  801bcb:	89 f2                	mov    %esi,%edx
  801bcd:	f7 74 24 0c          	divl   0xc(%esp)
  801bd1:	89 d6                	mov    %edx,%esi
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	f7 e5                	mul    %ebp
  801bd7:	39 d6                	cmp    %edx,%esi
  801bd9:	72 19                	jb     801bf4 <__udivdi3+0xfc>
  801bdb:	74 0b                	je     801be8 <__udivdi3+0xf0>
  801bdd:	89 d8                	mov    %ebx,%eax
  801bdf:	31 ff                	xor    %edi,%edi
  801be1:	e9 58 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bec:	89 f9                	mov    %edi,%ecx
  801bee:	d3 e2                	shl    %cl,%edx
  801bf0:	39 c2                	cmp    %eax,%edx
  801bf2:	73 e9                	jae    801bdd <__udivdi3+0xe5>
  801bf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bf7:	31 ff                	xor    %edi,%edi
  801bf9:	e9 40 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	31 c0                	xor    %eax,%eax
  801c02:	e9 37 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801c07:	90                   	nop

00801c08 <__umoddi3>:
  801c08:	55                   	push   %ebp
  801c09:	57                   	push   %edi
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 1c             	sub    $0x1c,%esp
  801c0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c27:	89 f3                	mov    %esi,%ebx
  801c29:	89 fa                	mov    %edi,%edx
  801c2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2f:	89 34 24             	mov    %esi,(%esp)
  801c32:	85 c0                	test   %eax,%eax
  801c34:	75 1a                	jne    801c50 <__umoddi3+0x48>
  801c36:	39 f7                	cmp    %esi,%edi
  801c38:	0f 86 a2 00 00 00    	jbe    801ce0 <__umoddi3+0xd8>
  801c3e:	89 c8                	mov    %ecx,%eax
  801c40:	89 f2                	mov    %esi,%edx
  801c42:	f7 f7                	div    %edi
  801c44:	89 d0                	mov    %edx,%eax
  801c46:	31 d2                	xor    %edx,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 f0                	cmp    %esi,%eax
  801c52:	0f 87 ac 00 00 00    	ja     801d04 <__umoddi3+0xfc>
  801c58:	0f bd e8             	bsr    %eax,%ebp
  801c5b:	83 f5 1f             	xor    $0x1f,%ebp
  801c5e:	0f 84 ac 00 00 00    	je     801d10 <__umoddi3+0x108>
  801c64:	bf 20 00 00 00       	mov    $0x20,%edi
  801c69:	29 ef                	sub    %ebp,%edi
  801c6b:	89 fe                	mov    %edi,%esi
  801c6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c71:	89 e9                	mov    %ebp,%ecx
  801c73:	d3 e0                	shl    %cl,%eax
  801c75:	89 d7                	mov    %edx,%edi
  801c77:	89 f1                	mov    %esi,%ecx
  801c79:	d3 ef                	shr    %cl,%edi
  801c7b:	09 c7                	or     %eax,%edi
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e2                	shl    %cl,%edx
  801c81:	89 14 24             	mov    %edx,(%esp)
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	d3 e0                	shl    %cl,%eax
  801c88:	89 c2                	mov    %eax,%edx
  801c8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c8e:	d3 e0                	shl    %cl,%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c98:	89 f1                	mov    %esi,%ecx
  801c9a:	d3 e8                	shr    %cl,%eax
  801c9c:	09 d0                	or     %edx,%eax
  801c9e:	d3 eb                	shr    %cl,%ebx
  801ca0:	89 da                	mov    %ebx,%edx
  801ca2:	f7 f7                	div    %edi
  801ca4:	89 d3                	mov    %edx,%ebx
  801ca6:	f7 24 24             	mull   (%esp)
  801ca9:	89 c6                	mov    %eax,%esi
  801cab:	89 d1                	mov    %edx,%ecx
  801cad:	39 d3                	cmp    %edx,%ebx
  801caf:	0f 82 87 00 00 00    	jb     801d3c <__umoddi3+0x134>
  801cb5:	0f 84 91 00 00 00    	je     801d4c <__umoddi3+0x144>
  801cbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cbf:	29 f2                	sub    %esi,%edx
  801cc1:	19 cb                	sbb    %ecx,%ebx
  801cc3:	89 d8                	mov    %ebx,%eax
  801cc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cc9:	d3 e0                	shl    %cl,%eax
  801ccb:	89 e9                	mov    %ebp,%ecx
  801ccd:	d3 ea                	shr    %cl,%edx
  801ccf:	09 d0                	or     %edx,%eax
  801cd1:	89 e9                	mov    %ebp,%ecx
  801cd3:	d3 eb                	shr    %cl,%ebx
  801cd5:	89 da                	mov    %ebx,%edx
  801cd7:	83 c4 1c             	add    $0x1c,%esp
  801cda:	5b                   	pop    %ebx
  801cdb:	5e                   	pop    %esi
  801cdc:	5f                   	pop    %edi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    
  801cdf:	90                   	nop
  801ce0:	89 fd                	mov    %edi,%ebp
  801ce2:	85 ff                	test   %edi,%edi
  801ce4:	75 0b                	jne    801cf1 <__umoddi3+0xe9>
  801ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f7                	div    %edi
  801cef:	89 c5                	mov    %eax,%ebp
  801cf1:	89 f0                	mov    %esi,%eax
  801cf3:	31 d2                	xor    %edx,%edx
  801cf5:	f7 f5                	div    %ebp
  801cf7:	89 c8                	mov    %ecx,%eax
  801cf9:	f7 f5                	div    %ebp
  801cfb:	89 d0                	mov    %edx,%eax
  801cfd:	e9 44 ff ff ff       	jmp    801c46 <__umoddi3+0x3e>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	89 c8                	mov    %ecx,%eax
  801d06:	89 f2                	mov    %esi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	3b 04 24             	cmp    (%esp),%eax
  801d13:	72 06                	jb     801d1b <__umoddi3+0x113>
  801d15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d19:	77 0f                	ja     801d2a <__umoddi3+0x122>
  801d1b:	89 f2                	mov    %esi,%edx
  801d1d:	29 f9                	sub    %edi,%ecx
  801d1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d23:	89 14 24             	mov    %edx,(%esp)
  801d26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d2e:	8b 14 24             	mov    (%esp),%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d 76 00             	lea    0x0(%esi),%esi
  801d3c:	2b 04 24             	sub    (%esp),%eax
  801d3f:	19 fa                	sbb    %edi,%edx
  801d41:	89 d1                	mov    %edx,%ecx
  801d43:	89 c6                	mov    %eax,%esi
  801d45:	e9 71 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d50:	72 ea                	jb     801d3c <__umoddi3+0x134>
  801d52:	89 d9                	mov    %ebx,%ecx
  801d54:	e9 62 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
