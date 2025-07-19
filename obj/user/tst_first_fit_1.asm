
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 60 09 00 00       	call   800996 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 2000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 de 25 00 00       	call   802628 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 20 40 80 00       	mov    0x804020,%eax
  800052:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
  800058:	a1 20 40 80 00       	mov    0x804020,%eax
  80005d:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 80 35 80 00       	push   $0x803580
  80006f:	6a 15                	push   $0x15
  800071:	68 9c 35 80 00       	push   $0x80359c
  800076:	e8 52 0a 00 00       	call   800acd <_panic>
	}
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	int Mega = 1024*1024;
  800082:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800089:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  800090:	8d 55 94             	lea    -0x6c(%ebp),%edx
  800093:	b9 14 00 00 00       	mov    $0x14,%ecx
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	89 d7                	mov    %edx,%edi
  80009f:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate set of blocks
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000a1:	e8 c2 20 00 00       	call   802168 <sys_calculate_free_frames>
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a9:	e8 05 21 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8000ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	50                   	push   %eax
  8000bb:	e8 b8 1c 00 00       	call   801d78 <malloc>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8000c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000cc:	74 14                	je     8000e2 <_main+0xaa>
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	68 b4 35 80 00       	push   $0x8035b4
  8000d6:	6a 26                	push   $0x26
  8000d8:	68 9c 35 80 00       	push   $0x80359c
  8000dd:	e8 eb 09 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8000e2:	e8 cc 20 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8000e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ea:	74 14                	je     800100 <_main+0xc8>
  8000ec:	83 ec 04             	sub    $0x4,%esp
  8000ef:	68 e4 35 80 00       	push   $0x8035e4
  8000f4:	6a 28                	push   $0x28
  8000f6:	68 9c 35 80 00       	push   $0x80359c
  8000fb:	e8 cd 09 00 00       	call   800acd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800100:	e8 63 20 00 00       	call   802168 <sys_calculate_free_frames>
  800105:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800108:	e8 a6 20 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80010d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800113:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	e8 59 1c 00 00       	call   801d78 <malloc>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800125:	8b 45 98             	mov    -0x68(%ebp),%eax
  800128:	89 c1                	mov    %eax,%ecx
  80012a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80012d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800130:	01 d0                	add    %edx,%eax
  800132:	39 c1                	cmp    %eax,%ecx
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 b4 35 80 00       	push   $0x8035b4
  80013e:	6a 2e                	push   $0x2e
  800140:	68 9c 35 80 00       	push   $0x80359c
  800145:	e8 83 09 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014a:	e8 64 20 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80014f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800152:	74 14                	je     800168 <_main+0x130>
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	68 e4 35 80 00       	push   $0x8035e4
  80015c:	6a 30                	push   $0x30
  80015e:	68 9c 35 80 00       	push   $0x80359c
  800163:	e8 65 09 00 00       	call   800acd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800168:	e8 fb 1f 00 00       	call   802168 <sys_calculate_free_frames>
  80016d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800170:	e8 3e 20 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	e8 f1 1b 00 00       	call   801d78 <malloc>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80018d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800195:	01 c0                	add    %eax,%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019c:	01 c8                	add    %ecx,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 b4 35 80 00       	push   $0x8035b4
  8001aa:	6a 36                	push   $0x36
  8001ac:	68 9c 35 80 00       	push   $0x80359c
  8001b1:	e8 17 09 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 f8 1f 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 e4 35 80 00       	push   $0x8035e4
  8001c8:	6a 38                	push   $0x38
  8001ca:	68 9c 35 80 00       	push   $0x80359c
  8001cf:	e8 f9 08 00 00       	call   800acd <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001d4:	e8 8f 1f 00 00       	call   802168 <sys_calculate_free_frames>
  8001d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dc:	e8 d2 1f 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8001e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	50                   	push   %eax
  8001ee:	e8 85 1b 00 00       	call   801d78 <malloc>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8001f9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8001fc:	89 c1                	mov    %eax,%ecx
  8001fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800201:	89 c2                	mov    %eax,%edx
  800203:	01 d2                	add    %edx,%edx
  800205:	01 d0                	add    %edx,%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80020c:	01 d0                	add    %edx,%eax
  80020e:	39 c1                	cmp    %eax,%ecx
  800210:	74 14                	je     800226 <_main+0x1ee>
  800212:	83 ec 04             	sub    $0x4,%esp
  800215:	68 b4 35 80 00       	push   $0x8035b4
  80021a:	6a 3e                	push   $0x3e
  80021c:	68 9c 35 80 00       	push   $0x80359c
  800221:	e8 a7 08 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800226:	e8 88 1f 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80022b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80022e:	74 14                	je     800244 <_main+0x20c>
  800230:	83 ec 04             	sub    $0x4,%esp
  800233:	68 e4 35 80 00       	push   $0x8035e4
  800238:	6a 40                	push   $0x40
  80023a:	68 9c 35 80 00       	push   $0x80359c
  80023f:	e8 89 08 00 00       	call   800acd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800244:	e8 1f 1f 00 00       	call   802168 <sys_calculate_free_frames>
  800249:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024c:	e8 62 1f 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800257:	01 c0                	add    %eax,%eax
  800259:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 13 1b 00 00       	call   801d78 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027b:	01 c8                	add    %ecx,%eax
  80027d:	39 c2                	cmp    %eax,%edx
  80027f:	74 14                	je     800295 <_main+0x25d>
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	68 b4 35 80 00       	push   $0x8035b4
  800289:	6a 46                	push   $0x46
  80028b:	68 9c 35 80 00       	push   $0x80359c
  800290:	e8 38 08 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800295:	e8 19 1f 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80029a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80029d:	74 14                	je     8002b3 <_main+0x27b>
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	68 e4 35 80 00       	push   $0x8035e4
  8002a7:	6a 48                	push   $0x48
  8002a9:	68 9c 35 80 00       	push   $0x80359c
  8002ae:	e8 1a 08 00 00       	call   800acd <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002b3:	e8 b0 1e 00 00       	call   802168 <sys_calculate_free_frames>
  8002b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002bb:	e8 f3 1e 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	01 c0                	add    %eax,%eax
  8002c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 a4 1a 00 00       	call   801d78 <malloc>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[5] != (pagealloc_start + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8002da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e2:	89 d0                	mov    %edx,%eax
  8002e4:	01 c0                	add    %eax,%eax
  8002e6:	01 d0                	add    %edx,%eax
  8002e8:	01 c0                	add    %eax,%eax
  8002ea:	89 c2                	mov    %eax,%edx
  8002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	39 c1                	cmp    %eax,%ecx
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 b4 35 80 00       	push   $0x8035b4
  8002fd:	6a 4e                	push   $0x4e
  8002ff:	68 9c 35 80 00       	push   $0x80359c
  800304:	e8 c4 07 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800309:	e8 a5 1e 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80030e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800311:	74 14                	je     800327 <_main+0x2ef>
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 e4 35 80 00       	push   $0x8035e4
  80031b:	6a 50                	push   $0x50
  80031d:	68 9c 35 80 00       	push   $0x80359c
  800322:	e8 a6 07 00 00       	call   800acd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800327:	e8 3c 1e 00 00       	call   802168 <sys_calculate_free_frames>
  80032c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032f:	e8 7f 1e 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033a:	89 c2                	mov    %eax,%edx
  80033c:	01 d2                	add    %edx,%edx
  80033e:	01 d0                	add    %edx,%eax
  800340:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	50                   	push   %eax
  800347:	e8 2c 1a 00 00       	call   801d78 <malloc>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800352:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800355:	89 c2                	mov    %eax,%edx
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035a:	c1 e0 03             	shl    $0x3,%eax
  80035d:	89 c1                	mov    %eax,%ecx
  80035f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	74 14                	je     80037c <_main+0x344>
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	68 b4 35 80 00       	push   $0x8035b4
  800370:	6a 56                	push   $0x56
  800372:	68 9c 35 80 00       	push   $0x80359c
  800377:	e8 51 07 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80037c:	e8 32 1e 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800381:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 e4 35 80 00       	push   $0x8035e4
  80038e:	6a 58                	push   $0x58
  800390:	68 9c 35 80 00       	push   $0x80359c
  800395:	e8 33 07 00 00       	call   800acd <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80039a:	e8 c9 1d 00 00       	call   802168 <sys_calculate_free_frames>
  80039f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a2:	e8 0c 1e 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8003a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ad:	89 c2                	mov    %eax,%edx
  8003af:	01 d2                	add    %edx,%edx
  8003b1:	01 d0                	add    %edx,%eax
  8003b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	50                   	push   %eax
  8003ba:	e8 b9 19 00 00       	call   801d78 <malloc>
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[7] != (pagealloc_start + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8003c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003c8:	89 c1                	mov    %eax,%ecx
  8003ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8003cd:	89 d0                	mov    %edx,%eax
  8003cf:	c1 e0 02             	shl    $0x2,%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 b4 35 80 00       	push   $0x8035b4
  8003eb:	6a 5e                	push   $0x5e
  8003ed:	68 9c 35 80 00       	push   $0x80359c
  8003f2:	e8 d6 06 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003f7:	e8 b7 1d 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8003fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003ff:	74 14                	je     800415 <_main+0x3dd>
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	68 e4 35 80 00       	push   $0x8035e4
  800409:	6a 60                	push   $0x60
  80040b:	68 9c 35 80 00       	push   $0x80359c
  800410:	e8 b8 06 00 00       	call   800acd <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800415:	e8 4e 1d 00 00       	call   802168 <sys_calculate_free_frames>
  80041a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80041d:	e8 91 1d 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  800425:	8b 45 98             	mov    -0x68(%ebp),%eax
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	50                   	push   %eax
  80042c:	e8 a7 1a 00 00       	call   801ed8 <free>
  800431:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800434:	e8 7a 1d 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800439:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043c:	74 14                	je     800452 <_main+0x41a>
  80043e:	83 ec 04             	sub    $0x4,%esp
  800441:	68 01 36 80 00       	push   $0x803601
  800446:	6a 6a                	push   $0x6a
  800448:	68 9c 35 80 00       	push   $0x80359c
  80044d:	e8 7b 06 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800452:	e8 11 1d 00 00       	call   802168 <sys_calculate_free_frames>
  800457:	89 c2                	mov    %eax,%edx
  800459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	74 14                	je     800474 <_main+0x43c>
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	68 18 36 80 00       	push   $0x803618
  800468:	6a 6b                	push   $0x6b
  80046a:	68 9c 35 80 00       	push   $0x80359c
  80046f:	e8 59 06 00 00       	call   800acd <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800474:	e8 ef 1c 00 00       	call   802168 <sys_calculate_free_frames>
  800479:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047c:	e8 32 1d 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800484:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800487:	83 ec 0c             	sub    $0xc,%esp
  80048a:	50                   	push   %eax
  80048b:	e8 48 1a 00 00       	call   801ed8 <free>
  800490:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800493:	e8 1b 1d 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800498:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 01 36 80 00       	push   $0x803601
  8004a5:	6a 72                	push   $0x72
  8004a7:	68 9c 35 80 00       	push   $0x80359c
  8004ac:	e8 1c 06 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8004b1:	e8 b2 1c 00 00       	call   802168 <sys_calculate_free_frames>
  8004b6:	89 c2                	mov    %eax,%edx
  8004b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004bb:	39 c2                	cmp    %eax,%edx
  8004bd:	74 14                	je     8004d3 <_main+0x49b>
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 18 36 80 00       	push   $0x803618
  8004c7:	6a 73                	push   $0x73
  8004c9:	68 9c 35 80 00       	push   $0x80359c
  8004ce:	e8 fa 05 00 00       	call   800acd <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d3:	e8 90 1c 00 00       	call   802168 <sys_calculate_free_frames>
  8004d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004db:	e8 d3 1c 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8004e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8004e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	50                   	push   %eax
  8004ea:	e8 e9 19 00 00       	call   801ed8 <free>
  8004ef:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004f2:	e8 bc 1c 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	74 14                	je     800510 <_main+0x4d8>
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 01 36 80 00       	push   $0x803601
  800504:	6a 7a                	push   $0x7a
  800506:	68 9c 35 80 00       	push   $0x80359c
  80050b:	e8 bd 05 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800510:	e8 53 1c 00 00       	call   802168 <sys_calculate_free_frames>
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80051a:	39 c2                	cmp    %eax,%edx
  80051c:	74 14                	je     800532 <_main+0x4fa>
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	68 18 36 80 00       	push   $0x803618
  800526:	6a 7b                	push   $0x7b
  800528:	68 9c 35 80 00       	push   $0x80359c
  80052d:	e8 9b 05 00 00       	call   800acd <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800532:	e8 31 1c 00 00       	call   802168 <sys_calculate_free_frames>
  800537:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80053a:	e8 74 1c 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80053f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800542:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800545:	89 d0                	mov    %edx,%eax
  800547:	c1 e0 09             	shl    $0x9,%eax
  80054a:	29 d0                	sub    %edx,%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 23 18 00 00       	call   801d78 <malloc>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80055b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800566:	01 d0                	add    %edx,%eax
  800568:	39 c1                	cmp    %eax,%ecx
  80056a:	74 17                	je     800583 <_main+0x54b>
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 b4 35 80 00       	push   $0x8035b4
  800574:	68 84 00 00 00       	push   $0x84
  800579:	68 9c 35 80 00       	push   $0x80359c
  80057e:	e8 4a 05 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800583:	e8 2b 1c 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800588:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80058b:	74 17                	je     8005a4 <_main+0x56c>
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	68 e4 35 80 00       	push   $0x8035e4
  800595:	68 86 00 00 00       	push   $0x86
  80059a:	68 9c 35 80 00       	push   $0x80359c
  80059f:	e8 29 05 00 00       	call   800acd <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  8005a4:	e8 bf 1b 00 00       	call   802168 <sys_calculate_free_frames>
  8005a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ac:	e8 02 1c 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8005b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8005ba:	83 ec 0c             	sub    $0xc,%esp
  8005bd:	50                   	push   %eax
  8005be:	e8 b5 17 00 00       	call   801d78 <malloc>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8005c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005cc:	89 c2                	mov    %eax,%edx
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d1:	c1 e0 02             	shl    $0x2,%eax
  8005d4:	89 c1                	mov    %eax,%ecx
  8005d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d9:	01 c8                	add    %ecx,%eax
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	74 17                	je     8005f6 <_main+0x5be>
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	68 b4 35 80 00       	push   $0x8035b4
  8005e7:	68 8c 00 00 00       	push   $0x8c
  8005ec:	68 9c 35 80 00       	push   $0x80359c
  8005f1:	e8 d7 04 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8005f6:	e8 b8 1b 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8005fb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005fe:	74 17                	je     800617 <_main+0x5df>
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 e4 35 80 00       	push   $0x8035e4
  800608:	68 8e 00 00 00       	push   $0x8e
  80060d:	68 9c 35 80 00       	push   $0x80359c
  800612:	e8 b6 04 00 00       	call   800acd <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800617:	e8 4c 1b 00 00       	call   802168 <sys_calculate_free_frames>
  80061c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061f:	e8 8f 1b 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800627:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80062a:	89 d0                	mov    %edx,%eax
  80062c:	c1 e0 08             	shl    $0x8,%eax
  80062f:	29 d0                	sub    %edx,%eax
  800631:	83 ec 0c             	sub    $0xc,%esp
  800634:	50                   	push   %eax
  800635:	e8 3e 17 00 00       	call   801d78 <malloc>
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800640:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800643:	89 c1                	mov    %eax,%ecx
  800645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064b:	01 c2                	add    %eax,%edx
  80064d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800650:	c1 e0 09             	shl    $0x9,%eax
  800653:	01 d0                	add    %edx,%eax
  800655:	39 c1                	cmp    %eax,%ecx
  800657:	74 17                	je     800670 <_main+0x638>
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	68 b4 35 80 00       	push   $0x8035b4
  800661:	68 94 00 00 00       	push   $0x94
  800666:	68 9c 35 80 00       	push   $0x80359c
  80066b:	e8 5d 04 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800670:	e8 3e 1b 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800675:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800678:	74 17                	je     800691 <_main+0x659>
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	68 e4 35 80 00       	push   $0x8035e4
  800682:	68 96 00 00 00       	push   $0x96
  800687:	68 9c 35 80 00       	push   $0x80359c
  80068c:	e8 3c 04 00 00       	call   800acd <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800691:	e8 d2 1a 00 00       	call   802168 <sys_calculate_free_frames>
  800696:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800699:	e8 15 1b 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	01 c0                	add    %eax,%eax
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	50                   	push   %eax
  8006aa:	e8 c9 16 00 00       	call   801d78 <malloc>
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8006b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006b8:	89 c2                	mov    %eax,%edx
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	c1 e0 03             	shl    $0x3,%eax
  8006c0:	89 c1                	mov    %eax,%ecx
  8006c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c5:	01 c8                	add    %ecx,%eax
  8006c7:	39 c2                	cmp    %eax,%edx
  8006c9:	74 17                	je     8006e2 <_main+0x6aa>
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	68 b4 35 80 00       	push   $0x8035b4
  8006d3:	68 9c 00 00 00       	push   $0x9c
  8006d8:	68 9c 35 80 00       	push   $0x80359c
  8006dd:	e8 eb 03 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e2:	e8 cc 1a 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8006e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006ea:	74 17                	je     800703 <_main+0x6cb>
  8006ec:	83 ec 04             	sub    $0x4,%esp
  8006ef:	68 e4 35 80 00       	push   $0x8035e4
  8006f4:	68 9e 00 00 00       	push   $0x9e
  8006f9:	68 9c 35 80 00       	push   $0x80359c
  8006fe:	e8 ca 03 00 00       	call   800acd <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800703:	e8 60 1a 00 00       	call   802168 <sys_calculate_free_frames>
  800708:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80070b:	e8 a3 1a 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800716:	c1 e0 02             	shl    $0x2,%eax
  800719:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	50                   	push   %eax
  800720:	e8 53 16 00 00       	call   801d78 <malloc>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80072b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80072e:	89 c1                	mov    %eax,%ecx
  800730:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800733:	89 d0                	mov    %edx,%eax
  800735:	01 c0                	add    %eax,%eax
  800737:	01 d0                	add    %edx,%eax
  800739:	01 c0                	add    %eax,%eax
  80073b:	01 d0                	add    %edx,%eax
  80073d:	01 c0                	add    %eax,%eax
  80073f:	89 c2                	mov    %eax,%edx
  800741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800744:	01 d0                	add    %edx,%eax
  800746:	39 c1                	cmp    %eax,%ecx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	68 b4 35 80 00       	push   $0x8035b4
  800752:	68 a4 00 00 00       	push   $0xa4
  800757:	68 9c 35 80 00       	push   $0x80359c
  80075c:	e8 6c 03 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800761:	e8 4d 1a 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800766:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800769:	74 17                	je     800782 <_main+0x74a>
  80076b:	83 ec 04             	sub    $0x4,%esp
  80076e:	68 e4 35 80 00       	push   $0x8035e4
  800773:	68 a6 00 00 00       	push   $0xa6
  800778:	68 9c 35 80 00       	push   $0x80359c
  80077d:	e8 4b 03 00 00       	call   800acd <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800782:	e8 e1 19 00 00       	call   802168 <sys_calculate_free_frames>
  800787:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80078a:	e8 24 1a 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80078f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[2]);
  800792:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 3a 17 00 00       	call   801ed8 <free>
  80079e:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8007a1:	e8 0d 1a 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8007a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007a9:	74 17                	je     8007c2 <_main+0x78a>
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	68 01 36 80 00       	push   $0x803601
  8007b3:	68 b0 00 00 00       	push   $0xb0
  8007b8:	68 9c 35 80 00       	push   $0x80359c
  8007bd:	e8 0b 03 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8007c2:	e8 a1 19 00 00       	call   802168 <sys_calculate_free_frames>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007cc:	39 c2                	cmp    %eax,%edx
  8007ce:	74 17                	je     8007e7 <_main+0x7af>
  8007d0:	83 ec 04             	sub    $0x4,%esp
  8007d3:	68 18 36 80 00       	push   $0x803618
  8007d8:	68 b1 00 00 00       	push   $0xb1
  8007dd:	68 9c 35 80 00       	push   $0x80359c
  8007e2:	e8 e6 02 00 00       	call   800acd <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 7c 19 00 00       	call   802168 <sys_calculate_free_frames>
  8007ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 bf 19 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  8007f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 d5 16 00 00       	call   801ed8 <free>
  800803:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800806:	e8 a8 19 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80080b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80080e:	74 17                	je     800827 <_main+0x7ef>
  800810:	83 ec 04             	sub    $0x4,%esp
  800813:	68 01 36 80 00       	push   $0x803601
  800818:	68 b8 00 00 00       	push   $0xb8
  80081d:	68 9c 35 80 00       	push   $0x80359c
  800822:	e8 a6 02 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800827:	e8 3c 19 00 00       	call   802168 <sys_calculate_free_frames>
  80082c:	89 c2                	mov    %eax,%edx
  80082e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800831:	39 c2                	cmp    %eax,%edx
  800833:	74 17                	je     80084c <_main+0x814>
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	68 18 36 80 00       	push   $0x803618
  80083d:	68 b9 00 00 00       	push   $0xb9
  800842:	68 9c 35 80 00       	push   $0x80359c
  800847:	e8 81 02 00 00       	call   800acd <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  80084c:	e8 17 19 00 00       	call   802168 <sys_calculate_free_frames>
  800851:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800854:	e8 5a 19 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[3]);
  80085c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	50                   	push   %eax
  800863:	e8 70 16 00 00       	call   801ed8 <free>
  800868:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80086b:	e8 43 19 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  800870:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800873:	74 17                	je     80088c <_main+0x854>
  800875:	83 ec 04             	sub    $0x4,%esp
  800878:	68 01 36 80 00       	push   $0x803601
  80087d:	68 c0 00 00 00       	push   $0xc0
  800882:	68 9c 35 80 00       	push   $0x80359c
  800887:	e8 41 02 00 00       	call   800acd <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80088c:	e8 d7 18 00 00       	call   802168 <sys_calculate_free_frames>
  800891:	89 c2                	mov    %eax,%edx
  800893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800896:	39 c2                	cmp    %eax,%edx
  800898:	74 17                	je     8008b1 <_main+0x879>
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 18 36 80 00       	push   $0x803618
  8008a2:	68 c1 00 00 00       	push   $0xc1
  8008a7:	68 9c 35 80 00       	push   $0x80359c
  8008ac:	e8 1c 02 00 00       	call   800acd <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8008b1:	e8 b2 18 00 00       	call   802168 <sys_calculate_free_frames>
  8008b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008b9:	e8 f5 18 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  8008be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c1 e0 06             	shl    $0x6,%eax
  8008c7:	89 c2                	mov    %eax,%edx
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	01 d0                	add    %edx,%eax
  8008ce:	c1 e0 02             	shl    $0x2,%eax
  8008d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	50                   	push   %eax
  8008d8:	e8 9b 14 00 00       	call   801d78 <malloc>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  8008e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008e6:	89 c1                	mov    %eax,%ecx
  8008e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ee:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8008f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f4:	89 d0                	mov    %edx,%eax
  8008f6:	01 c0                	add    %eax,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	c1 e0 08             	shl    $0x8,%eax
  8008fd:	01 d8                	add    %ebx,%eax
  8008ff:	39 c1                	cmp    %eax,%ecx
  800901:	74 17                	je     80091a <_main+0x8e2>
  800903:	83 ec 04             	sub    $0x4,%esp
  800906:	68 b4 35 80 00       	push   $0x8035b4
  80090b:	68 cb 00 00 00       	push   $0xcb
  800910:	68 9c 35 80 00       	push   $0x80359c
  800915:	e8 b3 01 00 00       	call   800acd <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80091a:	e8 94 18 00 00       	call   8021b3 <sys_pf_calculate_allocated_pages>
  80091f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800922:	74 17                	je     80093b <_main+0x903>
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 e4 35 80 00       	push   $0x8035e4
  80092c:	68 cd 00 00 00       	push   $0xcd
  800931:	68 9c 35 80 00       	push   $0x80359c
  800936:	e8 92 01 00 00       	call   800acd <_panic>
	//[6] Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - pagealloc_start - 18*Mega + 1));
  80093b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	c1 e0 03             	shl    $0x3,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	01 c0                	add    %eax,%eax
  800947:	f7 d8                	neg    %eax
  800949:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80094c:	2d ff ff ff 5f       	sub    $0x5fffffff,%eax
  800951:	83 ec 0c             	sub    $0xc,%esp
  800954:	50                   	push   %eax
  800955:	e8 1e 14 00 00       	call   801d78 <malloc>
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  800960:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800963:	85 c0                	test   %eax,%eax
  800965:	74 17                	je     80097e <_main+0x946>
  800967:	83 ec 04             	sub    $0x4,%esp
  80096a:	68 28 36 80 00       	push   $0x803628
  80096f:	68 d6 00 00 00       	push   $0xd6
  800974:	68 9c 35 80 00       	push   $0x80359c
  800979:	e8 4f 01 00 00       	call   800acd <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT (1) [PAGE ALLOCATOR] completed successfully.\n");
  80097e:	83 ec 0c             	sub    $0xc,%esp
  800981:	68 8c 36 80 00       	push   $0x80368c
  800986:	e8 ff 03 00 00       	call   800d8a <cprintf>
  80098b:	83 c4 10             	add    $0x10,%esp

	return;
  80098e:	90                   	nop
}
  80098f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800992:	5b                   	pop    %ebx
  800993:	5f                   	pop    %edi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80099c:	e8 52 1a 00 00       	call   8023f3 <sys_getenvindex>
  8009a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8009a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a7:	89 d0                	mov    %edx,%eax
  8009a9:	c1 e0 03             	shl    $0x3,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	c1 e0 04             	shl    $0x4,%eax
  8009be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009c3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8009cd:	8a 40 5c             	mov    0x5c(%eax),%al
  8009d0:	84 c0                	test   %al,%al
  8009d2:	74 0d                	je     8009e1 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8009d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8009d9:	83 c0 5c             	add    $0x5c,%eax
  8009dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009e5:	7e 0a                	jle    8009f1 <libmain+0x5b>
		binaryname = argv[0];
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	e8 39 f6 ff ff       	call   800038 <_main>
  8009ff:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800a02:	e8 f9 17 00 00       	call   802200 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 f4 36 80 00       	push   $0x8036f4
  800a0f:	e8 76 03 00 00       	call   800d8a <cprintf>
  800a14:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a17:	a1 20 40 80 00       	mov    0x804020,%eax
  800a1c:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800a22:	a1 20 40 80 00       	mov    0x804020,%eax
  800a27:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	52                   	push   %edx
  800a31:	50                   	push   %eax
  800a32:	68 1c 37 80 00       	push   $0x80371c
  800a37:	e8 4e 03 00 00       	call   800d8a <cprintf>
  800a3c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a3f:	a1 20 40 80 00       	mov    0x804020,%eax
  800a44:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800a4a:	a1 20 40 80 00       	mov    0x804020,%eax
  800a4f:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800a55:	a1 20 40 80 00       	mov    0x804020,%eax
  800a5a:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800a60:	51                   	push   %ecx
  800a61:	52                   	push   %edx
  800a62:	50                   	push   %eax
  800a63:	68 44 37 80 00       	push   $0x803744
  800a68:	e8 1d 03 00 00       	call   800d8a <cprintf>
  800a6d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a70:	a1 20 40 80 00       	mov    0x804020,%eax
  800a75:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	50                   	push   %eax
  800a7f:	68 9c 37 80 00       	push   $0x80379c
  800a84:	e8 01 03 00 00       	call   800d8a <cprintf>
  800a89:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	68 f4 36 80 00       	push   $0x8036f4
  800a94:	e8 f1 02 00 00       	call   800d8a <cprintf>
  800a99:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a9c:	e8 79 17 00 00       	call   80221a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800aa1:	e8 19 00 00 00       	call   800abf <exit>
}
  800aa6:	90                   	nop
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800aaf:	83 ec 0c             	sub    $0xc,%esp
  800ab2:	6a 00                	push   $0x0
  800ab4:	e8 06 19 00 00       	call   8023bf <sys_destroy_env>
  800ab9:	83 c4 10             	add    $0x10,%esp
}
  800abc:	90                   	nop
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <exit>:

