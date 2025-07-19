
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 58 12 00 00       	call   80128e <libmain>
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
  80003d:	81 ec a0 01 00 00    	sub    $0x1a0,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
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
  800060:	68 40 3f 80 00       	push   $0x803f40
  800065:	6a 1a                	push   $0x1a
  800067:	68 5c 3f 80 00       	push   $0x803f5c
  80006c:	e8 54 13 00 00       	call   8013c5 <_panic>
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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;

	int start_freeFrames = sys_calculate_free_frames() ;
  8000a8:	e8 b3 29 00 00       	call   802a60 <sys_calculate_free_frames>
  8000ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000b0:	8d 95 c8 fe ff ff    	lea    -0x138(%ebp),%edx
  8000b6:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c0:	89 d7                	mov    %edx,%edi
  8000c2:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ALL
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000c4:	e8 97 29 00 00       	call   802a60 <sys_calculate_free_frames>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000cc:	e8 da 29 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8000d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d7:	01 c0                	add    %eax,%eax
  8000d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	50                   	push   %eax
  8000e0:	e8 8b 25 00 00       	call   802670 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000ee:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8000f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f7:	74 14                	je     80010d <_main+0xd5>
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 70 3f 80 00       	push   $0x803f70
  800101:	6a 3d                	push   $0x3d
  800103:	68 5c 3f 80 00       	push   $0x803f5c
  800108:	e8 b8 12 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80010d:	e8 99 29 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800112:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800115:	74 14                	je     80012b <_main+0xf3>
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 a0 3f 80 00       	push   $0x803fa0
  80011f:	6a 3e                	push   $0x3e
  800121:	68 5c 3f 80 00       	push   $0x803f5c
  800126:	e8 9a 12 00 00       	call   8013c5 <_panic>


			freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 30 29 00 00       	call   802a60 <sys_calculate_free_frames>
  800130:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800136:	01 c0                	add    %eax,%eax
  800138:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80013b:	48                   	dec    %eax
  80013c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr = (char *) ptr_allocations[0];
  80013f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800145:	89 45 c8             	mov    %eax,-0x38(%ebp)
			byteArr[0] = minByte ;
  800148:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80014b:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80014e:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800150:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800153:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800156:	01 c2                	add    %eax,%edx
  800158:	8a 45 ea             	mov    -0x16(%ebp),%al
  80015b:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  80015d:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800164:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800167:	e8 f4 28 00 00       	call   802a60 <sys_calculate_free_frames>
  80016c:	29 c3                	sub    %eax,%ebx
  80016e:	89 d8                	mov    %ebx,%eax
  800170:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800173:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800176:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800179:	7d 1a                	jge    800195 <_main+0x15d>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	ff 75 c0             	pushl  -0x40(%ebp)
  800181:	ff 75 c4             	pushl  -0x3c(%ebp)
  800184:	68 d0 3f 80 00       	push   $0x803fd0
  800189:	6a 49                	push   $0x49
  80018b:	68 5c 3f 80 00       	push   $0x803f5c
  800190:	e8 30 12 00 00       	call   8013c5 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800195:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800198:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80019b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a3:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  8001a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8001ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bc:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001c2:	6a 02                	push   $0x2
  8001c4:	6a 00                	push   $0x0
  8001c6:	6a 02                	push   $0x2
  8001c8:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8001ce:	50                   	push   %eax
  8001cf:	e8 a9 2d 00 00       	call   802f7d <sys_check_WS_list>
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001da:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8001de:	74 14                	je     8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 4c 40 80 00       	push   $0x80404c
  8001e8:	6a 4d                	push   $0x4d
  8001ea:	68 5c 3f 80 00       	push   $0x803f5c
  8001ef:	e8 d1 11 00 00       	call   8013c5 <_panic>
		}

		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001f4:	e8 67 28 00 00       	call   802a60 <sys_calculate_free_frames>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001fc:	e8 aa 28 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  800204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 5b 24 00 00       	call   802670 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800224:	89 c2                	mov    %eax,%edx
  800226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800229:	01 c0                	add    %eax,%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	01 c8                	add    %ecx,%eax
  800232:	39 c2                	cmp    %eax,%edx
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 70 3f 80 00       	push   $0x803f70
  80023e:	6a 55                	push   $0x55
  800240:	68 5c 3f 80 00       	push   $0x803f5c
  800245:	e8 7b 11 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80024a:	e8 5c 28 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80024f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800252:	74 14                	je     800268 <_main+0x230>
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 a0 3f 80 00       	push   $0x803fa0
  80025c:	6a 56                	push   $0x56
  80025e:	68 5c 3f 80 00       	push   $0x803f5c
  800263:	e8 5d 11 00 00       	call   8013c5 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800268:	e8 f3 27 00 00       	call   802a60 <sys_calculate_free_frames>
  80026d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr = (short *) ptr_allocations[1];
  800270:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800276:	89 45 b0             	mov    %eax,-0x50(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	01 c0                	add    %eax,%eax
  80027e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800281:	d1 e8                	shr    %eax
  800283:	48                   	dec    %eax
  800284:	89 45 ac             	mov    %eax,-0x54(%ebp)
			shortArr[0] = minShort;
  800287:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  800290:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800293:	01 c0                	add    %eax,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80029a:	01 c2                	add    %eax,%edx
  80029c:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8002a0:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/;
  8002a3:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8002aa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ad:	e8 ae 27 00 00       	call   802a60 <sys_calculate_free_frames>
  8002b2:	29 c3                	sub    %eax,%ebx
  8002b4:	89 d8                	mov    %ebx,%eax
  8002b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  8002b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002bc:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002bf:	7d 1a                	jge    8002db <_main+0x2a3>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002ca:	68 d0 3f 80 00       	push   $0x803fd0
  8002cf:	6a 60                	push   $0x60
  8002d1:	68 5c 3f 80 00       	push   $0x803f5c
  8002d6:	e8 ea 10 00 00       	call   8013c5 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8002db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002de:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8002e1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002e9:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  8002ef:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002f2:	01 c0                	add    %eax,%eax
  8002f4:	89 c2                	mov    %eax,%edx
  8002f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8002fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800301:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800306:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80030c:	6a 02                	push   $0x2
  80030e:	6a 00                	push   $0x0
  800310:	6a 02                	push   $0x2
  800312:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800318:	50                   	push   %eax
  800319:	e8 5f 2c 00 00       	call   802f7d <sys_check_WS_list>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800324:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800328:	74 14                	je     80033e <_main+0x306>
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 4c 40 80 00       	push   $0x80404c
  800332:	6a 63                	push   $0x63
  800334:	68 5c 3f 80 00       	push   $0x803f5c
  800339:	e8 87 10 00 00       	call   8013c5 <_panic>
		}
		//cprintf("5\n");

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80033e:	e8 1d 27 00 00       	call   802a60 <sys_calculate_free_frames>
  800343:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800346:	e8 60 27 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80034b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80034e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800351:	89 c2                	mov    %eax,%edx
  800353:	01 d2                	add    %edx,%edx
  800355:	01 d0                	add    %edx,%eax
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	50                   	push   %eax
  80035b:	e8 10 23 00 00       	call   802670 <malloc>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800369:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80036f:	89 c2                	mov    %eax,%edx
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	c1 e0 02             	shl    $0x2,%eax
  800377:	89 c1                	mov    %eax,%ecx
  800379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	39 c2                	cmp    %eax,%edx
  800380:	74 14                	je     800396 <_main+0x35e>
  800382:	83 ec 04             	sub    $0x4,%esp
  800385:	68 70 3f 80 00       	push   $0x803f70
  80038a:	6a 6c                	push   $0x6c
  80038c:	68 5c 3f 80 00       	push   $0x803f5c
  800391:	e8 2f 10 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800396:	e8 10 27 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80039b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80039e:	74 14                	je     8003b4 <_main+0x37c>
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 a0 3f 80 00       	push   $0x803fa0
  8003a8:	6a 6d                	push   $0x6d
  8003aa:	68 5c 3f 80 00       	push   $0x803f5c
  8003af:	e8 11 10 00 00       	call   8013c5 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8003b4:	e8 a7 26 00 00       	call   802a60 <sys_calculate_free_frames>
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			intArr = (int *) ptr_allocations[2];
  8003bc:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8003c2:	89 45 a0             	mov    %eax,-0x60(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8003c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	c1 e8 02             	shr    $0x2,%eax
  8003cd:	48                   	dec    %eax
  8003ce:	89 45 9c             	mov    %eax,-0x64(%ebp)
			intArr[0] = minInt;
  8003d1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d7:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  8003d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  8003ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003f4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003f7:	e8 64 26 00 00       	call   802a60 <sys_calculate_free_frames>
  8003fc:	29 c3                	sub    %eax,%ebx
  8003fe:	89 d8                	mov    %ebx,%eax
  800400:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800403:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800406:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800409:	7d 1a                	jge    800425 <_main+0x3ed>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	ff 75 c0             	pushl  -0x40(%ebp)
  800411:	ff 75 c4             	pushl  -0x3c(%ebp)
  800414:	68 d0 3f 80 00       	push   $0x803fd0
  800419:	6a 77                	push   $0x77
  80041b:	68 5c 3f 80 00       	push   $0x803f5c
  800420:	e8 a0 0f 00 00       	call   8013c5 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800425:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800428:	89 45 98             	mov    %eax,-0x68(%ebp)
  80042b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80042e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800433:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
  800439:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80043c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800443:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80044b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80044e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800453:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800459:	6a 02                	push   $0x2
  80045b:	6a 00                	push   $0x0
  80045d:	6a 02                	push   $0x2
  80045f:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	e8 12 2b 00 00       	call   802f7d <sys_check_WS_list>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800471:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800475:	74 14                	je     80048b <_main+0x453>
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	68 4c 40 80 00       	push   $0x80404c
  80047f:	6a 7a                	push   $0x7a
  800481:	68 5c 3f 80 00       	push   $0x803f5c
  800486:	e8 3a 0f 00 00       	call   8013c5 <_panic>
		}

		//3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80048b:	e8 d0 25 00 00       	call   802a60 <sys_calculate_free_frames>
  800490:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800493:	e8 13 26 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  80049b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	01 d2                	add    %edx,%edx
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	50                   	push   %eax
  8004a8:	e8 c3 21 00 00       	call   802670 <malloc>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  8004b6:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c1:	c1 e0 02             	shl    $0x2,%eax
  8004c4:	89 c1                	mov    %eax,%ecx
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	c1 e0 02             	shl    $0x2,%eax
  8004cc:	01 c1                	add    %eax,%ecx
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d1:	01 c8                	add    %ecx,%eax
  8004d3:	39 c2                	cmp    %eax,%edx
  8004d5:	74 17                	je     8004ee <_main+0x4b6>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 70 3f 80 00       	push   $0x803f70
  8004df:	68 82 00 00 00       	push   $0x82
  8004e4:	68 5c 3f 80 00       	push   $0x803f5c
  8004e9:	e8 d7 0e 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ee:	e8 b8 25 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8004f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004f6:	74 17                	je     80050f <_main+0x4d7>
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	68 a0 3f 80 00       	push   $0x803fa0
  800500:	68 83 00 00 00       	push   $0x83
  800505:	68 5c 3f 80 00       	push   $0x803f5c
  80050a:	e8 b6 0e 00 00       	call   8013c5 <_panic>
		}

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80050f:	e8 4c 25 00 00       	call   802a60 <sys_calculate_free_frames>
  800514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800517:	e8 8f 25 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80051c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  80051f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800522:	89 d0                	mov    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	01 c0                	add    %eax,%eax
  80052a:	01 d0                	add    %edx,%eax
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	50                   	push   %eax
  800530:	e8 3b 21 00 00       	call   802670 <malloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  80053e:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800544:	89 c2                	mov    %eax,%edx
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	c1 e0 02             	shl    $0x2,%eax
  80054c:	89 c1                	mov    %eax,%ecx
  80054e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800551:	c1 e0 03             	shl    $0x3,%eax
  800554:	01 c1                	add    %eax,%ecx
  800556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800559:	01 c8                	add    %ecx,%eax
  80055b:	39 c2                	cmp    %eax,%edx
  80055d:	74 17                	je     800576 <_main+0x53e>
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	68 70 3f 80 00       	push   $0x803f70
  800567:	68 8b 00 00 00       	push   $0x8b
  80056c:	68 5c 3f 80 00       	push   $0x803f5c
  800571:	e8 4f 0e 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800576:	e8 30 25 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80057b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 a0 3f 80 00       	push   $0x803fa0
  800588:	68 8c 00 00 00       	push   $0x8c
  80058d:	68 5c 3f 80 00       	push   $0x803f5c
  800592:	e8 2e 0e 00 00       	call   8013c5 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800597:	e8 c4 24 00 00       	call   802a60 <sys_calculate_free_frames>
  80059c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80059f:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8005a5:	89 45 90             	mov    %eax,-0x70(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8005a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005ab:	89 d0                	mov    %edx,%eax
  8005ad:	01 c0                	add    %eax,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	01 c0                	add    %eax,%eax
  8005b3:	01 d0                	add    %edx,%eax
  8005b5:	c1 e8 03             	shr    $0x3,%eax
  8005b8:	48                   	dec    %eax
  8005b9:	89 45 8c             	mov    %eax,-0x74(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8005bc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bf:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8005c2:	88 10                	mov    %dl,(%eax)
  8005c4:	8b 55 90             	mov    -0x70(%ebp),%edx
  8005c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ca:	66 89 42 02          	mov    %ax,0x2(%edx)
  8005ce:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d4:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8005d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005e4:	01 c2                	add    %eax,%edx
  8005e6:	8a 45 ea             	mov    -0x16(%ebp),%al
  8005e9:	88 02                	mov    %al,(%edx)
  8005eb:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005f8:	01 c2                	add    %eax,%edx
  8005fa:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8005fe:	66 89 42 02          	mov    %ax,0x2(%edx)
  800602:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800605:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80060f:	01 c2                	add    %eax,%edx
  800611:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800614:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800617:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80061e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800621:	e8 3a 24 00 00       	call   802a60 <sys_calculate_free_frames>
  800626:	29 c3                	sub    %eax,%ebx
  800628:	89 d8                	mov    %ebx,%eax
  80062a:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80062d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800630:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800633:	7d 1d                	jge    800652 <_main+0x61a>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	ff 75 c0             	pushl  -0x40(%ebp)
  80063b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80063e:	68 d0 3f 80 00       	push   $0x803fd0
  800643:	68 96 00 00 00       	push   $0x96
  800648:	68 5c 3f 80 00       	push   $0x803f5c
  80064d:	e8 73 0d 00 00       	call   8013c5 <_panic>
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800652:	8b 45 90             	mov    -0x70(%ebp),%eax
  800655:	89 45 88             	mov    %eax,-0x78(%ebp)
  800658:	8b 45 88             	mov    -0x78(%ebp),%eax
  80065b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800660:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
  800666:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800669:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800670:	8b 45 90             	mov    -0x70(%ebp),%eax
  800673:	01 d0                	add    %edx,%eax
  800675:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800678:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80067b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800680:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800686:	6a 02                	push   $0x2
  800688:	6a 00                	push   $0x0
  80068a:	6a 02                	push   $0x2
  80068c:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800692:	50                   	push   %eax
  800693:	e8 e5 28 00 00       	call   802f7d <sys_check_WS_list>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  80069e:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8006a2:	74 17                	je     8006bb <_main+0x683>
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 4c 40 80 00       	push   $0x80404c
  8006ac:	68 99 00 00 00       	push   $0x99
  8006b1:	68 5c 3f 80 00       	push   $0x803f5c
  8006b6:	e8 0a 0d 00 00       	call   8013c5 <_panic>
		}

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006bb:	e8 a0 23 00 00       	call   802a60 <sys_calculate_free_frames>
  8006c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006c3:	e8 e3 23 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8006cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	01 d2                	add    %edx,%edx
  8006d2:	01 d0                	add    %edx,%eax
  8006d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	50                   	push   %eax
  8006db:	e8 90 1f 00 00       	call   802670 <malloc>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006e9:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8006ef:	89 c2                	mov    %eax,%edx
  8006f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f4:	c1 e0 02             	shl    $0x2,%eax
  8006f7:	89 c1                	mov    %eax,%ecx
  8006f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fc:	c1 e0 04             	shl    $0x4,%eax
  8006ff:	01 c1                	add    %eax,%ecx
  800701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800704:	01 c8                	add    %ecx,%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 17                	je     800721 <_main+0x6e9>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 70 3f 80 00       	push   $0x803f70
  800712:	68 a1 00 00 00       	push   $0xa1
  800717:	68 5c 3f 80 00       	push   $0x803f5c
  80071c:	e8 a4 0c 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800721:	e8 85 23 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800726:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800729:	74 17                	je     800742 <_main+0x70a>
  80072b:	83 ec 04             	sub    $0x4,%esp
  80072e:	68 a0 3f 80 00       	push   $0x803fa0
  800733:	68 a2 00 00 00       	push   $0xa2
  800738:	68 5c 3f 80 00       	push   $0x803f5c
  80073d:	e8 83 0c 00 00       	call   8013c5 <_panic>
		}

		//6 MB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800742:	e8 64 23 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800747:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80074a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	01 c0                	add    %eax,%eax
  800751:	01 d0                	add    %edx,%eax
  800753:	01 c0                	add    %eax,%eax
  800755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800758:	83 ec 0c             	sub    $0xc,%esp
  80075b:	50                   	push   %eax
  80075c:	e8 0f 1f 00 00       	call   802670 <malloc>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80076a:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800770:	89 c1                	mov    %eax,%ecx
  800772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800775:	89 d0                	mov    %edx,%eax
  800777:	01 c0                	add    %eax,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	01 c0                	add    %eax,%eax
  80077d:	01 d0                	add    %edx,%eax
  80077f:	89 c2                	mov    %eax,%edx
  800781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800784:	c1 e0 04             	shl    $0x4,%eax
  800787:	01 c2                	add    %eax,%edx
  800789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80078c:	01 d0                	add    %edx,%eax
  80078e:	39 c1                	cmp    %eax,%ecx
  800790:	74 17                	je     8007a9 <_main+0x771>
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	68 70 3f 80 00       	push   $0x803f70
  80079a:	68 a9 00 00 00       	push   $0xa9
  80079f:	68 5c 3f 80 00       	push   $0x803f5c
  8007a4:	e8 1c 0c 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8007a9:	e8 fd 22 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8007ae:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007b1:	74 17                	je     8007ca <_main+0x792>
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	68 a0 3f 80 00       	push   $0x803fa0
  8007bb:	68 aa 00 00 00       	push   $0xaa
  8007c0:	68 5c 3f 80 00       	push   $0x803f5c
  8007c5:	e8 fb 0b 00 00       	call   8013c5 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8007ca:	e8 91 22 00 00       	call   802a60 <sys_calculate_free_frames>
  8007cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  8007d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007d5:	89 d0                	mov    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	01 c0                	add    %eax,%eax
  8007dd:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8007e0:	48                   	dec    %eax
  8007e1:	89 45 80             	mov    %eax,-0x80(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  8007e4:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8007ea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			byteArr2[0] = minByte ;
  8007f0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8007f6:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8007f9:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8007fb:	8b 45 80             	mov    -0x80(%ebp),%eax
  8007fe:	89 c2                	mov    %eax,%edx
  800800:	c1 ea 1f             	shr    $0x1f,%edx
  800803:	01 d0                	add    %edx,%eax
  800805:	d1 f8                	sar    %eax
  800807:	89 c2                	mov    %eax,%edx
  800809:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80080f:	01 c2                	add    %eax,%edx
  800811:	8a 45 ea             	mov    -0x16(%ebp),%al
  800814:	88 c1                	mov    %al,%cl
  800816:	c0 e9 07             	shr    $0x7,%cl
  800819:	01 c8                	add    %ecx,%eax
  80081b:	d0 f8                	sar    %al
  80081d:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  80081f:	8b 55 80             	mov    -0x80(%ebp),%edx
  800822:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800828:	01 c2                	add    %eax,%edx
  80082a:	8a 45 ea             	mov    -0x16(%ebp),%al
  80082d:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 /*+2 tables already created in malloc due to marking the allocated pages*/ ;
  80082f:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800836:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800839:	e8 22 22 00 00       	call   802a60 <sys_calculate_free_frames>
  80083e:	29 c3                	sub    %eax,%ebx
  800840:	89 d8                	mov    %ebx,%eax
  800842:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800845:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800848:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80084b:	7d 1d                	jge    80086a <_main+0x832>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	ff 75 c0             	pushl  -0x40(%ebp)
  800853:	ff 75 c4             	pushl  -0x3c(%ebp)
  800856:	68 d0 3f 80 00       	push   $0x803fd0
  80085b:	68 b5 00 00 00       	push   $0xb5
  800860:	68 5c 3f 80 00       	push   $0x803f5c
  800865:	e8 5b 0b 00 00       	call   8013c5 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800876:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800881:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800887:	8b 45 80             	mov    -0x80(%ebp),%eax
  80088a:	89 c2                	mov    %eax,%edx
  80088c:	c1 ea 1f             	shr    $0x1f,%edx
  80088f:	01 d0                	add    %edx,%eax
  800891:	d1 f8                	sar    %eax
  800893:	89 c2                	mov    %eax,%edx
  800895:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  8008a3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8008a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ae:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
  8008b4:	8b 55 80             	mov    -0x80(%ebp),%edx
  8008b7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8008c5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8008cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008d0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
			chk = sys_check_WS_list(expectedVAs, 3, 0, 2);
  8008d6:	6a 02                	push   $0x2
  8008d8:	6a 00                	push   $0x0
  8008da:	6a 03                	push   $0x3
  8008dc:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  8008e2:	50                   	push   %eax
  8008e3:	e8 95 26 00 00       	call   802f7d <sys_check_WS_list>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8008ee:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 4c 40 80 00       	push   $0x80404c
  8008fc:	68 b8 00 00 00       	push   $0xb8
  800901:	68 5c 3f 80 00       	push   $0x803f5c
  800906:	e8 ba 0a 00 00       	call   8013c5 <_panic>
		}

		//14 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80090b:	e8 9b 21 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800910:	89 45 d0             	mov    %eax,-0x30(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800913:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800916:	89 d0                	mov    %edx,%eax
  800918:	01 c0                	add    %eax,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	01 c0                	add    %eax,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 45 1d 00 00       	call   802670 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800934:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80093a:	89 c1                	mov    %eax,%ecx
  80093c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80093f:	89 d0                	mov    %edx,%eax
  800941:	01 c0                	add    %eax,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	c1 e0 02             	shl    $0x2,%eax
  800948:	01 d0                	add    %edx,%eax
  80094a:	89 c2                	mov    %eax,%edx
  80094c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094f:	c1 e0 04             	shl    $0x4,%eax
  800952:	01 c2                	add    %eax,%edx
  800954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800957:	01 d0                	add    %edx,%eax
  800959:	39 c1                	cmp    %eax,%ecx
  80095b:	74 17                	je     800974 <_main+0x93c>
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	68 70 3f 80 00       	push   $0x803f70
  800965:	68 bf 00 00 00       	push   $0xbf
  80096a:	68 5c 3f 80 00       	push   $0x803f5c
  80096f:	e8 51 0a 00 00       	call   8013c5 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800974:	e8 32 21 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800979:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80097c:	74 17                	je     800995 <_main+0x95d>
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	68 a0 3f 80 00       	push   $0x803fa0
  800986:	68 c0 00 00 00       	push   $0xc0
  80098b:	68 5c 3f 80 00       	push   $0x803f5c
  800990:	e8 30 0a 00 00       	call   8013c5 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800995:	e8 c6 20 00 00       	call   802a60 <sys_calculate_free_frames>
  80099a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  80099d:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8009a3:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8009a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009ac:	89 d0                	mov    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	01 c0                	add    %eax,%eax
  8009b4:	01 d0                	add    %edx,%eax
  8009b6:	01 c0                	add    %eax,%eax
  8009b8:	d1 e8                	shr    %eax
  8009ba:	48                   	dec    %eax
  8009bb:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
			shortArr2[0] = minShort;
  8009c1:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  8009c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ca:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  8009cd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009d3:	89 c2                	mov    %eax,%edx
  8009d5:	c1 ea 1f             	shr    $0x1f,%edx
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	d1 f8                	sar    %eax
  8009dc:	01 c0                	add    %eax,%eax
  8009de:	89 c2                	mov    %eax,%edx
  8009e0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8009e6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8009e9:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	66 c1 ea 0f          	shr    $0xf,%dx
  8009f3:	01 d0                	add    %edx,%eax
  8009f5:	66 d1 f8             	sar    %ax
  8009f8:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  8009fb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a01:	01 c0                	add    %eax,%eax
  800a03:	89 c2                	mov    %eax,%edx
  800a05:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a0b:	01 c2                	add    %eax,%edx
  800a0d:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
  800a11:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800a14:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800a1b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a1e:	e8 3d 20 00 00       	call   802a60 <sys_calculate_free_frames>
  800a23:	29 c3                	sub    %eax,%ebx
  800a25:	89 d8                	mov    %ebx,%eax
  800a27:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  800a2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a2d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a30:	7d 1d                	jge    800a4f <_main+0xa17>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800a32:	83 ec 0c             	sub    $0xc,%esp
  800a35:	ff 75 c0             	pushl  -0x40(%ebp)
  800a38:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3b:	68 d0 3f 80 00       	push   $0x803fd0
  800a40:	68 cb 00 00 00       	push   $0xcb
  800a45:	68 5c 3f 80 00       	push   $0x803f5c
  800a4a:	e8 76 09 00 00       	call   8013c5 <_panic>
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800a4f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a55:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800a5b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800a61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a66:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800a6c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800a72:	89 c2                	mov    %eax,%edx
  800a74:	c1 ea 1f             	shr    $0x1f,%edx
  800a77:	01 d0                	add    %edx,%eax
  800a79:	d1 f8                	sar    %eax
  800a7b:	01 c0                	add    %eax,%eax
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a85:	01 d0                	add    %edx,%eax
  800a87:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800a8d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a98:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800a9e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800aa4:	01 c0                	add    %eax,%eax
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800aae:	01 d0                	add    %edx,%eax
  800ab0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800ab6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800abc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac1:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			chk = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800ac7:	6a 02                	push   $0x2
  800ac9:	6a 00                	push   $0x0
  800acb:	6a 03                	push   $0x3
  800acd:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ad3:	50                   	push   %eax
  800ad4:	e8 a4 24 00 00       	call   802f7d <sys_check_WS_list>
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  800adf:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ae3:	74 17                	je     800afc <_main+0xac4>
  800ae5:	83 ec 04             	sub    $0x4,%esp
  800ae8:	68 4c 40 80 00       	push   $0x80404c
  800aed:	68 ce 00 00 00       	push   $0xce
  800af2:	68 5c 3f 80 00       	push   $0x803f5c
  800af7:	e8 c9 08 00 00       	call   8013c5 <_panic>
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800aff:	89 d0                	mov    %edx,%eax
  800b01:	01 c0                	add    %eax,%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	c1 e0 02             	shl    $0x2,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	89 c2                	mov    %eax,%edx
  800b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0f:	c1 e0 05             	shl    $0x5,%eax
  800b12:	01 c2                	add    %eax,%edx
  800b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b17:	01 d0                	add    %edx,%eax
  800b19:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)

	//FREE ALL
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800b1f:	e8 3c 1f 00 00       	call   802a60 <sys_calculate_free_frames>
  800b24:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b27:	e8 7f 1f 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[0]);
  800b2f:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800b35:	83 ec 0c             	sub    $0xc,%esp
  800b38:	50                   	push   %eax
  800b39:	e8 92 1c 00 00       	call   8027d0 <free>
  800b3e:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800b41:	e8 65 1f 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800b46:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800b49:	74 17                	je     800b62 <_main+0xb2a>
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	68 6c 40 80 00       	push   $0x80406c
  800b53:	68 da 00 00 00       	push   $0xda
  800b58:	68 5c 3f 80 00       	push   $0x803f5c
  800b5d:	e8 63 08 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800b62:	e8 f9 1e 00 00       	call   802a60 <sys_calculate_free_frames>
  800b67:	89 c2                	mov    %eax,%edx
  800b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b6c:	29 c2                	sub    %eax,%edx
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	83 f8 02             	cmp    $0x2,%eax
  800b73:	74 17                	je     800b8c <_main+0xb54>
  800b75:	83 ec 04             	sub    $0x4,%esp
  800b78:	68 a8 40 80 00       	push   $0x8040a8
  800b7d:	68 db 00 00 00       	push   $0xdb
  800b82:	68 5c 3f 80 00       	push   $0x803f5c
  800b87:	e8 39 08 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800b8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b8f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b95:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba0:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800ba6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800ba9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bac:	01 d0                	add    %edx,%eax
  800bae:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800bb4:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bbf:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800bc5:	6a 03                	push   $0x3
  800bc7:	6a 00                	push   $0x0
  800bc9:	6a 02                	push   $0x2
  800bcb:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800bd1:	50                   	push   %eax
  800bd2:	e8 a6 23 00 00       	call   802f7d <sys_check_WS_list>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800bdd:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800be1:	74 17                	je     800bfa <_main+0xbc2>
  800be3:	83 ec 04             	sub    $0x4,%esp
  800be6:	68 f4 40 80 00       	push   $0x8040f4
  800beb:	68 de 00 00 00       	push   $0xde
  800bf0:	68 5c 3f 80 00       	push   $0x803f5c
  800bf5:	e8 cb 07 00 00       	call   8013c5 <_panic>
		}

		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bfa:	e8 61 1e 00 00       	call   802a60 <sys_calculate_free_frames>
  800bff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c02:	e8 a4 1e 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800c07:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[1]);
  800c0a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	e8 b7 1b 00 00       	call   8027d0 <free>
  800c19:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800c1c:	e8 8a 1e 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800c21:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 6c 40 80 00       	push   $0x80406c
  800c2e:	68 e6 00 00 00       	push   $0xe6
  800c33:	68 5c 3f 80 00       	push   $0x803f5c
  800c38:	e8 88 07 00 00       	call   8013c5 <_panic>
			cprintf("sys_calculate_free_frames() - freeFrames = %d\n", sys_calculate_free_frames() - freeFrames);
  800c3d:	e8 1e 1e 00 00       	call   802a60 <sys_calculate_free_frames>
  800c42:	89 c2                	mov    %eax,%edx
  800c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c47:	29 c2                	sub    %eax,%edx
  800c49:	89 d0                	mov    %edx,%eax
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	50                   	push   %eax
  800c4f:	68 18 41 80 00       	push   $0x804118
  800c54:	e8 29 0a 00 00       	call   801682 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800c5c:	e8 ff 1d 00 00       	call   802a60 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c66:	29 c2                	sub    %eax,%edx
  800c68:	89 d0                	mov    %edx,%eax
  800c6a:	83 f8 02             	cmp    $0x2,%eax
  800c6d:	74 17                	je     800c86 <_main+0xc4e>
  800c6f:	83 ec 04             	sub    $0x4,%esp
  800c72:	68 a8 40 80 00       	push   $0x8040a8
  800c77:	68 e8 00 00 00       	push   $0xe8
  800c7c:	68 5c 3f 80 00       	push   $0x803f5c
  800c81:	e8 3f 07 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800c86:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c89:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800c8f:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c9a:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
  800ca0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800ca3:	01 c0                	add    %eax,%eax
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800caa:	01 d0                	add    %edx,%eax
  800cac:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800cb2:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cbd:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800cc3:	6a 03                	push   $0x3
  800cc5:	6a 00                	push   $0x0
  800cc7:	6a 02                	push   $0x2
  800cc9:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800ccf:	50                   	push   %eax
  800cd0:	e8 a8 22 00 00       	call   802f7d <sys_check_WS_list>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800cdb:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800cdf:	74 17                	je     800cf8 <_main+0xcc0>
  800ce1:	83 ec 04             	sub    $0x4,%esp
  800ce4:	68 f4 40 80 00       	push   $0x8040f4
  800ce9:	68 eb 00 00 00       	push   $0xeb
  800cee:	68 5c 3f 80 00       	push   $0x803f5c
  800cf3:	e8 cd 06 00 00       	call   8013c5 <_panic>
		}

		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800cf8:	e8 63 1d 00 00       	call   802a60 <sys_calculate_free_frames>
  800cfd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d00:	e8 a6 1d 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800d05:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[6]);
  800d08:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800d0e:	83 ec 0c             	sub    $0xc,%esp
  800d11:	50                   	push   %eax
  800d12:	e8 b9 1a 00 00       	call   8027d0 <free>
  800d17:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800d1a:	e8 8c 1d 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800d1f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800d22:	74 17                	je     800d3b <_main+0xd03>
  800d24:	83 ec 04             	sub    $0x4,%esp
  800d27:	68 6c 40 80 00       	push   $0x80406c
  800d2c:	68 f3 00 00 00       	push   $0xf3
  800d31:	68 5c 3f 80 00       	push   $0x803f5c
  800d36:	e8 8a 06 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800d3b:	e8 20 1d 00 00       	call   802a60 <sys_calculate_free_frames>
  800d40:	89 c2                	mov    %eax,%edx
  800d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
  800d49:	83 f8 03             	cmp    $0x3,%eax
  800d4c:	74 17                	je     800d65 <_main+0xd2d>
  800d4e:	83 ec 04             	sub    $0x4,%esp
  800d51:	68 a8 40 80 00       	push   $0x8040a8
  800d56:	68 f4 00 00 00       	push   $0xf4
  800d5b:	68 5c 3f 80 00       	push   $0x803f5c
  800d60:	e8 60 06 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800d65:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d6b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800d71:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7c:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	c1 ea 1f             	shr    $0x1f,%edx
  800d8a:	01 d0                	add    %edx,%eax
  800d8c:	d1 f8                	sar    %eax
  800d8e:	89 c2                	mov    %eax,%edx
  800d90:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800d96:	01 d0                	add    %edx,%eax
  800d98:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800d9e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800da4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da9:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
  800daf:	8b 55 80             	mov    -0x80(%ebp),%edx
  800db2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800db8:	01 d0                	add    %edx,%eax
  800dba:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800dc0:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  800dd1:	6a 03                	push   $0x3
  800dd3:	6a 00                	push   $0x0
  800dd5:	6a 03                	push   $0x3
  800dd7:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800ddd:	50                   	push   %eax
  800dde:	e8 9a 21 00 00       	call   802f7d <sys_check_WS_list>
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800de9:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ded:	74 17                	je     800e06 <_main+0xdce>
  800def:	83 ec 04             	sub    $0x4,%esp
  800df2:	68 f4 40 80 00       	push   $0x8040f4
  800df7:	68 f7 00 00 00       	push   $0xf7
  800dfc:	68 5c 3f 80 00       	push   $0x803f5c
  800e01:	e8 bf 05 00 00       	call   8013c5 <_panic>
		}

		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e06:	e8 55 1c 00 00       	call   802a60 <sys_calculate_free_frames>
  800e0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e0e:	e8 98 1c 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800e13:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[4]);
  800e16:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	e8 ab 19 00 00       	call   8027d0 <free>
  800e25:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e28:	e8 7e 1c 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800e2d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800e30:	74 17                	je     800e49 <_main+0xe11>
  800e32:	83 ec 04             	sub    $0x4,%esp
  800e35:	68 6c 40 80 00       	push   $0x80406c
  800e3a:	68 ff 00 00 00       	push   $0xff
  800e3f:	68 5c 3f 80 00       	push   $0x803f5c
  800e44:	e8 7c 05 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e49:	e8 12 1c 00 00       	call   802a60 <sys_calculate_free_frames>
  800e4e:	89 c2                	mov    %eax,%edx
  800e50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e53:	29 c2                	sub    %eax,%edx
  800e55:	89 d0                	mov    %edx,%eax
  800e57:	83 f8 02             	cmp    $0x2,%eax
  800e5a:	74 17                	je     800e73 <_main+0xe3b>
  800e5c:	83 ec 04             	sub    $0x4,%esp
  800e5f:	68 a8 40 80 00       	push   $0x8040a8
  800e64:	68 00 01 00 00       	push   $0x100
  800e69:	68 5c 3f 80 00       	push   $0x803f5c
  800e6e:	e8 52 05 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800e73:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e76:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800e7c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800e82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e87:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  800e8d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800e90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800e97:	8b 45 90             	mov    -0x70(%ebp),%eax
  800e9a:	01 d0                	add    %edx,%eax
  800e9c:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800ea2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ead:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800eb3:	6a 03                	push   $0x3
  800eb5:	6a 00                	push   $0x0
  800eb7:	6a 02                	push   $0x2
  800eb9:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  800ebf:	50                   	push   %eax
  800ec0:	e8 b8 20 00 00       	call   802f7d <sys_check_WS_list>
  800ec5:	83 c4 10             	add    $0x10,%esp
  800ec8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800ecb:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  800ecf:	74 17                	je     800ee8 <_main+0xeb0>
  800ed1:	83 ec 04             	sub    $0x4,%esp
  800ed4:	68 f4 40 80 00       	push   $0x8040f4
  800ed9:	68 03 01 00 00       	push   $0x103
  800ede:	68 5c 3f 80 00       	push   $0x803f5c
  800ee3:	e8 dd 04 00 00       	call   8013c5 <_panic>
		}

		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800ee8:	e8 73 1b 00 00       	call   802a60 <sys_calculate_free_frames>
  800eed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ef0:	e8 b6 1b 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800ef5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[5]);
  800ef8:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	e8 c9 18 00 00       	call   8027d0 <free>
  800f07:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f0a:	e8 9c 1b 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800f0f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f12:	74 17                	je     800f2b <_main+0xef3>
  800f14:	83 ec 04             	sub    $0x4,%esp
  800f17:	68 6c 40 80 00       	push   $0x80406c
  800f1c:	68 0b 01 00 00       	push   $0x10b
  800f21:	68 5c 3f 80 00       	push   $0x803f5c
  800f26:	e8 9a 04 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f2b:	e8 30 1b 00 00       	call   802a60 <sys_calculate_free_frames>
  800f30:	89 c2                	mov    %eax,%edx
  800f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 17                	je     800f50 <_main+0xf18>
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	68 a8 40 80 00       	push   $0x8040a8
  800f41:	68 0c 01 00 00       	push   $0x10c
  800f46:	68 5c 3f 80 00       	push   $0x803f5c
  800f4b:	e8 75 04 00 00       	call   8013c5 <_panic>
		}

		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f50:	e8 0b 1b 00 00       	call   802a60 <sys_calculate_free_frames>
  800f55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f58:	e8 4e 1b 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800f5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[2]);
  800f60:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	50                   	push   %eax
  800f6a:	e8 61 18 00 00       	call   8027d0 <free>
  800f6f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f72:	e8 34 1b 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  800f77:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800f7a:	74 17                	je     800f93 <_main+0xf5b>
  800f7c:	83 ec 04             	sub    $0x4,%esp
  800f7f:	68 6c 40 80 00       	push   $0x80406c
  800f84:	68 14 01 00 00       	push   $0x114
  800f89:	68 5c 3f 80 00       	push   $0x803f5c
  800f8e:	e8 32 04 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800f93:	e8 c8 1a 00 00       	call   802a60 <sys_calculate_free_frames>
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f9d:	29 c2                	sub    %eax,%edx
  800f9f:	89 d0                	mov    %edx,%eax
  800fa1:	83 f8 01             	cmp    $0x1,%eax
  800fa4:	74 17                	je     800fbd <_main+0xf85>
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	68 a8 40 80 00       	push   $0x8040a8
  800fae:	68 15 01 00 00       	push   $0x115
  800fb3:	68 5c 3f 80 00       	push   $0x803f5c
  800fb8:	e8 08 04 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  800fbd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fc0:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800fc6:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd1:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  800fd7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800fda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800fec:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ff7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800ffd:	6a 03                	push   $0x3
  800fff:	6a 00                	push   $0x0
  801001:	6a 02                	push   $0x2
  801003:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  801009:	50                   	push   %eax
  80100a:	e8 6e 1f 00 00       	call   802f7d <sys_check_WS_list>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  801015:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  801019:	74 17                	je     801032 <_main+0xffa>
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 f4 40 80 00       	push   $0x8040f4
  801023:	68 18 01 00 00       	push   $0x118
  801028:	68 5c 3f 80 00       	push   $0x803f5c
  80102d:	e8 93 03 00 00       	call   8013c5 <_panic>
		}

		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801032:	e8 29 1a 00 00       	call   802a60 <sys_calculate_free_frames>
  801037:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80103a:	e8 6c 1a 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  80103f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[3]);
  801042:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	50                   	push   %eax
  80104c:	e8 7f 17 00 00       	call   8027d0 <free>
  801051:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801054:	e8 52 1a 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  801059:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80105c:	74 17                	je     801075 <_main+0x103d>
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	68 6c 40 80 00       	push   $0x80406c
  801066:	68 20 01 00 00       	push   $0x120
  80106b:	68 5c 3f 80 00       	push   $0x803f5c
  801070:	e8 50 03 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801075:	e8 e6 19 00 00       	call   802a60 <sys_calculate_free_frames>
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	74 17                	je     80109a <_main+0x1062>
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	68 a8 40 80 00       	push   $0x8040a8
  80108b:	68 21 01 00 00       	push   $0x121
  801090:	68 5c 3f 80 00       	push   $0x803f5c
  801095:	e8 2b 03 00 00       	call   8013c5 <_panic>
		}

		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80109a:	e8 c1 19 00 00       	call   802a60 <sys_calculate_free_frames>
  80109f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010a2:	e8 04 1a 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8010a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
			free(ptr_allocations[7]);
  8010aa:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	50                   	push   %eax
  8010b4:	e8 17 17 00 00       	call   8027d0 <free>
  8010b9:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010bc:	e8 ea 19 00 00       	call   802aab <sys_pf_calculate_allocated_pages>
  8010c1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8010c4:	74 17                	je     8010dd <_main+0x10a5>
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	68 6c 40 80 00       	push   $0x80406c
  8010ce:	68 29 01 00 00       	push   $0x129
  8010d3:	68 5c 3f 80 00       	push   $0x803f5c
  8010d8:	e8 e8 02 00 00       	call   8013c5 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8010dd:	e8 7e 19 00 00       	call   802a60 <sys_calculate_free_frames>
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010e7:	29 c2                	sub    %eax,%edx
  8010e9:	89 d0                	mov    %edx,%eax
  8010eb:	83 f8 03             	cmp    $0x3,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 a8 40 80 00       	push   $0x8040a8
  8010f8:	68 2a 01 00 00       	push   $0x12a
  8010fd:	68 5c 3f 80 00       	push   $0x803f5c
  801102:	e8 be 02 00 00       	call   8013c5 <_panic>
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  801107:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80110d:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801113:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80111e:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801124:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	c1 ea 1f             	shr    $0x1f,%edx
  80112f:	01 d0                	add    %edx,%eax
  801131:	d1 f8                	sar    %eax
  801133:	01 c0                	add    %eax,%eax
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801145:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80114b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801150:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
  801156:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80115c:	01 c0                	add    %eax,%eax
  80115e:	89 c2                	mov    %eax,%edx
  801160:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116e:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801174:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801179:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  80117f:	6a 03                	push   $0x3
  801181:	6a 00                	push   $0x0
  801183:	6a 03                	push   $0x3
  801185:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	e8 ec 1d 00 00       	call   802f7d <sys_check_WS_list>
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  801197:	83 7d b4 01          	cmpl   $0x1,-0x4c(%ebp)
  80119b:	74 17                	je     8011b4 <_main+0x117c>
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	68 f4 40 80 00       	push   $0x8040f4
  8011a5:	68 2d 01 00 00       	push   $0x12d
  8011aa:	68 5c 3f 80 00       	push   $0x803f5c
  8011af:	e8 11 02 00 00       	call   8013c5 <_panic>
		}
	}

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		rsttst();
  8011b4:	e8 10 1c 00 00       	call   802dc9 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8011b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8011be:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  8011c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011c9:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8011cf:	89 c1                	mov    %eax,%ecx
  8011d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8011d6:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8011dc:	52                   	push   %edx
  8011dd:	51                   	push   %ecx
  8011de:	50                   	push   %eax
  8011df:	68 47 41 80 00       	push   $0x804147
  8011e4:	e8 94 1a 00 00       	call   802c7d <sys_create_env>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		sys_run_env(ID1);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	ff b5 1c ff ff ff    	pushl  -0xe4(%ebp)
  8011fb:	e8 9b 1a 00 00       	call   802c9b <sys_run_env>
  801200:	83 c4 10             	add    $0x10,%esp

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801203:	a1 20 50 80 00       	mov    0x805020,%eax
  801208:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  80120e:	a1 20 50 80 00       	mov    0x805020,%eax
  801213:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801219:	89 c1                	mov    %eax,%ecx
  80121b:	a1 20 50 80 00       	mov    0x805020,%eax
  801220:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  801226:	52                   	push   %edx
  801227:	51                   	push   %ecx
  801228:	50                   	push   %eax
  801229:	68 52 41 80 00       	push   $0x804152
  80122e:	e8 4a 1a 00 00       	call   802c7d <sys_create_env>
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		sys_run_env(ID2);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	ff b5 18 ff ff ff    	pushl  -0xe8(%ebp)
  801245:	e8 51 1a 00 00       	call   802c9b <sys_run_env>
  80124a:	83 c4 10             	add    $0x10,%esp

		env_sleep(10000);
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	68 10 27 00 00       	push   $0x2710
  801255:	e8 b2 29 00 00       	call   803c0c <env_sleep>
  80125a:	83 c4 10             	add    $0x10,%esp

		if (gettst() != 0)
  80125d:	e8 e1 1b 00 00       	call   802e43 <gettst>
  801262:	85 c0                	test   %eax,%eax
  801264:	74 10                	je     801276 <_main+0x123e>
			cprintf("\nFree: successful access to freed space!! (processes should be killed by the validation of the fault handler)\n");
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	68 60 41 80 00       	push   $0x804160
  80126e:	e8 0f 04 00 00       	call   801682 <cprintf>
  801273:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Congratulations!! test free [1] [PAGE ALLOCATOR] completed successfully.\n");
  801276:	83 ec 0c             	sub    $0xc,%esp
  801279:	68 d0 41 80 00       	push   $0x8041d0
  80127e:	e8 ff 03 00 00       	call   801682 <cprintf>
  801283:	83 c4 10             	add    $0x10,%esp

	return;
  801286:	90                   	nop
}
  801287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80128a:	5b                   	pop    %ebx
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801294:	e8 52 1a 00 00       	call   802ceb <sys_getenvindex>
  801299:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80129c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129f:	89 d0                	mov    %edx,%eax
  8012a1:	c1 e0 03             	shl    $0x3,%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	01 c0                	add    %eax,%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c1 e0 04             	shl    $0x4,%eax
  8012b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012bb:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8012c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c5:	8a 40 5c             	mov    0x5c(%eax),%al
  8012c8:	84 c0                	test   %al,%al
  8012ca:	74 0d                	je     8012d9 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8012cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8012d1:	83 c0 5c             	add    $0x5c,%eax
  8012d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012dd:	7e 0a                	jle    8012e9 <libmain+0x5b>
		binaryname = argv[0];
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	8b 00                	mov    (%eax),%eax
  8012e4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	ff 75 08             	pushl  0x8(%ebp)
  8012f2:	e8 41 ed ff ff       	call   800038 <_main>
  8012f7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8012fa:	e8 f9 17 00 00       	call   802af8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	68 34 42 80 00       	push   $0x804234
  801307:	e8 76 03 00 00       	call   801682 <cprintf>
  80130c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80130f:	a1 20 50 80 00       	mov    0x805020,%eax
  801314:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80131a:	a1 20 50 80 00       	mov    0x805020,%eax
  80131f:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	52                   	push   %edx
  801329:	50                   	push   %eax
  80132a:	68 5c 42 80 00       	push   $0x80425c
  80132f:	e8 4e 03 00 00       	call   801682 <cprintf>
  801334:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801337:	a1 20 50 80 00       	mov    0x805020,%eax
  80133c:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  801342:	a1 20 50 80 00       	mov    0x805020,%eax
  801347:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80134d:	a1 20 50 80 00       	mov    0x805020,%eax
  801352:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  801358:	51                   	push   %ecx
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	68 84 42 80 00       	push   $0x804284
  801360:	e8 1d 03 00 00       	call   801682 <cprintf>
  801365:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801368:	a1 20 50 80 00       	mov    0x805020,%eax
  80136d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  801373:	83 ec 08             	sub    $0x8,%esp
  801376:	50                   	push   %eax
  801377:	68 dc 42 80 00       	push   $0x8042dc
  80137c:	e8 01 03 00 00       	call   801682 <cprintf>
  801381:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801384:	83 ec 0c             	sub    $0xc,%esp
  801387:	68 34 42 80 00       	push   $0x804234
  80138c:	e8 f1 02 00 00       	call   801682 <cprintf>
  801391:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801394:	e8 79 17 00 00       	call   802b12 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801399:	e8 19 00 00 00       	call   8013b7 <exit>
}
  80139e:	90                   	nop
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	6a 00                	push   $0x0
  8013ac:	e8 06 19 00 00       	call   802cb7 <sys_destroy_env>
  8013b1:	83 c4 10             	add    $0x10,%esp
}
  8013b4:	90                   	nop
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <exit>:

void
exit(void)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8013bd:	e8 5b 19 00 00       	call   802d1d <sys_exit_env>
}
  8013c2:	90                   	nop
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8013cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8013ce:	83 c0 04             	add    $0x4,%eax
  8013d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8013d4:	a1 2c 51 80 00       	mov    0x80512c,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 16                	je     8013f3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8013dd:	a1 2c 51 80 00       	mov    0x80512c,%eax
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	50                   	push   %eax
  8013e6:	68 f0 42 80 00       	push   $0x8042f0
  8013eb:	e8 92 02 00 00       	call   801682 <cprintf>
  8013f0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8013f3:	a1 00 50 80 00       	mov    0x805000,%eax
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	ff 75 08             	pushl  0x8(%ebp)
  8013fe:	50                   	push   %eax
  8013ff:	68 f5 42 80 00       	push   $0x8042f5
  801404:	e8 79 02 00 00       	call   801682 <cprintf>
  801409:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	ff 75 f4             	pushl  -0xc(%ebp)
  801415:	50                   	push   %eax
  801416:	e8 fc 01 00 00       	call   801617 <vcprintf>
  80141b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	6a 00                	push   $0x0
  801423:	68 11 43 80 00       	push   $0x804311
  801428:	e8 ea 01 00 00       	call   801617 <vcprintf>
  80142d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801430:	e8 82 ff ff ff       	call   8013b7 <exit>

	// should not return here
	while (1) ;
  801435:	eb fe                	jmp    801435 <_panic+0x70>

