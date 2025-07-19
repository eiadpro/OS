
obj/user/tst_placement_3:     file format elf32-i386


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
  800031:	e8 bc 03 00 00       	call   8003f2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern uint32 initFreeFrames;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 80 00 00 01    	sub    $0x1000080,%esp

	int8 arr[PAGE_SIZE*1024*4];
	int x = 0;
  800043:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  80004a:	8d 95 9c ff ff fe    	lea    -0x1000064(%ebp),%edx
  800050:	b9 0d 00 00 00       	mov    $0xd,%ecx
  800055:	b8 00 00 00 00       	mov    $0x0,%eax
  80005a:	89 d7                	mov    %edx,%edi
  80005c:	f3 ab                	rep stos %eax,%es:(%edi)
  80005e:	c7 85 9c ff ff fe 00 	movl   $0xedbfd000,-0x1000064(%ebp)
  800065:	d0 bf ed 
  800068:	c7 85 a0 ff ff fe 00 	movl   $0xeebfd000,-0x1000060(%ebp)
  80006f:	d0 bf ee 
  800072:	c7 85 a4 ff ff fe 00 	movl   $0x803000,-0x100005c(%ebp)
  800079:	30 80 00 
  80007c:	c7 85 a8 ff ff fe 00 	movl   $0x802000,-0x1000058(%ebp)
  800083:	20 80 00 
  800086:	c7 85 ac ff ff fe 00 	movl   $0x801000,-0x1000054(%ebp)
  80008d:	10 80 00 
  800090:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800097:	00 80 00 
  80009a:	c7 85 b4 ff ff fe 00 	movl   $0x205000,-0x100004c(%ebp)
  8000a1:	50 20 00 
  8000a4:	c7 85 b8 ff ff fe 00 	movl   $0x204000,-0x1000048(%ebp)
  8000ab:	40 20 00 
  8000ae:	c7 85 bc ff ff fe 00 	movl   $0x203000,-0x1000044(%ebp)
  8000b5:	30 20 00 
  8000b8:	c7 85 c0 ff ff fe 00 	movl   $0x202000,-0x1000040(%ebp)
  8000bf:	20 20 00 
  8000c2:	c7 85 c4 ff ff fe 00 	movl   $0x201000,-0x100003c(%ebp)
  8000c9:	10 20 00 
  8000cc:	c7 85 c8 ff ff fe 00 	movl   $0x200000,-0x1000038(%ebp)
  8000d3:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000d6:	8d 95 80 ff ff fe    	lea    -0x1000080(%ebp),%edx
  8000dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000ea:	6a 00                	push   $0x0
  8000ec:	6a 0c                	push   $0xc
  8000ee:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 b1 1a 00 00       	call   801bb2 <sys_check_LRU_lists>
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80010b:	75 14                	jne    800121 <_main+0xe9>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 20 1f 80 00       	push   $0x801f20
  800115:	6a 15                	push   $0x15
  800117:	68 a2 1f 80 00       	push   $0x801fa2
  80011c:	e8 08 04 00 00       	call   800529 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800121:	e8 fc 15 00 00       	call   801722 <sys_pf_calculate_allocated_pages>
  800126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  800129:	e8 a9 15 00 00       	call   8016d7 <sys_calculate_free_frames>
  80012e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int i=0;
  800131:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800138:	eb 11                	jmp    80014b <_main+0x113>
	{
		arr[i] = -1;
  80013a:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800143:	01 d0                	add    %edx,%eax
  800145:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800148:	ff 45 f4             	incl   -0xc(%ebp)
  80014b:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800152:	7e e6                	jle    80013a <_main+0x102>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800154:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80015b:	eb 11                	jmp    80016e <_main+0x136>
	{
		arr[i] = -1;
  80015d:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80016b:	ff 45 f4             	incl   -0xc(%ebp)
  80016e:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800175:	7e e6                	jle    80015d <_main+0x125>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800177:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80017e:	eb 11                	jmp    800191 <_main+0x159>
	{
		arr[i] = -1;
  800180:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800189:	01 d0                	add    %edx,%eax
  80018b:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80018e:	ff 45 f4             	incl   -0xc(%ebp)
  800191:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800198:	7e e6                	jle    800180 <_main+0x148>
	{
		arr[i] = -1;
	}

	uint32* secondlistVA= (uint32*)0x200000;
  80019a:	c7 45 dc 00 00 20 00 	movl   $0x200000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8b 10                	mov    (%eax),%edx
  8001a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a9:	01 d0                	add    %edx,%eax
  8001ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	secondlistVA = (uint32*) 0x202000;
  8001ae:	c7 45 dc 00 20 20 00 	movl   $0x202000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b8:	8b 10                	mov    (%eax),%edx
  8001ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	actual_second_list[0]=0X205000;
  8001c2:	c7 85 80 ff ff fe 00 	movl   $0x205000,-0x1000080(%ebp)
  8001c9:	50 20 00 
	actual_second_list[1]=0X204000;
  8001cc:	c7 85 84 ff ff fe 00 	movl   $0x204000,-0x100007c(%ebp)
  8001d3:	40 20 00 
	actual_second_list[2]=0x203000;
  8001d6:	c7 85 88 ff ff fe 00 	movl   $0x203000,-0x1000078(%ebp)
  8001dd:	30 20 00 
	actual_second_list[3]=0x201000;
  8001e0:	c7 85 8c ff ff fe 00 	movl   $0x201000,-0x1000074(%ebp)
  8001e7:	10 20 00 
	for (int i=12;i>6;i--)
  8001ea:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
  8001f1:	eb 1a                	jmp    80020d <_main+0x1d5>
		actual_active_list[i]=actual_active_list[i-7];
  8001f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001f6:	83 e8 07             	sub    $0x7,%eax
  8001f9:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  800200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800203:	89 94 85 9c ff ff fe 	mov    %edx,-0x1000064(%ebp,%eax,4)

	actual_second_list[0]=0X205000;
	actual_second_list[1]=0X204000;
	actual_second_list[2]=0x203000;
	actual_second_list[3]=0x201000;
	for (int i=12;i>6;i--)
  80020a:	ff 4d f0             	decl   -0x10(%ebp)
  80020d:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  800211:	7f e0                	jg     8001f3 <_main+0x1bb>
		actual_active_list[i]=actual_active_list[i-7];

	actual_active_list[0]=0x202000;
  800213:	c7 85 9c ff ff fe 00 	movl   $0x202000,-0x1000064(%ebp)
  80021a:	20 20 00 
	actual_active_list[1]=0x200000;
  80021d:	c7 85 a0 ff ff fe 00 	movl   $0x200000,-0x1000060(%ebp)
  800224:	00 20 00 
	actual_active_list[2]=0xee3fe000;
  800227:	c7 85 a4 ff ff fe 00 	movl   $0xee3fe000,-0x100005c(%ebp)
  80022e:	e0 3f ee 
	actual_active_list[3]=0xee3fd000;
  800231:	c7 85 a8 ff ff fe 00 	movl   $0xee3fd000,-0x1000058(%ebp)
  800238:	d0 3f ee 
	actual_active_list[4]=0xedffe000;
  80023b:	c7 85 ac ff ff fe 00 	movl   $0xedffe000,-0x1000054(%ebp)
  800242:	e0 ff ed 
	actual_active_list[5]=0xedffd000;
  800245:	c7 85 b0 ff ff fe 00 	movl   $0xedffd000,-0x1000050(%ebp)
  80024c:	d0 ff ed 
	actual_active_list[6]=0xedbfe000;
  80024f:	c7 85 b4 ff ff fe 00 	movl   $0xedbfe000,-0x100004c(%ebp)
  800256:	e0 bf ed 

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	68 bc 1f 80 00       	push   $0x801fbc
  800261:	e8 80 05 00 00       	call   8007e6 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  800269:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  80026f:	3c ff                	cmp    $0xff,%al
  800271:	74 14                	je     800287 <_main+0x24f>
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 ec 1f 80 00       	push   $0x801fec
  80027b:	6a 44                	push   $0x44
  80027d:	68 a2 1f 80 00       	push   $0x801fa2
  800282:	e8 a2 02 00 00       	call   800529 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800287:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  80028d:	3c ff                	cmp    $0xff,%al
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 ec 1f 80 00       	push   $0x801fec
  800299:	6a 45                	push   $0x45
  80029b:	68 a2 1f 80 00       	push   $0x801fa2
  8002a0:	e8 84 02 00 00       	call   800529 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8002a5:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 ec 1f 80 00       	push   $0x801fec
  8002b7:	6a 47                	push   $0x47
  8002b9:	68 a2 1f 80 00       	push   $0x801fa2
  8002be:	e8 66 02 00 00       	call   800529 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8002c3:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  8002c9:	3c ff                	cmp    $0xff,%al
  8002cb:	74 14                	je     8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 ec 1f 80 00       	push   $0x801fec
  8002d5:	6a 48                	push   $0x48
  8002d7:	68 a2 1f 80 00       	push   $0x801fa2
  8002dc:	e8 48 02 00 00       	call   800529 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  8002e1:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  8002e7:	3c ff                	cmp    $0xff,%al
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 ec 1f 80 00       	push   $0x801fec
  8002f3:	6a 4a                	push   $0x4a
  8002f5:	68 a2 1f 80 00       	push   $0x801fa2
  8002fa:	e8 2a 02 00 00       	call   800529 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8002ff:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  800305:	3c ff                	cmp    $0xff,%al
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 ec 1f 80 00       	push   $0x801fec
  800311:	6a 4b                	push   $0x4b
  800313:	68 a2 1f 80 00       	push   $0x801fa2
  800318:	e8 0c 02 00 00       	call   800529 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT written to Page File until it's replaced");
  80031d:	e8 00 14 00 00       	call   801722 <sys_pf_calculate_allocated_pages>
  800322:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800325:	74 14                	je     80033b <_main+0x303>
  800327:	83 ec 04             	sub    $0x4,%esp
  80032a:	68 0c 20 80 00       	push   $0x80200c
  80032f:	6a 4d                	push   $0x4d
  800331:	68 a2 1f 80 00       	push   $0x801fa2
  800336:	e8 ee 01 00 00       	call   800529 <_panic>

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  80033b:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800342:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800345:	e8 8d 13 00 00       	call   8016d7 <sys_calculate_free_frames>
  80034a:	29 c3                	sub    %eax,%ebx
  80034c:	89 d8                	mov    %ebx,%eax
  80034e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
  800351:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800354:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800357:	74 1a                	je     800373 <_main+0x33b>
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035f:	ff 75 d8             	pushl  -0x28(%ebp)
  800362:	68 50 20 80 00       	push   $0x802050
  800367:	6a 52                	push   $0x52
  800369:	68 a2 1f 80 00       	push   $0x801fa2
  80036e:	e8 b6 01 00 00       	call   800529 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	68 8c 20 80 00       	push   $0x80208c
  80037b:	e8 66 04 00 00       	call   8007e6 <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking LRU lists entries After Required PAGES IN SECOND LIST...\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 c0 20 80 00       	push   $0x8020c0
  80038b:	e8 56 04 00 00       	call   8007e6 <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800393:	6a 04                	push   $0x4
  800395:	6a 0d                	push   $0xd
  800397:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  80039d:	50                   	push   %eax
  80039e:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8003a4:	50                   	push   %eax
  8003a5:	e8 08 18 00 00       	call   801bb2 <sys_check_LRU_lists>
  8003aa:	83 c4 10             	add    $0x10,%esp
  8003ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(check == 0)
  8003b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8003b4:	75 14                	jne    8003ca <_main+0x392>
				panic("LRU lists entries are not correct, check your logic again!!");
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	68 0c 21 80 00       	push   $0x80210c
  8003be:	6a 5a                	push   $0x5a
  8003c0:	68 a2 1f 80 00       	push   $0x801fa2
  8003c5:	e8 5f 01 00 00       	call   800529 <_panic>
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	68 48 21 80 00       	push   $0x802148
  8003d2:	e8 0f 04 00 00       	call   8007e6 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of PAGE PLACEMENT THIRD SCENARIO completed successfully!!\n\n\n");
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 ac 21 80 00       	push   $0x8021ac
  8003e2:	e8 ff 03 00 00       	call   8007e6 <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	return;
  8003ea:	90                   	nop
}
  8003eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5f                   	pop    %edi
  8003f0:	5d                   	pop    %ebp
  8003f1:	c3                   	ret    

008003f2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003f8:	e8 65 15 00 00       	call   801962 <sys_getenvindex>
  8003fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800403:	89 d0                	mov    %edx,%eax
  800405:	c1 e0 03             	shl    $0x3,%eax
  800408:	01 d0                	add    %edx,%eax
  80040a:	01 c0                	add    %eax,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 04             	shl    $0x4,%eax
  80041a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80041f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8a 40 5c             	mov    0x5c(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	74 0d                	je     80043d <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800430:	a1 20 30 80 00       	mov    0x803020,%eax
  800435:	83 c0 5c             	add    $0x5c,%eax
  800438:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80043d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800441:	7e 0a                	jle    80044d <libmain+0x5b>
		binaryname = argv[0];
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	ff 75 08             	pushl  0x8(%ebp)
  800456:	e8 dd fb ff ff       	call   800038 <_main>
  80045b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80045e:	e8 0c 13 00 00       	call   80176f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 18 22 80 00       	push   $0x802218
  80046b:	e8 76 03 00 00       	call   8007e6 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800473:	a1 20 30 80 00       	mov    0x803020,%eax
  800478:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  80047e:	a1 20 30 80 00       	mov    0x803020,%eax
  800483:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	52                   	push   %edx
  80048d:	50                   	push   %eax
  80048e:	68 40 22 80 00       	push   $0x802240
  800493:	e8 4e 03 00 00       	call   8007e6 <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80049b:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a0:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8004a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ab:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8004b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b6:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8004bc:	51                   	push   %ecx
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	68 68 22 80 00       	push   $0x802268
  8004c4:	e8 1d 03 00 00       	call   8007e6 <cprintf>
  8004c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	50                   	push   %eax
  8004db:	68 c0 22 80 00       	push   $0x8022c0
  8004e0:	e8 01 03 00 00       	call   8007e6 <cprintf>
  8004e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	68 18 22 80 00       	push   $0x802218
  8004f0:	e8 f1 02 00 00       	call   8007e6 <cprintf>
  8004f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004f8:	e8 8c 12 00 00       	call   801789 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004fd:	e8 19 00 00 00       	call   80051b <exit>
}
  800502:	90                   	nop
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	6a 00                	push   $0x0
  800510:	e8 19 14 00 00       	call   80192e <sys_destroy_env>
  800515:	83 c4 10             	add    $0x10,%esp
}
  800518:	90                   	nop
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <exit>:

void
exit(void)
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800521:	e8 6e 14 00 00       	call   801994 <sys_exit_env>
}
  800526:	90                   	nop
  800527:	c9                   	leave  
  800528:	c3                   	ret    

