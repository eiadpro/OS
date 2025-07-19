
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 86 03 00 00       	call   8003bc <libmain>
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

	uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  800043:	8d 95 9c ff ff fe    	lea    -0x1000064(%ebp),%edx
  800049:	b9 0d 00 00 00       	mov    $0xd,%ecx
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	89 d7                	mov    %edx,%edi
  800055:	f3 ab                	rep stos %eax,%es:(%edi)
  800057:	c7 85 9c ff ff fe 00 	movl   $0xedbfd000,-0x1000064(%ebp)
  80005e:	d0 bf ed 
  800061:	c7 85 a0 ff ff fe 00 	movl   $0xeebfd000,-0x1000060(%ebp)
  800068:	d0 bf ee 
  80006b:	c7 85 a4 ff ff fe 00 	movl   $0x803000,-0x100005c(%ebp)
  800072:	30 80 00 
  800075:	c7 85 a8 ff ff fe 00 	movl   $0x802000,-0x1000058(%ebp)
  80007c:	20 80 00 
  80007f:	c7 85 ac ff ff fe 00 	movl   $0x801000,-0x1000054(%ebp)
  800086:	10 80 00 
  800089:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800090:	00 80 00 
  800093:	c7 85 b4 ff ff fe 00 	movl   $0x205000,-0x100004c(%ebp)
  80009a:	50 20 00 
  80009d:	c7 85 b8 ff ff fe 00 	movl   $0x204000,-0x1000048(%ebp)
  8000a4:	40 20 00 
  8000a7:	c7 85 bc ff ff fe 00 	movl   $0x203000,-0x1000044(%ebp)
  8000ae:	30 20 00 
  8000b1:	c7 85 c0 ff ff fe 00 	movl   $0x202000,-0x1000040(%ebp)
  8000b8:	20 20 00 
  8000bb:	c7 85 c4 ff ff fe 00 	movl   $0x201000,-0x100003c(%ebp)
  8000c2:	10 20 00 
  8000c5:	c7 85 c8 ff ff fe 00 	movl   $0x200000,-0x1000038(%ebp)
  8000cc:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000cf:	8d 95 80 ff ff fe    	lea    -0x1000080(%ebp),%edx
  8000d5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000da:	b8 00 00 00 00       	mov    $0x0,%eax
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	6a 0c                	push   $0xc
  8000e7:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  8000ed:	50                   	push   %eax
  8000ee:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	e8 82 1a 00 00       	call   801b7c <sys_check_LRU_lists>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(check == 0)
  800100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800104:	75 14                	jne    80011a <_main+0xe2>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 e0 1e 80 00       	push   $0x801ee0
  80010e:	6a 15                	push   $0x15
  800110:	68 62 1f 80 00       	push   $0x801f62
  800115:	e8 d9 03 00 00       	call   8004f3 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011a:	e8 cd 15 00 00       	call   8016ec <sys_pf_calculate_allocated_pages>
  80011f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int freePages = sys_calculate_free_frames();
  800122:	e8 7a 15 00 00       	call   8016a1 <sys_calculate_free_frames>
  800127:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = -1;
  800133:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800141:	ff 45 f4             	incl   -0xc(%ebp)
  800144:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80014b:	7e e6                	jle    800133 <_main+0xfb>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  80014d:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800154:	eb 11                	jmp    800167 <_main+0x12f>
	{
		arr[i] = -1;
  800156:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  80015c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800164:	ff 45 f4             	incl   -0xc(%ebp)
  800167:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80016e:	7e e6                	jle    800156 <_main+0x11e>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800170:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800177:	eb 11                	jmp    80018a <_main+0x152>
	{
		arr[i] = -1;
  800179:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  80017f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800187:	ff 45 f4             	incl   -0xc(%ebp)
  80018a:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800191:	7e e6                	jle    800179 <_main+0x141>
	{
		arr[i] = -1;
	}

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 7c 1f 80 00       	push   $0x801f7c
  80019b:	e8 10 06 00 00       	call   8007b0 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8001a3:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  8001a9:	3c ff                	cmp    $0xff,%al
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 ac 1f 80 00       	push   $0x801fac
  8001b5:	6a 30                	push   $0x30
  8001b7:	68 62 1f 80 00       	push   $0x801f62
  8001bc:	e8 32 03 00 00       	call   8004f3 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001c1:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001c7:	3c ff                	cmp    $0xff,%al
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 ac 1f 80 00       	push   $0x801fac
  8001d3:	6a 31                	push   $0x31
  8001d5:	68 62 1f 80 00       	push   $0x801f62
  8001da:	e8 14 03 00 00       	call   8004f3 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001df:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 14                	je     8001fd <_main+0x1c5>
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	68 ac 1f 80 00       	push   $0x801fac
  8001f1:	6a 33                	push   $0x33
  8001f3:	68 62 1f 80 00       	push   $0x801f62
  8001f8:	e8 f6 02 00 00       	call   8004f3 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001fd:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  800203:	3c ff                	cmp    $0xff,%al
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 ac 1f 80 00       	push   $0x801fac
  80020f:	6a 34                	push   $0x34
  800211:	68 62 1f 80 00       	push   $0x801f62
  800216:	e8 d8 02 00 00       	call   8004f3 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80021b:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  800221:	3c ff                	cmp    $0xff,%al
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 ac 1f 80 00       	push   $0x801fac
  80022d:	6a 36                	push   $0x36
  80022f:	68 62 1f 80 00       	push   $0x801f62
  800234:	e8 ba 02 00 00       	call   8004f3 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800239:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  80023f:	3c ff                	cmp    $0xff,%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 ac 1f 80 00       	push   $0x801fac
  80024b:	6a 37                	push   $0x37
  80024d:	68 62 1f 80 00       	push   $0x801f62
  800252:	e8 9c 02 00 00       	call   8004f3 <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages should NOT written to Page File until it's replaced");
  800257:	e8 90 14 00 00       	call   8016ec <sys_pf_calculate_allocated_pages>
  80025c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80025f:	74 14                	je     800275 <_main+0x23d>
  800261:	83 ec 04             	sub    $0x4,%esp
  800264:	68 cc 1f 80 00       	push   $0x801fcc
  800269:	6a 3a                	push   $0x3a
  80026b:	68 62 1f 80 00       	push   $0x801f62
  800270:	e8 7e 02 00 00       	call   8004f3 <_panic>

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800275:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80027c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80027f:	e8 1d 14 00 00       	call   8016a1 <sys_calculate_free_frames>
  800284:	29 c3                	sub    %eax,%ebx
  800286:	89 d8                	mov    %ebx,%eax
  800288:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
  80028b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800291:	74 1a                	je     8002ad <_main+0x275>
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	ff 75 d4             	pushl  -0x2c(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	68 10 20 80 00       	push   $0x802010
  8002a1:	6a 3f                	push   $0x3f
  8002a3:	68 62 1f 80 00       	push   $0x801f62
  8002a8:	e8 46 02 00 00       	call   8004f3 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 4c 20 80 00       	push   $0x80204c
  8002b5:	e8 f6 04 00 00       	call   8007b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	int j=0;
  8002bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002c4:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
  8002cb:	eb 1f                	jmp    8002ec <_main+0x2b4>
		actual_second_list[i]=actual_active_list[11-j];
  8002cd:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002d2:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8002d5:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  8002dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002df:	89 94 85 80 ff ff fe 	mov    %edx,-0x1000080(%ebp,%eax,4)
		if(actual != expected) panic("allocated memory size incorrect. Expected = %d, Actual = %d", expected, actual);
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
  8002e6:	ff 4d ec             	decl   -0x14(%ebp)
  8002e9:	ff 45 f0             	incl   -0x10(%ebp)
  8002ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002f0:	79 db                	jns    8002cd <_main+0x295>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  8002f2:	c7 45 e8 0c 00 00 00 	movl   $0xc,-0x18(%ebp)
  8002f9:	eb 1a                	jmp    800315 <_main+0x2dd>
		actual_active_list[i]=actual_active_list[i-5];
  8002fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fe:	83 e8 05             	sub    $0x5,%eax
  800301:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  800308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80030b:	89 94 85 9c ff ff fe 	mov    %edx,-0x1000064(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800312:	ff 4d e8             	decl   -0x18(%ebp)
  800315:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800319:	7f e0                	jg     8002fb <_main+0x2c3>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  80031b:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  800322:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800325:	c7 85 a0 ff ff fe 00 	movl   $0xee3fd000,-0x1000060(%ebp)
  80032c:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  80032f:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  800336:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800339:	c7 85 a8 ff ff fe 00 	movl   $0xedffd000,-0x1000058(%ebp)
  800340:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800343:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  80034a:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	68 80 20 80 00       	push   $0x802080
  800355:	e8 56 04 00 00       	call   8007b0 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  80035d:	6a 04                	push   $0x4
  80035f:	6a 0d                	push   $0xd
  800361:	8d 85 80 ff ff fe    	lea    -0x1000080(%ebp),%eax
  800367:	50                   	push   %eax
  800368:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  80036e:	50                   	push   %eax
  80036f:	e8 08 18 00 00       	call   801b7c <sys_check_LRU_lists>
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if(check == 0)
  80037a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80037e:	75 14                	jne    800394 <_main+0x35c>
			panic("LRU lists entries are not correct, check your logic again!!");
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	68 a8 20 80 00       	push   $0x8020a8
  800388:	6a 52                	push   $0x52
  80038a:	68 62 1f 80 00       	push   $0x801f62
  80038f:	e8 5f 01 00 00       	call   8004f3 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 e4 20 80 00       	push   $0x8020e4
  80039c:	e8 0f 04 00 00       	call   8007b0 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed successfully!!\n\n\n");
  8003a4:	83 ec 0c             	sub    $0xc,%esp
  8003a7:	68 1c 21 80 00       	push   $0x80211c
  8003ac:	e8 ff 03 00 00       	call   8007b0 <cprintf>
  8003b1:	83 c4 10             	add    $0x10,%esp
	return;
  8003b4:	90                   	nop
}
  8003b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5f                   	pop    %edi
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003c2:	e8 65 15 00 00       	call   80192c <sys_getenvindex>
  8003c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cd:	89 d0                	mov    %edx,%eax
  8003cf:	c1 e0 03             	shl    $0x3,%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	01 d0                	add    %edx,%eax
  8003e1:	c1 e0 04             	shl    $0x4,%eax
  8003e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	8a 40 5c             	mov    0x5c(%eax),%al
  8003f6:	84 c0                	test   %al,%al
  8003f8:	74 0d                	je     800407 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	83 c0 5c             	add    $0x5c,%eax
  800402:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040b:	7e 0a                	jle    800417 <libmain+0x5b>
		binaryname = argv[0];
  80040d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	ff 75 08             	pushl  0x8(%ebp)
  800420:	e8 13 fc ff ff       	call   800038 <_main>
  800425:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800428:	e8 0c 13 00 00       	call   801739 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	68 8c 21 80 00       	push   $0x80218c
  800435:	e8 76 03 00 00       	call   8007b0 <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043d:	a1 20 30 80 00       	mov    0x803020,%eax
  800442:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800448:	a1 20 30 80 00       	mov    0x803020,%eax
  80044d:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800453:	83 ec 04             	sub    $0x4,%esp
  800456:	52                   	push   %edx
  800457:	50                   	push   %eax
  800458:	68 b4 21 80 00       	push   $0x8021b4
  80045d:	e8 4e 03 00 00       	call   8007b0 <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800465:	a1 20 30 80 00       	mov    0x803020,%eax
  80046a:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800470:	a1 20 30 80 00       	mov    0x803020,%eax
  800475:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80047b:	a1 20 30 80 00       	mov    0x803020,%eax
  800480:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800486:	51                   	push   %ecx
  800487:	52                   	push   %edx
  800488:	50                   	push   %eax
  800489:	68 dc 21 80 00       	push   $0x8021dc
  80048e:	e8 1d 03 00 00       	call   8007b0 <cprintf>
  800493:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800496:	a1 20 30 80 00       	mov    0x803020,%eax
  80049b:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	50                   	push   %eax
  8004a5:	68 34 22 80 00       	push   $0x802234
  8004aa:	e8 01 03 00 00       	call   8007b0 <cprintf>
  8004af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	68 8c 21 80 00       	push   $0x80218c
  8004ba:	e8 f1 02 00 00       	call   8007b0 <cprintf>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c2:	e8 8c 12 00 00       	call   801753 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c7:	e8 19 00 00 00       	call   8004e5 <exit>
}
  8004cc:	90                   	nop
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d5:	83 ec 0c             	sub    $0xc,%esp
  8004d8:	6a 00                	push   $0x0
  8004da:	e8 19 14 00 00       	call   8018f8 <sys_destroy_env>
  8004df:	83 c4 10             	add    $0x10,%esp
}
  8004e2:	90                   	nop
  8004e3:	c9                   	leave  
  8004e4:	c3                   	ret    

008004e5 <exit>:

void
exit(void)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004eb:	e8 6e 14 00 00       	call   80195e <sys_exit_env>
}
  8004f0:	90                   	nop
  8004f1:	c9                   	leave  
  8004f2:	c3                   	ret    

