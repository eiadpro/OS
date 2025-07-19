
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 2a 0e 00 00       	call   800e60 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 60 3a 80 00       	push   $0x803a60
  800065:	6a 1c                	push   $0x1c
  800067:	68 7c 3a 80 00       	push   $0x803a7c
  80006c:	e8 26 0f 00 00       	call   800f97 <_panic>
	//	malloc(0);
	/*=================================================*/

	//cprintf("2\n");

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
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 85 25 00 00       	call   802632 <sys_calculate_free_frames>
  8000ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000b0:	8d 95 0c ff ff ff    	lea    -0xf4(%ebp),%edx
  8000b6:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	89 d7                	mov    %edx,%edi
  8000c2:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 69 25 00 00       	call   802632 <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 ac 25 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 5d 21 00 00       	call   802242 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000ee:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8000f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 90 3a 80 00       	push   $0x803a90
  800101:	6a 44                	push   $0x44
  800103:	68 7c 3a 80 00       	push   $0x803a7c
  800108:	e8 8a 0e 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  80010d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800110:	e8 1d 25 00 00       	call   802632 <sys_calculate_free_frames>
  800115:	29 c3                	sub    %eax,%ebx
  800117:	89 d8                	mov    %ebx,%eax
  800119:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  80011e:	76 14                	jbe    800134 <_main+0xfc>
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	68 c0 3a 80 00       	push   $0x803ac0
  800128:	6a 45                	push   $0x45
  80012a:	68 7c 3a 80 00       	push   $0x803a7c
  80012f:	e8 63 0e 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800134:	e8 44 25 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800139:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80013c:	74 14                	je     800152 <_main+0x11a>
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 0c 3b 80 00       	push   $0x803b0c
  800146:	6a 46                	push   $0x46
  800148:	68 7c 3a 80 00       	push   $0x803a7c
  80014d:	e8 45 0e 00 00       	call   800f97 <_panic>


			freeFrames = sys_calculate_free_frames() ;
  800152:	e8 db 24 00 00       	call   802632 <sys_calculate_free_frames>
  800157:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80015a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015d:	01 c0                	add    %eax,%eax
  80015f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800162:	48                   	dec    %eax
  800163:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800166:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80016c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			byteArr[0] = minByte ;
  80016f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800172:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800175:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800177:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80017a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80017d:	01 c2                	add    %eax,%edx
  80017f:	8a 45 ea             	mov    -0x16(%ebp),%al
  800182:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800184:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80018b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80018e:	e8 9f 24 00 00       	call   802632 <sys_calculate_free_frames>
  800193:	29 c3                	sub    %eax,%ebx
  800195:	89 d8                	mov    %ebx,%eax
  800197:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80019a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80019d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001a0:	7d 1a                	jge    8001bc <_main+0x184>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 c0             	pushl  -0x40(%ebp)
  8001a8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8001ab:	68 3c 3b 80 00       	push   $0x803b3c
  8001b0:	6a 51                	push   $0x51
  8001b2:	68 7c 3a 80 00       	push   $0x803a7c
  8001b7:	e8 db 0d 00 00       	call   800f97 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  8001bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001bf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ca:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8001d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001e3:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001e9:	6a 02                	push   $0x2
  8001eb:	6a 00                	push   $0x0
  8001ed:	6a 02                	push   $0x2
  8001ef:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
  8001f5:	50                   	push   %eax
  8001f6:	e8 54 29 00 00       	call   802b4f <sys_check_WS_list>
  8001fb:	83 c4 10             	add    $0x10,%esp
  8001fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800201:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 b8 3b 80 00       	push   $0x803bb8
  80020f:	6a 55                	push   $0x55
  800211:	68 7c 3a 80 00       	push   $0x803a7c
  800216:	e8 7c 0d 00 00       	call   800f97 <_panic>
		}
		//cprintf("4\n");

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80021b:	e8 12 24 00 00       	call   802632 <sys_calculate_free_frames>
  800220:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800223:	e8 55 24 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800228:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  80022b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022e:	01 c0                	add    %eax,%eax
  800230:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	50                   	push   %eax
  800237:	e8 06 20 00 00       	call   802242 <malloc>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800245:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800250:	01 c0                	add    %eax,%eax
  800252:	89 c1                	mov    %eax,%ecx
  800254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800257:	01 c8                	add    %ecx,%eax
  800259:	39 c2                	cmp    %eax,%edx
  80025b:	74 14                	je     800271 <_main+0x239>
  80025d:	83 ec 04             	sub    $0x4,%esp
  800260:	68 90 3a 80 00       	push   $0x803a90
  800265:	6a 5e                	push   $0x5e
  800267:	68 7c 3a 80 00       	push   $0x803a7c
  80026c:	e8 26 0d 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 512) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800271:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800274:	e8 b9 23 00 00       	call   802632 <sys_calculate_free_frames>
  800279:	29 c3                	sub    %eax,%ebx
  80027b:	89 d8                	mov    %ebx,%eax
  80027d:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  800282:	76 14                	jbe    800298 <_main+0x260>
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 c0 3a 80 00       	push   $0x803ac0
  80028c:	6a 5f                	push   $0x5f
  80028e:	68 7c 3a 80 00       	push   $0x803a7c
  800293:	e8 ff 0c 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800298:	e8 e0 23 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  80029d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8002a0:	74 14                	je     8002b6 <_main+0x27e>
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	68 0c 3b 80 00       	push   $0x803b0c
  8002aa:	6a 60                	push   $0x60
  8002ac:	68 7c 3a 80 00       	push   $0x803a7c
  8002b1:	e8 e1 0c 00 00       	call   800f97 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8002b6:	e8 77 23 00 00       	call   802632 <sys_calculate_free_frames>
  8002bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr = (short *) ptr_allocations[1];
  8002be:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8002c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cf:	d1 e8                	shr    %eax
  8002d1:	48                   	dec    %eax
  8002d2:	89 45 ac             	mov    %eax,-0x54(%ebp)
			shortArr[0] = minShort;
  8002d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8002de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002e1:	01 c0                	add    %eax,%eax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002e8:	01 c2                	add    %eax,%edx
  8002ea:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8002ee:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/;
  8002f1:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8002f8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002fb:	e8 32 23 00 00       	call   802632 <sys_calculate_free_frames>
  800300:	29 c3                	sub    %eax,%ebx
  800302:	89 d8                	mov    %ebx,%eax
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800307:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80030a:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80030d:	7d 1a                	jge    800329 <_main+0x2f1>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	ff 75 c0             	pushl  -0x40(%ebp)
  800315:	ff 75 c4             	pushl  -0x3c(%ebp)
  800318:	68 3c 3b 80 00       	push   $0x803b3c
  80031d:	6a 6a                	push   $0x6a
  80031f:	68 7c 3a 80 00       	push   $0x803a7c
  800324:	e8 6e 0c 00 00       	call   800f97 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800329:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80032c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80032f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  80033d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800340:	01 c0                	add    %eax,%eax
  800342:	89 c2                	mov    %eax,%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80034c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80034f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800354:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80035a:	6a 02                	push   $0x2
  80035c:	6a 00                	push   $0x0
  80035e:	6a 02                	push   $0x2
  800360:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	e8 e3 27 00 00       	call   802b4f <sys_check_WS_list>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800372:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800376:	74 14                	je     80038c <_main+0x354>
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	68 b8 3b 80 00       	push   $0x803bb8
  800380:	6a 6d                	push   $0x6d
  800382:	68 7c 3a 80 00       	push   $0x803a7c
  800387:	e8 0b 0c 00 00       	call   800f97 <_panic>
		}
		//cprintf("5\n");

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80038c:	e8 ec 22 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800391:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  800394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	01 d2                	add    %edx,%edx
  80039b:	01 d0                	add    %edx,%eax
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	50                   	push   %eax
  8003a1:	e8 9c 1e 00 00       	call   802242 <malloc>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8003af:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ba:	c1 e0 02             	shl    $0x2,%eax
  8003bd:	89 c1                	mov    %eax,%ecx
  8003bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	74 14                	je     8003dc <_main+0x3a4>
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	68 90 3a 80 00       	push   $0x803a90
  8003d0:	6a 75                	push   $0x75
  8003d2:	68 7c 3a 80 00       	push   $0x803a7c
  8003d7:	e8 bb 0b 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003dc:	e8 9c 22 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8003e1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8003e4:	74 14                	je     8003fa <_main+0x3c2>
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 0c 3b 80 00       	push   $0x803b0c
  8003ee:	6a 76                	push   $0x76
  8003f0:	68 7c 3a 80 00       	push   $0x803a7c
  8003f5:	e8 9d 0b 00 00       	call   800f97 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8003fa:	e8 33 22 00 00       	call   802632 <sys_calculate_free_frames>
  8003ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			intArr = (int *) ptr_allocations[2];
  800402:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800408:	89 45 a0             	mov    %eax,-0x60(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80040b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040e:	01 c0                	add    %eax,%eax
  800410:	c1 e8 02             	shr    $0x2,%eax
  800413:	48                   	dec    %eax
  800414:	89 45 9c             	mov    %eax,-0x64(%ebp)
			intArr[0] = minInt;
  800417:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80041a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80041f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80042c:	01 c2                	add    %eax,%edx
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800433:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80043a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80043d:	e8 f0 21 00 00       	call   802632 <sys_calculate_free_frames>
  800442:	29 c3                	sub    %eax,%ebx
  800444:	89 d8                	mov    %ebx,%eax
  800446:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800449:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80044c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80044f:	7d 1d                	jge    80046e <_main+0x436>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	ff 75 c0             	pushl  -0x40(%ebp)
  800457:	ff 75 c4             	pushl  -0x3c(%ebp)
  80045a:	68 3c 3b 80 00       	push   $0x803b3c
  80045f:	68 80 00 00 00       	push   $0x80
  800464:	68 7c 3a 80 00       	push   $0x803a7c
  800469:	e8 29 0b 00 00       	call   800f97 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80046e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800471:	89 45 98             	mov    %eax,-0x68(%ebp)
  800474:	8b 45 98             	mov    -0x68(%ebp),%eax
  800477:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80047c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800482:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800494:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800497:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049c:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8004a2:	6a 02                	push   $0x2
  8004a4:	6a 00                	push   $0x0
  8004a6:	6a 02                	push   $0x2
  8004a8:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  8004ae:	50                   	push   %eax
  8004af:	e8 9b 26 00 00       	call   802b4f <sys_check_WS_list>
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  8004ba:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8004be:	74 17                	je     8004d7 <_main+0x49f>
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	68 b8 3b 80 00       	push   $0x803bb8
  8004c8:	68 83 00 00 00       	push   $0x83
  8004cd:	68 7c 3a 80 00       	push   $0x803a7c
  8004d2:	e8 c0 0a 00 00       	call   800f97 <_panic>
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d7:	e8 a1 21 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  8004df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	50                   	push   %eax
  8004ec:	e8 51 1d 00 00       	call   802242 <malloc>
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  8004fa:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800500:	89 c2                	mov    %eax,%edx
  800502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800505:	c1 e0 02             	shl    $0x2,%eax
  800508:	89 c1                	mov    %eax,%ecx
  80050a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80050d:	c1 e0 02             	shl    $0x2,%eax
  800510:	01 c1                	add    %eax,%ecx
  800512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800515:	01 c8                	add    %ecx,%eax
  800517:	39 c2                	cmp    %eax,%edx
  800519:	74 17                	je     800532 <_main+0x4fa>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 90 3a 80 00       	push   $0x803a90
  800523:	68 8a 00 00 00       	push   $0x8a
  800528:	68 7c 3a 80 00       	push   $0x803a7c
  80052d:	e8 65 0a 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800532:	e8 46 21 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800537:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80053a:	74 17                	je     800553 <_main+0x51b>
  80053c:	83 ec 04             	sub    $0x4,%esp
  80053f:	68 0c 3b 80 00       	push   $0x803b0c
  800544:	68 8b 00 00 00       	push   $0x8b
  800549:	68 7c 3a 80 00       	push   $0x803a7c
  80054e:	e8 44 0a 00 00       	call   800f97 <_panic>
		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800553:	e8 da 20 00 00       	call   802632 <sys_calculate_free_frames>
  800558:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80055b:	e8 1d 21 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800560:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  800563:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800566:	89 d0                	mov    %edx,%eax
  800568:	01 c0                	add    %eax,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	83 ec 0c             	sub    $0xc,%esp
  800573:	50                   	push   %eax
  800574:	e8 c9 1c 00 00       	call   802242 <malloc>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800582:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800588:	89 c2                	mov    %eax,%edx
  80058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058d:	c1 e0 02             	shl    $0x2,%eax
  800590:	89 c1                	mov    %eax,%ecx
  800592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800595:	c1 e0 03             	shl    $0x3,%eax
  800598:	01 c1                	add    %eax,%ecx
  80059a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	39 c2                	cmp    %eax,%edx
  8005a1:	74 17                	je     8005ba <_main+0x582>
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	68 90 3a 80 00       	push   $0x803a90
  8005ab:	68 93 00 00 00       	push   $0x93
  8005b0:	68 7c 3a 80 00       	push   $0x803a7c
  8005b5:	e8 dd 09 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 2) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  8005ba:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005bd:	e8 70 20 00 00       	call   802632 <sys_calculate_free_frames>
  8005c2:	29 c3                	sub    %eax,%ebx
  8005c4:	89 d8                	mov    %ebx,%eax
  8005c6:	83 f8 01             	cmp    $0x1,%eax
  8005c9:	76 17                	jbe    8005e2 <_main+0x5aa>
  8005cb:	83 ec 04             	sub    $0x4,%esp
  8005ce:	68 c0 3a 80 00       	push   $0x803ac0
  8005d3:	68 94 00 00 00       	push   $0x94
  8005d8:	68 7c 3a 80 00       	push   $0x803a7c
  8005dd:	e8 b5 09 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8005e2:	e8 96 20 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8005e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 0c 3b 80 00       	push   $0x803b0c
  8005f4:	68 95 00 00 00       	push   $0x95
  8005f9:	68 7c 3a 80 00       	push   $0x803a7c
  8005fe:	e8 94 09 00 00       	call   800f97 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800603:	e8 2a 20 00 00       	call   802632 <sys_calculate_free_frames>
  800608:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80060b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800611:	89 45 90             	mov    %eax,-0x70(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800614:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800617:	89 d0                	mov    %edx,%eax
  800619:	01 c0                	add    %eax,%eax
  80061b:	01 d0                	add    %edx,%eax
  80061d:	01 c0                	add    %eax,%eax
  80061f:	01 d0                	add    %edx,%eax
  800621:	c1 e8 03             	shr    $0x3,%eax
  800624:	48                   	dec    %eax
  800625:	89 45 8c             	mov    %eax,-0x74(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800628:	8b 45 90             	mov    -0x70(%ebp),%eax
  80062b:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80062e:	88 10                	mov    %dl,(%eax)
  800630:	8b 55 90             	mov    -0x70(%ebp),%edx
  800633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800636:	66 89 42 02          	mov    %ax,0x2(%edx)
  80063a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80063d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800640:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800643:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800646:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80064d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800650:	01 c2                	add    %eax,%edx
  800652:	8a 45 ea             	mov    -0x16(%ebp),%al
  800655:	88 02                	mov    %al,(%edx)
  800657:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80065a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800661:	8b 45 90             	mov    -0x70(%ebp),%eax
  800664:	01 c2                	add    %eax,%edx
  800666:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  80066a:	66 89 42 02          	mov    %ax,0x2(%edx)
  80066e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800678:	8b 45 90             	mov    -0x70(%ebp),%eax
  80067b:	01 c2                	add    %eax,%edx
  80067d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800680:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800683:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80068a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80068d:	e8 a0 1f 00 00       	call   802632 <sys_calculate_free_frames>
  800692:	29 c3                	sub    %eax,%ebx
  800694:	89 d8                	mov    %ebx,%eax
  800696:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800699:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80069c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80069f:	7d 1d                	jge    8006be <_main+0x686>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	ff 75 c0             	pushl  -0x40(%ebp)
  8006a7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8006aa:	68 3c 3b 80 00       	push   $0x803b3c
  8006af:	68 9f 00 00 00       	push   $0x9f
  8006b4:	68 7c 3a 80 00       	push   $0x803a7c
  8006b9:	e8 d9 08 00 00       	call   800f97 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8006be:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c1:	89 45 88             	mov    %eax,-0x78(%ebp)
  8006c4:	8b 45 88             	mov    -0x78(%ebp),%eax
  8006c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006cc:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8006d2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8006dc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006df:	01 d0                	add    %edx,%eax
  8006e1:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8006e4:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ec:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8006f2:	6a 02                	push   $0x2
  8006f4:	6a 00                	push   $0x0
  8006f6:	6a 02                	push   $0x2
  8006f8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	e8 4b 24 00 00       	call   802b4f <sys_check_WS_list>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  80070a:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 b8 3b 80 00       	push   $0x803bb8
  800718:	68 a2 00 00 00       	push   $0xa2
  80071d:	68 7c 3a 80 00       	push   $0x803a7c
  800722:	e8 70 08 00 00       	call   800f97 <_panic>
		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800727:	e8 06 1f 00 00       	call   802632 <sys_calculate_free_frames>
  80072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 49 1f 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800734:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073a:	89 c2                	mov    %eax,%edx
  80073c:	01 d2                	add    %edx,%edx
  80073e:	01 d0                	add    %edx,%eax
  800740:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	50                   	push   %eax
  800747:	e8 f6 1a 00 00       	call   802242 <malloc>
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800755:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80075b:	89 c2                	mov    %eax,%edx
  80075d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800760:	c1 e0 02             	shl    $0x2,%eax
  800763:	89 c1                	mov    %eax,%ecx
  800765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800768:	c1 e0 04             	shl    $0x4,%eax
  80076b:	01 c1                	add    %eax,%ecx
  80076d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800770:	01 c8                	add    %ecx,%eax
  800772:	39 c2                	cmp    %eax,%edx
  800774:	74 17                	je     80078d <_main+0x755>
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	68 90 3a 80 00       	push   $0x803a90
  80077e:	68 aa 00 00 00       	push   $0xaa
  800783:	68 7c 3a 80 00       	push   $0x803a7c
  800788:	e8 0a 08 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 3*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  80078d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800790:	e8 9d 1e 00 00       	call   802632 <sys_calculate_free_frames>
  800795:	89 d9                	mov    %ebx,%ecx
  800797:	29 c1                	sub    %eax,%ecx
  800799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079c:	89 c2                	mov    %eax,%edx
  80079e:	01 d2                	add    %edx,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	79 05                	jns    8007ab <_main+0x773>
  8007a6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007ab:	c1 f8 0c             	sar    $0xc,%eax
  8007ae:	39 c1                	cmp    %eax,%ecx
  8007b0:	72 17                	jb     8007c9 <_main+0x791>
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	68 c0 3a 80 00       	push   $0x803ac0
  8007ba:	68 ab 00 00 00       	push   $0xab
  8007bf:	68 7c 3a 80 00       	push   $0x803a7c
  8007c4:	e8 ce 07 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8007c9:	e8 af 1e 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8007ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007d1:	74 17                	je     8007ea <_main+0x7b2>
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	68 0c 3b 80 00       	push   $0x803b0c
  8007db:	68 ac 00 00 00       	push   $0xac
  8007e0:	68 7c 3a 80 00       	push   $0x803a7c
  8007e5:	e8 ad 07 00 00       	call   800f97 <_panic>
		}

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8007ea:	e8 43 1e 00 00       	call   802632 <sys_calculate_free_frames>
  8007ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007f2:	e8 86 1e 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  8007f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8007fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	01 c0                	add    %eax,%eax
  800805:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800808:	83 ec 0c             	sub    $0xc,%esp
  80080b:	50                   	push   %eax
  80080c:	e8 31 1a 00 00       	call   802242 <malloc>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80081a:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800820:	89 c1                	mov    %eax,%ecx
  800822:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800825:	89 d0                	mov    %edx,%eax
  800827:	01 c0                	add    %eax,%eax
  800829:	01 d0                	add    %edx,%eax
  80082b:	01 c0                	add    %eax,%eax
  80082d:	01 d0                	add    %edx,%eax
  80082f:	89 c2                	mov    %eax,%edx
  800831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800834:	c1 e0 04             	shl    $0x4,%eax
  800837:	01 c2                	add    %eax,%edx
  800839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80083c:	01 d0                	add    %edx,%eax
  80083e:	39 c1                	cmp    %eax,%ecx
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 90 3a 80 00       	push   $0x803a90
  80084a:	68 b4 00 00 00       	push   $0xb4
  80084f:	68 7c 3a 80 00       	push   $0x803a7c
  800854:	e8 3e 07 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 6*Mega/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800859:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80085c:	e8 d1 1d 00 00       	call   802632 <sys_calculate_free_frames>
  800861:	89 d9                	mov    %ebx,%ecx
  800863:	29 c1                	sub    %eax,%ecx
  800865:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800868:	89 d0                	mov    %edx,%eax
  80086a:	01 c0                	add    %eax,%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	01 c0                	add    %eax,%eax
  800870:	85 c0                	test   %eax,%eax
  800872:	79 05                	jns    800879 <_main+0x841>
  800874:	05 ff 0f 00 00       	add    $0xfff,%eax
  800879:	c1 f8 0c             	sar    $0xc,%eax
  80087c:	39 c1                	cmp    %eax,%ecx
  80087e:	72 17                	jb     800897 <_main+0x85f>
  800880:	83 ec 04             	sub    $0x4,%esp
  800883:	68 c0 3a 80 00       	push   $0x803ac0
  800888:	68 b5 00 00 00       	push   $0xb5
  80088d:	68 7c 3a 80 00       	push   $0x803a7c
  800892:	e8 00 07 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800897:	e8 e1 1d 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  80089c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80089f:	74 17                	je     8008b8 <_main+0x880>
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	68 0c 3b 80 00       	push   $0x803b0c
  8008a9:	68 b6 00 00 00       	push   $0xb6
  8008ae:	68 7c 3a 80 00       	push   $0x803a7c
  8008b3:	e8 df 06 00 00       	call   800f97 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8008b8:	e8 75 1d 00 00       	call   802632 <sys_calculate_free_frames>
  8008bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  8008c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008c3:	89 d0                	mov    %edx,%eax
  8008c5:	01 c0                	add    %eax,%eax
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	01 c0                	add    %eax,%eax
  8008cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8008ce:	48                   	dec    %eax
  8008cf:	89 45 80             	mov    %eax,-0x80(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  8008d2:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8008d8:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			byteArr2[0] = minByte ;
  8008de:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008e4:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8008e7:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8008e9:	8b 45 80             	mov    -0x80(%ebp),%eax
  8008ec:	89 c2                	mov    %eax,%edx
  8008ee:	c1 ea 1f             	shr    $0x1f,%edx
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	d1 f8                	sar    %eax
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008fd:	01 c2                	add    %eax,%edx
  8008ff:	8a 45 ea             	mov    -0x16(%ebp),%al
  800902:	88 c1                	mov    %al,%cl
  800904:	c0 e9 07             	shr    $0x7,%cl
  800907:	01 c8                	add    %ecx,%eax
  800909:	d0 f8                	sar    %al
  80090b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  80090d:	8b 55 80             	mov    -0x80(%ebp),%edx
  800910:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800916:	01 c2                	add    %eax,%edx
  800918:	8a 45 ea             	mov    -0x16(%ebp),%al
  80091b:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 /*+2 tables already created in malloc due to marking the allocated pages*/ ;
  80091d:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800924:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800927:	e8 06 1d 00 00       	call   802632 <sys_calculate_free_frames>
  80092c:	29 c3                	sub    %eax,%ebx
  80092e:	89 d8                	mov    %ebx,%eax
  800930:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800933:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800936:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800939:	7d 1d                	jge    800958 <_main+0x920>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80093b:	83 ec 0c             	sub    $0xc,%esp
  80093e:	ff 75 c0             	pushl  -0x40(%ebp)
  800941:	ff 75 c4             	pushl  -0x3c(%ebp)
  800944:	68 3c 3b 80 00       	push   $0x803b3c
  800949:	68 c1 00 00 00       	push   $0xc1
  80094e:	68 7c 3a 80 00       	push   $0x803a7c
  800953:	e8 3f 06 00 00       	call   800f97 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800958:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80095e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800964:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80096a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80096f:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  800975:	8b 45 80             	mov    -0x80(%ebp),%eax
  800978:	89 c2                	mov    %eax,%edx
  80097a:	c1 ea 1f             	shr    $0x1f,%edx
  80097d:	01 d0                	add    %edx,%eax
  80097f:	d1 f8                	sar    %eax
  800981:	89 c2                	mov    %eax,%edx
  800983:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800989:	01 d0                	add    %edx,%eax
  80098b:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800991:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800997:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80099c:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  8009a2:	8b 55 80             	mov    -0x80(%ebp),%edx
  8009a5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8009b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  8009c4:	6a 02                	push   $0x2
  8009c6:	6a 00                	push   $0x0
  8009c8:	6a 03                	push   $0x3
  8009ca:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  8009d0:	50                   	push   %eax
  8009d1:	e8 79 21 00 00       	call   802b4f <sys_check_WS_list>
  8009d6:	83 c4 10             	add    $0x10,%esp
  8009d9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  8009dc:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 b8 3b 80 00       	push   $0x803bb8
  8009ea:	68 c4 00 00 00       	push   $0xc4
  8009ef:	68 7c 3a 80 00       	push   $0x803a7c
  8009f4:	e8 9e 05 00 00       	call   800f97 <_panic>
		}

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009f9:	e8 34 1c 00 00       	call   802632 <sys_calculate_free_frames>
  8009fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a01:	e8 77 1c 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a0c:	89 d0                	mov    %edx,%eax
  800a0e:	01 c0                	add    %eax,%eax
  800a10:	01 d0                	add    %edx,%eax
  800a12:	01 c0                	add    %eax,%eax
  800a14:	01 d0                	add    %edx,%eax
  800a16:	01 c0                	add    %eax,%eax
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	50                   	push   %eax
  800a1c:	e8 21 18 00 00       	call   802242 <malloc>
  800a21:	83 c4 10             	add    $0x10,%esp
  800a24:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800a2a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a35:	89 d0                	mov    %edx,%eax
  800a37:	01 c0                	add    %eax,%eax
  800a39:	01 d0                	add    %edx,%eax
  800a3b:	c1 e0 02             	shl    $0x2,%eax
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	89 c2                	mov    %eax,%edx
  800a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a45:	c1 e0 04             	shl    $0x4,%eax
  800a48:	01 c2                	add    %eax,%edx
  800a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a4d:	01 d0                	add    %edx,%eax
  800a4f:	39 c1                	cmp    %eax,%ecx
  800a51:	74 17                	je     800a6a <_main+0xa32>
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	68 90 3a 80 00       	push   $0x803a90
  800a5b:	68 cc 00 00 00       	push   $0xcc
  800a60:	68 7c 3a 80 00       	push   $0x803a7c
  800a65:	e8 2d 05 00 00       	call   800f97 <_panic>
			if ((freeFrames - sys_calculate_free_frames()) >= 16*kilo/PAGE_SIZE) panic("Wrong allocation: pages are allocated in memory while it's not supposed to!");
  800a6a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a6d:	e8 c0 1b 00 00       	call   802632 <sys_calculate_free_frames>
  800a72:	29 c3                	sub    %eax,%ebx
  800a74:	89 da                	mov    %ebx,%edx
  800a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a79:	c1 e0 04             	shl    $0x4,%eax
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	79 05                	jns    800a85 <_main+0xa4d>
  800a80:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a85:	c1 f8 0c             	sar    $0xc,%eax
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	72 17                	jb     800aa3 <_main+0xa6b>
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	68 c0 3a 80 00       	push   $0x803ac0
  800a94:	68 cd 00 00 00       	push   $0xcd
  800a99:	68 7c 3a 80 00       	push   $0x803a7c
  800a9e:	e8 f4 04 00 00       	call   800f97 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800aa3:	e8 d5 1b 00 00       	call   80267d <sys_pf_calculate_allocated_pages>
  800aa8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800aab:	74 17                	je     800ac4 <_main+0xa8c>
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	68 0c 3b 80 00       	push   $0x803b0c
  800ab5:	68 ce 00 00 00       	push   $0xce
  800aba:	68 7c 3a 80 00       	push   $0x803a7c
  800abf:	e8 d3 04 00 00       	call   800f97 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800ac4:	e8 69 1b 00 00       	call   802632 <sys_calculate_free_frames>
  800ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800acc:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800ad2:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800ad8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800adb:	89 d0                	mov    %edx,%eax
  800add:	01 c0                	add    %eax,%eax
  800adf:	01 d0                	add    %edx,%eax
  800ae1:	01 c0                	add    %eax,%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	01 c0                	add    %eax,%eax
  800ae7:	d1 e8                	shr    %eax
  800ae9:	48                   	dec    %eax
  800aea:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
			shortArr2[0] = minShort;
  800af0:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af9:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800afc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	c1 ea 1f             	shr    $0x1f,%edx
  800b07:	01 d0                	add    %edx,%eax
  800b09:	d1 f8                	sar    %eax
  800b0b:	01 c0                	add    %eax,%eax
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b15:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800b18:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	66 c1 ea 0f          	shr    $0xf,%dx
  800b22:	01 d0                	add    %edx,%eax
  800b24:	66 d1 f8             	sar    %ax
  800b27:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800b2a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b30:	01 c0                	add    %eax,%eax
  800b32:	89 c2                	mov    %eax,%edx
  800b34:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b3a:	01 c2                	add    %eax,%edx
  800b3c:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800b40:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800b43:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b4a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800b4d:	e8 e0 1a 00 00       	call   802632 <sys_calculate_free_frames>
  800b52:	29 c3                	sub    %eax,%ebx
  800b54:	89 d8                	mov    %ebx,%eax
  800b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800b59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b5c:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b5f:	7d 1d                	jge    800b7e <_main+0xb46>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800b61:	83 ec 0c             	sub    $0xc,%esp
  800b64:	ff 75 c0             	pushl  -0x40(%ebp)
  800b67:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b6a:	68 3c 3b 80 00       	push   $0x803b3c
  800b6f:	68 d9 00 00 00       	push   $0xd9
  800b74:	68 7c 3a 80 00       	push   $0x803a7c
  800b79:	e8 19 04 00 00       	call   800f97 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800b7e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b84:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800b8a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b95:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  800b9b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ba1:	89 c2                	mov    %eax,%edx
  800ba3:	c1 ea 1f             	shr    $0x1f,%edx
  800ba6:	01 d0                	add    %edx,%eax
  800ba8:	d1 f8                	sar    %eax
  800baa:	01 c0                	add    %eax,%eax
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bb4:	01 d0                	add    %edx,%eax
  800bb6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800bbc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc7:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800bcd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800bd3:	01 c0                	add    %eax,%eax
  800bd5:	89 c2                	mov    %eax,%edx
  800bd7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
  800bdf:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800be5:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800beb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bf0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf6:	6a 02                	push   $0x2
  800bf8:	6a 00                	push   $0x0
  800bfa:	6a 03                	push   $0x3
  800bfc:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800c02:	50                   	push   %eax
  800c03:	e8 47 1f 00 00       	call   802b4f <sys_check_WS_list>
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (found != 1) panic("malloc: page is not added to WS");
  800c0e:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800c12:	74 17                	je     800c2b <_main+0xbf3>
  800c14:	83 ec 04             	sub    $0x4,%esp
  800c17:	68 b8 3b 80 00       	push   $0x803bb8
  800c1c:	68 dc 00 00 00       	push   $0xdc
  800c21:	68 7c 3a 80 00       	push   $0x803a7c
  800c26:	e8 6c 03 00 00       	call   800f97 <_panic>
		}
	}

	//Check that the values are successfully stored
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800c2b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800c33:	75 0f                	jne    800c44 <_main+0xc0c>
  800c35:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800c38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800c42:	74 17                	je     800c5b <_main+0xc23>
  800c44:	83 ec 04             	sub    $0x4,%esp
  800c47:	68 d8 3b 80 00       	push   $0x803bd8
  800c4c:	68 e2 00 00 00       	push   $0xe2
  800c51:	68 7c 3a 80 00       	push   $0x803a7c
  800c56:	e8 3c 03 00 00       	call   800f97 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800c5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c5e:	66 8b 00             	mov    (%eax),%ax
  800c61:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800c65:	75 15                	jne    800c7c <_main+0xc44>
  800c67:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800c6a:	01 c0                	add    %eax,%eax
  800c6c:	89 c2                	mov    %eax,%edx
  800c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c71:	01 d0                	add    %edx,%eax
  800c73:	66 8b 00             	mov    (%eax),%ax
  800c76:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800c7a:	74 17                	je     800c93 <_main+0xc5b>
  800c7c:	83 ec 04             	sub    $0x4,%esp
  800c7f:	68 d8 3b 80 00       	push   $0x803bd8
  800c84:	68 e3 00 00 00       	push   $0xe3
  800c89:	68 7c 3a 80 00       	push   $0x803a7c
  800c8e:	e8 04 03 00 00       	call   800f97 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  800c93:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c9b:	75 16                	jne    800cb3 <_main+0xc7b>
  800c9d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800ca0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ca7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800caa:	01 d0                	add    %edx,%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 d8 3b 80 00       	push   $0x803bd8
  800cbb:	68 e4 00 00 00       	push   $0xe4
  800cc0:	68 7c 3a 80 00       	push   $0x803a7c
  800cc5:	e8 cd 02 00 00       	call   800f97 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800cca:	8b 45 90             	mov    -0x70(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800cd2:	75 16                	jne    800cea <_main+0xcb2>
  800cd4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800cd7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800cde:	8b 45 90             	mov    -0x70(%ebp),%eax
  800ce1:	01 d0                	add    %edx,%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800ce8:	74 17                	je     800d01 <_main+0xcc9>
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	68 d8 3b 80 00       	push   $0x803bd8
  800cf2:	68 e6 00 00 00       	push   $0xe6
  800cf7:	68 7c 3a 80 00       	push   $0x803a7c
  800cfc:	e8 96 02 00 00       	call   800f97 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800d01:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d04:	66 8b 40 02          	mov    0x2(%eax),%ax
  800d08:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800d0c:	75 19                	jne    800d27 <_main+0xcef>
  800d0e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800d11:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800d18:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d1b:	01 d0                	add    %edx,%eax
  800d1d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800d21:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800d25:	74 17                	je     800d3e <_main+0xd06>
  800d27:	83 ec 04             	sub    $0x4,%esp
  800d2a:	68 d8 3b 80 00       	push   $0x803bd8
  800d2f:	68 e7 00 00 00       	push   $0xe7
  800d34:	68 7c 3a 80 00       	push   $0x803a7c
  800d39:	e8 59 02 00 00       	call   800f97 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800d3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d41:	8b 40 04             	mov    0x4(%eax),%eax
  800d44:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800d47:	75 17                	jne    800d60 <_main+0xd28>
  800d49:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800d4c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800d53:	8b 45 90             	mov    -0x70(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	8b 40 04             	mov    0x4(%eax),%eax
  800d5b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d5e:	74 17                	je     800d77 <_main+0xd3f>
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	68 d8 3b 80 00       	push   $0x803bd8
  800d68:	68 e8 00 00 00       	push   $0xe8
  800d6d:	68 7c 3a 80 00       	push   $0x803a7c
  800d72:	e8 20 02 00 00       	call   800f97 <_panic>

		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800d77:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	3a 45 eb             	cmp    -0x15(%ebp),%al
  800d82:	75 3a                	jne    800dbe <_main+0xd86>
  800d84:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d87:	89 c2                	mov    %eax,%edx
  800d89:	c1 ea 1f             	shr    $0x1f,%edx
  800d8c:	01 d0                	add    %edx,%eax
  800d8e:	d1 f8                	sar    %eax
  800d90:	89 c2                	mov    %eax,%edx
  800d92:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d98:	01 d0                	add    %edx,%eax
  800d9a:	8a 10                	mov    (%eax),%dl
  800d9c:	8a 45 ea             	mov    -0x16(%ebp),%al
  800d9f:	88 c1                	mov    %al,%cl
  800da1:	c0 e9 07             	shr    $0x7,%cl
  800da4:	01 c8                	add    %ecx,%eax
  800da6:	d0 f8                	sar    %al
  800da8:	38 c2                	cmp    %al,%dl
  800daa:	75 12                	jne    800dbe <_main+0xd86>
  800dac:	8b 55 80             	mov    -0x80(%ebp),%edx
  800daf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800db5:	01 d0                	add    %edx,%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3a 45 ea             	cmp    -0x16(%ebp),%al
  800dbc:	74 17                	je     800dd5 <_main+0xd9d>
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	68 d8 3b 80 00       	push   $0x803bd8
  800dc6:	68 ea 00 00 00       	push   $0xea
  800dcb:	68 7c 3a 80 00       	push   $0x803a7c
  800dd0:	e8 c2 01 00 00       	call   800f97 <_panic>
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800dd5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800ddb:	66 8b 00             	mov    (%eax),%ax
  800dde:	66 3b 45 e8          	cmp    -0x18(%ebp),%ax
  800de2:	75 4d                	jne    800e31 <_main+0xdf9>
  800de4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800dea:	89 c2                	mov    %eax,%edx
  800dec:	c1 ea 1f             	shr    $0x1f,%edx
  800def:	01 d0                	add    %edx,%eax
  800df1:	d1 f8                	sar    %eax
  800df3:	01 c0                	add    %eax,%eax
  800df5:	89 c2                	mov    %eax,%edx
  800df7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800dfd:	01 d0                	add    %edx,%eax
  800dff:	66 8b 10             	mov    (%eax),%dx
  800e02:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800e06:	89 c1                	mov    %eax,%ecx
  800e08:	66 c1 e9 0f          	shr    $0xf,%cx
  800e0c:	01 c8                	add    %ecx,%eax
  800e0e:	66 d1 f8             	sar    %ax
  800e11:	66 39 c2             	cmp    %ax,%dx
  800e14:	75 1b                	jne    800e31 <_main+0xdf9>
  800e16:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800e1c:	01 c0                	add    %eax,%eax
  800e1e:	89 c2                	mov    %eax,%edx
  800e20:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800e26:	01 d0                	add    %edx,%eax
  800e28:	66 8b 00             	mov    (%eax),%ax
  800e2b:	66 3b 45 e6          	cmp    -0x1a(%ebp),%ax
  800e2f:	74 17                	je     800e48 <_main+0xe10>
  800e31:	83 ec 04             	sub    $0x4,%esp
  800e34:	68 d8 3b 80 00       	push   $0x803bd8
  800e39:	68 eb 00 00 00       	push   $0xeb
  800e3e:	68 7c 3a 80 00       	push   $0x803a7c
  800e43:	e8 4f 01 00 00       	call   800f97 <_panic>

	}
	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	68 10 3c 80 00       	push   $0x803c10
  800e50:	e8 ff 03 00 00       	call   801254 <cprintf>
  800e55:	83 c4 10             	add    $0x10,%esp

	return;
  800e58:	90                   	nop
}
  800e59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e66:	e8 52 1a 00 00       	call   8028bd <sys_getenvindex>
  800e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	89 d0                	mov    %edx,%eax
  800e73:	c1 e0 03             	shl    $0x3,%eax
  800e76:	01 d0                	add    %edx,%eax
  800e78:	01 c0                	add    %eax,%eax
  800e7a:	01 d0                	add    %edx,%eax
  800e7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e83:	01 d0                	add    %edx,%eax
  800e85:	c1 e0 04             	shl    $0x4,%eax
  800e88:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e8d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e92:	a1 20 50 80 00       	mov    0x805020,%eax
  800e97:	8a 40 5c             	mov    0x5c(%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	74 0d                	je     800eab <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800e9e:	a1 20 50 80 00       	mov    0x805020,%eax
  800ea3:	83 c0 5c             	add    $0x5c,%eax
  800ea6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800eab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eaf:	7e 0a                	jle    800ebb <libmain+0x5b>
		binaryname = argv[0];
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	8b 00                	mov    (%eax),%eax
  800eb6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	ff 75 08             	pushl  0x8(%ebp)
  800ec4:	e8 6f f1 ff ff       	call   800038 <_main>
  800ec9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ecc:	e8 f9 17 00 00       	call   8026ca <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	68 64 3c 80 00       	push   $0x803c64
  800ed9:	e8 76 03 00 00       	call   801254 <cprintf>
  800ede:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ee1:	a1 20 50 80 00       	mov    0x805020,%eax
  800ee6:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800eec:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef1:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	52                   	push   %edx
  800efb:	50                   	push   %eax
  800efc:	68 8c 3c 80 00       	push   $0x803c8c
  800f01:	e8 4e 03 00 00       	call   801254 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800f09:	a1 20 50 80 00       	mov    0x805020,%eax
  800f0e:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800f14:	a1 20 50 80 00       	mov    0x805020,%eax
  800f19:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800f1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f24:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800f2a:	51                   	push   %ecx
  800f2b:	52                   	push   %edx
  800f2c:	50                   	push   %eax
  800f2d:	68 b4 3c 80 00       	push   $0x803cb4
  800f32:	e8 1d 03 00 00       	call   801254 <cprintf>
  800f37:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	50                   	push   %eax
  800f49:	68 0c 3d 80 00       	push   $0x803d0c
  800f4e:	e8 01 03 00 00       	call   801254 <cprintf>
  800f53:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	68 64 3c 80 00       	push   $0x803c64
  800f5e:	e8 f1 02 00 00       	call   801254 <cprintf>
  800f63:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f66:	e8 79 17 00 00       	call   8026e4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f6b:	e8 19 00 00 00       	call   800f89 <exit>
}
  800f70:	90                   	nop
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f79:	83 ec 0c             	sub    $0xc,%esp
  800f7c:	6a 00                	push   $0x0
  800f7e:	e8 06 19 00 00       	call   802889 <sys_destroy_env>
  800f83:	83 c4 10             	add    $0x10,%esp
}
  800f86:	90                   	nop
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <exit>:

void
exit(void)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f8f:	e8 5b 19 00 00       	call   8028ef <sys_exit_env>
}
  800f94:	90                   	nop
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f9d:	8d 45 10             	lea    0x10(%ebp),%eax
  800fa0:	83 c0 04             	add    $0x4,%eax
  800fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800fa6:	a1 2c 51 80 00       	mov    0x80512c,%eax
  800fab:	85 c0                	test   %eax,%eax
  800fad:	74 16                	je     800fc5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800faf:	a1 2c 51 80 00       	mov    0x80512c,%eax
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	50                   	push   %eax
  800fb8:	68 20 3d 80 00       	push   $0x803d20
  800fbd:	e8 92 02 00 00       	call   801254 <cprintf>
  800fc2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fc5:	a1 00 50 80 00       	mov    0x805000,%eax
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	ff 75 08             	pushl  0x8(%ebp)
  800fd0:	50                   	push   %eax
  800fd1:	68 25 3d 80 00       	push   $0x803d25
  800fd6:	e8 79 02 00 00       	call   801254 <cprintf>
  800fdb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	83 ec 08             	sub    $0x8,%esp
  800fe4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe7:	50                   	push   %eax
  800fe8:	e8 fc 01 00 00       	call   8011e9 <vcprintf>
  800fed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	6a 00                	push   $0x0
  800ff5:	68 41 3d 80 00       	push   $0x803d41
  800ffa:	e8 ea 01 00 00       	call   8011e9 <vcprintf>
  800fff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801002:	e8 82 ff ff ff       	call   800f89 <exit>

	// should not return here
	while (1) ;
  801007:	eb fe                	jmp    801007 <_panic+0x70>

