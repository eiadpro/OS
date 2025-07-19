
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 21 06 00 00       	call   800657 <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800044:	83 ec 0c             	sub    $0xc,%esp
  800047:	6a 01                	push   $0x1
  800049:	e8 9b 22 00 00       	call   8022e9 <sys_set_uheap_strategy>
  80004e:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800051:	a1 40 40 80 00       	mov    0x804040,%eax
  800056:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  80005c:	a1 40 40 80 00       	mov    0x804040,%eax
  800061:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800067:	39 c2                	cmp    %eax,%edx
  800069:	72 14                	jb     80007f <_main+0x47>
			panic("Please increase the WS size");
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 40 32 80 00       	push   $0x803240
  800073:	6a 22                	push   $0x22
  800075:	68 5c 32 80 00       	push   $0x80325c
  80007a:	e8 0f 07 00 00       	call   80078e <_panic>
	}
	/*=================================================*/

	int eval = 0;
  80007f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  800086:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  80008d:	c7 45 bc 00 00 30 00 	movl   $0x300000,-0x44(%ebp)

	void * va ;
	int idx = 0;
  800094:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80009b:	e8 d4 1d 00 00       	call   801e74 <sys_pf_calculate_allocated_pages>
  8000a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000a3:	e8 81 1d 00 00       	call   801e29 <sys_calculate_free_frames>
  8000a8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	uint32 actualSize;

	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 74 32 80 00       	push   $0x803274
  8000b3:	e8 93 09 00 00       	call   800a4b <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8000bb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		void* curVA = (void*) USER_HEAP_START ;
  8000c2:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8000c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8000d0:	e9 e7 00 00 00       	jmp    8001bc <_main+0x184>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8000d5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8000dc:	e9 cb 00 00 00       	jmp    8001ac <_main+0x174>
			{
				actualSize = allocSizes[i] - sizeOfMetaData();
  8000e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000e4:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  8000eb:	83 e8 10             	sub    $0x10,%eax
  8000ee:	89 45 b0             	mov    %eax,-0x50(%ebp)
				va = startVAs[idx++] = malloc(actualSize);
  8000f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000f4:	8d 43 01             	lea    0x1(%ebx),%eax
  8000f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	ff 75 b0             	pushl  -0x50(%ebp)
  800100:	e8 34 19 00 00       	call   801a39 <malloc>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	89 04 9d 20 41 80 00 	mov    %eax,0x804120(,%ebx,4)
  80010f:	8b 04 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%eax
  800116:	89 45 ac             	mov    %eax,-0x54(%ebp)
				//Check returned va
				if(va == NULL || (va < curVA))
  800119:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  80011d:	74 08                	je     800127 <_main+0xef>
  80011f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800122:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800125:	73 2e                	jae    800155 <_main+0x11d>
				{
					if (is_correct)
  800127:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80012b:	74 28                	je     800155 <_main+0x11d>
					{
						is_correct = 0;
  80012d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
						panic("malloc() #1.%d: WRONG ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", idx, curVA + sizeOfMetaData() ,va);
  800134:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800137:	83 c0 10             	add    $0x10,%eax
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	ff 75 ac             	pushl  -0x54(%ebp)
  800140:	50                   	push   %eax
  800141:	ff 75 dc             	pushl  -0x24(%ebp)
  800144:	68 cc 32 80 00       	push   $0x8032cc
  800149:	6a 44                	push   $0x44
  80014b:	68 5c 32 80 00       	push   $0x80325c
  800150:	e8 39 06 00 00       	call   80078e <_panic>
					}
				}
				curVA += allocSizes[i] ;
  800155:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800158:	8b 04 85 00 40 80 00 	mov    0x804000(,%eax,4),%eax
  80015f:	01 45 d8             	add    %eax,-0x28(%ebp)

				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA to skip this area
				void* rounded_curVA = ROUNDUP(curVA, PAGE_SIZE);
  800162:	c7 45 a8 00 10 00 00 	movl   $0x1000,-0x58(%ebp)
  800169:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80016c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	48                   	dec    %eax
  800172:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800175:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800178:	ba 00 00 00 00       	mov    $0x0,%edx
  80017d:	f7 75 a8             	divl   -0x58(%ebp)
  800180:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800183:	29 d0                	sub    %edx,%eax
  800185:	89 45 a0             	mov    %eax,-0x60(%ebp)
				int diff = (rounded_curVA - curVA) ;
  800188:	8b 55 a0             	mov    -0x60(%ebp),%edx
  80018b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018e:	29 c2                	sub    %eax,%edx
  800190:	89 d0                	mov    %edx,%eax
  800192:	89 45 9c             	mov    %eax,-0x64(%ebp)
				if (diff > 0 && diff < sizeOfMetaData())
  800195:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800199:	7e 0e                	jle    8001a9 <_main+0x171>
  80019b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80019e:	83 f8 0f             	cmp    $0xf,%eax
  8001a1:	77 06                	ja     8001a9 <_main+0x171>
				{
					curVA = rounded_curVA;
  8001a3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8001a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8001a9:	ff 45 d0             	incl   -0x30(%ebp)
  8001ac:	81 7d d0 c7 00 00 00 	cmpl   $0xc7,-0x30(%ebp)
  8001b3:	0f 8e 28 ff ff ff    	jle    8000e1 <_main+0xa9>
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START ;
		uint32 actualSize;
		for (int i = 0; i < numOfAllocs; ++i)
  8001b9:	ff 45 d4             	incl   -0x2c(%ebp)
  8001bc:	83 7d d4 06          	cmpl   $0x6,-0x2c(%ebp)
  8001c0:	0f 8e 0f ff ff ff    	jle    8000d5 <_main+0x9d>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 28 33 80 00       	push   $0x803328
  8001ce:	e8 78 08 00 00       	call   800a4b <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	{
		for (int i = 0; i < numOfAllocs; ++i)
  8001d6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8001dd:	eb 2c                	jmp    80020b <_main+0x1d3>
		{
			free(startVAs[i*allocCntPerSize]);
  8001df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001e2:	89 d0                	mov    %edx,%eax
  8001e4:	c1 e0 02             	shl    $0x2,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	8b 04 85 20 41 80 00 	mov    0x804120(,%eax,4),%eax
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	e8 94 19 00 00       	call   801b99 <free>
  800205:	83 c4 10             	add    $0x10,%esp

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		for (int i = 0; i < numOfAllocs; ++i)
  800208:	ff 45 cc             	incl   -0x34(%ebp)
  80020b:	83 7d cc 06          	cmpl   $0x6,-0x34(%ebp)
  80020f:	7e ce                	jle    8001df <_main+0x1a7>
	short* tstMidVAs[numOfFFTests+1] ;
	short* tstEndVAs[numOfFFTests+1] ;

	//====================================================================//
	/*FF ALLOC Scenario 2: Try to allocate blocks with sizes smaller than existing free blocks*/
	cprintf("2: Try to allocate set of blocks with different sizes smaller than existing free blocks\n\n") ;
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 70 33 80 00       	push   $0x803370
  800219:	e8 2d 08 00 00       	call   800a4b <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  800221:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800227:	bb 90 37 80 00       	mov    $0x803790,%ebx
  80022c:	ba 03 00 00 00       	mov    $0x3,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData(), 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;

	uint32 startOf1stFreeBlock = (uint32)startVAs[0*allocCntPerSize];
  800239:	a1 20 41 80 00       	mov    0x804120,%eax
  80023e:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];
  800241:	a1 80 4a 80 00       	mov    0x804a80,%eax
  800246:	89 45 94             	mov    %eax,-0x6c(%ebp)

	{
		is_correct = 1;
  800249:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		uint32 expectedVAs[numOfFFTests] =
  800250:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800253:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800259:	8b 45 98             	mov    -0x68(%ebp),%eax
  80025c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
  800262:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800268:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80026b:	01 d0                	add    %edx,%eax
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];

	{
		is_correct = 1;

		uint32 expectedVAs[numOfFFTests] =
  80026d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  800273:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80027a:	e9 f7 00 00 00       	jmp    800376 <_main+0x33e>
		{
			actualSize = testSizes[i] - sizeOfMetaData();
  80027f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800282:	8b 84 85 4c ff ff ff 	mov    -0xb4(%ebp,%eax,4),%eax
  800289:	83 e8 10             	sub    $0x10,%eax
  80028c:	89 45 90             	mov    %eax,-0x70(%ebp)
			va = tstStartVAs[i] = malloc(actualSize);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	ff 75 90             	pushl  -0x70(%ebp)
  800295:	e8 9f 17 00 00       	call   801a39 <malloc>
  80029a:	83 c4 10             	add    $0x10,%esp
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	89 94 85 78 ff ff ff 	mov    %edx,-0x88(%ebp,%eax,4)
  8002a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002ac:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8002b3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			tstMidVAs[i] = va + actualSize/2 ;
  8002b6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002b9:	d1 e8                	shr    %eax
  8002bb:	89 c2                	mov    %eax,%edx
  8002bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002c0:	01 c2                	add    %eax,%edx
  8002c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002c5:	89 94 85 68 ff ff ff 	mov    %edx,-0x98(%ebp,%eax,4)
			tstEndVAs[i] = va + actualSize - sizeof(short);
  8002cc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002cf:	8d 50 fe             	lea    -0x2(%eax),%edx
  8002d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002d5:	01 c2                	add    %eax,%edx
  8002d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002da:	89 94 85 58 ff ff ff 	mov    %edx,-0xa8(%ebp,%eax,4)
			//Check returned va
			if(tstStartVAs[i] == NULL || (tstStartVAs[i] != (short*)expectedVAs[i]))
  8002e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002e4:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8002eb:	85 c0                	test   %eax,%eax
  8002ed:	74 18                	je     800307 <_main+0x2cf>
  8002ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002f2:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  8002f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002fc:	8b 84 85 40 ff ff ff 	mov    -0xc0(%ebp,%eax,4),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	74 2d                	je     800334 <_main+0x2fc>
			{
				is_correct = 0;
  800307:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #2.%d: WRONG FF ALLOC - alloc_block_FF return wrong address. Expected %x, Actual %x\n", i, expectedVAs[i] ,tstStartVAs[i]);
  80030e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800311:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  800318:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80031b:	8b 84 85 40 ff ff ff 	mov    -0xc0(%ebp,%eax,4),%eax
  800322:	52                   	push   %edx
  800323:	50                   	push   %eax
  800324:	ff 75 c8             	pushl  -0x38(%ebp)
  800327:	68 cc 33 80 00       	push   $0x8033cc
  80032c:	e8 1a 07 00 00       	call   800a4b <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
				//break;
			}
			*(tstStartVAs[i]) = 353 + i;
  800334:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800337:	8b 94 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%edx
  80033e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800341:	05 61 01 00 00       	add    $0x161,%eax
  800346:	66 89 02             	mov    %ax,(%edx)
			*(tstMidVAs[i]) = 353 + i;
  800349:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80034c:	8b 94 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%edx
  800353:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800356:	05 61 01 00 00       	add    $0x161,%eax
  80035b:	66 89 02             	mov    %ax,(%edx)
			*(tstEndVAs[i]) = 353 + i;
  80035e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800361:	8b 94 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%edx
  800368:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80036b:	05 61 01 00 00       	add    $0x161,%eax
  800370:	66 89 02             	mov    %ax,(%edx)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  800373:	ff 45 c8             	incl   -0x38(%ebp)
  800376:	83 7d c8 02          	cmpl   $0x2,-0x38(%ebp)
  80037a:	0f 8e ff fe ff ff    	jle    80027f <_main+0x247>
			*(tstStartVAs[i]) = 353 + i;
			*(tstMidVAs[i]) = 353 + i;
			*(tstEndVAs[i]) = 353 + i;
		}
		//Check stored sizes
		if(get_block_size(tstStartVAs[1]) != allocSizes[0])
  800380:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	50                   	push   %eax
  80038a:	e8 60 20 00 00       	call   8023ef <get_block_size>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 c2                	mov    %eax,%edx
  800394:	a1 00 40 80 00       	mov    0x804000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	74 17                	je     8003b4 <_main+0x37c>
		{
			is_correct = 0;
  80039d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #3: WRONG FF ALLOC - make sure if the remaining free space doesn’t fit a dynamic allocator block, then this area should be added to the allocated area and counted as internal fragmentation\n");
  8003a4:	83 ec 0c             	sub    $0xc,%esp
  8003a7:	68 2c 34 80 00       	push   $0x80342c
  8003ac:	e8 9a 06 00 00       	call   800a4b <cprintf>
  8003b1:	83 c4 10             	add    $0x10,%esp
			//break;
		}
		if (is_correct)
  8003b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b8:	74 04                	je     8003be <_main+0x386>
		{
			eval += 30;
  8003ba:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 3: Try to allocate a block with a size equal to the size of the first existing free block*/
	cprintf("3: Try to allocate a block with equal to the first existing free block\n\n") ;
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	68 f4 34 80 00       	push   $0x8034f4
  8003c6:	e8 80 06 00 00       	call   800a4b <cprintf>
  8003cb:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003ce:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		actualSize = kilo/8 - sizeOfMetaData(); 	//expected to be allocated in remaining of 4th free block
  8003d5:	c7 45 90 70 00 00 00 	movl   $0x70,-0x70(%ebp)
		va = tstStartVAs[numOfFFTests] = malloc(actualSize);
  8003dc:	83 ec 0c             	sub    $0xc,%esp
  8003df:	ff 75 90             	pushl  -0x70(%ebp)
  8003e2:	e8 52 16 00 00       	call   801a39 <malloc>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8003ed:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8003f0:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tstMidVAs[numOfFFTests] = va + actualSize/2 ;
  8003f3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003f6:	d1 e8                	shr    %eax
  8003f8:	89 c2                	mov    %eax,%edx
  8003fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		tstEndVAs[numOfFFTests] = va + actualSize - sizeof(short);
  800405:	8b 45 90             	mov    -0x70(%ebp),%eax
  800408:	8d 50 fe             	lea    -0x2(%eax),%edx
  80040b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80040e:	01 d0                	add    %edx,%eax
  800410:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		//Check returned va
		void* expected = (void*)(startOf4thFreeBlock + testSizes[0] + testSizes[2]) ;
  800416:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80041c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80041f:	01 c2                	add    %eax,%edx
  800421:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if(va == NULL || (va != expected))
  80042c:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  800430:	74 08                	je     80043a <_main+0x402>
  800432:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800435:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800438:	74 1d                	je     800457 <_main+0x41f>
		{
			is_correct = 0;
  80043a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #4: WRONG FF ALLOC - alloc_block_FF return wrong address.expected %x, actual %x\n", expected, va);
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	ff 75 ac             	pushl  -0x54(%ebp)
  800447:	ff 75 8c             	pushl  -0x74(%ebp)
  80044a:	68 40 35 80 00       	push   $0x803540
  80044f:	e8 f7 05 00 00       	call   800a4b <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		}
		*(tstStartVAs[numOfFFTests]) = 353 + numOfFFTests;
  800457:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80045a:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstMidVAs[numOfFFTests]) = 353 + numOfFFTests;
  80045f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800465:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstEndVAs[numOfFFTests]) = 353 + numOfFFTests;
  80046a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800470:	66 c7 00 64 01       	movw   $0x164,(%eax)

		if (is_correct)
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	74 04                	je     80047f <_main+0x447>
		{
			eval += 30;
  80047b:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	68 9c 35 80 00       	push   $0x80359c
  800487:	e8 bf 05 00 00       	call   800a4b <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80048f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		for (int i = 0; i <= numOfFFTests; ++i)
  800496:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  80049d:	e9 ab 00 00 00       	jmp    80054d <_main+0x515>
		{
			//cprintf("startVA = %x, mid = %x, last = %x\n", tstStartVAs[i], tstMidVAs[i], tstEndVAs[i]);
			if (*(tstStartVAs[i]) != (353+i) || *(tstMidVAs[i]) != (353+i) || *(tstEndVAs[i]) != (353+i) )
  8004a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004a5:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  8004ac:	66 8b 00             	mov    (%eax),%ax
  8004af:	98                   	cwtl   
  8004b0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b3:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004b9:	39 d0                	cmp    %edx,%eax
  8004bb:	75 36                	jne    8004f3 <_main+0x4bb>
  8004bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004c0:	8b 84 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%eax
  8004c7:	66 8b 00             	mov    (%eax),%ax
  8004ca:	98                   	cwtl   
  8004cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ce:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004d4:	39 d0                	cmp    %edx,%eax
  8004d6:	75 1b                	jne    8004f3 <_main+0x4bb>
  8004d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004db:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  8004e2:	66 8b 00             	mov    (%eax),%ax
  8004e5:	98                   	cwtl   
  8004e6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e9:	81 c2 61 01 00 00    	add    $0x161,%edx
  8004ef:	39 d0                	cmp    %edx,%eax
  8004f1:	74 57                	je     80054a <_main+0x512>
			{
				is_correct = 0;
  8004f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc #5.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
  8004fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004fd:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800504:	66 8b 00             	mov    (%eax),%ax
  800507:	0f bf c8             	movswl %ax,%ecx
  80050a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050d:	8b 84 85 68 ff ff ff 	mov    -0x98(%ebp,%eax,4),%eax
  800514:	66 8b 00             	mov    (%eax),%ax
  800517:	0f bf d0             	movswl %ax,%edx
  80051a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80051d:	8b 84 85 78 ff ff ff 	mov    -0x88(%ebp,%eax,4),%eax
  800524:	66 8b 00             	mov    (%eax),%ax
  800527:	98                   	cwtl   
  800528:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80052b:	81 c3 61 01 00 00    	add    $0x161,%ebx
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	51                   	push   %ecx
  800535:	52                   	push   %edx
  800536:	50                   	push   %eax
  800537:	53                   	push   %ebx
  800538:	ff 75 c4             	pushl  -0x3c(%ebp)
  80053b:	68 d0 35 80 00       	push   $0x8035d0
  800540:	e8 06 05 00 00       	call   800a4b <cprintf>
  800545:	83 c4 20             	add    $0x20,%esp
				break;
  800548:	eb 0d                	jmp    800557 <_main+0x51f>
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i <= numOfFFTests; ++i)
  80054a:	ff 45 c4             	incl   -0x3c(%ebp)
  80054d:	83 7d c4 03          	cmpl   $0x3,-0x3c(%ebp)
  800551:	0f 8e 4b ff ff ff    	jle    8004a2 <_main+0x46a>
				cprintf("malloc #5.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
				break;
			}
		}

		if (is_correct)
  800557:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80055b:	74 04                	je     800561 <_main+0x529>
		{
			eval += 20;
  80055d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 5: Test a Non-Granted Request */
	cprintf("5: Test a Non-Granted Request\n\n") ;
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 34 36 80 00       	push   $0x803634
  800569:	e8 dd 04 00 00       	call   800a4b <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800571:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 2*kilo - sizeOfMetaData();
  800578:	c7 45 90 f0 07 00 00 	movl   $0x7f0,-0x70(%ebp)

		//Fill the 7th free block
		va = malloc(actualSize);
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	ff 75 90             	pushl  -0x70(%ebp)
  800585:	e8 af 14 00 00       	call   801a39 <malloc>
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 45 ac             	mov    %eax,-0x54(%ebp)

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	6a 00                	push   $0x0
  800595:	e8 89 14 00 00       	call   801a23 <sbrk>
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	ba 00 00 00 82       	mov    $0x82000000,%edx
  8005a2:	29 c2                	sub    %eax,%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e8 0c             	shr    $0xc,%eax
  8005a9:	01 c0                	add    %eax,%eax
  8005ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8005ae:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8005b5:	eb 33                	jmp    8005ea <_main+0x5b2>
		{
			va = malloc(actualSize);
  8005b7:	83 ec 0c             	sub    $0xc,%esp
  8005ba:	ff 75 90             	pushl  -0x70(%ebp)
  8005bd:	e8 77 14 00 00       	call   801a39 <malloc>
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if(va == NULL)
  8005c8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  8005cc:	75 19                	jne    8005e7 <_main+0x5af>
			{
				is_correct = 0;
  8005ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #6.%d: WRONG FF ALLOC - alloc_block_FF return NULL address while it's expected to return correct one.\n");
  8005d5:	83 ec 0c             	sub    $0xc,%esp
  8005d8:	68 54 36 80 00       	push   $0x803654
  8005dd:	e8 69 04 00 00       	call   800a4b <cprintf>
  8005e2:	83 c4 10             	add    $0x10,%esp
				break;
  8005e5:	eb 0b                	jmp    8005f2 <_main+0x5ba>
		//Fill the 7th free block
		va = malloc(actualSize);

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8005e7:	ff 45 c0             	incl   -0x40(%ebp)
  8005ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005ed:	3b 45 88             	cmp    -0x78(%ebp),%eax
  8005f0:	72 c5                	jb     8005b7 <_main+0x57f>
				break;
			}
		}

		//Test two more allocs
		va = malloc(actualSize);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff 75 90             	pushl  -0x70(%ebp)
  8005f8:	e8 3c 14 00 00       	call   801a39 <malloc>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	89 45 ac             	mov    %eax,-0x54(%ebp)
		va = malloc(actualSize);
  800603:	83 ec 0c             	sub    $0xc,%esp
  800606:	ff 75 90             	pushl  -0x70(%ebp)
  800609:	e8 2b 14 00 00       	call   801a39 <malloc>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	89 45 ac             	mov    %eax,-0x54(%ebp)

		if(va != NULL)
  800614:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  800618:	74 17                	je     800631 <_main+0x5f9>
		{
			is_correct = 0;
  80061a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #7: WRONG FF ALLOC - alloc_block_FF return an address while it's expected to return NULL since it reaches the hard limit.\n");
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	68 c4 36 80 00       	push   $0x8036c4
  800629:	e8 1d 04 00 00       	call   800a4b <cprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800631:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800635:	74 04                	je     80063b <_main+0x603>
		{
			eval += 20;
  800637:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}
	cprintf("test FIRST FIT (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800641:	68 48 37 80 00       	push   $0x803748
  800646:	e8 00 04 00 00       	call   800a4b <cprintf>
  80064b:	83 c4 10             	add    $0x10,%esp

	return;
  80064e:	90                   	nop
}
  80064f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800652:	5b                   	pop    %ebx
  800653:	5e                   	pop    %esi
  800654:	5f                   	pop    %edi
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065d:	e8 52 1a 00 00       	call   8020b4 <sys_getenvindex>
  800662:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800668:	89 d0                	mov    %edx,%eax
  80066a:	c1 e0 03             	shl    $0x3,%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	01 d0                	add    %edx,%eax
  80067c:	c1 e0 04             	shl    $0x4,%eax
  80067f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800684:	a3 40 40 80 00       	mov    %eax,0x804040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800689:	a1 40 40 80 00       	mov    0x804040,%eax
  80068e:	8a 40 5c             	mov    0x5c(%eax),%al
  800691:	84 c0                	test   %al,%al
  800693:	74 0d                	je     8006a2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800695:	a1 40 40 80 00       	mov    0x804040,%eax
  80069a:	83 c0 5c             	add    $0x5c,%eax
  80069d:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a6:	7e 0a                	jle    8006b2 <libmain+0x5b>
		binaryname = argv[0];
  8006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	_main(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 78 f9 ff ff       	call   800038 <_main>
  8006c0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c3:	e8 f9 17 00 00       	call   801ec1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006c8:	83 ec 0c             	sub    $0xc,%esp
  8006cb:	68 b4 37 80 00       	push   $0x8037b4
  8006d0:	e8 76 03 00 00       	call   800a4b <cprintf>
  8006d5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006d8:	a1 40 40 80 00       	mov    0x804040,%eax
  8006dd:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8006e3:	a1 40 40 80 00       	mov    0x804040,%eax
  8006e8:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	52                   	push   %edx
  8006f2:	50                   	push   %eax
  8006f3:	68 dc 37 80 00       	push   $0x8037dc
  8006f8:	e8 4e 03 00 00       	call   800a4b <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800700:	a1 40 40 80 00       	mov    0x804040,%eax
  800705:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80070b:	a1 40 40 80 00       	mov    0x804040,%eax
  800710:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800716:	a1 40 40 80 00       	mov    0x804040,%eax
  80071b:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800721:	51                   	push   %ecx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	68 04 38 80 00       	push   $0x803804
  800729:	e8 1d 03 00 00       	call   800a4b <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800731:	a1 40 40 80 00       	mov    0x804040,%eax
  800736:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	50                   	push   %eax
  800740:	68 5c 38 80 00       	push   $0x80385c
  800745:	e8 01 03 00 00       	call   800a4b <cprintf>
  80074a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80074d:	83 ec 0c             	sub    $0xc,%esp
  800750:	68 b4 37 80 00       	push   $0x8037b4
  800755:	e8 f1 02 00 00       	call   800a4b <cprintf>
  80075a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80075d:	e8 79 17 00 00       	call   801edb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800762:	e8 19 00 00 00       	call   800780 <exit>
}
  800767:	90                   	nop
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800770:	83 ec 0c             	sub    $0xc,%esp
  800773:	6a 00                	push   $0x0
  800775:	e8 06 19 00 00       	call   802080 <sys_destroy_env>
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <exit>:

void
exit(void)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800786:	e8 5b 19 00 00       	call   8020e6 <sys_exit_env>
}
  80078b:	90                   	nop
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    

0080078e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800794:	8d 45 10             	lea    0x10(%ebp),%eax
  800797:	83 c0 04             	add    $0x4,%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80079d:	a1 30 83 80 00       	mov    0x808330,%eax
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	74 16                	je     8007bc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a6:	a1 30 83 80 00       	mov    0x808330,%eax
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	50                   	push   %eax
  8007af:	68 70 38 80 00       	push   $0x803870
  8007b4:	e8 92 02 00 00       	call   800a4b <cprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bc:	a1 1c 40 80 00       	mov    0x80401c,%eax
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	ff 75 08             	pushl  0x8(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	68 75 38 80 00       	push   $0x803875
  8007cd:	e8 79 02 00 00       	call   800a4b <cprintf>
  8007d2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 f4             	pushl  -0xc(%ebp)
  8007de:	50                   	push   %eax
  8007df:	e8 fc 01 00 00       	call   8009e0 <vcprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	6a 00                	push   $0x0
  8007ec:	68 91 38 80 00       	push   $0x803891
  8007f1:	e8 ea 01 00 00       	call   8009e0 <vcprintf>
  8007f6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007f9:	e8 82 ff ff ff       	call   800780 <exit>

	// should not return here
	while (1) ;
  8007fe:	eb fe                	jmp    8007fe <_panic+0x70>

00800800 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800806:	a1 40 40 80 00       	mov    0x804040,%eax
  80080b:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 94 38 80 00       	push   $0x803894
  800820:	6a 26                	push   $0x26
  800822:	68 e0 38 80 00       	push   $0x8038e0
  800827:	e8 62 ff ff ff       	call   80078e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c5 00 00 00       	jmp    800904 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a5 00 00 00       	jmp    800901 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 40 40 80 00       	mov    0x804040,%eax
  800871:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 40 40 80 00       	mov    0x804040,%eax
  800891:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 15                	jmp    8008e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8008da:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8008e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 85                	ja     80086c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008eb:	75 14                	jne    800901 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	68 ec 38 80 00       	push   $0x8038ec
  8008f5:	6a 3a                	push   $0x3a
  8008f7:	68 e0 38 80 00       	push   $0x8038e0
  8008fc:	e8 8d fe ff ff       	call   80078e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800901:	ff 45 f0             	incl   -0x10(%ebp)
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800907:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80090a:	0f 8c 2f ff ff ff    	jl     80083f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800910:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800917:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091e:	eb 26                	jmp    800946 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800920:	a1 40 40 80 00       	mov    0x804040,%eax
  800925:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80092b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092e:	89 d0                	mov    %edx,%eax
  800930:	01 c0                	add    %eax,%eax
  800932:	01 d0                	add    %edx,%eax
  800934:	c1 e0 03             	shl    $0x3,%eax
  800937:	01 c8                	add    %ecx,%eax
  800939:	8a 40 04             	mov    0x4(%eax),%al
  80093c:	3c 01                	cmp    $0x1,%al
  80093e:	75 03                	jne    800943 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800940:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800943:	ff 45 e0             	incl   -0x20(%ebp)
  800946:	a1 40 40 80 00       	mov    0x804040,%eax
  80094b:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	39 c2                	cmp    %eax,%edx
  800956:	77 c8                	ja     800920 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80095e:	74 14                	je     800974 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800960:	83 ec 04             	sub    $0x4,%esp
  800963:	68 40 39 80 00       	push   $0x803940
  800968:	6a 44                	push   $0x44
  80096a:	68 e0 38 80 00       	push   $0x8038e0
  80096f:	e8 1a fe ff ff       	call   80078e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800974:	90                   	nop
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	8d 48 01             	lea    0x1(%eax),%ecx
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 0a                	mov    %ecx,(%edx)
  80098a:	8b 55 08             	mov    0x8(%ebp),%edx
  80098d:	88 d1                	mov    %dl,%cl
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a0:	75 2c                	jne    8009ce <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a2:	a0 44 40 80 00       	mov    0x804044,%al
  8009a7:	0f b6 c0             	movzbl %al,%eax
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	8b 12                	mov    (%edx),%edx
  8009af:	89 d1                	mov    %edx,%ecx
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	83 c2 08             	add    $0x8,%edx
  8009b7:	83 ec 04             	sub    $0x4,%esp
  8009ba:	50                   	push   %eax
  8009bb:	51                   	push   %ecx
  8009bc:	52                   	push   %edx
  8009bd:	e8 a6 13 00 00       	call   801d68 <sys_cputs>
  8009c2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d1:	8b 40 04             	mov    0x4(%eax),%eax
  8009d4:	8d 50 01             	lea    0x1(%eax),%edx
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009da:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009dd:	90                   	nop
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f0:	00 00 00 
	b.cnt = 0;
  8009f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a09:	50                   	push   %eax
  800a0a:	68 77 09 80 00       	push   $0x800977
  800a0f:	e8 11 02 00 00       	call   800c25 <vprintfmt>
  800a14:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a17:	a0 44 40 80 00       	mov    0x804044,%al
  800a1c:	0f b6 c0             	movzbl %al,%eax
  800a1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a25:	83 ec 04             	sub    $0x4,%esp
  800a28:	50                   	push   %eax
  800a29:	52                   	push   %edx
  800a2a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a30:	83 c0 08             	add    $0x8,%eax
  800a33:	50                   	push   %eax
  800a34:	e8 2f 13 00 00       	call   801d68 <sys_cputs>
  800a39:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a3c:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800a43:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a51:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800a58:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 f4             	pushl  -0xc(%ebp)
  800a67:	50                   	push   %eax
  800a68:	e8 73 ff ff ff       	call   8009e0 <vcprintf>
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a7e:	e8 3e 14 00 00       	call   801ec1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a83:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a92:	50                   	push   %eax
  800a93:	e8 48 ff ff ff       	call   8009e0 <vcprintf>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a9e:	e8 38 14 00 00       	call   801edb <sys_enable_interrupt>
	return cnt;
  800aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	53                   	push   %ebx
  800aac:	83 ec 14             	sub    $0x14,%esp
  800aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abb:	8b 45 18             	mov    0x18(%ebp),%eax
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac6:	77 55                	ja     800b1d <printnum+0x75>
  800ac8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acb:	72 05                	jb     800ad2 <printnum+0x2a>
  800acd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad0:	77 4b                	ja     800b1d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad8:	8b 45 18             	mov    0x18(%ebp),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae0:	52                   	push   %edx
  800ae1:	50                   	push   %eax
  800ae2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae8:	e8 eb 24 00 00       	call   802fd8 <__udivdi3>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	83 ec 04             	sub    $0x4,%esp
  800af3:	ff 75 20             	pushl  0x20(%ebp)
  800af6:	53                   	push   %ebx
  800af7:	ff 75 18             	pushl  0x18(%ebp)
  800afa:	52                   	push   %edx
  800afb:	50                   	push   %eax
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 a1 ff ff ff       	call   800aa8 <printnum>
  800b07:	83 c4 20             	add    $0x20,%esp
  800b0a:	eb 1a                	jmp    800b26 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	ff 75 20             	pushl  0x20(%ebp)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b1d:	ff 4d 1c             	decl   0x1c(%ebp)
  800b20:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b24:	7f e6                	jg     800b0c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b26:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b34:	53                   	push   %ebx
  800b35:	51                   	push   %ecx
  800b36:	52                   	push   %edx
  800b37:	50                   	push   %eax
  800b38:	e8 ab 25 00 00       	call   8030e8 <__umoddi3>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be c0             	movsbl %al,%eax
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	50                   	push   %eax
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
}
  800b59:	90                   	nop
  800b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b66:	7e 1c                	jle    800b84 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	8d 50 08             	lea    0x8(%eax),%edx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 10                	mov    %edx,(%eax)
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	83 e8 08             	sub    $0x8,%eax
  800b7d:	8b 50 04             	mov    0x4(%eax),%edx
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	eb 40                	jmp    800bc4 <getuint+0x65>
	else if (lflag)
  800b84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b88:	74 1e                	je     800ba8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	8d 50 04             	lea    0x4(%eax),%edx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	89 10                	mov    %edx,(%eax)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	83 e8 04             	sub    $0x4,%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba6:	eb 1c                	jmp    800bc4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 00                	mov    (%eax),%eax
  800bad:	8d 50 04             	lea    0x4(%eax),%edx
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 10                	mov    %edx,(%eax)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	83 e8 04             	sub    $0x4,%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bcd:	7e 1c                	jle    800beb <getint+0x25>
		return va_arg(*ap, long long);
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	8d 50 08             	lea    0x8(%eax),%edx
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 10                	mov    %edx,(%eax)
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	83 e8 08             	sub    $0x8,%eax
  800be4:	8b 50 04             	mov    0x4(%eax),%edx
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	eb 38                	jmp    800c23 <getint+0x5d>
	else if (lflag)
  800beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bef:	74 1a                	je     800c0b <getint+0x45>
		return va_arg(*ap, long);
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	8d 50 04             	lea    0x4(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 10                	mov    %edx,(%eax)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	83 e8 04             	sub    $0x4,%eax
  800c06:	8b 00                	mov    (%eax),%eax
  800c08:	99                   	cltd   
  800c09:	eb 18                	jmp    800c23 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	8d 50 04             	lea    0x4(%eax),%edx
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 10                	mov    %edx,(%eax)
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	83 e8 04             	sub    $0x4,%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	99                   	cltd   
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2d:	eb 17                	jmp    800c46 <vprintfmt+0x21>
			if (ch == '\0')
  800c2f:	85 db                	test   %ebx,%ebx
  800c31:	0f 84 af 03 00 00    	je     800fe6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	53                   	push   %ebx
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 01             	lea    0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	0f b6 d8             	movzbl %al,%ebx
  800c54:	83 fb 25             	cmp    $0x25,%ebx
  800c57:	75 d6                	jne    800c2f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c59:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c5d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c64:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c72:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c79:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	0f b6 d8             	movzbl %al,%ebx
  800c87:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8a:	83 f8 55             	cmp    $0x55,%eax
  800c8d:	0f 87 2b 03 00 00    	ja     800fbe <vprintfmt+0x399>
  800c93:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  800c9a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c9c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d7                	jmp    800c79 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca6:	eb d1                	jmp    800c79 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb2:	89 d0                	mov    %edx,%eax
  800cb4:	c1 e0 02             	shl    $0x2,%eax
  800cb7:	01 d0                	add    %edx,%eax
  800cb9:	01 c0                	add    %eax,%eax
  800cbb:	01 d8                	add    %ebx,%eax
  800cbd:	83 e8 30             	sub    $0x30,%eax
  800cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccb:	83 fb 2f             	cmp    $0x2f,%ebx
  800cce:	7e 3e                	jle    800d0e <vprintfmt+0xe9>
  800cd0:	83 fb 39             	cmp    $0x39,%ebx
  800cd3:	7f 39                	jg     800d0e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd8:	eb d5                	jmp    800caf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 c0 04             	add    $0x4,%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce6:	83 e8 04             	sub    $0x4,%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cee:	eb 1f                	jmp    800d0f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf4:	79 83                	jns    800c79 <vprintfmt+0x54>
				width = 0;
  800cf6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cfd:	e9 77 ff ff ff       	jmp    800c79 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d02:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d09:	e9 6b ff ff ff       	jmp    800c79 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d0e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d13:	0f 89 60 ff ff ff    	jns    800c79 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d1f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d26:	e9 4e ff ff ff       	jmp    800c79 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d2e:	e9 46 ff ff ff       	jmp    800c79 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d33:	8b 45 14             	mov    0x14(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 14             	mov    %eax,0x14(%ebp)
  800d3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3f:	83 e8 04             	sub    $0x4,%eax
  800d42:	8b 00                	mov    (%eax),%eax
  800d44:	83 ec 08             	sub    $0x8,%esp
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	50                   	push   %eax
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	ff d0                	call   *%eax
  800d50:	83 c4 10             	add    $0x10,%esp
			break;
  800d53:	e9 89 02 00 00       	jmp    800fe1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d69:	85 db                	test   %ebx,%ebx
  800d6b:	79 02                	jns    800d6f <vprintfmt+0x14a>
				err = -err;
  800d6d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d6f:	83 fb 64             	cmp    $0x64,%ebx
  800d72:	7f 0b                	jg     800d7f <vprintfmt+0x15a>
  800d74:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800d7b:	85 f6                	test   %esi,%esi
  800d7d:	75 19                	jne    800d98 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d7f:	53                   	push   %ebx
  800d80:	68 c5 3b 80 00       	push   $0x803bc5
  800d85:	ff 75 0c             	pushl  0xc(%ebp)
  800d88:	ff 75 08             	pushl  0x8(%ebp)
  800d8b:	e8 5e 02 00 00       	call   800fee <printfmt>
  800d90:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d93:	e9 49 02 00 00       	jmp    800fe1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d98:	56                   	push   %esi
  800d99:	68 ce 3b 80 00       	push   $0x803bce
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	ff 75 08             	pushl  0x8(%ebp)
  800da4:	e8 45 02 00 00       	call   800fee <printfmt>
  800da9:	83 c4 10             	add    $0x10,%esp
			break;
  800dac:	e9 30 02 00 00       	jmp    800fe1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db1:	8b 45 14             	mov    0x14(%ebp),%eax
  800db4:	83 c0 04             	add    $0x4,%eax
  800db7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dba:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbd:	83 e8 04             	sub    $0x4,%eax
  800dc0:	8b 30                	mov    (%eax),%esi
  800dc2:	85 f6                	test   %esi,%esi
  800dc4:	75 05                	jne    800dcb <vprintfmt+0x1a6>
				p = "(null)";
  800dc6:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  800dcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dcf:	7e 6d                	jle    800e3e <vprintfmt+0x219>
  800dd1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd5:	74 67                	je     800e3e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	50                   	push   %eax
  800dde:	56                   	push   %esi
  800ddf:	e8 0c 03 00 00       	call   8010f0 <strnlen>
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dea:	eb 16                	jmp    800e02 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dec:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	50                   	push   %eax
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	ff d0                	call   *%eax
  800dfc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dff:	ff 4d e4             	decl   -0x1c(%ebp)
  800e02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e06:	7f e4                	jg     800dec <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e08:	eb 34                	jmp    800e3e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e0e:	74 1c                	je     800e2c <vprintfmt+0x207>
  800e10:	83 fb 1f             	cmp    $0x1f,%ebx
  800e13:	7e 05                	jle    800e1a <vprintfmt+0x1f5>
  800e15:	83 fb 7e             	cmp    $0x7e,%ebx
  800e18:	7e 12                	jle    800e2c <vprintfmt+0x207>
					putch('?', putdat);
  800e1a:	83 ec 08             	sub    $0x8,%esp
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	6a 3f                	push   $0x3f
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	eb 0f                	jmp    800e3b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	53                   	push   %ebx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3e:	89 f0                	mov    %esi,%eax
  800e40:	8d 70 01             	lea    0x1(%eax),%esi
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	0f be d8             	movsbl %al,%ebx
  800e48:	85 db                	test   %ebx,%ebx
  800e4a:	74 24                	je     800e70 <vprintfmt+0x24b>
  800e4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e50:	78 b8                	js     800e0a <vprintfmt+0x1e5>
  800e52:	ff 4d e0             	decl   -0x20(%ebp)
  800e55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e59:	79 af                	jns    800e0a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5b:	eb 13                	jmp    800e70 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 20                	push   $0x20
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e74:	7f e7                	jg     800e5d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e76:	e9 66 01 00 00       	jmp    800fe1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e81:	8d 45 14             	lea    0x14(%ebp),%eax
  800e84:	50                   	push   %eax
  800e85:	e8 3c fd ff ff       	call   800bc6 <getint>
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e99:	85 d2                	test   %edx,%edx
  800e9b:	79 23                	jns    800ec0 <vprintfmt+0x29b>
				putch('-', putdat);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	6a 2d                	push   $0x2d
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	f7 d8                	neg    %eax
  800eb5:	83 d2 00             	adc    $0x0,%edx
  800eb8:	f7 da                	neg    %edx
  800eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ebd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec7:	e9 bc 00 00 00       	jmp    800f88 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed5:	50                   	push   %eax
  800ed6:	e8 84 fc ff ff       	call   800b5f <getuint>
  800edb:	83 c4 10             	add    $0x10,%esp
  800ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eeb:	e9 98 00 00 00       	jmp    800f88 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	6a 58                	push   $0x58
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	6a 58                	push   $0x58
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	ff d0                	call   *%eax
  800f0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	6a 58                	push   $0x58
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
			break;
  800f20:	e9 bc 00 00 00       	jmp    800fe1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 30                	push   $0x30
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 78                	push   $0x78
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f51:	83 e8 04             	sub    $0x4,%eax
  800f54:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f60:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f67:	eb 1f                	jmp    800f88 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f72:	50                   	push   %eax
  800f73:	e8 e7 fb ff ff       	call   800b5f <getuint>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f81:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f88:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	52                   	push   %edx
  800f93:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f96:	50                   	push   %eax
  800f97:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9a:	ff 75 f0             	pushl  -0x10(%ebp)
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	ff 75 08             	pushl  0x8(%ebp)
  800fa3:	e8 00 fb ff ff       	call   800aa8 <printnum>
  800fa8:	83 c4 20             	add    $0x20,%esp
			break;
  800fab:	eb 34                	jmp    800fe1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	53                   	push   %ebx
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	ff d0                	call   *%eax
  800fb9:	83 c4 10             	add    $0x10,%esp
			break;
  800fbc:	eb 23                	jmp    800fe1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	ff 75 0c             	pushl  0xc(%ebp)
  800fc4:	6a 25                	push   $0x25
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	ff d0                	call   *%eax
  800fcb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fce:	ff 4d 10             	decl   0x10(%ebp)
  800fd1:	eb 03                	jmp    800fd6 <vprintfmt+0x3b1>
  800fd3:	ff 4d 10             	decl   0x10(%ebp)
  800fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd9:	48                   	dec    %eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 25                	cmp    $0x25,%al
  800fde:	75 f3                	jne    800fd3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe0:	90                   	nop
		}
	}
  800fe1:	e9 47 fc ff ff       	jmp    800c2d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fea:	5b                   	pop    %ebx
  800feb:	5e                   	pop    %esi
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    

00800fee <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff7:	83 c0 04             	add    $0x4,%eax
  800ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	ff 75 f4             	pushl  -0xc(%ebp)
  801003:	50                   	push   %eax
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	ff 75 08             	pushl  0x8(%ebp)
  80100a:	e8 16 fc ff ff       	call   800c25 <vprintfmt>
  80100f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801012:	90                   	nop
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8b 40 08             	mov    0x8(%eax),%eax
  80101e:	8d 50 01             	lea    0x1(%eax),%edx
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8b 10                	mov    (%eax),%edx
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	8b 40 04             	mov    0x4(%eax),%eax
  801032:	39 c2                	cmp    %eax,%edx
  801034:	73 12                	jae    801048 <sprintputch+0x33>
		*b->buf++ = ch;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	8d 48 01             	lea    0x1(%eax),%ecx
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	89 0a                	mov    %ecx,(%edx)
  801043:	8b 55 08             	mov    0x8(%ebp),%edx
  801046:	88 10                	mov    %dl,(%eax)
}
  801048:	90                   	nop
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801065:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80106c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801070:	74 06                	je     801078 <vsnprintf+0x2d>
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	7f 07                	jg     80107f <vsnprintf+0x34>
		return -E_INVAL;
  801078:	b8 03 00 00 00       	mov    $0x3,%eax
  80107d:	eb 20                	jmp    80109f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80107f:	ff 75 14             	pushl  0x14(%ebp)
  801082:	ff 75 10             	pushl  0x10(%ebp)
  801085:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801088:	50                   	push   %eax
  801089:	68 15 10 80 00       	push   $0x801015
  80108e:	e8 92 fb ff ff       	call   800c25 <vprintfmt>
  801093:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801099:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80109c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8010aa:	83 c0 04             	add    $0x4,%eax
  8010ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b6:	50                   	push   %eax
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	ff 75 08             	pushl  0x8(%ebp)
  8010bd:	e8 89 ff ff ff       	call   80104b <vsnprintf>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010da:	eb 06                	jmp    8010e2 <strlen+0x15>
		n++;
  8010dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010df:	ff 45 08             	incl   0x8(%ebp)
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	84 c0                	test   %al,%al
  8010e9:	75 f1                	jne    8010dc <strlen+0xf>
		n++;
	return n;
  8010eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010fd:	eb 09                	jmp    801108 <strnlen+0x18>
		n++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801102:	ff 45 08             	incl   0x8(%ebp)
  801105:	ff 4d 0c             	decl   0xc(%ebp)
  801108:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80110c:	74 09                	je     801117 <strnlen+0x27>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	84 c0                	test   %al,%al
  801115:	75 e8                	jne    8010ff <strnlen+0xf>
		n++;
	return n;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801128:	90                   	nop
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	89 55 08             	mov    %edx,0x8(%ebp)
  801132:	8b 55 0c             	mov    0xc(%ebp),%edx
  801135:	8d 4a 01             	lea    0x1(%edx),%ecx
  801138:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113b:	8a 12                	mov    (%edx),%dl
  80113d:	88 10                	mov    %dl,(%eax)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	75 e4                	jne    801129 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115d:	eb 1f                	jmp    80117e <strncpy+0x34>
		*dst++ = *src;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8d 50 01             	lea    0x1(%eax),%edx
  801165:	89 55 08             	mov    %edx,0x8(%ebp)
  801168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116b:	8a 12                	mov    (%edx),%dl
  80116d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 03                	je     80117b <strncpy+0x31>
			src++;
  801178:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117b:	ff 45 fc             	incl   -0x4(%ebp)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	3b 45 10             	cmp    0x10(%ebp),%eax
  801184:	72 d9                	jb     80115f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	74 30                	je     8011cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80119d:	eb 16                	jmp    8011b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8d 50 01             	lea    0x1(%eax),%edx
  8011a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b1:	8a 12                	mov    (%edx),%dl
  8011b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b5:	ff 4d 10             	decl   0x10(%ebp)
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 09                	je     8011c7 <strlcpy+0x3c>
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	84 c0                	test   %al,%al
  8011c5:	75 d8                	jne    80119f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	29 c2                	sub    %eax,%edx
  8011d5:	89 d0                	mov    %edx,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011dc:	eb 06                	jmp    8011e4 <strcmp+0xb>
		p++, q++;
  8011de:	ff 45 08             	incl   0x8(%ebp)
  8011e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	84 c0                	test   %al,%al
  8011eb:	74 0e                	je     8011fb <strcmp+0x22>
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 10                	mov    (%eax),%dl
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	38 c2                	cmp    %al,%dl
  8011f9:	74 e3                	je     8011de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	0f b6 d0             	movzbl %al,%edx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f b6 c0             	movzbl %al,%eax
  80120b:	29 c2                	sub    %eax,%edx
  80120d:	89 d0                	mov    %edx,%eax
}
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801214:	eb 09                	jmp    80121f <strncmp+0xe>
		n--, p++, q++;
  801216:	ff 4d 10             	decl   0x10(%ebp)
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80121f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801223:	74 17                	je     80123c <strncmp+0x2b>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	84 c0                	test   %al,%al
  80122c:	74 0e                	je     80123c <strncmp+0x2b>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 10                	mov    (%eax),%dl
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	38 c2                	cmp    %al,%dl
  80123a:	74 da                	je     801216 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80123c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801240:	75 07                	jne    801249 <strncmp+0x38>
		return 0;
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
  801247:	eb 14                	jmp    80125d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f b6 d0             	movzbl %al,%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	0f b6 c0             	movzbl %al,%eax
  801259:	29 c2                	sub    %eax,%edx
  80125b:	89 d0                	mov    %edx,%eax
}
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126b:	eb 12                	jmp    80127f <strchr+0x20>
		if (*s == c)
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801275:	75 05                	jne    80127c <strchr+0x1d>
			return (char *) s;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	eb 11                	jmp    80128d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	84 c0                	test   %al,%al
  801286:	75 e5                	jne    80126d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129b:	eb 0d                	jmp    8012aa <strfind+0x1b>
		if (*s == c)
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a5:	74 0e                	je     8012b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a7:	ff 45 08             	incl   0x8(%ebp)
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	84 c0                	test   %al,%al
  8012b1:	75 ea                	jne    80129d <strfind+0xe>
  8012b3:	eb 01                	jmp    8012b6 <strfind+0x27>
		if (*s == c)
			break;
  8012b5:	90                   	nop
	return (char *) s;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012cd:	eb 0e                	jmp    8012dd <memset+0x22>
		*p++ = c;
  8012cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d2:	8d 50 01             	lea    0x1(%eax),%edx
  8012d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012dd:	ff 4d f8             	decl   -0x8(%ebp)
  8012e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e4:	79 e9                	jns    8012cf <memset+0x14>
		*p++ = c;

	return v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012fd:	eb 16                	jmp    801315 <memcpy+0x2a>
		*d++ = *s++;
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	8d 50 01             	lea    0x1(%eax),%edx
  801305:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801308:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801311:	8a 12                	mov    (%edx),%dl
  801313:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131b:	89 55 10             	mov    %edx,0x10(%ebp)
  80131e:	85 c0                	test   %eax,%eax
  801320:	75 dd                	jne    8012ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801339:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80133f:	73 50                	jae    801391 <memmove+0x6a>
  801341:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80134c:	76 43                	jbe    801391 <memmove+0x6a>
		s += n;
  80134e:	8b 45 10             	mov    0x10(%ebp),%eax
  801351:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135a:	eb 10                	jmp    80136c <memmove+0x45>
			*--d = *--s;
  80135c:	ff 4d f8             	decl   -0x8(%ebp)
  80135f:	ff 4d fc             	decl   -0x4(%ebp)
  801362:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80136c:	8b 45 10             	mov    0x10(%ebp),%eax
  80136f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801372:	89 55 10             	mov    %edx,0x10(%ebp)
  801375:	85 c0                	test   %eax,%eax
  801377:	75 e3                	jne    80135c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801379:	eb 23                	jmp    80139e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137e:	8d 50 01             	lea    0x1(%eax),%edx
  801381:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801384:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801387:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80138d:	8a 12                	mov    (%edx),%dl
  80138f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 dd                	jne    80137b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b5:	eb 2a                	jmp    8013e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8013b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ba:	8a 10                	mov    (%eax),%dl
  8013bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	38 c2                	cmp    %al,%dl
  8013c3:	74 16                	je     8013db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	0f b6 d0             	movzbl %al,%edx
  8013cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	0f b6 c0             	movzbl %al,%eax
  8013d5:	29 c2                	sub    %eax,%edx
  8013d7:	89 d0                	mov    %edx,%eax
  8013d9:	eb 18                	jmp    8013f3 <memcmp+0x50>
		s1++, s2++;
  8013db:	ff 45 fc             	incl   -0x4(%ebp)
  8013de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	75 c9                	jne    8013b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801406:	eb 15                	jmp    80141d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	0f b6 d0             	movzbl %al,%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	0f b6 c0             	movzbl %al,%eax
  801416:	39 c2                	cmp    %eax,%edx
  801418:	74 0d                	je     801427 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141a:	ff 45 08             	incl   0x8(%ebp)
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801423:	72 e3                	jb     801408 <memfind+0x13>
  801425:	eb 01                	jmp    801428 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801427:	90                   	nop
	return (void *) s;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801441:	eb 03                	jmp    801446 <strtol+0x19>
		s++;
  801443:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	3c 20                	cmp    $0x20,%al
  80144d:	74 f4                	je     801443 <strtol+0x16>
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 09                	cmp    $0x9,%al
  801456:	74 eb                	je     801443 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	3c 2b                	cmp    $0x2b,%al
  80145f:	75 05                	jne    801466 <strtol+0x39>
		s++;
  801461:	ff 45 08             	incl   0x8(%ebp)
  801464:	eb 13                	jmp    801479 <strtol+0x4c>
	else if (*s == '-')
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 2d                	cmp    $0x2d,%al
  80146d:	75 0a                	jne    801479 <strtol+0x4c>
		s++, neg = 1;
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801479:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147d:	74 06                	je     801485 <strtol+0x58>
  80147f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801483:	75 20                	jne    8014a5 <strtol+0x78>
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	3c 30                	cmp    $0x30,%al
  80148c:	75 17                	jne    8014a5 <strtol+0x78>
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	40                   	inc    %eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 78                	cmp    $0x78,%al
  801496:	75 0d                	jne    8014a5 <strtol+0x78>
		s += 2, base = 16;
  801498:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80149c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a3:	eb 28                	jmp    8014cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a9:	75 15                	jne    8014c0 <strtol+0x93>
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 30                	cmp    $0x30,%al
  8014b2:	75 0c                	jne    8014c0 <strtol+0x93>
		s++, base = 8;
  8014b4:	ff 45 08             	incl   0x8(%ebp)
  8014b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014be:	eb 0d                	jmp    8014cd <strtol+0xa0>
	else if (base == 0)
  8014c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c4:	75 07                	jne    8014cd <strtol+0xa0>
		base = 10;
  8014c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	3c 2f                	cmp    $0x2f,%al
  8014d4:	7e 19                	jle    8014ef <strtol+0xc2>
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	3c 39                	cmp    $0x39,%al
  8014dd:	7f 10                	jg     8014ef <strtol+0xc2>
			dig = *s - '0';
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	0f be c0             	movsbl %al,%eax
  8014e7:	83 e8 30             	sub    $0x30,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ed:	eb 42                	jmp    801531 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	3c 60                	cmp    $0x60,%al
  8014f6:	7e 19                	jle    801511 <strtol+0xe4>
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	3c 7a                	cmp    $0x7a,%al
  8014ff:	7f 10                	jg     801511 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8a 00                	mov    (%eax),%al
  801506:	0f be c0             	movsbl %al,%eax
  801509:	83 e8 57             	sub    $0x57,%eax
  80150c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150f:	eb 20                	jmp    801531 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	3c 40                	cmp    $0x40,%al
  801518:	7e 39                	jle    801553 <strtol+0x126>
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	3c 5a                	cmp    $0x5a,%al
  801521:	7f 30                	jg     801553 <strtol+0x126>
			dig = *s - 'A' + 10;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	0f be c0             	movsbl %al,%eax
  80152b:	83 e8 37             	sub    $0x37,%eax
  80152e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801534:	3b 45 10             	cmp    0x10(%ebp),%eax
  801537:	7d 19                	jge    801552 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801539:	ff 45 08             	incl   0x8(%ebp)
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801543:	89 c2                	mov    %eax,%edx
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80154d:	e9 7b ff ff ff       	jmp    8014cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801552:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801557:	74 08                	je     801561 <strtol+0x134>
		*endptr = (char *) s;
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8b 55 08             	mov    0x8(%ebp),%edx
  80155f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801561:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801565:	74 07                	je     80156e <strtol+0x141>
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	f7 d8                	neg    %eax
  80156c:	eb 03                	jmp    801571 <strtol+0x144>
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <ltostr>:

void
ltostr(long value, char *str)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801579:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801580:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158b:	79 13                	jns    8015a0 <ltostr+0x2d>
	{
		neg = 1;
  80158d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80159d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015a8:	99                   	cltd   
  8015a9:	f7 f9                	idiv   %ecx
  8015ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	8d 50 01             	lea    0x1(%eax),%edx
  8015b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b7:	89 c2                	mov    %eax,%edx
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c1:	83 c2 30             	add    $0x30,%edx
  8015c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015ce:	f7 e9                	imul   %ecx
  8015d0:	c1 fa 02             	sar    $0x2,%edx
  8015d3:	89 c8                	mov    %ecx,%eax
  8015d5:	c1 f8 1f             	sar    $0x1f,%eax
  8015d8:	29 c2                	sub    %eax,%edx
  8015da:	89 d0                	mov    %edx,%eax
  8015dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015e7:	f7 e9                	imul   %ecx
  8015e9:	c1 fa 02             	sar    $0x2,%edx
  8015ec:	89 c8                	mov    %ecx,%eax
  8015ee:	c1 f8 1f             	sar    $0x1f,%eax
  8015f1:	29 c2                	sub    %eax,%edx
  8015f3:	89 d0                	mov    %edx,%eax
  8015f5:	c1 e0 02             	shl    $0x2,%eax
  8015f8:	01 d0                	add    %edx,%eax
  8015fa:	01 c0                	add    %eax,%eax
  8015fc:	29 c1                	sub    %eax,%ecx
  8015fe:	89 ca                	mov    %ecx,%edx
  801600:	85 d2                	test   %edx,%edx
  801602:	75 9c                	jne    8015a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	48                   	dec    %eax
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801612:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801616:	74 3d                	je     801655 <ltostr+0xe2>
		start = 1 ;
  801618:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80161f:	eb 34                	jmp    801655 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80162e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	01 c2                	add    %eax,%edx
  801636:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	01 c8                	add    %ecx,%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801642:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801645:	8b 45 0c             	mov    0xc(%ebp),%eax
  801648:	01 c2                	add    %eax,%edx
  80164a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80164d:	88 02                	mov    %al,(%edx)
		start++ ;
  80164f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801652:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801658:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165b:	7c c4                	jl     801621 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80165d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	01 d0                	add    %edx,%eax
  801665:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801668:	90                   	nop
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 54 fa ff ff       	call   8010cd <strlen>
  801679:	83 c4 04             	add    $0x4,%esp
  80167c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	e8 46 fa ff ff       	call   8010cd <strlen>
  801687:	83 c4 04             	add    $0x4,%esp
  80168a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80168d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169b:	eb 17                	jmp    8016b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80169d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 c2                	add    %eax,%edx
  8016a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	01 c8                	add    %ecx,%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b1:	ff 45 fc             	incl   -0x4(%ebp)
  8016b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016ba:	7c e1                	jl     80169d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ca:	eb 1f                	jmp    8016eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cf:	8d 50 01             	lea    0x1(%eax),%edx
  8016d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	01 c2                	add    %eax,%edx
  8016dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	01 c8                	add    %ecx,%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016e8:	ff 45 f8             	incl   -0x8(%ebp)
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f1:	7c d9                	jl     8016cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801704:	8b 45 14             	mov    0x14(%ebp),%eax
  801707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80170d:	8b 45 14             	mov    0x14(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801719:	8b 45 10             	mov    0x10(%ebp),%eax
  80171c:	01 d0                	add    %edx,%eax
  80171e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801724:	eb 0c                	jmp    801732 <strsplit+0x31>
			*string++ = 0;
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8d 50 01             	lea    0x1(%eax),%edx
  80172c:	89 55 08             	mov    %edx,0x8(%ebp)
  80172f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	84 c0                	test   %al,%al
  801739:	74 18                	je     801753 <strsplit+0x52>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	0f be c0             	movsbl %al,%eax
  801743:	50                   	push   %eax
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	e8 13 fb ff ff       	call   80125f <strchr>
  80174c:	83 c4 08             	add    $0x8,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	75 d3                	jne    801726 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	84 c0                	test   %al,%al
  80175a:	74 5a                	je     8017b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80175c:	8b 45 14             	mov    0x14(%ebp),%eax
  80175f:	8b 00                	mov    (%eax),%eax
  801761:	83 f8 0f             	cmp    $0xf,%eax
  801764:	75 07                	jne    80176d <strsplit+0x6c>
		{
			return 0;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 66                	jmp    8017d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80176d:	8b 45 14             	mov    0x14(%ebp),%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	8d 48 01             	lea    0x1(%eax),%ecx
  801775:	8b 55 14             	mov    0x14(%ebp),%edx
  801778:	89 0a                	mov    %ecx,(%edx)
  80177a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	01 c2                	add    %eax,%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178b:	eb 03                	jmp    801790 <strsplit+0x8f>
			string++;
  80178d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	84 c0                	test   %al,%al
  801797:	74 8b                	je     801724 <strsplit+0x23>
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	0f be c0             	movsbl %al,%eax
  8017a1:	50                   	push   %eax
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	e8 b5 fa ff ff       	call   80125f <strchr>
  8017aa:	83 c4 08             	add    $0x8,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	74 dc                	je     80178d <strsplit+0x8c>
			string++;
	}
  8017b1:	e9 6e ff ff ff       	jmp    801724 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ba:	8b 00                	mov    (%eax),%eax
  8017bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c6:	01 d0                	add    %edx,%eax
  8017c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8017db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017e2:	eb 4c                	jmp    801830 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8017e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ea:	01 d0                	add    %edx,%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	3c 40                	cmp    $0x40,%al
  8017f0:	7e 27                	jle    801819 <str2lower+0x44>
  8017f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	8a 00                	mov    (%eax),%al
  8017fc:	3c 5a                	cmp    $0x5a,%al
  8017fe:	7f 19                	jg     801819 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801800:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80180b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180e:	01 ca                	add    %ecx,%edx
  801810:	8a 12                	mov    (%edx),%dl
  801812:	83 c2 20             	add    $0x20,%edx
  801815:	88 10                	mov    %dl,(%eax)
  801817:	eb 14                	jmp    80182d <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801819:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	01 c2                	add    %eax,%edx
  801821:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 c8                	add    %ecx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80182d:	ff 45 fc             	incl   -0x4(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	e8 95 f8 ff ff       	call   8010cd <strlen>
  801838:	83 c4 04             	add    $0x4,%esp
  80183b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80183e:	7f a4                	jg     8017e4 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801840:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	01 d0                	add    %edx,%eax
  801848:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801853:	a1 48 40 80 00       	mov    0x804048,%eax
  801858:	8b 55 08             	mov    0x8(%ebp),%edx
  80185b:	89 14 c5 40 83 80 00 	mov    %edx,0x808340(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801862:	a1 48 40 80 00       	mov    0x804048,%eax
  801867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186a:	89 14 c5 44 83 80 00 	mov    %edx,0x808344(,%eax,8)
	marked_pagessize++;
  801871:	a1 48 40 80 00       	mov    0x804048,%eax
  801876:	40                   	inc    %eax
  801877:	a3 48 40 80 00       	mov    %eax,0x804048
}
  80187c:	90                   	nop
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <searchElement>:

int searchElement(uint32 start) {
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188c:	eb 17                	jmp    8018a5 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  80188e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801891:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  801898:	3b 45 08             	cmp    0x8(%ebp),%eax
  80189b:	75 05                	jne    8018a2 <searchElement+0x23>
			return i;
  80189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a0:	eb 12                	jmp    8018b4 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  8018a2:	ff 45 fc             	incl   -0x4(%ebp)
  8018a5:	a1 48 40 80 00       	mov    0x804048,%eax
  8018aa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8018ad:	7c df                	jl     80188e <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  8018af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <removeElement>:
void removeElement(uint32 start) {
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	e8 bb ff ff ff       	call   80187f <searchElement>
  8018c4:	83 c4 04             	add    $0x4,%esp
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  8018ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8018d0:	eb 26                	jmp    8018f8 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  8018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d5:	40                   	inc    %eax
  8018d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018d9:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  8018e0:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  8018e7:	89 04 cd 40 83 80 00 	mov    %eax,0x808340(,%ecx,8)
  8018ee:	89 14 cd 44 83 80 00 	mov    %edx,0x808344(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  8018f5:	ff 45 fc             	incl   -0x4(%ebp)
  8018f8:	a1 48 40 80 00       	mov    0x804048,%eax
  8018fd:	48                   	dec    %eax
  8018fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801901:	7f cf                	jg     8018d2 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801903:	a1 48 40 80 00       	mov    0x804048,%eax
  801908:	48                   	dec    %eax
  801909:	a3 48 40 80 00       	mov    %eax,0x804048
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <searchfree>:
int searchfree(uint32 end)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801917:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80191e:	eb 17                	jmp    801937 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801923:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  80192a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80192d:	75 05                	jne    801934 <searchfree+0x23>
			return i;
  80192f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801932:	eb 12                	jmp    801946 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801934:	ff 45 fc             	incl   -0x4(%ebp)
  801937:	a1 48 40 80 00       	mov    0x804048,%eax
  80193c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  80193f:	7c df                	jl     801920 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <removefree>:
void removefree(uint32 end)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  80194e:	eb 52                	jmp    8019a2 <removefree+0x5a>
		int index = searchfree(end);
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	e8 b9 ff ff ff       	call   801911 <searchfree>
  801958:	83 c4 04             	add    $0x4,%esp
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801964:	eb 26                	jmp    80198c <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801966:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801969:	40                   	inc    %eax
  80196a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80196d:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  801974:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  80197b:	89 04 cd 40 83 80 00 	mov    %eax,0x808340(,%ecx,8)
  801982:	89 14 cd 44 83 80 00 	mov    %edx,0x808344(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801989:	ff 45 fc             	incl   -0x4(%ebp)
  80198c:	a1 48 40 80 00       	mov    0x804048,%eax
  801991:	48                   	dec    %eax
  801992:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801995:	7f cf                	jg     801966 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801997:	a1 48 40 80 00       	mov    0x804048,%eax
  80199c:	48                   	dec    %eax
  80199d:	a3 48 40 80 00       	mov    %eax,0x804048
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	e8 67 ff ff ff       	call   801911 <searchfree>
  8019aa:	83 c4 04             	add    $0x4,%esp
  8019ad:	83 f8 ff             	cmp    $0xffffffff,%eax
  8019b0:	75 9e                	jne    801950 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <printArray>:
void printArray() {
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	68 30 3d 80 00       	push   $0x803d30
  8019c3:	e8 83 f0 ff ff       	call   800a4b <cprintf>
  8019c8:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8019cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8019d2:	eb 29                	jmp    8019fd <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  8019d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d7:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  8019e8:	52                   	push   %edx
  8019e9:	50                   	push   %eax
  8019ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ed:	68 41 3d 80 00       	push   $0x803d41
  8019f2:	e8 54 f0 ff ff       	call   800a4b <cprintf>
  8019f7:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  8019fa:	ff 45 f4             	incl   -0xc(%ebp)
  8019fd:	a1 48 40 80 00       	mov    0x804048,%eax
  801a02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801a05:	7c cd                	jl     8019d4 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801a0d:	a1 20 40 80 00       	mov    0x804020,%eax
  801a12:	85 c0                	test   %eax,%eax
  801a14:	74 0a                	je     801a20 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a16:	c7 05 20 40 80 00 00 	movl   $0x0,0x804020
  801a1d:	00 00 00 
	}
}
  801a20:	90                   	nop
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	ff 75 08             	pushl  0x8(%ebp)
  801a2f:	e8 4f 09 00 00       	call   802383 <sys_sbrk>
  801a34:	83 c4 10             	add    $0x10,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a3f:	e8 c6 ff ff ff       	call   801a0a <InitializeUHeap>
	if (size == 0) return NULL ;
  801a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a48:	75 0a                	jne    801a54 <malloc+0x1b>
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	e9 43 01 00 00       	jmp    801b97 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801a54:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a5b:	77 3c                	ja     801a99 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801a5d:	e8 c3 07 00 00       	call   802225 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 13                	je     801a79 <malloc+0x40>
			return alloc_block_FF(size);
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	e8 89 0b 00 00       	call   8025fa <alloc_block_FF>
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	e9 1e 01 00 00       	jmp    801b97 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801a79:	e8 d8 07 00 00       	call   802256 <sys_isUHeapPlacementStrategyBESTFIT>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	0f 84 0c 01 00 00    	je     801b92 <malloc+0x159>
			return alloc_block_BF(size);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 7d 0e 00 00       	call   80290e <alloc_block_BF>
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	e9 fe 00 00 00       	jmp    801b97 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801a99:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa6:	01 d0                	add    %edx,%eax
  801aa8:	48                   	dec    %eax
  801aa9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab4:	f7 75 e0             	divl   -0x20(%ebp)
  801ab7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aba:	29 d0                	sub    %edx,%eax
  801abc:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	c1 e8 0c             	shr    $0xc,%eax
  801ac5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801acf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801ad6:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801add:	e8 f4 08 00 00       	call   8023d6 <sys_hard_limit>
  801ae2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801ae5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ae8:	05 00 10 00 00       	add    $0x1000,%eax
  801aed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801af0:	eb 49                	jmp    801b3b <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	ff 75 e8             	pushl  -0x18(%ebp)
  801af8:	e8 82 fd ff ff       	call   80187f <searchElement>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	83 f8 ff             	cmp    $0xffffffff,%eax
  801b03:	75 28                	jne    801b2d <malloc+0xf4>
			{


				count++;
  801b05:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b0e:	75 24                	jne    801b34 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b13:	05 00 10 00 00       	add    $0x1000,%eax
  801b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1e:	c1 e0 0c             	shl    $0xc,%eax
  801b21:	89 c2                	mov    %eax,%edx
  801b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b26:	29 d0                	sub    %edx,%eax
  801b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801b2b:	eb 17                	jmp    801b44 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801b34:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801b3b:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801b42:	76 ae                	jbe    801af2 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801b44:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801b48:	75 07                	jne    801b51 <malloc+0x118>
		{
			return NULL;
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	eb 46                	jmp    801b97 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b57:	eb 1a                	jmp    801b73 <malloc+0x13a>
		{
			addElement(i,end);
  801b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	e8 e7 fc ff ff       	call   801850 <addElement>
  801b69:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801b6c:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b79:	7c de                	jl     801b59 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	50                   	push   %eax
  801b85:	e8 30 08 00 00       	call   8023ba <sys_allocate_user_mem>
  801b8a:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b90:	eb 05                	jmp    801b97 <malloc+0x15e>
	}
	return NULL;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801b9f:	e8 32 08 00 00       	call   8023d6 <sys_hard_limit>
  801ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	85 c0                	test   %eax,%eax
  801bac:	0f 89 82 00 00 00    	jns    801c34 <free+0x9b>
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801bba:	77 78                	ja     801c34 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bc2:	73 10                	jae    801bd4 <free+0x3b>
			free_block(virtual_address);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	e8 d2 0e 00 00       	call   802aa1 <free_block>
  801bcf:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801bd2:	eb 77                	jmp    801c4b <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	50                   	push   %eax
  801bdb:	e8 9f fc ff ff       	call   80187f <searchElement>
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be9:	8b 14 c5 44 83 80 00 	mov    0x808344(,%eax,8),%edx
  801bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf3:	8b 04 c5 40 83 80 00 	mov    0x808340(,%eax,8),%eax
  801bfa:	29 c2                	sub    %eax,%edx
  801bfc:	89 d0                	mov    %edx,%eax
  801bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c04:	c1 e8 0c             	shr    $0xc,%eax
  801c07:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	ff 75 ec             	pushl  -0x14(%ebp)
  801c13:	50                   	push   %eax
  801c14:	e8 85 07 00 00       	call   80239e <sys_free_user_mem>
  801c19:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	8b 04 c5 44 83 80 00 	mov    0x808344(,%eax,8),%eax
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	50                   	push   %eax
  801c2a:	e8 19 fd ff ff       	call   801948 <removefree>
  801c2f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801c32:	eb 17                	jmp    801c4b <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	68 5a 3d 80 00       	push   $0x803d5a
  801c3c:	68 ac 00 00 00       	push   $0xac
  801c41:	68 6a 3d 80 00       	push   $0x803d6a
  801c46:	e8 43 eb ff ff       	call   80078e <_panic>
	}
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 18             	sub    $0x18,%esp
  801c54:	8b 45 10             	mov    0x10(%ebp),%eax
  801c57:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c5a:	e8 ab fd ff ff       	call   801a0a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c63:	75 07                	jne    801c6c <smalloc+0x1e>
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	eb 17                	jmp    801c83 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	68 78 3d 80 00       	push   $0x803d78
  801c74:	68 bc 00 00 00       	push   $0xbc
  801c79:	68 6a 3d 80 00       	push   $0x803d6a
  801c7e:	e8 0b eb ff ff       	call   80078e <_panic>
	return NULL;
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c8b:	e8 7a fd ff ff       	call   801a0a <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	68 a0 3d 80 00       	push   $0x803da0
  801c98:	68 ca 00 00 00       	push   $0xca
  801c9d:	68 6a 3d 80 00       	push   $0x803d6a
  801ca2:	e8 e7 ea ff ff       	call   80078e <_panic>

00801ca7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cad:	e8 58 fd ff ff       	call   801a0a <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	68 c4 3d 80 00       	push   $0x803dc4
  801cba:	68 ea 00 00 00       	push   $0xea
  801cbf:	68 6a 3d 80 00       	push   $0x803d6a
  801cc4:	e8 c5 ea ff ff       	call   80078e <_panic>

00801cc9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 ec 3d 80 00       	push   $0x803dec
  801cd7:	68 fe 00 00 00       	push   $0xfe
  801cdc:	68 6a 3d 80 00       	push   $0x803d6a
  801ce1:	e8 a8 ea ff ff       	call   80078e <_panic>

00801ce6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 10 3e 80 00       	push   $0x803e10
  801cf4:	68 08 01 00 00       	push   $0x108
  801cf9:	68 6a 3d 80 00       	push   $0x803d6a
  801cfe:	e8 8b ea ff ff       	call   80078e <_panic>

00801d03 <shrink>:

}
void shrink(uint32 newSize)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 10 3e 80 00       	push   $0x803e10
  801d11:	68 0d 01 00 00       	push   $0x10d
  801d16:	68 6a 3d 80 00       	push   $0x803d6a
  801d1b:	e8 6e ea ff ff       	call   80078e <_panic>

00801d20 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 10 3e 80 00       	push   $0x803e10
  801d2e:	68 12 01 00 00       	push   $0x112
  801d33:	68 6a 3d 80 00       	push   $0x803d6a
  801d38:	e8 51 ea ff ff       	call   80078e <_panic>

00801d3d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	57                   	push   %edi
  801d41:	56                   	push   %esi
  801d42:	53                   	push   %ebx
  801d43:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d52:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d55:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d58:	cd 30                	int    $0x30
  801d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    

00801d68 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	52                   	push   %edx
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	50                   	push   %eax
  801d84:	6a 00                	push   $0x0
  801d86:	e8 b2 ff ff ff       	call   801d3d <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	90                   	nop
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 01                	push   $0x1
  801da0:	e8 98 ff ff ff       	call   801d3d <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 05                	push   $0x5
  801dbd:	e8 7b ff ff ff       	call   801d3d <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dcc:	8b 75 18             	mov    0x18(%ebp),%esi
  801dcf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	51                   	push   %ecx
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 06                	push   $0x6
  801de2:	e8 56 ff ff ff       	call   801d3d <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    

00801df1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	52                   	push   %edx
  801e01:	50                   	push   %eax
  801e02:	6a 07                	push   $0x7
  801e04:	e8 34 ff ff ff       	call   801d3d <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	ff 75 08             	pushl  0x8(%ebp)
  801e1d:	6a 08                	push   $0x8
  801e1f:	e8 19 ff ff ff       	call   801d3d <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 09                	push   $0x9
  801e38:	e8 00 ff ff ff       	call   801d3d <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 0a                	push   $0xa
  801e51:	e8 e7 fe ff ff       	call   801d3d <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 0b                	push   $0xb
  801e6a:	e8 ce fe ff ff       	call   801d3d <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 0c                	push   $0xc
  801e83:	e8 b5 fe ff ff       	call   801d3d <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	6a 0d                	push   $0xd
  801e9d:	e8 9b fe ff ff       	call   801d3d <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 0e                	push   $0xe
  801eb6:	e8 82 fe ff ff       	call   801d3d <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 11                	push   $0x11
  801ed0:	e8 68 fe ff ff       	call   801d3d <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 12                	push   $0x12
  801eea:	e8 4e fe ff ff       	call   801d3d <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	50                   	push   %eax
  801f0e:	6a 13                	push   $0x13
  801f10:	e8 28 fe ff ff       	call   801d3d <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	90                   	nop
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 14                	push   $0x14
  801f2a:	e8 0e fe ff ff       	call   801d3d <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	50                   	push   %eax
  801f45:	6a 15                	push   $0x15
  801f47:	e8 f1 fd ff ff       	call   801d3d <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	6a 18                	push   $0x18
  801f64:	e8 d4 fd ff ff       	call   801d3d <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 16                	push   $0x16
  801f81:	e8 b7 fd ff ff       	call   801d3d <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	90                   	nop
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	6a 17                	push   $0x17
  801f9f:	e8 99 fd ff ff       	call   801d3d <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	90                   	nop
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fb6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fb9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	51                   	push   %ecx
  801fc3:	52                   	push   %edx
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	50                   	push   %eax
  801fc8:	6a 19                	push   $0x19
  801fca:	e8 6e fd ff ff       	call   801d3d <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	52                   	push   %edx
  801fe4:	50                   	push   %eax
  801fe5:	6a 1a                	push   $0x1a
  801fe7:	e8 51 fd ff ff       	call   801d3d <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ff4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	51                   	push   %ecx
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 1b                	push   $0x1b
  802006:	e8 32 fd ff ff       	call   801d3d <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802013:	8b 55 0c             	mov    0xc(%ebp),%edx
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	52                   	push   %edx
  802020:	50                   	push   %eax
  802021:	6a 1c                	push   $0x1c
  802023:	e8 15 fd ff ff       	call   801d3d <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 1d                	push   $0x1d
  80203c:	e8 fc fc ff ff       	call   801d3d <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	6a 00                	push   $0x0
  80204e:	ff 75 14             	pushl  0x14(%ebp)
  802051:	ff 75 10             	pushl  0x10(%ebp)
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	50                   	push   %eax
  802058:	6a 1e                	push   $0x1e
  80205a:	e8 de fc ff ff       	call   801d3d <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	50                   	push   %eax
  802073:	6a 1f                	push   $0x1f
  802075:	e8 c3 fc ff ff       	call   801d3d <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	90                   	nop
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	50                   	push   %eax
  80208f:	6a 20                	push   $0x20
  802091:	e8 a7 fc ff ff       	call   801d3d <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 02                	push   $0x2
  8020aa:	e8 8e fc ff ff       	call   801d3d <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 03                	push   $0x3
  8020c3:	e8 75 fc ff ff       	call   801d3d <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 04                	push   $0x4
  8020dc:	e8 5c fc ff ff       	call   801d3d <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_exit_env>:


void sys_exit_env(void)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 21                	push   $0x21
  8020f5:	e8 43 fc ff ff       	call   801d3d <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	90                   	nop
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802106:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802109:	8d 50 04             	lea    0x4(%eax),%edx
  80210c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	6a 22                	push   $0x22
  802119:	e8 1f fc ff ff       	call   801d3d <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
	return result;
  802121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802124:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802127:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80212a:	89 01                	mov    %eax,(%ecx)
  80212c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	c9                   	leave  
  802133:	c2 04 00             	ret    $0x4

00802136 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	ff 75 10             	pushl  0x10(%ebp)
  802140:	ff 75 0c             	pushl  0xc(%ebp)
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	6a 10                	push   $0x10
  802148:	e8 f0 fb ff ff       	call   801d3d <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
	return ;
  802150:	90                   	nop
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_rcr2>:
uint32 sys_rcr2()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 23                	push   $0x23
  802162:	e8 d6 fb ff ff       	call   801d3d <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802178:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	50                   	push   %eax
  802185:	6a 24                	push   $0x24
  802187:	e8 b1 fb ff ff       	call   801d3d <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
	return ;
  80218f:	90                   	nop
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <rsttst>:
void rsttst()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 26                	push   $0x26
  8021a1:	e8 97 fb ff ff       	call   801d3d <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a9:	90                   	nop
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8021bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021bf:	52                   	push   %edx
  8021c0:	50                   	push   %eax
  8021c1:	ff 75 10             	pushl  0x10(%ebp)
  8021c4:	ff 75 0c             	pushl  0xc(%ebp)
  8021c7:	ff 75 08             	pushl  0x8(%ebp)
  8021ca:	6a 25                	push   $0x25
  8021cc:	e8 6c fb ff ff       	call   801d3d <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d4:	90                   	nop
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <chktst>:
void chktst(uint32 n)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	6a 27                	push   $0x27
  8021e7:	e8 51 fb ff ff       	call   801d3d <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ef:	90                   	nop
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <inctst>:

void inctst()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 28                	push   $0x28
  802201:	e8 37 fb ff ff       	call   801d3d <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
	return ;
  802209:	90                   	nop
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <gettst>:
uint32 gettst()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 29                	push   $0x29
  80221b:	e8 1d fb ff ff       	call   801d3d <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 2a                	push   $0x2a
  802237:	e8 01 fb ff ff       	call   801d3d <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
  80223f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802242:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802246:	75 07                	jne    80224f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802248:	b8 01 00 00 00       	mov    $0x1,%eax
  80224d:	eb 05                	jmp    802254 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 2a                	push   $0x2a
  802268:	e8 d0 fa ff ff       	call   801d3d <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
  802270:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802273:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802277:	75 07                	jne    802280 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
  80227e:	eb 05                	jmp    802285 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 2a                	push   $0x2a
  802299:	e8 9f fa ff ff       	call   801d3d <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
  8022a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022a4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022a8:	75 07                	jne    8022b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8022af:	eb 05                	jmp    8022b6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 2a                	push   $0x2a
  8022ca:	e8 6e fa ff ff       	call   801d3d <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
  8022d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022d9:	75 07                	jne    8022e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022db:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e0:	eb 05                	jmp    8022e7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 2b                	push   $0x2b
  8022f9:	e8 3f fa ff ff       	call   801d3d <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802308:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80230b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80230e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	6a 00                	push   $0x0
  802316:	53                   	push   %ebx
  802317:	51                   	push   %ecx
  802318:	52                   	push   %edx
  802319:	50                   	push   %eax
  80231a:	6a 2c                	push   $0x2c
  80231c:	e8 1c fa ff ff       	call   801d3d <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80232c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	52                   	push   %edx
  802339:	50                   	push   %eax
  80233a:	6a 2d                	push   $0x2d
  80233c:	e8 fc f9 ff ff       	call   801d3d <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802349:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	51                   	push   %ecx
  802355:	ff 75 10             	pushl  0x10(%ebp)
  802358:	52                   	push   %edx
  802359:	50                   	push   %eax
  80235a:	6a 2e                	push   $0x2e
  80235c:	e8 dc f9 ff ff       	call   801d3d <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	ff 75 10             	pushl  0x10(%ebp)
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	ff 75 08             	pushl  0x8(%ebp)
  802376:	6a 0f                	push   $0xf
  802378:	e8 c0 f9 ff ff       	call   801d3d <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	50                   	push   %eax
  802392:	6a 2f                	push   $0x2f
  802394:	e8 a4 f9 ff ff       	call   801d3d <syscall>
  802399:	83 c4 18             	add    $0x18,%esp

}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	ff 75 0c             	pushl  0xc(%ebp)
  8023aa:	ff 75 08             	pushl  0x8(%ebp)
  8023ad:	6a 30                	push   $0x30
  8023af:	e8 89 f9 ff ff       	call   801d3d <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp

}
  8023b7:	90                   	nop
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	6a 31                	push   $0x31
  8023cb:	e8 6d f9 ff ff       	call   801d3d <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp

}
  8023d3:	90                   	nop
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 32                	push   $0x32
  8023e5:	e8 53 f9 ff ff       	call   801d3d <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	83 e8 10             	sub    $0x10,%eax
  8023fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  8023fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	83 e8 10             	sub    $0x10,%eax
  802411:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802417:	8a 40 04             	mov    0x4(%eax),%al
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	83 f8 02             	cmp    $0x2,%eax
  80242f:	74 2b                	je     80245c <alloc_block+0x40>
  802431:	83 f8 02             	cmp    $0x2,%eax
  802434:	7f 07                	jg     80243d <alloc_block+0x21>
  802436:	83 f8 01             	cmp    $0x1,%eax
  802439:	74 0e                	je     802449 <alloc_block+0x2d>
  80243b:	eb 58                	jmp    802495 <alloc_block+0x79>
  80243d:	83 f8 03             	cmp    $0x3,%eax
  802440:	74 2d                	je     80246f <alloc_block+0x53>
  802442:	83 f8 04             	cmp    $0x4,%eax
  802445:	74 3b                	je     802482 <alloc_block+0x66>
  802447:	eb 4c                	jmp    802495 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff 75 08             	pushl  0x8(%ebp)
  80244f:	e8 a6 01 00 00       	call   8025fa <alloc_block_FF>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80245a:	eb 4a                	jmp    8024a6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80245c:	83 ec 0c             	sub    $0xc,%esp
  80245f:	ff 75 08             	pushl  0x8(%ebp)
  802462:	e8 1d 06 00 00       	call   802a84 <alloc_block_NF>
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80246d:	eb 37                	jmp    8024a6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80246f:	83 ec 0c             	sub    $0xc,%esp
  802472:	ff 75 08             	pushl  0x8(%ebp)
  802475:	e8 94 04 00 00       	call   80290e <alloc_block_BF>
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802480:	eb 24                	jmp    8024a6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802482:	83 ec 0c             	sub    $0xc,%esp
  802485:	ff 75 08             	pushl  0x8(%ebp)
  802488:	e8 da 05 00 00       	call   802a67 <alloc_block_WF>
  80248d:	83 c4 10             	add    $0x10,%esp
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802493:	eb 11                	jmp    8024a6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	68 20 3e 80 00       	push   $0x803e20
  80249d:	e8 a9 e5 ff ff       	call   800a4b <cprintf>
  8024a2:	83 c4 10             	add    $0x10,%esp
		break;
  8024a5:	90                   	nop
	}
	return va;
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8024b1:	83 ec 0c             	sub    $0xc,%esp
  8024b4:	68 40 3e 80 00       	push   $0x803e40
  8024b9:	e8 8d e5 ff ff       	call   800a4b <cprintf>
  8024be:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	68 6b 3e 80 00       	push   $0x803e6b
  8024c9:	e8 7d e5 ff ff       	call   800a4b <cprintf>
  8024ce:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	eb 26                	jmp    8024ff <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8a 40 04             	mov    0x4(%eax),%al
  8024df:	0f b6 d0             	movzbl %al,%edx
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	52                   	push   %edx
  8024eb:	50                   	push   %eax
  8024ec:	68 83 3e 80 00       	push   $0x803e83
  8024f1:	e8 55 e5 ff ff       	call   800a4b <cprintf>
  8024f6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	74 08                	je     80250d <print_blocks_list+0x62>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 08             	mov    0x8(%eax),%eax
  80250b:	eb 05                	jmp    802512 <print_blocks_list+0x67>
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
  802512:	89 45 10             	mov    %eax,0x10(%ebp)
  802515:	8b 45 10             	mov    0x10(%ebp),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	75 bd                	jne    8024d9 <print_blocks_list+0x2e>
  80251c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802520:	75 b7                	jne    8024d9 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	68 40 3e 80 00       	push   $0x803e40
  80252a:	e8 1c e5 ff ff       	call   800a4b <cprintf>
  80252f:	83 c4 10             	add    $0x10,%esp

}
  802532:	90                   	nop
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  80253b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80253f:	0f 84 b2 00 00 00    	je     8025f7 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802545:	c7 05 4c 40 80 00 01 	movl   $0x1,0x80404c
  80254c:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  80254f:	c7 05 18 83 80 00 00 	movl   $0x0,0x808318
  802556:	00 00 00 
  802559:	c7 05 1c 83 80 00 00 	movl   $0x0,0x80831c
  802560:	00 00 00 
  802563:	c7 05 24 83 80 00 00 	movl   $0x0,0x808324
  80256a:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	a3 28 83 80 00       	mov    %eax,0x808328
		firstBlock->size = initSizeOfAllocatedSpace;
  802575:	a1 28 83 80 00       	mov    0x808328,%eax
  80257a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257d:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  80257f:	a1 28 83 80 00       	mov    0x808328,%eax
  802584:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  802588:	a1 28 83 80 00       	mov    0x808328,%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	75 14                	jne    8025a5 <initialize_dynamic_allocator+0x70>
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	68 9c 3e 80 00       	push   $0x803e9c
  802599:	6a 68                	push   $0x68
  80259b:	68 bf 3e 80 00       	push   $0x803ebf
  8025a0:	e8 e9 e1 ff ff       	call   80078e <_panic>
  8025a5:	a1 28 83 80 00       	mov    0x808328,%eax
  8025aa:	8b 15 18 83 80 00    	mov    0x808318,%edx
  8025b0:	89 50 08             	mov    %edx,0x8(%eax)
  8025b3:	8b 40 08             	mov    0x8(%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 10                	je     8025ca <initialize_dynamic_allocator+0x95>
  8025ba:	a1 18 83 80 00       	mov    0x808318,%eax
  8025bf:	8b 15 28 83 80 00    	mov    0x808328,%edx
  8025c5:	89 50 0c             	mov    %edx,0xc(%eax)
  8025c8:	eb 0a                	jmp    8025d4 <initialize_dynamic_allocator+0x9f>
  8025ca:	a1 28 83 80 00       	mov    0x808328,%eax
  8025cf:	a3 1c 83 80 00       	mov    %eax,0x80831c
  8025d4:	a1 28 83 80 00       	mov    0x808328,%eax
  8025d9:	a3 18 83 80 00       	mov    %eax,0x808318
  8025de:	a1 28 83 80 00       	mov    0x808328,%eax
  8025e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8025ea:	a1 24 83 80 00       	mov    0x808324,%eax
  8025ef:	40                   	inc    %eax
  8025f0:	a3 24 83 80 00       	mov    %eax,0x808324
  8025f5:	eb 01                	jmp    8025f8 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8025f7:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  802600:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	75 40                	jne    802649 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	83 c0 10             	add    $0x10,%eax
  80260f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	83 ec 0c             	sub    $0xc,%esp
  802618:	50                   	push   %eax
  802619:	e8 05 f4 ff ff       	call   801a23 <sbrk>
  80261e:	83 c4 10             	add    $0x10,%esp
  802621:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802624:	83 ec 0c             	sub    $0xc,%esp
  802627:	6a 00                	push   $0x0
  802629:	e8 f5 f3 ff ff       	call   801a23 <sbrk>
  80262e:	83 c4 10             	add    $0x10,%esp
  802631:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802637:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80263a:	83 ec 08             	sub    $0x8,%esp
  80263d:	50                   	push   %eax
  80263e:	ff 75 ec             	pushl  -0x14(%ebp)
  802641:	e8 ef fe ff ff       	call   802535 <initialize_dynamic_allocator>
  802646:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802649:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80264d:	75 0a                	jne    802659 <alloc_block_FF+0x5f>
		 return NULL;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	e9 b3 02 00 00       	jmp    80290c <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  802659:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  80265d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  802664:	a1 18 83 80 00       	mov    0x808318,%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266c:	e9 12 01 00 00       	jmp    802783 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8a 40 04             	mov    0x4(%eax),%al
  802677:	84 c0                	test   %al,%al
  802679:	0f 84 fc 00 00 00    	je     80277b <alloc_block_FF+0x181>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	3b 45 08             	cmp    0x8(%ebp),%eax
  802687:	0f 82 ee 00 00 00    	jb     80277b <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	3b 45 08             	cmp    0x8(%ebp),%eax
  802695:	75 12                	jne    8026a9 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	83 c0 10             	add    $0x10,%eax
  8026a4:	e9 63 02 00 00       	jmp    80290c <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  8026a9:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8026bf:	83 f8 0f             	cmp    $0xf,%eax
  8026c2:	0f 86 a8 00 00 00    	jbe    802770 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026db:	89 c2                	mov    %eax,%edx
  8026dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026e0:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e8:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  8026ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026ed:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  8026f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f5:	74 06                	je     8026fd <alloc_block_FF+0x103>
  8026f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026fb:	75 17                	jne    802714 <alloc_block_FF+0x11a>
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 d8 3e 80 00       	push   $0x803ed8
  802705:	68 91 00 00 00       	push   $0x91
  80270a:	68 bf 3e 80 00       	push   $0x803ebf
  80270f:	e8 7a e0 ff ff       	call   80078e <_panic>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80271d:	89 50 08             	mov    %edx,0x8(%eax)
  802720:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802723:	8b 40 08             	mov    0x8(%eax),%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	74 0c                	je     802736 <alloc_block_FF+0x13c>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 08             	mov    0x8(%eax),%eax
  802730:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802733:	89 50 0c             	mov    %edx,0xc(%eax)
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80273c:	89 50 08             	mov    %edx,0x8(%eax)
  80273f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802745:	89 50 0c             	mov    %edx,0xc(%eax)
  802748:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80274b:	8b 40 08             	mov    0x8(%eax),%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	75 08                	jne    80275a <alloc_block_FF+0x160>
  802752:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802755:	a3 1c 83 80 00       	mov    %eax,0x80831c
  80275a:	a1 24 83 80 00       	mov    0x808324,%eax
  80275f:	40                   	inc    %eax
  802760:	a3 24 83 80 00       	mov    %eax,0x808324
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	83 c0 10             	add    $0x10,%eax
  80276b:	e9 9c 01 00 00       	jmp    80290c <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	83 c0 10             	add    $0x10,%eax
  802776:	e9 91 01 00 00       	jmp    80290c <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  80277b:	a1 20 83 80 00       	mov    0x808320,%eax
  802780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802787:	74 08                	je     802791 <alloc_block_FF+0x197>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 08             	mov    0x8(%eax),%eax
  80278f:	eb 05                	jmp    802796 <alloc_block_FF+0x19c>
  802791:	b8 00 00 00 00       	mov    $0x0,%eax
  802796:	a3 20 83 80 00       	mov    %eax,0x808320
  80279b:	a1 20 83 80 00       	mov    0x808320,%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 85 c9 fe ff ff    	jne    802671 <alloc_block_FF+0x77>
  8027a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ac:	0f 85 bf fe ff ff    	jne    802671 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  8027b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027b6:	0f 85 4b 01 00 00    	jne    802907 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	83 ec 0c             	sub    $0xc,%esp
  8027c2:	50                   	push   %eax
  8027c3:	e8 5b f2 ff ff       	call   801a23 <sbrk>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  8027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d2:	0f 84 28 01 00 00    	je     802900 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  8027de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  8027e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  8027ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027f1:	75 17                	jne    80280a <alloc_block_FF+0x210>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 0c 3f 80 00       	push   $0x803f0c
  8027fb:	68 a1 00 00 00       	push   $0xa1
  802800:	68 bf 3e 80 00       	push   $0x803ebf
  802805:	e8 84 df ff ff       	call   80078e <_panic>
  80280a:	8b 15 1c 83 80 00    	mov    0x80831c,%edx
  802810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802813:	89 50 0c             	mov    %edx,0xc(%eax)
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	8b 40 0c             	mov    0xc(%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 0d                	je     80282d <alloc_block_FF+0x233>
  802820:	a1 1c 83 80 00       	mov    0x80831c,%eax
  802825:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802828:	89 50 08             	mov    %edx,0x8(%eax)
  80282b:	eb 08                	jmp    802835 <alloc_block_FF+0x23b>
  80282d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802830:	a3 18 83 80 00       	mov    %eax,0x808318
  802835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802838:	a3 1c 83 80 00       	mov    %eax,0x80831c
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802847:	a1 24 83 80 00       	mov    0x808324,%eax
  80284c:	40                   	inc    %eax
  80284d:	a3 24 83 80 00       	mov    %eax,0x808324
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802852:	b8 00 10 00 00       	mov    $0x1000,%eax
  802857:	2b 45 08             	sub    0x8(%ebp),%eax
  80285a:	83 f8 0f             	cmp    $0xf,%eax
  80285d:	0f 86 95 00 00 00    	jbe    8028f8 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  80286e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802873:	2b 45 08             	sub    0x8(%ebp),%eax
  802876:	89 c2                	mov    %eax,%edx
  802878:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80287b:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  80287d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802880:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802884:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802888:	74 06                	je     802890 <alloc_block_FF+0x296>
  80288a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80288e:	75 17                	jne    8028a7 <alloc_block_FF+0x2ad>
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	68 d8 3e 80 00       	push   $0x803ed8
  802898:	68 a6 00 00 00       	push   $0xa6
  80289d:	68 bf 3e 80 00       	push   $0x803ebf
  8028a2:	e8 e7 de ff ff       	call   80078e <_panic>
  8028a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028aa:	8b 50 08             	mov    0x8(%eax),%edx
  8028ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028b0:	89 50 08             	mov    %edx,0x8(%eax)
  8028b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028b6:	8b 40 08             	mov    0x8(%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 0c                	je     8028c9 <alloc_block_FF+0x2cf>
  8028bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c0:	8b 40 08             	mov    0x8(%eax),%eax
  8028c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028c6:	89 50 0c             	mov    %edx,0xc(%eax)
  8028c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028cf:	89 50 08             	mov    %edx,0x8(%eax)
  8028d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028d8:	89 50 0c             	mov    %edx,0xc(%eax)
  8028db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028de:	8b 40 08             	mov    0x8(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	75 08                	jne    8028ed <alloc_block_FF+0x2f3>
  8028e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028e8:	a3 1c 83 80 00       	mov    %eax,0x80831c
  8028ed:	a1 24 83 80 00       	mov    0x808324,%eax
  8028f2:	40                   	inc    %eax
  8028f3:	a3 24 83 80 00       	mov    %eax,0x808324
			 }
			 return (sb + 1);
  8028f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fb:	83 c0 10             	add    $0x10,%eax
  8028fe:	eb 0c                	jmp    80290c <alloc_block_FF+0x312>
		 }
		 return NULL;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
  802905:	eb 05                	jmp    80290c <alloc_block_FF+0x312>
	 }
	 return NULL;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802914:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802918:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  80291f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802926:	a1 18 83 80 00       	mov    0x808318,%eax
  80292b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80292e:	eb 34                	jmp    802964 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	8a 40 04             	mov    0x4(%eax),%al
  802936:	84 c0                	test   %al,%al
  802938:	74 22                	je     80295c <alloc_block_BF+0x4e>
  80293a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802942:	72 18                	jb     80295c <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80294c:	73 0e                	jae    80295c <alloc_block_BF+0x4e>
                bestFitBlock = current;
  80294e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802951:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  80295c:	a1 20 83 80 00       	mov    0x808320,%eax
  802961:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802964:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802968:	74 08                	je     802972 <alloc_block_BF+0x64>
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	8b 40 08             	mov    0x8(%eax),%eax
  802970:	eb 05                	jmp    802977 <alloc_block_BF+0x69>
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	a3 20 83 80 00       	mov    %eax,0x808320
  80297c:	a1 20 83 80 00       	mov    0x808320,%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	75 ab                	jne    802930 <alloc_block_BF+0x22>
  802985:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802989:	75 a5                	jne    802930 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	0f 84 cb 00 00 00    	je     802a60 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a4:	0f 86 ae 00 00 00    	jbe    802a58 <alloc_block_BF+0x14a>
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b2:	83 f8 0f             	cmp    $0xf,%eax
  8029b5:	0f 86 9d 00 00 00    	jbe    802a58 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8029bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	01 d0                	add    %edx,%eax
  8029c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  8029d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e2:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  8029e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e8:	74 06                	je     8029f0 <alloc_block_BF+0xe2>
  8029ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ee:	75 17                	jne    802a07 <alloc_block_BF+0xf9>
  8029f0:	83 ec 04             	sub    $0x4,%esp
  8029f3:	68 d8 3e 80 00       	push   $0x803ed8
  8029f8:	68 c6 00 00 00       	push   $0xc6
  8029fd:	68 bf 3e 80 00       	push   $0x803ebf
  802a02:	e8 87 dd ff ff       	call   80078e <_panic>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 50 08             	mov    0x8(%eax),%edx
  802a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a10:	89 50 08             	mov    %edx,0x8(%eax)
  802a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0c                	je     802a29 <alloc_block_BF+0x11b>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 08             	mov    0x8(%eax),%eax
  802a23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a26:	89 50 0c             	mov    %edx,0xc(%eax)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2f:	89 50 08             	mov    %edx,0x8(%eax)
  802a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	89 50 0c             	mov    %edx,0xc(%eax)
  802a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3e:	8b 40 08             	mov    0x8(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 08                	jne    802a4d <alloc_block_BF+0x13f>
  802a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a48:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802a4d:	a1 24 83 80 00       	mov    0x808324,%eax
  802a52:	40                   	inc    %eax
  802a53:	a3 24 83 80 00       	mov    %eax,0x808324
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	83 c0 10             	add    $0x10,%eax
  802a5e:	eb 05                	jmp    802a65 <alloc_block_BF+0x157>
    }

    return NULL;
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
  802a6a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 30 3f 80 00       	push   $0x803f30
  802a75:	68 d2 00 00 00       	push   $0xd2
  802a7a:	68 bf 3e 80 00       	push   $0x803ebf
  802a7f:	e8 0a dd ff ff       	call   80078e <_panic>

00802a84 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	68 58 3f 80 00       	push   $0x803f58
  802a92:	68 db 00 00 00       	push   $0xdb
  802a97:	68 bf 3e 80 00       	push   $0x803ebf
  802a9c:	e8 ed dc ff ff       	call   80078e <_panic>

00802aa1 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
  802aa4:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802aa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aab:	0f 84 d2 01 00 00    	je     802c83 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	83 e8 10             	sub    $0x10,%eax
  802ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8a 40 04             	mov    0x4(%eax),%al
  802ac0:	84 c0                	test   %al,%al
  802ac2:	0f 85 be 01 00 00    	jne    802c86 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	0f 84 cc 00 00 00    	je     802ba9 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	8a 40 04             	mov    0x4(%eax),%al
  802ae6:	84 c0                	test   %al,%al
  802ae8:	0f 84 bb 00 00 00    	je     802ba9 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 10                	mov    (%eax),%edx
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	01 c2                	add    %eax,%edx
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 40 08             	mov    0x8(%eax),%eax
  802b08:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 08             	mov    0x8(%eax),%eax
  802b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b25:	75 17                	jne    802b3e <free_block+0x9d>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 7e 3f 80 00       	push   $0x803f7e
  802b2f:	68 f8 00 00 00       	push   $0xf8
  802b34:	68 bf 3e 80 00       	push   $0x803ebf
  802b39:	e8 50 dc ff ff       	call   80078e <_panic>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 11                	je     802b59 <free_block+0xb8>
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b51:	8b 52 0c             	mov    0xc(%edx),%edx
  802b54:	89 50 0c             	mov    %edx,0xc(%eax)
  802b57:	eb 0b                	jmp    802b64 <free_block+0xc3>
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5f:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	74 11                	je     802b7f <free_block+0xde>
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b77:	8b 52 08             	mov    0x8(%edx),%edx
  802b7a:	89 50 08             	mov    %edx,0x8(%eax)
  802b7d:	eb 0b                	jmp    802b8a <free_block+0xe9>
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	a3 18 83 80 00       	mov    %eax,0x808318
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b9e:	a1 24 83 80 00       	mov    0x808324,%eax
  802ba3:	48                   	dec    %eax
  802ba4:	a3 24 83 80 00       	mov    %eax,0x808324
				}
			}
			if( LIST_PREV(block))
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	0f 84 d0 00 00 00    	je     802c87 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbd:	8a 40 04             	mov    0x4(%eax),%al
  802bc0:	84 c0                	test   %al,%al
  802bc2:	0f 84 bf 00 00 00    	je     802c87 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd1:	8b 52 0c             	mov    0xc(%edx),%edx
  802bd4:	8b 0a                	mov    (%edx),%ecx
  802bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd9:	8b 12                	mov    (%edx),%edx
  802bdb:	01 ca                	add    %ecx,%edx
  802bdd:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 0c             	mov    0xc(%eax),%eax
  802be5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfd:	75 17                	jne    802c16 <free_block+0x175>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 7e 3f 80 00       	push   $0x803f7e
  802c07:	68 03 01 00 00       	push   $0x103
  802c0c:	68 bf 3e 80 00       	push   $0x803ebf
  802c11:	e8 78 db ff ff       	call   80078e <_panic>
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 11                	je     802c31 <free_block+0x190>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 08             	mov    0x8(%eax),%eax
  802c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c29:	8b 52 0c             	mov    0xc(%edx),%edx
  802c2c:	89 50 0c             	mov    %edx,0xc(%eax)
  802c2f:	eb 0b                	jmp    802c3c <free_block+0x19b>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 11                	je     802c57 <free_block+0x1b6>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4f:	8b 52 08             	mov    0x8(%edx),%edx
  802c52:	89 50 08             	mov    %edx,0x8(%eax)
  802c55:	eb 0b                	jmp    802c62 <free_block+0x1c1>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	a3 18 83 80 00       	mov    %eax,0x808318
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802c76:	a1 24 83 80 00       	mov    0x808324,%eax
  802c7b:	48                   	dec    %eax
  802c7c:	a3 24 83 80 00       	mov    %eax,0x808324
  802c81:	eb 04                	jmp    802c87 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802c83:	90                   	nop
  802c84:	eb 01                	jmp    802c87 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802c86:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802c87:	c9                   	leave  
  802c88:	c3                   	ret    

00802c89 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802c89:	55                   	push   %ebp
  802c8a:	89 e5                	mov    %esp,%ebp
  802c8c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c93:	75 10                	jne    802ca5 <realloc_block_FF+0x1c>
  802c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c99:	75 0a                	jne    802ca5 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	e9 2e 03 00 00       	jmp    802fd3 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802ca5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca9:	75 13                	jne    802cbe <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802cab:	83 ec 0c             	sub    $0xc,%esp
  802cae:	ff 75 0c             	pushl  0xc(%ebp)
  802cb1:	e8 44 f9 ff ff       	call   8025fa <alloc_block_FF>
  802cb6:	83 c4 10             	add    $0x10,%esp
  802cb9:	e9 15 03 00 00       	jmp    802fd3 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  802cbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc2:	75 18                	jne    802cdc <realloc_block_FF+0x53>
	 {
		 free_block(va);
  802cc4:	83 ec 0c             	sub    $0xc,%esp
  802cc7:	ff 75 08             	pushl  0x8(%ebp)
  802cca:	e8 d2 fd ff ff       	call   802aa1 <free_block>
  802ccf:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  802cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd7:	e9 f7 02 00 00       	jmp    802fd3 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	83 e8 10             	sub    $0x10,%eax
  802ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  802ce5:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cf1:	0f 82 c8 00 00 00    	jb     802dbf <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cff:	75 08                	jne    802d09 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	e9 ca 02 00 00       	jmp    802fd3 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	2b 45 0c             	sub    0xc(%ebp),%eax
  802d11:	83 f8 0f             	cmp    $0xf,%eax
  802d14:	0f 86 9d 00 00 00    	jbe    802db7 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	2b 45 0c             	sub    0xc(%ebp),%eax
  802d2d:	89 c2                	mov    %eax,%edx
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3a:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  802d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d47:	74 06                	je     802d4f <realloc_block_FF+0xc6>
  802d49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4d:	75 17                	jne    802d66 <realloc_block_FF+0xdd>
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	68 d8 3e 80 00       	push   $0x803ed8
  802d57:	68 2a 01 00 00       	push   $0x12a
  802d5c:	68 bf 3e 80 00       	push   $0x803ebf
  802d61:	e8 28 da ff ff       	call   80078e <_panic>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	89 50 08             	mov    %edx,0x8(%eax)
  802d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	74 0c                	je     802d88 <realloc_block_FF+0xff>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 08             	mov    0x8(%eax),%eax
  802d82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d85:	89 50 0c             	mov    %edx,0xc(%eax)
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8e:	89 50 08             	mov    %edx,0x8(%eax)
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d97:	89 50 0c             	mov    %edx,0xc(%eax)
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 40 08             	mov    0x8(%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	75 08                	jne    802dac <realloc_block_FF+0x123>
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802dac:	a1 24 83 80 00       	mov    0x808324,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 24 83 80 00       	mov    %eax,0x808324
	    	 }
	    	 return va;
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	e9 14 02 00 00       	jmp    802fd3 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 08             	mov    0x8(%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	0f 84 97 01 00 00    	je     802f64 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	8a 40 04             	mov    0x4(%eax),%al
  802dd6:	84 c0                	test   %al,%al
  802dd8:	0f 84 86 01 00 00    	je     802f64 <realloc_block_FF+0x2db>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 10                	mov    (%eax),%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 40 08             	mov    0x8(%eax),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	01 d0                	add    %edx,%eax
  802ded:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802df0:	0f 82 6e 01 00 00    	jb     802f64 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 10                	mov    (%eax),%edx
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	01 c2                	add    %eax,%edx
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  802e29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e2d:	75 17                	jne    802e46 <realloc_block_FF+0x1bd>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 7e 3f 80 00       	push   $0x803f7e
  802e37:	68 38 01 00 00       	push   $0x138
  802e3c:	68 bf 3e 80 00       	push   $0x803ebf
  802e41:	e8 48 d9 ff ff       	call   80078e <_panic>
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 11                	je     802e61 <realloc_block_FF+0x1d8>
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e59:	8b 52 0c             	mov    0xc(%edx),%edx
  802e5c:	89 50 0c             	mov    %edx,0xc(%eax)
  802e5f:	eb 0b                	jmp    802e6c <realloc_block_FF+0x1e3>
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	8b 40 0c             	mov    0xc(%eax),%eax
  802e67:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 11                	je     802e87 <realloc_block_FF+0x1fe>
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e7f:	8b 52 08             	mov    0x8(%edx),%edx
  802e82:	89 50 08             	mov    %edx,0x8(%eax)
  802e85:	eb 0b                	jmp    802e92 <realloc_block_FF+0x209>
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	a3 18 83 80 00       	mov    %eax,0x808318
  802e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ea6:	a1 24 83 80 00       	mov    0x808324,%eax
  802eab:	48                   	dec    %eax
  802eac:	a3 24 83 80 00       	mov    %eax,0x808324
					 if(block->size - new_size >= sizeOfMetaData())
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	2b 45 0c             	sub    0xc(%ebp),%eax
  802eb9:	83 f8 0f             	cmp    $0xf,%eax
  802ebc:	0f 86 9d 00 00 00    	jbe    802f5f <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec8:	01 d0                	add    %edx,%eax
  802eca:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	2b 45 0c             	sub    0xc(%ebp),%eax
  802ed5:	89 c2                	mov    %eax,%edx
  802ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eda:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee2:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  802ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee7:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  802eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eef:	74 06                	je     802ef7 <realloc_block_FF+0x26e>
  802ef1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef5:	75 17                	jne    802f0e <realloc_block_FF+0x285>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 d8 3e 80 00       	push   $0x803ed8
  802eff:	68 3f 01 00 00       	push   $0x13f
  802f04:	68 bf 3e 80 00       	push   $0x803ebf
  802f09:	e8 80 d8 ff ff       	call   80078e <_panic>
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	89 50 08             	mov    %edx,0x8(%eax)
  802f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	85 c0                	test   %eax,%eax
  802f22:	74 0c                	je     802f30 <realloc_block_FF+0x2a7>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 08             	mov    0x8(%eax),%eax
  802f2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2d:	89 50 0c             	mov    %edx,0xc(%eax)
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f36:	89 50 08             	mov    %edx,0x8(%eax)
  802f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3f:	89 50 0c             	mov    %edx,0xc(%eax)
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 40 08             	mov    0x8(%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	75 08                	jne    802f54 <realloc_block_FF+0x2cb>
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	a3 1c 83 80 00       	mov    %eax,0x80831c
  802f54:	a1 24 83 80 00       	mov    0x808324,%eax
  802f59:	40                   	inc    %eax
  802f5a:	a3 24 83 80 00       	mov    %eax,0x808324
					 }
					 return va;
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	eb 6f                	jmp    802fd3 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  802f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f67:	83 e8 10             	sub    $0x10,%eax
  802f6a:	83 ec 0c             	sub    $0xc,%esp
  802f6d:	50                   	push   %eax
  802f6e:	e8 87 f6 ff ff       	call   8025fa <alloc_block_FF>
  802f73:	83 c4 10             	add    $0x10,%esp
  802f76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  802f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f7d:	75 29                	jne    802fa8 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  802f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f82:	83 ec 0c             	sub    $0xc,%esp
  802f85:	50                   	push   %eax
  802f86:	e8 98 ea ff ff       	call   801a23 <sbrk>
  802f8b:	83 c4 10             	add    $0x10,%esp
  802f8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  802f91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f94:	83 f8 ff             	cmp    $0xffffffff,%eax
  802f97:	75 07                	jne    802fa0 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	eb 33                	jmp    802fd3 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  802fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa3:	83 c0 10             	add    $0x10,%eax
  802fa6:	eb 2b                	jmp    802fd3 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	83 ec 04             	sub    $0x4,%esp
  802fb0:	50                   	push   %eax
  802fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  802fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fb7:	e8 2f e3 ff ff       	call   8012eb <memcpy>
  802fbc:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  802fbf:	83 ec 0c             	sub    $0xc,%esp
  802fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc5:	e8 d7 fa ff ff       	call   802aa1 <free_block>
  802fca:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  802fcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd0:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    
  802fd5:	66 90                	xchg   %ax,%ax
  802fd7:	90                   	nop

00802fd8 <__udivdi3>:
  802fd8:	55                   	push   %ebp
  802fd9:	57                   	push   %edi
  802fda:	56                   	push   %esi
  802fdb:	53                   	push   %ebx
  802fdc:	83 ec 1c             	sub    $0x1c,%esp
  802fdf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fe3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fe7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802feb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fef:	89 ca                	mov    %ecx,%edx
  802ff1:	89 f8                	mov    %edi,%eax
  802ff3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ff7:	85 f6                	test   %esi,%esi
  802ff9:	75 2d                	jne    803028 <__udivdi3+0x50>
  802ffb:	39 cf                	cmp    %ecx,%edi
  802ffd:	77 65                	ja     803064 <__udivdi3+0x8c>
  802fff:	89 fd                	mov    %edi,%ebp
  803001:	85 ff                	test   %edi,%edi
  803003:	75 0b                	jne    803010 <__udivdi3+0x38>
  803005:	b8 01 00 00 00       	mov    $0x1,%eax
  80300a:	31 d2                	xor    %edx,%edx
  80300c:	f7 f7                	div    %edi
  80300e:	89 c5                	mov    %eax,%ebp
  803010:	31 d2                	xor    %edx,%edx
  803012:	89 c8                	mov    %ecx,%eax
  803014:	f7 f5                	div    %ebp
  803016:	89 c1                	mov    %eax,%ecx
  803018:	89 d8                	mov    %ebx,%eax
  80301a:	f7 f5                	div    %ebp
  80301c:	89 cf                	mov    %ecx,%edi
  80301e:	89 fa                	mov    %edi,%edx
  803020:	83 c4 1c             	add    $0x1c,%esp
  803023:	5b                   	pop    %ebx
  803024:	5e                   	pop    %esi
  803025:	5f                   	pop    %edi
  803026:	5d                   	pop    %ebp
  803027:	c3                   	ret    
  803028:	39 ce                	cmp    %ecx,%esi
  80302a:	77 28                	ja     803054 <__udivdi3+0x7c>
  80302c:	0f bd fe             	bsr    %esi,%edi
  80302f:	83 f7 1f             	xor    $0x1f,%edi
  803032:	75 40                	jne    803074 <__udivdi3+0x9c>
  803034:	39 ce                	cmp    %ecx,%esi
  803036:	72 0a                	jb     803042 <__udivdi3+0x6a>
  803038:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80303c:	0f 87 9e 00 00 00    	ja     8030e0 <__udivdi3+0x108>
  803042:	b8 01 00 00 00       	mov    $0x1,%eax
  803047:	89 fa                	mov    %edi,%edx
  803049:	83 c4 1c             	add    $0x1c,%esp
  80304c:	5b                   	pop    %ebx
  80304d:	5e                   	pop    %esi
  80304e:	5f                   	pop    %edi
  80304f:	5d                   	pop    %ebp
  803050:	c3                   	ret    
  803051:	8d 76 00             	lea    0x0(%esi),%esi
  803054:	31 ff                	xor    %edi,%edi
  803056:	31 c0                	xor    %eax,%eax
  803058:	89 fa                	mov    %edi,%edx
  80305a:	83 c4 1c             	add    $0x1c,%esp
  80305d:	5b                   	pop    %ebx
  80305e:	5e                   	pop    %esi
  80305f:	5f                   	pop    %edi
  803060:	5d                   	pop    %ebp
  803061:	c3                   	ret    
  803062:	66 90                	xchg   %ax,%ax
  803064:	89 d8                	mov    %ebx,%eax
  803066:	f7 f7                	div    %edi
  803068:	31 ff                	xor    %edi,%edi
  80306a:	89 fa                	mov    %edi,%edx
  80306c:	83 c4 1c             	add    $0x1c,%esp
  80306f:	5b                   	pop    %ebx
  803070:	5e                   	pop    %esi
  803071:	5f                   	pop    %edi
  803072:	5d                   	pop    %ebp
  803073:	c3                   	ret    
  803074:	bd 20 00 00 00       	mov    $0x20,%ebp
  803079:	89 eb                	mov    %ebp,%ebx
  80307b:	29 fb                	sub    %edi,%ebx
  80307d:	89 f9                	mov    %edi,%ecx
  80307f:	d3 e6                	shl    %cl,%esi
  803081:	89 c5                	mov    %eax,%ebp
  803083:	88 d9                	mov    %bl,%cl
  803085:	d3 ed                	shr    %cl,%ebp
  803087:	89 e9                	mov    %ebp,%ecx
  803089:	09 f1                	or     %esi,%ecx
  80308b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80308f:	89 f9                	mov    %edi,%ecx
  803091:	d3 e0                	shl    %cl,%eax
  803093:	89 c5                	mov    %eax,%ebp
  803095:	89 d6                	mov    %edx,%esi
  803097:	88 d9                	mov    %bl,%cl
  803099:	d3 ee                	shr    %cl,%esi
  80309b:	89 f9                	mov    %edi,%ecx
  80309d:	d3 e2                	shl    %cl,%edx
  80309f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a3:	88 d9                	mov    %bl,%cl
  8030a5:	d3 e8                	shr    %cl,%eax
  8030a7:	09 c2                	or     %eax,%edx
  8030a9:	89 d0                	mov    %edx,%eax
  8030ab:	89 f2                	mov    %esi,%edx
  8030ad:	f7 74 24 0c          	divl   0xc(%esp)
  8030b1:	89 d6                	mov    %edx,%esi
  8030b3:	89 c3                	mov    %eax,%ebx
  8030b5:	f7 e5                	mul    %ebp
  8030b7:	39 d6                	cmp    %edx,%esi
  8030b9:	72 19                	jb     8030d4 <__udivdi3+0xfc>
  8030bb:	74 0b                	je     8030c8 <__udivdi3+0xf0>
  8030bd:	89 d8                	mov    %ebx,%eax
  8030bf:	31 ff                	xor    %edi,%edi
  8030c1:	e9 58 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030c6:	66 90                	xchg   %ax,%ax
  8030c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8030cc:	89 f9                	mov    %edi,%ecx
  8030ce:	d3 e2                	shl    %cl,%edx
  8030d0:	39 c2                	cmp    %eax,%edx
  8030d2:	73 e9                	jae    8030bd <__udivdi3+0xe5>
  8030d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030d7:	31 ff                	xor    %edi,%edi
  8030d9:	e9 40 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030de:	66 90                	xchg   %ax,%ax
  8030e0:	31 c0                	xor    %eax,%eax
  8030e2:	e9 37 ff ff ff       	jmp    80301e <__udivdi3+0x46>
  8030e7:	90                   	nop

008030e8 <__umoddi3>:
  8030e8:	55                   	push   %ebp
  8030e9:	57                   	push   %edi
  8030ea:	56                   	push   %esi
  8030eb:	53                   	push   %ebx
  8030ec:	83 ec 1c             	sub    $0x1c,%esp
  8030ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803103:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803107:	89 f3                	mov    %esi,%ebx
  803109:	89 fa                	mov    %edi,%edx
  80310b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80310f:	89 34 24             	mov    %esi,(%esp)
  803112:	85 c0                	test   %eax,%eax
  803114:	75 1a                	jne    803130 <__umoddi3+0x48>
  803116:	39 f7                	cmp    %esi,%edi
  803118:	0f 86 a2 00 00 00    	jbe    8031c0 <__umoddi3+0xd8>
  80311e:	89 c8                	mov    %ecx,%eax
  803120:	89 f2                	mov    %esi,%edx
  803122:	f7 f7                	div    %edi
  803124:	89 d0                	mov    %edx,%eax
  803126:	31 d2                	xor    %edx,%edx
  803128:	83 c4 1c             	add    $0x1c,%esp
  80312b:	5b                   	pop    %ebx
  80312c:	5e                   	pop    %esi
  80312d:	5f                   	pop    %edi
  80312e:	5d                   	pop    %ebp
  80312f:	c3                   	ret    
  803130:	39 f0                	cmp    %esi,%eax
  803132:	0f 87 ac 00 00 00    	ja     8031e4 <__umoddi3+0xfc>
  803138:	0f bd e8             	bsr    %eax,%ebp
  80313b:	83 f5 1f             	xor    $0x1f,%ebp
  80313e:	0f 84 ac 00 00 00    	je     8031f0 <__umoddi3+0x108>
  803144:	bf 20 00 00 00       	mov    $0x20,%edi
  803149:	29 ef                	sub    %ebp,%edi
  80314b:	89 fe                	mov    %edi,%esi
  80314d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803151:	89 e9                	mov    %ebp,%ecx
  803153:	d3 e0                	shl    %cl,%eax
  803155:	89 d7                	mov    %edx,%edi
  803157:	89 f1                	mov    %esi,%ecx
  803159:	d3 ef                	shr    %cl,%edi
  80315b:	09 c7                	or     %eax,%edi
  80315d:	89 e9                	mov    %ebp,%ecx
  80315f:	d3 e2                	shl    %cl,%edx
  803161:	89 14 24             	mov    %edx,(%esp)
  803164:	89 d8                	mov    %ebx,%eax
  803166:	d3 e0                	shl    %cl,%eax
  803168:	89 c2                	mov    %eax,%edx
  80316a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80316e:	d3 e0                	shl    %cl,%eax
  803170:	89 44 24 04          	mov    %eax,0x4(%esp)
  803174:	8b 44 24 08          	mov    0x8(%esp),%eax
  803178:	89 f1                	mov    %esi,%ecx
  80317a:	d3 e8                	shr    %cl,%eax
  80317c:	09 d0                	or     %edx,%eax
  80317e:	d3 eb                	shr    %cl,%ebx
  803180:	89 da                	mov    %ebx,%edx
  803182:	f7 f7                	div    %edi
  803184:	89 d3                	mov    %edx,%ebx
  803186:	f7 24 24             	mull   (%esp)
  803189:	89 c6                	mov    %eax,%esi
  80318b:	89 d1                	mov    %edx,%ecx
  80318d:	39 d3                	cmp    %edx,%ebx
  80318f:	0f 82 87 00 00 00    	jb     80321c <__umoddi3+0x134>
  803195:	0f 84 91 00 00 00    	je     80322c <__umoddi3+0x144>
  80319b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80319f:	29 f2                	sub    %esi,%edx
  8031a1:	19 cb                	sbb    %ecx,%ebx
  8031a3:	89 d8                	mov    %ebx,%eax
  8031a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031a9:	d3 e0                	shl    %cl,%eax
  8031ab:	89 e9                	mov    %ebp,%ecx
  8031ad:	d3 ea                	shr    %cl,%edx
  8031af:	09 d0                	or     %edx,%eax
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 eb                	shr    %cl,%ebx
  8031b5:	89 da                	mov    %ebx,%edx
  8031b7:	83 c4 1c             	add    $0x1c,%esp
  8031ba:	5b                   	pop    %ebx
  8031bb:	5e                   	pop    %esi
  8031bc:	5f                   	pop    %edi
  8031bd:	5d                   	pop    %ebp
  8031be:	c3                   	ret    
  8031bf:	90                   	nop
  8031c0:	89 fd                	mov    %edi,%ebp
  8031c2:	85 ff                	test   %edi,%edi
  8031c4:	75 0b                	jne    8031d1 <__umoddi3+0xe9>
  8031c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031cb:	31 d2                	xor    %edx,%edx
  8031cd:	f7 f7                	div    %edi
  8031cf:	89 c5                	mov    %eax,%ebp
  8031d1:	89 f0                	mov    %esi,%eax
  8031d3:	31 d2                	xor    %edx,%edx
  8031d5:	f7 f5                	div    %ebp
  8031d7:	89 c8                	mov    %ecx,%eax
  8031d9:	f7 f5                	div    %ebp
  8031db:	89 d0                	mov    %edx,%eax
  8031dd:	e9 44 ff ff ff       	jmp    803126 <__umoddi3+0x3e>
  8031e2:	66 90                	xchg   %ax,%ax
  8031e4:	89 c8                	mov    %ecx,%eax
  8031e6:	89 f2                	mov    %esi,%edx
  8031e8:	83 c4 1c             	add    $0x1c,%esp
  8031eb:	5b                   	pop    %ebx
  8031ec:	5e                   	pop    %esi
  8031ed:	5f                   	pop    %edi
  8031ee:	5d                   	pop    %ebp
  8031ef:	c3                   	ret    
  8031f0:	3b 04 24             	cmp    (%esp),%eax
  8031f3:	72 06                	jb     8031fb <__umoddi3+0x113>
  8031f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031f9:	77 0f                	ja     80320a <__umoddi3+0x122>
  8031fb:	89 f2                	mov    %esi,%edx
  8031fd:	29 f9                	sub    %edi,%ecx
  8031ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803203:	89 14 24             	mov    %edx,(%esp)
  803206:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80320e:	8b 14 24             	mov    (%esp),%edx
  803211:	83 c4 1c             	add    $0x1c,%esp
  803214:	5b                   	pop    %ebx
  803215:	5e                   	pop    %esi
  803216:	5f                   	pop    %edi
  803217:	5d                   	pop    %ebp
  803218:	c3                   	ret    
  803219:	8d 76 00             	lea    0x0(%esi),%esi
  80321c:	2b 04 24             	sub    (%esp),%eax
  80321f:	19 fa                	sbb    %edi,%edx
  803221:	89 d1                	mov    %edx,%ecx
  803223:	89 c6                	mov    %eax,%esi
  803225:	e9 71 ff ff ff       	jmp    80319b <__umoddi3+0xb3>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803230:	72 ea                	jb     80321c <__umoddi3+0x134>
  803232:	89 d9                	mov    %ebx,%ecx
  803234:	e9 62 ff ff ff       	jmp    80319b <__umoddi3+0xb3>