void
exit(void)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ac5:	e8 5b 19 00 00       	call   802425 <sys_exit_env>
}
  800aca:	90                   	nop
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ad3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800adc:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800ae1:	85 c0                	test   %eax,%eax
  800ae3:	74 16                	je     800afb <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ae5:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	68 b0 37 80 00       	push   $0x8037b0
  800af3:	e8 92 02 00 00       	call   800d8a <cprintf>
  800af8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800afb:	a1 00 40 80 00       	mov    0x804000,%eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	50                   	push   %eax
  800b07:	68 b5 37 80 00       	push   $0x8037b5
  800b0c:	e8 79 02 00 00       	call   800d8a <cprintf>
  800b11:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1d:	50                   	push   %eax
  800b1e:	e8 fc 01 00 00       	call   800d1f <vcprintf>
  800b23:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	6a 00                	push   $0x0
  800b2b:	68 d1 37 80 00       	push   $0x8037d1
  800b30:	e8 ea 01 00 00       	call   800d1f <vcprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b38:	e8 82 ff ff ff       	call   800abf <exit>

	// should not return here
	while (1) ;
  800b3d:	eb fe                	jmp    800b3d <_panic+0x70>

00800b3f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b45:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4a:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	39 c2                	cmp    %eax,%edx
  800b55:	74 14                	je     800b6b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b57:	83 ec 04             	sub    $0x4,%esp
  800b5a:	68 d4 37 80 00       	push   $0x8037d4
  800b5f:	6a 26                	push   $0x26
  800b61:	68 20 38 80 00       	push   $0x803820
  800b66:	e8 62 ff ff ff       	call   800acd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b79:	e9 c5 00 00 00       	jmp    800c43 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	01 d0                	add    %edx,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	75 08                	jne    800b9b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b93:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b96:	e9 a5 00 00 00       	jmp    800c40 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ba2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ba9:	eb 69                	jmp    800c14 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800bab:	a1 20 40 80 00       	mov    0x804020,%eax
  800bb0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bb9:	89 d0                	mov    %edx,%eax
  800bbb:	01 c0                	add    %eax,%eax
  800bbd:	01 d0                	add    %edx,%eax
  800bbf:	c1 e0 03             	shl    $0x3,%eax
  800bc2:	01 c8                	add    %ecx,%eax
  800bc4:	8a 40 04             	mov    0x4(%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 46                	jne    800c11 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bcb:	a1 20 40 80 00       	mov    0x804020,%eax
  800bd0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800bd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bd9:	89 d0                	mov    %edx,%eax
  800bdb:	01 c0                	add    %eax,%eax
  800bdd:	01 d0                	add    %edx,%eax
  800bdf:	c1 e0 03             	shl    $0x3,%eax
  800be2:	01 c8                	add    %ecx,%eax
  800be4:	8b 00                	mov    (%eax),%eax
  800be6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bf1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	01 c8                	add    %ecx,%eax
  800c02:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	75 09                	jne    800c11 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800c08:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800c0f:	eb 15                	jmp    800c26 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c11:	ff 45 e8             	incl   -0x18(%ebp)
  800c14:	a1 20 40 80 00       	mov    0x804020,%eax
  800c19:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c22:	39 c2                	cmp    %eax,%edx
  800c24:	77 85                	ja     800bab <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c2a:	75 14                	jne    800c40 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 2c 38 80 00       	push   $0x80382c
  800c34:	6a 3a                	push   $0x3a
  800c36:	68 20 38 80 00       	push   $0x803820
  800c3b:	e8 8d fe ff ff       	call   800acd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c40:	ff 45 f0             	incl   -0x10(%ebp)
  800c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c46:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c49:	0f 8c 2f ff ff ff    	jl     800b7e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c5d:	eb 26                	jmp    800c85 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c5f:	a1 20 40 80 00       	mov    0x804020,%eax
  800c64:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800c6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6d:	89 d0                	mov    %edx,%eax
  800c6f:	01 c0                	add    %eax,%eax
  800c71:	01 d0                	add    %edx,%eax
  800c73:	c1 e0 03             	shl    $0x3,%eax
  800c76:	01 c8                	add    %ecx,%eax
  800c78:	8a 40 04             	mov    0x4(%eax),%al
  800c7b:	3c 01                	cmp    $0x1,%al
  800c7d:	75 03                	jne    800c82 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c7f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c82:	ff 45 e0             	incl   -0x20(%ebp)
  800c85:	a1 20 40 80 00       	mov    0x804020,%eax
  800c8a:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c93:	39 c2                	cmp    %eax,%edx
  800c95:	77 c8                	ja     800c5f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c9a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c9d:	74 14                	je     800cb3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	68 80 38 80 00       	push   $0x803880
  800ca7:	6a 44                	push   $0x44
  800ca9:	68 20 38 80 00       	push   $0x803820
  800cae:	e8 1a fe ff ff       	call   800acd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800cb3:	90                   	nop
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	89 0a                	mov    %ecx,(%edx)
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	88 d1                	mov    %dl,%cl
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cdf:	75 2c                	jne    800d0d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ce1:	a0 24 40 80 00       	mov    0x804024,%al
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cec:	8b 12                	mov    (%edx),%edx
  800cee:	89 d1                	mov    %edx,%ecx
  800cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf3:	83 c2 08             	add    $0x8,%edx
  800cf6:	83 ec 04             	sub    $0x4,%esp
  800cf9:	50                   	push   %eax
  800cfa:	51                   	push   %ecx
  800cfb:	52                   	push   %edx
  800cfc:	e8 a6 13 00 00       	call   8020a7 <sys_cputs>
  800d01:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 40 04             	mov    0x4(%eax),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d1c:	90                   	nop
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d28:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d2f:	00 00 00 
	b.cnt = 0;
  800d32:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d39:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	ff 75 08             	pushl  0x8(%ebp)
  800d42:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d48:	50                   	push   %eax
  800d49:	68 b6 0c 80 00       	push   $0x800cb6
  800d4e:	e8 11 02 00 00       	call   800f64 <vprintfmt>
  800d53:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d56:	a0 24 40 80 00       	mov    0x804024,%al
  800d5b:	0f b6 c0             	movzbl %al,%eax
  800d5e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d64:	83 ec 04             	sub    $0x4,%esp
  800d67:	50                   	push   %eax
  800d68:	52                   	push   %edx
  800d69:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d6f:	83 c0 08             	add    $0x8,%eax
  800d72:	50                   	push   %eax
  800d73:	e8 2f 13 00 00       	call   8020a7 <sys_cputs>
  800d78:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d7b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800d82:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <cprintf>:

int cprintf(const char *fmt, ...) {
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d90:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800d97:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	83 ec 08             	sub    $0x8,%esp
  800da3:	ff 75 f4             	pushl  -0xc(%ebp)
  800da6:	50                   	push   %eax
  800da7:	e8 73 ff ff ff       	call   800d1f <vcprintf>
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800dbd:	e8 3e 14 00 00       	call   802200 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800dc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd1:	50                   	push   %eax
  800dd2:	e8 48 ff ff ff       	call   800d1f <vcprintf>
  800dd7:	83 c4 10             	add    $0x10,%esp
  800dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ddd:	e8 38 14 00 00       	call   80221a <sys_enable_interrupt>
	return cnt;
  800de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	53                   	push   %ebx
  800deb:	83 ec 14             	sub    $0x14,%esp
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df4:	8b 45 14             	mov    0x14(%ebp),%eax
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dfa:	8b 45 18             	mov    0x18(%ebp),%eax
  800dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800e02:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e05:	77 55                	ja     800e5c <printnum+0x75>
  800e07:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e0a:	72 05                	jb     800e11 <printnum+0x2a>
  800e0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e0f:	77 4b                	ja     800e5c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e11:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e14:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e17:	8b 45 18             	mov    0x18(%ebp),%eax
  800e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1f:	52                   	push   %edx
  800e20:	50                   	push   %eax
  800e21:	ff 75 f4             	pushl  -0xc(%ebp)
  800e24:	ff 75 f0             	pushl  -0x10(%ebp)
  800e27:	e8 e8 24 00 00       	call   803314 <__udivdi3>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	83 ec 04             	sub    $0x4,%esp
  800e32:	ff 75 20             	pushl  0x20(%ebp)
  800e35:	53                   	push   %ebx
  800e36:	ff 75 18             	pushl  0x18(%ebp)
  800e39:	52                   	push   %edx
  800e3a:	50                   	push   %eax
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	ff 75 08             	pushl  0x8(%ebp)
  800e41:	e8 a1 ff ff ff       	call   800de7 <printnum>
  800e46:	83 c4 20             	add    $0x20,%esp
  800e49:	eb 1a                	jmp    800e65 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e4b:	83 ec 08             	sub    $0x8,%esp
  800e4e:	ff 75 0c             	pushl  0xc(%ebp)
  800e51:	ff 75 20             	pushl  0x20(%ebp)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e5c:	ff 4d 1c             	decl   0x1c(%ebp)
  800e5f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e63:	7f e6                	jg     800e4b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e65:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e73:	53                   	push   %ebx
  800e74:	51                   	push   %ecx
  800e75:	52                   	push   %edx
  800e76:	50                   	push   %eax
  800e77:	e8 a8 25 00 00       	call   803424 <__umoddi3>
  800e7c:	83 c4 10             	add    $0x10,%esp
  800e7f:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f be c0             	movsbl %al,%eax
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	50                   	push   %eax
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	ff d0                	call   *%eax
  800e95:	83 c4 10             	add    $0x10,%esp
}
  800e98:	90                   	nop
  800e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ea1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ea5:	7e 1c                	jle    800ec3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8b 00                	mov    (%eax),%eax
  800eac:	8d 50 08             	lea    0x8(%eax),%edx
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	89 10                	mov    %edx,(%eax)
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 e8 08             	sub    $0x8,%eax
  800ebc:	8b 50 04             	mov    0x4(%eax),%edx
  800ebf:	8b 00                	mov    (%eax),%eax
  800ec1:	eb 40                	jmp    800f03 <getuint+0x65>
	else if (lflag)
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	74 1e                	je     800ee7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 00                	mov    (%eax),%eax
  800ece:	8d 50 04             	lea    0x4(%eax),%edx
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 10                	mov    %edx,(%eax)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8b 00                	mov    (%eax),%eax
  800edb:	83 e8 04             	sub    $0x4,%eax
  800ede:	8b 00                	mov    (%eax),%eax
  800ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee5:	eb 1c                	jmp    800f03 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8b 00                	mov    (%eax),%eax
  800eec:	8d 50 04             	lea    0x4(%eax),%edx
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	89 10                	mov    %edx,(%eax)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8b 00                	mov    (%eax),%eax
  800ef9:	83 e8 04             	sub    $0x4,%eax
  800efc:	8b 00                	mov    (%eax),%eax
  800efe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f08:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f0c:	7e 1c                	jle    800f2a <getint+0x25>
		return va_arg(*ap, long long);
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 50 08             	lea    0x8(%eax),%edx
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	89 10                	mov    %edx,(%eax)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8b 00                	mov    (%eax),%eax
  800f20:	83 e8 08             	sub    $0x8,%eax
  800f23:	8b 50 04             	mov    0x4(%eax),%edx
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	eb 38                	jmp    800f62 <getint+0x5d>
	else if (lflag)
  800f2a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2e:	74 1a                	je     800f4a <getint+0x45>
		return va_arg(*ap, long);
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8b 00                	mov    (%eax),%eax
  800f35:	8d 50 04             	lea    0x4(%eax),%edx
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 10                	mov    %edx,(%eax)
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	83 e8 04             	sub    $0x4,%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	99                   	cltd   
  800f48:	eb 18                	jmp    800f62 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	8d 50 04             	lea    0x4(%eax),%edx
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	89 10                	mov    %edx,(%eax)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	83 e8 04             	sub    $0x4,%eax
  800f5f:	8b 00                	mov    (%eax),%eax
  800f61:	99                   	cltd   
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f6c:	eb 17                	jmp    800f85 <vprintfmt+0x21>
			if (ch == '\0')
  800f6e:	85 db                	test   %ebx,%ebx
  800f70:	0f 84 af 03 00 00    	je     801325 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	53                   	push   %ebx
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	ff d0                	call   *%eax
  800f82:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	0f b6 d8             	movzbl %al,%ebx
  800f93:	83 fb 25             	cmp    $0x25,%ebx
  800f96:	75 d6                	jne    800f6e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f98:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f9c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fa3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800faa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fb1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 01             	lea    0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d8             	movzbl %al,%ebx
  800fc6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fc9:	83 f8 55             	cmp    $0x55,%eax
  800fcc:	0f 87 2b 03 00 00    	ja     8012fd <vprintfmt+0x399>
  800fd2:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  800fd9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fdb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fdf:	eb d7                	jmp    800fb8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fe1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fe5:	eb d1                	jmp    800fb8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fe7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ff1:	89 d0                	mov    %edx,%eax
  800ff3:	c1 e0 02             	shl    $0x2,%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	01 c0                	add    %eax,%eax
  800ffa:	01 d8                	add    %ebx,%eax
  800ffc:	83 e8 30             	sub    $0x30,%eax
  800fff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80100a:	83 fb 2f             	cmp    $0x2f,%ebx
  80100d:	7e 3e                	jle    80104d <vprintfmt+0xe9>
  80100f:	83 fb 39             	cmp    $0x39,%ebx
  801012:	7f 39                	jg     80104d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801014:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801017:	eb d5                	jmp    800fee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 14             	mov    %eax,0x14(%ebp)
  801022:	8b 45 14             	mov    0x14(%ebp),%eax
  801025:	83 e8 04             	sub    $0x4,%eax
  801028:	8b 00                	mov    (%eax),%eax
  80102a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80102d:	eb 1f                	jmp    80104e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80102f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801033:	79 83                	jns    800fb8 <vprintfmt+0x54>
				width = 0;
  801035:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80103c:	e9 77 ff ff ff       	jmp    800fb8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801041:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801048:	e9 6b ff ff ff       	jmp    800fb8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80104d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80104e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801052:	0f 89 60 ff ff ff    	jns    800fb8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80105e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801065:	e9 4e ff ff ff       	jmp    800fb8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80106a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80106d:	e9 46 ff ff ff       	jmp    800fb8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801072:	8b 45 14             	mov    0x14(%ebp),%eax
  801075:	83 c0 04             	add    $0x4,%eax
  801078:	89 45 14             	mov    %eax,0x14(%ebp)
  80107b:	8b 45 14             	mov    0x14(%ebp),%eax
  80107e:	83 e8 04             	sub    $0x4,%eax
  801081:	8b 00                	mov    (%eax),%eax
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	50                   	push   %eax
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	ff d0                	call   *%eax
  80108f:	83 c4 10             	add    $0x10,%esp
			break;
  801092:	e9 89 02 00 00       	jmp    801320 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801097:	8b 45 14             	mov    0x14(%ebp),%eax
  80109a:	83 c0 04             	add    $0x4,%eax
  80109d:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a3:	83 e8 04             	sub    $0x4,%eax
  8010a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010a8:	85 db                	test   %ebx,%ebx
  8010aa:	79 02                	jns    8010ae <vprintfmt+0x14a>
				err = -err;
  8010ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010ae:	83 fb 64             	cmp    $0x64,%ebx
  8010b1:	7f 0b                	jg     8010be <vprintfmt+0x15a>
  8010b3:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8010ba:	85 f6                	test   %esi,%esi
  8010bc:	75 19                	jne    8010d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010be:	53                   	push   %ebx
  8010bf:	68 05 3b 80 00       	push   $0x803b05
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	e8 5e 02 00 00       	call   80132d <printfmt>
  8010cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010d2:	e9 49 02 00 00       	jmp    801320 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010d7:	56                   	push   %esi
  8010d8:	68 0e 3b 80 00       	push   $0x803b0e
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 45 02 00 00       	call   80132d <printfmt>
  8010e8:	83 c4 10             	add    $0x10,%esp
			break;
  8010eb:	e9 30 02 00 00       	jmp    801320 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	83 c0 04             	add    $0x4,%eax
  8010f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8010f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fc:	83 e8 04             	sub    $0x4,%eax
  8010ff:	8b 30                	mov    (%eax),%esi
  801101:	85 f6                	test   %esi,%esi
  801103:	75 05                	jne    80110a <vprintfmt+0x1a6>
				p = "(null)";
  801105:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  80110a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80110e:	7e 6d                	jle    80117d <vprintfmt+0x219>
  801110:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801114:	74 67                	je     80117d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801116:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	50                   	push   %eax
  80111d:	56                   	push   %esi
  80111e:	e8 0c 03 00 00       	call   80142f <strnlen>
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801129:	eb 16                	jmp    801141 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80112b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	50                   	push   %eax
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	ff d0                	call   *%eax
  80113b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80113e:	ff 4d e4             	decl   -0x1c(%ebp)
  801141:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801145:	7f e4                	jg     80112b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801147:	eb 34                	jmp    80117d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801149:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80114d:	74 1c                	je     80116b <vprintfmt+0x207>
  80114f:	83 fb 1f             	cmp    $0x1f,%ebx
  801152:	7e 05                	jle    801159 <vprintfmt+0x1f5>
  801154:	83 fb 7e             	cmp    $0x7e,%ebx
  801157:	7e 12                	jle    80116b <vprintfmt+0x207>
					putch('?', putdat);
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	ff 75 0c             	pushl  0xc(%ebp)
  80115f:	6a 3f                	push   $0x3f
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	ff d0                	call   *%eax
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	eb 0f                	jmp    80117a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	53                   	push   %ebx
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	ff d0                	call   *%eax
  801177:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80117a:	ff 4d e4             	decl   -0x1c(%ebp)
  80117d:	89 f0                	mov    %esi,%eax
  80117f:	8d 70 01             	lea    0x1(%eax),%esi
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f be d8             	movsbl %al,%ebx
  801187:	85 db                	test   %ebx,%ebx
  801189:	74 24                	je     8011af <vprintfmt+0x24b>
  80118b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80118f:	78 b8                	js     801149 <vprintfmt+0x1e5>
  801191:	ff 4d e0             	decl   -0x20(%ebp)
  801194:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801198:	79 af                	jns    801149 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80119a:	eb 13                	jmp    8011af <vprintfmt+0x24b>
				putch(' ', putdat);
  80119c:	83 ec 08             	sub    $0x8,%esp
  80119f:	ff 75 0c             	pushl  0xc(%ebp)
  8011a2:	6a 20                	push   $0x20
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	ff d0                	call   *%eax
  8011a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8011af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011b3:	7f e7                	jg     80119c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011b5:	e9 66 01 00 00       	jmp    801320 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8011c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011c3:	50                   	push   %eax
  8011c4:	e8 3c fd ff ff       	call   800f05 <getint>
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d8:	85 d2                	test   %edx,%edx
  8011da:	79 23                	jns    8011ff <vprintfmt+0x29b>
				putch('-', putdat);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	6a 2d                	push   $0x2d
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	ff d0                	call   *%eax
  8011e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f2:	f7 d8                	neg    %eax
  8011f4:	83 d2 00             	adc    $0x0,%edx
  8011f7:	f7 da                	neg    %edx
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801206:	e9 bc 00 00 00       	jmp    8012c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	ff 75 e8             	pushl  -0x18(%ebp)
  801211:	8d 45 14             	lea    0x14(%ebp),%eax
  801214:	50                   	push   %eax
  801215:	e8 84 fc ff ff       	call   800e9e <getuint>
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801220:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801223:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80122a:	e9 98 00 00 00       	jmp    8012c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	6a 58                	push   $0x58
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	ff d0                	call   *%eax
  80123c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	6a 58                	push   $0x58
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	ff d0                	call   *%eax
  80124c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80124f:	83 ec 08             	sub    $0x8,%esp
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	6a 58                	push   $0x58
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	ff d0                	call   *%eax
  80125c:	83 c4 10             	add    $0x10,%esp
			break;
  80125f:	e9 bc 00 00 00       	jmp    801320 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801264:	83 ec 08             	sub    $0x8,%esp
  801267:	ff 75 0c             	pushl  0xc(%ebp)
  80126a:	6a 30                	push   $0x30
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	ff d0                	call   *%eax
  801271:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	ff 75 0c             	pushl  0xc(%ebp)
  80127a:	6a 78                	push   $0x78
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801284:	8b 45 14             	mov    0x14(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 14             	mov    %eax,0x14(%ebp)
  80128d:	8b 45 14             	mov    0x14(%ebp),%eax
  801290:	83 e8 04             	sub    $0x4,%eax
  801293:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801295:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012a6:	eb 1f                	jmp    8012c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012a8:	83 ec 08             	sub    $0x8,%esp
  8012ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8012ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	e8 e7 fb ff ff       	call   800e9e <getuint>
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	52                   	push   %edx
  8012d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d5:	50                   	push   %eax
  8012d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	ff 75 08             	pushl  0x8(%ebp)
  8012e2:	e8 00 fb ff ff       	call   800de7 <printnum>
  8012e7:	83 c4 20             	add    $0x20,%esp
			break;
  8012ea:	eb 34                	jmp    801320 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	53                   	push   %ebx
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
			break;
  8012fb:	eb 23                	jmp    801320 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	6a 25                	push   $0x25
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	ff d0                	call   *%eax
  80130a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80130d:	ff 4d 10             	decl   0x10(%ebp)
  801310:	eb 03                	jmp    801315 <vprintfmt+0x3b1>
  801312:	ff 4d 10             	decl   0x10(%ebp)
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	48                   	dec    %eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	3c 25                	cmp    $0x25,%al
  80131d:	75 f3                	jne    801312 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80131f:	90                   	nop
		}
	}
  801320:	e9 47 fc ff ff       	jmp    800f6c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801325:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801326:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801333:	8d 45 10             	lea    0x10(%ebp),%eax
  801336:	83 c0 04             	add    $0x4,%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	ff 75 f4             	pushl  -0xc(%ebp)
  801342:	50                   	push   %eax
  801343:	ff 75 0c             	pushl  0xc(%ebp)
  801346:	ff 75 08             	pushl  0x8(%ebp)
  801349:	e8 16 fc ff ff       	call   800f64 <vprintfmt>
  80134e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	8b 40 08             	mov    0x8(%eax),%eax
  80135d:	8d 50 01             	lea    0x1(%eax),%edx
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	8b 10                	mov    (%eax),%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	8b 40 04             	mov    0x4(%eax),%eax
  801371:	39 c2                	cmp    %eax,%edx
  801373:	73 12                	jae    801387 <sprintputch+0x33>
		*b->buf++ = ch;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	8d 48 01             	lea    0x1(%eax),%ecx
  80137d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801380:	89 0a                	mov    %ecx,(%edx)
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	88 10                	mov    %dl,(%eax)
}
  801387:	90                   	nop
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	01 d0                	add    %edx,%eax
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013af:	74 06                	je     8013b7 <vsnprintf+0x2d>
  8013b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013b5:	7f 07                	jg     8013be <vsnprintf+0x34>
		return -E_INVAL;
  8013b7:	b8 03 00 00 00       	mov    $0x3,%eax
  8013bc:	eb 20                	jmp    8013de <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013be:	ff 75 14             	pushl  0x14(%ebp)
  8013c1:	ff 75 10             	pushl  0x10(%ebp)
  8013c4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	68 54 13 80 00       	push   $0x801354
  8013cd:	e8 92 fb ff ff       	call   800f64 <vprintfmt>
  8013d2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8013e9:	83 c0 04             	add    $0x4,%eax
  8013ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	ff 75 08             	pushl  0x8(%ebp)
  8013fc:	e8 89 ff ff ff       	call   80138a <vsnprintf>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801419:	eb 06                	jmp    801421 <strlen+0x15>
		n++;
  80141b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	84 c0                	test   %al,%al
  801428:	75 f1                	jne    80141b <strlen+0xf>
		n++;
	return n;
  80142a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143c:	eb 09                	jmp    801447 <strnlen+0x18>
		n++;
  80143e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801441:	ff 45 08             	incl   0x8(%ebp)
  801444:	ff 4d 0c             	decl   0xc(%ebp)
  801447:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80144b:	74 09                	je     801456 <strnlen+0x27>
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	84 c0                	test   %al,%al
  801454:	75 e8                	jne    80143e <strnlen+0xf>
		n++;
	return n;
  801456:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801467:	90                   	nop
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8d 50 01             	lea    0x1(%eax),%edx
  80146e:	89 55 08             	mov    %edx,0x8(%ebp)
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8d 4a 01             	lea    0x1(%edx),%ecx
  801477:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80147a:	8a 12                	mov    (%edx),%dl
  80147c:	88 10                	mov    %dl,(%eax)
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	75 e4                	jne    801468 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801484:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80149c:	eb 1f                	jmp    8014bd <strncpy+0x34>
		*dst++ = *src;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	8d 50 01             	lea    0x1(%eax),%edx
  8014a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	8a 12                	mov    (%edx),%dl
  8014ac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 03                	je     8014ba <strncpy+0x31>
			src++;
  8014b7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ba:	ff 45 fc             	incl   -0x4(%ebp)
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c3:	72 d9                	jb     80149e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 30                	je     80150c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014dc:	eb 16                	jmp    8014f4 <strlcpy+0x2a>
			*dst++ = *src++;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8d 50 01             	lea    0x1(%eax),%edx
  8014e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f0:	8a 12                	mov    (%edx),%dl
  8014f2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014f4:	ff 4d 10             	decl   0x10(%ebp)
  8014f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014fb:	74 09                	je     801506 <strlcpy+0x3c>
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	84 c0                	test   %al,%al
  801504:	75 d8                	jne    8014de <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80150c:	8b 55 08             	mov    0x8(%ebp),%edx
  80150f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801512:	29 c2                	sub    %eax,%edx
  801514:	89 d0                	mov    %edx,%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80151b:	eb 06                	jmp    801523 <strcmp+0xb>
		p++, q++;
  80151d:	ff 45 08             	incl   0x8(%ebp)
  801520:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	84 c0                	test   %al,%al
  80152a:	74 0e                	je     80153a <strcmp+0x22>
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 0c             	mov    0xc(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 e3                	je     80151d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 0c             	mov    0xc(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
}
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801553:	eb 09                	jmp    80155e <strncmp+0xe>
		n--, p++, q++;
  801555:	ff 4d 10             	decl   0x10(%ebp)
  801558:	ff 45 08             	incl   0x8(%ebp)
  80155b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80155e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801562:	74 17                	je     80157b <strncmp+0x2b>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	84 c0                	test   %al,%al
  80156b:	74 0e                	je     80157b <strncmp+0x2b>
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8a 10                	mov    (%eax),%dl
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	8a 00                	mov    (%eax),%al
  801577:	38 c2                	cmp    %al,%dl
  801579:	74 da                	je     801555 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80157b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80157f:	75 07                	jne    801588 <strncmp+0x38>
		return 0;
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	eb 14                	jmp    80159c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	0f b6 d0             	movzbl %al,%edx
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f b6 c0             	movzbl %al,%eax
  801598:	29 c2                	sub    %eax,%edx
  80159a:	89 d0                	mov    %edx,%eax
}
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015aa:	eb 12                	jmp    8015be <strchr+0x20>
		if (*s == c)
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	8a 00                	mov    (%eax),%al
  8015b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b4:	75 05                	jne    8015bb <strchr+0x1d>
			return (char *) s;
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	eb 11                	jmp    8015cc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015bb:	ff 45 08             	incl   0x8(%ebp)
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	84 c0                	test   %al,%al
  8015c5:	75 e5                	jne    8015ac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015da:	eb 0d                	jmp    8015e9 <strfind+0x1b>
		if (*s == c)
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e4:	74 0e                	je     8015f4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015e6:	ff 45 08             	incl   0x8(%ebp)
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 ea                	jne    8015dc <strfind+0xe>
  8015f2:	eb 01                	jmp    8015f5 <strfind+0x27>
		if (*s == c)
			break;
  8015f4:	90                   	nop
	return (char *) s;
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801606:	8b 45 10             	mov    0x10(%ebp),%eax
  801609:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80160c:	eb 0e                	jmp    80161c <memset+0x22>
		*p++ = c;
  80160e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801611:	8d 50 01             	lea    0x1(%eax),%edx
  801614:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80161c:	ff 4d f8             	decl   -0x8(%ebp)
  80161f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801623:	79 e9                	jns    80160e <memset+0x14>
		*p++ = c;

	return v;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80163c:	eb 16                	jmp    801654 <memcpy+0x2a>
		*d++ = *s++;
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801641:	8d 50 01             	lea    0x1(%eax),%edx
  801644:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801647:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801650:	8a 12                	mov    (%edx),%dl
  801652:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	8d 50 ff             	lea    -0x1(%eax),%edx
  80165a:	89 55 10             	mov    %edx,0x10(%ebp)
  80165d:	85 c0                	test   %eax,%eax
  80165f:	75 dd                	jne    80163e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80166c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801678:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80167e:	73 50                	jae    8016d0 <memmove+0x6a>
  801680:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	01 d0                	add    %edx,%eax
  801688:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168b:	76 43                	jbe    8016d0 <memmove+0x6a>
		s += n;
  80168d:	8b 45 10             	mov    0x10(%ebp),%eax
  801690:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801699:	eb 10                	jmp    8016ab <memmove+0x45>
			*--d = *--s;
  80169b:	ff 4d f8             	decl   -0x8(%ebp)
  80169e:	ff 4d fc             	decl   -0x4(%ebp)
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	8a 10                	mov    (%eax),%dl
  8016a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 e3                	jne    80169b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016b8:	eb 23                	jmp    8016dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	75 dd                	jne    8016ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016f4:	eb 2a                	jmp    801720 <memcmp+0x3e>
		if (*s1 != *s2)
  8016f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f9:	8a 10                	mov    (%eax),%dl
  8016fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	38 c2                	cmp    %al,%dl
  801702:	74 16                	je     80171a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801704:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f b6 d0             	movzbl %al,%edx
  80170c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170f:	8a 00                	mov    (%eax),%al
  801711:	0f b6 c0             	movzbl %al,%eax
  801714:	29 c2                	sub    %eax,%edx
  801716:	89 d0                	mov    %edx,%eax
  801718:	eb 18                	jmp    801732 <memcmp+0x50>
		s1++, s2++;
  80171a:	ff 45 fc             	incl   -0x4(%ebp)
  80171d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	8d 50 ff             	lea    -0x1(%eax),%edx
  801726:	89 55 10             	mov    %edx,0x10(%ebp)
  801729:	85 c0                	test   %eax,%eax
  80172b:	75 c9                	jne    8016f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80173a:	8b 55 08             	mov    0x8(%ebp),%edx
  80173d:	8b 45 10             	mov    0x10(%ebp),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801745:	eb 15                	jmp    80175c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	0f b6 d0             	movzbl %al,%edx
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	0f b6 c0             	movzbl %al,%eax
  801755:	39 c2                	cmp    %eax,%edx
  801757:	74 0d                	je     801766 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801759:	ff 45 08             	incl   0x8(%ebp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801762:	72 e3                	jb     801747 <memfind+0x13>
  801764:	eb 01                	jmp    801767 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801766:	90                   	nop
	return (void *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801772:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801779:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801780:	eb 03                	jmp    801785 <strtol+0x19>
		s++;
  801782:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	3c 20                	cmp    $0x20,%al
  80178c:	74 f4                	je     801782 <strtol+0x16>
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 09                	cmp    $0x9,%al
  801795:	74 eb                	je     801782 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 2b                	cmp    $0x2b,%al
  80179e:	75 05                	jne    8017a5 <strtol+0x39>
		s++;
  8017a0:	ff 45 08             	incl   0x8(%ebp)
  8017a3:	eb 13                	jmp    8017b8 <strtol+0x4c>
	else if (*s == '-')
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 2d                	cmp    $0x2d,%al
  8017ac:	75 0a                	jne    8017b8 <strtol+0x4c>
		s++, neg = 1;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bc:	74 06                	je     8017c4 <strtol+0x58>
  8017be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c2:	75 20                	jne    8017e4 <strtol+0x78>
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	3c 30                	cmp    $0x30,%al
  8017cb:	75 17                	jne    8017e4 <strtol+0x78>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	40                   	inc    %eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 78                	cmp    $0x78,%al
  8017d5:	75 0d                	jne    8017e4 <strtol+0x78>
		s += 2, base = 16;
  8017d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e2:	eb 28                	jmp    80180c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e8:	75 15                	jne    8017ff <strtol+0x93>
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	3c 30                	cmp    $0x30,%al
  8017f1:	75 0c                	jne    8017ff <strtol+0x93>
		s++, base = 8;
  8017f3:	ff 45 08             	incl   0x8(%ebp)
  8017f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017fd:	eb 0d                	jmp    80180c <strtol+0xa0>
	else if (base == 0)
  8017ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801803:	75 07                	jne    80180c <strtol+0xa0>
		base = 10;
  801805:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 2f                	cmp    $0x2f,%al
  801813:	7e 19                	jle    80182e <strtol+0xc2>
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	3c 39                	cmp    $0x39,%al
  80181c:	7f 10                	jg     80182e <strtol+0xc2>
			dig = *s - '0';
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8a 00                	mov    (%eax),%al
  801823:	0f be c0             	movsbl %al,%eax
  801826:	83 e8 30             	sub    $0x30,%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	eb 42                	jmp    801870 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 60                	cmp    $0x60,%al
  801835:	7e 19                	jle    801850 <strtol+0xe4>
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 7a                	cmp    $0x7a,%al
  80183e:	7f 10                	jg     801850 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	0f be c0             	movsbl %al,%eax
  801848:	83 e8 57             	sub    $0x57,%eax
  80184b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80184e:	eb 20                	jmp    801870 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 40                	cmp    $0x40,%al
  801857:	7e 39                	jle    801892 <strtol+0x126>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 5a                	cmp    $0x5a,%al
  801860:	7f 30                	jg     801892 <strtol+0x126>
			dig = *s - 'A' + 10;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 37             	sub    $0x37,%eax
  80186d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	3b 45 10             	cmp    0x10(%ebp),%eax
  801876:	7d 19                	jge    801891 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801878:	ff 45 08             	incl   0x8(%ebp)
  80187b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801882:	89 c2                	mov    %eax,%edx
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	01 d0                	add    %edx,%eax
  801889:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80188c:	e9 7b ff ff ff       	jmp    80180c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801891:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801892:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801896:	74 08                	je     8018a0 <strtol+0x134>
		*endptr = (char *) s;
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	8b 55 08             	mov    0x8(%ebp),%edx
  80189e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a4:	74 07                	je     8018ad <strtol+0x141>
  8018a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a9:	f7 d8                	neg    %eax
  8018ab:	eb 03                	jmp    8018b0 <strtol+0x144>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ca:	79 13                	jns    8018df <ltostr+0x2d>
	{
		neg = 1;
  8018cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018e7:	99                   	cltd   
  8018e8:	f7 f9                	idiv   %ecx
  8018ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f0:	8d 50 01             	lea    0x1(%eax),%edx
  8018f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018f6:	89 c2                	mov    %eax,%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801900:	83 c2 30             	add    $0x30,%edx
  801903:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801905:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801908:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80190d:	f7 e9                	imul   %ecx
  80190f:	c1 fa 02             	sar    $0x2,%edx
  801912:	89 c8                	mov    %ecx,%eax
  801914:	c1 f8 1f             	sar    $0x1f,%eax
  801917:	29 c2                	sub    %eax,%edx
  801919:	89 d0                	mov    %edx,%eax
  80191b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80191e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801921:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801926:	f7 e9                	imul   %ecx
  801928:	c1 fa 02             	sar    $0x2,%edx
  80192b:	89 c8                	mov    %ecx,%eax
  80192d:	c1 f8 1f             	sar    $0x1f,%eax
  801930:	29 c2                	sub    %eax,%edx
  801932:	89 d0                	mov    %edx,%eax
  801934:	c1 e0 02             	shl    $0x2,%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	01 c0                	add    %eax,%eax
  80193b:	29 c1                	sub    %eax,%ecx
  80193d:	89 ca                	mov    %ecx,%edx
  80193f:	85 d2                	test   %edx,%edx
  801941:	75 9c                	jne    8018df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801943:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80194a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194d:	48                   	dec    %eax
  80194e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801951:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801955:	74 3d                	je     801994 <ltostr+0xe2>
		start = 1 ;
  801957:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80195e:	eb 34                	jmp    801994 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 d0                	add    %edx,%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80196d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	01 c8                	add    %ecx,%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801981:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	01 c2                	add    %eax,%edx
  801989:	8a 45 eb             	mov    -0x15(%ebp),%al
  80198c:	88 02                	mov    %al,(%edx)
		start++ ;
  80198e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801991:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199a:	7c c4                	jl     801960 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80199c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80199f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a2:	01 d0                	add    %edx,%eax
  8019a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	e8 54 fa ff ff       	call   80140c <strlen>
  8019b8:	83 c4 04             	add    $0x4,%esp
  8019bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	e8 46 fa ff ff       	call   80140c <strlen>
  8019c6:	83 c4 04             	add    $0x4,%esp
  8019c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019da:	eb 17                	jmp    8019f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	01 c2                	add    %eax,%edx
  8019e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	01 c8                	add    %ecx,%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f0:	ff 45 fc             	incl   -0x4(%ebp)
  8019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019f9:	7c e1                	jl     8019dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a09:	eb 1f                	jmp    801a2a <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a0e:	8d 50 01             	lea    0x1(%eax),%edx
  801a11:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a14:	89 c2                	mov    %eax,%edx
  801a16:	8b 45 10             	mov    0x10(%ebp),%eax
  801a19:	01 c2                	add    %eax,%edx
  801a1b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	01 c8                	add    %ecx,%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a27:	ff 45 f8             	incl   -0x8(%ebp)
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a30:	7c d9                	jl     801a0b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	c6 00 00             	movb   $0x0,(%eax)
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	8b 00                	mov    (%eax),%eax
  801a51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a58:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a63:	eb 0c                	jmp    801a71 <strsplit+0x31>
			*string++ = 0;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8d 50 01             	lea    0x1(%eax),%edx
  801a6b:	89 55 08             	mov    %edx,0x8(%ebp)
  801a6e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 18                	je     801a92 <strsplit+0x52>
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8a 00                	mov    (%eax),%al
  801a7f:	0f be c0             	movsbl %al,%eax
  801a82:	50                   	push   %eax
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	e8 13 fb ff ff       	call   80159e <strchr>
  801a8b:	83 c4 08             	add    $0x8,%esp
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	75 d3                	jne    801a65 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	84 c0                	test   %al,%al
  801a99:	74 5a                	je     801af5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 00                	mov    (%eax),%eax
  801aa0:	83 f8 0f             	cmp    $0xf,%eax
  801aa3:	75 07                	jne    801aac <strsplit+0x6c>
		{
			return 0;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	eb 66                	jmp    801b12 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801aac:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaf:	8b 00                	mov    (%eax),%eax
  801ab1:	8d 48 01             	lea    0x1(%eax),%ecx
  801ab4:	8b 55 14             	mov    0x14(%ebp),%edx
  801ab7:	89 0a                	mov    %ecx,(%edx)
  801ab9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac3:	01 c2                	add    %eax,%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aca:	eb 03                	jmp    801acf <strsplit+0x8f>
			string++;
  801acc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	8a 00                	mov    (%eax),%al
  801ad4:	84 c0                	test   %al,%al
  801ad6:	74 8b                	je     801a63 <strsplit+0x23>
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	8a 00                	mov    (%eax),%al
  801add:	0f be c0             	movsbl %al,%eax
  801ae0:	50                   	push   %eax
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	e8 b5 fa ff ff       	call   80159e <strchr>
  801ae9:	83 c4 08             	add    $0x8,%esp
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 dc                	je     801acc <strsplit+0x8c>
			string++;
	}
  801af0:	e9 6e ff ff ff       	jmp    801a63 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801af5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801af6:	8b 45 14             	mov    0x14(%ebp),%eax
  801af9:	8b 00                	mov    (%eax),%eax
  801afb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b02:	8b 45 10             	mov    0x10(%ebp),%eax
  801b05:	01 d0                	add    %edx,%eax
  801b07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b21:	eb 4c                	jmp    801b6f <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801b23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b29:	01 d0                	add    %edx,%eax
  801b2b:	8a 00                	mov    (%eax),%al
  801b2d:	3c 40                	cmp    $0x40,%al
  801b2f:	7e 27                	jle    801b58 <str2lower+0x44>
  801b31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	01 d0                	add    %edx,%eax
  801b39:	8a 00                	mov    (%eax),%al
  801b3b:	3c 5a                	cmp    $0x5a,%al
  801b3d:	7f 19                	jg     801b58 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801b3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	01 ca                	add    %ecx,%edx
  801b4f:	8a 12                	mov    (%edx),%dl
  801b51:	83 c2 20             	add    $0x20,%edx
  801b54:	88 10                	mov    %dl,(%eax)
  801b56:	eb 14                	jmp    801b6c <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801b58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	01 c2                	add    %eax,%edx
  801b60:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b66:	01 c8                	add    %ecx,%eax
  801b68:	8a 00                	mov    (%eax),%al
  801b6a:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801b6c:	ff 45 fc             	incl   -0x4(%ebp)
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 95 f8 ff ff       	call   80140c <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b7d:	7f a4                	jg     801b23 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801b7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	01 d0                	add    %edx,%eax
  801b87:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801b92:	a1 28 40 80 00       	mov    0x804028,%eax
  801b97:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9a:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801ba1:	a1 28 40 80 00       	mov    0x804028,%eax
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba9:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  801bb0:	a1 28 40 80 00       	mov    0x804028,%eax
  801bb5:	40                   	inc    %eax
  801bb6:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801bbb:	90                   	nop
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    

00801bbe <searchElement>:

int searchElement(uint32 start) {
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bcb:	eb 17                	jmp    801be4 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd0:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801bd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bda:	75 05                	jne    801be1 <searchElement+0x23>
			return i;
  801bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bdf:	eb 12                	jmp    801bf3 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801be1:	ff 45 fc             	incl   -0x4(%ebp)
  801be4:	a1 28 40 80 00       	mov    0x804028,%eax
  801be9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801bec:	7c df                	jl     801bcd <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801bee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <removeElement>:
void removeElement(uint32 start) {
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 bb ff ff ff       	call   801bbe <searchElement>
  801c03:	83 c4 04             	add    $0x4,%esp
  801c06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801c0f:	eb 26                	jmp    801c37 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c14:	40                   	inc    %eax
  801c15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c18:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801c1f:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801c26:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801c2d:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c34:	ff 45 fc             	incl   -0x4(%ebp)
  801c37:	a1 28 40 80 00       	mov    0x804028,%eax
  801c3c:	48                   	dec    %eax
  801c3d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c40:	7f cf                	jg     801c11 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801c42:	a1 28 40 80 00       	mov    0x804028,%eax
  801c47:	48                   	dec    %eax
  801c48:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <searchfree>:
int searchfree(uint32 end)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c5d:	eb 17                	jmp    801c76 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c62:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801c69:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c6c:	75 05                	jne    801c73 <searchfree+0x23>
			return i;
  801c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c71:	eb 12                	jmp    801c85 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801c73:	ff 45 fc             	incl   -0x4(%ebp)
  801c76:	a1 28 40 80 00       	mov    0x804028,%eax
  801c7b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801c7e:	7c df                	jl     801c5f <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <removefree>:
void removefree(uint32 end)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  801c8d:	eb 52                	jmp    801ce1 <removefree+0x5a>
		int index = searchfree(end);
  801c8f:	ff 75 08             	pushl  0x8(%ebp)
  801c92:	e8 b9 ff ff ff       	call   801c50 <searchfree>
  801c97:	83 c4 04             	add    $0x4,%esp
  801c9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  801c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ca3:	eb 26                	jmp    801ccb <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca8:	40                   	inc    %eax
  801ca9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cac:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801cb3:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801cba:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801cc1:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801cc8:	ff 45 fc             	incl   -0x4(%ebp)
  801ccb:	a1 28 40 80 00       	mov    0x804028,%eax
  801cd0:	48                   	dec    %eax
  801cd1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cd4:	7f cf                	jg     801ca5 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801cd6:	a1 28 40 80 00       	mov    0x804028,%eax
  801cdb:	48                   	dec    %eax
  801cdc:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	e8 67 ff ff ff       	call   801c50 <searchfree>
  801ce9:	83 c4 04             	add    $0x4,%esp
  801cec:	83 f8 ff             	cmp    $0xffffffff,%eax
  801cef:	75 9e                	jne    801c8f <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  801cf1:	90                   	nop
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <printArray>:
void printArray() {
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	68 70 3c 80 00       	push   $0x803c70
  801d02:	e8 83 f0 ff ff       	call   800d8a <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d11:	eb 29                	jmp    801d3c <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2c:	68 81 3c 80 00       	push   $0x803c81
  801d31:	e8 54 f0 ff ff       	call   800d8a <cprintf>
  801d36:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801d39:	ff 45 f4             	incl   -0xc(%ebp)
  801d3c:	a1 28 40 80 00       	mov    0x804028,%eax
  801d41:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d44:	7c cd                	jl     801d13 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801d46:	90                   	nop
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801d4c:	a1 04 40 80 00       	mov    0x804004,%eax
  801d51:	85 c0                	test   %eax,%eax
  801d53:	74 0a                	je     801d5f <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d55:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801d5c:	00 00 00 
	}
}
  801d5f:	90                   	nop
  801d60:	5d                   	pop    %ebp
  801d61:	c3                   	ret    

00801d62 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	e8 4f 09 00 00       	call   8026c2 <sys_sbrk>
  801d73:	83 c4 10             	add    $0x10,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d7e:	e8 c6 ff ff ff       	call   801d49 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d87:	75 0a                	jne    801d93 <malloc+0x1b>
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	e9 43 01 00 00       	jmp    801ed6 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801d93:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d9a:	77 3c                	ja     801dd8 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d9c:	e8 c3 07 00 00       	call   802564 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801da1:	85 c0                	test   %eax,%eax
  801da3:	74 13                	je     801db8 <malloc+0x40>
			return alloc_block_FF(size);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	e8 89 0b 00 00       	call   802939 <alloc_block_FF>
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	e9 1e 01 00 00       	jmp    801ed6 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801db8:	e8 d8 07 00 00       	call   802595 <sys_isUHeapPlacementStrategyBESTFIT>
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	0f 84 0c 01 00 00    	je     801ed1 <malloc+0x159>
			return alloc_block_BF(size);
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	ff 75 08             	pushl  0x8(%ebp)
  801dcb:	e8 7d 0e 00 00       	call   802c4d <alloc_block_BF>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	e9 fe 00 00 00       	jmp    801ed6 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801dd8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  801de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de5:	01 d0                	add    %edx,%eax
  801de7:	48                   	dec    %eax
  801de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801deb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dee:	ba 00 00 00 00       	mov    $0x0,%edx
  801df3:	f7 75 e0             	divl   -0x20(%ebp)
  801df6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801df9:	29 d0                	sub    %edx,%eax
  801dfb:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	c1 e8 0c             	shr    $0xc,%eax
  801e04:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801e07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801e0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801e15:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801e1c:	e8 f4 08 00 00       	call   802715 <sys_hard_limit>
  801e21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801e24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e27:	05 00 10 00 00       	add    $0x1000,%eax
  801e2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e2f:	eb 49                	jmp    801e7a <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 e8             	pushl  -0x18(%ebp)
  801e37:	e8 82 fd ff ff       	call   801bbe <searchElement>
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	83 f8 ff             	cmp    $0xffffffff,%eax
  801e42:	75 28                	jne    801e6c <malloc+0xf4>
			{


				count++;
  801e44:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e4d:	75 24                	jne    801e73 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e52:	05 00 10 00 00       	add    $0x1000,%eax
  801e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5d:	c1 e0 0c             	shl    $0xc,%eax
  801e60:	89 c2                	mov    %eax,%edx
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	29 d0                	sub    %edx,%eax
  801e67:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801e6a:	eb 17                	jmp    801e83 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801e6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801e73:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801e7a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801e81:	76 ae                	jbe    801e31 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801e83:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801e87:	75 07                	jne    801e90 <malloc+0x118>
		{
			return NULL;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb 46                	jmp    801ed6 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e96:	eb 1a                	jmp    801eb2 <malloc+0x13a>
		{
			addElement(i,end);
  801e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9e:	83 ec 08             	sub    $0x8,%esp
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	e8 e7 fc ff ff       	call   801b8f <addElement>
  801ea8:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801eab:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801eb8:	7c de                	jl     801e98 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebd:	83 ec 08             	sub    $0x8,%esp
  801ec0:	ff 75 08             	pushl  0x8(%ebp)
  801ec3:	50                   	push   %eax
  801ec4:	e8 30 08 00 00       	call   8026f9 <sys_allocate_user_mem>
  801ec9:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecf:	eb 05                	jmp    801ed6 <malloc+0x15e>
	}
	return NULL;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801ede:	e8 32 08 00 00       	call   802715 <sys_hard_limit>
  801ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	0f 89 82 00 00 00    	jns    801f73 <free+0x9b>
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ef9:	77 78                	ja     801f73 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f01:	73 10                	jae    801f13 <free+0x3b>
			free_block(virtual_address);
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	e8 d2 0e 00 00       	call   802de0 <free_block>
  801f0e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801f11:	eb 77                	jmp    801f8a <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	50                   	push   %eax
  801f1a:	e8 9f fc ff ff       	call   801bbe <searchElement>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f28:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801f39:	29 c2                	sub    %eax,%edx
  801f3b:	89 d0                	mov    %edx,%eax
  801f3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f43:	c1 e8 0c             	shr    $0xc,%eax
  801f46:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	ff 75 ec             	pushl  -0x14(%ebp)
  801f52:	50                   	push   %eax
  801f53:	e8 85 07 00 00       	call   8026dd <sys_free_user_mem>
  801f58:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	50                   	push   %eax
  801f69:	e8 19 fd ff ff       	call   801c87 <removefree>
  801f6e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801f71:	eb 17                	jmp    801f8a <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	68 9a 3c 80 00       	push   $0x803c9a
  801f7b:	68 ac 00 00 00       	push   $0xac
  801f80:	68 aa 3c 80 00       	push   $0x803caa
  801f85:	e8 43 eb ff ff       	call   800acd <_panic>
	}
}
  801f8a:	90                   	nop
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
  801f93:	8b 45 10             	mov    0x10(%ebp),%eax
  801f96:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f99:	e8 ab fd ff ff       	call   801d49 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fa2:	75 07                	jne    801fab <smalloc+0x1e>
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	eb 17                	jmp    801fc2 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 b8 3c 80 00       	push   $0x803cb8
  801fb3:	68 bc 00 00 00       	push   $0xbc
  801fb8:	68 aa 3c 80 00       	push   $0x803caa
  801fbd:	e8 0b eb ff ff       	call   800acd <_panic>
	return NULL;
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fca:	e8 7a fd ff ff       	call   801d49 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 e0 3c 80 00       	push   $0x803ce0
  801fd7:	68 ca 00 00 00       	push   $0xca
  801fdc:	68 aa 3c 80 00       	push   $0x803caa
  801fe1:	e8 e7 ea ff ff       	call   800acd <_panic>

00801fe6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fec:	e8 58 fd ff ff       	call   801d49 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 04 3d 80 00       	push   $0x803d04
  801ff9:	68 ea 00 00 00       	push   $0xea
  801ffe:	68 aa 3c 80 00       	push   $0x803caa
  802003:	e8 c5 ea ff ff       	call   800acd <_panic>

00802008 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 2c 3d 80 00       	push   $0x803d2c
  802016:	68 fe 00 00 00       	push   $0xfe
  80201b:	68 aa 3c 80 00       	push   $0x803caa
  802020:	e8 a8 ea ff ff       	call   800acd <_panic>

00802025 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 50 3d 80 00       	push   $0x803d50
  802033:	68 08 01 00 00       	push   $0x108
  802038:	68 aa 3c 80 00       	push   $0x803caa
  80203d:	e8 8b ea ff ff       	call   800acd <_panic>

00802042 <shrink>:

}
void shrink(uint32 newSize)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 50 3d 80 00       	push   $0x803d50
  802050:	68 0d 01 00 00       	push   $0x10d
  802055:	68 aa 3c 80 00       	push   $0x803caa
  80205a:	e8 6e ea ff ff       	call   800acd <_panic>

0080205f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	68 50 3d 80 00       	push   $0x803d50
  80206d:	68 12 01 00 00       	push   $0x112
  802072:	68 aa 3c 80 00       	push   $0x803caa
  802077:	e8 51 ea ff ff       	call   800acd <_panic>

0080207c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	57                   	push   %edi
  802080:	56                   	push   %esi
  802081:	53                   	push   %ebx
  802082:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802091:	8b 7d 18             	mov    0x18(%ebp),%edi
  802094:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802097:	cd 30                	int    $0x30
  802099:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80209c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5f                   	pop    %edi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    

008020a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	52                   	push   %edx
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	50                   	push   %eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	e8 b2 ff ff ff       	call   80207c <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 01                	push   $0x1
  8020df:	e8 98 ff ff ff       	call   80207c <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	6a 05                	push   $0x5
  8020fc:	e8 7b ff ff ff       	call   80207c <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	56                   	push   %esi
  80210a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80210b:	8b 75 18             	mov    0x18(%ebp),%esi
  80210e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802111:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	51                   	push   %ecx
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	6a 06                	push   $0x6
  802121:	e8 56 ff ff ff       	call   80207c <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212c:	5b                   	pop    %ebx
  80212d:	5e                   	pop    %esi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    

00802130 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802133:	8b 55 0c             	mov    0xc(%ebp),%edx
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	52                   	push   %edx
  802140:	50                   	push   %eax
  802141:	6a 07                	push   $0x7
  802143:	e8 34 ff ff ff       	call   80207c <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	ff 75 0c             	pushl  0xc(%ebp)
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	6a 08                	push   $0x8
  80215e:	e8 19 ff ff ff       	call   80207c <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 09                	push   $0x9
  802177:	e8 00 ff ff ff       	call   80207c <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 0a                	push   $0xa
  802190:	e8 e7 fe ff ff       	call   80207c <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 0b                	push   $0xb
  8021a9:	e8 ce fe ff ff       	call   80207c <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 0c                	push   $0xc
  8021c2:	e8 b5 fe ff ff       	call   80207c <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	6a 0d                	push   $0xd
  8021dc:	e8 9b fe ff ff       	call   80207c <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 0e                	push   $0xe
  8021f5:	e8 82 fe ff ff       	call   80207c <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
}
  8021fd:	90                   	nop
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 11                	push   $0x11
  80220f:	e8 68 fe ff ff       	call   80207c <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 12                	push   $0x12
  802229:	e8 4e fe ff ff       	call   80207c <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	90                   	nop
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_cputc>:


void
sys_cputc(const char c)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802240:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	50                   	push   %eax
  80224d:	6a 13                	push   $0x13
  80224f:	e8 28 fe ff ff       	call   80207c <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	90                   	nop
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 14                	push   $0x14
  802269:	e8 0e fe ff ff       	call   80207c <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	90                   	nop
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	50                   	push   %eax
  802284:	6a 15                	push   $0x15
  802286:	e8 f1 fd ff ff       	call   80207c <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802293:	8b 55 0c             	mov    0xc(%ebp),%edx
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	52                   	push   %edx
  8022a0:	50                   	push   %eax
  8022a1:	6a 18                	push   $0x18
  8022a3:	e8 d4 fd ff ff       	call   80207c <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	52                   	push   %edx
  8022bd:	50                   	push   %eax
  8022be:	6a 16                	push   $0x16
  8022c0:	e8 b7 fd ff ff       	call   80207c <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	90                   	nop
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	6a 17                	push   $0x17
  8022de:	e8 99 fd ff ff       	call   80207c <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	6a 00                	push   $0x0
  802301:	51                   	push   %ecx
  802302:	52                   	push   %edx
  802303:	ff 75 0c             	pushl  0xc(%ebp)
  802306:	50                   	push   %eax
  802307:	6a 19                	push   $0x19
  802309:	e8 6e fd ff ff       	call   80207c <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802316:	8b 55 0c             	mov    0xc(%ebp),%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	52                   	push   %edx
  802323:	50                   	push   %eax
  802324:	6a 1a                	push   $0x1a
  802326:	e8 51 fd ff ff       	call   80207c <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802333:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802336:	8b 55 0c             	mov    0xc(%ebp),%edx
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	51                   	push   %ecx
  802341:	52                   	push   %edx
  802342:	50                   	push   %eax
  802343:	6a 1b                	push   $0x1b
  802345:	e8 32 fd ff ff       	call   80207c <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802352:	8b 55 0c             	mov    0xc(%ebp),%edx
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	52                   	push   %edx
  80235f:	50                   	push   %eax
  802360:	6a 1c                	push   $0x1c
  802362:	e8 15 fd ff ff       	call   80207c <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 1d                	push   $0x1d
  80237b:	e8 fc fc ff ff       	call   80207c <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	6a 00                	push   $0x0
  80238d:	ff 75 14             	pushl  0x14(%ebp)
  802390:	ff 75 10             	pushl  0x10(%ebp)
  802393:	ff 75 0c             	pushl  0xc(%ebp)
  802396:	50                   	push   %eax
  802397:	6a 1e                	push   $0x1e
  802399:	e8 de fc ff ff       	call   80207c <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	50                   	push   %eax
  8023b2:	6a 1f                	push   $0x1f
  8023b4:	e8 c3 fc ff ff       	call   80207c <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
}
  8023bc:	90                   	nop
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	50                   	push   %eax
  8023ce:	6a 20                	push   $0x20
  8023d0:	e8 a7 fc ff ff       	call   80207c <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 02                	push   $0x2
  8023e9:	e8 8e fc ff ff       	call   80207c <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 03                	push   $0x3
  802402:	e8 75 fc ff ff       	call   80207c <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 04                	push   $0x4
  80241b:	e8 5c fc ff ff       	call   80207c <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_exit_env>:


void sys_exit_env(void)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 21                	push   $0x21
  802434:	e8 43 fc ff ff       	call   80207c <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
}
  80243c:	90                   	nop
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802445:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802448:	8d 50 04             	lea    0x4(%eax),%edx
  80244b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	52                   	push   %edx
  802455:	50                   	push   %eax
  802456:	6a 22                	push   $0x22
  802458:	e8 1f fc ff ff       	call   80207c <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
	return result;
  802460:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802463:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802466:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802469:	89 01                	mov    %eax,(%ecx)
  80246b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	c9                   	leave  
  802472:	c2 04 00             	ret    $0x4