008004f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fc:	83 c0 04             	add    $0x4,%eax
  8004ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800502:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800507:	85 c0                	test   %eax,%eax
  800509:	74 16                	je     800521 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050b:	a1 2c 31 80 00       	mov    0x80312c,%eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	50                   	push   %eax
  800514:	68 48 22 80 00       	push   $0x802248
  800519:	e8 92 02 00 00       	call   8007b0 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800521:	a1 00 30 80 00       	mov    0x803000,%eax
  800526:	ff 75 0c             	pushl  0xc(%ebp)
  800529:	ff 75 08             	pushl  0x8(%ebp)
  80052c:	50                   	push   %eax
  80052d:	68 4d 22 80 00       	push   $0x80224d
  800532:	e8 79 02 00 00       	call   8007b0 <cprintf>
  800537:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80053a:	8b 45 10             	mov    0x10(%ebp),%eax
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 f4             	pushl  -0xc(%ebp)
  800543:	50                   	push   %eax
  800544:	e8 fc 01 00 00       	call   800745 <vcprintf>
  800549:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	6a 00                	push   $0x0
  800551:	68 69 22 80 00       	push   $0x802269
  800556:	e8 ea 01 00 00       	call   800745 <vcprintf>
  80055b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055e:	e8 82 ff ff ff       	call   8004e5 <exit>

	// should not return here
	while (1) ;
  800563:	eb fe                	jmp    800563 <_panic+0x70>

00800565 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056b:	a1 20 30 80 00       	mov    0x803020,%eax
  800570:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 6c 22 80 00       	push   $0x80226c
  800585:	6a 26                	push   $0x26
  800587:	68 b8 22 80 00       	push   $0x8022b8
  80058c:	e8 62 ff ff ff       	call   8004f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059f:	e9 c5 00 00 00       	jmp    800669 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	85 c0                	test   %eax,%eax
  8005b7:	75 08                	jne    8005c1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005b9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005bc:	e9 a5 00 00 00       	jmp    800666 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cf:	eb 69                	jmp    80063a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8a 40 04             	mov    0x4(%eax),%al
  8005ed:	84 c0                	test   %al,%al
  8005ef:	75 46                	jne    800637 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ff:	89 d0                	mov    %edx,%eax
  800601:	01 c0                	add    %eax,%eax
  800603:	01 d0                	add    %edx,%eax
  800605:	c1 e0 03             	shl    $0x3,%eax
  800608:	01 c8                	add    %ecx,%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800612:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800617:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	75 09                	jne    800637 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80062e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800635:	eb 15                	jmp    80064c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800637:	ff 45 e8             	incl   -0x18(%ebp)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800648:	39 c2                	cmp    %eax,%edx
  80064a:	77 85                	ja     8005d1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80064c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800650:	75 14                	jne    800666 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800652:	83 ec 04             	sub    $0x4,%esp
  800655:	68 c4 22 80 00       	push   $0x8022c4
  80065a:	6a 3a                	push   $0x3a
  80065c:	68 b8 22 80 00       	push   $0x8022b8
  800661:	e8 8d fe ff ff       	call   8004f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800666:	ff 45 f0             	incl   -0x10(%ebp)
  800669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80066f:	0f 8c 2f ff ff ff    	jl     8005a4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800683:	eb 26                	jmp    8006ab <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800685:	a1 20 30 80 00       	mov    0x803020,%eax
  80068a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800693:	89 d0                	mov    %edx,%eax
  800695:	01 c0                	add    %eax,%eax
  800697:	01 d0                	add    %edx,%eax
  800699:	c1 e0 03             	shl    $0x3,%eax
  80069c:	01 c8                	add    %ecx,%eax
  80069e:	8a 40 04             	mov    0x4(%eax),%al
  8006a1:	3c 01                	cmp    $0x1,%al
  8006a3:	75 03                	jne    8006a8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006a5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a8:	ff 45 e0             	incl   -0x20(%ebp)
  8006ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b0:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b9:	39 c2                	cmp    %eax,%edx
  8006bb:	77 c8                	ja     800685 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006c3:	74 14                	je     8006d9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 18 23 80 00       	push   $0x802318
  8006cd:	6a 44                	push   $0x44
  8006cf:	68 b8 22 80 00       	push   $0x8022b8
  8006d4:	e8 1a fe ff ff       	call   8004f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006d9:	90                   	nop
  8006da:	c9                   	leave  
  8006db:	c3                   	ret    