00800529 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80052f:	8d 45 10             	lea    0x10(%ebp),%eax
  800532:	83 c0 04             	add    $0x4,%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800538:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	74 16                	je     800557 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800541:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	50                   	push   %eax
  80054a:	68 d4 22 80 00       	push   $0x8022d4
  80054f:	e8 92 02 00 00       	call   8007e6 <cprintf>
  800554:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800557:	a1 00 30 80 00       	mov    0x803000,%eax
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	ff 75 08             	pushl  0x8(%ebp)
  800562:	50                   	push   %eax
  800563:	68 d9 22 80 00       	push   $0x8022d9
  800568:	e8 79 02 00 00       	call   8007e6 <cprintf>
  80056d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800570:	8b 45 10             	mov    0x10(%ebp),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	e8 fc 01 00 00       	call   80077b <vcprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	6a 00                	push   $0x0
  800587:	68 f5 22 80 00       	push   $0x8022f5
  80058c:	e8 ea 01 00 00       	call   80077b <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800594:	e8 82 ff ff ff       	call   80051b <exit>

	// should not return here
	while (1) ;
  800599:	eb fe                	jmp    800599 <_panic+0x70>

0080059b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a6:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	39 c2                	cmp    %eax,%edx
  8005b1:	74 14                	je     8005c7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005b3:	83 ec 04             	sub    $0x4,%esp
  8005b6:	68 f8 22 80 00       	push   $0x8022f8
  8005bb:	6a 26                	push   $0x26
  8005bd:	68 44 23 80 00       	push   $0x802344
  8005c2:	e8 62 ff ff ff       	call   800529 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005d5:	e9 c5 00 00 00       	jmp    80069f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	75 08                	jne    8005f7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005ef:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005f2:	e9 a5 00 00 00       	jmp    80069c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800605:	eb 69                	jmp    800670 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800607:	a1 20 30 80 00       	mov    0x803020,%eax
  80060c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800612:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800615:	89 d0                	mov    %edx,%eax
  800617:	01 c0                	add    %eax,%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	c1 e0 03             	shl    $0x3,%eax
  80061e:	01 c8                	add    %ecx,%eax
  800620:	8a 40 04             	mov    0x4(%eax),%al
  800623:	84 c0                	test   %al,%al
  800625:	75 46                	jne    80066d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800627:	a1 20 30 80 00       	mov    0x803020,%eax
  80062c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800632:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800635:	89 d0                	mov    %edx,%eax
  800637:	01 c0                	add    %eax,%eax
  800639:	01 d0                	add    %edx,%eax
  80063b:	c1 e0 03             	shl    $0x3,%eax
  80063e:	01 c8                	add    %ecx,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800648:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80064d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80064f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800652:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800660:	39 c2                	cmp    %eax,%edx
  800662:	75 09                	jne    80066d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800664:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80066b:	eb 15                	jmp    800682 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066d:	ff 45 e8             	incl   -0x18(%ebp)
  800670:	a1 20 30 80 00       	mov    0x803020,%eax
  800675:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80067b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	77 85                	ja     800607 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800682:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800686:	75 14                	jne    80069c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 50 23 80 00       	push   $0x802350
  800690:	6a 3a                	push   $0x3a
  800692:	68 44 23 80 00       	push   $0x802344
  800697:	e8 8d fe ff ff       	call   800529 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80069c:	ff 45 f0             	incl   -0x10(%ebp)
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a5:	0f 8c 2f ff ff ff    	jl     8005da <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006b9:	eb 26                	jmp    8006e1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8006c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c9:	89 d0                	mov    %edx,%eax
  8006cb:	01 c0                	add    %eax,%eax
  8006cd:	01 d0                	add    %edx,%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	8a 40 04             	mov    0x4(%eax),%al
  8006d7:	3c 01                	cmp    $0x1,%al
  8006d9:	75 03                	jne    8006de <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006db:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006de:	ff 45 e0             	incl   -0x20(%ebp)
  8006e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e6:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8006ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ef:	39 c2                	cmp    %eax,%edx
  8006f1:	77 c8                	ja     8006bb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006f9:	74 14                	je     80070f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	68 a4 23 80 00       	push   $0x8023a4
  800703:	6a 44                	push   $0x44
  800705:	68 44 23 80 00       	push   $0x802344
  80070a:	e8 1a fe ff ff       	call   800529 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80070f:	90                   	nop
  800710:	c9                   	leave  
  800711:	c3                   	ret    

