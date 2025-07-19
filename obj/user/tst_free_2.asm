
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 28 0d 00 00       	call   800d5e <libmain>
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
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800042:	83 ec 0c             	sub    $0xc,%esp
  800045:	6a 01                	push   $0x1
  800047:	e8 a4 29 00 00       	call   8029f0 <sys_set_uheap_strategy>
  80004c:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004f:	a1 40 50 80 00       	mov    0x805040,%eax
  800054:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  80005a:	a1 40 50 80 00       	mov    0x805040,%eax
  80005f:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800065:	39 c2                	cmp    %eax,%edx
  800067:	72 14                	jb     80007d <_main+0x45>
			panic("Please increase the WS size");
  800069:	83 ec 04             	sub    $0x4,%esp
  80006c:	68 40 39 80 00       	push   $0x803940
  800071:	6a 22                	push   $0x22
  800073:	68 5c 39 80 00       	push   $0x80395c
  800078:	e8 18 0e 00 00       	call   800e95 <_panic>
	}
	/*=================================================*/

	int eval = 0;
  80007d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800084:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80008b:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  800092:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800099:	e8 dd 24 00 00       	call   80257b <sys_pf_calculate_allocated_pages>
  80009e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000a1:	e8 8a 24 00 00       	call   802530 <sys_calculate_free_frames>
  8000a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 actualSize, block_size, expectedSize, blockIndex;
	int8 block_status;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 70 39 80 00       	push   $0x803970
  8000b1:	e8 9c 10 00 00       	call   801152 <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000c0:	c7 45 e8 00 00 00 80 	movl   $0x80000000,-0x18(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000ce:	e9 e7 00 00 00       	jmp    8001ba <_main+0x182>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8000da:	e9 cb 00 00 00       	jmp    8001aa <_main+0x172>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8000e9:	83 e8 10             	sub    $0x10,%eax
  8000ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx++] = malloc(actualSize);
  8000ef:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000f2:	8d 43 01             	lea    0x1(%ebx),%eax
  8000f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	ff 75 bc             	pushl  -0x44(%ebp)
  8000fe:	e8 3d 20 00 00       	call   802140 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 04 9d 20 51 80 00 	mov    %eax,0x805120(,%ebx,4)
  80010d:	8b 04 9d 20 51 80 00 	mov    0x805120(,%ebx,4),%eax
  800114:	89 45 b8             	mov    %eax,-0x48(%ebp)
				//				if (j == 0)
				//					cprintf("first va of size %x = %x\n",allocSizes[i], va);

				//Check returned va
				if(va == NULL || (va < curVA))
  800117:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80011b:	74 08                	je     800125 <_main+0xed>
  80011d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800120:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800123:	73 2e                	jae    800153 <_main+0x11b>
				{
					if (is_correct)
  800125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800129:	74 28                	je     800153 <_main+0x11b>
					{
						is_correct = 0;
  80012b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
						panic("malloc() #0.%d: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	83 c0 10             	add    $0x10,%eax
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	ff 75 b8             	pushl  -0x48(%ebp)
  80013e:	50                   	push   %eax
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	68 c8 39 80 00       	push   $0x8039c8
  800147:	6a 47                	push   $0x47
  800149:	68 5c 39 80 00       	push   $0x80395c
  80014e:	e8 42 0d 00 00       	call   800e95 <_panic>
					}
				}
				curVA += allocSizes[i] ;
  800153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800156:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80015d:	01 45 e8             	add    %eax,-0x18(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800160:	c7 45 b4 00 10 00 00 	movl   $0x1000,-0x4c(%ebp)
  800167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80016a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80016d:	01 d0                	add    %edx,%eax
  80016f:	48                   	dec    %eax
  800170:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800173:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800176:	ba 00 00 00 00       	mov    $0x0,%edx
  80017b:	f7 75 b4             	divl   -0x4c(%ebp)
  80017e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800181:	29 d0                	sub    %edx,%eax
  800183:	89 45 ac             	mov    %eax,-0x54(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800186:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018c:	29 c2                	sub    %eax,%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  800193:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  800197:	7e 0e                	jle    8001a7 <_main+0x16f>
  800199:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80019c:	83 f8 0f             	cmp    $0xf,%eax
  80019f:	77 06                	ja     8001a7 <_main+0x16f>
				{
					curVA = rounded_curVA;
  8001a1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001a7:	ff 45 e0             	incl   -0x20(%ebp)
  8001aa:	81 7d e0 c7 00 00 00 	cmpl   $0xc7,-0x20(%ebp)
  8001b1:	0f 8e 28 ff ff ff    	jle    8000df <_main+0xa7>
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001b7:	ff 45 e4             	incl   -0x1c(%ebp)
  8001ba:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001be:	0f 8e 0f ff ff ff    	jle    8000d3 <_main+0x9b>
			//if (is_correct == 0)
			//break;
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  8001c4:	e8 67 23 00 00       	call   802530 <sys_calculate_free_frames>
  8001c9:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 24 3a 80 00       	push   $0x803a24
  8001d4:	e8 79 0f 00 00       	call   801152 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8001dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8001e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ea:	eb 2c                	jmp    800218 <_main+0x1e0>
		{
			free(startVAs[i*allocCntPerSize]);
  8001ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001ef:	89 d0                	mov    %edx,%eax
  8001f1:	c1 e0 02             	shl    $0x2,%eax
  8001f4:	01 d0                	add    %edx,%eax
  8001f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fd:	01 d0                	add    %edx,%eax
  8001ff:	c1 e0 03             	shl    $0x3,%eax
  800202:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	50                   	push   %eax
  80020d:	e8 8e 20 00 00       	call   8022a0 <free>
  800212:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  800215:	ff 45 dc             	incl   -0x24(%ebp)
  800218:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  80021c:	7e ce                	jle    8001ec <_main+0x1b4>
		{
			free(startVAs[i*allocCntPerSize]);
		}

		//Free block before last
		free(startVAs[numOfAllocs*allocCntPerSize - 2]);
  80021e:	a1 f8 66 80 00       	mov    0x8066f8,%eax
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	50                   	push   %eax
  800227:	e8 74 20 00 00       	call   8022a0 <free>
  80022c:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[numOfAllocs*allocCntPerSize - 2]) ;
  80022f:	a1 f8 66 80 00       	mov    0x8066f8,%eax
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	50                   	push   %eax
  800238:	e8 b9 28 00 00       	call   802af6 <get_block_size>
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (block_size != allocSizes[numOfAllocs-1])
  800243:	a1 18 50 80 00       	mov    0x805018,%eax
  800248:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80024b:	74 20                	je     80026d <_main+0x235>
		{
			is_correct = 0;
  80024d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",allocSizes[numOfAllocs-1],block_size);
  800254:	a1 18 50 80 00       	mov    0x805018,%eax
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80025f:	50                   	push   %eax
  800260:	68 6c 3a 80 00       	push   $0x803a6c
  800265:	e8 e8 0e 00 00       	call   801152 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[numOfAllocs*allocCntPerSize-2]) ;
  80026d:	a1 f8 66 80 00       	mov    0x8066f8,%eax
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	50                   	push   %eax
  800276:	e8 91 28 00 00       	call   802b0c <is_free_block>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800281:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800285:	74 17                	je     80029e <_main+0x266>
		{
			is_correct = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	68 c8 3a 80 00       	push   $0x803ac8
  800296:	e8 b7 0e 00 00       	call   801152 <cprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
		}

		//Reallocate first block
		actualSize = allocSizes[0] - sizeOfMetaData();
  80029e:	a1 00 50 80 00       	mov    0x805000,%eax
  8002a3:	83 e8 10             	sub    $0x10,%eax
  8002a6:	89 45 9c             	mov    %eax,-0x64(%ebp)
		va = malloc(actualSize);
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	ff 75 9c             	pushl  -0x64(%ebp)
  8002af:	e8 8c 1e 00 00       	call   802140 <malloc>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		if(va == NULL || (va != (void*)(USER_HEAP_START + sizeOfMetaData())))
  8002ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8002be:	74 09                	je     8002c9 <_main+0x291>
  8002c0:	81 7d b8 10 00 00 80 	cmpl   $0x80000010,-0x48(%ebp)
  8002c7:	74 17                	je     8002e0 <_main+0x2a8>
		{
			is_correct = 0;
  8002c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.3: WRONG ALLOC - alloc_block_FF return wrong address.\n");
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 1c 3b 80 00       	push   $0x803b1c
  8002d8:	e8 75 0e 00 00       	call   801152 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
		}

		//Free 2nd block
		free(startVAs[1]);
  8002e0:	a1 24 51 80 00       	mov    0x805124,%eax
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	50                   	push   %eax
  8002e9:	e8 b2 1f 00 00       	call   8022a0 <free>
  8002ee:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[1]) ;
  8002f1:	a1 24 51 80 00       	mov    0x805124,%eax
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	50                   	push   %eax
  8002fa:	e8 f7 27 00 00       	call   802af6 <get_block_size>
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (block_size != allocSizes[0])
  800305:	a1 00 50 80 00       	mov    0x805000,%eax
  80030a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80030d:	74 20                	je     80032f <_main+0x2f7>
		{
			is_correct = 0;
  80030f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.4: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",allocSizes[0],block_size);
  800316:	a1 00 50 80 00       	mov    0x805000,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	ff 75 a4             	pushl  -0x5c(%ebp)
  800321:	50                   	push   %eax
  800322:	68 64 3b 80 00       	push   $0x803b64
  800327:	e8 26 0e 00 00       	call   801152 <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[1]) ;
  80032f:	a1 24 51 80 00       	mov    0x805124,%eax
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	e8 cf 27 00 00       	call   802b0c <is_free_block>
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800343:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800347:	74 17                	je     800360 <_main+0x328>
		{
			is_correct = 0;
  800349:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #1.5: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 c0 3b 80 00       	push   $0x803bc0
  800358:	e8 f5 0d 00 00       	call   801152 <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800364:	74 04                	je     80036a <_main+0x332>
		{
			eval += 10;
  800366:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*free Scenario 2: Merge with previous ONLY (AT the tail)*/
	cprintf("2: Free some allocated blocks [Merge with previous ONLY]\n\n") ;
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 14 3c 80 00       	push   $0x803c14
  800372:	e8 db 0d 00 00       	call   801152 <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	68 4f 3c 80 00       	push   $0x803c4f
  800382:	e8 cb 0d 00 00       	call   801152 <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  80038a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last block (coalesce with previous)
		blockIndex = numOfAllocs*allocCntPerSize-1;
  800391:	c7 45 98 77 05 00 00 	movl   $0x577,-0x68(%ebp)
		free(startVAs[blockIndex]);
  800398:	8b 45 98             	mov    -0x68(%ebp),%eax
  80039b:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	50                   	push   %eax
  8003a6:	e8 f5 1e 00 00       	call   8022a0 <free>
  8003ab:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8003ae:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003b1:	48                   	dec    %eax
  8003b2:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	50                   	push   %eax
  8003bd:	e8 34 27 00 00       	call   802af6 <get_block_size>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = 2*allocSizes[numOfAllocs-1];
  8003c8:	a1 18 50 80 00       	mov    0x805018,%eax
  8003cd:	01 c0                	add    %eax,%eax
  8003cf:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8003d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d5:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8003d8:	74 1d                	je     8003f7 <_main+0x3bf>
		{
			is_correct = 0;
  8003da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n", expectedSize,block_size);
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003e7:	ff 75 94             	pushl  -0x6c(%ebp)
  8003ea:	68 64 3c 80 00       	push   $0x803c64
  8003ef:	e8 5e 0d 00 00       	call   801152 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8003f7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003fa:	48                   	dec    %eax
  8003fb:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800402:	83 ec 0c             	sub    $0xc,%esp
  800405:	50                   	push   %eax
  800406:	e8 01 27 00 00       	call   802b0c <is_free_block>
  80040b:	83 c4 10             	add    $0x10,%esp
  80040e:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  800411:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800415:	74 17                	je     80042e <_main+0x3f6>
		{
			is_correct = 0;
  800417:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80041e:	83 ec 0c             	sub    $0xc,%esp
  800421:	68 c4 3c 80 00       	push   $0x803cc4
  800426:	e8 27 0d 00 00       	call   801152 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80042e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800431:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	50                   	push   %eax
  80043c:	e8 b5 26 00 00       	call   802af6 <get_block_size>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	85 c0                	test   %eax,%eax
  800446:	75 1a                	jne    800462 <_main+0x42a>
  800448:	8b 45 98             	mov    -0x68(%ebp),%eax
  80044b:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800452:	83 ec 0c             	sub    $0xc,%esp
  800455:	50                   	push   %eax
  800456:	e8 b1 26 00 00       	call   802b0c <is_free_block>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	84 c0                	test   %al,%al
  800460:	74 17                	je     800479 <_main+0x441>
		{
			is_correct = 0;
  800462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	68 18 3d 80 00       	push   $0x803d18
  800471:	e8 dc 0c 00 00       	call   801152 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	68 80 3d 80 00       	push   $0x803d80
  800481:	e8 cc 0c 00 00       	call   801152 <cprintf>
  800486:	83 c4 10             	add    $0x10,%esp
		blockIndex = 2*allocCntPerSize+1 ;
  800489:	c7 45 98 91 01 00 00 	movl   $0x191,-0x68(%ebp)
		free(startVAs[blockIndex]);
  800490:	8b 45 98             	mov    -0x68(%ebp),%eax
  800493:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	50                   	push   %eax
  80049e:	e8 fd 1d 00 00       	call   8022a0 <free>
  8004a3:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8004a6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004a9:	48                   	dec    %eax
  8004aa:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	50                   	push   %eax
  8004b5:	e8 3c 26 00 00       	call   802af6 <get_block_size>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[2]+allocSizes[2];
  8004c0:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8004c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8004d0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004d3:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8004d6:	74 1d                	je     8004f5 <_main+0x4bd>
		{
			is_correct = 0;
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #2.2.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8004e5:	ff 75 94             	pushl  -0x6c(%ebp)
  8004e8:	68 9c 3d 80 00       	push   $0x803d9c
  8004ed:	e8 60 0c 00 00       	call   801152 <cprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  8004f5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8004f8:	48                   	dec    %eax
  8004f9:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	50                   	push   %eax
  800504:	e8 03 26 00 00       	call   802b0c <is_free_block>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80050f:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800513:	74 17                	je     80052c <_main+0x4f4>
		{
			is_correct = 0;
  800515:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.2.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80051c:	83 ec 0c             	sub    $0xc,%esp
  80051f:	68 fc 3d 80 00       	push   $0x803dfc
  800524:	e8 29 0c 00 00       	call   801152 <cprintf>
  800529:	83 c4 10             	add    $0x10,%esp
		}

		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0)
  80052c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80052f:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	50                   	push   %eax
  80053a:	e8 b7 25 00 00       	call   802af6 <get_block_size>
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 c0                	test   %eax,%eax
  800544:	75 1a                	jne    800560 <_main+0x528>
  800546:	8b 45 98             	mov    -0x68(%ebp),%eax
  800549:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 b3 25 00 00       	call   802b0c <is_free_block>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	84 c0                	test   %al,%al
  80055e:	74 17                	je     800577 <_main+0x53f>
		{
			is_correct = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #2.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	68 50 3e 80 00       	push   $0x803e50
  80056f:	e8 de 0b 00 00       	call   801152 <cprintf>
  800574:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80057b:	74 04                	je     800581 <_main+0x549>
		{
			eval += 10;
  80057d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}


	//====================================================================//
	/*free Scenario 4: Merge with next ONLY (AT the head)*/
	cprintf("3: Free some allocated blocks [Merge with next ONLY]\n\n") ;
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	68 b8 3e 80 00       	push   $0x803eb8
  800589:	e8 c4 0b 00 00       	call   801152 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	68 ef 3e 80 00       	push   $0x803eef
  800599:	e8 b4 0b 00 00       	call   801152 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8005a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		blockIndex = 0 ;
  8005a8:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8005af:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b2:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8005b9:	83 ec 0c             	sub    $0xc,%esp
  8005bc:	50                   	push   %eax
  8005bd:	e8 de 1c 00 00       	call   8022a0 <free>
  8005c2:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8005c5:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005c8:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8005cf:	83 ec 0c             	sub    $0xc,%esp
  8005d2:	50                   	push   %eax
  8005d3:	e8 1e 25 00 00       	call   802af6 <get_block_size>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[0]+allocSizes[0];
  8005de:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8005e4:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e9:	01 d0                	add    %edx,%eax
  8005eb:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8005ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8005f1:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8005f4:	74 1d                	je     800613 <_main+0x5db>
		{
			is_correct = 0;
  8005f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #3.1.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8005fd:	83 ec 04             	sub    $0x4,%esp
  800600:	ff 75 a4             	pushl  -0x5c(%ebp)
  800603:	ff 75 94             	pushl  -0x6c(%ebp)
  800606:	68 04 3f 80 00       	push   $0x803f04
  80060b:	e8 42 0b 00 00       	call   801152 <cprintf>
  800610:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800613:	8b 45 98             	mov    -0x68(%ebp),%eax
  800616:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  80061d:	83 ec 0c             	sub    $0xc,%esp
  800620:	50                   	push   %eax
  800621:	e8 e6 24 00 00       	call   802b0c <is_free_block>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80062c:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800630:	74 17                	je     800649 <_main+0x611>
		{
			is_correct = 0;
  800632:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.1.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	68 64 3f 80 00       	push   $0x803f64
  800641:	e8 0c 0b 00 00       	call   801152 <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800649:	8b 45 98             	mov    -0x68(%ebp),%eax
  80064c:	40                   	inc    %eax
  80064d:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800654:	83 ec 0c             	sub    $0xc,%esp
  800657:	50                   	push   %eax
  800658:	e8 99 24 00 00       	call   802af6 <get_block_size>
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	85 c0                	test   %eax,%eax
  800662:	75 1b                	jne    80067f <_main+0x647>
  800664:	8b 45 98             	mov    -0x68(%ebp),%eax
  800667:	40                   	inc    %eax
  800668:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	e8 94 24 00 00       	call   802b0c <is_free_block>
  800678:	83 c4 10             	add    $0x10,%esp
  80067b:	84 c0                	test   %al,%al
  80067d:	74 17                	je     800696 <_main+0x65e>
		{
			is_correct = 0;
  80067f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.1.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800686:	83 ec 0c             	sub    $0xc,%esp
  800689:	68 b8 3f 80 00       	push   $0x803fb8
  80068e:	e8 bf 0a 00 00       	call   801152 <cprintf>
  800693:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	68 20 40 80 00       	push   $0x804020
  80069e:	e8 af 0a 00 00       	call   801152 <cprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
		blockIndex = 1*allocCntPerSize - 1 ;
  8006a6:	c7 45 98 c7 00 00 00 	movl   $0xc7,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8006ad:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006b0:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	50                   	push   %eax
  8006bb:	e8 e0 1b 00 00       	call   8022a0 <free>
  8006c0:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  8006c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006c6:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	50                   	push   %eax
  8006d1:	e8 20 24 00 00       	call   802af6 <get_block_size>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[0]+allocSizes[1];
  8006dc:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8006e2:	a1 04 50 80 00       	mov    0x805004,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  8006ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006ef:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  8006f2:	74 1d                	je     800711 <_main+0x6d9>
		{
			is_correct = 0;
  8006f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #3.2.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	ff 75 a4             	pushl  -0x5c(%ebp)
  800701:	ff 75 94             	pushl  -0x6c(%ebp)
  800704:	68 3c 40 80 00       	push   $0x80403c
  800709:	e8 44 0a 00 00       	call   801152 <cprintf>
  80070e:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex]) ;
  800711:	8b 45 98             	mov    -0x68(%ebp),%eax
  800714:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	50                   	push   %eax
  80071f:	e8 e8 23 00 00       	call   802b0c <is_free_block>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80072a:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  80072e:	74 17                	je     800747 <_main+0x70f>
		{
			is_correct = 0;
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.2.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	68 9c 40 80 00       	push   $0x80409c
  80073f:	e8 0e 0a 00 00       	call   801152 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  800747:	8b 45 98             	mov    -0x68(%ebp),%eax
  80074a:	40                   	inc    %eax
  80074b:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	50                   	push   %eax
  800756:	e8 9b 23 00 00       	call   802af6 <get_block_size>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	85 c0                	test   %eax,%eax
  800760:	75 1b                	jne    80077d <_main+0x745>
  800762:	8b 45 98             	mov    -0x68(%ebp),%eax
  800765:	40                   	inc    %eax
  800766:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	50                   	push   %eax
  800771:	e8 96 23 00 00       	call   802b0c <is_free_block>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	84 c0                	test   %al,%al
  80077b:	74 17                	je     800794 <_main+0x75c>
		{
			is_correct = 0;
  80077d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #3.2.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	68 f0 40 80 00       	push   $0x8040f0
  80078c:	e8 c1 09 00 00       	call   801152 <cprintf>
  800791:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800798:	74 04                	je     80079e <_main+0x766>
		{
			eval += 10;
  80079a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}
	//====================================================================//
	/*free Scenario 6: Merge with prev & next */
	cprintf("4: Free some allocated blocks [Merge with previous & next]\n\n") ;
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	68 58 41 80 00       	push   $0x804158
  8007a6:	e8 a7 09 00 00       	call   801152 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8007ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		blockIndex = 4*allocCntPerSize - 2 ;
  8007b5:	c7 45 98 1e 03 00 00 	movl   $0x31e,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8007bc:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007bf:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8007c6:	83 ec 0c             	sub    $0xc,%esp
  8007c9:	50                   	push   %eax
  8007ca:	e8 d1 1a 00 00       	call   8022a0 <free>
  8007cf:	83 c4 10             	add    $0x10,%esp

		blockIndex = 4*allocCntPerSize - 1 ;
  8007d2:	c7 45 98 1f 03 00 00 	movl   $0x31f,-0x68(%ebp)
		free(startVAs[blockIndex]);
  8007d9:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007dc:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	50                   	push   %eax
  8007e7:	e8 b4 1a 00 00       	call   8022a0 <free>
  8007ec:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  8007ef:	8b 45 98             	mov    -0x68(%ebp),%eax
  8007f2:	48                   	dec    %eax
  8007f3:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 f3 22 00 00       	call   802af6 <get_block_size>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		expectedSize = allocSizes[3]+allocSizes[3]+allocSizes[4];
  800809:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80080f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800814:	01 c2                	add    %eax,%edx
  800816:	a1 10 50 80 00       	mov    0x805010,%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (block_size != expectedSize)
  800820:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800823:	3b 45 94             	cmp    -0x6c(%ebp),%eax
  800826:	74 1d                	je     800845 <_main+0x80d>
		{
			is_correct = 0;
  800828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf	("test_free_2 #4.1: WRONG FREE! block size after free is not correct. Expected %d, Actual %d\n",expectedSize,block_size);
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 a4             	pushl  -0x5c(%ebp)
  800835:	ff 75 94             	pushl  -0x6c(%ebp)
  800838:	68 98 41 80 00       	push   $0x804198
  80083d:	e8 10 09 00 00       	call   801152 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
		}
		block_status = is_free_block(startVAs[blockIndex-1]) ;
  800845:	8b 45 98             	mov    -0x68(%ebp),%eax
  800848:	48                   	dec    %eax
  800849:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800850:	83 ec 0c             	sub    $0xc,%esp
  800853:	50                   	push   %eax
  800854:	e8 b3 22 00 00       	call   802b0c <is_free_block>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	88 45 a3             	mov    %al,-0x5d(%ebp)
		if (block_status != 1)
  80085f:	80 7d a3 01          	cmpb   $0x1,-0x5d(%ebp)
  800863:	74 17                	je     80087c <_main+0x844>
		{
			is_correct = 0;
  800865:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #4.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
  80086c:	83 ec 0c             	sub    $0xc,%esp
  80086f:	68 f4 41 80 00       	push   $0x8041f4
  800874:	e8 d9 08 00 00       	call   801152 <cprintf>
  800879:	83 c4 10             	add    $0x10,%esp
		}
		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0 ||
  80087c:	8b 45 98             	mov    -0x68(%ebp),%eax
  80087f:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	50                   	push   %eax
  80088a:	e8 67 22 00 00       	call   802af6 <get_block_size>
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	85 c0                	test   %eax,%eax
  800894:	75 50                	jne    8008e6 <_main+0x8ae>
  800896:	8b 45 98             	mov    -0x68(%ebp),%eax
  800899:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	50                   	push   %eax
  8008a4:	e8 63 22 00 00       	call   802b0c <is_free_block>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	84 c0                	test   %al,%al
  8008ae:	75 36                	jne    8008e6 <_main+0x8ae>
				get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  8008b0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008b3:	40                   	inc    %eax
  8008b4:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 32 22 00 00       	call   802af6 <get_block_size>
  8008c4:	83 c4 10             	add    $0x10,%esp
		if (block_status != 1)
		{
			is_correct = 0;
			cprintf("test_free_2 #4.2: WRONG FREE! block status (is_free) not equal 1 after freeing.\n");
		}
		if (get_block_size(startVAs[blockIndex]) != 0 || is_free_block(startVAs[blockIndex]) != 0 ||
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	75 1b                	jne    8008e6 <_main+0x8ae>
				get_block_size(startVAs[blockIndex+1]) != 0 || is_free_block(startVAs[blockIndex+1]) != 0)
  8008cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008ce:	40                   	inc    %eax
  8008cf:	8b 04 85 20 51 80 00 	mov    0x805120(,%eax,4),%eax
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	50                   	push   %eax
  8008da:	e8 2d 22 00 00       	call   802b0c <is_free_block>
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	84 c0                	test   %al,%al
  8008e4:	74 17                	je     8008fd <_main+0x8c5>
		{
			is_correct = 0;
  8008e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #4.3: WRONG FREE! make sure to ZEROing the size & is_free values of the vanishing block.\n");
  8008ed:	83 ec 0c             	sub    $0xc,%esp
  8008f0:	68 48 42 80 00       	push   $0x804248
  8008f5:	e8 58 08 00 00       	call   801152 <cprintf>
  8008fa:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800901:	74 04                	je     800907 <_main+0x8cf>
		{
			eval += 20;
  800903:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}


	//====================================================================//
	/*Allocate After Free Scenarios */
	cprintf("5: Allocate After Free [should be placed in coalesced blocks]\n\n") ;
  800907:	83 ec 0c             	sub    $0xc,%esp
  80090a:	68 b0 42 80 00       	push   $0x8042b0
  80090f:	e8 3e 08 00 00       	call   801152 <cprintf>
  800914:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  800917:	83 ec 0c             	sub    $0xc,%esp
  80091a:	68 f0 42 80 00       	push   $0x8042f0
  80091f:	e8 2e 08 00 00       	call   801152 <cprintf>
  800924:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800927:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 4*sizeof(int);
  80092e:	c7 45 9c 10 00 00 00 	movl   $0x10,-0x64(%ebp)
		va = malloc(actualSize);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	ff 75 9c             	pushl  -0x64(%ebp)
  80093b:	e8 00 18 00 00       	call   802140 <malloc>
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		void* expected = (void*)(USER_HEAP_START + sizeOfMetaData());
  800946:	c7 45 90 10 00 00 80 	movl   $0x80000010,-0x70(%ebp)
		if(va == NULL || (va != expected))
  80094d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800951:	74 08                	je     80095b <_main+0x923>
  800953:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800956:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800959:	74 1d                	je     800978 <_main+0x940>
		{
			is_correct = 0;
  80095b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.1: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	ff 75 b8             	pushl  -0x48(%ebp)
  800968:	ff 75 90             	pushl  -0x70(%ebp)
  80096b:	68 18 43 80 00       	push   $0x804318
  800970:	e8 dd 07 00 00       	call   801152 <cprintf>
  800975:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 2*sizeof(int) ;
  800978:	c7 45 9c 08 00 00 00 	movl   $0x8,-0x64(%ebp)
		va = malloc(actualSize);
  80097f:	83 ec 0c             	sub    $0xc,%esp
  800982:	ff 75 9c             	pushl  -0x64(%ebp)
  800985:	e8 b6 17 00 00       	call   802140 <malloc>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = (void*)(USER_HEAP_START + sizeOfMetaData() + 4*sizeof(int) + sizeOfMetaData());
  800990:	c7 45 90 30 00 00 80 	movl   $0x80000030,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800997:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80099b:	74 08                	je     8009a5 <_main+0x96d>
  80099d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009a0:	3b 45 90             	cmp    -0x70(%ebp),%eax
  8009a3:	74 1d                	je     8009c2 <_main+0x98a>
		{
			is_correct = 0;
  8009a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	ff 75 b8             	pushl  -0x48(%ebp)
  8009b2:	ff 75 90             	pushl  -0x70(%ebp)
  8009b5:	68 78 43 80 00       	push   $0x804378
  8009ba:	e8 93 07 00 00       	call   801152 <cprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 5*sizeof(int);
  8009c2:	c7 45 9c 14 00 00 00 	movl   $0x14,-0x64(%ebp)
		va = malloc(actualSize);
  8009c9:	83 ec 0c             	sub    $0xc,%esp
  8009cc:	ff 75 9c             	pushl  -0x64(%ebp)
  8009cf:	e8 6c 17 00 00       	call   802140 <malloc>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[1*allocCntPerSize - 1];
  8009da:	a1 3c 54 80 00       	mov    0x80543c,%eax
  8009df:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  8009e2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8009e6:	74 08                	je     8009f0 <_main+0x9b8>
  8009e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009eb:	3b 45 90             	cmp    -0x70(%ebp),%eax
  8009ee:	74 1d                	je     800a0d <_main+0x9d5>
		{
			is_correct = 0;
  8009f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.1.3: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  8009f7:	83 ec 04             	sub    $0x4,%esp
  8009fa:	ff 75 b8             	pushl  -0x48(%ebp)
  8009fd:	ff 75 90             	pushl  -0x70(%ebp)
  800a00:	68 d8 43 80 00       	push   $0x8043d8
  800a05:	e8 48 07 00 00       	call   801152 <cprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a11:	74 04                	je     800a17 <_main+0x9df>
		{
			eval += 10;
  800a13:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		cprintf("	5.2: in block coalesces with PREV & NEXT\n\n") ;
  800a17:	83 ec 0c             	sub    $0xc,%esp
  800a1a:	68 38 44 80 00       	push   $0x804438
  800a1f:	e8 2e 07 00 00       	call   801152 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a27:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 3*kilo/2;
  800a2e:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800a35:	83 ec 0c             	sub    $0xc,%esp
  800a38:	ff 75 9c             	pushl  -0x64(%ebp)
  800a3b:	e8 00 17 00 00       	call   802140 <malloc>
  800a40:	83 c4 10             	add    $0x10,%esp
  800a43:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[4*allocCntPerSize - 2];
  800a46:	a1 98 5d 80 00       	mov    0x805d98,%eax
  800a4b:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800a4e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800a52:	74 08                	je     800a5c <_main+0xa24>
  800a54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a57:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800a5a:	74 1d                	je     800a79 <_main+0xa41>
		{
			is_correct = 0;
  800a5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800a63:	83 ec 04             	sub    $0x4,%esp
  800a66:	ff 75 b8             	pushl  -0x48(%ebp)
  800a69:	ff 75 90             	pushl  -0x70(%ebp)
  800a6c:	68 64 44 80 00       	push   $0x804464
  800a71:	e8 dc 06 00 00       	call   801152 <cprintf>
  800a76:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800a79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a7d:	74 04                	je     800a83 <_main+0xa4b>
		{
			eval += 10;
  800a7f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		cprintf("	5.3: in block coalesces with PREV\n\n") ;
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	68 c4 44 80 00       	push   $0x8044c4
  800a8b:	e8 c2 06 00 00       	call   801152 <cprintf>
  800a90:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		actualSize = 30*sizeof(char) ;
  800a9a:	c7 45 9c 1e 00 00 00 	movl   $0x1e,-0x64(%ebp)
		va = malloc(actualSize);
  800aa1:	83 ec 0c             	sub    $0xc,%esp
  800aa4:	ff 75 9c             	pushl  -0x64(%ebp)
  800aa7:	e8 94 16 00 00       	call   802140 <malloc>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[2*allocCntPerSize];
  800ab2:	a1 60 57 80 00       	mov    0x805760,%eax
  800ab7:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800aba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800abe:	74 08                	je     800ac8 <_main+0xa90>
  800ac0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ac3:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800ac6:	74 1d                	je     800ae5 <_main+0xaad>
		{
			is_correct = 0;
  800ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.1: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800acf:	83 ec 04             	sub    $0x4,%esp
  800ad2:	ff 75 b8             	pushl  -0x48(%ebp)
  800ad5:	ff 75 90             	pushl  -0x70(%ebp)
  800ad8:	68 ec 44 80 00       	push   $0x8044ec
  800add:	e8 70 06 00 00       	call   801152 <cprintf>
  800ae2:	83 c4 10             	add    $0x10,%esp
		}
		actualSize = 3*kilo/2 ;
  800ae5:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)

		//dummy allocation to consume the 1st 1.5 KB free block
		{
			va = malloc(actualSize);
  800aec:	83 ec 0c             	sub    $0xc,%esp
  800aef:	ff 75 9c             	pushl  -0x64(%ebp)
  800af2:	e8 49 16 00 00       	call   802140 <malloc>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		//dummy allocation to consume the 1st 2 KB free block
		{
			va = malloc(actualSize);
  800afd:	83 ec 0c             	sub    $0xc,%esp
  800b00:	ff 75 9c             	pushl  -0x64(%ebp)
  800b03:	e8 38 16 00 00       	call   802140 <malloc>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		va = malloc(actualSize);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 9c             	pushl  -0x64(%ebp)
  800b14:	e8 27 16 00 00       	call   802140 <malloc>
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//Check returned va
		expected = startVAs[numOfAllocs*allocCntPerSize-2];
  800b1f:	a1 f8 66 80 00       	mov    0x8066f8,%eax
  800b24:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800b27:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800b2b:	74 08                	je     800b35 <_main+0xafd>
  800b2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b30:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800b33:	74 1d                	je     800b52 <_main+0xb1a>
		{
			is_correct = 0;
  800b35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.2: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	ff 75 b8             	pushl  -0x48(%ebp)
  800b42:	ff 75 90             	pushl  -0x70(%ebp)
  800b45:	68 4c 45 80 00       	push   $0x80454c
  800b4a:	e8 03 06 00 00       	call   801152 <cprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
		}

		actualSize = 3*kilo/2 ;
  800b52:	c7 45 9c 00 06 00 00 	movl   $0x600,-0x64(%ebp)
		va = malloc(actualSize);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	ff 75 9c             	pushl  -0x64(%ebp)
  800b5f:	e8 dc 15 00 00       	call   802140 <malloc>
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	89 45 b8             	mov    %eax,-0x48(%ebp)

		//Check returned va
		expected = (void*)startVAs[numOfAllocs*allocCntPerSize-2] + 3*kilo/2 + sizeOfMetaData();
  800b6a:	a1 f8 66 80 00       	mov    0x8066f8,%eax
  800b6f:	05 10 06 00 00       	add    $0x610,%eax
  800b74:	89 45 90             	mov    %eax,-0x70(%ebp)
		if(va == NULL || (va != expected))
  800b77:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  800b7b:	74 08                	je     800b85 <_main+0xb4d>
  800b7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b80:	3b 45 90             	cmp    -0x70(%ebp),%eax
  800b83:	74 1d                	je     800ba2 <_main+0xb6a>
		{
			is_correct = 0;
  800b85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			cprintf("test_free_2 #5.3.3: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", expected, va);
  800b8c:	83 ec 04             	sub    $0x4,%esp
  800b8f:	ff 75 b8             	pushl  -0x48(%ebp)
  800b92:	ff 75 90             	pushl  -0x70(%ebp)
  800b95:	68 ac 45 80 00       	push   $0x8045ac
  800b9a:	e8 b3 05 00 00       	call   801152 <cprintf>
  800b9f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800ba2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ba6:	74 04                	je     800bac <_main+0xb74>
		{
			eval += 10;
  800ba8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}


	//====================================================================//
	/*Check memory allocation*/
	cprintf("6: Check memory allocation [should not be changed due to free]\n\n") ;
  800bac:	83 ec 0c             	sub    $0xc,%esp
  800baf:	68 0c 46 80 00       	push   $0x80460c
  800bb4:	e8 99 05 00 00       	call   801152 <cprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800bbc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800bc3:	e8 68 19 00 00       	call   802530 <sys_calculate_free_frames>
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcd:	39 c2                	cmp    %eax,%edx
  800bcf:	74 17                	je     800be8 <_main+0xbb0>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	68 50 46 80 00       	push   $0x804650
  800bd9:	e8 74 05 00 00       	call   801152 <cprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800be1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bec:	74 04                	je     800bf2 <_main+0xbba>
		{
			eval += 10;
  800bee:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  800bf2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (int i = 0; i < numOfAllocs; ++i)
  800bf9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800c00:	eb 23                	jmp    800c25 <_main+0xbed>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
  800c02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c05:	8b 14 85 00 50 80 00 	mov    0x805000(,%eax,4),%edx
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	c1 e0 02             	shl    $0x2,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c1a:	01 d0                	add    %edx,%eax
  800c1c:	c1 e0 03             	shl    $0x3,%eax
  800c1f:	01 45 d8             	add    %eax,-0x28(%ebp)
			eval += 10;
		}
	}

	uint32 expectedAllocatedSize = 0;
	for (int i = 0; i < numOfAllocs; ++i)
  800c22:	ff 45 d4             	incl   -0x2c(%ebp)
  800c25:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  800c29:	7e d7                	jle    800c02 <_main+0xbca>
	{
		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  800c2b:	c7 45 8c 00 10 00 00 	movl   $0x1000,-0x74(%ebp)
  800c32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c35:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c38:	01 d0                	add    %edx,%eax
  800c3a:	48                   	dec    %eax
  800c3b:	89 45 88             	mov    %eax,-0x78(%ebp)
  800c3e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800c41:	ba 00 00 00 00       	mov    $0x0,%edx
  800c46:	f7 75 8c             	divl   -0x74(%ebp)
  800c49:	8b 45 88             	mov    -0x78(%ebp),%eax
  800c4c:	29 d0                	sub    %edx,%eax
  800c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800c51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c54:	c1 e8 0c             	shr    $0xc,%eax
  800c57:	89 45 84             	mov    %eax,-0x7c(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800c5a:	c7 45 80 00 00 40 00 	movl   $0x400000,-0x80(%ebp)
  800c61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c64:	8b 45 80             	mov    -0x80(%ebp),%eax
  800c67:	01 d0                	add    %edx,%eax
  800c69:	48                   	dec    %eax
  800c6a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800c70:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	f7 75 80             	divl   -0x80(%ebp)
  800c7e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800c84:	29 d0                	sub    %edx,%eax
  800c86:	c1 e8 16             	shr    $0x16,%eax
  800c89:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

	//====================================================================//
	/*Check WS elements*/
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	68 bc 46 80 00       	push   $0x8046bc
  800c97:	e8 b6 04 00 00       	call   801152 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800c9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800ca6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800ca9:	c1 e0 02             	shl    $0x2,%eax
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	e8 8b 14 00 00       	call   802140 <malloc>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		int i = 0;
  800cbe:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800cc5:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  800ccc:	eb 24                	jmp    800cf2 <_main+0xcba>
		{
			expectedVAs[i++] = va;
  800cce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800cd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cde:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ce4:	01 c2                	add    %eax,%edx
  800ce6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ce9:	89 02                	mov    %eax,(%edx)
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800ceb:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  800cf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf5:	05 00 00 00 80       	add    $0x80000000,%eax
  800cfa:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800cfd:	77 cf                	ja     800cce <_main+0xc96>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800cff:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800d02:	6a 02                	push   $0x2
  800d04:	6a 00                	push   $0x0
  800d06:	50                   	push   %eax
  800d07:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  800d0d:	e8 3b 1d 00 00       	call   802a4d <sys_check_WS_list>
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (chk != 1)
  800d1b:	83 bd 70 ff ff ff 01 	cmpl   $0x1,-0x90(%ebp)
  800d22:	74 17                	je     800d3b <_main+0xd03>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	68 f8 46 80 00       	push   $0x8046f8
  800d2c:	e8 21 04 00 00       	call   801152 <cprintf>
  800d31:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800d34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  800d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3f:	74 04                	je     800d45 <_main+0xd0d>
		{
			eval += 10;
  800d41:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	cprintf("test free() with FIRST FIT completed [DYNAMIC ALLOCATOR]. Evaluation = %d%\n", eval);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	68 3c 47 80 00       	push   $0x80473c
  800d50:	e8 fd 03 00 00       	call   801152 <cprintf>
  800d55:	83 c4 10             	add    $0x10,%esp

	return;
  800d58:	90                   	nop
}
  800d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d64:	e8 52 1a 00 00       	call   8027bb <sys_getenvindex>
  800d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d6f:	89 d0                	mov    %edx,%eax
  800d71:	c1 e0 03             	shl    $0x3,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	01 c0                	add    %eax,%eax
  800d78:	01 d0                	add    %edx,%eax
  800d7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d81:	01 d0                	add    %edx,%eax
  800d83:	c1 e0 04             	shl    $0x4,%eax
  800d86:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800d8b:	a3 40 50 80 00       	mov    %eax,0x805040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800d90:	a1 40 50 80 00       	mov    0x805040,%eax
  800d95:	8a 40 5c             	mov    0x5c(%eax),%al
  800d98:	84 c0                	test   %al,%al
  800d9a:	74 0d                	je     800da9 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800d9c:	a1 40 50 80 00       	mov    0x805040,%eax
  800da1:	83 c0 5c             	add    $0x5c,%eax
  800da4:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800da9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dad:	7e 0a                	jle    800db9 <libmain+0x5b>
		binaryname = argv[0];
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 00                	mov    (%eax),%eax
  800db4:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	_main(argc, argv);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	ff 75 08             	pushl  0x8(%ebp)
  800dc2:	e8 71 f2 ff ff       	call   800038 <_main>
  800dc7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800dca:	e8 f9 17 00 00       	call   8025c8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	68 a0 47 80 00       	push   $0x8047a0
  800dd7:	e8 76 03 00 00       	call   801152 <cprintf>
  800ddc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ddf:	a1 40 50 80 00       	mov    0x805040,%eax
  800de4:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800dea:	a1 40 50 80 00       	mov    0x805040,%eax
  800def:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800df5:	83 ec 04             	sub    $0x4,%esp
  800df8:	52                   	push   %edx
  800df9:	50                   	push   %eax
  800dfa:	68 c8 47 80 00       	push   $0x8047c8
  800dff:	e8 4e 03 00 00       	call   801152 <cprintf>
  800e04:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e07:	a1 40 50 80 00       	mov    0x805040,%eax
  800e0c:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800e12:	a1 40 50 80 00       	mov    0x805040,%eax
  800e17:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800e1d:	a1 40 50 80 00       	mov    0x805040,%eax
  800e22:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800e28:	51                   	push   %ecx
  800e29:	52                   	push   %edx
  800e2a:	50                   	push   %eax
  800e2b:	68 f0 47 80 00       	push   $0x8047f0
  800e30:	e8 1d 03 00 00       	call   801152 <cprintf>
  800e35:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e38:	a1 40 50 80 00       	mov    0x805040,%eax
  800e3d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800e43:	83 ec 08             	sub    $0x8,%esp
  800e46:	50                   	push   %eax
  800e47:	68 48 48 80 00       	push   $0x804848
  800e4c:	e8 01 03 00 00       	call   801152 <cprintf>
  800e51:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	68 a0 47 80 00       	push   $0x8047a0
  800e5c:	e8 f1 02 00 00       	call   801152 <cprintf>
  800e61:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e64:	e8 79 17 00 00       	call   8025e2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e69:	e8 19 00 00 00       	call   800e87 <exit>
}
  800e6e:	90                   	nop
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	6a 00                	push   $0x0
  800e7c:	e8 06 19 00 00       	call   802787 <sys_destroy_env>
  800e81:	83 c4 10             	add    $0x10,%esp
}
  800e84:	90                   	nop
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <exit>:

void
exit(void)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800e8d:	e8 5b 19 00 00       	call   8027ed <sys_exit_env>
}
  800e92:	90                   	nop
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800e9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e9e:	83 c0 04             	add    $0x4,%eax
  800ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ea4:	a1 30 93 80 00       	mov    0x809330,%eax
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	74 16                	je     800ec3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ead:	a1 30 93 80 00       	mov    0x809330,%eax
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	50                   	push   %eax
  800eb6:	68 5c 48 80 00       	push   $0x80485c
  800ebb:	e8 92 02 00 00       	call   801152 <cprintf>
  800ec0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ec3:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	ff 75 08             	pushl  0x8(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	68 61 48 80 00       	push   $0x804861
  800ed4:	e8 79 02 00 00       	call   801152 <cprintf>
  800ed9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800edc:	8b 45 10             	mov    0x10(%ebp),%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee5:	50                   	push   %eax
  800ee6:	e8 fc 01 00 00       	call   8010e7 <vcprintf>
  800eeb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	6a 00                	push   $0x0
  800ef3:	68 7d 48 80 00       	push   $0x80487d
  800ef8:	e8 ea 01 00 00       	call   8010e7 <vcprintf>
  800efd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f00:	e8 82 ff ff ff       	call   800e87 <exit>

	// should not return here
	while (1) ;
  800f05:	eb fe                	jmp    800f05 <_panic+0x70>

00800f07 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f0d:	a1 40 50 80 00       	mov    0x805040,%eax
  800f12:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	39 c2                	cmp    %eax,%edx
  800f1d:	74 14                	je     800f33 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f1f:	83 ec 04             	sub    $0x4,%esp
  800f22:	68 80 48 80 00       	push   $0x804880
  800f27:	6a 26                	push   $0x26
  800f29:	68 cc 48 80 00       	push   $0x8048cc
  800f2e:	e8 62 ff ff ff       	call   800e95 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	e9 c5 00 00 00       	jmp    80100b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	85 c0                	test   %eax,%eax
  800f59:	75 08                	jne    800f63 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800f5b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f5e:	e9 a5 00 00 00       	jmp    801008 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800f63:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f71:	eb 69                	jmp    800fdc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f73:	a1 40 50 80 00       	mov    0x805040,%eax
  800f78:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800f7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800f81:	89 d0                	mov    %edx,%eax
  800f83:	01 c0                	add    %eax,%eax
  800f85:	01 d0                	add    %edx,%eax
  800f87:	c1 e0 03             	shl    $0x3,%eax
  800f8a:	01 c8                	add    %ecx,%eax
  800f8c:	8a 40 04             	mov    0x4(%eax),%al
  800f8f:	84 c0                	test   %al,%al
  800f91:	75 46                	jne    800fd9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f93:	a1 40 50 80 00       	mov    0x805040,%eax
  800f98:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800f9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fa1:	89 d0                	mov    %edx,%eax
  800fa3:	01 c0                	add    %eax,%eax
  800fa5:	01 d0                	add    %edx,%eax
  800fa7:	c1 e0 03             	shl    $0x3,%eax
  800faa:	01 c8                	add    %ecx,%eax
  800fac:	8b 00                	mov    (%eax),%eax
  800fae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fb9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	01 c8                	add    %ecx,%eax
  800fca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fcc:	39 c2                	cmp    %eax,%edx
  800fce:	75 09                	jne    800fd9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800fd0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800fd7:	eb 15                	jmp    800fee <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fd9:	ff 45 e8             	incl   -0x18(%ebp)
  800fdc:	a1 40 50 80 00       	mov    0x805040,%eax
  800fe1:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fea:	39 c2                	cmp    %eax,%edx
  800fec:	77 85                	ja     800f73 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800fee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ff2:	75 14                	jne    801008 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	68 d8 48 80 00       	push   $0x8048d8
  800ffc:	6a 3a                	push   $0x3a
  800ffe:	68 cc 48 80 00       	push   $0x8048cc
  801003:	e8 8d fe ff ff       	call   800e95 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801008:	ff 45 f0             	incl   -0x10(%ebp)
  80100b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801011:	0f 8c 2f ff ff ff    	jl     800f46 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801017:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80101e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801025:	eb 26                	jmp    80104d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801027:	a1 40 50 80 00       	mov    0x805040,%eax
  80102c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801032:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801035:	89 d0                	mov    %edx,%eax
  801037:	01 c0                	add    %eax,%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	c1 e0 03             	shl    $0x3,%eax
  80103e:	01 c8                	add    %ecx,%eax
  801040:	8a 40 04             	mov    0x4(%eax),%al
  801043:	3c 01                	cmp    $0x1,%al
  801045:	75 03                	jne    80104a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801047:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80104a:	ff 45 e0             	incl   -0x20(%ebp)
  80104d:	a1 40 50 80 00       	mov    0x805040,%eax
  801052:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  801058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105b:	39 c2                	cmp    %eax,%edx
  80105d:	77 c8                	ja     801027 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801062:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801065:	74 14                	je     80107b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801067:	83 ec 04             	sub    $0x4,%esp
  80106a:	68 2c 49 80 00       	push   $0x80492c
  80106f:	6a 44                	push   $0x44
  801071:	68 cc 48 80 00       	push   $0x8048cc
  801076:	e8 1a fe ff ff       	call   800e95 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80107b:	90                   	nop
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8b 00                	mov    (%eax),%eax
  801089:	8d 48 01             	lea    0x1(%eax),%ecx
  80108c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108f:	89 0a                	mov    %ecx,(%edx)
  801091:	8b 55 08             	mov    0x8(%ebp),%edx
  801094:	88 d1                	mov    %dl,%cl
  801096:	8b 55 0c             	mov    0xc(%ebp),%edx
  801099:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010a7:	75 2c                	jne    8010d5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010a9:	a0 44 50 80 00       	mov    0x805044,%al
  8010ae:	0f b6 c0             	movzbl %al,%eax
  8010b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b4:	8b 12                	mov    (%edx),%edx
  8010b6:	89 d1                	mov    %edx,%ecx
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	83 c2 08             	add    $0x8,%edx
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	50                   	push   %eax
  8010c2:	51                   	push   %ecx
  8010c3:	52                   	push   %edx
  8010c4:	e8 a6 13 00 00       	call   80246f <sys_cputs>
  8010c9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	8b 40 04             	mov    0x4(%eax),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8010e4:	90                   	nop
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8010f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8010f7:	00 00 00 
	b.cnt = 0;
  8010fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801101:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	68 7e 10 80 00       	push   $0x80107e
  801116:	e8 11 02 00 00       	call   80132c <vprintfmt>
  80111b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80111e:	a0 44 50 80 00       	mov    0x805044,%al
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	50                   	push   %eax
  801130:	52                   	push   %edx
  801131:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801137:	83 c0 08             	add    $0x8,%eax
  80113a:	50                   	push   %eax
  80113b:	e8 2f 13 00 00       	call   80246f <sys_cputs>
  801140:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801143:	c6 05 44 50 80 00 00 	movb   $0x0,0x805044
	return b.cnt;
  80114a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <cprintf>:

int cprintf(const char *fmt, ...) {
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801158:	c6 05 44 50 80 00 01 	movb   $0x1,0x805044
	va_start(ap, fmt);
  80115f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801162:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 f4             	pushl  -0xc(%ebp)
  80116e:	50                   	push   %eax
  80116f:	e8 73 ff ff ff       	call   8010e7 <vcprintf>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80117a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801185:	e8 3e 14 00 00       	call   8025c8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80118a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80118d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 f4             	pushl  -0xc(%ebp)
  801199:	50                   	push   %eax
  80119a:	e8 48 ff ff ff       	call   8010e7 <vcprintf>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011a5:	e8 38 14 00 00       	call   8025e2 <sys_enable_interrupt>
	return cnt;
  8011aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 14             	sub    $0x14,%esp
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8011c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011cd:	77 55                	ja     801224 <printnum+0x75>
  8011cf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011d2:	72 05                	jb     8011d9 <printnum+0x2a>
  8011d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d7:	77 4b                	ja     801224 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011d9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8011dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8011df:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e7:	52                   	push   %edx
  8011e8:	50                   	push   %eax
  8011e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ef:	e8 e8 24 00 00       	call   8036dc <__udivdi3>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	ff 75 20             	pushl  0x20(%ebp)
  8011fd:	53                   	push   %ebx
  8011fe:	ff 75 18             	pushl  0x18(%ebp)
  801201:	52                   	push   %edx
  801202:	50                   	push   %eax
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	ff 75 08             	pushl  0x8(%ebp)
  801209:	e8 a1 ff ff ff       	call   8011af <printnum>
  80120e:	83 c4 20             	add    $0x20,%esp
  801211:	eb 1a                	jmp    80122d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	ff 75 0c             	pushl  0xc(%ebp)
  801219:	ff 75 20             	pushl  0x20(%ebp)
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	ff d0                	call   *%eax
  801221:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801224:	ff 4d 1c             	decl   0x1c(%ebp)
  801227:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80122b:	7f e6                	jg     801213 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80122d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123b:	53                   	push   %ebx
  80123c:	51                   	push   %ecx
  80123d:	52                   	push   %edx
  80123e:	50                   	push   %eax
  80123f:	e8 a8 25 00 00       	call   8037ec <__umoddi3>
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	05 94 4b 80 00       	add    $0x804b94,%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f be c0             	movsbl %al,%eax
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	ff 75 0c             	pushl  0xc(%ebp)
  801257:	50                   	push   %eax
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	ff d0                	call   *%eax
  80125d:	83 c4 10             	add    $0x10,%esp
}
  801260:	90                   	nop
  801261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801269:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80126d:	7e 1c                	jle    80128b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8b 00                	mov    (%eax),%eax
  801274:	8d 50 08             	lea    0x8(%eax),%edx
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	89 10                	mov    %edx,(%eax)
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	83 e8 08             	sub    $0x8,%eax
  801284:	8b 50 04             	mov    0x4(%eax),%edx
  801287:	8b 00                	mov    (%eax),%eax
  801289:	eb 40                	jmp    8012cb <getuint+0x65>
	else if (lflag)
  80128b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80128f:	74 1e                	je     8012af <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 50 04             	lea    0x4(%eax),%edx
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	89 10                	mov    %edx,(%eax)
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	83 e8 04             	sub    $0x4,%eax
  8012a6:	8b 00                	mov    (%eax),%eax
  8012a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ad:	eb 1c                	jmp    8012cb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8b 00                	mov    (%eax),%eax
  8012b4:	8d 50 04             	lea    0x4(%eax),%edx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 10                	mov    %edx,(%eax)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8b 00                	mov    (%eax),%eax
  8012c1:	83 e8 04             	sub    $0x4,%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012d4:	7e 1c                	jle    8012f2 <getint+0x25>
		return va_arg(*ap, long long);
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 50 08             	lea    0x8(%eax),%edx
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	89 10                	mov    %edx,(%eax)
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	8b 00                	mov    (%eax),%eax
  8012e8:	83 e8 08             	sub    $0x8,%eax
  8012eb:	8b 50 04             	mov    0x4(%eax),%edx
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	eb 38                	jmp    80132a <getint+0x5d>
	else if (lflag)
  8012f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f6:	74 1a                	je     801312 <getint+0x45>
		return va_arg(*ap, long);
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8b 00                	mov    (%eax),%eax
  8012fd:	8d 50 04             	lea    0x4(%eax),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 10                	mov    %edx,(%eax)
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8b 00                	mov    (%eax),%eax
  80130a:	83 e8 04             	sub    $0x4,%eax
  80130d:	8b 00                	mov    (%eax),%eax
  80130f:	99                   	cltd   
  801310:	eb 18                	jmp    80132a <getint+0x5d>
	else
		return va_arg(*ap, int);
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8b 00                	mov    (%eax),%eax
  801317:	8d 50 04             	lea    0x4(%eax),%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	89 10                	mov    %edx,(%eax)
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8b 00                	mov    (%eax),%eax
  801324:	83 e8 04             	sub    $0x4,%eax
  801327:	8b 00                	mov    (%eax),%eax
  801329:	99                   	cltd   
}
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801334:	eb 17                	jmp    80134d <vprintfmt+0x21>
			if (ch == '\0')
  801336:	85 db                	test   %ebx,%ebx
  801338:	0f 84 af 03 00 00    	je     8016ed <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	53                   	push   %ebx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	ff d0                	call   *%eax
  80134a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	8d 50 01             	lea    0x1(%eax),%edx
  801353:	89 55 10             	mov    %edx,0x10(%ebp)
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f b6 d8             	movzbl %al,%ebx
  80135b:	83 fb 25             	cmp    $0x25,%ebx
  80135e:	75 d6                	jne    801336 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801360:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801364:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80136b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801372:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801379:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	8d 50 01             	lea    0x1(%eax),%edx
  801386:	89 55 10             	mov    %edx,0x10(%ebp)
  801389:	8a 00                	mov    (%eax),%al
  80138b:	0f b6 d8             	movzbl %al,%ebx
  80138e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801391:	83 f8 55             	cmp    $0x55,%eax
  801394:	0f 87 2b 03 00 00    	ja     8016c5 <vprintfmt+0x399>
  80139a:	8b 04 85 b8 4b 80 00 	mov    0x804bb8(,%eax,4),%eax
  8013a1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013a3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013a7:	eb d7                	jmp    801380 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013a9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013ad:	eb d1                	jmp    801380 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013b9:	89 d0                	mov    %edx,%eax
  8013bb:	c1 e0 02             	shl    $0x2,%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	01 c0                	add    %eax,%eax
  8013c2:	01 d8                	add    %ebx,%eax
  8013c4:	83 e8 30             	sub    $0x30,%eax
  8013c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013d2:	83 fb 2f             	cmp    $0x2f,%ebx
  8013d5:	7e 3e                	jle    801415 <vprintfmt+0xe9>
  8013d7:	83 fb 39             	cmp    $0x39,%ebx
  8013da:	7f 39                	jg     801415 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013dc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8013df:	eb d5                	jmp    8013b6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8013e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e4:	83 c0 04             	add    $0x4,%eax
  8013e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8013ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ed:	83 e8 04             	sub    $0x4,%eax
  8013f0:	8b 00                	mov    (%eax),%eax
  8013f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8013f5:	eb 1f                	jmp    801416 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8013f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013fb:	79 83                	jns    801380 <vprintfmt+0x54>
				width = 0;
  8013fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801404:	e9 77 ff ff ff       	jmp    801380 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801409:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801410:	e9 6b ff ff ff       	jmp    801380 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801415:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141a:	0f 89 60 ff ff ff    	jns    801380 <vprintfmt+0x54>
				width = precision, precision = -1;
  801420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801426:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80142d:	e9 4e ff ff ff       	jmp    801380 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801432:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801435:	e9 46 ff ff ff       	jmp    801380 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80143a:	8b 45 14             	mov    0x14(%ebp),%eax
  80143d:	83 c0 04             	add    $0x4,%eax
  801440:	89 45 14             	mov    %eax,0x14(%ebp)
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	83 e8 04             	sub    $0x4,%eax
  801449:	8b 00                	mov    (%eax),%eax
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	50                   	push   %eax
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	ff d0                	call   *%eax
  801457:	83 c4 10             	add    $0x10,%esp
			break;
  80145a:	e9 89 02 00 00       	jmp    8016e8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	83 c0 04             	add    $0x4,%eax
  801465:	89 45 14             	mov    %eax,0x14(%ebp)
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	83 e8 04             	sub    $0x4,%eax
  80146e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801470:	85 db                	test   %ebx,%ebx
  801472:	79 02                	jns    801476 <vprintfmt+0x14a>
				err = -err;
  801474:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801476:	83 fb 64             	cmp    $0x64,%ebx
  801479:	7f 0b                	jg     801486 <vprintfmt+0x15a>
  80147b:	8b 34 9d 00 4a 80 00 	mov    0x804a00(,%ebx,4),%esi
  801482:	85 f6                	test   %esi,%esi
  801484:	75 19                	jne    80149f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801486:	53                   	push   %ebx
  801487:	68 a5 4b 80 00       	push   $0x804ba5
  80148c:	ff 75 0c             	pushl  0xc(%ebp)
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	e8 5e 02 00 00       	call   8016f5 <printfmt>
  801497:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80149a:	e9 49 02 00 00       	jmp    8016e8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80149f:	56                   	push   %esi
  8014a0:	68 ae 4b 80 00       	push   $0x804bae
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	ff 75 08             	pushl  0x8(%ebp)
  8014ab:	e8 45 02 00 00       	call   8016f5 <printfmt>
  8014b0:	83 c4 10             	add    $0x10,%esp
			break;
  8014b3:	e9 30 02 00 00       	jmp    8016e8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bb:	83 c0 04             	add    $0x4,%eax
  8014be:	89 45 14             	mov    %eax,0x14(%ebp)
  8014c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c4:	83 e8 04             	sub    $0x4,%eax
  8014c7:	8b 30                	mov    (%eax),%esi
  8014c9:	85 f6                	test   %esi,%esi
  8014cb:	75 05                	jne    8014d2 <vprintfmt+0x1a6>
				p = "(null)";
  8014cd:	be b1 4b 80 00       	mov    $0x804bb1,%esi
			if (width > 0 && padc != '-')
  8014d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d6:	7e 6d                	jle    801545 <vprintfmt+0x219>
  8014d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8014dc:	74 67                	je     801545 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8014de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	50                   	push   %eax
  8014e5:	56                   	push   %esi
  8014e6:	e8 0c 03 00 00       	call   8017f7 <strnlen>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8014f1:	eb 16                	jmp    801509 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8014f3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	50                   	push   %eax
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	ff d0                	call   *%eax
  801503:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801506:	ff 4d e4             	decl   -0x1c(%ebp)
  801509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80150d:	7f e4                	jg     8014f3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80150f:	eb 34                	jmp    801545 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801511:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801515:	74 1c                	je     801533 <vprintfmt+0x207>
  801517:	83 fb 1f             	cmp    $0x1f,%ebx
  80151a:	7e 05                	jle    801521 <vprintfmt+0x1f5>
  80151c:	83 fb 7e             	cmp    $0x7e,%ebx
  80151f:	7e 12                	jle    801533 <vprintfmt+0x207>
					putch('?', putdat);
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	6a 3f                	push   $0x3f
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	ff d0                	call   *%eax
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	eb 0f                	jmp    801542 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	53                   	push   %ebx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	ff d0                	call   *%eax
  80153f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801542:	ff 4d e4             	decl   -0x1c(%ebp)
  801545:	89 f0                	mov    %esi,%eax
  801547:	8d 70 01             	lea    0x1(%eax),%esi
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	0f be d8             	movsbl %al,%ebx
  80154f:	85 db                	test   %ebx,%ebx
  801551:	74 24                	je     801577 <vprintfmt+0x24b>
  801553:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801557:	78 b8                	js     801511 <vprintfmt+0x1e5>
  801559:	ff 4d e0             	decl   -0x20(%ebp)
  80155c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801560:	79 af                	jns    801511 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801562:	eb 13                	jmp    801577 <vprintfmt+0x24b>
				putch(' ', putdat);
  801564:	83 ec 08             	sub    $0x8,%esp
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	6a 20                	push   $0x20
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	ff d0                	call   *%eax
  801571:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801574:	ff 4d e4             	decl   -0x1c(%ebp)
  801577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80157b:	7f e7                	jg     801564 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80157d:	e9 66 01 00 00       	jmp    8016e8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	ff 75 e8             	pushl  -0x18(%ebp)
  801588:	8d 45 14             	lea    0x14(%ebp),%eax
  80158b:	50                   	push   %eax
  80158c:	e8 3c fd ff ff       	call   8012cd <getint>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801597:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a0:	85 d2                	test   %edx,%edx
  8015a2:	79 23                	jns    8015c7 <vprintfmt+0x29b>
				putch('-', putdat);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	6a 2d                	push   $0x2d
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	ff d0                	call   *%eax
  8015b1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ba:	f7 d8                	neg    %eax
  8015bc:	83 d2 00             	adc    $0x0,%edx
  8015bf:	f7 da                	neg    %edx
  8015c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015c7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015ce:	e9 bc 00 00 00       	jmp    80168f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8015dc:	50                   	push   %eax
  8015dd:	e8 84 fc ff ff       	call   801266 <getuint>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 98 00 00 00       	jmp    80168f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 0c             	pushl  0xc(%ebp)
  8015fd:	6a 58                	push   $0x58
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	ff d0                	call   *%eax
  801604:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	ff 75 0c             	pushl  0xc(%ebp)
  80160d:	6a 58                	push   $0x58
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	ff d0                	call   *%eax
  801614:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801617:	83 ec 08             	sub    $0x8,%esp
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	6a 58                	push   $0x58
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	ff d0                	call   *%eax
  801624:	83 c4 10             	add    $0x10,%esp
			break;
  801627:	e9 bc 00 00 00       	jmp    8016e8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	6a 30                	push   $0x30
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	ff d0                	call   *%eax
  801639:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	6a 78                	push   $0x78
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	ff d0                	call   *%eax
  801649:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80164c:	8b 45 14             	mov    0x14(%ebp),%eax
  80164f:	83 c0 04             	add    $0x4,%eax
  801652:	89 45 14             	mov    %eax,0x14(%ebp)
  801655:	8b 45 14             	mov    0x14(%ebp),%eax
  801658:	83 e8 04             	sub    $0x4,%eax
  80165b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801667:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80166e:	eb 1f                	jmp    80168f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 e8             	pushl  -0x18(%ebp)
  801676:	8d 45 14             	lea    0x14(%ebp),%eax
  801679:	50                   	push   %eax
  80167a:	e8 e7 fb ff ff       	call   801266 <getuint>
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801685:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801688:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80168f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	52                   	push   %edx
  80169a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169d:	50                   	push   %eax
  80169e:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	e8 00 fb ff ff       	call   8011af <printnum>
  8016af:	83 c4 20             	add    $0x20,%esp
			break;
  8016b2:	eb 34                	jmp    8016e8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	53                   	push   %ebx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	ff d0                	call   *%eax
  8016c0:	83 c4 10             	add    $0x10,%esp
			break;
  8016c3:	eb 23                	jmp    8016e8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016c5:	83 ec 08             	sub    $0x8,%esp
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	6a 25                	push   $0x25
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	ff d0                	call   *%eax
  8016d2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016d5:	ff 4d 10             	decl   0x10(%ebp)
  8016d8:	eb 03                	jmp    8016dd <vprintfmt+0x3b1>
  8016da:	ff 4d 10             	decl   0x10(%ebp)
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	48                   	dec    %eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 25                	cmp    $0x25,%al
  8016e5:	75 f3                	jne    8016da <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8016e7:	90                   	nop
		}
	}
  8016e8:	e9 47 fc ff ff       	jmp    801334 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8016ed:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8016ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8016fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8016fe:	83 c0 04             	add    $0x4,%eax
  801701:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	ff 75 f4             	pushl  -0xc(%ebp)
  80170a:	50                   	push   %eax
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 16 fc ff ff       	call   80132c <vprintfmt>
  801716:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801719:	90                   	nop
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	8b 40 08             	mov    0x8(%eax),%eax
  801725:	8d 50 01             	lea    0x1(%eax),%edx
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	8b 10                	mov    (%eax),%edx
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	8b 40 04             	mov    0x4(%eax),%eax
  801739:	39 c2                	cmp    %eax,%edx
  80173b:	73 12                	jae    80174f <sprintputch+0x33>
		*b->buf++ = ch;
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	8d 48 01             	lea    0x1(%eax),%ecx
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	89 0a                	mov    %ecx,(%edx)
  80174a:	8b 55 08             	mov    0x8(%ebp),%edx
  80174d:	88 10                	mov    %dl,(%eax)
}
  80174f:	90                   	nop
  801750:	5d                   	pop    %ebp
  801751:	c3                   	ret    

00801752 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801761:	8d 50 ff             	lea    -0x1(%eax),%edx
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80176c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801773:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801777:	74 06                	je     80177f <vsnprintf+0x2d>
  801779:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80177d:	7f 07                	jg     801786 <vsnprintf+0x34>
		return -E_INVAL;
  80177f:	b8 03 00 00 00       	mov    $0x3,%eax
  801784:	eb 20                	jmp    8017a6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801786:	ff 75 14             	pushl  0x14(%ebp)
  801789:	ff 75 10             	pushl  0x10(%ebp)
  80178c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	68 1c 17 80 00       	push   $0x80171c
  801795:	e8 92 fb ff ff       	call   80132c <vprintfmt>
  80179a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80179d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8017b1:	83 c0 04             	add    $0x4,%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bd:	50                   	push   %eax
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	ff 75 08             	pushl  0x8(%ebp)
  8017c4:	e8 89 ff ff ff       	call   801752 <vsnprintf>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017e1:	eb 06                	jmp    8017e9 <strlen+0x15>
		n++;
  8017e3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8017e6:	ff 45 08             	incl   0x8(%ebp)
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	84 c0                	test   %al,%al
  8017f0:	75 f1                	jne    8017e3 <strlen+0xf>
		n++;
	return n;
  8017f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8017fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801804:	eb 09                	jmp    80180f <strnlen+0x18>
		n++;
  801806:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801809:	ff 45 08             	incl   0x8(%ebp)
  80180c:	ff 4d 0c             	decl   0xc(%ebp)
  80180f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801813:	74 09                	je     80181e <strnlen+0x27>
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	84 c0                	test   %al,%al
  80181c:	75 e8                	jne    801806 <strnlen+0xf>
		n++;
	return n;
  80181e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80182f:	90                   	nop
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8d 50 01             	lea    0x1(%eax),%edx
  801836:	89 55 08             	mov    %edx,0x8(%ebp)
  801839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80183f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801842:	8a 12                	mov    (%edx),%dl
  801844:	88 10                	mov    %dl,(%eax)
  801846:	8a 00                	mov    (%eax),%al
  801848:	84 c0                	test   %al,%al
  80184a:	75 e4                	jne    801830 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80185d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801864:	eb 1f                	jmp    801885 <strncpy+0x34>
		*dst++ = *src;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8d 50 01             	lea    0x1(%eax),%edx
  80186c:	89 55 08             	mov    %edx,0x8(%ebp)
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8a 12                	mov    (%edx),%dl
  801874:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801876:	8b 45 0c             	mov    0xc(%ebp),%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	84 c0                	test   %al,%al
  80187d:	74 03                	je     801882 <strncpy+0x31>
			src++;
  80187f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801882:	ff 45 fc             	incl   -0x4(%ebp)
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	3b 45 10             	cmp    0x10(%ebp),%eax
  80188b:	72 d9                	jb     801866 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80189e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018a2:	74 30                	je     8018d4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018a4:	eb 16                	jmp    8018bc <strlcpy+0x2a>
			*dst++ = *src++;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8d 50 01             	lea    0x1(%eax),%edx
  8018ac:	89 55 08             	mov    %edx,0x8(%ebp)
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018b8:	8a 12                	mov    (%edx),%dl
  8018ba:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018bc:	ff 4d 10             	decl   0x10(%ebp)
  8018bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c3:	74 09                	je     8018ce <strlcpy+0x3c>
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	8a 00                	mov    (%eax),%al
  8018ca:	84 c0                	test   %al,%al
  8018cc:	75 d8                	jne    8018a6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018da:	29 c2                	sub    %eax,%edx
  8018dc:	89 d0                	mov    %edx,%eax
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8018e3:	eb 06                	jmp    8018eb <strcmp+0xb>
		p++, q++;
  8018e5:	ff 45 08             	incl   0x8(%ebp)
  8018e8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	84 c0                	test   %al,%al
  8018f2:	74 0e                	je     801902 <strcmp+0x22>
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 10                	mov    (%eax),%dl
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	38 c2                	cmp    %al,%dl
  801900:	74 e3                	je     8018e5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8a 00                	mov    (%eax),%al
  801907:	0f b6 d0             	movzbl %al,%edx
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	8a 00                	mov    (%eax),%al
  80190f:	0f b6 c0             	movzbl %al,%eax
  801912:	29 c2                	sub    %eax,%edx
  801914:	89 d0                	mov    %edx,%eax
}
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    

00801918 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80191b:	eb 09                	jmp    801926 <strncmp+0xe>
		n--, p++, q++;
  80191d:	ff 4d 10             	decl   0x10(%ebp)
  801920:	ff 45 08             	incl   0x8(%ebp)
  801923:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 17                	je     801943 <strncmp+0x2b>
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	84 c0                	test   %al,%al
  801933:	74 0e                	je     801943 <strncmp+0x2b>
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	8a 10                	mov    (%eax),%dl
  80193a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	38 c2                	cmp    %al,%dl
  801941:	74 da                	je     80191d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801943:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801947:	75 07                	jne    801950 <strncmp+0x38>
		return 0;
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	eb 14                	jmp    801964 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	0f b6 d0             	movzbl %al,%edx
  801958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	0f b6 c0             	movzbl %al,%eax
  801960:	29 c2                	sub    %eax,%edx
  801962:	89 d0                	mov    %edx,%eax
}
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801972:	eb 12                	jmp    801986 <strchr+0x20>
		if (*s == c)
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80197c:	75 05                	jne    801983 <strchr+0x1d>
			return (char *) s;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	eb 11                	jmp    801994 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801983:	ff 45 08             	incl   0x8(%ebp)
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	8a 00                	mov    (%eax),%al
  80198b:	84 c0                	test   %al,%al
  80198d:	75 e5                	jne    801974 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019a2:	eb 0d                	jmp    8019b1 <strfind+0x1b>
		if (*s == c)
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019ac:	74 0e                	je     8019bc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019ae:	ff 45 08             	incl   0x8(%ebp)
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	84 c0                	test   %al,%al
  8019b8:	75 ea                	jne    8019a4 <strfind+0xe>
  8019ba:	eb 01                	jmp    8019bd <strfind+0x27>
		if (*s == c)
			break;
  8019bc:	90                   	nop
	return (char *) s;
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019d4:	eb 0e                	jmp    8019e4 <memset+0x22>
		*p++ = c;
  8019d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d9:	8d 50 01             	lea    0x1(%eax),%edx
  8019dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8019e4:	ff 4d f8             	decl   -0x8(%ebp)
  8019e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8019eb:	79 e9                	jns    8019d6 <memset+0x14>
		*p++ = c;

	return v;
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8019f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a04:	eb 16                	jmp    801a1c <memcpy+0x2a>
		*d++ = *s++;
  801a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a09:	8d 50 01             	lea    0x1(%eax),%edx
  801a0c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a12:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a15:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a18:	8a 12                	mov    (%edx),%dl
  801a1a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a22:	89 55 10             	mov    %edx,0x10(%ebp)
  801a25:	85 c0                	test   %eax,%eax
  801a27:	75 dd                	jne    801a06 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a43:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a46:	73 50                	jae    801a98 <memmove+0x6a>
  801a48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4e:	01 d0                	add    %edx,%eax
  801a50:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a53:	76 43                	jbe    801a98 <memmove+0x6a>
		s += n;
  801a55:	8b 45 10             	mov    0x10(%ebp),%eax
  801a58:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a61:	eb 10                	jmp    801a73 <memmove+0x45>
			*--d = *--s;
  801a63:	ff 4d f8             	decl   -0x8(%ebp)
  801a66:	ff 4d fc             	decl   -0x4(%ebp)
  801a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a6c:	8a 10                	mov    (%eax),%dl
  801a6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a71:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a73:	8b 45 10             	mov    0x10(%ebp),%eax
  801a76:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a79:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	75 e3                	jne    801a63 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801a80:	eb 23                	jmp    801aa5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a85:	8d 50 01             	lea    0x1(%eax),%edx
  801a88:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a91:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a94:	8a 12                	mov    (%edx),%dl
  801a96:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9e:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	75 dd                	jne    801a82 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801abc:	eb 2a                	jmp    801ae8 <memcmp+0x3e>
		if (*s1 != *s2)
  801abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac1:	8a 10                	mov    (%eax),%dl
  801ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	38 c2                	cmp    %al,%dl
  801aca:	74 16                	je     801ae2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801acf:	8a 00                	mov    (%eax),%al
  801ad1:	0f b6 d0             	movzbl %al,%edx
  801ad4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad7:	8a 00                	mov    (%eax),%al
  801ad9:	0f b6 c0             	movzbl %al,%eax
  801adc:	29 c2                	sub    %eax,%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	eb 18                	jmp    801afa <memcmp+0x50>
		s1++, s2++;
  801ae2:	ff 45 fc             	incl   -0x4(%ebp)
  801ae5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aee:	89 55 10             	mov    %edx,0x10(%ebp)
  801af1:	85 c0                	test   %eax,%eax
  801af3:	75 c9                	jne    801abe <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b02:	8b 55 08             	mov    0x8(%ebp),%edx
  801b05:	8b 45 10             	mov    0x10(%ebp),%eax
  801b08:	01 d0                	add    %edx,%eax
  801b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b0d:	eb 15                	jmp    801b24 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	8a 00                	mov    (%eax),%al
  801b14:	0f b6 d0             	movzbl %al,%edx
  801b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1a:	0f b6 c0             	movzbl %al,%eax
  801b1d:	39 c2                	cmp    %eax,%edx
  801b1f:	74 0d                	je     801b2e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b21:	ff 45 08             	incl   0x8(%ebp)
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b2a:	72 e3                	jb     801b0f <memfind+0x13>
  801b2c:	eb 01                	jmp    801b2f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b2e:	90                   	nop
	return (void *) s;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b48:	eb 03                	jmp    801b4d <strtol+0x19>
		s++;
  801b4a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	8a 00                	mov    (%eax),%al
  801b52:	3c 20                	cmp    $0x20,%al
  801b54:	74 f4                	je     801b4a <strtol+0x16>
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	8a 00                	mov    (%eax),%al
  801b5b:	3c 09                	cmp    $0x9,%al
  801b5d:	74 eb                	je     801b4a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	8a 00                	mov    (%eax),%al
  801b64:	3c 2b                	cmp    $0x2b,%al
  801b66:	75 05                	jne    801b6d <strtol+0x39>
		s++;
  801b68:	ff 45 08             	incl   0x8(%ebp)
  801b6b:	eb 13                	jmp    801b80 <strtol+0x4c>
	else if (*s == '-')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 2d                	cmp    $0x2d,%al
  801b74:	75 0a                	jne    801b80 <strtol+0x4c>
		s++, neg = 1;
  801b76:	ff 45 08             	incl   0x8(%ebp)
  801b79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b84:	74 06                	je     801b8c <strtol+0x58>
  801b86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801b8a:	75 20                	jne    801bac <strtol+0x78>
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	8a 00                	mov    (%eax),%al
  801b91:	3c 30                	cmp    $0x30,%al
  801b93:	75 17                	jne    801bac <strtol+0x78>
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	40                   	inc    %eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	3c 78                	cmp    $0x78,%al
  801b9d:	75 0d                	jne    801bac <strtol+0x78>
		s += 2, base = 16;
  801b9f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801ba3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801baa:	eb 28                	jmp    801bd4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bb0:	75 15                	jne    801bc7 <strtol+0x93>
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	8a 00                	mov    (%eax),%al
  801bb7:	3c 30                	cmp    $0x30,%al
  801bb9:	75 0c                	jne    801bc7 <strtol+0x93>
		s++, base = 8;
  801bbb:	ff 45 08             	incl   0x8(%ebp)
  801bbe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801bc5:	eb 0d                	jmp    801bd4 <strtol+0xa0>
	else if (base == 0)
  801bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bcb:	75 07                	jne    801bd4 <strtol+0xa0>
		base = 10;
  801bcd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	8a 00                	mov    (%eax),%al
  801bd9:	3c 2f                	cmp    $0x2f,%al
  801bdb:	7e 19                	jle    801bf6 <strtol+0xc2>
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	8a 00                	mov    (%eax),%al
  801be2:	3c 39                	cmp    $0x39,%al
  801be4:	7f 10                	jg     801bf6 <strtol+0xc2>
			dig = *s - '0';
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	0f be c0             	movsbl %al,%eax
  801bee:	83 e8 30             	sub    $0x30,%eax
  801bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bf4:	eb 42                	jmp    801c38 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	8a 00                	mov    (%eax),%al
  801bfb:	3c 60                	cmp    $0x60,%al
  801bfd:	7e 19                	jle    801c18 <strtol+0xe4>
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8a 00                	mov    (%eax),%al
  801c04:	3c 7a                	cmp    $0x7a,%al
  801c06:	7f 10                	jg     801c18 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	8a 00                	mov    (%eax),%al
  801c0d:	0f be c0             	movsbl %al,%eax
  801c10:	83 e8 57             	sub    $0x57,%eax
  801c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c16:	eb 20                	jmp    801c38 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	8a 00                	mov    (%eax),%al
  801c1d:	3c 40                	cmp    $0x40,%al
  801c1f:	7e 39                	jle    801c5a <strtol+0x126>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	3c 5a                	cmp    $0x5a,%al
  801c28:	7f 30                	jg     801c5a <strtol+0x126>
			dig = *s - 'A' + 10;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	8a 00                	mov    (%eax),%al
  801c2f:	0f be c0             	movsbl %al,%eax
  801c32:	83 e8 37             	sub    $0x37,%eax
  801c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3b:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c3e:	7d 19                	jge    801c59 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c46:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c4a:	89 c2                	mov    %eax,%edx
  801c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4f:	01 d0                	add    %edx,%eax
  801c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c54:	e9 7b ff ff ff       	jmp    801bd4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c59:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c5e:	74 08                	je     801c68 <strtol+0x134>
		*endptr = (char *) s;
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	8b 55 08             	mov    0x8(%ebp),%edx
  801c66:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c6c:	74 07                	je     801c75 <strtol+0x141>
  801c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c71:	f7 d8                	neg    %eax
  801c73:	eb 03                	jmp    801c78 <strtol+0x144>
  801c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <ltostr>:

void
ltostr(long value, char *str)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801c80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801c87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c92:	79 13                	jns    801ca7 <ltostr+0x2d>
	{
		neg = 1;
  801c94:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801ca1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ca4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801caf:	99                   	cltd   
  801cb0:	f7 f9                	idiv   %ecx
  801cb2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb8:	8d 50 01             	lea    0x1(%eax),%edx
  801cbb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801cbe:	89 c2                	mov    %eax,%edx
  801cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc3:	01 d0                	add    %edx,%eax
  801cc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cc8:	83 c2 30             	add    $0x30,%edx
  801ccb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cd5:	f7 e9                	imul   %ecx
  801cd7:	c1 fa 02             	sar    $0x2,%edx
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	c1 f8 1f             	sar    $0x1f,%eax
  801cdf:	29 c2                	sub    %eax,%edx
  801ce1:	89 d0                	mov    %edx,%eax
  801ce3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801ce6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cee:	f7 e9                	imul   %ecx
  801cf0:	c1 fa 02             	sar    $0x2,%edx
  801cf3:	89 c8                	mov    %ecx,%eax
  801cf5:	c1 f8 1f             	sar    $0x1f,%eax
  801cf8:	29 c2                	sub    %eax,%edx
  801cfa:	89 d0                	mov    %edx,%eax
  801cfc:	c1 e0 02             	shl    $0x2,%eax
  801cff:	01 d0                	add    %edx,%eax
  801d01:	01 c0                	add    %eax,%eax
  801d03:	29 c1                	sub    %eax,%ecx
  801d05:	89 ca                	mov    %ecx,%edx
  801d07:	85 d2                	test   %edx,%edx
  801d09:	75 9c                	jne    801ca7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d15:	48                   	dec    %eax
  801d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d1d:	74 3d                	je     801d5c <ltostr+0xe2>
		start = 1 ;
  801d1f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d26:	eb 34                	jmp    801d5c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2e:	01 d0                	add    %edx,%eax
  801d30:	8a 00                	mov    (%eax),%al
  801d32:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3b:	01 c2                	add    %eax,%edx
  801d3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d43:	01 c8                	add    %ecx,%eax
  801d45:	8a 00                	mov    (%eax),%al
  801d47:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	01 c2                	add    %eax,%edx
  801d51:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d54:	88 02                	mov    %al,(%edx)
		start++ ;
  801d56:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d59:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d62:	7c c4                	jl     801d28 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d64:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6a:	01 d0                	add    %edx,%eax
  801d6c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	e8 54 fa ff ff       	call   8017d4 <strlen>
  801d80:	83 c4 04             	add    $0x4,%esp
  801d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	e8 46 fa ff ff       	call   8017d4 <strlen>
  801d8e:	83 c4 04             	add    $0x4,%esp
  801d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801d94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801da2:	eb 17                	jmp    801dbb <strcconcat+0x49>
		final[s] = str1[s] ;
  801da4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da7:	8b 45 10             	mov    0x10(%ebp),%eax
  801daa:	01 c2                	add    %eax,%edx
  801dac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	01 c8                	add    %ecx,%eax
  801db4:	8a 00                	mov    (%eax),%al
  801db6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801db8:	ff 45 fc             	incl   -0x4(%ebp)
  801dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801dc1:	7c e1                	jl     801da4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801dc3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801dd1:	eb 1f                	jmp    801df2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd6:	8d 50 01             	lea    0x1(%eax),%edx
  801dd9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ddc:	89 c2                	mov    %eax,%edx
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	01 c2                	add    %eax,%edx
  801de3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de9:	01 c8                	add    %ecx,%eax
  801deb:	8a 00                	mov    (%eax),%al
  801ded:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801def:	ff 45 f8             	incl   -0x8(%ebp)
  801df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801df8:	7c d9                	jl     801dd3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	c6 00 00             	movb   $0x0,(%eax)
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e14:	8b 45 14             	mov    0x14(%ebp),%eax
  801e17:	8b 00                	mov    (%eax),%eax
  801e19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e20:	8b 45 10             	mov    0x10(%ebp),%eax
  801e23:	01 d0                	add    %edx,%eax
  801e25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e2b:	eb 0c                	jmp    801e39 <strsplit+0x31>
			*string++ = 0;
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	8d 50 01             	lea    0x1(%eax),%edx
  801e33:	89 55 08             	mov    %edx,0x8(%ebp)
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	8a 00                	mov    (%eax),%al
  801e3e:	84 c0                	test   %al,%al
  801e40:	74 18                	je     801e5a <strsplit+0x52>
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	8a 00                	mov    (%eax),%al
  801e47:	0f be c0             	movsbl %al,%eax
  801e4a:	50                   	push   %eax
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	e8 13 fb ff ff       	call   801966 <strchr>
  801e53:	83 c4 08             	add    $0x8,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	75 d3                	jne    801e2d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	8a 00                	mov    (%eax),%al
  801e5f:	84 c0                	test   %al,%al
  801e61:	74 5a                	je     801ebd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e63:	8b 45 14             	mov    0x14(%ebp),%eax
  801e66:	8b 00                	mov    (%eax),%eax
  801e68:	83 f8 0f             	cmp    $0xf,%eax
  801e6b:	75 07                	jne    801e74 <strsplit+0x6c>
		{
			return 0;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	eb 66                	jmp    801eda <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e74:	8b 45 14             	mov    0x14(%ebp),%eax
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	8d 48 01             	lea    0x1(%eax),%ecx
  801e7c:	8b 55 14             	mov    0x14(%ebp),%edx
  801e7f:	89 0a                	mov    %ecx,(%edx)
  801e81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	01 c2                	add    %eax,%edx
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801e92:	eb 03                	jmp    801e97 <strsplit+0x8f>
			string++;
  801e94:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	8a 00                	mov    (%eax),%al
  801e9c:	84 c0                	test   %al,%al
  801e9e:	74 8b                	je     801e2b <strsplit+0x23>
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	8a 00                	mov    (%eax),%al
  801ea5:	0f be c0             	movsbl %al,%eax
  801ea8:	50                   	push   %eax
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	e8 b5 fa ff ff       	call   801966 <strchr>
  801eb1:	83 c4 08             	add    $0x8,%esp
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	74 dc                	je     801e94 <strsplit+0x8c>
			string++;
	}
  801eb8:	e9 6e ff ff ff       	jmp    801e2b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ebd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ed5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801ee2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ee9:	eb 4c                	jmp    801f37 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	8a 00                	mov    (%eax),%al
  801ef5:	3c 40                	cmp    $0x40,%al
  801ef7:	7e 27                	jle    801f20 <str2lower+0x44>
  801ef9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	01 d0                	add    %edx,%eax
  801f01:	8a 00                	mov    (%eax),%al
  801f03:	3c 5a                	cmp    $0x5a,%al
  801f05:	7f 19                	jg     801f20 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	01 d0                	add    %edx,%eax
  801f0f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f15:	01 ca                	add    %ecx,%edx
  801f17:	8a 12                	mov    (%edx),%dl
  801f19:	83 c2 20             	add    $0x20,%edx
  801f1c:	88 10                	mov    %dl,(%eax)
  801f1e:	eb 14                	jmp    801f34 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801f20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	01 c2                	add    %eax,%edx
  801f28:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2e:	01 c8                	add    %ecx,%eax
  801f30:	8a 00                	mov    (%eax),%al
  801f32:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801f34:	ff 45 fc             	incl   -0x4(%ebp)
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	e8 95 f8 ff ff       	call   8017d4 <strlen>
  801f3f:	83 c4 04             	add    $0x4,%esp
  801f42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f45:	7f a4                	jg     801eeb <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801f5a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f62:	89 14 c5 40 93 80 00 	mov    %edx,0x809340(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801f69:	a1 48 50 80 00       	mov    0x805048,%eax
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f71:	89 14 c5 44 93 80 00 	mov    %edx,0x809344(,%eax,8)
	marked_pagessize++;
  801f78:	a1 48 50 80 00       	mov    0x805048,%eax
  801f7d:	40                   	inc    %eax
  801f7e:	a3 48 50 80 00       	mov    %eax,0x805048
}
  801f83:	90                   	nop
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    

00801f86 <searchElement>:

int searchElement(uint32 start) {
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f93:	eb 17                	jmp    801fac <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f98:	8b 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%eax
  801f9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa2:	75 05                	jne    801fa9 <searchElement+0x23>
			return i;
  801fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa7:	eb 12                	jmp    801fbb <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801fa9:	ff 45 fc             	incl   -0x4(%ebp)
  801fac:	a1 48 50 80 00       	mov    0x805048,%eax
  801fb1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801fb4:	7c df                	jl     801f95 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <removeElement>:
void removeElement(uint32 start) {
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	e8 bb ff ff ff       	call   801f86 <searchElement>
  801fcb:	83 c4 04             	add    $0x4,%esp
  801fce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801fd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd7:	eb 26                	jmp    801fff <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801fd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdc:	40                   	inc    %eax
  801fdd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801fe0:	8b 14 c5 44 93 80 00 	mov    0x809344(,%eax,8),%edx
  801fe7:	8b 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%eax
  801fee:	89 04 cd 40 93 80 00 	mov    %eax,0x809340(,%ecx,8)
  801ff5:	89 14 cd 44 93 80 00 	mov    %edx,0x809344(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801ffc:	ff 45 fc             	incl   -0x4(%ebp)
  801fff:	a1 48 50 80 00       	mov    0x805048,%eax
  802004:	48                   	dec    %eax
  802005:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802008:	7f cf                	jg     801fd9 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  80200a:	a1 48 50 80 00       	mov    0x805048,%eax
  80200f:	48                   	dec    %eax
  802010:	a3 48 50 80 00       	mov    %eax,0x805048
}
  802015:	90                   	nop
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <searchfree>:
int searchfree(uint32 end)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80201e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802025:	eb 17                	jmp    80203e <searchfree+0x26>
		if (marked_pages[i].end == end) {
  802027:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202a:	8b 04 c5 44 93 80 00 	mov    0x809344(,%eax,8),%eax
  802031:	3b 45 08             	cmp    0x8(%ebp),%eax
  802034:	75 05                	jne    80203b <searchfree+0x23>
			return i;
  802036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802039:	eb 12                	jmp    80204d <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  80203b:	ff 45 fc             	incl   -0x4(%ebp)
  80203e:	a1 48 50 80 00       	mov    0x805048,%eax
  802043:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  802046:	7c df                	jl     802027 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  802048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <removefree>:
void removefree(uint32 end)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  802055:	eb 52                	jmp    8020a9 <removefree+0x5a>
		int index = searchfree(end);
  802057:	ff 75 08             	pushl  0x8(%ebp)
  80205a:	e8 b9 ff ff ff       	call   802018 <searchfree>
  80205f:	83 c4 04             	add    $0x4,%esp
  802062:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  802065:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802068:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80206b:	eb 26                	jmp    802093 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  80206d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802070:	40                   	inc    %eax
  802071:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802074:	8b 14 c5 44 93 80 00 	mov    0x809344(,%eax,8),%edx
  80207b:	8b 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%eax
  802082:	89 04 cd 40 93 80 00 	mov    %eax,0x809340(,%ecx,8)
  802089:	89 14 cd 44 93 80 00 	mov    %edx,0x809344(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  802090:	ff 45 fc             	incl   -0x4(%ebp)
  802093:	a1 48 50 80 00       	mov    0x805048,%eax
  802098:	48                   	dec    %eax
  802099:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80209c:	7f cf                	jg     80206d <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  80209e:	a1 48 50 80 00       	mov    0x805048,%eax
  8020a3:	48                   	dec    %eax
  8020a4:	a3 48 50 80 00       	mov    %eax,0x805048
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	e8 67 ff ff ff       	call   802018 <searchfree>
  8020b1:	83 c4 04             	add    $0x4,%esp
  8020b4:	83 f8 ff             	cmp    $0xffffffff,%eax
  8020b7:	75 9e                	jne    802057 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8020b9:	90                   	nop
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <printArray>:
void printArray() {
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	68 10 4d 80 00       	push   $0x804d10
  8020ca:	e8 83 f0 ff ff       	call   801152 <cprintf>
  8020cf:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8020d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d9:	eb 29                	jmp    802104 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 14 c5 44 93 80 00 	mov    0x809344(,%eax,8),%edx
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	8b 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%eax
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f4:	68 21 4d 80 00       	push   $0x804d21
  8020f9:	e8 54 f0 ff ff       	call   801152 <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  802101:	ff 45 f4             	incl   -0xc(%ebp)
  802104:	a1 48 50 80 00       	mov    0x805048,%eax
  802109:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80210c:	7c cd                	jl     8020db <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  80210e:	90                   	nop
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  802114:	a1 20 50 80 00       	mov    0x805020,%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	74 0a                	je     802127 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80211d:	c7 05 20 50 80 00 00 	movl   $0x0,0x805020
  802124:	00 00 00 
	}
}
  802127:	90                   	nop
  802128:	5d                   	pop    %ebp
  802129:	c3                   	ret    

0080212a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802130:	83 ec 0c             	sub    $0xc,%esp
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 4f 09 00 00       	call   802a8a <sys_sbrk>
  80213b:	83 c4 10             	add    $0x10,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802146:	e8 c6 ff ff ff       	call   802111 <InitializeUHeap>
	if (size == 0) return NULL ;
  80214b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214f:	75 0a                	jne    80215b <malloc+0x1b>
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	e9 43 01 00 00       	jmp    80229e <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80215b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802162:	77 3c                	ja     8021a0 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802164:	e8 c3 07 00 00       	call   80292c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802169:	85 c0                	test   %eax,%eax
  80216b:	74 13                	je     802180 <malloc+0x40>
			return alloc_block_FF(size);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff 75 08             	pushl  0x8(%ebp)
  802173:	e8 89 0b 00 00       	call   802d01 <alloc_block_FF>
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	e9 1e 01 00 00       	jmp    80229e <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  802180:	e8 d8 07 00 00       	call   80295d <sys_isUHeapPlacementStrategyBESTFIT>
  802185:	85 c0                	test   %eax,%eax
  802187:	0f 84 0c 01 00 00    	je     802299 <malloc+0x159>
			return alloc_block_BF(size);
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	ff 75 08             	pushl  0x8(%ebp)
  802193:	e8 7d 0e 00 00       	call   803015 <alloc_block_BF>
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	e9 fe 00 00 00       	jmp    80229e <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8021a0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	48                   	dec    %eax
  8021b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8021b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bb:	f7 75 e0             	divl   -0x20(%ebp)
  8021be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021c1:	29 d0                	sub    %edx,%eax
  8021c3:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	c1 e8 0c             	shr    $0xc,%eax
  8021cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  8021cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  8021d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  8021dd:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  8021e4:	e8 f4 08 00 00       	call   802add <sys_hard_limit>
  8021e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8021ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021ef:	05 00 10 00 00       	add    $0x1000,%eax
  8021f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021f7:	eb 49                	jmp    802242 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8021ff:	e8 82 fd ff ff       	call   801f86 <searchElement>
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	83 f8 ff             	cmp    $0xffffffff,%eax
  80220a:	75 28                	jne    802234 <malloc+0xf4>
			{


				count++;
  80220c:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802215:	75 24                	jne    80223b <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  802217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221a:	05 00 10 00 00       	add    $0x1000,%eax
  80221f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	c1 e0 0c             	shl    $0xc,%eax
  802228:	89 c2                	mov    %eax,%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	29 d0                	sub    %edx,%eax
  80222f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  802232:	eb 17                	jmp    80224b <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  802234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80223b:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  802242:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802249:	76 ae                	jbe    8021f9 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  80224b:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  80224f:	75 07                	jne    802258 <malloc+0x118>
		{
			return NULL;
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	eb 46                	jmp    80229e <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  802258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80225e:	eb 1a                	jmp    80227a <malloc+0x13a>
		{
			addElement(i,end);
  802260:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802266:	83 ec 08             	sub    $0x8,%esp
  802269:	52                   	push   %edx
  80226a:	50                   	push   %eax
  80226b:	e8 e7 fc ff ff       	call   801f57 <addElement>
  802270:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  802273:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  80227a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802280:	7c de                	jl     802260 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	50                   	push   %eax
  80228c:	e8 30 08 00 00       	call   802ac1 <sys_allocate_user_mem>
  802291:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	eb 05                	jmp    80229e <malloc+0x15e>
	}
	return NULL;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax



}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  8022a6:	e8 32 08 00 00       	call   802add <sys_hard_limit>
  8022ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	0f 89 82 00 00 00    	jns    80233b <free+0x9b>
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022c1:	77 78                	ja     80233b <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022c9:	73 10                	jae    8022db <free+0x3b>
			free_block(virtual_address);
  8022cb:	83 ec 0c             	sub    $0xc,%esp
  8022ce:	ff 75 08             	pushl  0x8(%ebp)
  8022d1:	e8 d2 0e 00 00       	call   8031a8 <free_block>
  8022d6:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8022d9:	eb 77                	jmp    802352 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	83 ec 0c             	sub    $0xc,%esp
  8022e1:	50                   	push   %eax
  8022e2:	e8 9f fc ff ff       	call   801f86 <searchElement>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  8022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f0:	8b 14 c5 44 93 80 00 	mov    0x809344(,%eax,8),%edx
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	8b 04 c5 40 93 80 00 	mov    0x809340(,%eax,8),%eax
  802301:	29 c2                	sub    %eax,%edx
  802303:	89 d0                	mov    %edx,%eax
  802305:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	c1 e8 0c             	shr    $0xc,%eax
  80230e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	83 ec 08             	sub    $0x8,%esp
  802317:	ff 75 ec             	pushl  -0x14(%ebp)
  80231a:	50                   	push   %eax
  80231b:	e8 85 07 00 00       	call   802aa5 <sys_free_user_mem>
  802320:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	8b 04 c5 44 93 80 00 	mov    0x809344(,%eax,8),%eax
  80232d:	83 ec 0c             	sub    $0xc,%esp
  802330:	50                   	push   %eax
  802331:	e8 19 fd ff ff       	call   80204f <removefree>
  802336:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  802339:	eb 17                	jmp    802352 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 3a 4d 80 00       	push   $0x804d3a
  802343:	68 ac 00 00 00       	push   $0xac
  802348:	68 4a 4d 80 00       	push   $0x804d4a
  80234d:	e8 43 eb ff ff       	call   800e95 <_panic>
	}
}
  802352:	90                   	nop
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 18             	sub    $0x18,%esp
  80235b:	8b 45 10             	mov    0x10(%ebp),%eax
  80235e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802361:	e8 ab fd ff ff       	call   802111 <InitializeUHeap>
	if (size == 0) return NULL ;
  802366:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80236a:	75 07                	jne    802373 <smalloc+0x1e>
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	eb 17                	jmp    80238a <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 58 4d 80 00       	push   $0x804d58
  80237b:	68 bc 00 00 00       	push   $0xbc
  802380:	68 4a 4d 80 00       	push   $0x804d4a
  802385:	e8 0b eb ff ff       	call   800e95 <_panic>
	return NULL;
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802392:	e8 7a fd ff ff       	call   802111 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	68 80 4d 80 00       	push   $0x804d80
  80239f:	68 ca 00 00 00       	push   $0xca
  8023a4:	68 4a 4d 80 00       	push   $0x804d4a
  8023a9:	e8 e7 ea ff ff       	call   800e95 <_panic>

008023ae <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023b4:	e8 58 fd ff ff       	call   802111 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	68 a4 4d 80 00       	push   $0x804da4
  8023c1:	68 ea 00 00 00       	push   $0xea
  8023c6:	68 4a 4d 80 00       	push   $0x804d4a
  8023cb:	e8 c5 ea ff ff       	call   800e95 <_panic>

008023d0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	68 cc 4d 80 00       	push   $0x804dcc
  8023de:	68 fe 00 00 00       	push   $0xfe
  8023e3:	68 4a 4d 80 00       	push   $0x804d4a
  8023e8:	e8 a8 ea ff ff       	call   800e95 <_panic>

008023ed <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	68 f0 4d 80 00       	push   $0x804df0
  8023fb:	68 08 01 00 00       	push   $0x108
  802400:	68 4a 4d 80 00       	push   $0x804d4a
  802405:	e8 8b ea ff ff       	call   800e95 <_panic>

0080240a <shrink>:

}
void shrink(uint32 newSize)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	68 f0 4d 80 00       	push   $0x804df0
  802418:	68 0d 01 00 00       	push   $0x10d
  80241d:	68 4a 4d 80 00       	push   $0x804d4a
  802422:	e8 6e ea ff ff       	call   800e95 <_panic>

00802427 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	68 f0 4d 80 00       	push   $0x804df0
  802435:	68 12 01 00 00       	push   $0x112
  80243a:	68 4a 4d 80 00       	push   $0x804d4a
  80243f:	e8 51 ea ff ff       	call   800e95 <_panic>

00802444 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	57                   	push   %edi
  802448:	56                   	push   %esi
  802449:	53                   	push   %ebx
  80244a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802456:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802459:	8b 7d 18             	mov    0x18(%ebp),%edi
  80245c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80245f:	cd 30                	int    $0x30
  802461:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	5b                   	pop    %ebx
  80246b:	5e                   	pop    %esi
  80246c:	5f                   	pop    %edi
  80246d:	5d                   	pop    %ebp
  80246e:	c3                   	ret    

0080246f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	8b 45 10             	mov    0x10(%ebp),%eax
  802478:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80247b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	52                   	push   %edx
  802487:	ff 75 0c             	pushl  0xc(%ebp)
  80248a:	50                   	push   %eax
  80248b:	6a 00                	push   $0x0
  80248d:	e8 b2 ff ff ff       	call   802444 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_cgetc>:

int
sys_cgetc(void)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 01                	push   $0x1
  8024a7:	e8 98 ff ff ff       	call   802444 <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	52                   	push   %edx
  8024c1:	50                   	push   %eax
  8024c2:	6a 05                	push   $0x5
  8024c4:	e8 7b ff ff ff       	call   802444 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	56                   	push   %esi
  8024d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8024d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	51                   	push   %ecx
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 06                	push   $0x6
  8024e9:	e8 56 ff ff ff       	call   802444 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5d                   	pop    %ebp
  8024f7:	c3                   	ret    

008024f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	52                   	push   %edx
  802508:	50                   	push   %eax
  802509:	6a 07                	push   $0x7
  80250b:	e8 34 ff ff ff       	call   802444 <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	ff 75 0c             	pushl  0xc(%ebp)
  802521:	ff 75 08             	pushl  0x8(%ebp)
  802524:	6a 08                	push   $0x8
  802526:	e8 19 ff ff ff       	call   802444 <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 09                	push   $0x9
  80253f:	e8 00 ff ff ff       	call   802444 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 0a                	push   $0xa
  802558:	e8 e7 fe ff ff       	call   802444 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 0b                	push   $0xb
  802571:	e8 ce fe ff ff       	call   802444 <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
}
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 0c                	push   $0xc
  80258a:	e8 b5 fe ff ff       	call   802444 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	ff 75 08             	pushl  0x8(%ebp)
  8025a2:	6a 0d                	push   $0xd
  8025a4:	e8 9b fe ff ff       	call   802444 <syscall>
  8025a9:	83 c4 18             	add    $0x18,%esp
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 0e                	push   $0xe
  8025bd:	e8 82 fe ff ff       	call   802444 <syscall>
  8025c2:	83 c4 18             	add    $0x18,%esp
}
  8025c5:	90                   	nop
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 11                	push   $0x11
  8025d7:	e8 68 fe ff ff       	call   802444 <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	90                   	nop
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 12                	push   $0x12
  8025f1:	e8 4e fe ff ff       	call   802444 <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
}
  8025f9:	90                   	nop
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_cputc>:


void
sys_cputc(const char c)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802608:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	50                   	push   %eax
  802615:	6a 13                	push   $0x13
  802617:	e8 28 fe ff ff       	call   802444 <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
}
  80261f:	90                   	nop
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 14                	push   $0x14
  802631:	e8 0e fe ff ff       	call   802444 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
}
  802639:	90                   	nop
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	ff 75 0c             	pushl  0xc(%ebp)
  80264b:	50                   	push   %eax
  80264c:	6a 15                	push   $0x15
  80264e:	e8 f1 fd ff ff       	call   802444 <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80265b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	52                   	push   %edx
  802668:	50                   	push   %eax
  802669:	6a 18                	push   $0x18
  80266b:	e8 d4 fd ff ff       	call   802444 <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	52                   	push   %edx
  802685:	50                   	push   %eax
  802686:	6a 16                	push   $0x16
  802688:	e8 b7 fd ff ff       	call   802444 <syscall>
  80268d:	83 c4 18             	add    $0x18,%esp
}
  802690:	90                   	nop
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802696:	8b 55 0c             	mov    0xc(%ebp),%edx
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	6a 17                	push   $0x17
  8026a6:	e8 99 fd ff ff       	call   802444 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	90                   	nop
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	6a 00                	push   $0x0
  8026c9:	51                   	push   %ecx
  8026ca:	52                   	push   %edx
  8026cb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ce:	50                   	push   %eax
  8026cf:	6a 19                	push   $0x19
  8026d1:	e8 6e fd ff ff       	call   802444 <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8026de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	52                   	push   %edx
  8026eb:	50                   	push   %eax
  8026ec:	6a 1a                	push   $0x1a
  8026ee:	e8 51 fd ff ff       	call   802444 <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
}
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    

008026f8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8026fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	51                   	push   %ecx
  802709:	52                   	push   %edx
  80270a:	50                   	push   %eax
  80270b:	6a 1b                	push   $0x1b
  80270d:	e8 32 fd ff ff       	call   802444 <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80271a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	52                   	push   %edx
  802727:	50                   	push   %eax
  802728:	6a 1c                	push   $0x1c
  80272a:	e8 15 fd ff ff       	call   802444 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 1d                	push   $0x1d
  802743:	e8 fc fc ff ff       	call   802444 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	ff 75 14             	pushl  0x14(%ebp)
  802758:	ff 75 10             	pushl  0x10(%ebp)
  80275b:	ff 75 0c             	pushl  0xc(%ebp)
  80275e:	50                   	push   %eax
  80275f:	6a 1e                	push   $0x1e
  802761:	e8 de fc ff ff       	call   802444 <syscall>
  802766:	83 c4 18             	add    $0x18,%esp
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	50                   	push   %eax
  80277a:	6a 1f                	push   $0x1f
  80277c:	e8 c3 fc ff ff       	call   802444 <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	90                   	nop
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	50                   	push   %eax
  802796:	6a 20                	push   $0x20
  802798:	e8 a7 fc ff ff       	call   802444 <syscall>
  80279d:	83 c4 18             	add    $0x18,%esp
}
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 02                	push   $0x2
  8027b1:	e8 8e fc ff ff       	call   802444 <syscall>
  8027b6:	83 c4 18             	add    $0x18,%esp
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 03                	push   $0x3
  8027ca:	e8 75 fc ff ff       	call   802444 <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 04                	push   $0x4
  8027e3:	e8 5c fc ff ff       	call   802444 <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <sys_exit_env>:


void sys_exit_env(void)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 21                	push   $0x21
  8027fc:	e8 43 fc ff ff       	call   802444 <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
}
  802804:	90                   	nop
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80280d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802810:	8d 50 04             	lea    0x4(%eax),%edx
  802813:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	52                   	push   %edx
  80281d:	50                   	push   %eax
  80281e:	6a 22                	push   $0x22
  802820:	e8 1f fc ff ff       	call   802444 <syscall>
  802825:	83 c4 18             	add    $0x18,%esp
	return result;
  802828:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80282b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80282e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802831:	89 01                	mov    %eax,(%ecx)
  802833:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	c9                   	leave  
  80283a:	c2 04 00             	ret    $0x4

0080283d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	ff 75 10             	pushl  0x10(%ebp)
  802847:	ff 75 0c             	pushl  0xc(%ebp)
  80284a:	ff 75 08             	pushl  0x8(%ebp)
  80284d:	6a 10                	push   $0x10
  80284f:	e8 f0 fb ff ff       	call   802444 <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
	return ;
  802857:	90                   	nop
}
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <sys_rcr2>:
uint32 sys_rcr2()
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 23                	push   $0x23
  802869:	e8 d6 fb ff ff       	call   802444 <syscall>
  80286e:	83 c4 18             	add    $0x18,%esp
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80287f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	50                   	push   %eax
  80288c:	6a 24                	push   $0x24
  80288e:	e8 b1 fb ff ff       	call   802444 <syscall>
  802893:	83 c4 18             	add    $0x18,%esp
	return ;
  802896:	90                   	nop
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <rsttst>:
void rsttst()
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 26                	push   $0x26
  8028a8:	e8 97 fb ff ff       	call   802444 <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8028b0:	90                   	nop
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8028bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028bf:	8b 55 18             	mov    0x18(%ebp),%edx
  8028c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028c6:	52                   	push   %edx
  8028c7:	50                   	push   %eax
  8028c8:	ff 75 10             	pushl  0x10(%ebp)
  8028cb:	ff 75 0c             	pushl  0xc(%ebp)
  8028ce:	ff 75 08             	pushl  0x8(%ebp)
  8028d1:	6a 25                	push   $0x25
  8028d3:	e8 6c fb ff ff       	call   802444 <syscall>
  8028d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8028db:	90                   	nop
}
  8028dc:	c9                   	leave  
  8028dd:	c3                   	ret    

008028de <chktst>:
void chktst(uint32 n)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	ff 75 08             	pushl  0x8(%ebp)
  8028ec:	6a 27                	push   $0x27
  8028ee:	e8 51 fb ff ff       	call   802444 <syscall>
  8028f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f6:	90                   	nop
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <inctst>:

void inctst()
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 28                	push   $0x28
  802908:	e8 37 fb ff ff       	call   802444 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
	return ;
  802910:	90                   	nop
}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <gettst>:
uint32 gettst()
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 29                	push   $0x29
  802922:	e8 1d fb ff ff       	call   802444 <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
}
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 2a                	push   $0x2a
  80293e:	e8 01 fb ff ff       	call   802444 <syscall>
  802943:	83 c4 18             	add    $0x18,%esp
  802946:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802949:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80294d:	75 07                	jne    802956 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80294f:	b8 01 00 00 00       	mov    $0x1,%eax
  802954:	eb 05                	jmp    80295b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802956:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
  802960:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802963:	6a 00                	push   $0x0
  802965:	6a 00                	push   $0x0
  802967:	6a 00                	push   $0x0
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 2a                	push   $0x2a
  80296f:	e8 d0 fa ff ff       	call   802444 <syscall>
  802974:	83 c4 18             	add    $0x18,%esp
  802977:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80297a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80297e:	75 07                	jne    802987 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802980:	b8 01 00 00 00       	mov    $0x1,%eax
  802985:	eb 05                	jmp    80298c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298c:	c9                   	leave  
  80298d:	c3                   	ret    

0080298e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
  802991:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 2a                	push   $0x2a
  8029a0:	e8 9f fa ff ff       	call   802444 <syscall>
  8029a5:	83 c4 18             	add    $0x18,%esp
  8029a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029ab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029af:	75 07                	jne    8029b8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b6:	eb 05                	jmp    8029bd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029bd:	c9                   	leave  
  8029be:	c3                   	ret    

008029bf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
  8029c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 2a                	push   $0x2a
  8029d1:	e8 6e fa ff ff       	call   802444 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
  8029d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8029dc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8029e0:	75 07                	jne    8029e9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8029e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e7:	eb 05                	jmp    8029ee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8029e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ee:	c9                   	leave  
  8029ef:	c3                   	ret    

008029f0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	ff 75 08             	pushl  0x8(%ebp)
  8029fe:	6a 2b                	push   $0x2b
  802a00:	e8 3f fa ff ff       	call   802444 <syscall>
  802a05:	83 c4 18             	add    $0x18,%esp
	return ;
  802a08:	90                   	nop
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	6a 00                	push   $0x0
  802a1d:	53                   	push   %ebx
  802a1e:	51                   	push   %ecx
  802a1f:	52                   	push   %edx
  802a20:	50                   	push   %eax
  802a21:	6a 2c                	push   $0x2c
  802a23:	e8 1c fa ff ff       	call   802444 <syscall>
  802a28:	83 c4 18             	add    $0x18,%esp
}
  802a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 00                	push   $0x0
  802a3f:	52                   	push   %edx
  802a40:	50                   	push   %eax
  802a41:	6a 2d                	push   $0x2d
  802a43:	e8 fc f9 ff ff       	call   802444 <syscall>
  802a48:	83 c4 18             	add    $0x18,%esp
}
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802a50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	6a 00                	push   $0x0
  802a5b:	51                   	push   %ecx
  802a5c:	ff 75 10             	pushl  0x10(%ebp)
  802a5f:	52                   	push   %edx
  802a60:	50                   	push   %eax
  802a61:	6a 2e                	push   $0x2e
  802a63:	e8 dc f9 ff ff       	call   802444 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	ff 75 10             	pushl  0x10(%ebp)
  802a77:	ff 75 0c             	pushl  0xc(%ebp)
  802a7a:	ff 75 08             	pushl  0x8(%ebp)
  802a7d:	6a 0f                	push   $0xf
  802a7f:	e8 c0 f9 ff ff       	call   802444 <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
	return ;
  802a87:	90                   	nop
}
  802a88:	c9                   	leave  
  802a89:	c3                   	ret    

00802a8a <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	50                   	push   %eax
  802a99:	6a 2f                	push   $0x2f
  802a9b:	e8 a4 f9 ff ff       	call   802444 <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp

}
  802aa3:	c9                   	leave  
  802aa4:	c3                   	ret    

00802aa5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802aa5:	55                   	push   %ebp
  802aa6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	ff 75 0c             	pushl  0xc(%ebp)
  802ab1:	ff 75 08             	pushl  0x8(%ebp)
  802ab4:	6a 30                	push   $0x30
  802ab6:	e8 89 f9 ff ff       	call   802444 <syscall>
  802abb:	83 c4 18             	add    $0x18,%esp

}
  802abe:	90                   	nop
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	ff 75 0c             	pushl  0xc(%ebp)
  802acd:	ff 75 08             	pushl  0x8(%ebp)
  802ad0:	6a 31                	push   $0x31
  802ad2:	e8 6d f9 ff ff       	call   802444 <syscall>
  802ad7:	83 c4 18             	add    $0x18,%esp

}
  802ada:	90                   	nop
  802adb:	c9                   	leave  
  802adc:	c3                   	ret    