00801009 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80100f:	a1 20 50 80 00       	mov    0x805020,%eax
  801014:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	39 c2                	cmp    %eax,%edx
  80101f:	74 14                	je     801035 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801021:	83 ec 04             	sub    $0x4,%esp
  801024:	68 44 3d 80 00       	push   $0x803d44
  801029:	6a 26                	push   $0x26
  80102b:	68 90 3d 80 00       	push   $0x803d90
  801030:	e8 62 ff ff ff       	call   800f97 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801035:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80103c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801043:	e9 c5 00 00 00       	jmp    80110d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	8b 00                	mov    (%eax),%eax
  801059:	85 c0                	test   %eax,%eax
  80105b:	75 08                	jne    801065 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80105d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801060:	e9 a5 00 00 00       	jmp    80110a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801065:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80106c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801073:	eb 69                	jmp    8010de <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801075:	a1 20 50 80 00       	mov    0x805020,%eax
  80107a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801080:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	01 c0                	add    %eax,%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	c1 e0 03             	shl    $0x3,%eax
  80108c:	01 c8                	add    %ecx,%eax
  80108e:	8a 40 04             	mov    0x4(%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	75 46                	jne    8010db <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801095:	a1 20 50 80 00       	mov    0x805020,%eax
  80109a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8010a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8010a3:	89 d0                	mov    %edx,%eax
  8010a5:	01 c0                	add    %eax,%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	c1 e0 03             	shl    $0x3,%eax
  8010ac:	01 c8                	add    %ecx,%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	01 c8                	add    %ecx,%eax
  8010cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010ce:	39 c2                	cmp    %eax,%edx
  8010d0:	75 09                	jne    8010db <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8010d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010d9:	eb 15                	jmp    8010f0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010db:	ff 45 e8             	incl   -0x18(%ebp)
  8010de:	a1 20 50 80 00       	mov    0x805020,%eax
  8010e3:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8010e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010ec:	39 c2                	cmp    %eax,%edx
  8010ee:	77 85                	ja     801075 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f4:	75 14                	jne    80110a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8010f6:	83 ec 04             	sub    $0x4,%esp
  8010f9:	68 9c 3d 80 00       	push   $0x803d9c
  8010fe:	6a 3a                	push   $0x3a
  801100:	68 90 3d 80 00       	push   $0x803d90
  801105:	e8 8d fe ff ff       	call   800f97 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80110a:	ff 45 f0             	incl   -0x10(%ebp)
  80110d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801110:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801113:	0f 8c 2f ff ff ff    	jl     801048 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801119:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801120:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801127:	eb 26                	jmp    80114f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801129:	a1 20 50 80 00       	mov    0x805020,%eax
  80112e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801134:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801137:	89 d0                	mov    %edx,%eax
  801139:	01 c0                	add    %eax,%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	c1 e0 03             	shl    $0x3,%eax
  801140:	01 c8                	add    %ecx,%eax
  801142:	8a 40 04             	mov    0x4(%eax),%al
  801145:	3c 01                	cmp    $0x1,%al
  801147:	75 03                	jne    80114c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801149:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80114c:	ff 45 e0             	incl   -0x20(%ebp)
  80114f:	a1 20 50 80 00       	mov    0x805020,%eax
  801154:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80115a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115d:	39 c2                	cmp    %eax,%edx
  80115f:	77 c8                	ja     801129 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801164:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801167:	74 14                	je     80117d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801169:	83 ec 04             	sub    $0x4,%esp
  80116c:	68 f0 3d 80 00       	push   $0x803df0
  801171:	6a 44                	push   $0x44
  801173:	68 90 3d 80 00       	push   $0x803d90
  801178:	e8 1a fe ff ff       	call   800f97 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80117d:	90                   	nop
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	8b 00                	mov    (%eax),%eax
  80118b:	8d 48 01             	lea    0x1(%eax),%ecx
  80118e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801191:	89 0a                	mov    %ecx,(%edx)
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	88 d1                	mov    %dl,%cl
  801198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 00                	mov    (%eax),%eax
  8011a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a9:	75 2c                	jne    8011d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8011ab:	a0 24 50 80 00       	mov    0x805024,%al
  8011b0:	0f b6 c0             	movzbl %al,%eax
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	8b 12                	mov    (%edx),%edx
  8011b8:	89 d1                	mov    %edx,%ecx
  8011ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bd:	83 c2 08             	add    $0x8,%edx
  8011c0:	83 ec 04             	sub    $0x4,%esp
  8011c3:	50                   	push   %eax
  8011c4:	51                   	push   %ecx
  8011c5:	52                   	push   %edx
  8011c6:	e8 a6 13 00 00       	call   802571 <sys_cputs>
  8011cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	8b 40 04             	mov    0x4(%eax),%eax
  8011dd:	8d 50 01             	lea    0x1(%eax),%edx
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011f9:	00 00 00 
	b.cnt = 0;
  8011fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801203:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	ff 75 08             	pushl  0x8(%ebp)
  80120c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	68 80 11 80 00       	push   $0x801180
  801218:	e8 11 02 00 00       	call   80142e <vprintfmt>
  80121d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801220:	a0 24 50 80 00       	mov    0x805024,%al
  801225:	0f b6 c0             	movzbl %al,%eax
  801228:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80122e:	83 ec 04             	sub    $0x4,%esp
  801231:	50                   	push   %eax
  801232:	52                   	push   %edx
  801233:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801239:	83 c0 08             	add    $0x8,%eax
  80123c:	50                   	push   %eax
  80123d:	e8 2f 13 00 00       	call   802571 <sys_cputs>
  801242:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801245:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80124c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <cprintf>:

int cprintf(const char *fmt, ...) {
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80125a:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801261:	8d 45 0c             	lea    0xc(%ebp),%eax
  801264:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	ff 75 f4             	pushl  -0xc(%ebp)
  801270:	50                   	push   %eax
  801271:	e8 73 ff ff ff       	call   8011e9 <vcprintf>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801287:	e8 3e 14 00 00       	call   8026ca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80128c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	83 ec 08             	sub    $0x8,%esp
  801298:	ff 75 f4             	pushl  -0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	e8 48 ff ff ff       	call   8011e9 <vcprintf>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8012a7:	e8 38 14 00 00       	call   8026e4 <sys_enable_interrupt>
	return cnt;
  8012ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 14             	sub    $0x14,%esp
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012be:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8012c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012cf:	77 55                	ja     801326 <printnum+0x75>
  8012d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012d4:	72 05                	jb     8012db <printnum+0x2a>
  8012d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d9:	77 4b                	ja     801326 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8012e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e9:	52                   	push   %edx
  8012ea:	50                   	push   %eax
  8012eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f1:	e8 ea 24 00 00       	call   8037e0 <__udivdi3>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	ff 75 20             	pushl  0x20(%ebp)
  8012ff:	53                   	push   %ebx
  801300:	ff 75 18             	pushl  0x18(%ebp)
  801303:	52                   	push   %edx
  801304:	50                   	push   %eax
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	e8 a1 ff ff ff       	call   8012b1 <printnum>
  801310:	83 c4 20             	add    $0x20,%esp
  801313:	eb 1a                	jmp    80132f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	ff 75 20             	pushl  0x20(%ebp)
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	ff d0                	call   *%eax
  801323:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801326:	ff 4d 1c             	decl   0x1c(%ebp)
  801329:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80132d:	7f e6                	jg     801315 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80132f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801332:	bb 00 00 00 00       	mov    $0x0,%ebx
  801337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133d:	53                   	push   %ebx
  80133e:	51                   	push   %ecx
  80133f:	52                   	push   %edx
  801340:	50                   	push   %eax
  801341:	e8 aa 25 00 00       	call   8038f0 <__umoddi3>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	05 54 40 80 00       	add    $0x804054,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	0f be c0             	movsbl %al,%eax
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	ff 75 0c             	pushl  0xc(%ebp)
  801359:	50                   	push   %eax
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	ff d0                	call   *%eax
  80135f:	83 c4 10             	add    $0x10,%esp
}
  801362:	90                   	nop
  801363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80136b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80136f:	7e 1c                	jle    80138d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8b 00                	mov    (%eax),%eax
  801376:	8d 50 08             	lea    0x8(%eax),%edx
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	89 10                	mov    %edx,(%eax)
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8b 00                	mov    (%eax),%eax
  801383:	83 e8 08             	sub    $0x8,%eax
  801386:	8b 50 04             	mov    0x4(%eax),%edx
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	eb 40                	jmp    8013cd <getuint+0x65>
	else if (lflag)
  80138d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801391:	74 1e                	je     8013b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8b 00                	mov    (%eax),%eax
  801398:	8d 50 04             	lea    0x4(%eax),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 10                	mov    %edx,(%eax)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	83 e8 04             	sub    $0x4,%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013af:	eb 1c                	jmp    8013cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	8d 50 04             	lea    0x4(%eax),%edx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	89 10                	mov    %edx,(%eax)
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8b 00                	mov    (%eax),%eax
  8013c3:	83 e8 04             	sub    $0x4,%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013d6:	7e 1c                	jle    8013f4 <getint+0x25>
		return va_arg(*ap, long long);
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	8d 50 08             	lea    0x8(%eax),%edx
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 10                	mov    %edx,(%eax)
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8b 00                	mov    (%eax),%eax
  8013ea:	83 e8 08             	sub    $0x8,%eax
  8013ed:	8b 50 04             	mov    0x4(%eax),%edx
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	eb 38                	jmp    80142c <getint+0x5d>
	else if (lflag)
  8013f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013f8:	74 1a                	je     801414 <getint+0x45>
		return va_arg(*ap, long);
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	8d 50 04             	lea    0x4(%eax),%edx
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 10                	mov    %edx,(%eax)
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	83 e8 04             	sub    $0x4,%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	99                   	cltd   
  801412:	eb 18                	jmp    80142c <getint+0x5d>
	else
		return va_arg(*ap, int);
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 50 04             	lea    0x4(%eax),%edx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	89 10                	mov    %edx,(%eax)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8b 00                	mov    (%eax),%eax
  801426:	83 e8 04             	sub    $0x4,%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	99                   	cltd   
}
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	56                   	push   %esi
  801432:	53                   	push   %ebx
  801433:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801436:	eb 17                	jmp    80144f <vprintfmt+0x21>
			if (ch == '\0')
  801438:	85 db                	test   %ebx,%ebx
  80143a:	0f 84 af 03 00 00    	je     8017ef <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801440:	83 ec 08             	sub    $0x8,%esp
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	53                   	push   %ebx
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	ff d0                	call   *%eax
  80144c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80144f:	8b 45 10             	mov    0x10(%ebp),%eax
  801452:	8d 50 01             	lea    0x1(%eax),%edx
  801455:	89 55 10             	mov    %edx,0x10(%ebp)
  801458:	8a 00                	mov    (%eax),%al
  80145a:	0f b6 d8             	movzbl %al,%ebx
  80145d:	83 fb 25             	cmp    $0x25,%ebx
  801460:	75 d6                	jne    801438 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801462:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801466:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80146d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801474:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80147b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	8d 50 01             	lea    0x1(%eax),%edx
  801488:	89 55 10             	mov    %edx,0x10(%ebp)
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f b6 d8             	movzbl %al,%ebx
  801490:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801493:	83 f8 55             	cmp    $0x55,%eax
  801496:	0f 87 2b 03 00 00    	ja     8017c7 <vprintfmt+0x399>
  80149c:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
  8014a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8014a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8014a9:	eb d7                	jmp    801482 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8014af:	eb d1                	jmp    801482 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014bb:	89 d0                	mov    %edx,%eax
  8014bd:	c1 e0 02             	shl    $0x2,%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	01 c0                	add    %eax,%eax
  8014c4:	01 d8                	add    %ebx,%eax
  8014c6:	83 e8 30             	sub    $0x30,%eax
  8014c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8014d7:	7e 3e                	jle    801517 <vprintfmt+0xe9>
  8014d9:	83 fb 39             	cmp    $0x39,%ebx
  8014dc:	7f 39                	jg     801517 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014e1:	eb d5                	jmp    8014b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	83 c0 04             	add    $0x4,%eax
  8014e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8014ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ef:	83 e8 04             	sub    $0x4,%eax
  8014f2:	8b 00                	mov    (%eax),%eax
  8014f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014f7:	eb 1f                	jmp    801518 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fd:	79 83                	jns    801482 <vprintfmt+0x54>
				width = 0;
  8014ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801506:	e9 77 ff ff ff       	jmp    801482 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80150b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801512:	e9 6b ff ff ff       	jmp    801482 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801517:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801518:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80151c:	0f 89 60 ff ff ff    	jns    801482 <vprintfmt+0x54>
				width = precision, precision = -1;
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801528:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80152f:	e9 4e ff ff ff       	jmp    801482 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801534:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801537:	e9 46 ff ff ff       	jmp    801482 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80153c:	8b 45 14             	mov    0x14(%ebp),%eax
  80153f:	83 c0 04             	add    $0x4,%eax
  801542:	89 45 14             	mov    %eax,0x14(%ebp)
  801545:	8b 45 14             	mov    0x14(%ebp),%eax
  801548:	83 e8 04             	sub    $0x4,%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	50                   	push   %eax
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			break;
  80155c:	e9 89 02 00 00       	jmp    8017ea <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801561:	8b 45 14             	mov    0x14(%ebp),%eax
  801564:	83 c0 04             	add    $0x4,%eax
  801567:	89 45 14             	mov    %eax,0x14(%ebp)
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	83 e8 04             	sub    $0x4,%eax
  801570:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801572:	85 db                	test   %ebx,%ebx
  801574:	79 02                	jns    801578 <vprintfmt+0x14a>
				err = -err;
  801576:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801578:	83 fb 64             	cmp    $0x64,%ebx
  80157b:	7f 0b                	jg     801588 <vprintfmt+0x15a>
  80157d:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  801584:	85 f6                	test   %esi,%esi
  801586:	75 19                	jne    8015a1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801588:	53                   	push   %ebx
  801589:	68 65 40 80 00       	push   $0x804065
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	e8 5e 02 00 00       	call   8017f7 <printfmt>
  801599:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80159c:	e9 49 02 00 00       	jmp    8017ea <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8015a1:	56                   	push   %esi
  8015a2:	68 6e 40 80 00       	push   $0x80406e
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 45 02 00 00       	call   8017f7 <printfmt>
  8015b2:	83 c4 10             	add    $0x10,%esp
			break;
  8015b5:	e9 30 02 00 00       	jmp    8017ea <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	83 e8 04             	sub    $0x4,%eax
  8015c9:	8b 30                	mov    (%eax),%esi
  8015cb:	85 f6                	test   %esi,%esi
  8015cd:	75 05                	jne    8015d4 <vprintfmt+0x1a6>
				p = "(null)";
  8015cf:	be 71 40 80 00       	mov    $0x804071,%esi
			if (width > 0 && padc != '-')
  8015d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d8:	7e 6d                	jle    801647 <vprintfmt+0x219>
  8015da:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015de:	74 67                	je     801647 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e3:	83 ec 08             	sub    $0x8,%esp
  8015e6:	50                   	push   %eax
  8015e7:	56                   	push   %esi
  8015e8:	e8 0c 03 00 00       	call   8018f9 <strnlen>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015f3:	eb 16                	jmp    80160b <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015f5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	ff d0                	call   *%eax
  801605:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801608:	ff 4d e4             	decl   -0x1c(%ebp)
  80160b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80160f:	7f e4                	jg     8015f5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801611:	eb 34                	jmp    801647 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801613:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801617:	74 1c                	je     801635 <vprintfmt+0x207>
  801619:	83 fb 1f             	cmp    $0x1f,%ebx
  80161c:	7e 05                	jle    801623 <vprintfmt+0x1f5>
  80161e:	83 fb 7e             	cmp    $0x7e,%ebx
  801621:	7e 12                	jle    801635 <vprintfmt+0x207>
					putch('?', putdat);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	6a 3f                	push   $0x3f
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	ff d0                	call   *%eax
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	eb 0f                	jmp    801644 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	53                   	push   %ebx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	ff d0                	call   *%eax
  801641:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801644:	ff 4d e4             	decl   -0x1c(%ebp)
  801647:	89 f0                	mov    %esi,%eax
  801649:	8d 70 01             	lea    0x1(%eax),%esi
  80164c:	8a 00                	mov    (%eax),%al
  80164e:	0f be d8             	movsbl %al,%ebx
  801651:	85 db                	test   %ebx,%ebx
  801653:	74 24                	je     801679 <vprintfmt+0x24b>
  801655:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801659:	78 b8                	js     801613 <vprintfmt+0x1e5>
  80165b:	ff 4d e0             	decl   -0x20(%ebp)
  80165e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801662:	79 af                	jns    801613 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801664:	eb 13                	jmp    801679 <vprintfmt+0x24b>
				putch(' ', putdat);
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	6a 20                	push   $0x20
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	ff d0                	call   *%eax
  801673:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801676:	ff 4d e4             	decl   -0x1c(%ebp)
  801679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80167d:	7f e7                	jg     801666 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80167f:	e9 66 01 00 00       	jmp    8017ea <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	ff 75 e8             	pushl  -0x18(%ebp)
  80168a:	8d 45 14             	lea    0x14(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	e8 3c fd ff ff       	call   8013cf <getint>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801699:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a2:	85 d2                	test   %edx,%edx
  8016a4:	79 23                	jns    8016c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	6a 2d                	push   $0x2d
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	ff d0                	call   *%eax
  8016b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bc:	f7 d8                	neg    %eax
  8016be:	83 d2 00             	adc    $0x0,%edx
  8016c1:	f7 da                	neg    %edx
  8016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016d0:	e9 bc 00 00 00       	jmp    801791 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8016db:	8d 45 14             	lea    0x14(%ebp),%eax
  8016de:	50                   	push   %eax
  8016df:	e8 84 fc ff ff       	call   801368 <getuint>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016f4:	e9 98 00 00 00       	jmp    801791 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	6a 58                	push   $0x58
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	ff d0                	call   *%eax
  801706:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	6a 58                	push   $0x58
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	ff d0                	call   *%eax
  801716:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801719:	83 ec 08             	sub    $0x8,%esp
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	6a 58                	push   $0x58
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	ff d0                	call   *%eax
  801726:	83 c4 10             	add    $0x10,%esp
			break;
  801729:	e9 bc 00 00 00       	jmp    8017ea <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80172e:	83 ec 08             	sub    $0x8,%esp
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	6a 30                	push   $0x30
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	ff d0                	call   *%eax
  80173b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	6a 78                	push   $0x78
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	ff d0                	call   *%eax
  80174b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80174e:	8b 45 14             	mov    0x14(%ebp),%eax
  801751:	83 c0 04             	add    $0x4,%eax
  801754:	89 45 14             	mov    %eax,0x14(%ebp)
  801757:	8b 45 14             	mov    0x14(%ebp),%eax
  80175a:	83 e8 04             	sub    $0x4,%eax
  80175d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80175f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801769:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801770:	eb 1f                	jmp    801791 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	ff 75 e8             	pushl  -0x18(%ebp)
  801778:	8d 45 14             	lea    0x14(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	e8 e7 fb ff ff       	call   801368 <getuint>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801787:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80178a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801791:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	52                   	push   %edx
  80179c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80179f:	50                   	push   %eax
  8017a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	ff 75 08             	pushl  0x8(%ebp)
  8017ac:	e8 00 fb ff ff       	call   8012b1 <printnum>
  8017b1:	83 c4 20             	add    $0x20,%esp
			break;
  8017b4:	eb 34                	jmp    8017ea <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	53                   	push   %ebx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	ff d0                	call   *%eax
  8017c2:	83 c4 10             	add    $0x10,%esp
			break;
  8017c5:	eb 23                	jmp    8017ea <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	6a 25                	push   $0x25
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	ff d0                	call   *%eax
  8017d4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017d7:	ff 4d 10             	decl   0x10(%ebp)
  8017da:	eb 03                	jmp    8017df <vprintfmt+0x3b1>
  8017dc:	ff 4d 10             	decl   0x10(%ebp)
  8017df:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e2:	48                   	dec    %eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	3c 25                	cmp    $0x25,%al
  8017e7:	75 f3                	jne    8017dc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017e9:	90                   	nop
		}
	}
  8017ea:	e9 47 fc ff ff       	jmp    801436 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017ef:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f3:	5b                   	pop    %ebx
  8017f4:	5e                   	pop    %esi
  8017f5:	5d                   	pop    %ebp
  8017f6:	c3                   	ret    