00800712 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 48 01             	lea    0x1(%eax),%ecx
  800720:	8b 55 0c             	mov    0xc(%ebp),%edx
  800723:	89 0a                	mov    %ecx,(%edx)
  800725:	8b 55 08             	mov    0x8(%ebp),%edx
  800728:	88 d1                	mov    %dl,%cl
  80072a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800731:	8b 45 0c             	mov    0xc(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073b:	75 2c                	jne    800769 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80073d:	a0 24 30 80 00       	mov    0x803024,%al
  800742:	0f b6 c0             	movzbl %al,%eax
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
  800748:	8b 12                	mov    (%edx),%edx
  80074a:	89 d1                	mov    %edx,%ecx
  80074c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074f:	83 c2 08             	add    $0x8,%edx
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	50                   	push   %eax
  800756:	51                   	push   %ecx
  800757:	52                   	push   %edx
  800758:	e8 b9 0e 00 00       	call   801616 <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076c:	8b 40 04             	mov    0x4(%eax),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	8b 45 0c             	mov    0xc(%ebp),%eax
  800775:	89 50 04             	mov    %edx,0x4(%eax)
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800784:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80078b:	00 00 00 
	b.cnt = 0;
  80078e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800795:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	ff 75 08             	pushl  0x8(%ebp)
  80079e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a4:	50                   	push   %eax
  8007a5:	68 12 07 80 00       	push   $0x800712
  8007aa:	e8 11 02 00 00       	call   8009c0 <vprintfmt>
  8007af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007b2:	a0 24 30 80 00       	mov    0x803024,%al
  8007b7:	0f b6 c0             	movzbl %al,%eax
  8007ba:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007c0:	83 ec 04             	sub    $0x4,%esp
  8007c3:	50                   	push   %eax
  8007c4:	52                   	push   %edx
  8007c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007cb:	83 c0 08             	add    $0x8,%eax
  8007ce:	50                   	push   %eax
  8007cf:	e8 42 0e 00 00       	call   801616 <sys_cputs>
  8007d4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007d7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ec:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800802:	50                   	push   %eax
  800803:	e8 73 ff ff ff       	call   80077b <vcprintf>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800819:	e8 51 0f 00 00       	call   80176f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80081e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800821:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 f4             	pushl  -0xc(%ebp)
  80082d:	50                   	push   %eax
  80082e:	e8 48 ff ff ff       	call   80077b <vcprintf>
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800839:	e8 4b 0f 00 00       	call   801789 <sys_enable_interrupt>
	return cnt;
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	53                   	push   %ebx
  800847:	83 ec 14             	sub    $0x14,%esp
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800856:	8b 45 18             	mov    0x18(%ebp),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800861:	77 55                	ja     8008b8 <printnum+0x75>
  800863:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800866:	72 05                	jb     80086d <printnum+0x2a>
  800868:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80086b:	77 4b                	ja     8008b8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80086d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800870:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800873:	8b 45 18             	mov    0x18(%ebp),%eax
  800876:	ba 00 00 00 00       	mov    $0x0,%edx
  80087b:	52                   	push   %edx
  80087c:	50                   	push   %eax
  80087d:	ff 75 f4             	pushl  -0xc(%ebp)
  800880:	ff 75 f0             	pushl  -0x10(%ebp)
  800883:	e8 18 14 00 00       	call   801ca0 <__udivdi3>
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	83 ec 04             	sub    $0x4,%esp
  80088e:	ff 75 20             	pushl  0x20(%ebp)
  800891:	53                   	push   %ebx
  800892:	ff 75 18             	pushl  0x18(%ebp)
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 a1 ff ff ff       	call   800843 <printnum>
  8008a2:	83 c4 20             	add    $0x20,%esp
  8008a5:	eb 1a                	jmp    8008c1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	ff 75 20             	pushl  0x20(%ebp)
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b8:	ff 4d 1c             	decl   0x1c(%ebp)
  8008bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008bf:	7f e6                	jg     8008a7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008c1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cf:	53                   	push   %ebx
  8008d0:	51                   	push   %ecx
  8008d1:	52                   	push   %edx
  8008d2:	50                   	push   %eax
  8008d3:	e8 d8 14 00 00       	call   801db0 <__umoddi3>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	05 14 26 80 00       	add    $0x802614,%eax
  8008e0:	8a 00                	mov    (%eax),%al
  8008e2:	0f be c0             	movsbl %al,%eax
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	50                   	push   %eax
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	ff d0                	call   *%eax
  8008f1:	83 c4 10             	add    $0x10,%esp
}
  8008f4:	90                   	nop
  8008f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    