00801437 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80143d:	a1 20 50 80 00       	mov    0x805020,%eax
  801442:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	39 c2                	cmp    %eax,%edx
  80144d:	74 14                	je     801463 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 14 43 80 00       	push   $0x804314
  801457:	6a 26                	push   $0x26
  801459:	68 60 43 80 00       	push   $0x804360
  80145e:	e8 62 ff ff ff       	call   8013c5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80146a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801471:	e9 c5 00 00 00       	jmp    80153b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801479:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	8b 00                	mov    (%eax),%eax
  801487:	85 c0                	test   %eax,%eax
  801489:	75 08                	jne    801493 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80148b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80148e:	e9 a5 00 00 00       	jmp    801538 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801493:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80149a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8014a1:	eb 69                	jmp    80150c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8014a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8014ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	01 c0                	add    %eax,%eax
  8014b5:	01 d0                	add    %edx,%eax
  8014b7:	c1 e0 03             	shl    $0x3,%eax
  8014ba:	01 c8                	add    %ecx,%eax
  8014bc:	8a 40 04             	mov    0x4(%eax),%al
  8014bf:	84 c0                	test   %al,%al
  8014c1:	75 46                	jne    801509 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8014c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8014c8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8014ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014d1:	89 d0                	mov    %edx,%eax
  8014d3:	01 c0                	add    %eax,%eax
  8014d5:	01 d0                	add    %edx,%eax
  8014d7:	c1 e0 03             	shl    $0x3,%eax
  8014da:	01 c8                	add    %ecx,%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	01 c8                	add    %ecx,%eax
  8014fa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8014fc:	39 c2                	cmp    %eax,%edx
  8014fe:	75 09                	jne    801509 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801500:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801507:	eb 15                	jmp    80151e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801509:	ff 45 e8             	incl   -0x18(%ebp)
  80150c:	a1 20 50 80 00       	mov    0x805020,%eax
  801511:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  801517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151a:	39 c2                	cmp    %eax,%edx
  80151c:	77 85                	ja     8014a3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80151e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801522:	75 14                	jne    801538 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 6c 43 80 00       	push   $0x80436c
  80152c:	6a 3a                	push   $0x3a
  80152e:	68 60 43 80 00       	push   $0x804360
  801533:	e8 8d fe ff ff       	call   8013c5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801538:	ff 45 f0             	incl   -0x10(%ebp)
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801541:	0f 8c 2f ff ff ff    	jl     801476 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801547:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80154e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801555:	eb 26                	jmp    80157d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801557:	a1 20 50 80 00       	mov    0x805020,%eax
  80155c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801562:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801565:	89 d0                	mov    %edx,%eax
  801567:	01 c0                	add    %eax,%eax
  801569:	01 d0                	add    %edx,%eax
  80156b:	c1 e0 03             	shl    $0x3,%eax
  80156e:	01 c8                	add    %ecx,%eax
  801570:	8a 40 04             	mov    0x4(%eax),%al
  801573:	3c 01                	cmp    $0x1,%al
  801575:	75 03                	jne    80157a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801577:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80157a:	ff 45 e0             	incl   -0x20(%ebp)
  80157d:	a1 20 50 80 00       	mov    0x805020,%eax
  801582:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  801588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	77 c8                	ja     801557 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801595:	74 14                	je     8015ab <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	68 c0 43 80 00       	push   $0x8043c0
  80159f:	6a 44                	push   $0x44
  8015a1:	68 60 43 80 00       	push   $0x804360
  8015a6:	e8 1a fe ff ff       	call   8013c5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8015ab:	90                   	nop
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8015b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8015bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bf:	89 0a                	mov    %ecx,(%edx)
  8015c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c4:	88 d1                	mov    %dl,%cl
  8015c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	8b 00                	mov    (%eax),%eax
  8015d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8015d7:	75 2c                	jne    801605 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8015d9:	a0 24 50 80 00       	mov    0x805024,%al
  8015de:	0f b6 c0             	movzbl %al,%eax
  8015e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e4:	8b 12                	mov    (%edx),%edx
  8015e6:	89 d1                	mov    %edx,%ecx
  8015e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015eb:	83 c2 08             	add    $0x8,%edx
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	50                   	push   %eax
  8015f2:	51                   	push   %ecx
  8015f3:	52                   	push   %edx
  8015f4:	e8 a6 13 00 00       	call   80299f <sys_cputs>
  8015f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	8b 40 04             	mov    0x4(%eax),%eax
  80160b:	8d 50 01             	lea    0x1(%eax),%edx
  80160e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801611:	89 50 04             	mov    %edx,0x4(%eax)
}
  801614:	90                   	nop
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801620:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801627:	00 00 00 
	b.cnt = 0;
  80162a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801631:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801640:	50                   	push   %eax
  801641:	68 ae 15 80 00       	push   $0x8015ae
  801646:	e8 11 02 00 00       	call   80185c <vprintfmt>
  80164b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80164e:	a0 24 50 80 00       	mov    0x805024,%al
  801653:	0f b6 c0             	movzbl %al,%eax
  801656:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	50                   	push   %eax
  801660:	52                   	push   %edx
  801661:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801667:	83 c0 08             	add    $0x8,%eax
  80166a:	50                   	push   %eax
  80166b:	e8 2f 13 00 00       	call   80299f <sys_cputs>
  801670:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801673:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80167a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <cprintf>:

int cprintf(const char *fmt, ...) {
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801688:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80168f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	83 ec 08             	sub    $0x8,%esp
  80169b:	ff 75 f4             	pushl  -0xc(%ebp)
  80169e:	50                   	push   %eax
  80169f:	e8 73 ff ff ff       	call   801617 <vcprintf>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8016b5:	e8 3e 14 00 00       	call   802af8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c9:	50                   	push   %eax
  8016ca:	e8 48 ff ff ff       	call   801617 <vcprintf>
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8016d5:	e8 38 14 00 00       	call   802b12 <sys_enable_interrupt>
	return cnt;
  8016da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 14             	sub    $0x14,%esp
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8016f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016fd:	77 55                	ja     801754 <printnum+0x75>
  8016ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801702:	72 05                	jb     801709 <printnum+0x2a>
  801704:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801707:	77 4b                	ja     801754 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801709:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80170c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80170f:	8b 45 18             	mov    0x18(%ebp),%eax
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	ff 75 f4             	pushl  -0xc(%ebp)
  80171c:	ff 75 f0             	pushl  -0x10(%ebp)
  80171f:	e8 9c 25 00 00       	call   803cc0 <__udivdi3>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	ff 75 20             	pushl  0x20(%ebp)
  80172d:	53                   	push   %ebx
  80172e:	ff 75 18             	pushl  0x18(%ebp)
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	e8 a1 ff ff ff       	call   8016df <printnum>
  80173e:	83 c4 20             	add    $0x20,%esp
  801741:	eb 1a                	jmp    80175d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 20             	pushl  0x20(%ebp)
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	ff d0                	call   *%eax
  801751:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801754:	ff 4d 1c             	decl   0x1c(%ebp)
  801757:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80175b:	7f e6                	jg     801743 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80175d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
  801765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176b:	53                   	push   %ebx
  80176c:	51                   	push   %ecx
  80176d:	52                   	push   %edx
  80176e:	50                   	push   %eax
  80176f:	e8 5c 26 00 00       	call   803dd0 <__umoddi3>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	05 34 46 80 00       	add    $0x804634,%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	0f be c0             	movsbl %al,%eax
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	50                   	push   %eax
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	ff d0                	call   *%eax
  80178d:	83 c4 10             	add    $0x10,%esp
}
  801790:	90                   	nop
  801791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801799:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80179d:	7e 1c                	jle    8017bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8b 00                	mov    (%eax),%eax
  8017a4:	8d 50 08             	lea    0x8(%eax),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	89 10                	mov    %edx,(%eax)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8b 00                	mov    (%eax),%eax
  8017b1:	83 e8 08             	sub    $0x8,%eax
  8017b4:	8b 50 04             	mov    0x4(%eax),%edx
  8017b7:	8b 00                	mov    (%eax),%eax
  8017b9:	eb 40                	jmp    8017fb <getuint+0x65>
	else if (lflag)
  8017bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017bf:	74 1e                	je     8017df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 00                	mov    (%eax),%eax
  8017c6:	8d 50 04             	lea    0x4(%eax),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	89 10                	mov    %edx,(%eax)
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8b 00                	mov    (%eax),%eax
  8017d3:	83 e8 04             	sub    $0x4,%eax
  8017d6:	8b 00                	mov    (%eax),%eax
  8017d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dd:	eb 1c                	jmp    8017fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 00                	mov    (%eax),%eax
  8017e4:	8d 50 04             	lea    0x4(%eax),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 10                	mov    %edx,(%eax)
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	83 e8 04             	sub    $0x4,%eax
  8017f4:	8b 00                	mov    (%eax),%eax
  8017f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017fb:	5d                   	pop    %ebp
  8017fc:	c3                   	ret    

