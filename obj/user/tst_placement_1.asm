
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 93 03 00 00       	call   8003c9 <libmain>
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
  80003d:	81 ec 70 00 00 01    	sub    $0x1000070,%esp
	int freePages = sys_calculate_free_frames();
  800043:	e8 66 16 00 00       	call   8016ae <sys_calculate_free_frames>
  800048:	89 45 ec             	mov    %eax,-0x14(%ebp)

	//	cprintf("envID = %d\n",envID);
	char arr[PAGE_SIZE*1024*4];

	uint32 actual_active_list[17] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  80004b:	8d 95 94 ff ff fe    	lea    -0x100006c(%ebp),%edx
  800051:	b9 11 00 00 00       	mov    $0x11,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
  80005f:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  800066:	d0 bf ed 
  800069:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  800070:	d0 bf ee 
  800073:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  80007a:	30 80 00 
  80007d:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  800084:	20 80 00 
  800087:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  80008e:	10 80 00 
  800091:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  800098:	00 80 00 
  80009b:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  8000a2:	50 20 00 
  8000a5:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  8000ac:	40 20 00 
  8000af:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  8000b6:	30 20 00 
  8000b9:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000c0:	20 20 00 
  8000c3:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000ca:	10 20 00 
  8000cd:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000d4:	00 20 00 
	uint32 actual_second_list[2] = {};
  8000d7:	c7 85 8c ff ff fe 00 	movl   $0x0,-0x1000074(%ebp)
  8000de:	00 00 00 
  8000e1:	c7 85 90 ff ff fe 00 	movl   $0x0,-0x1000070(%ebp)
  8000e8:	00 00 00 

	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000eb:	6a 00                	push   $0x0
  8000ed:	6a 0c                	push   $0xc
  8000ef:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  8000f5:	50                   	push   %eax
  8000f6:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000fc:	50                   	push   %eax
  8000fd:	e8 87 1a 00 00       	call   801b89 <sys_check_LRU_lists>
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  800108:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80010c:	75 14                	jne    800122 <_main+0xea>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	68 e0 1e 80 00       	push   $0x801ee0
  800116:	6a 17                	push   $0x17
  800118:	68 62 1f 80 00       	push   $0x801f62
  80011d:	e8 de 03 00 00       	call   800500 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800122:	e8 d2 15 00 00       	call   8016f9 <sys_pf_calculate_allocated_pages>
  800127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = 'A';
  800133:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 41             	movb   $0x41,(%eax)
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800141:	ff 45 f4             	incl   -0xc(%ebp)
  800144:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80014b:	7e e6                	jle    800133 <_main+0xfb>
	{
		arr[i] = 'A';
	}
	cprintf("1. free frames = %d\n", sys_calculate_free_frames());
  80014d:	e8 5c 15 00 00       	call   8016ae <sys_calculate_free_frames>
  800152:	83 ec 08             	sub    $0x8,%esp
  800155:	50                   	push   %eax
  800156:	68 79 1f 80 00       	push   $0x801f79
  80015b:	e8 5d 06 00 00       	call   8007bd <cprintf>
  800160:	83 c4 10             	add    $0x10,%esp

	i=PAGE_SIZE*1024;
  800163:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80016a:	eb 11                	jmp    80017d <_main+0x145>
	{
		arr[i] = 'A';
  80016c:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800175:	01 d0                	add    %edx,%eax
  800177:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80017a:	ff 45 f4             	incl   -0xc(%ebp)
  80017d:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800184:	7e e6                	jle    80016c <_main+0x134>
	{
		arr[i] = 'A';
	}
	cprintf("2. free frames = %d\n", sys_calculate_free_frames());
  800186:	e8 23 15 00 00       	call   8016ae <sys_calculate_free_frames>
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	50                   	push   %eax
  80018f:	68 8e 1f 80 00       	push   $0x801f8e
  800194:	e8 24 06 00 00       	call   8007bd <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp

	i=PAGE_SIZE*1024*2;
  80019c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8001a3:	eb 11                	jmp    8001b6 <_main+0x17e>
	{
		arr[i] = 'A';
  8001a5:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  8001ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8001b3:	ff 45 f4             	incl   -0xc(%ebp)
  8001b6:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  8001bd:	7e e6                	jle    8001a5 <_main+0x16d>
	{
		arr[i] = 'A';
	}
	cprintf("3. free frames = %d\n", sys_calculate_free_frames());
  8001bf:	e8 ea 14 00 00       	call   8016ae <sys_calculate_free_frames>
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	50                   	push   %eax
  8001c8:	68 a3 1f 80 00       	push   $0x801fa3
  8001cd:	e8 eb 05 00 00       	call   8007bd <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp


	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 1f 80 00       	push   $0x801fb8
  8001dd:	e8 db 05 00 00       	call   8007bd <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  panic("PLACEMENT of stack page failed");
  8001e5:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  8001eb:	3c 41                	cmp    $0x41,%al
  8001ed:	74 14                	je     800203 <_main+0x1cb>
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	68 e8 1f 80 00       	push   $0x801fe8
  8001f7:	6a 34                	push   $0x34
  8001f9:	68 62 1f 80 00       	push   $0x801f62
  8001fe:	e8 fd 02 00 00       	call   800500 <_panic>
		if( arr[PAGE_SIZE] != 'A')  panic("PLACEMENT of stack page failed");
  800203:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  800209:	3c 41                	cmp    $0x41,%al
  80020b:	74 14                	je     800221 <_main+0x1e9>
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	68 e8 1f 80 00       	push   $0x801fe8
  800215:	6a 35                	push   $0x35
  800217:	68 62 1f 80 00       	push   $0x801f62
  80021c:	e8 df 02 00 00       	call   800500 <_panic>

		if( arr[PAGE_SIZE*1024] != 'A')  panic("PLACEMENT of stack page failed");
  800221:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  800227:	3c 41                	cmp    $0x41,%al
  800229:	74 14                	je     80023f <_main+0x207>
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	68 e8 1f 80 00       	push   $0x801fe8
  800233:	6a 37                	push   $0x37
  800235:	68 62 1f 80 00       	push   $0x801f62
  80023a:	e8 c1 02 00 00       	call   800500 <_panic>
		if( arr[PAGE_SIZE*1025] != 'A')  panic("PLACEMENT of stack page failed");
  80023f:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  800245:	3c 41                	cmp    $0x41,%al
  800247:	74 14                	je     80025d <_main+0x225>
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	68 e8 1f 80 00       	push   $0x801fe8
  800251:	6a 38                	push   $0x38
  800253:	68 62 1f 80 00       	push   $0x801f62
  800258:	e8 a3 02 00 00       	call   800500 <_panic>

		if( arr[PAGE_SIZE*1024*2] != 'A')  panic("PLACEMENT of stack page failed");
  80025d:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  800263:	3c 41                	cmp    $0x41,%al
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 e8 1f 80 00       	push   $0x801fe8
  80026f:	6a 3a                	push   $0x3a
  800271:	68 62 1f 80 00       	push   $0x801f62
  800276:	e8 85 02 00 00       	call   800500 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  panic("PLACEMENT of stack page failed");
  80027b:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  800281:	3c 41                	cmp    $0x41,%al
  800283:	74 14                	je     800299 <_main+0x261>
  800285:	83 ec 04             	sub    $0x4,%esp
  800288:	68 e8 1f 80 00       	push   $0x801fe8
  80028d:	6a 3b                	push   $0x3b
  80028f:	68 62 1f 80 00       	push   $0x801f62
  800294:	e8 67 02 00 00       	call   800500 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT written to Page File until it's replaced");
  800299:	e8 5b 14 00 00       	call   8016f9 <sys_pf_calculate_allocated_pages>
  80029e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8002a1:	74 14                	je     8002b7 <_main+0x27f>
  8002a3:	83 ec 04             	sub    $0x4,%esp
  8002a6:	68 08 20 80 00       	push   $0x802008
  8002ab:	6a 3d                	push   $0x3d
  8002ad:	68 62 1f 80 00       	push   $0x801f62
  8002b2:	e8 49 02 00 00       	call   800500 <_panic>

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  8002b7:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  8002be:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8002c1:	e8 e8 13 00 00       	call   8016ae <sys_calculate_free_frames>
  8002c6:	29 c3                	sub    %eax,%ebx
  8002c8:	89 d8                	mov    %ebx,%eax
  8002ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;

		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
  8002cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002d0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002d3:	74 1a                	je     8002ef <_main+0x2b7>
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002db:	ff 75 e0             	pushl  -0x20(%ebp)
  8002de:	68 4c 20 80 00       	push   $0x80204c
  8002e3:	6a 43                	push   $0x43
  8002e5:	68 62 1f 80 00       	push   $0x801f62
  8002ea:	e8 11 02 00 00       	call   800500 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 88 20 80 00       	push   $0x802088
  8002f7:	e8 c1 04 00 00       	call   8007bd <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp

	for (int i=16;i>4;i--)
  8002ff:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
  800306:	eb 1a                	jmp    800322 <_main+0x2ea>
		actual_active_list[i]=actual_active_list[i-5];
  800308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030b:	83 e8 05             	sub    $0x5,%eax
  80030e:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  800315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800318:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)

		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	for (int i=16;i>4;i--)
  80031f:	ff 4d f0             	decl   -0x10(%ebp)
  800322:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  800326:	7f e0                	jg     800308 <_main+0x2d0>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  800328:	c7 85 94 ff ff fe 00 	movl   $0xee3fe000,-0x100006c(%ebp)
  80032f:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800332:	c7 85 98 ff ff fe 00 	movl   $0xee3fd000,-0x1000068(%ebp)
  800339:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  80033c:	c7 85 9c ff ff fe 00 	movl   $0xedffe000,-0x1000064(%ebp)
  800343:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800346:	c7 85 a0 ff ff fe 00 	movl   $0xedffd000,-0x1000060(%ebp)
  80034d:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800350:	c7 85 a4 ff ff fe 00 	movl   $0xedbfe000,-0x100005c(%ebp)
  800357:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	68 bc 20 80 00       	push   $0x8020bc
  800362:	e8 56 04 00 00       	call   8007bd <cprintf>
  800367:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  80036a:	6a 00                	push   $0x0
  80036c:	6a 11                	push   $0x11
  80036e:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  800374:	50                   	push   %eax
  800375:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  80037b:	50                   	push   %eax
  80037c:	e8 08 18 00 00       	call   801b89 <sys_check_LRU_lists>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if(check == 0)
  800387:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80038b:	75 14                	jne    8003a1 <_main+0x369>
				panic("LRU lists entries are not correct, check your logic again!!");
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 e4 20 80 00       	push   $0x8020e4
  800395:	6a 54                	push   $0x54
  800397:	68 62 1f 80 00       	push   $0x801f62
  80039c:	e8 5f 01 00 00       	call   800500 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 20 21 80 00       	push   $0x802120
  8003a9:	e8 0f 04 00 00       	call   8007bd <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed successfully!!\n\n\n");
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 58 21 80 00       	push   $0x802158
  8003b9:	e8 ff 03 00 00       	call   8007bd <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
	return;
  8003c1:	90                   	nop
}
  8003c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003c5:	5b                   	pop    %ebx
  8003c6:	5f                   	pop    %edi
  8003c7:	5d                   	pop    %ebp
  8003c8:	c3                   	ret    

