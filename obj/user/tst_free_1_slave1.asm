
obj/user/tst_free_1_slave1:     file format elf32-i386


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
  800031:	e8 a7 02 00 00       	call   8002dd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 40 80 00       	mov    0x804020,%eax
  800048:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  80004e:	a1 20 40 80 00       	mov    0x804020,%eax
  800053:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 2e 80 00       	push   $0x802ec0
  800065:	6a 14                	push   $0x14
  800067:	68 dc 2e 80 00       	push   $0x802edc
  80006c:	e8 a3 03 00 00       	call   800414 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 ee 19 00 00       	call   801aaf <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 31 1a 00 00       	call   801afa <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 e2 15 00 00       	call   8016bf <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 f8 2e 80 00       	push   $0x802ef8
  8000f9:	6a 33                	push   $0x33
  8000fb:	68 dc 2e 80 00       	push   $0x802edc
  800100:	e8 0f 03 00 00       	call   800414 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 f0 19 00 00       	call   801afa <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 2f 80 00       	push   $0x802f28
  800117:	6a 34                	push   $0x34
  800119:	68 dc 2e 80 00       	push   $0x802edc
  80011e:	e8 f1 02 00 00       	call   800414 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 87 19 00 00       	call   801aaf <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 4b 19 00 00       	call   801aaf <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 58 2f 80 00       	push   $0x802f58
  800181:	6a 3e                	push   $0x3e
  800183:	68 dc 2e 80 00       	push   $0x802edc
  800188:	e8 87 02 00 00       	call   800414 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 00 1e 00 00       	call   801fcc <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 2f 80 00       	push   $0x802fd4
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 dc 2e 80 00       	push   $0x802edc
  8001e7:	e8 28 02 00 00       	call   800414 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 be 18 00 00       	call   801aaf <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 01 19 00 00       	call   801afa <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 14 16 00 00       	call   80181f <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 e7 18 00 00       	call   801afa <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 2f 80 00       	push   $0x802ff4
  800220:	6a 4f                	push   $0x4f
  800222:	68 dc 2e 80 00       	push   $0x802edc
  800227:	e8 e8 01 00 00       	call   800414 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 7e 18 00 00       	call   801aaf <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 30 30 80 00       	push   $0x803030
  800247:	6a 50                	push   $0x50
  800249:	68 dc 2e 80 00       	push   $0x802edc
  80024e:	e8 c1 01 00 00       	call   800414 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 3a 1d 00 00       	call   801fcc <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 30 80 00       	push   $0x80307c
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 dc 2e 80 00       	push   $0x802edc
  8002ad:	e8 62 01 00 00       	call   800414 <_panic>
		}
	}

	//Test accessing a freed area but NOT ACCESSED Before (processes should be killed by the validation of the fault handler)
	{
		byteArr[8*kilo] = minByte ;
  8002b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b5:	c1 e0 03             	shl    $0x3,%eax
  8002b8:	89 c2                	mov    %eax,%edx
  8002ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002bd:	01 c2                	add    %eax,%edx
  8002bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8002c2:	88 02                	mov    %al,(%edx)
		inctst();
  8002c4:	e8 af 1b 00 00       	call   801e78 <inctst>
		panic("tst_free_1_slave2 failed: The env must be killed and shouldn't return here.");
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	68 a0 30 80 00       	push   $0x8030a0
  8002d1:	6a 5b                	push   $0x5b
  8002d3:	68 dc 2e 80 00       	push   $0x802edc
  8002d8:	e8 37 01 00 00       	call   800414 <_panic>

008002dd <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002e3:	e8 52 1a 00 00       	call   801d3a <sys_getenvindex>
  8002e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ee:	89 d0                	mov    %edx,%eax
  8002f0:	c1 e0 03             	shl    $0x3,%eax
  8002f3:	01 d0                	add    %edx,%eax
  8002f5:	01 c0                	add    %eax,%eax
  8002f7:	01 d0                	add    %edx,%eax
  8002f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800300:	01 d0                	add    %edx,%eax
  800302:	c1 e0 04             	shl    $0x4,%eax
  800305:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80030a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8a 40 5c             	mov    0x5c(%eax),%al
  800317:	84 c0                	test   %al,%al
  800319:	74 0d                	je     800328 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80031b:	a1 20 40 80 00       	mov    0x804020,%eax
  800320:	83 c0 5c             	add    $0x5c,%eax
  800323:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032c:	7e 0a                	jle    800338 <libmain+0x5b>
		binaryname = argv[0];
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	e8 f2 fc ff ff       	call   800038 <_main>
  800346:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800349:	e8 f9 17 00 00       	call   801b47 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 04 31 80 00       	push   $0x803104
  800356:	e8 76 03 00 00       	call   8006d1 <cprintf>
  80035b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80035e:	a1 20 40 80 00       	mov    0x804020,%eax
  800363:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800369:	a1 20 40 80 00       	mov    0x804020,%eax
  80036e:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	52                   	push   %edx
  800378:	50                   	push   %eax
  800379:	68 2c 31 80 00       	push   $0x80312c
  80037e:	e8 4e 03 00 00       	call   8006d1 <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800386:	a1 20 40 80 00       	mov    0x804020,%eax
  80038b:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80039c:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a1:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8003a7:	51                   	push   %ecx
  8003a8:	52                   	push   %edx
  8003a9:	50                   	push   %eax
  8003aa:	68 54 31 80 00       	push   $0x803154
  8003af:	e8 1d 03 00 00       	call   8006d1 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8003c2:	83 ec 08             	sub    $0x8,%esp
  8003c5:	50                   	push   %eax
  8003c6:	68 ac 31 80 00       	push   $0x8031ac
  8003cb:	e8 01 03 00 00       	call   8006d1 <cprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 04 31 80 00       	push   $0x803104
  8003db:	e8 f1 02 00 00       	call   8006d1 <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003e3:	e8 79 17 00 00       	call   801b61 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003e8:	e8 19 00 00 00       	call   800406 <exit>
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003f6:	83 ec 0c             	sub    $0xc,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	e8 06 19 00 00       	call   801d06 <sys_destroy_env>
  800400:	83 c4 10             	add    $0x10,%esp
}
  800403:	90                   	nop
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <exit>:

void
exit(void)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80040c:	e8 5b 19 00 00       	call   801d6c <sys_exit_env>
}
  800411:	90                   	nop
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80041a:	8d 45 10             	lea    0x10(%ebp),%eax
  80041d:	83 c0 04             	add    $0x4,%eax
  800420:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800423:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800428:	85 c0                	test   %eax,%eax
  80042a:	74 16                	je     800442 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80042c:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	50                   	push   %eax
  800435:	68 c0 31 80 00       	push   $0x8031c0
  80043a:	e8 92 02 00 00       	call   8006d1 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800442:	a1 00 40 80 00       	mov    0x804000,%eax
  800447:	ff 75 0c             	pushl  0xc(%ebp)
  80044a:	ff 75 08             	pushl  0x8(%ebp)
  80044d:	50                   	push   %eax
  80044e:	68 c5 31 80 00       	push   $0x8031c5
  800453:	e8 79 02 00 00       	call   8006d1 <cprintf>
  800458:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80045b:	8b 45 10             	mov    0x10(%ebp),%eax
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 f4             	pushl  -0xc(%ebp)
  800464:	50                   	push   %eax
  800465:	e8 fc 01 00 00       	call   800666 <vcprintf>
  80046a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	6a 00                	push   $0x0
  800472:	68 e1 31 80 00       	push   $0x8031e1
  800477:	e8 ea 01 00 00       	call   800666 <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80047f:	e8 82 ff ff ff       	call   800406 <exit>

	// should not return here
	while (1) ;
  800484:	eb fe                	jmp    800484 <_panic+0x70>

00800486 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80048c:	a1 20 40 80 00       	mov    0x804020,%eax
  800491:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	39 c2                	cmp    %eax,%edx
  80049c:	74 14                	je     8004b2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 e4 31 80 00       	push   $0x8031e4
  8004a6:	6a 26                	push   $0x26
  8004a8:	68 30 32 80 00       	push   $0x803230
  8004ad:	e8 62 ff ff ff       	call   800414 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c0:	e9 c5 00 00 00       	jmp    80058a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	01 d0                	add    %edx,%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	75 08                	jne    8004e2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004da:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004dd:	e9 a5 00 00 00       	jmp    800587 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004f0:	eb 69                	jmp    80055b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f7:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800500:	89 d0                	mov    %edx,%eax
  800502:	01 c0                	add    %eax,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	c1 e0 03             	shl    $0x3,%eax
  800509:	01 c8                	add    %ecx,%eax
  80050b:	8a 40 04             	mov    0x4(%eax),%al
  80050e:	84 c0                	test   %al,%al
  800510:	75 46                	jne    800558 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800512:	a1 20 40 80 00       	mov    0x804020,%eax
  800517:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80051d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	01 c0                	add    %eax,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	c1 e0 03             	shl    $0x3,%eax
  800529:	01 c8                	add    %ecx,%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800538:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80053a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	01 c8                	add    %ecx,%eax
  800549:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 09                	jne    800558 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80054f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800556:	eb 15                	jmp    80056d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800558:	ff 45 e8             	incl   -0x18(%ebp)
  80055b:	a1 20 40 80 00       	mov    0x804020,%eax
  800560:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800566:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800569:	39 c2                	cmp    %eax,%edx
  80056b:	77 85                	ja     8004f2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80056d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800571:	75 14                	jne    800587 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800573:	83 ec 04             	sub    $0x4,%esp
  800576:	68 3c 32 80 00       	push   $0x80323c
  80057b:	6a 3a                	push   $0x3a
  80057d:	68 30 32 80 00       	push   $0x803230
  800582:	e8 8d fe ff ff       	call   800414 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800587:	ff 45 f0             	incl   -0x10(%ebp)
  80058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800590:	0f 8c 2f ff ff ff    	jl     8004c5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800596:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005a4:	eb 26                	jmp    8005cc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	c1 e0 03             	shl    $0x3,%eax
  8005bd:	01 c8                	add    %ecx,%eax
  8005bf:	8a 40 04             	mov    0x4(%eax),%al
  8005c2:	3c 01                	cmp    $0x1,%al
  8005c4:	75 03                	jne    8005c9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c9:	ff 45 e0             	incl   -0x20(%ebp)
  8005cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d1:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8005d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005da:	39 c2                	cmp    %eax,%edx
  8005dc:	77 c8                	ja     8005a6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005e4:	74 14                	je     8005fa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005e6:	83 ec 04             	sub    $0x4,%esp
  8005e9:	68 90 32 80 00       	push   $0x803290
  8005ee:	6a 44                	push   $0x44
  8005f0:	68 30 32 80 00       	push   $0x803230
  8005f5:	e8 1a fe ff ff       	call   800414 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800603:	8b 45 0c             	mov    0xc(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	8d 48 01             	lea    0x1(%eax),%ecx
  80060b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060e:	89 0a                	mov    %ecx,(%edx)
  800610:	8b 55 08             	mov    0x8(%ebp),%edx
  800613:	88 d1                	mov    %dl,%cl
  800615:	8b 55 0c             	mov    0xc(%ebp),%edx
  800618:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	3d ff 00 00 00       	cmp    $0xff,%eax
  800626:	75 2c                	jne    800654 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800628:	a0 24 40 80 00       	mov    0x804024,%al
  80062d:	0f b6 c0             	movzbl %al,%eax
  800630:	8b 55 0c             	mov    0xc(%ebp),%edx
  800633:	8b 12                	mov    (%edx),%edx
  800635:	89 d1                	mov    %edx,%ecx
  800637:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063a:	83 c2 08             	add    $0x8,%edx
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	50                   	push   %eax
  800641:	51                   	push   %ecx
  800642:	52                   	push   %edx
  800643:	e8 a6 13 00 00       	call   8019ee <sys_cputs>
  800648:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	8b 40 04             	mov    0x4(%eax),%eax
  80065a:	8d 50 01             	lea    0x1(%eax),%edx
  80065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800660:	89 50 04             	mov    %edx,0x4(%eax)
}
  800663:	90                   	nop
  800664:	c9                   	leave  
  800665:	c3                   	ret    