008017f7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017fd:	8d 45 10             	lea    0x10(%ebp),%eax
  801800:	83 c0 04             	add    $0x4,%eax
  801803:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	ff 75 f4             	pushl  -0xc(%ebp)
  80180c:	50                   	push   %eax
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 16 fc ff ff       	call   80142e <vprintfmt>
  801818:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	8b 40 08             	mov    0x8(%eax),%eax
  801827:	8d 50 01             	lea    0x1(%eax),%edx
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	8b 10                	mov    (%eax),%edx
  801835:	8b 45 0c             	mov    0xc(%ebp),%eax
  801838:	8b 40 04             	mov    0x4(%eax),%eax
  80183b:	39 c2                	cmp    %eax,%edx
  80183d:	73 12                	jae    801851 <sprintputch+0x33>
		*b->buf++ = ch;
  80183f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801842:	8b 00                	mov    (%eax),%eax
  801844:	8d 48 01             	lea    0x1(%eax),%ecx
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	89 0a                	mov    %ecx,(%edx)
  80184c:	8b 55 08             	mov    0x8(%ebp),%edx
  80184f:	88 10                	mov    %dl,(%eax)
}
  801851:	90                   	nop
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	8d 50 ff             	lea    -0x1(%eax),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	01 d0                	add    %edx,%eax
  80186b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80186e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801879:	74 06                	je     801881 <vsnprintf+0x2d>
  80187b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80187f:	7f 07                	jg     801888 <vsnprintf+0x34>
		return -E_INVAL;
  801881:	b8 03 00 00 00       	mov    $0x3,%eax
  801886:	eb 20                	jmp    8018a8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801888:	ff 75 14             	pushl  0x14(%ebp)
  80188b:	ff 75 10             	pushl  0x10(%ebp)
  80188e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	68 1e 18 80 00       	push   $0x80181e
  801897:	e8 92 fb ff ff       	call   80142e <vprintfmt>
  80189c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80189f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8018b3:	83 c0 04             	add    $0x4,%eax
  8018b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	e8 89 ff ff ff       	call   801854 <vsnprintf>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018e3:	eb 06                	jmp    8018eb <strlen+0x15>
		n++;
  8018e5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e8:	ff 45 08             	incl   0x8(%ebp)
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	84 c0                	test   %al,%al
  8018f2:	75 f1                	jne    8018e5 <strlen+0xf>
		n++;
	return n;
  8018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801906:	eb 09                	jmp    801911 <strnlen+0x18>
		n++;
  801908:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80190b:	ff 45 08             	incl   0x8(%ebp)
  80190e:	ff 4d 0c             	decl   0xc(%ebp)
  801911:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801915:	74 09                	je     801920 <strnlen+0x27>
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	8a 00                	mov    (%eax),%al
  80191c:	84 c0                	test   %al,%al
  80191e:	75 e8                	jne    801908 <strnlen+0xf>
		n++;
	return n;
  801920:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801931:	90                   	nop
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8d 50 01             	lea    0x1(%eax),%edx
  801938:	89 55 08             	mov    %edx,0x8(%ebp)
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801941:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801944:	8a 12                	mov    (%edx),%dl
  801946:	88 10                	mov    %dl,(%eax)
  801948:	8a 00                	mov    (%eax),%al
  80194a:	84 c0                	test   %al,%al
  80194c:	75 e4                	jne    801932 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80195f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801966:	eb 1f                	jmp    801987 <strncpy+0x34>
		*dst++ = *src;
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8d 50 01             	lea    0x1(%eax),%edx
  80196e:	89 55 08             	mov    %edx,0x8(%ebp)
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8a 12                	mov    (%edx),%dl
  801976:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	8a 00                	mov    (%eax),%al
  80197d:	84 c0                	test   %al,%al
  80197f:	74 03                	je     801984 <strncpy+0x31>
			src++;
  801981:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801984:	ff 45 fc             	incl   -0x4(%ebp)
  801987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80198d:	72 d9                	jb     801968 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80198f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019a4:	74 30                	je     8019d6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019a6:	eb 16                	jmp    8019be <strlcpy+0x2a>
			*dst++ = *src++;
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8d 50 01             	lea    0x1(%eax),%edx
  8019ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019ba:	8a 12                	mov    (%edx),%dl
  8019bc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019be:	ff 4d 10             	decl   0x10(%ebp)
  8019c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019c5:	74 09                	je     8019d0 <strlcpy+0x3c>
  8019c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	84 c0                	test   %al,%al
  8019ce:	75 d8                	jne    8019a8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019e5:	eb 06                	jmp    8019ed <strcmp+0xb>
		p++, q++;
  8019e7:	ff 45 08             	incl   0x8(%ebp)
  8019ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	84 c0                	test   %al,%al
  8019f4:	74 0e                	je     801a04 <strcmp+0x22>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 10                	mov    (%eax),%dl
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	38 c2                	cmp    %al,%dl
  801a02:	74 e3                	je     8019e7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	0f b6 d0             	movzbl %al,%edx
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0f:	8a 00                	mov    (%eax),%al
  801a11:	0f b6 c0             	movzbl %al,%eax
  801a14:	29 c2                	sub    %eax,%edx
  801a16:	89 d0                	mov    %edx,%eax
}
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a1d:	eb 09                	jmp    801a28 <strncmp+0xe>
		n--, p++, q++;
  801a1f:	ff 4d 10             	decl   0x10(%ebp)
  801a22:	ff 45 08             	incl   0x8(%ebp)
  801a25:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a2c:	74 17                	je     801a45 <strncmp+0x2b>
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	84 c0                	test   %al,%al
  801a35:	74 0e                	je     801a45 <strncmp+0x2b>
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8a 10                	mov    (%eax),%dl
  801a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	38 c2                	cmp    %al,%dl
  801a43:	74 da                	je     801a1f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a49:	75 07                	jne    801a52 <strncmp+0x38>
		return 0;
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	eb 14                	jmp    801a66 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8a 00                	mov    (%eax),%al
  801a57:	0f b6 d0             	movzbl %al,%edx
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	8a 00                	mov    (%eax),%al
  801a5f:	0f b6 c0             	movzbl %al,%eax
  801a62:	29 c2                	sub    %eax,%edx
  801a64:	89 d0                	mov    %edx,%eax
}
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    

00801a68 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a74:	eb 12                	jmp    801a88 <strchr+0x20>
		if (*s == c)
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	8a 00                	mov    (%eax),%al
  801a7b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a7e:	75 05                	jne    801a85 <strchr+0x1d>
			return (char *) s;
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	eb 11                	jmp    801a96 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a85:	ff 45 08             	incl   0x8(%ebp)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8a 00                	mov    (%eax),%al
  801a8d:	84 c0                	test   %al,%al
  801a8f:	75 e5                	jne    801a76 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801aa4:	eb 0d                	jmp    801ab3 <strfind+0x1b>
		if (*s == c)
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	8a 00                	mov    (%eax),%al
  801aab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801aae:	74 0e                	je     801abe <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ab0:	ff 45 08             	incl   0x8(%ebp)
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	8a 00                	mov    (%eax),%al
  801ab8:	84 c0                	test   %al,%al
  801aba:	75 ea                	jne    801aa6 <strfind+0xe>
  801abc:	eb 01                	jmp    801abf <strfind+0x27>
		if (*s == c)
			break;
  801abe:	90                   	nop
	return (char *) s;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801ad6:	eb 0e                	jmp    801ae6 <memset+0x22>
		*p++ = c;
  801ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801adb:	8d 50 01             	lea    0x1(%eax),%edx
  801ade:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801ae6:	ff 4d f8             	decl   -0x8(%ebp)
  801ae9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801aed:	79 e9                	jns    801ad8 <memset+0x14>
		*p++ = c;

	return v;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b06:	eb 16                	jmp    801b1e <memcpy+0x2a>
		*d++ = *s++;
  801b08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0b:	8d 50 01             	lea    0x1(%eax),%edx
  801b0e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b14:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b17:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b1a:	8a 12                	mov    (%edx),%dl
  801b1c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b21:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b24:	89 55 10             	mov    %edx,0x10(%ebp)
  801b27:	85 c0                	test   %eax,%eax
  801b29:	75 dd                	jne    801b08 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b45:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b48:	73 50                	jae    801b9a <memmove+0x6a>
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 d0                	add    %edx,%eax
  801b52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b55:	76 43                	jbe    801b9a <memmove+0x6a>
		s += n;
  801b57:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b63:	eb 10                	jmp    801b75 <memmove+0x45>
			*--d = *--s;
  801b65:	ff 4d f8             	decl   -0x8(%ebp)
  801b68:	ff 4d fc             	decl   -0x4(%ebp)
  801b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6e:	8a 10                	mov    (%eax),%dl
  801b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b73:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b75:	8b 45 10             	mov    0x10(%ebp),%eax
  801b78:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b7b:	89 55 10             	mov    %edx,0x10(%ebp)
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	75 e3                	jne    801b65 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b82:	eb 23                	jmp    801ba7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b87:	8d 50 01             	lea    0x1(%eax),%edx
  801b8a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b93:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b96:	8a 12                	mov    (%edx),%dl
  801b98:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ba0:	89 55 10             	mov    %edx,0x10(%ebp)
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	75 dd                	jne    801b84 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bbe:	eb 2a                	jmp    801bea <memcmp+0x3e>
		if (*s1 != *s2)
  801bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc3:	8a 10                	mov    (%eax),%dl
  801bc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	38 c2                	cmp    %al,%dl
  801bcc:	74 16                	je     801be4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd1:	8a 00                	mov    (%eax),%al
  801bd3:	0f b6 d0             	movzbl %al,%edx
  801bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	0f b6 c0             	movzbl %al,%eax
  801bde:	29 c2                	sub    %eax,%edx
  801be0:	89 d0                	mov    %edx,%eax
  801be2:	eb 18                	jmp    801bfc <memcmp+0x50>
		s1++, s2++;
  801be4:	ff 45 fc             	incl   -0x4(%ebp)
  801be7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bf0:	89 55 10             	mov    %edx,0x10(%ebp)
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	75 c9                	jne    801bc0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c04:	8b 55 08             	mov    0x8(%ebp),%edx
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0a:	01 d0                	add    %edx,%eax
  801c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c0f:	eb 15                	jmp    801c26 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	8a 00                	mov    (%eax),%al
  801c16:	0f b6 d0             	movzbl %al,%edx
  801c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1c:	0f b6 c0             	movzbl %al,%eax
  801c1f:	39 c2                	cmp    %eax,%edx
  801c21:	74 0d                	je     801c30 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c23:	ff 45 08             	incl   0x8(%ebp)
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c2c:	72 e3                	jb     801c11 <memfind+0x13>
  801c2e:	eb 01                	jmp    801c31 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c30:	90                   	nop
	return (void *) s;
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c43:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4a:	eb 03                	jmp    801c4f <strtol+0x19>
		s++;
  801c4c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	3c 20                	cmp    $0x20,%al
  801c56:	74 f4                	je     801c4c <strtol+0x16>
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8a 00                	mov    (%eax),%al
  801c5d:	3c 09                	cmp    $0x9,%al
  801c5f:	74 eb                	je     801c4c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	3c 2b                	cmp    $0x2b,%al
  801c68:	75 05                	jne    801c6f <strtol+0x39>
		s++;
  801c6a:	ff 45 08             	incl   0x8(%ebp)
  801c6d:	eb 13                	jmp    801c82 <strtol+0x4c>
	else if (*s == '-')
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	8a 00                	mov    (%eax),%al
  801c74:	3c 2d                	cmp    $0x2d,%al
  801c76:	75 0a                	jne    801c82 <strtol+0x4c>
		s++, neg = 1;
  801c78:	ff 45 08             	incl   0x8(%ebp)
  801c7b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c86:	74 06                	je     801c8e <strtol+0x58>
  801c88:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c8c:	75 20                	jne    801cae <strtol+0x78>
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	8a 00                	mov    (%eax),%al
  801c93:	3c 30                	cmp    $0x30,%al
  801c95:	75 17                	jne    801cae <strtol+0x78>
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	40                   	inc    %eax
  801c9b:	8a 00                	mov    (%eax),%al
  801c9d:	3c 78                	cmp    $0x78,%al
  801c9f:	75 0d                	jne    801cae <strtol+0x78>
		s += 2, base = 16;
  801ca1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801ca5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801cac:	eb 28                	jmp    801cd6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801cae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cb2:	75 15                	jne    801cc9 <strtol+0x93>
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8a 00                	mov    (%eax),%al
  801cb9:	3c 30                	cmp    $0x30,%al
  801cbb:	75 0c                	jne    801cc9 <strtol+0x93>
		s++, base = 8;
  801cbd:	ff 45 08             	incl   0x8(%ebp)
  801cc0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cc7:	eb 0d                	jmp    801cd6 <strtol+0xa0>
	else if (base == 0)
  801cc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccd:	75 07                	jne    801cd6 <strtol+0xa0>
		base = 10;
  801ccf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	8a 00                	mov    (%eax),%al
  801cdb:	3c 2f                	cmp    $0x2f,%al
  801cdd:	7e 19                	jle    801cf8 <strtol+0xc2>
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	8a 00                	mov    (%eax),%al
  801ce4:	3c 39                	cmp    $0x39,%al
  801ce6:	7f 10                	jg     801cf8 <strtol+0xc2>
			dig = *s - '0';
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	8a 00                	mov    (%eax),%al
  801ced:	0f be c0             	movsbl %al,%eax
  801cf0:	83 e8 30             	sub    $0x30,%eax
  801cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf6:	eb 42                	jmp    801d3a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	8a 00                	mov    (%eax),%al
  801cfd:	3c 60                	cmp    $0x60,%al
  801cff:	7e 19                	jle    801d1a <strtol+0xe4>
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8a 00                	mov    (%eax),%al
  801d06:	3c 7a                	cmp    $0x7a,%al
  801d08:	7f 10                	jg     801d1a <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8a 00                	mov    (%eax),%al
  801d0f:	0f be c0             	movsbl %al,%eax
  801d12:	83 e8 57             	sub    $0x57,%eax
  801d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d18:	eb 20                	jmp    801d3a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	8a 00                	mov    (%eax),%al
  801d1f:	3c 40                	cmp    $0x40,%al
  801d21:	7e 39                	jle    801d5c <strtol+0x126>
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8a 00                	mov    (%eax),%al
  801d28:	3c 5a                	cmp    $0x5a,%al
  801d2a:	7f 30                	jg     801d5c <strtol+0x126>
			dig = *s - 'A' + 10;
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8a 00                	mov    (%eax),%al
  801d31:	0f be c0             	movsbl %al,%eax
  801d34:	83 e8 37             	sub    $0x37,%eax
  801d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d40:	7d 19                	jge    801d5b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d42:	ff 45 08             	incl   0x8(%ebp)
  801d45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d48:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	01 d0                	add    %edx,%eax
  801d53:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d56:	e9 7b ff ff ff       	jmp    801cd6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d5b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d60:	74 08                	je     801d6a <strtol+0x134>
		*endptr = (char *) s;
  801d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d65:	8b 55 08             	mov    0x8(%ebp),%edx
  801d68:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d6e:	74 07                	je     801d77 <strtol+0x141>
  801d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d73:	f7 d8                	neg    %eax
  801d75:	eb 03                	jmp    801d7a <strtol+0x144>
  801d77:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <ltostr>:

void
ltostr(long value, char *str)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d94:	79 13                	jns    801da9 <ltostr+0x2d>
	{
		neg = 1;
  801d96:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801da3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801da6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801db1:	99                   	cltd   
  801db2:	f7 f9                	idiv   %ecx
  801db4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dba:	8d 50 01             	lea    0x1(%eax),%edx
  801dbd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dc0:	89 c2                	mov    %eax,%edx
  801dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc5:	01 d0                	add    %edx,%eax
  801dc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dca:	83 c2 30             	add    $0x30,%edx
  801dcd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801dd7:	f7 e9                	imul   %ecx
  801dd9:	c1 fa 02             	sar    $0x2,%edx
  801ddc:	89 c8                	mov    %ecx,%eax
  801dde:	c1 f8 1f             	sar    $0x1f,%eax
  801de1:	29 c2                	sub    %eax,%edx
  801de3:	89 d0                	mov    %edx,%eax
  801de5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801de8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801deb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801df0:	f7 e9                	imul   %ecx
  801df2:	c1 fa 02             	sar    $0x2,%edx
  801df5:	89 c8                	mov    %ecx,%eax
  801df7:	c1 f8 1f             	sar    $0x1f,%eax
  801dfa:	29 c2                	sub    %eax,%edx
  801dfc:	89 d0                	mov    %edx,%eax
  801dfe:	c1 e0 02             	shl    $0x2,%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	01 c0                	add    %eax,%eax
  801e05:	29 c1                	sub    %eax,%ecx
  801e07:	89 ca                	mov    %ecx,%edx
  801e09:	85 d2                	test   %edx,%edx
  801e0b:	75 9c                	jne    801da9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801e14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e17:	48                   	dec    %eax
  801e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e1f:	74 3d                	je     801e5e <ltostr+0xe2>
		start = 1 ;
  801e21:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e28:	eb 34                	jmp    801e5e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e30:	01 d0                	add    %edx,%eax
  801e32:	8a 00                	mov    (%eax),%al
  801e34:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3d:	01 c2                	add    %eax,%edx
  801e3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	01 c8                	add    %ecx,%eax
  801e47:	8a 00                	mov    (%eax),%al
  801e49:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e51:	01 c2                	add    %eax,%edx
  801e53:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e56:	88 02                	mov    %al,(%edx)
		start++ ;
  801e58:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e5b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e64:	7c c4                	jl     801e2a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e66:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6c:	01 d0                	add    %edx,%eax
  801e6e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	e8 54 fa ff ff       	call   8018d6 <strlen>
  801e82:	83 c4 04             	add    $0x4,%esp
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	e8 46 fa ff ff       	call   8018d6 <strlen>
  801e90:	83 c4 04             	add    $0x4,%esp
  801e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ea4:	eb 17                	jmp    801ebd <strcconcat+0x49>
		final[s] = str1[s] ;
  801ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eac:	01 c2                	add    %eax,%edx
  801eae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	01 c8                	add    %ecx,%eax
  801eb6:	8a 00                	mov    (%eax),%al
  801eb8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801eba:	ff 45 fc             	incl   -0x4(%ebp)
  801ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ec3:	7c e1                	jl     801ea6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ec5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ecc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ed3:	eb 1f                	jmp    801ef4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed8:	8d 50 01             	lea    0x1(%eax),%edx
  801edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ede:	89 c2                	mov    %eax,%edx
  801ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee3:	01 c2                	add    %eax,%edx
  801ee5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eeb:	01 c8                	add    %ecx,%eax
  801eed:	8a 00                	mov    (%eax),%al
  801eef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
  801ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801efa:	7c d9                	jl     801ed5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801efc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eff:	8b 45 10             	mov    0x10(%ebp),%eax
  801f02:	01 d0                	add    %edx,%eax
  801f04:	c6 00 00             	movb   $0x0,(%eax)
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801f16:	8b 45 14             	mov    0x14(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f22:	8b 45 10             	mov    0x10(%ebp),%eax
  801f25:	01 d0                	add    %edx,%eax
  801f27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f2d:	eb 0c                	jmp    801f3b <strsplit+0x31>
			*string++ = 0;
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8d 50 01             	lea    0x1(%eax),%edx
  801f35:	89 55 08             	mov    %edx,0x8(%ebp)
  801f38:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8a 00                	mov    (%eax),%al
  801f40:	84 c0                	test   %al,%al
  801f42:	74 18                	je     801f5c <strsplit+0x52>
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	8a 00                	mov    (%eax),%al
  801f49:	0f be c0             	movsbl %al,%eax
  801f4c:	50                   	push   %eax
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	e8 13 fb ff ff       	call   801a68 <strchr>
  801f55:	83 c4 08             	add    $0x8,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	75 d3                	jne    801f2f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	8a 00                	mov    (%eax),%al
  801f61:	84 c0                	test   %al,%al
  801f63:	74 5a                	je     801fbf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f65:	8b 45 14             	mov    0x14(%ebp),%eax
  801f68:	8b 00                	mov    (%eax),%eax
  801f6a:	83 f8 0f             	cmp    $0xf,%eax
  801f6d:	75 07                	jne    801f76 <strsplit+0x6c>
		{
			return 0;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	eb 66                	jmp    801fdc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f76:	8b 45 14             	mov    0x14(%ebp),%eax
  801f79:	8b 00                	mov    (%eax),%eax
  801f7b:	8d 48 01             	lea    0x1(%eax),%ecx
  801f7e:	8b 55 14             	mov    0x14(%ebp),%edx
  801f81:	89 0a                	mov    %ecx,(%edx)
  801f83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8d:	01 c2                	add    %eax,%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f94:	eb 03                	jmp    801f99 <strsplit+0x8f>
			string++;
  801f96:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8a 00                	mov    (%eax),%al
  801f9e:	84 c0                	test   %al,%al
  801fa0:	74 8b                	je     801f2d <strsplit+0x23>
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	0f be c0             	movsbl %al,%eax
  801faa:	50                   	push   %eax
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	e8 b5 fa ff ff       	call   801a68 <strchr>
  801fb3:	83 c4 08             	add    $0x8,%esp
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	74 dc                	je     801f96 <strsplit+0x8c>
			string++;
	}
  801fba:	e9 6e ff ff ff       	jmp    801f2d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fbf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcf:	01 d0                	add    %edx,%eax
  801fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fd7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801fe4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801feb:	eb 4c                	jmp    802039 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801fed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	3c 40                	cmp    $0x40,%al
  801ff9:	7e 27                	jle    802022 <str2lower+0x44>
  801ffb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	01 d0                	add    %edx,%eax
  802003:	8a 00                	mov    (%eax),%al
  802005:	3c 5a                	cmp    $0x5a,%al
  802007:	7f 19                	jg     802022 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  802009:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	01 d0                	add    %edx,%eax
  802011:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	01 ca                	add    %ecx,%edx
  802019:	8a 12                	mov    (%edx),%dl
  80201b:	83 c2 20             	add    $0x20,%edx
  80201e:	88 10                	mov    %dl,(%eax)
  802020:	eb 14                	jmp    802036 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  802022:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	01 c2                	add    %eax,%edx
  80202a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80202d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802030:	01 c8                	add    %ecx,%eax
  802032:	8a 00                	mov    (%eax),%al
  802034:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  802036:	ff 45 fc             	incl   -0x4(%ebp)
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	e8 95 f8 ff ff       	call   8018d6 <strlen>
  802041:	83 c4 04             	add    $0x4,%esp
  802044:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802047:	7f a4                	jg     801fed <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  802049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  80205c:	a1 28 50 80 00       	mov    0x805028,%eax
  802061:	8b 55 08             	mov    0x8(%ebp),%edx
  802064:	89 14 c5 40 51 80 00 	mov    %edx,0x805140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  80206b:	a1 28 50 80 00       	mov    0x805028,%eax
  802070:	8b 55 0c             	mov    0xc(%ebp),%edx
  802073:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
	marked_pagessize++;
  80207a:	a1 28 50 80 00       	mov    0x805028,%eax
  80207f:	40                   	inc    %eax
  802080:	a3 28 50 80 00       	mov    %eax,0x805028
}
  802085:	90                   	nop
  802086:	5d                   	pop    %ebp
  802087:	c3                   	ret    

00802088 <searchElement>:

int searchElement(uint32 start) {
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80208e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802095:	eb 17                	jmp    8020ae <searchElement+0x26>
		if (marked_pages[i].start == start) {
  802097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209a:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  8020a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a4:	75 05                	jne    8020ab <searchElement+0x23>
			return i;
  8020a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a9:	eb 12                	jmp    8020bd <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  8020ab:	ff 45 fc             	incl   -0x4(%ebp)
  8020ae:	a1 28 50 80 00       	mov    0x805028,%eax
  8020b3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8020b6:	7c df                	jl     802097 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  8020b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <removeElement>:
void removeElement(uint32 start) {
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	e8 bb ff ff ff       	call   802088 <searchElement>
  8020cd:	83 c4 04             	add    $0x4,%esp
  8020d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  8020d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	eb 26                	jmp    802101 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  8020db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020de:	40                   	inc    %eax
  8020df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8020e2:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  8020e9:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  8020f0:	89 04 cd 40 51 80 00 	mov    %eax,0x805140(,%ecx,8)
  8020f7:	89 14 cd 44 51 80 00 	mov    %edx,0x805144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  8020fe:	ff 45 fc             	incl   -0x4(%ebp)
  802101:	a1 28 50 80 00       	mov    0x805028,%eax
  802106:	48                   	dec    %eax
  802107:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80210a:	7f cf                	jg     8020db <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  80210c:	a1 28 50 80 00       	mov    0x805028,%eax
  802111:	48                   	dec    %eax
  802112:	a3 28 50 80 00       	mov    %eax,0x805028
}
  802117:	90                   	nop
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <searchfree>:
int searchfree(uint32 end)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  802120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802127:	eb 17                	jmp    802140 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  802129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212c:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  802133:	3b 45 08             	cmp    0x8(%ebp),%eax
  802136:	75 05                	jne    80213d <searchfree+0x23>
			return i;
  802138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213b:	eb 12                	jmp    80214f <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  80213d:	ff 45 fc             	incl   -0x4(%ebp)
  802140:	a1 28 50 80 00       	mov    0x805028,%eax
  802145:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  802148:	7c df                	jl     802129 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  80214a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <removefree>:
void removefree(uint32 end)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  802157:	eb 52                	jmp    8021ab <removefree+0x5a>
		int index = searchfree(end);
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	e8 b9 ff ff ff       	call   80211a <searchfree>
  802161:	83 c4 04             	add    $0x4,%esp
  802164:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  802167:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80216a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216d:	eb 26                	jmp    802195 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  80216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802172:	40                   	inc    %eax
  802173:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802176:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  80217d:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  802184:	89 04 cd 40 51 80 00 	mov    %eax,0x805140(,%ecx,8)
  80218b:	89 14 cd 44 51 80 00 	mov    %edx,0x805144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  802192:	ff 45 fc             	incl   -0x4(%ebp)
  802195:	a1 28 50 80 00       	mov    0x805028,%eax
  80219a:	48                   	dec    %eax
  80219b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80219e:	7f cf                	jg     80216f <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  8021a0:	a1 28 50 80 00       	mov    0x805028,%eax
  8021a5:	48                   	dec    %eax
  8021a6:	a3 28 50 80 00       	mov    %eax,0x805028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  8021ab:	ff 75 08             	pushl  0x8(%ebp)
  8021ae:	e8 67 ff ff ff       	call   80211a <searchfree>
  8021b3:	83 c4 04             	add    $0x4,%esp
  8021b6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8021b9:	75 9e                	jne    802159 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8021bb:	90                   	nop
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <printArray>:
void printArray() {
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8021c4:	83 ec 0c             	sub    $0xc,%esp
  8021c7:	68 d0 41 80 00       	push   $0x8041d0
  8021cc:	e8 83 f0 ff ff       	call   801254 <cprintf>
  8021d1:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8021d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021db:	eb 29                	jmp    802206 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  8021f1:	52                   	push   %edx
  8021f2:	50                   	push   %eax
  8021f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f6:	68 e1 41 80 00       	push   $0x8041e1
  8021fb:	e8 54 f0 ff ff       	call   801254 <cprintf>
  802200:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  802203:	ff 45 f4             	incl   -0xc(%ebp)
  802206:	a1 28 50 80 00       	mov    0x805028,%eax
  80220b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80220e:	7c cd                	jl     8021dd <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  802210:	90                   	nop
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  802216:	a1 04 50 80 00       	mov    0x805004,%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	74 0a                	je     802229 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80221f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802226:	00 00 00 
	}
}
  802229:	90                   	nop
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    

0080222c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802232:	83 ec 0c             	sub    $0xc,%esp
  802235:	ff 75 08             	pushl  0x8(%ebp)
  802238:	e8 4f 09 00 00       	call   802b8c <sys_sbrk>
  80223d:	83 c4 10             	add    $0x10,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802248:	e8 c6 ff ff ff       	call   802213 <InitializeUHeap>
	if (size == 0) return NULL ;
  80224d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802251:	75 0a                	jne    80225d <malloc+0x1b>
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
  802258:	e9 43 01 00 00       	jmp    8023a0 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80225d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802264:	77 3c                	ja     8022a2 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802266:	e8 c3 07 00 00       	call   802a2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 13                	je     802282 <malloc+0x40>
			return alloc_block_FF(size);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	e8 89 0b 00 00       	call   802e03 <alloc_block_FF>
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	e9 1e 01 00 00       	jmp    8023a0 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  802282:	e8 d8 07 00 00       	call   802a5f <sys_isUHeapPlacementStrategyBESTFIT>
  802287:	85 c0                	test   %eax,%eax
  802289:	0f 84 0c 01 00 00    	je     80239b <malloc+0x159>
			return alloc_block_BF(size);
  80228f:	83 ec 0c             	sub    $0xc,%esp
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	e8 7d 0e 00 00       	call   803117 <alloc_block_BF>
  80229a:	83 c4 10             	add    $0x10,%esp
  80229d:	e9 fe 00 00 00       	jmp    8023a0 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8022a2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8022a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	48                   	dec    %eax
  8022b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8022b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bd:	f7 75 e0             	divl   -0x20(%ebp)
  8022c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022c3:	29 d0                	sub    %edx,%eax
  8022c5:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	c1 e8 0c             	shr    $0xc,%eax
  8022ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  8022d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  8022d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  8022df:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  8022e6:	e8 f4 08 00 00       	call   802bdf <sys_hard_limit>
  8022eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8022ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022f1:	05 00 10 00 00       	add    $0x1000,%eax
  8022f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022f9:	eb 49                	jmp    802344 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  8022fb:	83 ec 0c             	sub    $0xc,%esp
  8022fe:	ff 75 e8             	pushl  -0x18(%ebp)
  802301:	e8 82 fd ff ff       	call   802088 <searchElement>
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	83 f8 ff             	cmp    $0xffffffff,%eax
  80230c:	75 28                	jne    802336 <malloc+0xf4>
			{


				count++;
  80230e:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802317:	75 24                	jne    80233d <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  802319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231c:	05 00 10 00 00       	add    $0x1000,%eax
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	c1 e0 0c             	shl    $0xc,%eax
  80232a:	89 c2                	mov    %eax,%edx
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	29 d0                	sub    %edx,%eax
  802331:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  802334:	eb 17                	jmp    80234d <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  802336:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80233d:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  802344:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80234b:	76 ae                	jbe    8022fb <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  80234d:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  802351:	75 07                	jne    80235a <malloc+0x118>
		{
			return NULL;
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	eb 46                	jmp    8023a0 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  80235a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802360:	eb 1a                	jmp    80237c <malloc+0x13a>
		{
			addElement(i,end);
  802362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802368:	83 ec 08             	sub    $0x8,%esp
  80236b:	52                   	push   %edx
  80236c:	50                   	push   %eax
  80236d:	e8 e7 fc ff ff       	call   802059 <addElement>
  802372:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  802375:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  80237c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802382:	7c de                	jl     802362 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  802384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802387:	83 ec 08             	sub    $0x8,%esp
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	50                   	push   %eax
  80238e:	e8 30 08 00 00       	call   802bc3 <sys_allocate_user_mem>
  802393:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  802396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802399:	eb 05                	jmp    8023a0 <malloc+0x15e>
	}
	return NULL;
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax



}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  8023a8:	e8 32 08 00 00       	call   802bdf <sys_hard_limit>
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	0f 89 82 00 00 00    	jns    80243d <free+0x9b>
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8023c3:	77 78                	ja     80243d <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023cb:	73 10                	jae    8023dd <free+0x3b>
			free_block(virtual_address);
  8023cd:	83 ec 0c             	sub    $0xc,%esp
  8023d0:	ff 75 08             	pushl  0x8(%ebp)
  8023d3:	e8 d2 0e 00 00       	call   8032aa <free_block>
  8023d8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8023db:	eb 77                	jmp    802454 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	83 ec 0c             	sub    $0xc,%esp
  8023e3:	50                   	push   %eax
  8023e4:	e8 9f fc ff ff       	call   802088 <searchElement>
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  802403:	29 c2                	sub    %eax,%edx
  802405:	89 d0                	mov    %edx,%eax
  802407:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  80240a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240d:	c1 e8 0c             	shr    $0xc,%eax
  802410:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	83 ec 08             	sub    $0x8,%esp
  802419:	ff 75 ec             	pushl  -0x14(%ebp)
  80241c:	50                   	push   %eax
  80241d:	e8 85 07 00 00       	call   802ba7 <sys_free_user_mem>
  802422:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	50                   	push   %eax
  802433:	e8 19 fd ff ff       	call   802151 <removefree>
  802438:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  80243b:	eb 17                	jmp    802454 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	68 fa 41 80 00       	push   $0x8041fa
  802445:	68 ac 00 00 00       	push   $0xac
  80244a:	68 0a 42 80 00       	push   $0x80420a
  80244f:	e8 43 eb ff ff       	call   800f97 <_panic>
	}
}
  802454:	90                   	nop
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 18             	sub    $0x18,%esp
  80245d:	8b 45 10             	mov    0x10(%ebp),%eax
  802460:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802463:	e8 ab fd ff ff       	call   802213 <InitializeUHeap>
	if (size == 0) return NULL ;
  802468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80246c:	75 07                	jne    802475 <smalloc+0x1e>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	eb 17                	jmp    80248c <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	68 18 42 80 00       	push   $0x804218
  80247d:	68 bc 00 00 00       	push   $0xbc
  802482:	68 0a 42 80 00       	push   $0x80420a
  802487:	e8 0b eb ff ff       	call   800f97 <_panic>
	return NULL;
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802494:	e8 7a fd ff ff       	call   802213 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 40 42 80 00       	push   $0x804240
  8024a1:	68 ca 00 00 00       	push   $0xca
  8024a6:	68 0a 42 80 00       	push   $0x80420a
  8024ab:	e8 e7 ea ff ff       	call   800f97 <_panic>

008024b0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024b6:	e8 58 fd ff ff       	call   802213 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8024bb:	83 ec 04             	sub    $0x4,%esp
  8024be:	68 64 42 80 00       	push   $0x804264
  8024c3:	68 ea 00 00 00       	push   $0xea
  8024c8:	68 0a 42 80 00       	push   $0x80420a
  8024cd:	e8 c5 ea ff ff       	call   800f97 <_panic>

008024d2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8024d8:	83 ec 04             	sub    $0x4,%esp
  8024db:	68 8c 42 80 00       	push   $0x80428c
  8024e0:	68 fe 00 00 00       	push   $0xfe
  8024e5:	68 0a 42 80 00       	push   $0x80420a
  8024ea:	e8 a8 ea ff ff       	call   800f97 <_panic>

008024ef <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 b0 42 80 00       	push   $0x8042b0
  8024fd:	68 08 01 00 00       	push   $0x108
  802502:	68 0a 42 80 00       	push   $0x80420a
  802507:	e8 8b ea ff ff       	call   800f97 <_panic>

0080250c <shrink>:

}
void shrink(uint32 newSize)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	68 b0 42 80 00       	push   $0x8042b0
  80251a:	68 0d 01 00 00       	push   $0x10d
  80251f:	68 0a 42 80 00       	push   $0x80420a
  802524:	e8 6e ea ff ff       	call   800f97 <_panic>

00802529 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 b0 42 80 00       	push   $0x8042b0
  802537:	68 12 01 00 00       	push   $0x112
  80253c:	68 0a 42 80 00       	push   $0x80420a
  802541:	e8 51 ea ff ff       	call   800f97 <_panic>