008017fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801800:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801804:	7e 1c                	jle    801822 <getint+0x25>
		return va_arg(*ap, long long);
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	8d 50 08             	lea    0x8(%eax),%edx
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	89 10                	mov    %edx,(%eax)
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8b 00                	mov    (%eax),%eax
  801818:	83 e8 08             	sub    $0x8,%eax
  80181b:	8b 50 04             	mov    0x4(%eax),%edx
  80181e:	8b 00                	mov    (%eax),%eax
  801820:	eb 38                	jmp    80185a <getint+0x5d>
	else if (lflag)
  801822:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801826:	74 1a                	je     801842 <getint+0x45>
		return va_arg(*ap, long);
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8b 00                	mov    (%eax),%eax
  80182d:	8d 50 04             	lea    0x4(%eax),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	89 10                	mov    %edx,(%eax)
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8b 00                	mov    (%eax),%eax
  80183a:	83 e8 04             	sub    $0x4,%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	99                   	cltd   
  801840:	eb 18                	jmp    80185a <getint+0x5d>
	else
		return va_arg(*ap, int);
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	8d 50 04             	lea    0x4(%eax),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	89 10                	mov    %edx,(%eax)
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	83 e8 04             	sub    $0x4,%eax
  801857:	8b 00                	mov    (%eax),%eax
  801859:	99                   	cltd   
}
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	56                   	push   %esi
  801860:	53                   	push   %ebx
  801861:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801864:	eb 17                	jmp    80187d <vprintfmt+0x21>
			if (ch == '\0')
  801866:	85 db                	test   %ebx,%ebx
  801868:	0f 84 af 03 00 00    	je     801c1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	53                   	push   %ebx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	ff d0                	call   *%eax
  80187a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80187d:	8b 45 10             	mov    0x10(%ebp),%eax
  801880:	8d 50 01             	lea    0x1(%eax),%edx
  801883:	89 55 10             	mov    %edx,0x10(%ebp)
  801886:	8a 00                	mov    (%eax),%al
  801888:	0f b6 d8             	movzbl %al,%ebx
  80188b:	83 fb 25             	cmp    $0x25,%ebx
  80188e:	75 d6                	jne    801866 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801890:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801894:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80189b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8018a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b3:	8d 50 01             	lea    0x1(%eax),%edx
  8018b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	0f b6 d8             	movzbl %al,%ebx
  8018be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8018c1:	83 f8 55             	cmp    $0x55,%eax
  8018c4:	0f 87 2b 03 00 00    	ja     801bf5 <vprintfmt+0x399>
  8018ca:	8b 04 85 58 46 80 00 	mov    0x804658(,%eax,4),%eax
  8018d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8018d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8018d7:	eb d7                	jmp    8018b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8018dd:	eb d1                	jmp    8018b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8018e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	01 c0                	add    %eax,%eax
  8018f2:	01 d8                	add    %ebx,%eax
  8018f4:	83 e8 30             	sub    $0x30,%eax
  8018f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8018fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fd:	8a 00                	mov    (%eax),%al
  8018ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801902:	83 fb 2f             	cmp    $0x2f,%ebx
  801905:	7e 3e                	jle    801945 <vprintfmt+0xe9>
  801907:	83 fb 39             	cmp    $0x39,%ebx
  80190a:	7f 39                	jg     801945 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80190c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80190f:	eb d5                	jmp    8018e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801911:	8b 45 14             	mov    0x14(%ebp),%eax
  801914:	83 c0 04             	add    $0x4,%eax
  801917:	89 45 14             	mov    %eax,0x14(%ebp)
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	83 e8 04             	sub    $0x4,%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801925:	eb 1f                	jmp    801946 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801927:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192b:	79 83                	jns    8018b0 <vprintfmt+0x54>
				width = 0;
  80192d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801934:	e9 77 ff ff ff       	jmp    8018b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801939:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801940:	e9 6b ff ff ff       	jmp    8018b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801945:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80194a:	0f 89 60 ff ff ff    	jns    8018b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  801950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80195d:	e9 4e ff ff ff       	jmp    8018b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801962:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801965:	e9 46 ff ff ff       	jmp    8018b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	83 c0 04             	add    $0x4,%eax
  801970:	89 45 14             	mov    %eax,0x14(%ebp)
  801973:	8b 45 14             	mov    0x14(%ebp),%eax
  801976:	83 e8 04             	sub    $0x4,%eax
  801979:	8b 00                	mov    (%eax),%eax
  80197b:	83 ec 08             	sub    $0x8,%esp
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	50                   	push   %eax
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	ff d0                	call   *%eax
  801987:	83 c4 10             	add    $0x10,%esp
			break;
  80198a:	e9 89 02 00 00       	jmp    801c18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80198f:	8b 45 14             	mov    0x14(%ebp),%eax
  801992:	83 c0 04             	add    $0x4,%eax
  801995:	89 45 14             	mov    %eax,0x14(%ebp)
  801998:	8b 45 14             	mov    0x14(%ebp),%eax
  80199b:	83 e8 04             	sub    $0x4,%eax
  80199e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019a0:	85 db                	test   %ebx,%ebx
  8019a2:	79 02                	jns    8019a6 <vprintfmt+0x14a>
				err = -err;
  8019a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8019a6:	83 fb 64             	cmp    $0x64,%ebx
  8019a9:	7f 0b                	jg     8019b6 <vprintfmt+0x15a>
  8019ab:	8b 34 9d a0 44 80 00 	mov    0x8044a0(,%ebx,4),%esi
  8019b2:	85 f6                	test   %esi,%esi
  8019b4:	75 19                	jne    8019cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8019b6:	53                   	push   %ebx
  8019b7:	68 45 46 80 00       	push   $0x804645
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	e8 5e 02 00 00       	call   801c25 <printfmt>
  8019c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8019ca:	e9 49 02 00 00       	jmp    801c18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8019cf:	56                   	push   %esi
  8019d0:	68 4e 46 80 00       	push   $0x80464e
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 45 02 00 00       	call   801c25 <printfmt>
  8019e0:	83 c4 10             	add    $0x10,%esp
			break;
  8019e3:	e9 30 02 00 00       	jmp    801c18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8019e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019eb:	83 c0 04             	add    $0x4,%eax
  8019ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f4:	83 e8 04             	sub    $0x4,%eax
  8019f7:	8b 30                	mov    (%eax),%esi
  8019f9:	85 f6                	test   %esi,%esi
  8019fb:	75 05                	jne    801a02 <vprintfmt+0x1a6>
				p = "(null)";
  8019fd:	be 51 46 80 00       	mov    $0x804651,%esi
			if (width > 0 && padc != '-')
  801a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a06:	7e 6d                	jle    801a75 <vprintfmt+0x219>
  801a08:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a0c:	74 67                	je     801a75 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a11:	83 ec 08             	sub    $0x8,%esp
  801a14:	50                   	push   %eax
  801a15:	56                   	push   %esi
  801a16:	e8 0c 03 00 00       	call   801d27 <strnlen>
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a21:	eb 16                	jmp    801a39 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a23:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	50                   	push   %eax
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	ff d0                	call   *%eax
  801a33:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a36:	ff 4d e4             	decl   -0x1c(%ebp)
  801a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a3d:	7f e4                	jg     801a23 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a3f:	eb 34                	jmp    801a75 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a45:	74 1c                	je     801a63 <vprintfmt+0x207>
  801a47:	83 fb 1f             	cmp    $0x1f,%ebx
  801a4a:	7e 05                	jle    801a51 <vprintfmt+0x1f5>
  801a4c:	83 fb 7e             	cmp    $0x7e,%ebx
  801a4f:	7e 12                	jle    801a63 <vprintfmt+0x207>
					putch('?', putdat);
  801a51:	83 ec 08             	sub    $0x8,%esp
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	6a 3f                	push   $0x3f
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	ff d0                	call   *%eax
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	eb 0f                	jmp    801a72 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	53                   	push   %ebx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	ff d0                	call   *%eax
  801a6f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a72:	ff 4d e4             	decl   -0x1c(%ebp)
  801a75:	89 f0                	mov    %esi,%eax
  801a77:	8d 70 01             	lea    0x1(%eax),%esi
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f be d8             	movsbl %al,%ebx
  801a7f:	85 db                	test   %ebx,%ebx
  801a81:	74 24                	je     801aa7 <vprintfmt+0x24b>
  801a83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a87:	78 b8                	js     801a41 <vprintfmt+0x1e5>
  801a89:	ff 4d e0             	decl   -0x20(%ebp)
  801a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a90:	79 af                	jns    801a41 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a92:	eb 13                	jmp    801aa7 <vprintfmt+0x24b>
				putch(' ', putdat);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	6a 20                	push   $0x20
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	ff d0                	call   *%eax
  801aa1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  801aa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aab:	7f e7                	jg     801a94 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801aad:	e9 66 01 00 00       	jmp    801c18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab8:	8d 45 14             	lea    0x14(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	e8 3c fd ff ff       	call   8017fd <getint>
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad0:	85 d2                	test   %edx,%edx
  801ad2:	79 23                	jns    801af7 <vprintfmt+0x29b>
				putch('-', putdat);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	6a 2d                	push   $0x2d
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	ff d0                	call   *%eax
  801ae1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aea:	f7 d8                	neg    %eax
  801aec:	83 d2 00             	adc    $0x0,%edx
  801aef:	f7 da                	neg    %edx
  801af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801af4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801af7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801afe:	e9 bc 00 00 00       	jmp    801bbf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	ff 75 e8             	pushl  -0x18(%ebp)
  801b09:	8d 45 14             	lea    0x14(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	e8 84 fc ff ff       	call   801796 <getuint>
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b22:	e9 98 00 00 00       	jmp    801bbf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	ff 75 0c             	pushl  0xc(%ebp)
  801b2d:	6a 58                	push   $0x58
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	ff d0                	call   *%eax
  801b34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b37:	83 ec 08             	sub    $0x8,%esp
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	6a 58                	push   $0x58
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	ff d0                	call   *%eax
  801b44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	6a 58                	push   $0x58
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	ff d0                	call   *%eax
  801b54:	83 c4 10             	add    $0x10,%esp
			break;
  801b57:	e9 bc 00 00 00       	jmp    801c18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801b5c:	83 ec 08             	sub    $0x8,%esp
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	6a 30                	push   $0x30
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	ff d0                	call   *%eax
  801b69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	6a 78                	push   $0x78
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	ff d0                	call   *%eax
  801b79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7f:	83 c0 04             	add    $0x4,%eax
  801b82:	89 45 14             	mov    %eax,0x14(%ebp)
  801b85:	8b 45 14             	mov    0x14(%ebp),%eax
  801b88:	83 e8 04             	sub    $0x4,%eax
  801b8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b9e:	eb 1f                	jmp    801bbf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ba6:	8d 45 14             	lea    0x14(%ebp),%eax
  801ba9:	50                   	push   %eax
  801baa:	e8 e7 fb ff ff       	call   801796 <getuint>
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801bb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801bbf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	52                   	push   %edx
  801bca:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	e8 00 fb ff ff       	call   8016df <printnum>
  801bdf:	83 c4 20             	add    $0x20,%esp
			break;
  801be2:	eb 34                	jmp    801c18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801be4:	83 ec 08             	sub    $0x8,%esp
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	53                   	push   %ebx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	ff d0                	call   *%eax
  801bf0:	83 c4 10             	add    $0x10,%esp
			break;
  801bf3:	eb 23                	jmp    801c18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801bf5:	83 ec 08             	sub    $0x8,%esp
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	6a 25                	push   $0x25
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	ff d0                	call   *%eax
  801c02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c05:	ff 4d 10             	decl   0x10(%ebp)
  801c08:	eb 03                	jmp    801c0d <vprintfmt+0x3b1>
  801c0a:	ff 4d 10             	decl   0x10(%ebp)
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	48                   	dec    %eax
  801c11:	8a 00                	mov    (%eax),%al
  801c13:	3c 25                	cmp    $0x25,%al
  801c15:	75 f3                	jne    801c0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c17:	90                   	nop
		}
	}
  801c18:	e9 47 fc ff ff       	jmp    801864 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c2b:	8d 45 10             	lea    0x10(%ebp),%eax
  801c2e:	83 c0 04             	add    $0x4,%eax
  801c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3a:	50                   	push   %eax
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	e8 16 fc ff ff       	call   80185c <vprintfmt>
  801c46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c52:	8b 40 08             	mov    0x8(%eax),%eax
  801c55:	8d 50 01             	lea    0x1(%eax),%edx
  801c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c61:	8b 10                	mov    (%eax),%edx
  801c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c66:	8b 40 04             	mov    0x4(%eax),%eax
  801c69:	39 c2                	cmp    %eax,%edx
  801c6b:	73 12                	jae    801c7f <sprintputch+0x33>
		*b->buf++ = ch;
  801c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c70:	8b 00                	mov    (%eax),%eax
  801c72:	8d 48 01             	lea    0x1(%eax),%ecx
  801c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c78:	89 0a                	mov    %ecx,(%edx)
  801c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7d:	88 10                	mov    %dl,(%eax)
}
  801c7f:	90                   	nop
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	01 d0                	add    %edx,%eax
  801c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ca7:	74 06                	je     801caf <vsnprintf+0x2d>
  801ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cad:	7f 07                	jg     801cb6 <vsnprintf+0x34>
		return -E_INVAL;
  801caf:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb4:	eb 20                	jmp    801cd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801cb6:	ff 75 14             	pushl  0x14(%ebp)
  801cb9:	ff 75 10             	pushl  0x10(%ebp)
  801cbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801cbf:	50                   	push   %eax
  801cc0:	68 4c 1c 80 00       	push   $0x801c4c
  801cc5:	e8 92 fb ff ff       	call   80185c <vprintfmt>
  801cca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801cde:	8d 45 10             	lea    0x10(%ebp),%eax
  801ce1:	83 c0 04             	add    $0x4,%eax
  801ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cea:	ff 75 f4             	pushl  -0xc(%ebp)
  801ced:	50                   	push   %eax
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	e8 89 ff ff ff       	call   801c82 <vsnprintf>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d11:	eb 06                	jmp    801d19 <strlen+0x15>
		n++;
  801d13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d16:	ff 45 08             	incl   0x8(%ebp)
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8a 00                	mov    (%eax),%al
  801d1e:	84 c0                	test   %al,%al
  801d20:	75 f1                	jne    801d13 <strlen+0xf>
		n++;
	return n;
  801d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d34:	eb 09                	jmp    801d3f <strnlen+0x18>
		n++;
  801d36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d39:	ff 45 08             	incl   0x8(%ebp)
  801d3c:	ff 4d 0c             	decl   0xc(%ebp)
  801d3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d43:	74 09                	je     801d4e <strnlen+0x27>
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	8a 00                	mov    (%eax),%al
  801d4a:	84 c0                	test   %al,%al
  801d4c:	75 e8                	jne    801d36 <strnlen+0xf>
		n++;
	return n;
  801d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d5f:	90                   	nop
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	8d 50 01             	lea    0x1(%eax),%edx
  801d66:	89 55 08             	mov    %edx,0x8(%ebp)
  801d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d72:	8a 12                	mov    (%edx),%dl
  801d74:	88 10                	mov    %dl,(%eax)
  801d76:	8a 00                	mov    (%eax),%al
  801d78:	84 c0                	test   %al,%al
  801d7a:	75 e4                	jne    801d60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d94:	eb 1f                	jmp    801db5 <strncpy+0x34>
		*dst++ = *src;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	8d 50 01             	lea    0x1(%eax),%edx
  801d9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8a 12                	mov    (%edx),%dl
  801da4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	8a 00                	mov    (%eax),%al
  801dab:	84 c0                	test   %al,%al
  801dad:	74 03                	je     801db2 <strncpy+0x31>
			src++;
  801daf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801db2:	ff 45 fc             	incl   -0x4(%ebp)
  801db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db8:	3b 45 10             	cmp    0x10(%ebp),%eax
  801dbb:	72 d9                	jb     801d96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801dbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801dce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dd2:	74 30                	je     801e04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801dd4:	eb 16                	jmp    801dec <strlcpy+0x2a>
			*dst++ = *src++;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	8d 50 01             	lea    0x1(%eax),%edx
  801ddc:	89 55 08             	mov    %edx,0x8(%ebp)
  801ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801de5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801de8:	8a 12                	mov    (%edx),%dl
  801dea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801dec:	ff 4d 10             	decl   0x10(%ebp)
  801def:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df3:	74 09                	je     801dfe <strlcpy+0x3c>
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	84 c0                	test   %al,%al
  801dfc:	75 d8                	jne    801dd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e04:	8b 55 08             	mov    0x8(%ebp),%edx
  801e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e0a:	29 c2                	sub    %eax,%edx
  801e0c:	89 d0                	mov    %edx,%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e13:	eb 06                	jmp    801e1b <strcmp+0xb>
		p++, q++;
  801e15:	ff 45 08             	incl   0x8(%ebp)
  801e18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	8a 00                	mov    (%eax),%al
  801e20:	84 c0                	test   %al,%al
  801e22:	74 0e                	je     801e32 <strcmp+0x22>
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	8a 10                	mov    (%eax),%dl
  801e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2c:	8a 00                	mov    (%eax),%al
  801e2e:	38 c2                	cmp    %al,%dl
  801e30:	74 e3                	je     801e15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	8a 00                	mov    (%eax),%al
  801e37:	0f b6 d0             	movzbl %al,%edx
  801e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3d:	8a 00                	mov    (%eax),%al
  801e3f:	0f b6 c0             	movzbl %al,%eax
  801e42:	29 c2                	sub    %eax,%edx
  801e44:	89 d0                	mov    %edx,%eax
}
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    

00801e48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e4b:	eb 09                	jmp    801e56 <strncmp+0xe>
		n--, p++, q++;
  801e4d:	ff 4d 10             	decl   0x10(%ebp)
  801e50:	ff 45 08             	incl   0x8(%ebp)
  801e53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e5a:	74 17                	je     801e73 <strncmp+0x2b>
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8a 00                	mov    (%eax),%al
  801e61:	84 c0                	test   %al,%al
  801e63:	74 0e                	je     801e73 <strncmp+0x2b>
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	8a 10                	mov    (%eax),%dl
  801e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6d:	8a 00                	mov    (%eax),%al
  801e6f:	38 c2                	cmp    %al,%dl
  801e71:	74 da                	je     801e4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e77:	75 07                	jne    801e80 <strncmp+0x38>
		return 0;
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7e:	eb 14                	jmp    801e94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	8a 00                	mov    (%eax),%al
  801e85:	0f b6 d0             	movzbl %al,%edx
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	8a 00                	mov    (%eax),%al
  801e8d:	0f b6 c0             	movzbl %al,%eax
  801e90:	29 c2                	sub    %eax,%edx
  801e92:	89 d0                	mov    %edx,%eax
}
  801e94:	5d                   	pop    %ebp
  801e95:	c3                   	ret    

00801e96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ea2:	eb 12                	jmp    801eb6 <strchr+0x20>
		if (*s == c)
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	8a 00                	mov    (%eax),%al
  801ea9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801eac:	75 05                	jne    801eb3 <strchr+0x1d>
			return (char *) s;
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	eb 11                	jmp    801ec4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801eb3:	ff 45 08             	incl   0x8(%ebp)
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8a 00                	mov    (%eax),%al
  801ebb:	84 c0                	test   %al,%al
  801ebd:	75 e5                	jne    801ea4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 04             	sub    $0x4,%esp
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ed2:	eb 0d                	jmp    801ee1 <strfind+0x1b>
		if (*s == c)
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	8a 00                	mov    (%eax),%al
  801ed9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801edc:	74 0e                	je     801eec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ede:	ff 45 08             	incl   0x8(%ebp)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8a 00                	mov    (%eax),%al
  801ee6:	84 c0                	test   %al,%al
  801ee8:	75 ea                	jne    801ed4 <strfind+0xe>
  801eea:	eb 01                	jmp    801eed <strfind+0x27>
		if (*s == c)
			break;
  801eec:	90                   	nop
	return (char *) s;
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801efe:	8b 45 10             	mov    0x10(%ebp),%eax
  801f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f04:	eb 0e                	jmp    801f14 <memset+0x22>
		*p++ = c;
  801f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f09:	8d 50 01             	lea    0x1(%eax),%edx
  801f0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f14:	ff 4d f8             	decl   -0x8(%ebp)
  801f17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f1b:	79 e9                	jns    801f06 <memset+0x14>
		*p++ = c;

	return v;
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f34:	eb 16                	jmp    801f4c <memcpy+0x2a>
		*d++ = *s++;
  801f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f39:	8d 50 01             	lea    0x1(%eax),%edx
  801f3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f42:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801f48:	8a 12                	mov    (%edx),%dl
  801f4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f52:	89 55 10             	mov    %edx,0x10(%ebp)
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 dd                	jne    801f36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f76:	73 50                	jae    801fc8 <memmove+0x6a>
  801f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7e:	01 d0                	add    %edx,%eax
  801f80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f83:	76 43                	jbe    801fc8 <memmove+0x6a>
		s += n;
  801f85:	8b 45 10             	mov    0x10(%ebp),%eax
  801f88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f91:	eb 10                	jmp    801fa3 <memmove+0x45>
			*--d = *--s;
  801f93:	ff 4d f8             	decl   -0x8(%ebp)
  801f96:	ff 4d fc             	decl   -0x4(%ebp)
  801f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9c:	8a 10                	mov    (%eax),%dl
  801f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa6:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fa9:	89 55 10             	mov    %edx,0x10(%ebp)
  801fac:	85 c0                	test   %eax,%eax
  801fae:	75 e3                	jne    801f93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801fb0:	eb 23                	jmp    801fd5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fb5:	8d 50 01             	lea    0x1(%eax),%edx
  801fb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fc1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fc4:	8a 12                	mov    (%edx),%dl
  801fc6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fce:	89 55 10             	mov    %edx,0x10(%ebp)
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	75 dd                	jne    801fb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801fec:	eb 2a                	jmp    802018 <memcmp+0x3e>
		if (*s1 != *s2)
  801fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff1:	8a 10                	mov    (%eax),%dl
  801ff3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	38 c2                	cmp    %al,%dl
  801ffa:	74 16                	je     802012 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	0f b6 d0             	movzbl %al,%edx
  802004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802007:	8a 00                	mov    (%eax),%al
  802009:	0f b6 c0             	movzbl %al,%eax
  80200c:	29 c2                	sub    %eax,%edx
  80200e:	89 d0                	mov    %edx,%eax
  802010:	eb 18                	jmp    80202a <memcmp+0x50>
		s1++, s2++;
  802012:	ff 45 fc             	incl   -0x4(%ebp)
  802015:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802018:	8b 45 10             	mov    0x10(%ebp),%eax
  80201b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80201e:	89 55 10             	mov    %edx,0x10(%ebp)
  802021:	85 c0                	test   %eax,%eax
  802023:	75 c9                	jne    801fee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802032:	8b 55 08             	mov    0x8(%ebp),%edx
  802035:	8b 45 10             	mov    0x10(%ebp),%eax
  802038:	01 d0                	add    %edx,%eax
  80203a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80203d:	eb 15                	jmp    802054 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	8a 00                	mov    (%eax),%al
  802044:	0f b6 d0             	movzbl %al,%edx
  802047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204a:	0f b6 c0             	movzbl %al,%eax
  80204d:	39 c2                	cmp    %eax,%edx
  80204f:	74 0d                	je     80205e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802051:	ff 45 08             	incl   0x8(%ebp)
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80205a:	72 e3                	jb     80203f <memfind+0x13>
  80205c:	eb 01                	jmp    80205f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80205e:	90                   	nop
	return (void *) s;
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80206a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802071:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802078:	eb 03                	jmp    80207d <strtol+0x19>
		s++;
  80207a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8a 00                	mov    (%eax),%al
  802082:	3c 20                	cmp    $0x20,%al
  802084:	74 f4                	je     80207a <strtol+0x16>
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	3c 09                	cmp    $0x9,%al
  80208d:	74 eb                	je     80207a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	8a 00                	mov    (%eax),%al
  802094:	3c 2b                	cmp    $0x2b,%al
  802096:	75 05                	jne    80209d <strtol+0x39>
		s++;
  802098:	ff 45 08             	incl   0x8(%ebp)
  80209b:	eb 13                	jmp    8020b0 <strtol+0x4c>
	else if (*s == '-')
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8a 00                	mov    (%eax),%al
  8020a2:	3c 2d                	cmp    $0x2d,%al
  8020a4:	75 0a                	jne    8020b0 <strtol+0x4c>
		s++, neg = 1;
  8020a6:	ff 45 08             	incl   0x8(%ebp)
  8020a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b4:	74 06                	je     8020bc <strtol+0x58>
  8020b6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8020ba:	75 20                	jne    8020dc <strtol+0x78>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	3c 30                	cmp    $0x30,%al
  8020c3:	75 17                	jne    8020dc <strtol+0x78>
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	40                   	inc    %eax
  8020c9:	8a 00                	mov    (%eax),%al
  8020cb:	3c 78                	cmp    $0x78,%al
  8020cd:	75 0d                	jne    8020dc <strtol+0x78>
		s += 2, base = 16;
  8020cf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8020d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8020da:	eb 28                	jmp    802104 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8020dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e0:	75 15                	jne    8020f7 <strtol+0x93>
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	8a 00                	mov    (%eax),%al
  8020e7:	3c 30                	cmp    $0x30,%al
  8020e9:	75 0c                	jne    8020f7 <strtol+0x93>
		s++, base = 8;
  8020eb:	ff 45 08             	incl   0x8(%ebp)
  8020ee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8020f5:	eb 0d                	jmp    802104 <strtol+0xa0>
	else if (base == 0)
  8020f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fb:	75 07                	jne    802104 <strtol+0xa0>
		base = 10;
  8020fd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8a 00                	mov    (%eax),%al
  802109:	3c 2f                	cmp    $0x2f,%al
  80210b:	7e 19                	jle    802126 <strtol+0xc2>
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8a 00                	mov    (%eax),%al
  802112:	3c 39                	cmp    $0x39,%al
  802114:	7f 10                	jg     802126 <strtol+0xc2>
			dig = *s - '0';
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8a 00                	mov    (%eax),%al
  80211b:	0f be c0             	movsbl %al,%eax
  80211e:	83 e8 30             	sub    $0x30,%eax
  802121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802124:	eb 42                	jmp    802168 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8a 00                	mov    (%eax),%al
  80212b:	3c 60                	cmp    $0x60,%al
  80212d:	7e 19                	jle    802148 <strtol+0xe4>
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8a 00                	mov    (%eax),%al
  802134:	3c 7a                	cmp    $0x7a,%al
  802136:	7f 10                	jg     802148 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8a 00                	mov    (%eax),%al
  80213d:	0f be c0             	movsbl %al,%eax
  802140:	83 e8 57             	sub    $0x57,%eax
  802143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802146:	eb 20                	jmp    802168 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8a 00                	mov    (%eax),%al
  80214d:	3c 40                	cmp    $0x40,%al
  80214f:	7e 39                	jle    80218a <strtol+0x126>
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8a 00                	mov    (%eax),%al
  802156:	3c 5a                	cmp    $0x5a,%al
  802158:	7f 30                	jg     80218a <strtol+0x126>
			dig = *s - 'A' + 10;
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8a 00                	mov    (%eax),%al
  80215f:	0f be c0             	movsbl %al,%eax
  802162:	83 e8 37             	sub    $0x37,%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80216e:	7d 19                	jge    802189 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802170:	ff 45 08             	incl   0x8(%ebp)
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	0f af 45 10          	imul   0x10(%ebp),%eax
  80217a:	89 c2                	mov    %eax,%edx
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802184:	e9 7b ff ff ff       	jmp    802104 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802189:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80218a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80218e:	74 08                	je     802198 <strtol+0x134>
		*endptr = (char *) s;
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	8b 55 08             	mov    0x8(%ebp),%edx
  802196:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80219c:	74 07                	je     8021a5 <strtol+0x141>
  80219e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a1:	f7 d8                	neg    %eax
  8021a3:	eb 03                	jmp    8021a8 <strtol+0x144>
  8021a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <ltostr>:

void
ltostr(long value, char *str)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8021b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8021b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8021be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c2:	79 13                	jns    8021d7 <ltostr+0x2d>
	{
		neg = 1;
  8021c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8021cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8021d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8021d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021df:	99                   	cltd   
  8021e0:	f7 f9                	idiv   %ecx
  8021e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8021e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021e8:	8d 50 01             	lea    0x1(%eax),%edx
  8021eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021ee:	89 c2                	mov    %eax,%edx
  8021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f8:	83 c2 30             	add    $0x30,%edx
  8021fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8021fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802200:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802205:	f7 e9                	imul   %ecx
  802207:	c1 fa 02             	sar    $0x2,%edx
  80220a:	89 c8                	mov    %ecx,%eax
  80220c:	c1 f8 1f             	sar    $0x1f,%eax
  80220f:	29 c2                	sub    %eax,%edx
  802211:	89 d0                	mov    %edx,%eax
  802213:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802216:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802219:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80221e:	f7 e9                	imul   %ecx
  802220:	c1 fa 02             	sar    $0x2,%edx
  802223:	89 c8                	mov    %ecx,%eax
  802225:	c1 f8 1f             	sar    $0x1f,%eax
  802228:	29 c2                	sub    %eax,%edx
  80222a:	89 d0                	mov    %edx,%eax
  80222c:	c1 e0 02             	shl    $0x2,%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	01 c0                	add    %eax,%eax
  802233:	29 c1                	sub    %eax,%ecx
  802235:	89 ca                	mov    %ecx,%edx
  802237:	85 d2                	test   %edx,%edx
  802239:	75 9c                	jne    8021d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80223b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802242:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802245:	48                   	dec    %eax
  802246:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802249:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80224d:	74 3d                	je     80228c <ltostr+0xe2>
		start = 1 ;
  80224f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802256:	eb 34                	jmp    80228c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225e:	01 d0                	add    %edx,%eax
  802260:	8a 00                	mov    (%eax),%al
  802262:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	01 c2                	add    %eax,%edx
  80226d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	01 c8                	add    %ecx,%eax
  802275:	8a 00                	mov    (%eax),%al
  802277:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	01 c2                	add    %eax,%edx
  802281:	8a 45 eb             	mov    -0x15(%ebp),%al
  802284:	88 02                	mov    %al,(%edx)
		start++ ;
  802286:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802289:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802292:	7c c4                	jl     802258 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802294:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	01 d0                	add    %edx,%eax
  80229c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80229f:	90                   	nop
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022a8:	ff 75 08             	pushl  0x8(%ebp)
  8022ab:	e8 54 fa ff ff       	call   801d04 <strlen>
  8022b0:	83 c4 04             	add    $0x4,%esp
  8022b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022b6:	ff 75 0c             	pushl  0xc(%ebp)
  8022b9:	e8 46 fa ff ff       	call   801d04 <strlen>
  8022be:	83 c4 04             	add    $0x4,%esp
  8022c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8022c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8022cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022d2:	eb 17                	jmp    8022eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8022d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	01 c8                	add    %ecx,%eax
  8022e4:	8a 00                	mov    (%eax),%al
  8022e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8022e8:	ff 45 fc             	incl   -0x4(%ebp)
  8022eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022f1:	7c e1                	jl     8022d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8022f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8022fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802301:	eb 1f                	jmp    802322 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802303:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802306:	8d 50 01             	lea    0x1(%eax),%edx
  802309:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80230c:	89 c2                	mov    %eax,%edx
  80230e:	8b 45 10             	mov    0x10(%ebp),%eax
  802311:	01 c2                	add    %eax,%edx
  802313:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	01 c8                	add    %ecx,%eax
  80231b:	8a 00                	mov    (%eax),%al
  80231d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80231f:	ff 45 f8             	incl   -0x8(%ebp)
  802322:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802325:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802328:	7c d9                	jl     802303 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80232a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80232d:	8b 45 10             	mov    0x10(%ebp),%eax
  802330:	01 d0                	add    %edx,%eax
  802332:	c6 00 00             	movb   $0x0,(%eax)
}
  802335:	90                   	nop
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80233b:	8b 45 14             	mov    0x14(%ebp),%eax
  80233e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802344:	8b 45 14             	mov    0x14(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802350:	8b 45 10             	mov    0x10(%ebp),%eax
  802353:	01 d0                	add    %edx,%eax
  802355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80235b:	eb 0c                	jmp    802369 <strsplit+0x31>
			*string++ = 0;
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	8d 50 01             	lea    0x1(%eax),%edx
  802363:	89 55 08             	mov    %edx,0x8(%ebp)
  802366:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8a 00                	mov    (%eax),%al
  80236e:	84 c0                	test   %al,%al
  802370:	74 18                	je     80238a <strsplit+0x52>
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8a 00                	mov    (%eax),%al
  802377:	0f be c0             	movsbl %al,%eax
  80237a:	50                   	push   %eax
  80237b:	ff 75 0c             	pushl  0xc(%ebp)
  80237e:	e8 13 fb ff ff       	call   801e96 <strchr>
  802383:	83 c4 08             	add    $0x8,%esp
  802386:	85 c0                	test   %eax,%eax
  802388:	75 d3                	jne    80235d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	8a 00                	mov    (%eax),%al
  80238f:	84 c0                	test   %al,%al
  802391:	74 5a                	je     8023ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802393:	8b 45 14             	mov    0x14(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	83 f8 0f             	cmp    $0xf,%eax
  80239b:	75 07                	jne    8023a4 <strsplit+0x6c>
		{
			return 0;
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	eb 66                	jmp    80240a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8023ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8023af:	89 0a                	mov    %ecx,(%edx)
  8023b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023bb:	01 c2                	add    %eax,%edx
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023c2:	eb 03                	jmp    8023c7 <strsplit+0x8f>
			string++;
  8023c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8a 00                	mov    (%eax),%al
  8023cc:	84 c0                	test   %al,%al
  8023ce:	74 8b                	je     80235b <strsplit+0x23>
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8a 00                	mov    (%eax),%al
  8023d5:	0f be c0             	movsbl %al,%eax
  8023d8:	50                   	push   %eax
  8023d9:	ff 75 0c             	pushl  0xc(%ebp)
  8023dc:	e8 b5 fa ff ff       	call   801e96 <strchr>
  8023e1:	83 c4 08             	add    $0x8,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 dc                	je     8023c4 <strsplit+0x8c>
			string++;
	}
  8023e8:	e9 6e ff ff ff       	jmp    80235b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8023ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802405:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  802412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802419:	eb 4c                	jmp    802467 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80241b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80241e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802421:	01 d0                	add    %edx,%eax
  802423:	8a 00                	mov    (%eax),%al
  802425:	3c 40                	cmp    $0x40,%al
  802427:	7e 27                	jle    802450 <str2lower+0x44>
  802429:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	01 d0                	add    %edx,%eax
  802431:	8a 00                	mov    (%eax),%al
  802433:	3c 5a                	cmp    $0x5a,%al
  802435:	7f 19                	jg     802450 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  802437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802442:	8b 55 0c             	mov    0xc(%ebp),%edx
  802445:	01 ca                	add    %ecx,%edx
  802447:	8a 12                	mov    (%edx),%dl
  802449:	83 c2 20             	add    $0x20,%edx
  80244c:	88 10                	mov    %dl,(%eax)
  80244e:	eb 14                	jmp    802464 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  802450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	01 c2                	add    %eax,%edx
  802458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80245b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245e:	01 c8                	add    %ecx,%eax
  802460:	8a 00                	mov    (%eax),%al
  802462:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  802464:	ff 45 fc             	incl   -0x4(%ebp)
  802467:	ff 75 0c             	pushl  0xc(%ebp)
  80246a:	e8 95 f8 ff ff       	call   801d04 <strlen>
  80246f:	83 c4 04             	add    $0x4,%esp
  802472:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802475:	7f a4                	jg     80241b <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  802477:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	01 d0                	add    %edx,%eax
  80247f:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  80248a:	a1 28 50 80 00       	mov    0x805028,%eax
  80248f:	8b 55 08             	mov    0x8(%ebp),%edx
  802492:	89 14 c5 40 51 80 00 	mov    %edx,0x805140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  802499:	a1 28 50 80 00       	mov    0x805028,%eax
  80249e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a1:	89 14 c5 44 51 80 00 	mov    %edx,0x805144(,%eax,8)
	marked_pagessize++;
  8024a8:	a1 28 50 80 00       	mov    0x805028,%eax
  8024ad:	40                   	inc    %eax
  8024ae:	a3 28 50 80 00       	mov    %eax,0x805028
}
  8024b3:	90                   	nop
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    

008024b6 <searchElement>:

int searchElement(uint32 start) {
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8024bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024c3:	eb 17                	jmp    8024dc <searchElement+0x26>
		if (marked_pages[i].start == start) {
  8024c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c8:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  8024cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d2:	75 05                	jne    8024d9 <searchElement+0x23>
			return i;
  8024d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d7:	eb 12                	jmp    8024eb <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  8024d9:	ff 45 fc             	incl   -0x4(%ebp)
  8024dc:	a1 28 50 80 00       	mov    0x805028,%eax
  8024e1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8024e4:	7c df                	jl     8024c5 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  8024e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <removeElement>:
void removeElement(uint32 start) {
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  8024f3:	ff 75 08             	pushl  0x8(%ebp)
  8024f6:	e8 bb ff ff ff       	call   8024b6 <searchElement>
  8024fb:	83 c4 04             	add    $0x4,%esp
  8024fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  802501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802504:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802507:	eb 26                	jmp    80252f <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  802509:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80250c:	40                   	inc    %eax
  80250d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802510:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  802517:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  80251e:	89 04 cd 40 51 80 00 	mov    %eax,0x805140(,%ecx,8)
  802525:	89 14 cd 44 51 80 00 	mov    %edx,0x805144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  80252c:	ff 45 fc             	incl   -0x4(%ebp)
  80252f:	a1 28 50 80 00       	mov    0x805028,%eax
  802534:	48                   	dec    %eax
  802535:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802538:	7f cf                	jg     802509 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  80253a:	a1 28 50 80 00       	mov    0x805028,%eax
  80253f:	48                   	dec    %eax
  802540:	a3 28 50 80 00       	mov    %eax,0x805028
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <searchfree>:
int searchfree(uint32 end)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80254e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802555:	eb 17                	jmp    80256e <searchfree+0x26>
		if (marked_pages[i].end == end) {
  802557:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255a:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  802561:	3b 45 08             	cmp    0x8(%ebp),%eax
  802564:	75 05                	jne    80256b <searchfree+0x23>
			return i;
  802566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802569:	eb 12                	jmp    80257d <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  80256b:	ff 45 fc             	incl   -0x4(%ebp)
  80256e:	a1 28 50 80 00       	mov    0x805028,%eax
  802573:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  802576:	7c df                	jl     802557 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  802578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80257d:	c9                   	leave  
  80257e:	c3                   	ret    

0080257f <removefree>:
void removefree(uint32 end)
{
  80257f:	55                   	push   %ebp
  802580:	89 e5                	mov    %esp,%ebp
  802582:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  802585:	eb 52                	jmp    8025d9 <removefree+0x5a>
		int index = searchfree(end);
  802587:	ff 75 08             	pushl  0x8(%ebp)
  80258a:	e8 b9 ff ff ff       	call   802548 <searchfree>
  80258f:	83 c4 04             	add    $0x4,%esp
  802592:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  802595:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802598:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80259b:	eb 26                	jmp    8025c3 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  80259d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a0:	40                   	inc    %eax
  8025a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8025a4:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  8025ab:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  8025b2:	89 04 cd 40 51 80 00 	mov    %eax,0x805140(,%ecx,8)
  8025b9:	89 14 cd 44 51 80 00 	mov    %edx,0x805144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  8025c0:	ff 45 fc             	incl   -0x4(%ebp)
  8025c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8025c8:	48                   	dec    %eax
  8025c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025cc:	7f cf                	jg     80259d <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  8025ce:	a1 28 50 80 00       	mov    0x805028,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	a3 28 50 80 00       	mov    %eax,0x805028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  8025d9:	ff 75 08             	pushl  0x8(%ebp)
  8025dc:	e8 67 ff ff ff       	call   802548 <searchfree>
  8025e1:	83 c4 04             	add    $0x4,%esp
  8025e4:	83 f8 ff             	cmp    $0xffffffff,%eax
  8025e7:	75 9e                	jne    802587 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8025e9:	90                   	nop
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <printArray>:
void printArray() {
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8025f2:	83 ec 0c             	sub    $0xc,%esp
  8025f5:	68 b0 47 80 00       	push   $0x8047b0
  8025fa:	e8 83 f0 ff ff       	call   801682 <cprintf>
  8025ff:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  802602:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802609:	eb 29                	jmp    802634 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  80261f:	52                   	push   %edx
  802620:	50                   	push   %eax
  802621:	ff 75 f4             	pushl  -0xc(%ebp)
  802624:	68 c1 47 80 00       	push   $0x8047c1
  802629:	e8 54 f0 ff ff       	call   801682 <cprintf>
  80262e:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  802631:	ff 45 f4             	incl   -0xc(%ebp)
  802634:	a1 28 50 80 00       	mov    0x805028,%eax
  802639:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  80263c:	7c cd                	jl     80260b <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  80263e:	90                   	nop
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  802644:	a1 04 50 80 00       	mov    0x805004,%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 0a                	je     802657 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80264d:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802654:	00 00 00 
	}
}
  802657:	90                   	nop
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 08             	pushl  0x8(%ebp)
  802666:	e8 4f 09 00 00       	call   802fba <sys_sbrk>
  80266b:	83 c4 10             	add    $0x10,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802676:	e8 c6 ff ff ff       	call   802641 <InitializeUHeap>
	if (size == 0) return NULL ;
  80267b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267f:	75 0a                	jne    80268b <malloc+0x1b>
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
  802686:	e9 43 01 00 00       	jmp    8027ce <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80268b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802692:	77 3c                	ja     8026d0 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802694:	e8 c3 07 00 00       	call   802e5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 13                	je     8026b0 <malloc+0x40>
			return alloc_block_FF(size);
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	ff 75 08             	pushl  0x8(%ebp)
  8026a3:	e8 89 0b 00 00       	call   803231 <alloc_block_FF>
  8026a8:	83 c4 10             	add    $0x10,%esp
  8026ab:	e9 1e 01 00 00       	jmp    8027ce <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  8026b0:	e8 d8 07 00 00       	call   802e8d <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 0c 01 00 00    	je     8027c9 <malloc+0x159>
			return alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 7d 0e 00 00       	call   803545 <alloc_block_BF>
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	e9 fe 00 00 00       	jmp    8027ce <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  8026d0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dd:	01 d0                	add    %edx,%eax
  8026df:	48                   	dec    %eax
  8026e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026eb:	f7 75 e0             	divl   -0x20(%ebp)
  8026ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026f1:	29 d0                	sub    %edx,%eax
  8026f3:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	c1 e8 0c             	shr    $0xc,%eax
  8026fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  8026ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  802706:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  80270d:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  802714:	e8 f4 08 00 00       	call   80300d <sys_hard_limit>
  802719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80271c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271f:	05 00 10 00 00       	add    $0x1000,%eax
  802724:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802727:	eb 49                	jmp    802772 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  802729:	83 ec 0c             	sub    $0xc,%esp
  80272c:	ff 75 e8             	pushl  -0x18(%ebp)
  80272f:	e8 82 fd ff ff       	call   8024b6 <searchElement>
  802734:	83 c4 10             	add    $0x10,%esp
  802737:	83 f8 ff             	cmp    $0xffffffff,%eax
  80273a:	75 28                	jne    802764 <malloc+0xf4>
			{


				count++;
  80273c:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802745:	75 24                	jne    80276b <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  802747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274a:	05 00 10 00 00       	add    $0x1000,%eax
  80274f:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	c1 e0 0c             	shl    $0xc,%eax
  802758:	89 c2                	mov    %eax,%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	29 d0                	sub    %edx,%eax
  80275f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  802762:	eb 17                	jmp    80277b <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  802764:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80276b:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  802772:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802779:	76 ae                	jbe    802729 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  80277b:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  80277f:	75 07                	jne    802788 <malloc+0x118>
		{
			return NULL;
  802781:	b8 00 00 00 00       	mov    $0x0,%eax
  802786:	eb 46                	jmp    8027ce <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  802788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80278e:	eb 1a                	jmp    8027aa <malloc+0x13a>
		{
			addElement(i,end);
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802796:	83 ec 08             	sub    $0x8,%esp
  802799:	52                   	push   %edx
  80279a:	50                   	push   %eax
  80279b:	e8 e7 fc ff ff       	call   802487 <addElement>
  8027a0:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  8027a3:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027b0:	7c de                	jl     802790 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  8027b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b5:	83 ec 08             	sub    $0x8,%esp
  8027b8:	ff 75 08             	pushl  0x8(%ebp)
  8027bb:	50                   	push   %eax
  8027bc:	e8 30 08 00 00       	call   802ff1 <sys_allocate_user_mem>
  8027c1:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  8027c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c7:	eb 05                	jmp    8027ce <malloc+0x15e>
	}
	return NULL;
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax



}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  8027d6:	e8 32 08 00 00       	call   80300d <sys_hard_limit>
  8027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	0f 89 82 00 00 00    	jns    80286b <free+0x9b>
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8027f1:	77 78                	ja     80286b <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027f9:	73 10                	jae    80280b <free+0x3b>
			free_block(virtual_address);
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	ff 75 08             	pushl  0x8(%ebp)
  802801:	e8 d2 0e 00 00       	call   8036d8 <free_block>
  802806:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  802809:	eb 77                	jmp    802882 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	50                   	push   %eax
  802812:	e8 9f fc ff ff       	call   8024b6 <searchElement>
  802817:	83 c4 10             	add    $0x10,%esp
  80281a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	8b 14 c5 44 51 80 00 	mov    0x805144(,%eax,8),%edx
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 04 c5 40 51 80 00 	mov    0x805140(,%eax,8),%eax
  802831:	29 c2                	sub    %eax,%edx
  802833:	89 d0                	mov    %edx,%eax
  802835:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  802838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283b:	c1 e8 0c             	shr    $0xc,%eax
  80283e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	83 ec 08             	sub    $0x8,%esp
  802847:	ff 75 ec             	pushl  -0x14(%ebp)
  80284a:	50                   	push   %eax
  80284b:	e8 85 07 00 00       	call   802fd5 <sys_free_user_mem>
  802850:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 04 c5 44 51 80 00 	mov    0x805144(,%eax,8),%eax
  80285d:	83 ec 0c             	sub    $0xc,%esp
  802860:	50                   	push   %eax
  802861:	e8 19 fd ff ff       	call   80257f <removefree>
  802866:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  802869:	eb 17                	jmp    802882 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	68 da 47 80 00       	push   $0x8047da
  802873:	68 ac 00 00 00       	push   $0xac
  802878:	68 ea 47 80 00       	push   $0x8047ea
  80287d:	e8 43 eb ff ff       	call   8013c5 <_panic>
	}
}
  802882:	90                   	nop
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
  802888:	83 ec 18             	sub    $0x18,%esp
  80288b:	8b 45 10             	mov    0x10(%ebp),%eax
  80288e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802891:	e8 ab fd ff ff       	call   802641 <InitializeUHeap>
	if (size == 0) return NULL ;
  802896:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80289a:	75 07                	jne    8028a3 <smalloc+0x1e>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	eb 17                	jmp    8028ba <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	68 f8 47 80 00       	push   $0x8047f8
  8028ab:	68 bc 00 00 00       	push   $0xbc
  8028b0:	68 ea 47 80 00       	push   $0x8047ea
  8028b5:	e8 0b eb ff ff       	call   8013c5 <_panic>
	return NULL;
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028c2:	e8 7a fd ff ff       	call   802641 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	68 20 48 80 00       	push   $0x804820
  8028cf:	68 ca 00 00 00       	push   $0xca
  8028d4:	68 ea 47 80 00       	push   $0x8047ea
  8028d9:	e8 e7 ea ff ff       	call   8013c5 <_panic>

008028de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
  8028e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028e4:	e8 58 fd ff ff       	call   802641 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8028e9:	83 ec 04             	sub    $0x4,%esp
  8028ec:	68 44 48 80 00       	push   $0x804844
  8028f1:	68 ea 00 00 00       	push   $0xea
  8028f6:	68 ea 47 80 00       	push   $0x8047ea
  8028fb:	e8 c5 ea ff ff       	call   8013c5 <_panic>

00802900 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 6c 48 80 00       	push   $0x80486c
  80290e:	68 fe 00 00 00       	push   $0xfe
  802913:	68 ea 47 80 00       	push   $0x8047ea
  802918:	e8 a8 ea ff ff       	call   8013c5 <_panic>

0080291d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802923:	83 ec 04             	sub    $0x4,%esp
  802926:	68 90 48 80 00       	push   $0x804890
  80292b:	68 08 01 00 00       	push   $0x108
  802930:	68 ea 47 80 00       	push   $0x8047ea
  802935:	e8 8b ea ff ff       	call   8013c5 <_panic>

0080293a <shrink>:

}
void shrink(uint32 newSize)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 90 48 80 00       	push   $0x804890
  802948:	68 0d 01 00 00       	push   $0x10d
  80294d:	68 ea 47 80 00       	push   $0x8047ea
  802952:	e8 6e ea ff ff       	call   8013c5 <_panic>

00802957 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
  80295a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 90 48 80 00       	push   $0x804890
  802965:	68 12 01 00 00       	push   $0x112
  80296a:	68 ea 47 80 00       	push   $0x8047ea
  80296f:	e8 51 ea ff ff       	call   8013c5 <_panic>

00802974 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	57                   	push   %edi
  802978:	56                   	push   %esi
  802979:	53                   	push   %ebx
  80297a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8b 55 0c             	mov    0xc(%ebp),%edx
  802983:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802986:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802989:	8b 7d 18             	mov    0x18(%ebp),%edi
  80298c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80298f:	cd 30                	int    $0x30
  802991:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802997:	83 c4 10             	add    $0x10,%esp
  80299a:	5b                   	pop    %ebx
  80299b:	5e                   	pop    %esi
  80299c:	5f                   	pop    %edi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    

0080299f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	83 ec 04             	sub    $0x4,%esp
  8029a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	6a 00                	push   $0x0
  8029b4:	6a 00                	push   $0x0
  8029b6:	52                   	push   %edx
  8029b7:	ff 75 0c             	pushl  0xc(%ebp)
  8029ba:	50                   	push   %eax
  8029bb:	6a 00                	push   $0x0
  8029bd:	e8 b2 ff ff ff       	call   802974 <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	90                   	nop
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 01                	push   $0x1
  8029d7:	e8 98 ff ff ff       	call   802974 <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
}
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	52                   	push   %edx
  8029f1:	50                   	push   %eax
  8029f2:	6a 05                	push   $0x5
  8029f4:	e8 7b ff ff ff       	call   802974 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
  802a01:	56                   	push   %esi
  802a02:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a03:	8b 75 18             	mov    0x18(%ebp),%esi
  802a06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	51                   	push   %ecx
  802a15:	52                   	push   %edx
  802a16:	50                   	push   %eax
  802a17:	6a 06                	push   $0x6
  802a19:	e8 56 ff ff ff       	call   802974 <syscall>
  802a1e:	83 c4 18             	add    $0x18,%esp
}
  802a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a24:	5b                   	pop    %ebx
  802a25:	5e                   	pop    %esi
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    

00802a28 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	52                   	push   %edx
  802a38:	50                   	push   %eax
  802a39:	6a 07                	push   $0x7
  802a3b:	e8 34 ff ff ff       	call   802974 <syscall>
  802a40:	83 c4 18             	add    $0x18,%esp
}
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	ff 75 0c             	pushl  0xc(%ebp)
  802a51:	ff 75 08             	pushl  0x8(%ebp)
  802a54:	6a 08                	push   $0x8
  802a56:	e8 19 ff ff ff       	call   802974 <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
}
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    

00802a60 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 09                	push   $0x9
  802a6f:	e8 00 ff ff ff       	call   802974 <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 0a                	push   $0xa
  802a88:	e8 e7 fe ff ff       	call   802974 <syscall>
  802a8d:	83 c4 18             	add    $0x18,%esp
}
  802a90:	c9                   	leave  
  802a91:	c3                   	ret    

00802a92 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 0b                	push   $0xb
  802aa1:	e8 ce fe ff ff       	call   802974 <syscall>
  802aa6:	83 c4 18             	add    $0x18,%esp
}
  802aa9:	c9                   	leave  
  802aaa:	c3                   	ret    

00802aab <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802aab:	55                   	push   %ebp
  802aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 0c                	push   $0xc
  802aba:	e8 b5 fe ff ff       	call   802974 <syscall>
  802abf:	83 c4 18             	add    $0x18,%esp
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	ff 75 08             	pushl  0x8(%ebp)
  802ad2:	6a 0d                	push   $0xd
  802ad4:	e8 9b fe ff ff       	call   802974 <syscall>
  802ad9:	83 c4 18             	add    $0x18,%esp
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	6a 0e                	push   $0xe
  802aed:	e8 82 fe ff ff       	call   802974 <syscall>
  802af2:	83 c4 18             	add    $0x18,%esp
}
  802af5:	90                   	nop
  802af6:	c9                   	leave  
  802af7:	c3                   	ret    

00802af8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802af8:	55                   	push   %ebp
  802af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802afb:	6a 00                	push   $0x0
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 11                	push   $0x11
  802b07:	e8 68 fe ff ff       	call   802974 <syscall>
  802b0c:	83 c4 18             	add    $0x18,%esp
}
  802b0f:	90                   	nop
  802b10:	c9                   	leave  
  802b11:	c3                   	ret    