00800666 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
  800669:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80066f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800676:	00 00 00 
	b.cnt = 0;
  800679:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800680:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	ff 75 08             	pushl  0x8(%ebp)
  800689:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068f:	50                   	push   %eax
  800690:	68 fd 05 80 00       	push   $0x8005fd
  800695:	e8 11 02 00 00       	call   8008ab <vprintfmt>
  80069a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80069d:	a0 24 40 80 00       	mov    0x804024,%al
  8006a2:	0f b6 c0             	movzbl %al,%eax
  8006a5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006ab:	83 ec 04             	sub    $0x4,%esp
  8006ae:	50                   	push   %eax
  8006af:	52                   	push   %edx
  8006b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b6:	83 c0 08             	add    $0x8,%eax
  8006b9:	50                   	push   %eax
  8006ba:	e8 2f 13 00 00       	call   8019ee <sys_cputs>
  8006bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006c2:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006d7:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ed:	50                   	push   %eax
  8006ee:	e8 73 ff ff ff       	call   800666 <vcprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800704:	e8 3e 14 00 00       	call   801b47 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800709:	8d 45 0c             	lea    0xc(%ebp),%eax
  80070c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 f4             	pushl  -0xc(%ebp)
  800718:	50                   	push   %eax
  800719:	e8 48 ff ff ff       	call   800666 <vcprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800724:	e8 38 14 00 00       	call   801b61 <sys_enable_interrupt>
	return cnt;
  800729:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	53                   	push   %ebx
  800732:	83 ec 14             	sub    $0x14,%esp
  800735:	8b 45 10             	mov    0x10(%ebp),%eax
  800738:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800741:	8b 45 18             	mov    0x18(%ebp),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80074c:	77 55                	ja     8007a3 <printnum+0x75>
  80074e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800751:	72 05                	jb     800758 <printnum+0x2a>
  800753:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800756:	77 4b                	ja     8007a3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800758:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80075b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80075e:	8b 45 18             	mov    0x18(%ebp),%eax
  800761:	ba 00 00 00 00       	mov    $0x0,%edx
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	ff 75 f4             	pushl  -0xc(%ebp)
  80076b:	ff 75 f0             	pushl  -0x10(%ebp)
  80076e:	e8 e9 24 00 00       	call   802c5c <__udivdi3>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	ff 75 20             	pushl  0x20(%ebp)
  80077c:	53                   	push   %ebx
  80077d:	ff 75 18             	pushl  0x18(%ebp)
  800780:	52                   	push   %edx
  800781:	50                   	push   %eax
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 08             	pushl  0x8(%ebp)
  800788:	e8 a1 ff ff ff       	call   80072e <printnum>
  80078d:	83 c4 20             	add    $0x20,%esp
  800790:	eb 1a                	jmp    8007ac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 20             	pushl  0x20(%ebp)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a3:	ff 4d 1c             	decl   0x1c(%ebp)
  8007a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007aa:	7f e6                	jg     800792 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ba:	53                   	push   %ebx
  8007bb:	51                   	push   %ecx
  8007bc:	52                   	push   %edx
  8007bd:	50                   	push   %eax
  8007be:	e8 a9 25 00 00       	call   802d6c <__umoddi3>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	05 f4 34 80 00       	add    $0x8034f4,%eax
  8007cb:	8a 00                	mov    (%eax),%al
  8007cd:	0f be c0             	movsbl %al,%eax
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	50                   	push   %eax
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	83 c4 10             	add    $0x10,%esp
}
  8007df:	90                   	nop
  8007e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ec:	7e 1c                	jle    80080a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	8d 50 08             	lea    0x8(%eax),%edx
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	89 10                	mov    %edx,(%eax)
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	83 e8 08             	sub    $0x8,%eax
  800803:	8b 50 04             	mov    0x4(%eax),%edx
  800806:	8b 00                	mov    (%eax),%eax
  800808:	eb 40                	jmp    80084a <getuint+0x65>
	else if (lflag)
  80080a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80080e:	74 1e                	je     80082e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	8d 50 04             	lea    0x4(%eax),%edx
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	89 10                	mov    %edx,(%eax)
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	83 e8 04             	sub    $0x4,%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	eb 1c                	jmp    80084a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	8d 50 04             	lea    0x4(%eax),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	89 10                	mov    %edx,(%eax)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	83 e8 04             	sub    $0x4,%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80084f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800853:	7e 1c                	jle    800871 <getint+0x25>
		return va_arg(*ap, long long);
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	8d 50 08             	lea    0x8(%eax),%edx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	89 10                	mov    %edx,(%eax)
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	83 e8 08             	sub    $0x8,%eax
  80086a:	8b 50 04             	mov    0x4(%eax),%edx
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	eb 38                	jmp    8008a9 <getint+0x5d>
	else if (lflag)
  800871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800875:	74 1a                	je     800891 <getint+0x45>
		return va_arg(*ap, long);
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 10                	mov    %edx,(%eax)
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	83 e8 04             	sub    $0x4,%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	99                   	cltd   
  80088f:	eb 18                	jmp    8008a9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 04             	lea    0x4(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 00                	mov    (%eax),%eax
  8008a8:	99                   	cltd   
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	56                   	push   %esi
  8008af:	53                   	push   %ebx
  8008b0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b3:	eb 17                	jmp    8008cc <vprintfmt+0x21>
			if (ch == '\0')
  8008b5:	85 db                	test   %ebx,%ebx
  8008b7:	0f 84 af 03 00 00    	je     800c6c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cf:	8d 50 01             	lea    0x1(%eax),%edx
  8008d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d5:	8a 00                	mov    (%eax),%al
  8008d7:	0f b6 d8             	movzbl %al,%ebx
  8008da:	83 fb 25             	cmp    $0x25,%ebx
  8008dd:	75 d6                	jne    8008b5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008df:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	8d 50 01             	lea    0x1(%eax),%edx
  800905:	89 55 10             	mov    %edx,0x10(%ebp)
  800908:	8a 00                	mov    (%eax),%al
  80090a:	0f b6 d8             	movzbl %al,%ebx
  80090d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800910:	83 f8 55             	cmp    $0x55,%eax
  800913:	0f 87 2b 03 00 00    	ja     800c44 <vprintfmt+0x399>
  800919:	8b 04 85 18 35 80 00 	mov    0x803518(,%eax,4),%eax
  800920:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800922:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800926:	eb d7                	jmp    8008ff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800928:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80092c:	eb d1                	jmp    8008ff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800935:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800938:	89 d0                	mov    %edx,%eax
  80093a:	c1 e0 02             	shl    $0x2,%eax
  80093d:	01 d0                	add    %edx,%eax
  80093f:	01 c0                	add    %eax,%eax
  800941:	01 d8                	add    %ebx,%eax
  800943:	83 e8 30             	sub    $0x30,%eax
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	8a 00                	mov    (%eax),%al
  80094e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800951:	83 fb 2f             	cmp    $0x2f,%ebx
  800954:	7e 3e                	jle    800994 <vprintfmt+0xe9>
  800956:	83 fb 39             	cmp    $0x39,%ebx
  800959:	7f 39                	jg     800994 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80095e:	eb d5                	jmp    800935 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 c0 04             	add    $0x4,%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	83 e8 04             	sub    $0x4,%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800974:	eb 1f                	jmp    800995 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097a:	79 83                	jns    8008ff <vprintfmt+0x54>
				width = 0;
  80097c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800983:	e9 77 ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800988:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80098f:	e9 6b ff ff ff       	jmp    8008ff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800994:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800995:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800999:	0f 89 60 ff ff ff    	jns    8008ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80099f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009ac:	e9 4e ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009b4:	e9 46 ff ff ff       	jmp    8008ff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bc:	83 c0 04             	add    $0x4,%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	83 e8 04             	sub    $0x4,%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	50                   	push   %eax
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			break;
  8009d9:	e9 89 02 00 00       	jmp    800c67 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 c0 04             	add    $0x4,%eax
  8009e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ea:	83 e8 04             	sub    $0x4,%eax
  8009ed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	79 02                	jns    8009f5 <vprintfmt+0x14a>
				err = -err;
  8009f3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009f5:	83 fb 64             	cmp    $0x64,%ebx
  8009f8:	7f 0b                	jg     800a05 <vprintfmt+0x15a>
  8009fa:	8b 34 9d 60 33 80 00 	mov    0x803360(,%ebx,4),%esi
  800a01:	85 f6                	test   %esi,%esi
  800a03:	75 19                	jne    800a1e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a05:	53                   	push   %ebx
  800a06:	68 05 35 80 00       	push   $0x803505
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 5e 02 00 00       	call   800c74 <printfmt>
  800a16:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a19:	e9 49 02 00 00       	jmp    800c67 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a1e:	56                   	push   %esi
  800a1f:	68 0e 35 80 00       	push   $0x80350e
  800a24:	ff 75 0c             	pushl  0xc(%ebp)
  800a27:	ff 75 08             	pushl  0x8(%ebp)
  800a2a:	e8 45 02 00 00       	call   800c74 <printfmt>
  800a2f:	83 c4 10             	add    $0x10,%esp
			break;
  800a32:	e9 30 02 00 00       	jmp    800c67 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a37:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3a:	83 c0 04             	add    $0x4,%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	83 e8 04             	sub    $0x4,%eax
  800a46:	8b 30                	mov    (%eax),%esi
  800a48:	85 f6                	test   %esi,%esi
  800a4a:	75 05                	jne    800a51 <vprintfmt+0x1a6>
				p = "(null)";
  800a4c:	be 11 35 80 00       	mov    $0x803511,%esi
			if (width > 0 && padc != '-')
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a55:	7e 6d                	jle    800ac4 <vprintfmt+0x219>
  800a57:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a5b:	74 67                	je     800ac4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	50                   	push   %eax
  800a64:	56                   	push   %esi
  800a65:	e8 0c 03 00 00       	call   800d76 <strnlen>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a70:	eb 16                	jmp    800a88 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a72:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a85:	ff 4d e4             	decl   -0x1c(%ebp)
  800a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8c:	7f e4                	jg     800a72 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8e:	eb 34                	jmp    800ac4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a90:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a94:	74 1c                	je     800ab2 <vprintfmt+0x207>
  800a96:	83 fb 1f             	cmp    $0x1f,%ebx
  800a99:	7e 05                	jle    800aa0 <vprintfmt+0x1f5>
  800a9b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a9e:	7e 12                	jle    800ab2 <vprintfmt+0x207>
					putch('?', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 3f                	push   $0x3f
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	eb 0f                	jmp    800ac1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac4:	89 f0                	mov    %esi,%eax
  800ac6:	8d 70 01             	lea    0x1(%eax),%esi
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	0f be d8             	movsbl %al,%ebx
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	74 24                	je     800af6 <vprintfmt+0x24b>
  800ad2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ad6:	78 b8                	js     800a90 <vprintfmt+0x1e5>
  800ad8:	ff 4d e0             	decl   -0x20(%ebp)
  800adb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800adf:	79 af                	jns    800a90 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae1:	eb 13                	jmp    800af6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 20                	push   $0x20
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af3:	ff 4d e4             	decl   -0x1c(%ebp)
  800af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afa:	7f e7                	jg     800ae3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800afc:	e9 66 01 00 00       	jmp    800c67 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 e8             	pushl  -0x18(%ebp)
  800b07:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0a:	50                   	push   %eax
  800b0b:	e8 3c fd ff ff       	call   80084c <getint>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1f:	85 d2                	test   %edx,%edx
  800b21:	79 23                	jns    800b46 <vprintfmt+0x29b>
				putch('-', putdat);
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 0c             	pushl  0xc(%ebp)
  800b29:	6a 2d                	push   $0x2d
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	ff d0                	call   *%eax
  800b30:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b39:	f7 d8                	neg    %eax
  800b3b:	83 d2 00             	adc    $0x0,%edx
  800b3e:	f7 da                	neg    %edx
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b4d:	e9 bc 00 00 00       	jmp    800c0e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 e8             	pushl  -0x18(%ebp)
  800b58:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 84 fc ff ff       	call   8007e5 <getuint>
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b71:	e9 98 00 00 00       	jmp    800c0e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b76:	83 ec 08             	sub    $0x8,%esp
  800b79:	ff 75 0c             	pushl  0xc(%ebp)
  800b7c:	6a 58                	push   $0x58
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	ff d0                	call   *%eax
  800b83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 58                	push   $0x58
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 58                	push   $0x58
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			break;
  800ba6:	e9 bc 00 00 00       	jmp    800c67 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	6a 30                	push   $0x30
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	ff d0                	call   *%eax
  800bb8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	6a 78                	push   $0x78
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 e8 04             	sub    $0x4,%eax
  800bda:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bed:	eb 1f                	jmp    800c0e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf8:	50                   	push   %eax
  800bf9:	e8 e7 fb ff ff       	call   8007e5 <getuint>
  800bfe:	83 c4 10             	add    $0x10,%esp
  800c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c15:	83 ec 04             	sub    $0x4,%esp
  800c18:	52                   	push   %edx
  800c19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c1c:	50                   	push   %eax
  800c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c20:	ff 75 f0             	pushl  -0x10(%ebp)
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	ff 75 08             	pushl  0x8(%ebp)
  800c29:	e8 00 fb ff ff       	call   80072e <printnum>
  800c2e:	83 c4 20             	add    $0x20,%esp
			break;
  800c31:	eb 34                	jmp    800c67 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			break;
  800c42:	eb 23                	jmp    800c67 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	6a 25                	push   $0x25
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	ff d0                	call   *%eax
  800c51:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c54:	ff 4d 10             	decl   0x10(%ebp)
  800c57:	eb 03                	jmp    800c5c <vprintfmt+0x3b1>
  800c59:	ff 4d 10             	decl   0x10(%ebp)
  800c5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5f:	48                   	dec    %eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	3c 25                	cmp    $0x25,%al
  800c64:	75 f3                	jne    800c59 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c66:	90                   	nop
		}
	}
  800c67:	e9 47 fc ff ff       	jmp    8008b3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c6c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 16 fc ff ff       	call   8008ab <vprintfmt>
  800c95:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c98:	90                   	nop
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8b 40 08             	mov    0x8(%eax),%eax
  800ca4:	8d 50 01             	lea    0x1(%eax),%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	8b 10                	mov    (%eax),%edx
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8b 40 04             	mov    0x4(%eax),%eax
  800cb8:	39 c2                	cmp    %eax,%edx
  800cba:	73 12                	jae    800cce <sprintputch+0x33>
		*b->buf++ = ch;
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	89 0a                	mov    %ecx,(%edx)
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	88 10                	mov    %dl,(%eax)
}
  800cce:	90                   	nop
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	01 d0                	add    %edx,%eax
  800ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf6:	74 06                	je     800cfe <vsnprintf+0x2d>
  800cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfc:	7f 07                	jg     800d05 <vsnprintf+0x34>
		return -E_INVAL;
  800cfe:	b8 03 00 00 00       	mov    $0x3,%eax
  800d03:	eb 20                	jmp    800d25 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d05:	ff 75 14             	pushl  0x14(%ebp)
  800d08:	ff 75 10             	pushl  0x10(%ebp)
  800d0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0e:	50                   	push   %eax
  800d0f:	68 9b 0c 80 00       	push   $0x800c9b
  800d14:	e8 92 fb ff ff       	call   8008ab <vprintfmt>
  800d19:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3c:	50                   	push   %eax
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	ff 75 08             	pushl  0x8(%ebp)
  800d43:	e8 89 ff ff ff       	call   800cd1 <vsnprintf>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d60:	eb 06                	jmp    800d68 <strlen+0x15>
		n++;
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	75 f1                	jne    800d62 <strlen+0xf>
		n++;
	return n;
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d83:	eb 09                	jmp    800d8e <strnlen+0x18>
		n++;
  800d85:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	ff 4d 0c             	decl   0xc(%ebp)
  800d8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d92:	74 09                	je     800d9d <strnlen+0x27>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 e8                	jne    800d85 <strnlen+0xf>
		n++;
	return n;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dae:	90                   	nop
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 08             	mov    %edx,0x8(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dc1:	8a 12                	mov    (%edx),%dl
  800dc3:	88 10                	mov    %dl,(%eax)
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e4                	jne    800daf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ddc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de3:	eb 1f                	jmp    800e04 <strncpy+0x34>
		*dst++ = *src;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8d 50 01             	lea    0x1(%eax),%edx
  800deb:	89 55 08             	mov    %edx,0x8(%ebp)
  800dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	84 c0                	test   %al,%al
  800dfc:	74 03                	je     800e01 <strncpy+0x31>
			src++;
  800dfe:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
  800e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e07:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e0a:	72 d9                	jb     800de5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 30                	je     800e53 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e23:	eb 16                	jmp    800e3b <strlcpy+0x2a>
			*dst++ = *src++;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e3b:	ff 4d 10             	decl   0x10(%ebp)
  800e3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e42:	74 09                	je     800e4d <strlcpy+0x3c>
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	84 c0                	test   %al,%al
  800e4b:	75 d8                	jne    800e25 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e59:	29 c2                	sub    %eax,%edx
  800e5b:	89 d0                	mov    %edx,%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e62:	eb 06                	jmp    800e6a <strcmp+0xb>
		p++, q++;
  800e64:	ff 45 08             	incl   0x8(%ebp)
  800e67:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	74 0e                	je     800e81 <strcmp+0x22>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 10                	mov    (%eax),%dl
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	38 c2                	cmp    %al,%dl
  800e7f:	74 e3                	je     800e64 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e9a:	eb 09                	jmp    800ea5 <strncmp+0xe>
		n--, p++, q++;
  800e9c:	ff 4d 10             	decl   0x10(%ebp)
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea9:	74 17                	je     800ec2 <strncmp+0x2b>
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	84 c0                	test   %al,%al
  800eb2:	74 0e                	je     800ec2 <strncmp+0x2b>
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	38 c2                	cmp    %al,%dl
  800ec0:	74 da                	je     800e9c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec6:	75 07                	jne    800ecf <strncmp+0x38>
		return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecd:	eb 14                	jmp    800ee3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
}
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    