00802546 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	57                   	push   %edi
  80254a:	56                   	push   %esi
  80254b:	53                   	push   %ebx
  80254c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	8b 55 0c             	mov    0xc(%ebp),%edx
  802555:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802558:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80255b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80255e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802561:	cd 30                	int    $0x30
  802563:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5f                   	pop    %edi
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    

00802571 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	8b 45 10             	mov    0x10(%ebp),%eax
  80257a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80257d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	52                   	push   %edx
  802589:	ff 75 0c             	pushl  0xc(%ebp)
  80258c:	50                   	push   %eax
  80258d:	6a 00                	push   $0x0
  80258f:	e8 b2 ff ff ff       	call   802546 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	90                   	nop
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_cgetc>:

int
sys_cgetc(void)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 01                	push   $0x1
  8025a9:	e8 98 ff ff ff       	call   802546 <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	52                   	push   %edx
  8025c3:	50                   	push   %eax
  8025c4:	6a 05                	push   $0x5
  8025c6:	e8 7b ff ff ff       	call   802546 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8025d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	56                   	push   %esi
  8025e5:	53                   	push   %ebx
  8025e6:	51                   	push   %ecx
  8025e7:	52                   	push   %edx
  8025e8:	50                   	push   %eax
  8025e9:	6a 06                	push   $0x6
  8025eb:	e8 56 ff ff ff       	call   802546 <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025f6:	5b                   	pop    %ebx
  8025f7:	5e                   	pop    %esi
  8025f8:	5d                   	pop    %ebp
  8025f9:	c3                   	ret    

008025fa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8025fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	52                   	push   %edx
  80260a:	50                   	push   %eax
  80260b:	6a 07                	push   $0x7
  80260d:	e8 34 ff ff ff       	call   802546 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	6a 08                	push   $0x8
  802628:	e8 19 ff ff ff       	call   802546 <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 09                	push   $0x9
  802641:	e8 00 ff ff ff       	call   802546 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 0a                	push   $0xa
  80265a:	e8 e7 fe ff ff       	call   802546 <syscall>
  80265f:	83 c4 18             	add    $0x18,%esp
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 0b                	push   $0xb
  802673:	e8 ce fe ff ff       	call   802546 <syscall>
  802678:	83 c4 18             	add    $0x18,%esp
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 0c                	push   $0xc
  80268c:	e8 b5 fe ff ff       	call   802546 <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	ff 75 08             	pushl  0x8(%ebp)
  8026a4:	6a 0d                	push   $0xd
  8026a6:	e8 9b fe ff ff       	call   802546 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 0e                	push   $0xe
  8026bf:	e8 82 fe ff ff       	call   802546 <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
}
  8026c7:	90                   	nop
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 11                	push   $0x11
  8026d9:	e8 68 fe ff ff       	call   802546 <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
}
  8026e1:	90                   	nop
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 12                	push   $0x12
  8026f3:	e8 4e fe ff ff       	call   802546 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
}
  8026fb:	90                   	nop
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <sys_cputc>:


void
sys_cputc(const char c)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80270a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	50                   	push   %eax
  802717:	6a 13                	push   $0x13
  802719:	e8 28 fe ff ff       	call   802546 <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	90                   	nop
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 14                	push   $0x14
  802733:	e8 0e fe ff ff       	call   802546 <syscall>
  802738:	83 c4 18             	add    $0x18,%esp
}
  80273b:	90                   	nop
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	ff 75 0c             	pushl  0xc(%ebp)
  80274d:	50                   	push   %eax
  80274e:	6a 15                	push   $0x15
  802750:	e8 f1 fd ff ff       	call   802546 <syscall>
  802755:	83 c4 18             	add    $0x18,%esp
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80275d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	52                   	push   %edx
  80276a:	50                   	push   %eax
  80276b:	6a 18                	push   $0x18
  80276d:	e8 d4 fd ff ff       	call   802546 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80277a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	52                   	push   %edx
  802787:	50                   	push   %eax
  802788:	6a 16                	push   $0x16
  80278a:	e8 b7 fd ff ff       	call   802546 <syscall>
  80278f:	83 c4 18             	add    $0x18,%esp
}
  802792:	90                   	nop
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	52                   	push   %edx
  8027a5:	50                   	push   %eax
  8027a6:	6a 17                	push   $0x17
  8027a8:	e8 99 fd ff ff       	call   802546 <syscall>
  8027ad:	83 c4 18             	add    $0x18,%esp
}
  8027b0:	90                   	nop
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8027bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8027bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	6a 00                	push   $0x0
  8027cb:	51                   	push   %ecx
  8027cc:	52                   	push   %edx
  8027cd:	ff 75 0c             	pushl  0xc(%ebp)
  8027d0:	50                   	push   %eax
  8027d1:	6a 19                	push   $0x19
  8027d3:	e8 6e fd ff ff       	call   802546 <syscall>
  8027d8:	83 c4 18             	add    $0x18,%esp
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	6a 1a                	push   $0x1a
  8027f0:	e8 51 fd ff ff       	call   802546 <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	51                   	push   %ecx
  80280b:	52                   	push   %edx
  80280c:	50                   	push   %eax
  80280d:	6a 1b                	push   $0x1b
  80280f:	e8 32 fd ff ff       	call   802546 <syscall>
  802814:	83 c4 18             	add    $0x18,%esp
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	52                   	push   %edx
  802829:	50                   	push   %eax
  80282a:	6a 1c                	push   $0x1c
  80282c:	e8 15 fd ff ff       	call   802546 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 1d                	push   $0x1d
  802845:	e8 fc fc ff ff       	call   802546 <syscall>
  80284a:	83 c4 18             	add    $0x18,%esp
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	6a 00                	push   $0x0
  802857:	ff 75 14             	pushl  0x14(%ebp)
  80285a:	ff 75 10             	pushl  0x10(%ebp)
  80285d:	ff 75 0c             	pushl  0xc(%ebp)
  802860:	50                   	push   %eax
  802861:	6a 1e                	push   $0x1e
  802863:	e8 de fc ff ff       	call   802546 <syscall>
  802868:	83 c4 18             	add    $0x18,%esp
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	50                   	push   %eax
  80287c:	6a 1f                	push   $0x1f
  80287e:	e8 c3 fc ff ff       	call   802546 <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
}
  802886:	90                   	nop
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	50                   	push   %eax
  802898:	6a 20                	push   $0x20
  80289a:	e8 a7 fc ff ff       	call   802546 <syscall>
  80289f:	83 c4 18             	add    $0x18,%esp
}
  8028a2:	c9                   	leave  
  8028a3:	c3                   	ret    

008028a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 02                	push   $0x2
  8028b3:	e8 8e fc ff ff       	call   802546 <syscall>
  8028b8:	83 c4 18             	add    $0x18,%esp
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 03                	push   $0x3
  8028cc:	e8 75 fc ff ff       	call   802546 <syscall>
  8028d1:	83 c4 18             	add    $0x18,%esp
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 04                	push   $0x4
  8028e5:	e8 5c fc ff ff       	call   802546 <syscall>
  8028ea:	83 c4 18             	add    $0x18,%esp
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <sys_exit_env>:


void sys_exit_env(void)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028f2:	6a 00                	push   $0x0
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 21                	push   $0x21
  8028fe:	e8 43 fc ff ff       	call   802546 <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
}
  802906:	90                   	nop
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80290f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802912:	8d 50 04             	lea    0x4(%eax),%edx
  802915:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	52                   	push   %edx
  80291f:	50                   	push   %eax
  802920:	6a 22                	push   $0x22
  802922:	e8 1f fc ff ff       	call   802546 <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
	return result;
  80292a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80292d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802933:	89 01                	mov    %eax,(%ecx)
  802935:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	c9                   	leave  
  80293c:	c2 04 00             	ret    $0x4

0080293f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	ff 75 10             	pushl  0x10(%ebp)
  802949:	ff 75 0c             	pushl  0xc(%ebp)
  80294c:	ff 75 08             	pushl  0x8(%ebp)
  80294f:	6a 10                	push   $0x10
  802951:	e8 f0 fb ff ff       	call   802546 <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
	return ;
  802959:	90                   	nop
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <sys_rcr2>:
uint32 sys_rcr2()
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 23                	push   $0x23
  80296b:	e8 d6 fb ff ff       	call   802546 <syscall>
  802970:	83 c4 18             	add    $0x18,%esp
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802981:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	50                   	push   %eax
  80298e:	6a 24                	push   $0x24
  802990:	e8 b1 fb ff ff       	call   802546 <syscall>
  802995:	83 c4 18             	add    $0x18,%esp
	return ;
  802998:	90                   	nop
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <rsttst>:
void rsttst()
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 26                	push   $0x26
  8029aa:	e8 97 fb ff ff       	call   802546 <syscall>
  8029af:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b2:	90                   	nop
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8029be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8029c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029c8:	52                   	push   %edx
  8029c9:	50                   	push   %eax
  8029ca:	ff 75 10             	pushl  0x10(%ebp)
  8029cd:	ff 75 0c             	pushl  0xc(%ebp)
  8029d0:	ff 75 08             	pushl  0x8(%ebp)
  8029d3:	6a 25                	push   $0x25
  8029d5:	e8 6c fb ff ff       	call   802546 <syscall>
  8029da:	83 c4 18             	add    $0x18,%esp
	return ;
  8029dd:	90                   	nop
}
  8029de:	c9                   	leave  
  8029df:	c3                   	ret    

008029e0 <chktst>:
void chktst(uint32 n)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	ff 75 08             	pushl  0x8(%ebp)
  8029ee:	6a 27                	push   $0x27
  8029f0:	e8 51 fb ff ff       	call   802546 <syscall>
  8029f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029f8:	90                   	nop
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <inctst>:

void inctst()
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 28                	push   $0x28
  802a0a:	e8 37 fb ff ff       	call   802546 <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  802a12:	90                   	nop
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <gettst>:
uint32 gettst()
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 29                	push   $0x29
  802a24:	e8 1d fb ff ff       	call   802546 <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 2a                	push   $0x2a
  802a40:	e8 01 fb ff ff       	call   802546 <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
  802a48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a4b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a4f:	75 07                	jne    802a58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a51:	b8 01 00 00 00       	mov    $0x1,%eax
  802a56:	eb 05                	jmp    802a5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a5d:	c9                   	leave  
  802a5e:	c3                   	ret    

00802a5f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a5f:	55                   	push   %ebp
  802a60:	89 e5                	mov    %esp,%ebp
  802a62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 2a                	push   $0x2a
  802a71:	e8 d0 fa ff ff       	call   802546 <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
  802a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a7c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a80:	75 07                	jne    802a89 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a82:	b8 01 00 00 00       	mov    $0x1,%eax
  802a87:	eb 05                	jmp    802a8e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a96:	6a 00                	push   $0x0
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 2a                	push   $0x2a
  802aa2:	e8 9f fa ff ff       	call   802546 <syscall>
  802aa7:	83 c4 18             	add    $0x18,%esp
  802aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802aad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802ab1:	75 07                	jne    802aba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ab3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab8:	eb 05                	jmp    802abf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 2a                	push   $0x2a
  802ad3:	e8 6e fa ff ff       	call   802546 <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
  802adb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ade:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ae2:	75 07                	jne    802aeb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ae4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae9:	eb 05                	jmp    802af0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

00802af2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	6a 00                	push   $0x0
  802afd:	ff 75 08             	pushl  0x8(%ebp)
  802b00:	6a 2b                	push   $0x2b
  802b02:	e8 3f fa ff ff       	call   802546 <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0a:	90                   	nop
}
  802b0b:	c9                   	leave  
  802b0c:	c3                   	ret    

00802b0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
  802b10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	6a 00                	push   $0x0
  802b1f:	53                   	push   %ebx
  802b20:	51                   	push   %ecx
  802b21:	52                   	push   %edx
  802b22:	50                   	push   %eax
  802b23:	6a 2c                	push   $0x2c
  802b25:	e8 1c fa ff ff       	call   802546 <syscall>
  802b2a:	83 c4 18             	add    $0x18,%esp
}
  802b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b30:	c9                   	leave  
  802b31:	c3                   	ret    

00802b32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	52                   	push   %edx
  802b42:	50                   	push   %eax
  802b43:	6a 2d                	push   $0x2d
  802b45:	e8 fc f9 ff ff       	call   802546 <syscall>
  802b4a:	83 c4 18             	add    $0x18,%esp
}
  802b4d:	c9                   	leave  
  802b4e:	c3                   	ret    

00802b4f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	6a 00                	push   $0x0
  802b5d:	51                   	push   %ecx
  802b5e:	ff 75 10             	pushl  0x10(%ebp)
  802b61:	52                   	push   %edx
  802b62:	50                   	push   %eax
  802b63:	6a 2e                	push   $0x2e
  802b65:	e8 dc f9 ff ff       	call   802546 <syscall>
  802b6a:	83 c4 18             	add    $0x18,%esp
}
  802b6d:	c9                   	leave  
  802b6e:	c3                   	ret    

00802b6f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	ff 75 10             	pushl  0x10(%ebp)
  802b79:	ff 75 0c             	pushl  0xc(%ebp)
  802b7c:	ff 75 08             	pushl  0x8(%ebp)
  802b7f:	6a 0f                	push   $0xf
  802b81:	e8 c0 f9 ff ff       	call   802546 <syscall>
  802b86:	83 c4 18             	add    $0x18,%esp
	return ;
  802b89:	90                   	nop
}
  802b8a:	c9                   	leave  
  802b8b:	c3                   	ret    

00802b8c <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	50                   	push   %eax
  802b9b:	6a 2f                	push   $0x2f
  802b9d:	e8 a4 f9 ff ff       	call   802546 <syscall>
  802ba2:	83 c4 18             	add    $0x18,%esp

}
  802ba5:	c9                   	leave  
  802ba6:	c3                   	ret    

00802ba7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	ff 75 0c             	pushl  0xc(%ebp)
  802bb3:	ff 75 08             	pushl  0x8(%ebp)
  802bb6:	6a 30                	push   $0x30
  802bb8:	e8 89 f9 ff ff       	call   802546 <syscall>
  802bbd:	83 c4 18             	add    $0x18,%esp

}
  802bc0:	90                   	nop
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	ff 75 0c             	pushl  0xc(%ebp)
  802bcf:	ff 75 08             	pushl  0x8(%ebp)
  802bd2:	6a 31                	push   $0x31
  802bd4:	e8 6d f9 ff ff       	call   802546 <syscall>
  802bd9:	83 c4 18             	add    $0x18,%esp

}
  802bdc:	90                   	nop
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <sys_hard_limit>:
uint32 sys_hard_limit(){
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 00                	push   $0x0
  802bec:	6a 32                	push   $0x32
  802bee:	e8 53 f9 ff ff       	call   802546 <syscall>
  802bf3:	83 c4 18             	add    $0x18,%esp
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	83 e8 10             	sub    $0x10,%eax
  802c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  802c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
}
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    

00802c0e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
  802c11:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	83 e8 10             	sub    $0x10,%eax
  802c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c20:	8a 40 04             	mov    0x4(%eax),%al
}
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
  802c28:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802c2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c35:	83 f8 02             	cmp    $0x2,%eax
  802c38:	74 2b                	je     802c65 <alloc_block+0x40>
  802c3a:	83 f8 02             	cmp    $0x2,%eax
  802c3d:	7f 07                	jg     802c46 <alloc_block+0x21>
  802c3f:	83 f8 01             	cmp    $0x1,%eax
  802c42:	74 0e                	je     802c52 <alloc_block+0x2d>
  802c44:	eb 58                	jmp    802c9e <alloc_block+0x79>
  802c46:	83 f8 03             	cmp    $0x3,%eax
  802c49:	74 2d                	je     802c78 <alloc_block+0x53>
  802c4b:	83 f8 04             	cmp    $0x4,%eax
  802c4e:	74 3b                	je     802c8b <alloc_block+0x66>
  802c50:	eb 4c                	jmp    802c9e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802c52:	83 ec 0c             	sub    $0xc,%esp
  802c55:	ff 75 08             	pushl  0x8(%ebp)
  802c58:	e8 a6 01 00 00       	call   802e03 <alloc_block_FF>
  802c5d:	83 c4 10             	add    $0x10,%esp
  802c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c63:	eb 4a                	jmp    802caf <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802c65:	83 ec 0c             	sub    $0xc,%esp
  802c68:	ff 75 08             	pushl  0x8(%ebp)
  802c6b:	e8 1d 06 00 00       	call   80328d <alloc_block_NF>
  802c70:	83 c4 10             	add    $0x10,%esp
  802c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c76:	eb 37                	jmp    802caf <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802c78:	83 ec 0c             	sub    $0xc,%esp
  802c7b:	ff 75 08             	pushl  0x8(%ebp)
  802c7e:	e8 94 04 00 00       	call   803117 <alloc_block_BF>
  802c83:	83 c4 10             	add    $0x10,%esp
  802c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c89:	eb 24                	jmp    802caf <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802c8b:	83 ec 0c             	sub    $0xc,%esp
  802c8e:	ff 75 08             	pushl  0x8(%ebp)
  802c91:	e8 da 05 00 00       	call   803270 <alloc_block_WF>
  802c96:	83 c4 10             	add    $0x10,%esp
  802c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802c9c:	eb 11                	jmp    802caf <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	68 c0 42 80 00       	push   $0x8042c0
  802ca6:	e8 a9 e5 ff ff       	call   801254 <cprintf>
  802cab:	83 c4 10             	add    $0x10,%esp
		break;
  802cae:	90                   	nop
	}
	return va;
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    

00802cb4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
  802cb7:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802cba:	83 ec 0c             	sub    $0xc,%esp
  802cbd:	68 e0 42 80 00       	push   $0x8042e0
  802cc2:	e8 8d e5 ff ff       	call   801254 <cprintf>
  802cc7:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802cca:	83 ec 0c             	sub    $0xc,%esp
  802ccd:	68 0b 43 80 00       	push   $0x80430b
  802cd2:	e8 7d e5 ff ff       	call   801254 <cprintf>
  802cd7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce0:	eb 26                	jmp    802d08 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8a 40 04             	mov    0x4(%eax),%al
  802ce8:	0f b6 d0             	movzbl %al,%edx
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	52                   	push   %edx
  802cf4:	50                   	push   %eax
  802cf5:	68 23 43 80 00       	push   $0x804323
  802cfa:	e8 55 e5 ff ff       	call   801254 <cprintf>
  802cff:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d02:	8b 45 10             	mov    0x10(%ebp),%eax
  802d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0c:	74 08                	je     802d16 <print_blocks_list+0x62>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	eb 05                	jmp    802d1b <print_blocks_list+0x67>
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1b:	89 45 10             	mov    %eax,0x10(%ebp)
  802d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	75 bd                	jne    802ce2 <print_blocks_list+0x2e>
  802d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d29:	75 b7                	jne    802ce2 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802d2b:	83 ec 0c             	sub    $0xc,%esp
  802d2e:	68 e0 42 80 00       	push   $0x8042e0
  802d33:	e8 1c e5 ff ff       	call   801254 <cprintf>
  802d38:	83 c4 10             	add    $0x10,%esp

}
  802d3b:	90                   	nop
  802d3c:	c9                   	leave  
  802d3d:	c3                   	ret    