00802add <sys_hard_limit>:
uint32 sys_hard_limit(){
  802add:	55                   	push   %ebp
  802ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 32                	push   $0x32
  802aec:	e8 53 f9 ff ff       	call   802444 <syscall>
  802af1:	83 c4 18             	add    $0x18,%esp
}
  802af4:	c9                   	leave  
  802af5:	c3                   	ret    

00802af6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	83 e8 10             	sub    $0x10,%eax
  802b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  802b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	83 e8 10             	sub    $0x10,%eax
  802b18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b1e:	8a 40 04             	mov    0x4(%eax),%al
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b33:	83 f8 02             	cmp    $0x2,%eax
  802b36:	74 2b                	je     802b63 <alloc_block+0x40>
  802b38:	83 f8 02             	cmp    $0x2,%eax
  802b3b:	7f 07                	jg     802b44 <alloc_block+0x21>
  802b3d:	83 f8 01             	cmp    $0x1,%eax
  802b40:	74 0e                	je     802b50 <alloc_block+0x2d>
  802b42:	eb 58                	jmp    802b9c <alloc_block+0x79>
  802b44:	83 f8 03             	cmp    $0x3,%eax
  802b47:	74 2d                	je     802b76 <alloc_block+0x53>
  802b49:	83 f8 04             	cmp    $0x4,%eax
  802b4c:	74 3b                	je     802b89 <alloc_block+0x66>
  802b4e:	eb 4c                	jmp    802b9c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802b50:	83 ec 0c             	sub    $0xc,%esp
  802b53:	ff 75 08             	pushl  0x8(%ebp)
  802b56:	e8 a6 01 00 00       	call   802d01 <alloc_block_FF>
  802b5b:	83 c4 10             	add    $0x10,%esp
  802b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b61:	eb 4a                	jmp    802bad <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802b63:	83 ec 0c             	sub    $0xc,%esp
  802b66:	ff 75 08             	pushl  0x8(%ebp)
  802b69:	e8 1d 06 00 00       	call   80318b <alloc_block_NF>
  802b6e:	83 c4 10             	add    $0x10,%esp
  802b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b74:	eb 37                	jmp    802bad <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	ff 75 08             	pushl  0x8(%ebp)
  802b7c:	e8 94 04 00 00       	call   803015 <alloc_block_BF>
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b87:	eb 24                	jmp    802bad <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802b89:	83 ec 0c             	sub    $0xc,%esp
  802b8c:	ff 75 08             	pushl  0x8(%ebp)
  802b8f:	e8 da 05 00 00       	call   80316e <alloc_block_WF>
  802b94:	83 c4 10             	add    $0x10,%esp
  802b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802b9a:	eb 11                	jmp    802bad <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802b9c:	83 ec 0c             	sub    $0xc,%esp
  802b9f:	68 00 4e 80 00       	push   $0x804e00
  802ba4:	e8 a9 e5 ff ff       	call   801152 <cprintf>
  802ba9:	83 c4 10             	add    $0x10,%esp
		break;
  802bac:	90                   	nop
	}
	return va;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802bb0:	c9                   	leave  
  802bb1:	c3                   	ret    

