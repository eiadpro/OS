
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 9d 02 00 00       	call   8002d3 <libmain>
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
  80006c:	e8 99 03 00 00       	call   80040a <_panic>
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
  8000bc:	e8 e4 19 00 00       	call   801aa5 <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 27 1a 00 00       	call   801af0 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 d8 15 00 00       	call   8016b5 <malloc>
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
  800100:	e8 05 03 00 00       	call   80040a <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 e6 19 00 00       	call   801af0 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 2f 80 00       	push   $0x802f28
  800117:	6a 34                	push   $0x34
  800119:	68 dc 2e 80 00       	push   $0x802edc
  80011e:	e8 e7 02 00 00       	call   80040a <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 7d 19 00 00       	call   801aa5 <sys_calculate_free_frames>
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
  80015f:	e8 41 19 00 00       	call   801aa5 <sys_calculate_free_frames>
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
  800188:	e8 7d 02 00 00       	call   80040a <_panic>

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
  8001c7:	e8 f6 1d 00 00       	call   801fc2 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 2f 80 00       	push   $0x802fd4
  8001e0:	6a 42                	push   $0x42
  8001e2:	68 dc 2e 80 00       	push   $0x802edc
  8001e7:	e8 1e 02 00 00       	call   80040a <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 b4 18 00 00       	call   801aa5 <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 f7 18 00 00       	call   801af0 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 0a 16 00 00       	call   801815 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 dd 18 00 00       	call   801af0 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 2f 80 00       	push   $0x802ff4
  800220:	6a 4f                	push   $0x4f
  800222:	68 dc 2e 80 00       	push   $0x802edc
  800227:	e8 de 01 00 00       	call   80040a <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 74 18 00 00       	call   801aa5 <sys_calculate_free_frames>
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
  80024e:	e8 b7 01 00 00       	call   80040a <_panic>
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
  80028d:	e8 30 1d 00 00       	call   801fc2 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 30 80 00       	push   $0x80307c
  8002a6:	6a 53                	push   $0x53
  8002a8:	68 dc 2e 80 00       	push   $0x802edc
  8002ad:	e8 58 01 00 00       	call   80040a <_panic>
		}
	}

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002b5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002b8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ba:	e8 af 1b 00 00       	call   801e6e <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	68 a0 30 80 00       	push   $0x8030a0
  8002c7:	6a 5b                	push   $0x5b
  8002c9:	68 dc 2e 80 00       	push   $0x802edc
  8002ce:	e8 37 01 00 00       	call   80040a <_panic>

008002d3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002d9:	e8 52 1a 00 00       	call   801d30 <sys_getenvindex>
  8002de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002e4:	89 d0                	mov    %edx,%eax
  8002e6:	c1 e0 03             	shl    $0x3,%eax
  8002e9:	01 d0                	add    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f6:	01 d0                	add    %edx,%eax
  8002f8:	c1 e0 04             	shl    $0x4,%eax
  8002fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800300:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800305:	a1 20 40 80 00       	mov    0x804020,%eax
  80030a:	8a 40 5c             	mov    0x5c(%eax),%al
  80030d:	84 c0                	test   %al,%al
  80030f:	74 0d                	je     80031e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800311:	a1 20 40 80 00       	mov    0x804020,%eax
  800316:	83 c0 5c             	add    $0x5c,%eax
  800319:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800322:	7e 0a                	jle    80032e <libmain+0x5b>
		binaryname = argv[0];
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	8b 00                	mov    (%eax),%eax
  800329:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 fc fc ff ff       	call   800038 <_main>
  80033c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80033f:	e8 f9 17 00 00       	call   801b3d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800344:	83 ec 0c             	sub    $0xc,%esp
  800347:	68 04 31 80 00       	push   $0x803104
  80034c:	e8 76 03 00 00       	call   8006c7 <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800354:	a1 20 40 80 00       	mov    0x804020,%eax
  800359:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80035f:	a1 20 40 80 00       	mov    0x804020,%eax
  800364:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	52                   	push   %edx
  80036e:	50                   	push   %eax
  80036f:	68 2c 31 80 00       	push   $0x80312c
  800374:	e8 4e 03 00 00       	call   8006c7 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800387:	a1 20 40 80 00       	mov    0x804020,%eax
  80038c:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800392:	a1 20 40 80 00       	mov    0x804020,%eax
  800397:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80039d:	51                   	push   %ecx
  80039e:	52                   	push   %edx
  80039f:	50                   	push   %eax
  8003a0:	68 54 31 80 00       	push   $0x803154
  8003a5:	e8 1d 03 00 00       	call   8006c7 <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	50                   	push   %eax
  8003bc:	68 ac 31 80 00       	push   $0x8031ac
  8003c1:	e8 01 03 00 00       	call   8006c7 <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003c9:	83 ec 0c             	sub    $0xc,%esp
  8003cc:	68 04 31 80 00       	push   $0x803104
  8003d1:	e8 f1 02 00 00       	call   8006c7 <cprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d9:	e8 79 17 00 00       	call   801b57 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003de:	e8 19 00 00 00       	call   8003fc <exit>
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	6a 00                	push   $0x0
  8003f1:	e8 06 19 00 00       	call   801cfc <sys_destroy_env>
  8003f6:	83 c4 10             	add    $0x10,%esp
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <exit>:

void
exit(void)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800402:	e8 5b 19 00 00       	call   801d62 <sys_exit_env>
}
  800407:	90                   	nop
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800410:	8d 45 10             	lea    0x10(%ebp),%eax
  800413:	83 c0 04             	add    $0x4,%eax
  800416:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800419:	a1 2c 41 80 00       	mov    0x80412c,%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	74 16                	je     800438 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800422:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	50                   	push   %eax
  80042b:	68 c0 31 80 00       	push   $0x8031c0
  800430:	e8 92 02 00 00       	call   8006c7 <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800438:	a1 00 40 80 00       	mov    0x804000,%eax
  80043d:	ff 75 0c             	pushl  0xc(%ebp)
  800440:	ff 75 08             	pushl  0x8(%ebp)
  800443:	50                   	push   %eax
  800444:	68 c5 31 80 00       	push   $0x8031c5
  800449:	e8 79 02 00 00       	call   8006c7 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800451:	8b 45 10             	mov    0x10(%ebp),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	ff 75 f4             	pushl  -0xc(%ebp)
  80045a:	50                   	push   %eax
  80045b:	e8 fc 01 00 00       	call   80065c <vcprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	6a 00                	push   $0x0
  800468:	68 e1 31 80 00       	push   $0x8031e1
  80046d:	e8 ea 01 00 00       	call   80065c <vcprintf>
  800472:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800475:	e8 82 ff ff ff       	call   8003fc <exit>

	// should not return here
	while (1) ;
  80047a:	eb fe                	jmp    80047a <_panic+0x70>

0080047c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
  80047f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800482:	a1 20 40 80 00       	mov    0x804020,%eax
  800487:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	39 c2                	cmp    %eax,%edx
  800492:	74 14                	je     8004a8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 e4 31 80 00       	push   $0x8031e4
  80049c:	6a 26                	push   $0x26
  80049e:	68 30 32 80 00       	push   $0x803230
  8004a3:	e8 62 ff ff ff       	call   80040a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b6:	e9 c5 00 00 00       	jmp    800580 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	85 c0                	test   %eax,%eax
  8004ce:	75 08                	jne    8004d8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004d0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004d3:	e9 a5 00 00 00       	jmp    80057d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e6:	eb 69                	jmp    800551 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ed:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	01 c0                	add    %eax,%eax
  8004fa:	01 d0                	add    %edx,%eax
  8004fc:	c1 e0 03             	shl    $0x3,%eax
  8004ff:	01 c8                	add    %ecx,%eax
  800501:	8a 40 04             	mov    0x4(%eax),%al
  800504:	84 c0                	test   %al,%al
  800506:	75 46                	jne    80054e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800508:	a1 20 40 80 00       	mov    0x804020,%eax
  80050d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800513:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800516:	89 d0                	mov    %edx,%eax
  800518:	01 c0                	add    %eax,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	c1 e0 03             	shl    $0x3,%eax
  80051f:	01 c8                	add    %ecx,%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800529:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80052e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800533:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	01 c8                	add    %ecx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800541:	39 c2                	cmp    %eax,%edx
  800543:	75 09                	jne    80054e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800545:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80054c:	eb 15                	jmp    800563 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054e:	ff 45 e8             	incl   -0x18(%ebp)
  800551:	a1 20 40 80 00       	mov    0x804020,%eax
  800556:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80055c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80055f:	39 c2                	cmp    %eax,%edx
  800561:	77 85                	ja     8004e8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800563:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800567:	75 14                	jne    80057d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800569:	83 ec 04             	sub    $0x4,%esp
  80056c:	68 3c 32 80 00       	push   $0x80323c
  800571:	6a 3a                	push   $0x3a
  800573:	68 30 32 80 00       	push   $0x803230
  800578:	e8 8d fe ff ff       	call   80040a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80057d:	ff 45 f0             	incl   -0x10(%ebp)
  800580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800583:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800586:	0f 8c 2f ff ff ff    	jl     8004bb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80058c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800593:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80059a:	eb 26                	jmp    8005c2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80059c:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a1:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005aa:	89 d0                	mov    %edx,%eax
  8005ac:	01 c0                	add    %eax,%eax
  8005ae:	01 d0                	add    %edx,%eax
  8005b0:	c1 e0 03             	shl    $0x3,%eax
  8005b3:	01 c8                	add    %ecx,%eax
  8005b5:	8a 40 04             	mov    0x4(%eax),%al
  8005b8:	3c 01                	cmp    $0x1,%al
  8005ba:	75 03                	jne    8005bf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005bc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bf:	ff 45 e0             	incl   -0x20(%ebp)
  8005c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c7:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d0:	39 c2                	cmp    %eax,%edx
  8005d2:	77 c8                	ja     80059c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005da:	74 14                	je     8005f0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	68 90 32 80 00       	push   $0x803290
  8005e4:	6a 44                	push   $0x44
  8005e6:	68 30 32 80 00       	push   $0x803230
  8005eb:	e8 1a fe ff ff       	call   80040a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005f0:	90                   	nop
  8005f1:	c9                   	leave  
  8005f2:	c3                   	ret    

008005f3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	8d 48 01             	lea    0x1(%eax),%ecx
  800601:	8b 55 0c             	mov    0xc(%ebp),%edx
  800604:	89 0a                	mov    %ecx,(%edx)
  800606:	8b 55 08             	mov    0x8(%ebp),%edx
  800609:	88 d1                	mov    %dl,%cl
  80060b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800612:	8b 45 0c             	mov    0xc(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	3d ff 00 00 00       	cmp    $0xff,%eax
  80061c:	75 2c                	jne    80064a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80061e:	a0 24 40 80 00       	mov    0x804024,%al
  800623:	0f b6 c0             	movzbl %al,%eax
  800626:	8b 55 0c             	mov    0xc(%ebp),%edx
  800629:	8b 12                	mov    (%edx),%edx
  80062b:	89 d1                	mov    %edx,%ecx
  80062d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800630:	83 c2 08             	add    $0x8,%edx
  800633:	83 ec 04             	sub    $0x4,%esp
  800636:	50                   	push   %eax
  800637:	51                   	push   %ecx
  800638:	52                   	push   %edx
  800639:	e8 a6 13 00 00       	call   8019e4 <sys_cputs>
  80063e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	8b 40 04             	mov    0x4(%eax),%eax
  800650:	8d 50 01             	lea    0x1(%eax),%edx
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	89 50 04             	mov    %edx,0x4(%eax)
}
  800659:	90                   	nop
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800665:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80066c:	00 00 00 
	b.cnt = 0;
  80066f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800676:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	ff 75 08             	pushl  0x8(%ebp)
  80067f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800685:	50                   	push   %eax
  800686:	68 f3 05 80 00       	push   $0x8005f3
  80068b:	e8 11 02 00 00       	call   8008a1 <vprintfmt>
  800690:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800693:	a0 24 40 80 00       	mov    0x804024,%al
  800698:	0f b6 c0             	movzbl %al,%eax
  80069b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006a1:	83 ec 04             	sub    $0x4,%esp
  8006a4:	50                   	push   %eax
  8006a5:	52                   	push   %edx
  8006a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ac:	83 c0 08             	add    $0x8,%eax
  8006af:	50                   	push   %eax
  8006b0:	e8 2f 13 00 00       	call   8019e4 <sys_cputs>
  8006b5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b8:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    