00800ee5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 04             	sub    $0x4,%esp
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef1:	eb 12                	jmp    800f05 <strchr+0x20>
		if (*s == c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efb:	75 05                	jne    800f02 <strchr+0x1d>
			return (char *) s;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	eb 11                	jmp    800f13 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	84 c0                	test   %al,%al
  800f0c:	75 e5                	jne    800ef3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 04             	sub    $0x4,%esp
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f21:	eb 0d                	jmp    800f30 <strfind+0x1b>
		if (*s == c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f2b:	74 0e                	je     800f3b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f2d:	ff 45 08             	incl   0x8(%ebp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	84 c0                	test   %al,%al
  800f37:	75 ea                	jne    800f23 <strfind+0xe>
  800f39:	eb 01                	jmp    800f3c <strfind+0x27>
		if (*s == c)
			break;
  800f3b:	90                   	nop
	return (char *) s;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f53:	eb 0e                	jmp    800f63 <memset+0x22>
		*p++ = c;
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8d 50 01             	lea    0x1(%eax),%edx
  800f5b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f61:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f63:	ff 4d f8             	decl   -0x8(%ebp)
  800f66:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f6a:	79 e9                	jns    800f55 <memset+0x14>
		*p++ = c;

	return v;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f83:	eb 16                	jmp    800f9b <memcpy+0x2a>
		*d++ = *s++;
  800f85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f97:	8a 12                	mov    (%edx),%dl
  800f99:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	75 dd                	jne    800f85 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc5:	73 50                	jae    801017 <memmove+0x6a>
  800fc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 d0                	add    %edx,%eax
  800fcf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd2:	76 43                	jbe    801017 <memmove+0x6a>
		s += n;
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe0:	eb 10                	jmp    800ff2 <memmove+0x45>
			*--d = *--s;
  800fe2:	ff 4d f8             	decl   -0x8(%ebp)
  800fe5:	ff 4d fc             	decl   -0x4(%ebp)
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	8a 10                	mov    (%eax),%dl
  800fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	75 e3                	jne    800fe2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fff:	eb 23                	jmp    801024 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80103b:	eb 2a                	jmp    801067 <memcmp+0x3e>
		if (*s1 != *s2)
  80103d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801040:	8a 10                	mov    (%eax),%dl
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	38 c2                	cmp    %al,%dl
  801049:	74 16                	je     801061 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 d0             	movzbl %al,%edx
  801053:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 c0             	movzbl %al,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	eb 18                	jmp    801079 <memcmp+0x50>
		s1++, s2++;
  801061:	ff 45 fc             	incl   -0x4(%ebp)
  801064:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 c9                	jne    80103d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80108c:	eb 15                	jmp    8010a3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	0f b6 d0             	movzbl %al,%edx
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	0f b6 c0             	movzbl %al,%eax
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	74 0d                	je     8010ad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a0:	ff 45 08             	incl   0x8(%ebp)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a9:	72 e3                	jb     80108e <memfind+0x13>
  8010ab:	eb 01                	jmp    8010ae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010ad:	90                   	nop
	return (void *) s;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c7:	eb 03                	jmp    8010cc <strtol+0x19>
		s++;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 20                	cmp    $0x20,%al
  8010d3:	74 f4                	je     8010c9 <strtol+0x16>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 09                	cmp    $0x9,%al
  8010dc:	74 eb                	je     8010c9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 2b                	cmp    $0x2b,%al
  8010e5:	75 05                	jne    8010ec <strtol+0x39>
		s++;
  8010e7:	ff 45 08             	incl   0x8(%ebp)
  8010ea:	eb 13                	jmp    8010ff <strtol+0x4c>
	else if (*s == '-')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 2d                	cmp    $0x2d,%al
  8010f3:	75 0a                	jne    8010ff <strtol+0x4c>
		s++, neg = 1;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
  8010f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	74 06                	je     80110b <strtol+0x58>
  801105:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801109:	75 20                	jne    80112b <strtol+0x78>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 30                	cmp    $0x30,%al
  801112:	75 17                	jne    80112b <strtol+0x78>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	40                   	inc    %eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 78                	cmp    $0x78,%al
  80111c:	75 0d                	jne    80112b <strtol+0x78>
		s += 2, base = 16;
  80111e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801122:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801129:	eb 28                	jmp    801153 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	75 15                	jne    801146 <strtol+0x93>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 30                	cmp    $0x30,%al
  801138:	75 0c                	jne    801146 <strtol+0x93>
		s++, base = 8;
  80113a:	ff 45 08             	incl   0x8(%ebp)
  80113d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801144:	eb 0d                	jmp    801153 <strtol+0xa0>
	else if (base == 0)
  801146:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114a:	75 07                	jne    801153 <strtol+0xa0>
		base = 10;
  80114c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2f                	cmp    $0x2f,%al
  80115a:	7e 19                	jle    801175 <strtol+0xc2>
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 39                	cmp    $0x39,%al
  801163:	7f 10                	jg     801175 <strtol+0xc2>
			dig = *s - '0';
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f be c0             	movsbl %al,%eax
  80116d:	83 e8 30             	sub    $0x30,%eax
  801170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801173:	eb 42                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 60                	cmp    $0x60,%al
  80117c:	7e 19                	jle    801197 <strtol+0xe4>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 7a                	cmp    $0x7a,%al
  801185:	7f 10                	jg     801197 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	83 e8 57             	sub    $0x57,%eax
  801192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801195:	eb 20                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 40                	cmp    $0x40,%al
  80119e:	7e 39                	jle    8011d9 <strtol+0x126>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 5a                	cmp    $0x5a,%al
  8011a7:	7f 30                	jg     8011d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 37             	sub    $0x37,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011bd:	7d 19                	jge    8011d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011bf:	ff 45 08             	incl   0x8(%ebp)
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d3:	e9 7b ff ff ff       	jmp    801153 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011dd:	74 08                	je     8011e7 <strtol+0x134>
		*endptr = (char *) s;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011eb:	74 07                	je     8011f4 <strtol+0x141>
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	f7 d8                	neg    %eax
  8011f2:	eb 03                	jmp    8011f7 <strtol+0x144>
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80120d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801211:	79 13                	jns    801226 <ltostr+0x2d>
	{
		neg = 1;
  801213:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801220:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801223:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80122e:	99                   	cltd   
  80122f:	f7 f9                	idiv   %ecx
  801231:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801234:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801237:	8d 50 01             	lea    0x1(%eax),%edx
  80123a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80123d:	89 c2                	mov    %eax,%edx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801247:	83 c2 30             	add    $0x30,%edx
  80124a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80124c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801254:	f7 e9                	imul   %ecx
  801256:	c1 fa 02             	sar    $0x2,%edx
  801259:	89 c8                	mov    %ecx,%eax
  80125b:	c1 f8 1f             	sar    $0x1f,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
  801262:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801265:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801268:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80126d:	f7 e9                	imul   %ecx
  80126f:	c1 fa 02             	sar    $0x2,%edx
  801272:	89 c8                	mov    %ecx,%eax
  801274:	c1 f8 1f             	sar    $0x1f,%eax
  801277:	29 c2                	sub    %eax,%edx
  801279:	89 d0                	mov    %edx,%eax
  80127b:	c1 e0 02             	shl    $0x2,%eax
  80127e:	01 d0                	add    %edx,%eax
  801280:	01 c0                	add    %eax,%eax
  801282:	29 c1                	sub    %eax,%ecx
  801284:	89 ca                	mov    %ecx,%edx
  801286:	85 d2                	test   %edx,%edx
  801288:	75 9c                	jne    801226 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80128a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801291:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801294:	48                   	dec    %eax
  801295:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801298:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129c:	74 3d                	je     8012db <ltostr+0xe2>
		start = 1 ;
  80129e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012a5:	eb 34                	jmp    8012db <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8012a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 c8                	add    %ecx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 c2                	add    %eax,%edx
  8012d0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012d3:	88 02                	mov    %al,(%edx)
		start++ ;
  8012d5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012d8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e1:	7c c4                	jl     8012a7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	01 d0                	add    %edx,%eax
  8012eb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	e8 54 fa ff ff       	call   800d53 <strlen>
  8012ff:	83 c4 04             	add    $0x4,%esp
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	e8 46 fa ff ff       	call   800d53 <strlen>
  80130d:	83 c4 04             	add    $0x4,%esp
  801310:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80131a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801321:	eb 17                	jmp    80133a <strcconcat+0x49>
		final[s] = str1[s] ;
  801323:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801326:	8b 45 10             	mov    0x10(%ebp),%eax
  801329:	01 c2                	add    %eax,%edx
  80132b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	01 c8                	add    %ecx,%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801337:	ff 45 fc             	incl   -0x4(%ebp)
  80133a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801340:	7c e1                	jl     801323 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801342:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801350:	eb 1f                	jmp    801371 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801352:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 10             	mov    0x10(%ebp),%eax
  801360:	01 c2                	add    %eax,%edx
  801362:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801365:	8b 45 0c             	mov    0xc(%ebp),%eax
  801368:	01 c8                	add    %ecx,%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80136e:	ff 45 f8             	incl   -0x8(%ebp)
  801371:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801374:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801377:	7c d9                	jl     801352 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801379:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	c6 00 00             	movb   $0x0,(%eax)
}
  801384:	90                   	nop
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801393:	8b 45 14             	mov    0x14(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139f:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013aa:	eb 0c                	jmp    8013b8 <strsplit+0x31>
			*string++ = 0;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8d 50 01             	lea    0x1(%eax),%edx
  8013b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 18                	je     8013d9 <strsplit+0x52>
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f be c0             	movsbl %al,%eax
  8013c9:	50                   	push   %eax
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	e8 13 fb ff ff       	call   800ee5 <strchr>
  8013d2:	83 c4 08             	add    $0x8,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	75 d3                	jne    8013ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	84 c0                	test   %al,%al
  8013e0:	74 5a                	je     80143c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e5:	8b 00                	mov    (%eax),%eax
  8013e7:	83 f8 0f             	cmp    $0xf,%eax
  8013ea:	75 07                	jne    8013f3 <strsplit+0x6c>
		{
			return 0;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	eb 66                	jmp    801459 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8013fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8013fe:	89 0a                	mov    %ecx,(%edx)
  801400:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801407:	8b 45 10             	mov    0x10(%ebp),%eax
  80140a:	01 c2                	add    %eax,%edx
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801411:	eb 03                	jmp    801416 <strsplit+0x8f>
			string++;
  801413:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	84 c0                	test   %al,%al
  80141d:	74 8b                	je     8013aa <strsplit+0x23>
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	0f be c0             	movsbl %al,%eax
  801427:	50                   	push   %eax
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	e8 b5 fa ff ff       	call   800ee5 <strchr>
  801430:	83 c4 08             	add    $0x8,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	74 dc                	je     801413 <strsplit+0x8c>
			string++;
	}
  801437:	e9 6e ff ff ff       	jmp    8013aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80143c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80143d:	8b 45 14             	mov    0x14(%ebp),%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801454:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801468:	eb 4c                	jmp    8014b6 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80146a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	01 d0                	add    %edx,%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3c 40                	cmp    $0x40,%al
  801476:	7e 27                	jle    80149f <str2lower+0x44>
  801478:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	01 d0                	add    %edx,%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 5a                	cmp    $0x5a,%al
  801484:	7f 19                	jg     80149f <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801486:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801491:	8b 55 0c             	mov    0xc(%ebp),%edx
  801494:	01 ca                	add    %ecx,%edx
  801496:	8a 12                	mov    (%edx),%dl
  801498:	83 c2 20             	add    $0x20,%edx
  80149b:	88 10                	mov    %dl,(%eax)
  80149d:	eb 14                	jmp    8014b3 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80149f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	01 c2                	add    %eax,%edx
  8014a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	01 c8                	add    %ecx,%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8014b3:	ff 45 fc             	incl   -0x4(%ebp)
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	e8 95 f8 ff ff       	call   800d53 <strlen>
  8014be:	83 c4 04             	add    $0x4,%esp
  8014c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014c4:	7f a4                	jg     80146a <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8014c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	01 d0                	add    %edx,%eax
  8014ce:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  8014d9:	a1 28 40 80 00       	mov    0x804028,%eax
  8014de:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e1:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  8014e8:	a1 28 40 80 00       	mov    0x804028,%eax
  8014ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f0:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  8014f7:	a1 28 40 80 00       	mov    0x804028,%eax
  8014fc:	40                   	inc    %eax
  8014fd:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801502:	90                   	nop
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <searchElement>:

int searchElement(uint32 start) {
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80150b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801512:	eb 17                	jmp    80152b <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801514:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801517:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  80151e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801521:	75 05                	jne    801528 <searchElement+0x23>
			return i;
  801523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801526:	eb 12                	jmp    80153a <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801528:	ff 45 fc             	incl   -0x4(%ebp)
  80152b:	a1 28 40 80 00       	mov    0x804028,%eax
  801530:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801533:	7c df                	jl     801514 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <removeElement>:
void removeElement(uint32 start) {
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801542:	ff 75 08             	pushl  0x8(%ebp)
  801545:	e8 bb ff ff ff       	call   801505 <searchElement>
  80154a:	83 c4 04             	add    $0x4,%esp
  80154d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801550:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801553:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801556:	eb 26                	jmp    80157e <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155b:	40                   	inc    %eax
  80155c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80155f:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801566:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  80156d:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801574:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  80157b:	ff 45 fc             	incl   -0x4(%ebp)
  80157e:	a1 28 40 80 00       	mov    0x804028,%eax
  801583:	48                   	dec    %eax
  801584:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801587:	7f cf                	jg     801558 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801589:	a1 28 40 80 00       	mov    0x804028,%eax
  80158e:	48                   	dec    %eax
  80158f:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <searchfree>:
int searchfree(uint32 end)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80159d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a4:	eb 17                	jmp    8015bd <searchfree+0x26>
		if (marked_pages[i].end == end) {
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8015b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015b3:	75 05                	jne    8015ba <searchfree+0x23>
			return i;
  8015b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b8:	eb 12                	jmp    8015cc <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  8015ba:	ff 45 fc             	incl   -0x4(%ebp)
  8015bd:	a1 28 40 80 00       	mov    0x804028,%eax
  8015c2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8015c5:	7c df                	jl     8015a6 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  8015c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <removefree>:
void removefree(uint32 end)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  8015d4:	eb 52                	jmp    801628 <removefree+0x5a>
		int index = searchfree(end);
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	e8 b9 ff ff ff       	call   801597 <searchfree>
  8015de:	83 c4 04             	add    $0x4,%esp
  8015e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  8015e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015ea:	eb 26                	jmp    801612 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	40                   	inc    %eax
  8015f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f3:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  8015fa:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801601:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801608:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  80160f:	ff 45 fc             	incl   -0x4(%ebp)
  801612:	a1 28 40 80 00       	mov    0x804028,%eax
  801617:	48                   	dec    %eax
  801618:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80161b:	7f cf                	jg     8015ec <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  80161d:	a1 28 40 80 00       	mov    0x804028,%eax
  801622:	48                   	dec    %eax
  801623:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  801628:	ff 75 08             	pushl  0x8(%ebp)
  80162b:	e8 67 ff ff ff       	call   801597 <searchfree>
  801630:	83 c4 04             	add    $0x4,%esp
  801633:	83 f8 ff             	cmp    $0xffffffff,%eax
  801636:	75 9e                	jne    8015d6 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <printArray>:
void printArray() {
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	68 70 36 80 00       	push   $0x803670
  801649:	e8 83 f0 ff ff       	call   8006d1 <cprintf>
  80164e:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801658:	eb 29                	jmp    801683 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  80165a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165d:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	ff 75 f4             	pushl  -0xc(%ebp)
  801673:	68 81 36 80 00       	push   $0x803681
  801678:	e8 54 f0 ff ff       	call   8006d1 <cprintf>
  80167d:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801680:	ff 45 f4             	incl   -0xc(%ebp)
  801683:	a1 28 40 80 00       	mov    0x804028,%eax
  801688:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80168b:	7c cd                	jl     80165a <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801693:	a1 04 40 80 00       	mov    0x804004,%eax
  801698:	85 c0                	test   %eax,%eax
  80169a:	74 0a                	je     8016a6 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80169c:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8016a3:	00 00 00 
	}
}
  8016a6:	90                   	nop
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	e8 4f 09 00 00       	call   802009 <sys_sbrk>
  8016ba:	83 c4 10             	add    $0x10,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c5:	e8 c6 ff ff ff       	call   801690 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ce:	75 0a                	jne    8016da <malloc+0x1b>
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d5:	e9 43 01 00 00       	jmp    80181d <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016da:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016e1:	77 3c                	ja     80171f <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016e3:	e8 c3 07 00 00       	call   801eab <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 13                	je     8016ff <malloc+0x40>
			return alloc_block_FF(size);
  8016ec:	83 ec 0c             	sub    $0xc,%esp
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	e8 89 0b 00 00       	call   802280 <alloc_block_FF>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	e9 1e 01 00 00       	jmp    80181d <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  8016ff:	e8 d8 07 00 00       	call   801edc <sys_isUHeapPlacementStrategyBESTFIT>
  801704:	85 c0                	test   %eax,%eax
  801706:	0f 84 0c 01 00 00    	je     801818 <malloc+0x159>
			return alloc_block_BF(size);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 7d 0e 00 00       	call   802594 <alloc_block_BF>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	e9 fe 00 00 00       	jmp    80181d <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  80171f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801726:	8b 55 08             	mov    0x8(%ebp),%edx
  801729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172c:	01 d0                	add    %edx,%eax
  80172e:	48                   	dec    %eax
  80172f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801732:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801735:	ba 00 00 00 00       	mov    $0x0,%edx
  80173a:	f7 75 e0             	divl   -0x20(%ebp)
  80173d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801740:	29 d0                	sub    %edx,%eax
  801742:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	c1 e8 0c             	shr    $0xc,%eax
  80174b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  80174e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  80175c:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801763:	e8 f4 08 00 00       	call   80205c <sys_hard_limit>
  801768:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80176b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80176e:	05 00 10 00 00       	add    $0x1000,%eax
  801773:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801776:	eb 49                	jmp    8017c1 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff 75 e8             	pushl  -0x18(%ebp)
  80177e:	e8 82 fd ff ff       	call   801505 <searchElement>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	83 f8 ff             	cmp    $0xffffffff,%eax
  801789:	75 28                	jne    8017b3 <malloc+0xf4>
			{


				count++;
  80178b:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801794:	75 24                	jne    8017ba <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801799:	05 00 10 00 00       	add    $0x1000,%eax
  80179e:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  8017a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a4:	c1 e0 0c             	shl    $0xc,%eax
  8017a7:	89 c2                	mov    %eax,%edx
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	29 d0                	sub    %edx,%eax
  8017ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  8017b1:	eb 17                	jmp    8017ca <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  8017b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8017ba:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  8017c1:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8017c8:	76 ae                	jbe    801778 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  8017ca:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  8017ce:	75 07                	jne    8017d7 <malloc+0x118>
		{
			return NULL;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d5:	eb 46                	jmp    80181d <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  8017d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017dd:	eb 1a                	jmp    8017f9 <malloc+0x13a>
		{
			addElement(i,end);
  8017df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e5:	83 ec 08             	sub    $0x8,%esp
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	e8 e7 fc ff ff       	call   8014d6 <addElement>
  8017ef:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  8017f2:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  8017f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ff:	7c de                	jl     8017df <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801804:	83 ec 08             	sub    $0x8,%esp
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	50                   	push   %eax
  80180b:	e8 30 08 00 00       	call   802040 <sys_allocate_user_mem>
  801810:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801816:	eb 05                	jmp    80181d <malloc+0x15e>
	}
	return NULL;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax



}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801825:	e8 32 08 00 00       	call   80205c <sys_hard_limit>
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	85 c0                	test   %eax,%eax
  801832:	0f 89 82 00 00 00    	jns    8018ba <free+0x9b>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801840:	77 78                	ja     8018ba <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801848:	73 10                	jae    80185a <free+0x3b>
			free_block(virtual_address);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 d2 0e 00 00       	call   802727 <free_block>
  801855:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801858:	eb 77                	jmp    8018d1 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	83 ec 0c             	sub    $0xc,%esp
  801860:	50                   	push   %eax
  801861:	e8 9f fc ff ff       	call   801505 <searchElement>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  80186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186f:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801880:	29 c2                	sub    %eax,%edx
  801882:	89 d0                	mov    %edx,%eax
  801884:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188a:	c1 e8 0c             	shr    $0xc,%eax
  80188d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	83 ec 08             	sub    $0x8,%esp
  801896:	ff 75 ec             	pushl  -0x14(%ebp)
  801899:	50                   	push   %eax
  80189a:	e8 85 07 00 00       	call   802024 <sys_free_user_mem>
  80189f:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8018ac:	83 ec 0c             	sub    $0xc,%esp
  8018af:	50                   	push   %eax
  8018b0:	e8 19 fd ff ff       	call   8015ce <removefree>
  8018b5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8018b8:	eb 17                	jmp    8018d1 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	68 9a 36 80 00       	push   $0x80369a
  8018c2:	68 ac 00 00 00       	push   $0xac
  8018c7:	68 aa 36 80 00       	push   $0x8036aa
  8018cc:	e8 43 eb ff ff       	call   800414 <_panic>
	}
}
  8018d1:	90                   	nop
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 18             	sub    $0x18,%esp
  8018da:	8b 45 10             	mov    0x10(%ebp),%eax
  8018dd:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e0:	e8 ab fd ff ff       	call   801690 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e9:	75 07                	jne    8018f2 <smalloc+0x1e>
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	eb 17                	jmp    801909 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	68 b8 36 80 00       	push   $0x8036b8
  8018fa:	68 bc 00 00 00       	push   $0xbc
  8018ff:	68 aa 36 80 00       	push   $0x8036aa
  801904:	e8 0b eb ff ff       	call   800414 <_panic>
	return NULL;
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801911:	e8 7a fd ff ff       	call   801690 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	68 e0 36 80 00       	push   $0x8036e0
  80191e:	68 ca 00 00 00       	push   $0xca
  801923:	68 aa 36 80 00       	push   $0x8036aa
  801928:	e8 e7 ea ff ff       	call   800414 <_panic>

0080192d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801933:	e8 58 fd ff ff       	call   801690 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	68 04 37 80 00       	push   $0x803704
  801940:	68 ea 00 00 00       	push   $0xea
  801945:	68 aa 36 80 00       	push   $0x8036aa
  80194a:	e8 c5 ea ff ff       	call   800414 <_panic>

0080194f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	68 2c 37 80 00       	push   $0x80372c
  80195d:	68 fe 00 00 00       	push   $0xfe
  801962:	68 aa 36 80 00       	push   $0x8036aa
  801967:	e8 a8 ea ff ff       	call   800414 <_panic>

0080196c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 50 37 80 00       	push   $0x803750
  80197a:	68 08 01 00 00       	push   $0x108
  80197f:	68 aa 36 80 00       	push   $0x8036aa
  801984:	e8 8b ea ff ff       	call   800414 <_panic>

00801989 <shrink>:

}
void shrink(uint32 newSize)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	68 50 37 80 00       	push   $0x803750
  801997:	68 0d 01 00 00       	push   $0x10d
  80199c:	68 aa 36 80 00       	push   $0x8036aa
  8019a1:	e8 6e ea ff ff       	call   800414 <_panic>

008019a6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 50 37 80 00       	push   $0x803750
  8019b4:	68 12 01 00 00       	push   $0x112
  8019b9:	68 aa 36 80 00       	push   $0x8036aa
  8019be:	e8 51 ea ff ff       	call   800414 <_panic>

008019c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	57                   	push   %edi
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
  8019c9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019db:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019de:	cd 30                	int    $0x30
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	52                   	push   %edx
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	e8 b2 ff ff ff       	call   8019c3 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 01                	push   $0x1
  801a26:	e8 98 ff ff ff       	call   8019c3 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 05                	push   $0x5
  801a43:	e8 7b ff ff ff       	call   8019c3 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	56                   	push   %esi
  801a51:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a52:	8b 75 18             	mov    0x18(%ebp),%esi
  801a55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	56                   	push   %esi
  801a62:	53                   	push   %ebx
  801a63:	51                   	push   %ecx
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 06                	push   $0x6
  801a68:	e8 56 ff ff ff       	call   8019c3 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5d                   	pop    %ebp
  801a76:	c3                   	ret    

00801a77 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	6a 07                	push   $0x7
  801a8a:	e8 34 ff ff ff       	call   8019c3 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	6a 08                	push   $0x8
  801aa5:	e8 19 ff ff ff       	call   8019c3 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 09                	push   $0x9
  801abe:	e8 00 ff ff ff       	call   8019c3 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 0a                	push   $0xa
  801ad7:	e8 e7 fe ff ff       	call   8019c3 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 0b                	push   $0xb
  801af0:	e8 ce fe ff ff       	call   8019c3 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 0c                	push   $0xc
  801b09:	e8 b5 fe ff ff       	call   8019c3 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	6a 0d                	push   $0xd
  801b23:	e8 9b fe ff ff       	call   8019c3 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 0e                	push   $0xe
  801b3c:	e8 82 fe ff ff       	call   8019c3 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 11                	push   $0x11
  801b56:	e8 68 fe ff ff       	call   8019c3 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 12                	push   $0x12
  801b70:	e8 4e fe ff ff       	call   8019c3 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	90                   	nop
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_cputc>:


void
sys_cputc(const char c)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b87:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 13                	push   $0x13
  801b96:	e8 28 fe ff ff       	call   8019c3 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	90                   	nop
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 14                	push   $0x14
  801bb0:	e8 0e fe ff ff       	call   8019c3 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	50                   	push   %eax
  801bcb:	6a 15                	push   $0x15
  801bcd:	e8 f1 fd ff ff       	call   8019c3 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 18                	push   $0x18
  801bea:	e8 d4 fd ff ff       	call   8019c3 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	52                   	push   %edx
  801c04:	50                   	push   %eax
  801c05:	6a 16                	push   $0x16
  801c07:	e8 b7 fd ff ff       	call   8019c3 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	90                   	nop
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 17                	push   $0x17
  801c25:	e8 99 fd ff ff       	call   8019c3 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 45 10             	mov    0x10(%ebp),%eax
  801c39:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c3c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c3f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	51                   	push   %ecx
  801c49:	52                   	push   %edx
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	50                   	push   %eax
  801c4e:	6a 19                	push   $0x19
  801c50:	e8 6e fd ff ff       	call   8019c3 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 1a                	push   $0x1a
  801c6d:	e8 51 fd ff ff       	call   8019c3 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	51                   	push   %ecx
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	6a 1b                	push   $0x1b
  801c8c:	e8 32 fd ff ff       	call   8019c3 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	52                   	push   %edx
  801ca6:	50                   	push   %eax
  801ca7:	6a 1c                	push   $0x1c
  801ca9:	e8 15 fd ff ff       	call   8019c3 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 1d                	push   $0x1d
  801cc2:	e8 fc fc ff ff       	call   8019c3 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	ff 75 14             	pushl  0x14(%ebp)
  801cd7:	ff 75 10             	pushl  0x10(%ebp)
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	50                   	push   %eax
  801cde:	6a 1e                	push   $0x1e
  801ce0:	e8 de fc ff ff       	call   8019c3 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	50                   	push   %eax
  801cf9:	6a 1f                	push   $0x1f
  801cfb:	e8 c3 fc ff ff       	call   8019c3 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	50                   	push   %eax
  801d15:	6a 20                	push   $0x20
  801d17:	e8 a7 fc ff ff       	call   8019c3 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 02                	push   $0x2
  801d30:	e8 8e fc ff ff       	call   8019c3 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 03                	push   $0x3
  801d49:	e8 75 fc ff ff       	call   8019c3 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 04                	push   $0x4
  801d62:	e8 5c fc ff ff       	call   8019c3 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_exit_env>:


void sys_exit_env(void)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 21                	push   $0x21
  801d7b:	e8 43 fc ff ff       	call   8019c3 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	90                   	nop
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d8f:	8d 50 04             	lea    0x4(%eax),%edx
  801d92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 22                	push   $0x22
  801d9f:	e8 1f fc ff ff       	call   8019c3 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return result;
  801da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db0:	89 01                	mov    %eax,(%ecx)
  801db2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	c9                   	leave  
  801db9:	c2 04 00             	ret    $0x4

00801dbc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	ff 75 10             	pushl  0x10(%ebp)
  801dc6:	ff 75 0c             	pushl  0xc(%ebp)
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 10                	push   $0x10
  801dce:	e8 f0 fb ff ff       	call   8019c3 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 23                	push   $0x23
  801de8:	e8 d6 fb ff ff       	call   8019c3 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dfe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	50                   	push   %eax
  801e0b:	6a 24                	push   $0x24
  801e0d:	e8 b1 fb ff ff       	call   8019c3 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
	return ;
  801e15:	90                   	nop
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <rsttst>:
void rsttst()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 26                	push   $0x26
  801e27:	e8 97 fb ff ff       	call   8019c3 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2f:	90                   	nop
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801e41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e45:	52                   	push   %edx
  801e46:	50                   	push   %eax
  801e47:	ff 75 10             	pushl  0x10(%ebp)
  801e4a:	ff 75 0c             	pushl  0xc(%ebp)
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	6a 25                	push   $0x25
  801e52:	e8 6c fb ff ff       	call   8019c3 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5a:	90                   	nop
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <chktst>:
void chktst(uint32 n)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	ff 75 08             	pushl  0x8(%ebp)
  801e6b:	6a 27                	push   $0x27
  801e6d:	e8 51 fb ff ff       	call   8019c3 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
	return ;
  801e75:	90                   	nop
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <inctst>:

void inctst()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 28                	push   $0x28
  801e87:	e8 37 fb ff ff       	call   8019c3 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <gettst>:
uint32 gettst()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 29                	push   $0x29
  801ea1:	e8 1d fb ff ff       	call   8019c3 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 2a                	push   $0x2a
  801ebd:	e8 01 fb ff ff       	call   8019c3 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
  801ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ec8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ecc:	75 07                	jne    801ed5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	eb 05                	jmp    801eda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 2a                	push   $0x2a
  801eee:	e8 d0 fa ff ff       	call   8019c3 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
  801ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ef9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801efd:	75 07                	jne    801f06 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eff:	b8 01 00 00 00       	mov    $0x1,%eax
  801f04:	eb 05                	jmp    801f0b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 2a                	push   $0x2a
  801f1f:	e8 9f fa ff ff       	call   8019c3 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
  801f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f2e:	75 07                	jne    801f37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f30:	b8 01 00 00 00       	mov    $0x1,%eax
  801f35:	eb 05                	jmp    801f3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2a                	push   $0x2a
  801f50:	e8 6e fa ff ff       	call   8019c3 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
  801f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f5b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f5f:	75 07                	jne    801f68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb 05                	jmp    801f6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	ff 75 08             	pushl  0x8(%ebp)
  801f7d:	6a 2b                	push   $0x2b
  801f7f:	e8 3f fa ff ff       	call   8019c3 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
	return ;
  801f87:	90                   	nop
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f8e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	53                   	push   %ebx
  801f9d:	51                   	push   %ecx
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 2c                	push   $0x2c
  801fa2:	e8 1c fa ff ff       	call   8019c3 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 2d                	push   $0x2d
  801fc2:	e8 fc f9 ff ff       	call   8019c3 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	6a 00                	push   $0x0
  801fda:	51                   	push   %ecx
  801fdb:	ff 75 10             	pushl  0x10(%ebp)
  801fde:	52                   	push   %edx
  801fdf:	50                   	push   %eax
  801fe0:	6a 2e                	push   $0x2e
  801fe2:	e8 dc f9 ff ff       	call   8019c3 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	ff 75 10             	pushl  0x10(%ebp)
  801ff6:	ff 75 0c             	pushl  0xc(%ebp)
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	6a 0f                	push   $0xf
  801ffe:	e8 c0 f9 ff ff       	call   8019c3 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return ;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	50                   	push   %eax
  802018:	6a 2f                	push   $0x2f
  80201a:	e8 a4 f9 ff ff       	call   8019c3 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp

}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	6a 30                	push   $0x30
  802035:	e8 89 f9 ff ff       	call   8019c3 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp

}
  80203d:	90                   	nop
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	ff 75 08             	pushl  0x8(%ebp)
  80204f:	6a 31                	push   $0x31
  802051:	e8 6d f9 ff ff       	call   8019c3 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp

}
  802059:	90                   	nop
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_hard_limit>:
uint32 sys_hard_limit(){
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 32                	push   $0x32
  80206b:	e8 53 f9 ff ff       	call   8019c3 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	83 e8 10             	sub    $0x10,%eax
  802081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  802084:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802087:	8b 00                	mov    (%eax),%eax
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	83 e8 10             	sub    $0x10,%eax
  802097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  80209a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209d:	8a 40 04             	mov    0x4(%eax),%al
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b2:	83 f8 02             	cmp    $0x2,%eax
  8020b5:	74 2b                	je     8020e2 <alloc_block+0x40>
  8020b7:	83 f8 02             	cmp    $0x2,%eax
  8020ba:	7f 07                	jg     8020c3 <alloc_block+0x21>
  8020bc:	83 f8 01             	cmp    $0x1,%eax
  8020bf:	74 0e                	je     8020cf <alloc_block+0x2d>
  8020c1:	eb 58                	jmp    80211b <alloc_block+0x79>
  8020c3:	83 f8 03             	cmp    $0x3,%eax
  8020c6:	74 2d                	je     8020f5 <alloc_block+0x53>
  8020c8:	83 f8 04             	cmp    $0x4,%eax
  8020cb:	74 3b                	je     802108 <alloc_block+0x66>
  8020cd:	eb 4c                	jmp    80211b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	e8 a6 01 00 00       	call   802280 <alloc_block_FF>
  8020da:	83 c4 10             	add    $0x10,%esp
  8020dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e0:	eb 4a                	jmp    80212c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	ff 75 08             	pushl  0x8(%ebp)
  8020e8:	e8 1d 06 00 00       	call   80270a <alloc_block_NF>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f3:	eb 37                	jmp    80212c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	e8 94 04 00 00       	call   802594 <alloc_block_BF>
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802106:	eb 24                	jmp    80212c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	ff 75 08             	pushl  0x8(%ebp)
  80210e:	e8 da 05 00 00       	call   8026ed <alloc_block_WF>
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802119:	eb 11                	jmp    80212c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	68 60 37 80 00       	push   $0x803760
  802123:	e8 a9 e5 ff ff       	call   8006d1 <cprintf>
  802128:	83 c4 10             	add    $0x10,%esp
		break;
  80212b:	90                   	nop
	}
	return va;
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	68 80 37 80 00       	push   $0x803780
  80213f:	e8 8d e5 ff ff       	call   8006d1 <cprintf>
  802144:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	68 ab 37 80 00       	push   $0x8037ab
  80214f:	e8 7d e5 ff ff       	call   8006d1 <cprintf>
  802154:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	eb 26                	jmp    802185 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8a 40 04             	mov    0x4(%eax),%al
  802165:	0f b6 d0             	movzbl %al,%edx
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 00                	mov    (%eax),%eax
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	68 c3 37 80 00       	push   $0x8037c3
  802177:	e8 55 e5 ff ff       	call   8006d1 <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80217f:	8b 45 10             	mov    0x10(%ebp),%eax
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802189:	74 08                	je     802193 <print_blocks_list+0x62>
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 40 08             	mov    0x8(%eax),%eax
  802191:	eb 05                	jmp    802198 <print_blocks_list+0x67>
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	89 45 10             	mov    %eax,0x10(%ebp)
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	75 bd                	jne    80215f <print_blocks_list+0x2e>
  8021a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a6:	75 b7                	jne    80215f <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	68 80 37 80 00       	push   $0x803780
  8021b0:	e8 1c e5 ff ff       	call   8006d1 <cprintf>
  8021b5:	83 c4 10             	add    $0x10,%esp

}
  8021b8:	90                   	nop
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  8021c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021c5:	0f 84 b2 00 00 00    	je     80227d <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  8021cb:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  8021d2:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  8021d5:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  8021dc:	00 00 00 
  8021df:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  8021e6:	00 00 00 
  8021e9:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  8021f0:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  8021fb:	a1 24 41 80 00       	mov    0x804124,%eax
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  802205:	a1 24 41 80 00       	mov    0x804124,%eax
  80220a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  80220e:	a1 24 41 80 00       	mov    0x804124,%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	75 14                	jne    80222b <initialize_dynamic_allocator+0x70>
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	68 dc 37 80 00       	push   $0x8037dc
  80221f:	6a 68                	push   $0x68
  802221:	68 ff 37 80 00       	push   $0x8037ff
  802226:	e8 e9 e1 ff ff       	call   800414 <_panic>
  80222b:	a1 24 41 80 00       	mov    0x804124,%eax
  802230:	8b 15 14 41 80 00    	mov    0x804114,%edx
  802236:	89 50 08             	mov    %edx,0x8(%eax)
  802239:	8b 40 08             	mov    0x8(%eax),%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	74 10                	je     802250 <initialize_dynamic_allocator+0x95>
  802240:	a1 14 41 80 00       	mov    0x804114,%eax
  802245:	8b 15 24 41 80 00    	mov    0x804124,%edx
  80224b:	89 50 0c             	mov    %edx,0xc(%eax)
  80224e:	eb 0a                	jmp    80225a <initialize_dynamic_allocator+0x9f>
  802250:	a1 24 41 80 00       	mov    0x804124,%eax
  802255:	a3 18 41 80 00       	mov    %eax,0x804118
  80225a:	a1 24 41 80 00       	mov    0x804124,%eax
  80225f:	a3 14 41 80 00       	mov    %eax,0x804114
  802264:	a1 24 41 80 00       	mov    0x804124,%eax
  802269:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802270:	a1 20 41 80 00       	mov    0x804120,%eax
  802275:	40                   	inc    %eax
  802276:	a3 20 41 80 00       	mov    %eax,0x804120
  80227b:	eb 01                	jmp    80227e <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80227d:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  802286:	a1 2c 40 80 00       	mov    0x80402c,%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 40                	jne    8022cf <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	83 c0 10             	add    $0x10,%eax
  802295:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	50                   	push   %eax
  80229f:	e8 05 f4 ff ff       	call   8016a9 <sbrk>
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	6a 00                	push   $0x0
  8022af:	e8 f5 f3 ff ff       	call   8016a9 <sbrk>
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  8022ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022bd:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8022c0:	83 ec 08             	sub    $0x8,%esp
  8022c3:	50                   	push   %eax
  8022c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8022c7:	e8 ef fe ff ff       	call   8021bb <initialize_dynamic_allocator>
  8022cc:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  8022cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d3:	75 0a                	jne    8022df <alloc_block_FF+0x5f>
		 return NULL;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	e9 b3 02 00 00       	jmp    802592 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  8022df:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  8022e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  8022ea:	a1 14 41 80 00       	mov    0x804114,%eax
  8022ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f2:	e9 12 01 00 00       	jmp    802409 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8a 40 04             	mov    0x4(%eax),%al
  8022fd:	84 c0                	test   %al,%al
  8022ff:	0f 84 fc 00 00 00    	je     802401 <alloc_block_FF+0x181>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230d:	0f 82 ee 00 00 00    	jb     802401 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231b:	75 12                	jne    80232f <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	83 c0 10             	add    $0x10,%eax
  80232a:	e9 63 02 00 00       	jmp    802592 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  80232f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	2b 45 08             	sub    0x8(%ebp),%eax
  802345:	83 f8 0f             	cmp    $0xf,%eax
  802348:	0f 86 a8 00 00 00    	jbe    8023f6 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  80234e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	01 d0                	add    %edx,%eax
  802356:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	2b 45 08             	sub    0x8(%ebp),%eax
  802361:	89 c2                	mov    %eax,%edx
  802363:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802366:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 55 08             	mov    0x8(%ebp),%edx
  80236e:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802370:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802373:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	74 06                	je     802383 <alloc_block_FF+0x103>
  80237d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802381:	75 17                	jne    80239a <alloc_block_FF+0x11a>
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	68 18 38 80 00       	push   $0x803818
  80238b:	68 91 00 00 00       	push   $0x91
  802390:	68 ff 37 80 00       	push   $0x8037ff
  802395:	e8 7a e0 ff ff       	call   800414 <_panic>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 50 08             	mov    0x8(%eax),%edx
  8023a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a3:	89 50 08             	mov    %edx,0x8(%eax)
  8023a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a9:	8b 40 08             	mov    0x8(%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 0c                	je     8023bc <alloc_block_FF+0x13c>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 40 08             	mov    0x8(%eax),%eax
  8023b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023b9:	89 50 0c             	mov    %edx,0xc(%eax)
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023c2:	89 50 08             	mov    %edx,0x8(%eax)
  8023c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cb:	89 50 0c             	mov    %edx,0xc(%eax)
  8023ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d1:	8b 40 08             	mov    0x8(%eax),%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	75 08                	jne    8023e0 <alloc_block_FF+0x160>
  8023d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023db:	a3 18 41 80 00       	mov    %eax,0x804118
  8023e0:	a1 20 41 80 00       	mov    0x804120,%eax
  8023e5:	40                   	inc    %eax
  8023e6:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	83 c0 10             	add    $0x10,%eax
  8023f1:	e9 9c 01 00 00       	jmp    802592 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	83 c0 10             	add    $0x10,%eax
  8023fc:	e9 91 01 00 00       	jmp    802592 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802401:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 08                	je     802417 <alloc_block_FF+0x197>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 08             	mov    0x8(%eax),%eax
  802415:	eb 05                	jmp    80241c <alloc_block_FF+0x19c>
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802421:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	0f 85 c9 fe ff ff    	jne    8022f7 <alloc_block_FF+0x77>
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	0f 85 bf fe ff ff    	jne    8022f7 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802438:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80243c:	0f 85 4b 01 00 00    	jne    80258d <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	50                   	push   %eax
  802449:	e8 5b f2 ff ff       	call   8016a9 <sbrk>
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	0f 84 28 01 00 00    	je     802586 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802467:	8b 55 08             	mov    0x8(%ebp),%edx
  80246a:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  80246c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802473:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802477:	75 17                	jne    802490 <alloc_block_FF+0x210>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 4c 38 80 00       	push   $0x80384c
  802481:	68 a1 00 00 00       	push   $0xa1
  802486:	68 ff 37 80 00       	push   $0x8037ff
  80248b:	e8 84 df ff ff       	call   800414 <_panic>
  802490:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802499:	89 50 0c             	mov    %edx,0xc(%eax)
  80249c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	74 0d                	je     8024b3 <alloc_block_FF+0x233>
  8024a6:	a1 18 41 80 00       	mov    0x804118,%eax
  8024ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024ae:	89 50 08             	mov    %edx,0x8(%eax)
  8024b1:	eb 08                	jmp    8024bb <alloc_block_FF+0x23b>
  8024b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b6:	a3 14 41 80 00       	mov    %eax,0x804114
  8024bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024be:	a3 18 41 80 00       	mov    %eax,0x804118
  8024c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024cd:	a1 20 41 80 00       	mov    0x804120,%eax
  8024d2:	40                   	inc    %eax
  8024d3:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  8024d8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e0:	83 f8 0f             	cmp    $0xf,%eax
  8024e3:	0f 86 95 00 00 00    	jbe    80257e <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  8024e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  8024f4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802501:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802503:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802506:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  80250a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80250e:	74 06                	je     802516 <alloc_block_FF+0x296>
  802510:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_FF+0x2ad>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 18 38 80 00       	push   $0x803818
  80251e:	68 a6 00 00 00       	push   $0xa6
  802523:	68 ff 37 80 00       	push   $0x8037ff
  802528:	e8 e7 de ff ff       	call   800414 <_panic>
  80252d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802536:	89 50 08             	mov    %edx,0x8(%eax)
  802539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253c:	8b 40 08             	mov    0x8(%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 0c                	je     80254f <alloc_block_FF+0x2cf>
  802543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802546:	8b 40 08             	mov    0x8(%eax),%eax
  802549:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254c:	89 50 0c             	mov    %edx,0xc(%eax)
  80254f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802552:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802555:	89 50 08             	mov    %edx,0x8(%eax)
  802558:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80255b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80255e:	89 50 0c             	mov    %edx,0xc(%eax)
  802561:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802564:	8b 40 08             	mov    0x8(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	75 08                	jne    802573 <alloc_block_FF+0x2f3>
  80256b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256e:	a3 18 41 80 00       	mov    %eax,0x804118
  802573:	a1 20 41 80 00       	mov    0x804120,%eax
  802578:	40                   	inc    %eax
  802579:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  80257e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802581:	83 c0 10             	add    $0x10,%eax
  802584:	eb 0c                	jmp    802592 <alloc_block_FF+0x312>
		 }
		 return NULL;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	eb 05                	jmp    802592 <alloc_block_FF+0x312>
	 }
	 return NULL;
  80258d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  80259a:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  80259e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  8025a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  8025ac:	a1 14 41 80 00       	mov    0x804114,%eax
  8025b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025b4:	eb 34                	jmp    8025ea <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8a 40 04             	mov    0x4(%eax),%al
  8025bc:	84 c0                	test   %al,%al
  8025be:	74 22                	je     8025e2 <alloc_block_BF+0x4e>
  8025c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c8:	72 18                	jb     8025e2 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025d2:	73 0e                	jae    8025e2 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  8025d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  8025da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  8025e2:	a1 1c 41 80 00       	mov    0x80411c,%eax
  8025e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ee:	74 08                	je     8025f8 <alloc_block_BF+0x64>
  8025f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f3:	8b 40 08             	mov    0x8(%eax),%eax
  8025f6:	eb 05                	jmp    8025fd <alloc_block_BF+0x69>
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802602:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	75 ab                	jne    8025b6 <alloc_block_BF+0x22>
  80260b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260f:	75 a5                	jne    8025b6 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	0f 84 cb 00 00 00    	je     8026e6 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262a:	0f 86 ae 00 00 00    	jbe    8026de <alloc_block_BF+0x14a>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	2b 45 08             	sub    0x8(%ebp),%eax
  802638:	83 f8 0f             	cmp    $0xf,%eax
  80263b:	0f 86 9d 00 00 00    	jbe    8026de <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	01 d0                	add    %edx,%eax
  802649:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	2b 45 08             	sub    0x8(%ebp),%eax
  802654:	89 c2                	mov    %eax,%edx
  802656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802659:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  80265b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 55 08             	mov    0x8(%ebp),%edx
  802668:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  80266a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266e:	74 06                	je     802676 <alloc_block_BF+0xe2>
  802670:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802674:	75 17                	jne    80268d <alloc_block_BF+0xf9>
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	68 18 38 80 00       	push   $0x803818
  80267e:	68 c6 00 00 00       	push   $0xc6
  802683:	68 ff 37 80 00       	push   $0x8037ff
  802688:	e8 87 dd ff ff       	call   800414 <_panic>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 50 08             	mov    0x8(%eax),%edx
  802693:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802696:	89 50 08             	mov    %edx,0x8(%eax)
  802699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269c:	8b 40 08             	mov    0x8(%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 0c                	je     8026af <alloc_block_BF+0x11b>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 08             	mov    0x8(%eax),%eax
  8026a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ac:	89 50 0c             	mov    %edx,0xc(%eax)
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
  8026b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	89 50 0c             	mov    %edx,0xc(%eax)
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 40 08             	mov    0x8(%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	75 08                	jne    8026d3 <alloc_block_BF+0x13f>
  8026cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ce:	a3 18 41 80 00       	mov    %eax,0x804118
  8026d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8026d8:	40                   	inc    %eax
  8026d9:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	83 c0 10             	add    $0x10,%eax
  8026e4:	eb 05                	jmp    8026eb <alloc_block_BF+0x157>
    }

    return NULL;
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	68 70 38 80 00       	push   $0x803870
  8026fb:	68 d2 00 00 00       	push   $0xd2
  802700:	68 ff 37 80 00       	push   $0x8037ff
  802705:	e8 0a dd ff ff       	call   800414 <_panic>

0080270a <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 98 38 80 00       	push   $0x803898
  802718:	68 db 00 00 00       	push   $0xdb
  80271d:	68 ff 37 80 00       	push   $0x8037ff
  802722:	e8 ed dc ff ff       	call   800414 <_panic>

00802727 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  80272d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802731:	0f 84 d2 01 00 00    	je     802909 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	83 e8 10             	sub    $0x10,%eax
  80273d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8a 40 04             	mov    0x4(%eax),%al
  802746:	84 c0                	test   %al,%al
  802748:	0f 85 be 01 00 00    	jne    80290c <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 08             	mov    0x8(%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	0f 84 cc 00 00 00    	je     80282f <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 40 08             	mov    0x8(%eax),%eax
  802769:	8a 40 04             	mov    0x4(%eax),%al
  80276c:	84 c0                	test   %al,%al
  80276e:	0f 84 bb 00 00 00    	je     80282f <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 10                	mov    (%eax),%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 08             	mov    0x8(%eax),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	01 c2                	add    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 08             	mov    0x8(%eax),%eax
  80278e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 08             	mov    0x8(%eax),%eax
  802798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 08             	mov    0x8(%eax),%eax
  8027a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  8027a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ab:	75 17                	jne    8027c4 <free_block+0x9d>
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	68 be 38 80 00       	push   $0x8038be
  8027b5:	68 f8 00 00 00       	push   $0xf8
  8027ba:	68 ff 37 80 00       	push   $0x8037ff
  8027bf:	e8 50 dc ff ff       	call   800414 <_panic>
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 11                	je     8027df <free_block+0xb8>
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	8b 40 08             	mov    0x8(%eax),%eax
  8027d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8027da:	89 50 0c             	mov    %edx,0xc(%eax)
  8027dd:	eb 0b                	jmp    8027ea <free_block+0xc3>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e5:	a3 18 41 80 00       	mov    %eax,0x804118
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 11                	je     802805 <free_block+0xde>
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fd:	8b 52 08             	mov    0x8(%edx),%edx
  802800:	89 50 08             	mov    %edx,0x8(%eax)
  802803:	eb 0b                	jmp    802810 <free_block+0xe9>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 40 08             	mov    0x8(%eax),%eax
  80280b:	a3 14 41 80 00       	mov    %eax,0x804114
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802824:	a1 20 41 80 00       	mov    0x804120,%eax
  802829:	48                   	dec    %eax
  80282a:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 0c             	mov    0xc(%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	0f 84 d0 00 00 00    	je     80290d <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	8a 40 04             	mov    0x4(%eax),%al
  802846:	84 c0                	test   %al,%al
  802848:	0f 84 bf 00 00 00    	je     80290d <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 0c             	mov    0xc(%eax),%eax
  802854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802857:	8b 52 0c             	mov    0xc(%edx),%edx
  80285a:	8b 0a                	mov    (%edx),%ecx
  80285c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285f:	8b 12                	mov    (%edx),%edx
  802861:	01 ca                	add    %ecx,%edx
  802863:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 0c             	mov    0xc(%eax),%eax
  80286b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  80287f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802883:	75 17                	jne    80289c <free_block+0x175>
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	68 be 38 80 00       	push   $0x8038be
  80288d:	68 03 01 00 00       	push   $0x103
  802892:	68 ff 37 80 00       	push   $0x8037ff
  802897:	e8 78 db ff ff       	call   800414 <_panic>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 08             	mov    0x8(%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 11                	je     8028b7 <free_block+0x190>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 52 0c             	mov    0xc(%edx),%edx
  8028b2:	89 50 0c             	mov    %edx,0xc(%eax)
  8028b5:	eb 0b                	jmp    8028c2 <free_block+0x19b>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	a3 18 41 80 00       	mov    %eax,0x804118
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 11                	je     8028dd <free_block+0x1b6>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d5:	8b 52 08             	mov    0x8(%edx),%edx
  8028d8:	89 50 08             	mov    %edx,0x8(%eax)
  8028db:	eb 0b                	jmp    8028e8 <free_block+0x1c1>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 08             	mov    0x8(%eax),%eax
  8028e3:	a3 14 41 80 00       	mov    %eax,0x804114
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028fc:	a1 20 41 80 00       	mov    0x804120,%eax
  802901:	48                   	dec    %eax
  802902:	a3 20 41 80 00       	mov    %eax,0x804120
  802907:	eb 04                	jmp    80290d <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802909:	90                   	nop
  80290a:	eb 01                	jmp    80290d <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  80290c:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  80290d:	c9                   	leave  
  80290e:	c3                   	ret    

0080290f <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802915:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802919:	75 10                	jne    80292b <realloc_block_FF+0x1c>
  80291b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80291f:	75 0a                	jne    80292b <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802921:	b8 00 00 00 00       	mov    $0x0,%eax
  802926:	e9 2e 03 00 00       	jmp    802c59 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  80292b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292f:	75 13                	jne    802944 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	ff 75 0c             	pushl  0xc(%ebp)
  802937:	e8 44 f9 ff ff       	call   802280 <alloc_block_FF>
  80293c:	83 c4 10             	add    $0x10,%esp
  80293f:	e9 15 03 00 00       	jmp    802c59 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  802944:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802948:	75 18                	jne    802962 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	ff 75 08             	pushl  0x8(%ebp)
  802950:	e8 d2 fd ff ff       	call   802727 <free_block>
  802955:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	e9 f7 02 00 00       	jmp    802c59 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	83 e8 10             	sub    $0x10,%eax
  802968:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  80296b:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802977:	0f 82 c8 00 00 00    	jb     802a45 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802985:	75 08                	jne    80298f <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	e9 ca 02 00 00       	jmp    802c59 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	2b 45 0c             	sub    0xc(%ebp),%eax
  802997:	83 f8 0f             	cmp    $0xf,%eax
  80299a:	0f 86 9d 00 00 00    	jbe    802a3d <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  8029a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8029b3:	89 c2                	mov    %eax,%edx
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c0:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	74 06                	je     8029d5 <realloc_block_FF+0xc6>
  8029cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d3:	75 17                	jne    8029ec <realloc_block_FF+0xdd>
  8029d5:	83 ec 04             	sub    $0x4,%esp
  8029d8:	68 18 38 80 00       	push   $0x803818
  8029dd:	68 2a 01 00 00       	push   $0x12a
  8029e2:	68 ff 37 80 00       	push   $0x8037ff
  8029e7:	e8 28 da ff ff       	call   800414 <_panic>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 50 08             	mov    0x8(%eax),%edx
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	89 50 08             	mov    %edx,0x8(%eax)
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 40 08             	mov    0x8(%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 0c                	je     802a0e <realloc_block_FF+0xff>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 40 08             	mov    0x8(%eax),%eax
  802a08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0b:	89 50 0c             	mov    %edx,0xc(%eax)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a14:	89 50 08             	mov    %edx,0x8(%eax)
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	75 08                	jne    802a32 <realloc_block_FF+0x123>
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	a3 18 41 80 00       	mov    %eax,0x804118
  802a32:	a1 20 41 80 00       	mov    0x804120,%eax
  802a37:	40                   	inc    %eax
  802a38:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	e9 14 02 00 00       	jmp    802c59 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 08             	mov    0x8(%eax),%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	0f 84 97 01 00 00    	je     802bea <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	8a 40 04             	mov    0x4(%eax),%al
  802a5c:	84 c0                	test   %al,%al
  802a5e:	0f 84 86 01 00 00    	je     802bea <realloc_block_FF+0x2db>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 10                	mov    (%eax),%edx
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 08             	mov    0x8(%eax),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	01 d0                	add    %edx,%eax
  802a73:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a76:	0f 82 6e 01 00 00    	jb     802bea <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 10                	mov    (%eax),%edx
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 08             	mov    0x8(%eax),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	01 c2                	add    %eax,%edx
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 08             	mov    0x8(%eax),%eax
  802a96:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  802aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab3:	75 17                	jne    802acc <realloc_block_FF+0x1bd>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 be 38 80 00       	push   $0x8038be
  802abd:	68 38 01 00 00       	push   $0x138
  802ac2:	68 ff 37 80 00       	push   $0x8037ff
  802ac7:	e8 48 d9 ff ff       	call   800414 <_panic>
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 11                	je     802ae7 <realloc_block_FF+0x1d8>
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802adf:	8b 52 0c             	mov    0xc(%edx),%edx
  802ae2:	89 50 0c             	mov    %edx,0xc(%eax)
  802ae5:	eb 0b                	jmp    802af2 <realloc_block_FF+0x1e3>
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 40 0c             	mov    0xc(%eax),%eax
  802aed:	a3 18 41 80 00       	mov    %eax,0x804118
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	8b 40 0c             	mov    0xc(%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	74 11                	je     802b0d <realloc_block_FF+0x1fe>
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b05:	8b 52 08             	mov    0x8(%edx),%edx
  802b08:	89 50 08             	mov    %edx,0x8(%eax)
  802b0b:	eb 0b                	jmp    802b18 <realloc_block_FF+0x209>
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	8b 40 08             	mov    0x8(%eax),%eax
  802b13:	a3 14 41 80 00       	mov    %eax,0x804114
  802b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b2c:	a1 20 41 80 00       	mov    0x804120,%eax
  802b31:	48                   	dec    %eax
  802b32:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b3f:	83 f8 0f             	cmp    $0xf,%eax
  802b42:	0f 86 9d 00 00 00    	jbe    802be5 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b5b:	89 c2                	mov    %eax,%edx
  802b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b60:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b68:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  802b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  802b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b75:	74 06                	je     802b7d <realloc_block_FF+0x26e>
  802b77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b7b:	75 17                	jne    802b94 <realloc_block_FF+0x285>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 18 38 80 00       	push   $0x803818
  802b85:	68 3f 01 00 00       	push   $0x13f
  802b8a:	68 ff 37 80 00       	push   $0x8037ff
  802b8f:	e8 80 d8 ff ff       	call   800414 <_panic>
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	89 50 08             	mov    %edx,0x8(%eax)
  802ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0c                	je     802bb6 <realloc_block_FF+0x2a7>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 08             	mov    0x8(%eax),%eax
  802bb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb3:	89 50 0c             	mov    %edx,0xc(%eax)
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bbc:	89 50 08             	mov    %edx,0x8(%eax)
  802bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc5:	89 50 0c             	mov    %edx,0xc(%eax)
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	75 08                	jne    802bda <realloc_block_FF+0x2cb>
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	a3 18 41 80 00       	mov    %eax,0x804118
  802bda:	a1 20 41 80 00       	mov    0x804120,%eax
  802bdf:	40                   	inc    %eax
  802be0:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	eb 6f                	jmp    802c59 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  802bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bed:	83 e8 10             	sub    $0x10,%eax
  802bf0:	83 ec 0c             	sub    $0xc,%esp
  802bf3:	50                   	push   %eax
  802bf4:	e8 87 f6 ff ff       	call   802280 <alloc_block_FF>
  802bf9:	83 c4 10             	add    $0x10,%esp
  802bfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  802bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c03:	75 29                	jne    802c2e <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  802c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c08:	83 ec 0c             	sub    $0xc,%esp
  802c0b:	50                   	push   %eax
  802c0c:	e8 98 ea ff ff       	call   8016a9 <sbrk>
  802c11:	83 c4 10             	add    $0x10,%esp
  802c14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  802c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1a:	83 f8 ff             	cmp    $0xffffffff,%eax
  802c1d:	75 07                	jne    802c26 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c24:	eb 33                	jmp    802c59 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  802c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c29:	83 c0 10             	add    $0x10,%eax
  802c2c:	eb 2b                	jmp    802c59 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	83 ec 04             	sub    $0x4,%esp
  802c36:	50                   	push   %eax
  802c37:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c3d:	e8 2f e3 ff ff       	call   800f71 <memcpy>
  802c42:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  802c45:	83 ec 0c             	sub    $0xc,%esp
  802c48:	ff 75 f4             	pushl  -0xc(%ebp)
  802c4b:	e8 d7 fa ff ff       	call   802727 <free_block>
  802c50:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  802c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c56:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    
  802c5b:	90                   	nop

00802c5c <__udivdi3>:
  802c5c:	55                   	push   %ebp
  802c5d:	57                   	push   %edi
  802c5e:	56                   	push   %esi
  802c5f:	53                   	push   %ebx
  802c60:	83 ec 1c             	sub    $0x1c,%esp
  802c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c73:	89 ca                	mov    %ecx,%edx
  802c75:	89 f8                	mov    %edi,%eax
  802c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802c7b:	85 f6                	test   %esi,%esi
  802c7d:	75 2d                	jne    802cac <__udivdi3+0x50>
  802c7f:	39 cf                	cmp    %ecx,%edi
  802c81:	77 65                	ja     802ce8 <__udivdi3+0x8c>
  802c83:	89 fd                	mov    %edi,%ebp
  802c85:	85 ff                	test   %edi,%edi
  802c87:	75 0b                	jne    802c94 <__udivdi3+0x38>
  802c89:	b8 01 00 00 00       	mov    $0x1,%eax
  802c8e:	31 d2                	xor    %edx,%edx
  802c90:	f7 f7                	div    %edi
  802c92:	89 c5                	mov    %eax,%ebp
  802c94:	31 d2                	xor    %edx,%edx
  802c96:	89 c8                	mov    %ecx,%eax
  802c98:	f7 f5                	div    %ebp
  802c9a:	89 c1                	mov    %eax,%ecx
  802c9c:	89 d8                	mov    %ebx,%eax
  802c9e:	f7 f5                	div    %ebp
  802ca0:	89 cf                	mov    %ecx,%edi
  802ca2:	89 fa                	mov    %edi,%edx
  802ca4:	83 c4 1c             	add    $0x1c,%esp
  802ca7:	5b                   	pop    %ebx
  802ca8:	5e                   	pop    %esi
  802ca9:	5f                   	pop    %edi
  802caa:	5d                   	pop    %ebp
  802cab:	c3                   	ret    
  802cac:	39 ce                	cmp    %ecx,%esi
  802cae:	77 28                	ja     802cd8 <__udivdi3+0x7c>
  802cb0:	0f bd fe             	bsr    %esi,%edi
  802cb3:	83 f7 1f             	xor    $0x1f,%edi
  802cb6:	75 40                	jne    802cf8 <__udivdi3+0x9c>
  802cb8:	39 ce                	cmp    %ecx,%esi
  802cba:	72 0a                	jb     802cc6 <__udivdi3+0x6a>
  802cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802cc0:	0f 87 9e 00 00 00    	ja     802d64 <__udivdi3+0x108>
  802cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ccb:	89 fa                	mov    %edi,%edx
  802ccd:	83 c4 1c             	add    $0x1c,%esp
  802cd0:	5b                   	pop    %ebx
  802cd1:	5e                   	pop    %esi
  802cd2:	5f                   	pop    %edi
  802cd3:	5d                   	pop    %ebp
  802cd4:	c3                   	ret    
  802cd5:	8d 76 00             	lea    0x0(%esi),%esi
  802cd8:	31 ff                	xor    %edi,%edi
  802cda:	31 c0                	xor    %eax,%eax
  802cdc:	89 fa                	mov    %edi,%edx
  802cde:	83 c4 1c             	add    $0x1c,%esp
  802ce1:	5b                   	pop    %ebx
  802ce2:	5e                   	pop    %esi
  802ce3:	5f                   	pop    %edi
  802ce4:	5d                   	pop    %ebp
  802ce5:	c3                   	ret    
  802ce6:	66 90                	xchg   %ax,%ax
  802ce8:	89 d8                	mov    %ebx,%eax
  802cea:	f7 f7                	div    %edi
  802cec:	31 ff                	xor    %edi,%edi
  802cee:	89 fa                	mov    %edi,%edx
  802cf0:	83 c4 1c             	add    $0x1c,%esp
  802cf3:	5b                   	pop    %ebx
  802cf4:	5e                   	pop    %esi
  802cf5:	5f                   	pop    %edi
  802cf6:	5d                   	pop    %ebp
  802cf7:	c3                   	ret    
  802cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802cfd:	89 eb                	mov    %ebp,%ebx
  802cff:	29 fb                	sub    %edi,%ebx
  802d01:	89 f9                	mov    %edi,%ecx
  802d03:	d3 e6                	shl    %cl,%esi
  802d05:	89 c5                	mov    %eax,%ebp
  802d07:	88 d9                	mov    %bl,%cl
  802d09:	d3 ed                	shr    %cl,%ebp
  802d0b:	89 e9                	mov    %ebp,%ecx
  802d0d:	09 f1                	or     %esi,%ecx
  802d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d13:	89 f9                	mov    %edi,%ecx
  802d15:	d3 e0                	shl    %cl,%eax
  802d17:	89 c5                	mov    %eax,%ebp
  802d19:	89 d6                	mov    %edx,%esi
  802d1b:	88 d9                	mov    %bl,%cl
  802d1d:	d3 ee                	shr    %cl,%esi
  802d1f:	89 f9                	mov    %edi,%ecx
  802d21:	d3 e2                	shl    %cl,%edx
  802d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d27:	88 d9                	mov    %bl,%cl
  802d29:	d3 e8                	shr    %cl,%eax
  802d2b:	09 c2                	or     %eax,%edx
  802d2d:	89 d0                	mov    %edx,%eax
  802d2f:	89 f2                	mov    %esi,%edx
  802d31:	f7 74 24 0c          	divl   0xc(%esp)
  802d35:	89 d6                	mov    %edx,%esi
  802d37:	89 c3                	mov    %eax,%ebx
  802d39:	f7 e5                	mul    %ebp
  802d3b:	39 d6                	cmp    %edx,%esi
  802d3d:	72 19                	jb     802d58 <__udivdi3+0xfc>
  802d3f:	74 0b                	je     802d4c <__udivdi3+0xf0>
  802d41:	89 d8                	mov    %ebx,%eax
  802d43:	31 ff                	xor    %edi,%edi
  802d45:	e9 58 ff ff ff       	jmp    802ca2 <__udivdi3+0x46>
  802d4a:	66 90                	xchg   %ax,%ax
  802d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802d50:	89 f9                	mov    %edi,%ecx
  802d52:	d3 e2                	shl    %cl,%edx
  802d54:	39 c2                	cmp    %eax,%edx
  802d56:	73 e9                	jae    802d41 <__udivdi3+0xe5>
  802d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d5b:	31 ff                	xor    %edi,%edi
  802d5d:	e9 40 ff ff ff       	jmp    802ca2 <__udivdi3+0x46>
  802d62:	66 90                	xchg   %ax,%ax
  802d64:	31 c0                	xor    %eax,%eax
  802d66:	e9 37 ff ff ff       	jmp    802ca2 <__udivdi3+0x46>
  802d6b:	90                   	nop

00802d6c <__umoddi3>:
  802d6c:	55                   	push   %ebp
  802d6d:	57                   	push   %edi
  802d6e:	56                   	push   %esi
  802d6f:	53                   	push   %ebx
  802d70:	83 ec 1c             	sub    $0x1c,%esp
  802d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d8b:	89 f3                	mov    %esi,%ebx
  802d8d:	89 fa                	mov    %edi,%edx
  802d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d93:	89 34 24             	mov    %esi,(%esp)
  802d96:	85 c0                	test   %eax,%eax
  802d98:	75 1a                	jne    802db4 <__umoddi3+0x48>
  802d9a:	39 f7                	cmp    %esi,%edi
  802d9c:	0f 86 a2 00 00 00    	jbe    802e44 <__umoddi3+0xd8>
  802da2:	89 c8                	mov    %ecx,%eax
  802da4:	89 f2                	mov    %esi,%edx
  802da6:	f7 f7                	div    %edi
  802da8:	89 d0                	mov    %edx,%eax
  802daa:	31 d2                	xor    %edx,%edx
  802dac:	83 c4 1c             	add    $0x1c,%esp
  802daf:	5b                   	pop    %ebx
  802db0:	5e                   	pop    %esi
  802db1:	5f                   	pop    %edi
  802db2:	5d                   	pop    %ebp
  802db3:	c3                   	ret    
  802db4:	39 f0                	cmp    %esi,%eax
  802db6:	0f 87 ac 00 00 00    	ja     802e68 <__umoddi3+0xfc>
  802dbc:	0f bd e8             	bsr    %eax,%ebp
  802dbf:	83 f5 1f             	xor    $0x1f,%ebp
  802dc2:	0f 84 ac 00 00 00    	je     802e74 <__umoddi3+0x108>
  802dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  802dcd:	29 ef                	sub    %ebp,%edi
  802dcf:	89 fe                	mov    %edi,%esi
  802dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dd5:	89 e9                	mov    %ebp,%ecx
  802dd7:	d3 e0                	shl    %cl,%eax
  802dd9:	89 d7                	mov    %edx,%edi
  802ddb:	89 f1                	mov    %esi,%ecx
  802ddd:	d3 ef                	shr    %cl,%edi
  802ddf:	09 c7                	or     %eax,%edi
  802de1:	89 e9                	mov    %ebp,%ecx
  802de3:	d3 e2                	shl    %cl,%edx
  802de5:	89 14 24             	mov    %edx,(%esp)
  802de8:	89 d8                	mov    %ebx,%eax
  802dea:	d3 e0                	shl    %cl,%eax
  802dec:	89 c2                	mov    %eax,%edx
  802dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  802df2:	d3 e0                	shl    %cl,%eax
  802df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dfc:	89 f1                	mov    %esi,%ecx
  802dfe:	d3 e8                	shr    %cl,%eax
  802e00:	09 d0                	or     %edx,%eax
  802e02:	d3 eb                	shr    %cl,%ebx
  802e04:	89 da                	mov    %ebx,%edx
  802e06:	f7 f7                	div    %edi
  802e08:	89 d3                	mov    %edx,%ebx
  802e0a:	f7 24 24             	mull   (%esp)
  802e0d:	89 c6                	mov    %eax,%esi
  802e0f:	89 d1                	mov    %edx,%ecx
  802e11:	39 d3                	cmp    %edx,%ebx
  802e13:	0f 82 87 00 00 00    	jb     802ea0 <__umoddi3+0x134>
  802e19:	0f 84 91 00 00 00    	je     802eb0 <__umoddi3+0x144>
  802e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e23:	29 f2                	sub    %esi,%edx
  802e25:	19 cb                	sbb    %ecx,%ebx
  802e27:	89 d8                	mov    %ebx,%eax
  802e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802e2d:	d3 e0                	shl    %cl,%eax
  802e2f:	89 e9                	mov    %ebp,%ecx
  802e31:	d3 ea                	shr    %cl,%edx
  802e33:	09 d0                	or     %edx,%eax
  802e35:	89 e9                	mov    %ebp,%ecx
  802e37:	d3 eb                	shr    %cl,%ebx
  802e39:	89 da                	mov    %ebx,%edx
  802e3b:	83 c4 1c             	add    $0x1c,%esp
  802e3e:	5b                   	pop    %ebx
  802e3f:	5e                   	pop    %esi
  802e40:	5f                   	pop    %edi
  802e41:	5d                   	pop    %ebp
  802e42:	c3                   	ret    
  802e43:	90                   	nop
  802e44:	89 fd                	mov    %edi,%ebp
  802e46:	85 ff                	test   %edi,%edi
  802e48:	75 0b                	jne    802e55 <__umoddi3+0xe9>
  802e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802e4f:	31 d2                	xor    %edx,%edx
  802e51:	f7 f7                	div    %edi
  802e53:	89 c5                	mov    %eax,%ebp
  802e55:	89 f0                	mov    %esi,%eax
  802e57:	31 d2                	xor    %edx,%edx
  802e59:	f7 f5                	div    %ebp
  802e5b:	89 c8                	mov    %ecx,%eax
  802e5d:	f7 f5                	div    %ebp
  802e5f:	89 d0                	mov    %edx,%eax
  802e61:	e9 44 ff ff ff       	jmp    802daa <__umoddi3+0x3e>
  802e66:	66 90                	xchg   %ax,%ax
  802e68:	89 c8                	mov    %ecx,%eax
  802e6a:	89 f2                	mov    %esi,%edx
  802e6c:	83 c4 1c             	add    $0x1c,%esp
  802e6f:	5b                   	pop    %ebx
  802e70:	5e                   	pop    %esi
  802e71:	5f                   	pop    %edi
  802e72:	5d                   	pop    %ebp
  802e73:	c3                   	ret    
  802e74:	3b 04 24             	cmp    (%esp),%eax
  802e77:	72 06                	jb     802e7f <__umoddi3+0x113>
  802e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802e7d:	77 0f                	ja     802e8e <__umoddi3+0x122>
  802e7f:	89 f2                	mov    %esi,%edx
  802e81:	29 f9                	sub    %edi,%ecx
  802e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802e87:	89 14 24             	mov    %edx,(%esp)
  802e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e92:	8b 14 24             	mov    (%esp),%edx
  802e95:	83 c4 1c             	add    $0x1c,%esp
  802e98:	5b                   	pop    %ebx
  802e99:	5e                   	pop    %esi
  802e9a:	5f                   	pop    %edi
  802e9b:	5d                   	pop    %ebp
  802e9c:	c3                   	ret    
  802e9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ea0:	2b 04 24             	sub    (%esp),%eax
  802ea3:	19 fa                	sbb    %edi,%edx
  802ea5:	89 d1                	mov    %edx,%ecx
  802ea7:	89 c6                	mov    %eax,%esi
  802ea9:	e9 71 ff ff ff       	jmp    802e1f <__umoddi3+0xb3>
  802eae:	66 90                	xchg   %ax,%ax
  802eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802eb4:	72 ea                	jb     802ea0 <__umoddi3+0x134>
  802eb6:	89 d9                	mov    %ebx,%ecx
  802eb8:	e9 62 ff ff ff       	jmp    802e1f <__umoddi3+0xb3>
