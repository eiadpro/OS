
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 5e 03 00 00       	call   800394 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
				0x200000, 0x201000, 0x202000, 0x203000, 0x204000, 0x205000, 0x206000,0x207000,	//Data
				0x800000, 0x801000, 0x802000, 0x803000,		//Code
				0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/} ;//Stack

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 00 00 01    	sub    $0x100007c,%esp

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	//("STEP 0: checking Initial WS entries ...\n");
	{
		found = sys_check_WS_list(expectedInitialVAs, 14, 0, 1);
  800044:	6a 01                	push   $0x1
  800046:	6a 00                	push   $0x0
  800048:	6a 0e                	push   $0xe
  80004a:	68 00 30 80 00       	push   $0x803000
  80004f:	e8 42 1b 00 00       	call   801b96 <sys_check_WS_list>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80005a:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 c0 1e 80 00       	push   $0x801ec0
  800068:	6a 15                	push   $0x15
  80006a:	68 01 1f 80 00       	push   $0x801f01
  80006f:	e8 57 04 00 00       	call   8004cb <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800074:	a1 40 30 80 00       	mov    0x803040,%eax
  800079:	8b 80 d4 00 00 00    	mov    0xd4(%eax),%eax
  80007f:	85 c0                	test   %eax,%eax
  800081:	74 14                	je     800097 <_main+0x5f>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 18 1f 80 00       	push   $0x801f18
  80008b:	6a 19                	push   $0x19
  80008d:	68 01 1f 80 00       	push   $0x801f01
  800092:	e8 34 04 00 00       	call   8004cb <_panic>
		/*====================================*/
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800097:	e8 28 16 00 00       	call   8016c4 <sys_pf_calculate_allocated_pages>
  80009c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int freePages = sys_calculate_free_frames();
  80009f:	e8 d5 15 00 00       	call   801679 <sys_calculate_free_frames>
  8000a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int i=0;
  8000a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(;i<=PAGE_SIZE;i++)
  8000ae:	eb 11                	jmp    8000c1 <_main+0x89>
	{
		arr[i] = 1;
  8000b0:	8d 95 d4 ff ff fe    	lea    -0x100002c(%ebp),%edx
  8000b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	c6 00 01             	movb   $0x1,(%eax)
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8000be:	ff 45 e4             	incl   -0x1c(%ebp)
  8000c1:	81 7d e4 00 10 00 00 	cmpl   $0x1000,-0x1c(%ebp)
  8000c8:	7e e6                	jle    8000b0 <_main+0x78>
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
  8000ca:	c7 45 e4 00 00 40 00 	movl   $0x400000,-0x1c(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000d1:	eb 11                	jmp    8000e4 <_main+0xac>
	{
		arr[i] = 2;
  8000d3:	8d 95 d4 ff ff fe    	lea    -0x100002c(%ebp),%edx
  8000d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	c6 00 02             	movb   $0x2,(%eax)
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000e1:	ff 45 e4             	incl   -0x1c(%ebp)
  8000e4:	81 7d e4 00 10 40 00 	cmpl   $0x401000,-0x1c(%ebp)
  8000eb:	7e e6                	jle    8000d3 <_main+0x9b>
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
  8000ed:	c7 45 e4 00 00 80 00 	movl   $0x800000,-0x1c(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8000f4:	eb 11                	jmp    800107 <_main+0xcf>
	{
		arr[i] = 3;
  8000f6:	8d 95 d4 ff ff fe    	lea    -0x100002c(%ebp),%edx
  8000fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ff:	01 d0                	add    %edx,%eax
  800101:	c6 00 03             	movb   $0x3,(%eax)
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800104:	ff 45 e4             	incl   -0x1c(%ebp)
  800107:	81 7d e4 00 10 80 00 	cmpl   $0x801000,-0x1c(%ebp)
  80010e:	7e e6                	jle    8000f6 <_main+0xbe>
	{
		arr[i] = 3;
	}

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	68 58 1f 80 00       	push   $0x801f58
  800118:	e8 6b 06 00 00       	call   800788 <cprintf>
  80011d:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  panic("PLACEMENT of stack page failed");
  800120:	8a 85 d4 ff ff fe    	mov    -0x100002c(%ebp),%al
  800126:	3c 01                	cmp    $0x1,%al
  800128:	74 14                	je     80013e <_main+0x106>
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	68 88 1f 80 00       	push   $0x801f88
  800132:	6a 33                	push   $0x33
  800134:	68 01 1f 80 00       	push   $0x801f01
  800139:	e8 8d 03 00 00       	call   8004cb <_panic>
		if( arr[PAGE_SIZE] !=  1)  panic("PLACEMENT of stack page failed");
  80013e:	8a 85 d4 0f 00 ff    	mov    -0xfff02c(%ebp),%al
  800144:	3c 01                	cmp    $0x1,%al
  800146:	74 14                	je     80015c <_main+0x124>
  800148:	83 ec 04             	sub    $0x4,%esp
  80014b:	68 88 1f 80 00       	push   $0x801f88
  800150:	6a 34                	push   $0x34
  800152:	68 01 1f 80 00       	push   $0x801f01
  800157:	e8 6f 03 00 00       	call   8004cb <_panic>

		if( arr[PAGE_SIZE*1024] !=  2)  panic("PLACEMENT of stack page failed");
  80015c:	8a 85 d4 ff 3f ff    	mov    -0xc0002c(%ebp),%al
  800162:	3c 02                	cmp    $0x2,%al
  800164:	74 14                	je     80017a <_main+0x142>
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	68 88 1f 80 00       	push   $0x801f88
  80016e:	6a 36                	push   $0x36
  800170:	68 01 1f 80 00       	push   $0x801f01
  800175:	e8 51 03 00 00       	call   8004cb <_panic>
		if( arr[PAGE_SIZE*1025] !=  2)  panic("PLACEMENT of stack page failed");
  80017a:	8a 85 d4 0f 40 ff    	mov    -0xbff02c(%ebp),%al
  800180:	3c 02                	cmp    $0x2,%al
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 88 1f 80 00       	push   $0x801f88
  80018c:	6a 37                	push   $0x37
  80018e:	68 01 1f 80 00       	push   $0x801f01
  800193:	e8 33 03 00 00       	call   8004cb <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  3)  panic("PLACEMENT of stack page failed");
  800198:	8a 85 d4 ff 7f ff    	mov    -0x80002c(%ebp),%al
  80019e:	3c 03                	cmp    $0x3,%al
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 88 1f 80 00       	push   $0x801f88
  8001aa:	6a 39                	push   $0x39
  8001ac:	68 01 1f 80 00       	push   $0x801f01
  8001b1:	e8 15 03 00 00       	call   8004cb <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  panic("PLACEMENT of stack page failed");
  8001b6:	8a 85 d4 0f 80 ff    	mov    -0x7ff02c(%ebp),%al
  8001bc:	3c 03                	cmp    $0x3,%al
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 88 1f 80 00       	push   $0x801f88
  8001c8:	6a 3a                	push   $0x3a
  8001ca:	68 01 1f 80 00       	push   $0x801f01
  8001cf:	e8 f7 02 00 00       	call   8004cb <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT be written to Page File until evicted as victim");
  8001d4:	e8 eb 14 00 00       	call   8016c4 <sys_pf_calculate_allocated_pages>
  8001d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 a8 1f 80 00       	push   $0x801fa8
  8001e6:	6a 3d                	push   $0x3d
  8001e8:	68 01 1f 80 00       	push   $0x801f01
  8001ed:	e8 d9 02 00 00       	call   8004cb <_panic>

		int expected = 5 /*pages*/ + 2 /*tables*/;
  8001f2:	c7 45 d4 07 00 00 00 	movl   $0x7,-0x2c(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  8001f9:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8001fc:	e8 78 14 00 00       	call   801679 <sys_calculate_free_frames>
  800201:	29 c3                	sub    %eax,%ebx
  800203:	89 da                	mov    %ebx,%edx
  800205:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800208:	39 c2                	cmp    %eax,%edx
  80020a:	74 24                	je     800230 <_main+0x1f8>
			panic("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));
  80020c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80020f:	e8 65 14 00 00       	call   801679 <sys_calculate_free_frames>
  800214:	29 c3                	sub    %eax,%ebx
  800216:	89 d8                	mov    %ebx,%eax
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80021f:	68 f4 1f 80 00       	push   $0x801ff4
  800224:	6a 41                	push   $0x41
  800226:	68 01 1f 80 00       	push   $0x801f01
  80022b:	e8 9b 02 00 00       	call   8004cb <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 3c 20 80 00       	push   $0x80203c
  800238:	e8 4b 05 00 00       	call   800788 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp



	cprintf("STEP B: checking WS entries ...\n");
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	68 70 20 80 00       	push   $0x802070
  800248:	e8 3b 05 00 00       	call   800788 <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 expectedPages[19] = {
  800250:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800256:	bb 20 22 80 00       	mov    $0x802220,%ebx
  80025b:	ba 13 00 00 00       	mov    $0x13,%edx
  800260:	89 c7                	mov    %eax,%edi
  800262:	89 de                	mov    %ebx,%esi
  800264:	89 d1                	mov    %edx,%ecx
  800266:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
				0x800000,0x801000,0x802000,0x803000,
				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000};
		found = sys_check_WS_list(expectedPages, 19, 0, 1);
  800268:	6a 01                	push   $0x1
  80026a:	6a 00                	push   $0x0
  80026c:	6a 13                	push   $0x13
  80026e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	e8 1c 19 00 00       	call   801b96 <sys_check_WS_list>
  80027a:	83 c4 10             	add    $0x10,%esp
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1)
  800280:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  800284:	74 14                	je     80029a <_main+0x262>
			panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 94 20 80 00       	push   $0x802094
  80028e:	6a 4f                	push   $0x4f
  800290:	68 01 1f 80 00       	push   $0x801f01
  800295:	e8 31 02 00 00       	call   8004cb <_panic>
	}
	cprintf("STEP B passed: WS entries test are correct\n\n\n");
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	68 e8 20 80 00       	push   $0x8020e8
  8002a2:	e8 e1 04 00 00       	call   800788 <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	68 18 21 80 00       	push   $0x802118
  8002b2:	e8 d1 04 00 00       	call   800788 <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8002ba:	a1 40 30 80 00       	mov    0x803040,%eax
  8002bf:	8b 80 d4 00 00 00    	mov    0xd4(%eax),%eax
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	74 14                	je     8002dd <_main+0x2a5>
			panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	68 4c 21 80 00       	push   $0x80214c
  8002d1:	6a 57                	push   $0x57
  8002d3:	68 01 1f 80 00       	push   $0x801f01
  8002d8:	e8 ee 01 00 00       	call   8004cb <_panic>

		i=PAGE_SIZE*1024*3;
  8002dd:	c7 45 e4 00 00 c0 00 	movl   $0xc00000,-0x1c(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8002e4:	eb 11                	jmp    8002f7 <_main+0x2bf>
		{
			arr[i] = 4;
  8002e6:	8d 95 d4 ff ff fe    	lea    -0x100002c(%ebp),%edx
  8002ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c6 00 04             	movb   $0x4,(%eax)
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
			panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8002f4:	ff 45 e4             	incl   -0x1c(%ebp)
  8002f7:	81 7d e4 00 00 c0 00 	cmpl   $0xc00000,-0x1c(%ebp)
  8002fe:	7e e6                	jle    8002e6 <_main+0x2ae>
		{
			arr[i] = 4;
		}

		if( arr[PAGE_SIZE*1024*3] != 4)  panic("PLACEMENT of stack page failed");
  800300:	8a 85 d4 ff bf ff    	mov    -0x40002c(%ebp),%al
  800306:	3c 04                	cmp    $0x4,%al
  800308:	74 14                	je     80031e <_main+0x2e6>
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	68 88 1f 80 00       	push   $0x801f88
  800312:	6a 5f                	push   $0x5f
  800314:	68 01 1f 80 00       	push   $0x801f01
  800319:	e8 ad 01 00 00       	call   8004cb <_panic>
		//		if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");

		uint32 expectedPages[20] = {
  80031e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800324:	bb 80 22 80 00       	mov    $0x802280,%ebx
  800329:	ba 14 00 00 00       	mov    $0x14,%edx
  80032e:	89 c7                	mov    %eax,%edi
  800330:	89 de                	mov    %ebx,%esi
  800332:	89 d1                	mov    %edx,%ecx
  800334:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
				0x800000,0x801000,0x802000,0x803000,
				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};

		found = sys_check_WS_list(expectedPages, 20, 0x200000, 1);
  800336:	6a 01                	push   $0x1
  800338:	68 00 00 20 00       	push   $0x200000
  80033d:	6a 14                	push   $0x14
  80033f:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	e8 4b 18 00 00       	call   801b96 <sys_check_WS_list>
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (found != 1)
  800351:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  800355:	74 14                	je     80036b <_main+0x333>
			panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	68 94 20 80 00       	push   $0x802094
  80035f:	6a 69                	push   $0x69
  800361:	68 01 1f 80 00       	push   $0x801f01
  800366:	e8 60 01 00 00       	call   8004cb <_panic>
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	}
	cprintf("STEP C passed: WS is FULL now\n\n\n");
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	68 a0 21 80 00       	push   $0x8021a0
  800373:	e8 10 04 00 00       	call   800788 <cprintf>
  800378:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	68 c4 21 80 00       	push   $0x8021c4
  800383:	e8 00 04 00 00       	call   800788 <cprintf>
  800388:	83 c4 10             	add    $0x10,%esp
	return;
  80038b:	90                   	nop
}
  80038c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038f:	5b                   	pop    %ebx
  800390:	5e                   	pop    %esi
  800391:	5f                   	pop    %edi
  800392:	5d                   	pop    %ebp
  800393:	c3                   	ret    

00800394 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80039a:	e8 65 15 00 00       	call   801904 <sys_getenvindex>
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	c1 e0 03             	shl    $0x3,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	01 c0                	add    %eax,%eax
  8003ae:	01 d0                	add    %edx,%eax
  8003b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	c1 e0 04             	shl    $0x4,%eax
  8003bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c1:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003c6:	a1 40 30 80 00       	mov    0x803040,%eax
  8003cb:	8a 40 5c             	mov    0x5c(%eax),%al
  8003ce:	84 c0                	test   %al,%al
  8003d0:	74 0d                	je     8003df <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8003d2:	a1 40 30 80 00       	mov    0x803040,%eax
  8003d7:	83 c0 5c             	add    $0x5c,%eax
  8003da:	a3 38 30 80 00       	mov    %eax,0x803038

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003e3:	7e 0a                	jle    8003ef <libmain+0x5b>
		binaryname = argv[0];
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	a3 38 30 80 00       	mov    %eax,0x803038

	// call user main routine
	_main(argc, argv);
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	ff 75 0c             	pushl  0xc(%ebp)
  8003f5:	ff 75 08             	pushl  0x8(%ebp)
  8003f8:	e8 3b fc ff ff       	call   800038 <_main>
  8003fd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800400:	e8 0c 13 00 00       	call   801711 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	68 e8 22 80 00       	push   $0x8022e8
  80040d:	e8 76 03 00 00       	call   800788 <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800415:	a1 40 30 80 00       	mov    0x803040,%eax
  80041a:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800420:	a1 40 30 80 00       	mov    0x803040,%eax
  800425:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80042b:	83 ec 04             	sub    $0x4,%esp
  80042e:	52                   	push   %edx
  80042f:	50                   	push   %eax
  800430:	68 10 23 80 00       	push   $0x802310
  800435:	e8 4e 03 00 00       	call   800788 <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80043d:	a1 40 30 80 00       	mov    0x803040,%eax
  800442:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800448:	a1 40 30 80 00       	mov    0x803040,%eax
  80044d:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800453:	a1 40 30 80 00       	mov    0x803040,%eax
  800458:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80045e:	51                   	push   %ecx
  80045f:	52                   	push   %edx
  800460:	50                   	push   %eax
  800461:	68 38 23 80 00       	push   $0x802338
  800466:	e8 1d 03 00 00       	call   800788 <cprintf>
  80046b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80046e:	a1 40 30 80 00       	mov    0x803040,%eax
  800473:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	50                   	push   %eax
  80047d:	68 90 23 80 00       	push   $0x802390
  800482:	e8 01 03 00 00       	call   800788 <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80048a:	83 ec 0c             	sub    $0xc,%esp
  80048d:	68 e8 22 80 00       	push   $0x8022e8
  800492:	e8 f1 02 00 00       	call   800788 <cprintf>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80049a:	e8 8c 12 00 00       	call   80172b <sys_enable_interrupt>

	// exit gracefully
	exit();
  80049f:	e8 19 00 00 00       	call   8004bd <exit>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004ad:	83 ec 0c             	sub    $0xc,%esp
  8004b0:	6a 00                	push   $0x0
  8004b2:	e8 19 14 00 00       	call   8018d0 <sys_destroy_env>
  8004b7:	83 c4 10             	add    $0x10,%esp
}
  8004ba:	90                   	nop
  8004bb:	c9                   	leave  
  8004bc:	c3                   	ret    

008004bd <exit>:

void
exit(void)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004c3:	e8 6e 14 00 00       	call   801936 <sys_exit_env>
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004d1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004d4:	83 c0 04             	add    $0x4,%eax
  8004d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004da:	a1 4c 31 80 00       	mov    0x80314c,%eax
  8004df:	85 c0                	test   %eax,%eax
  8004e1:	74 16                	je     8004f9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004e3:	a1 4c 31 80 00       	mov    0x80314c,%eax
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	50                   	push   %eax
  8004ec:	68 a4 23 80 00       	push   $0x8023a4
  8004f1:	e8 92 02 00 00       	call   800788 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004f9:	a1 38 30 80 00       	mov    0x803038,%eax
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	50                   	push   %eax
  800505:	68 a9 23 80 00       	push   $0x8023a9
  80050a:	e8 79 02 00 00       	call   800788 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800512:	8b 45 10             	mov    0x10(%ebp),%eax
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	ff 75 f4             	pushl  -0xc(%ebp)
  80051b:	50                   	push   %eax
  80051c:	e8 fc 01 00 00       	call   80071d <vcprintf>
  800521:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	6a 00                	push   $0x0
  800529:	68 c5 23 80 00       	push   $0x8023c5
  80052e:	e8 ea 01 00 00       	call   80071d <vcprintf>
  800533:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800536:	e8 82 ff ff ff       	call   8004bd <exit>

	// should not return here
	while (1) ;
  80053b:	eb fe                	jmp    80053b <_panic+0x70>

0080053d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800543:	a1 40 30 80 00       	mov    0x803040,%eax
  800548:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800551:	39 c2                	cmp    %eax,%edx
  800553:	74 14                	je     800569 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 c8 23 80 00       	push   $0x8023c8
  80055d:	6a 26                	push   $0x26
  80055f:	68 14 24 80 00       	push   $0x802414
  800564:	e8 62 ff ff ff       	call   8004cb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	e9 c5 00 00 00       	jmp    800641 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	01 d0                	add    %edx,%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	85 c0                	test   %eax,%eax
  80058f:	75 08                	jne    800599 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800591:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800594:	e9 a5 00 00 00       	jmp    80063e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800599:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 69                	jmp    800612 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005a9:	a1 40 30 80 00       	mov    0x803040,%eax
  8005ae:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b7:	89 d0                	mov    %edx,%eax
  8005b9:	01 c0                	add    %eax,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	c1 e0 03             	shl    $0x3,%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8a 40 04             	mov    0x4(%eax),%al
  8005c5:	84 c0                	test   %al,%al
  8005c7:	75 46                	jne    80060f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c9:	a1 40 30 80 00       	mov    0x803040,%eax
  8005ce:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d7:	89 d0                	mov    %edx,%eax
  8005d9:	01 c0                	add    %eax,%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	c1 e0 03             	shl    $0x3,%eax
  8005e0:	01 c8                	add    %ecx,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	01 c8                	add    %ecx,%eax
  800600:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800602:	39 c2                	cmp    %eax,%edx
  800604:	75 09                	jne    80060f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800606:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80060d:	eb 15                	jmp    800624 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060f:	ff 45 e8             	incl   -0x18(%ebp)
  800612:	a1 40 30 80 00       	mov    0x803040,%eax
  800617:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80061d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	77 85                	ja     8005a9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800624:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800628:	75 14                	jne    80063e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	68 20 24 80 00       	push   $0x802420
  800632:	6a 3a                	push   $0x3a
  800634:	68 14 24 80 00       	push   $0x802414
  800639:	e8 8d fe ff ff       	call   8004cb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80063e:	ff 45 f0             	incl   -0x10(%ebp)
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800644:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800647:	0f 8c 2f ff ff ff    	jl     80057c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80064d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800654:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80065b:	eb 26                	jmp    800683 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80065d:	a1 40 30 80 00       	mov    0x803040,%eax
  800662:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800668:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066b:	89 d0                	mov    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	c1 e0 03             	shl    $0x3,%eax
  800674:	01 c8                	add    %ecx,%eax
  800676:	8a 40 04             	mov    0x4(%eax),%al
  800679:	3c 01                	cmp    $0x1,%al
  80067b:	75 03                	jne    800680 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80067d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800680:	ff 45 e0             	incl   -0x20(%ebp)
  800683:	a1 40 30 80 00       	mov    0x803040,%eax
  800688:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80068e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800691:	39 c2                	cmp    %eax,%edx
  800693:	77 c8                	ja     80065d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800698:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069b:	74 14                	je     8006b1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	68 74 24 80 00       	push   $0x802474
  8006a5:	6a 44                	push   $0x44
  8006a7:	68 14 24 80 00       	push   $0x802414
  8006ac:	e8 1a fe ff ff       	call   8004cb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b1:	90                   	nop
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c5:	89 0a                	mov    %ecx,(%edx)
  8006c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ca:	88 d1                	mov    %dl,%cl
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006dd:	75 2c                	jne    80070b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006df:	a0 44 30 80 00       	mov    0x803044,%al
  8006e4:	0f b6 c0             	movzbl %al,%eax
  8006e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ea:	8b 12                	mov    (%edx),%edx
  8006ec:	89 d1                	mov    %edx,%ecx
  8006ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f1:	83 c2 08             	add    $0x8,%edx
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	50                   	push   %eax
  8006f8:	51                   	push   %ecx
  8006f9:	52                   	push   %edx
  8006fa:	e8 b9 0e 00 00       	call   8015b8 <sys_cputs>
  8006ff:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	8b 40 04             	mov    0x4(%eax),%eax
  800711:	8d 50 01             	lea    0x1(%eax),%edx
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071a:	90                   	nop
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    

0080071d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800726:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072d:	00 00 00 
	b.cnt = 0;
  800730:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800737:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	ff 75 08             	pushl  0x8(%ebp)
  800740:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800746:	50                   	push   %eax
  800747:	68 b4 06 80 00       	push   $0x8006b4
  80074c:	e8 11 02 00 00       	call   800962 <vprintfmt>
  800751:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800754:	a0 44 30 80 00       	mov    0x803044,%al
  800759:	0f b6 c0             	movzbl %al,%eax
  80075c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800762:	83 ec 04             	sub    $0x4,%esp
  800765:	50                   	push   %eax
  800766:	52                   	push   %edx
  800767:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076d:	83 c0 08             	add    $0x8,%eax
  800770:	50                   	push   %eax
  800771:	e8 42 0e 00 00       	call   8015b8 <sys_cputs>
  800776:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800779:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800780:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <cprintf>:

int cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800795:	8d 45 0c             	lea    0xc(%ebp),%eax
  800798:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a4:	50                   	push   %eax
  8007a5:	e8 73 ff ff ff       	call   80071d <vcprintf>
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bb:	e8 51 0f 00 00       	call   801711 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	50                   	push   %eax
  8007d0:	e8 48 ff ff ff       	call   80071d <vcprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007db:	e8 4b 0f 00 00       	call   80172b <sys_enable_interrupt>
	return cnt;
  8007e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 14             	sub    $0x14,%esp
  8007ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800803:	77 55                	ja     80085a <printnum+0x75>
  800805:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800808:	72 05                	jb     80080f <printnum+0x2a>
  80080a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080d:	77 4b                	ja     80085a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80080f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800812:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800815:	8b 45 18             	mov    0x18(%ebp),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	52                   	push   %edx
  80081e:	50                   	push   %eax
  80081f:	ff 75 f4             	pushl  -0xc(%ebp)
  800822:	ff 75 f0             	pushl  -0x10(%ebp)
  800825:	e8 16 14 00 00       	call   801c40 <__udivdi3>
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	ff 75 20             	pushl  0x20(%ebp)
  800833:	53                   	push   %ebx
  800834:	ff 75 18             	pushl  0x18(%ebp)
  800837:	52                   	push   %edx
  800838:	50                   	push   %eax
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 a1 ff ff ff       	call   8007e5 <printnum>
  800844:	83 c4 20             	add    $0x20,%esp
  800847:	eb 1a                	jmp    800863 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 20             	pushl  0x20(%ebp)
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	ff d0                	call   *%eax
  800857:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085a:	ff 4d 1c             	decl   0x1c(%ebp)
  80085d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800861:	7f e6                	jg     800849 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800863:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800866:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800871:	53                   	push   %ebx
  800872:	51                   	push   %ecx
  800873:	52                   	push   %edx
  800874:	50                   	push   %eax
  800875:	e8 d6 14 00 00       	call   801d50 <__umoddi3>
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	05 d4 26 80 00       	add    $0x8026d4,%eax
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be c0             	movsbl %al,%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
}
  800896:	90                   	nop
  800897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a3:	7e 1c                	jle    8008c1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	8d 50 08             	lea    0x8(%eax),%edx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	89 10                	mov    %edx,(%eax)
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	83 e8 08             	sub    $0x8,%eax
  8008ba:	8b 50 04             	mov    0x4(%eax),%edx
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	eb 40                	jmp    800901 <getuint+0x65>
	else if (lflag)
  8008c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c5:	74 1e                	je     8008e5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 50 04             	lea    0x4(%eax),%edx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	89 10                	mov    %edx,(%eax)
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	eb 1c                	jmp    800901 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800906:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090a:	7e 1c                	jle    800928 <getint+0x25>
		return va_arg(*ap, long long);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 08             	lea    0x8(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 08             	sub    $0x8,%eax
  800921:	8b 50 04             	mov    0x4(%eax),%edx
  800924:	8b 00                	mov    (%eax),%eax
  800926:	eb 38                	jmp    800960 <getint+0x5d>
	else if (lflag)
  800928:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092c:	74 1a                	je     800948 <getint+0x45>
		return va_arg(*ap, long);
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	8d 50 04             	lea    0x4(%eax),%edx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	89 10                	mov    %edx,(%eax)
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	83 e8 04             	sub    $0x4,%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	99                   	cltd   
  800946:	eb 18                	jmp    800960 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 50 04             	lea    0x4(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 10                	mov    %edx,(%eax)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	99                   	cltd   
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	eb 17                	jmp    800983 <vprintfmt+0x21>
			if (ch == '\0')
  80096c:	85 db                	test   %ebx,%ebx
  80096e:	0f 84 af 03 00 00    	je     800d23 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	8d 50 01             	lea    0x1(%eax),%edx
  800989:	89 55 10             	mov    %edx,0x10(%ebp)
  80098c:	8a 00                	mov    (%eax),%al
  80098e:	0f b6 d8             	movzbl %al,%ebx
  800991:	83 fb 25             	cmp    $0x25,%ebx
  800994:	75 d6                	jne    80096c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800996:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	8d 50 01             	lea    0x1(%eax),%edx
  8009bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bf:	8a 00                	mov    (%eax),%al
  8009c1:	0f b6 d8             	movzbl %al,%ebx
  8009c4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c7:	83 f8 55             	cmp    $0x55,%eax
  8009ca:	0f 87 2b 03 00 00    	ja     800cfb <vprintfmt+0x399>
  8009d0:	8b 04 85 f8 26 80 00 	mov    0x8026f8(,%eax,4),%eax
  8009d7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009dd:	eb d7                	jmp    8009b6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009df:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e3:	eb d1                	jmp    8009b6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	c1 e0 02             	shl    $0x2,%eax
  8009f4:	01 d0                	add    %edx,%eax
  8009f6:	01 c0                	add    %eax,%eax
  8009f8:	01 d8                	add    %ebx,%eax
  8009fa:	83 e8 30             	sub    $0x30,%eax
  8009fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	8a 00                	mov    (%eax),%al
  800a05:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a08:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0b:	7e 3e                	jle    800a4b <vprintfmt+0xe9>
  800a0d:	83 fb 39             	cmp    $0x39,%ebx
  800a10:	7f 39                	jg     800a4b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a12:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a15:	eb d5                	jmp    8009ec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 c0 04             	add    $0x4,%eax
  800a1d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a20:	8b 45 14             	mov    0x14(%ebp),%eax
  800a23:	83 e8 04             	sub    $0x4,%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a31:	79 83                	jns    8009b6 <vprintfmt+0x54>
				width = 0;
  800a33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3a:	e9 77 ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a3f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a46:	e9 6b ff ff ff       	jmp    8009b6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a50:	0f 89 60 ff ff ff    	jns    8009b6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a63:	e9 4e ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a68:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6b:	e9 46 ff ff ff       	jmp    8009b6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a70:	8b 45 14             	mov    0x14(%ebp),%eax
  800a73:	83 c0 04             	add    $0x4,%eax
  800a76:	89 45 14             	mov    %eax,0x14(%ebp)
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 e8 04             	sub    $0x4,%eax
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	50                   	push   %eax
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			break;
  800a90:	e9 89 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a95:	8b 45 14             	mov    0x14(%ebp),%eax
  800a98:	83 c0 04             	add    $0x4,%eax
  800a9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	83 e8 04             	sub    $0x4,%eax
  800aa4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	79 02                	jns    800aac <vprintfmt+0x14a>
				err = -err;
  800aaa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aac:	83 fb 64             	cmp    $0x64,%ebx
  800aaf:	7f 0b                	jg     800abc <vprintfmt+0x15a>
  800ab1:	8b 34 9d 40 25 80 00 	mov    0x802540(,%ebx,4),%esi
  800ab8:	85 f6                	test   %esi,%esi
  800aba:	75 19                	jne    800ad5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abc:	53                   	push   %ebx
  800abd:	68 e5 26 80 00       	push   $0x8026e5
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 5e 02 00 00       	call   800d2b <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad0:	e9 49 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad5:	56                   	push   %esi
  800ad6:	68 ee 26 80 00       	push   $0x8026ee
  800adb:	ff 75 0c             	pushl  0xc(%ebp)
  800ade:	ff 75 08             	pushl  0x8(%ebp)
  800ae1:	e8 45 02 00 00       	call   800d2b <printfmt>
  800ae6:	83 c4 10             	add    $0x10,%esp
			break;
  800ae9:	e9 30 02 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	83 c0 04             	add    $0x4,%eax
  800af4:	89 45 14             	mov    %eax,0x14(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	83 e8 04             	sub    $0x4,%eax
  800afd:	8b 30                	mov    (%eax),%esi
  800aff:	85 f6                	test   %esi,%esi
  800b01:	75 05                	jne    800b08 <vprintfmt+0x1a6>
				p = "(null)";
  800b03:	be f1 26 80 00       	mov    $0x8026f1,%esi
			if (width > 0 && padc != '-')
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	7e 6d                	jle    800b7b <vprintfmt+0x219>
  800b0e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b12:	74 67                	je     800b7b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	50                   	push   %eax
  800b1b:	56                   	push   %esi
  800b1c:	e8 0c 03 00 00       	call   800e2d <strnlen>
  800b21:	83 c4 10             	add    $0x10,%esp
  800b24:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b27:	eb 16                	jmp    800b3f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b29:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2d:	83 ec 08             	sub    $0x8,%esp
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	ff d0                	call   *%eax
  800b39:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b43:	7f e4                	jg     800b29 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b45:	eb 34                	jmp    800b7b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4b:	74 1c                	je     800b69 <vprintfmt+0x207>
  800b4d:	83 fb 1f             	cmp    $0x1f,%ebx
  800b50:	7e 05                	jle    800b57 <vprintfmt+0x1f5>
  800b52:	83 fb 7e             	cmp    $0x7e,%ebx
  800b55:	7e 12                	jle    800b69 <vprintfmt+0x207>
					putch('?', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	6a 3f                	push   $0x3f
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	53                   	push   %ebx
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	ff d0                	call   *%eax
  800b75:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b78:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7b:	89 f0                	mov    %esi,%eax
  800b7d:	8d 70 01             	lea    0x1(%eax),%esi
  800b80:	8a 00                	mov    (%eax),%al
  800b82:	0f be d8             	movsbl %al,%ebx
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	74 24                	je     800bad <vprintfmt+0x24b>
  800b89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8d:	78 b8                	js     800b47 <vprintfmt+0x1e5>
  800b8f:	ff 4d e0             	decl   -0x20(%ebp)
  800b92:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b96:	79 af                	jns    800b47 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b98:	eb 13                	jmp    800bad <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 20                	push   $0x20
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baa:	ff 4d e4             	decl   -0x1c(%ebp)
  800bad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb1:	7f e7                	jg     800b9a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb3:	e9 66 01 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc1:	50                   	push   %eax
  800bc2:	e8 3c fd ff ff       	call   800903 <getint>
  800bc7:	83 c4 10             	add    $0x10,%esp
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd6:	85 d2                	test   %edx,%edx
  800bd8:	79 23                	jns    800bfd <vprintfmt+0x29b>
				putch('-', putdat);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	6a 2d                	push   $0x2d
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf0:	f7 d8                	neg    %eax
  800bf2:	83 d2 00             	adc    $0x0,%edx
  800bf5:	f7 da                	neg    %edx
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bfd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c04:	e9 bc 00 00 00       	jmp    800cc5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c12:	50                   	push   %eax
  800c13:	e8 84 fc ff ff       	call   80089c <getuint>
  800c18:	83 c4 10             	add    $0x10,%esp
  800c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c28:	e9 98 00 00 00       	jmp    800cc5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	6a 58                	push   $0x58
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	ff d0                	call   *%eax
  800c3a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	6a 58                	push   $0x58
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	ff 75 0c             	pushl  0xc(%ebp)
  800c53:	6a 58                	push   $0x58
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
			break;
  800c5d:	e9 bc 00 00 00       	jmp    800d1e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 30                	push   $0x30
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 78                	push   $0x78
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c82:	8b 45 14             	mov    0x14(%ebp),%eax
  800c85:	83 c0 04             	add    $0x4,%eax
  800c88:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8e:	83 e8 04             	sub    $0x4,%eax
  800c91:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca4:	eb 1f                	jmp    800cc5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 e8             	pushl  -0x18(%ebp)
  800cac:	8d 45 14             	lea    0x14(%ebp),%eax
  800caf:	50                   	push   %eax
  800cb0:	e8 e7 fb ff ff       	call   80089c <getuint>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccc:	83 ec 04             	sub    $0x4,%esp
  800ccf:	52                   	push   %edx
  800cd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd3:	50                   	push   %eax
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	ff 75 08             	pushl  0x8(%ebp)
  800ce0:	e8 00 fb ff ff       	call   8007e5 <printnum>
  800ce5:	83 c4 20             	add    $0x20,%esp
			break;
  800ce8:	eb 34                	jmp    800d1e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	53                   	push   %ebx
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
			break;
  800cf9:	eb 23                	jmp    800d1e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	6a 25                	push   $0x25
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0b:	ff 4d 10             	decl   0x10(%ebp)
  800d0e:	eb 03                	jmp    800d13 <vprintfmt+0x3b1>
  800d10:	ff 4d 10             	decl   0x10(%ebp)
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	48                   	dec    %eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3c 25                	cmp    $0x25,%al
  800d1b:	75 f3                	jne    800d10 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1d:	90                   	nop
		}
	}
  800d1e:	e9 47 fc ff ff       	jmp    80096a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d23:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d31:	8d 45 10             	lea    0x10(%ebp),%eax
  800d34:	83 c0 04             	add    $0x4,%eax
  800d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	ff 75 08             	pushl  0x8(%ebp)
  800d47:	e8 16 fc ff ff       	call   800962 <vprintfmt>
  800d4c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4f:	90                   	nop
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8b 40 08             	mov    0x8(%eax),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	8b 10                	mov    (%eax),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 40 04             	mov    0x4(%eax),%eax
  800d6f:	39 c2                	cmp    %eax,%edx
  800d71:	73 12                	jae    800d85 <sprintputch+0x33>
		*b->buf++ = ch;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	89 0a                	mov    %ecx,(%edx)
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	88 10                	mov    %dl,(%eax)
}
  800d85:	90                   	nop
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	01 d0                	add    %edx,%eax
  800d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dad:	74 06                	je     800db5 <vsnprintf+0x2d>
  800daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db3:	7f 07                	jg     800dbc <vsnprintf+0x34>
		return -E_INVAL;
  800db5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dba:	eb 20                	jmp    800ddc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbc:	ff 75 14             	pushl  0x14(%ebp)
  800dbf:	ff 75 10             	pushl  0x10(%ebp)
  800dc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc5:	50                   	push   %eax
  800dc6:	68 52 0d 80 00       	push   $0x800d52
  800dcb:	e8 92 fb ff ff       	call   800962 <vprintfmt>
  800dd0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ddc:	c9                   	leave  
  800ddd:	c3                   	ret    

00800dde <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de4:	8d 45 10             	lea    0x10(%ebp),%eax
  800de7:	83 c0 04             	add    $0x4,%eax
  800dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	50                   	push   %eax
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	ff 75 08             	pushl  0x8(%ebp)
  800dfa:	e8 89 ff ff ff       	call   800d88 <vsnprintf>
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e17:	eb 06                	jmp    800e1f <strlen+0x15>
		n++;
  800e19:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1c:	ff 45 08             	incl   0x8(%ebp)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	84 c0                	test   %al,%al
  800e26:	75 f1                	jne    800e19 <strlen+0xf>
		n++;
	return n;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3a:	eb 09                	jmp    800e45 <strnlen+0x18>
		n++;
  800e3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	ff 4d 0c             	decl   0xc(%ebp)
  800e45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e49:	74 09                	je     800e54 <strnlen+0x27>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	84 c0                	test   %al,%al
  800e52:	75 e8                	jne    800e3c <strnlen+0xf>
		n++;
	return n;
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e65:	90                   	nop
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	84 c0                	test   %al,%al
  800e80:	75 e4                	jne    800e66 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9a:	eb 1f                	jmp    800ebb <strncpy+0x34>
		*dst++ = *src;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ea2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	84 c0                	test   %al,%al
  800eb3:	74 03                	je     800eb8 <strncpy+0x31>
			src++;
  800eb5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec1:	72 d9                	jb     800e9c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	74 30                	je     800f0a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eda:	eb 16                	jmp    800ef2 <strlcpy+0x2a>
			*dst++ = *src++;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef2:	ff 4d 10             	decl   0x10(%ebp)
  800ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef9:	74 09                	je     800f04 <strlcpy+0x3c>
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	84 c0                	test   %al,%al
  800f02:	75 d8                	jne    800edc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	29 c2                	sub    %eax,%edx
  800f12:	89 d0                	mov    %edx,%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f19:	eb 06                	jmp    800f21 <strcmp+0xb>
		p++, q++;
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	74 0e                	je     800f38 <strcmp+0x22>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 10                	mov    (%eax),%dl
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	38 c2                	cmp    %al,%dl
  800f36:	74 e3                	je     800f1b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f b6 d0             	movzbl %al,%edx
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f b6 c0             	movzbl %al,%eax
  800f48:	29 c2                	sub    %eax,%edx
  800f4a:	89 d0                	mov    %edx,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f51:	eb 09                	jmp    800f5c <strncmp+0xe>
		n--, p++, q++;
  800f53:	ff 4d 10             	decl   0x10(%ebp)
  800f56:	ff 45 08             	incl   0x8(%ebp)
  800f59:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 17                	je     800f79 <strncmp+0x2b>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	74 0e                	je     800f79 <strncmp+0x2b>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 10                	mov    (%eax),%dl
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	38 c2                	cmp    %al,%dl
  800f77:	74 da                	je     800f53 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7d:	75 07                	jne    800f86 <strncmp+0x38>
		return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	eb 14                	jmp    800f9a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	0f b6 c0             	movzbl %al,%eax
  800f96:	29 c2                	sub    %eax,%edx
  800f98:	89 d0                	mov    %edx,%eax
}
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 04             	sub    $0x4,%esp
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa8:	eb 12                	jmp    800fbc <strchr+0x20>
		if (*s == c)
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb2:	75 05                	jne    800fb9 <strchr+0x1d>
			return (char *) s;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	eb 11                	jmp    800fca <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb9:	ff 45 08             	incl   0x8(%ebp)
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	84 c0                	test   %al,%al
  800fc3:	75 e5                	jne    800faa <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd8:	eb 0d                	jmp    800fe7 <strfind+0x1b>
		if (*s == c)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe2:	74 0e                	je     800ff2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	84 c0                	test   %al,%al
  800fee:	75 ea                	jne    800fda <strfind+0xe>
  800ff0:	eb 01                	jmp    800ff3 <strfind+0x27>
		if (*s == c)
			break;
  800ff2:	90                   	nop
	return (char *) s;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100a:	eb 0e                	jmp    80101a <memset+0x22>
		*p++ = c;
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801015:	8b 55 0c             	mov    0xc(%ebp),%edx
  801018:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101a:	ff 4d f8             	decl   -0x8(%ebp)
  80101d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801021:	79 e9                	jns    80100c <memset+0x14>
		*p++ = c;

	return v;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103a:	eb 16                	jmp    801052 <memcpy+0x2a>
		*d++ = *s++;
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	8d 50 01             	lea    0x1(%eax),%edx
  801042:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801045:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801048:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80104e:	8a 12                	mov    (%edx),%dl
  801050:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 dd                	jne    80103c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801076:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801079:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107c:	73 50                	jae    8010ce <memmove+0x6a>
  80107e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	01 d0                	add    %edx,%eax
  801086:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801089:	76 43                	jbe    8010ce <memmove+0x6a>
		s += n;
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801091:	8b 45 10             	mov    0x10(%ebp),%eax
  801094:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801097:	eb 10                	jmp    8010a9 <memmove+0x45>
			*--d = *--s;
  801099:	ff 4d f8             	decl   -0x8(%ebp)
  80109c:	ff 4d fc             	decl   -0x4(%ebp)
  80109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a2:	8a 10                	mov    (%eax),%dl
  8010a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010af:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	75 e3                	jne    801099 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b6:	eb 23                	jmp    8010db <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ca:	8a 12                	mov    (%edx),%dl
  8010cc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	75 dd                	jne    8010b8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f2:	eb 2a                	jmp    80111e <memcmp+0x3e>
		if (*s1 != *s2)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 10                	mov    (%eax),%dl
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	38 c2                	cmp    %al,%dl
  801100:	74 16                	je     801118 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f b6 d0             	movzbl %al,%edx
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 c0             	movzbl %al,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	eb 18                	jmp    801130 <memcmp+0x50>
		s1++, s2++;
  801118:	ff 45 fc             	incl   -0x4(%ebp)
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	8d 50 ff             	lea    -0x1(%eax),%edx
  801124:	89 55 10             	mov    %edx,0x10(%ebp)
  801127:	85 c0                	test   %eax,%eax
  801129:	75 c9                	jne    8010f4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801143:	eb 15                	jmp    80115a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	0f b6 c0             	movzbl %al,%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	74 0d                	je     801164 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801157:	ff 45 08             	incl   0x8(%ebp)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801160:	72 e3                	jb     801145 <memfind+0x13>
  801162:	eb 01                	jmp    801165 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801164:	90                   	nop
	return (void *) s;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801170:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801177:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80117e:	eb 03                	jmp    801183 <strtol+0x19>
		s++;
  801180:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 20                	cmp    $0x20,%al
  80118a:	74 f4                	je     801180 <strtol+0x16>
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 09                	cmp    $0x9,%al
  801193:	74 eb                	je     801180 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 2b                	cmp    $0x2b,%al
  80119c:	75 05                	jne    8011a3 <strtol+0x39>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	eb 13                	jmp    8011b6 <strtol+0x4c>
	else if (*s == '-')
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	3c 2d                	cmp    $0x2d,%al
  8011aa:	75 0a                	jne    8011b6 <strtol+0x4c>
		s++, neg = 1;
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ba:	74 06                	je     8011c2 <strtol+0x58>
  8011bc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c0:	75 20                	jne    8011e2 <strtol+0x78>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 30                	cmp    $0x30,%al
  8011c9:	75 17                	jne    8011e2 <strtol+0x78>
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	40                   	inc    %eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	3c 78                	cmp    $0x78,%al
  8011d3:	75 0d                	jne    8011e2 <strtol+0x78>
		s += 2, base = 16;
  8011d5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011d9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e0:	eb 28                	jmp    80120a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e6:	75 15                	jne    8011fd <strtol+0x93>
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 30                	cmp    $0x30,%al
  8011ef:	75 0c                	jne    8011fd <strtol+0x93>
		s++, base = 8;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fb:	eb 0d                	jmp    80120a <strtol+0xa0>
	else if (base == 0)
  8011fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801201:	75 07                	jne    80120a <strtol+0xa0>
		base = 10;
  801203:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	3c 2f                	cmp    $0x2f,%al
  801211:	7e 19                	jle    80122c <strtol+0xc2>
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 39                	cmp    $0x39,%al
  80121a:	7f 10                	jg     80122c <strtol+0xc2>
			dig = *s - '0';
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	0f be c0             	movsbl %al,%eax
  801224:	83 e8 30             	sub    $0x30,%eax
  801227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122a:	eb 42                	jmp    80126e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	3c 60                	cmp    $0x60,%al
  801233:	7e 19                	jle    80124e <strtol+0xe4>
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 7a                	cmp    $0x7a,%al
  80123c:	7f 10                	jg     80124e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	0f be c0             	movsbl %al,%eax
  801246:	83 e8 57             	sub    $0x57,%eax
  801249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124c:	eb 20                	jmp    80126e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 40                	cmp    $0x40,%al
  801255:	7e 39                	jle    801290 <strtol+0x126>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 5a                	cmp    $0x5a,%al
  80125e:	7f 30                	jg     801290 <strtol+0x126>
			dig = *s - 'A' + 10;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f be c0             	movsbl %al,%eax
  801268:	83 e8 37             	sub    $0x37,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	3b 45 10             	cmp    0x10(%ebp),%eax
  801274:	7d 19                	jge    80128f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801276:	ff 45 08             	incl   0x8(%ebp)
  801279:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801280:	89 c2                	mov    %eax,%edx
  801282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128a:	e9 7b ff ff ff       	jmp    80120a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80128f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801290:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801294:	74 08                	je     80129e <strtol+0x134>
		*endptr = (char *) s;
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80129e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a2:	74 07                	je     8012ab <strtol+0x141>
  8012a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a7:	f7 d8                	neg    %eax
  8012a9:	eb 03                	jmp    8012ae <strtol+0x144>
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c8:	79 13                	jns    8012dd <ltostr+0x2d>
	{
		neg = 1;
  8012ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012da:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e5:	99                   	cltd   
  8012e6:	f7 f9                	idiv   %ecx
  8012e8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ee:	8d 50 01             	lea    0x1(%eax),%edx
  8012f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f4:	89 c2                	mov    %eax,%edx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012fe:	83 c2 30             	add    $0x30,%edx
  801301:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801324:	f7 e9                	imul   %ecx
  801326:	c1 fa 02             	sar    $0x2,%edx
  801329:	89 c8                	mov    %ecx,%eax
  80132b:	c1 f8 1f             	sar    $0x1f,%eax
  80132e:	29 c2                	sub    %eax,%edx
  801330:	89 d0                	mov    %edx,%eax
  801332:	c1 e0 02             	shl    $0x2,%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	01 c0                	add    %eax,%eax
  801339:	29 c1                	sub    %eax,%ecx
  80133b:	89 ca                	mov    %ecx,%edx
  80133d:	85 d2                	test   %edx,%edx
  80133f:	75 9c                	jne    8012dd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801341:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	48                   	dec    %eax
  80134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80134f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801353:	74 3d                	je     801392 <ltostr+0xe2>
		start = 1 ;
  801355:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135c:	eb 34                	jmp    801392 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80135e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801371:	01 c2                	add    %eax,%edx
  801373:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 c8                	add    %ecx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80137f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138a:	88 02                	mov    %al,(%edx)
		start++ ;
  80138c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80138f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801398:	7c c4                	jl     80135e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	01 d0                	add    %edx,%eax
  8013a2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a5:	90                   	nop
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ae:	ff 75 08             	pushl  0x8(%ebp)
  8013b1:	e8 54 fa ff ff       	call   800e0a <strlen>
  8013b6:	83 c4 04             	add    $0x4,%esp
  8013b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	e8 46 fa ff ff       	call   800e0a <strlen>
  8013c4:	83 c4 04             	add    $0x4,%esp
  8013c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d8:	eb 17                	jmp    8013f1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	01 c8                	add    %ecx,%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013ee:	ff 45 fc             	incl   -0x4(%ebp)
  8013f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f7:	7c e1                	jl     8013da <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801400:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801407:	eb 1f                	jmp    801428 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140c:	8d 50 01             	lea    0x1(%eax),%edx
  80140f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801412:	89 c2                	mov    %eax,%edx
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	01 c2                	add    %eax,%edx
  801419:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141f:	01 c8                	add    %ecx,%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801425:	ff 45 f8             	incl   -0x8(%ebp)
  801428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142e:	7c d9                	jl     801409 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801430:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	01 d0                	add    %edx,%eax
  801438:	c6 00 00             	movb   $0x0,(%eax)
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801441:	8b 45 14             	mov    0x14(%ebp),%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8b 00                	mov    (%eax),%eax
  80144f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801456:	8b 45 10             	mov    0x10(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801461:	eb 0c                	jmp    80146f <strsplit+0x31>
			*string++ = 0;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8d 50 01             	lea    0x1(%eax),%edx
  801469:	89 55 08             	mov    %edx,0x8(%ebp)
  80146c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	84 c0                	test   %al,%al
  801476:	74 18                	je     801490 <strsplit+0x52>
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	0f be c0             	movsbl %al,%eax
  801480:	50                   	push   %eax
  801481:	ff 75 0c             	pushl  0xc(%ebp)
  801484:	e8 13 fb ff ff       	call   800f9c <strchr>
  801489:	83 c4 08             	add    $0x8,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	75 d3                	jne    801463 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	84 c0                	test   %al,%al
  801497:	74 5a                	je     8014f3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801499:	8b 45 14             	mov    0x14(%ebp),%eax
  80149c:	8b 00                	mov    (%eax),%eax
  80149e:	83 f8 0f             	cmp    $0xf,%eax
  8014a1:	75 07                	jne    8014aa <strsplit+0x6c>
		{
			return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a8:	eb 66                	jmp    801510 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ad:	8b 00                	mov    (%eax),%eax
  8014af:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b2:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b5:	89 0a                	mov    %ecx,(%edx)
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 c2                	add    %eax,%edx
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c8:	eb 03                	jmp    8014cd <strsplit+0x8f>
			string++;
  8014ca:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	84 c0                	test   %al,%al
  8014d4:	74 8b                	je     801461 <strsplit+0x23>
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	0f be c0             	movsbl %al,%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 b5 fa ff ff       	call   800f9c <strchr>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 dc                	je     8014ca <strsplit+0x8c>
			string++;
	}
  8014ee:	e9 6e ff ff ff       	jmp    801461 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80151f:	eb 4c                	jmp    80156d <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	01 d0                	add    %edx,%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	3c 40                	cmp    $0x40,%al
  80152d:	7e 27                	jle    801556 <str2lower+0x44>
  80152f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801532:	8b 45 0c             	mov    0xc(%ebp),%eax
  801535:	01 d0                	add    %edx,%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	3c 5a                	cmp    $0x5a,%al
  80153b:	7f 19                	jg     801556 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80153d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154b:	01 ca                	add    %ecx,%edx
  80154d:	8a 12                	mov    (%edx),%dl
  80154f:	83 c2 20             	add    $0x20,%edx
  801552:	88 10                	mov    %dl,(%eax)
  801554:	eb 14                	jmp    80156a <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801556:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	01 c2                	add    %eax,%edx
  80155e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c8                	add    %ecx,%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80156a:	ff 45 fc             	incl   -0x4(%ebp)
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	e8 95 f8 ff ff       	call   800e0a <strlen>
  801575:	83 c4 04             	add    $0x4,%esp
  801578:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157b:	7f a4                	jg     801521 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  80157d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	57                   	push   %edi
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015a8:	cd 30                	int    $0x30
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5f                   	pop    %edi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	52                   	push   %edx
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	50                   	push   %eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 b2 ff ff ff       	call   80158d <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 01                	push   $0x1
  8015f0:	e8 98 ff ff ff       	call   80158d <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 05                	push   $0x5
  80160d:	e8 7b ff ff ff       	call   80158d <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161c:	8b 75 18             	mov    0x18(%ebp),%esi
  80161f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
  80162d:	51                   	push   %ecx
  80162e:	52                   	push   %edx
  80162f:	50                   	push   %eax
  801630:	6a 06                	push   $0x6
  801632:	e8 56 ff ff ff       	call   80158d <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801644:	8b 55 0c             	mov    0xc(%ebp),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	52                   	push   %edx
  801651:	50                   	push   %eax
  801652:	6a 07                	push   $0x7
  801654:	e8 34 ff ff ff       	call   80158d <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	6a 08                	push   $0x8
  80166f:	e8 19 ff ff ff       	call   80158d <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 09                	push   $0x9
  801688:	e8 00 ff ff ff       	call   80158d <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 0a                	push   $0xa
  8016a1:	e8 e7 fe ff ff       	call   80158d <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 0b                	push   $0xb
  8016ba:	e8 ce fe ff ff       	call   80158d <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 0c                	push   $0xc
  8016d3:	e8 b5 fe ff ff       	call   80158d <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	6a 0d                	push   $0xd
  8016ed:	e8 9b fe ff ff       	call   80158d <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0e                	push   $0xe
  801706:	e8 82 fe ff ff       	call   80158d <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 11                	push   $0x11
  801720:	e8 68 fe ff ff       	call   80158d <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 12                	push   $0x12
  80173a:	e8 4e fe ff ff       	call   80158d <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_cputc>:


void
sys_cputc(const char c)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801751:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	50                   	push   %eax
  80175e:	6a 13                	push   $0x13
  801760:	e8 28 fe ff ff       	call   80158d <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 14                	push   $0x14
  80177a:	e8 0e fe ff ff       	call   80158d <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	90                   	nop
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	50                   	push   %eax
  801795:	6a 15                	push   $0x15
  801797:	e8 f1 fd ff ff       	call   80158d <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 18                	push   $0x18
  8017b4:	e8 d4 fd ff ff       	call   80158d <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	52                   	push   %edx
  8017ce:	50                   	push   %eax
  8017cf:	6a 16                	push   $0x16
  8017d1:	e8 b7 fd ff ff       	call   80158d <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 17                	push   $0x17
  8017ef:	e8 99 fd ff ff       	call   80158d <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	8b 45 10             	mov    0x10(%ebp),%eax
  801803:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801806:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801809:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	51                   	push   %ecx
  801813:	52                   	push   %edx
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	6a 19                	push   $0x19
  80181a:	e8 6e fd ff ff       	call   80158d <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	6a 1a                	push   $0x1a
  801837:	e8 51 fd ff ff       	call   80158d <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	51                   	push   %ecx
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 1b                	push   $0x1b
  801856:	e8 32 fd ff ff       	call   80158d <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 1c                	push   $0x1c
  801873:	e8 15 fd ff ff       	call   80158d <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 1d                	push   $0x1d
  80188c:	e8 fc fc ff ff       	call   80158d <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 14             	pushl  0x14(%ebp)
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	6a 1e                	push   $0x1e
  8018aa:	e8 de fc ff ff       	call   80158d <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	50                   	push   %eax
  8018c3:	6a 1f                	push   $0x1f
  8018c5:	e8 c3 fc ff ff       	call   80158d <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	50                   	push   %eax
  8018df:	6a 20                	push   $0x20
  8018e1:	e8 a7 fc ff ff       	call   80158d <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 02                	push   $0x2
  8018fa:	e8 8e fc ff ff       	call   80158d <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 03                	push   $0x3
  801913:	e8 75 fc ff ff       	call   80158d <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 04                	push   $0x4
  80192c:	e8 5c fc ff ff       	call   80158d <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_exit_env>:


void sys_exit_env(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 21                	push   $0x21
  801945:	e8 43 fc ff ff       	call   80158d <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801956:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801959:	8d 50 04             	lea    0x4(%eax),%edx
  80195c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 22                	push   $0x22
  801969:	e8 1f fc ff ff       	call   80158d <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return result;
  801971:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801974:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801977:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197a:	89 01                	mov    %eax,(%ecx)
  80197c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	c9                   	leave  
  801983:	c2 04 00             	ret    $0x4

00801986 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 10             	pushl  0x10(%ebp)
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 10                	push   $0x10
  801998:	e8 f0 fb ff ff       	call   80158d <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 23                	push   $0x23
  8019b2:	e8 d6 fb ff ff       	call   80158d <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	50                   	push   %eax
  8019d5:	6a 24                	push   $0x24
  8019d7:	e8 b1 fb ff ff       	call   80158d <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <rsttst>:
void rsttst()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 26                	push   $0x26
  8019f1:	e8 97 fb ff ff       	call   80158d <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f9:	90                   	nop
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 14             	mov    0x14(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a08:	8b 55 18             	mov    0x18(%ebp),%edx
  801a0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	ff 75 10             	pushl  0x10(%ebp)
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 25                	push   $0x25
  801a1c:	e8 6c fb ff ff       	call   80158d <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return ;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <chktst>:
void chktst(uint32 n)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 27                	push   $0x27
  801a37:	e8 51 fb ff ff       	call   80158d <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <inctst>:

void inctst()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 28                	push   $0x28
  801a51:	e8 37 fb ff ff       	call   80158d <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
	return ;
  801a59:	90                   	nop
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <gettst>:
uint32 gettst()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 29                	push   $0x29
  801a6b:	e8 1d fb ff ff       	call   80158d <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 2a                	push   $0x2a
  801a87:	e8 01 fb ff ff       	call   80158d <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
  801a8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a92:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a96:	75 07                	jne    801a9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a98:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9d:	eb 05                	jmp    801aa4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 2a                	push   $0x2a
  801ab8:	e8 d0 fa ff ff       	call   80158d <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
  801ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ac3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ac7:	75 07                	jne    801ad0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ace:	eb 05                	jmp    801ad5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 2a                	push   $0x2a
  801ae9:	e8 9f fa ff ff       	call   80158d <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
  801af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801af4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801af8:	75 07                	jne    801b01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801afa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aff:	eb 05                	jmp    801b06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 2a                	push   $0x2a
  801b1a:	e8 6e fa ff ff       	call   80158d <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b25:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b29:	75 07                	jne    801b32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b30:	eb 05                	jmp    801b37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	ff 75 08             	pushl  0x8(%ebp)
  801b47:	6a 2b                	push   $0x2b
  801b49:	e8 3f fa ff ff       	call   80158d <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b51:	90                   	nop
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	53                   	push   %ebx
  801b67:	51                   	push   %ecx
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 2c                	push   $0x2c
  801b6c:	e8 1c fa ff ff       	call   80158d <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	6a 2d                	push   $0x2d
  801b8c:	e8 fc f9 ff ff       	call   80158d <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b99:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	51                   	push   %ecx
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 2e                	push   $0x2e
  801bac:	e8 dc f9 ff ff       	call   80158d <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 10             	pushl  0x10(%ebp)
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	6a 0f                	push   $0xf
  801bc8:	e8 c0 f9 ff ff       	call   80158d <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd0:	90                   	nop
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 2f                	push   $0x2f
  801be4:	e8 a4 f9 ff ff       	call   80158d <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp

}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 30                	push   $0x30
  801bff:	e8 89 f9 ff ff       	call   80158d <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp

}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	6a 31                	push   $0x31
  801c1b:	e8 6d f9 ff ff       	call   80158d <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp

}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 32                	push   $0x32
  801c35:	e8 53 f9 ff ff       	call   80158d <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    
  801c3f:	90                   	nop

00801c40 <__udivdi3>:
  801c40:	55                   	push   %ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c57:	89 ca                	mov    %ecx,%edx
  801c59:	89 f8                	mov    %edi,%eax
  801c5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c5f:	85 f6                	test   %esi,%esi
  801c61:	75 2d                	jne    801c90 <__udivdi3+0x50>
  801c63:	39 cf                	cmp    %ecx,%edi
  801c65:	77 65                	ja     801ccc <__udivdi3+0x8c>
  801c67:	89 fd                	mov    %edi,%ebp
  801c69:	85 ff                	test   %edi,%edi
  801c6b:	75 0b                	jne    801c78 <__udivdi3+0x38>
  801c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c72:	31 d2                	xor    %edx,%edx
  801c74:	f7 f7                	div    %edi
  801c76:	89 c5                	mov    %eax,%ebp
  801c78:	31 d2                	xor    %edx,%edx
  801c7a:	89 c8                	mov    %ecx,%eax
  801c7c:	f7 f5                	div    %ebp
  801c7e:	89 c1                	mov    %eax,%ecx
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	f7 f5                	div    %ebp
  801c84:	89 cf                	mov    %ecx,%edi
  801c86:	89 fa                	mov    %edi,%edx
  801c88:	83 c4 1c             	add    $0x1c,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5f                   	pop    %edi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    
  801c90:	39 ce                	cmp    %ecx,%esi
  801c92:	77 28                	ja     801cbc <__udivdi3+0x7c>
  801c94:	0f bd fe             	bsr    %esi,%edi
  801c97:	83 f7 1f             	xor    $0x1f,%edi
  801c9a:	75 40                	jne    801cdc <__udivdi3+0x9c>
  801c9c:	39 ce                	cmp    %ecx,%esi
  801c9e:	72 0a                	jb     801caa <__udivdi3+0x6a>
  801ca0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ca4:	0f 87 9e 00 00 00    	ja     801d48 <__udivdi3+0x108>
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	89 fa                	mov    %edi,%edx
  801cb1:	83 c4 1c             	add    $0x1c,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5f                   	pop    %edi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
  801cb9:	8d 76 00             	lea    0x0(%esi),%esi
  801cbc:	31 ff                	xor    %edi,%edi
  801cbe:	31 c0                	xor    %eax,%eax
  801cc0:	89 fa                	mov    %edi,%edx
  801cc2:	83 c4 1c             	add    $0x1c,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	f7 f7                	div    %edi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	89 fa                	mov    %edi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce1:	89 eb                	mov    %ebp,%ebx
  801ce3:	29 fb                	sub    %edi,%ebx
  801ce5:	89 f9                	mov    %edi,%ecx
  801ce7:	d3 e6                	shl    %cl,%esi
  801ce9:	89 c5                	mov    %eax,%ebp
  801ceb:	88 d9                	mov    %bl,%cl
  801ced:	d3 ed                	shr    %cl,%ebp
  801cef:	89 e9                	mov    %ebp,%ecx
  801cf1:	09 f1                	or     %esi,%ecx
  801cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cf7:	89 f9                	mov    %edi,%ecx
  801cf9:	d3 e0                	shl    %cl,%eax
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 d6                	mov    %edx,%esi
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ee                	shr    %cl,%esi
  801d03:	89 f9                	mov    %edi,%ecx
  801d05:	d3 e2                	shl    %cl,%edx
  801d07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0b:	88 d9                	mov    %bl,%cl
  801d0d:	d3 e8                	shr    %cl,%eax
  801d0f:	09 c2                	or     %eax,%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	f7 74 24 0c          	divl   0xc(%esp)
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	f7 e5                	mul    %ebp
  801d1f:	39 d6                	cmp    %edx,%esi
  801d21:	72 19                	jb     801d3c <__udivdi3+0xfc>
  801d23:	74 0b                	je     801d30 <__udivdi3+0xf0>
  801d25:	89 d8                	mov    %ebx,%eax
  801d27:	31 ff                	xor    %edi,%edi
  801d29:	e9 58 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d34:	89 f9                	mov    %edi,%ecx
  801d36:	d3 e2                	shl    %cl,%edx
  801d38:	39 c2                	cmp    %eax,%edx
  801d3a:	73 e9                	jae    801d25 <__udivdi3+0xe5>
  801d3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d3f:	31 ff                	xor    %edi,%edi
  801d41:	e9 40 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	31 c0                	xor    %eax,%eax
  801d4a:	e9 37 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d4f:	90                   	nop

00801d50 <__umoddi3>:
  801d50:	55                   	push   %ebp
  801d51:	57                   	push   %edi
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	83 ec 1c             	sub    $0x1c,%esp
  801d57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d6f:	89 f3                	mov    %esi,%ebx
  801d71:	89 fa                	mov    %edi,%edx
  801d73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d77:	89 34 24             	mov    %esi,(%esp)
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	75 1a                	jne    801d98 <__umoddi3+0x48>
  801d7e:	39 f7                	cmp    %esi,%edi
  801d80:	0f 86 a2 00 00 00    	jbe    801e28 <__umoddi3+0xd8>
  801d86:	89 c8                	mov    %ecx,%eax
  801d88:	89 f2                	mov    %esi,%edx
  801d8a:	f7 f7                	div    %edi
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	83 c4 1c             	add    $0x1c,%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    
  801d98:	39 f0                	cmp    %esi,%eax
  801d9a:	0f 87 ac 00 00 00    	ja     801e4c <__umoddi3+0xfc>
  801da0:	0f bd e8             	bsr    %eax,%ebp
  801da3:	83 f5 1f             	xor    $0x1f,%ebp
  801da6:	0f 84 ac 00 00 00    	je     801e58 <__umoddi3+0x108>
  801dac:	bf 20 00 00 00       	mov    $0x20,%edi
  801db1:	29 ef                	sub    %ebp,%edi
  801db3:	89 fe                	mov    %edi,%esi
  801db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	d3 e0                	shl    %cl,%eax
  801dbd:	89 d7                	mov    %edx,%edi
  801dbf:	89 f1                	mov    %esi,%ecx
  801dc1:	d3 ef                	shr    %cl,%edi
  801dc3:	09 c7                	or     %eax,%edi
  801dc5:	89 e9                	mov    %ebp,%ecx
  801dc7:	d3 e2                	shl    %cl,%edx
  801dc9:	89 14 24             	mov    %edx,(%esp)
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	d3 e0                	shl    %cl,%eax
  801dd0:	89 c2                	mov    %eax,%edx
  801dd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd6:	d3 e0                	shl    %cl,%eax
  801dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de0:	89 f1                	mov    %esi,%ecx
  801de2:	d3 e8                	shr    %cl,%eax
  801de4:	09 d0                	or     %edx,%eax
  801de6:	d3 eb                	shr    %cl,%ebx
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	f7 f7                	div    %edi
  801dec:	89 d3                	mov    %edx,%ebx
  801dee:	f7 24 24             	mull   (%esp)
  801df1:	89 c6                	mov    %eax,%esi
  801df3:	89 d1                	mov    %edx,%ecx
  801df5:	39 d3                	cmp    %edx,%ebx
  801df7:	0f 82 87 00 00 00    	jb     801e84 <__umoddi3+0x134>
  801dfd:	0f 84 91 00 00 00    	je     801e94 <__umoddi3+0x144>
  801e03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e07:	29 f2                	sub    %esi,%edx
  801e09:	19 cb                	sbb    %ecx,%ebx
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e11:	d3 e0                	shl    %cl,%eax
  801e13:	89 e9                	mov    %ebp,%ecx
  801e15:	d3 ea                	shr    %cl,%edx
  801e17:	09 d0                	or     %edx,%eax
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 eb                	shr    %cl,%ebx
  801e1d:	89 da                	mov    %ebx,%edx
  801e1f:	83 c4 1c             	add    $0x1c,%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    
  801e27:	90                   	nop
  801e28:	89 fd                	mov    %edi,%ebp
  801e2a:	85 ff                	test   %edi,%edi
  801e2c:	75 0b                	jne    801e39 <__umoddi3+0xe9>
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f7                	div    %edi
  801e37:	89 c5                	mov    %eax,%ebp
  801e39:	89 f0                	mov    %esi,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f5                	div    %ebp
  801e3f:	89 c8                	mov    %ecx,%eax
  801e41:	f7 f5                	div    %ebp
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	e9 44 ff ff ff       	jmp    801d8e <__umoddi3+0x3e>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	89 c8                	mov    %ecx,%eax
  801e4e:	89 f2                	mov    %esi,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	3b 04 24             	cmp    (%esp),%eax
  801e5b:	72 06                	jb     801e63 <__umoddi3+0x113>
  801e5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e61:	77 0f                	ja     801e72 <__umoddi3+0x122>
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	29 f9                	sub    %edi,%ecx
  801e67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e6b:	89 14 24             	mov    %edx,(%esp)
  801e6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e76:	8b 14 24             	mov    (%esp),%edx
  801e79:	83 c4 1c             	add    $0x1c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
  801e81:	8d 76 00             	lea    0x0(%esi),%esi
  801e84:	2b 04 24             	sub    (%esp),%eax
  801e87:	19 fa                	sbb    %edi,%edx
  801e89:	89 d1                	mov    %edx,%ecx
  801e8b:	89 c6                	mov    %eax,%esi
  801e8d:	e9 71 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e98:	72 ea                	jb     801e84 <__umoddi3+0x134>
  801e9a:	89 d9                	mov    %ebx,%ecx
  801e9c:	e9 62 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>