008006c7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006c7:	55                   	push   %ebp
  8006c8:	89 e5                	mov    %esp,%ebp
  8006ca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006cd:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e3:	50                   	push   %eax
  8006e4:	e8 73 ff ff ff       	call   80065c <vcprintf>
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006fa:	e8 3e 14 00 00       	call   801b3d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800702:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	ff 75 f4             	pushl  -0xc(%ebp)
  80070e:	50                   	push   %eax
  80070f:	e8 48 ff ff ff       	call   80065c <vcprintf>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80071a:	e8 38 14 00 00       	call   801b57 <sys_enable_interrupt>
	return cnt;
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	53                   	push   %ebx
  800728:	83 ec 14             	sub    $0x14,%esp
  80072b:	8b 45 10             	mov    0x10(%ebp),%eax
  80072e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800737:	8b 45 18             	mov    0x18(%ebp),%eax
  80073a:	ba 00 00 00 00       	mov    $0x0,%edx
  80073f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800742:	77 55                	ja     800799 <printnum+0x75>
  800744:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800747:	72 05                	jb     80074e <printnum+0x2a>
  800749:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80074c:	77 4b                	ja     800799 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800751:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800754:	8b 45 18             	mov    0x18(%ebp),%eax
  800757:	ba 00 00 00 00       	mov    $0x0,%edx
  80075c:	52                   	push   %edx
  80075d:	50                   	push   %eax
  80075e:	ff 75 f4             	pushl  -0xc(%ebp)
  800761:	ff 75 f0             	pushl  -0x10(%ebp)
  800764:	e8 eb 24 00 00       	call   802c54 <__udivdi3>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	83 ec 04             	sub    $0x4,%esp
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	53                   	push   %ebx
  800773:	ff 75 18             	pushl  0x18(%ebp)
  800776:	52                   	push   %edx
  800777:	50                   	push   %eax
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 a1 ff ff ff       	call   800724 <printnum>
  800783:	83 c4 20             	add    $0x20,%esp
  800786:	eb 1a                	jmp    8007a2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	ff 75 20             	pushl  0x20(%ebp)
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	ff d0                	call   *%eax
  800796:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800799:	ff 4d 1c             	decl   0x1c(%ebp)
  80079c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007a0:	7f e6                	jg     800788 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	53                   	push   %ebx
  8007b1:	51                   	push   %ecx
  8007b2:	52                   	push   %edx
  8007b3:	50                   	push   %eax
  8007b4:	e8 ab 25 00 00       	call   802d64 <__umoddi3>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	05 f4 34 80 00       	add    $0x8034f4,%eax
  8007c1:	8a 00                	mov    (%eax),%al
  8007c3:	0f be c0             	movsbl %al,%eax
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
}
  8007d5:	90                   	nop
  8007d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    