008003c9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003cf:	e8 65 15 00 00       	call   801939 <sys_getenvindex>
  8003d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	c1 e0 03             	shl    $0x3,%eax
  8003df:	01 d0                	add    %edx,%eax
  8003e1:	01 c0                	add    %eax,%eax
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ec:	01 d0                	add    %edx,%eax
  8003ee:	c1 e0 04             	shl    $0x4,%eax
  8003f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003f6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8a 40 5c             	mov    0x5c(%eax),%al
  800403:	84 c0                	test   %al,%al
  800405:	74 0d                	je     800414 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800407:	a1 20 30 80 00       	mov    0x803020,%eax
  80040c:	83 c0 5c             	add    $0x5c,%eax
  80040f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800414:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800418:	7e 0a                	jle    800424 <libmain+0x5b>
		binaryname = argv[0];
  80041a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	e8 06 fc ff ff       	call   800038 <_main>
  800432:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800435:	e8 0c 13 00 00       	call   801746 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80043a:	83 ec 0c             	sub    $0xc,%esp
  80043d:	68 c4 21 80 00       	push   $0x8021c4
  800442:	e8 76 03 00 00       	call   8007bd <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80044a:	a1 20 30 80 00       	mov    0x803020,%eax
  80044f:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800455:	a1 20 30 80 00       	mov    0x803020,%eax
  80045a:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	52                   	push   %edx
  800464:	50                   	push   %eax
  800465:	68 ec 21 80 00       	push   $0x8021ec
  80046a:	e8 4e 03 00 00       	call   8007bd <cprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800472:	a1 20 30 80 00       	mov    0x803020,%eax
  800477:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80047d:	a1 20 30 80 00       	mov    0x803020,%eax
  800482:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800488:	a1 20 30 80 00       	mov    0x803020,%eax
  80048d:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800493:	51                   	push   %ecx
  800494:	52                   	push   %edx
  800495:	50                   	push   %eax
  800496:	68 14 22 80 00       	push   $0x802214
  80049b:	e8 1d 03 00 00       	call   8007bd <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	50                   	push   %eax
  8004b2:	68 6c 22 80 00       	push   $0x80226c
  8004b7:	e8 01 03 00 00       	call   8007bd <cprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	68 c4 21 80 00       	push   $0x8021c4
  8004c7:	e8 f1 02 00 00       	call   8007bd <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004cf:	e8 8c 12 00 00       	call   801760 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004d4:	e8 19 00 00 00       	call   8004f2 <exit>
}
  8004d9:	90                   	nop
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
  8004df:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	6a 00                	push   $0x0
  8004e7:	e8 19 14 00 00       	call   801905 <sys_destroy_env>
  8004ec:	83 c4 10             	add    $0x10,%esp
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <exit>:

void
exit(void)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004f8:	e8 6e 14 00 00       	call   80196b <sys_exit_env>
}
  8004fd:	90                   	nop
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800506:	8d 45 10             	lea    0x10(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80050f:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	74 16                	je     80052e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800518:	a1 2c 31 80 00       	mov    0x80312c,%eax
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	50                   	push   %eax
  800521:	68 80 22 80 00       	push   $0x802280
  800526:	e8 92 02 00 00       	call   8007bd <cprintf>
  80052b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80052e:	a1 00 30 80 00       	mov    0x803000,%eax
  800533:	ff 75 0c             	pushl  0xc(%ebp)
  800536:	ff 75 08             	pushl  0x8(%ebp)
  800539:	50                   	push   %eax
  80053a:	68 85 22 80 00       	push   $0x802285
  80053f:	e8 79 02 00 00       	call   8007bd <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800547:	8b 45 10             	mov    0x10(%ebp),%eax
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 f4             	pushl  -0xc(%ebp)
  800550:	50                   	push   %eax
  800551:	e8 fc 01 00 00       	call   800752 <vcprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	6a 00                	push   $0x0
  80055e:	68 a1 22 80 00       	push   $0x8022a1
  800563:	e8 ea 01 00 00       	call   800752 <vcprintf>
  800568:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80056b:	e8 82 ff ff ff       	call   8004f2 <exit>

	// should not return here
	while (1) ;
  800570:	eb fe                	jmp    800570 <_panic+0x70>

00800572 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800578:	a1 20 30 80 00       	mov    0x803020,%eax
  80057d:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 a4 22 80 00       	push   $0x8022a4
  800592:	6a 26                	push   $0x26
  800594:	68 f0 22 80 00       	push   $0x8022f0
  800599:	e8 62 ff ff ff       	call   800500 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80059e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ac:	e9 c5 00 00 00       	jmp    800676 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	01 d0                	add    %edx,%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	85 c0                	test   %eax,%eax
  8005c4:	75 08                	jne    8005ce <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005c6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005c9:	e9 a5 00 00 00       	jmp    800673 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005dc:	eb 69                	jmp    800647 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005de:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ec:	89 d0                	mov    %edx,%eax
  8005ee:	01 c0                	add    %eax,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	c1 e0 03             	shl    $0x3,%eax
  8005f5:	01 c8                	add    %ecx,%eax
  8005f7:	8a 40 04             	mov    0x4(%eax),%al
  8005fa:	84 c0                	test   %al,%al
  8005fc:	75 46                	jne    800644 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800603:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800609:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80060c:	89 d0                	mov    %edx,%eax
  80060e:	01 c0                	add    %eax,%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	c1 e0 03             	shl    $0x3,%eax
  800615:	01 c8                	add    %ecx,%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80061c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800624:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800629:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	01 c8                	add    %ecx,%eax
  800635:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800637:	39 c2                	cmp    %eax,%edx
  800639:	75 09                	jne    800644 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80063b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800642:	eb 15                	jmp    800659 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800644:	ff 45 e8             	incl   -0x18(%ebp)
  800647:	a1 20 30 80 00       	mov    0x803020,%eax
  80064c:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800655:	39 c2                	cmp    %eax,%edx
  800657:	77 85                	ja     8005de <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800659:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80065d:	75 14                	jne    800673 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80065f:	83 ec 04             	sub    $0x4,%esp
  800662:	68 fc 22 80 00       	push   $0x8022fc
  800667:	6a 3a                	push   $0x3a
  800669:	68 f0 22 80 00       	push   $0x8022f0
  80066e:	e8 8d fe ff ff       	call   800500 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800673:	ff 45 f0             	incl   -0x10(%ebp)
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80067c:	0f 8c 2f ff ff ff    	jl     8005b1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800682:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800689:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800690:	eb 26                	jmp    8006b8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800692:	a1 20 30 80 00       	mov    0x803020,%eax
  800697:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80069d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a0:	89 d0                	mov    %edx,%eax
  8006a2:	01 c0                	add    %eax,%eax
  8006a4:	01 d0                	add    %edx,%eax
  8006a6:	c1 e0 03             	shl    $0x3,%eax
  8006a9:	01 c8                	add    %ecx,%eax
  8006ab:	8a 40 04             	mov    0x4(%eax),%al
  8006ae:	3c 01                	cmp    $0x1,%al
  8006b0:	75 03                	jne    8006b5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006b2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b5:	ff 45 e0             	incl   -0x20(%ebp)
  8006b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bd:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8006c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c6:	39 c2                	cmp    %eax,%edx
  8006c8:	77 c8                	ja     800692 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006cd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006d0:	74 14                	je     8006e6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006d2:	83 ec 04             	sub    $0x4,%esp
  8006d5:	68 50 23 80 00       	push   $0x802350
  8006da:	6a 44                	push   $0x44
  8006dc:	68 f0 22 80 00       	push   $0x8022f0
  8006e1:	e8 1a fe ff ff       	call   800500 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006e6:	90                   	nop
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8006f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fa:	89 0a                	mov    %ecx,(%edx)
  8006fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ff:	88 d1                	mov    %dl,%cl
  800701:	8b 55 0c             	mov    0xc(%ebp),%edx
  800704:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800712:	75 2c                	jne    800740 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800714:	a0 24 30 80 00       	mov    0x803024,%al
  800719:	0f b6 c0             	movzbl %al,%eax
  80071c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071f:	8b 12                	mov    (%edx),%edx
  800721:	89 d1                	mov    %edx,%ecx
  800723:	8b 55 0c             	mov    0xc(%ebp),%edx
  800726:	83 c2 08             	add    $0x8,%edx
  800729:	83 ec 04             	sub    $0x4,%esp
  80072c:	50                   	push   %eax
  80072d:	51                   	push   %ecx
  80072e:	52                   	push   %edx
  80072f:	e8 b9 0e 00 00       	call   8015ed <sys_cputs>
  800734:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800740:	8b 45 0c             	mov    0xc(%ebp),%eax
  800743:	8b 40 04             	mov    0x4(%eax),%eax
  800746:	8d 50 01             	lea    0x1(%eax),%edx
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80074f:	90                   	nop
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80075b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800762:	00 00 00 
	b.cnt = 0;
  800765:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80076c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	ff 75 08             	pushl  0x8(%ebp)
  800775:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80077b:	50                   	push   %eax
  80077c:	68 e9 06 80 00       	push   $0x8006e9
  800781:	e8 11 02 00 00       	call   800997 <vprintfmt>
  800786:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800789:	a0 24 30 80 00       	mov    0x803024,%al
  80078e:	0f b6 c0             	movzbl %al,%eax
  800791:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800797:	83 ec 04             	sub    $0x4,%esp
  80079a:	50                   	push   %eax
  80079b:	52                   	push   %edx
  80079c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a2:	83 c0 08             	add    $0x8,%eax
  8007a5:	50                   	push   %eax
  8007a6:	e8 42 0e 00 00       	call   8015ed <sys_cputs>
  8007ab:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ae:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <cprintf>:

int cprintf(const char *fmt, ...) {
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d9:	50                   	push   %eax
  8007da:	e8 73 ff ff ff       	call   800752 <vcprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    

008007ea <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007f0:	e8 51 0f 00 00       	call   801746 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007f5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 f4             	pushl  -0xc(%ebp)
  800804:	50                   	push   %eax
  800805:	e8 48 ff ff ff       	call   800752 <vcprintf>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800810:	e8 4b 0f 00 00       	call   801760 <sys_enable_interrupt>
	return cnt;
  800815:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	83 ec 14             	sub    $0x14,%esp
  800821:	8b 45 10             	mov    0x10(%ebp),%eax
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80082d:	8b 45 18             	mov    0x18(%ebp),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
  800835:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800838:	77 55                	ja     80088f <printnum+0x75>
  80083a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083d:	72 05                	jb     800844 <printnum+0x2a>
  80083f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800842:	77 4b                	ja     80088f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800844:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800847:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80084a:	8b 45 18             	mov    0x18(%ebp),%eax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
  800852:	52                   	push   %edx
  800853:	50                   	push   %eax
  800854:	ff 75 f4             	pushl  -0xc(%ebp)
  800857:	ff 75 f0             	pushl  -0x10(%ebp)
  80085a:	e8 15 14 00 00       	call   801c74 <__udivdi3>
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	83 ec 04             	sub    $0x4,%esp
  800865:	ff 75 20             	pushl  0x20(%ebp)
  800868:	53                   	push   %ebx
  800869:	ff 75 18             	pushl  0x18(%ebp)
  80086c:	52                   	push   %edx
  80086d:	50                   	push   %eax
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	ff 75 08             	pushl  0x8(%ebp)
  800874:	e8 a1 ff ff ff       	call   80081a <printnum>
  800879:	83 c4 20             	add    $0x20,%esp
  80087c:	eb 1a                	jmp    800898 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	ff 75 20             	pushl  0x20(%ebp)
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
  80088c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088f:	ff 4d 1c             	decl   0x1c(%ebp)
  800892:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800896:	7f e6                	jg     80087e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800898:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80089b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a6:	53                   	push   %ebx
  8008a7:	51                   	push   %ecx
  8008a8:	52                   	push   %edx
  8008a9:	50                   	push   %eax
  8008aa:	e8 d5 14 00 00       	call   801d84 <__umoddi3>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	05 b4 25 80 00       	add    $0x8025b4,%eax
  8008b7:	8a 00                	mov    (%eax),%al
  8008b9:	0f be c0             	movsbl %al,%eax
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	50                   	push   %eax
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
}
  8008cb:	90                   	nop
  8008cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d8:	7e 1c                	jle    8008f6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	8d 50 08             	lea    0x8(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	89 10                	mov    %edx,(%eax)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 e8 08             	sub    $0x8,%eax
  8008ef:	8b 50 04             	mov    0x4(%eax),%edx
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	eb 40                	jmp    800936 <getuint+0x65>
	else if (lflag)
  8008f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fa:	74 1e                	je     80091a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	8d 50 04             	lea    0x4(%eax),%edx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 10                	mov    %edx,(%eax)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	83 e8 04             	sub    $0x4,%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	ba 00 00 00 00       	mov    $0x0,%edx
  800918:	eb 1c                	jmp    800936 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	8d 50 04             	lea    0x4(%eax),%edx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	89 10                	mov    %edx,(%eax)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	83 e8 04             	sub    $0x4,%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093f:	7e 1c                	jle    80095d <getint+0x25>
		return va_arg(*ap, long long);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 08             	lea    0x8(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 08             	sub    $0x8,%eax
  800956:	8b 50 04             	mov    0x4(%eax),%edx
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	eb 38                	jmp    800995 <getint+0x5d>
	else if (lflag)
  80095d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800961:	74 1a                	je     80097d <getint+0x45>
		return va_arg(*ap, long);
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	8d 50 04             	lea    0x4(%eax),%edx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 10                	mov    %edx,(%eax)
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	83 e8 04             	sub    $0x4,%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	99                   	cltd   
  80097b:	eb 18                	jmp    800995 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	8d 50 04             	lea    0x4(%eax),%edx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	89 10                	mov    %edx,(%eax)
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	83 e8 04             	sub    $0x4,%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	99                   	cltd   
}
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099f:	eb 17                	jmp    8009b8 <vprintfmt+0x21>
			if (ch == '\0')
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	0f 84 af 03 00 00    	je     800d58 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	83 fb 25             	cmp    $0x25,%ebx
  8009c9:	75 d6                	jne    8009a1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009cb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ee:	8d 50 01             	lea    0x1(%eax),%edx
  8009f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f4:	8a 00                	mov    (%eax),%al
  8009f6:	0f b6 d8             	movzbl %al,%ebx
  8009f9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009fc:	83 f8 55             	cmp    $0x55,%eax
  8009ff:	0f 87 2b 03 00 00    	ja     800d30 <vprintfmt+0x399>
  800a05:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  800a0c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a12:	eb d7                	jmp    8009eb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a14:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a18:	eb d1                	jmp    8009eb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a24:	89 d0                	mov    %edx,%eax
  800a26:	c1 e0 02             	shl    $0x2,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	01 c0                	add    %eax,%eax
  800a2d:	01 d8                	add    %ebx,%eax
  800a2f:	83 e8 30             	sub    $0x30,%eax
  800a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a35:	8b 45 10             	mov    0x10(%ebp),%eax
  800a38:	8a 00                	mov    (%eax),%al
  800a3a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a40:	7e 3e                	jle    800a80 <vprintfmt+0xe9>
  800a42:	83 fb 39             	cmp    $0x39,%ebx
  800a45:	7f 39                	jg     800a80 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a47:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4a:	eb d5                	jmp    800a21 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 c0 04             	add    $0x4,%eax
  800a52:	89 45 14             	mov    %eax,0x14(%ebp)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	83 e8 04             	sub    $0x4,%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a66:	79 83                	jns    8009eb <vprintfmt+0x54>
				width = 0;
  800a68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6f:	e9 77 ff ff ff       	jmp    8009eb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a74:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a7b:	e9 6b ff ff ff       	jmp    8009eb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a80:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a85:	0f 89 60 ff ff ff    	jns    8009eb <vprintfmt+0x54>
				width = precision, precision = -1;
  800a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a91:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a98:	e9 4e ff ff ff       	jmp    8009eb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a9d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aa0:	e9 46 ff ff ff       	jmp    8009eb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa8:	83 c0 04             	add    $0x4,%eax
  800aab:	89 45 14             	mov    %eax,0x14(%ebp)
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 e8 04             	sub    $0x4,%eax
  800ab4:	8b 00                	mov    (%eax),%eax
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	50                   	push   %eax
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			break;
  800ac5:	e9 89 02 00 00       	jmp    800d53 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 c0 04             	add    $0x4,%eax
  800ad0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800adb:	85 db                	test   %ebx,%ebx
  800add:	79 02                	jns    800ae1 <vprintfmt+0x14a>
				err = -err;
  800adf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae1:	83 fb 64             	cmp    $0x64,%ebx
  800ae4:	7f 0b                	jg     800af1 <vprintfmt+0x15a>
  800ae6:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800aed:	85 f6                	test   %esi,%esi
  800aef:	75 19                	jne    800b0a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800af1:	53                   	push   %ebx
  800af2:	68 c5 25 80 00       	push   $0x8025c5
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	ff 75 08             	pushl  0x8(%ebp)
  800afd:	e8 5e 02 00 00       	call   800d60 <printfmt>
  800b02:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b05:	e9 49 02 00 00       	jmp    800d53 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b0a:	56                   	push   %esi
  800b0b:	68 ce 25 80 00       	push   $0x8025ce
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	ff 75 08             	pushl  0x8(%ebp)
  800b16:	e8 45 02 00 00       	call   800d60 <printfmt>
  800b1b:	83 c4 10             	add    $0x10,%esp
			break;
  800b1e:	e9 30 02 00 00       	jmp    800d53 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b23:	8b 45 14             	mov    0x14(%ebp),%eax
  800b26:	83 c0 04             	add    $0x4,%eax
  800b29:	89 45 14             	mov    %eax,0x14(%ebp)
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 e8 04             	sub    $0x4,%eax
  800b32:	8b 30                	mov    (%eax),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 05                	jne    800b3d <vprintfmt+0x1a6>
				p = "(null)";
  800b38:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b41:	7e 6d                	jle    800bb0 <vprintfmt+0x219>
  800b43:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b47:	74 67                	je     800bb0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	50                   	push   %eax
  800b50:	56                   	push   %esi
  800b51:	e8 0c 03 00 00       	call   800e62 <strnlen>
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b5c:	eb 16                	jmp    800b74 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	50                   	push   %eax
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b71:	ff 4d e4             	decl   -0x1c(%ebp)
  800b74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b78:	7f e4                	jg     800b5e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	eb 34                	jmp    800bb0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b80:	74 1c                	je     800b9e <vprintfmt+0x207>
  800b82:	83 fb 1f             	cmp    $0x1f,%ebx
  800b85:	7e 05                	jle    800b8c <vprintfmt+0x1f5>
  800b87:	83 fb 7e             	cmp    $0x7e,%ebx
  800b8a:	7e 12                	jle    800b9e <vprintfmt+0x207>
					putch('?', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 3f                	push   $0x3f
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	eb 0f                	jmp    800bad <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	53                   	push   %ebx
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	ff d0                	call   *%eax
  800baa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bad:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb0:	89 f0                	mov    %esi,%eax
  800bb2:	8d 70 01             	lea    0x1(%eax),%esi
  800bb5:	8a 00                	mov    (%eax),%al
  800bb7:	0f be d8             	movsbl %al,%ebx
  800bba:	85 db                	test   %ebx,%ebx
  800bbc:	74 24                	je     800be2 <vprintfmt+0x24b>
  800bbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc2:	78 b8                	js     800b7c <vprintfmt+0x1e5>
  800bc4:	ff 4d e0             	decl   -0x20(%ebp)
  800bc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bcb:	79 af                	jns    800b7c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcd:	eb 13                	jmp    800be2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 20                	push   $0x20
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdf:	ff 4d e4             	decl   -0x1c(%ebp)
  800be2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be6:	7f e7                	jg     800bcf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be8:	e9 66 01 00 00       	jmp    800d53 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf6:	50                   	push   %eax
  800bf7:	e8 3c fd ff ff       	call   800938 <getint>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0b:	85 d2                	test   %edx,%edx
  800c0d:	79 23                	jns    800c32 <vprintfmt+0x29b>
				putch('-', putdat);
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	6a 2d                	push   $0x2d
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	ff d0                	call   *%eax
  800c1c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c25:	f7 d8                	neg    %eax
  800c27:	83 d2 00             	adc    $0x0,%edx
  800c2a:	f7 da                	neg    %edx
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c32:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c39:	e9 bc 00 00 00       	jmp    800cfa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 e8             	pushl  -0x18(%ebp)
  800c44:	8d 45 14             	lea    0x14(%ebp),%eax
  800c47:	50                   	push   %eax
  800c48:	e8 84 fc ff ff       	call   8008d1 <getuint>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c5d:	e9 98 00 00 00       	jmp    800cfa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 58                	push   $0x58
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 58                	push   $0x58
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	6a 58                	push   $0x58
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
			break;
  800c92:	e9 bc 00 00 00       	jmp    800d53 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	6a 30                	push   $0x30
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	6a 78                	push   $0x78
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	83 c0 04             	add    $0x4,%eax
  800cbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 e8 04             	sub    $0x4,%eax
  800cc6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd9:	eb 1f                	jmp    800cfa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce4:	50                   	push   %eax
  800ce5:	e8 e7 fb ff ff       	call   8008d1 <getuint>
  800cea:	83 c4 10             	add    $0x10,%esp
  800ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d01:	83 ec 04             	sub    $0x4,%esp
  800d04:	52                   	push   %edx
  800d05:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d08:	50                   	push   %eax
  800d09:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0c:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	ff 75 08             	pushl  0x8(%ebp)
  800d15:	e8 00 fb ff ff       	call   80081a <printnum>
  800d1a:	83 c4 20             	add    $0x20,%esp
			break;
  800d1d:	eb 34                	jmp    800d53 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	53                   	push   %ebx
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	ff d0                	call   *%eax
  800d2b:	83 c4 10             	add    $0x10,%esp
			break;
  800d2e:	eb 23                	jmp    800d53 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	6a 25                	push   $0x25
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	ff d0                	call   *%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d40:	ff 4d 10             	decl   0x10(%ebp)
  800d43:	eb 03                	jmp    800d48 <vprintfmt+0x3b1>
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	48                   	dec    %eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3c 25                	cmp    $0x25,%al
  800d50:	75 f3                	jne    800d45 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d52:	90                   	nop
		}
	}
  800d53:	e9 47 fc ff ff       	jmp    80099f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d58:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d66:	8d 45 10             	lea    0x10(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	50                   	push   %eax
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 16 fc ff ff       	call   800997 <vprintfmt>
  800d81:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d84:	90                   	nop
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 40 08             	mov    0x8(%eax),%eax
  800d90:	8d 50 01             	lea    0x1(%eax),%edx
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 10                	mov    (%eax),%edx
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 40 04             	mov    0x4(%eax),%eax
  800da4:	39 c2                	cmp    %eax,%edx
  800da6:	73 12                	jae    800dba <sprintputch+0x33>
		*b->buf++ = ch;
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 00                	mov    (%eax),%eax
  800dad:	8d 48 01             	lea    0x1(%eax),%ecx
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	89 0a                	mov    %ecx,(%edx)
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	88 10                	mov    %dl,(%eax)
}
  800dba:	90                   	nop
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	01 d0                	add    %edx,%eax
  800dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de2:	74 06                	je     800dea <vsnprintf+0x2d>
  800de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de8:	7f 07                	jg     800df1 <vsnprintf+0x34>
		return -E_INVAL;
  800dea:	b8 03 00 00 00       	mov    $0x3,%eax
  800def:	eb 20                	jmp    800e11 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df1:	ff 75 14             	pushl  0x14(%ebp)
  800df4:	ff 75 10             	pushl  0x10(%ebp)
  800df7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dfa:	50                   	push   %eax
  800dfb:	68 87 0d 80 00       	push   $0x800d87
  800e00:	e8 92 fb ff ff       	call   800997 <vprintfmt>
  800e05:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e19:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1c:	83 c0 04             	add    $0x4,%eax
  800e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	ff 75 f4             	pushl  -0xc(%ebp)
  800e28:	50                   	push   %eax
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	ff 75 08             	pushl  0x8(%ebp)
  800e2f:	e8 89 ff ff ff       	call   800dbd <vsnprintf>
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4c:	eb 06                	jmp    800e54 <strlen+0x15>
		n++;
  800e4e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	84 c0                	test   %al,%al
  800e5b:	75 f1                	jne    800e4e <strlen+0xf>
		n++;
	return n;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6f:	eb 09                	jmp    800e7a <strnlen+0x18>
		n++;
  800e71:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	ff 4d 0c             	decl   0xc(%ebp)
  800e7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7e:	74 09                	je     800e89 <strnlen+0x27>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	84 c0                	test   %al,%al
  800e87:	75 e8                	jne    800e71 <strnlen+0xf>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9a:	90                   	nop
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ea1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eaa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ead:	8a 12                	mov    (%edx),%dl
  800eaf:	88 10                	mov    %dl,(%eax)
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	75 e4                	jne    800e9b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecf:	eb 1f                	jmp    800ef0 <strncpy+0x34>
		*dst++ = *src;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8d 50 01             	lea    0x1(%eax),%edx
  800ed7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edd:	8a 12                	mov    (%edx),%dl
  800edf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	84 c0                	test   %al,%al
  800ee8:	74 03                	je     800eed <strncpy+0x31>
			src++;
  800eea:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eed:	ff 45 fc             	incl   -0x4(%ebp)
  800ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef6:	72 d9                	jb     800ed1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0d:	74 30                	je     800f3f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0f:	eb 16                	jmp    800f27 <strlcpy+0x2a>
			*dst++ = *src++;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8d 50 01             	lea    0x1(%eax),%edx
  800f17:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f23:	8a 12                	mov    (%edx),%dl
  800f25:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f27:	ff 4d 10             	decl   0x10(%ebp)
  800f2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2e:	74 09                	je     800f39 <strlcpy+0x3c>
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	84 c0                	test   %al,%al
  800f37:	75 d8                	jne    800f11 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	29 c2                	sub    %eax,%edx
  800f47:	89 d0                	mov    %edx,%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f4e:	eb 06                	jmp    800f56 <strcmp+0xb>
		p++, q++;
  800f50:	ff 45 08             	incl   0x8(%ebp)
  800f53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	74 0e                	je     800f6d <strcmp+0x22>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 10                	mov    (%eax),%dl
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	38 c2                	cmp    %al,%dl
  800f6b:	74 e3                	je     800f50 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f86:	eb 09                	jmp    800f91 <strncmp+0xe>
		n--, p++, q++;
  800f88:	ff 4d 10             	decl   0x10(%ebp)
  800f8b:	ff 45 08             	incl   0x8(%ebp)
  800f8e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	74 17                	je     800fae <strncmp+0x2b>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strncmp+0x2b>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 da                	je     800f88 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb2:	75 07                	jne    800fbb <strncmp+0x38>
		return 0;
  800fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb9:	eb 14                	jmp    800fcf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f b6 d0             	movzbl %al,%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f b6 c0             	movzbl %al,%eax
  800fcb:	29 c2                	sub    %eax,%edx
  800fcd:	89 d0                	mov    %edx,%eax
}
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 04             	sub    $0x4,%esp
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fdd:	eb 12                	jmp    800ff1 <strchr+0x20>
		if (*s == c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe7:	75 05                	jne    800fee <strchr+0x1d>
			return (char *) s;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	eb 11                	jmp    800fff <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 e5                	jne    800fdf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100d:	eb 0d                	jmp    80101c <strfind+0x1b>
		if (*s == c)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801017:	74 0e                	je     801027 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	84 c0                	test   %al,%al
  801023:	75 ea                	jne    80100f <strfind+0xe>
  801025:	eb 01                	jmp    801028 <strfind+0x27>
		if (*s == c)
			break;
  801027:	90                   	nop
	return (char *) s;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80103f:	eb 0e                	jmp    80104f <memset+0x22>
		*p++ = c;
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8d 50 01             	lea    0x1(%eax),%edx
  801047:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80104f:	ff 4d f8             	decl   -0x8(%ebp)
  801052:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801056:	79 e9                	jns    801041 <memset+0x14>
		*p++ = c;

	return v;
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80106f:	eb 16                	jmp    801087 <memcpy+0x2a>
		*d++ = *s++;
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801080:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801083:	8a 12                	mov    (%edx),%dl
  801085:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 dd                	jne    801071 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b1:	73 50                	jae    801103 <memmove+0x6a>
  8010b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010be:	76 43                	jbe    801103 <memmove+0x6a>
		s += n;
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010cc:	eb 10                	jmp    8010de <memmove+0x45>
			*--d = *--s;
  8010ce:	ff 4d f8             	decl   -0x8(%ebp)
  8010d1:	ff 4d fc             	decl   -0x4(%ebp)
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8a 10                	mov    (%eax),%dl
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	75 e3                	jne    8010ce <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010eb:	eb 23                	jmp    801110 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	8d 50 01             	lea    0x1(%eax),%edx
  8010f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ff:	8a 12                	mov    (%edx),%dl
  801101:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	8d 50 ff             	lea    -0x1(%eax),%edx
  801109:	89 55 10             	mov    %edx,0x10(%ebp)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	75 dd                	jne    8010ed <memmove+0x54>
			*d++ = *s++;

	return dst;
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801127:	eb 2a                	jmp    801153 <memcmp+0x3e>
		if (*s1 != *s2)
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 10                	mov    (%eax),%dl
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	38 c2                	cmp    %al,%dl
  801135:	74 16                	je     80114d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f b6 d0             	movzbl %al,%edx
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 c0             	movzbl %al,%eax
  801147:	29 c2                	sub    %eax,%edx
  801149:	89 d0                	mov    %edx,%eax
  80114b:	eb 18                	jmp    801165 <memcmp+0x50>
		s1++, s2++;
  80114d:	ff 45 fc             	incl   -0x4(%ebp)
  801150:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	8d 50 ff             	lea    -0x1(%eax),%edx
  801159:	89 55 10             	mov    %edx,0x10(%ebp)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 c9                	jne    801129 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80116d:	8b 55 08             	mov    0x8(%ebp),%edx
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	01 d0                	add    %edx,%eax
  801175:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801178:	eb 15                	jmp    80118f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 d0             	movzbl %al,%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	39 c2                	cmp    %eax,%edx
  80118a:	74 0d                	je     801199 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801195:	72 e3                	jb     80117a <memfind+0x13>
  801197:	eb 01                	jmp    80119a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801199:	90                   	nop
	return (void *) s;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b3:	eb 03                	jmp    8011b8 <strtol+0x19>
		s++;
  8011b5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 20                	cmp    $0x20,%al
  8011bf:	74 f4                	je     8011b5 <strtol+0x16>
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 09                	cmp    $0x9,%al
  8011c8:	74 eb                	je     8011b5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 2b                	cmp    $0x2b,%al
  8011d1:	75 05                	jne    8011d8 <strtol+0x39>
		s++;
  8011d3:	ff 45 08             	incl   0x8(%ebp)
  8011d6:	eb 13                	jmp    8011eb <strtol+0x4c>
	else if (*s == '-')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 2d                	cmp    $0x2d,%al
  8011df:	75 0a                	jne    8011eb <strtol+0x4c>
		s++, neg = 1;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ef:	74 06                	je     8011f7 <strtol+0x58>
  8011f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011f5:	75 20                	jne    801217 <strtol+0x78>
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 30                	cmp    $0x30,%al
  8011fe:	75 17                	jne    801217 <strtol+0x78>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	40                   	inc    %eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3c 78                	cmp    $0x78,%al
  801208:	75 0d                	jne    801217 <strtol+0x78>
		s += 2, base = 16;
  80120a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80120e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801215:	eb 28                	jmp    80123f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121b:	75 15                	jne    801232 <strtol+0x93>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	3c 30                	cmp    $0x30,%al
  801224:	75 0c                	jne    801232 <strtol+0x93>
		s++, base = 8;
  801226:	ff 45 08             	incl   0x8(%ebp)
  801229:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801230:	eb 0d                	jmp    80123f <strtol+0xa0>
	else if (base == 0)
  801232:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801236:	75 07                	jne    80123f <strtol+0xa0>
		base = 10;
  801238:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 2f                	cmp    $0x2f,%al
  801246:	7e 19                	jle    801261 <strtol+0xc2>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 39                	cmp    $0x39,%al
  80124f:	7f 10                	jg     801261 <strtol+0xc2>
			dig = *s - '0';
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	0f be c0             	movsbl %al,%eax
  801259:	83 e8 30             	sub    $0x30,%eax
  80125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80125f:	eb 42                	jmp    8012a3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 60                	cmp    $0x60,%al
  801268:	7e 19                	jle    801283 <strtol+0xe4>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 7a                	cmp    $0x7a,%al
  801271:	7f 10                	jg     801283 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	83 e8 57             	sub    $0x57,%eax
  80127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801281:	eb 20                	jmp    8012a3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	3c 40                	cmp    $0x40,%al
  80128a:	7e 39                	jle    8012c5 <strtol+0x126>
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 5a                	cmp    $0x5a,%al
  801293:	7f 30                	jg     8012c5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	0f be c0             	movsbl %al,%eax
  80129d:	83 e8 37             	sub    $0x37,%eax
  8012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a9:	7d 19                	jge    8012c4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b5:	89 c2                	mov    %eax,%edx
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012bf:	e9 7b ff ff ff       	jmp    80123f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012c4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c9:	74 08                	je     8012d3 <strtol+0x134>
		*endptr = (char *) s;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d7:	74 07                	je     8012e0 <strtol+0x141>
  8012d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012dc:	f7 d8                	neg    %eax
  8012de:	eb 03                	jmp    8012e3 <strtol+0x144>
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fd:	79 13                	jns    801312 <ltostr+0x2d>
	{
		neg = 1;
  8012ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80130c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80130f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80131a:	99                   	cltd   
  80131b:	f7 f9                	idiv   %ecx
  80131d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801329:	89 c2                	mov    %eax,%edx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 d0                	add    %edx,%eax
  801330:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801333:	83 c2 30             	add    $0x30,%edx
  801336:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801338:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801340:	f7 e9                	imul   %ecx
  801342:	c1 fa 02             	sar    $0x2,%edx
  801345:	89 c8                	mov    %ecx,%eax
  801347:	c1 f8 1f             	sar    $0x1f,%eax
  80134a:	29 c2                	sub    %eax,%edx
  80134c:	89 d0                	mov    %edx,%eax
  80134e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801351:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801354:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801359:	f7 e9                	imul   %ecx
  80135b:	c1 fa 02             	sar    $0x2,%edx
  80135e:	89 c8                	mov    %ecx,%eax
  801360:	c1 f8 1f             	sar    $0x1f,%eax
  801363:	29 c2                	sub    %eax,%edx
  801365:	89 d0                	mov    %edx,%eax
  801367:	c1 e0 02             	shl    $0x2,%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	01 c0                	add    %eax,%eax
  80136e:	29 c1                	sub    %eax,%ecx
  801370:	89 ca                	mov    %ecx,%edx
  801372:	85 d2                	test   %edx,%edx
  801374:	75 9c                	jne    801312 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80137d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801380:	48                   	dec    %eax
  801381:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801384:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801388:	74 3d                	je     8013c7 <ltostr+0xe2>
		start = 1 ;
  80138a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801391:	eb 34                	jmp    8013c7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	01 c2                	add    %eax,%edx
  8013a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	01 c8                	add    %ecx,%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ba:	01 c2                	add    %eax,%edx
  8013bc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013bf:	88 02                	mov    %al,(%edx)
		start++ ;
  8013c1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013cd:	7c c4                	jl     801393 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	e8 54 fa ff ff       	call   800e3f <strlen>
  8013eb:	83 c4 04             	add    $0x4,%esp
  8013ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	e8 46 fa ff ff       	call   800e3f <strlen>
  8013f9:	83 c4 04             	add    $0x4,%esp
  8013fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140d:	eb 17                	jmp    801426 <strcconcat+0x49>
		final[s] = str1[s] ;
  80140f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 c2                	add    %eax,%edx
  801417:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	01 c8                	add    %ecx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801423:	ff 45 fc             	incl   -0x4(%ebp)
  801426:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801429:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80142c:	7c e1                	jl     80140f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80142e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801435:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80143c:	eb 1f                	jmp    80145d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80143e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801441:	8d 50 01             	lea    0x1(%eax),%edx
  801444:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801447:	89 c2                	mov    %eax,%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80145a:	ff 45 f8             	incl   -0x8(%ebp)
  80145d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801460:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801463:	7c d9                	jl     80143e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	c6 00 00             	movb   $0x0,(%eax)
}
  801470:	90                   	nop
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801476:	8b 45 14             	mov    0x14(%ebp),%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80147f:	8b 45 14             	mov    0x14(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801496:	eb 0c                	jmp    8014a4 <strsplit+0x31>
			*string++ = 0;
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8d 50 01             	lea    0x1(%eax),%edx
  80149e:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	84 c0                	test   %al,%al
  8014ab:	74 18                	je     8014c5 <strsplit+0x52>
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	0f be c0             	movsbl %al,%eax
  8014b5:	50                   	push   %eax
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	e8 13 fb ff ff       	call   800fd1 <strchr>
  8014be:	83 c4 08             	add    $0x8,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	75 d3                	jne    801498 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	84 c0                	test   %al,%al
  8014cc:	74 5a                	je     801528 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d1:	8b 00                	mov    (%eax),%eax
  8014d3:	83 f8 0f             	cmp    $0xf,%eax
  8014d6:	75 07                	jne    8014df <strsplit+0x6c>
		{
			return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	eb 66                	jmp    801545 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014ea:	89 0a                	mov    %ecx,(%edx)
  8014ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 c2                	add    %eax,%edx
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fd:	eb 03                	jmp    801502 <strsplit+0x8f>
			string++;
  8014ff:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 8b                	je     801496 <strsplit+0x23>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	0f be c0             	movsbl %al,%eax
  801513:	50                   	push   %eax
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	e8 b5 fa ff ff       	call   800fd1 <strchr>
  80151c:	83 c4 08             	add    $0x8,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 dc                	je     8014ff <strsplit+0x8c>
			string++;
	}
  801523:	e9 6e ff ff ff       	jmp    801496 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801528:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	8b 00                	mov    (%eax),%eax
  80152e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801535:	8b 45 10             	mov    0x10(%ebp),%eax
  801538:	01 d0                	add    %edx,%eax
  80153a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801540:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80154d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801554:	eb 4c                	jmp    8015a2 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801556:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	01 d0                	add    %edx,%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	3c 40                	cmp    $0x40,%al
  801562:	7e 27                	jle    80158b <str2lower+0x44>
  801564:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	01 d0                	add    %edx,%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	3c 5a                	cmp    $0x5a,%al
  801570:	7f 19                	jg     80158b <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801572:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	01 d0                	add    %edx,%eax
  80157a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	01 ca                	add    %ecx,%edx
  801582:	8a 12                	mov    (%edx),%dl
  801584:	83 c2 20             	add    $0x20,%edx
  801587:	88 10                	mov    %dl,(%eax)
  801589:	eb 14                	jmp    80159f <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80158b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	01 c2                	add    %eax,%edx
  801593:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 c8                	add    %ecx,%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80159f:	ff 45 fc             	incl   -0x4(%ebp)
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	e8 95 f8 ff ff       	call   800e3f <strlen>
  8015aa:	83 c4 04             	add    $0x4,%esp
  8015ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b0:	7f a4                	jg     801556 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8015b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	57                   	push   %edi
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015da:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015dd:	cd 30                	int    $0x30
  8015df:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	52                   	push   %edx
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	50                   	push   %eax
  801609:	6a 00                	push   $0x0
  80160b:	e8 b2 ff ff ff       	call   8015c2 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_cgetc>:

int
sys_cgetc(void)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 01                	push   $0x1
  801625:	e8 98 ff ff ff       	call   8015c2 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 05                	push   $0x5
  801642:	e8 7b ff ff ff       	call   8015c2 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801651:	8b 75 18             	mov    0x18(%ebp),%esi
  801654:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801657:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
  801662:	51                   	push   %ecx
  801663:	52                   	push   %edx
  801664:	50                   	push   %eax
  801665:	6a 06                	push   $0x6
  801667:	e8 56 ff ff ff       	call   8015c2 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801672:	5b                   	pop    %ebx
  801673:	5e                   	pop    %esi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	52                   	push   %edx
  801686:	50                   	push   %eax
  801687:	6a 07                	push   $0x7
  801689:	e8 34 ff ff ff       	call   8015c2 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	6a 08                	push   $0x8
  8016a4:	e8 19 ff ff ff       	call   8015c2 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 09                	push   $0x9
  8016bd:	e8 00 ff ff ff       	call   8015c2 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 0a                	push   $0xa
  8016d6:	e8 e7 fe ff ff       	call   8015c2 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 0b                	push   $0xb
  8016ef:	e8 ce fe ff ff       	call   8015c2 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 0c                	push   $0xc
  801708:	e8 b5 fe ff ff       	call   8015c2 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	6a 0d                	push   $0xd
  801722:	e8 9b fe ff ff       	call   8015c2 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 0e                	push   $0xe
  80173b:	e8 82 fe ff ff       	call   8015c2 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	90                   	nop
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 11                	push   $0x11
  801755:	e8 68 fe ff ff       	call   8015c2 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	90                   	nop
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 12                	push   $0x12
  80176f:	e8 4e fe ff ff       	call   8015c2 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	90                   	nop
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_cputc>:


void
sys_cputc(const char c)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801786:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	50                   	push   %eax
  801793:	6a 13                	push   $0x13
  801795:	e8 28 fe ff ff       	call   8015c2 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	90                   	nop
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 14                	push   $0x14
  8017af:	e8 0e fe ff ff       	call   8015c2 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	50                   	push   %eax
  8017ca:	6a 15                	push   $0x15
  8017cc:	e8 f1 fd ff ff       	call   8015c2 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 18                	push   $0x18
  8017e9:	e8 d4 fd ff ff       	call   8015c2 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	52                   	push   %edx
  801803:	50                   	push   %eax
  801804:	6a 16                	push   $0x16
  801806:	e8 b7 fd ff ff       	call   8015c2 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	90                   	nop
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 17                	push   $0x17
  801824:	e8 99 fd ff ff       	call   8015c2 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80183b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80183e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	51                   	push   %ecx
  801848:	52                   	push   %edx
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	50                   	push   %eax
  80184d:	6a 19                	push   $0x19
  80184f:	e8 6e fd ff ff       	call   8015c2 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 1a                	push   $0x1a
  80186c:	e8 51 fd ff ff       	call   8015c2 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801879:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	51                   	push   %ecx
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 1b                	push   $0x1b
  80188b:	e8 32 fd ff ff       	call   8015c2 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	50                   	push   %eax
  8018a6:	6a 1c                	push   $0x1c
  8018a8:	e8 15 fd ff ff       	call   8015c2 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 1d                	push   $0x1d
  8018c1:	e8 fc fc ff ff       	call   8015c2 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 14             	pushl  0x14(%ebp)
  8018d6:	ff 75 10             	pushl  0x10(%ebp)
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	6a 1e                	push   $0x1e
  8018df:	e8 de fc ff ff       	call   8015c2 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	50                   	push   %eax
  8018f8:	6a 1f                	push   $0x1f
  8018fa:	e8 c3 fc ff ff       	call   8015c2 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	50                   	push   %eax
  801914:	6a 20                	push   $0x20
  801916:	e8 a7 fc ff ff       	call   8015c2 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 02                	push   $0x2
  80192f:	e8 8e fc ff ff       	call   8015c2 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 03                	push   $0x3
  801948:	e8 75 fc ff ff       	call   8015c2 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 04                	push   $0x4
  801961:	e8 5c fc ff ff       	call   8015c2 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_exit_env>:


void sys_exit_env(void)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 21                	push   $0x21
  80197a:	e8 43 fc ff ff       	call   8015c2 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	90                   	nop
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80198e:	8d 50 04             	lea    0x4(%eax),%edx
  801991:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 22                	push   $0x22
  80199e:	e8 1f fc ff ff       	call   8015c2 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019af:	89 01                	mov    %eax,(%ecx)
  8019b1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	c9                   	leave  
  8019b8:	c2 04 00             	ret    $0x4

008019bb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 10             	pushl  0x10(%ebp)
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	6a 10                	push   $0x10
  8019cd:	e8 f0 fb ff ff       	call   8015c2 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d5:	90                   	nop
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 23                	push   $0x23
  8019e7:	e8 d6 fb ff ff       	call   8015c2 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019fd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	50                   	push   %eax
  801a0a:	6a 24                	push   $0x24
  801a0c:	e8 b1 fb ff ff       	call   8015c2 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
	return ;
  801a14:	90                   	nop
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <rsttst>:
void rsttst()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 26                	push   $0x26
  801a26:	e8 97 fb ff ff       	call   8015c2 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2e:	90                   	nop
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3d:	8b 55 18             	mov    0x18(%ebp),%edx
  801a40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	ff 75 10             	pushl  0x10(%ebp)
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	6a 25                	push   $0x25
  801a51:	e8 6c fb ff ff       	call   8015c2 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
	return ;
  801a59:	90                   	nop
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <chktst>:
void chktst(uint32 n)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 08             	pushl  0x8(%ebp)
  801a6a:	6a 27                	push   $0x27
  801a6c:	e8 51 fb ff ff       	call   8015c2 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
	return ;
  801a74:	90                   	nop
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <inctst>:

void inctst()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 28                	push   $0x28
  801a86:	e8 37 fb ff ff       	call   8015c2 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <gettst>:
uint32 gettst()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 29                	push   $0x29
  801aa0:	e8 1d fb ff ff       	call   8015c2 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 2a                	push   $0x2a
  801abc:	e8 01 fb ff ff       	call   8015c2 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
  801ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ac7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801acb:	75 07                	jne    801ad4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801acd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad2:	eb 05                	jmp    801ad9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 2a                	push   $0x2a
  801aed:	e8 d0 fa ff ff       	call   8015c2 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
  801af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801af8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801afc:	75 07                	jne    801b05 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801afe:	b8 01 00 00 00       	mov    $0x1,%eax
  801b03:	eb 05                	jmp    801b0a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 2a                	push   $0x2a
  801b1e:	e8 9f fa ff ff       	call   8015c2 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
  801b26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b29:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b2d:	75 07                	jne    801b36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b34:	eb 05                	jmp    801b3b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 2a                	push   $0x2a
  801b4f:	e8 6e fa ff ff       	call   8015c2 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
  801b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b5a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b5e:	75 07                	jne    801b67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b60:	b8 01 00 00 00       	mov    $0x1,%eax
  801b65:	eb 05                	jmp    801b6c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 2b                	push   $0x2b
  801b7e:	e8 3f fa ff ff       	call   8015c2 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
	return ;
  801b86:	90                   	nop
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	53                   	push   %ebx
  801b9c:	51                   	push   %ecx
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 2c                	push   $0x2c
  801ba1:	e8 1c fa ff ff       	call   8015c2 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 2d                	push   $0x2d
  801bc1:	e8 fc f9 ff ff       	call   8015c2 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	51                   	push   %ecx
  801bda:	ff 75 10             	pushl  0x10(%ebp)
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 2e                	push   $0x2e
  801be1:	e8 dc f9 ff ff       	call   8015c2 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 10             	pushl  0x10(%ebp)
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 0f                	push   $0xf
  801bfd:	e8 c0 f9 ff ff       	call   8015c2 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return ;
  801c05:	90                   	nop
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	50                   	push   %eax
  801c17:	6a 2f                	push   $0x2f
  801c19:	e8 a4 f9 ff ff       	call   8015c2 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp

}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 30                	push   $0x30
  801c34:	e8 89 f9 ff ff       	call   8015c2 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp

}
  801c3c:	90                   	nop
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	6a 31                	push   $0x31
  801c50:	e8 6d f9 ff ff       	call   8015c2 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp

}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_hard_limit>:
uint32 sys_hard_limit(){
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 32                	push   $0x32
  801c6a:	e8 53 f9 ff ff       	call   8015c2 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <__udivdi3>:
  801c74:	55                   	push   %ebp
  801c75:	57                   	push   %edi
  801c76:	56                   	push   %esi
  801c77:	53                   	push   %ebx
  801c78:	83 ec 1c             	sub    $0x1c,%esp
  801c7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c8b:	89 ca                	mov    %ecx,%edx
  801c8d:	89 f8                	mov    %edi,%eax
  801c8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c93:	85 f6                	test   %esi,%esi
  801c95:	75 2d                	jne    801cc4 <__udivdi3+0x50>
  801c97:	39 cf                	cmp    %ecx,%edi
  801c99:	77 65                	ja     801d00 <__udivdi3+0x8c>
  801c9b:	89 fd                	mov    %edi,%ebp
  801c9d:	85 ff                	test   %edi,%edi
  801c9f:	75 0b                	jne    801cac <__udivdi3+0x38>
  801ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca6:	31 d2                	xor    %edx,%edx
  801ca8:	f7 f7                	div    %edi
  801caa:	89 c5                	mov    %eax,%ebp
  801cac:	31 d2                	xor    %edx,%edx
  801cae:	89 c8                	mov    %ecx,%eax
  801cb0:	f7 f5                	div    %ebp
  801cb2:	89 c1                	mov    %eax,%ecx
  801cb4:	89 d8                	mov    %ebx,%eax
  801cb6:	f7 f5                	div    %ebp
  801cb8:	89 cf                	mov    %ecx,%edi
  801cba:	89 fa                	mov    %edi,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	39 ce                	cmp    %ecx,%esi
  801cc6:	77 28                	ja     801cf0 <__udivdi3+0x7c>
  801cc8:	0f bd fe             	bsr    %esi,%edi
  801ccb:	83 f7 1f             	xor    $0x1f,%edi
  801cce:	75 40                	jne    801d10 <__udivdi3+0x9c>
  801cd0:	39 ce                	cmp    %ecx,%esi
  801cd2:	72 0a                	jb     801cde <__udivdi3+0x6a>
  801cd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cd8:	0f 87 9e 00 00 00    	ja     801d7c <__udivdi3+0x108>
  801cde:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce3:	89 fa                	mov    %edi,%edx
  801ce5:	83 c4 1c             	add    $0x1c,%esp
  801ce8:	5b                   	pop    %ebx
  801ce9:	5e                   	pop    %esi
  801cea:	5f                   	pop    %edi
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    
  801ced:	8d 76 00             	lea    0x0(%esi),%esi
  801cf0:	31 ff                	xor    %edi,%edi
  801cf2:	31 c0                	xor    %eax,%eax
  801cf4:	89 fa                	mov    %edi,%edx
  801cf6:	83 c4 1c             	add    $0x1c,%esp
  801cf9:	5b                   	pop    %ebx
  801cfa:	5e                   	pop    %esi
  801cfb:	5f                   	pop    %edi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	f7 f7                	div    %edi
  801d04:	31 ff                	xor    %edi,%edi
  801d06:	89 fa                	mov    %edi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d15:	89 eb                	mov    %ebp,%ebx
  801d17:	29 fb                	sub    %edi,%ebx
  801d19:	89 f9                	mov    %edi,%ecx
  801d1b:	d3 e6                	shl    %cl,%esi
  801d1d:	89 c5                	mov    %eax,%ebp
  801d1f:	88 d9                	mov    %bl,%cl
  801d21:	d3 ed                	shr    %cl,%ebp
  801d23:	89 e9                	mov    %ebp,%ecx
  801d25:	09 f1                	or     %esi,%ecx
  801d27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e0                	shl    %cl,%eax
  801d2f:	89 c5                	mov    %eax,%ebp
  801d31:	89 d6                	mov    %edx,%esi
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 ee                	shr    %cl,%esi
  801d37:	89 f9                	mov    %edi,%ecx
  801d39:	d3 e2                	shl    %cl,%edx
  801d3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3f:	88 d9                	mov    %bl,%cl
  801d41:	d3 e8                	shr    %cl,%eax
  801d43:	09 c2                	or     %eax,%edx
  801d45:	89 d0                	mov    %edx,%eax
  801d47:	89 f2                	mov    %esi,%edx
  801d49:	f7 74 24 0c          	divl   0xc(%esp)
  801d4d:	89 d6                	mov    %edx,%esi
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	f7 e5                	mul    %ebp
  801d53:	39 d6                	cmp    %edx,%esi
  801d55:	72 19                	jb     801d70 <__udivdi3+0xfc>
  801d57:	74 0b                	je     801d64 <__udivdi3+0xf0>
  801d59:	89 d8                	mov    %ebx,%eax
  801d5b:	31 ff                	xor    %edi,%edi
  801d5d:	e9 58 ff ff ff       	jmp    801cba <__udivdi3+0x46>
  801d62:	66 90                	xchg   %ax,%ax
  801d64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d68:	89 f9                	mov    %edi,%ecx
  801d6a:	d3 e2                	shl    %cl,%edx
  801d6c:	39 c2                	cmp    %eax,%edx
  801d6e:	73 e9                	jae    801d59 <__udivdi3+0xe5>
  801d70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d73:	31 ff                	xor    %edi,%edi
  801d75:	e9 40 ff ff ff       	jmp    801cba <__udivdi3+0x46>
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	31 c0                	xor    %eax,%eax
  801d7e:	e9 37 ff ff ff       	jmp    801cba <__udivdi3+0x46>
  801d83:	90                   	nop

00801d84 <__umoddi3>:
  801d84:	55                   	push   %ebp
  801d85:	57                   	push   %edi
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	83 ec 1c             	sub    $0x1c,%esp
  801d8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801da3:	89 f3                	mov    %esi,%ebx
  801da5:	89 fa                	mov    %edi,%edx
  801da7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dab:	89 34 24             	mov    %esi,(%esp)
  801dae:	85 c0                	test   %eax,%eax
  801db0:	75 1a                	jne    801dcc <__umoddi3+0x48>
  801db2:	39 f7                	cmp    %esi,%edi
  801db4:	0f 86 a2 00 00 00    	jbe    801e5c <__umoddi3+0xd8>
  801dba:	89 c8                	mov    %ecx,%eax
  801dbc:	89 f2                	mov    %esi,%edx
  801dbe:	f7 f7                	div    %edi
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	31 d2                	xor    %edx,%edx
  801dc4:	83 c4 1c             	add    $0x1c,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    
  801dcc:	39 f0                	cmp    %esi,%eax
  801dce:	0f 87 ac 00 00 00    	ja     801e80 <__umoddi3+0xfc>
  801dd4:	0f bd e8             	bsr    %eax,%ebp
  801dd7:	83 f5 1f             	xor    $0x1f,%ebp
  801dda:	0f 84 ac 00 00 00    	je     801e8c <__umoddi3+0x108>
  801de0:	bf 20 00 00 00       	mov    $0x20,%edi
  801de5:	29 ef                	sub    %ebp,%edi
  801de7:	89 fe                	mov    %edi,%esi
  801de9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 e0                	shl    %cl,%eax
  801df1:	89 d7                	mov    %edx,%edi
  801df3:	89 f1                	mov    %esi,%ecx
  801df5:	d3 ef                	shr    %cl,%edi
  801df7:	09 c7                	or     %eax,%edi
  801df9:	89 e9                	mov    %ebp,%ecx
  801dfb:	d3 e2                	shl    %cl,%edx
  801dfd:	89 14 24             	mov    %edx,(%esp)
  801e00:	89 d8                	mov    %ebx,%eax
  801e02:	d3 e0                	shl    %cl,%eax
  801e04:	89 c2                	mov    %eax,%edx
  801e06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e0a:	d3 e0                	shl    %cl,%eax
  801e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e14:	89 f1                	mov    %esi,%ecx
  801e16:	d3 e8                	shr    %cl,%eax
  801e18:	09 d0                	or     %edx,%eax
  801e1a:	d3 eb                	shr    %cl,%ebx
  801e1c:	89 da                	mov    %ebx,%edx
  801e1e:	f7 f7                	div    %edi
  801e20:	89 d3                	mov    %edx,%ebx
  801e22:	f7 24 24             	mull   (%esp)
  801e25:	89 c6                	mov    %eax,%esi
  801e27:	89 d1                	mov    %edx,%ecx
  801e29:	39 d3                	cmp    %edx,%ebx
  801e2b:	0f 82 87 00 00 00    	jb     801eb8 <__umoddi3+0x134>
  801e31:	0f 84 91 00 00 00    	je     801ec8 <__umoddi3+0x144>
  801e37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e3b:	29 f2                	sub    %esi,%edx
  801e3d:	19 cb                	sbb    %ecx,%ebx
  801e3f:	89 d8                	mov    %ebx,%eax
  801e41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e45:	d3 e0                	shl    %cl,%eax
  801e47:	89 e9                	mov    %ebp,%ecx
  801e49:	d3 ea                	shr    %cl,%edx
  801e4b:	09 d0                	or     %edx,%eax
  801e4d:	89 e9                	mov    %ebp,%ecx
  801e4f:	d3 eb                	shr    %cl,%ebx
  801e51:	89 da                	mov    %ebx,%edx
  801e53:	83 c4 1c             	add    $0x1c,%esp
  801e56:	5b                   	pop    %ebx
  801e57:	5e                   	pop    %esi
  801e58:	5f                   	pop    %edi
  801e59:	5d                   	pop    %ebp
  801e5a:	c3                   	ret    
  801e5b:	90                   	nop
  801e5c:	89 fd                	mov    %edi,%ebp
  801e5e:	85 ff                	test   %edi,%edi
  801e60:	75 0b                	jne    801e6d <__umoddi3+0xe9>
  801e62:	b8 01 00 00 00       	mov    $0x1,%eax
  801e67:	31 d2                	xor    %edx,%edx
  801e69:	f7 f7                	div    %edi
  801e6b:	89 c5                	mov    %eax,%ebp
  801e6d:	89 f0                	mov    %esi,%eax
  801e6f:	31 d2                	xor    %edx,%edx
  801e71:	f7 f5                	div    %ebp
  801e73:	89 c8                	mov    %ecx,%eax
  801e75:	f7 f5                	div    %ebp
  801e77:	89 d0                	mov    %edx,%eax
  801e79:	e9 44 ff ff ff       	jmp    801dc2 <__umoddi3+0x3e>
  801e7e:	66 90                	xchg   %ax,%ax
  801e80:	89 c8                	mov    %ecx,%eax
  801e82:	89 f2                	mov    %esi,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	3b 04 24             	cmp    (%esp),%eax
  801e8f:	72 06                	jb     801e97 <__umoddi3+0x113>
  801e91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e95:	77 0f                	ja     801ea6 <__umoddi3+0x122>
  801e97:	89 f2                	mov    %esi,%edx
  801e99:	29 f9                	sub    %edi,%ecx
  801e9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e9f:	89 14 24             	mov    %edx,(%esp)
  801ea2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ea6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801eaa:	8b 14 24             	mov    (%esp),%edx
  801ead:	83 c4 1c             	add    $0x1c,%esp
  801eb0:	5b                   	pop    %ebx
  801eb1:	5e                   	pop    %esi
  801eb2:	5f                   	pop    %edi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    
  801eb5:	8d 76 00             	lea    0x0(%esi),%esi
  801eb8:	2b 04 24             	sub    (%esp),%eax
  801ebb:	19 fa                	sbb    %edi,%edx
  801ebd:	89 d1                	mov    %edx,%ecx
  801ebf:	89 c6                	mov    %eax,%esi
  801ec1:	e9 71 ff ff ff       	jmp    801e37 <__umoddi3+0xb3>
  801ec6:	66 90                	xchg   %ax,%ax
  801ec8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ecc:	72 ea                	jb     801eb8 <__umoddi3+0x134>
  801ece:	89 d9                	mov    %ebx,%ecx
  801ed0:	e9 62 ff ff ff       	jmp    801e37 <__umoddi3+0xb3>