00802475 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	ff 75 10             	pushl  0x10(%ebp)
  80247f:	ff 75 0c             	pushl  0xc(%ebp)
  802482:	ff 75 08             	pushl  0x8(%ebp)
  802485:	6a 10                	push   $0x10
  802487:	e8 f0 fb ff ff       	call   80207c <syscall>
  80248c:	83 c4 18             	add    $0x18,%esp
	return ;
  80248f:	90                   	nop
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <sys_rcr2>:
uint32 sys_rcr2()
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 23                	push   $0x23
  8024a1:	e8 d6 fb ff ff       	call   80207c <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	50                   	push   %eax
  8024c4:	6a 24                	push   $0x24
  8024c6:	e8 b1 fb ff ff       	call   80207c <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ce:	90                   	nop
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <rsttst>:
void rsttst()
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 26                	push   $0x26
  8024e0:	e8 97 fb ff ff       	call   80207c <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e8:	90                   	nop
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8024fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024fe:	52                   	push   %edx
  8024ff:	50                   	push   %eax
  802500:	ff 75 10             	pushl  0x10(%ebp)
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	ff 75 08             	pushl  0x8(%ebp)
  802509:	6a 25                	push   $0x25
  80250b:	e8 6c fb ff ff       	call   80207c <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
	return ;
  802513:	90                   	nop
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <chktst>:
void chktst(uint32 n)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	ff 75 08             	pushl  0x8(%ebp)
  802524:	6a 27                	push   $0x27
  802526:	e8 51 fb ff ff       	call   80207c <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
	return ;
  80252e:	90                   	nop
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <inctst>:

void inctst()
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 28                	push   $0x28
  802540:	e8 37 fb ff ff       	call   80207c <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return ;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <gettst>:
uint32 gettst()
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 29                	push   $0x29
  80255a:	e8 1d fb ff ff       	call   80207c <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 2a                	push   $0x2a
  802576:	e8 01 fb ff ff       	call   80207c <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
  80257e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802581:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802585:	75 07                	jne    80258e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802587:	b8 01 00 00 00       	mov    $0x1,%eax
  80258c:	eb 05                	jmp    802593 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 2a                	push   $0x2a
  8025a7:	e8 d0 fa ff ff       	call   80207c <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
  8025af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b6:	75 07                	jne    8025bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bd:	eb 05                	jmp    8025c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 2a                	push   $0x2a
  8025d8:	e8 9f fa ff ff       	call   80207c <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
  8025e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e7:	75 07                	jne    8025f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ee:	eb 05                	jmp    8025f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 2a                	push   $0x2a
  802609:	e8 6e fa ff ff       	call   80207c <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
  802611:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802614:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802618:	75 07                	jne    802621 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	eb 05                	jmp    802626 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	ff 75 08             	pushl  0x8(%ebp)
  802636:	6a 2b                	push   $0x2b
  802638:	e8 3f fa ff ff       	call   80207c <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
	return ;
  802640:	90                   	nop
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802647:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	6a 00                	push   $0x0
  802655:	53                   	push   %ebx
  802656:	51                   	push   %ecx
  802657:	52                   	push   %edx
  802658:	50                   	push   %eax
  802659:	6a 2c                	push   $0x2c
  80265b:	e8 1c fa ff ff       	call   80207c <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80266b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	52                   	push   %edx
  802678:	50                   	push   %eax
  802679:	6a 2d                	push   $0x2d
  80267b:	e8 fc f9 ff ff       	call   80207c <syscall>
  802680:	83 c4 18             	add    $0x18,%esp
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802688:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80268b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	6a 00                	push   $0x0
  802693:	51                   	push   %ecx
  802694:	ff 75 10             	pushl  0x10(%ebp)
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	6a 2e                	push   $0x2e
  80269b:	e8 dc f9 ff ff       	call   80207c <syscall>
  8026a0:	83 c4 18             	add    $0x18,%esp
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	ff 75 10             	pushl  0x10(%ebp)
  8026af:	ff 75 0c             	pushl  0xc(%ebp)
  8026b2:	ff 75 08             	pushl  0x8(%ebp)
  8026b5:	6a 0f                	push   $0xf
  8026b7:	e8 c0 f9 ff ff       	call   80207c <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bf:	90                   	nop
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	50                   	push   %eax
  8026d1:	6a 2f                	push   $0x2f
  8026d3:	e8 a4 f9 ff ff       	call   80207c <syscall>
  8026d8:	83 c4 18             	add    $0x18,%esp

}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	ff 75 0c             	pushl  0xc(%ebp)
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	6a 30                	push   $0x30
  8026ee:	e8 89 f9 ff ff       	call   80207c <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp

}
  8026f6:	90                   	nop
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	ff 75 0c             	pushl  0xc(%ebp)
  802705:	ff 75 08             	pushl  0x8(%ebp)
  802708:	6a 31                	push   $0x31
  80270a:	e8 6d f9 ff ff       	call   80207c <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp

}
  802712:	90                   	nop
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <sys_hard_limit>:
uint32 sys_hard_limit(){
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 32                	push   $0x32
  802724:	e8 53 f9 ff ff       	call   80207c <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	83 e8 10             	sub    $0x10,%eax
  80273a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  80273d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	83 e8 10             	sub    $0x10,%eax
  802750:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802753:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802756:	8a 40 04             	mov    0x4(%eax),%al
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802761:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	83 f8 02             	cmp    $0x2,%eax
  80276e:	74 2b                	je     80279b <alloc_block+0x40>
  802770:	83 f8 02             	cmp    $0x2,%eax
  802773:	7f 07                	jg     80277c <alloc_block+0x21>
  802775:	83 f8 01             	cmp    $0x1,%eax
  802778:	74 0e                	je     802788 <alloc_block+0x2d>
  80277a:	eb 58                	jmp    8027d4 <alloc_block+0x79>
  80277c:	83 f8 03             	cmp    $0x3,%eax
  80277f:	74 2d                	je     8027ae <alloc_block+0x53>
  802781:	83 f8 04             	cmp    $0x4,%eax
  802784:	74 3b                	je     8027c1 <alloc_block+0x66>
  802786:	eb 4c                	jmp    8027d4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	ff 75 08             	pushl  0x8(%ebp)
  80278e:	e8 a6 01 00 00       	call   802939 <alloc_block_FF>
  802793:	83 c4 10             	add    $0x10,%esp
  802796:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802799:	eb 4a                	jmp    8027e5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80279b:	83 ec 0c             	sub    $0xc,%esp
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	e8 1d 06 00 00       	call   802dc3 <alloc_block_NF>
  8027a6:	83 c4 10             	add    $0x10,%esp
  8027a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027ac:	eb 37                	jmp    8027e5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027ae:	83 ec 0c             	sub    $0xc,%esp
  8027b1:	ff 75 08             	pushl  0x8(%ebp)
  8027b4:	e8 94 04 00 00       	call   802c4d <alloc_block_BF>
  8027b9:	83 c4 10             	add    $0x10,%esp
  8027bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027bf:	eb 24                	jmp    8027e5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027c1:	83 ec 0c             	sub    $0xc,%esp
  8027c4:	ff 75 08             	pushl  0x8(%ebp)
  8027c7:	e8 da 05 00 00       	call   802da6 <alloc_block_WF>
  8027cc:	83 c4 10             	add    $0x10,%esp
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027d2:	eb 11                	jmp    8027e5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	68 60 3d 80 00       	push   $0x803d60
  8027dc:	e8 a9 e5 ff ff       	call   800d8a <cprintf>
  8027e1:	83 c4 10             	add    $0x10,%esp
		break;
  8027e4:	90                   	nop
	}
	return va;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8027f0:	83 ec 0c             	sub    $0xc,%esp
  8027f3:	68 80 3d 80 00       	push   $0x803d80
  8027f8:	e8 8d e5 ff ff       	call   800d8a <cprintf>
  8027fd:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	68 ab 3d 80 00       	push   $0x803dab
  802808:	e8 7d e5 ff ff       	call   800d8a <cprintf>
  80280d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802816:	eb 26                	jmp    80283e <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8a 40 04             	mov    0x4(%eax),%al
  80281e:	0f b6 d0             	movzbl %al,%edx
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	52                   	push   %edx
  80282a:	50                   	push   %eax
  80282b:	68 c3 3d 80 00       	push   $0x803dc3
  802830:	e8 55 e5 ff ff       	call   800d8a <cprintf>
  802835:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802838:	8b 45 10             	mov    0x10(%ebp),%eax
  80283b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802842:	74 08                	je     80284c <print_blocks_list+0x62>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 08             	mov    0x8(%eax),%eax
  80284a:	eb 05                	jmp    802851 <print_blocks_list+0x67>
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
  802851:	89 45 10             	mov    %eax,0x10(%ebp)
  802854:	8b 45 10             	mov    0x10(%ebp),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	75 bd                	jne    802818 <print_blocks_list+0x2e>
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	75 b7                	jne    802818 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802861:	83 ec 0c             	sub    $0xc,%esp
  802864:	68 80 3d 80 00       	push   $0x803d80
  802869:	e8 1c e5 ff ff       	call   800d8a <cprintf>
  80286e:	83 c4 10             	add    $0x10,%esp

}
  802871:	90                   	nop
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  80287a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80287e:	0f 84 b2 00 00 00    	je     802936 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802884:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  80288b:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  80288e:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  802895:	00 00 00 
  802898:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  80289f:	00 00 00 
  8028a2:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  8028a9:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  8028b4:	a1 24 41 80 00       	mov    0x804124,%eax
  8028b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  8028be:	a1 24 41 80 00       	mov    0x804124,%eax
  8028c3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  8028c7:	a1 24 41 80 00       	mov    0x804124,%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	75 14                	jne    8028e4 <initialize_dynamic_allocator+0x70>
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	68 dc 3d 80 00       	push   $0x803ddc
  8028d8:	6a 68                	push   $0x68
  8028da:	68 ff 3d 80 00       	push   $0x803dff
  8028df:	e8 e9 e1 ff ff       	call   800acd <_panic>
  8028e4:	a1 24 41 80 00       	mov    0x804124,%eax
  8028e9:	8b 15 14 41 80 00    	mov    0x804114,%edx
  8028ef:	89 50 08             	mov    %edx,0x8(%eax)
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 10                	je     802909 <initialize_dynamic_allocator+0x95>
  8028f9:	a1 14 41 80 00       	mov    0x804114,%eax
  8028fe:	8b 15 24 41 80 00    	mov    0x804124,%edx
  802904:	89 50 0c             	mov    %edx,0xc(%eax)
  802907:	eb 0a                	jmp    802913 <initialize_dynamic_allocator+0x9f>
  802909:	a1 24 41 80 00       	mov    0x804124,%eax
  80290e:	a3 18 41 80 00       	mov    %eax,0x804118
  802913:	a1 24 41 80 00       	mov    0x804124,%eax
  802918:	a3 14 41 80 00       	mov    %eax,0x804114
  80291d:	a1 24 41 80 00       	mov    0x804124,%eax
  802922:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802929:	a1 20 41 80 00       	mov    0x804120,%eax
  80292e:	40                   	inc    %eax
  80292f:	a3 20 41 80 00       	mov    %eax,0x804120
  802934:	eb 01                	jmp    802937 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802936:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
  80293c:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  80293f:	a1 2c 40 80 00       	mov    0x80402c,%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	75 40                	jne    802988 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	83 c0 10             	add    $0x10,%eax
  80294e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	83 ec 0c             	sub    $0xc,%esp
  802957:	50                   	push   %eax
  802958:	e8 05 f4 ff ff       	call   801d62 <sbrk>
  80295d:	83 c4 10             	add    $0x10,%esp
  802960:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802963:	83 ec 0c             	sub    $0xc,%esp
  802966:	6a 00                	push   $0x0
  802968:	e8 f5 f3 ff ff       	call   801d62 <sbrk>
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802973:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802976:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802979:	83 ec 08             	sub    $0x8,%esp
  80297c:	50                   	push   %eax
  80297d:	ff 75 ec             	pushl  -0x14(%ebp)
  802980:	e8 ef fe ff ff       	call   802874 <initialize_dynamic_allocator>
  802985:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298c:	75 0a                	jne    802998 <alloc_block_FF+0x5f>
		 return NULL;
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
  802993:	e9 b3 02 00 00       	jmp    802c4b <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  802998:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  80299c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  8029a3:	a1 14 41 80 00       	mov    0x804114,%eax
  8029a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ab:	e9 12 01 00 00       	jmp    802ac2 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8a 40 04             	mov    0x4(%eax),%al
  8029b6:	84 c0                	test   %al,%al
  8029b8:	0f 84 fc 00 00 00    	je     802aba <alloc_block_FF+0x181>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c6:	0f 82 ee 00 00 00    	jb     802aba <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d4:	75 12                	jne    8029e8 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	83 c0 10             	add    $0x10,%eax
  8029e3:	e9 63 02 00 00       	jmp    802c4b <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  8029e8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029fe:	83 f8 0f             	cmp    $0xf,%eax
  802a01:	0f 86 a8 00 00 00    	jbe    802aaf <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1a:	89 c2                	mov    %eax,%edx
  802a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1f:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 55 08             	mov    0x8(%ebp),%edx
  802a27:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a2c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a34:	74 06                	je     802a3c <alloc_block_FF+0x103>
  802a36:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_FF+0x11a>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 18 3e 80 00       	push   $0x803e18
  802a44:	68 91 00 00 00       	push   $0x91
  802a49:	68 ff 3d 80 00       	push   $0x803dff
  802a4e:	e8 7a e0 ff ff       	call   800acd <_panic>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 50 08             	mov    0x8(%eax),%edx
  802a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a5c:	89 50 08             	mov    %edx,0x8(%eax)
  802a5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 0c                	je     802a75 <alloc_block_FF+0x13c>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 08             	mov    0x8(%eax),%eax
  802a6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a72:	89 50 0c             	mov    %edx,0xc(%eax)
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a7b:	89 50 08             	mov    %edx,0x8(%eax)
  802a7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a84:	89 50 0c             	mov    %edx,0xc(%eax)
  802a87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a8a:	8b 40 08             	mov    0x8(%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	75 08                	jne    802a99 <alloc_block_FF+0x160>
  802a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a94:	a3 18 41 80 00       	mov    %eax,0x804118
  802a99:	a1 20 41 80 00       	mov    0x804120,%eax
  802a9e:	40                   	inc    %eax
  802a9f:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	83 c0 10             	add    $0x10,%eax
  802aaa:	e9 9c 01 00 00       	jmp    802c4b <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	83 c0 10             	add    $0x10,%eax
  802ab5:	e9 91 01 00 00       	jmp    802c4b <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802aba:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	74 08                	je     802ad0 <alloc_block_FF+0x197>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 08             	mov    0x8(%eax),%eax
  802ace:	eb 05                	jmp    802ad5 <alloc_block_FF+0x19c>
  802ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad5:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802ada:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	0f 85 c9 fe ff ff    	jne    8029b0 <alloc_block_FF+0x77>
  802ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aeb:	0f 85 bf fe ff ff    	jne    8029b0 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802af1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802af5:	0f 85 4b 01 00 00    	jne    802c46 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	83 ec 0c             	sub    $0xc,%esp
  802b01:	50                   	push   %eax
  802b02:	e8 5b f2 ff ff       	call   801d62 <sbrk>
  802b07:	83 c4 10             	add    $0x10,%esp
  802b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b11:	0f 84 28 01 00 00    	je     802c3f <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b28:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802b2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_FF+0x210>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 4c 3e 80 00       	push   $0x803e4c
  802b3a:	68 a1 00 00 00       	push   $0xa1
  802b3f:	68 ff 3d 80 00       	push   $0x803dff
  802b44:	e8 84 df ff ff       	call   800acd <_panic>
  802b49:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
  802b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0d                	je     802b6c <alloc_block_FF+0x233>
  802b5f:	a1 18 41 80 00       	mov    0x804118,%eax
  802b64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b67:	89 50 08             	mov    %edx,0x8(%eax)
  802b6a:	eb 08                	jmp    802b74 <alloc_block_FF+0x23b>
  802b6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6f:	a3 14 41 80 00       	mov    %eax,0x804114
  802b74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b77:	a3 18 41 80 00       	mov    %eax,0x804118
  802b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b86:	a1 20 41 80 00       	mov    0x804120,%eax
  802b8b:	40                   	inc    %eax
  802b8c:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802b91:	b8 00 10 00 00       	mov    $0x1000,%eax
  802b96:	2b 45 08             	sub    0x8(%ebp),%eax
  802b99:	83 f8 0f             	cmp    $0xf,%eax
  802b9c:	0f 86 95 00 00 00    	jbe    802c37 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	01 d0                	add    %edx,%eax
  802baa:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802bad:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bb2:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb5:	89 c2                	mov    %eax,%edx
  802bb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bba:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802bbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bbf:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802bc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bc7:	74 06                	je     802bcf <alloc_block_FF+0x296>
  802bc9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block_FF+0x2ad>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 18 3e 80 00       	push   $0x803e18
  802bd7:	68 a6 00 00 00       	push   $0xa6
  802bdc:	68 ff 3d 80 00       	push   $0x803dff
  802be1:	e8 e7 de ff ff       	call   800acd <_panic>
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	8b 50 08             	mov    0x8(%eax),%edx
  802bec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bef:	89 50 08             	mov    %edx,0x8(%eax)
  802bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0c                	je     802c08 <alloc_block_FF+0x2cf>
  802bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bff:	8b 40 08             	mov    0x8(%eax),%eax
  802c02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c05:	89 50 0c             	mov    %edx,0xc(%eax)
  802c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c0e:	89 50 08             	mov    %edx,0x8(%eax)
  802c11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c17:	89 50 0c             	mov    %edx,0xc(%eax)
  802c1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1d:	8b 40 08             	mov    0x8(%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	75 08                	jne    802c2c <alloc_block_FF+0x2f3>
  802c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c27:	a3 18 41 80 00       	mov    %eax,0x804118
  802c2c:	a1 20 41 80 00       	mov    0x804120,%eax
  802c31:	40                   	inc    %eax
  802c32:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  802c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3a:	83 c0 10             	add    $0x10,%eax
  802c3d:	eb 0c                	jmp    802c4b <alloc_block_FF+0x312>
		 }
		 return NULL;
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c44:	eb 05                	jmp    802c4b <alloc_block_FF+0x312>
	 }
	 return NULL;
  802c46:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
  802c50:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802c53:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  802c5e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802c65:	a1 14 41 80 00       	mov    0x804114,%eax
  802c6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c6d:	eb 34                	jmp    802ca3 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	8a 40 04             	mov    0x4(%eax),%al
  802c75:	84 c0                	test   %al,%al
  802c77:	74 22                	je     802c9b <alloc_block_BF+0x4e>
  802c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c81:	72 18                	jb     802c9b <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c8b:	73 0e                	jae    802c9b <alloc_block_BF+0x4e>
                bestFitBlock = current;
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802c9b:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ca7:	74 08                	je     802cb1 <alloc_block_BF+0x64>
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	8b 40 08             	mov    0x8(%eax),%eax
  802caf:	eb 05                	jmp    802cb6 <alloc_block_BF+0x69>
  802cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb6:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802cbb:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	75 ab                	jne    802c6f <alloc_block_BF+0x22>
  802cc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cc8:	75 a5                	jne    802c6f <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802cca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cce:	0f 84 cb 00 00 00    	je     802d9f <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce3:	0f 86 ae 00 00 00    	jbe    802d97 <alloc_block_BF+0x14a>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf1:	83 f8 0f             	cmp    $0xf,%eax
  802cf4:	0f 86 9d 00 00 00    	jbe    802d97 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	01 d0                	add    %edx,%eax
  802d02:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d0d:	89 c2                	mov    %eax,%edx
  802d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d12:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  802d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d17:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  802d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d27:	74 06                	je     802d2f <alloc_block_BF+0xe2>
  802d29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d2d:	75 17                	jne    802d46 <alloc_block_BF+0xf9>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 18 3e 80 00       	push   $0x803e18
  802d37:	68 c6 00 00 00       	push   $0xc6
  802d3c:	68 ff 3d 80 00       	push   $0x803dff
  802d41:	e8 87 dd ff ff       	call   800acd <_panic>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 50 08             	mov    0x8(%eax),%edx
  802d4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4f:	89 50 08             	mov    %edx,0x8(%eax)
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0c                	je     802d68 <alloc_block_BF+0x11b>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d65:	89 50 0c             	mov    %edx,0xc(%eax)
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6e:	89 50 08             	mov    %edx,0x8(%eax)
  802d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d77:	89 50 0c             	mov    %edx,0xc(%eax)
  802d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7d:	8b 40 08             	mov    0x8(%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	75 08                	jne    802d8c <alloc_block_BF+0x13f>
  802d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d87:	a3 18 41 80 00       	mov    %eax,0x804118
  802d8c:	a1 20 41 80 00       	mov    0x804120,%eax
  802d91:	40                   	inc    %eax
  802d92:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	83 c0 10             	add    $0x10,%eax
  802d9d:	eb 05                	jmp    802da4 <alloc_block_BF+0x157>
    }

    return NULL;
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 70 3e 80 00       	push   $0x803e70
  802db4:	68 d2 00 00 00       	push   $0xd2
  802db9:	68 ff 3d 80 00       	push   $0x803dff
  802dbe:	e8 0a dd ff ff       	call   800acd <_panic>