00802b12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b12:	55                   	push   %ebp
  802b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 00                	push   $0x0
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 12                	push   $0x12
  802b21:	e8 4e fe ff ff       	call   802974 <syscall>
  802b26:	83 c4 18             	add    $0x18,%esp
}
  802b29:	90                   	nop
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <sys_cputc>:


void
sys_cputc(const char c)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	83 ec 04             	sub    $0x4,%esp
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 00                	push   $0x0
  802b44:	50                   	push   %eax
  802b45:	6a 13                	push   $0x13
  802b47:	e8 28 fe ff ff       	call   802974 <syscall>
  802b4c:	83 c4 18             	add    $0x18,%esp
}
  802b4f:	90                   	nop
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    

00802b52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b52:	55                   	push   %ebp
  802b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 14                	push   $0x14
  802b61:	e8 0e fe ff ff       	call   802974 <syscall>
  802b66:	83 c4 18             	add    $0x18,%esp
}
  802b69:	90                   	nop
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	ff 75 0c             	pushl  0xc(%ebp)
  802b7b:	50                   	push   %eax
  802b7c:	6a 15                	push   $0x15
  802b7e:	e8 f1 fd ff ff       	call   802974 <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 00                	push   $0x0
  802b97:	52                   	push   %edx
  802b98:	50                   	push   %eax
  802b99:	6a 18                	push   $0x18
  802b9b:	e8 d4 fd ff ff       	call   802974 <syscall>
  802ba0:	83 c4 18             	add    $0x18,%esp
}
  802ba3:	c9                   	leave  
  802ba4:	c3                   	ret    

00802ba5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ba5:	55                   	push   %ebp
  802ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	52                   	push   %edx
  802bb5:	50                   	push   %eax
  802bb6:	6a 16                	push   $0x16
  802bb8:	e8 b7 fd ff ff       	call   802974 <syscall>
  802bbd:	83 c4 18             	add    $0x18,%esp
}
  802bc0:	90                   	nop
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	52                   	push   %edx
  802bd3:	50                   	push   %eax
  802bd4:	6a 17                	push   $0x17
  802bd6:	e8 99 fd ff ff       	call   802974 <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
}
  802bde:	90                   	nop
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	8b 45 10             	mov    0x10(%ebp),%eax
  802bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802bed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	6a 00                	push   $0x0
  802bf9:	51                   	push   %ecx
  802bfa:	52                   	push   %edx
  802bfb:	ff 75 0c             	pushl  0xc(%ebp)
  802bfe:	50                   	push   %eax
  802bff:	6a 19                	push   $0x19
  802c01:	e8 6e fd ff ff       	call   802974 <syscall>
  802c06:	83 c4 18             	add    $0x18,%esp
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	52                   	push   %edx
  802c1b:	50                   	push   %eax
  802c1c:	6a 1a                	push   $0x1a
  802c1e:	e8 51 fd ff ff       	call   802974 <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
}
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	51                   	push   %ecx
  802c39:	52                   	push   %edx
  802c3a:	50                   	push   %eax
  802c3b:	6a 1b                	push   $0x1b
  802c3d:	e8 32 fd ff ff       	call   802974 <syscall>
  802c42:	83 c4 18             	add    $0x18,%esp
}
  802c45:	c9                   	leave  
  802c46:	c3                   	ret    

00802c47 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802c47:	55                   	push   %ebp
  802c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	52                   	push   %edx
  802c57:	50                   	push   %eax
  802c58:	6a 1c                	push   $0x1c
  802c5a:	e8 15 fd ff ff       	call   802974 <syscall>
  802c5f:	83 c4 18             	add    $0x18,%esp
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 1d                	push   $0x1d
  802c73:	e8 fc fc ff ff       	call   802974 <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
}
  802c7b:	c9                   	leave  
  802c7c:	c3                   	ret    

00802c7d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	6a 00                	push   $0x0
  802c85:	ff 75 14             	pushl  0x14(%ebp)
  802c88:	ff 75 10             	pushl  0x10(%ebp)
  802c8b:	ff 75 0c             	pushl  0xc(%ebp)
  802c8e:	50                   	push   %eax
  802c8f:	6a 1e                	push   $0x1e
  802c91:	e8 de fc ff ff       	call   802974 <syscall>
  802c96:	83 c4 18             	add    $0x18,%esp
}
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

00802c9b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802c9b:	55                   	push   %ebp
  802c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	6a 00                	push   $0x0
  802ca3:	6a 00                	push   $0x0
  802ca5:	6a 00                	push   $0x0
  802ca7:	6a 00                	push   $0x0
  802ca9:	50                   	push   %eax
  802caa:	6a 1f                	push   $0x1f
  802cac:	e8 c3 fc ff ff       	call   802974 <syscall>
  802cb1:	83 c4 18             	add    $0x18,%esp
}
  802cb4:	90                   	nop
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

00802cb7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802cb7:	55                   	push   %ebp
  802cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	6a 00                	push   $0x0
  802cc5:	50                   	push   %eax
  802cc6:	6a 20                	push   $0x20
  802cc8:	e8 a7 fc ff ff       	call   802974 <syscall>
  802ccd:	83 c4 18             	add    $0x18,%esp
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 02                	push   $0x2
  802ce1:	e8 8e fc ff ff       	call   802974 <syscall>
  802ce6:	83 c4 18             	add    $0x18,%esp
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802cee:	6a 00                	push   $0x0
  802cf0:	6a 00                	push   $0x0
  802cf2:	6a 00                	push   $0x0
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 03                	push   $0x3
  802cfa:	e8 75 fc ff ff       	call   802974 <syscall>
  802cff:	83 c4 18             	add    $0x18,%esp
}
  802d02:	c9                   	leave  
  802d03:	c3                   	ret    

00802d04 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 04                	push   $0x4
  802d13:	e8 5c fc ff ff       	call   802974 <syscall>
  802d18:	83 c4 18             	add    $0x18,%esp
}
  802d1b:	c9                   	leave  
  802d1c:	c3                   	ret    

00802d1d <sys_exit_env>:


void sys_exit_env(void)
{
  802d1d:	55                   	push   %ebp
  802d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 00                	push   $0x0
  802d2a:	6a 21                	push   $0x21
  802d2c:	e8 43 fc ff ff       	call   802974 <syscall>
  802d31:	83 c4 18             	add    $0x18,%esp
}
  802d34:	90                   	nop
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
  802d3a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802d3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d40:	8d 50 04             	lea    0x4(%eax),%edx
  802d43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d46:	6a 00                	push   $0x0
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	52                   	push   %edx
  802d4d:	50                   	push   %eax
  802d4e:	6a 22                	push   $0x22
  802d50:	e8 1f fc ff ff       	call   802974 <syscall>
  802d55:	83 c4 18             	add    $0x18,%esp
	return result;
  802d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d61:	89 01                	mov    %eax,(%ecx)
  802d63:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	c9                   	leave  
  802d6a:	c2 04 00             	ret    $0x4

00802d6d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d70:	6a 00                	push   $0x0
  802d72:	6a 00                	push   $0x0
  802d74:	ff 75 10             	pushl  0x10(%ebp)
  802d77:	ff 75 0c             	pushl  0xc(%ebp)
  802d7a:	ff 75 08             	pushl  0x8(%ebp)
  802d7d:	6a 10                	push   $0x10
  802d7f:	e8 f0 fb ff ff       	call   802974 <syscall>
  802d84:	83 c4 18             	add    $0x18,%esp
	return ;
  802d87:	90                   	nop
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <sys_rcr2>:
uint32 sys_rcr2()
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 23                	push   $0x23
  802d99:	e8 d6 fb ff ff       	call   802974 <syscall>
  802d9e:	83 c4 18             	add    $0x18,%esp
}
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
  802da6:	83 ec 04             	sub    $0x4,%esp
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802daf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	50                   	push   %eax
  802dbc:	6a 24                	push   $0x24
  802dbe:	e8 b1 fb ff ff       	call   802974 <syscall>
  802dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  802dc6:	90                   	nop
}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <rsttst>:
void rsttst()
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 26                	push   $0x26
  802dd8:	e8 97 fb ff ff       	call   802974 <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  802de0:	90                   	nop
}
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	8b 45 14             	mov    0x14(%ebp),%eax
  802dec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802def:	8b 55 18             	mov    0x18(%ebp),%edx
  802df2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802df6:	52                   	push   %edx
  802df7:	50                   	push   %eax
  802df8:	ff 75 10             	pushl  0x10(%ebp)
  802dfb:	ff 75 0c             	pushl  0xc(%ebp)
  802dfe:	ff 75 08             	pushl  0x8(%ebp)
  802e01:	6a 25                	push   $0x25
  802e03:	e8 6c fb ff ff       	call   802974 <syscall>
  802e08:	83 c4 18             	add    $0x18,%esp
	return ;
  802e0b:	90                   	nop
}
  802e0c:	c9                   	leave  
  802e0d:	c3                   	ret    

00802e0e <chktst>:
void chktst(uint32 n)
{
  802e0e:	55                   	push   %ebp
  802e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	ff 75 08             	pushl  0x8(%ebp)
  802e1c:	6a 27                	push   $0x27
  802e1e:	e8 51 fb ff ff       	call   802974 <syscall>
  802e23:	83 c4 18             	add    $0x18,%esp
	return ;
  802e26:	90                   	nop
}
  802e27:	c9                   	leave  
  802e28:	c3                   	ret    

00802e29 <inctst>:

void inctst()
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 28                	push   $0x28
  802e38:	e8 37 fb ff ff       	call   802974 <syscall>
  802e3d:	83 c4 18             	add    $0x18,%esp
	return ;
  802e40:	90                   	nop
}
  802e41:	c9                   	leave  
  802e42:	c3                   	ret    

00802e43 <gettst>:
uint32 gettst()
{
  802e43:	55                   	push   %ebp
  802e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 29                	push   $0x29
  802e52:	e8 1d fb ff ff       	call   802974 <syscall>
  802e57:	83 c4 18             	add    $0x18,%esp
}
  802e5a:	c9                   	leave  
  802e5b:	c3                   	ret    

00802e5c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802e5c:	55                   	push   %ebp
  802e5d:	89 e5                	mov    %esp,%ebp
  802e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 2a                	push   $0x2a
  802e6e:	e8 01 fb ff ff       	call   802974 <syscall>
  802e73:	83 c4 18             	add    $0x18,%esp
  802e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802e79:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802e7d:	75 07                	jne    802e86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  802e84:	eb 05                	jmp    802e8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8b:	c9                   	leave  
  802e8c:	c3                   	ret    

00802e8d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802e8d:	55                   	push   %ebp
  802e8e:	89 e5                	mov    %esp,%ebp
  802e90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 2a                	push   $0x2a
  802e9f:	e8 d0 fa ff ff       	call   802974 <syscall>
  802ea4:	83 c4 18             	add    $0x18,%esp
  802ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802eaa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802eae:	75 07                	jne    802eb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802eb0:	b8 01 00 00 00       	mov    $0x1,%eax
  802eb5:	eb 05                	jmp    802ebc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 00                	push   $0x0
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 2a                	push   $0x2a
  802ed0:	e8 9f fa ff ff       	call   802974 <syscall>
  802ed5:	83 c4 18             	add    $0x18,%esp
  802ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802edb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802edf:	75 07                	jne    802ee8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  802ee6:	eb 05                	jmp    802eed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eed:	c9                   	leave  
  802eee:	c3                   	ret    

00802eef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802eef:	55                   	push   %ebp
  802ef0:	89 e5                	mov    %esp,%ebp
  802ef2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 2a                	push   $0x2a
  802f01:	e8 6e fa ff ff       	call   802974 <syscall>
  802f06:	83 c4 18             	add    $0x18,%esp
  802f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f0c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f10:	75 07                	jne    802f19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f12:	b8 01 00 00 00       	mov    $0x1,%eax
  802f17:	eb 05                	jmp    802f1e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	ff 75 08             	pushl  0x8(%ebp)
  802f2e:	6a 2b                	push   $0x2b
  802f30:	e8 3f fa ff ff       	call   802974 <syscall>
  802f35:	83 c4 18             	add    $0x18,%esp
	return ;
  802f38:	90                   	nop
}
  802f39:	c9                   	leave  
  802f3a:	c3                   	ret    

00802f3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
  802f3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	6a 00                	push   $0x0
  802f4d:	53                   	push   %ebx
  802f4e:	51                   	push   %ecx
  802f4f:	52                   	push   %edx
  802f50:	50                   	push   %eax
  802f51:	6a 2c                	push   $0x2c
  802f53:	e8 1c fa ff ff       	call   802974 <syscall>
  802f58:	83 c4 18             	add    $0x18,%esp
}
  802f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	52                   	push   %edx
  802f70:	50                   	push   %eax
  802f71:	6a 2d                	push   $0x2d
  802f73:	e8 fc f9 ff ff       	call   802974 <syscall>
  802f78:	83 c4 18             	add    $0x18,%esp
}
  802f7b:	c9                   	leave  
  802f7c:	c3                   	ret    

00802f7d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802f7d:	55                   	push   %ebp
  802f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802f80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	6a 00                	push   $0x0
  802f8b:	51                   	push   %ecx
  802f8c:	ff 75 10             	pushl  0x10(%ebp)
  802f8f:	52                   	push   %edx
  802f90:	50                   	push   %eax
  802f91:	6a 2e                	push   $0x2e
  802f93:	e8 dc f9 ff ff       	call   802974 <syscall>
  802f98:	83 c4 18             	add    $0x18,%esp
}
  802f9b:	c9                   	leave  
  802f9c:	c3                   	ret    

00802f9d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802fa0:	6a 00                	push   $0x0
  802fa2:	6a 00                	push   $0x0
  802fa4:	ff 75 10             	pushl  0x10(%ebp)
  802fa7:	ff 75 0c             	pushl  0xc(%ebp)
  802faa:	ff 75 08             	pushl  0x8(%ebp)
  802fad:	6a 0f                	push   $0xf
  802faf:	e8 c0 f9 ff ff       	call   802974 <syscall>
  802fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb7:	90                   	nop
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	50                   	push   %eax
  802fc9:	6a 2f                	push   $0x2f
  802fcb:	e8 a4 f9 ff ff       	call   802974 <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp

}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	ff 75 0c             	pushl  0xc(%ebp)
  802fe1:	ff 75 08             	pushl  0x8(%ebp)
  802fe4:	6a 30                	push   $0x30
  802fe6:	e8 89 f9 ff ff       	call   802974 <syscall>
  802feb:	83 c4 18             	add    $0x18,%esp

}
  802fee:	90                   	nop
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	ff 75 0c             	pushl  0xc(%ebp)
  802ffd:	ff 75 08             	pushl  0x8(%ebp)
  803000:	6a 31                	push   $0x31
  803002:	e8 6d f9 ff ff       	call   802974 <syscall>
  803007:	83 c4 18             	add    $0x18,%esp

}
  80300a:	90                   	nop
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    

0080300d <sys_hard_limit>:
uint32 sys_hard_limit(){
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	6a 00                	push   $0x0
  80301a:	6a 32                	push   $0x32
  80301c:	e8 53 f9 ff ff       	call   802974 <syscall>
  803021:	83 c4 18             	add    $0x18,%esp
}
  803024:	c9                   	leave  
  803025:	c3                   	ret    

00803026 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  803026:	55                   	push   %ebp
  803027:	89 e5                	mov    %esp,%ebp
  803029:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	83 e8 10             	sub    $0x10,%eax
  803032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  803035:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
  80303f:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	83 e8 10             	sub    $0x10,%eax
  803048:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  80304b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80304e:	8a 40 04             	mov    0x4(%eax),%al
}
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
  803056:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  803060:	8b 45 0c             	mov    0xc(%ebp),%eax
  803063:	83 f8 02             	cmp    $0x2,%eax
  803066:	74 2b                	je     803093 <alloc_block+0x40>
  803068:	83 f8 02             	cmp    $0x2,%eax
  80306b:	7f 07                	jg     803074 <alloc_block+0x21>
  80306d:	83 f8 01             	cmp    $0x1,%eax
  803070:	74 0e                	je     803080 <alloc_block+0x2d>
  803072:	eb 58                	jmp    8030cc <alloc_block+0x79>
  803074:	83 f8 03             	cmp    $0x3,%eax
  803077:	74 2d                	je     8030a6 <alloc_block+0x53>
  803079:	83 f8 04             	cmp    $0x4,%eax
  80307c:	74 3b                	je     8030b9 <alloc_block+0x66>
  80307e:	eb 4c                	jmp    8030cc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  803080:	83 ec 0c             	sub    $0xc,%esp
  803083:	ff 75 08             	pushl  0x8(%ebp)
  803086:	e8 a6 01 00 00       	call   803231 <alloc_block_FF>
  80308b:	83 c4 10             	add    $0x10,%esp
  80308e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803091:	eb 4a                	jmp    8030dd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  803093:	83 ec 0c             	sub    $0xc,%esp
  803096:	ff 75 08             	pushl  0x8(%ebp)
  803099:	e8 1d 06 00 00       	call   8036bb <alloc_block_NF>
  80309e:	83 c4 10             	add    $0x10,%esp
  8030a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8030a4:	eb 37                	jmp    8030dd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8030a6:	83 ec 0c             	sub    $0xc,%esp
  8030a9:	ff 75 08             	pushl  0x8(%ebp)
  8030ac:	e8 94 04 00 00       	call   803545 <alloc_block_BF>
  8030b1:	83 c4 10             	add    $0x10,%esp
  8030b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8030b7:	eb 24                	jmp    8030dd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8030b9:	83 ec 0c             	sub    $0xc,%esp
  8030bc:	ff 75 08             	pushl  0x8(%ebp)
  8030bf:	e8 da 05 00 00       	call   80369e <alloc_block_WF>
  8030c4:	83 c4 10             	add    $0x10,%esp
  8030c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8030ca:	eb 11                	jmp    8030dd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8030cc:	83 ec 0c             	sub    $0xc,%esp
  8030cf:	68 a0 48 80 00       	push   $0x8048a0
  8030d4:	e8 a9 e5 ff ff       	call   801682 <cprintf>
  8030d9:	83 c4 10             	add    $0x10,%esp
		break;
  8030dc:	90                   	nop
	}
	return va;
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    

008030e2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8030e2:	55                   	push   %ebp
  8030e3:	89 e5                	mov    %esp,%ebp
  8030e5:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8030e8:	83 ec 0c             	sub    $0xc,%esp
  8030eb:	68 c0 48 80 00       	push   $0x8048c0
  8030f0:	e8 8d e5 ff ff       	call   801682 <cprintf>
  8030f5:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8030f8:	83 ec 0c             	sub    $0xc,%esp
  8030fb:	68 eb 48 80 00       	push   $0x8048eb
  803100:	e8 7d e5 ff ff       	call   801682 <cprintf>
  803105:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310e:	eb 26                	jmp    803136 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8a 40 04             	mov    0x4(%eax),%al
  803116:	0f b6 d0             	movzbl %al,%edx
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	52                   	push   %edx
  803122:	50                   	push   %eax
  803123:	68 03 49 80 00       	push   $0x804903
  803128:	e8 55 e5 ff ff       	call   801682 <cprintf>
  80312d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803130:	8b 45 10             	mov    0x10(%ebp),%eax
  803133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313a:	74 08                	je     803144 <print_blocks_list+0x62>
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 40 08             	mov    0x8(%eax),%eax
  803142:	eb 05                	jmp    803149 <print_blocks_list+0x67>
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
  803149:	89 45 10             	mov    %eax,0x10(%ebp)
  80314c:	8b 45 10             	mov    0x10(%ebp),%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 bd                	jne    803110 <print_blocks_list+0x2e>
  803153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803157:	75 b7                	jne    803110 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  803159:	83 ec 0c             	sub    $0xc,%esp
  80315c:	68 c0 48 80 00       	push   $0x8048c0
  803161:	e8 1c e5 ff ff       	call   801682 <cprintf>
  803166:	83 c4 10             	add    $0x10,%esp

}
  803169:	90                   	nop
  80316a:	c9                   	leave  
  80316b:	c3                   	ret    