008008fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008fd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800901:	7e 1c                	jle    80091f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 08             	lea    0x8(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 08             	sub    $0x8,%eax
  800918:	8b 50 04             	mov    0x4(%eax),%edx
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	eb 40                	jmp    80095f <getuint+0x65>
	else if (lflag)
  80091f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800923:	74 1e                	je     800943 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	8d 50 04             	lea    0x4(%eax),%edx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	89 10                	mov    %edx,(%eax)
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	ba 00 00 00 00       	mov    $0x0,%edx
  800941:	eb 1c                	jmp    80095f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	8d 50 04             	lea    0x4(%eax),%edx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	89 10                	mov    %edx,(%eax)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800964:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800968:	7e 1c                	jle    800986 <getint+0x25>
		return va_arg(*ap, long long);
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 50 08             	lea    0x8(%eax),%edx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	89 10                	mov    %edx,(%eax)
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 e8 08             	sub    $0x8,%eax
  80097f:	8b 50 04             	mov    0x4(%eax),%edx
  800982:	8b 00                	mov    (%eax),%eax
  800984:	eb 38                	jmp    8009be <getint+0x5d>
	else if (lflag)
  800986:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098a:	74 1a                	je     8009a6 <getint+0x45>
		return va_arg(*ap, long);
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	8d 50 04             	lea    0x4(%eax),%edx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	89 10                	mov    %edx,(%eax)
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	83 e8 04             	sub    $0x4,%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	99                   	cltd   
  8009a4:	eb 18                	jmp    8009be <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	8d 50 04             	lea    0x4(%eax),%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	89 10                	mov    %edx,(%eax)
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	83 e8 04             	sub    $0x4,%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	99                   	cltd   
}
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	56                   	push   %esi
  8009c4:	53                   	push   %ebx
  8009c5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c8:	eb 17                	jmp    8009e1 <vprintfmt+0x21>
			if (ch == '\0')
  8009ca:	85 db                	test   %ebx,%ebx
  8009cc:	0f 84 af 03 00 00    	je     800d81 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009d2:	83 ec 08             	sub    $0x8,%esp
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	53                   	push   %ebx
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	8d 50 01             	lea    0x1(%eax),%edx
  8009e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f b6 d8             	movzbl %al,%ebx
  8009ef:	83 fb 25             	cmp    $0x25,%ebx
  8009f2:	75 d6                	jne    8009ca <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a0d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	8d 50 01             	lea    0x1(%eax),%edx
  800a1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	0f b6 d8             	movzbl %al,%ebx
  800a22:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a25:	83 f8 55             	cmp    $0x55,%eax
  800a28:	0f 87 2b 03 00 00    	ja     800d59 <vprintfmt+0x399>
  800a2e:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800a35:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a37:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a3b:	eb d7                	jmp    800a14 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a3d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a41:	eb d1                	jmp    800a14 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a4d:	89 d0                	mov    %edx,%eax
  800a4f:	c1 e0 02             	shl    $0x2,%eax
  800a52:	01 d0                	add    %edx,%eax
  800a54:	01 c0                	add    %eax,%eax
  800a56:	01 d8                	add    %ebx,%eax
  800a58:	83 e8 30             	sub    $0x30,%eax
  800a5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a66:	83 fb 2f             	cmp    $0x2f,%ebx
  800a69:	7e 3e                	jle    800aa9 <vprintfmt+0xe9>
  800a6b:	83 fb 39             	cmp    $0x39,%ebx
  800a6e:	7f 39                	jg     800aa9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a70:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a73:	eb d5                	jmp    800a4a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 c0 04             	add    $0x4,%eax
  800a7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	83 e8 04             	sub    $0x4,%eax
  800a84:	8b 00                	mov    (%eax),%eax
  800a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a89:	eb 1f                	jmp    800aaa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8f:	79 83                	jns    800a14 <vprintfmt+0x54>
				width = 0;
  800a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a98:	e9 77 ff ff ff       	jmp    800a14 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a9d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa4:	e9 6b ff ff ff       	jmp    800a14 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aaa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aae:	0f 89 60 ff ff ff    	jns    800a14 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ac1:	e9 4e ff ff ff       	jmp    800a14 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac9:	e9 46 ff ff ff       	jmp    800a14 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 e8 04             	sub    $0x4,%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	50                   	push   %eax
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
			break;
  800aee:	e9 89 02 00 00       	jmp    800d7c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 c0 04             	add    $0x4,%eax
  800af9:	89 45 14             	mov    %eax,0x14(%ebp)
  800afc:	8b 45 14             	mov    0x14(%ebp),%eax
  800aff:	83 e8 04             	sub    $0x4,%eax
  800b02:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b04:	85 db                	test   %ebx,%ebx
  800b06:	79 02                	jns    800b0a <vprintfmt+0x14a>
				err = -err;
  800b08:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b0a:	83 fb 64             	cmp    $0x64,%ebx
  800b0d:	7f 0b                	jg     800b1a <vprintfmt+0x15a>
  800b0f:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800b16:	85 f6                	test   %esi,%esi
  800b18:	75 19                	jne    800b33 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b1a:	53                   	push   %ebx
  800b1b:	68 25 26 80 00       	push   $0x802625
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 5e 02 00 00       	call   800d89 <printfmt>
  800b2b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2e:	e9 49 02 00 00       	jmp    800d7c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b33:	56                   	push   %esi
  800b34:	68 2e 26 80 00       	push   $0x80262e
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 45 02 00 00       	call   800d89 <printfmt>
  800b44:	83 c4 10             	add    $0x10,%esp
			break;
  800b47:	e9 30 02 00 00       	jmp    800d7c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	83 c0 04             	add    $0x4,%eax
  800b52:	89 45 14             	mov    %eax,0x14(%ebp)
  800b55:	8b 45 14             	mov    0x14(%ebp),%eax
  800b58:	83 e8 04             	sub    $0x4,%eax
  800b5b:	8b 30                	mov    (%eax),%esi
  800b5d:	85 f6                	test   %esi,%esi
  800b5f:	75 05                	jne    800b66 <vprintfmt+0x1a6>
				p = "(null)";
  800b61:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6a:	7e 6d                	jle    800bd9 <vprintfmt+0x219>
  800b6c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b70:	74 67                	je     800bd9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	50                   	push   %eax
  800b79:	56                   	push   %esi
  800b7a:	e8 0c 03 00 00       	call   800e8b <strnlen>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b85:	eb 16                	jmp    800b9d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b87:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	50                   	push   %eax
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba1:	7f e4                	jg     800b87 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba3:	eb 34                	jmp    800bd9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba9:	74 1c                	je     800bc7 <vprintfmt+0x207>
  800bab:	83 fb 1f             	cmp    $0x1f,%ebx
  800bae:	7e 05                	jle    800bb5 <vprintfmt+0x1f5>
  800bb0:	83 fb 7e             	cmp    $0x7e,%ebx
  800bb3:	7e 12                	jle    800bc7 <vprintfmt+0x207>
					putch('?', putdat);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	6a 3f                	push   $0x3f
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	ff d0                	call   *%eax
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	eb 0f                	jmp    800bd6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd6:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd9:	89 f0                	mov    %esi,%eax
  800bdb:	8d 70 01             	lea    0x1(%eax),%esi
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f be d8             	movsbl %al,%ebx
  800be3:	85 db                	test   %ebx,%ebx
  800be5:	74 24                	je     800c0b <vprintfmt+0x24b>
  800be7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800beb:	78 b8                	js     800ba5 <vprintfmt+0x1e5>
  800bed:	ff 4d e0             	decl   -0x20(%ebp)
  800bf0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf4:	79 af                	jns    800ba5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf6:	eb 13                	jmp    800c0b <vprintfmt+0x24b>
				putch(' ', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 20                	push   $0x20
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c08:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0f:	7f e7                	jg     800bf8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c11:	e9 66 01 00 00       	jmp    800d7c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1f:	50                   	push   %eax
  800c20:	e8 3c fd ff ff       	call   800961 <getint>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c34:	85 d2                	test   %edx,%edx
  800c36:	79 23                	jns    800c5b <vprintfmt+0x29b>
				putch('-', putdat);
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	6a 2d                	push   $0x2d
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	ff d0                	call   *%eax
  800c45:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4e:	f7 d8                	neg    %eax
  800c50:	83 d2 00             	adc    $0x0,%edx
  800c53:	f7 da                	neg    %edx
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c5b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c62:	e9 bc 00 00 00       	jmp    800d23 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c70:	50                   	push   %eax
  800c71:	e8 84 fc ff ff       	call   8008fa <getuint>
  800c76:	83 c4 10             	add    $0x10,%esp
  800c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c7f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c86:	e9 98 00 00 00       	jmp    800d23 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	6a 58                	push   $0x58
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	ff d0                	call   *%eax
  800c98:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	6a 58                	push   $0x58
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	ff d0                	call   *%eax
  800ca8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	6a 58                	push   $0x58
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	ff d0                	call   *%eax
  800cb8:	83 c4 10             	add    $0x10,%esp
			break;
  800cbb:	e9 bc 00 00 00       	jmp    800d7c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 30                	push   $0x30
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cd0:	83 ec 08             	sub    $0x8,%esp
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	6a 78                	push   $0x78
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ce0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce3:	83 c0 04             	add    $0x4,%eax
  800ce6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 e8 04             	sub    $0x4,%eax
  800cef:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cfb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d02:	eb 1f                	jmp    800d23 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 e8             	pushl  -0x18(%ebp)
  800d0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0d:	50                   	push   %eax
  800d0e:	e8 e7 fb ff ff       	call   8008fa <getuint>
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d1c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d23:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d2a:	83 ec 04             	sub    $0x4,%esp
  800d2d:	52                   	push   %edx
  800d2e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d31:	50                   	push   %eax
  800d32:	ff 75 f4             	pushl  -0xc(%ebp)
  800d35:	ff 75 f0             	pushl  -0x10(%ebp)
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	ff 75 08             	pushl  0x8(%ebp)
  800d3e:	e8 00 fb ff ff       	call   800843 <printnum>
  800d43:	83 c4 20             	add    $0x20,%esp
			break;
  800d46:	eb 34                	jmp    800d7c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	eb 23                	jmp    800d7c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	6a 25                	push   $0x25
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d69:	ff 4d 10             	decl   0x10(%ebp)
  800d6c:	eb 03                	jmp    800d71 <vprintfmt+0x3b1>
  800d6e:	ff 4d 10             	decl   0x10(%ebp)
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	48                   	dec    %eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3c 25                	cmp    $0x25,%al
  800d79:	75 f3                	jne    800d6e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d7b:	90                   	nop
		}
	}
  800d7c:	e9 47 fc ff ff       	jmp    8009c8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d81:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d92:	83 c0 04             	add    $0x4,%eax
  800d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9e:	50                   	push   %eax
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 16 fc ff ff       	call   8009c0 <vprintfmt>
  800daa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dad:	90                   	nop
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8b 40 08             	mov    0x8(%eax),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8b 10                	mov    (%eax),%edx
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8b 40 04             	mov    0x4(%eax),%eax
  800dcd:	39 c2                	cmp    %eax,%edx
  800dcf:	73 12                	jae    800de3 <sprintputch+0x33>
		*b->buf++ = ch;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8b 00                	mov    (%eax),%eax
  800dd6:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	89 0a                	mov    %ecx,(%edx)
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	88 10                	mov    %dl,(%eax)
}
  800de3:	90                   	nop
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	01 d0                	add    %edx,%eax
  800dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0b:	74 06                	je     800e13 <vsnprintf+0x2d>
  800e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e11:	7f 07                	jg     800e1a <vsnprintf+0x34>
		return -E_INVAL;
  800e13:	b8 03 00 00 00       	mov    $0x3,%eax
  800e18:	eb 20                	jmp    800e3a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e1a:	ff 75 14             	pushl  0x14(%ebp)
  800e1d:	ff 75 10             	pushl  0x10(%ebp)
  800e20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e23:	50                   	push   %eax
  800e24:	68 b0 0d 80 00       	push   $0x800db0
  800e29:	e8 92 fb ff ff       	call   8009c0 <vprintfmt>
  800e2e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e34:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e42:	8d 45 10             	lea    0x10(%ebp),%eax
  800e45:	83 c0 04             	add    $0x4,%eax
  800e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e51:	50                   	push   %eax
  800e52:	ff 75 0c             	pushl  0xc(%ebp)
  800e55:	ff 75 08             	pushl  0x8(%ebp)
  800e58:	e8 89 ff ff ff       	call   800de6 <vsnprintf>
  800e5d:	83 c4 10             	add    $0x10,%esp
  800e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e75:	eb 06                	jmp    800e7d <strlen+0x15>
		n++;
  800e77:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 f1                	jne    800e77 <strlen+0xf>
		n++;
	return n;
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e98:	eb 09                	jmp    800ea3 <strnlen+0x18>
		n++;
  800e9a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	ff 4d 0c             	decl   0xc(%ebp)
  800ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea7:	74 09                	je     800eb2 <strnlen+0x27>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 e8                	jne    800e9a <strnlen+0xf>
		n++;
	return n;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec3:	90                   	nop
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8d 50 01             	lea    0x1(%eax),%edx
  800eca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed6:	8a 12                	mov    (%edx),%dl
  800ed8:	88 10                	mov    %dl,(%eax)
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	84 c0                	test   %al,%al
  800ede:	75 e4                	jne    800ec4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef8:	eb 1f                	jmp    800f19 <strncpy+0x34>
		*dst++ = *src;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8a 12                	mov    (%edx),%dl
  800f08:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 03                	je     800f16 <strncpy+0x31>
			src++;
  800f13:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f16:	ff 45 fc             	incl   -0x4(%ebp)
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f1f:	72 d9                	jb     800efa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 30                	je     800f68 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f38:	eb 16                	jmp    800f50 <strlcpy+0x2a>
			*dst++ = *src++;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8d 50 01             	lea    0x1(%eax),%edx
  800f40:	89 55 08             	mov    %edx,0x8(%ebp)
  800f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f49:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f4c:	8a 12                	mov    (%edx),%dl
  800f4e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f50:	ff 4d 10             	decl   0x10(%ebp)
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 09                	je     800f62 <strlcpy+0x3c>
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	84 c0                	test   %al,%al
  800f60:	75 d8                	jne    800f3a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	c9                   	leave  
  800f73:	c3                   	ret    