008007db <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007de:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007e2:	7e 1c                	jle    800800 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	8d 50 08             	lea    0x8(%eax),%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 10                	mov    %edx,(%eax)
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	83 e8 08             	sub    $0x8,%eax
  8007f9:	8b 50 04             	mov    0x4(%eax),%edx
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	eb 40                	jmp    800840 <getuint+0x65>
	else if (lflag)
  800800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800804:	74 1e                	je     800824 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	8d 50 04             	lea    0x4(%eax),%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	89 10                	mov    %edx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	eb 1c                	jmp    800840 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8d 50 04             	lea    0x4(%eax),%edx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	89 10                	mov    %edx,(%eax)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	83 e8 04             	sub    $0x4,%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800845:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800849:	7e 1c                	jle    800867 <getint+0x25>
		return va_arg(*ap, long long);
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	8d 50 08             	lea    0x8(%eax),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	89 10                	mov    %edx,(%eax)
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	83 e8 08             	sub    $0x8,%eax
  800860:	8b 50 04             	mov    0x4(%eax),%edx
  800863:	8b 00                	mov    (%eax),%eax
  800865:	eb 38                	jmp    80089f <getint+0x5d>
	else if (lflag)
  800867:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80086b:	74 1a                	je     800887 <getint+0x45>
		return va_arg(*ap, long);
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	8d 50 04             	lea    0x4(%eax),%edx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 10                	mov    %edx,(%eax)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	99                   	cltd   
  800885:	eb 18                	jmp    80089f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	8d 50 04             	lea    0x4(%eax),%edx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	89 10                	mov    %edx,(%eax)
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	83 e8 04             	sub    $0x4,%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	99                   	cltd   
}
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	56                   	push   %esi
  8008a5:	53                   	push   %ebx
  8008a6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	eb 17                	jmp    8008c2 <vprintfmt+0x21>
			if (ch == '\0')
  8008ab:	85 db                	test   %ebx,%ebx
  8008ad:	0f 84 af 03 00 00    	je     800c62 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	53                   	push   %ebx
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c5:	8d 50 01             	lea    0x1(%eax),%edx
  8008c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008cb:	8a 00                	mov    (%eax),%al
  8008cd:	0f b6 d8             	movzbl %al,%ebx
  8008d0:	83 fb 25             	cmp    $0x25,%ebx
  8008d3:	75 d6                	jne    8008ab <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008d9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008e0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	8d 50 01             	lea    0x1(%eax),%edx
  8008fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f b6 d8             	movzbl %al,%ebx
  800903:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800906:	83 f8 55             	cmp    $0x55,%eax
  800909:	0f 87 2b 03 00 00    	ja     800c3a <vprintfmt+0x399>
  80090f:	8b 04 85 18 35 80 00 	mov    0x803518(,%eax,4),%eax
  800916:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800918:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80091c:	eb d7                	jmp    8008f5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80091e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800922:	eb d1                	jmp    8008f5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800924:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80092b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	c1 e0 02             	shl    $0x2,%eax
  800933:	01 d0                	add    %edx,%eax
  800935:	01 c0                	add    %eax,%eax
  800937:	01 d8                	add    %ebx,%eax
  800939:	83 e8 30             	sub    $0x30,%eax
  80093c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80093f:	8b 45 10             	mov    0x10(%ebp),%eax
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800947:	83 fb 2f             	cmp    $0x2f,%ebx
  80094a:	7e 3e                	jle    80098a <vprintfmt+0xe9>
  80094c:	83 fb 39             	cmp    $0x39,%ebx
  80094f:	7f 39                	jg     80098a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800951:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800954:	eb d5                	jmp    80092b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 c0 04             	add    $0x4,%eax
  80095c:	89 45 14             	mov    %eax,0x14(%ebp)
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80096a:	eb 1f                	jmp    80098b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	79 83                	jns    8008f5 <vprintfmt+0x54>
				width = 0;
  800972:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800979:	e9 77 ff ff ff       	jmp    8008f5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80097e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800985:	e9 6b ff ff ff       	jmp    8008f5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80098a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	0f 89 60 ff ff ff    	jns    8008f5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009a2:	e9 4e ff ff ff       	jmp    8008f5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009aa:	e9 46 ff ff ff       	jmp    8008f5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	83 c0 04             	add    $0x4,%eax
  8009b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	83 e8 04             	sub    $0x4,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			break;
  8009cf:	e9 89 02 00 00       	jmp    800c5d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	83 c0 04             	add    $0x4,%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	83 e8 04             	sub    $0x4,%eax
  8009e3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009e5:	85 db                	test   %ebx,%ebx
  8009e7:	79 02                	jns    8009eb <vprintfmt+0x14a>
				err = -err;
  8009e9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009eb:	83 fb 64             	cmp    $0x64,%ebx
  8009ee:	7f 0b                	jg     8009fb <vprintfmt+0x15a>
  8009f0:	8b 34 9d 60 33 80 00 	mov    0x803360(,%ebx,4),%esi
  8009f7:	85 f6                	test   %esi,%esi
  8009f9:	75 19                	jne    800a14 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009fb:	53                   	push   %ebx
  8009fc:	68 05 35 80 00       	push   $0x803505
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 5e 02 00 00       	call   800c6a <printfmt>
  800a0c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a0f:	e9 49 02 00 00       	jmp    800c5d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a14:	56                   	push   %esi
  800a15:	68 0e 35 80 00       	push   $0x80350e
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	ff 75 08             	pushl  0x8(%ebp)
  800a20:	e8 45 02 00 00       	call   800c6a <printfmt>
  800a25:	83 c4 10             	add    $0x10,%esp
			break;
  800a28:	e9 30 02 00 00       	jmp    800c5d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 30                	mov    (%eax),%esi
  800a3e:	85 f6                	test   %esi,%esi
  800a40:	75 05                	jne    800a47 <vprintfmt+0x1a6>
				p = "(null)";
  800a42:	be 11 35 80 00       	mov    $0x803511,%esi
			if (width > 0 && padc != '-')
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7e 6d                	jle    800aba <vprintfmt+0x219>
  800a4d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a51:	74 67                	je     800aba <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	50                   	push   %eax
  800a5a:	56                   	push   %esi
  800a5b:	e8 0c 03 00 00       	call   800d6c <strnlen>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a66:	eb 16                	jmp    800a7e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a68:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	50                   	push   %eax
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a82:	7f e4                	jg     800a68 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a84:	eb 34                	jmp    800aba <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a86:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a8a:	74 1c                	je     800aa8 <vprintfmt+0x207>
  800a8c:	83 fb 1f             	cmp    $0x1f,%ebx
  800a8f:	7e 05                	jle    800a96 <vprintfmt+0x1f5>
  800a91:	83 fb 7e             	cmp    $0x7e,%ebx
  800a94:	7e 12                	jle    800aa8 <vprintfmt+0x207>
					putch('?', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 3f                	push   $0x3f
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	eb 0f                	jmp    800ab7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	53                   	push   %ebx
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aba:	89 f0                	mov    %esi,%eax
  800abc:	8d 70 01             	lea    0x1(%eax),%esi
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	0f be d8             	movsbl %al,%ebx
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	74 24                	je     800aec <vprintfmt+0x24b>
  800ac8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800acc:	78 b8                	js     800a86 <vprintfmt+0x1e5>
  800ace:	ff 4d e0             	decl   -0x20(%ebp)
  800ad1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ad5:	79 af                	jns    800a86 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad7:	eb 13                	jmp    800aec <vprintfmt+0x24b>
				putch(' ', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 20                	push   $0x20
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae9:	ff 4d e4             	decl   -0x1c(%ebp)
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	7f e7                	jg     800ad9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800af2:	e9 66 01 00 00       	jmp    800c5d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 e8             	pushl  -0x18(%ebp)
  800afd:	8d 45 14             	lea    0x14(%ebp),%eax
  800b00:	50                   	push   %eax
  800b01:	e8 3c fd ff ff       	call   800842 <getint>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b15:	85 d2                	test   %edx,%edx
  800b17:	79 23                	jns    800b3c <vprintfmt+0x29b>
				putch('-', putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	6a 2d                	push   $0x2d
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2f:	f7 d8                	neg    %eax
  800b31:	83 d2 00             	adc    $0x0,%edx
  800b34:	f7 da                	neg    %edx
  800b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b43:	e9 bc 00 00 00       	jmp    800c04 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b4e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b51:	50                   	push   %eax
  800b52:	e8 84 fc ff ff       	call   8007db <getuint>
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b60:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b67:	e9 98 00 00 00       	jmp    800c04 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 58                	push   $0x58
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	6a 58                	push   $0x58
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 58                	push   $0x58
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
			break;
  800b9c:	e9 bc 00 00 00       	jmp    800c5d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	6a 30                	push   $0x30
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	6a 78                	push   $0x78
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	ff d0                	call   *%eax
  800bbe:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc4:	83 c0 04             	add    $0x4,%eax
  800bc7:	89 45 14             	mov    %eax,0x14(%ebp)
  800bca:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcd:	83 e8 04             	sub    $0x4,%eax
  800bd0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800be3:	eb 1f                	jmp    800c04 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 e8             	pushl  -0x18(%ebp)
  800beb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bee:	50                   	push   %eax
  800bef:	e8 e7 fb ff ff       	call   8007db <getuint>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bfd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c04:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c0b:	83 ec 04             	sub    $0x4,%esp
  800c0e:	52                   	push   %edx
  800c0f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c12:	50                   	push   %eax
  800c13:	ff 75 f4             	pushl  -0xc(%ebp)
  800c16:	ff 75 f0             	pushl  -0x10(%ebp)
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	ff 75 08             	pushl  0x8(%ebp)
  800c1f:	e8 00 fb ff ff       	call   800724 <printnum>
  800c24:	83 c4 20             	add    $0x20,%esp
			break;
  800c27:	eb 34                	jmp    800c5d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	53                   	push   %ebx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			break;
  800c38:	eb 23                	jmp    800c5d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 25                	push   $0x25
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c4a:	ff 4d 10             	decl   0x10(%ebp)
  800c4d:	eb 03                	jmp    800c52 <vprintfmt+0x3b1>
  800c4f:	ff 4d 10             	decl   0x10(%ebp)
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	48                   	dec    %eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	3c 25                	cmp    $0x25,%al
  800c5a:	75 f3                	jne    800c4f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c5c:	90                   	nop
		}
	}
  800c5d:	e9 47 fc ff ff       	jmp    8008a9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c62:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c70:	8d 45 10             	lea    0x10(%ebp),%eax
  800c73:	83 c0 04             	add    $0x4,%eax
  800c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c79:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7f:	50                   	push   %eax
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	ff 75 08             	pushl  0x8(%ebp)
  800c86:	e8 16 fc ff ff       	call   8008a1 <vprintfmt>
  800c8b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8e:	90                   	nop
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 40 08             	mov    0x8(%eax),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	8b 10                	mov    (%eax),%edx
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	8b 40 04             	mov    0x4(%eax),%eax
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	73 12                	jae    800cc4 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	8d 48 01             	lea    0x1(%eax),%ecx
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	89 0a                	mov    %ecx,(%edx)
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	88 10                	mov    %dl,(%eax)
}
  800cc4:	90                   	nop
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cec:	74 06                	je     800cf4 <vsnprintf+0x2d>
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	7f 07                	jg     800cfb <vsnprintf+0x34>
		return -E_INVAL;
  800cf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf9:	eb 20                	jmp    800d1b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfb:	ff 75 14             	pushl  0x14(%ebp)
  800cfe:	ff 75 10             	pushl  0x10(%ebp)
  800d01:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d04:	50                   	push   %eax
  800d05:	68 91 0c 80 00       	push   $0x800c91
  800d0a:	e8 92 fb ff ff       	call   8008a1 <vprintfmt>
  800d0f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d15:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d23:	8d 45 10             	lea    0x10(%ebp),%eax
  800d26:	83 c0 04             	add    $0x4,%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d32:	50                   	push   %eax
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	ff 75 08             	pushl  0x8(%ebp)
  800d39:	e8 89 ff ff ff       	call   800cc7 <vsnprintf>
  800d3e:	83 c4 10             	add    $0x10,%esp
  800d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 06                	jmp    800d5e <strlen+0x15>
		n++;
  800d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	75 f1                	jne    800d58 <strlen+0xf>
		n++;
	return n;
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d79:	eb 09                	jmp    800d84 <strnlen+0x18>
		n++;
  800d7b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7e:	ff 45 08             	incl   0x8(%ebp)
  800d81:	ff 4d 0c             	decl   0xc(%ebp)
  800d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d88:	74 09                	je     800d93 <strnlen+0x27>
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 e8                	jne    800d7b <strnlen+0xf>
		n++;
	return n;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da4:	90                   	nop
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	84 c0                	test   %al,%al
  800dbf:	75 e4                	jne    800da5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd9:	eb 1f                	jmp    800dfa <strncpy+0x34>
		*dst++ = *src;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	89 55 08             	mov    %edx,0x8(%ebp)
  800de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	84 c0                	test   %al,%al
  800df2:	74 03                	je     800df7 <strncpy+0x31>
			src++;
  800df4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df7:	ff 45 fc             	incl   -0x4(%ebp)
  800dfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e00:	72 d9                	jb     800ddb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	74 30                	je     800e49 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e19:	eb 16                	jmp    800e31 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e31:	ff 4d 10             	decl   0x10(%ebp)
  800e34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e38:	74 09                	je     800e43 <strlcpy+0x3c>
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	84 c0                	test   %al,%al
  800e41:	75 d8                	jne    800e1b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4f:	29 c2                	sub    %eax,%edx
  800e51:	89 d0                	mov    %edx,%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e58:	eb 06                	jmp    800e60 <strcmp+0xb>
		p++, q++;
  800e5a:	ff 45 08             	incl   0x8(%ebp)
  800e5d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	74 0e                	je     800e77 <strcmp+0x22>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 10                	mov    (%eax),%dl
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	38 c2                	cmp    %al,%dl
  800e75:	74 e3                	je     800e5a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	0f b6 d0             	movzbl %al,%edx
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	0f b6 c0             	movzbl %al,%eax
  800e87:	29 c2                	sub    %eax,%edx
  800e89:	89 d0                	mov    %edx,%eax
}
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e90:	eb 09                	jmp    800e9b <strncmp+0xe>
		n--, p++, q++;
  800e92:	ff 4d 10             	decl   0x10(%ebp)
  800e95:	ff 45 08             	incl   0x8(%ebp)
  800e98:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9f:	74 17                	je     800eb8 <strncmp+0x2b>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	74 0e                	je     800eb8 <strncmp+0x2b>
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 10                	mov    (%eax),%dl
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	38 c2                	cmp    %al,%dl
  800eb6:	74 da                	je     800e92 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebc:	75 07                	jne    800ec5 <strncmp+0x38>
		return 0;
  800ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec3:	eb 14                	jmp    800ed9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 d0             	movzbl %al,%edx
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	0f b6 c0             	movzbl %al,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 04             	sub    $0x4,%esp
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee7:	eb 12                	jmp    800efb <strchr+0x20>
		if (*s == c)
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef1:	75 05                	jne    800ef8 <strchr+0x1d>
			return (char *) s;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	eb 11                	jmp    800f09 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef8:	ff 45 08             	incl   0x8(%ebp)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	84 c0                	test   %al,%al
  800f02:	75 e5                	jne    800ee9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f17:	eb 0d                	jmp    800f26 <strfind+0x1b>
		if (*s == c)
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f21:	74 0e                	je     800f31 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f23:	ff 45 08             	incl   0x8(%ebp)
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 ea                	jne    800f19 <strfind+0xe>
  800f2f:	eb 01                	jmp    800f32 <strfind+0x27>
		if (*s == c)
			break;
  800f31:	90                   	nop
	return (char *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f49:	eb 0e                	jmp    800f59 <memset+0x22>
		*p++ = c;
  800f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4e:	8d 50 01             	lea    0x1(%eax),%edx
  800f51:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f57:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f59:	ff 4d f8             	decl   -0x8(%ebp)
  800f5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f60:	79 e9                	jns    800f4b <memset+0x14>
		*p++ = c;

	return v;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f79:	eb 16                	jmp    800f91 <memcpy+0x2a>
		*d++ = *s++;
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7e:	8d 50 01             	lea    0x1(%eax),%edx
  800f81:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8d:	8a 12                	mov    (%edx),%dl
  800f8f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f97:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	75 dd                	jne    800f7b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbb:	73 50                	jae    80100d <memmove+0x6a>
  800fbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 d0                	add    %edx,%eax
  800fc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc8:	76 43                	jbe    80100d <memmove+0x6a>
		s += n;
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd6:	eb 10                	jmp    800fe8 <memmove+0x45>
			*--d = *--s;
  800fd8:	ff 4d f8             	decl   -0x8(%ebp)
  800fdb:	ff 4d fc             	decl   -0x4(%ebp)
  800fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe1:	8a 10                	mov    (%eax),%dl
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	75 e3                	jne    800fd8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff5:	eb 23                	jmp    80101a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffa:	8d 50 01             	lea    0x1(%eax),%edx
  800ffd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801000:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801003:	8d 4a 01             	lea    0x1(%edx),%ecx
  801006:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801009:	8a 12                	mov    (%edx),%dl
  80100b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100d:	8b 45 10             	mov    0x10(%ebp),%eax
  801010:	8d 50 ff             	lea    -0x1(%eax),%edx
  801013:	89 55 10             	mov    %edx,0x10(%ebp)
  801016:	85 c0                	test   %eax,%eax
  801018:	75 dd                	jne    800ff7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801031:	eb 2a                	jmp    80105d <memcmp+0x3e>
		if (*s1 != *s2)
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801036:	8a 10                	mov    (%eax),%dl
  801038:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	38 c2                	cmp    %al,%dl
  80103f:	74 16                	je     801057 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f b6 d0             	movzbl %al,%edx
  801049:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f b6 c0             	movzbl %al,%eax
  801051:	29 c2                	sub    %eax,%edx
  801053:	89 d0                	mov    %edx,%eax
  801055:	eb 18                	jmp    80106f <memcmp+0x50>
		s1++, s2++;
  801057:	ff 45 fc             	incl   -0x4(%ebp)
  80105a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	8d 50 ff             	lea    -0x1(%eax),%edx
  801063:	89 55 10             	mov    %edx,0x10(%ebp)
  801066:	85 c0                	test   %eax,%eax
  801068:	75 c9                	jne    801033 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	01 d0                	add    %edx,%eax
  80107f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801082:	eb 15                	jmp    801099 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f b6 d0             	movzbl %al,%edx
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	0f b6 c0             	movzbl %al,%eax
  801092:	39 c2                	cmp    %eax,%edx
  801094:	74 0d                	je     8010a3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801096:	ff 45 08             	incl   0x8(%ebp)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109f:	72 e3                	jb     801084 <memfind+0x13>
  8010a1:	eb 01                	jmp    8010a4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a3:	90                   	nop
	return (void *) s;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bd:	eb 03                	jmp    8010c2 <strtol+0x19>
		s++;
  8010bf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 20                	cmp    $0x20,%al
  8010c9:	74 f4                	je     8010bf <strtol+0x16>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 09                	cmp    $0x9,%al
  8010d2:	74 eb                	je     8010bf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	3c 2b                	cmp    $0x2b,%al
  8010db:	75 05                	jne    8010e2 <strtol+0x39>
		s++;
  8010dd:	ff 45 08             	incl   0x8(%ebp)
  8010e0:	eb 13                	jmp    8010f5 <strtol+0x4c>
	else if (*s == '-')
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 2d                	cmp    $0x2d,%al
  8010e9:	75 0a                	jne    8010f5 <strtol+0x4c>
		s++, neg = 1;
  8010eb:	ff 45 08             	incl   0x8(%ebp)
  8010ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f9:	74 06                	je     801101 <strtol+0x58>
  8010fb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ff:	75 20                	jne    801121 <strtol+0x78>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 30                	cmp    $0x30,%al
  801108:	75 17                	jne    801121 <strtol+0x78>
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	40                   	inc    %eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 78                	cmp    $0x78,%al
  801112:	75 0d                	jne    801121 <strtol+0x78>
		s += 2, base = 16;
  801114:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801118:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111f:	eb 28                	jmp    801149 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801121:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801125:	75 15                	jne    80113c <strtol+0x93>
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 30                	cmp    $0x30,%al
  80112e:	75 0c                	jne    80113c <strtol+0x93>
		s++, base = 8;
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80113a:	eb 0d                	jmp    801149 <strtol+0xa0>
	else if (base == 0)
  80113c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801140:	75 07                	jne    801149 <strtol+0xa0>
		base = 10;
  801142:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 2f                	cmp    $0x2f,%al
  801150:	7e 19                	jle    80116b <strtol+0xc2>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 39                	cmp    $0x39,%al
  801159:	7f 10                	jg     80116b <strtol+0xc2>
			dig = *s - '0';
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 30             	sub    $0x30,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801169:	eb 42                	jmp    8011ad <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 60                	cmp    $0x60,%al
  801172:	7e 19                	jle    80118d <strtol+0xe4>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 7a                	cmp    $0x7a,%al
  80117b:	7f 10                	jg     80118d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f be c0             	movsbl %al,%eax
  801185:	83 e8 57             	sub    $0x57,%eax
  801188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118b:	eb 20                	jmp    8011ad <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 40                	cmp    $0x40,%al
  801194:	7e 39                	jle    8011cf <strtol+0x126>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 5a                	cmp    $0x5a,%al
  80119d:	7f 30                	jg     8011cf <strtol+0x126>
			dig = *s - 'A' + 10;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	83 e8 37             	sub    $0x37,%eax
  8011aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b3:	7d 19                	jge    8011ce <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b5:	ff 45 08             	incl   0x8(%ebp)
  8011b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c4:	01 d0                	add    %edx,%eax
  8011c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c9:	e9 7b ff ff ff       	jmp    801149 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ce:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d3:	74 08                	je     8011dd <strtol+0x134>
		*endptr = (char *) s;
  8011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e1:	74 07                	je     8011ea <strtol+0x141>
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e6:	f7 d8                	neg    %eax
  8011e8:	eb 03                	jmp    8011ed <strtol+0x144>
  8011ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <ltostr>:

void
ltostr(long value, char *str)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801203:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801207:	79 13                	jns    80121c <ltostr+0x2d>
	{
		neg = 1;
  801209:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801216:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801219:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801224:	99                   	cltd   
  801225:	f7 f9                	idiv   %ecx
  801227:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80122a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122d:	8d 50 01             	lea    0x1(%eax),%edx
  801230:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801233:	89 c2                	mov    %eax,%edx
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	01 d0                	add    %edx,%eax
  80123a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123d:	83 c2 30             	add    $0x30,%edx
  801240:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801242:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801245:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124a:	f7 e9                	imul   %ecx
  80124c:	c1 fa 02             	sar    $0x2,%edx
  80124f:	89 c8                	mov    %ecx,%eax
  801251:	c1 f8 1f             	sar    $0x1f,%eax
  801254:	29 c2                	sub    %eax,%edx
  801256:	89 d0                	mov    %edx,%eax
  801258:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80125b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801263:	f7 e9                	imul   %ecx
  801265:	c1 fa 02             	sar    $0x2,%edx
  801268:	89 c8                	mov    %ecx,%eax
  80126a:	c1 f8 1f             	sar    $0x1f,%eax
  80126d:	29 c2                	sub    %eax,%edx
  80126f:	89 d0                	mov    %edx,%eax
  801271:	c1 e0 02             	shl    $0x2,%eax
  801274:	01 d0                	add    %edx,%eax
  801276:	01 c0                	add    %eax,%eax
  801278:	29 c1                	sub    %eax,%ecx
  80127a:	89 ca                	mov    %ecx,%edx
  80127c:	85 d2                	test   %edx,%edx
  80127e:	75 9c                	jne    80121c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801287:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128a:	48                   	dec    %eax
  80128b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80128e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801292:	74 3d                	je     8012d1 <ltostr+0xe2>
		start = 1 ;
  801294:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80129b:	eb 34                	jmp    8012d1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80129d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 c2                	add    %eax,%edx
  8012b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c8                	add    %ecx,%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012cb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ce:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d7:	7c c4                	jl     80129d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 d0                	add    %edx,%eax
  8012e1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012e4:	90                   	nop
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ed:	ff 75 08             	pushl  0x8(%ebp)
  8012f0:	e8 54 fa ff ff       	call   800d49 <strlen>
  8012f5:	83 c4 04             	add    $0x4,%esp
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	e8 46 fa ff ff       	call   800d49 <strlen>
  801303:	83 c4 04             	add    $0x4,%esp
  801306:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801317:	eb 17                	jmp    801330 <strcconcat+0x49>
		final[s] = str1[s] ;
  801319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131c:	8b 45 10             	mov    0x10(%ebp),%eax
  80131f:	01 c2                	add    %eax,%edx
  801321:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	01 c8                	add    %ecx,%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80132d:	ff 45 fc             	incl   -0x4(%ebp)
  801330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801333:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801336:	7c e1                	jl     801319 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80133f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801346:	eb 1f                	jmp    801367 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134b:	8d 50 01             	lea    0x1(%eax),%edx
  80134e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 c2                	add    %eax,%edx
  801358:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c8                	add    %ecx,%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801364:	ff 45 f8             	incl   -0x8(%ebp)
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136d:	7c d9                	jl     801348 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	c6 00 00             	movb   $0x0,(%eax)
}
  80137a:	90                   	nop
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801389:	8b 45 14             	mov    0x14(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a0:	eb 0c                	jmp    8013ae <strsplit+0x31>
			*string++ = 0;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8d 50 01             	lea    0x1(%eax),%edx
  8013a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ab:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	84 c0                	test   %al,%al
  8013b5:	74 18                	je     8013cf <strsplit+0x52>
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	0f be c0             	movsbl %al,%eax
  8013bf:	50                   	push   %eax
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	e8 13 fb ff ff       	call   800edb <strchr>
  8013c8:	83 c4 08             	add    $0x8,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	75 d3                	jne    8013a2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	74 5a                	je     801432 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	83 f8 0f             	cmp    $0xf,%eax
  8013e0:	75 07                	jne    8013e9 <strsplit+0x6c>
		{
			return 0;
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e7:	eb 66                	jmp    80144f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8013f1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013f4:	89 0a                	mov    %ecx,(%edx)
  8013f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801407:	eb 03                	jmp    80140c <strsplit+0x8f>
			string++;
  801409:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	84 c0                	test   %al,%al
  801413:	74 8b                	je     8013a0 <strsplit+0x23>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	50                   	push   %eax
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	e8 b5 fa ff ff       	call   800edb <strchr>
  801426:	83 c4 08             	add    $0x8,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 dc                	je     801409 <strsplit+0x8c>
			string++;
	}
  80142d:	e9 6e ff ff ff       	jmp    8013a0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801432:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143f:	8b 45 10             	mov    0x10(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80144a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145e:	eb 4c                	jmp    8014ac <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801460:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 40                	cmp    $0x40,%al
  80146c:	7e 27                	jle    801495 <str2lower+0x44>
  80146e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 d0                	add    %edx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 5a                	cmp    $0x5a,%al
  80147a:	7f 19                	jg     801495 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80147c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	01 d0                	add    %edx,%eax
  801484:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	01 ca                	add    %ecx,%edx
  80148c:	8a 12                	mov    (%edx),%dl
  80148e:	83 c2 20             	add    $0x20,%edx
  801491:	88 10                	mov    %dl,(%eax)
  801493:	eb 14                	jmp    8014a9 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	01 c2                	add    %eax,%edx
  80149d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 c8                	add    %ecx,%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8014a9:	ff 45 fc             	incl   -0x4(%ebp)
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	e8 95 f8 ff ff       	call   800d49 <strlen>
  8014b4:	83 c4 04             	add    $0x4,%esp
  8014b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ba:	7f a4                	jg     801460 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8014bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	01 d0                	add    %edx,%eax
  8014c4:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  8014cf:	a1 28 40 80 00       	mov    0x804028,%eax
  8014d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d7:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  8014de:	a1 28 40 80 00       	mov    0x804028,%eax
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  8014ed:	a1 28 40 80 00       	mov    0x804028,%eax
  8014f2:	40                   	inc    %eax
  8014f3:	a3 28 40 80 00       	mov    %eax,0x804028
}
  8014f8:	90                   	nop
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <searchElement>:

int searchElement(uint32 start) {
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801508:	eb 17                	jmp    801521 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  80150a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150d:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801514:	3b 45 08             	cmp    0x8(%ebp),%eax
  801517:	75 05                	jne    80151e <searchElement+0x23>
			return i;
  801519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151c:	eb 12                	jmp    801530 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  80151e:	ff 45 fc             	incl   -0x4(%ebp)
  801521:	a1 28 40 80 00       	mov    0x804028,%eax
  801526:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801529:	7c df                	jl     80150a <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  80152b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <removeElement>:
void removeElement(uint32 start) {
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 bb ff ff ff       	call   8014fb <searchElement>
  801540:	83 c4 04             	add    $0x4,%esp
  801543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801546:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801549:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80154c:	eb 26                	jmp    801574 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  80154e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801551:	40                   	inc    %eax
  801552:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801555:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  80155c:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801563:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  80156a:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801571:	ff 45 fc             	incl   -0x4(%ebp)
  801574:	a1 28 40 80 00       	mov    0x804028,%eax
  801579:	48                   	dec    %eax
  80157a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157d:	7f cf                	jg     80154e <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  80157f:	a1 28 40 80 00       	mov    0x804028,%eax
  801584:	48                   	dec    %eax
  801585:	a3 28 40 80 00       	mov    %eax,0x804028
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <searchfree>:
int searchfree(uint32 end)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801593:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80159a:	eb 17                	jmp    8015b3 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  80159c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159f:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8015a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015a9:	75 05                	jne    8015b0 <searchfree+0x23>
			return i;
  8015ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ae:	eb 12                	jmp    8015c2 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  8015b0:	ff 45 fc             	incl   -0x4(%ebp)
  8015b3:	a1 28 40 80 00       	mov    0x804028,%eax
  8015b8:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8015bb:	7c df                	jl     80159c <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  8015bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <removefree>:
void removefree(uint32 end)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  8015ca:	eb 52                	jmp    80161e <removefree+0x5a>
		int index = searchfree(end);
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	e8 b9 ff ff ff       	call   80158d <searchfree>
  8015d4:	83 c4 04             	add    $0x4,%esp
  8015d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  8015da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8015e0:	eb 26                	jmp    801608 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  8015e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e5:	40                   	inc    %eax
  8015e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e9:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  8015f0:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  8015f7:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  8015fe:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801605:	ff 45 fc             	incl   -0x4(%ebp)
  801608:	a1 28 40 80 00       	mov    0x804028,%eax
  80160d:	48                   	dec    %eax
  80160e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801611:	7f cf                	jg     8015e2 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801613:	a1 28 40 80 00       	mov    0x804028,%eax
  801618:	48                   	dec    %eax
  801619:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 67 ff ff ff       	call   80158d <searchfree>
  801626:	83 c4 04             	add    $0x4,%esp
  801629:	83 f8 ff             	cmp    $0xffffffff,%eax
  80162c:	75 9e                	jne    8015cc <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  80162e:	90                   	nop
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <printArray>:
void printArray() {
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	68 70 36 80 00       	push   $0x803670
  80163f:	e8 83 f0 ff ff       	call   8006c7 <cprintf>
  801644:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801647:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80164e:	eb 29                	jmp    801679 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  80165a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165d:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	ff 75 f4             	pushl  -0xc(%ebp)
  801669:	68 81 36 80 00       	push   $0x803681
  80166e:	e8 54 f0 ff ff       	call   8006c7 <cprintf>
  801673:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801676:	ff 45 f4             	incl   -0xc(%ebp)
  801679:	a1 28 40 80 00       	mov    0x804028,%eax
  80167e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801681:	7c cd                	jl     801650 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801683:	90                   	nop
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801689:	a1 04 40 80 00       	mov    0x804004,%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 0a                	je     80169c <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801692:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801699:	00 00 00 
	}
}
  80169c:	90                   	nop
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	ff 75 08             	pushl  0x8(%ebp)
  8016ab:	e8 4f 09 00 00       	call   801fff <sys_sbrk>
  8016b0:	83 c4 10             	add    $0x10,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bb:	e8 c6 ff ff ff       	call   801686 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c4:	75 0a                	jne    8016d0 <malloc+0x1b>
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	e9 43 01 00 00       	jmp    801813 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016d0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016d7:	77 3c                	ja     801715 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016d9:	e8 c3 07 00 00       	call   801ea1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	74 13                	je     8016f5 <malloc+0x40>
			return alloc_block_FF(size);
  8016e2:	83 ec 0c             	sub    $0xc,%esp
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 89 0b 00 00       	call   802276 <alloc_block_FF>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	e9 1e 01 00 00       	jmp    801813 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  8016f5:	e8 d8 07 00 00       	call   801ed2 <sys_isUHeapPlacementStrategyBESTFIT>
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	0f 84 0c 01 00 00    	je     80180e <malloc+0x159>
			return alloc_block_BF(size);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 7d 0e 00 00       	call   80258a <alloc_block_BF>
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	e9 fe 00 00 00       	jmp    801813 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801715:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80171c:	8b 55 08             	mov    0x8(%ebp),%edx
  80171f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801722:	01 d0                	add    %edx,%eax
  801724:	48                   	dec    %eax
  801725:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801728:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80172b:	ba 00 00 00 00       	mov    $0x0,%edx
  801730:	f7 75 e0             	divl   -0x20(%ebp)
  801733:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801736:	29 d0                	sub    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	c1 e8 0c             	shr    $0xc,%eax
  801741:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801744:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  80174b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801752:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801759:	e8 f4 08 00 00       	call   802052 <sys_hard_limit>
  80175e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801761:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801764:	05 00 10 00 00       	add    $0x1000,%eax
  801769:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80176c:	eb 49                	jmp    8017b7 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	ff 75 e8             	pushl  -0x18(%ebp)
  801774:	e8 82 fd ff ff       	call   8014fb <searchElement>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	83 f8 ff             	cmp    $0xffffffff,%eax
  80177f:	75 28                	jne    8017a9 <malloc+0xf4>
			{


				count++;
  801781:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80178a:	75 24                	jne    8017b0 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  80178c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178f:	05 00 10 00 00       	add    $0x1000,%eax
  801794:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	c1 e0 0c             	shl    $0xc,%eax
  80179d:	89 c2                	mov    %eax,%edx
  80179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a2:	29 d0                	sub    %edx,%eax
  8017a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  8017a7:	eb 17                	jmp    8017c0 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  8017a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8017b0:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  8017b7:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8017be:	76 ae                	jbe    80176e <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  8017c0:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  8017c4:	75 07                	jne    8017cd <malloc+0x118>
		{
			return NULL;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	eb 46                	jmp    801813 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  8017cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d3:	eb 1a                	jmp    8017ef <malloc+0x13a>
		{
			addElement(i,end);
  8017d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	e8 e7 fc ff ff       	call   8014cc <addElement>
  8017e5:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  8017e8:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  8017ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017f5:	7c de                	jl     8017d5 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	83 ec 08             	sub    $0x8,%esp
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	50                   	push   %eax
  801801:	e8 30 08 00 00       	call   802036 <sys_allocate_user_mem>
  801806:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180c:	eb 05                	jmp    801813 <malloc+0x15e>
	}
	return NULL;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  80181b:	e8 32 08 00 00       	call   802052 <sys_hard_limit>
  801820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	85 c0                	test   %eax,%eax
  801828:	0f 89 82 00 00 00    	jns    8018b0 <free+0x9b>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801836:	77 78                	ja     8018b0 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80183e:	73 10                	jae    801850 <free+0x3b>
			free_block(virtual_address);
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 d2 0e 00 00       	call   80271d <free_block>
  80184b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  80184e:	eb 77                	jmp    8018c7 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	50                   	push   %eax
  801857:	e8 9f fc ff ff       	call   8014fb <searchElement>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801865:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  80186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186f:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801876:	29 c2                	sub    %eax,%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  80187d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801880:	c1 e8 0c             	shr    $0xc,%eax
  801883:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	ff 75 ec             	pushl  -0x14(%ebp)
  80188f:	50                   	push   %eax
  801890:	e8 85 07 00 00       	call   80201a <sys_free_user_mem>
  801895:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	50                   	push   %eax
  8018a6:	e8 19 fd ff ff       	call   8015c4 <removefree>
  8018ab:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8018ae:	eb 17                	jmp    8018c7 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 9a 36 80 00       	push   $0x80369a
  8018b8:	68 ac 00 00 00       	push   $0xac
  8018bd:	68 aa 36 80 00       	push   $0x8036aa
  8018c2:	e8 43 eb ff ff       	call   80040a <_panic>
	}
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 18             	sub    $0x18,%esp
  8018d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d6:	e8 ab fd ff ff       	call   801686 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018df:	75 07                	jne    8018e8 <smalloc+0x1e>
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e6:	eb 17                	jmp    8018ff <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	68 b8 36 80 00       	push   $0x8036b8
  8018f0:	68 bc 00 00 00       	push   $0xbc
  8018f5:	68 aa 36 80 00       	push   $0x8036aa
  8018fa:	e8 0b eb ff ff       	call   80040a <_panic>
	return NULL;
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801907:	e8 7a fd ff ff       	call   801686 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	68 e0 36 80 00       	push   $0x8036e0
  801914:	68 ca 00 00 00       	push   $0xca
  801919:	68 aa 36 80 00       	push   $0x8036aa
  80191e:	e8 e7 ea ff ff       	call   80040a <_panic>

00801923 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801929:	e8 58 fd ff ff       	call   801686 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	68 04 37 80 00       	push   $0x803704
  801936:	68 ea 00 00 00       	push   $0xea
  80193b:	68 aa 36 80 00       	push   $0x8036aa
  801940:	e8 c5 ea ff ff       	call   80040a <_panic>

00801945 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 2c 37 80 00       	push   $0x80372c
  801953:	68 fe 00 00 00       	push   $0xfe
  801958:	68 aa 36 80 00       	push   $0x8036aa
  80195d:	e8 a8 ea ff ff       	call   80040a <_panic>

00801962 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	68 50 37 80 00       	push   $0x803750
  801970:	68 08 01 00 00       	push   $0x108
  801975:	68 aa 36 80 00       	push   $0x8036aa
  80197a:	e8 8b ea ff ff       	call   80040a <_panic>

0080197f <shrink>:

}
void shrink(uint32 newSize)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 50 37 80 00       	push   $0x803750
  80198d:	68 0d 01 00 00       	push   $0x10d
  801992:	68 aa 36 80 00       	push   $0x8036aa
  801997:	e8 6e ea ff ff       	call   80040a <_panic>

0080199c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	68 50 37 80 00       	push   $0x803750
  8019aa:	68 12 01 00 00       	push   $0x112
  8019af:	68 aa 36 80 00       	push   $0x8036aa
  8019b4:	e8 51 ea ff ff       	call   80040a <_panic>

008019b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	57                   	push   %edi
  8019bd:	56                   	push   %esi
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d4:	cd 30                	int    $0x30
  8019d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    

008019e4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	6a 00                	push   $0x0
  801a02:	e8 b2 ff ff ff       	call   8019b9 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 01                	push   $0x1
  801a1c:	e8 98 ff ff ff       	call   8019b9 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 05                	push   $0x5
  801a39:	e8 7b ff ff ff       	call   8019b9 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a48:	8b 75 18             	mov    0x18(%ebp),%esi
  801a4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	56                   	push   %esi
  801a58:	53                   	push   %ebx
  801a59:	51                   	push   %ecx
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 06                	push   $0x6
  801a5e:	e8 56 ff ff ff       	call   8019b9 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    

00801a6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	52                   	push   %edx
  801a7d:	50                   	push   %eax
  801a7e:	6a 07                	push   $0x7
  801a80:	e8 34 ff ff ff       	call   8019b9 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	ff 75 08             	pushl  0x8(%ebp)
  801a99:	6a 08                	push   $0x8
  801a9b:	e8 19 ff ff ff       	call   8019b9 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 09                	push   $0x9
  801ab4:	e8 00 ff ff ff       	call   8019b9 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 0a                	push   $0xa
  801acd:	e8 e7 fe ff ff       	call   8019b9 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 0b                	push   $0xb
  801ae6:	e8 ce fe ff ff       	call   8019b9 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 0c                	push   $0xc
  801aff:	e8 b5 fe ff ff       	call   8019b9 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	6a 0d                	push   $0xd
  801b19:	e8 9b fe ff ff       	call   8019b9 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 0e                	push   $0xe
  801b32:	e8 82 fe ff ff       	call   8019b9 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 11                	push   $0x11
  801b4c:	e8 68 fe ff ff       	call   8019b9 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 12                	push   $0x12
  801b66:	e8 4e fe ff ff       	call   8019b9 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	90                   	nop
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	50                   	push   %eax
  801b8a:	6a 13                	push   $0x13
  801b8c:	e8 28 fe ff ff       	call   8019b9 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	90                   	nop
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 14                	push   $0x14
  801ba6:	e8 0e fe ff ff       	call   8019b9 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	90                   	nop
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	6a 15                	push   $0x15
  801bc3:	e8 f1 fd ff ff       	call   8019b9 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 18                	push   $0x18
  801be0:	e8 d4 fd ff ff       	call   8019b9 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 16                	push   $0x16
  801bfd:	e8 b7 fd ff ff       	call   8019b9 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	90                   	nop
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 17                	push   $0x17
  801c1b:	e8 99 fd ff ff       	call   8019b9 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c35:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	51                   	push   %ecx
  801c3f:	52                   	push   %edx
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	50                   	push   %eax
  801c44:	6a 19                	push   $0x19
  801c46:	e8 6e fd ff ff       	call   8019b9 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 1a                	push   $0x1a
  801c63:	e8 51 fd ff ff       	call   8019b9 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	51                   	push   %ecx
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 1b                	push   $0x1b
  801c82:	e8 32 fd ff ff       	call   8019b9 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 1c                	push   $0x1c
  801c9f:	e8 15 fd ff ff       	call   8019b9 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 1d                	push   $0x1d
  801cb8:	e8 fc fc ff ff       	call   8019b9 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 14             	pushl  0x14(%ebp)
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	50                   	push   %eax
  801cd4:	6a 1e                	push   $0x1e
  801cd6:	e8 de fc ff ff       	call   8019b9 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	50                   	push   %eax
  801cef:	6a 1f                	push   $0x1f
  801cf1:	e8 c3 fc ff ff       	call   8019b9 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	50                   	push   %eax
  801d0b:	6a 20                	push   $0x20
  801d0d:	e8 a7 fc ff ff       	call   8019b9 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 02                	push   $0x2
  801d26:	e8 8e fc ff ff       	call   8019b9 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 03                	push   $0x3
  801d3f:	e8 75 fc ff ff       	call   8019b9 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 04                	push   $0x4
  801d58:	e8 5c fc ff ff       	call   8019b9 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_exit_env>:


void sys_exit_env(void)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 21                	push   $0x21
  801d71:	e8 43 fc ff ff       	call   8019b9 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	90                   	nop
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d85:	8d 50 04             	lea    0x4(%eax),%edx
  801d88:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 22                	push   $0x22
  801d95:	e8 1f fc ff ff       	call   8019b9 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return result;
  801d9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da6:	89 01                	mov    %eax,(%ecx)
  801da8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	c9                   	leave  
  801daf:	c2 04 00             	ret    $0x4

00801db2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 10             	pushl  0x10(%ebp)
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	6a 10                	push   $0x10
  801dc4:	e8 f0 fb ff ff       	call   8019b9 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcc:	90                   	nop
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_rcr2>:
uint32 sys_rcr2()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 23                	push   $0x23
  801dde:	e8 d6 fb ff ff       	call   8019b9 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 04             	sub    $0x4,%esp
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801df4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	50                   	push   %eax
  801e01:	6a 24                	push   $0x24
  801e03:	e8 b1 fb ff ff       	call   8019b9 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <rsttst>:
void rsttst()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 26                	push   $0x26
  801e1d:	e8 97 fb ff ff       	call   8019b9 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return ;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 04             	sub    $0x4,%esp
  801e2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e34:	8b 55 18             	mov    0x18(%ebp),%edx
  801e37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e3b:	52                   	push   %edx
  801e3c:	50                   	push   %eax
  801e3d:	ff 75 10             	pushl  0x10(%ebp)
  801e40:	ff 75 0c             	pushl  0xc(%ebp)
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	6a 25                	push   $0x25
  801e48:	e8 6c fb ff ff       	call   8019b9 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <chktst>:
void chktst(uint32 n)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	ff 75 08             	pushl  0x8(%ebp)
  801e61:	6a 27                	push   $0x27
  801e63:	e8 51 fb ff ff       	call   8019b9 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6b:	90                   	nop
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <inctst>:

void inctst()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 28                	push   $0x28
  801e7d:	e8 37 fb ff ff       	call   8019b9 <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
	return ;
  801e85:	90                   	nop
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <gettst>:
uint32 gettst()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 29                	push   $0x29
  801e97:	e8 1d fb ff ff       	call   8019b9 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 2a                	push   $0x2a
  801eb3:	e8 01 fb ff ff       	call   8019b9 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
  801ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ebe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ec2:	75 07                	jne    801ecb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ec4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec9:	eb 05                	jmp    801ed0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 2a                	push   $0x2a
  801ee4:	e8 d0 fa ff ff       	call   8019b9 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
  801eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ef3:	75 07                	jne    801efc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ef5:	b8 01 00 00 00       	mov    $0x1,%eax
  801efa:	eb 05                	jmp    801f01 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 2a                	push   $0x2a
  801f15:	e8 9f fa ff ff       	call   8019b9 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f20:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f24:	75 07                	jne    801f2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	eb 05                	jmp    801f32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 2a                	push   $0x2a
  801f46:	e8 6e fa ff ff       	call   8019b9 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
  801f4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f51:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f55:	75 07                	jne    801f5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f57:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5c:	eb 05                	jmp    801f63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	ff 75 08             	pushl  0x8(%ebp)
  801f73:	6a 2b                	push   $0x2b
  801f75:	e8 3f fa ff ff       	call   8019b9 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	53                   	push   %ebx
  801f93:	51                   	push   %ecx
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	6a 2c                	push   $0x2c
  801f98:	e8 1c fa ff ff       	call   8019b9 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 2d                	push   $0x2d
  801fb8:	e8 fc f9 ff ff       	call   8019b9 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fc5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	51                   	push   %ecx
  801fd1:	ff 75 10             	pushl  0x10(%ebp)
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 2e                	push   $0x2e
  801fd8:	e8 dc f9 ff ff       	call   8019b9 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 10             	pushl  0x10(%ebp)
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 0f                	push   $0xf
  801ff4:	e8 c0 f9 ff ff       	call   8019b9 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	50                   	push   %eax
  80200e:	6a 2f                	push   $0x2f
  802010:	e8 a4 f9 ff ff       	call   8019b9 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp

}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	ff 75 08             	pushl  0x8(%ebp)
  802029:	6a 30                	push   $0x30
  80202b:	e8 89 f9 ff ff       	call   8019b9 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp

}
  802033:	90                   	nop
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	6a 31                	push   $0x31
  802047:	e8 6d f9 ff ff       	call   8019b9 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp

}
  80204f:	90                   	nop
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_hard_limit>:
uint32 sys_hard_limit(){
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 32                	push   $0x32
  802061:	e8 53 f9 ff ff       	call   8019b9 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	83 e8 10             	sub    $0x10,%eax
  802077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  80207a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	83 e8 10             	sub    $0x10,%eax
  80208d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802093:	8a 40 04             	mov    0x4(%eax),%al
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80209e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	83 f8 02             	cmp    $0x2,%eax
  8020ab:	74 2b                	je     8020d8 <alloc_block+0x40>
  8020ad:	83 f8 02             	cmp    $0x2,%eax
  8020b0:	7f 07                	jg     8020b9 <alloc_block+0x21>
  8020b2:	83 f8 01             	cmp    $0x1,%eax
  8020b5:	74 0e                	je     8020c5 <alloc_block+0x2d>
  8020b7:	eb 58                	jmp    802111 <alloc_block+0x79>
  8020b9:	83 f8 03             	cmp    $0x3,%eax
  8020bc:	74 2d                	je     8020eb <alloc_block+0x53>
  8020be:	83 f8 04             	cmp    $0x4,%eax
  8020c1:	74 3b                	je     8020fe <alloc_block+0x66>
  8020c3:	eb 4c                	jmp    802111 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	ff 75 08             	pushl  0x8(%ebp)
  8020cb:	e8 a6 01 00 00       	call   802276 <alloc_block_FF>
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d6:	eb 4a                	jmp    802122 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020d8:	83 ec 0c             	sub    $0xc,%esp
  8020db:	ff 75 08             	pushl  0x8(%ebp)
  8020de:	e8 1d 06 00 00       	call   802700 <alloc_block_NF>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e9:	eb 37                	jmp    802122 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020eb:	83 ec 0c             	sub    $0xc,%esp
  8020ee:	ff 75 08             	pushl  0x8(%ebp)
  8020f1:	e8 94 04 00 00       	call   80258a <alloc_block_BF>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020fc:	eb 24                	jmp    802122 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	e8 da 05 00 00       	call   8026e3 <alloc_block_WF>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80210f:	eb 11                	jmp    802122 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	68 60 37 80 00       	push   $0x803760
  802119:	e8 a9 e5 ff ff       	call   8006c7 <cprintf>
  80211e:	83 c4 10             	add    $0x10,%esp
		break;
  802121:	90                   	nop
	}
	return va;
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	68 80 37 80 00       	push   $0x803780
  802135:	e8 8d e5 ff ff       	call   8006c7 <cprintf>
  80213a:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	68 ab 37 80 00       	push   $0x8037ab
  802145:	e8 7d e5 ff ff       	call   8006c7 <cprintf>
  80214a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802153:	eb 26                	jmp    80217b <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8a 40 04             	mov    0x4(%eax),%al
  80215b:	0f b6 d0             	movzbl %al,%edx
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	52                   	push   %edx
  802167:	50                   	push   %eax
  802168:	68 c3 37 80 00       	push   $0x8037c3
  80216d:	e8 55 e5 ff ff       	call   8006c7 <cprintf>
  802172:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802175:	8b 45 10             	mov    0x10(%ebp),%eax
  802178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217f:	74 08                	je     802189 <print_blocks_list+0x62>
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	eb 05                	jmp    80218e <print_blocks_list+0x67>
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	89 45 10             	mov    %eax,0x10(%ebp)
  802191:	8b 45 10             	mov    0x10(%ebp),%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	75 bd                	jne    802155 <print_blocks_list+0x2e>
  802198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219c:	75 b7                	jne    802155 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	68 80 37 80 00       	push   $0x803780
  8021a6:	e8 1c e5 ff ff       	call   8006c7 <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp

}
  8021ae:	90                   	nop
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  8021b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021bb:	0f 84 b2 00 00 00    	je     802273 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  8021c1:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  8021c8:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  8021cb:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  8021d2:	00 00 00 
  8021d5:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  8021dc:	00 00 00 
  8021df:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  8021e6:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  8021f1:	a1 24 41 80 00       	mov    0x804124,%eax
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  8021fb:	a1 24 41 80 00       	mov    0x804124,%eax
  802200:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  802204:	a1 24 41 80 00       	mov    0x804124,%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	75 14                	jne    802221 <initialize_dynamic_allocator+0x70>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 dc 37 80 00       	push   $0x8037dc
  802215:	6a 68                	push   $0x68
  802217:	68 ff 37 80 00       	push   $0x8037ff
  80221c:	e8 e9 e1 ff ff       	call   80040a <_panic>
  802221:	a1 24 41 80 00       	mov    0x804124,%eax
  802226:	8b 15 14 41 80 00    	mov    0x804114,%edx
  80222c:	89 50 08             	mov    %edx,0x8(%eax)
  80222f:	8b 40 08             	mov    0x8(%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 10                	je     802246 <initialize_dynamic_allocator+0x95>
  802236:	a1 14 41 80 00       	mov    0x804114,%eax
  80223b:	8b 15 24 41 80 00    	mov    0x804124,%edx
  802241:	89 50 0c             	mov    %edx,0xc(%eax)
  802244:	eb 0a                	jmp    802250 <initialize_dynamic_allocator+0x9f>
  802246:	a1 24 41 80 00       	mov    0x804124,%eax
  80224b:	a3 18 41 80 00       	mov    %eax,0x804118
  802250:	a1 24 41 80 00       	mov    0x804124,%eax
  802255:	a3 14 41 80 00       	mov    %eax,0x804114
  80225a:	a1 24 41 80 00       	mov    0x804124,%eax
  80225f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802266:	a1 20 41 80 00       	mov    0x804120,%eax
  80226b:	40                   	inc    %eax
  80226c:	a3 20 41 80 00       	mov    %eax,0x804120
  802271:	eb 01                	jmp    802274 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802273:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  80227c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	75 40                	jne    8022c5 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	83 c0 10             	add    $0x10,%eax
  80228b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	50                   	push   %eax
  802295:	e8 05 f4 ff ff       	call   80169f <sbrk>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 f5 f3 ff ff       	call   80169f <sbrk>
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  8022b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8022b6:	83 ec 08             	sub    $0x8,%esp
  8022b9:	50                   	push   %eax
  8022ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8022bd:	e8 ef fe ff ff       	call   8021b1 <initialize_dynamic_allocator>
  8022c2:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  8022c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c9:	75 0a                	jne    8022d5 <alloc_block_FF+0x5f>
		 return NULL;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	e9 b3 02 00 00       	jmp    802588 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  8022d5:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  8022d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  8022e0:	a1 14 41 80 00       	mov    0x804114,%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e8:	e9 12 01 00 00       	jmp    8023ff <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8a 40 04             	mov    0x4(%eax),%al
  8022f3:	84 c0                	test   %al,%al
  8022f5:	0f 84 fc 00 00 00    	je     8023f7 <alloc_block_FF+0x181>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	3b 45 08             	cmp    0x8(%ebp),%eax
  802303:	0f 82 ee 00 00 00    	jb     8023f7 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802311:	75 12                	jne    802325 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	83 c0 10             	add    $0x10,%eax
  802320:	e9 63 02 00 00       	jmp    802588 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  802325:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	2b 45 08             	sub    0x8(%ebp),%eax
  80233b:	83 f8 0f             	cmp    $0xf,%eax
  80233e:	0f 86 a8 00 00 00    	jbe    8023ec <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	01 d0                	add    %edx,%eax
  80234c:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	2b 45 08             	sub    0x8(%ebp),%eax
  802357:	89 c2                	mov    %eax,%edx
  802359:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80235c:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 55 08             	mov    0x8(%ebp),%edx
  802364:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802366:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802369:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  80236d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802371:	74 06                	je     802379 <alloc_block_FF+0x103>
  802373:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802377:	75 17                	jne    802390 <alloc_block_FF+0x11a>
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 18 38 80 00       	push   $0x803818
  802381:	68 91 00 00 00       	push   $0x91
  802386:	68 ff 37 80 00       	push   $0x8037ff
  80238b:	e8 7a e0 ff ff       	call   80040a <_panic>
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 50 08             	mov    0x8(%eax),%edx
  802396:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802399:	89 50 08             	mov    %edx,0x8(%eax)
  80239c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80239f:	8b 40 08             	mov    0x8(%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 0c                	je     8023b2 <alloc_block_FF+0x13c>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 40 08             	mov    0x8(%eax),%eax
  8023ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023af:	89 50 0c             	mov    %edx,0xc(%eax)
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8023b8:	89 50 08             	mov    %edx,0x8(%eax)
  8023bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c1:	89 50 0c             	mov    %edx,0xc(%eax)
  8023c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023c7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 08                	jne    8023d6 <alloc_block_FF+0x160>
  8023ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d1:	a3 18 41 80 00       	mov    %eax,0x804118
  8023d6:	a1 20 41 80 00       	mov    0x804120,%eax
  8023db:	40                   	inc    %eax
  8023dc:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	83 c0 10             	add    $0x10,%eax
  8023e7:	e9 9c 01 00 00       	jmp    802588 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	83 c0 10             	add    $0x10,%eax
  8023f2:	e9 91 01 00 00       	jmp    802588 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  8023f7:	a1 1c 41 80 00       	mov    0x80411c,%eax
  8023fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802403:	74 08                	je     80240d <alloc_block_FF+0x197>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	eb 05                	jmp    802412 <alloc_block_FF+0x19c>
  80240d:	b8 00 00 00 00       	mov    $0x0,%eax
  802412:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802417:	a1 1c 41 80 00       	mov    0x80411c,%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	0f 85 c9 fe ff ff    	jne    8022ed <alloc_block_FF+0x77>
  802424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802428:	0f 85 bf fe ff ff    	jne    8022ed <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  80242e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802432:	0f 85 4b 01 00 00    	jne    802583 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	83 ec 0c             	sub    $0xc,%esp
  80243e:	50                   	push   %eax
  80243f:	e8 5b f2 ff ff       	call   80169f <sbrk>
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	0f 84 28 01 00 00    	je     80257c <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  80245a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245d:	8b 55 08             	mov    0x8(%ebp),%edx
  802460:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802465:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80246d:	75 17                	jne    802486 <alloc_block_FF+0x210>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 4c 38 80 00       	push   $0x80384c
  802477:	68 a1 00 00 00       	push   $0xa1
  80247c:	68 ff 37 80 00       	push   $0x8037ff
  802481:	e8 84 df ff ff       	call   80040a <_panic>
  802486:	8b 15 18 41 80 00    	mov    0x804118,%edx
  80248c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248f:	89 50 0c             	mov    %edx,0xc(%eax)
  802492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802495:	8b 40 0c             	mov    0xc(%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 0d                	je     8024a9 <alloc_block_FF+0x233>
  80249c:	a1 18 41 80 00       	mov    0x804118,%eax
  8024a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024a4:	89 50 08             	mov    %edx,0x8(%eax)
  8024a7:	eb 08                	jmp    8024b1 <alloc_block_FF+0x23b>
  8024a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ac:	a3 14 41 80 00       	mov    %eax,0x804114
  8024b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b4:	a3 18 41 80 00       	mov    %eax,0x804118
  8024b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8024c3:	a1 20 41 80 00       	mov    0x804120,%eax
  8024c8:	40                   	inc    %eax
  8024c9:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  8024ce:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d6:	83 f8 0f             	cmp    $0xf,%eax
  8024d9:	0f 86 95 00 00 00    	jbe    802574 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  8024df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	01 d0                	add    %edx,%eax
  8024e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  8024ea:	b8 00 10 00 00       	mov    $0x1000,%eax
  8024ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f2:	89 c2                	mov    %eax,%edx
  8024f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024f7:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  8024f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024fc:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802500:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802504:	74 06                	je     80250c <alloc_block_FF+0x296>
  802506:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80250a:	75 17                	jne    802523 <alloc_block_FF+0x2ad>
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 18 38 80 00       	push   $0x803818
  802514:	68 a6 00 00 00       	push   $0xa6
  802519:	68 ff 37 80 00       	push   $0x8037ff
  80251e:	e8 e7 de ff ff       	call   80040a <_panic>
  802523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802526:	8b 50 08             	mov    0x8(%eax),%edx
  802529:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80252c:	89 50 08             	mov    %edx,0x8(%eax)
  80252f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802532:	8b 40 08             	mov    0x8(%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 0c                	je     802545 <alloc_block_FF+0x2cf>
  802539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253c:	8b 40 08             	mov    0x8(%eax),%eax
  80253f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802542:	89 50 0c             	mov    %edx,0xc(%eax)
  802545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802548:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254b:	89 50 08             	mov    %edx,0x8(%eax)
  80254e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802551:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802554:	89 50 0c             	mov    %edx,0xc(%eax)
  802557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80255a:	8b 40 08             	mov    0x8(%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	75 08                	jne    802569 <alloc_block_FF+0x2f3>
  802561:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802564:	a3 18 41 80 00       	mov    %eax,0x804118
  802569:	a1 20 41 80 00       	mov    0x804120,%eax
  80256e:	40                   	inc    %eax
  80256f:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  802574:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802577:	83 c0 10             	add    $0x10,%eax
  80257a:	eb 0c                	jmp    802588 <alloc_block_FF+0x312>
		 }
		 return NULL;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	eb 05                	jmp    802588 <alloc_block_FF+0x312>
	 }
	 return NULL;
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802590:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  80259b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  8025a2:	a1 14 41 80 00       	mov    0x804114,%eax
  8025a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025aa:	eb 34                	jmp    8025e0 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8a 40 04             	mov    0x4(%eax),%al
  8025b2:	84 c0                	test   %al,%al
  8025b4:	74 22                	je     8025d8 <alloc_block_BF+0x4e>
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025be:	72 18                	jb     8025d8 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  8025c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c8:	73 0e                	jae    8025d8 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  8025d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  8025d8:	a1 1c 41 80 00       	mov    0x80411c,%eax
  8025dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e4:	74 08                	je     8025ee <alloc_block_BF+0x64>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	8b 40 08             	mov    0x8(%eax),%eax
  8025ec:	eb 05                	jmp    8025f3 <alloc_block_BF+0x69>
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	a3 1c 41 80 00       	mov    %eax,0x80411c
  8025f8:	a1 1c 41 80 00       	mov    0x80411c,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	75 ab                	jne    8025ac <alloc_block_BF+0x22>
  802601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802605:	75 a5                	jne    8025ac <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	0f 84 cb 00 00 00    	je     8026dc <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802620:	0f 86 ae 00 00 00    	jbe    8026d4 <alloc_block_BF+0x14a>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	2b 45 08             	sub    0x8(%ebp),%eax
  80262e:	83 f8 0f             	cmp    $0xf,%eax
  802631:	0f 86 9d 00 00 00    	jbe    8026d4 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	01 d0                	add    %edx,%eax
  80263f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	2b 45 08             	sub    0x8(%ebp),%eax
  80264a:	89 c2                	mov    %eax,%edx
  80264c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264f:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  802651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802654:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 55 08             	mov    0x8(%ebp),%edx
  80265e:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	74 06                	je     80266c <alloc_block_BF+0xe2>
  802666:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80266a:	75 17                	jne    802683 <alloc_block_BF+0xf9>
  80266c:	83 ec 04             	sub    $0x4,%esp
  80266f:	68 18 38 80 00       	push   $0x803818
  802674:	68 c6 00 00 00       	push   $0xc6
  802679:	68 ff 37 80 00       	push   $0x8037ff
  80267e:	e8 87 dd ff ff       	call   80040a <_panic>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 50 08             	mov    0x8(%eax),%edx
  802689:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268c:	89 50 08             	mov    %edx,0x8(%eax)
  80268f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802692:	8b 40 08             	mov    0x8(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0c                	je     8026a5 <alloc_block_BF+0x11b>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 08             	mov    0x8(%eax),%eax
  80269f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026a2:	89 50 0c             	mov    %edx,0xc(%eax)
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ab:	89 50 08             	mov    %edx,0x8(%eax)
  8026ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	89 50 0c             	mov    %edx,0xc(%eax)
  8026b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ba:	8b 40 08             	mov    0x8(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	75 08                	jne    8026c9 <alloc_block_BF+0x13f>
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	a3 18 41 80 00       	mov    %eax,0x804118
  8026c9:	a1 20 41 80 00       	mov    0x804120,%eax
  8026ce:	40                   	inc    %eax
  8026cf:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	83 c0 10             	add    $0x10,%eax
  8026da:	eb 05                	jmp    8026e1 <alloc_block_BF+0x157>
    }

    return NULL;
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	68 70 38 80 00       	push   $0x803870
  8026f1:	68 d2 00 00 00       	push   $0xd2
  8026f6:	68 ff 37 80 00       	push   $0x8037ff
  8026fb:	e8 0a dd ff ff       	call   80040a <_panic>

00802700 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	68 98 38 80 00       	push   $0x803898
  80270e:	68 db 00 00 00       	push   $0xdb
  802713:	68 ff 37 80 00       	push   $0x8037ff
  802718:	e8 ed dc ff ff       	call   80040a <_panic>

0080271d <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802723:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802727:	0f 84 d2 01 00 00    	je     8028ff <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	83 e8 10             	sub    $0x10,%eax
  802733:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8a 40 04             	mov    0x4(%eax),%al
  80273c:	84 c0                	test   %al,%al
  80273e:	0f 85 be 01 00 00    	jne    802902 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	0f 84 cc 00 00 00    	je     802825 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 08             	mov    0x8(%eax),%eax
  80275f:	8a 40 04             	mov    0x4(%eax),%al
  802762:	84 c0                	test   %al,%al
  802764:	0f 84 bb 00 00 00    	je     802825 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 10                	mov    (%eax),%edx
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 08             	mov    0x8(%eax),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	01 c2                	add    %eax,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 40 08             	mov    0x8(%eax),%eax
  802784:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 08             	mov    0x8(%eax),%eax
  80278e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 08             	mov    0x8(%eax),%eax
  80279a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  80279d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a1:	75 17                	jne    8027ba <free_block+0x9d>
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	68 be 38 80 00       	push   $0x8038be
  8027ab:	68 f8 00 00 00       	push   $0xf8
  8027b0:	68 ff 37 80 00       	push   $0x8037ff
  8027b5:	e8 50 dc ff ff       	call   80040a <_panic>
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	74 11                	je     8027d5 <free_block+0xb8>
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8027d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8027d3:	eb 0b                	jmp    8027e0 <free_block+0xc3>
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027db:	a3 18 41 80 00       	mov    %eax,0x804118
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 11                	je     8027fb <free_block+0xde>
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f3:	8b 52 08             	mov    0x8(%edx),%edx
  8027f6:	89 50 08             	mov    %edx,0x8(%eax)
  8027f9:	eb 0b                	jmp    802806 <free_block+0xe9>
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	8b 40 08             	mov    0x8(%eax),%eax
  802801:	a3 14 41 80 00       	mov    %eax,0x804114
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80281a:	a1 20 41 80 00       	mov    0x804120,%eax
  80281f:	48                   	dec    %eax
  802820:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	0f 84 d0 00 00 00    	je     802903 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 0c             	mov    0xc(%eax),%eax
  802839:	8a 40 04             	mov    0x4(%eax),%al
  80283c:	84 c0                	test   %al,%al
  80283e:	0f 84 bf 00 00 00    	je     802903 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284d:	8b 52 0c             	mov    0xc(%edx),%edx
  802850:	8b 0a                	mov    (%edx),%ecx
  802852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802855:	8b 12                	mov    (%edx),%edx
  802857:	01 ca                	add    %ecx,%edx
  802859:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 0c             	mov    0xc(%eax),%eax
  802861:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 17                	jne    802892 <free_block+0x175>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 be 38 80 00       	push   $0x8038be
  802883:	68 03 01 00 00       	push   $0x103
  802888:	68 ff 37 80 00       	push   $0x8037ff
  80288d:	e8 78 db ff ff       	call   80040a <_panic>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 08             	mov    0x8(%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 11                	je     8028ad <free_block+0x190>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 08             	mov    0x8(%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <free_block+0x19b>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	a3 18 41 80 00       	mov    %eax,0x804118
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 11                	je     8028d3 <free_block+0x1b6>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 52 08             	mov    0x8(%edx),%edx
  8028ce:	89 50 08             	mov    %edx,0x8(%eax)
  8028d1:	eb 0b                	jmp    8028de <free_block+0x1c1>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 08             	mov    0x8(%eax),%eax
  8028d9:	a3 14 41 80 00       	mov    %eax,0x804114
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8028f2:	a1 20 41 80 00       	mov    0x804120,%eax
  8028f7:	48                   	dec    %eax
  8028f8:	a3 20 41 80 00       	mov    %eax,0x804120
  8028fd:	eb 04                	jmp    802903 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  8028ff:	90                   	nop
  802900:	eb 01                	jmp    802903 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802902:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  80290b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290f:	75 10                	jne    802921 <realloc_block_FF+0x1c>
  802911:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802915:	75 0a                	jne    802921 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802917:	b8 00 00 00 00       	mov    $0x0,%eax
  80291c:	e9 2e 03 00 00       	jmp    802c4f <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802921:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802925:	75 13                	jne    80293a <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	ff 75 0c             	pushl  0xc(%ebp)
  80292d:	e8 44 f9 ff ff       	call   802276 <alloc_block_FF>
  802932:	83 c4 10             	add    $0x10,%esp
  802935:	e9 15 03 00 00       	jmp    802c4f <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  80293a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80293e:	75 18                	jne    802958 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  802940:	83 ec 0c             	sub    $0xc,%esp
  802943:	ff 75 08             	pushl  0x8(%ebp)
  802946:	e8 d2 fd ff ff       	call   80271d <free_block>
  80294b:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	e9 f7 02 00 00       	jmp    802c4f <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	83 e8 10             	sub    $0x10,%eax
  80295e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  802961:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80296d:	0f 82 c8 00 00 00    	jb     802a3b <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80297b:	75 08                	jne    802985 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	e9 ca 02 00 00       	jmp    802c4f <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80298d:	83 f8 0f             	cmp    $0xf,%eax
  802990:	0f 86 9d 00 00 00    	jbe    802a33 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80299c:	01 d0                	add    %edx,%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b6:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  8029bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c3:	74 06                	je     8029cb <realloc_block_FF+0xc6>
  8029c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c9:	75 17                	jne    8029e2 <realloc_block_FF+0xdd>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 18 38 80 00       	push   $0x803818
  8029d3:	68 2a 01 00 00       	push   $0x12a
  8029d8:	68 ff 37 80 00       	push   $0x8037ff
  8029dd:	e8 28 da ff ff       	call   80040a <_panic>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 50 08             	mov    0x8(%eax),%edx
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	89 50 08             	mov    %edx,0x8(%eax)
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 40 08             	mov    0x8(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0c                	je     802a04 <realloc_block_FF+0xff>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 40 08             	mov    0x8(%eax),%eax
  8029fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a01:	89 50 0c             	mov    %edx,0xc(%eax)
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0a:	89 50 08             	mov    %edx,0x8(%eax)
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a13:	89 50 0c             	mov    %edx,0xc(%eax)
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	8b 40 08             	mov    0x8(%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	75 08                	jne    802a28 <realloc_block_FF+0x123>
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	a3 18 41 80 00       	mov    %eax,0x804118
  802a28:	a1 20 41 80 00       	mov    0x804120,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	e9 14 02 00 00       	jmp    802c4f <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 08             	mov    0x8(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	0f 84 97 01 00 00    	je     802be0 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	8a 40 04             	mov    0x4(%eax),%al
  802a52:	84 c0                	test   %al,%al
  802a54:	0f 84 86 01 00 00    	je     802be0 <realloc_block_FF+0x2db>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 10                	mov    (%eax),%edx
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a6c:	0f 82 6e 01 00 00    	jb     802be0 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 10                	mov    (%eax),%edx
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 08             	mov    0x8(%eax),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	01 c2                	add    %eax,%edx
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
  802a8c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 08             	mov    0x8(%eax),%eax
  802a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 08             	mov    0x8(%eax),%eax
  802aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  802aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa9:	75 17                	jne    802ac2 <realloc_block_FF+0x1bd>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 be 38 80 00       	push   $0x8038be
  802ab3:	68 38 01 00 00       	push   $0x138
  802ab8:	68 ff 37 80 00       	push   $0x8037ff
  802abd:	e8 48 d9 ff ff       	call   80040a <_panic>
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 11                	je     802add <realloc_block_FF+0x1d8>
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad5:	8b 52 0c             	mov    0xc(%edx),%edx
  802ad8:	89 50 0c             	mov    %edx,0xc(%eax)
  802adb:	eb 0b                	jmp    802ae8 <realloc_block_FF+0x1e3>
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	a3 18 41 80 00       	mov    %eax,0x804118
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	74 11                	je     802b03 <realloc_block_FF+0x1fe>
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	8b 40 0c             	mov    0xc(%eax),%eax
  802af8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afb:	8b 52 08             	mov    0x8(%edx),%edx
  802afe:	89 50 08             	mov    %edx,0x8(%eax)
  802b01:	eb 0b                	jmp    802b0e <realloc_block_FF+0x209>
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	8b 40 08             	mov    0x8(%eax),%eax
  802b09:	a3 14 41 80 00       	mov    %eax,0x804114
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b22:	a1 20 41 80 00       	mov    0x804120,%eax
  802b27:	48                   	dec    %eax
  802b28:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b35:	83 f8 0f             	cmp    $0xf,%eax
  802b38:	0f 86 9d 00 00 00    	jbe    802bdb <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b44:	01 d0                	add    %edx,%eax
  802b46:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b51:	89 c2                	mov    %eax,%edx
  802b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b56:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5e:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  802b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b63:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	74 06                	je     802b73 <realloc_block_FF+0x26e>
  802b6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b71:	75 17                	jne    802b8a <realloc_block_FF+0x285>
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	68 18 38 80 00       	push   $0x803818
  802b7b:	68 3f 01 00 00       	push   $0x13f
  802b80:	68 ff 37 80 00       	push   $0x8037ff
  802b85:	e8 80 d8 ff ff       	call   80040a <_panic>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b93:	89 50 08             	mov    %edx,0x8(%eax)
  802b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b99:	8b 40 08             	mov    0x8(%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0c                	je     802bac <realloc_block_FF+0x2a7>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
  802ba6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba9:	89 50 0c             	mov    %edx,0xc(%eax)
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb2:	89 50 08             	mov    %edx,0x8(%eax)
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbb:	89 50 0c             	mov    %edx,0xc(%eax)
  802bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	75 08                	jne    802bd0 <realloc_block_FF+0x2cb>
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	a3 18 41 80 00       	mov    %eax,0x804118
  802bd0:	a1 20 41 80 00       	mov    0x804120,%eax
  802bd5:	40                   	inc    %eax
  802bd6:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	eb 6f                	jmp    802c4f <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  802be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be3:	83 e8 10             	sub    $0x10,%eax
  802be6:	83 ec 0c             	sub    $0xc,%esp
  802be9:	50                   	push   %eax
  802bea:	e8 87 f6 ff ff       	call   802276 <alloc_block_FF>
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  802bf5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bf9:	75 29                	jne    802c24 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  802bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfe:	83 ec 0c             	sub    $0xc,%esp
  802c01:	50                   	push   %eax
  802c02:	e8 98 ea ff ff       	call   80169f <sbrk>
  802c07:	83 c4 10             	add    $0x10,%esp
  802c0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  802c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c10:	83 f8 ff             	cmp    $0xffffffff,%eax
  802c13:	75 07                	jne    802c1c <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1a:	eb 33                	jmp    802c4f <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  802c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1f:	83 c0 10             	add    $0x10,%eax
  802c22:	eb 2b                	jmp    802c4f <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	50                   	push   %eax
  802c2d:	ff 75 f4             	pushl  -0xc(%ebp)
  802c30:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c33:	e8 2f e3 ff ff       	call   800f67 <memcpy>
  802c38:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  802c3b:	83 ec 0c             	sub    $0xc,%esp
  802c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  802c41:	e8 d7 fa ff ff       	call   80271d <free_block>
  802c46:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  802c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4c:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  802c4f:	c9                   	leave  
  802c50:	c3                   	ret    
  802c51:	66 90                	xchg   %ax,%ax
  802c53:	90                   	nop

00802c54 <__udivdi3>:
  802c54:	55                   	push   %ebp
  802c55:	57                   	push   %edi
  802c56:	56                   	push   %esi
  802c57:	53                   	push   %ebx
  802c58:	83 ec 1c             	sub    $0x1c,%esp
  802c5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802c5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c6b:	89 ca                	mov    %ecx,%edx
  802c6d:	89 f8                	mov    %edi,%eax
  802c6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802c73:	85 f6                	test   %esi,%esi
  802c75:	75 2d                	jne    802ca4 <__udivdi3+0x50>
  802c77:	39 cf                	cmp    %ecx,%edi
  802c79:	77 65                	ja     802ce0 <__udivdi3+0x8c>
  802c7b:	89 fd                	mov    %edi,%ebp
  802c7d:	85 ff                	test   %edi,%edi
  802c7f:	75 0b                	jne    802c8c <__udivdi3+0x38>
  802c81:	b8 01 00 00 00       	mov    $0x1,%eax
  802c86:	31 d2                	xor    %edx,%edx
  802c88:	f7 f7                	div    %edi
  802c8a:	89 c5                	mov    %eax,%ebp
  802c8c:	31 d2                	xor    %edx,%edx
  802c8e:	89 c8                	mov    %ecx,%eax
  802c90:	f7 f5                	div    %ebp
  802c92:	89 c1                	mov    %eax,%ecx
  802c94:	89 d8                	mov    %ebx,%eax
  802c96:	f7 f5                	div    %ebp
  802c98:	89 cf                	mov    %ecx,%edi
  802c9a:	89 fa                	mov    %edi,%edx
  802c9c:	83 c4 1c             	add    $0x1c,%esp
  802c9f:	5b                   	pop    %ebx
  802ca0:	5e                   	pop    %esi
  802ca1:	5f                   	pop    %edi
  802ca2:	5d                   	pop    %ebp
  802ca3:	c3                   	ret    
  802ca4:	39 ce                	cmp    %ecx,%esi
  802ca6:	77 28                	ja     802cd0 <__udivdi3+0x7c>
  802ca8:	0f bd fe             	bsr    %esi,%edi
  802cab:	83 f7 1f             	xor    $0x1f,%edi
  802cae:	75 40                	jne    802cf0 <__udivdi3+0x9c>
  802cb0:	39 ce                	cmp    %ecx,%esi
  802cb2:	72 0a                	jb     802cbe <__udivdi3+0x6a>
  802cb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802cb8:	0f 87 9e 00 00 00    	ja     802d5c <__udivdi3+0x108>
  802cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc3:	89 fa                	mov    %edi,%edx
  802cc5:	83 c4 1c             	add    $0x1c,%esp
  802cc8:	5b                   	pop    %ebx
  802cc9:	5e                   	pop    %esi
  802cca:	5f                   	pop    %edi
  802ccb:	5d                   	pop    %ebp
  802ccc:	c3                   	ret    
  802ccd:	8d 76 00             	lea    0x0(%esi),%esi
  802cd0:	31 ff                	xor    %edi,%edi
  802cd2:	31 c0                	xor    %eax,%eax
  802cd4:	89 fa                	mov    %edi,%edx
  802cd6:	83 c4 1c             	add    $0x1c,%esp
  802cd9:	5b                   	pop    %ebx
  802cda:	5e                   	pop    %esi
  802cdb:	5f                   	pop    %edi
  802cdc:	5d                   	pop    %ebp
  802cdd:	c3                   	ret    
  802cde:	66 90                	xchg   %ax,%ax
  802ce0:	89 d8                	mov    %ebx,%eax
  802ce2:	f7 f7                	div    %edi
  802ce4:	31 ff                	xor    %edi,%edi
  802ce6:	89 fa                	mov    %edi,%edx
  802ce8:	83 c4 1c             	add    $0x1c,%esp
  802ceb:	5b                   	pop    %ebx
  802cec:	5e                   	pop    %esi
  802ced:	5f                   	pop    %edi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    
  802cf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  802cf5:	89 eb                	mov    %ebp,%ebx
  802cf7:	29 fb                	sub    %edi,%ebx
  802cf9:	89 f9                	mov    %edi,%ecx
  802cfb:	d3 e6                	shl    %cl,%esi
  802cfd:	89 c5                	mov    %eax,%ebp
  802cff:	88 d9                	mov    %bl,%cl
  802d01:	d3 ed                	shr    %cl,%ebp
  802d03:	89 e9                	mov    %ebp,%ecx
  802d05:	09 f1                	or     %esi,%ecx
  802d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d0b:	89 f9                	mov    %edi,%ecx
  802d0d:	d3 e0                	shl    %cl,%eax
  802d0f:	89 c5                	mov    %eax,%ebp
  802d11:	89 d6                	mov    %edx,%esi
  802d13:	88 d9                	mov    %bl,%cl
  802d15:	d3 ee                	shr    %cl,%esi
  802d17:	89 f9                	mov    %edi,%ecx
  802d19:	d3 e2                	shl    %cl,%edx
  802d1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d1f:	88 d9                	mov    %bl,%cl
  802d21:	d3 e8                	shr    %cl,%eax
  802d23:	09 c2                	or     %eax,%edx
  802d25:	89 d0                	mov    %edx,%eax
  802d27:	89 f2                	mov    %esi,%edx
  802d29:	f7 74 24 0c          	divl   0xc(%esp)
  802d2d:	89 d6                	mov    %edx,%esi
  802d2f:	89 c3                	mov    %eax,%ebx
  802d31:	f7 e5                	mul    %ebp
  802d33:	39 d6                	cmp    %edx,%esi
  802d35:	72 19                	jb     802d50 <__udivdi3+0xfc>
  802d37:	74 0b                	je     802d44 <__udivdi3+0xf0>
  802d39:	89 d8                	mov    %ebx,%eax
  802d3b:	31 ff                	xor    %edi,%edi
  802d3d:	e9 58 ff ff ff       	jmp    802c9a <__udivdi3+0x46>
  802d42:	66 90                	xchg   %ax,%ax
  802d44:	8b 54 24 08          	mov    0x8(%esp),%edx
  802d48:	89 f9                	mov    %edi,%ecx
  802d4a:	d3 e2                	shl    %cl,%edx
  802d4c:	39 c2                	cmp    %eax,%edx
  802d4e:	73 e9                	jae    802d39 <__udivdi3+0xe5>
  802d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d53:	31 ff                	xor    %edi,%edi
  802d55:	e9 40 ff ff ff       	jmp    802c9a <__udivdi3+0x46>
  802d5a:	66 90                	xchg   %ax,%ax
  802d5c:	31 c0                	xor    %eax,%eax
  802d5e:	e9 37 ff ff ff       	jmp    802c9a <__udivdi3+0x46>
  802d63:	90                   	nop

00802d64 <__umoddi3>:
  802d64:	55                   	push   %ebp
  802d65:	57                   	push   %edi
  802d66:	56                   	push   %esi
  802d67:	53                   	push   %ebx
  802d68:	83 ec 1c             	sub    $0x1c,%esp
  802d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d83:	89 f3                	mov    %esi,%ebx
  802d85:	89 fa                	mov    %edi,%edx
  802d87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d8b:	89 34 24             	mov    %esi,(%esp)
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	75 1a                	jne    802dac <__umoddi3+0x48>
  802d92:	39 f7                	cmp    %esi,%edi
  802d94:	0f 86 a2 00 00 00    	jbe    802e3c <__umoddi3+0xd8>
  802d9a:	89 c8                	mov    %ecx,%eax
  802d9c:	89 f2                	mov    %esi,%edx
  802d9e:	f7 f7                	div    %edi
  802da0:	89 d0                	mov    %edx,%eax
  802da2:	31 d2                	xor    %edx,%edx
  802da4:	83 c4 1c             	add    $0x1c,%esp
  802da7:	5b                   	pop    %ebx
  802da8:	5e                   	pop    %esi
  802da9:	5f                   	pop    %edi
  802daa:	5d                   	pop    %ebp
  802dab:	c3                   	ret    
  802dac:	39 f0                	cmp    %esi,%eax
  802dae:	0f 87 ac 00 00 00    	ja     802e60 <__umoddi3+0xfc>
  802db4:	0f bd e8             	bsr    %eax,%ebp
  802db7:	83 f5 1f             	xor    $0x1f,%ebp
  802dba:	0f 84 ac 00 00 00    	je     802e6c <__umoddi3+0x108>
  802dc0:	bf 20 00 00 00       	mov    $0x20,%edi
  802dc5:	29 ef                	sub    %ebp,%edi
  802dc7:	89 fe                	mov    %edi,%esi
  802dc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dcd:	89 e9                	mov    %ebp,%ecx
  802dcf:	d3 e0                	shl    %cl,%eax
  802dd1:	89 d7                	mov    %edx,%edi
  802dd3:	89 f1                	mov    %esi,%ecx
  802dd5:	d3 ef                	shr    %cl,%edi
  802dd7:	09 c7                	or     %eax,%edi
  802dd9:	89 e9                	mov    %ebp,%ecx
  802ddb:	d3 e2                	shl    %cl,%edx
  802ddd:	89 14 24             	mov    %edx,(%esp)
  802de0:	89 d8                	mov    %ebx,%eax
  802de2:	d3 e0                	shl    %cl,%eax
  802de4:	89 c2                	mov    %eax,%edx
  802de6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802dea:	d3 e0                	shl    %cl,%eax
  802dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  802df0:	8b 44 24 08          	mov    0x8(%esp),%eax
  802df4:	89 f1                	mov    %esi,%ecx
  802df6:	d3 e8                	shr    %cl,%eax
  802df8:	09 d0                	or     %edx,%eax
  802dfa:	d3 eb                	shr    %cl,%ebx
  802dfc:	89 da                	mov    %ebx,%edx
  802dfe:	f7 f7                	div    %edi
  802e00:	89 d3                	mov    %edx,%ebx
  802e02:	f7 24 24             	mull   (%esp)
  802e05:	89 c6                	mov    %eax,%esi
  802e07:	89 d1                	mov    %edx,%ecx
  802e09:	39 d3                	cmp    %edx,%ebx
  802e0b:	0f 82 87 00 00 00    	jb     802e98 <__umoddi3+0x134>
  802e11:	0f 84 91 00 00 00    	je     802ea8 <__umoddi3+0x144>
  802e17:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e1b:	29 f2                	sub    %esi,%edx
  802e1d:	19 cb                	sbb    %ecx,%ebx
  802e1f:	89 d8                	mov    %ebx,%eax
  802e21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802e25:	d3 e0                	shl    %cl,%eax
  802e27:	89 e9                	mov    %ebp,%ecx
  802e29:	d3 ea                	shr    %cl,%edx
  802e2b:	09 d0                	or     %edx,%eax
  802e2d:	89 e9                	mov    %ebp,%ecx
  802e2f:	d3 eb                	shr    %cl,%ebx
  802e31:	89 da                	mov    %ebx,%edx
  802e33:	83 c4 1c             	add    $0x1c,%esp
  802e36:	5b                   	pop    %ebx
  802e37:	5e                   	pop    %esi
  802e38:	5f                   	pop    %edi
  802e39:	5d                   	pop    %ebp
  802e3a:	c3                   	ret    
  802e3b:	90                   	nop
  802e3c:	89 fd                	mov    %edi,%ebp
  802e3e:	85 ff                	test   %edi,%edi
  802e40:	75 0b                	jne    802e4d <__umoddi3+0xe9>
  802e42:	b8 01 00 00 00       	mov    $0x1,%eax
  802e47:	31 d2                	xor    %edx,%edx
  802e49:	f7 f7                	div    %edi
  802e4b:	89 c5                	mov    %eax,%ebp
  802e4d:	89 f0                	mov    %esi,%eax
  802e4f:	31 d2                	xor    %edx,%edx
  802e51:	f7 f5                	div    %ebp
  802e53:	89 c8                	mov    %ecx,%eax
  802e55:	f7 f5                	div    %ebp
  802e57:	89 d0                	mov    %edx,%eax
  802e59:	e9 44 ff ff ff       	jmp    802da2 <__umoddi3+0x3e>
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	89 c8                	mov    %ecx,%eax
  802e62:	89 f2                	mov    %esi,%edx
  802e64:	83 c4 1c             	add    $0x1c,%esp
  802e67:	5b                   	pop    %ebx
  802e68:	5e                   	pop    %esi
  802e69:	5f                   	pop    %edi
  802e6a:	5d                   	pop    %ebp
  802e6b:	c3                   	ret    
  802e6c:	3b 04 24             	cmp    (%esp),%eax
  802e6f:	72 06                	jb     802e77 <__umoddi3+0x113>
  802e71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802e75:	77 0f                	ja     802e86 <__umoddi3+0x122>
  802e77:	89 f2                	mov    %esi,%edx
  802e79:	29 f9                	sub    %edi,%ecx
  802e7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802e7f:	89 14 24             	mov    %edx,(%esp)
  802e82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e86:	8b 44 24 04          	mov    0x4(%esp),%eax
  802e8a:	8b 14 24             	mov    (%esp),%edx
  802e8d:	83 c4 1c             	add    $0x1c,%esp
  802e90:	5b                   	pop    %ebx
  802e91:	5e                   	pop    %esi
  802e92:	5f                   	pop    %edi
  802e93:	5d                   	pop    %ebp
  802e94:	c3                   	ret    
  802e95:	8d 76 00             	lea    0x0(%esi),%esi
  802e98:	2b 04 24             	sub    (%esp),%eax
  802e9b:	19 fa                	sbb    %edi,%edx
  802e9d:	89 d1                	mov    %edx,%ecx
  802e9f:	89 c6                	mov    %eax,%esi
  802ea1:	e9 71 ff ff ff       	jmp    802e17 <__umoddi3+0xb3>
  802ea6:	66 90                	xchg   %ax,%ax
  802ea8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802eac:	72 ea                	jb     802e98 <__umoddi3+0x134>
  802eae:	89 d9                	mov    %ebx,%ecx
  802eb0:	e9 62 ff ff ff       	jmp    802e17 <__umoddi3+0xb3>