0080316c <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80316c:	55                   	push   %ebp
  80316d:	89 e5                	mov    %esp,%ebp
  80316f:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  803172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803176:	0f 84 b2 00 00 00    	je     80322e <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  80317c:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  803183:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  803186:	c7 05 14 51 80 00 00 	movl   $0x0,0x805114
  80318d:	00 00 00 
  803190:	c7 05 18 51 80 00 00 	movl   $0x0,0x805118
  803197:	00 00 00 
  80319a:	c7 05 20 51 80 00 00 	movl   $0x0,0x805120
  8031a1:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	a3 24 51 80 00       	mov    %eax,0x805124
		firstBlock->size = initSizeOfAllocatedSpace;
  8031ac:	a1 24 51 80 00       	mov    0x805124,%eax
  8031b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b4:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  8031b6:	a1 24 51 80 00       	mov    0x805124,%eax
  8031bb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  8031bf:	a1 24 51 80 00       	mov    0x805124,%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	75 14                	jne    8031dc <initialize_dynamic_allocator+0x70>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 1c 49 80 00       	push   $0x80491c
  8031d0:	6a 68                	push   $0x68
  8031d2:	68 3f 49 80 00       	push   $0x80493f
  8031d7:	e8 e9 e1 ff ff       	call   8013c5 <_panic>
  8031dc:	a1 24 51 80 00       	mov    0x805124,%eax
  8031e1:	8b 15 14 51 80 00    	mov    0x805114,%edx
  8031e7:	89 50 08             	mov    %edx,0x8(%eax)
  8031ea:	8b 40 08             	mov    0x8(%eax),%eax
  8031ed:	85 c0                	test   %eax,%eax
  8031ef:	74 10                	je     803201 <initialize_dynamic_allocator+0x95>
  8031f1:	a1 14 51 80 00       	mov    0x805114,%eax
  8031f6:	8b 15 24 51 80 00    	mov    0x805124,%edx
  8031fc:	89 50 0c             	mov    %edx,0xc(%eax)
  8031ff:	eb 0a                	jmp    80320b <initialize_dynamic_allocator+0x9f>
  803201:	a1 24 51 80 00       	mov    0x805124,%eax
  803206:	a3 18 51 80 00       	mov    %eax,0x805118
  80320b:	a1 24 51 80 00       	mov    0x805124,%eax
  803210:	a3 14 51 80 00       	mov    %eax,0x805114
  803215:	a1 24 51 80 00       	mov    0x805124,%eax
  80321a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803221:	a1 20 51 80 00       	mov    0x805120,%eax
  803226:	40                   	inc    %eax
  803227:	a3 20 51 80 00       	mov    %eax,0x805120
  80322c:	eb 01                	jmp    80322f <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80322e:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
  803234:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  803237:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323c:	85 c0                	test   %eax,%eax
  80323e:	75 40                	jne    803280 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	83 c0 10             	add    $0x10,%eax
  803246:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	83 ec 0c             	sub    $0xc,%esp
  80324f:	50                   	push   %eax
  803250:	e8 05 f4 ff ff       	call   80265a <sbrk>
  803255:	83 c4 10             	add    $0x10,%esp
  803258:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  80325b:	83 ec 0c             	sub    $0xc,%esp
  80325e:	6a 00                	push   $0x0
  803260:	e8 f5 f3 ff ff       	call   80265a <sbrk>
  803265:	83 c4 10             	add    $0x10,%esp
  803268:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803271:	83 ec 08             	sub    $0x8,%esp
  803274:	50                   	push   %eax
  803275:	ff 75 ec             	pushl  -0x14(%ebp)
  803278:	e8 ef fe ff ff       	call   80316c <initialize_dynamic_allocator>
  80327d:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  803280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803284:	75 0a                	jne    803290 <alloc_block_FF+0x5f>
		 return NULL;
  803286:	b8 00 00 00 00       	mov    $0x0,%eax
  80328b:	e9 b3 02 00 00       	jmp    803543 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  803290:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  803294:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  80329b:	a1 14 51 80 00       	mov    0x805114,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a3:	e9 12 01 00 00       	jmp    8033ba <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8a 40 04             	mov    0x4(%eax),%al
  8032ae:	84 c0                	test   %al,%al
  8032b0:	0f 84 fc 00 00 00    	je     8033b2 <alloc_block_FF+0x181>
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032be:	0f 82 ee 00 00 00    	jb     8033b2 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032cc:	75 12                	jne    8032e0 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	83 c0 10             	add    $0x10,%eax
  8032db:	e9 63 02 00 00       	jmp    803543 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  8032e0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8032f6:	83 f8 0f             	cmp    $0xf,%eax
  8032f9:	0f 86 a8 00 00 00    	jbe    8033a7 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  8032ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	01 d0                	add    %edx,%eax
  803307:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	2b 45 08             	sub    0x8(%ebp),%eax
  803312:	89 c2                	mov    %eax,%edx
  803314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803317:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	8b 55 08             	mov    0x8(%ebp),%edx
  80331f:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  803321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803324:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  803328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332c:	74 06                	je     803334 <alloc_block_FF+0x103>
  80332e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803332:	75 17                	jne    80334b <alloc_block_FF+0x11a>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 58 49 80 00       	push   $0x804958
  80333c:	68 91 00 00 00       	push   $0x91
  803341:	68 3f 49 80 00       	push   $0x80493f
  803346:	e8 7a e0 ff ff       	call   8013c5 <_panic>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 50 08             	mov    0x8(%eax),%edx
  803351:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803354:	89 50 08             	mov    %edx,0x8(%eax)
  803357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335a:	8b 40 08             	mov    0x8(%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 0c                	je     80336d <alloc_block_FF+0x13c>
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 40 08             	mov    0x8(%eax),%eax
  803367:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80336a:	89 50 0c             	mov    %edx,0xc(%eax)
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803373:	89 50 08             	mov    %edx,0x8(%eax)
  803376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337c:	89 50 0c             	mov    %edx,0xc(%eax)
  80337f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803382:	8b 40 08             	mov    0x8(%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	75 08                	jne    803391 <alloc_block_FF+0x160>
  803389:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80338c:	a3 18 51 80 00       	mov    %eax,0x805118
  803391:	a1 20 51 80 00       	mov    0x805120,%eax
  803396:	40                   	inc    %eax
  803397:	a3 20 51 80 00       	mov    %eax,0x805120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	83 c0 10             	add    $0x10,%eax
  8033a2:	e9 9c 01 00 00       	jmp    803543 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	83 c0 10             	add    $0x10,%eax
  8033ad:	e9 91 01 00 00       	jmp    803543 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  8033b2:	a1 1c 51 80 00       	mov    0x80511c,%eax
  8033b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033be:	74 08                	je     8033c8 <alloc_block_FF+0x197>
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 40 08             	mov    0x8(%eax),%eax
  8033c6:	eb 05                	jmp    8033cd <alloc_block_FF+0x19c>
  8033c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cd:	a3 1c 51 80 00       	mov    %eax,0x80511c
  8033d2:	a1 1c 51 80 00       	mov    0x80511c,%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	0f 85 c9 fe ff ff    	jne    8032a8 <alloc_block_FF+0x77>
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	0f 85 bf fe ff ff    	jne    8032a8 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  8033e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033ed:	0f 85 4b 01 00 00    	jne    80353e <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	83 ec 0c             	sub    $0xc,%esp
  8033f9:	50                   	push   %eax
  8033fa:	e8 5b f2 ff ff       	call   80265a <sbrk>
  8033ff:	83 c4 10             	add    $0x10,%esp
  803402:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  803405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803409:	0f 84 28 01 00 00    	je     803537 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  803415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803418:	8b 55 08             	mov    0x8(%ebp),%edx
  80341b:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  80341d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803420:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  803424:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803428:	75 17                	jne    803441 <alloc_block_FF+0x210>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 8c 49 80 00       	push   $0x80498c
  803432:	68 a1 00 00 00       	push   $0xa1
  803437:	68 3f 49 80 00       	push   $0x80493f
  80343c:	e8 84 df ff ff       	call   8013c5 <_panic>
  803441:	8b 15 18 51 80 00    	mov    0x805118,%edx
  803447:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344a:	89 50 0c             	mov    %edx,0xc(%eax)
  80344d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803450:	8b 40 0c             	mov    0xc(%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0d                	je     803464 <alloc_block_FF+0x233>
  803457:	a1 18 51 80 00       	mov    0x805118,%eax
  80345c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80345f:	89 50 08             	mov    %edx,0x8(%eax)
  803462:	eb 08                	jmp    80346c <alloc_block_FF+0x23b>
  803464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803467:	a3 14 51 80 00       	mov    %eax,0x805114
  80346c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346f:	a3 18 51 80 00       	mov    %eax,0x805118
  803474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803477:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80347e:	a1 20 51 80 00       	mov    0x805120,%eax
  803483:	40                   	inc    %eax
  803484:	a3 20 51 80 00       	mov    %eax,0x805120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  803489:	b8 00 10 00 00       	mov    $0x1000,%eax
  80348e:	2b 45 08             	sub    0x8(%ebp),%eax
  803491:	83 f8 0f             	cmp    $0xf,%eax
  803494:	0f 86 95 00 00 00    	jbe    80352f <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  80349a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  8034a5:	b8 00 10 00 00       	mov    $0x1000,%eax
  8034aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8034ad:	89 c2                	mov    %eax,%edx
  8034af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b2:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  8034b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b7:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  8034bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034bf:	74 06                	je     8034c7 <alloc_block_FF+0x296>
  8034c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034c5:	75 17                	jne    8034de <alloc_block_FF+0x2ad>
  8034c7:	83 ec 04             	sub    $0x4,%esp
  8034ca:	68 58 49 80 00       	push   $0x804958
  8034cf:	68 a6 00 00 00       	push   $0xa6
  8034d4:	68 3f 49 80 00       	push   $0x80493f
  8034d9:	e8 e7 de ff ff       	call   8013c5 <_panic>
  8034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e1:	8b 50 08             	mov    0x8(%eax),%edx
  8034e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034e7:	89 50 08             	mov    %edx,0x8(%eax)
  8034ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 0c                	je     803500 <alloc_block_FF+0x2cf>
  8034f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f7:	8b 40 08             	mov    0x8(%eax),%eax
  8034fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034fd:	89 50 0c             	mov    %edx,0xc(%eax)
  803500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803503:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803506:	89 50 08             	mov    %edx,0x8(%eax)
  803509:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80350f:	89 50 0c             	mov    %edx,0xc(%eax)
  803512:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803515:	8b 40 08             	mov    0x8(%eax),%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	75 08                	jne    803524 <alloc_block_FF+0x2f3>
  80351c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351f:	a3 18 51 80 00       	mov    %eax,0x805118
  803524:	a1 20 51 80 00       	mov    0x805120,%eax
  803529:	40                   	inc    %eax
  80352a:	a3 20 51 80 00       	mov    %eax,0x805120
			 }
			 return (sb + 1);
  80352f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803532:	83 c0 10             	add    $0x10,%eax
  803535:	eb 0c                	jmp    803543 <alloc_block_FF+0x312>
		 }
		 return NULL;
  803537:	b8 00 00 00 00       	mov    $0x0,%eax
  80353c:	eb 05                	jmp    803543 <alloc_block_FF+0x312>
	 }
	 return NULL;
  80353e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803543:	c9                   	leave  
  803544:	c3                   	ret    

00803545 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803545:	55                   	push   %ebp
  803546:	89 e5                	mov    %esp,%ebp
  803548:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  80354b:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  80354f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  803556:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  80355d:	a1 14 51 80 00       	mov    0x805114,%eax
  803562:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803565:	eb 34                	jmp    80359b <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  803567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356a:	8a 40 04             	mov    0x4(%eax),%al
  80356d:	84 c0                	test   %al,%al
  80356f:	74 22                	je     803593 <alloc_block_BF+0x4e>
  803571:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	3b 45 08             	cmp    0x8(%ebp),%eax
  803579:	72 18                	jb     803593 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  80357b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803583:	73 0e                	jae    803593 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  803585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803588:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  80358b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  803593:	a1 1c 51 80 00       	mov    0x80511c,%eax
  803598:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80359b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80359f:	74 08                	je     8035a9 <alloc_block_BF+0x64>
  8035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a4:	8b 40 08             	mov    0x8(%eax),%eax
  8035a7:	eb 05                	jmp    8035ae <alloc_block_BF+0x69>
  8035a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ae:	a3 1c 51 80 00       	mov    %eax,0x80511c
  8035b3:	a1 1c 51 80 00       	mov    0x80511c,%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	75 ab                	jne    803567 <alloc_block_BF+0x22>
  8035bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035c0:	75 a5                	jne    803567 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  8035c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c6:	0f 84 cb 00 00 00    	je     803697 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035db:	0f 86 ae 00 00 00    	jbe    80368f <alloc_block_BF+0x14a>
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8035e9:	83 f8 0f             	cmp    $0xf,%eax
  8035ec:	0f 86 9d 00 00 00    	jbe    80368f <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8035f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	01 d0                	add    %edx,%eax
  8035fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 00                	mov    (%eax),%eax
  803602:	2b 45 08             	sub    0x8(%ebp),%eax
  803605:	89 c2                	mov    %eax,%edx
  803607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360a:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  80360c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 55 08             	mov    0x8(%ebp),%edx
  803619:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  80361b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361f:	74 06                	je     803627 <alloc_block_BF+0xe2>
  803621:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803625:	75 17                	jne    80363e <alloc_block_BF+0xf9>
  803627:	83 ec 04             	sub    $0x4,%esp
  80362a:	68 58 49 80 00       	push   $0x804958
  80362f:	68 c6 00 00 00       	push   $0xc6
  803634:	68 3f 49 80 00       	push   $0x80493f
  803639:	e8 87 dd ff ff       	call   8013c5 <_panic>
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 50 08             	mov    0x8(%eax),%edx
  803644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803647:	89 50 08             	mov    %edx,0x8(%eax)
  80364a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364d:	8b 40 08             	mov    0x8(%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	74 0c                	je     803660 <alloc_block_BF+0x11b>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 40 08             	mov    0x8(%eax),%eax
  80365a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365d:	89 50 0c             	mov    %edx,0xc(%eax)
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803666:	89 50 08             	mov    %edx,0x8(%eax)
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80366f:	89 50 0c             	mov    %edx,0xc(%eax)
  803672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803675:	8b 40 08             	mov    0x8(%eax),%eax
  803678:	85 c0                	test   %eax,%eax
  80367a:	75 08                	jne    803684 <alloc_block_BF+0x13f>
  80367c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367f:	a3 18 51 80 00       	mov    %eax,0x805118
  803684:	a1 20 51 80 00       	mov    0x805120,%eax
  803689:	40                   	inc    %eax
  80368a:	a3 20 51 80 00       	mov    %eax,0x805120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	83 c0 10             	add    $0x10,%eax
  803695:	eb 05                	jmp    80369c <alloc_block_BF+0x157>
    }

    return NULL;
  803697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80369c:	c9                   	leave  
  80369d:	c3                   	ret    

0080369e <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80369e:	55                   	push   %ebp
  80369f:	89 e5                	mov    %esp,%ebp
  8036a1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036a4:	83 ec 04             	sub    $0x4,%esp
  8036a7:	68 b0 49 80 00       	push   $0x8049b0
  8036ac:	68 d2 00 00 00       	push   $0xd2
  8036b1:	68 3f 49 80 00       	push   $0x80493f
  8036b6:	e8 0a dd ff ff       	call   8013c5 <_panic>

008036bb <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036bb:	55                   	push   %ebp
  8036bc:	89 e5                	mov    %esp,%ebp
  8036be:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	68 d8 49 80 00       	push   $0x8049d8
  8036c9:	68 db 00 00 00       	push   $0xdb
  8036ce:	68 3f 49 80 00       	push   $0x80493f
  8036d3:	e8 ed dc ff ff       	call   8013c5 <_panic>

008036d8 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  8036d8:	55                   	push   %ebp
  8036d9:	89 e5                	mov    %esp,%ebp
  8036db:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  8036de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e2:	0f 84 d2 01 00 00    	je     8038ba <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	83 e8 10             	sub    $0x10,%eax
  8036ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8a 40 04             	mov    0x4(%eax),%al
  8036f7:	84 c0                	test   %al,%al
  8036f9:	0f 85 be 01 00 00    	jne    8038bd <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	8b 40 08             	mov    0x8(%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	0f 84 cc 00 00 00    	je     8037e0 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	8b 40 08             	mov    0x8(%eax),%eax
  80371a:	8a 40 04             	mov    0x4(%eax),%al
  80371d:	84 c0                	test   %al,%al
  80371f:	0f 84 bb 00 00 00    	je     8037e0 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 10                	mov    (%eax),%edx
  80372a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372d:	8b 40 08             	mov    0x8(%eax),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	01 c2                	add    %eax,%edx
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 40 08             	mov    0x8(%eax),%eax
  80373f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 40 08             	mov    0x8(%eax),%eax
  803749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  80374f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803752:	8b 40 08             	mov    0x8(%eax),%eax
  803755:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  803758:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80375c:	75 17                	jne    803775 <free_block+0x9d>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 fe 49 80 00       	push   $0x8049fe
  803766:	68 f8 00 00 00       	push   $0xf8
  80376b:	68 3f 49 80 00       	push   $0x80493f
  803770:	e8 50 dc ff ff       	call   8013c5 <_panic>
  803775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803778:	8b 40 08             	mov    0x8(%eax),%eax
  80377b:	85 c0                	test   %eax,%eax
  80377d:	74 11                	je     803790 <free_block+0xb8>
  80377f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803782:	8b 40 08             	mov    0x8(%eax),%eax
  803785:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803788:	8b 52 0c             	mov    0xc(%edx),%edx
  80378b:	89 50 0c             	mov    %edx,0xc(%eax)
  80378e:	eb 0b                	jmp    80379b <free_block+0xc3>
  803790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803793:	8b 40 0c             	mov    0xc(%eax),%eax
  803796:	a3 18 51 80 00       	mov    %eax,0x805118
  80379b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379e:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 11                	je     8037b6 <free_block+0xde>
  8037a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037ae:	8b 52 08             	mov    0x8(%edx),%edx
  8037b1:	89 50 08             	mov    %edx,0x8(%eax)
  8037b4:	eb 0b                	jmp    8037c1 <free_block+0xe9>
  8037b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b9:	8b 40 08             	mov    0x8(%eax),%eax
  8037bc:	a3 14 51 80 00       	mov    %eax,0x805114
  8037c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8037d5:	a1 20 51 80 00       	mov    0x805120,%eax
  8037da:	48                   	dec    %eax
  8037db:	a3 20 51 80 00       	mov    %eax,0x805120
				}
			}
			if( LIST_PREV(block))
  8037e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	0f 84 d0 00 00 00    	je     8038be <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  8037ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f4:	8a 40 04             	mov    0x4(%eax),%al
  8037f7:	84 c0                	test   %al,%al
  8037f9:	0f 84 bf 00 00 00    	je     8038be <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  8037ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803802:	8b 40 0c             	mov    0xc(%eax),%eax
  803805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803808:	8b 52 0c             	mov    0xc(%edx),%edx
  80380b:	8b 0a                	mov    (%edx),%ecx
  80380d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803810:	8b 12                	mov    (%edx),%edx
  803812:	01 ca                	add    %ecx,%edx
  803814:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	8b 40 0c             	mov    0xc(%eax),%eax
  80381c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  803830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803834:	75 17                	jne    80384d <free_block+0x175>
  803836:	83 ec 04             	sub    $0x4,%esp
  803839:	68 fe 49 80 00       	push   $0x8049fe
  80383e:	68 03 01 00 00       	push   $0x103
  803843:	68 3f 49 80 00       	push   $0x80493f
  803848:	e8 78 db ff ff       	call   8013c5 <_panic>
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 08             	mov    0x8(%eax),%eax
  803853:	85 c0                	test   %eax,%eax
  803855:	74 11                	je     803868 <free_block+0x190>
  803857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385a:	8b 40 08             	mov    0x8(%eax),%eax
  80385d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803860:	8b 52 0c             	mov    0xc(%edx),%edx
  803863:	89 50 0c             	mov    %edx,0xc(%eax)
  803866:	eb 0b                	jmp    803873 <free_block+0x19b>
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	8b 40 0c             	mov    0xc(%eax),%eax
  80386e:	a3 18 51 80 00       	mov    %eax,0x805118
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 40 0c             	mov    0xc(%eax),%eax
  803879:	85 c0                	test   %eax,%eax
  80387b:	74 11                	je     80388e <free_block+0x1b6>
  80387d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803880:	8b 40 0c             	mov    0xc(%eax),%eax
  803883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803886:	8b 52 08             	mov    0x8(%edx),%edx
  803889:	89 50 08             	mov    %edx,0x8(%eax)
  80388c:	eb 0b                	jmp    803899 <free_block+0x1c1>
  80388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803891:	8b 40 08             	mov    0x8(%eax),%eax
  803894:	a3 14 51 80 00       	mov    %eax,0x805114
  803899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8038ad:	a1 20 51 80 00       	mov    0x805120,%eax
  8038b2:	48                   	dec    %eax
  8038b3:	a3 20 51 80 00       	mov    %eax,0x805120
  8038b8:	eb 04                	jmp    8038be <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  8038ba:	90                   	nop
  8038bb:	eb 01                	jmp    8038be <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  8038bd:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  8038be:	c9                   	leave  
  8038bf:	c3                   	ret    