00800f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f77:	eb 06                	jmp    800f7f <strcmp+0xb>
		p++, q++;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	84 c0                	test   %al,%al
  800f86:	74 0e                	je     800f96 <strcmp+0x22>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 10                	mov    (%eax),%dl
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	38 c2                	cmp    %al,%dl
  800f94:	74 e3                	je     800f79 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	0f b6 d0             	movzbl %al,%edx
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	0f b6 c0             	movzbl %al,%eax
  800fa6:	29 c2                	sub    %eax,%edx
  800fa8:	89 d0                	mov    %edx,%eax
}
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800faf:	eb 09                	jmp    800fba <strncmp+0xe>
		n--, p++, q++;
  800fb1:	ff 4d 10             	decl   0x10(%ebp)
  800fb4:	ff 45 08             	incl   0x8(%ebp)
  800fb7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbe:	74 17                	je     800fd7 <strncmp+0x2b>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 0e                	je     800fd7 <strncmp+0x2b>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 10                	mov    (%eax),%dl
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	38 c2                	cmp    %al,%dl
  800fd5:	74 da                	je     800fb1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdb:	75 07                	jne    800fe4 <strncmp+0x38>
		return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb 14                	jmp    800ff8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 d0             	movzbl %al,%edx
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	29 c2                	sub    %eax,%edx
  800ff6:	89 d0                	mov    %edx,%eax
}
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801006:	eb 12                	jmp    80101a <strchr+0x20>
		if (*s == c)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801010:	75 05                	jne    801017 <strchr+0x1d>
			return (char *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	eb 11                	jmp    801028 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 e5                	jne    801008 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801036:	eb 0d                	jmp    801045 <strfind+0x1b>
		if (*s == c)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801040:	74 0e                	je     801050 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	84 c0                	test   %al,%al
  80104c:	75 ea                	jne    801038 <strfind+0xe>
  80104e:	eb 01                	jmp    801051 <strfind+0x27>
		if (*s == c)
			break;
  801050:	90                   	nop
	return (char *) s;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801062:	8b 45 10             	mov    0x10(%ebp),%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801068:	eb 0e                	jmp    801078 <memset+0x22>
		*p++ = c;
  80106a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106d:	8d 50 01             	lea    0x1(%eax),%edx
  801070:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801073:	8b 55 0c             	mov    0xc(%ebp),%edx
  801076:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801078:	ff 4d f8             	decl   -0x8(%ebp)
  80107b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80107f:	79 e9                	jns    80106a <memset+0x14>
		*p++ = c;

	return v;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801098:	eb 16                	jmp    8010b0 <memcpy+0x2a>
		*d++ = *s++;
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109d:	8d 50 01             	lea    0x1(%eax),%edx
  8010a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ac:	8a 12                	mov    (%edx),%dl
  8010ae:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 dd                	jne    80109a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010da:	73 50                	jae    80112c <memmove+0x6a>
  8010dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e7:	76 43                	jbe    80112c <memmove+0x6a>
		s += n;
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010f5:	eb 10                	jmp    801107 <memmove+0x45>
			*--d = *--s;
  8010f7:	ff 4d f8             	decl   -0x8(%ebp)
  8010fa:	ff 4d fc             	decl   -0x4(%ebp)
  8010fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801100:	8a 10                	mov    (%eax),%dl
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801105:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110d:	89 55 10             	mov    %edx,0x10(%ebp)
  801110:	85 c0                	test   %eax,%eax
  801112:	75 e3                	jne    8010f7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801114:	eb 23                	jmp    801139 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801116:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801119:	8d 50 01             	lea    0x1(%eax),%edx
  80111c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801122:	8d 4a 01             	lea    0x1(%edx),%ecx
  801125:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801128:	8a 12                	mov    (%edx),%dl
  80112a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801132:	89 55 10             	mov    %edx,0x10(%ebp)
  801135:	85 c0                	test   %eax,%eax
  801137:	75 dd                	jne    801116 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801150:	eb 2a                	jmp    80117c <memcmp+0x3e>
		if (*s1 != *s2)
  801152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801155:	8a 10                	mov    (%eax),%dl
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	38 c2                	cmp    %al,%dl
  80115e:	74 16                	je     801176 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	0f b6 d0             	movzbl %al,%edx
  801168:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f b6 c0             	movzbl %al,%eax
  801170:	29 c2                	sub    %eax,%edx
  801172:	89 d0                	mov    %edx,%eax
  801174:	eb 18                	jmp    80118e <memcmp+0x50>
		s1++, s2++;
  801176:	ff 45 fc             	incl   -0x4(%ebp)
  801179:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	85 c0                	test   %eax,%eax
  801187:	75 c9                	jne    801152 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 d0                	add    %edx,%eax
  80119e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011a1:	eb 15                	jmp    8011b8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	0f b6 d0             	movzbl %al,%edx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	0f b6 c0             	movzbl %al,%eax
  8011b1:	39 c2                	cmp    %eax,%edx
  8011b3:	74 0d                	je     8011c2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011b5:	ff 45 08             	incl   0x8(%ebp)
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011be:	72 e3                	jb     8011a3 <memfind+0x13>
  8011c0:	eb 01                	jmp    8011c3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011c2:	90                   	nop
	return (void *) s;
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011dc:	eb 03                	jmp    8011e1 <strtol+0x19>
		s++;
  8011de:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 20                	cmp    $0x20,%al
  8011e8:	74 f4                	je     8011de <strtol+0x16>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 09                	cmp    $0x9,%al
  8011f1:	74 eb                	je     8011de <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 2b                	cmp    $0x2b,%al
  8011fa:	75 05                	jne    801201 <strtol+0x39>
		s++;
  8011fc:	ff 45 08             	incl   0x8(%ebp)
  8011ff:	eb 13                	jmp    801214 <strtol+0x4c>
	else if (*s == '-')
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3c 2d                	cmp    $0x2d,%al
  801208:	75 0a                	jne    801214 <strtol+0x4c>
		s++, neg = 1;
  80120a:	ff 45 08             	incl   0x8(%ebp)
  80120d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801214:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801218:	74 06                	je     801220 <strtol+0x58>
  80121a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80121e:	75 20                	jne    801240 <strtol+0x78>
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	3c 30                	cmp    $0x30,%al
  801227:	75 17                	jne    801240 <strtol+0x78>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	40                   	inc    %eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 78                	cmp    $0x78,%al
  801231:	75 0d                	jne    801240 <strtol+0x78>
		s += 2, base = 16;
  801233:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801237:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80123e:	eb 28                	jmp    801268 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 15                	jne    80125b <strtol+0x93>
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	3c 30                	cmp    $0x30,%al
  80124d:	75 0c                	jne    80125b <strtol+0x93>
		s++, base = 8;
  80124f:	ff 45 08             	incl   0x8(%ebp)
  801252:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801259:	eb 0d                	jmp    801268 <strtol+0xa0>
	else if (base == 0)
  80125b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125f:	75 07                	jne    801268 <strtol+0xa0>
		base = 10;
  801261:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 2f                	cmp    $0x2f,%al
  80126f:	7e 19                	jle    80128a <strtol+0xc2>
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 39                	cmp    $0x39,%al
  801278:	7f 10                	jg     80128a <strtol+0xc2>
			dig = *s - '0';
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	0f be c0             	movsbl %al,%eax
  801282:	83 e8 30             	sub    $0x30,%eax
  801285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801288:	eb 42                	jmp    8012cc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 60                	cmp    $0x60,%al
  801291:	7e 19                	jle    8012ac <strtol+0xe4>
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	3c 7a                	cmp    $0x7a,%al
  80129a:	7f 10                	jg     8012ac <strtol+0xe4>
			dig = *s - 'a' + 10;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	0f be c0             	movsbl %al,%eax
  8012a4:	83 e8 57             	sub    $0x57,%eax
  8012a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012aa:	eb 20                	jmp    8012cc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 40                	cmp    $0x40,%al
  8012b3:	7e 39                	jle    8012ee <strtol+0x126>
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	3c 5a                	cmp    $0x5a,%al
  8012bc:	7f 30                	jg     8012ee <strtol+0x126>
			dig = *s - 'A' + 10;
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	0f be c0             	movsbl %al,%eax
  8012c6:	83 e8 37             	sub    $0x37,%eax
  8012c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012d2:	7d 19                	jge    8012ed <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012d4:	ff 45 08             	incl   0x8(%ebp)
  8012d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012de:	89 c2                	mov    %eax,%edx
  8012e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e3:	01 d0                	add    %edx,%eax
  8012e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012e8:	e9 7b ff ff ff       	jmp    801268 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ed:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f2:	74 08                	je     8012fc <strtol+0x134>
		*endptr = (char *) s;
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801300:	74 07                	je     801309 <strtol+0x141>
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	f7 d8                	neg    %eax
  801307:	eb 03                	jmp    80130c <strtol+0x144>
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <ltostr>:

void
ltostr(long value, char *str)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80131b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801322:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801326:	79 13                	jns    80133b <ltostr+0x2d>
	{
		neg = 1;
  801328:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80132f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801332:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801335:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801338:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801343:	99                   	cltd   
  801344:	f7 f9                	idiv   %ecx
  801346:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	8d 50 01             	lea    0x1(%eax),%edx
  80134f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801352:	89 c2                	mov    %eax,%edx
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80135c:	83 c2 30             	add    $0x30,%edx
  80135f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801361:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801364:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801369:	f7 e9                	imul   %ecx
  80136b:	c1 fa 02             	sar    $0x2,%edx
  80136e:	89 c8                	mov    %ecx,%eax
  801370:	c1 f8 1f             	sar    $0x1f,%eax
  801373:	29 c2                	sub    %eax,%edx
  801375:	89 d0                	mov    %edx,%eax
  801377:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80137a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801382:	f7 e9                	imul   %ecx
  801384:	c1 fa 02             	sar    $0x2,%edx
  801387:	89 c8                	mov    %ecx,%eax
  801389:	c1 f8 1f             	sar    $0x1f,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
  801390:	c1 e0 02             	shl    $0x2,%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	29 c1                	sub    %eax,%ecx
  801399:	89 ca                	mov    %ecx,%edx
  80139b:	85 d2                	test   %edx,%edx
  80139d:	75 9c                	jne    80133b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80139f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a9:	48                   	dec    %eax
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b1:	74 3d                	je     8013f0 <ltostr+0xe2>
		start = 1 ;
  8013b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ba:	eb 34                	jmp    8013f0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c2:	01 d0                	add    %edx,%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	01 c2                	add    %eax,%edx
  8013d1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	01 c8                	add    %ecx,%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	01 c2                	add    %eax,%edx
  8013e5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013ea:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ed:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f6:	7c c4                	jl     8013bc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801403:	90                   	nop
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80140c:	ff 75 08             	pushl  0x8(%ebp)
  80140f:	e8 54 fa ff ff       	call   800e68 <strlen>
  801414:	83 c4 04             	add    $0x4,%esp
  801417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80141a:	ff 75 0c             	pushl  0xc(%ebp)
  80141d:	e8 46 fa ff ff       	call   800e68 <strlen>
  801422:	83 c4 04             	add    $0x4,%esp
  801425:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801428:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80142f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801436:	eb 17                	jmp    80144f <strcconcat+0x49>
		final[s] = str1[s] ;
  801438:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	01 c2                	add    %eax,%edx
  801440:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	01 c8                	add    %ecx,%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
  80144f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801452:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801455:	7c e1                	jl     801438 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801457:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80145e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801465:	eb 1f                	jmp    801486 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	8d 50 01             	lea    0x1(%eax),%edx
  80146d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801470:	89 c2                	mov    %eax,%edx
  801472:	8b 45 10             	mov    0x10(%ebp),%eax
  801475:	01 c2                	add    %eax,%edx
  801477:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	01 c8                	add    %ecx,%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801483:	ff 45 f8             	incl   -0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80148c:	7c d9                	jl     801467 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80148e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 d0                	add    %edx,%eax
  801496:	c6 00 00             	movb   $0x0,(%eax)
}
  801499:	90                   	nop
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80149f:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bf:	eb 0c                	jmp    8014cd <strsplit+0x31>
			*string++ = 0;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ca:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	84 c0                	test   %al,%al
  8014d4:	74 18                	je     8014ee <strsplit+0x52>
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	0f be c0             	movsbl %al,%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 13 fb ff ff       	call   800ffa <strchr>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 d3                	jne    8014c1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	84 c0                	test   %al,%al
  8014f5:	74 5a                	je     801551 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	8b 00                	mov    (%eax),%eax
  8014fc:	83 f8 0f             	cmp    $0xf,%eax
  8014ff:	75 07                	jne    801508 <strsplit+0x6c>
		{
			return 0;
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
  801506:	eb 66                	jmp    80156e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	8d 48 01             	lea    0x1(%eax),%ecx
  801510:	8b 55 14             	mov    0x14(%ebp),%edx
  801513:	89 0a                	mov    %ecx,(%edx)
  801515:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151c:	8b 45 10             	mov    0x10(%ebp),%eax
  80151f:	01 c2                	add    %eax,%edx
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801526:	eb 03                	jmp    80152b <strsplit+0x8f>
			string++;
  801528:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	84 c0                	test   %al,%al
  801532:	74 8b                	je     8014bf <strsplit+0x23>
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	0f be c0             	movsbl %al,%eax
  80153c:	50                   	push   %eax
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	e8 b5 fa ff ff       	call   800ffa <strchr>
  801545:	83 c4 08             	add    $0x8,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	74 dc                	je     801528 <strsplit+0x8c>
			string++;
	}
  80154c:	e9 6e ff ff ff       	jmp    8014bf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801551:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801552:	8b 45 14             	mov    0x14(%ebp),%eax
  801555:	8b 00                	mov    (%eax),%eax
  801557:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155e:	8b 45 10             	mov    0x10(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801569:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801576:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157d:	eb 4c                	jmp    8015cb <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  80157f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	3c 40                	cmp    $0x40,%al
  80158b:	7e 27                	jle    8015b4 <str2lower+0x44>
  80158d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	01 d0                	add    %edx,%eax
  801595:	8a 00                	mov    (%eax),%al
  801597:	3c 5a                	cmp    $0x5a,%al
  801599:	7f 19                	jg     8015b4 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  80159b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	01 d0                	add    %edx,%eax
  8015a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	01 ca                	add    %ecx,%edx
  8015ab:	8a 12                	mov    (%edx),%dl
  8015ad:	83 c2 20             	add    $0x20,%edx
  8015b0:	88 10                	mov    %dl,(%eax)
  8015b2:	eb 14                	jmp    8015c8 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8015b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	01 c2                	add    %eax,%edx
  8015bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c2:	01 c8                	add    %ecx,%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8015c8:	ff 45 fc             	incl   -0x4(%ebp)
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	e8 95 f8 ff ff       	call   800e68 <strlen>
  8015d3:	83 c4 04             	add    $0x4,%esp
  8015d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015d9:	7f a4                	jg     80157f <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8015db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	57                   	push   %edi
  8015ef:	56                   	push   %esi
  8015f0:	53                   	push   %ebx
  8015f1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801600:	8b 7d 18             	mov    0x18(%ebp),%edi
  801603:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801606:	cd 30                	int    $0x30
  801608:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801622:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	52                   	push   %edx
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	50                   	push   %eax
  801632:	6a 00                	push   $0x0
  801634:	e8 b2 ff ff ff       	call   8015eb <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_cgetc>:

int
sys_cgetc(void)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 01                	push   $0x1
  80164e:	e8 98 ff ff ff       	call   8015eb <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	52                   	push   %edx
  801668:	50                   	push   %eax
  801669:	6a 05                	push   $0x5
  80166b:	e8 7b ff ff ff       	call   8015eb <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80167a:	8b 75 18             	mov    0x18(%ebp),%esi
  80167d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801680:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	51                   	push   %ecx
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	6a 06                	push   $0x6
  801690:	e8 56 ff ff ff       	call   8015eb <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	52                   	push   %edx
  8016af:	50                   	push   %eax
  8016b0:	6a 07                	push   $0x7
  8016b2:	e8 34 ff ff ff       	call   8015eb <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	6a 08                	push   $0x8
  8016cd:	e8 19 ff ff ff       	call   8015eb <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 09                	push   $0x9
  8016e6:	e8 00 ff ff ff       	call   8015eb <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 0a                	push   $0xa
  8016ff:	e8 e7 fe ff ff       	call   8015eb <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 0b                	push   $0xb
  801718:	e8 ce fe ff ff       	call   8015eb <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 0c                	push   $0xc
  801731:	e8 b5 fe ff ff       	call   8015eb <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 0d                	push   $0xd
  80174b:	e8 9b fe ff ff       	call   8015eb <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 0e                	push   $0xe
  801764:	e8 82 fe ff ff       	call   8015eb <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 11                	push   $0x11
  80177e:	e8 68 fe ff ff       	call   8015eb <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	90                   	nop
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 12                	push   $0x12
  801798:	e8 4e fe ff ff       	call   8015eb <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	90                   	nop
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	50                   	push   %eax
  8017bc:	6a 13                	push   $0x13
  8017be:	e8 28 fe ff ff       	call   8015eb <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	90                   	nop
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 14                	push   $0x14
  8017d8:	e8 0e fe ff ff       	call   8015eb <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	50                   	push   %eax
  8017f3:	6a 15                	push   $0x15
  8017f5:	e8 f1 fd ff ff       	call   8015eb <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 18                	push   $0x18
  801812:	e8 d4 fd ff ff       	call   8015eb <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 16                	push   $0x16
  80182f:	e8 b7 fd ff ff       	call   8015eb <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80183d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	6a 17                	push   $0x17
  80184d:	e8 99 fd ff ff       	call   8015eb <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	90                   	nop
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	8b 45 10             	mov    0x10(%ebp),%eax
  801861:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801864:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801867:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	51                   	push   %ecx
  801871:	52                   	push   %edx
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	50                   	push   %eax
  801876:	6a 19                	push   $0x19
  801878:	e8 6e fd ff ff       	call   8015eb <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	50                   	push   %eax
  801893:	6a 1a                	push   $0x1a
  801895:	e8 51 fd ff ff       	call   8015eb <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	51                   	push   %ecx
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 1b                	push   $0x1b
  8018b4:	e8 32 fd ff ff       	call   8015eb <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 1c                	push   $0x1c
  8018d1:	e8 15 fd ff ff       	call   8015eb <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 1d                	push   $0x1d
  8018ea:	e8 fc fc ff ff       	call   8015eb <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	ff 75 14             	pushl  0x14(%ebp)
  8018ff:	ff 75 10             	pushl  0x10(%ebp)
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 1e                	push   $0x1e
  801908:	e8 de fc ff ff       	call   8015eb <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	50                   	push   %eax
  801921:	6a 1f                	push   $0x1f
  801923:	e8 c3 fc ff ff       	call   8015eb <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 20                	push   $0x20
  80193f:	e8 a7 fc ff ff       	call   8015eb <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 02                	push   $0x2
  801958:	e8 8e fc ff ff       	call   8015eb <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 03                	push   $0x3
  801971:	e8 75 fc ff ff       	call   8015eb <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 04                	push   $0x4
  80198a:	e8 5c fc ff ff       	call   8015eb <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_exit_env>:


void sys_exit_env(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 21                	push   $0x21
  8019a3:	e8 43 fc ff ff       	call   8015eb <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b7:	8d 50 04             	lea    0x4(%eax),%edx
  8019ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 22                	push   $0x22
  8019c7:	e8 1f fc ff ff       	call   8015eb <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return result;
  8019cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d8:	89 01                	mov    %eax,(%ecx)
  8019da:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	c9                   	leave  
  8019e1:	c2 04 00             	ret    $0x4

008019e4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 10             	pushl  0x10(%ebp)
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 10                	push   $0x10
  8019f6:	e8 f0 fb ff ff       	call   8015eb <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 23                	push   $0x23
  801a10:	e8 d6 fb ff ff       	call   8015eb <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	50                   	push   %eax
  801a33:	6a 24                	push   $0x24
  801a35:	e8 b1 fb ff ff       	call   8015eb <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3d:	90                   	nop
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <rsttst>:
void rsttst()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 26                	push   $0x26
  801a4f:	e8 97 fb ff ff       	call   8015eb <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	8b 45 14             	mov    0x14(%ebp),%eax
  801a63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a66:	8b 55 18             	mov    0x18(%ebp),%edx
  801a69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	ff 75 10             	pushl  0x10(%ebp)
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	6a 25                	push   $0x25
  801a7a:	e8 6c fb ff ff       	call   8015eb <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <chktst>:
void chktst(uint32 n)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	6a 27                	push   $0x27
  801a95:	e8 51 fb ff ff       	call   8015eb <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <inctst>:

void inctst()
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 28                	push   $0x28
  801aaf:	e8 37 fb ff ff       	call   8015eb <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <gettst>:
uint32 gettst()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 29                	push   $0x29
  801ac9:	e8 1d fb ff ff       	call   8015eb <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 2a                	push   $0x2a
  801ae5:	e8 01 fb ff ff       	call   8015eb <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
  801aed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801af0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801af4:	75 07                	jne    801afd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801af6:	b8 01 00 00 00       	mov    $0x1,%eax
  801afb:	eb 05                	jmp    801b02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 2a                	push   $0x2a
  801b16:	e8 d0 fa ff ff       	call   8015eb <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
  801b1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b25:	75 07                	jne    801b2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b27:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2c:	eb 05                	jmp    801b33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 2a                	push   $0x2a
  801b47:	e8 9f fa ff ff       	call   8015eb <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
  801b4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b56:	75 07                	jne    801b5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b58:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5d:	eb 05                	jmp    801b64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 2a                	push   $0x2a
  801b78:	e8 6e fa ff ff       	call   8015eb <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
  801b80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b87:	75 07                	jne    801b90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b89:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8e:	eb 05                	jmp    801b95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 2b                	push   $0x2b
  801ba7:	e8 3f fa ff ff       	call   8015eb <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	53                   	push   %ebx
  801bc5:	51                   	push   %ecx
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 2c                	push   $0x2c
  801bca:	e8 1c fa ff ff       	call   8015eb <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 2d                	push   $0x2d
  801bea:	e8 fc f9 ff ff       	call   8015eb <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bf7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	51                   	push   %ecx
  801c03:	ff 75 10             	pushl  0x10(%ebp)
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 2e                	push   $0x2e
  801c0a:	e8 dc f9 ff ff       	call   8015eb <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 10             	pushl  0x10(%ebp)
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 0f                	push   $0xf
  801c26:	e8 c0 f9 ff ff       	call   8015eb <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	50                   	push   %eax
  801c40:	6a 2f                	push   $0x2f
  801c42:	e8 a4 f9 ff ff       	call   8015eb <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp

}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 30                	push   $0x30
  801c5d:	e8 89 f9 ff ff       	call   8015eb <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp

}
  801c65:	90                   	nop
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 31                	push   $0x31
  801c79:	e8 6d f9 ff ff       	call   8015eb <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp

}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_hard_limit>:
uint32 sys_hard_limit(){
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 32                	push   $0x32
  801c93:	e8 53 f9 ff ff       	call   8015eb <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    
  801c9d:	66 90                	xchg   %ax,%ax
  801c9f:	90                   	nop

00801ca0 <__udivdi3>:
  801ca0:	55                   	push   %ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801caf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cb7:	89 ca                	mov    %ecx,%edx
  801cb9:	89 f8                	mov    %edi,%eax
  801cbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cbf:	85 f6                	test   %esi,%esi
  801cc1:	75 2d                	jne    801cf0 <__udivdi3+0x50>
  801cc3:	39 cf                	cmp    %ecx,%edi
  801cc5:	77 65                	ja     801d2c <__udivdi3+0x8c>
  801cc7:	89 fd                	mov    %edi,%ebp
  801cc9:	85 ff                	test   %edi,%edi
  801ccb:	75 0b                	jne    801cd8 <__udivdi3+0x38>
  801ccd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd2:	31 d2                	xor    %edx,%edx
  801cd4:	f7 f7                	div    %edi
  801cd6:	89 c5                	mov    %eax,%ebp
  801cd8:	31 d2                	xor    %edx,%edx
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	f7 f5                	div    %ebp
  801cde:	89 c1                	mov    %eax,%ecx
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	f7 f5                	div    %ebp
  801ce4:	89 cf                	mov    %ecx,%edi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	39 ce                	cmp    %ecx,%esi
  801cf2:	77 28                	ja     801d1c <__udivdi3+0x7c>
  801cf4:	0f bd fe             	bsr    %esi,%edi
  801cf7:	83 f7 1f             	xor    $0x1f,%edi
  801cfa:	75 40                	jne    801d3c <__udivdi3+0x9c>
  801cfc:	39 ce                	cmp    %ecx,%esi
  801cfe:	72 0a                	jb     801d0a <__udivdi3+0x6a>
  801d00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d04:	0f 87 9e 00 00 00    	ja     801da8 <__udivdi3+0x108>
  801d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0f:	89 fa                	mov    %edi,%edx
  801d11:	83 c4 1c             	add    $0x1c,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5f                   	pop    %edi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
  801d19:	8d 76 00             	lea    0x0(%esi),%esi
  801d1c:	31 ff                	xor    %edi,%edi
  801d1e:	31 c0                	xor    %eax,%eax
  801d20:	89 fa                	mov    %edi,%edx
  801d22:	83 c4 1c             	add    $0x1c,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	f7 f7                	div    %edi
  801d30:	31 ff                	xor    %edi,%edi
  801d32:	89 fa                	mov    %edi,%edx
  801d34:	83 c4 1c             	add    $0x1c,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d41:	89 eb                	mov    %ebp,%ebx
  801d43:	29 fb                	sub    %edi,%ebx
  801d45:	89 f9                	mov    %edi,%ecx
  801d47:	d3 e6                	shl    %cl,%esi
  801d49:	89 c5                	mov    %eax,%ebp
  801d4b:	88 d9                	mov    %bl,%cl
  801d4d:	d3 ed                	shr    %cl,%ebp
  801d4f:	89 e9                	mov    %ebp,%ecx
  801d51:	09 f1                	or     %esi,%ecx
  801d53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d57:	89 f9                	mov    %edi,%ecx
  801d59:	d3 e0                	shl    %cl,%eax
  801d5b:	89 c5                	mov    %eax,%ebp
  801d5d:	89 d6                	mov    %edx,%esi
  801d5f:	88 d9                	mov    %bl,%cl
  801d61:	d3 ee                	shr    %cl,%esi
  801d63:	89 f9                	mov    %edi,%ecx
  801d65:	d3 e2                	shl    %cl,%edx
  801d67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d6b:	88 d9                	mov    %bl,%cl
  801d6d:	d3 e8                	shr    %cl,%eax
  801d6f:	09 c2                	or     %eax,%edx
  801d71:	89 d0                	mov    %edx,%eax
  801d73:	89 f2                	mov    %esi,%edx
  801d75:	f7 74 24 0c          	divl   0xc(%esp)
  801d79:	89 d6                	mov    %edx,%esi
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	f7 e5                	mul    %ebp
  801d7f:	39 d6                	cmp    %edx,%esi
  801d81:	72 19                	jb     801d9c <__udivdi3+0xfc>
  801d83:	74 0b                	je     801d90 <__udivdi3+0xf0>
  801d85:	89 d8                	mov    %ebx,%eax
  801d87:	31 ff                	xor    %edi,%edi
  801d89:	e9 58 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d94:	89 f9                	mov    %edi,%ecx
  801d96:	d3 e2                	shl    %cl,%edx
  801d98:	39 c2                	cmp    %eax,%edx
  801d9a:	73 e9                	jae    801d85 <__udivdi3+0xe5>
  801d9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d9f:	31 ff                	xor    %edi,%edi
  801da1:	e9 40 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	31 c0                	xor    %eax,%eax
  801daa:	e9 37 ff ff ff       	jmp    801ce6 <__udivdi3+0x46>
  801daf:	90                   	nop

00801db0 <__umoddi3>:
  801db0:	55                   	push   %ebp
  801db1:	57                   	push   %edi
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 1c             	sub    $0x1c,%esp
  801db7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dcf:	89 f3                	mov    %esi,%ebx
  801dd1:	89 fa                	mov    %edi,%edx
  801dd3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd7:	89 34 24             	mov    %esi,(%esp)
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	75 1a                	jne    801df8 <__umoddi3+0x48>
  801dde:	39 f7                	cmp    %esi,%edi
  801de0:	0f 86 a2 00 00 00    	jbe    801e88 <__umoddi3+0xd8>
  801de6:	89 c8                	mov    %ecx,%eax
  801de8:	89 f2                	mov    %esi,%edx
  801dea:	f7 f7                	div    %edi
  801dec:	89 d0                	mov    %edx,%eax
  801dee:	31 d2                	xor    %edx,%edx
  801df0:	83 c4 1c             	add    $0x1c,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
  801df8:	39 f0                	cmp    %esi,%eax
  801dfa:	0f 87 ac 00 00 00    	ja     801eac <__umoddi3+0xfc>
  801e00:	0f bd e8             	bsr    %eax,%ebp
  801e03:	83 f5 1f             	xor    $0x1f,%ebp
  801e06:	0f 84 ac 00 00 00    	je     801eb8 <__umoddi3+0x108>
  801e0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e11:	29 ef                	sub    %ebp,%edi
  801e13:	89 fe                	mov    %edi,%esi
  801e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 e0                	shl    %cl,%eax
  801e1d:	89 d7                	mov    %edx,%edi
  801e1f:	89 f1                	mov    %esi,%ecx
  801e21:	d3 ef                	shr    %cl,%edi
  801e23:	09 c7                	or     %eax,%edi
  801e25:	89 e9                	mov    %ebp,%ecx
  801e27:	d3 e2                	shl    %cl,%edx
  801e29:	89 14 24             	mov    %edx,(%esp)
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	d3 e0                	shl    %cl,%eax
  801e30:	89 c2                	mov    %eax,%edx
  801e32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e36:	d3 e0                	shl    %cl,%eax
  801e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e40:	89 f1                	mov    %esi,%ecx
  801e42:	d3 e8                	shr    %cl,%eax
  801e44:	09 d0                	or     %edx,%eax
  801e46:	d3 eb                	shr    %cl,%ebx
  801e48:	89 da                	mov    %ebx,%edx
  801e4a:	f7 f7                	div    %edi
  801e4c:	89 d3                	mov    %edx,%ebx
  801e4e:	f7 24 24             	mull   (%esp)
  801e51:	89 c6                	mov    %eax,%esi
  801e53:	89 d1                	mov    %edx,%ecx
  801e55:	39 d3                	cmp    %edx,%ebx
  801e57:	0f 82 87 00 00 00    	jb     801ee4 <__umoddi3+0x134>
  801e5d:	0f 84 91 00 00 00    	je     801ef4 <__umoddi3+0x144>
  801e63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e67:	29 f2                	sub    %esi,%edx
  801e69:	19 cb                	sbb    %ecx,%ebx
  801e6b:	89 d8                	mov    %ebx,%eax
  801e6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e71:	d3 e0                	shl    %cl,%eax
  801e73:	89 e9                	mov    %ebp,%ecx
  801e75:	d3 ea                	shr    %cl,%edx
  801e77:	09 d0                	or     %edx,%eax
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	d3 eb                	shr    %cl,%ebx
  801e7d:	89 da                	mov    %ebx,%edx
  801e7f:	83 c4 1c             	add    $0x1c,%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5e                   	pop    %esi
  801e84:	5f                   	pop    %edi
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    
  801e87:	90                   	nop
  801e88:	89 fd                	mov    %edi,%ebp
  801e8a:	85 ff                	test   %edi,%edi
  801e8c:	75 0b                	jne    801e99 <__umoddi3+0xe9>
  801e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f7                	div    %edi
  801e97:	89 c5                	mov    %eax,%ebp
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	31 d2                	xor    %edx,%edx
  801e9d:	f7 f5                	div    %ebp
  801e9f:	89 c8                	mov    %ecx,%eax
  801ea1:	f7 f5                	div    %ebp
  801ea3:	89 d0                	mov    %edx,%eax
  801ea5:	e9 44 ff ff ff       	jmp    801dee <__umoddi3+0x3e>
  801eaa:	66 90                	xchg   %ax,%ax
  801eac:	89 c8                	mov    %ecx,%eax
  801eae:	89 f2                	mov    %esi,%edx
  801eb0:	83 c4 1c             	add    $0x1c,%esp
  801eb3:	5b                   	pop    %ebx
  801eb4:	5e                   	pop    %esi
  801eb5:	5f                   	pop    %edi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    
  801eb8:	3b 04 24             	cmp    (%esp),%eax
  801ebb:	72 06                	jb     801ec3 <__umoddi3+0x113>
  801ebd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ec1:	77 0f                	ja     801ed2 <__umoddi3+0x122>
  801ec3:	89 f2                	mov    %esi,%edx
  801ec5:	29 f9                	sub    %edi,%ecx
  801ec7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ecb:	89 14 24             	mov    %edx,(%esp)
  801ece:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed6:	8b 14 24             	mov    (%esp),%edx
  801ed9:	83 c4 1c             	add    $0x1c,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
  801ee1:	8d 76 00             	lea    0x0(%esi),%esi
  801ee4:	2b 04 24             	sub    (%esp),%eax
  801ee7:	19 fa                	sbb    %edi,%edx
  801ee9:	89 d1                	mov    %edx,%ecx
  801eeb:	89 c6                	mov    %eax,%esi
  801eed:	e9 71 ff ff ff       	jmp    801e63 <__umoddi3+0xb3>
  801ef2:	66 90                	xchg   %ax,%ax
  801ef4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ef8:	72 ea                	jb     801ee4 <__umoddi3+0x134>
  801efa:	89 d9                	mov    %ebx,%ecx
  801efc:	e9 62 ff ff ff       	jmp    801e63 <__umoddi3+0xb3>