00802dc3 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	68 98 3e 80 00       	push   $0x803e98
  802dd1:	68 db 00 00 00       	push   $0xdb
  802dd6:	68 ff 3d 80 00       	push   $0x803dff
  802ddb:	e8 ed dc ff ff       	call   800acd <_panic>

00802de0 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802de0:	55                   	push   %ebp
  802de1:	89 e5                	mov    %esp,%ebp
  802de3:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802de6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dea:	0f 84 d2 01 00 00    	je     802fc2 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	83 e8 10             	sub    $0x10,%eax
  802df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8a 40 04             	mov    0x4(%eax),%al
  802dff:	84 c0                	test   %al,%al
  802e01:	0f 85 be 01 00 00    	jne    802fc5 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 08             	mov    0x8(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	0f 84 cc 00 00 00    	je     802ee8 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 08             	mov    0x8(%eax),%eax
  802e22:	8a 40 04             	mov    0x4(%eax),%al
  802e25:	84 c0                	test   %al,%al
  802e27:	0f 84 bb 00 00 00    	je     802ee8 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 10                	mov    (%eax),%edx
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 40 08             	mov    0x8(%eax),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 08             	mov    0x8(%eax),%eax
  802e47:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 08             	mov    0x8(%eax),%eax
  802e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 08             	mov    0x8(%eax),%eax
  802e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802e60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e64:	75 17                	jne    802e7d <free_block+0x9d>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 be 3e 80 00       	push   $0x803ebe
  802e6e:	68 f8 00 00 00       	push   $0xf8
  802e73:	68 ff 3d 80 00       	push   $0x803dff
  802e78:	e8 50 dc ff ff       	call   800acd <_panic>
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 40 08             	mov    0x8(%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 11                	je     802e98 <free_block+0xb8>
  802e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e90:	8b 52 0c             	mov    0xc(%edx),%edx
  802e93:	89 50 0c             	mov    %edx,0xc(%eax)
  802e96:	eb 0b                	jmp    802ea3 <free_block+0xc3>
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	a3 18 41 80 00       	mov    %eax,0x804118
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 11                	je     802ebe <free_block+0xde>
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb6:	8b 52 08             	mov    0x8(%edx),%edx
  802eb9:	89 50 08             	mov    %edx,0x8(%eax)
  802ebc:	eb 0b                	jmp    802ec9 <free_block+0xe9>
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	a3 14 41 80 00       	mov    %eax,0x804114
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802edd:	a1 20 41 80 00       	mov    0x804120,%eax
  802ee2:	48                   	dec    %eax
  802ee3:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	0f 84 d0 00 00 00    	je     802fc6 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  802efc:	8a 40 04             	mov    0x4(%eax),%al
  802eff:	84 c0                	test   %al,%al
  802f01:	0f 84 bf 00 00 00    	je     802fc6 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f10:	8b 52 0c             	mov    0xc(%edx),%edx
  802f13:	8b 0a                	mov    (%edx),%ecx
  802f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f18:	8b 12                	mov    (%edx),%edx
  802f1a:	01 ca                	add    %ecx,%edx
  802f1c:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802f38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3c:	75 17                	jne    802f55 <free_block+0x175>
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	68 be 3e 80 00       	push   $0x803ebe
  802f46:	68 03 01 00 00       	push   $0x103
  802f4b:	68 ff 3d 80 00       	push   $0x803dff
  802f50:	e8 78 db ff ff       	call   800acd <_panic>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 11                	je     802f70 <free_block+0x190>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 08             	mov    0x8(%eax),%eax
  802f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f68:	8b 52 0c             	mov    0xc(%edx),%edx
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
  802f6e:	eb 0b                	jmp    802f7b <free_block+0x19b>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 0c             	mov    0xc(%eax),%eax
  802f76:	a3 18 41 80 00       	mov    %eax,0x804118
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 11                	je     802f96 <free_block+0x1b6>
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8e:	8b 52 08             	mov    0x8(%edx),%edx
  802f91:	89 50 08             	mov    %edx,0x8(%eax)
  802f94:	eb 0b                	jmp    802fa1 <free_block+0x1c1>
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 40 08             	mov    0x8(%eax),%eax
  802f9c:	a3 14 41 80 00       	mov    %eax,0x804114
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fb5:	a1 20 41 80 00       	mov    0x804120,%eax
  802fba:	48                   	dec    %eax
  802fbb:	a3 20 41 80 00       	mov    %eax,0x804120
  802fc0:	eb 04                	jmp    802fc6 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802fc2:	90                   	nop
  802fc3:	eb 01                	jmp    802fc6 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802fc5:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
  802fcb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd2:	75 10                	jne    802fe4 <realloc_block_FF+0x1c>
  802fd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd8:	75 0a                	jne    802fe4 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	e9 2e 03 00 00       	jmp    803312 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802fe4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe8:	75 13                	jne    802ffd <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802fea:	83 ec 0c             	sub    $0xc,%esp
  802fed:	ff 75 0c             	pushl  0xc(%ebp)
  802ff0:	e8 44 f9 ff ff       	call   802939 <alloc_block_FF>
  802ff5:	83 c4 10             	add    $0x10,%esp
  802ff8:	e9 15 03 00 00       	jmp    803312 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  802ffd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803001:	75 18                	jne    80301b <realloc_block_FF+0x53>
	 {
		 free_block(va);
  803003:	83 ec 0c             	sub    $0xc,%esp
  803006:	ff 75 08             	pushl  0x8(%ebp)
  803009:	e8 d2 fd ff ff       	call   802de0 <free_block>
  80300e:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  803011:	b8 00 00 00 00       	mov    $0x0,%eax
  803016:	e9 f7 02 00 00       	jmp    803312 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	83 e8 10             	sub    $0x10,%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  803024:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803030:	0f 82 c8 00 00 00    	jb     8030fe <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80303e:	75 08                	jne    803048 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	e9 ca 02 00 00       	jmp    803312 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803050:	83 f8 0f             	cmp    $0xf,%eax
  803053:	0f 86 9d 00 00 00    	jbe    8030f6 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305f:	01 d0                	add    %edx,%eax
  803061:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	2b 45 0c             	sub    0xc(%ebp),%eax
  80306c:	89 c2                	mov    %eax,%edx
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 55 0c             	mov    0xc(%ebp),%edx
  803079:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  803082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803086:	74 06                	je     80308e <realloc_block_FF+0xc6>
  803088:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308c:	75 17                	jne    8030a5 <realloc_block_FF+0xdd>
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	68 18 3e 80 00       	push   $0x803e18
  803096:	68 2a 01 00 00       	push   $0x12a
  80309b:	68 ff 3d 80 00       	push   $0x803dff
  8030a0:	e8 28 da ff ff       	call   800acd <_panic>
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 50 08             	mov    0x8(%eax),%edx
  8030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ae:	89 50 08             	mov    %edx,0x8(%eax)
  8030b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	74 0c                	je     8030c7 <realloc_block_FF+0xff>
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 08             	mov    0x8(%eax),%eax
  8030c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c4:	89 50 0c             	mov    %edx,0xc(%eax)
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030cd:	89 50 08             	mov    %edx,0x8(%eax)
  8030d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 40 08             	mov    0x8(%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	75 08                	jne    8030eb <realloc_block_FF+0x123>
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	a3 18 41 80 00       	mov    %eax,0x804118
  8030eb:	a1 20 41 80 00       	mov    0x804120,%eax
  8030f0:	40                   	inc    %eax
  8030f1:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	e9 14 02 00 00       	jmp    803312 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 40 08             	mov    0x8(%eax),%eax
  803104:	85 c0                	test   %eax,%eax
  803106:	0f 84 97 01 00 00    	je     8032a3 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 40 08             	mov    0x8(%eax),%eax
  803112:	8a 40 04             	mov    0x4(%eax),%al
  803115:	84 c0                	test   %al,%al
  803117:	0f 84 86 01 00 00    	je     8032a3 <realloc_block_FF+0x2db>
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 10                	mov    (%eax),%edx
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 08             	mov    0x8(%eax),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	01 d0                	add    %edx,%eax
  80312c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80312f:	0f 82 6e 01 00 00    	jb     8032a3 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 10                	mov    (%eax),%edx
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	01 c2                	add    %eax,%edx
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 40 08             	mov    0x8(%eax),%eax
  80314f:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 40 08             	mov    0x8(%eax),%eax
  803165:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  803168:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316c:	75 17                	jne    803185 <realloc_block_FF+0x1bd>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 be 3e 80 00       	push   $0x803ebe
  803176:	68 38 01 00 00       	push   $0x138
  80317b:	68 ff 3d 80 00       	push   $0x803dff
  803180:	e8 48 d9 ff ff       	call   800acd <_panic>
  803185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803188:	8b 40 08             	mov    0x8(%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 11                	je     8031a0 <realloc_block_FF+0x1d8>
  80318f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803192:	8b 40 08             	mov    0x8(%eax),%eax
  803195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803198:	8b 52 0c             	mov    0xc(%edx),%edx
  80319b:	89 50 0c             	mov    %edx,0xc(%eax)
  80319e:	eb 0b                	jmp    8031ab <realloc_block_FF+0x1e3>
  8031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a6:	a3 18 41 80 00       	mov    %eax,0x804118
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 11                	je     8031c6 <realloc_block_FF+0x1fe>
  8031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031be:	8b 52 08             	mov    0x8(%edx),%edx
  8031c1:	89 50 08             	mov    %edx,0x8(%eax)
  8031c4:	eb 0b                	jmp    8031d1 <realloc_block_FF+0x209>
  8031c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c9:	8b 40 08             	mov    0x8(%eax),%eax
  8031cc:	a3 14 41 80 00       	mov    %eax,0x804114
  8031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031e5:	a1 20 41 80 00       	mov    0x804120,%eax
  8031ea:	48                   	dec    %eax
  8031eb:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031f8:	83 f8 0f             	cmp    $0xf,%eax
  8031fb:	0f 86 9d 00 00 00    	jbe    80329e <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803204:	8b 45 0c             	mov    0xc(%ebp),%eax
  803207:	01 d0                	add    %edx,%eax
  803209:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	2b 45 0c             	sub    0xc(%ebp),%eax
  803214:	89 c2                	mov    %eax,%edx
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803221:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  803223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803226:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  80322a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322e:	74 06                	je     803236 <realloc_block_FF+0x26e>
  803230:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803234:	75 17                	jne    80324d <realloc_block_FF+0x285>
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	68 18 3e 80 00       	push   $0x803e18
  80323e:	68 3f 01 00 00       	push   $0x13f
  803243:	68 ff 3d 80 00       	push   $0x803dff
  803248:	e8 80 d8 ff ff       	call   800acd <_panic>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 50 08             	mov    0x8(%eax),%edx
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	89 50 08             	mov    %edx,0x8(%eax)
  803259:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325c:	8b 40 08             	mov    0x8(%eax),%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	74 0c                	je     80326f <realloc_block_FF+0x2a7>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 40 08             	mov    0x8(%eax),%eax
  803269:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326c:	89 50 0c             	mov    %edx,0xc(%eax)
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803275:	89 50 08             	mov    %edx,0x8(%eax)
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327e:	89 50 0c             	mov    %edx,0xc(%eax)
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 40 08             	mov    0x8(%eax),%eax
  803287:	85 c0                	test   %eax,%eax
  803289:	75 08                	jne    803293 <realloc_block_FF+0x2cb>
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	a3 18 41 80 00       	mov    %eax,0x804118
  803293:	a1 20 41 80 00       	mov    0x804120,%eax
  803298:	40                   	inc    %eax
  803299:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	eb 6f                	jmp    803312 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  8032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a6:	83 e8 10             	sub    $0x10,%eax
  8032a9:	83 ec 0c             	sub    $0xc,%esp
  8032ac:	50                   	push   %eax
  8032ad:	e8 87 f6 ff ff       	call   802939 <alloc_block_FF>
  8032b2:	83 c4 10             	add    $0x10,%esp
  8032b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  8032b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032bc:	75 29                	jne    8032e7 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  8032be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	50                   	push   %eax
  8032c5:	e8 98 ea ff ff       	call   801d62 <sbrk>
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  8032d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8032d6:	75 07                	jne    8032df <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dd:	eb 33                	jmp    803312 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  8032df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e2:	83 c0 10             	add    $0x10,%eax
  8032e5:	eb 2b                	jmp    803312 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	50                   	push   %eax
  8032f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8032f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f6:	e8 2f e3 ff ff       	call   80162a <memcpy>
  8032fb:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  8032fe:	83 ec 0c             	sub    $0xc,%esp
  803301:	ff 75 f4             	pushl  -0xc(%ebp)
  803304:	e8 d7 fa ff ff       	call   802de0 <free_block>
  803309:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  80330c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330f:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  803312:	c9                   	leave  
  803313:	c3                   	ret    

00803314 <__udivdi3>:
  803314:	55                   	push   %ebp
  803315:	57                   	push   %edi
  803316:	56                   	push   %esi
  803317:	53                   	push   %ebx
  803318:	83 ec 1c             	sub    $0x1c,%esp
  80331b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80331f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803323:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803327:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80332b:	89 ca                	mov    %ecx,%edx
  80332d:	89 f8                	mov    %edi,%eax
  80332f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803333:	85 f6                	test   %esi,%esi
  803335:	75 2d                	jne    803364 <__udivdi3+0x50>
  803337:	39 cf                	cmp    %ecx,%edi
  803339:	77 65                	ja     8033a0 <__udivdi3+0x8c>
  80333b:	89 fd                	mov    %edi,%ebp
  80333d:	85 ff                	test   %edi,%edi
  80333f:	75 0b                	jne    80334c <__udivdi3+0x38>
  803341:	b8 01 00 00 00       	mov    $0x1,%eax
  803346:	31 d2                	xor    %edx,%edx
  803348:	f7 f7                	div    %edi
  80334a:	89 c5                	mov    %eax,%ebp
  80334c:	31 d2                	xor    %edx,%edx
  80334e:	89 c8                	mov    %ecx,%eax
  803350:	f7 f5                	div    %ebp
  803352:	89 c1                	mov    %eax,%ecx
  803354:	89 d8                	mov    %ebx,%eax
  803356:	f7 f5                	div    %ebp
  803358:	89 cf                	mov    %ecx,%edi
  80335a:	89 fa                	mov    %edi,%edx
  80335c:	83 c4 1c             	add    $0x1c,%esp
  80335f:	5b                   	pop    %ebx
  803360:	5e                   	pop    %esi
  803361:	5f                   	pop    %edi
  803362:	5d                   	pop    %ebp
  803363:	c3                   	ret    
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	77 28                	ja     803390 <__udivdi3+0x7c>
  803368:	0f bd fe             	bsr    %esi,%edi
  80336b:	83 f7 1f             	xor    $0x1f,%edi
  80336e:	75 40                	jne    8033b0 <__udivdi3+0x9c>
  803370:	39 ce                	cmp    %ecx,%esi
  803372:	72 0a                	jb     80337e <__udivdi3+0x6a>
  803374:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803378:	0f 87 9e 00 00 00    	ja     80341c <__udivdi3+0x108>
  80337e:	b8 01 00 00 00       	mov    $0x1,%eax
  803383:	89 fa                	mov    %edi,%edx
  803385:	83 c4 1c             	add    $0x1c,%esp
  803388:	5b                   	pop    %ebx
  803389:	5e                   	pop    %esi
  80338a:	5f                   	pop    %edi
  80338b:	5d                   	pop    %ebp
  80338c:	c3                   	ret    
  80338d:	8d 76 00             	lea    0x0(%esi),%esi
  803390:	31 ff                	xor    %edi,%edi
  803392:	31 c0                	xor    %eax,%eax
  803394:	89 fa                	mov    %edi,%edx
  803396:	83 c4 1c             	add    $0x1c,%esp
  803399:	5b                   	pop    %ebx
  80339a:	5e                   	pop    %esi
  80339b:	5f                   	pop    %edi
  80339c:	5d                   	pop    %ebp
  80339d:	c3                   	ret    
  80339e:	66 90                	xchg   %ax,%ax
  8033a0:	89 d8                	mov    %ebx,%eax
  8033a2:	f7 f7                	div    %edi
  8033a4:	31 ff                	xor    %edi,%edi
  8033a6:	89 fa                	mov    %edi,%edx
  8033a8:	83 c4 1c             	add    $0x1c,%esp
  8033ab:	5b                   	pop    %ebx
  8033ac:	5e                   	pop    %esi
  8033ad:	5f                   	pop    %edi
  8033ae:	5d                   	pop    %ebp
  8033af:	c3                   	ret    
  8033b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033b5:	89 eb                	mov    %ebp,%ebx
  8033b7:	29 fb                	sub    %edi,%ebx
  8033b9:	89 f9                	mov    %edi,%ecx
  8033bb:	d3 e6                	shl    %cl,%esi
  8033bd:	89 c5                	mov    %eax,%ebp
  8033bf:	88 d9                	mov    %bl,%cl
  8033c1:	d3 ed                	shr    %cl,%ebp
  8033c3:	89 e9                	mov    %ebp,%ecx
  8033c5:	09 f1                	or     %esi,%ecx
  8033c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e0                	shl    %cl,%eax
  8033cf:	89 c5                	mov    %eax,%ebp
  8033d1:	89 d6                	mov    %edx,%esi
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 ee                	shr    %cl,%esi
  8033d7:	89 f9                	mov    %edi,%ecx
  8033d9:	d3 e2                	shl    %cl,%edx
  8033db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 e8                	shr    %cl,%eax
  8033e3:	09 c2                	or     %eax,%edx
  8033e5:	89 d0                	mov    %edx,%eax
  8033e7:	89 f2                	mov    %esi,%edx
  8033e9:	f7 74 24 0c          	divl   0xc(%esp)
  8033ed:	89 d6                	mov    %edx,%esi
  8033ef:	89 c3                	mov    %eax,%ebx
  8033f1:	f7 e5                	mul    %ebp
  8033f3:	39 d6                	cmp    %edx,%esi
  8033f5:	72 19                	jb     803410 <__udivdi3+0xfc>
  8033f7:	74 0b                	je     803404 <__udivdi3+0xf0>
  8033f9:	89 d8                	mov    %ebx,%eax
  8033fb:	31 ff                	xor    %edi,%edi
  8033fd:	e9 58 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  803402:	66 90                	xchg   %ax,%ax
  803404:	8b 54 24 08          	mov    0x8(%esp),%edx
  803408:	89 f9                	mov    %edi,%ecx
  80340a:	d3 e2                	shl    %cl,%edx
  80340c:	39 c2                	cmp    %eax,%edx
  80340e:	73 e9                	jae    8033f9 <__udivdi3+0xe5>
  803410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803413:	31 ff                	xor    %edi,%edi
  803415:	e9 40 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	31 c0                	xor    %eax,%eax
  80341e:	e9 37 ff ff ff       	jmp    80335a <__udivdi3+0x46>
  803423:	90                   	nop

00803424 <__umoddi3>:
  803424:	55                   	push   %ebp
  803425:	57                   	push   %edi
  803426:	56                   	push   %esi
  803427:	53                   	push   %ebx
  803428:	83 ec 1c             	sub    $0x1c,%esp
  80342b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80342f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803437:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80343b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80343f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803443:	89 f3                	mov    %esi,%ebx
  803445:	89 fa                	mov    %edi,%edx
  803447:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80344b:	89 34 24             	mov    %esi,(%esp)
  80344e:	85 c0                	test   %eax,%eax
  803450:	75 1a                	jne    80346c <__umoddi3+0x48>
  803452:	39 f7                	cmp    %esi,%edi
  803454:	0f 86 a2 00 00 00    	jbe    8034fc <__umoddi3+0xd8>
  80345a:	89 c8                	mov    %ecx,%eax
  80345c:	89 f2                	mov    %esi,%edx
  80345e:	f7 f7                	div    %edi
  803460:	89 d0                	mov    %edx,%eax
  803462:	31 d2                	xor    %edx,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	39 f0                	cmp    %esi,%eax
  80346e:	0f 87 ac 00 00 00    	ja     803520 <__umoddi3+0xfc>
  803474:	0f bd e8             	bsr    %eax,%ebp
  803477:	83 f5 1f             	xor    $0x1f,%ebp
  80347a:	0f 84 ac 00 00 00    	je     80352c <__umoddi3+0x108>
  803480:	bf 20 00 00 00       	mov    $0x20,%edi
  803485:	29 ef                	sub    %ebp,%edi
  803487:	89 fe                	mov    %edi,%esi
  803489:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e0                	shl    %cl,%eax
  803491:	89 d7                	mov    %edx,%edi
  803493:	89 f1                	mov    %esi,%ecx
  803495:	d3 ef                	shr    %cl,%edi
  803497:	09 c7                	or     %eax,%edi
  803499:	89 e9                	mov    %ebp,%ecx
  80349b:	d3 e2                	shl    %cl,%edx
  80349d:	89 14 24             	mov    %edx,(%esp)
  8034a0:	89 d8                	mov    %ebx,%eax
  8034a2:	d3 e0                	shl    %cl,%eax
  8034a4:	89 c2                	mov    %eax,%edx
  8034a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034aa:	d3 e0                	shl    %cl,%eax
  8034ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b4:	89 f1                	mov    %esi,%ecx
  8034b6:	d3 e8                	shr    %cl,%eax
  8034b8:	09 d0                	or     %edx,%eax
  8034ba:	d3 eb                	shr    %cl,%ebx
  8034bc:	89 da                	mov    %ebx,%edx
  8034be:	f7 f7                	div    %edi
  8034c0:	89 d3                	mov    %edx,%ebx
  8034c2:	f7 24 24             	mull   (%esp)
  8034c5:	89 c6                	mov    %eax,%esi
  8034c7:	89 d1                	mov    %edx,%ecx
  8034c9:	39 d3                	cmp    %edx,%ebx
  8034cb:	0f 82 87 00 00 00    	jb     803558 <__umoddi3+0x134>
  8034d1:	0f 84 91 00 00 00    	je     803568 <__umoddi3+0x144>
  8034d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034db:	29 f2                	sub    %esi,%edx
  8034dd:	19 cb                	sbb    %ecx,%ebx
  8034df:	89 d8                	mov    %ebx,%eax
  8034e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034e5:	d3 e0                	shl    %cl,%eax
  8034e7:	89 e9                	mov    %ebp,%ecx
  8034e9:	d3 ea                	shr    %cl,%edx
  8034eb:	09 d0                	or     %edx,%eax
  8034ed:	89 e9                	mov    %ebp,%ecx
  8034ef:	d3 eb                	shr    %cl,%ebx
  8034f1:	89 da                	mov    %ebx,%edx
  8034f3:	83 c4 1c             	add    $0x1c,%esp
  8034f6:	5b                   	pop    %ebx
  8034f7:	5e                   	pop    %esi
  8034f8:	5f                   	pop    %edi
  8034f9:	5d                   	pop    %ebp
  8034fa:	c3                   	ret    
  8034fb:	90                   	nop
  8034fc:	89 fd                	mov    %edi,%ebp
  8034fe:	85 ff                	test   %edi,%edi
  803500:	75 0b                	jne    80350d <__umoddi3+0xe9>
  803502:	b8 01 00 00 00       	mov    $0x1,%eax
  803507:	31 d2                	xor    %edx,%edx
  803509:	f7 f7                	div    %edi
  80350b:	89 c5                	mov    %eax,%ebp
  80350d:	89 f0                	mov    %esi,%eax
  80350f:	31 d2                	xor    %edx,%edx
  803511:	f7 f5                	div    %ebp
  803513:	89 c8                	mov    %ecx,%eax
  803515:	f7 f5                	div    %ebp
  803517:	89 d0                	mov    %edx,%eax
  803519:	e9 44 ff ff ff       	jmp    803462 <__umoddi3+0x3e>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	89 c8                	mov    %ecx,%eax
  803522:	89 f2                	mov    %esi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	3b 04 24             	cmp    (%esp),%eax
  80352f:	72 06                	jb     803537 <__umoddi3+0x113>
  803531:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803535:	77 0f                	ja     803546 <__umoddi3+0x122>
  803537:	89 f2                	mov    %esi,%edx
  803539:	29 f9                	sub    %edi,%ecx
  80353b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80353f:	89 14 24             	mov    %edx,(%esp)
  803542:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803546:	8b 44 24 04          	mov    0x4(%esp),%eax
  80354a:	8b 14 24             	mov    (%esp),%edx
  80354d:	83 c4 1c             	add    $0x1c,%esp
  803550:	5b                   	pop    %ebx
  803551:	5e                   	pop    %esi
  803552:	5f                   	pop    %edi
  803553:	5d                   	pop    %ebp
  803554:	c3                   	ret    
  803555:	8d 76 00             	lea    0x0(%esi),%esi
  803558:	2b 04 24             	sub    (%esp),%eax
  80355b:	19 fa                	sbb    %edi,%edx
  80355d:	89 d1                	mov    %edx,%ecx
  80355f:	89 c6                	mov    %eax,%esi
  803561:	e9 71 ff ff ff       	jmp    8034d7 <__umoddi3+0xb3>
  803566:	66 90                	xchg   %ax,%ax
  803568:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80356c:	72 ea                	jb     803558 <__umoddi3+0x134>
  80356e:	89 d9                	mov    %ebx,%ecx
  803570:	e9 62 ff ff ff       	jmp    8034d7 <__umoddi3+0xb3>