008038c0 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8038c0:	55                   	push   %ebp
  8038c1:	89 e5                	mov    %esp,%ebp
  8038c3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  8038c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ca:	75 10                	jne    8038dc <realloc_block_FF+0x1c>
  8038cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038d0:	75 0a                	jne    8038dc <realloc_block_FF+0x1c>
	 {
		 return NULL;
  8038d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d7:	e9 2e 03 00 00       	jmp    803c0a <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  8038dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e0:	75 13                	jne    8038f5 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  8038e2:	83 ec 0c             	sub    $0xc,%esp
  8038e5:	ff 75 0c             	pushl  0xc(%ebp)
  8038e8:	e8 44 f9 ff ff       	call   803231 <alloc_block_FF>
  8038ed:	83 c4 10             	add    $0x10,%esp
  8038f0:	e9 15 03 00 00       	jmp    803c0a <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  8038f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038f9:	75 18                	jne    803913 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  8038fb:	83 ec 0c             	sub    $0xc,%esp
  8038fe:	ff 75 08             	pushl  0x8(%ebp)
  803901:	e8 d2 fd ff ff       	call   8036d8 <free_block>
  803906:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  803909:	b8 00 00 00 00       	mov    $0x0,%eax
  80390e:	e9 f7 02 00 00       	jmp    803c0a <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	83 e8 10             	sub    $0x10,%eax
  803919:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  80391c:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803928:	0f 82 c8 00 00 00    	jb     8039f6 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  80392e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803936:	75 08                	jne    803940 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	e9 ca 02 00 00       	jmp    803c0a <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	2b 45 0c             	sub    0xc(%ebp),%eax
  803948:	83 f8 0f             	cmp    $0xf,%eax
  80394b:	0f 86 9d 00 00 00    	jbe    8039ee <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803954:	8b 45 0c             	mov    0xc(%ebp),%eax
  803957:	01 d0                	add    %edx,%eax
  803959:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	2b 45 0c             	sub    0xc(%ebp),%eax
  803964:	89 c2                	mov    %eax,%edx
  803966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803969:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  80396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803971:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  803973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803976:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  80397a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80397e:	74 06                	je     803986 <realloc_block_FF+0xc6>
  803980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803984:	75 17                	jne    80399d <realloc_block_FF+0xdd>
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 58 49 80 00       	push   $0x804958
  80398e:	68 2a 01 00 00       	push   $0x12a
  803993:	68 3f 49 80 00       	push   $0x80493f
  803998:	e8 28 da ff ff       	call   8013c5 <_panic>
  80399d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a0:	8b 50 08             	mov    0x8(%eax),%edx
  8039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a6:	89 50 08             	mov    %edx,0x8(%eax)
  8039a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ac:	8b 40 08             	mov    0x8(%eax),%eax
  8039af:	85 c0                	test   %eax,%eax
  8039b1:	74 0c                	je     8039bf <realloc_block_FF+0xff>
  8039b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b6:	8b 40 08             	mov    0x8(%eax),%eax
  8039b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039bc:	89 50 0c             	mov    %edx,0xc(%eax)
  8039bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c5:	89 50 08             	mov    %edx,0x8(%eax)
  8039c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ce:	89 50 0c             	mov    %edx,0xc(%eax)
  8039d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d4:	8b 40 08             	mov    0x8(%eax),%eax
  8039d7:	85 c0                	test   %eax,%eax
  8039d9:	75 08                	jne    8039e3 <realloc_block_FF+0x123>
  8039db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039de:	a3 18 51 80 00       	mov    %eax,0x805118
  8039e3:	a1 20 51 80 00       	mov    0x805120,%eax
  8039e8:	40                   	inc    %eax
  8039e9:	a3 20 51 80 00       	mov    %eax,0x805120
	    	 }
	    	 return va;
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	e9 14 02 00 00       	jmp    803c0a <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	8b 40 08             	mov    0x8(%eax),%eax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	0f 84 97 01 00 00    	je     803b9b <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  803a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a07:	8b 40 08             	mov    0x8(%eax),%eax
  803a0a:	8a 40 04             	mov    0x4(%eax),%al
  803a0d:	84 c0                	test   %al,%al
  803a0f:	0f 84 86 01 00 00    	je     803b9b <realloc_block_FF+0x2db>
  803a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a18:	8b 10                	mov    (%eax),%edx
  803a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1d:	8b 40 08             	mov    0x8(%eax),%eax
  803a20:	8b 00                	mov    (%eax),%eax
  803a22:	01 d0                	add    %edx,%eax
  803a24:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a27:	0f 82 6e 01 00 00    	jb     803b9b <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	8b 10                	mov    (%eax),%edx
  803a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a35:	8b 40 08             	mov    0x8(%eax),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	01 c2                	add    %eax,%edx
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  803a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a44:	8b 40 08             	mov    0x8(%eax),%eax
  803a47:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  803a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4e:	8b 40 08             	mov    0x8(%eax),%eax
  803a51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	8b 40 08             	mov    0x8(%eax),%eax
  803a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  803a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a64:	75 17                	jne    803a7d <realloc_block_FF+0x1bd>
  803a66:	83 ec 04             	sub    $0x4,%esp
  803a69:	68 fe 49 80 00       	push   $0x8049fe
  803a6e:	68 38 01 00 00       	push   $0x138
  803a73:	68 3f 49 80 00       	push   $0x80493f
  803a78:	e8 48 d9 ff ff       	call   8013c5 <_panic>
  803a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a80:	8b 40 08             	mov    0x8(%eax),%eax
  803a83:	85 c0                	test   %eax,%eax
  803a85:	74 11                	je     803a98 <realloc_block_FF+0x1d8>
  803a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8a:	8b 40 08             	mov    0x8(%eax),%eax
  803a8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a90:	8b 52 0c             	mov    0xc(%edx),%edx
  803a93:	89 50 0c             	mov    %edx,0xc(%eax)
  803a96:	eb 0b                	jmp    803aa3 <realloc_block_FF+0x1e3>
  803a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9e:	a3 18 51 80 00       	mov    %eax,0x805118
  803aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa6:	8b 40 0c             	mov    0xc(%eax),%eax
  803aa9:	85 c0                	test   %eax,%eax
  803aab:	74 11                	je     803abe <realloc_block_FF+0x1fe>
  803aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ab6:	8b 52 08             	mov    0x8(%edx),%edx
  803ab9:	89 50 08             	mov    %edx,0x8(%eax)
  803abc:	eb 0b                	jmp    803ac9 <realloc_block_FF+0x209>
  803abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac1:	8b 40 08             	mov    0x8(%eax),%eax
  803ac4:	a3 14 51 80 00       	mov    %eax,0x805114
  803ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803add:	a1 20 51 80 00       	mov    0x805120,%eax
  803ae2:	48                   	dec    %eax
  803ae3:	a3 20 51 80 00       	mov    %eax,0x805120
					 if(block->size - new_size >= sizeOfMetaData())
  803ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	2b 45 0c             	sub    0xc(%ebp),%eax
  803af0:	83 f8 0f             	cmp    $0xf,%eax
  803af3:	0f 86 9d 00 00 00    	jbe    803b96 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aff:	01 d0                	add    %edx,%eax
  803b01:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  803b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b07:	8b 00                	mov    (%eax),%eax
  803b09:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b11:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  803b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b19:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  803b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  803b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b26:	74 06                	je     803b2e <realloc_block_FF+0x26e>
  803b28:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b2c:	75 17                	jne    803b45 <realloc_block_FF+0x285>
  803b2e:	83 ec 04             	sub    $0x4,%esp
  803b31:	68 58 49 80 00       	push   $0x804958
  803b36:	68 3f 01 00 00       	push   $0x13f
  803b3b:	68 3f 49 80 00       	push   $0x80493f
  803b40:	e8 80 d8 ff ff       	call   8013c5 <_panic>
  803b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b48:	8b 50 08             	mov    0x8(%eax),%edx
  803b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4e:	89 50 08             	mov    %edx,0x8(%eax)
  803b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b54:	8b 40 08             	mov    0x8(%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 0c                	je     803b67 <realloc_block_FF+0x2a7>
  803b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5e:	8b 40 08             	mov    0x8(%eax),%eax
  803b61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b64:	89 50 0c             	mov    %edx,0xc(%eax)
  803b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b6d:	89 50 08             	mov    %edx,0x8(%eax)
  803b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b76:	89 50 0c             	mov    %edx,0xc(%eax)
  803b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7c:	8b 40 08             	mov    0x8(%eax),%eax
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	75 08                	jne    803b8b <realloc_block_FF+0x2cb>
  803b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b86:	a3 18 51 80 00       	mov    %eax,0x805118
  803b8b:	a1 20 51 80 00       	mov    0x805120,%eax
  803b90:	40                   	inc    %eax
  803b91:	a3 20 51 80 00       	mov    %eax,0x805120
					 }
					 return va;
  803b96:	8b 45 08             	mov    0x8(%ebp),%eax
  803b99:	eb 6f                	jmp    803c0a <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  803b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b9e:	83 e8 10             	sub    $0x10,%eax
  803ba1:	83 ec 0c             	sub    $0xc,%esp
  803ba4:	50                   	push   %eax
  803ba5:	e8 87 f6 ff ff       	call   803231 <alloc_block_FF>
  803baa:	83 c4 10             	add    $0x10,%esp
  803bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  803bb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb4:	75 29                	jne    803bdf <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  803bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb9:	83 ec 0c             	sub    $0xc,%esp
  803bbc:	50                   	push   %eax
  803bbd:	e8 98 ea ff ff       	call   80265a <sbrk>
  803bc2:	83 c4 10             	add    $0x10,%esp
  803bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  803bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcb:	83 f8 ff             	cmp    $0xffffffff,%eax
  803bce:	75 07                	jne    803bd7 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  803bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd5:	eb 33                	jmp    803c0a <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  803bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bda:	83 c0 10             	add    $0x10,%eax
  803bdd:	eb 2b                	jmp    803c0a <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  803bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be2:	8b 00                	mov    (%eax),%eax
  803be4:	83 ec 04             	sub    $0x4,%esp
  803be7:	50                   	push   %eax
  803be8:	ff 75 f4             	pushl  -0xc(%ebp)
  803beb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bee:	e8 2f e3 ff ff       	call   801f22 <memcpy>
  803bf3:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  803bf6:	83 ec 0c             	sub    $0xc,%esp
  803bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  803bfc:	e8 d7 fa ff ff       	call   8036d8 <free_block>
  803c01:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  803c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c07:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  803c0a:	c9                   	leave  
  803c0b:	c3                   	ret    

00803c0c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803c0c:	55                   	push   %ebp
  803c0d:	89 e5                	mov    %esp,%ebp
  803c0f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803c12:	8b 55 08             	mov    0x8(%ebp),%edx
  803c15:	89 d0                	mov    %edx,%eax
  803c17:	c1 e0 02             	shl    $0x2,%eax
  803c1a:	01 d0                	add    %edx,%eax
  803c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c23:	01 d0                	add    %edx,%eax
  803c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c2c:	01 d0                	add    %edx,%eax
  803c2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c35:	01 d0                	add    %edx,%eax
  803c37:	c1 e0 04             	shl    $0x4,%eax
  803c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803c3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803c44:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803c47:	83 ec 0c             	sub    $0xc,%esp
  803c4a:	50                   	push   %eax
  803c4b:	e8 e7 f0 ff ff       	call   802d37 <sys_get_virtual_time>
  803c50:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803c53:	eb 41                	jmp    803c96 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803c55:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803c58:	83 ec 0c             	sub    $0xc,%esp
  803c5b:	50                   	push   %eax
  803c5c:	e8 d6 f0 ff ff       	call   802d37 <sys_get_virtual_time>
  803c61:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803c64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6a:	29 c2                	sub    %eax,%edx
  803c6c:	89 d0                	mov    %edx,%eax
  803c6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c77:	89 d1                	mov    %edx,%ecx
  803c79:	29 c1                	sub    %eax,%ecx
  803c7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c81:	39 c2                	cmp    %eax,%edx
  803c83:	0f 97 c0             	seta   %al
  803c86:	0f b6 c0             	movzbl %al,%eax
  803c89:	29 c1                	sub    %eax,%ecx
  803c8b:	89 c8                	mov    %ecx,%eax
  803c8d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803c90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c9c:	72 b7                	jb     803c55 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803c9e:	90                   	nop
  803c9f:	c9                   	leave  
  803ca0:	c3                   	ret    

00803ca1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803ca1:	55                   	push   %ebp
  803ca2:	89 e5                	mov    %esp,%ebp
  803ca4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803cae:	eb 03                	jmp    803cb3 <busy_wait+0x12>
  803cb0:	ff 45 fc             	incl   -0x4(%ebp)
  803cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803cb6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cb9:	72 f5                	jb     803cb0 <busy_wait+0xf>
	return i;
  803cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803cbe:	c9                   	leave  
  803cbf:	c3                   	ret    

00803cc0 <__udivdi3>:
  803cc0:	55                   	push   %ebp
  803cc1:	57                   	push   %edi
  803cc2:	56                   	push   %esi
  803cc3:	53                   	push   %ebx
  803cc4:	83 ec 1c             	sub    $0x1c,%esp
  803cc7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ccb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cd7:	89 ca                	mov    %ecx,%edx
  803cd9:	89 f8                	mov    %edi,%eax
  803cdb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cdf:	85 f6                	test   %esi,%esi
  803ce1:	75 2d                	jne    803d10 <__udivdi3+0x50>
  803ce3:	39 cf                	cmp    %ecx,%edi
  803ce5:	77 65                	ja     803d4c <__udivdi3+0x8c>
  803ce7:	89 fd                	mov    %edi,%ebp
  803ce9:	85 ff                	test   %edi,%edi
  803ceb:	75 0b                	jne    803cf8 <__udivdi3+0x38>
  803ced:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf2:	31 d2                	xor    %edx,%edx
  803cf4:	f7 f7                	div    %edi
  803cf6:	89 c5                	mov    %eax,%ebp
  803cf8:	31 d2                	xor    %edx,%edx
  803cfa:	89 c8                	mov    %ecx,%eax
  803cfc:	f7 f5                	div    %ebp
  803cfe:	89 c1                	mov    %eax,%ecx
  803d00:	89 d8                	mov    %ebx,%eax
  803d02:	f7 f5                	div    %ebp
  803d04:	89 cf                	mov    %ecx,%edi
  803d06:	89 fa                	mov    %edi,%edx
  803d08:	83 c4 1c             	add    $0x1c,%esp
  803d0b:	5b                   	pop    %ebx
  803d0c:	5e                   	pop    %esi
  803d0d:	5f                   	pop    %edi
  803d0e:	5d                   	pop    %ebp
  803d0f:	c3                   	ret    
  803d10:	39 ce                	cmp    %ecx,%esi
  803d12:	77 28                	ja     803d3c <__udivdi3+0x7c>
  803d14:	0f bd fe             	bsr    %esi,%edi
  803d17:	83 f7 1f             	xor    $0x1f,%edi
  803d1a:	75 40                	jne    803d5c <__udivdi3+0x9c>
  803d1c:	39 ce                	cmp    %ecx,%esi
  803d1e:	72 0a                	jb     803d2a <__udivdi3+0x6a>
  803d20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d24:	0f 87 9e 00 00 00    	ja     803dc8 <__udivdi3+0x108>
  803d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d2f:	89 fa                	mov    %edi,%edx
  803d31:	83 c4 1c             	add    $0x1c,%esp
  803d34:	5b                   	pop    %ebx
  803d35:	5e                   	pop    %esi
  803d36:	5f                   	pop    %edi
  803d37:	5d                   	pop    %ebp
  803d38:	c3                   	ret    
  803d39:	8d 76 00             	lea    0x0(%esi),%esi
  803d3c:	31 ff                	xor    %edi,%edi
  803d3e:	31 c0                	xor    %eax,%eax
  803d40:	89 fa                	mov    %edi,%edx
  803d42:	83 c4 1c             	add    $0x1c,%esp
  803d45:	5b                   	pop    %ebx
  803d46:	5e                   	pop    %esi
  803d47:	5f                   	pop    %edi
  803d48:	5d                   	pop    %ebp
  803d49:	c3                   	ret    
  803d4a:	66 90                	xchg   %ax,%ax
  803d4c:	89 d8                	mov    %ebx,%eax
  803d4e:	f7 f7                	div    %edi
  803d50:	31 ff                	xor    %edi,%edi
  803d52:	89 fa                	mov    %edi,%edx
  803d54:	83 c4 1c             	add    $0x1c,%esp
  803d57:	5b                   	pop    %ebx
  803d58:	5e                   	pop    %esi
  803d59:	5f                   	pop    %edi
  803d5a:	5d                   	pop    %ebp
  803d5b:	c3                   	ret    
  803d5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d61:	89 eb                	mov    %ebp,%ebx
  803d63:	29 fb                	sub    %edi,%ebx
  803d65:	89 f9                	mov    %edi,%ecx
  803d67:	d3 e6                	shl    %cl,%esi
  803d69:	89 c5                	mov    %eax,%ebp
  803d6b:	88 d9                	mov    %bl,%cl
  803d6d:	d3 ed                	shr    %cl,%ebp
  803d6f:	89 e9                	mov    %ebp,%ecx
  803d71:	09 f1                	or     %esi,%ecx
  803d73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d77:	89 f9                	mov    %edi,%ecx
  803d79:	d3 e0                	shl    %cl,%eax
  803d7b:	89 c5                	mov    %eax,%ebp
  803d7d:	89 d6                	mov    %edx,%esi
  803d7f:	88 d9                	mov    %bl,%cl
  803d81:	d3 ee                	shr    %cl,%esi
  803d83:	89 f9                	mov    %edi,%ecx
  803d85:	d3 e2                	shl    %cl,%edx
  803d87:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d8b:	88 d9                	mov    %bl,%cl
  803d8d:	d3 e8                	shr    %cl,%eax
  803d8f:	09 c2                	or     %eax,%edx
  803d91:	89 d0                	mov    %edx,%eax
  803d93:	89 f2                	mov    %esi,%edx
  803d95:	f7 74 24 0c          	divl   0xc(%esp)
  803d99:	89 d6                	mov    %edx,%esi
  803d9b:	89 c3                	mov    %eax,%ebx
  803d9d:	f7 e5                	mul    %ebp
  803d9f:	39 d6                	cmp    %edx,%esi
  803da1:	72 19                	jb     803dbc <__udivdi3+0xfc>
  803da3:	74 0b                	je     803db0 <__udivdi3+0xf0>
  803da5:	89 d8                	mov    %ebx,%eax
  803da7:	31 ff                	xor    %edi,%edi
  803da9:	e9 58 ff ff ff       	jmp    803d06 <__udivdi3+0x46>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803db4:	89 f9                	mov    %edi,%ecx
  803db6:	d3 e2                	shl    %cl,%edx
  803db8:	39 c2                	cmp    %eax,%edx
  803dba:	73 e9                	jae    803da5 <__udivdi3+0xe5>
  803dbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dbf:	31 ff                	xor    %edi,%edi
  803dc1:	e9 40 ff ff ff       	jmp    803d06 <__udivdi3+0x46>
  803dc6:	66 90                	xchg   %ax,%ax
  803dc8:	31 c0                	xor    %eax,%eax
  803dca:	e9 37 ff ff ff       	jmp    803d06 <__udivdi3+0x46>
  803dcf:	90                   	nop

00803dd0 <__umoddi3>:
  803dd0:	55                   	push   %ebp
  803dd1:	57                   	push   %edi
  803dd2:	56                   	push   %esi
  803dd3:	53                   	push   %ebx
  803dd4:	83 ec 1c             	sub    $0x1c,%esp
  803dd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ddb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ddf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803de3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803de7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803deb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803def:	89 f3                	mov    %esi,%ebx
  803df1:	89 fa                	mov    %edi,%edx
  803df3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803df7:	89 34 24             	mov    %esi,(%esp)
  803dfa:	85 c0                	test   %eax,%eax
  803dfc:	75 1a                	jne    803e18 <__umoddi3+0x48>
  803dfe:	39 f7                	cmp    %esi,%edi
  803e00:	0f 86 a2 00 00 00    	jbe    803ea8 <__umoddi3+0xd8>
  803e06:	89 c8                	mov    %ecx,%eax
  803e08:	89 f2                	mov    %esi,%edx
  803e0a:	f7 f7                	div    %edi
  803e0c:	89 d0                	mov    %edx,%eax
  803e0e:	31 d2                	xor    %edx,%edx
  803e10:	83 c4 1c             	add    $0x1c,%esp
  803e13:	5b                   	pop    %ebx
  803e14:	5e                   	pop    %esi
  803e15:	5f                   	pop    %edi
  803e16:	5d                   	pop    %ebp
  803e17:	c3                   	ret    
  803e18:	39 f0                	cmp    %esi,%eax
  803e1a:	0f 87 ac 00 00 00    	ja     803ecc <__umoddi3+0xfc>
  803e20:	0f bd e8             	bsr    %eax,%ebp
  803e23:	83 f5 1f             	xor    $0x1f,%ebp
  803e26:	0f 84 ac 00 00 00    	je     803ed8 <__umoddi3+0x108>
  803e2c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e31:	29 ef                	sub    %ebp,%edi
  803e33:	89 fe                	mov    %edi,%esi
  803e35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e39:	89 e9                	mov    %ebp,%ecx
  803e3b:	d3 e0                	shl    %cl,%eax
  803e3d:	89 d7                	mov    %edx,%edi
  803e3f:	89 f1                	mov    %esi,%ecx
  803e41:	d3 ef                	shr    %cl,%edi
  803e43:	09 c7                	or     %eax,%edi
  803e45:	89 e9                	mov    %ebp,%ecx
  803e47:	d3 e2                	shl    %cl,%edx
  803e49:	89 14 24             	mov    %edx,(%esp)
  803e4c:	89 d8                	mov    %ebx,%eax
  803e4e:	d3 e0                	shl    %cl,%eax
  803e50:	89 c2                	mov    %eax,%edx
  803e52:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e56:	d3 e0                	shl    %cl,%eax
  803e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e60:	89 f1                	mov    %esi,%ecx
  803e62:	d3 e8                	shr    %cl,%eax
  803e64:	09 d0                	or     %edx,%eax
  803e66:	d3 eb                	shr    %cl,%ebx
  803e68:	89 da                	mov    %ebx,%edx
  803e6a:	f7 f7                	div    %edi
  803e6c:	89 d3                	mov    %edx,%ebx
  803e6e:	f7 24 24             	mull   (%esp)
  803e71:	89 c6                	mov    %eax,%esi
  803e73:	89 d1                	mov    %edx,%ecx
  803e75:	39 d3                	cmp    %edx,%ebx
  803e77:	0f 82 87 00 00 00    	jb     803f04 <__umoddi3+0x134>
  803e7d:	0f 84 91 00 00 00    	je     803f14 <__umoddi3+0x144>
  803e83:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e87:	29 f2                	sub    %esi,%edx
  803e89:	19 cb                	sbb    %ecx,%ebx
  803e8b:	89 d8                	mov    %ebx,%eax
  803e8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e91:	d3 e0                	shl    %cl,%eax
  803e93:	89 e9                	mov    %ebp,%ecx
  803e95:	d3 ea                	shr    %cl,%edx
  803e97:	09 d0                	or     %edx,%eax
  803e99:	89 e9                	mov    %ebp,%ecx
  803e9b:	d3 eb                	shr    %cl,%ebx
  803e9d:	89 da                	mov    %ebx,%edx
  803e9f:	83 c4 1c             	add    $0x1c,%esp
  803ea2:	5b                   	pop    %ebx
  803ea3:	5e                   	pop    %esi
  803ea4:	5f                   	pop    %edi
  803ea5:	5d                   	pop    %ebp
  803ea6:	c3                   	ret    
  803ea7:	90                   	nop
  803ea8:	89 fd                	mov    %edi,%ebp
  803eaa:	85 ff                	test   %edi,%edi
  803eac:	75 0b                	jne    803eb9 <__umoddi3+0xe9>
  803eae:	b8 01 00 00 00       	mov    $0x1,%eax
  803eb3:	31 d2                	xor    %edx,%edx
  803eb5:	f7 f7                	div    %edi
  803eb7:	89 c5                	mov    %eax,%ebp
  803eb9:	89 f0                	mov    %esi,%eax
  803ebb:	31 d2                	xor    %edx,%edx
  803ebd:	f7 f5                	div    %ebp
  803ebf:	89 c8                	mov    %ecx,%eax
  803ec1:	f7 f5                	div    %ebp
  803ec3:	89 d0                	mov    %edx,%eax
  803ec5:	e9 44 ff ff ff       	jmp    803e0e <__umoddi3+0x3e>
  803eca:	66 90                	xchg   %ax,%ax
  803ecc:	89 c8                	mov    %ecx,%eax
  803ece:	89 f2                	mov    %esi,%edx
  803ed0:	83 c4 1c             	add    $0x1c,%esp
  803ed3:	5b                   	pop    %ebx
  803ed4:	5e                   	pop    %esi
  803ed5:	5f                   	pop    %edi
  803ed6:	5d                   	pop    %ebp
  803ed7:	c3                   	ret    
  803ed8:	3b 04 24             	cmp    (%esp),%eax
  803edb:	72 06                	jb     803ee3 <__umoddi3+0x113>
  803edd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ee1:	77 0f                	ja     803ef2 <__umoddi3+0x122>
  803ee3:	89 f2                	mov    %esi,%edx
  803ee5:	29 f9                	sub    %edi,%ecx
  803ee7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803eeb:	89 14 24             	mov    %edx,(%esp)
  803eee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ef2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ef6:	8b 14 24             	mov    (%esp),%edx
  803ef9:	83 c4 1c             	add    $0x1c,%esp
  803efc:	5b                   	pop    %ebx
  803efd:	5e                   	pop    %esi
  803efe:	5f                   	pop    %edi
  803eff:	5d                   	pop    %ebp
  803f00:	c3                   	ret    
  803f01:	8d 76 00             	lea    0x0(%esi),%esi
  803f04:	2b 04 24             	sub    (%esp),%eax
  803f07:	19 fa                	sbb    %edi,%edx
  803f09:	89 d1                	mov    %edx,%ecx
  803f0b:	89 c6                	mov    %eax,%esi
  803f0d:	e9 71 ff ff ff       	jmp    803e83 <__umoddi3+0xb3>
  803f12:	66 90                	xchg   %ax,%ax
  803f14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f18:	72 ea                	jb     803f04 <__umoddi3+0x134>
  803f1a:	89 d9                	mov    %ebx,%ecx
  803f1c:	e9 62 ff ff ff       	jmp    803e83 <__umoddi3+0xb3>