008006dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	89 0a                	mov    %ecx,(%edx)
  8006ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f2:	88 d1                	mov    %dl,%cl
  8006f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	3d ff 00 00 00       	cmp    $0xff,%eax
  800705:	75 2c                	jne    800733 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800707:	a0 24 30 80 00       	mov    0x803024,%al
  80070c:	0f b6 c0             	movzbl %al,%eax
  80070f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800712:	8b 12                	mov    (%edx),%edx
  800714:	89 d1                	mov    %edx,%ecx
  800716:	8b 55 0c             	mov    0xc(%ebp),%edx
  800719:	83 c2 08             	add    $0x8,%edx
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	50                   	push   %eax
  800720:	51                   	push   %ecx
  800721:	52                   	push   %edx
  800722:	e8 b9 0e 00 00       	call   8015e0 <sys_cputs>
  800727:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80072a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	8b 40 04             	mov    0x4(%eax),%eax
  800739:	8d 50 01             	lea    0x1(%eax),%edx
  80073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800742:	90                   	nop
  800743:	c9                   	leave  
  800744:	c3                   	ret    

00800745 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
  800748:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80074e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800755:	00 00 00 
	b.cnt = 0;
  800758:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	ff 75 08             	pushl  0x8(%ebp)
  800768:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076e:	50                   	push   %eax
  80076f:	68 dc 06 80 00       	push   $0x8006dc
  800774:	e8 11 02 00 00       	call   80098a <vprintfmt>
  800779:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80077c:	a0 24 30 80 00       	mov    0x803024,%al
  800781:	0f b6 c0             	movzbl %al,%eax
  800784:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	50                   	push   %eax
  80078e:	52                   	push   %edx
  80078f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800795:	83 c0 08             	add    $0x8,%eax
  800798:	50                   	push   %eax
  800799:	e8 42 0e 00 00       	call   8015e0 <sys_cputs>
  80079e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007a1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b6:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	e8 73 ff ff ff       	call   800745 <vcprintf>
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007e3:	e8 51 0f 00 00       	call   801739 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	e8 48 ff ff ff       	call   800745 <vcprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800803:	e8 4b 0f 00 00       	call   801753 <sys_enable_interrupt>
	return cnt;
  800808:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	83 ec 14             	sub    $0x14,%esp
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800820:	8b 45 18             	mov    0x18(%ebp),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082b:	77 55                	ja     800882 <printnum+0x75>
  80082d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800830:	72 05                	jb     800837 <printnum+0x2a>
  800832:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800835:	77 4b                	ja     800882 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800837:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083d:	8b 45 18             	mov    0x18(%ebp),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	52                   	push   %edx
  800846:	50                   	push   %eax
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	ff 75 f0             	pushl  -0x10(%ebp)
  80084d:	e8 16 14 00 00       	call   801c68 <__udivdi3>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	83 ec 04             	sub    $0x4,%esp
  800858:	ff 75 20             	pushl  0x20(%ebp)
  80085b:	53                   	push   %ebx
  80085c:	ff 75 18             	pushl  0x18(%ebp)
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 08             	pushl  0x8(%ebp)
  800867:	e8 a1 ff ff ff       	call   80080d <printnum>
  80086c:	83 c4 20             	add    $0x20,%esp
  80086f:	eb 1a                	jmp    80088b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 20             	pushl  0x20(%ebp)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800882:	ff 4d 1c             	decl   0x1c(%ebp)
  800885:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800889:	7f e6                	jg     800871 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	53                   	push   %ebx
  80089a:	51                   	push   %ecx
  80089b:	52                   	push   %edx
  80089c:	50                   	push   %eax
  80089d:	e8 d6 14 00 00       	call   801d78 <__umoddi3>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	05 94 25 80 00       	add    $0x802594,%eax
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f be c0             	movsbl %al,%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
}
  8008be:	90                   	nop
  8008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cb:	7e 1c                	jle    8008e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 08             	lea    0x8(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 08             	sub    $0x8,%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	eb 40                	jmp    800929 <getuint+0x65>
	else if (lflag)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 1e                	je     80090d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	eb 1c                	jmp    800929 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800932:	7e 1c                	jle    800950 <getint+0x25>
		return va_arg(*ap, long long);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 08             	lea    0x8(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 08             	sub    $0x8,%eax
  800949:	8b 50 04             	mov    0x4(%eax),%edx
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	eb 38                	jmp    800988 <getint+0x5d>
	else if (lflag)
  800950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800954:	74 1a                	je     800970 <getint+0x45>
		return va_arg(*ap, long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 04             	lea    0x4(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 04             	sub    $0x4,%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	99                   	cltd   
  80096e:	eb 18                	jmp    800988 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	8d 50 04             	lea    0x4(%eax),%edx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	89 10                	mov    %edx,(%eax)
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	99                   	cltd   
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800992:	eb 17                	jmp    8009ab <vprintfmt+0x21>
			if (ch == '\0')
  800994:	85 db                	test   %ebx,%ebx
  800996:	0f 84 af 03 00 00    	je     800d4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	53                   	push   %ebx
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	ff d0                	call   *%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	0f b6 d8             	movzbl %al,%ebx
  8009b9:	83 fb 25             	cmp    $0x25,%ebx
  8009bc:	75 d6                	jne    800994 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	0f b6 d8             	movzbl %al,%ebx
  8009ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ef:	83 f8 55             	cmp    $0x55,%eax
  8009f2:	0f 87 2b 03 00 00    	ja     800d23 <vprintfmt+0x399>
  8009f8:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  8009ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a01:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d7                	jmp    8009de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a07:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0b:	eb d1                	jmp    8009de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a17:	89 d0                	mov    %edx,%eax
  800a19:	c1 e0 02             	shl    $0x2,%eax
  800a1c:	01 d0                	add    %edx,%eax
  800a1e:	01 c0                	add    %eax,%eax
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	83 e8 30             	sub    $0x30,%eax
  800a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a28:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a30:	83 fb 2f             	cmp    $0x2f,%ebx
  800a33:	7e 3e                	jle    800a73 <vprintfmt+0xe9>
  800a35:	83 fb 39             	cmp    $0x39,%ebx
  800a38:	7f 39                	jg     800a73 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3d:	eb d5                	jmp    800a14 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 c0 04             	add    $0x4,%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 e8 04             	sub    $0x4,%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a53:	eb 1f                	jmp    800a74 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a59:	79 83                	jns    8009de <vprintfmt+0x54>
				width = 0;
  800a5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a62:	e9 77 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a67:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6e:	e9 6b ff ff ff       	jmp    8009de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a73:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a78:	0f 89 60 ff ff ff    	jns    8009de <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a84:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8b:	e9 4e ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a90:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a93:	e9 46 ff ff ff       	jmp    8009de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			break;
  800ab8:	e9 89 02 00 00       	jmp    800d46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac0:	83 c0 04             	add    $0x4,%eax
  800ac3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ace:	85 db                	test   %ebx,%ebx
  800ad0:	79 02                	jns    800ad4 <vprintfmt+0x14a>
				err = -err;
  800ad2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad4:	83 fb 64             	cmp    $0x64,%ebx
  800ad7:	7f 0b                	jg     800ae4 <vprintfmt+0x15a>
  800ad9:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800ae0:	85 f6                	test   %esi,%esi
  800ae2:	75 19                	jne    800afd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae4:	53                   	push   %ebx
  800ae5:	68 a5 25 80 00       	push   $0x8025a5
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	ff 75 08             	pushl  0x8(%ebp)
  800af0:	e8 5e 02 00 00       	call   800d53 <printfmt>
  800af5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af8:	e9 49 02 00 00       	jmp    800d46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afd:	56                   	push   %esi
  800afe:	68 ae 25 80 00       	push   $0x8025ae
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 45 02 00 00       	call   800d53 <printfmt>
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 30 02 00 00       	jmp    800d46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 30                	mov    (%eax),%esi
  800b27:	85 f6                	test   %esi,%esi
  800b29:	75 05                	jne    800b30 <vprintfmt+0x1a6>
				p = "(null)";
  800b2b:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7e 6d                	jle    800ba3 <vprintfmt+0x219>
  800b36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3a:	74 67                	je     800ba3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	50                   	push   %eax
  800b43:	56                   	push   %esi
  800b44:	e8 0c 03 00 00       	call   800e55 <strnlen>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4f:	eb 16                	jmp    800b67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6b:	7f e4                	jg     800b51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	eb 34                	jmp    800ba3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b73:	74 1c                	je     800b91 <vprintfmt+0x207>
  800b75:	83 fb 1f             	cmp    $0x1f,%ebx
  800b78:	7e 05                	jle    800b7f <vprintfmt+0x1f5>
  800b7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7d:	7e 12                	jle    800b91 <vprintfmt+0x207>
					putch('?', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 3f                	push   $0x3f
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	eb 0f                	jmp    800ba0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	53                   	push   %ebx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba3:	89 f0                	mov    %esi,%eax
  800ba5:	8d 70 01             	lea    0x1(%eax),%esi
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	0f be d8             	movsbl %al,%ebx
  800bad:	85 db                	test   %ebx,%ebx
  800baf:	74 24                	je     800bd5 <vprintfmt+0x24b>
  800bb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb5:	78 b8                	js     800b6f <vprintfmt+0x1e5>
  800bb7:	ff 4d e0             	decl   -0x20(%ebp)
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	79 af                	jns    800b6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc0:	eb 13                	jmp    800bd5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc2:	83 ec 08             	sub    $0x8,%esp
  800bc5:	ff 75 0c             	pushl  0xc(%ebp)
  800bc8:	6a 20                	push   $0x20
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	ff d0                	call   *%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd9:	7f e7                	jg     800bc2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bdb:	e9 66 01 00 00       	jmp    800d46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be0:	83 ec 08             	sub    $0x8,%esp
  800be3:	ff 75 e8             	pushl  -0x18(%ebp)
  800be6:	8d 45 14             	lea    0x14(%ebp),%eax
  800be9:	50                   	push   %eax
  800bea:	e8 3c fd ff ff       	call   80092b <getint>
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfe:	85 d2                	test   %edx,%edx
  800c00:	79 23                	jns    800c25 <vprintfmt+0x29b>
				putch('-', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 2d                	push   $0x2d
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c18:	f7 d8                	neg    %eax
  800c1a:	83 d2 00             	adc    $0x0,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2c:	e9 bc 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 84 fc ff ff       	call   8008c4 <getuint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c50:	e9 98 00 00 00       	jmp    800ced <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	6a 58                	push   $0x58
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff d0                	call   *%eax
  800c62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	ff 75 0c             	pushl  0xc(%ebp)
  800c6b:	6a 58                	push   $0x58
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 58                	push   $0x58
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			break;
  800c85:	e9 bc 00 00 00       	jmp    800d46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	6a 30                	push   $0x30
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 78                	push   $0x78
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800caa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cad:	83 c0 04             	add    $0x4,%eax
  800cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 e8 04             	sub    $0x4,%eax
  800cb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccc:	eb 1f                	jmp    800ced <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd7:	50                   	push   %eax
  800cd8:	e8 e7 fb ff ff       	call   8008c4 <getuint>
  800cdd:	83 c4 10             	add    $0x10,%esp
  800ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ced:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf4:	83 ec 04             	sub    $0x4,%esp
  800cf7:	52                   	push   %edx
  800cf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cff:	ff 75 f0             	pushl  -0x10(%ebp)
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	ff 75 08             	pushl  0x8(%ebp)
  800d08:	e8 00 fb ff ff       	call   80080d <printnum>
  800d0d:	83 c4 20             	add    $0x20,%esp
			break;
  800d10:	eb 34                	jmp    800d46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	53                   	push   %ebx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			break;
  800d21:	eb 23                	jmp    800d46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d23:	83 ec 08             	sub    $0x8,%esp
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	6a 25                	push   $0x25
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	ff d0                	call   *%eax
  800d30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	eb 03                	jmp    800d3b <vprintfmt+0x3b1>
  800d38:	ff 4d 10             	decl   0x10(%ebp)
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	48                   	dec    %eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 25                	cmp    $0x25,%al
  800d43:	75 f3                	jne    800d38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d45:	90                   	nop
		}
	}
  800d46:	e9 47 fc ff ff       	jmp    800992 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d59:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5c:	83 c0 04             	add    $0x4,%eax
  800d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	ff 75 f4             	pushl  -0xc(%ebp)
  800d68:	50                   	push   %eax
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	e8 16 fc ff ff       	call   80098a <vprintfmt>
  800d74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d77:	90                   	nop
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8b 40 08             	mov    0x8(%eax),%eax
  800d83:	8d 50 01             	lea    0x1(%eax),%edx
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8b 10                	mov    (%eax),%edx
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 40 04             	mov    0x4(%eax),%eax
  800d97:	39 c2                	cmp    %eax,%edx
  800d99:	73 12                	jae    800dad <sprintputch+0x33>
		*b->buf++ = ch;
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	8d 48 01             	lea    0x1(%eax),%ecx
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	89 0a                	mov    %ecx,(%edx)
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	88 10                	mov    %dl,(%eax)
}
  800dad:	90                   	nop
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	01 d0                	add    %edx,%eax
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd5:	74 06                	je     800ddd <vsnprintf+0x2d>
  800dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddb:	7f 07                	jg     800de4 <vsnprintf+0x34>
		return -E_INVAL;
  800ddd:	b8 03 00 00 00       	mov    $0x3,%eax
  800de2:	eb 20                	jmp    800e04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de4:	ff 75 14             	pushl  0x14(%ebp)
  800de7:	ff 75 10             	pushl  0x10(%ebp)
  800dea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ded:	50                   	push   %eax
  800dee:	68 7a 0d 80 00       	push   $0x800d7a
  800df3:	e8 92 fb ff ff       	call   80098a <vprintfmt>
  800df8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 89 ff ff ff       	call   800db0 <vsnprintf>
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3f:	eb 06                	jmp    800e47 <strlen+0x15>
		n++;
  800e41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	84 c0                	test   %al,%al
  800e4e:	75 f1                	jne    800e41 <strlen+0xf>
		n++;
	return n;
  800e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e62:	eb 09                	jmp    800e6d <strnlen+0x18>
		n++;
  800e64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	ff 4d 0c             	decl   0xc(%ebp)
  800e6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e71:	74 09                	je     800e7c <strnlen+0x27>
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	84 c0                	test   %al,%al
  800e7a:	75 e8                	jne    800e64 <strnlen+0xf>
		n++;
	return n;
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8d:	90                   	nop
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 08             	mov    %edx,0x8(%ebp)
  800e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 e4                	jne    800e8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec2:	eb 1f                	jmp    800ee3 <strncpy+0x34>
		*dst++ = *src;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8d 50 01             	lea    0x1(%eax),%edx
  800eca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	84 c0                	test   %al,%al
  800edb:	74 03                	je     800ee0 <strncpy+0x31>
			src++;
  800edd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee0:	ff 45 fc             	incl   -0x4(%ebp)
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee9:	72 d9                	jb     800ec4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 30                	je     800f32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f02:	eb 16                	jmp    800f1a <strlcpy+0x2a>
			*dst++ = *src++;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8d 50 01             	lea    0x1(%eax),%edx
  800f0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f16:	8a 12                	mov    (%edx),%dl
  800f18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f1a:	ff 4d 10             	decl   0x10(%ebp)
  800f1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f21:	74 09                	je     800f2c <strlcpy+0x3c>
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 d8                	jne    800f04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	29 c2                	sub    %eax,%edx
  800f3a:	89 d0                	mov    %edx,%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f41:	eb 06                	jmp    800f49 <strcmp+0xb>
		p++, q++;
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strcmp+0x22>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 e3                	je     800f43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f b6 d0             	movzbl %al,%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f b6 c0             	movzbl %al,%eax
  800f70:	29 c2                	sub    %eax,%edx
  800f72:	89 d0                	mov    %edx,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f79:	eb 09                	jmp    800f84 <strncmp+0xe>
		n--, p++, q++;
  800f7b:	ff 4d 10             	decl   0x10(%ebp)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	74 17                	je     800fa1 <strncmp+0x2b>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 0e                	je     800fa1 <strncmp+0x2b>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 10                	mov    (%eax),%dl
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	38 c2                	cmp    %al,%dl
  800f9f:	74 da                	je     800f7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa5:	75 07                	jne    800fae <strncmp+0x38>
		return 0;
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fac:	eb 14                	jmp    800fc2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 04             	sub    $0x4,%esp
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd0:	eb 12                	jmp    800fe4 <strchr+0x20>
		if (*s == c)
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fda:	75 05                	jne    800fe1 <strchr+0x1d>
			return (char *) s;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	eb 11                	jmp    800ff2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe1:	ff 45 08             	incl   0x8(%ebp)
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	84 c0                	test   %al,%al
  800feb:	75 e5                	jne    800fd2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801000:	eb 0d                	jmp    80100f <strfind+0x1b>
		if (*s == c)
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80100a:	74 0e                	je     80101a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100c:	ff 45 08             	incl   0x8(%ebp)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	84 c0                	test   %al,%al
  801016:	75 ea                	jne    801002 <strfind+0xe>
  801018:	eb 01                	jmp    80101b <strfind+0x27>
		if (*s == c)
			break;
  80101a:	90                   	nop
	return (char *) s;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801032:	eb 0e                	jmp    801042 <memset+0x22>
		*p++ = c;
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	8d 50 01             	lea    0x1(%eax),%edx
  80103a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80103d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801042:	ff 4d f8             	decl   -0x8(%ebp)
  801045:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801049:	79 e9                	jns    801034 <memset+0x14>
		*p++ = c;

	return v;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801056:	8b 45 0c             	mov    0xc(%ebp),%eax
  801059:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801062:	eb 16                	jmp    80107a <memcpy+0x2a>
		*d++ = *s++;
  801064:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801067:	8d 50 01             	lea    0x1(%eax),%edx
  80106a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801070:	8d 4a 01             	lea    0x1(%edx),%ecx
  801073:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801076:	8a 12                	mov    (%edx),%dl
  801078:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801080:	89 55 10             	mov    %edx,0x10(%ebp)
  801083:	85 c0                	test   %eax,%eax
  801085:	75 dd                	jne    801064 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a4:	73 50                	jae    8010f6 <memmove+0x6a>
  8010a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 d0                	add    %edx,%eax
  8010ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b1:	76 43                	jbe    8010f6 <memmove+0x6a>
		s += n;
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010bf:	eb 10                	jmp    8010d1 <memmove+0x45>
			*--d = *--s;
  8010c1:	ff 4d f8             	decl   -0x8(%ebp)
  8010c4:	ff 4d fc             	decl   -0x4(%ebp)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	75 e3                	jne    8010c1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010de:	eb 23                	jmp    801103 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8d 50 01             	lea    0x1(%eax),%edx
  8010e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	75 dd                	jne    8010e0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801106:	c9                   	leave  
  801107:	c3                   	ret    

00801108 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80111a:	eb 2a                	jmp    801146 <memcmp+0x3e>
		if (*s1 != *s2)
  80111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111f:	8a 10                	mov    (%eax),%dl
  801121:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	38 c2                	cmp    %al,%dl
  801128:	74 16                	je     801140 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80112a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	0f b6 d0             	movzbl %al,%edx
  801132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	29 c2                	sub    %eax,%edx
  80113c:	89 d0                	mov    %edx,%eax
  80113e:	eb 18                	jmp    801158 <memcmp+0x50>
		s1++, s2++;
  801140:	ff 45 fc             	incl   -0x4(%ebp)
  801143:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114c:	89 55 10             	mov    %edx,0x10(%ebp)
  80114f:	85 c0                	test   %eax,%eax
  801151:	75 c9                	jne    80111c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801153:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801160:	8b 55 08             	mov    0x8(%ebp),%edx
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80116b:	eb 15                	jmp    801182 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 d0             	movzbl %al,%edx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	39 c2                	cmp    %eax,%edx
  80117d:	74 0d                	je     80118c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801188:	72 e3                	jb     80116d <memfind+0x13>
  80118a:	eb 01                	jmp    80118d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80118c:	90                   	nop
	return (void *) s;
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801198:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80119f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a6:	eb 03                	jmp    8011ab <strtol+0x19>
		s++;
  8011a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 20                	cmp    $0x20,%al
  8011b2:	74 f4                	je     8011a8 <strtol+0x16>
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	3c 09                	cmp    $0x9,%al
  8011bb:	74 eb                	je     8011a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3c 2b                	cmp    $0x2b,%al
  8011c4:	75 05                	jne    8011cb <strtol+0x39>
		s++;
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	eb 13                	jmp    8011de <strtol+0x4c>
	else if (*s == '-')
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	3c 2d                	cmp    $0x2d,%al
  8011d2:	75 0a                	jne    8011de <strtol+0x4c>
		s++, neg = 1;
  8011d4:	ff 45 08             	incl   0x8(%ebp)
  8011d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e2:	74 06                	je     8011ea <strtol+0x58>
  8011e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011e8:	75 20                	jne    80120a <strtol+0x78>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 17                	jne    80120a <strtol+0x78>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	40                   	inc    %eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 78                	cmp    $0x78,%al
  8011fb:	75 0d                	jne    80120a <strtol+0x78>
		s += 2, base = 16;
  8011fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801201:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801208:	eb 28                	jmp    801232 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80120a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120e:	75 15                	jne    801225 <strtol+0x93>
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 30                	cmp    $0x30,%al
  801217:	75 0c                	jne    801225 <strtol+0x93>
		s++, base = 8;
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801223:	eb 0d                	jmp    801232 <strtol+0xa0>
	else if (base == 0)
  801225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801229:	75 07                	jne    801232 <strtol+0xa0>
		base = 10;
  80122b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	3c 2f                	cmp    $0x2f,%al
  801239:	7e 19                	jle    801254 <strtol+0xc2>
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 39                	cmp    $0x39,%al
  801242:	7f 10                	jg     801254 <strtol+0xc2>
			dig = *s - '0';
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	0f be c0             	movsbl %al,%eax
  80124c:	83 e8 30             	sub    $0x30,%eax
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801252:	eb 42                	jmp    801296 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	3c 60                	cmp    $0x60,%al
  80125b:	7e 19                	jle    801276 <strtol+0xe4>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	3c 7a                	cmp    $0x7a,%al
  801264:	7f 10                	jg     801276 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	0f be c0             	movsbl %al,%eax
  80126e:	83 e8 57             	sub    $0x57,%eax
  801271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801274:	eb 20                	jmp    801296 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 40                	cmp    $0x40,%al
  80127d:	7e 39                	jle    8012b8 <strtol+0x126>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 5a                	cmp    $0x5a,%al
  801286:	7f 30                	jg     8012b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f be c0             	movsbl %al,%eax
  801290:	83 e8 37             	sub    $0x37,%eax
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	3b 45 10             	cmp    0x10(%ebp),%eax
  80129c:	7d 19                	jge    8012b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012b2:	e9 7b ff ff ff       	jmp    801232 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012bc:	74 08                	je     8012c6 <strtol+0x134>
		*endptr = (char *) s;
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ca:	74 07                	je     8012d3 <strtol+0x141>
  8012cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cf:	f7 d8                	neg    %eax
  8012d1:	eb 03                	jmp    8012d6 <strtol+0x144>
  8012d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f0:	79 13                	jns    801305 <ltostr+0x2d>
	{
		neg = 1;
  8012f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801302:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80130d:	99                   	cltd   
  80130e:	f7 f9                	idiv   %ecx
  801310:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	8d 50 01             	lea    0x1(%eax),%edx
  801319:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801326:	83 c2 30             	add    $0x30,%edx
  801329:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80132b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801333:	f7 e9                	imul   %ecx
  801335:	c1 fa 02             	sar    $0x2,%edx
  801338:	89 c8                	mov    %ecx,%eax
  80133a:	c1 f8 1f             	sar    $0x1f,%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801344:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801347:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134c:	f7 e9                	imul   %ecx
  80134e:	c1 fa 02             	sar    $0x2,%edx
  801351:	89 c8                	mov    %ecx,%eax
  801353:	c1 f8 1f             	sar    $0x1f,%eax
  801356:	29 c2                	sub    %eax,%edx
  801358:	89 d0                	mov    %edx,%eax
  80135a:	c1 e0 02             	shl    $0x2,%eax
  80135d:	01 d0                	add    %edx,%eax
  80135f:	01 c0                	add    %eax,%eax
  801361:	29 c1                	sub    %eax,%ecx
  801363:	89 ca                	mov    %ecx,%edx
  801365:	85 d2                	test   %edx,%edx
  801367:	75 9c                	jne    801305 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801373:	48                   	dec    %eax
  801374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801377:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137b:	74 3d                	je     8013ba <ltostr+0xe2>
		start = 1 ;
  80137d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801384:	eb 34                	jmp    8013ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	01 c2                	add    %eax,%edx
  80139b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	01 c8                	add    %ecx,%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	01 c2                	add    %eax,%edx
  8013af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c0:	7c c4                	jl     801386 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c8:	01 d0                	add    %edx,%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	e8 54 fa ff ff       	call   800e32 <strlen>
  8013de:	83 c4 04             	add    $0x4,%esp
  8013e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	e8 46 fa ff ff       	call   800e32 <strlen>
  8013ec:	83 c4 04             	add    $0x4,%esp
  8013ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801400:	eb 17                	jmp    801419 <strcconcat+0x49>
		final[s] = str1[s] ;
  801402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	01 c2                	add    %eax,%edx
  80140a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	01 c8                	add    %ecx,%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801416:	ff 45 fc             	incl   -0x4(%ebp)
  801419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141f:	7c e1                	jl     801402 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801421:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801428:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142f:	eb 1f                	jmp    801450 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801434:	8d 50 01             	lea    0x1(%eax),%edx
  801437:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	01 c2                	add    %eax,%edx
  801441:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	01 c8                	add    %ecx,%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80144d:	ff 45 f8             	incl   -0x8(%ebp)
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801453:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801456:	7c d9                	jl     801431 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	c6 00 00             	movb   $0x0,(%eax)
}
  801463:	90                   	nop
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801469:	8b 45 14             	mov    0x14(%ebp),%eax
  80146c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801472:	8b 45 14             	mov    0x14(%ebp),%eax
  801475:	8b 00                	mov    (%eax),%eax
  801477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147e:	8b 45 10             	mov    0x10(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801489:	eb 0c                	jmp    801497 <strsplit+0x31>
			*string++ = 0;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8d 50 01             	lea    0x1(%eax),%edx
  801491:	89 55 08             	mov    %edx,0x8(%ebp)
  801494:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	84 c0                	test   %al,%al
  80149e:	74 18                	je     8014b8 <strsplit+0x52>
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	0f be c0             	movsbl %al,%eax
  8014a8:	50                   	push   %eax
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	e8 13 fb ff ff       	call   800fc4 <strchr>
  8014b1:	83 c4 08             	add    $0x8,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	75 d3                	jne    80148b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	84 c0                	test   %al,%al
  8014bf:	74 5a                	je     80151b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c4:	8b 00                	mov    (%eax),%eax
  8014c6:	83 f8 0f             	cmp    $0xf,%eax
  8014c9:	75 07                	jne    8014d2 <strsplit+0x6c>
		{
			return 0;
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d0:	eb 66                	jmp    801538 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d5:	8b 00                	mov    (%eax),%eax
  8014d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8014da:	8b 55 14             	mov    0x14(%ebp),%edx
  8014dd:	89 0a                	mov    %ecx,(%edx)
  8014df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e9:	01 c2                	add    %eax,%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f0:	eb 03                	jmp    8014f5 <strsplit+0x8f>
			string++;
  8014f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	84 c0                	test   %al,%al
  8014fc:	74 8b                	je     801489 <strsplit+0x23>
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	0f be c0             	movsbl %al,%eax
  801506:	50                   	push   %eax
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	e8 b5 fa ff ff       	call   800fc4 <strchr>
  80150f:	83 c4 08             	add    $0x8,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	74 dc                	je     8014f2 <strsplit+0x8c>
			string++;
	}
  801516:	e9 6e ff ff ff       	jmp    801489 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80151b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801528:	8b 45 10             	mov    0x10(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
  80152d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801533:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801540:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801547:	eb 4c                	jmp    801595 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801549:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	8a 00                	mov    (%eax),%al
  801553:	3c 40                	cmp    $0x40,%al
  801555:	7e 27                	jle    80157e <str2lower+0x44>
  801557:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	3c 5a                	cmp    $0x5a,%al
  801563:	7f 19                	jg     80157e <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801565:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	01 d0                	add    %edx,%eax
  80156d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	01 ca                	add    %ecx,%edx
  801575:	8a 12                	mov    (%edx),%dl
  801577:	83 c2 20             	add    $0x20,%edx
  80157a:	88 10                	mov    %dl,(%eax)
  80157c:	eb 14                	jmp    801592 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  80157e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	01 c2                	add    %eax,%edx
  801586:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158c:	01 c8                	add    %ecx,%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801592:	ff 45 fc             	incl   -0x4(%ebp)
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 95 f8 ff ff       	call   800e32 <strlen>
  80159d:	83 c4 04             	add    $0x4,%esp
  8015a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015a3:	7f a4                	jg     801549 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  8015a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	01 d0                	add    %edx,%eax
  8015ad:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	57                   	push   %edi
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
  8015bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015d0:	cd 30                	int    $0x30
  8015d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5f                   	pop    %edi
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	52                   	push   %edx
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	50                   	push   %eax
  8015fc:	6a 00                	push   $0x0
  8015fe:	e8 b2 ff ff ff       	call   8015b5 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_cgetc>:

int
sys_cgetc(void)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 01                	push   $0x1
  801618:	e8 98 ff ff ff       	call   8015b5 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 05                	push   $0x5
  801635:	e8 7b ff ff ff       	call   8015b5 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801644:	8b 75 18             	mov    0x18(%ebp),%esi
  801647:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	51                   	push   %ecx
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	6a 06                	push   $0x6
  80165a:	e8 56 ff ff ff       	call   8015b5 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	6a 07                	push   $0x7
  80167c:	e8 34 ff ff ff       	call   8015b5 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	6a 08                	push   $0x8
  801697:	e8 19 ff ff ff       	call   8015b5 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 09                	push   $0x9
  8016b0:	e8 00 ff ff ff       	call   8015b5 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 0a                	push   $0xa
  8016c9:	e8 e7 fe ff ff       	call   8015b5 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 0b                	push   $0xb
  8016e2:	e8 ce fe ff ff       	call   8015b5 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 0c                	push   $0xc
  8016fb:	e8 b5 fe ff ff       	call   8015b5 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	ff 75 08             	pushl  0x8(%ebp)
  801713:	6a 0d                	push   $0xd
  801715:	e8 9b fe ff ff       	call   8015b5 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 0e                	push   $0xe
  80172e:	e8 82 fe ff ff       	call   8015b5 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 11                	push   $0x11
  801748:	e8 68 fe ff ff       	call   8015b5 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 12                	push   $0x12
  801762:	e8 4e fe ff ff       	call   8015b5 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	90                   	nop
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_cputc>:


void
sys_cputc(const char c)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801779:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	50                   	push   %eax
  801786:	6a 13                	push   $0x13
  801788:	e8 28 fe ff ff       	call   8015b5 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 14                	push   $0x14
  8017a2:	e8 0e fe ff ff       	call   8015b5 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	90                   	nop
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	50                   	push   %eax
  8017bd:	6a 15                	push   $0x15
  8017bf:	e8 f1 fd ff ff       	call   8015b5 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	52                   	push   %edx
  8017d9:	50                   	push   %eax
  8017da:	6a 18                	push   $0x18
  8017dc:	e8 d4 fd ff ff       	call   8015b5 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 16                	push   $0x16
  8017f9:	e8 b7 fd ff ff       	call   8015b5 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	90                   	nop
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	6a 17                	push   $0x17
  801817:	e8 99 fd ff ff       	call   8015b5 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80182e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801831:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	51                   	push   %ecx
  80183b:	52                   	push   %edx
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	50                   	push   %eax
  801840:	6a 19                	push   $0x19
  801842:	e8 6e fd ff ff       	call   8015b5 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 1a                	push   $0x1a
  80185f:	e8 51 fd ff ff       	call   8015b5 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	51                   	push   %ecx
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 1b                	push   $0x1b
  80187e:	e8 32 fd ff ff       	call   8015b5 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 1c                	push   $0x1c
  80189b:	e8 15 fd ff ff       	call   8015b5 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 1d                	push   $0x1d
  8018b4:	e8 fc fc ff ff       	call   8015b5 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	ff 75 14             	pushl  0x14(%ebp)
  8018c9:	ff 75 10             	pushl  0x10(%ebp)
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	50                   	push   %eax
  8018d0:	6a 1e                	push   $0x1e
  8018d2:	e8 de fc ff ff       	call   8015b5 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	50                   	push   %eax
  8018eb:	6a 1f                	push   $0x1f
  8018ed:	e8 c3 fc ff ff       	call   8015b5 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	90                   	nop
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	50                   	push   %eax
  801907:	6a 20                	push   $0x20
  801909:	e8 a7 fc ff ff       	call   8015b5 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 02                	push   $0x2
  801922:	e8 8e fc ff ff       	call   8015b5 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 03                	push   $0x3
  80193b:	e8 75 fc ff ff       	call   8015b5 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 04                	push   $0x4
  801954:	e8 5c fc ff ff       	call   8015b5 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_exit_env>:


void sys_exit_env(void)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 21                	push   $0x21
  80196d:	e8 43 fc ff ff       	call   8015b5 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80197e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801981:	8d 50 04             	lea    0x4(%eax),%edx
  801984:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 22                	push   $0x22
  801991:	e8 1f fc ff ff       	call   8015b5 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
	return result;
  801999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80199c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80199f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a2:	89 01                	mov    %eax,(%ecx)
  8019a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	c9                   	leave  
  8019ab:	c2 04 00             	ret    $0x4

008019ae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 10             	pushl  0x10(%ebp)
  8019b8:	ff 75 0c             	pushl  0xc(%ebp)
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	6a 10                	push   $0x10
  8019c0:	e8 f0 fb ff ff       	call   8015b5 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c8:	90                   	nop
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_rcr2>:
uint32 sys_rcr2()
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 23                	push   $0x23
  8019da:	e8 d6 fb ff ff       	call   8015b5 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019f0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	50                   	push   %eax
  8019fd:	6a 24                	push   $0x24
  8019ff:	e8 b1 fb ff ff       	call   8015b5 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
	return ;
  801a07:	90                   	nop
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <rsttst>:
void rsttst()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 26                	push   $0x26
  801a19:	e8 97 fb ff ff       	call   8015b5 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a30:	8b 55 18             	mov    0x18(%ebp),%edx
  801a33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	ff 75 08             	pushl  0x8(%ebp)
  801a42:	6a 25                	push   $0x25
  801a44:	e8 6c fb ff ff       	call   8015b5 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4c:	90                   	nop
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <chktst>:
void chktst(uint32 n)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 27                	push   $0x27
  801a5f:	e8 51 fb ff ff       	call   8015b5 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return ;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <inctst>:

void inctst()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 28                	push   $0x28
  801a79:	e8 37 fb ff ff       	call   8015b5 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a81:	90                   	nop
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <gettst>:
uint32 gettst()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 29                	push   $0x29
  801a93:	e8 1d fb ff ff       	call   8015b5 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 2a                	push   $0x2a
  801aaf:	e8 01 fb ff ff       	call   8015b5 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
  801ab7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801aba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801abe:	75 07                	jne    801ac7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ac0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac5:	eb 05                	jmp    801acc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 2a                	push   $0x2a
  801ae0:	e8 d0 fa ff ff       	call   8015b5 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
  801ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aeb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aef:	75 07                	jne    801af8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	eb 05                	jmp    801afd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 2a                	push   $0x2a
  801b11:	e8 9f fa ff ff       	call   8015b5 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
  801b19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b1c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b20:	75 07                	jne    801b29 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
  801b27:	eb 05                	jmp    801b2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 2a                	push   $0x2a
  801b42:	e8 6e fa ff ff       	call   8015b5 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
  801b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b51:	75 07                	jne    801b5a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b53:	b8 01 00 00 00       	mov    $0x1,%eax
  801b58:	eb 05                	jmp    801b5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	6a 2b                	push   $0x2b
  801b71:	e8 3f fa ff ff       	call   8015b5 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	53                   	push   %ebx
  801b8f:	51                   	push   %ecx
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 2c                	push   $0x2c
  801b94:	e8 1c fa ff ff       	call   8015b5 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	6a 2d                	push   $0x2d
  801bb4:	e8 fc f9 ff ff       	call   8015b5 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bc1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	51                   	push   %ecx
  801bcd:	ff 75 10             	pushl  0x10(%ebp)
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 2e                	push   $0x2e
  801bd4:	e8 dc f9 ff ff       	call   8015b5 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	ff 75 10             	pushl  0x10(%ebp)
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	6a 0f                	push   $0xf
  801bf0:	e8 c0 f9 ff ff       	call   8015b5 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf8:	90                   	nop
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	50                   	push   %eax
  801c0a:	6a 2f                	push   $0x2f
  801c0c:	e8 a4 f9 ff ff       	call   8015b5 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp

}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 30                	push   $0x30
  801c27:	e8 89 f9 ff ff       	call   8015b5 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp

}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	6a 31                	push   $0x31
  801c43:	e8 6d f9 ff ff       	call   8015b5 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp

}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_hard_limit>:
uint32 sys_hard_limit(){
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 32                	push   $0x32
  801c5d:	e8 53 f9 ff ff       	call   8015b5 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    
  801c67:	90                   	nop

00801c68 <__udivdi3>:
  801c68:	55                   	push   %ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 1c             	sub    $0x1c,%esp
  801c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7f:	89 ca                	mov    %ecx,%edx
  801c81:	89 f8                	mov    %edi,%eax
  801c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c87:	85 f6                	test   %esi,%esi
  801c89:	75 2d                	jne    801cb8 <__udivdi3+0x50>
  801c8b:	39 cf                	cmp    %ecx,%edi
  801c8d:	77 65                	ja     801cf4 <__udivdi3+0x8c>
  801c8f:	89 fd                	mov    %edi,%ebp
  801c91:	85 ff                	test   %edi,%edi
  801c93:	75 0b                	jne    801ca0 <__udivdi3+0x38>
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	31 d2                	xor    %edx,%edx
  801c9c:	f7 f7                	div    %edi
  801c9e:	89 c5                	mov    %eax,%ebp
  801ca0:	31 d2                	xor    %edx,%edx
  801ca2:	89 c8                	mov    %ecx,%eax
  801ca4:	f7 f5                	div    %ebp
  801ca6:	89 c1                	mov    %eax,%ecx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	f7 f5                	div    %ebp
  801cac:	89 cf                	mov    %ecx,%edi
  801cae:	89 fa                	mov    %edi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 ce                	cmp    %ecx,%esi
  801cba:	77 28                	ja     801ce4 <__udivdi3+0x7c>
  801cbc:	0f bd fe             	bsr    %esi,%edi
  801cbf:	83 f7 1f             	xor    $0x1f,%edi
  801cc2:	75 40                	jne    801d04 <__udivdi3+0x9c>
  801cc4:	39 ce                	cmp    %ecx,%esi
  801cc6:	72 0a                	jb     801cd2 <__udivdi3+0x6a>
  801cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ccc:	0f 87 9e 00 00 00    	ja     801d70 <__udivdi3+0x108>
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	89 fa                	mov    %edi,%edx
  801cd9:	83 c4 1c             	add    $0x1c,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    
  801ce1:	8d 76 00             	lea    0x0(%esi),%esi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	31 c0                	xor    %eax,%eax
  801ce8:	89 fa                	mov    %edi,%edx
  801cea:	83 c4 1c             	add    $0x1c,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5e                   	pop    %esi
  801cef:	5f                   	pop    %edi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	89 d8                	mov    %ebx,%eax
  801cf6:	f7 f7                	div    %edi
  801cf8:	31 ff                	xor    %edi,%edi
  801cfa:	89 fa                	mov    %edi,%edx
  801cfc:	83 c4 1c             	add    $0x1c,%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5f                   	pop    %edi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
  801d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d09:	89 eb                	mov    %ebp,%ebx
  801d0b:	29 fb                	sub    %edi,%ebx
  801d0d:	89 f9                	mov    %edi,%ecx
  801d0f:	d3 e6                	shl    %cl,%esi
  801d11:	89 c5                	mov    %eax,%ebp
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ed                	shr    %cl,%ebp
  801d17:	89 e9                	mov    %ebp,%ecx
  801d19:	09 f1                	or     %esi,%ecx
  801d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d1f:	89 f9                	mov    %edi,%ecx
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 c5                	mov    %eax,%ebp
  801d25:	89 d6                	mov    %edx,%esi
  801d27:	88 d9                	mov    %bl,%cl
  801d29:	d3 ee                	shr    %cl,%esi
  801d2b:	89 f9                	mov    %edi,%ecx
  801d2d:	d3 e2                	shl    %cl,%edx
  801d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 e8                	shr    %cl,%eax
  801d37:	09 c2                	or     %eax,%edx
  801d39:	89 d0                	mov    %edx,%eax
  801d3b:	89 f2                	mov    %esi,%edx
  801d3d:	f7 74 24 0c          	divl   0xc(%esp)
  801d41:	89 d6                	mov    %edx,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	f7 e5                	mul    %ebp
  801d47:	39 d6                	cmp    %edx,%esi
  801d49:	72 19                	jb     801d64 <__udivdi3+0xfc>
  801d4b:	74 0b                	je     801d58 <__udivdi3+0xf0>
  801d4d:	89 d8                	mov    %ebx,%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 58 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d5c:	89 f9                	mov    %edi,%ecx
  801d5e:	d3 e2                	shl    %cl,%edx
  801d60:	39 c2                	cmp    %eax,%edx
  801d62:	73 e9                	jae    801d4d <__udivdi3+0xe5>
  801d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d67:	31 ff                	xor    %edi,%edi
  801d69:	e9 40 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	31 c0                	xor    %eax,%eax
  801d72:	e9 37 ff ff ff       	jmp    801cae <__udivdi3+0x46>
  801d77:	90                   	nop

00801d78 <__umoddi3>:
  801d78:	55                   	push   %ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 1c             	sub    $0x1c,%esp
  801d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d97:	89 f3                	mov    %esi,%ebx
  801d99:	89 fa                	mov    %edi,%edx
  801d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9f:	89 34 24             	mov    %esi,(%esp)
  801da2:	85 c0                	test   %eax,%eax
  801da4:	75 1a                	jne    801dc0 <__umoddi3+0x48>
  801da6:	39 f7                	cmp    %esi,%edi
  801da8:	0f 86 a2 00 00 00    	jbe    801e50 <__umoddi3+0xd8>
  801dae:	89 c8                	mov    %ecx,%eax
  801db0:	89 f2                	mov    %esi,%edx
  801db2:	f7 f7                	div    %edi
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	31 d2                	xor    %edx,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	39 f0                	cmp    %esi,%eax
  801dc2:	0f 87 ac 00 00 00    	ja     801e74 <__umoddi3+0xfc>
  801dc8:	0f bd e8             	bsr    %eax,%ebp
  801dcb:	83 f5 1f             	xor    $0x1f,%ebp
  801dce:	0f 84 ac 00 00 00    	je     801e80 <__umoddi3+0x108>
  801dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801dd9:	29 ef                	sub    %ebp,%edi
  801ddb:	89 fe                	mov    %edi,%esi
  801ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 e0                	shl    %cl,%eax
  801de5:	89 d7                	mov    %edx,%edi
  801de7:	89 f1                	mov    %esi,%ecx
  801de9:	d3 ef                	shr    %cl,%edi
  801deb:	09 c7                	or     %eax,%edi
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 e2                	shl    %cl,%edx
  801df1:	89 14 24             	mov    %edx,(%esp)
  801df4:	89 d8                	mov    %ebx,%eax
  801df6:	d3 e0                	shl    %cl,%eax
  801df8:	89 c2                	mov    %eax,%edx
  801dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfe:	d3 e0                	shl    %cl,%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e08:	89 f1                	mov    %esi,%ecx
  801e0a:	d3 e8                	shr    %cl,%eax
  801e0c:	09 d0                	or     %edx,%eax
  801e0e:	d3 eb                	shr    %cl,%ebx
  801e10:	89 da                	mov    %ebx,%edx
  801e12:	f7 f7                	div    %edi
  801e14:	89 d3                	mov    %edx,%ebx
  801e16:	f7 24 24             	mull   (%esp)
  801e19:	89 c6                	mov    %eax,%esi
  801e1b:	89 d1                	mov    %edx,%ecx
  801e1d:	39 d3                	cmp    %edx,%ebx
  801e1f:	0f 82 87 00 00 00    	jb     801eac <__umoddi3+0x134>
  801e25:	0f 84 91 00 00 00    	je     801ebc <__umoddi3+0x144>
  801e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2f:	29 f2                	sub    %esi,%edx
  801e31:	19 cb                	sbb    %ecx,%ebx
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e39:	d3 e0                	shl    %cl,%eax
  801e3b:	89 e9                	mov    %ebp,%ecx
  801e3d:	d3 ea                	shr    %cl,%edx
  801e3f:	09 d0                	or     %edx,%eax
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 eb                	shr    %cl,%ebx
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	83 c4 1c             	add    $0x1c,%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
  801e4f:	90                   	nop
  801e50:	89 fd                	mov    %edi,%ebp
  801e52:	85 ff                	test   %edi,%edi
  801e54:	75 0b                	jne    801e61 <__umoddi3+0xe9>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	f7 f7                	div    %edi
  801e5f:	89 c5                	mov    %eax,%ebp
  801e61:	89 f0                	mov    %esi,%eax
  801e63:	31 d2                	xor    %edx,%edx
  801e65:	f7 f5                	div    %ebp
  801e67:	89 c8                	mov    %ecx,%eax
  801e69:	f7 f5                	div    %ebp
  801e6b:	89 d0                	mov    %edx,%eax
  801e6d:	e9 44 ff ff ff       	jmp    801db6 <__umoddi3+0x3e>
  801e72:	66 90                	xchg   %ax,%ax
  801e74:	89 c8                	mov    %ecx,%eax
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	3b 04 24             	cmp    (%esp),%eax
  801e83:	72 06                	jb     801e8b <__umoddi3+0x113>
  801e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e89:	77 0f                	ja     801e9a <__umoddi3+0x122>
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	29 f9                	sub    %edi,%ecx
  801e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e93:	89 14 24             	mov    %edx,(%esp)
  801e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9e:	8b 14 24             	mov    (%esp),%edx
  801ea1:	83 c4 1c             	add    $0x1c,%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    
  801ea9:	8d 76 00             	lea    0x0(%esi),%esi
  801eac:	2b 04 24             	sub    (%esp),%eax
  801eaf:	19 fa                	sbb    %edi,%edx
  801eb1:	89 d1                	mov    %edx,%ecx
  801eb3:	89 c6                	mov    %eax,%esi
  801eb5:	e9 71 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ec0:	72 ea                	jb     801eac <__umoddi3+0x134>
  801ec2:	89 d9                	mov    %ebx,%ecx
  801ec4:	e9 62 ff ff ff       	jmp    801e2b <__umoddi3+0xb3>