00802d3e <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  802d44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d48:	0f 84 b2 00 00 00    	je     802e00 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802d4e:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802d55:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  802d58:	c7 05 14 51 80 00 00 	movl   $0x0,0x805114
  802d5f:	00 00 00 
  802d62:	c7 05 18 51 80 00 00 	movl   $0x0,0x805118
  802d69:	00 00 00 
  802d6c:	c7 05 20 51 80 00 00 	movl   $0x0,0x805120
  802d73:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 24 51 80 00       	mov    %eax,0x805124
		firstBlock->size = initSizeOfAllocatedSpace;
  802d7e:	a1 24 51 80 00       	mov    0x805124,%eax
  802d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d86:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  802d88:	a1 24 51 80 00       	mov    0x805124,%eax
  802d8d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  802d91:	a1 24 51 80 00       	mov    0x805124,%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	75 14                	jne    802dae <initialize_dynamic_allocator+0x70>
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	68 3c 43 80 00       	push   $0x80433c
  802da2:	6a 68                	push   $0x68
  802da4:	68 5f 43 80 00       	push   $0x80435f
  802da9:	e8 e9 e1 ff ff       	call   800f97 <_panic>
  802dae:	a1 24 51 80 00       	mov    0x805124,%eax
  802db3:	8b 15 14 51 80 00    	mov    0x805114,%edx
  802db9:	89 50 08             	mov    %edx,0x8(%eax)
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 10                	je     802dd3 <initialize_dynamic_allocator+0x95>
  802dc3:	a1 14 51 80 00       	mov    0x805114,%eax
  802dc8:	8b 15 24 51 80 00    	mov    0x805124,%edx
  802dce:	89 50 0c             	mov    %edx,0xc(%eax)
  802dd1:	eb 0a                	jmp    802ddd <initialize_dynamic_allocator+0x9f>
  802dd3:	a1 24 51 80 00       	mov    0x805124,%eax
  802dd8:	a3 18 51 80 00       	mov    %eax,0x805118
  802ddd:	a1 24 51 80 00       	mov    0x805124,%eax
  802de2:	a3 14 51 80 00       	mov    %eax,0x805114
  802de7:	a1 24 51 80 00       	mov    0x805124,%eax
  802dec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802df3:	a1 20 51 80 00       	mov    0x805120,%eax
  802df8:	40                   	inc    %eax
  802df9:	a3 20 51 80 00       	mov    %eax,0x805120
  802dfe:	eb 01                	jmp    802e01 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802e00:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  802e01:	c9                   	leave  
  802e02:	c3                   	ret    

00802e03 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
  802e06:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  802e09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	75 40                	jne    802e52 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	83 c0 10             	add    $0x10,%eax
  802e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	50                   	push   %eax
  802e22:	e8 05 f4 ff ff       	call   80222c <sbrk>
  802e27:	83 c4 10             	add    $0x10,%esp
  802e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802e2d:	83 ec 0c             	sub    $0xc,%esp
  802e30:	6a 00                	push   $0x0
  802e32:	e8 f5 f3 ff ff       	call   80222c <sbrk>
  802e37:	83 c4 10             	add    $0x10,%esp
  802e3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e40:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802e43:	83 ec 08             	sub    $0x8,%esp
  802e46:	50                   	push   %eax
  802e47:	ff 75 ec             	pushl  -0x14(%ebp)
  802e4a:	e8 ef fe ff ff       	call   802d3e <initialize_dynamic_allocator>
  802e4f:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802e52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e56:	75 0a                	jne    802e62 <alloc_block_FF+0x5f>
		 return NULL;
  802e58:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5d:	e9 b3 02 00 00       	jmp    803115 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  802e62:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  802e66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  802e6d:	a1 14 51 80 00       	mov    0x805114,%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e75:	e9 12 01 00 00       	jmp    802f8c <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8a 40 04             	mov    0x4(%eax),%al
  802e80:	84 c0                	test   %al,%al
  802e82:	0f 84 fc 00 00 00    	je     802f84 <alloc_block_FF+0x181>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e90:	0f 82 ee 00 00 00    	jb     802f84 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9e:	75 12                	jne    802eb2 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	83 c0 10             	add    $0x10,%eax
  802ead:	e9 63 02 00 00       	jmp    803115 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  802eb2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	2b 45 08             	sub    0x8(%ebp),%eax
  802ec8:	83 f8 0f             	cmp    $0xf,%eax
  802ecb:	0f 86 a8 00 00 00    	jbe    802f79 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	01 d0                	add    %edx,%eax
  802ed9:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee4:	89 c2                	mov    %eax,%edx
  802ee6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ee9:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef1:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802ef3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ef6:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	74 06                	je     802f06 <alloc_block_FF+0x103>
  802f00:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f04:	75 17                	jne    802f1d <alloc_block_FF+0x11a>
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	68 78 43 80 00       	push   $0x804378
  802f0e:	68 91 00 00 00       	push   $0x91
  802f13:	68 5f 43 80 00       	push   $0x80435f
  802f18:	e8 7a e0 ff ff       	call   800f97 <_panic>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 50 08             	mov    0x8(%eax),%edx
  802f23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f26:	89 50 08             	mov    %edx,0x8(%eax)
  802f29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f2c:	8b 40 08             	mov    0x8(%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0c                	je     802f3f <alloc_block_FF+0x13c>
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f3c:	89 50 0c             	mov    %edx,0xc(%eax)
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f45:	89 50 08             	mov    %edx,0x8(%eax)
  802f48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
  802f51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f54:	8b 40 08             	mov    0x8(%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	75 08                	jne    802f63 <alloc_block_FF+0x160>
  802f5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f5e:	a3 18 51 80 00       	mov    %eax,0x805118
  802f63:	a1 20 51 80 00       	mov    0x805120,%eax
  802f68:	40                   	inc    %eax
  802f69:	a3 20 51 80 00       	mov    %eax,0x805120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	83 c0 10             	add    $0x10,%eax
  802f74:	e9 9c 01 00 00       	jmp    803115 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	83 c0 10             	add    $0x10,%eax
  802f7f:	e9 91 01 00 00       	jmp    803115 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802f84:	a1 1c 51 80 00       	mov    0x80511c,%eax
  802f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f90:	74 08                	je     802f9a <alloc_block_FF+0x197>
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 40 08             	mov    0x8(%eax),%eax
  802f98:	eb 05                	jmp    802f9f <alloc_block_FF+0x19c>
  802f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9f:	a3 1c 51 80 00       	mov    %eax,0x80511c
  802fa4:	a1 1c 51 80 00       	mov    0x80511c,%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	0f 85 c9 fe ff ff    	jne    802e7a <alloc_block_FF+0x77>
  802fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb5:	0f 85 bf fe ff ff    	jne    802e7a <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802fbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fbf:	0f 85 4b 01 00 00    	jne    803110 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	83 ec 0c             	sub    $0xc,%esp
  802fcb:	50                   	push   %eax
  802fcc:	e8 5b f2 ff ff       	call   80222c <sbrk>
  802fd1:	83 c4 10             	add    $0x10,%esp
  802fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdb:	0f 84 28 01 00 00    	je     803109 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fea:	8b 55 08             	mov    0x8(%ebp),%edx
  802fed:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802fef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802ff6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ffa:	75 17                	jne    803013 <alloc_block_FF+0x210>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 ac 43 80 00       	push   $0x8043ac
  803004:	68 a1 00 00 00       	push   $0xa1
  803009:	68 5f 43 80 00       	push   $0x80435f
  80300e:	e8 84 df ff ff       	call   800f97 <_panic>
  803013:	8b 15 18 51 80 00    	mov    0x805118,%edx
  803019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301c:	89 50 0c             	mov    %edx,0xc(%eax)
  80301f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 0d                	je     803036 <alloc_block_FF+0x233>
  803029:	a1 18 51 80 00       	mov    0x805118,%eax
  80302e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803031:	89 50 08             	mov    %edx,0x8(%eax)
  803034:	eb 08                	jmp    80303e <alloc_block_FF+0x23b>
  803036:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803039:	a3 14 51 80 00       	mov    %eax,0x805114
  80303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803041:	a3 18 51 80 00       	mov    %eax,0x805118
  803046:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803049:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803050:	a1 20 51 80 00       	mov    0x805120,%eax
  803055:	40                   	inc    %eax
  803056:	a3 20 51 80 00       	mov    %eax,0x805120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  80305b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803060:	2b 45 08             	sub    0x8(%ebp),%eax
  803063:	83 f8 0f             	cmp    $0xf,%eax
  803066:	0f 86 95 00 00 00    	jbe    803101 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  80306c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	01 d0                	add    %edx,%eax
  803074:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  803077:	b8 00 10 00 00       	mov    $0x1000,%eax
  80307c:	2b 45 08             	sub    0x8(%ebp),%eax
  80307f:	89 c2                	mov    %eax,%edx
  803081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803084:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  80308d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803091:	74 06                	je     803099 <alloc_block_FF+0x296>
  803093:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803097:	75 17                	jne    8030b0 <alloc_block_FF+0x2ad>
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	68 78 43 80 00       	push   $0x804378
  8030a1:	68 a6 00 00 00       	push   $0xa6
  8030a6:	68 5f 43 80 00       	push   $0x80435f
  8030ab:	e8 e7 de ff ff       	call   800f97 <_panic>
  8030b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b3:	8b 50 08             	mov    0x8(%eax),%edx
  8030b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b9:	89 50 08             	mov    %edx,0x8(%eax)
  8030bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0c                	je     8030d2 <alloc_block_FF+0x2cf>
  8030c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c9:	8b 40 08             	mov    0x8(%eax),%eax
  8030cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8030d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d8:	89 50 08             	mov    %edx,0x8(%eax)
  8030db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e1:	89 50 0c             	mov    %edx,0xc(%eax)
  8030e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	75 08                	jne    8030f6 <alloc_block_FF+0x2f3>
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	a3 18 51 80 00       	mov    %eax,0x805118
  8030f6:	a1 20 51 80 00       	mov    0x805120,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 20 51 80 00       	mov    %eax,0x805120
			 }
			 return (sb + 1);
  803101:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803104:	83 c0 10             	add    $0x10,%eax
  803107:	eb 0c                	jmp    803115 <alloc_block_FF+0x312>
		 }
		 return NULL;
  803109:	b8 00 00 00 00       	mov    $0x0,%eax
  80310e:	eb 05                	jmp    803115 <alloc_block_FF+0x312>
	 }
	 return NULL;
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803115:	c9                   	leave  
  803116:	c3                   	ret    

00803117 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803117:	55                   	push   %ebp
  803118:	89 e5                	mov    %esp,%ebp
  80311a:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  80311d:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  803121:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  803128:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  80312f:	a1 14 51 80 00       	mov    0x805114,%eax
  803134:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803137:	eb 34                	jmp    80316d <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  803139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313c:	8a 40 04             	mov    0x4(%eax),%al
  80313f:	84 c0                	test   %al,%al
  803141:	74 22                	je     803165 <alloc_block_BF+0x4e>
  803143:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314b:	72 18                	jb     803165 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803155:	73 0e                	jae    803165 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  803157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315a:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  80315d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  803165:	a1 1c 51 80 00       	mov    0x80511c,%eax
  80316a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80316d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803171:	74 08                	je     80317b <alloc_block_BF+0x64>
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	8b 40 08             	mov    0x8(%eax),%eax
  803179:	eb 05                	jmp    803180 <alloc_block_BF+0x69>
  80317b:	b8 00 00 00 00       	mov    $0x0,%eax
  803180:	a3 1c 51 80 00       	mov    %eax,0x80511c
  803185:	a1 1c 51 80 00       	mov    0x80511c,%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	75 ab                	jne    803139 <alloc_block_BF+0x22>
  80318e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803192:	75 a5                	jne    803139 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  803194:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803198:	0f 84 cb 00 00 00    	je     803269 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ad:	0f 86 ae 00 00 00    	jbe    803261 <alloc_block_BF+0x14a>
  8031b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b6:	8b 00                	mov    (%eax),%eax
  8031b8:	2b 45 08             	sub    0x8(%ebp),%eax
  8031bb:	83 f8 0f             	cmp    $0xf,%eax
  8031be:	0f 86 9d 00 00 00    	jbe    803261 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8031c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	01 d0                	add    %edx,%eax
  8031cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8031d7:	89 c2                	mov    %eax,%edx
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031eb:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  8031ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f1:	74 06                	je     8031f9 <alloc_block_BF+0xe2>
  8031f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f7:	75 17                	jne    803210 <alloc_block_BF+0xf9>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 78 43 80 00       	push   $0x804378
  803201:	68 c6 00 00 00       	push   $0xc6
  803206:	68 5f 43 80 00       	push   $0x80435f
  80320b:	e8 87 dd ff ff       	call   800f97 <_panic>
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 50 08             	mov    0x8(%eax),%edx
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	89 50 08             	mov    %edx,0x8(%eax)
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	74 0c                	je     803232 <alloc_block_BF+0x11b>
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 40 08             	mov    0x8(%eax),%eax
  80322c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322f:	89 50 0c             	mov    %edx,0xc(%eax)
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803238:	89 50 08             	mov    %edx,0x8(%eax)
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803241:	89 50 0c             	mov    %edx,0xc(%eax)
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 40 08             	mov    0x8(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	75 08                	jne    803256 <alloc_block_BF+0x13f>
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	a3 18 51 80 00       	mov    %eax,0x805118
  803256:	a1 20 51 80 00       	mov    0x805120,%eax
  80325b:	40                   	inc    %eax
  80325c:	a3 20 51 80 00       	mov    %eax,0x805120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	83 c0 10             	add    $0x10,%eax
  803267:	eb 05                	jmp    80326e <alloc_block_BF+0x157>
    }

    return NULL;
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 d0 43 80 00       	push   $0x8043d0
  80327e:	68 d2 00 00 00       	push   $0xd2
  803283:	68 5f 43 80 00       	push   $0x80435f
  803288:	e8 0a dd ff ff       	call   800f97 <_panic>

0080328d <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80328d:	55                   	push   %ebp
  80328e:	89 e5                	mov    %esp,%ebp
  803290:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 f8 43 80 00       	push   $0x8043f8
  80329b:	68 db 00 00 00       	push   $0xdb
  8032a0:	68 5f 43 80 00       	push   $0x80435f
  8032a5:	e8 ed dc ff ff       	call   800f97 <_panic>

