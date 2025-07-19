
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 1e 04 00 00       	call   800454 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 74             	sub    $0x74,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 40 40 80 00       	mov    0x804040,%eax
  800044:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  80004a:	a1 40 40 80 00       	mov    0x804040,%eax
  80004f:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 40 30 80 00       	push   $0x803040
  800061:	6a 21                	push   $0x21
  800063:	68 5c 30 80 00       	push   $0x80305c
  800068:	e8 1e 05 00 00       	call   80058b <_panic>
	}
	/*=================================================*/


	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80007b:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  800082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800089:	e8 e3 1b 00 00       	call   801c71 <sys_pf_calculate_allocated_pages>
  80008e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  800091:	e8 90 1b 00 00       	call   801c26 <sys_calculate_free_frames>
  800096:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("	1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 70 30 80 00       	push   $0x803070
  8000a1:	e8 a2 07 00 00       	call   800848 <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000b0:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000be:	e9 3d 01 00 00       	jmp    800200 <_main+0x1c8>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000ca:	e9 21 01 00 00       	jmp    8001f0 <_main+0x1b8>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d2:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  8000d9:	83 e8 10             	sub    $0x10,%eax
  8000dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 bc             	pushl  -0x44(%ebp)
  8000e5:	e8 4c 17 00 00       	call   801836 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 c2                	mov    %eax,%edx
  8000ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f2:	89 14 85 20 41 80 00 	mov    %edx,0x804120(,%eax,4)
  8000f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000fc:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  800103:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800106:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800109:	d1 e8                	shr    %eax
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800110:	01 c2                	add    %eax,%edx
  800112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800115:	89 14 85 20 6d 80 00 	mov    %edx,0x806d20(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  80011c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80011f:	8d 50 fe             	lea    -0x2(%eax),%edx
  800122:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800125:	01 c2                	add    %eax,%edx
  800127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80012a:	89 14 85 20 57 80 00 	mov    %edx,0x805720(,%eax,4)
				//Check returned va
				if(va == NULL || (va < curVA))
  800131:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800135:	74 08                	je     80013f <_main+0x107>
  800137:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80013a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013d:	73 27                	jae    800166 <_main+0x12e>
				{
					if (is_correct)
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 21                	je     800166 <_main+0x12e>
					{
						is_correct = 0;
  800145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
						cprintf("alloc_block_xx #1.%d: WRONG ALLOC - alloc_block_xx return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  80014c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014f:	83 c0 10             	add    $0x10,%eax
  800152:	ff 75 b8             	pushl  -0x48(%ebp)
  800155:	50                   	push   %eax
  800156:	ff 75 ec             	pushl  -0x14(%ebp)
  800159:	68 bc 30 80 00       	push   $0x8030bc
  80015e:	e8 e5 06 00 00       	call   800848 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
					}
				}
				curVA += allocSizes[i] ;
  800166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800169:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  800170:	01 45 e8             	add    %eax,-0x18(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800173:	c7 45 b4 00 10 00 00 	movl   $0x1000,-0x4c(%ebp)
  80017a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80017d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800180:	01 d0                	add    %edx,%eax
  800182:	48                   	dec    %eax
  800183:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800186:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800189:	ba 00 00 00 00       	mov    $0x0,%edx
  80018e:	f7 75 b4             	divl   -0x4c(%ebp)
  800191:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800194:	29 d0                	sub    %edx,%eax
  800196:	89 45 ac             	mov    %eax,-0x54(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800199:	8b 55 ac             	mov    -0x54(%ebp),%edx
  80019c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80019f:	29 c2                	sub    %eax,%edx
  8001a1:	89 d0                	mov    %edx,%eax
  8001a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  8001a6:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  8001aa:	7e 0e                	jle    8001ba <_main+0x182>
  8001ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001af:	83 f8 0f             	cmp    $0xf,%eax
  8001b2:	77 06                	ja     8001ba <_main+0x182>
				{
					curVA = rounded_curVA;
  8001b4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				}
				//============================================================
				*(startVAs[idx]) = idx ;
  8001ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bd:	8b 14 85 20 41 80 00 	mov    0x804120(,%eax,4),%edx
  8001c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c7:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8001ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001cd:	8b 14 85 20 6d 80 00 	mov    0x806d20(,%eax,4),%edx
  8001d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d7:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8001da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001dd:	8b 14 85 20 57 80 00 	mov    0x805720(,%eax,4),%edx
  8001e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e7:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8001ea:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001ed:	ff 45 e0             	incl   -0x20(%ebp)
  8001f0:	81 7d e0 c7 00 00 00 	cmpl   $0xc7,-0x20(%ebp)
  8001f7:	0f 8e d2 fe ff ff    	jle    8000cf <_main+0x97>
	cprintf("	1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001fd:	ff 45 e4             	incl   -0x1c(%ebp)
  800200:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800204:	0f 8e b9 fe ff ff    	jle    8000c3 <_main+0x8b>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  80020a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80020e:	74 04                	je     800214 <_main+0x1dc>
		{
			eval += 30;
  800210:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("	2: Check stored data inside each allocated block\n\n") ;
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 20 31 80 00       	push   $0x803120
  80021c:	e8 27 06 00 00       	call   800848 <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800224:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  80022b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800232:	eb 5b                	jmp    80028f <_main+0x257>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  800234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800237:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  80023e:	66 8b 00             	mov    (%eax),%ax
  800241:	98                   	cwtl   
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	75 26                	jne    80026d <_main+0x235>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8b 04 85 20 6d 80 00 	mov    0x806d20(,%eax,4),%eax
  800251:	66 8b 00             	mov    (%eax),%ax
  800254:	98                   	cwtl   
  800255:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800258:	75 13                	jne    80026d <_main+0x235>
  80025a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025d:	8b 04 85 20 57 80 00 	mov    0x805720(,%eax,4),%eax
  800264:	66 8b 00             	mov    (%eax),%ax
  800267:	98                   	cwtl   
  800268:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026b:	74 1f                	je     80028c <_main+0x254>
			{
				is_correct = 0;
  80026d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 dc             	pushl  -0x24(%ebp)
  80027d:	68 54 31 80 00       	push   $0x803154
  800282:	e8 c1 05 00 00       	call   800848 <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
				break;
  80028a:	eb 0b                	jmp    800297 <_main+0x25f>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("	2: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  80028c:	ff 45 dc             	incl   -0x24(%ebp)
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800295:	7c 9d                	jl     800234 <_main+0x1fc>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  800297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80029b:	74 04                	je     8002a1 <_main+0x269>
		{
			eval += 40;
  80029d:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
		}
	}

	/*Check page file*/
	{
		is_correct = 1;
  8002a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8002a8:	e8 c4 19 00 00       	call   801c71 <sys_pf_calculate_allocated_pages>
  8002ad:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002b0:	74 17                	je     8002c9 <_main+0x291>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	68 a4 31 80 00       	push   $0x8031a4
  8002ba:	e8 89 05 00 00       	call   800848 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8002c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8002c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002cd:	74 04                	je     8002d3 <_main+0x29b>
		{
			eval += 5;
  8002cf:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8002d3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (int i = 0; i < numOfAllocs; ++i)
  8002da:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8002e1:	eb 23                	jmp    800306 <_main+0x2ce>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
  8002e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002e6:	8b 14 85 00 40 80 00 	mov    0x804000(,%eax,4),%edx
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	c1 e0 02             	shl    $0x2,%eax
  8002f2:	01 d0                	add    %edx,%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	01 d0                	add    %edx,%eax
  8002fd:	c1 e0 03             	shl    $0x3,%eax
  800300:	01 45 d8             	add    %eax,-0x28(%ebp)
			eval += 5;
		}
	}

	uint32 expectedAllocatedSize = 0;
	for (int i = 0; i < numOfAllocs; ++i)
  800303:	ff 45 d4             	incl   -0x2c(%ebp)
  800306:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  80030a:	7e d7                	jle    8002e3 <_main+0x2ab>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  80030c:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  800313:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800316:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800319:	01 d0                	add    %edx,%eax
  80031b:	48                   	dec    %eax
  80031c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80031f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	f7 75 a4             	divl   -0x5c(%ebp)
  80032a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032d:	29 d0                	sub    %edx,%eax
  80032f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800332:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800335:	c1 e8 0c             	shr    $0xc,%eax
  800338:	89 45 9c             	mov    %eax,-0x64(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  80033b:	c7 45 98 00 00 40 00 	movl   $0x400000,-0x68(%ebp)
  800342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800345:	8b 45 98             	mov    -0x68(%ebp),%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	48                   	dec    %eax
  80034b:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80034e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800351:	ba 00 00 00 00       	mov    $0x0,%edx
  800356:	f7 75 98             	divl   -0x68(%ebp)
  800359:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80035c:	29 d0                	sub    %edx,%eax
  80035e:	c1 e8 16             	shr    $0x16,%eax
  800361:	89 45 90             	mov    %eax,-0x70(%ebp)

	/*Check memory allocation*/
	{
		is_correct = 1;
  800364:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) < (expectedAllocNumOfPages + expectedAllocNumOfTables))
  80036b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80036e:	e8 b3 18 00 00       	call   801c26 <sys_calculate_free_frames>
  800373:	89 d9                	mov    %ebx,%ecx
  800375:	29 c1                	sub    %eax,%ecx
  800377:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80037a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	39 c1                	cmp    %eax,%ecx
  800381:	73 17                	jae    80039a <_main+0x362>
		{
			cprintf("number of allocated pages in MEMORY are less than the its expected lower bound\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 e0 31 80 00       	push   $0x8031e0
  80038b:	e8 b8 04 00 00       	call   800848 <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  80039a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80039e:	74 04                	je     8003a4 <_main+0x36c>
		{
			eval += 10;
  8003a0:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  8003ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003ae:	c1 e0 02             	shl    $0x2,%eax
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	50                   	push   %eax
  8003b5:	e8 7c 14 00 00       	call   801836 <malloc>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int i = 0;
  8003c0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  8003c7:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  8003ce:	eb 21                	jmp    8003f1 <_main+0x3b9>
		{
			expectedVAs[i++] = va;
  8003d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d3:	8d 50 01             	lea    0x1(%eax),%edx
  8003d6:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8003d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003e3:	01 c2                	add    %eax,%edx
  8003e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e8:	89 02                	mov    %eax,(%edx)
	/*Check WS elements*/
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  8003ea:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  8003f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003fc:	77 d2                	ja     8003d0 <_main+0x398>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  8003fe:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800401:	6a 02                	push   $0x2
  800403:	6a 00                	push   $0x0
  800405:	50                   	push   %eax
  800406:	ff 75 8c             	pushl  -0x74(%ebp)
  800409:	e8 35 1d 00 00       	call   802143 <sys_check_WS_list>
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	89 45 88             	mov    %eax,-0x78(%ebp)
		if (chk != 1)
  800414:	83 7d 88 01          	cmpl   $0x1,-0x78(%ebp)
  800418:	74 17                	je     800431 <_main+0x3f9>
		{
			cprintf("malloc: page is not added to WS\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 30 32 80 00       	push   $0x803230
  800422:	e8 21 04 00 00       	call   800848 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  80042a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800435:	74 04                	je     80043b <_main+0x403>
		{
			eval += 15;
  800437:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		}
	}

	cprintf("test malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 f4             	pushl  -0xc(%ebp)
  800441:	68 54 32 80 00       	push   $0x803254
  800446:	e8 fd 03 00 00       	call   800848 <cprintf>
  80044b:	83 c4 10             	add    $0x10,%esp

	return;
  80044e:	90                   	nop
}
  80044f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80045a:	e8 52 1a 00 00       	call   801eb1 <sys_getenvindex>
  80045f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	89 d0                	mov    %edx,%eax
  800467:	c1 e0 03             	shl    $0x3,%eax
  80046a:	01 d0                	add    %edx,%eax
  80046c:	01 c0                	add    %eax,%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 04             	shl    $0x4,%eax
  80047c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800481:	a3 40 40 80 00       	mov    %eax,0x804040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800486:	a1 40 40 80 00       	mov    0x804040,%eax
  80048b:	8a 40 5c             	mov    0x5c(%eax),%al
  80048e:	84 c0                	test   %al,%al
  800490:	74 0d                	je     80049f <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800492:	a1 40 40 80 00       	mov    0x804040,%eax
  800497:	83 c0 5c             	add    $0x5c,%eax
  80049a:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80049f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004a3:	7e 0a                	jle    8004af <libmain+0x5b>
		binaryname = argv[0];
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	_main(argc, argv);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	ff 75 08             	pushl  0x8(%ebp)
  8004b8:	e8 7b fb ff ff       	call   800038 <_main>
  8004bd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004c0:	e8 f9 17 00 00       	call   801cbe <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	68 b0 32 80 00       	push   $0x8032b0
  8004cd:	e8 76 03 00 00       	call   800848 <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8004da:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8004e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8004e5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8004eb:	83 ec 04             	sub    $0x4,%esp
  8004ee:	52                   	push   %edx
  8004ef:	50                   	push   %eax
  8004f0:	68 d8 32 80 00       	push   $0x8032d8
  8004f5:	e8 4e 03 00 00       	call   800848 <cprintf>
  8004fa:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004fd:	a1 40 40 80 00       	mov    0x804040,%eax
  800502:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800508:	a1 40 40 80 00       	mov    0x804040,%eax
  80050d:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800513:	a1 40 40 80 00       	mov    0x804040,%eax
  800518:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80051e:	51                   	push   %ecx
  80051f:	52                   	push   %edx
  800520:	50                   	push   %eax
  800521:	68 00 33 80 00       	push   $0x803300
  800526:	e8 1d 03 00 00       	call   800848 <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80052e:	a1 40 40 80 00       	mov    0x804040,%eax
  800533:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	50                   	push   %eax
  80053d:	68 58 33 80 00       	push   $0x803358
  800542:	e8 01 03 00 00       	call   800848 <cprintf>
  800547:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80054a:	83 ec 0c             	sub    $0xc,%esp
  80054d:	68 b0 32 80 00       	push   $0x8032b0
  800552:	e8 f1 02 00 00       	call   800848 <cprintf>
  800557:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80055a:	e8 79 17 00 00       	call   801cd8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80055f:	e8 19 00 00 00       	call   80057d <exit>
}
  800564:	90                   	nop
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	6a 00                	push   $0x0
  800572:	e8 06 19 00 00       	call   801e7d <sys_destroy_env>
  800577:	83 c4 10             	add    $0x10,%esp
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <exit>:

void
exit(void)
{
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800583:	e8 5b 19 00 00       	call   801ee3 <sys_exit_env>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800591:	8d 45 10             	lea    0x10(%ebp),%eax
  800594:	83 c0 04             	add    $0x4,%eax
  800597:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80059a:	a1 30 83 80 00       	mov    0x808330,%eax
  80059f:	85 c0                	test   %eax,%eax
  8005a1:	74 16                	je     8005b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005a3:	a1 30 83 80 00       	mov    0x808330,%eax
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	50                   	push   %eax
  8005ac:	68 6c 33 80 00       	push   $0x80336c
  8005b1:	e8 92 02 00 00       	call   800848 <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005b9:	a1 1c 40 80 00       	mov    0x80401c,%eax
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	ff 75 08             	pushl  0x8(%ebp)
  8005c4:	50                   	push   %eax
  8005c5:	68 71 33 80 00       	push   $0x803371
  8005ca:	e8 79 02 00 00       	call   800848 <cprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005db:	50                   	push   %eax
  8005dc:	e8 fc 01 00 00       	call   8007dd <vcprintf>
  8005e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	6a 00                	push   $0x0
  8005e9:	68 8d 33 80 00       	push   $0x80338d
  8005ee:	e8 ea 01 00 00       	call   8007dd <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005f6:	e8 82 ff ff ff       	call   80057d <exit>

	// should not return here
	while (1) ;
  8005fb:	eb fe                	jmp    8005fb <_panic+0x70>

008005fd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800603:	a1 40 40 80 00       	mov    0x804040,%eax
  800608:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800611:	39 c2                	cmp    %eax,%edx
  800613:	74 14                	je     800629 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	68 90 33 80 00       	push   $0x803390
  80061d:	6a 26                	push   $0x26
  80061f:	68 dc 33 80 00       	push   $0x8033dc
  800624:	e8 62 ff ff ff       	call   80058b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800630:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800637:	e9 c5 00 00 00       	jmp    800701 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80063c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	01 d0                	add    %edx,%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	75 08                	jne    800659 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800651:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800654:	e9 a5 00 00 00       	jmp    8006fe <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800659:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800660:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800667:	eb 69                	jmp    8006d2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800669:	a1 40 40 80 00       	mov    0x804040,%eax
  80066e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800674:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	01 c0                	add    %eax,%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	c1 e0 03             	shl    $0x3,%eax
  800680:	01 c8                	add    %ecx,%eax
  800682:	8a 40 04             	mov    0x4(%eax),%al
  800685:	84 c0                	test   %al,%al
  800687:	75 46                	jne    8006cf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800689:	a1 40 40 80 00       	mov    0x804040,%eax
  80068e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800694:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	01 c0                	add    %eax,%eax
  80069b:	01 d0                	add    %edx,%eax
  80069d:	c1 e0 03             	shl    $0x3,%eax
  8006a0:	01 c8                	add    %ecx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	01 c8                	add    %ecx,%eax
  8006c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c2:	39 c2                	cmp    %eax,%edx
  8006c4:	75 09                	jne    8006cf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006cd:	eb 15                	jmp    8006e4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cf:	ff 45 e8             	incl   -0x18(%ebp)
  8006d2:	a1 40 40 80 00       	mov    0x804040,%eax
  8006d7:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8006dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e0:	39 c2                	cmp    %eax,%edx
  8006e2:	77 85                	ja     800669 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006e8:	75 14                	jne    8006fe <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006ea:	83 ec 04             	sub    $0x4,%esp
  8006ed:	68 e8 33 80 00       	push   $0x8033e8
  8006f2:	6a 3a                	push   $0x3a
  8006f4:	68 dc 33 80 00       	push   $0x8033dc
  8006f9:	e8 8d fe ff ff       	call   80058b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006fe:	ff 45 f0             	incl   -0x10(%ebp)
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800707:	0f 8c 2f ff ff ff    	jl     80063c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80070d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800714:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80071b:	eb 26                	jmp    800743 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80071d:	a1 40 40 80 00       	mov    0x804040,%eax
  800722:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800728:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072b:	89 d0                	mov    %edx,%eax
  80072d:	01 c0                	add    %eax,%eax
  80072f:	01 d0                	add    %edx,%eax
  800731:	c1 e0 03             	shl    $0x3,%eax
  800734:	01 c8                	add    %ecx,%eax
  800736:	8a 40 04             	mov    0x4(%eax),%al
  800739:	3c 01                	cmp    $0x1,%al
  80073b:	75 03                	jne    800740 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80073d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800740:	ff 45 e0             	incl   -0x20(%ebp)
  800743:	a1 40 40 80 00       	mov    0x804040,%eax
  800748:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80074e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800751:	39 c2                	cmp    %eax,%edx
  800753:	77 c8                	ja     80071d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80075b:	74 14                	je     800771 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80075d:	83 ec 04             	sub    $0x4,%esp
  800760:	68 3c 34 80 00       	push   $0x80343c
  800765:	6a 44                	push   $0x44
  800767:	68 dc 33 80 00       	push   $0x8033dc
  80076c:	e8 1a fe ff ff       	call   80058b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800771:	90                   	nop
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	8d 48 01             	lea    0x1(%eax),%ecx
  800782:	8b 55 0c             	mov    0xc(%ebp),%edx
  800785:	89 0a                	mov    %ecx,(%edx)
  800787:	8b 55 08             	mov    0x8(%ebp),%edx
  80078a:	88 d1                	mov    %dl,%cl
  80078c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800793:	8b 45 0c             	mov    0xc(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	3d ff 00 00 00       	cmp    $0xff,%eax
  80079d:	75 2c                	jne    8007cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80079f:	a0 44 40 80 00       	mov    0x804044,%al
  8007a4:	0f b6 c0             	movzbl %al,%eax
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	8b 12                	mov    (%edx),%edx
  8007ac:	89 d1                	mov    %edx,%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b1:	83 c2 08             	add    $0x8,%edx
  8007b4:	83 ec 04             	sub    $0x4,%esp
  8007b7:	50                   	push   %eax
  8007b8:	51                   	push   %ecx
  8007b9:	52                   	push   %edx
  8007ba:	e8 a6 13 00 00       	call   801b65 <sys_cputs>
  8007bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	8b 40 04             	mov    0x4(%eax),%eax
  8007d1:	8d 50 01             	lea    0x1(%eax),%edx
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007da:	90                   	nop
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007ed:	00 00 00 
	b.cnt = 0;
  8007f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	ff 75 08             	pushl  0x8(%ebp)
  800800:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	68 74 07 80 00       	push   $0x800774
  80080c:	e8 11 02 00 00       	call   800a22 <vprintfmt>
  800811:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800814:	a0 44 40 80 00       	mov    0x804044,%al
  800819:	0f b6 c0             	movzbl %al,%eax
  80081c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	50                   	push   %eax
  800826:	52                   	push   %edx
  800827:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80082d:	83 c0 08             	add    $0x8,%eax
  800830:	50                   	push   %eax
  800831:	e8 2f 13 00 00       	call   801b65 <sys_cputs>
  800836:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800839:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800840:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800846:	c9                   	leave  
  800847:	c3                   	ret    

00800848 <cprintf>:

int cprintf(const char *fmt, ...) {
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80084e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800855:	8d 45 0c             	lea    0xc(%ebp),%eax
  800858:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 f4             	pushl  -0xc(%ebp)
  800864:	50                   	push   %eax
  800865:	e8 73 ff ff ff       	call   8007dd <vcprintf>
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800870:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80087b:	e8 3e 14 00 00       	call   801cbe <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800880:	8d 45 0c             	lea    0xc(%ebp),%eax
  800883:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 f4             	pushl  -0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	e8 48 ff ff ff       	call   8007dd <vcprintf>
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80089b:	e8 38 14 00 00       	call   801cd8 <sys_enable_interrupt>
	return cnt;
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	53                   	push   %ebx
  8008a9:	83 ec 14             	sub    $0x14,%esp
  8008ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8008af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8008bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008c3:	77 55                	ja     80091a <printnum+0x75>
  8008c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008c8:	72 05                	jb     8008cf <printnum+0x2a>
  8008ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008cd:	77 4b                	ja     80091a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dd:	52                   	push   %edx
  8008de:	50                   	push   %eax
  8008df:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e5:	e8 ea 24 00 00       	call   802dd4 <__udivdi3>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	ff 75 20             	pushl  0x20(%ebp)
  8008f3:	53                   	push   %ebx
  8008f4:	ff 75 18             	pushl  0x18(%ebp)
  8008f7:	52                   	push   %edx
  8008f8:	50                   	push   %eax
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	ff 75 08             	pushl  0x8(%ebp)
  8008ff:	e8 a1 ff ff ff       	call   8008a5 <printnum>
  800904:	83 c4 20             	add    $0x20,%esp
  800907:	eb 1a                	jmp    800923 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 20             	pushl  0x20(%ebp)
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80091a:	ff 4d 1c             	decl   0x1c(%ebp)
  80091d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800921:	7f e6                	jg     800909 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800923:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800926:	bb 00 00 00 00       	mov    $0x0,%ebx
  80092b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800931:	53                   	push   %ebx
  800932:	51                   	push   %ecx
  800933:	52                   	push   %edx
  800934:	50                   	push   %eax
  800935:	e8 aa 25 00 00       	call   802ee4 <__umoddi3>
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	05 b4 36 80 00       	add    $0x8036b4,%eax
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f be c0             	movsbl %al,%eax
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	50                   	push   %eax
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
}
  800956:	90                   	nop
  800957:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80095f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800963:	7e 1c                	jle    800981 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	8d 50 08             	lea    0x8(%eax),%edx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	89 10                	mov    %edx,(%eax)
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 00                	mov    (%eax),%eax
  800977:	83 e8 08             	sub    $0x8,%eax
  80097a:	8b 50 04             	mov    0x4(%eax),%edx
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	eb 40                	jmp    8009c1 <getuint+0x65>
	else if (lflag)
  800981:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800985:	74 1e                	je     8009a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	8d 50 04             	lea    0x4(%eax),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	89 10                	mov    %edx,(%eax)
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	83 e8 04             	sub    $0x4,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	eb 1c                	jmp    8009c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	89 10                	mov    %edx,(%eax)
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	83 e8 04             	sub    $0x4,%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009ca:	7e 1c                	jle    8009e8 <getint+0x25>
		return va_arg(*ap, long long);
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 00                	mov    (%eax),%eax
  8009d1:	8d 50 08             	lea    0x8(%eax),%edx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	89 10                	mov    %edx,(%eax)
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	83 e8 08             	sub    $0x8,%eax
  8009e1:	8b 50 04             	mov    0x4(%eax),%edx
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	eb 38                	jmp    800a20 <getint+0x5d>
	else if (lflag)
  8009e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ec:	74 1a                	je     800a08 <getint+0x45>
		return va_arg(*ap, long);
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	8d 50 04             	lea    0x4(%eax),%edx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	89 10                	mov    %edx,(%eax)
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	83 e8 04             	sub    $0x4,%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	99                   	cltd   
  800a06:	eb 18                	jmp    800a20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	8d 50 04             	lea    0x4(%eax),%edx
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	89 10                	mov    %edx,(%eax)
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	99                   	cltd   
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a2a:	eb 17                	jmp    800a43 <vprintfmt+0x21>
			if (ch == '\0')
  800a2c:	85 db                	test   %ebx,%ebx
  800a2e:	0f 84 af 03 00 00    	je     800de3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	53                   	push   %ebx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a43:	8b 45 10             	mov    0x10(%ebp),%eax
  800a46:	8d 50 01             	lea    0x1(%eax),%edx
  800a49:	89 55 10             	mov    %edx,0x10(%ebp)
  800a4c:	8a 00                	mov    (%eax),%al
  800a4e:	0f b6 d8             	movzbl %al,%ebx
  800a51:	83 fb 25             	cmp    $0x25,%ebx
  800a54:	75 d6                	jne    800a2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8d 50 01             	lea    0x1(%eax),%edx
  800a7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800a7f:	8a 00                	mov    (%eax),%al
  800a81:	0f b6 d8             	movzbl %al,%ebx
  800a84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a87:	83 f8 55             	cmp    $0x55,%eax
  800a8a:	0f 87 2b 03 00 00    	ja     800dbb <vprintfmt+0x399>
  800a90:	8b 04 85 d8 36 80 00 	mov    0x8036d8(,%eax,4),%eax
  800a97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a9d:	eb d7                	jmp    800a76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800aa3:	eb d1                	jmp    800a76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800aac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	c1 e0 02             	shl    $0x2,%eax
  800ab4:	01 d0                	add    %edx,%eax
  800ab6:	01 c0                	add    %eax,%eax
  800ab8:	01 d8                	add    %ebx,%eax
  800aba:	83 e8 30             	sub    $0x30,%eax
  800abd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac8:	83 fb 2f             	cmp    $0x2f,%ebx
  800acb:	7e 3e                	jle    800b0b <vprintfmt+0xe9>
  800acd:	83 fb 39             	cmp    $0x39,%ebx
  800ad0:	7f 39                	jg     800b0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ad5:	eb d5                	jmp    800aac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 c0 04             	add    $0x4,%eax
  800add:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	83 e8 04             	sub    $0x4,%eax
  800ae6:	8b 00                	mov    (%eax),%eax
  800ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aeb:	eb 1f                	jmp    800b0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af1:	79 83                	jns    800a76 <vprintfmt+0x54>
				width = 0;
  800af3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800afa:	e9 77 ff ff ff       	jmp    800a76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b06:	e9 6b ff ff ff       	jmp    800a76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b10:	0f 89 60 ff ff ff    	jns    800a76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b23:	e9 4e ff ff ff       	jmp    800a76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b2b:	e9 46 ff ff ff       	jmp    800a76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 c0 04             	add    $0x4,%eax
  800b36:	89 45 14             	mov    %eax,0x14(%ebp)
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	83 e8 04             	sub    $0x4,%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			break;
  800b50:	e9 89 02 00 00       	jmp    800dde <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b55:	8b 45 14             	mov    0x14(%ebp),%eax
  800b58:	83 c0 04             	add    $0x4,%eax
  800b5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 e8 04             	sub    $0x4,%eax
  800b64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b66:	85 db                	test   %ebx,%ebx
  800b68:	79 02                	jns    800b6c <vprintfmt+0x14a>
				err = -err;
  800b6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b6c:	83 fb 64             	cmp    $0x64,%ebx
  800b6f:	7f 0b                	jg     800b7c <vprintfmt+0x15a>
  800b71:	8b 34 9d 20 35 80 00 	mov    0x803520(,%ebx,4),%esi
  800b78:	85 f6                	test   %esi,%esi
  800b7a:	75 19                	jne    800b95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b7c:	53                   	push   %ebx
  800b7d:	68 c5 36 80 00       	push   $0x8036c5
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 5e 02 00 00       	call   800deb <printfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b90:	e9 49 02 00 00       	jmp    800dde <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b95:	56                   	push   %esi
  800b96:	68 ce 36 80 00       	push   $0x8036ce
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	ff 75 08             	pushl  0x8(%ebp)
  800ba1:	e8 45 02 00 00       	call   800deb <printfmt>
  800ba6:	83 c4 10             	add    $0x10,%esp
			break;
  800ba9:	e9 30 02 00 00       	jmp    800dde <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 c0 04             	add    $0x4,%eax
  800bb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	83 e8 04             	sub    $0x4,%eax
  800bbd:	8b 30                	mov    (%eax),%esi
  800bbf:	85 f6                	test   %esi,%esi
  800bc1:	75 05                	jne    800bc8 <vprintfmt+0x1a6>
				p = "(null)";
  800bc3:	be d1 36 80 00       	mov    $0x8036d1,%esi
			if (width > 0 && padc != '-')
  800bc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcc:	7e 6d                	jle    800c3b <vprintfmt+0x219>
  800bce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bd2:	74 67                	je     800c3b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	50                   	push   %eax
  800bdb:	56                   	push   %esi
  800bdc:	e8 0c 03 00 00       	call   800eed <strnlen>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800be7:	eb 16                	jmp    800bff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800be9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 0c             	pushl  0xc(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c03:	7f e4                	jg     800be9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c05:	eb 34                	jmp    800c3b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c07:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c0b:	74 1c                	je     800c29 <vprintfmt+0x207>
  800c0d:	83 fb 1f             	cmp    $0x1f,%ebx
  800c10:	7e 05                	jle    800c17 <vprintfmt+0x1f5>
  800c12:	83 fb 7e             	cmp    $0x7e,%ebx
  800c15:	7e 12                	jle    800c29 <vprintfmt+0x207>
					putch('?', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 3f                	push   $0x3f
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
  800c27:	eb 0f                	jmp    800c38 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	53                   	push   %ebx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c38:	ff 4d e4             	decl   -0x1c(%ebp)
  800c3b:	89 f0                	mov    %esi,%eax
  800c3d:	8d 70 01             	lea    0x1(%eax),%esi
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	0f be d8             	movsbl %al,%ebx
  800c45:	85 db                	test   %ebx,%ebx
  800c47:	74 24                	je     800c6d <vprintfmt+0x24b>
  800c49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c4d:	78 b8                	js     800c07 <vprintfmt+0x1e5>
  800c4f:	ff 4d e0             	decl   -0x20(%ebp)
  800c52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c56:	79 af                	jns    800c07 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c58:	eb 13                	jmp    800c6d <vprintfmt+0x24b>
				putch(' ', putdat);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	6a 20                	push   $0x20
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	ff d0                	call   *%eax
  800c67:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c71:	7f e7                	jg     800c5a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c73:	e9 66 01 00 00       	jmp    800dde <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	e8 3c fd ff ff       	call   8009c3 <getint>
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c96:	85 d2                	test   %edx,%edx
  800c98:	79 23                	jns    800cbd <vprintfmt+0x29b>
				putch('-', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 2d                	push   $0x2d
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb0:	f7 d8                	neg    %eax
  800cb2:	83 d2 00             	adc    $0x0,%edx
  800cb5:	f7 da                	neg    %edx
  800cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cbd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc4:	e9 bc 00 00 00       	jmp    800d85 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 e8             	pushl  -0x18(%ebp)
  800ccf:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd2:	50                   	push   %eax
  800cd3:	e8 84 fc ff ff       	call   80095c <getuint>
  800cd8:	83 c4 10             	add    $0x10,%esp
  800cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ce1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ce8:	e9 98 00 00 00       	jmp    800d85 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	6a 58                	push   $0x58
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 58                	push   $0x58
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	6a 58                	push   $0x58
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	ff d0                	call   *%eax
  800d1a:	83 c4 10             	add    $0x10,%esp
			break;
  800d1d:	e9 bc 00 00 00       	jmp    800dde <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	6a 30                	push   $0x30
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d32:	83 ec 08             	sub    $0x8,%esp
  800d35:	ff 75 0c             	pushl  0xc(%ebp)
  800d38:	6a 78                	push   $0x78
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	ff d0                	call   *%eax
  800d3f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d42:	8b 45 14             	mov    0x14(%ebp),%eax
  800d45:	83 c0 04             	add    $0x4,%eax
  800d48:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	83 e8 04             	sub    $0x4,%eax
  800d51:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d5d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d64:	eb 1f                	jmp    800d85 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	ff 75 e8             	pushl  -0x18(%ebp)
  800d6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d6f:	50                   	push   %eax
  800d70:	e8 e7 fb ff ff       	call   80095c <getuint>
  800d75:	83 c4 10             	add    $0x10,%esp
  800d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d85:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8c:	83 ec 04             	sub    $0x4,%esp
  800d8f:	52                   	push   %edx
  800d90:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d93:	50                   	push   %eax
  800d94:	ff 75 f4             	pushl  -0xc(%ebp)
  800d97:	ff 75 f0             	pushl  -0x10(%ebp)
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 00 fb ff ff       	call   8008a5 <printnum>
  800da5:	83 c4 20             	add    $0x20,%esp
			break;
  800da8:	eb 34                	jmp    800dde <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	53                   	push   %ebx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
			break;
  800db9:	eb 23                	jmp    800dde <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	6a 25                	push   $0x25
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dcb:	ff 4d 10             	decl   0x10(%ebp)
  800dce:	eb 03                	jmp    800dd3 <vprintfmt+0x3b1>
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd6:	48                   	dec    %eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3c 25                	cmp    $0x25,%al
  800ddb:	75 f3                	jne    800dd0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ddd:	90                   	nop
		}
	}
  800dde:	e9 47 fc ff ff       	jmp    800a2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800de3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800df1:	8d 45 10             	lea    0x10(%ebp),%eax
  800df4:	83 c0 04             	add    $0x4,%eax
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800e00:	50                   	push   %eax
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	ff 75 08             	pushl  0x8(%ebp)
  800e07:	e8 16 fc ff ff       	call   800a22 <vprintfmt>
  800e0c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e0f:	90                   	nop
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8b 40 08             	mov    0x8(%eax),%eax
  800e1b:	8d 50 01             	lea    0x1(%eax),%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8b 10                	mov    (%eax),%edx
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	8b 40 04             	mov    0x4(%eax),%eax
  800e2f:	39 c2                	cmp    %eax,%edx
  800e31:	73 12                	jae    800e45 <sprintputch+0x33>
		*b->buf++ = ch;
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8b 00                	mov    (%eax),%eax
  800e38:	8d 48 01             	lea    0x1(%eax),%ecx
  800e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3e:	89 0a                	mov    %ecx,(%edx)
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	88 10                	mov    %dl,(%eax)
}
  800e45:	90                   	nop
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	01 d0                	add    %edx,%eax
  800e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e6d:	74 06                	je     800e75 <vsnprintf+0x2d>
  800e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e73:	7f 07                	jg     800e7c <vsnprintf+0x34>
		return -E_INVAL;
  800e75:	b8 03 00 00 00       	mov    $0x3,%eax
  800e7a:	eb 20                	jmp    800e9c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e7c:	ff 75 14             	pushl  0x14(%ebp)
  800e7f:	ff 75 10             	pushl  0x10(%ebp)
  800e82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e85:	50                   	push   %eax
  800e86:	68 12 0e 80 00       	push   $0x800e12
  800e8b:	e8 92 fb ff ff       	call   800a22 <vprintfmt>
  800e90:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e96:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ea7:	83 c0 04             	add    $0x4,%eax
  800eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb3:	50                   	push   %eax
  800eb4:	ff 75 0c             	pushl  0xc(%ebp)
  800eb7:	ff 75 08             	pushl  0x8(%ebp)
  800eba:	e8 89 ff ff ff       	call   800e48 <vsnprintf>
  800ebf:	83 c4 10             	add    $0x10,%esp
  800ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed7:	eb 06                	jmp    800edf <strlen+0x15>
		n++;
  800ed9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800edc:	ff 45 08             	incl   0x8(%ebp)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	75 f1                	jne    800ed9 <strlen+0xf>
		n++;
	return n;
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efa:	eb 09                	jmp    800f05 <strnlen+0x18>
		n++;
  800efc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eff:	ff 45 08             	incl   0x8(%ebp)
  800f02:	ff 4d 0c             	decl   0xc(%ebp)
  800f05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f09:	74 09                	je     800f14 <strnlen+0x27>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	75 e8                	jne    800efc <strnlen+0xf>
		n++;
	return n;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f25:	90                   	nop
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f38:	8a 12                	mov    (%edx),%dl
  800f3a:	88 10                	mov    %dl,(%eax)
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	84 c0                	test   %al,%al
  800f40:	75 e4                	jne    800f26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f5a:	eb 1f                	jmp    800f7b <strncpy+0x34>
		*dst++ = *src;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 08             	mov    %edx,0x8(%ebp)
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	8a 12                	mov    (%edx),%dl
  800f6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	84 c0                	test   %al,%al
  800f73:	74 03                	je     800f78 <strncpy+0x31>
			src++;
  800f75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f78:	ff 45 fc             	incl   -0x4(%ebp)
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f81:	72 d9                	jb     800f5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 30                	je     800fca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f9a:	eb 16                	jmp    800fb2 <strlcpy+0x2a>
			*dst++ = *src++;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8d 50 01             	lea    0x1(%eax),%edx
  800fa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fae:	8a 12                	mov    (%edx),%dl
  800fb0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fb2:	ff 4d 10             	decl   0x10(%ebp)
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 09                	je     800fc4 <strlcpy+0x3c>
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	75 d8                	jne    800f9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd0:	29 c2                	sub    %eax,%edx
  800fd2:	89 d0                	mov    %edx,%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fd9:	eb 06                	jmp    800fe1 <strcmp+0xb>
		p++, q++;
  800fdb:	ff 45 08             	incl   0x8(%ebp)
  800fde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 0e                	je     800ff8 <strcmp+0x22>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 10                	mov    (%eax),%dl
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 e3                	je     800fdb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f b6 d0             	movzbl %al,%edx
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f b6 c0             	movzbl %al,%eax
  801008:	29 c2                	sub    %eax,%edx
  80100a:	89 d0                	mov    %edx,%eax
}
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801011:	eb 09                	jmp    80101c <strncmp+0xe>
		n--, p++, q++;
  801013:	ff 4d 10             	decl   0x10(%ebp)
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80101c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801020:	74 17                	je     801039 <strncmp+0x2b>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	84 c0                	test   %al,%al
  801029:	74 0e                	je     801039 <strncmp+0x2b>
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 10                	mov    (%eax),%dl
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	38 c2                	cmp    %al,%dl
  801037:	74 da                	je     801013 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801039:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103d:	75 07                	jne    801046 <strncmp+0x38>
		return 0;
  80103f:	b8 00 00 00 00       	mov    $0x0,%eax
  801044:	eb 14                	jmp    80105a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f b6 d0             	movzbl %al,%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f b6 c0             	movzbl %al,%eax
  801056:	29 c2                	sub    %eax,%edx
  801058:	89 d0                	mov    %edx,%eax
}
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801068:	eb 12                	jmp    80107c <strchr+0x20>
		if (*s == c)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801072:	75 05                	jne    801079 <strchr+0x1d>
			return (char *) s;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	eb 11                	jmp    80108a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801079:	ff 45 08             	incl   0x8(%ebp)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	84 c0                	test   %al,%al
  801083:	75 e5                	jne    80106a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801098:	eb 0d                	jmp    8010a7 <strfind+0x1b>
		if (*s == c)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010a2:	74 0e                	je     8010b2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010a4:	ff 45 08             	incl   0x8(%ebp)
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	75 ea                	jne    80109a <strfind+0xe>
  8010b0:	eb 01                	jmp    8010b3 <strfind+0x27>
		if (*s == c)
			break;
  8010b2:	90                   	nop
	return (char *) s;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010ca:	eb 0e                	jmp    8010da <memset+0x22>
		*p++ = c;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8d 50 01             	lea    0x1(%eax),%edx
  8010d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010da:	ff 4d f8             	decl   -0x8(%ebp)
  8010dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010e1:	79 e9                	jns    8010cc <memset+0x14>
		*p++ = c;

	return v;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010fa:	eb 16                	jmp    801112 <memcpy+0x2a>
		*d++ = *s++;
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801108:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110e:	8a 12                	mov    (%edx),%dl
  801110:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	8d 50 ff             	lea    -0x1(%eax),%edx
  801118:	89 55 10             	mov    %edx,0x10(%ebp)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	75 dd                	jne    8010fc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801139:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113c:	73 50                	jae    80118e <memmove+0x6a>
  80113e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801149:	76 43                	jbe    80118e <memmove+0x6a>
		s += n;
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801151:	8b 45 10             	mov    0x10(%ebp),%eax
  801154:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801157:	eb 10                	jmp    801169 <memmove+0x45>
			*--d = *--s;
  801159:	ff 4d f8             	decl   -0x8(%ebp)
  80115c:	ff 4d fc             	decl   -0x4(%ebp)
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801162:	8a 10                	mov    (%eax),%dl
  801164:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801167:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	85 c0                	test   %eax,%eax
  801174:	75 e3                	jne    801159 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801176:	eb 23                	jmp    80119b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801181:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801184:	8d 4a 01             	lea    0x1(%edx),%ecx
  801187:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80118a:	8a 12                	mov    (%edx),%dl
  80118c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	8d 50 ff             	lea    -0x1(%eax),%edx
  801194:	89 55 10             	mov    %edx,0x10(%ebp)
  801197:	85 c0                	test   %eax,%eax
  801199:	75 dd                	jne    801178 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011b2:	eb 2a                	jmp    8011de <memcmp+0x3e>
		if (*s1 != *s2)
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8a 10                	mov    (%eax),%dl
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	38 c2                	cmp    %al,%dl
  8011c0:	74 16                	je     8011d8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	0f b6 d0             	movzbl %al,%edx
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	0f b6 c0             	movzbl %al,%eax
  8011d2:	29 c2                	sub    %eax,%edx
  8011d4:	89 d0                	mov    %edx,%eax
  8011d6:	eb 18                	jmp    8011f0 <memcmp+0x50>
		s1++, s2++;
  8011d8:	ff 45 fc             	incl   -0x4(%ebp)
  8011db:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	75 c9                	jne    8011b4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801203:	eb 15                	jmp    80121a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	0f b6 d0             	movzbl %al,%edx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	0f b6 c0             	movzbl %al,%eax
  801213:	39 c2                	cmp    %eax,%edx
  801215:	74 0d                	je     801224 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801217:	ff 45 08             	incl   0x8(%ebp)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801220:	72 e3                	jb     801205 <memfind+0x13>
  801222:	eb 01                	jmp    801225 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801224:	90                   	nop
	return (void *) s;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801237:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123e:	eb 03                	jmp    801243 <strtol+0x19>
		s++;
  801240:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 20                	cmp    $0x20,%al
  80124a:	74 f4                	je     801240 <strtol+0x16>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 09                	cmp    $0x9,%al
  801253:	74 eb                	je     801240 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 2b                	cmp    $0x2b,%al
  80125c:	75 05                	jne    801263 <strtol+0x39>
		s++;
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	eb 13                	jmp    801276 <strtol+0x4c>
	else if (*s == '-')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 2d                	cmp    $0x2d,%al
  80126a:	75 0a                	jne    801276 <strtol+0x4c>
		s++, neg = 1;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801276:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127a:	74 06                	je     801282 <strtol+0x58>
  80127c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801280:	75 20                	jne    8012a2 <strtol+0x78>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 30                	cmp    $0x30,%al
  801289:	75 17                	jne    8012a2 <strtol+0x78>
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	40                   	inc    %eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 78                	cmp    $0x78,%al
  801293:	75 0d                	jne    8012a2 <strtol+0x78>
		s += 2, base = 16;
  801295:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801299:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012a0:	eb 28                	jmp    8012ca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a6:	75 15                	jne    8012bd <strtol+0x93>
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 30                	cmp    $0x30,%al
  8012af:	75 0c                	jne    8012bd <strtol+0x93>
		s++, base = 8;
  8012b1:	ff 45 08             	incl   0x8(%ebp)
  8012b4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012bb:	eb 0d                	jmp    8012ca <strtol+0xa0>
	else if (base == 0)
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 07                	jne    8012ca <strtol+0xa0>
		base = 10;
  8012c3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 2f                	cmp    $0x2f,%al
  8012d1:	7e 19                	jle    8012ec <strtol+0xc2>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	3c 39                	cmp    $0x39,%al
  8012da:	7f 10                	jg     8012ec <strtol+0xc2>
			dig = *s - '0';
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	83 e8 30             	sub    $0x30,%eax
  8012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ea:	eb 42                	jmp    80132e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 60                	cmp    $0x60,%al
  8012f3:	7e 19                	jle    80130e <strtol+0xe4>
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 7a                	cmp    $0x7a,%al
  8012fc:	7f 10                	jg     80130e <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f be c0             	movsbl %al,%eax
  801306:	83 e8 57             	sub    $0x57,%eax
  801309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130c:	eb 20                	jmp    80132e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 40                	cmp    $0x40,%al
  801315:	7e 39                	jle    801350 <strtol+0x126>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 5a                	cmp    $0x5a,%al
  80131e:	7f 30                	jg     801350 <strtol+0x126>
			dig = *s - 'A' + 10;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	0f be c0             	movsbl %al,%eax
  801328:	83 e8 37             	sub    $0x37,%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80132e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801331:	3b 45 10             	cmp    0x10(%ebp),%eax
  801334:	7d 19                	jge    80134f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80134a:	e9 7b ff ff ff       	jmp    8012ca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80134f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801350:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801354:	74 08                	je     80135e <strtol+0x134>
		*endptr = (char *) s;
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	8b 55 08             	mov    0x8(%ebp),%edx
  80135c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80135e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801362:	74 07                	je     80136b <strtol+0x141>
  801364:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801367:	f7 d8                	neg    %eax
  801369:	eb 03                	jmp    80136e <strtol+0x144>
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <ltostr>:

void
ltostr(long value, char *str)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80137d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801388:	79 13                	jns    80139d <ltostr+0x2d>
	{
		neg = 1;
  80138a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801397:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80139a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a5:	99                   	cltd   
  8013a6:	f7 f9                	idiv   %ecx
  8013a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	8d 50 01             	lea    0x1(%eax),%edx
  8013b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013be:	83 c2 30             	add    $0x30,%edx
  8013c1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013cb:	f7 e9                	imul   %ecx
  8013cd:	c1 fa 02             	sar    $0x2,%edx
  8013d0:	89 c8                	mov    %ecx,%eax
  8013d2:	c1 f8 1f             	sar    $0x1f,%eax
  8013d5:	29 c2                	sub    %eax,%edx
  8013d7:	89 d0                	mov    %edx,%eax
  8013d9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e4:	f7 e9                	imul   %ecx
  8013e6:	c1 fa 02             	sar    $0x2,%edx
  8013e9:	89 c8                	mov    %ecx,%eax
  8013eb:	c1 f8 1f             	sar    $0x1f,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
  8013f2:	c1 e0 02             	shl    $0x2,%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	01 c0                	add    %eax,%eax
  8013f9:	29 c1                	sub    %eax,%ecx
  8013fb:	89 ca                	mov    %ecx,%edx
  8013fd:	85 d2                	test   %edx,%edx
  8013ff:	75 9c                	jne    80139d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	48                   	dec    %eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801413:	74 3d                	je     801452 <ltostr+0xe2>
		start = 1 ;
  801415:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141c:	eb 34                	jmp    801452 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c8                	add    %ecx,%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8a 45 eb             	mov    -0x15(%ebp),%al
  80144a:	88 02                	mov    %al,(%edx)
		start++ ;
  80144c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801458:	7c c4                	jl     80141e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80145a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 54 fa ff ff       	call   800eca <strlen>
  801476:	83 c4 04             	add    $0x4,%esp
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	e8 46 fa ff ff       	call   800eca <strlen>
  801484:	83 c4 04             	add    $0x4,%esp
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80148a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 17                	jmp    8014b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ae:	ff 45 fc             	incl   -0x4(%ebp)
  8014b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b7:	7c e1                	jl     80149a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c7:	eb 1f                	jmp    8014e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8d 50 01             	lea    0x1(%eax),%edx
  8014cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 c2                	add    %eax,%edx
  8014d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	01 c8                	add    %ecx,%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e5:	ff 45 f8             	incl   -0x8(%ebp)
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ee:	7c d9                	jl     8014c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801521:	eb 0c                	jmp    80152f <strsplit+0x31>
			*string++ = 0;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8d 50 01             	lea    0x1(%eax),%edx
  801529:	89 55 08             	mov    %edx,0x8(%ebp)
  80152c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	74 18                	je     801550 <strsplit+0x52>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	50                   	push   %eax
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	e8 13 fb ff ff       	call   80105c <strchr>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 d3                	jne    801523 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	74 5a                	je     8015b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	83 f8 0f             	cmp    $0xf,%eax
  801561:	75 07                	jne    80156a <strsplit+0x6c>
		{
			return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 66                	jmp    8015d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 48 01             	lea    0x1(%eax),%ecx
  801572:	8b 55 14             	mov    0x14(%ebp),%edx
  801575:	89 0a                	mov    %ecx,(%edx)
  801577:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	01 c2                	add    %eax,%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801588:	eb 03                	jmp    80158d <strsplit+0x8f>
			string++;
  80158a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	84 c0                	test   %al,%al
  801594:	74 8b                	je     801521 <strsplit+0x23>
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	50                   	push   %eax
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	e8 b5 fa ff ff       	call   80105c <strchr>
  8015a7:	83 c4 08             	add    $0x8,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 dc                	je     80158a <strsplit+0x8c>
			string++;
	}
  8015ae:	e9 6e ff ff ff       	jmp    801521 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8015d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015df:	eb 4c                	jmp    80162d <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8015e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	01 d0                	add    %edx,%eax
  8015e9:	8a 00                	mov    (%eax),%al
  8015eb:	3c 40                	cmp    $0x40,%al
  8015ed:	7e 27                	jle    801616 <str2lower+0x44>
  8015ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	3c 5a                	cmp    $0x5a,%al
  8015fb:	7f 19                	jg     801616 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	01 ca                	add    %ecx,%edx
  80160d:	8a 12                	mov    (%edx),%dl
  80160f:	83 c2 20             	add    $0x20,%edx
  801612:	88 10                	mov    %dl,(%eax)
  801614:	eb 14                	jmp    80162a <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801616:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	01 c2                	add    %eax,%edx
  80161e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	01 c8                	add    %ecx,%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80162a:	ff 45 fc             	incl   -0x4(%ebp)
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	e8 95 f8 ff ff       	call   800eca <strlen>
  801635:	83 c4 04             	add    $0x4,%esp
  801638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163b:	7f a4                	jg     8015e1 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801650:	a1 48 40 80 00       	mov    0x804048,%eax
  801655:	8b 55 08             	mov    0x8(%ebp),%edx
  801658:	89 14 c5 40 83 80 00 	mov    %edx,0x808340(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  80165f:	a1 48 40 80 00       	mov    0x804048,%eax
  801664:	8b 55 0c             	mov    0xc(%ebp),%edx
  801667:	89 14 c5 44 83 80 00 	mov    %edx,0x808344(,%eax,8)
	marked_pagessize++;
  80166e:	a1 48 40 80 00       	mov    0x804048,%eax
  801673:	40                   	inc    %eax
  801674:	a3 48 40 80 00       	mov    %eax,0x804048
}
  801679:	90                   	nop
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <searchElement>:

int searchElement(uint32 start) {
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801689:	eb 17                	jmp    8016a2 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  80168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168e:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  801695:	3b 45 08             	cmp    0x8(%ebp),%eax
  801698:	75 05                	jne    80169f <searchElement+0x23>
			return i;
  80169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169d:	eb 12                	jmp    8016b1 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  80169f:	ff 45 fc             	incl   -0x4(%ebp)
  8016a2:	a1 48 40 80 00       	mov    0x804048,%eax
  8016a7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8016aa:	7c df                	jl     80168b <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  8016ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <removeElement>:
void removeElement(uint32 start) {
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  8016b9:	ff 75 08             	pushl  0x8(%ebp)
  8016bc:	e8 bb ff ff ff       	call   80167c <searchElement>
  8016c1:	83 c4 04             	add    $0x4,%esp
  8016c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  8016c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8016cd:	eb 26                	jmp    8016f5 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  8016cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d2:	40                   	inc    %eax
  8016d3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016d6:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  8016dd:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  8016e4:	89 04 cd 40 83 80 00 	mov    %eax,0x808340(,%ecx,8)
  8016eb:	89 14 cd 44 83 80 00 	mov    %edx,0x808344(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  8016f2:	ff 45 fc             	incl   -0x4(%ebp)
  8016f5:	a1 48 40 80 00       	mov    0x804048,%eax
  8016fa:	48                   	dec    %eax
  8016fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016fe:	7f cf                	jg     8016cf <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801700:	a1 48 40 80 00       	mov    0x804048,%eax
  801705:	48                   	dec    %eax
  801706:	a3 48 40 80 00       	mov    %eax,0x804048
}
  80170b:	90                   	nop
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <searchfree>:
int searchfree(uint32 end)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801714:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80171b:	eb 17                	jmp    801734 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  80171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801720:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  801727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80172a:	75 05                	jne    801731 <searchfree+0x23>
			return i;
  80172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172f:	eb 12                	jmp    801743 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801731:	ff 45 fc             	incl   -0x4(%ebp)
  801734:	a1 48 40 80 00       	mov    0x804048,%eax
  801739:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  80173c:	7c df                	jl     80171d <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  80173e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <removefree>:
void removefree(uint32 end)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  80174b:	eb 52                	jmp    80179f <removefree+0x5a>
		int index = searchfree(end);
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	e8 b9 ff ff ff       	call   80170e <searchfree>
  801755:	83 c4 04             	add    $0x4,%esp
  801758:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  80175b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801761:	eb 26                	jmp    801789 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801763:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801766:	40                   	inc    %eax
  801767:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80176a:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  801771:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  801778:	89 04 cd 40 83 80 00 	mov    %eax,0x808340(,%ecx,8)
  80177f:	89 14 cd 44 83 80 00 	mov    %edx,0x808344(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801786:	ff 45 fc             	incl   -0x4(%ebp)
  801789:	a1 48 40 80 00       	mov    0x804048,%eax
  80178e:	48                   	dec    %eax
  80178f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801792:	7f cf                	jg     801763 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801794:	a1 48 40 80 00       	mov    0x804048,%eax
  801799:	48                   	dec    %eax
  80179a:	a3 48 40 80 00       	mov    %eax,0x804048
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 67 ff ff ff       	call   80170e <searchfree>
  8017a7:	83 c4 04             	add    $0x4,%esp
  8017aa:	83 f8 ff             	cmp    $0xffffffff,%eax
  8017ad:	75 9e                	jne    80174d <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8017af:	90                   	nop
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <printArray>:
void printArray() {
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	68 30 38 80 00       	push   $0x803830
  8017c0:	e8 83 f0 ff ff       	call   800848 <cprintf>
  8017c5:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8017c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8017cf:	eb 29                	jmp    8017fa <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  8017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d4:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  8017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017de:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ea:	68 41 38 80 00       	push   $0x803841
  8017ef:	e8 54 f0 ff ff       	call   800848 <cprintf>
  8017f4:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  8017f7:	ff 45 f4             	incl   -0xc(%ebp)
  8017fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8017ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801802:	7c cd                	jl     8017d1 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  80180a:	a1 20 40 80 00       	mov    0x804020,%eax
  80180f:	85 c0                	test   %eax,%eax
  801811:	74 0a                	je     80181d <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801813:	c7 05 20 40 80 00 00 	movl   $0x0,0x804020
  80181a:	00 00 00 
	}
}
  80181d:	90                   	nop
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 4f 09 00 00       	call   802180 <sys_sbrk>
  801831:	83 c4 10             	add    $0x10,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183c:	e8 c6 ff ff ff       	call   801807 <InitializeUHeap>
	if (size == 0) return NULL ;
  801841:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801845:	75 0a                	jne    801851 <malloc+0x1b>
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
  80184c:	e9 43 01 00 00       	jmp    801994 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801851:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801858:	77 3c                	ja     801896 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80185a:	e8 c3 07 00 00       	call   802022 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80185f:	85 c0                	test   %eax,%eax
  801861:	74 13                	je     801876 <malloc+0x40>
			return alloc_block_FF(size);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	e8 89 0b 00 00       	call   8023f7 <alloc_block_FF>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	e9 1e 01 00 00       	jmp    801994 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801876:	e8 d8 07 00 00       	call   802053 <sys_isUHeapPlacementStrategyBESTFIT>
  80187b:	85 c0                	test   %eax,%eax
  80187d:	0f 84 0c 01 00 00    	je     80198f <malloc+0x159>
			return alloc_block_BF(size);
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	ff 75 08             	pushl  0x8(%ebp)
  801889:	e8 7d 0e 00 00       	call   80270b <alloc_block_BF>
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	e9 fe 00 00 00       	jmp    801994 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801896:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80189d:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	48                   	dec    %eax
  8018a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b1:	f7 75 e0             	divl   -0x20(%ebp)
  8018b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b7:	29 d0                	sub    %edx,%eax
  8018b9:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	c1 e8 0c             	shr    $0xc,%eax
  8018c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  8018c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  8018cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  8018d3:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  8018da:	e8 f4 08 00 00       	call   8021d3 <sys_hard_limit>
  8018df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8018e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018e5:	05 00 10 00 00       	add    $0x1000,%eax
  8018ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018ed:	eb 49                	jmp    801938 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8018f5:	e8 82 fd ff ff       	call   80167c <searchElement>
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	83 f8 ff             	cmp    $0xffffffff,%eax
  801900:	75 28                	jne    80192a <malloc+0xf4>
			{


				count++;
  801902:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801908:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80190b:	75 24                	jne    801931 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  80190d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801910:	05 00 10 00 00       	add    $0x1000,%eax
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191b:	c1 e0 0c             	shl    $0xc,%eax
  80191e:	89 c2                	mov    %eax,%edx
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	29 d0                	sub    %edx,%eax
  801925:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801928:	eb 17                	jmp    801941 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  80192a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801931:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801938:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80193f:	76 ae                	jbe    8018ef <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801941:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801945:	75 07                	jne    80194e <malloc+0x118>
		{
			return NULL;
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	eb 46                	jmp    801994 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  80194e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801954:	eb 1a                	jmp    801970 <malloc+0x13a>
		{
			addElement(i,end);
  801956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	e8 e7 fc ff ff       	call   80164d <addElement>
  801966:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801969:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801973:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801976:	7c de                	jl     801956 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197b:	83 ec 08             	sub    $0x8,%esp
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	50                   	push   %eax
  801982:	e8 30 08 00 00       	call   8021b7 <sys_allocate_user_mem>
  801987:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  80198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198d:	eb 05                	jmp    801994 <malloc+0x15e>
	}
	return NULL;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  80199c:	e8 32 08 00 00       	call   8021d3 <sys_hard_limit>
  8019a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	0f 89 82 00 00 00    	jns    801a31 <free+0x9b>
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019b7:	77 78                	ja     801a31 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019bf:	73 10                	jae    8019d1 <free+0x3b>
			free_block(virtual_address);
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	e8 d2 0e 00 00       	call   80289e <free_block>
  8019cc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8019cf:	eb 77                	jmp    801a48 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	50                   	push   %eax
  8019d8:	e8 9f fc ff ff       	call   80167c <searchElement>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  8019ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f0:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  8019f7:	29 c2                	sub    %eax,%edx
  8019f9:	89 d0                	mov    %edx,%eax
  8019fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  8019fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a01:	c1 e8 0c             	shr    $0xc,%eax
  801a04:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	ff 75 ec             	pushl  -0x14(%ebp)
  801a10:	50                   	push   %eax
  801a11:	e8 85 07 00 00       	call   80219b <sys_free_user_mem>
  801a16:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1c:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	50                   	push   %eax
  801a27:	e8 19 fd ff ff       	call   801745 <removefree>
  801a2c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801a2f:	eb 17                	jmp    801a48 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	68 5a 38 80 00       	push   $0x80385a
  801a39:	68 ac 00 00 00       	push   $0xac
  801a3e:	68 6a 38 80 00       	push   $0x80386a
  801a43:	e8 43 eb ff ff       	call   80058b <_panic>
	}
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 18             	sub    $0x18,%esp
  801a51:	8b 45 10             	mov    0x10(%ebp),%eax
  801a54:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a57:	e8 ab fd ff ff       	call   801807 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a60:	75 07                	jne    801a69 <smalloc+0x1e>
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	eb 17                	jmp    801a80 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 78 38 80 00       	push   $0x803878
  801a71:	68 bc 00 00 00       	push   $0xbc
  801a76:	68 6a 38 80 00       	push   $0x80386a
  801a7b:	e8 0b eb ff ff       	call   80058b <_panic>
	return NULL;
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a88:	e8 7a fd ff ff       	call   801807 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	68 a0 38 80 00       	push   $0x8038a0
  801a95:	68 ca 00 00 00       	push   $0xca
  801a9a:	68 6a 38 80 00       	push   $0x80386a
  801a9f:	e8 e7 ea ff ff       	call   80058b <_panic>

00801aa4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aaa:	e8 58 fd ff ff       	call   801807 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 c4 38 80 00       	push   $0x8038c4
  801ab7:	68 ea 00 00 00       	push   $0xea
  801abc:	68 6a 38 80 00       	push   $0x80386a
  801ac1:	e8 c5 ea ff ff       	call   80058b <_panic>

00801ac6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	68 ec 38 80 00       	push   $0x8038ec
  801ad4:	68 fe 00 00 00       	push   $0xfe
  801ad9:	68 6a 38 80 00       	push   $0x80386a
  801ade:	e8 a8 ea ff ff       	call   80058b <_panic>

00801ae3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	68 10 39 80 00       	push   $0x803910
  801af1:	68 08 01 00 00       	push   $0x108
  801af6:	68 6a 38 80 00       	push   $0x80386a
  801afb:	e8 8b ea ff ff       	call   80058b <_panic>

00801b00 <shrink>:

}
void shrink(uint32 newSize)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	68 10 39 80 00       	push   $0x803910
  801b0e:	68 0d 01 00 00       	push   $0x10d
  801b13:	68 6a 38 80 00       	push   $0x80386a
  801b18:	e8 6e ea ff ff       	call   80058b <_panic>

00801b1d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	68 10 39 80 00       	push   $0x803910
  801b2b:	68 12 01 00 00       	push   $0x112
  801b30:	68 6a 38 80 00       	push   $0x80386a
  801b35:	e8 51 ea ff ff       	call   80058b <_panic>

00801b3a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	57                   	push   %edi
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b52:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b55:	cd 30                	int    $0x30
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5e                   	pop    %esi
  801b62:	5f                   	pop    %edi
  801b63:	5d                   	pop    %ebp
  801b64:	c3                   	ret    

00801b65 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b71:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	50                   	push   %eax
  801b81:	6a 00                	push   $0x0
  801b83:	e8 b2 ff ff ff       	call   801b3a <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 01                	push   $0x1
  801b9d:	e8 98 ff ff ff       	call   801b3a <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 05                	push   $0x5
  801bba:	e8 7b ff ff ff       	call   801b3a <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bc9:	8b 75 18             	mov    0x18(%ebp),%esi
  801bcc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	51                   	push   %ecx
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 06                	push   $0x6
  801bdf:	e8 56 ff ff ff       	call   801b3a <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	52                   	push   %edx
  801bfe:	50                   	push   %eax
  801bff:	6a 07                	push   $0x7
  801c01:	e8 34 ff ff ff       	call   801b3a <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 08                	push   $0x8
  801c1c:	e8 19 ff ff ff       	call   801b3a <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 09                	push   $0x9
  801c35:	e8 00 ff ff ff       	call   801b3a <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 0a                	push   $0xa
  801c4e:	e8 e7 fe ff ff       	call   801b3a <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 0b                	push   $0xb
  801c67:	e8 ce fe ff ff       	call   801b3a <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 0c                	push   $0xc
  801c80:	e8 b5 fe ff ff       	call   801b3a <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 08             	pushl  0x8(%ebp)
  801c98:	6a 0d                	push   $0xd
  801c9a:	e8 9b fe ff ff       	call   801b3a <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 0e                	push   $0xe
  801cb3:	e8 82 fe ff ff       	call   801b3a <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	90                   	nop
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 11                	push   $0x11
  801ccd:	e8 68 fe ff ff       	call   801b3a <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	90                   	nop
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 12                	push   $0x12
  801ce7:	e8 4e fe ff ff       	call   801b3a <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	90                   	nop
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cfe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	50                   	push   %eax
  801d0b:	6a 13                	push   $0x13
  801d0d:	e8 28 fe ff ff       	call   801b3a <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	90                   	nop
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 14                	push   $0x14
  801d27:	e8 0e fe ff ff       	call   801b3a <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	50                   	push   %eax
  801d42:	6a 15                	push   $0x15
  801d44:	e8 f1 fd ff ff       	call   801b3a <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 18                	push   $0x18
  801d61:	e8 d4 fd ff ff       	call   801b3a <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	52                   	push   %edx
  801d7b:	50                   	push   %eax
  801d7c:	6a 16                	push   $0x16
  801d7e:	e8 b7 fd ff ff       	call   801b3a <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	90                   	nop
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	52                   	push   %edx
  801d99:	50                   	push   %eax
  801d9a:	6a 17                	push   $0x17
  801d9c:	e8 99 fd ff ff       	call   801b3a <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	90                   	nop
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	8b 45 10             	mov    0x10(%ebp),%eax
  801db0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801db3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801db6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	51                   	push   %ecx
  801dc0:	52                   	push   %edx
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	50                   	push   %eax
  801dc5:	6a 19                	push   $0x19
  801dc7:	e8 6e fd ff ff       	call   801b3a <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	52                   	push   %edx
  801de1:	50                   	push   %eax
  801de2:	6a 1a                	push   $0x1a
  801de4:	e8 51 fd ff ff       	call   801b3a <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801df1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	51                   	push   %ecx
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 1b                	push   $0x1b
  801e03:	e8 32 fd ff ff       	call   801b3a <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 1c                	push   $0x1c
  801e20:	e8 15 fd ff ff       	call   801b3a <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 1d                	push   $0x1d
  801e39:	e8 fc fc ff ff       	call   801b3a <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 14             	pushl  0x14(%ebp)
  801e4e:	ff 75 10             	pushl  0x10(%ebp)
  801e51:	ff 75 0c             	pushl  0xc(%ebp)
  801e54:	50                   	push   %eax
  801e55:	6a 1e                	push   $0x1e
  801e57:	e8 de fc ff ff       	call   801b3a <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	50                   	push   %eax
  801e70:	6a 1f                	push   $0x1f
  801e72:	e8 c3 fc ff ff       	call   801b3a <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	90                   	nop
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	50                   	push   %eax
  801e8c:	6a 20                	push   $0x20
  801e8e:	e8 a7 fc ff ff       	call   801b3a <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 02                	push   $0x2
  801ea7:	e8 8e fc ff ff       	call   801b3a <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 03                	push   $0x3
  801ec0:	e8 75 fc ff ff       	call   801b3a <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 04                	push   $0x4
  801ed9:	e8 5c fc ff ff       	call   801b3a <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_exit_env>:


void sys_exit_env(void)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 21                	push   $0x21
  801ef2:	e8 43 fc ff ff       	call   801b3a <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f06:	8d 50 04             	lea    0x4(%eax),%edx
  801f09:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 22                	push   $0x22
  801f16:	e8 1f fc ff ff       	call   801b3a <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return result;
  801f1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f27:	89 01                	mov    %eax,(%ecx)
  801f29:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	c9                   	leave  
  801f30:	c2 04 00             	ret    $0x4

00801f33 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	ff 75 10             	pushl  0x10(%ebp)
  801f3d:	ff 75 0c             	pushl  0xc(%ebp)
  801f40:	ff 75 08             	pushl  0x8(%ebp)
  801f43:	6a 10                	push   $0x10
  801f45:	e8 f0 fb ff ff       	call   801b3a <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4d:	90                   	nop
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 23                	push   $0x23
  801f5f:	e8 d6 fb ff ff       	call   801b3a <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f75:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	50                   	push   %eax
  801f82:	6a 24                	push   $0x24
  801f84:	e8 b1 fb ff ff       	call   801b3a <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8c:	90                   	nop
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <rsttst>:
void rsttst()
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 26                	push   $0x26
  801f9e:	e8 97 fb ff ff       	call   801b3a <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa6:	90                   	nop
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fb5:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	ff 75 10             	pushl  0x10(%ebp)
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	6a 25                	push   $0x25
  801fc9:	e8 6c fb ff ff       	call   801b3a <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <chktst>:
void chktst(uint32 n)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	6a 27                	push   $0x27
  801fe4:	e8 51 fb ff ff       	call   801b3a <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fec:	90                   	nop
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <inctst>:

void inctst()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 28                	push   $0x28
  801ffe:	e8 37 fb ff ff       	call   801b3a <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return ;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <gettst>:
uint32 gettst()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 29                	push   $0x29
  802018:	e8 1d fb ff ff       	call   801b3a <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 2a                	push   $0x2a
  802034:	e8 01 fb ff ff       	call   801b3a <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
  80203c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80203f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802043:	75 07                	jne    80204c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802045:	b8 01 00 00 00       	mov    $0x1,%eax
  80204a:	eb 05                	jmp    802051 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 2a                	push   $0x2a
  802065:	e8 d0 fa ff ff       	call   801b3a <syscall>
  80206a:	83 c4 18             	add    $0x18,%esp
  80206d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802070:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802074:	75 07                	jne    80207d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802076:	b8 01 00 00 00       	mov    $0x1,%eax
  80207b:	eb 05                	jmp    802082 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 2a                	push   $0x2a
  802096:	e8 9f fa ff ff       	call   801b3a <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
  80209e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020a1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020a5:	75 07                	jne    8020ae <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ac:	eb 05                	jmp    8020b3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 2a                	push   $0x2a
  8020c7:	e8 6e fa ff ff       	call   801b3a <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
  8020cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020d6:	75 07                	jne    8020df <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020dd:	eb 05                	jmp    8020e4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	ff 75 08             	pushl  0x8(%ebp)
  8020f4:	6a 2b                	push   $0x2b
  8020f6:	e8 3f fa ff ff       	call   801b3a <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fe:	90                   	nop
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802105:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802108:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	6a 00                	push   $0x0
  802113:	53                   	push   %ebx
  802114:	51                   	push   %ecx
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	6a 2c                	push   $0x2c
  802119:	e8 1c fa ff ff       	call   801b3a <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	6a 2d                	push   $0x2d
  802139:	e8 fc f9 ff ff       	call   801b3a <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802146:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	6a 00                	push   $0x0
  802151:	51                   	push   %ecx
  802152:	ff 75 10             	pushl  0x10(%ebp)
  802155:	52                   	push   %edx
  802156:	50                   	push   %eax
  802157:	6a 2e                	push   $0x2e
  802159:	e8 dc f9 ff ff       	call   801b3a <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	ff 75 10             	pushl  0x10(%ebp)
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	ff 75 08             	pushl  0x8(%ebp)
  802173:	6a 0f                	push   $0xf
  802175:	e8 c0 f9 ff ff       	call   801b3a <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
	return ;
  80217d:	90                   	nop
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	50                   	push   %eax
  80218f:	6a 2f                	push   $0x2f
  802191:	e8 a4 f9 ff ff       	call   801b3a <syscall>
  802196:	83 c4 18             	add    $0x18,%esp

}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	6a 30                	push   $0x30
  8021ac:	e8 89 f9 ff ff       	call   801b3a <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp

}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 0c             	pushl  0xc(%ebp)
  8021c3:	ff 75 08             	pushl  0x8(%ebp)
  8021c6:	6a 31                	push   $0x31
  8021c8:	e8 6d f9 ff ff       	call   801b3a <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp

}
  8021d0:	90                   	nop
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 32                	push   $0x32
  8021e2:	e8 53 f9 ff ff       	call   801b3a <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	83 e8 10             	sub    $0x10,%eax
  8021f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  8021fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	83 e8 10             	sub    $0x10,%eax
  80220e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802211:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802214:	8a 40 04             	mov    0x4(%eax),%al
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80221f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	83 f8 02             	cmp    $0x2,%eax
  80222c:	74 2b                	je     802259 <alloc_block+0x40>
  80222e:	83 f8 02             	cmp    $0x2,%eax
  802231:	7f 07                	jg     80223a <alloc_block+0x21>
  802233:	83 f8 01             	cmp    $0x1,%eax
  802236:	74 0e                	je     802246 <alloc_block+0x2d>
  802238:	eb 58                	jmp    802292 <alloc_block+0x79>
  80223a:	83 f8 03             	cmp    $0x3,%eax
  80223d:	74 2d                	je     80226c <alloc_block+0x53>
  80223f:	83 f8 04             	cmp    $0x4,%eax
  802242:	74 3b                	je     80227f <alloc_block+0x66>
  802244:	eb 4c                	jmp    802292 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802246:	83 ec 0c             	sub    $0xc,%esp
  802249:	ff 75 08             	pushl  0x8(%ebp)
  80224c:	e8 a6 01 00 00       	call   8023f7 <alloc_block_FF>
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802257:	eb 4a                	jmp    8022a3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802259:	83 ec 0c             	sub    $0xc,%esp
  80225c:	ff 75 08             	pushl  0x8(%ebp)
  80225f:	e8 1d 06 00 00       	call   802881 <alloc_block_NF>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80226a:	eb 37                	jmp    8022a3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80226c:	83 ec 0c             	sub    $0xc,%esp
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	e8 94 04 00 00       	call   80270b <alloc_block_BF>
  802277:	83 c4 10             	add    $0x10,%esp
  80227a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80227d:	eb 24                	jmp    8022a3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	ff 75 08             	pushl  0x8(%ebp)
  802285:	e8 da 05 00 00       	call   802864 <alloc_block_WF>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802290:	eb 11                	jmp    8022a3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 20 39 80 00       	push   $0x803920
  80229a:	e8 a9 e5 ff ff       	call   800848 <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp
		break;
  8022a2:	90                   	nop
	}
	return va;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	68 40 39 80 00       	push   $0x803940
  8022b6:	e8 8d e5 ff ff       	call   800848 <cprintf>
  8022bb:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022be:	83 ec 0c             	sub    $0xc,%esp
  8022c1:	68 6b 39 80 00       	push   $0x80396b
  8022c6:	e8 7d e5 ff ff       	call   800848 <cprintf>
  8022cb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d4:	eb 26                	jmp    8022fc <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8a 40 04             	mov    0x4(%eax),%al
  8022dc:	0f b6 d0             	movzbl %al,%edx
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	52                   	push   %edx
  8022e8:	50                   	push   %eax
  8022e9:	68 83 39 80 00       	push   $0x803983
  8022ee:	e8 55 e5 ff ff       	call   800848 <cprintf>
  8022f3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802300:	74 08                	je     80230a <print_blocks_list+0x62>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 08             	mov    0x8(%eax),%eax
  802308:	eb 05                	jmp    80230f <print_blocks_list+0x67>
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	89 45 10             	mov    %eax,0x10(%ebp)
  802312:	8b 45 10             	mov    0x10(%ebp),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	75 bd                	jne    8022d6 <print_blocks_list+0x2e>
  802319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231d:	75 b7                	jne    8022d6 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  80231f:	83 ec 0c             	sub    $0xc,%esp
  802322:	68 40 39 80 00       	push   $0x803940
  802327:	e8 1c e5 ff ff       	call   800848 <cprintf>
  80232c:	83 c4 10             	add    $0x10,%esp

}
  80232f:	90                   	nop
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  802338:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80233c:	0f 84 b2 00 00 00    	je     8023f4 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802342:	c7 05 4c 40 80 00 01 	movl   $0x1,0x80404c
  802349:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  80234c:	c7 05 18 83 80 00 00 	movl   $0x0,0x808318
  802353:	00 00 00 
  802356:	c7 05 1c 83 80 00 00 	movl   $0x0,0x80831c
  80235d:	00 00 00 
  802360:	c7 05 24 83 80 00 00 	movl   $0x0,0x808324
  802367:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	a3 28 83 80 00       	mov    %eax,0x808328
		firstBlock->size = initSizeOfAllocatedSpace;
  802372:	a1 28 83 80 00       	mov    0x808328,%eax
  802377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237a:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  80237c:	a1 28 83 80 00       	mov    0x808328,%eax
  802381:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  802385:	a1 28 83 80 00       	mov    0x808328,%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	75 14                	jne    8023a2 <initialize_dynamic_allocator+0x70>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 9c 39 80 00       	push   $0x80399c
  802396:	6a 68                	push   $0x68
  802398:	68 bf 39 80 00       	push   $0x8039bf
  80239d:	e8 e9 e1 ff ff       	call   80058b <_panic>
  8023a2:	a1 28 83 80 00       	mov    0x808328,%eax
  8023a7:	8b 15 18 83 80 00    	mov    0x808318,%edx
  8023ad:	89 50 08             	mov    %edx,0x8(%eax)
  8023b0:	8b 40 08             	mov    0x8(%eax),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 10                	je     8023c7 <initialize_dynamic_allocator+0x95>
  8023b7:	a1 18 83 80 00       	mov    0x808318,%eax
  8023bc:	8b 15 28 83 80 00    	mov    0x808328,%edx
  8023c2:	89 50 0c             	mov    %edx,0xc(%eax)
  8023c5:	eb 0a                	jmp    8023d1 <initialize_dynamic_allocator+0x9f>
  8023c7:	a1 28 83 80 00       	mov    0x808328,%eax
  8023cc:	a3 1c 83 80 00       	mov    %eax,0x80831c
  8023d1:	a1 28 83 80 00       	mov    0x808328,%eax
  8023d6:	a3 18 83 80 00       	mov    %eax,0x808318
  8023db:	a1 28 83 80 00       	mov    0x808328,%eax
  8023e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8023e7:	a1 24 83 80 00       	mov    0x808324,%eax
  8023ec:	40                   	inc    %eax
  8023ed:	a3 24 83 80 00       	mov    %eax,0x808324
  8023f2:	eb 01                	jmp    8023f5 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8023f4:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  8023fd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	75 40                	jne    802446 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	83 c0 10             	add    $0x10,%eax
  80240c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	50                   	push   %eax
  802416:	e8 05 f4 ff ff       	call   801820 <sbrk>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	6a 00                	push   $0x0
  802426:	e8 f5 f3 ff ff       	call   801820 <sbrk>
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802434:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802437:	83 ec 08             	sub    $0x8,%esp
  80243a:	50                   	push   %eax
  80243b:	ff 75 ec             	pushl  -0x14(%ebp)
  80243e:	e8 ef fe ff ff       	call   802332 <initialize_dynamic_allocator>
  802443:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244a:	75 0a                	jne    802456 <alloc_block_FF+0x5f>
		 return NULL;
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
  802451:	e9 b3 02 00 00       	jmp    802709 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  802456:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  80245a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  802461:	a1 18 83 80 00       	mov    0x808318,%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802469:	e9 12 01 00 00       	jmp    802580 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8a 40 04             	mov    0x4(%eax),%al
  802474:	84 c0                	test   %al,%al
  802476:	0f 84 fc 00 00 00    	je     802578 <alloc_block_FF+0x181>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	3b 45 08             	cmp    0x8(%ebp),%eax
  802484:	0f 82 ee 00 00 00    	jb     802578 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802492:	75 12                	jne    8024a6 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	83 c0 10             	add    $0x10,%eax
  8024a1:	e9 63 02 00 00       	jmp    802709 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  8024a6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024bc:	83 f8 0f             	cmp    $0xf,%eax
  8024bf:	0f 86 a8 00 00 00    	jbe    80256d <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  8024c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	01 d0                	add    %edx,%eax
  8024cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d8:	89 c2                	mov    %eax,%edx
  8024da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024dd:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e5:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  8024e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ea:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	74 06                	je     8024fa <alloc_block_FF+0x103>
  8024f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8024f8:	75 17                	jne    802511 <alloc_block_FF+0x11a>
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	68 d8 39 80 00       	push   $0x8039d8
  802502:	68 91 00 00 00       	push   $0x91
  802507:	68 bf 39 80 00       	push   $0x8039bf
  80250c:	e8 7a e0 ff ff       	call   80058b <_panic>
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251a:	89 50 08             	mov    %edx,0x8(%eax)
  80251d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802520:	8b 40 08             	mov    0x8(%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 0c                	je     802533 <alloc_block_FF+0x13c>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 40 08             	mov    0x8(%eax),%eax
  80252d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802530:	89 50 0c             	mov    %edx,0xc(%eax)
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802539:	89 50 08             	mov    %edx,0x8(%eax)
  80253c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	89 50 0c             	mov    %edx,0xc(%eax)
  802545:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802548:	8b 40 08             	mov    0x8(%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 08                	jne    802557 <alloc_block_FF+0x160>
  80254f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802552:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802557:	a1 24 83 80 00       	mov    0x808324,%eax
  80255c:	40                   	inc    %eax
  80255d:	a3 24 83 80 00       	mov    %eax,0x808324
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	83 c0 10             	add    $0x10,%eax
  802568:	e9 9c 01 00 00       	jmp    802709 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	83 c0 10             	add    $0x10,%eax
  802573:	e9 91 01 00 00       	jmp    802709 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802578:	a1 20 83 80 00       	mov    0x808320,%eax
  80257d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802584:	74 08                	je     80258e <alloc_block_FF+0x197>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 08             	mov    0x8(%eax),%eax
  80258c:	eb 05                	jmp    802593 <alloc_block_FF+0x19c>
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	a3 20 83 80 00       	mov    %eax,0x808320
  802598:	a1 20 83 80 00       	mov    0x808320,%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	0f 85 c9 fe ff ff    	jne    80246e <alloc_block_FF+0x77>
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	0f 85 bf fe ff ff    	jne    80246e <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  8025af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025b3:	0f 85 4b 01 00 00    	jne    802704 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	50                   	push   %eax
  8025c0:	e8 5b f2 ff ff       	call   801820 <sbrk>
  8025c5:	83 c4 10             	add    $0x10,%esp
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	0f 84 28 01 00 00    	je     8026fd <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  8025db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025de:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e1:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  8025e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  8025ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025ee:	75 17                	jne    802607 <alloc_block_FF+0x210>
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	68 0c 3a 80 00       	push   $0x803a0c
  8025f8:	68 a1 00 00 00       	push   $0xa1
  8025fd:	68 bf 39 80 00       	push   $0x8039bf
  802602:	e8 84 df ff ff       	call   80058b <_panic>
  802607:	8b 15 1c 83 80 00    	mov    0x80831c,%edx
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	89 50 0c             	mov    %edx,0xc(%eax)
  802613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 0d                	je     80262a <alloc_block_FF+0x233>
  80261d:	a1 1c 83 80 00       	mov    0x80831c,%eax
  802622:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802625:	89 50 08             	mov    %edx,0x8(%eax)
  802628:	eb 08                	jmp    802632 <alloc_block_FF+0x23b>
  80262a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262d:	a3 18 83 80 00       	mov    %eax,0x808318
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	a3 1c 83 80 00       	mov    %eax,0x80831c
  80263a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802644:	a1 24 83 80 00       	mov    0x808324,%eax
  802649:	40                   	inc    %eax
  80264a:	a3 24 83 80 00       	mov    %eax,0x808324
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  80264f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802654:	2b 45 08             	sub    0x8(%ebp),%eax
  802657:	83 f8 0f             	cmp    $0xf,%eax
  80265a:	0f 86 95 00 00 00    	jbe    8026f5 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802660:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	01 d0                	add    %edx,%eax
  802668:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  80266b:	b8 00 10 00 00       	mov    $0x1000,%eax
  802670:	2b 45 08             	sub    0x8(%ebp),%eax
  802673:	89 c2                	mov    %eax,%edx
  802675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802678:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  80267a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80267d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802685:	74 06                	je     80268d <alloc_block_FF+0x296>
  802687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80268b:	75 17                	jne    8026a4 <alloc_block_FF+0x2ad>
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 d8 39 80 00       	push   $0x8039d8
  802695:	68 a6 00 00 00       	push   $0xa6
  80269a:	68 bf 39 80 00       	push   $0x8039bf
  80269f:	e8 e7 de ff ff       	call   80058b <_panic>
  8026a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a7:	8b 50 08             	mov    0x8(%eax),%edx
  8026aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ad:	89 50 08             	mov    %edx,0x8(%eax)
  8026b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b3:	8b 40 08             	mov    0x8(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0c                	je     8026c6 <alloc_block_FF+0x2cf>
  8026ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bd:	8b 40 08             	mov    0x8(%eax),%eax
  8026c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026c3:	89 50 0c             	mov    %edx,0xc(%eax)
  8026c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026cc:	89 50 08             	mov    %edx,0x8(%eax)
  8026cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d5:	89 50 0c             	mov    %edx,0xc(%eax)
  8026d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026db:	8b 40 08             	mov    0x8(%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	75 08                	jne    8026ea <alloc_block_FF+0x2f3>
  8026e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026e5:	a3 1c 83 80 00       	mov    %eax,0x80831c
  8026ea:	a1 24 83 80 00       	mov    0x808324,%eax
  8026ef:	40                   	inc    %eax
  8026f0:	a3 24 83 80 00       	mov    %eax,0x808324
			 }
			 return (sb + 1);
  8026f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f8:	83 c0 10             	add    $0x10,%eax
  8026fb:	eb 0c                	jmp    802709 <alloc_block_FF+0x312>
		 }
		 return NULL;
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802702:	eb 05                	jmp    802709 <alloc_block_FF+0x312>
	 }
	 return NULL;
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802711:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802715:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  80271c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802723:	a1 18 83 80 00       	mov    0x808318,%eax
  802728:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80272b:	eb 34                	jmp    802761 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  80272d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802730:	8a 40 04             	mov    0x4(%eax),%al
  802733:	84 c0                	test   %al,%al
  802735:	74 22                	je     802759 <alloc_block_BF+0x4e>
  802737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273f:	72 18                	jb     802759 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802749:	73 0e                	jae    802759 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  80274b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274e:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802759:	a1 20 83 80 00       	mov    0x808320,%eax
  80275e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802765:	74 08                	je     80276f <alloc_block_BF+0x64>
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	eb 05                	jmp    802774 <alloc_block_BF+0x69>
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	a3 20 83 80 00       	mov    %eax,0x808320
  802779:	a1 20 83 80 00       	mov    0x808320,%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	75 ab                	jne    80272d <alloc_block_BF+0x22>
  802782:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802786:	75 a5                	jne    80272d <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	0f 84 cb 00 00 00    	je     80285d <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a1:	0f 86 ae 00 00 00    	jbe    802855 <alloc_block_BF+0x14a>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8027af:	83 f8 0f             	cmp    $0xf,%eax
  8027b2:	0f 86 9d 00 00 00    	jbe    802855 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8027b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	01 d0                	add    %edx,%eax
  8027c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cb:	89 c2                	mov    %eax,%edx
  8027cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d0:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  8027d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8027df:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  8027e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e5:	74 06                	je     8027ed <alloc_block_BF+0xe2>
  8027e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027eb:	75 17                	jne    802804 <alloc_block_BF+0xf9>
  8027ed:	83 ec 04             	sub    $0x4,%esp
  8027f0:	68 d8 39 80 00       	push   $0x8039d8
  8027f5:	68 c6 00 00 00       	push   $0xc6
  8027fa:	68 bf 39 80 00       	push   $0x8039bf
  8027ff:	e8 87 dd ff ff       	call   80058b <_panic>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 50 08             	mov    0x8(%eax),%edx
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
  802810:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802813:	8b 40 08             	mov    0x8(%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 0c                	je     802826 <alloc_block_BF+0x11b>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802823:	89 50 0c             	mov    %edx,0xc(%eax)
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80282c:	89 50 08             	mov    %edx,0x8(%eax)
  80282f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802832:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802835:	89 50 0c             	mov    %edx,0xc(%eax)
  802838:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283b:	8b 40 08             	mov    0x8(%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	75 08                	jne    80284a <alloc_block_BF+0x13f>
  802842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802845:	a3 1c 83 80 00       	mov    %eax,0x80831c
  80284a:	a1 24 83 80 00       	mov    0x808324,%eax
  80284f:	40                   	inc    %eax
  802850:	a3 24 83 80 00       	mov    %eax,0x808324
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	83 c0 10             	add    $0x10,%eax
  80285b:	eb 05                	jmp    802862 <alloc_block_BF+0x157>
    }

    return NULL;
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 30 3a 80 00       	push   $0x803a30
  802872:	68 d2 00 00 00       	push   $0xd2
  802877:	68 bf 39 80 00       	push   $0x8039bf
  80287c:	e8 0a dd ff ff       	call   80058b <_panic>

00802881 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
  802884:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 58 3a 80 00       	push   $0x803a58
  80288f:	68 db 00 00 00       	push   $0xdb
  802894:	68 bf 39 80 00       	push   $0x8039bf
  802899:	e8 ed dc ff ff       	call   80058b <_panic>

0080289e <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
  8028a1:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  8028a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a8:	0f 84 d2 01 00 00    	je     802a80 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	83 e8 10             	sub    $0x10,%eax
  8028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8a 40 04             	mov    0x4(%eax),%al
  8028bd:	84 c0                	test   %al,%al
  8028bf:	0f 85 be 01 00 00    	jne    802a83 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 08             	mov    0x8(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	0f 84 cc 00 00 00    	je     8029a6 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 08             	mov    0x8(%eax),%eax
  8028e0:	8a 40 04             	mov    0x4(%eax),%al
  8028e3:	84 c0                	test   %al,%al
  8028e5:	0f 84 bb 00 00 00    	je     8029a6 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 10                	mov    (%eax),%edx
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 40 08             	mov    0x8(%eax),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	01 c2                	add    %eax,%edx
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 08             	mov    0x8(%eax),%eax
  802905:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 08             	mov    0x8(%eax),%eax
  80290f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 40 08             	mov    0x8(%eax),%eax
  80291b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  80291e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802922:	75 17                	jne    80293b <free_block+0x9d>
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 7e 3a 80 00       	push   $0x803a7e
  80292c:	68 f8 00 00 00       	push   $0xf8
  802931:	68 bf 39 80 00       	push   $0x8039bf
  802936:	e8 50 dc ff ff       	call   80058b <_panic>
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 08             	mov    0x8(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 11                	je     802956 <free_block+0xb8>
  802945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802948:	8b 40 08             	mov    0x8(%eax),%eax
  80294b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294e:	8b 52 0c             	mov    0xc(%edx),%edx
  802951:	89 50 0c             	mov    %edx,0xc(%eax)
  802954:	eb 0b                	jmp    802961 <free_block+0xc3>
  802956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802959:	8b 40 0c             	mov    0xc(%eax),%eax
  80295c:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 40 0c             	mov    0xc(%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 11                	je     80297c <free_block+0xde>
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802974:	8b 52 08             	mov    0x8(%edx),%edx
  802977:	89 50 08             	mov    %edx,0x8(%eax)
  80297a:	eb 0b                	jmp    802987 <free_block+0xe9>
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	8b 40 08             	mov    0x8(%eax),%eax
  802982:	a3 18 83 80 00       	mov    %eax,0x808318
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80299b:	a1 24 83 80 00       	mov    0x808324,%eax
  8029a0:	48                   	dec    %eax
  8029a1:	a3 24 83 80 00       	mov    %eax,0x808324
				}
			}
			if( LIST_PREV(block))
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	0f 84 d0 00 00 00    	je     802a84 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ba:	8a 40 04             	mov    0x4(%eax),%al
  8029bd:	84 c0                	test   %al,%al
  8029bf:	0f 84 bf 00 00 00    	je     802a84 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ce:	8b 52 0c             	mov    0xc(%edx),%edx
  8029d1:	8b 0a                	mov    (%edx),%ecx
  8029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d6:	8b 12                	mov    (%edx),%edx
  8029d8:	01 ca                	add    %ecx,%edx
  8029da:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	75 17                	jne    802a13 <free_block+0x175>
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	68 7e 3a 80 00       	push   $0x803a7e
  802a04:	68 03 01 00 00       	push   $0x103
  802a09:	68 bf 39 80 00       	push   $0x8039bf
  802a0e:	e8 78 db ff ff       	call   80058b <_panic>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 11                	je     802a2e <free_block+0x190>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 08             	mov    0x8(%eax),%eax
  802a23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a26:	8b 52 0c             	mov    0xc(%edx),%edx
  802a29:	89 50 0c             	mov    %edx,0xc(%eax)
  802a2c:	eb 0b                	jmp    802a39 <free_block+0x19b>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	74 11                	je     802a54 <free_block+0x1b6>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4c:	8b 52 08             	mov    0x8(%edx),%edx
  802a4f:	89 50 08             	mov    %edx,0x8(%eax)
  802a52:	eb 0b                	jmp    802a5f <free_block+0x1c1>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 08             	mov    0x8(%eax),%eax
  802a5a:	a3 18 83 80 00       	mov    %eax,0x808318
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802a73:	a1 24 83 80 00       	mov    0x808324,%eax
  802a78:	48                   	dec    %eax
  802a79:	a3 24 83 80 00       	mov    %eax,0x808324
  802a7e:	eb 04                	jmp    802a84 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802a80:	90                   	nop
  802a81:	eb 01                	jmp    802a84 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802a83:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802a84:	c9                   	leave  
  802a85:	c3                   	ret    

00802a86 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802a86:	55                   	push   %ebp
  802a87:	89 e5                	mov    %esp,%ebp
  802a89:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a90:	75 10                	jne    802aa2 <realloc_block_FF+0x1c>
  802a92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a96:	75 0a                	jne    802aa2 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802a98:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9d:	e9 2e 03 00 00       	jmp    802dd0 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802aa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa6:	75 13                	jne    802abb <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802aa8:	83 ec 0c             	sub    $0xc,%esp
  802aab:	ff 75 0c             	pushl  0xc(%ebp)
  802aae:	e8 44 f9 ff ff       	call   8023f7 <alloc_block_FF>
  802ab3:	83 c4 10             	add    $0x10,%esp
  802ab6:	e9 15 03 00 00       	jmp    802dd0 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  802abb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802abf:	75 18                	jne    802ad9 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  802ac1:	83 ec 0c             	sub    $0xc,%esp
  802ac4:	ff 75 08             	pushl  0x8(%ebp)
  802ac7:	e8 d2 fd ff ff       	call   80289e <free_block>
  802acc:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	e9 f7 02 00 00       	jmp    802dd0 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	83 e8 10             	sub    $0x10,%eax
  802adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  802ae2:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aee:	0f 82 c8 00 00 00    	jb     802bbc <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802afc:	75 08                	jne    802b06 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	e9 ca 02 00 00       	jmp    802dd0 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b0e:	83 f8 0f             	cmp    $0xf,%eax
  802b11:	0f 86 9d 00 00 00    	jbe    802bb4 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b1d:	01 d0                	add    %edx,%eax
  802b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b2a:	89 c2                	mov    %eax,%edx
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	74 06                	je     802b4c <realloc_block_FF+0xc6>
  802b46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4a:	75 17                	jne    802b63 <realloc_block_FF+0xdd>
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	68 d8 39 80 00       	push   $0x8039d8
  802b54:	68 2a 01 00 00       	push   $0x12a
  802b59:	68 bf 39 80 00       	push   $0x8039bf
  802b5e:	e8 28 da ff ff       	call   80058b <_panic>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 40 08             	mov    0x8(%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 0c                	je     802b85 <realloc_block_FF+0xff>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 08             	mov    0x8(%eax),%eax
  802b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b82:	89 50 0c             	mov    %edx,0xc(%eax)
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	89 50 08             	mov    %edx,0x8(%eax)
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b94:	89 50 0c             	mov    %edx,0xc(%eax)
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	75 08                	jne    802ba9 <realloc_block_FF+0x123>
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802ba9:	a1 24 83 80 00       	mov    0x808324,%eax
  802bae:	40                   	inc    %eax
  802baf:	a3 24 83 80 00       	mov    %eax,0x808324
	    	 }
	    	 return va;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	e9 14 02 00 00       	jmp    802dd0 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	0f 84 97 01 00 00    	je     802d61 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 08             	mov    0x8(%eax),%eax
  802bd0:	8a 40 04             	mov    0x4(%eax),%al
  802bd3:	84 c0                	test   %al,%al
  802bd5:	0f 84 86 01 00 00    	je     802d61 <realloc_block_FF+0x2db>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 10                	mov    (%eax),%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 08             	mov    0x8(%eax),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	01 d0                	add    %edx,%eax
  802bea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802bed:	0f 82 6e 01 00 00    	jb     802d61 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 10                	mov    (%eax),%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 40 08             	mov    0x8(%eax),%eax
  802c0d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 08             	mov    0x8(%eax),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  802c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c2a:	75 17                	jne    802c43 <realloc_block_FF+0x1bd>
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	68 7e 3a 80 00       	push   $0x803a7e
  802c34:	68 38 01 00 00       	push   $0x138
  802c39:	68 bf 39 80 00       	push   $0x8039bf
  802c3e:	e8 48 d9 ff ff       	call   80058b <_panic>
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 40 08             	mov    0x8(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 11                	je     802c5e <realloc_block_FF+0x1d8>
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
  802c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c56:	8b 52 0c             	mov    0xc(%edx),%edx
  802c59:	89 50 0c             	mov    %edx,0xc(%eax)
  802c5c:	eb 0b                	jmp    802c69 <realloc_block_FF+0x1e3>
  802c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c61:	8b 40 0c             	mov    0xc(%eax),%eax
  802c64:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 11                	je     802c84 <realloc_block_FF+0x1fe>
  802c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c76:	8b 40 0c             	mov    0xc(%eax),%eax
  802c79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7c:	8b 52 08             	mov    0x8(%edx),%edx
  802c7f:	89 50 08             	mov    %edx,0x8(%eax)
  802c82:	eb 0b                	jmp    802c8f <realloc_block_FF+0x209>
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	8b 40 08             	mov    0x8(%eax),%eax
  802c8a:	a3 18 83 80 00       	mov    %eax,0x808318
  802c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ca3:	a1 24 83 80 00       	mov    0x808324,%eax
  802ca8:	48                   	dec    %eax
  802ca9:	a3 24 83 80 00       	mov    %eax,0x808324
					 if(block->size - new_size >= sizeOfMetaData())
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	2b 45 0c             	sub    0xc(%ebp),%eax
  802cb6:	83 f8 0f             	cmp    $0xf,%eax
  802cb9:	0f 86 9d 00 00 00    	jbe    802d5c <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc5:	01 d0                	add    %edx,%eax
  802cc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	2b 45 0c             	sub    0xc(%ebp),%eax
  802cd2:	89 c2                	mov    %eax,%edx
  802cd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd7:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cdf:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  802ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cec:	74 06                	je     802cf4 <realloc_block_FF+0x26e>
  802cee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cf2:	75 17                	jne    802d0b <realloc_block_FF+0x285>
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	68 d8 39 80 00       	push   $0x8039d8
  802cfc:	68 3f 01 00 00       	push   $0x13f
  802d01:	68 bf 39 80 00       	push   $0x8039bf
  802d06:	e8 80 d8 ff ff       	call   80058b <_panic>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 50 08             	mov    0x8(%eax),%edx
  802d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
  802d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1a:	8b 40 08             	mov    0x8(%eax),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 0c                	je     802d2d <realloc_block_FF+0x2a7>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2a:	89 50 0c             	mov    %edx,0xc(%eax)
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d33:	89 50 08             	mov    %edx,0x8(%eax)
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
  802d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d42:	8b 40 08             	mov    0x8(%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	75 08                	jne    802d51 <realloc_block_FF+0x2cb>
  802d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4c:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802d51:	a1 24 83 80 00       	mov    0x808324,%eax
  802d56:	40                   	inc    %eax
  802d57:	a3 24 83 80 00       	mov    %eax,0x808324
					 }
					 return va;
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	eb 6f                	jmp    802dd0 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  802d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d64:	83 e8 10             	sub    $0x10,%eax
  802d67:	83 ec 0c             	sub    $0xc,%esp
  802d6a:	50                   	push   %eax
  802d6b:	e8 87 f6 ff ff       	call   8023f7 <alloc_block_FF>
  802d70:	83 c4 10             	add    $0x10,%esp
  802d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  802d76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d7a:	75 29                	jne    802da5 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  802d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	50                   	push   %eax
  802d83:	e8 98 ea ff ff       	call   801820 <sbrk>
  802d88:	83 c4 10             	add    $0x10,%esp
  802d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	83 f8 ff             	cmp    $0xffffffff,%eax
  802d94:	75 07                	jne    802d9d <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9b:	eb 33                	jmp    802dd0 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  802d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da0:	83 c0 10             	add    $0x10,%eax
  802da3:	eb 2b                	jmp    802dd0 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	83 ec 04             	sub    $0x4,%esp
  802dad:	50                   	push   %eax
  802dae:	ff 75 f4             	pushl  -0xc(%ebp)
  802db1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802db4:	e8 2f e3 ff ff       	call   8010e8 <memcpy>
  802db9:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  802dc2:	e8 d7 fa ff ff       	call   80289e <free_block>
  802dc7:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  802dd0:	c9                   	leave  
  802dd1:	c3                   	ret    
  802dd2:	66 90                	xchg   %ax,%ax

00802dd4 <__udivdi3>:
  802dd4:	55                   	push   %ebp
  802dd5:	57                   	push   %edi
  802dd6:	56                   	push   %esi
  802dd7:	53                   	push   %ebx
  802dd8:	83 ec 1c             	sub    $0x1c,%esp
  802ddb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802ddf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802de7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802deb:	89 ca                	mov    %ecx,%edx
  802ded:	89 f8                	mov    %edi,%eax
  802def:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802df3:	85 f6                	test   %esi,%esi
  802df5:	75 2d                	jne    802e24 <__udivdi3+0x50>
  802df7:	39 cf                	cmp    %ecx,%edi
  802df9:	77 65                	ja     802e60 <__udivdi3+0x8c>
  802dfb:	89 fd                	mov    %edi,%ebp
  802dfd:	85 ff                	test   %edi,%edi
  802dff:	75 0b                	jne    802e0c <__udivdi3+0x38>
  802e01:	b8 01 00 00 00       	mov    $0x1,%eax
  802e06:	31 d2                	xor    %edx,%edx
  802e08:	f7 f7                	div    %edi
  802e0a:	89 c5                	mov    %eax,%ebp
  802e0c:	31 d2                	xor    %edx,%edx
  802e0e:	89 c8                	mov    %ecx,%eax
  802e10:	f7 f5                	div    %ebp
  802e12:	89 c1                	mov    %eax,%ecx
  802e14:	89 d8                	mov    %ebx,%eax
  802e16:	f7 f5                	div    %ebp
  802e18:	89 cf                	mov    %ecx,%edi
  802e1a:	89 fa                	mov    %edi,%edx
  802e1c:	83 c4 1c             	add    $0x1c,%esp
  802e1f:	5b                   	pop    %ebx
  802e20:	5e                   	pop    %esi
  802e21:	5f                   	pop    %edi
  802e22:	5d                   	pop    %ebp
  802e23:	c3                   	ret    
  802e24:	39 ce                	cmp    %ecx,%esi
  802e26:	77 28                	ja     802e50 <__udivdi3+0x7c>
  802e28:	0f bd fe             	bsr    %esi,%edi
  802e2b:	83 f7 1f             	xor    $0x1f,%edi
  802e2e:	75 40                	jne    802e70 <__udivdi3+0x9c>
  802e30:	39 ce                	cmp    %ecx,%esi
  802e32:	72 0a                	jb     802e3e <__udivdi3+0x6a>
  802e34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802e38:	0f 87 9e 00 00 00    	ja     802edc <__udivdi3+0x108>
  802e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e43:	89 fa                	mov    %edi,%edx
  802e45:	83 c4 1c             	add    $0x1c,%esp
  802e48:	5b                   	pop    %ebx
  802e49:	5e                   	pop    %esi
  802e4a:	5f                   	pop    %edi
  802e4b:	5d                   	pop    %ebp
  802e4c:	c3                   	ret    
  802e4d:	8d 76 00             	lea    0x0(%esi),%esi
  802e50:	31 ff                	xor    %edi,%edi
  802e52:	31 c0                	xor    %eax,%eax
  802e54:	89 fa                	mov    %edi,%edx
  802e56:	83 c4 1c             	add    $0x1c,%esp
  802e59:	5b                   	pop    %ebx
  802e5a:	5e                   	pop    %esi
  802e5b:	5f                   	pop    %edi
  802e5c:	5d                   	pop    %ebp
  802e5d:	c3                   	ret    
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	89 d8                	mov    %ebx,%eax
  802e62:	f7 f7                	div    %edi
  802e64:	31 ff                	xor    %edi,%edi
  802e66:	89 fa                	mov    %edi,%edx
  802e68:	83 c4 1c             	add    $0x1c,%esp
  802e6b:	5b                   	pop    %ebx
  802e6c:	5e                   	pop    %esi
  802e6d:	5f                   	pop    %edi
  802e6e:	5d                   	pop    %ebp
  802e6f:	c3                   	ret    
  802e70:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e75:	89 eb                	mov    %ebp,%ebx
  802e77:	29 fb                	sub    %edi,%ebx
  802e79:	89 f9                	mov    %edi,%ecx
  802e7b:	d3 e6                	shl    %cl,%esi
  802e7d:	89 c5                	mov    %eax,%ebp
  802e7f:	88 d9                	mov    %bl,%cl
  802e81:	d3 ed                	shr    %cl,%ebp
  802e83:	89 e9                	mov    %ebp,%ecx
  802e85:	09 f1                	or     %esi,%ecx
  802e87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e8b:	89 f9                	mov    %edi,%ecx
  802e8d:	d3 e0                	shl    %cl,%eax
  802e8f:	89 c5                	mov    %eax,%ebp
  802e91:	89 d6                	mov    %edx,%esi
  802e93:	88 d9                	mov    %bl,%cl
  802e95:	d3 ee                	shr    %cl,%esi
  802e97:	89 f9                	mov    %edi,%ecx
  802e99:	d3 e2                	shl    %cl,%edx
  802e9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e9f:	88 d9                	mov    %bl,%cl
  802ea1:	d3 e8                	shr    %cl,%eax
  802ea3:	09 c2                	or     %eax,%edx
  802ea5:	89 d0                	mov    %edx,%eax
  802ea7:	89 f2                	mov    %esi,%edx
  802ea9:	f7 74 24 0c          	divl   0xc(%esp)
  802ead:	89 d6                	mov    %edx,%esi
  802eaf:	89 c3                	mov    %eax,%ebx
  802eb1:	f7 e5                	mul    %ebp
  802eb3:	39 d6                	cmp    %edx,%esi
  802eb5:	72 19                	jb     802ed0 <__udivdi3+0xfc>
  802eb7:	74 0b                	je     802ec4 <__udivdi3+0xf0>
  802eb9:	89 d8                	mov    %ebx,%eax
  802ebb:	31 ff                	xor    %edi,%edi
  802ebd:	e9 58 ff ff ff       	jmp    802e1a <__udivdi3+0x46>
  802ec2:	66 90                	xchg   %ax,%ax
  802ec4:	8b 54 24 08          	mov    0x8(%esp),%edx
  802ec8:	89 f9                	mov    %edi,%ecx
  802eca:	d3 e2                	shl    %cl,%edx
  802ecc:	39 c2                	cmp    %eax,%edx
  802ece:	73 e9                	jae    802eb9 <__udivdi3+0xe5>
  802ed0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ed3:	31 ff                	xor    %edi,%edi
  802ed5:	e9 40 ff ff ff       	jmp    802e1a <__udivdi3+0x46>
  802eda:	66 90                	xchg   %ax,%ax
  802edc:	31 c0                	xor    %eax,%eax
  802ede:	e9 37 ff ff ff       	jmp    802e1a <__udivdi3+0x46>
  802ee3:	90                   	nop

00802ee4 <__umoddi3>:
  802ee4:	55                   	push   %ebp
  802ee5:	57                   	push   %edi
  802ee6:	56                   	push   %esi
  802ee7:	53                   	push   %ebx
  802ee8:	83 ec 1c             	sub    $0x1c,%esp
  802eeb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802eef:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ef3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ef7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802efb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802eff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f03:	89 f3                	mov    %esi,%ebx
  802f05:	89 fa                	mov    %edi,%edx
  802f07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f0b:	89 34 24             	mov    %esi,(%esp)
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	75 1a                	jne    802f2c <__umoddi3+0x48>
  802f12:	39 f7                	cmp    %esi,%edi
  802f14:	0f 86 a2 00 00 00    	jbe    802fbc <__umoddi3+0xd8>
  802f1a:	89 c8                	mov    %ecx,%eax
  802f1c:	89 f2                	mov    %esi,%edx
  802f1e:	f7 f7                	div    %edi
  802f20:	89 d0                	mov    %edx,%eax
  802f22:	31 d2                	xor    %edx,%edx
  802f24:	83 c4 1c             	add    $0x1c,%esp
  802f27:	5b                   	pop    %ebx
  802f28:	5e                   	pop    %esi
  802f29:	5f                   	pop    %edi
  802f2a:	5d                   	pop    %ebp
  802f2b:	c3                   	ret    
  802f2c:	39 f0                	cmp    %esi,%eax
  802f2e:	0f 87 ac 00 00 00    	ja     802fe0 <__umoddi3+0xfc>
  802f34:	0f bd e8             	bsr    %eax,%ebp
  802f37:	83 f5 1f             	xor    $0x1f,%ebp
  802f3a:	0f 84 ac 00 00 00    	je     802fec <__umoddi3+0x108>
  802f40:	bf 20 00 00 00       	mov    $0x20,%edi
  802f45:	29 ef                	sub    %ebp,%edi
  802f47:	89 fe                	mov    %edi,%esi
  802f49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f4d:	89 e9                	mov    %ebp,%ecx
  802f4f:	d3 e0                	shl    %cl,%eax
  802f51:	89 d7                	mov    %edx,%edi
  802f53:	89 f1                	mov    %esi,%ecx
  802f55:	d3 ef                	shr    %cl,%edi
  802f57:	09 c7                	or     %eax,%edi
  802f59:	89 e9                	mov    %ebp,%ecx
  802f5b:	d3 e2                	shl    %cl,%edx
  802f5d:	89 14 24             	mov    %edx,(%esp)
  802f60:	89 d8                	mov    %ebx,%eax
  802f62:	d3 e0                	shl    %cl,%eax
  802f64:	89 c2                	mov    %eax,%edx
  802f66:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f6a:	d3 e0                	shl    %cl,%eax
  802f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f70:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f74:	89 f1                	mov    %esi,%ecx
  802f76:	d3 e8                	shr    %cl,%eax
  802f78:	09 d0                	or     %edx,%eax
  802f7a:	d3 eb                	shr    %cl,%ebx
  802f7c:	89 da                	mov    %ebx,%edx
  802f7e:	f7 f7                	div    %edi
  802f80:	89 d3                	mov    %edx,%ebx
  802f82:	f7 24 24             	mull   (%esp)
  802f85:	89 c6                	mov    %eax,%esi
  802f87:	89 d1                	mov    %edx,%ecx
  802f89:	39 d3                	cmp    %edx,%ebx
  802f8b:	0f 82 87 00 00 00    	jb     803018 <__umoddi3+0x134>
  802f91:	0f 84 91 00 00 00    	je     803028 <__umoddi3+0x144>
  802f97:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f9b:	29 f2                	sub    %esi,%edx
  802f9d:	19 cb                	sbb    %ecx,%ebx
  802f9f:	89 d8                	mov    %ebx,%eax
  802fa1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802fa5:	d3 e0                	shl    %cl,%eax
  802fa7:	89 e9                	mov    %ebp,%ecx
  802fa9:	d3 ea                	shr    %cl,%edx
  802fab:	09 d0                	or     %edx,%eax
  802fad:	89 e9                	mov    %ebp,%ecx
  802faf:	d3 eb                	shr    %cl,%ebx
  802fb1:	89 da                	mov    %ebx,%edx
  802fb3:	83 c4 1c             	add    $0x1c,%esp
  802fb6:	5b                   	pop    %ebx
  802fb7:	5e                   	pop    %esi
  802fb8:	5f                   	pop    %edi
  802fb9:	5d                   	pop    %ebp
  802fba:	c3                   	ret    
  802fbb:	90                   	nop
  802fbc:	89 fd                	mov    %edi,%ebp
  802fbe:	85 ff                	test   %edi,%edi
  802fc0:	75 0b                	jne    802fcd <__umoddi3+0xe9>
  802fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc7:	31 d2                	xor    %edx,%edx
  802fc9:	f7 f7                	div    %edi
  802fcb:	89 c5                	mov    %eax,%ebp
  802fcd:	89 f0                	mov    %esi,%eax
  802fcf:	31 d2                	xor    %edx,%edx
  802fd1:	f7 f5                	div    %ebp
  802fd3:	89 c8                	mov    %ecx,%eax
  802fd5:	f7 f5                	div    %ebp
  802fd7:	89 d0                	mov    %edx,%eax
  802fd9:	e9 44 ff ff ff       	jmp    802f22 <__umoddi3+0x3e>
  802fde:	66 90                	xchg   %ax,%ax
  802fe0:	89 c8                	mov    %ecx,%eax
  802fe2:	89 f2                	mov    %esi,%edx
  802fe4:	83 c4 1c             	add    $0x1c,%esp
  802fe7:	5b                   	pop    %ebx
  802fe8:	5e                   	pop    %esi
  802fe9:	5f                   	pop    %edi
  802fea:	5d                   	pop    %ebp
  802feb:	c3                   	ret    
  802fec:	3b 04 24             	cmp    (%esp),%eax
  802fef:	72 06                	jb     802ff7 <__umoddi3+0x113>
  802ff1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802ff5:	77 0f                	ja     803006 <__umoddi3+0x122>
  802ff7:	89 f2                	mov    %esi,%edx
  802ff9:	29 f9                	sub    %edi,%ecx
  802ffb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802fff:	89 14 24             	mov    %edx,(%esp)
  803002:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803006:	8b 44 24 04          	mov    0x4(%esp),%eax
  80300a:	8b 14 24             	mov    (%esp),%edx
  80300d:	83 c4 1c             	add    $0x1c,%esp
  803010:	5b                   	pop    %ebx
  803011:	5e                   	pop    %esi
  803012:	5f                   	pop    %edi
  803013:	5d                   	pop    %ebp
  803014:	c3                   	ret    
  803015:	8d 76 00             	lea    0x0(%esi),%esi
  803018:	2b 04 24             	sub    (%esp),%eax
  80301b:	19 fa                	sbb    %edi,%edx
  80301d:	89 d1                	mov    %edx,%ecx
  80301f:	89 c6                	mov    %eax,%esi
  803021:	e9 71 ff ff ff       	jmp    802f97 <__umoddi3+0xb3>
  803026:	66 90                	xchg   %ax,%ax
  803028:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80302c:	72 ea                	jb     803018 <__umoddi3+0x134>
  80302e:	89 d9                	mov    %ebx,%ecx
  803030:	e9 62 ff ff ff       	jmp    802f97 <__umoddi3+0xb3>