00802bb2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802bb2:	55                   	push   %ebp
  802bb3:	89 e5                	mov    %esp,%ebp
  802bb5:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802bb8:	83 ec 0c             	sub    $0xc,%esp
  802bbb:	68 20 4e 80 00       	push   $0x804e20
  802bc0:	e8 8d e5 ff ff       	call   801152 <cprintf>
  802bc5:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802bc8:	83 ec 0c             	sub    $0xc,%esp
  802bcb:	68 4b 4e 80 00       	push   $0x804e4b
  802bd0:	e8 7d e5 ff ff       	call   801152 <cprintf>
  802bd5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bde:	eb 26                	jmp    802c06 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8a 40 04             	mov    0x4(%eax),%al
  802be6:	0f b6 d0             	movzbl %al,%edx
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	52                   	push   %edx
  802bf2:	50                   	push   %eax
  802bf3:	68 63 4e 80 00       	push   $0x804e63
  802bf8:	e8 55 e5 ff ff       	call   801152 <cprintf>
  802bfd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802c00:	8b 45 10             	mov    0x10(%ebp),%eax
  802c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	74 08                	je     802c14 <print_blocks_list+0x62>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 40 08             	mov    0x8(%eax),%eax
  802c12:	eb 05                	jmp    802c19 <print_blocks_list+0x67>
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
  802c19:	89 45 10             	mov    %eax,0x10(%ebp)
  802c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	75 bd                	jne    802be0 <print_blocks_list+0x2e>
  802c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c27:	75 b7                	jne    802be0 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802c29:	83 ec 0c             	sub    $0xc,%esp
  802c2c:	68 20 4e 80 00       	push   $0x804e20
  802c31:	e8 1c e5 ff ff       	call   801152 <cprintf>
  802c36:	83 c4 10             	add    $0x10,%esp

}
  802c39:	90                   	nop
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
  802c3f:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  802c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c46:	0f 84 b2 00 00 00    	je     802cfe <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802c4c:	c7 05 4c 50 80 00 01 	movl   $0x1,0x80504c
  802c53:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  802c56:	c7 05 18 93 80 00 00 	movl   $0x0,0x809318
  802c5d:	00 00 00 
  802c60:	c7 05 1c 93 80 00 00 	movl   $0x0,0x80931c
  802c67:	00 00 00 
  802c6a:	c7 05 24 93 80 00 00 	movl   $0x0,0x809324
  802c71:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 28 93 80 00       	mov    %eax,0x809328
		firstBlock->size = initSizeOfAllocatedSpace;
  802c7c:	a1 28 93 80 00       	mov    0x809328,%eax
  802c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c84:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  802c86:	a1 28 93 80 00       	mov    0x809328,%eax
  802c8b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  802c8f:	a1 28 93 80 00       	mov    0x809328,%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	75 14                	jne    802cac <initialize_dynamic_allocator+0x70>
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 7c 4e 80 00       	push   $0x804e7c
  802ca0:	6a 68                	push   $0x68
  802ca2:	68 9f 4e 80 00       	push   $0x804e9f
  802ca7:	e8 e9 e1 ff ff       	call   800e95 <_panic>
  802cac:	a1 28 93 80 00       	mov    0x809328,%eax
  802cb1:	8b 15 18 93 80 00    	mov    0x809318,%edx
  802cb7:	89 50 08             	mov    %edx,0x8(%eax)
  802cba:	8b 40 08             	mov    0x8(%eax),%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	74 10                	je     802cd1 <initialize_dynamic_allocator+0x95>
  802cc1:	a1 18 93 80 00       	mov    0x809318,%eax
  802cc6:	8b 15 28 93 80 00    	mov    0x809328,%edx
  802ccc:	89 50 0c             	mov    %edx,0xc(%eax)
  802ccf:	eb 0a                	jmp    802cdb <initialize_dynamic_allocator+0x9f>
  802cd1:	a1 28 93 80 00       	mov    0x809328,%eax
  802cd6:	a3 1c 93 80 00       	mov    %eax,0x80931c
  802cdb:	a1 28 93 80 00       	mov    0x809328,%eax
  802ce0:	a3 18 93 80 00       	mov    %eax,0x809318
  802ce5:	a1 28 93 80 00       	mov    0x809328,%eax
  802cea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802cf1:	a1 24 93 80 00       	mov    0x809324,%eax
  802cf6:	40                   	inc    %eax
  802cf7:	a3 24 93 80 00       	mov    %eax,0x809324
  802cfc:	eb 01                	jmp    802cff <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802cfe:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  802d07:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	75 40                	jne    802d50 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	83 c0 10             	add    $0x10,%eax
  802d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	83 ec 0c             	sub    $0xc,%esp
  802d1f:	50                   	push   %eax
  802d20:	e8 05 f4 ff ff       	call   80212a <sbrk>
  802d25:	83 c4 10             	add    $0x10,%esp
  802d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802d2b:	83 ec 0c             	sub    $0xc,%esp
  802d2e:	6a 00                	push   $0x0
  802d30:	e8 f5 f3 ff ff       	call   80212a <sbrk>
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802d41:	83 ec 08             	sub    $0x8,%esp
  802d44:	50                   	push   %eax
  802d45:	ff 75 ec             	pushl  -0x14(%ebp)
  802d48:	e8 ef fe ff ff       	call   802c3c <initialize_dynamic_allocator>
  802d4d:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802d50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d54:	75 0a                	jne    802d60 <alloc_block_FF+0x5f>
		 return NULL;
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	e9 b3 02 00 00       	jmp    803013 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  802d60:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  802d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  802d6b:	a1 18 93 80 00       	mov    0x809318,%eax
  802d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d73:	e9 12 01 00 00       	jmp    802e8a <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8a 40 04             	mov    0x4(%eax),%al
  802d7e:	84 c0                	test   %al,%al
  802d80:	0f 84 fc 00 00 00    	je     802e82 <alloc_block_FF+0x181>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d8e:	0f 82 ee 00 00 00    	jb     802e82 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9c:	75 12                	jne    802db0 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	83 c0 10             	add    $0x10,%eax
  802dab:	e9 63 02 00 00       	jmp    803013 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  802db0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc6:	83 f8 0f             	cmp    $0xf,%eax
  802dc9:	0f 86 a8 00 00 00    	jbe    802e77 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	2b 45 08             	sub    0x8(%ebp),%eax
  802de2:	89 c2                	mov    %eax,%edx
  802de4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802de7:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 55 08             	mov    0x8(%ebp),%edx
  802def:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802df1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802df4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	74 06                	je     802e04 <alloc_block_FF+0x103>
  802dfe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e02:	75 17                	jne    802e1b <alloc_block_FF+0x11a>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 b8 4e 80 00       	push   $0x804eb8
  802e0c:	68 91 00 00 00       	push   $0x91
  802e11:	68 9f 4e 80 00       	push   $0x804e9f
  802e16:	e8 7a e0 ff ff       	call   800e95 <_panic>
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 50 08             	mov    0x8(%eax),%edx
  802e21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e24:	89 50 08             	mov    %edx,0x8(%eax)
  802e27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0c                	je     802e3d <alloc_block_FF+0x13c>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 08             	mov    0x8(%eax),%eax
  802e37:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e3a:	89 50 0c             	mov    %edx,0xc(%eax)
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e43:	89 50 08             	mov    %edx,0x8(%eax)
  802e46:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4c:	89 50 0c             	mov    %edx,0xc(%eax)
  802e4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	75 08                	jne    802e61 <alloc_block_FF+0x160>
  802e59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e5c:	a3 1c 93 80 00       	mov    %eax,0x80931c
  802e61:	a1 24 93 80 00       	mov    0x809324,%eax
  802e66:	40                   	inc    %eax
  802e67:	a3 24 93 80 00       	mov    %eax,0x809324
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	83 c0 10             	add    $0x10,%eax
  802e72:	e9 9c 01 00 00       	jmp    803013 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	83 c0 10             	add    $0x10,%eax
  802e7d:	e9 91 01 00 00       	jmp    803013 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802e82:	a1 20 93 80 00       	mov    0x809320,%eax
  802e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8e:	74 08                	je     802e98 <alloc_block_FF+0x197>
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	eb 05                	jmp    802e9d <alloc_block_FF+0x19c>
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9d:	a3 20 93 80 00       	mov    %eax,0x809320
  802ea2:	a1 20 93 80 00       	mov    0x809320,%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	0f 85 c9 fe ff ff    	jne    802d78 <alloc_block_FF+0x77>
  802eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb3:	0f 85 bf fe ff ff    	jne    802d78 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802eb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ebd:	0f 85 4b 01 00 00    	jne    80300e <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	83 ec 0c             	sub    $0xc,%esp
  802ec9:	50                   	push   %eax
  802eca:	e8 5b f2 ff ff       	call   80212a <sbrk>
  802ecf:	83 c4 10             	add    $0x10,%esp
  802ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed9:	0f 84 28 01 00 00    	je     803007 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802ef4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ef8:	75 17                	jne    802f11 <alloc_block_FF+0x210>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 ec 4e 80 00       	push   $0x804eec
  802f02:	68 a1 00 00 00       	push   $0xa1
  802f07:	68 9f 4e 80 00       	push   $0x804e9f
  802f0c:	e8 84 df ff ff       	call   800e95 <_panic>
  802f11:	8b 15 1c 93 80 00    	mov    0x80931c,%edx
  802f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
  802f1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0d                	je     802f34 <alloc_block_FF+0x233>
  802f27:	a1 1c 93 80 00       	mov    0x80931c,%eax
  802f2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f2f:	89 50 08             	mov    %edx,0x8(%eax)
  802f32:	eb 08                	jmp    802f3c <alloc_block_FF+0x23b>
  802f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f37:	a3 18 93 80 00       	mov    %eax,0x809318
  802f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3f:	a3 1c 93 80 00       	mov    %eax,0x80931c
  802f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f4e:	a1 24 93 80 00       	mov    0x809324,%eax
  802f53:	40                   	inc    %eax
  802f54:	a3 24 93 80 00       	mov    %eax,0x809324
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802f59:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f5e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f61:	83 f8 0f             	cmp    $0xf,%eax
  802f64:	0f 86 95 00 00 00    	jbe    802fff <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	01 d0                	add    %edx,%eax
  802f72:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802f75:	b8 00 10 00 00       	mov    $0x1000,%eax
  802f7a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7d:	89 c2                	mov    %eax,%edx
  802f7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f82:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802f84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f87:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802f8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f8f:	74 06                	je     802f97 <alloc_block_FF+0x296>
  802f91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f95:	75 17                	jne    802fae <alloc_block_FF+0x2ad>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 b8 4e 80 00       	push   $0x804eb8
  802f9f:	68 a6 00 00 00       	push   $0xa6
  802fa4:	68 9f 4e 80 00       	push   $0x804e9f
  802fa9:	e8 e7 de ff ff       	call   800e95 <_panic>
  802fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb7:	89 50 08             	mov    %edx,0x8(%eax)
  802fba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbd:	8b 40 08             	mov    0x8(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 0c                	je     802fd0 <alloc_block_FF+0x2cf>
  802fc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc7:	8b 40 08             	mov    0x8(%eax),%eax
  802fca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcd:	89 50 0c             	mov    %edx,0xc(%eax)
  802fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd6:	89 50 08             	mov    %edx,0x8(%eax)
  802fd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fdf:	89 50 0c             	mov    %edx,0xc(%eax)
  802fe2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	75 08                	jne    802ff4 <alloc_block_FF+0x2f3>
  802fec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fef:	a3 1c 93 80 00       	mov    %eax,0x80931c
  802ff4:	a1 24 93 80 00       	mov    0x809324,%eax
  802ff9:	40                   	inc    %eax
  802ffa:	a3 24 93 80 00       	mov    %eax,0x809324
			 }
			 return (sb + 1);
  802fff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803002:	83 c0 10             	add    $0x10,%eax
  803005:	eb 0c                	jmp    803013 <alloc_block_FF+0x312>
		 }
		 return NULL;
  803007:	b8 00 00 00 00       	mov    $0x0,%eax
  80300c:	eb 05                	jmp    803013 <alloc_block_FF+0x312>
	 }
	 return NULL;
  80300e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
  803018:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  80301b:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  80301f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  803026:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  80302d:	a1 18 93 80 00       	mov    0x809318,%eax
  803032:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803035:	eb 34                	jmp    80306b <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	8a 40 04             	mov    0x4(%eax),%al
  80303d:	84 c0                	test   %al,%al
  80303f:	74 22                	je     803063 <alloc_block_BF+0x4e>
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	3b 45 08             	cmp    0x8(%ebp),%eax
  803049:	72 18                	jb     803063 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  80304b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803053:	73 0e                	jae    803063 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  803055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803058:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  80305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  803063:	a1 20 93 80 00       	mov    0x809320,%eax
  803068:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80306b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306f:	74 08                	je     803079 <alloc_block_BF+0x64>
  803071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803074:	8b 40 08             	mov    0x8(%eax),%eax
  803077:	eb 05                	jmp    80307e <alloc_block_BF+0x69>
  803079:	b8 00 00 00 00       	mov    $0x0,%eax
  80307e:	a3 20 93 80 00       	mov    %eax,0x809320
  803083:	a1 20 93 80 00       	mov    0x809320,%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	75 ab                	jne    803037 <alloc_block_BF+0x22>
  80308c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803090:	75 a5                	jne    803037 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  803092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803096:	0f 84 cb 00 00 00    	je     803167 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ab:	0f 86 ae 00 00 00    	jbe    80315f <alloc_block_BF+0x14a>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8030b9:	83 f8 0f             	cmp    $0xf,%eax
  8030bc:	0f 86 9d 00 00 00    	jbe    80315f <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8030c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	01 d0                	add    %edx,%eax
  8030ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d5:	89 c2                	mov    %eax,%edx
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  8030eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ef:	74 06                	je     8030f7 <alloc_block_BF+0xe2>
  8030f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f5:	75 17                	jne    80310e <alloc_block_BF+0xf9>
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 b8 4e 80 00       	push   $0x804eb8
  8030ff:	68 c6 00 00 00       	push   $0xc6
  803104:	68 9f 4e 80 00       	push   $0x804e9f
  803109:	e8 87 dd ff ff       	call   800e95 <_panic>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 50 08             	mov    0x8(%eax),%edx
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	89 50 08             	mov    %edx,0x8(%eax)
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 08             	mov    0x8(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0c                	je     803130 <alloc_block_BF+0x11b>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 40 08             	mov    0x8(%eax),%eax
  80312a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312d:	89 50 0c             	mov    %edx,0xc(%eax)
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803136:	89 50 08             	mov    %edx,0x8(%eax)
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313f:	89 50 0c             	mov    %edx,0xc(%eax)
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 40 08             	mov    0x8(%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	75 08                	jne    803154 <alloc_block_BF+0x13f>
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	a3 1c 93 80 00       	mov    %eax,0x80931c
  803154:	a1 24 93 80 00       	mov    0x809324,%eax
  803159:	40                   	inc    %eax
  80315a:	a3 24 93 80 00       	mov    %eax,0x809324
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	83 c0 10             	add    $0x10,%eax
  803165:	eb 05                	jmp    80316c <alloc_block_BF+0x157>
    }

    return NULL;
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80316c:	c9                   	leave  
  80316d:	c3                   	ret    

0080316e <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80316e:	55                   	push   %ebp
  80316f:	89 e5                	mov    %esp,%ebp
  803171:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803174:	83 ec 04             	sub    $0x4,%esp
  803177:	68 10 4f 80 00       	push   $0x804f10
  80317c:	68 d2 00 00 00       	push   $0xd2
  803181:	68 9f 4e 80 00       	push   $0x804e9f
  803186:	e8 0a dd ff ff       	call   800e95 <_panic>

0080318b <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80318b:	55                   	push   %ebp
  80318c:	89 e5                	mov    %esp,%ebp
  80318e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	68 38 4f 80 00       	push   $0x804f38
  803199:	68 db 00 00 00       	push   $0xdb
  80319e:	68 9f 4e 80 00       	push   $0x804e9f
  8031a3:	e8 ed dc ff ff       	call   800e95 <_panic>

008031a8 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  8031a8:	55                   	push   %ebp
  8031a9:	89 e5                	mov    %esp,%ebp
  8031ab:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  8031ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b2:	0f 84 d2 01 00 00    	je     80338a <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	83 e8 10             	sub    $0x10,%eax
  8031be:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8a 40 04             	mov    0x4(%eax),%al
  8031c7:	84 c0                	test   %al,%al
  8031c9:	0f 85 be 01 00 00    	jne    80338d <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	8b 40 08             	mov    0x8(%eax),%eax
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	0f 84 cc 00 00 00    	je     8032b0 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 40 08             	mov    0x8(%eax),%eax
  8031ea:	8a 40 04             	mov    0x4(%eax),%al
  8031ed:	84 c0                	test   %al,%al
  8031ef:	0f 84 bb 00 00 00    	je     8032b0 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	8b 10                	mov    (%eax),%edx
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	01 c2                	add    %eax,%edx
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	8b 40 08             	mov    0x8(%eax),%eax
  80320f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	8b 40 08             	mov    0x8(%eax),%eax
  803219:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 08             	mov    0x8(%eax),%eax
  803225:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  803228:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322c:	75 17                	jne    803245 <free_block+0x9d>
  80322e:	83 ec 04             	sub    $0x4,%esp
  803231:	68 5e 4f 80 00       	push   $0x804f5e
  803236:	68 f8 00 00 00       	push   $0xf8
  80323b:	68 9f 4e 80 00       	push   $0x804e9f
  803240:	e8 50 dc ff ff       	call   800e95 <_panic>
  803245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803248:	8b 40 08             	mov    0x8(%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 11                	je     803260 <free_block+0xb8>
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	8b 40 08             	mov    0x8(%eax),%eax
  803255:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803258:	8b 52 0c             	mov    0xc(%edx),%edx
  80325b:	89 50 0c             	mov    %edx,0xc(%eax)
  80325e:	eb 0b                	jmp    80326b <free_block+0xc3>
  803260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	a3 1c 93 80 00       	mov    %eax,0x80931c
  80326b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	74 11                	je     803286 <free_block+0xde>
  803275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327e:	8b 52 08             	mov    0x8(%edx),%edx
  803281:	89 50 08             	mov    %edx,0x8(%eax)
  803284:	eb 0b                	jmp    803291 <free_block+0xe9>
  803286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803289:	8b 40 08             	mov    0x8(%eax),%eax
  80328c:	a3 18 93 80 00       	mov    %eax,0x809318
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8032a5:	a1 24 93 80 00       	mov    0x809324,%eax
  8032aa:	48                   	dec    %eax
  8032ab:	a3 24 93 80 00       	mov    %eax,0x809324
				}
			}
			if( LIST_PREV(block))
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	0f 84 d0 00 00 00    	je     80338e <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c4:	8a 40 04             	mov    0x4(%eax),%al
  8032c7:	84 c0                	test   %al,%al
  8032c9:	0f 84 bf 00 00 00    	je     80338e <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8032db:	8b 0a                	mov    (%edx),%ecx
  8032dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e0:	8b 12                	mov    (%edx),%edx
  8032e2:	01 ca                	add    %ecx,%edx
  8032e4:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ec:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  803300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803304:	75 17                	jne    80331d <free_block+0x175>
  803306:	83 ec 04             	sub    $0x4,%esp
  803309:	68 5e 4f 80 00       	push   $0x804f5e
  80330e:	68 03 01 00 00       	push   $0x103
  803313:	68 9f 4e 80 00       	push   $0x804e9f
  803318:	e8 78 db ff ff       	call   800e95 <_panic>
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 40 08             	mov    0x8(%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 11                	je     803338 <free_block+0x190>
  803327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332a:	8b 40 08             	mov    0x8(%eax),%eax
  80332d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803330:	8b 52 0c             	mov    0xc(%edx),%edx
  803333:	89 50 0c             	mov    %edx,0xc(%eax)
  803336:	eb 0b                	jmp    803343 <free_block+0x19b>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 40 0c             	mov    0xc(%eax),%eax
  80333e:	a3 1c 93 80 00       	mov    %eax,0x80931c
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 40 0c             	mov    0xc(%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 11                	je     80335e <free_block+0x1b6>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 40 0c             	mov    0xc(%eax),%eax
  803353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803356:	8b 52 08             	mov    0x8(%edx),%edx
  803359:	89 50 08             	mov    %edx,0x8(%eax)
  80335c:	eb 0b                	jmp    803369 <free_block+0x1c1>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 40 08             	mov    0x8(%eax),%eax
  803364:	a3 18 93 80 00       	mov    %eax,0x809318
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80337d:	a1 24 93 80 00       	mov    0x809324,%eax
  803382:	48                   	dec    %eax
  803383:	a3 24 93 80 00       	mov    %eax,0x809324
  803388:	eb 04                	jmp    80338e <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  80338a:	90                   	nop
  80338b:	eb 01                	jmp    80338e <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  80338d:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  80338e:	c9                   	leave  
  80338f:	c3                   	ret    

00803390 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803390:	55                   	push   %ebp
  803391:	89 e5                	mov    %esp,%ebp
  803393:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  803396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339a:	75 10                	jne    8033ac <realloc_block_FF+0x1c>
  80339c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a0:	75 0a                	jne    8033ac <realloc_block_FF+0x1c>
	 {
		 return NULL;
  8033a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a7:	e9 2e 03 00 00       	jmp    8036da <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  8033ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b0:	75 13                	jne    8033c5 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  8033b2:	83 ec 0c             	sub    $0xc,%esp
  8033b5:	ff 75 0c             	pushl  0xc(%ebp)
  8033b8:	e8 44 f9 ff ff       	call   802d01 <alloc_block_FF>
  8033bd:	83 c4 10             	add    $0x10,%esp
  8033c0:	e9 15 03 00 00       	jmp    8036da <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  8033c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c9:	75 18                	jne    8033e3 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  8033cb:	83 ec 0c             	sub    $0xc,%esp
  8033ce:	ff 75 08             	pushl  0x8(%ebp)
  8033d1:	e8 d2 fd ff ff       	call   8031a8 <free_block>
  8033d6:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  8033d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033de:	e9 f7 02 00 00       	jmp    8036da <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	83 e8 10             	sub    $0x10,%eax
  8033e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  8033ec:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033f8:	0f 82 c8 00 00 00    	jb     8034c6 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803406:	75 08                	jne    803410 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	e9 ca 02 00 00       	jmp    8036da <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	2b 45 0c             	sub    0xc(%ebp),%eax
  803418:	83 f8 0f             	cmp    $0xf,%eax
  80341b:	0f 86 9d 00 00 00    	jbe    8034be <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803424:	8b 45 0c             	mov    0xc(%ebp),%eax
  803427:	01 d0                	add    %edx,%eax
  803429:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	2b 45 0c             	sub    0xc(%ebp),%eax
  803434:	89 c2                	mov    %eax,%edx
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803441:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  803443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803446:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  80344a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344e:	74 06                	je     803456 <realloc_block_FF+0xc6>
  803450:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803454:	75 17                	jne    80346d <realloc_block_FF+0xdd>
  803456:	83 ec 04             	sub    $0x4,%esp
  803459:	68 b8 4e 80 00       	push   $0x804eb8
  80345e:	68 2a 01 00 00       	push   $0x12a
  803463:	68 9f 4e 80 00       	push   $0x804e9f
  803468:	e8 28 da ff ff       	call   800e95 <_panic>
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 50 08             	mov    0x8(%eax),%edx
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	89 50 08             	mov    %edx,0x8(%eax)
  803479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347c:	8b 40 08             	mov    0x8(%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0c                	je     80348f <realloc_block_FF+0xff>
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 08             	mov    0x8(%eax),%eax
  803489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348c:	89 50 0c             	mov    %edx,0xc(%eax)
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803495:	89 50 08             	mov    %edx,0x8(%eax)
  803498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349e:	89 50 0c             	mov    %edx,0xc(%eax)
  8034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a4:	8b 40 08             	mov    0x8(%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	75 08                	jne    8034b3 <realloc_block_FF+0x123>
  8034ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ae:	a3 1c 93 80 00       	mov    %eax,0x80931c
  8034b3:	a1 24 93 80 00       	mov    0x809324,%eax
  8034b8:	40                   	inc    %eax
  8034b9:	a3 24 93 80 00       	mov    %eax,0x809324
	    	 }
	    	 return va;
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	e9 14 02 00 00       	jmp    8036da <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 40 08             	mov    0x8(%eax),%eax
  8034cc:	85 c0                	test   %eax,%eax
  8034ce:	0f 84 97 01 00 00    	je     80366b <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 40 08             	mov    0x8(%eax),%eax
  8034da:	8a 40 04             	mov    0x4(%eax),%al
  8034dd:	84 c0                	test   %al,%al
  8034df:	0f 84 86 01 00 00    	je     80366b <realloc_block_FF+0x2db>
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 10                	mov    (%eax),%edx
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	01 d0                	add    %edx,%eax
  8034f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034f7:	0f 82 6e 01 00 00    	jb     80366b <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 10                	mov    (%eax),%edx
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 40 08             	mov    0x8(%eax),%eax
  803508:	8b 00                	mov    (%eax),%eax
  80350a:	01 c2                	add    %eax,%edx
  80350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350f:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 40 08             	mov    0x8(%eax),%eax
  803517:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 40 08             	mov    0x8(%eax),%eax
  803521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  803527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352a:	8b 40 08             	mov    0x8(%eax),%eax
  80352d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  803530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803534:	75 17                	jne    80354d <realloc_block_FF+0x1bd>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 5e 4f 80 00       	push   $0x804f5e
  80353e:	68 38 01 00 00       	push   $0x138
  803543:	68 9f 4e 80 00       	push   $0x804e9f
  803548:	e8 48 d9 ff ff       	call   800e95 <_panic>
  80354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803550:	8b 40 08             	mov    0x8(%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 11                	je     803568 <realloc_block_FF+0x1d8>
  803557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355a:	8b 40 08             	mov    0x8(%eax),%eax
  80355d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803560:	8b 52 0c             	mov    0xc(%edx),%edx
  803563:	89 50 0c             	mov    %edx,0xc(%eax)
  803566:	eb 0b                	jmp    803573 <realloc_block_FF+0x1e3>
  803568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356b:	8b 40 0c             	mov    0xc(%eax),%eax
  80356e:	a3 1c 93 80 00       	mov    %eax,0x80931c
  803573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803576:	8b 40 0c             	mov    0xc(%eax),%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 11                	je     80358e <realloc_block_FF+0x1fe>
  80357d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803580:	8b 40 0c             	mov    0xc(%eax),%eax
  803583:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803586:	8b 52 08             	mov    0x8(%edx),%edx
  803589:	89 50 08             	mov    %edx,0x8(%eax)
  80358c:	eb 0b                	jmp    803599 <realloc_block_FF+0x209>
  80358e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803591:	8b 40 08             	mov    0x8(%eax),%eax
  803594:	a3 18 93 80 00       	mov    %eax,0x809318
  803599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8035ad:	a1 24 93 80 00       	mov    0x809324,%eax
  8035b2:	48                   	dec    %eax
  8035b3:	a3 24 93 80 00       	mov    %eax,0x809324
					 if(block->size - new_size >= sizeOfMetaData())
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035c0:	83 f8 0f             	cmp    $0xf,%eax
  8035c3:	0f 86 9d 00 00 00    	jbe    803666 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  8035c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cf:	01 d0                	add    %edx,%eax
  8035d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035dc:	89 c2                	mov    %eax,%edx
  8035de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e1:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e9:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  8035eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ee:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  8035f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f6:	74 06                	je     8035fe <realloc_block_FF+0x26e>
  8035f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035fc:	75 17                	jne    803615 <realloc_block_FF+0x285>
  8035fe:	83 ec 04             	sub    $0x4,%esp
  803601:	68 b8 4e 80 00       	push   $0x804eb8
  803606:	68 3f 01 00 00       	push   $0x13f
  80360b:	68 9f 4e 80 00       	push   $0x804e9f
  803610:	e8 80 d8 ff ff       	call   800e95 <_panic>
  803615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803618:	8b 50 08             	mov    0x8(%eax),%edx
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	89 50 08             	mov    %edx,0x8(%eax)
  803621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803624:	8b 40 08             	mov    0x8(%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 0c                	je     803637 <realloc_block_FF+0x2a7>
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	8b 40 08             	mov    0x8(%eax),%eax
  803631:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803634:	89 50 0c             	mov    %edx,0xc(%eax)
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363d:	89 50 08             	mov    %edx,0x8(%eax)
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803646:	89 50 0c             	mov    %edx,0xc(%eax)
  803649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364c:	8b 40 08             	mov    0x8(%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	75 08                	jne    80365b <realloc_block_FF+0x2cb>
  803653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803656:	a3 1c 93 80 00       	mov    %eax,0x80931c
  80365b:	a1 24 93 80 00       	mov    0x809324,%eax
  803660:	40                   	inc    %eax
  803661:	a3 24 93 80 00       	mov    %eax,0x809324
					 }
					 return va;
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	eb 6f                	jmp    8036da <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  80366b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366e:	83 e8 10             	sub    $0x10,%eax
  803671:	83 ec 0c             	sub    $0xc,%esp
  803674:	50                   	push   %eax
  803675:	e8 87 f6 ff ff       	call   802d01 <alloc_block_FF>
  80367a:	83 c4 10             	add    $0x10,%esp
  80367d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  803680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803684:	75 29                	jne    8036af <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  803686:	8b 45 0c             	mov    0xc(%ebp),%eax
  803689:	83 ec 0c             	sub    $0xc,%esp
  80368c:	50                   	push   %eax
  80368d:	e8 98 ea ff ff       	call   80212a <sbrk>
  803692:	83 c4 10             	add    $0x10,%esp
  803695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  803698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80369e:	75 07                	jne    8036a7 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  8036a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a5:	eb 33                	jmp    8036da <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  8036a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036aa:	83 c0 10             	add    $0x10,%eax
  8036ad:	eb 2b                	jmp    8036da <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	83 ec 04             	sub    $0x4,%esp
  8036b7:	50                   	push   %eax
  8036b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8036bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036be:	e8 2f e3 ff ff       	call   8019f2 <memcpy>
  8036c3:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  8036c6:	83 ec 0c             	sub    $0xc,%esp
  8036c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8036cc:	e8 d7 fa ff ff       	call   8031a8 <free_block>
  8036d1:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  8036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d7:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  8036da:	c9                   	leave  
  8036db:	c3                   	ret    

008036dc <__udivdi3>:
  8036dc:	55                   	push   %ebp
  8036dd:	57                   	push   %edi
  8036de:	56                   	push   %esi
  8036df:	53                   	push   %ebx
  8036e0:	83 ec 1c             	sub    $0x1c,%esp
  8036e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036f3:	89 ca                	mov    %ecx,%edx
  8036f5:	89 f8                	mov    %edi,%eax
  8036f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036fb:	85 f6                	test   %esi,%esi
  8036fd:	75 2d                	jne    80372c <__udivdi3+0x50>
  8036ff:	39 cf                	cmp    %ecx,%edi
  803701:	77 65                	ja     803768 <__udivdi3+0x8c>
  803703:	89 fd                	mov    %edi,%ebp
  803705:	85 ff                	test   %edi,%edi
  803707:	75 0b                	jne    803714 <__udivdi3+0x38>
  803709:	b8 01 00 00 00       	mov    $0x1,%eax
  80370e:	31 d2                	xor    %edx,%edx
  803710:	f7 f7                	div    %edi
  803712:	89 c5                	mov    %eax,%ebp
  803714:	31 d2                	xor    %edx,%edx
  803716:	89 c8                	mov    %ecx,%eax
  803718:	f7 f5                	div    %ebp
  80371a:	89 c1                	mov    %eax,%ecx
  80371c:	89 d8                	mov    %ebx,%eax
  80371e:	f7 f5                	div    %ebp
  803720:	89 cf                	mov    %ecx,%edi
  803722:	89 fa                	mov    %edi,%edx
  803724:	83 c4 1c             	add    $0x1c,%esp
  803727:	5b                   	pop    %ebx
  803728:	5e                   	pop    %esi
  803729:	5f                   	pop    %edi
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    
  80372c:	39 ce                	cmp    %ecx,%esi
  80372e:	77 28                	ja     803758 <__udivdi3+0x7c>
  803730:	0f bd fe             	bsr    %esi,%edi
  803733:	83 f7 1f             	xor    $0x1f,%edi
  803736:	75 40                	jne    803778 <__udivdi3+0x9c>
  803738:	39 ce                	cmp    %ecx,%esi
  80373a:	72 0a                	jb     803746 <__udivdi3+0x6a>
  80373c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803740:	0f 87 9e 00 00 00    	ja     8037e4 <__udivdi3+0x108>
  803746:	b8 01 00 00 00       	mov    $0x1,%eax
  80374b:	89 fa                	mov    %edi,%edx
  80374d:	83 c4 1c             	add    $0x1c,%esp
  803750:	5b                   	pop    %ebx
  803751:	5e                   	pop    %esi
  803752:	5f                   	pop    %edi
  803753:	5d                   	pop    %ebp
  803754:	c3                   	ret    
  803755:	8d 76 00             	lea    0x0(%esi),%esi
  803758:	31 ff                	xor    %edi,%edi
  80375a:	31 c0                	xor    %eax,%eax
  80375c:	89 fa                	mov    %edi,%edx
  80375e:	83 c4 1c             	add    $0x1c,%esp
  803761:	5b                   	pop    %ebx
  803762:	5e                   	pop    %esi
  803763:	5f                   	pop    %edi
  803764:	5d                   	pop    %ebp
  803765:	c3                   	ret    
  803766:	66 90                	xchg   %ax,%ax
  803768:	89 d8                	mov    %ebx,%eax
  80376a:	f7 f7                	div    %edi
  80376c:	31 ff                	xor    %edi,%edi
  80376e:	89 fa                	mov    %edi,%edx
  803770:	83 c4 1c             	add    $0x1c,%esp
  803773:	5b                   	pop    %ebx
  803774:	5e                   	pop    %esi
  803775:	5f                   	pop    %edi
  803776:	5d                   	pop    %ebp
  803777:	c3                   	ret    
  803778:	bd 20 00 00 00       	mov    $0x20,%ebp
  80377d:	89 eb                	mov    %ebp,%ebx
  80377f:	29 fb                	sub    %edi,%ebx
  803781:	89 f9                	mov    %edi,%ecx
  803783:	d3 e6                	shl    %cl,%esi
  803785:	89 c5                	mov    %eax,%ebp
  803787:	88 d9                	mov    %bl,%cl
  803789:	d3 ed                	shr    %cl,%ebp
  80378b:	89 e9                	mov    %ebp,%ecx
  80378d:	09 f1                	or     %esi,%ecx
  80378f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803793:	89 f9                	mov    %edi,%ecx
  803795:	d3 e0                	shl    %cl,%eax
  803797:	89 c5                	mov    %eax,%ebp
  803799:	89 d6                	mov    %edx,%esi
  80379b:	88 d9                	mov    %bl,%cl
  80379d:	d3 ee                	shr    %cl,%esi
  80379f:	89 f9                	mov    %edi,%ecx
  8037a1:	d3 e2                	shl    %cl,%edx
  8037a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037a7:	88 d9                	mov    %bl,%cl
  8037a9:	d3 e8                	shr    %cl,%eax
  8037ab:	09 c2                	or     %eax,%edx
  8037ad:	89 d0                	mov    %edx,%eax
  8037af:	89 f2                	mov    %esi,%edx
  8037b1:	f7 74 24 0c          	divl   0xc(%esp)
  8037b5:	89 d6                	mov    %edx,%esi
  8037b7:	89 c3                	mov    %eax,%ebx
  8037b9:	f7 e5                	mul    %ebp
  8037bb:	39 d6                	cmp    %edx,%esi
  8037bd:	72 19                	jb     8037d8 <__udivdi3+0xfc>
  8037bf:	74 0b                	je     8037cc <__udivdi3+0xf0>
  8037c1:	89 d8                	mov    %ebx,%eax
  8037c3:	31 ff                	xor    %edi,%edi
  8037c5:	e9 58 ff ff ff       	jmp    803722 <__udivdi3+0x46>
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037d0:	89 f9                	mov    %edi,%ecx
  8037d2:	d3 e2                	shl    %cl,%edx
  8037d4:	39 c2                	cmp    %eax,%edx
  8037d6:	73 e9                	jae    8037c1 <__udivdi3+0xe5>
  8037d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037db:	31 ff                	xor    %edi,%edi
  8037dd:	e9 40 ff ff ff       	jmp    803722 <__udivdi3+0x46>
  8037e2:	66 90                	xchg   %ax,%ax
  8037e4:	31 c0                	xor    %eax,%eax
  8037e6:	e9 37 ff ff ff       	jmp    803722 <__udivdi3+0x46>
  8037eb:	90                   	nop

008037ec <__umoddi3>:
  8037ec:	55                   	push   %ebp
  8037ed:	57                   	push   %edi
  8037ee:	56                   	push   %esi
  8037ef:	53                   	push   %ebx
  8037f0:	83 ec 1c             	sub    $0x1c,%esp
  8037f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803807:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80380b:	89 f3                	mov    %esi,%ebx
  80380d:	89 fa                	mov    %edi,%edx
  80380f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803813:	89 34 24             	mov    %esi,(%esp)
  803816:	85 c0                	test   %eax,%eax
  803818:	75 1a                	jne    803834 <__umoddi3+0x48>
  80381a:	39 f7                	cmp    %esi,%edi
  80381c:	0f 86 a2 00 00 00    	jbe    8038c4 <__umoddi3+0xd8>
  803822:	89 c8                	mov    %ecx,%eax
  803824:	89 f2                	mov    %esi,%edx
  803826:	f7 f7                	div    %edi
  803828:	89 d0                	mov    %edx,%eax
  80382a:	31 d2                	xor    %edx,%edx
  80382c:	83 c4 1c             	add    $0x1c,%esp
  80382f:	5b                   	pop    %ebx
  803830:	5e                   	pop    %esi
  803831:	5f                   	pop    %edi
  803832:	5d                   	pop    %ebp
  803833:	c3                   	ret    
  803834:	39 f0                	cmp    %esi,%eax
  803836:	0f 87 ac 00 00 00    	ja     8038e8 <__umoddi3+0xfc>
  80383c:	0f bd e8             	bsr    %eax,%ebp
  80383f:	83 f5 1f             	xor    $0x1f,%ebp
  803842:	0f 84 ac 00 00 00    	je     8038f4 <__umoddi3+0x108>
  803848:	bf 20 00 00 00       	mov    $0x20,%edi
  80384d:	29 ef                	sub    %ebp,%edi
  80384f:	89 fe                	mov    %edi,%esi
  803851:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803855:	89 e9                	mov    %ebp,%ecx
  803857:	d3 e0                	shl    %cl,%eax
  803859:	89 d7                	mov    %edx,%edi
  80385b:	89 f1                	mov    %esi,%ecx
  80385d:	d3 ef                	shr    %cl,%edi
  80385f:	09 c7                	or     %eax,%edi
  803861:	89 e9                	mov    %ebp,%ecx
  803863:	d3 e2                	shl    %cl,%edx
  803865:	89 14 24             	mov    %edx,(%esp)
  803868:	89 d8                	mov    %ebx,%eax
  80386a:	d3 e0                	shl    %cl,%eax
  80386c:	89 c2                	mov    %eax,%edx
  80386e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803872:	d3 e0                	shl    %cl,%eax
  803874:	89 44 24 04          	mov    %eax,0x4(%esp)
  803878:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387c:	89 f1                	mov    %esi,%ecx
  80387e:	d3 e8                	shr    %cl,%eax
  803880:	09 d0                	or     %edx,%eax
  803882:	d3 eb                	shr    %cl,%ebx
  803884:	89 da                	mov    %ebx,%edx
  803886:	f7 f7                	div    %edi
  803888:	89 d3                	mov    %edx,%ebx
  80388a:	f7 24 24             	mull   (%esp)
  80388d:	89 c6                	mov    %eax,%esi
  80388f:	89 d1                	mov    %edx,%ecx
  803891:	39 d3                	cmp    %edx,%ebx
  803893:	0f 82 87 00 00 00    	jb     803920 <__umoddi3+0x134>
  803899:	0f 84 91 00 00 00    	je     803930 <__umoddi3+0x144>
  80389f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038a3:	29 f2                	sub    %esi,%edx
  8038a5:	19 cb                	sbb    %ecx,%ebx
  8038a7:	89 d8                	mov    %ebx,%eax
  8038a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038ad:	d3 e0                	shl    %cl,%eax
  8038af:	89 e9                	mov    %ebp,%ecx
  8038b1:	d3 ea                	shr    %cl,%edx
  8038b3:	09 d0                	or     %edx,%eax
  8038b5:	89 e9                	mov    %ebp,%ecx
  8038b7:	d3 eb                	shr    %cl,%ebx
  8038b9:	89 da                	mov    %ebx,%edx
  8038bb:	83 c4 1c             	add    $0x1c,%esp
  8038be:	5b                   	pop    %ebx
  8038bf:	5e                   	pop    %esi
  8038c0:	5f                   	pop    %edi
  8038c1:	5d                   	pop    %ebp
  8038c2:	c3                   	ret    
  8038c3:	90                   	nop
  8038c4:	89 fd                	mov    %edi,%ebp
  8038c6:	85 ff                	test   %edi,%edi
  8038c8:	75 0b                	jne    8038d5 <__umoddi3+0xe9>
  8038ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8038cf:	31 d2                	xor    %edx,%edx
  8038d1:	f7 f7                	div    %edi
  8038d3:	89 c5                	mov    %eax,%ebp
  8038d5:	89 f0                	mov    %esi,%eax
  8038d7:	31 d2                	xor    %edx,%edx
  8038d9:	f7 f5                	div    %ebp
  8038db:	89 c8                	mov    %ecx,%eax
  8038dd:	f7 f5                	div    %ebp
  8038df:	89 d0                	mov    %edx,%eax
  8038e1:	e9 44 ff ff ff       	jmp    80382a <__umoddi3+0x3e>
  8038e6:	66 90                	xchg   %ax,%ax
  8038e8:	89 c8                	mov    %ecx,%eax
  8038ea:	89 f2                	mov    %esi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	3b 04 24             	cmp    (%esp),%eax
  8038f7:	72 06                	jb     8038ff <__umoddi3+0x113>
  8038f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038fd:	77 0f                	ja     80390e <__umoddi3+0x122>
  8038ff:	89 f2                	mov    %esi,%edx
  803901:	29 f9                	sub    %edi,%ecx
  803903:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803907:	89 14 24             	mov    %edx,(%esp)
  80390a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80390e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803912:	8b 14 24             	mov    (%esp),%edx
  803915:	83 c4 1c             	add    $0x1c,%esp
  803918:	5b                   	pop    %ebx
  803919:	5e                   	pop    %esi
  80391a:	5f                   	pop    %edi
  80391b:	5d                   	pop    %ebp
  80391c:	c3                   	ret    
  80391d:	8d 76 00             	lea    0x0(%esi),%esi
  803920:	2b 04 24             	sub    (%esp),%eax
  803923:	19 fa                	sbb    %edi,%edx
  803925:	89 d1                	mov    %edx,%ecx
  803927:	89 c6                	mov    %eax,%esi
  803929:	e9 71 ff ff ff       	jmp    80389f <__umoddi3+0xb3>
  80392e:	66 90                	xchg   %ax,%ax
  803930:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803934:	72 ea                	jb     803920 <__umoddi3+0x134>
  803936:	89 d9                	mov    %ebx,%ecx
  803938:	e9 62 ff ff ff       	jmp    80389f <__umoddi3+0xb3>