008032aa <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  8032aa:	55                   	push   %ebp
  8032ab:	89 e5                	mov    %esp,%ebp
  8032ad:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  8032b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b4:	0f 84 d2 01 00 00    	je     80348c <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	83 e8 10             	sub    $0x10,%eax
  8032c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8a 40 04             	mov    0x4(%eax),%al
  8032c9:	84 c0                	test   %al,%al
  8032cb:	0f 85 be 01 00 00    	jne    80348f <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 40 08             	mov    0x8(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	0f 84 cc 00 00 00    	je     8033b2 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ec:	8a 40 04             	mov    0x4(%eax),%al
  8032ef:	84 c0                	test   %al,%al
  8032f1:	0f 84 bb 00 00 00    	je     8033b2 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 10                	mov    (%eax),%edx
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 40 08             	mov    0x8(%eax),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 08             	mov    0x8(%eax),%eax
  80331b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 40 08             	mov    0x8(%eax),%eax
  803327:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  80332a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80332e:	75 17                	jne    803347 <free_block+0x9d>
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	68 1e 44 80 00       	push   $0x80441e
  803338:	68 f8 00 00 00       	push   $0xf8
  80333d:	68 5f 43 80 00       	push   $0x80435f
  803342:	e8 50 dc ff ff       	call   800f97 <_panic>
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	8b 40 08             	mov    0x8(%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 11                	je     803362 <free_block+0xb8>
  803351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80335a:	8b 52 0c             	mov    0xc(%edx),%edx
  80335d:	89 50 0c             	mov    %edx,0xc(%eax)
  803360:	eb 0b                	jmp    80336d <free_block+0xc3>
  803362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803365:	8b 40 0c             	mov    0xc(%eax),%eax
  803368:	a3 18 51 80 00       	mov    %eax,0x805118
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 40 0c             	mov    0xc(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 11                	je     803388 <free_block+0xde>
  803377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337a:	8b 40 0c             	mov    0xc(%eax),%eax
  80337d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803380:	8b 52 08             	mov    0x8(%edx),%edx
  803383:	89 50 08             	mov    %edx,0x8(%eax)
  803386:	eb 0b                	jmp    803393 <free_block+0xe9>
  803388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	a3 14 51 80 00       	mov    %eax,0x805114
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8033a7:	a1 20 51 80 00       	mov    0x805120,%eax
  8033ac:	48                   	dec    %eax
  8033ad:	a3 20 51 80 00       	mov    %eax,0x805120
				}
			}
			if( LIST_PREV(block))
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	0f 84 d0 00 00 00    	je     803490 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c6:	8a 40 04             	mov    0x4(%eax),%al
  8033c9:	84 c0                	test   %al,%al
  8033cb:	0f 84 bf 00 00 00    	je     803490 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033da:	8b 52 0c             	mov    0xc(%edx),%edx
  8033dd:	8b 0a                	mov    (%edx),%ecx
  8033df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e2:	8b 12                	mov    (%edx),%edx
  8033e4:	01 ca                	add    %ecx,%edx
  8033e6:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ee:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	75 17                	jne    80341f <free_block+0x175>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 1e 44 80 00       	push   $0x80441e
  803410:	68 03 01 00 00       	push   $0x103
  803415:	68 5f 43 80 00       	push   $0x80435f
  80341a:	e8 78 db ff ff       	call   800f97 <_panic>
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 40 08             	mov    0x8(%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 11                	je     80343a <free_block+0x190>
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 40 08             	mov    0x8(%eax),%eax
  80342f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803432:	8b 52 0c             	mov    0xc(%edx),%edx
  803435:	89 50 0c             	mov    %edx,0xc(%eax)
  803438:	eb 0b                	jmp    803445 <free_block+0x19b>
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 40 0c             	mov    0xc(%eax),%eax
  803440:	a3 18 51 80 00       	mov    %eax,0x805118
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 0c             	mov    0xc(%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 11                	je     803460 <free_block+0x1b6>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 40 0c             	mov    0xc(%eax),%eax
  803455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803458:	8b 52 08             	mov    0x8(%edx),%edx
  80345b:	89 50 08             	mov    %edx,0x8(%eax)
  80345e:	eb 0b                	jmp    80346b <free_block+0x1c1>
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	8b 40 08             	mov    0x8(%eax),%eax
  803466:	a3 14 51 80 00       	mov    %eax,0x805114
  80346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80347f:	a1 20 51 80 00       	mov    0x805120,%eax
  803484:	48                   	dec    %eax
  803485:	a3 20 51 80 00       	mov    %eax,0x805120
  80348a:	eb 04                	jmp    803490 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  80348c:	90                   	nop
  80348d:	eb 01                	jmp    803490 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  80348f:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  803490:	c9                   	leave  
  803491:	c3                   	ret    

00803492 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
  803495:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  803498:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349c:	75 10                	jne    8034ae <realloc_block_FF+0x1c>
  80349e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034a2:	75 0a                	jne    8034ae <realloc_block_FF+0x1c>
	 {
		 return NULL;
  8034a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a9:	e9 2e 03 00 00       	jmp    8037dc <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  8034ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b2:	75 13                	jne    8034c7 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  8034b4:	83 ec 0c             	sub    $0xc,%esp
  8034b7:	ff 75 0c             	pushl  0xc(%ebp)
  8034ba:	e8 44 f9 ff ff       	call   802e03 <alloc_block_FF>
  8034bf:	83 c4 10             	add    $0x10,%esp
  8034c2:	e9 15 03 00 00       	jmp    8037dc <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  8034c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034cb:	75 18                	jne    8034e5 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	ff 75 08             	pushl  0x8(%ebp)
  8034d3:	e8 d2 fd ff ff       	call   8032aa <free_block>
  8034d8:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  8034db:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e0:	e9 f7 02 00 00       	jmp    8037dc <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	83 e8 10             	sub    $0x10,%eax
  8034eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  8034ee:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034fa:	0f 82 c8 00 00 00    	jb     8035c8 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803508:	75 08                	jne    803512 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	e9 ca 02 00 00       	jmp    8037dc <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  803512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	2b 45 0c             	sub    0xc(%ebp),%eax
  80351a:	83 f8 0f             	cmp    $0xf,%eax
  80351d:	0f 86 9d 00 00 00    	jbe    8035c0 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803526:	8b 45 0c             	mov    0xc(%ebp),%eax
  803529:	01 d0                	add    %edx,%eax
  80352b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	2b 45 0c             	sub    0xc(%ebp),%eax
  803536:	89 c2                	mov    %eax,%edx
  803538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353b:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 55 0c             	mov    0xc(%ebp),%edx
  803543:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  803545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803548:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  80354c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803550:	74 06                	je     803558 <realloc_block_FF+0xc6>
  803552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803556:	75 17                	jne    80356f <realloc_block_FF+0xdd>
  803558:	83 ec 04             	sub    $0x4,%esp
  80355b:	68 78 43 80 00       	push   $0x804378
  803560:	68 2a 01 00 00       	push   $0x12a
  803565:	68 5f 43 80 00       	push   $0x80435f
  80356a:	e8 28 da ff ff       	call   800f97 <_panic>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 50 08             	mov    0x8(%eax),%edx
  803575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803578:	89 50 08             	mov    %edx,0x8(%eax)
  80357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357e:	8b 40 08             	mov    0x8(%eax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	74 0c                	je     803591 <realloc_block_FF+0xff>
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 40 08             	mov    0x8(%eax),%eax
  80358b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358e:	89 50 0c             	mov    %edx,0xc(%eax)
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803597:	89 50 08             	mov    %edx,0x8(%eax)
  80359a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a0:	89 50 0c             	mov    %edx,0xc(%eax)
  8035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a6:	8b 40 08             	mov    0x8(%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	75 08                	jne    8035b5 <realloc_block_FF+0x123>
  8035ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b0:	a3 18 51 80 00       	mov    %eax,0x805118
  8035b5:	a1 20 51 80 00       	mov    0x805120,%eax
  8035ba:	40                   	inc    %eax
  8035bb:	a3 20 51 80 00       	mov    %eax,0x805120
	    	 }
	    	 return va;
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	e9 14 02 00 00       	jmp    8037dc <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	0f 84 97 01 00 00    	je     80376d <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  8035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d9:	8b 40 08             	mov    0x8(%eax),%eax
  8035dc:	8a 40 04             	mov    0x4(%eax),%al
  8035df:	84 c0                	test   %al,%al
  8035e1:	0f 84 86 01 00 00    	je     80376d <realloc_block_FF+0x2db>
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	8b 10                	mov    (%eax),%edx
  8035ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ef:	8b 40 08             	mov    0x8(%eax),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	01 d0                	add    %edx,%eax
  8035f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035f9:	0f 82 6e 01 00 00    	jb     80376d <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  8035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803602:	8b 10                	mov    (%eax),%edx
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	8b 40 08             	mov    0x8(%eax),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	01 c2                	add    %eax,%edx
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 40 08             	mov    0x8(%eax),%eax
  803619:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 40 08             	mov    0x8(%eax),%eax
  803623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 40 08             	mov    0x8(%eax),%eax
  80362f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  803632:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803636:	75 17                	jne    80364f <realloc_block_FF+0x1bd>
  803638:	83 ec 04             	sub    $0x4,%esp
  80363b:	68 1e 44 80 00       	push   $0x80441e
  803640:	68 38 01 00 00       	push   $0x138
  803645:	68 5f 43 80 00       	push   $0x80435f
  80364a:	e8 48 d9 ff ff       	call   800f97 <_panic>
  80364f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803652:	8b 40 08             	mov    0x8(%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 11                	je     80366a <realloc_block_FF+0x1d8>
  803659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365c:	8b 40 08             	mov    0x8(%eax),%eax
  80365f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803662:	8b 52 0c             	mov    0xc(%edx),%edx
  803665:	89 50 0c             	mov    %edx,0xc(%eax)
  803668:	eb 0b                	jmp    803675 <realloc_block_FF+0x1e3>
  80366a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366d:	8b 40 0c             	mov    0xc(%eax),%eax
  803670:	a3 18 51 80 00       	mov    %eax,0x805118
  803675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803678:	8b 40 0c             	mov    0xc(%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 11                	je     803690 <realloc_block_FF+0x1fe>
  80367f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803682:	8b 40 0c             	mov    0xc(%eax),%eax
  803685:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803688:	8b 52 08             	mov    0x8(%edx),%edx
  80368b:	89 50 08             	mov    %edx,0x8(%eax)
  80368e:	eb 0b                	jmp    80369b <realloc_block_FF+0x209>
  803690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803693:	8b 40 08             	mov    0x8(%eax),%eax
  803696:	a3 14 51 80 00       	mov    %eax,0x805114
  80369b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8036af:	a1 20 51 80 00       	mov    0x805120,%eax
  8036b4:	48                   	dec    %eax
  8036b5:	a3 20 51 80 00       	mov    %eax,0x805120
					 if(block->size - new_size >= sizeOfMetaData())
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036c2:	83 f8 0f             	cmp    $0xf,%eax
  8036c5:	0f 86 9d 00 00 00    	jbe    803768 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  8036cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d1:	01 d0                	add    %edx,%eax
  8036d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036de:	89 c2                	mov    %eax,%edx
  8036e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e3:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  8036ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  8036f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f8:	74 06                	je     803700 <realloc_block_FF+0x26e>
  8036fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036fe:	75 17                	jne    803717 <realloc_block_FF+0x285>
  803700:	83 ec 04             	sub    $0x4,%esp
  803703:	68 78 43 80 00       	push   $0x804378
  803708:	68 3f 01 00 00       	push   $0x13f
  80370d:	68 5f 43 80 00       	push   $0x80435f
  803712:	e8 80 d8 ff ff       	call   800f97 <_panic>
  803717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371a:	8b 50 08             	mov    0x8(%eax),%edx
  80371d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803720:	89 50 08             	mov    %edx,0x8(%eax)
  803723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803726:	8b 40 08             	mov    0x8(%eax),%eax
  803729:	85 c0                	test   %eax,%eax
  80372b:	74 0c                	je     803739 <realloc_block_FF+0x2a7>
  80372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803730:	8b 40 08             	mov    0x8(%eax),%eax
  803733:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803736:	89 50 0c             	mov    %edx,0xc(%eax)
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80373f:	89 50 08             	mov    %edx,0x8(%eax)
  803742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803748:	89 50 0c             	mov    %edx,0xc(%eax)
  80374b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374e:	8b 40 08             	mov    0x8(%eax),%eax
  803751:	85 c0                	test   %eax,%eax
  803753:	75 08                	jne    80375d <realloc_block_FF+0x2cb>
  803755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803758:	a3 18 51 80 00       	mov    %eax,0x805118
  80375d:	a1 20 51 80 00       	mov    0x805120,%eax
  803762:	40                   	inc    %eax
  803763:	a3 20 51 80 00       	mov    %eax,0x805120
					 }
					 return va;
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	eb 6f                	jmp    8037dc <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  80376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803770:	83 e8 10             	sub    $0x10,%eax
  803773:	83 ec 0c             	sub    $0xc,%esp
  803776:	50                   	push   %eax
  803777:	e8 87 f6 ff ff       	call   802e03 <alloc_block_FF>
  80377c:	83 c4 10             	add    $0x10,%esp
  80377f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  803782:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803786:	75 29                	jne    8037b1 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  803788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378b:	83 ec 0c             	sub    $0xc,%esp
  80378e:	50                   	push   %eax
  80378f:	e8 98 ea ff ff       	call   80222c <sbrk>
  803794:	83 c4 10             	add    $0x10,%esp
  803797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  80379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379d:	83 f8 ff             	cmp    $0xffffffff,%eax
  8037a0:	75 07                	jne    8037a9 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  8037a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a7:	eb 33                	jmp    8037dc <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	83 c0 10             	add    $0x10,%eax
  8037af:	eb 2b                	jmp    8037dc <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	83 ec 04             	sub    $0x4,%esp
  8037b9:	50                   	push   %eax
  8037ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8037bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c0:	e8 2f e3 ff ff       	call   801af4 <memcpy>
  8037c5:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  8037c8:	83 ec 0c             	sub    $0xc,%esp
  8037cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8037ce:	e8 d7 fa ff ff       	call   8032aa <free_block>
  8037d3:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  8037dc:	c9                   	leave  
  8037dd:	c3                   	ret    
  8037de:	66 90                	xchg   %ax,%ax

008037e0 <__udivdi3>:
  8037e0:	55                   	push   %ebp
  8037e1:	57                   	push   %edi
  8037e2:	56                   	push   %esi
  8037e3:	53                   	push   %ebx
  8037e4:	83 ec 1c             	sub    $0x1c,%esp
  8037e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037f7:	89 ca                	mov    %ecx,%edx
  8037f9:	89 f8                	mov    %edi,%eax
  8037fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037ff:	85 f6                	test   %esi,%esi
  803801:	75 2d                	jne    803830 <__udivdi3+0x50>
  803803:	39 cf                	cmp    %ecx,%edi
  803805:	77 65                	ja     80386c <__udivdi3+0x8c>
  803807:	89 fd                	mov    %edi,%ebp
  803809:	85 ff                	test   %edi,%edi
  80380b:	75 0b                	jne    803818 <__udivdi3+0x38>
  80380d:	b8 01 00 00 00       	mov    $0x1,%eax
  803812:	31 d2                	xor    %edx,%edx
  803814:	f7 f7                	div    %edi
  803816:	89 c5                	mov    %eax,%ebp
  803818:	31 d2                	xor    %edx,%edx
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	f7 f5                	div    %ebp
  80381e:	89 c1                	mov    %eax,%ecx
  803820:	89 d8                	mov    %ebx,%eax
  803822:	f7 f5                	div    %ebp
  803824:	89 cf                	mov    %ecx,%edi
  803826:	89 fa                	mov    %edi,%edx
  803828:	83 c4 1c             	add    $0x1c,%esp
  80382b:	5b                   	pop    %ebx
  80382c:	5e                   	pop    %esi
  80382d:	5f                   	pop    %edi
  80382e:	5d                   	pop    %ebp
  80382f:	c3                   	ret    
  803830:	39 ce                	cmp    %ecx,%esi
  803832:	77 28                	ja     80385c <__udivdi3+0x7c>
  803834:	0f bd fe             	bsr    %esi,%edi
  803837:	83 f7 1f             	xor    $0x1f,%edi
  80383a:	75 40                	jne    80387c <__udivdi3+0x9c>
  80383c:	39 ce                	cmp    %ecx,%esi
  80383e:	72 0a                	jb     80384a <__udivdi3+0x6a>
  803840:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803844:	0f 87 9e 00 00 00    	ja     8038e8 <__udivdi3+0x108>
  80384a:	b8 01 00 00 00       	mov    $0x1,%eax
  80384f:	89 fa                	mov    %edi,%edx
  803851:	83 c4 1c             	add    $0x1c,%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5f                   	pop    %edi
  803857:	5d                   	pop    %ebp
  803858:	c3                   	ret    
  803859:	8d 76 00             	lea    0x0(%esi),%esi
  80385c:	31 ff                	xor    %edi,%edi
  80385e:	31 c0                	xor    %eax,%eax
  803860:	89 fa                	mov    %edi,%edx
  803862:	83 c4 1c             	add    $0x1c,%esp
  803865:	5b                   	pop    %ebx
  803866:	5e                   	pop    %esi
  803867:	5f                   	pop    %edi
  803868:	5d                   	pop    %ebp
  803869:	c3                   	ret    
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	89 d8                	mov    %ebx,%eax
  80386e:	f7 f7                	div    %edi
  803870:	31 ff                	xor    %edi,%edi
  803872:	89 fa                	mov    %edi,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803881:	89 eb                	mov    %ebp,%ebx
  803883:	29 fb                	sub    %edi,%ebx
  803885:	89 f9                	mov    %edi,%ecx
  803887:	d3 e6                	shl    %cl,%esi
  803889:	89 c5                	mov    %eax,%ebp
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 ed                	shr    %cl,%ebp
  80388f:	89 e9                	mov    %ebp,%ecx
  803891:	09 f1                	or     %esi,%ecx
  803893:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803897:	89 f9                	mov    %edi,%ecx
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 c5                	mov    %eax,%ebp
  80389d:	89 d6                	mov    %edx,%esi
  80389f:	88 d9                	mov    %bl,%cl
  8038a1:	d3 ee                	shr    %cl,%esi
  8038a3:	89 f9                	mov    %edi,%ecx
  8038a5:	d3 e2                	shl    %cl,%edx
  8038a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ab:	88 d9                	mov    %bl,%cl
  8038ad:	d3 e8                	shr    %cl,%eax
  8038af:	09 c2                	or     %eax,%edx
  8038b1:	89 d0                	mov    %edx,%eax
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	f7 74 24 0c          	divl   0xc(%esp)
  8038b9:	89 d6                	mov    %edx,%esi
  8038bb:	89 c3                	mov    %eax,%ebx
  8038bd:	f7 e5                	mul    %ebp
  8038bf:	39 d6                	cmp    %edx,%esi
  8038c1:	72 19                	jb     8038dc <__udivdi3+0xfc>
  8038c3:	74 0b                	je     8038d0 <__udivdi3+0xf0>
  8038c5:	89 d8                	mov    %ebx,%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 58 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038d4:	89 f9                	mov    %edi,%ecx
  8038d6:	d3 e2                	shl    %cl,%edx
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	73 e9                	jae    8038c5 <__udivdi3+0xe5>
  8038dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038df:	31 ff                	xor    %edi,%edi
  8038e1:	e9 40 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038e6:	66 90                	xchg   %ax,%ax
  8038e8:	31 c0                	xor    %eax,%eax
  8038ea:	e9 37 ff ff ff       	jmp    803826 <__udivdi3+0x46>
  8038ef:	90                   	nop

008038f0 <__umoddi3>:
  8038f0:	55                   	push   %ebp
  8038f1:	57                   	push   %edi
  8038f2:	56                   	push   %esi
  8038f3:	53                   	push   %ebx
  8038f4:	83 ec 1c             	sub    $0x1c,%esp
  8038f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803903:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803907:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80390b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80390f:	89 f3                	mov    %esi,%ebx
  803911:	89 fa                	mov    %edi,%edx
  803913:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803917:	89 34 24             	mov    %esi,(%esp)
  80391a:	85 c0                	test   %eax,%eax
  80391c:	75 1a                	jne    803938 <__umoddi3+0x48>
  80391e:	39 f7                	cmp    %esi,%edi
  803920:	0f 86 a2 00 00 00    	jbe    8039c8 <__umoddi3+0xd8>
  803926:	89 c8                	mov    %ecx,%eax
  803928:	89 f2                	mov    %esi,%edx
  80392a:	f7 f7                	div    %edi
  80392c:	89 d0                	mov    %edx,%eax
  80392e:	31 d2                	xor    %edx,%edx
  803930:	83 c4 1c             	add    $0x1c,%esp
  803933:	5b                   	pop    %ebx
  803934:	5e                   	pop    %esi
  803935:	5f                   	pop    %edi
  803936:	5d                   	pop    %ebp
  803937:	c3                   	ret    
  803938:	39 f0                	cmp    %esi,%eax
  80393a:	0f 87 ac 00 00 00    	ja     8039ec <__umoddi3+0xfc>
  803940:	0f bd e8             	bsr    %eax,%ebp
  803943:	83 f5 1f             	xor    $0x1f,%ebp
  803946:	0f 84 ac 00 00 00    	je     8039f8 <__umoddi3+0x108>
  80394c:	bf 20 00 00 00       	mov    $0x20,%edi
  803951:	29 ef                	sub    %ebp,%edi
  803953:	89 fe                	mov    %edi,%esi
  803955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803959:	89 e9                	mov    %ebp,%ecx
  80395b:	d3 e0                	shl    %cl,%eax
  80395d:	89 d7                	mov    %edx,%edi
  80395f:	89 f1                	mov    %esi,%ecx
  803961:	d3 ef                	shr    %cl,%edi
  803963:	09 c7                	or     %eax,%edi
  803965:	89 e9                	mov    %ebp,%ecx
  803967:	d3 e2                	shl    %cl,%edx
  803969:	89 14 24             	mov    %edx,(%esp)
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	d3 e0                	shl    %cl,%eax
  803970:	89 c2                	mov    %eax,%edx
  803972:	8b 44 24 08          	mov    0x8(%esp),%eax
  803976:	d3 e0                	shl    %cl,%eax
  803978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80397c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803980:	89 f1                	mov    %esi,%ecx
  803982:	d3 e8                	shr    %cl,%eax
  803984:	09 d0                	or     %edx,%eax
  803986:	d3 eb                	shr    %cl,%ebx
  803988:	89 da                	mov    %ebx,%edx
  80398a:	f7 f7                	div    %edi
  80398c:	89 d3                	mov    %edx,%ebx
  80398e:	f7 24 24             	mull   (%esp)
  803991:	89 c6                	mov    %eax,%esi
  803993:	89 d1                	mov    %edx,%ecx
  803995:	39 d3                	cmp    %edx,%ebx
  803997:	0f 82 87 00 00 00    	jb     803a24 <__umoddi3+0x134>
  80399d:	0f 84 91 00 00 00    	je     803a34 <__umoddi3+0x144>
  8039a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039a7:	29 f2                	sub    %esi,%edx
  8039a9:	19 cb                	sbb    %ecx,%ebx
  8039ab:	89 d8                	mov    %ebx,%eax
  8039ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039b1:	d3 e0                	shl    %cl,%eax
  8039b3:	89 e9                	mov    %ebp,%ecx
  8039b5:	d3 ea                	shr    %cl,%edx
  8039b7:	09 d0                	or     %edx,%eax
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	d3 eb                	shr    %cl,%ebx
  8039bd:	89 da                	mov    %ebx,%edx
  8039bf:	83 c4 1c             	add    $0x1c,%esp
  8039c2:	5b                   	pop    %ebx
  8039c3:	5e                   	pop    %esi
  8039c4:	5f                   	pop    %edi
  8039c5:	5d                   	pop    %ebp
  8039c6:	c3                   	ret    
  8039c7:	90                   	nop
  8039c8:	89 fd                	mov    %edi,%ebp
  8039ca:	85 ff                	test   %edi,%edi
  8039cc:	75 0b                	jne    8039d9 <__umoddi3+0xe9>
  8039ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d3:	31 d2                	xor    %edx,%edx
  8039d5:	f7 f7                	div    %edi
  8039d7:	89 c5                	mov    %eax,%ebp
  8039d9:	89 f0                	mov    %esi,%eax
  8039db:	31 d2                	xor    %edx,%edx
  8039dd:	f7 f5                	div    %ebp
  8039df:	89 c8                	mov    %ecx,%eax
  8039e1:	f7 f5                	div    %ebp
  8039e3:	89 d0                	mov    %edx,%eax
  8039e5:	e9 44 ff ff ff       	jmp    80392e <__umoddi3+0x3e>
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	89 c8                	mov    %ecx,%eax
  8039ee:	89 f2                	mov    %esi,%edx
  8039f0:	83 c4 1c             	add    $0x1c,%esp
  8039f3:	5b                   	pop    %ebx
  8039f4:	5e                   	pop    %esi
  8039f5:	5f                   	pop    %edi
  8039f6:	5d                   	pop    %ebp
  8039f7:	c3                   	ret    
  8039f8:	3b 04 24             	cmp    (%esp),%eax
  8039fb:	72 06                	jb     803a03 <__umoddi3+0x113>
  8039fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a01:	77 0f                	ja     803a12 <__umoddi3+0x122>
  803a03:	89 f2                	mov    %esi,%edx
  803a05:	29 f9                	sub    %edi,%ecx
  803a07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a0b:	89 14 24             	mov    %edx,(%esp)
  803a0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a16:	8b 14 24             	mov    (%esp),%edx
  803a19:	83 c4 1c             	add    $0x1c,%esp
  803a1c:	5b                   	pop    %ebx
  803a1d:	5e                   	pop    %esi
  803a1e:	5f                   	pop    %edi
  803a1f:	5d                   	pop    %ebp
  803a20:	c3                   	ret    
  803a21:	8d 76 00             	lea    0x0(%esi),%esi
  803a24:	2b 04 24             	sub    (%esp),%eax
  803a27:	19 fa                	sbb    %edi,%edx
  803a29:	89 d1                	mov    %edx,%ecx
  803a2b:	89 c6                	mov    %eax,%esi
  803a2d:	e9 71 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a38:	72 ea                	jb     803a24 <__umoddi3+0x134>
  803a3a:	89 d9                	mov    %ebx,%ecx
  803a3c:	e9 62 ff ff ff       	jmp    8039a3 <__umoddi3+0xb3>
