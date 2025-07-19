
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 eb 01 00 00       	call   800221 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	cprintf("PART I: Test the Pointer Validation inside fault_handler():\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 00 1c 80 00       	push   $0x801c00
  800046:	e8 e1 03 00 00       	call   80042c <cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================\n");
  80004e:	83 ec 0c             	sub    $0xc,%esp
  800051:	68 40 1c 80 00       	push   $0x801c40
  800056:	e8 d1 03 00 00       	call   80042c <cprintf>
  80005b:	83 c4 10             	add    $0x10,%esp
		rsttst();
  80005e:	e8 23 16 00 00       	call   801686 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800063:	a1 20 30 80 00       	mov    0x803020,%eax
  800068:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	a1 20 30 80 00       	mov    0x803020,%eax
  800080:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  800086:	52                   	push   %edx
  800087:	51                   	push   %ecx
  800088:	50                   	push   %eax
  800089:	68 7d 1c 80 00       	push   $0x801c7d
  80008e:	e8 a7 14 00 00       	call   80153a <sys_create_env>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	ff 75 f4             	pushl  -0xc(%ebp)
  80009f:	e8 b4 14 00 00       	call   801558 <sys_run_env>
  8000a4:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  8000b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8000bd:	89 c1                	mov    %eax,%ecx
  8000bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c4:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8000ca:	52                   	push   %edx
  8000cb:	51                   	push   %ecx
  8000cc:	50                   	push   %eax
  8000cd:	68 88 1c 80 00       	push   $0x801c88
  8000d2:	e8 63 14 00 00       	call   80153a <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID2);
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e3:	e8 70 14 00 00       	call   801558 <sys_run_env>
  8000e8:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  8000f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fb:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800101:	89 c1                	mov    %eax,%ecx
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  80010e:	52                   	push   %edx
  80010f:	51                   	push   %ecx
  800110:	50                   	push   %eax
  800111:	68 93 1c 80 00       	push   $0x801c93
  800116:	e8 1f 14 00 00       	call   80153a <sys_create_env>
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID3);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	ff 75 ec             	pushl  -0x14(%ebp)
  800127:	e8 2c 14 00 00       	call   801558 <sys_run_env>
  80012c:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 10 27 00 00       	push   $0x2710
  800137:	e8 a7 17 00 00       	call   8018e3 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  80013f:	e8 bc 15 00 00       	call   801700 <gettst>
  800144:	85 c0                	test   %eax,%eax
  800146:	74 12                	je     80015a <_main+0x122>
		cprintf("\nPART I... Failed.\n");
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	68 9e 1c 80 00       	push   $0x801c9e
  800150:	e8 d7 02 00 00       	call   80042c <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb 10                	jmp    80016a <_main+0x132>
	else
		cprintf("\nPART I... completed successfully\n\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 b4 1c 80 00       	push   $0x801cb4
  800162:	e8 c5 02 00 00       	call   80042c <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp


	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap:\n");
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	68 d8 1c 80 00       	push   $0x801cd8
  800172:	e8 b5 02 00 00       	call   80042c <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================================================\n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 38 1d 80 00       	push   $0x801d38
  800182:	e8 a5 02 00 00       	call   80042c <cprintf>
  800187:	83 c4 10             	add    $0x10,%esp

	rsttst();
  80018a:	e8 f7 14 00 00       	call   801686 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 90 c0 05 00 00    	mov    0x5c0(%eax),%edx
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001a5:	89 c1                	mov    %eax,%ecx
  8001a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ac:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
  8001b2:	52                   	push   %edx
  8001b3:	51                   	push   %ecx
  8001b4:	50                   	push   %eax
  8001b5:	68 95 1d 80 00       	push   $0x801d95
  8001ba:	e8 7b 13 00 00       	call   80153a <sys_create_env>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID4);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001cb:	e8 88 13 00 00       	call   801558 <sys_run_env>
  8001d0:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 10 27 00 00       	push   $0x2710
  8001db:	e8 03 17 00 00       	call   8018e3 <env_sleep>
  8001e0:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001e3:	e8 18 15 00 00       	call   801700 <gettst>
  8001e8:	85 c0                	test   %eax,%eax
  8001ea:	74 12                	je     8001fe <_main+0x1c6>
		cprintf("\nPART II... Failed.\n");
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	68 a0 1d 80 00       	push   $0x801da0
  8001f4:	e8 33 02 00 00       	call   80042c <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb 10                	jmp    80020e <_main+0x1d6>
	else
		cprintf("\nPART II... completed successfully\n\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 b8 1d 80 00       	push   $0x801db8
  800206:	e8 21 02 00 00       	call   80042c <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations... test invalid access completed successfully\n");
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	68 e0 1d 80 00       	push   $0x801de0
  800216:	e8 11 02 00 00       	call   80042c <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp
}
  80021e:	90                   	nop
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800227:	e8 7c 13 00 00       	call   8015a8 <sys_getenvindex>
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80022f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	c1 e0 03             	shl    $0x3,%eax
  800237:	01 d0                	add    %edx,%eax
  800239:	01 c0                	add    %eax,%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800244:	01 d0                	add    %edx,%eax
  800246:	c1 e0 04             	shl    $0x4,%eax
  800249:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80024e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800253:	a1 20 30 80 00       	mov    0x803020,%eax
  800258:	8a 40 5c             	mov    0x5c(%eax),%al
  80025b:	84 c0                	test   %al,%al
  80025d:	74 0d                	je     80026c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	83 c0 5c             	add    $0x5c,%eax
  800267:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80026c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800270:	7e 0a                	jle    80027c <libmain+0x5b>
		binaryname = argv[0];
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	8b 00                	mov    (%eax),%eax
  800277:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	ff 75 0c             	pushl  0xc(%ebp)
  800282:	ff 75 08             	pushl  0x8(%ebp)
  800285:	e8 ae fd ff ff       	call   800038 <_main>
  80028a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80028d:	e8 23 11 00 00       	call   8013b5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	68 38 1e 80 00       	push   $0x801e38
  80029a:	e8 8d 01 00 00       	call   80042c <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a7:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8002ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b2:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002b8:	83 ec 04             	sub    $0x4,%esp
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	68 60 1e 80 00       	push   $0x801e60
  8002c2:	e8 65 01 00 00       	call   80042c <cprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cf:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8002e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e5:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	50                   	push   %eax
  8002ee:	68 88 1e 80 00       	push   $0x801e88
  8002f3:	e8 34 01 00 00       	call   80042c <cprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800300:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 e0 1e 80 00       	push   $0x801ee0
  80030f:	e8 18 01 00 00       	call   80042c <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 38 1e 80 00       	push   $0x801e38
  80031f:	e8 08 01 00 00       	call   80042c <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800327:	e8 a3 10 00 00       	call   8013cf <sys_enable_interrupt>

	// exit gracefully
	exit();
  80032c:	e8 19 00 00 00       	call   80034a <exit>
}
  800331:	90                   	nop
  800332:	c9                   	leave  
  800333:	c3                   	ret    

00800334 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	6a 00                	push   $0x0
  80033f:	e8 30 12 00 00       	call   801574 <sys_destroy_env>
  800344:	83 c4 10             	add    $0x10,%esp
}
  800347:	90                   	nop
  800348:	c9                   	leave  
  800349:	c3                   	ret    

0080034a <exit>:

void
exit(void)
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800350:	e8 85 12 00 00       	call   8015da <sys_exit_env>
}
  800355:	90                   	nop
  800356:	c9                   	leave  
  800357:	c3                   	ret    

00800358 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80035e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	8d 48 01             	lea    0x1(%eax),%ecx
  800366:	8b 55 0c             	mov    0xc(%ebp),%edx
  800369:	89 0a                	mov    %ecx,(%edx)
  80036b:	8b 55 08             	mov    0x8(%ebp),%edx
  80036e:	88 d1                	mov    %dl,%cl
  800370:	8b 55 0c             	mov    0xc(%ebp),%edx
  800373:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800381:	75 2c                	jne    8003af <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800383:	a0 24 30 80 00       	mov    0x803024,%al
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	8b 12                	mov    (%edx),%edx
  800390:	89 d1                	mov    %edx,%ecx
  800392:	8b 55 0c             	mov    0xc(%ebp),%edx
  800395:	83 c2 08             	add    $0x8,%edx
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	50                   	push   %eax
  80039c:	51                   	push   %ecx
  80039d:	52                   	push   %edx
  80039e:	e8 b9 0e 00 00       	call   80125c <sys_cputs>
  8003a3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	8b 40 04             	mov    0x4(%eax),%eax
  8003b5:	8d 50 01             	lea    0x1(%eax),%edx
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003be:	90                   	nop
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    

008003c1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d1:	00 00 00 
	b.cnt = 0;
  8003d4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003db:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ea:	50                   	push   %eax
  8003eb:	68 58 03 80 00       	push   $0x800358
  8003f0:	e8 11 02 00 00       	call   800606 <vprintfmt>
  8003f5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003f8:	a0 24 30 80 00       	mov    0x803024,%al
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	50                   	push   %eax
  80040a:	52                   	push   %edx
  80040b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800411:	83 c0 08             	add    $0x8,%eax
  800414:	50                   	push   %eax
  800415:	e8 42 0e 00 00       	call   80125c <sys_cputs>
  80041a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80041d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800424:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <cprintf>:

int cprintf(const char *fmt, ...) {
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800432:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800439:	8d 45 0c             	lea    0xc(%ebp),%eax
  80043c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 f4             	pushl  -0xc(%ebp)
  800448:	50                   	push   %eax
  800449:	e8 73 ff ff ff       	call   8003c1 <vcprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800454:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80045f:	e8 51 0f 00 00       	call   8013b5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800464:	8d 45 0c             	lea    0xc(%ebp),%eax
  800467:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 f4             	pushl  -0xc(%ebp)
  800473:	50                   	push   %eax
  800474:	e8 48 ff ff ff       	call   8003c1 <vcprintf>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80047f:	e8 4b 0f 00 00       	call   8013cf <sys_enable_interrupt>
	return cnt;
  800484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	53                   	push   %ebx
  80048d:	83 ec 14             	sub    $0x14,%esp
  800490:	8b 45 10             	mov    0x10(%ebp),%eax
  800493:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80049c:	8b 45 18             	mov    0x18(%ebp),%eax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004a7:	77 55                	ja     8004fe <printnum+0x75>
  8004a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ac:	72 05                	jb     8004b3 <printnum+0x2a>
  8004ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004b1:	77 4b                	ja     8004fe <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004b3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004b6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c1:	52                   	push   %edx
  8004c2:	50                   	push   %eax
  8004c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004c9:	e8 ca 14 00 00       	call   801998 <__udivdi3>
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	83 ec 04             	sub    $0x4,%esp
  8004d4:	ff 75 20             	pushl  0x20(%ebp)
  8004d7:	53                   	push   %ebx
  8004d8:	ff 75 18             	pushl  0x18(%ebp)
  8004db:	52                   	push   %edx
  8004dc:	50                   	push   %eax
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	e8 a1 ff ff ff       	call   800489 <printnum>
  8004e8:	83 c4 20             	add    $0x20,%esp
  8004eb:	eb 1a                	jmp    800507 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 20             	pushl  0x20(%ebp)
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	ff d0                	call   *%eax
  8004fb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004fe:	ff 4d 1c             	decl   0x1c(%ebp)
  800501:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800505:	7f e6                	jg     8004ed <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800507:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80050a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80050f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800512:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800515:	53                   	push   %ebx
  800516:	51                   	push   %ecx
  800517:	52                   	push   %edx
  800518:	50                   	push   %eax
  800519:	e8 8a 15 00 00       	call   801aa8 <__umoddi3>
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	05 14 21 80 00       	add    $0x802114,%eax
  800526:	8a 00                	mov    (%eax),%al
  800528:	0f be c0             	movsbl %al,%eax
  80052b:	83 ec 08             	sub    $0x8,%esp
  80052e:	ff 75 0c             	pushl  0xc(%ebp)
  800531:	50                   	push   %eax
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	ff d0                	call   *%eax
  800537:	83 c4 10             	add    $0x10,%esp
}
  80053a:	90                   	nop
  80053b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800543:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800547:	7e 1c                	jle    800565 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 50 08             	lea    0x8(%eax),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	89 10                	mov    %edx,(%eax)
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	83 e8 08             	sub    $0x8,%eax
  80055e:	8b 50 04             	mov    0x4(%eax),%edx
  800561:	8b 00                	mov    (%eax),%eax
  800563:	eb 40                	jmp    8005a5 <getuint+0x65>
	else if (lflag)
  800565:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800569:	74 1e                	je     800589 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 04             	lea    0x4(%eax),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	83 e8 04             	sub    $0x4,%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	eb 1c                	jmp    8005a5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	8d 50 04             	lea    0x4(%eax),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	89 10                	mov    %edx,(%eax)
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	83 e8 04             	sub    $0x4,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005a5:	5d                   	pop    %ebp
  8005a6:	c3                   	ret    

008005a7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ae:	7e 1c                	jle    8005cc <getint+0x25>
		return va_arg(*ap, long long);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	8d 50 08             	lea    0x8(%eax),%edx
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	89 10                	mov    %edx,(%eax)
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	83 e8 08             	sub    $0x8,%eax
  8005c5:	8b 50 04             	mov    0x4(%eax),%edx
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	eb 38                	jmp    800604 <getint+0x5d>
	else if (lflag)
  8005cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005d0:	74 1a                	je     8005ec <getint+0x45>
		return va_arg(*ap, long);
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	8d 50 04             	lea    0x4(%eax),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	89 10                	mov    %edx,(%eax)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	83 e8 04             	sub    $0x4,%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	99                   	cltd   
  8005ea:	eb 18                	jmp    800604 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 10                	mov    %edx,(%eax)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	83 e8 04             	sub    $0x4,%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	99                   	cltd   
}
  800604:	5d                   	pop    %ebp
  800605:	c3                   	ret    

00800606 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	56                   	push   %esi
  80060a:	53                   	push   %ebx
  80060b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80060e:	eb 17                	jmp    800627 <vprintfmt+0x21>
			if (ch == '\0')
  800610:	85 db                	test   %ebx,%ebx
  800612:	0f 84 af 03 00 00    	je     8009c7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	53                   	push   %ebx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800627:	8b 45 10             	mov    0x10(%ebp),%eax
  80062a:	8d 50 01             	lea    0x1(%eax),%edx
  80062d:	89 55 10             	mov    %edx,0x10(%ebp)
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f b6 d8             	movzbl %al,%ebx
  800635:	83 fb 25             	cmp    $0x25,%ebx
  800638:	75 d6                	jne    800610 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80063a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80063e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800645:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80064c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800653:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065a:	8b 45 10             	mov    0x10(%ebp),%eax
  80065d:	8d 50 01             	lea    0x1(%eax),%edx
  800660:	89 55 10             	mov    %edx,0x10(%ebp)
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f b6 d8             	movzbl %al,%ebx
  800668:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80066b:	83 f8 55             	cmp    $0x55,%eax
  80066e:	0f 87 2b 03 00 00    	ja     80099f <vprintfmt+0x399>
  800674:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  80067b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80067d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800681:	eb d7                	jmp    80065a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800683:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800687:	eb d1                	jmp    80065a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800689:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800690:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800693:	89 d0                	mov    %edx,%eax
  800695:	c1 e0 02             	shl    $0x2,%eax
  800698:	01 d0                	add    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d8                	add    %ebx,%eax
  80069e:	83 e8 30             	sub    $0x30,%eax
  8006a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a7:	8a 00                	mov    (%eax),%al
  8006a9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ac:	83 fb 2f             	cmp    $0x2f,%ebx
  8006af:	7e 3e                	jle    8006ef <vprintfmt+0xe9>
  8006b1:	83 fb 39             	cmp    $0x39,%ebx
  8006b4:	7f 39                	jg     8006ef <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006b9:	eb d5                	jmp    800690 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	83 c0 04             	add    $0x4,%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006cf:	eb 1f                	jmp    8006f0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	79 83                	jns    80065a <vprintfmt+0x54>
				width = 0;
  8006d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006de:	e9 77 ff ff ff       	jmp    80065a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006e3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006ea:	e9 6b ff ff ff       	jmp    80065a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006ef:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f4:	0f 89 60 ff ff ff    	jns    80065a <vprintfmt+0x54>
				width = precision, precision = -1;
  8006fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800700:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800707:	e9 4e ff ff ff       	jmp    80065a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80070c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80070f:	e9 46 ff ff ff       	jmp    80065a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	83 c0 04             	add    $0x4,%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	50                   	push   %eax
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
			break;
  800734:	e9 89 02 00 00       	jmp    8009c2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	83 c0 04             	add    $0x4,%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 e8 04             	sub    $0x4,%eax
  800748:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	79 02                	jns    800750 <vprintfmt+0x14a>
				err = -err;
  80074e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800750:	83 fb 64             	cmp    $0x64,%ebx
  800753:	7f 0b                	jg     800760 <vprintfmt+0x15a>
  800755:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  80075c:	85 f6                	test   %esi,%esi
  80075e:	75 19                	jne    800779 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800760:	53                   	push   %ebx
  800761:	68 25 21 80 00       	push   $0x802125
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	ff 75 08             	pushl  0x8(%ebp)
  80076c:	e8 5e 02 00 00       	call   8009cf <printfmt>
  800771:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800774:	e9 49 02 00 00       	jmp    8009c2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800779:	56                   	push   %esi
  80077a:	68 2e 21 80 00       	push   $0x80212e
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	ff 75 08             	pushl  0x8(%ebp)
  800785:	e8 45 02 00 00       	call   8009cf <printfmt>
  80078a:	83 c4 10             	add    $0x10,%esp
			break;
  80078d:	e9 30 02 00 00       	jmp    8009c2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	83 c0 04             	add    $0x4,%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	83 e8 04             	sub    $0x4,%eax
  8007a1:	8b 30                	mov    (%eax),%esi
  8007a3:	85 f6                	test   %esi,%esi
  8007a5:	75 05                	jne    8007ac <vprintfmt+0x1a6>
				p = "(null)";
  8007a7:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  8007ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b0:	7e 6d                	jle    80081f <vprintfmt+0x219>
  8007b2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007b6:	74 67                	je     80081f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	50                   	push   %eax
  8007bf:	56                   	push   %esi
  8007c0:	e8 0c 03 00 00       	call   800ad1 <strnlen>
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007cb:	eb 16                	jmp    8007e3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007cd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	ff 75 0c             	pushl  0xc(%ebp)
  8007d7:	50                   	push   %eax
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	ff d0                	call   *%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	7f e4                	jg     8007cd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e9:	eb 34                	jmp    80081f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ef:	74 1c                	je     80080d <vprintfmt+0x207>
  8007f1:	83 fb 1f             	cmp    $0x1f,%ebx
  8007f4:	7e 05                	jle    8007fb <vprintfmt+0x1f5>
  8007f6:	83 fb 7e             	cmp    $0x7e,%ebx
  8007f9:	7e 12                	jle    80080d <vprintfmt+0x207>
					putch('?', putdat);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	6a 3f                	push   $0x3f
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	ff d0                	call   *%eax
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	eb 0f                	jmp    80081c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	53                   	push   %ebx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081c:	ff 4d e4             	decl   -0x1c(%ebp)
  80081f:	89 f0                	mov    %esi,%eax
  800821:	8d 70 01             	lea    0x1(%eax),%esi
  800824:	8a 00                	mov    (%eax),%al
  800826:	0f be d8             	movsbl %al,%ebx
  800829:	85 db                	test   %ebx,%ebx
  80082b:	74 24                	je     800851 <vprintfmt+0x24b>
  80082d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800831:	78 b8                	js     8007eb <vprintfmt+0x1e5>
  800833:	ff 4d e0             	decl   -0x20(%ebp)
  800836:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80083a:	79 af                	jns    8007eb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80083c:	eb 13                	jmp    800851 <vprintfmt+0x24b>
				putch(' ', putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	6a 20                	push   $0x20
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	ff 4d e4             	decl   -0x1c(%ebp)
  800851:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800855:	7f e7                	jg     80083e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800857:	e9 66 01 00 00       	jmp    8009c2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 e8             	pushl  -0x18(%ebp)
  800862:	8d 45 14             	lea    0x14(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	e8 3c fd ff ff       	call   8005a7 <getint>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800871:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087a:	85 d2                	test   %edx,%edx
  80087c:	79 23                	jns    8008a1 <vprintfmt+0x29b>
				putch('-', putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	6a 2d                	push   $0x2d
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	ff d0                	call   *%eax
  80088b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800894:	f7 d8                	neg    %eax
  800896:	83 d2 00             	adc    $0x0,%edx
  800899:	f7 da                	neg    %edx
  80089b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008a8:	e9 bc 00 00 00       	jmp    800969 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	e8 84 fc ff ff       	call   800540 <getuint>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008cc:	e9 98 00 00 00       	jmp    800969 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	6a 58                	push   $0x58
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	ff d0                	call   *%eax
  8008de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	6a 58                	push   $0x58
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 58                	push   $0x58
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			break;
  800901:	e9 bc 00 00 00       	jmp    8009c2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	6a 30                	push   $0x30
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	ff d0                	call   *%eax
  800913:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	6a 78                	push   $0x78
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800941:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800948:	eb 1f                	jmp    800969 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 e8             	pushl  -0x18(%ebp)
  800950:	8d 45 14             	lea    0x14(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	e8 e7 fb ff ff       	call   800540 <getuint>
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800962:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800969:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80096d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800970:	83 ec 04             	sub    $0x4,%esp
  800973:	52                   	push   %edx
  800974:	ff 75 e4             	pushl  -0x1c(%ebp)
  800977:	50                   	push   %eax
  800978:	ff 75 f4             	pushl  -0xc(%ebp)
  80097b:	ff 75 f0             	pushl  -0x10(%ebp)
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 00 fb ff ff       	call   800489 <printnum>
  800989:	83 c4 20             	add    $0x20,%esp
			break;
  80098c:	eb 34                	jmp    8009c2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
			break;
  80099d:	eb 23                	jmp    8009c2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	6a 25                	push   $0x25
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009af:	ff 4d 10             	decl   0x10(%ebp)
  8009b2:	eb 03                	jmp    8009b7 <vprintfmt+0x3b1>
  8009b4:	ff 4d 10             	decl   0x10(%ebp)
  8009b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ba:	48                   	dec    %eax
  8009bb:	8a 00                	mov    (%eax),%al
  8009bd:	3c 25                	cmp    $0x25,%al
  8009bf:	75 f3                	jne    8009b4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009c1:	90                   	nop
		}
	}
  8009c2:	e9 47 fc ff ff       	jmp    80060e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009c7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009cb:	5b                   	pop    %ebx
  8009cc:	5e                   	pop    %esi
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e4:	50                   	push   %eax
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	ff 75 08             	pushl  0x8(%ebp)
  8009eb:	e8 16 fc ff ff       	call   800606 <vprintfmt>
  8009f0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009f3:	90                   	nop
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	8b 40 08             	mov    0x8(%eax),%eax
  8009ff:	8d 50 01             	lea    0x1(%eax),%edx
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0b:	8b 10                	mov    (%eax),%edx
  800a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a10:	8b 40 04             	mov    0x4(%eax),%eax
  800a13:	39 c2                	cmp    %eax,%edx
  800a15:	73 12                	jae    800a29 <sprintputch+0x33>
		*b->buf++ = ch;
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	89 0a                	mov    %ecx,(%edx)
  800a24:	8b 55 08             	mov    0x8(%ebp),%edx
  800a27:	88 10                	mov    %dl,(%eax)
}
  800a29:	90                   	nop
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	01 d0                	add    %edx,%eax
  800a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a51:	74 06                	je     800a59 <vsnprintf+0x2d>
  800a53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a57:	7f 07                	jg     800a60 <vsnprintf+0x34>
		return -E_INVAL;
  800a59:	b8 03 00 00 00       	mov    $0x3,%eax
  800a5e:	eb 20                	jmp    800a80 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a60:	ff 75 14             	pushl  0x14(%ebp)
  800a63:	ff 75 10             	pushl  0x10(%ebp)
  800a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a69:	50                   	push   %eax
  800a6a:	68 f6 09 80 00       	push   $0x8009f6
  800a6f:	e8 92 fb ff ff       	call   800606 <vprintfmt>
  800a74:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a88:	8d 45 10             	lea    0x10(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	ff 75 f4             	pushl  -0xc(%ebp)
  800a97:	50                   	push   %eax
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	ff 75 08             	pushl  0x8(%ebp)
  800a9e:	e8 89 ff ff ff       	call   800a2c <vsnprintf>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aac:	c9                   	leave  
  800aad:	c3                   	ret    

00800aae <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800abb:	eb 06                	jmp    800ac3 <strlen+0x15>
		n++;
  800abd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac0:	ff 45 08             	incl   0x8(%ebp)
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	84 c0                	test   %al,%al
  800aca:	75 f1                	jne    800abd <strlen+0xf>
		n++;
	return n;
  800acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ade:	eb 09                	jmp    800ae9 <strnlen+0x18>
		n++;
  800ae0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae3:	ff 45 08             	incl   0x8(%ebp)
  800ae6:	ff 4d 0c             	decl   0xc(%ebp)
  800ae9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aed:	74 09                	je     800af8 <strnlen+0x27>
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 e8                	jne    800ae0 <strnlen+0xf>
		n++;
	return n;
  800af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b09:	90                   	nop
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8d 50 01             	lea    0x1(%eax),%edx
  800b10:	89 55 08             	mov    %edx,0x8(%ebp)
  800b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b19:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b1c:	8a 12                	mov    (%edx),%dl
  800b1e:	88 10                	mov    %dl,(%eax)
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e4                	jne    800b0a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b3e:	eb 1f                	jmp    800b5f <strncpy+0x34>
		*dst++ = *src;
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	89 55 08             	mov    %edx,0x8(%ebp)
  800b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4c:	8a 12                	mov    (%edx),%dl
  800b4e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	84 c0                	test   %al,%al
  800b57:	74 03                	je     800b5c <strncpy+0x31>
			src++;
  800b59:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b5c:	ff 45 fc             	incl   -0x4(%ebp)
  800b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b65:	72 d9                	jb     800b40 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7c:	74 30                	je     800bae <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b7e:	eb 16                	jmp    800b96 <strlcpy+0x2a>
			*dst++ = *src++;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8d 50 01             	lea    0x1(%eax),%edx
  800b86:	89 55 08             	mov    %edx,0x8(%ebp)
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b92:	8a 12                	mov    (%edx),%dl
  800b94:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b96:	ff 4d 10             	decl   0x10(%ebp)
  800b99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9d:	74 09                	je     800ba8 <strlcpy+0x3c>
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	75 d8                	jne    800b80 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bae:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb4:	29 c2                	sub    %eax,%edx
  800bb6:	89 d0                	mov    %edx,%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bbd:	eb 06                	jmp    800bc5 <strcmp+0xb>
		p++, q++;
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	84 c0                	test   %al,%al
  800bcc:	74 0e                	je     800bdc <strcmp+0x22>
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 10                	mov    (%eax),%dl
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	38 c2                	cmp    %al,%dl
  800bda:	74 e3                	je     800bbf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8a 00                	mov    (%eax),%al
  800be1:	0f b6 d0             	movzbl %al,%edx
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	29 c2                	sub    %eax,%edx
  800bee:	89 d0                	mov    %edx,%eax
}
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bf5:	eb 09                	jmp    800c00 <strncmp+0xe>
		n--, p++, q++;
  800bf7:	ff 4d 10             	decl   0x10(%ebp)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c04:	74 17                	je     800c1d <strncmp+0x2b>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	74 0e                	je     800c1d <strncmp+0x2b>
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 10                	mov    (%eax),%dl
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	38 c2                	cmp    %al,%dl
  800c1b:	74 da                	je     800bf7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c21:	75 07                	jne    800c2a <strncmp+0x38>
		return 0;
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	eb 14                	jmp    800c3e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	0f b6 d0             	movzbl %al,%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	29 c2                	sub    %eax,%edx
  800c3c:	89 d0                	mov    %edx,%eax
}
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 04             	sub    $0x4,%esp
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c4c:	eb 12                	jmp    800c60 <strchr+0x20>
		if (*s == c)
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c56:	75 05                	jne    800c5d <strchr+0x1d>
			return (char *) s;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	eb 11                	jmp    800c6e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e5                	jne    800c4e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 04             	sub    $0x4,%esp
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7c:	eb 0d                	jmp    800c8b <strfind+0x1b>
		if (*s == c)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c86:	74 0e                	je     800c96 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	84 c0                	test   %al,%al
  800c92:	75 ea                	jne    800c7e <strfind+0xe>
  800c94:	eb 01                	jmp    800c97 <strfind+0x27>
		if (*s == c)
			break;
  800c96:	90                   	nop
	return (char *) s;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cae:	eb 0e                	jmp    800cbe <memset+0x22>
		*p++ = c;
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cbe:	ff 4d f8             	decl   -0x8(%ebp)
  800cc1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cc5:	79 e9                	jns    800cb0 <memset+0x14>
		*p++ = c;

	return v;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cde:	eb 16                	jmp    800cf6 <memcpy+0x2a>
		*d++ = *s++;
  800ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce3:	8d 50 01             	lea    0x1(%eax),%edx
  800ce6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cf2:	8a 12                	mov    (%edx),%dl
  800cf4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	75 dd                	jne    800ce0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d20:	73 50                	jae    800d72 <memmove+0x6a>
  800d22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	01 d0                	add    %edx,%eax
  800d2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d2d:	76 43                	jbe    800d72 <memmove+0x6a>
		s += n;
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d3b:	eb 10                	jmp    800d4d <memmove+0x45>
			*--d = *--s;
  800d3d:	ff 4d f8             	decl   -0x8(%ebp)
  800d40:	ff 4d fc             	decl   -0x4(%ebp)
  800d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d46:	8a 10                	mov    (%eax),%dl
  800d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d4b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d53:	89 55 10             	mov    %edx,0x10(%ebp)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	75 e3                	jne    800d3d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d5a:	eb 23                	jmp    800d7f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5f:	8d 50 01             	lea    0x1(%eax),%edx
  800d62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d6e:	8a 12                	mov    (%edx),%dl
  800d70:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d78:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	75 dd                	jne    800d5c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d96:	eb 2a                	jmp    800dc2 <memcmp+0x3e>
		if (*s1 != *s2)
  800d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9b:	8a 10                	mov    (%eax),%dl
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	38 c2                	cmp    %al,%dl
  800da4:	74 16                	je     800dbc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	0f b6 d0             	movzbl %al,%edx
  800dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	0f b6 c0             	movzbl %al,%eax
  800db6:	29 c2                	sub    %eax,%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	eb 18                	jmp    800dd4 <memcmp+0x50>
		s1++, s2++;
  800dbc:	ff 45 fc             	incl   -0x4(%ebp)
  800dbf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	75 c9                	jne    800d98 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800de7:	eb 15                	jmp    800dfe <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d0             	movzbl %al,%edx
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	39 c2                	cmp    %eax,%edx
  800df9:	74 0d                	je     800e08 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e04:	72 e3                	jb     800de9 <memfind+0x13>
  800e06:	eb 01                	jmp    800e09 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e08:	90                   	nop
	return (void *) s;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e1b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e22:	eb 03                	jmp    800e27 <strtol+0x19>
		s++;
  800e24:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3c 20                	cmp    $0x20,%al
  800e2e:	74 f4                	je     800e24 <strtol+0x16>
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3c 09                	cmp    $0x9,%al
  800e37:	74 eb                	je     800e24 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3c 2b                	cmp    $0x2b,%al
  800e40:	75 05                	jne    800e47 <strtol+0x39>
		s++;
  800e42:	ff 45 08             	incl   0x8(%ebp)
  800e45:	eb 13                	jmp    800e5a <strtol+0x4c>
	else if (*s == '-')
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3c 2d                	cmp    $0x2d,%al
  800e4e:	75 0a                	jne    800e5a <strtol+0x4c>
		s++, neg = 1;
  800e50:	ff 45 08             	incl   0x8(%ebp)
  800e53:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5e:	74 06                	je     800e66 <strtol+0x58>
  800e60:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e64:	75 20                	jne    800e86 <strtol+0x78>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3c 30                	cmp    $0x30,%al
  800e6d:	75 17                	jne    800e86 <strtol+0x78>
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	40                   	inc    %eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 78                	cmp    $0x78,%al
  800e77:	75 0d                	jne    800e86 <strtol+0x78>
		s += 2, base = 16;
  800e79:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e7d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e84:	eb 28                	jmp    800eae <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8a:	75 15                	jne    800ea1 <strtol+0x93>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	3c 30                	cmp    $0x30,%al
  800e93:	75 0c                	jne    800ea1 <strtol+0x93>
		s++, base = 8;
  800e95:	ff 45 08             	incl   0x8(%ebp)
  800e98:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e9f:	eb 0d                	jmp    800eae <strtol+0xa0>
	else if (base == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strtol+0xa0>
		base = 10;
  800ea7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	3c 2f                	cmp    $0x2f,%al
  800eb5:	7e 19                	jle    800ed0 <strtol+0xc2>
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	3c 39                	cmp    $0x39,%al
  800ebe:	7f 10                	jg     800ed0 <strtol+0xc2>
			dig = *s - '0';
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	0f be c0             	movsbl %al,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ece:	eb 42                	jmp    800f12 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	3c 60                	cmp    $0x60,%al
  800ed7:	7e 19                	jle    800ef2 <strtol+0xe4>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3c 7a                	cmp    $0x7a,%al
  800ee0:	7f 10                	jg     800ef2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f be c0             	movsbl %al,%eax
  800eea:	83 e8 57             	sub    $0x57,%eax
  800eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef0:	eb 20                	jmp    800f12 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 40                	cmp    $0x40,%al
  800ef9:	7e 39                	jle    800f34 <strtol+0x126>
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 5a                	cmp    $0x5a,%al
  800f02:	7f 30                	jg     800f34 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f be c0             	movsbl %al,%eax
  800f0c:	83 e8 37             	sub    $0x37,%eax
  800f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f15:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f18:	7d 19                	jge    800f33 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f24:	89 c2                	mov    %eax,%edx
  800f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f2e:	e9 7b ff ff ff       	jmp    800eae <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f33:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f38:	74 08                	je     800f42 <strtol+0x134>
		*endptr = (char *) s;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 07                	je     800f4f <strtol+0x141>
  800f48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4b:	f7 d8                	neg    %eax
  800f4d:	eb 03                	jmp    800f52 <strtol+0x144>
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <ltostr>:

void
ltostr(long value, char *str)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f6c:	79 13                	jns    800f81 <ltostr+0x2d>
	{
		neg = 1;
  800f6e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f7b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f7e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f89:	99                   	cltd   
  800f8a:	f7 f9                	idiv   %ecx
  800f8c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8d 50 01             	lea    0x1(%eax),%edx
  800f95:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f98:	89 c2                	mov    %eax,%edx
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	01 d0                	add    %edx,%eax
  800f9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fa2:	83 c2 30             	add    $0x30,%edx
  800fa5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800faf:	f7 e9                	imul   %ecx
  800fb1:	c1 fa 02             	sar    $0x2,%edx
  800fb4:	89 c8                	mov    %ecx,%eax
  800fb6:	c1 f8 1f             	sar    $0x1f,%eax
  800fb9:	29 c2                	sub    %eax,%edx
  800fbb:	89 d0                	mov    %edx,%eax
  800fbd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fc8:	f7 e9                	imul   %ecx
  800fca:	c1 fa 02             	sar    $0x2,%edx
  800fcd:	89 c8                	mov    %ecx,%eax
  800fcf:	c1 f8 1f             	sar    $0x1f,%eax
  800fd2:	29 c2                	sub    %eax,%edx
  800fd4:	89 d0                	mov    %edx,%eax
  800fd6:	c1 e0 02             	shl    $0x2,%eax
  800fd9:	01 d0                	add    %edx,%eax
  800fdb:	01 c0                	add    %eax,%eax
  800fdd:	29 c1                	sub    %eax,%ecx
  800fdf:	89 ca                	mov    %ecx,%edx
  800fe1:	85 d2                	test   %edx,%edx
  800fe3:	75 9c                	jne    800f81 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	48                   	dec    %eax
  800ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ff3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ff7:	74 3d                	je     801036 <ltostr+0xe2>
		start = 1 ;
  800ff9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801000:	eb 34                	jmp    801036 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80100f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	01 c2                	add    %eax,%edx
  801017:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	01 c8                	add    %ecx,%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801023:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	01 c2                	add    %eax,%edx
  80102b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80102e:	88 02                	mov    %al,(%edx)
		start++ ;
  801030:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801033:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801039:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80103c:	7c c4                	jl     801002 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80103e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801049:	90                   	nop
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801052:	ff 75 08             	pushl  0x8(%ebp)
  801055:	e8 54 fa ff ff       	call   800aae <strlen>
  80105a:	83 c4 04             	add    $0x4,%esp
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	e8 46 fa ff ff       	call   800aae <strlen>
  801068:	83 c4 04             	add    $0x4,%esp
  80106b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80106e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801075:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107c:	eb 17                	jmp    801095 <strcconcat+0x49>
		final[s] = str1[s] ;
  80107e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	01 c2                	add    %eax,%edx
  801086:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	01 c8                	add    %ecx,%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801092:	ff 45 fc             	incl   -0x4(%ebp)
  801095:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801098:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80109b:	7c e1                	jl     80107e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80109d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010ab:	eb 1f                	jmp    8010cc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	01 c2                	add    %eax,%edx
  8010bd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	01 c8                	add    %ecx,%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010c9:	ff 45 f8             	incl   -0x8(%ebp)
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010d2:	7c d9                	jl     8010ad <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010da:	01 d0                	add    %edx,%eax
  8010dc:	c6 00 00             	movb   $0x0,(%eax)
}
  8010df:	90                   	nop
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fd:	01 d0                	add    %edx,%eax
  8010ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801105:	eb 0c                	jmp    801113 <strsplit+0x31>
			*string++ = 0;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 08             	mov    %edx,0x8(%ebp)
  801110:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	84 c0                	test   %al,%al
  80111a:	74 18                	je     801134 <strsplit+0x52>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	50                   	push   %eax
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	e8 13 fb ff ff       	call   800c40 <strchr>
  80112d:	83 c4 08             	add    $0x8,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	75 d3                	jne    801107 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 5a                	je     801197 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80113d:	8b 45 14             	mov    0x14(%ebp),%eax
  801140:	8b 00                	mov    (%eax),%eax
  801142:	83 f8 0f             	cmp    $0xf,%eax
  801145:	75 07                	jne    80114e <strsplit+0x6c>
		{
			return 0;
  801147:	b8 00 00 00 00       	mov    $0x0,%eax
  80114c:	eb 66                	jmp    8011b4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80114e:	8b 45 14             	mov    0x14(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 14             	mov    0x14(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	01 c2                	add    %eax,%edx
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80116c:	eb 03                	jmp    801171 <strsplit+0x8f>
			string++;
  80116e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	74 8b                	je     801105 <strsplit+0x23>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f be c0             	movsbl %al,%eax
  801182:	50                   	push   %eax
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	e8 b5 fa ff ff       	call   800c40 <strchr>
  80118b:	83 c4 08             	add    $0x8,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	74 dc                	je     80116e <strsplit+0x8c>
			string++;
	}
  801192:	e9 6e ff ff ff       	jmp    801105 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801197:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801198:	8b 45 14             	mov    0x14(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011af:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8011bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c3:	eb 4c                	jmp    801211 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8011c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 40                	cmp    $0x40,%al
  8011d1:	7e 27                	jle    8011fa <str2lower+0x44>
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 5a                	cmp    $0x5a,%al
  8011df:	7f 19                	jg     8011fa <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8011e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ef:	01 ca                	add    %ecx,%edx
  8011f1:	8a 12                	mov    (%edx),%dl
  8011f3:	83 c2 20             	add    $0x20,%edx
  8011f6:	88 10                	mov    %dl,(%eax)
  8011f8:	eb 14                	jmp    80120e <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  8011fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  80120e:	ff 45 fc             	incl   -0x4(%ebp)
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	e8 95 f8 ff ff       	call   800aae <strlen>
  801219:	83 c4 04             	add    $0x4,%esp
  80121c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80121f:	7f a4                	jg     8011c5 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801221:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	57                   	push   %edi
  801235:	56                   	push   %esi
  801236:	53                   	push   %ebx
  801237:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801240:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801243:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801246:	8b 7d 18             	mov    0x18(%ebp),%edi
  801249:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80124c:	cd 30                	int    $0x30
  80124e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801251:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	5b                   	pop    %ebx
  801258:	5e                   	pop    %esi
  801259:	5f                   	pop    %edi
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 04             	sub    $0x4,%esp
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801268:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	52                   	push   %edx
  801274:	ff 75 0c             	pushl  0xc(%ebp)
  801277:	50                   	push   %eax
  801278:	6a 00                	push   $0x0
  80127a:	e8 b2 ff ff ff       	call   801231 <syscall>
  80127f:	83 c4 18             	add    $0x18,%esp
}
  801282:	90                   	nop
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <sys_cgetc>:

int
sys_cgetc(void)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	6a 00                	push   $0x0
  801292:	6a 01                	push   $0x1
  801294:	e8 98 ff ff ff       	call   801231 <syscall>
  801299:	83 c4 18             	add    $0x18,%esp
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	52                   	push   %edx
  8012ae:	50                   	push   %eax
  8012af:	6a 05                	push   $0x5
  8012b1:	e8 7b ff ff ff       	call   801231 <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	51                   	push   %ecx
  8012d2:	52                   	push   %edx
  8012d3:	50                   	push   %eax
  8012d4:	6a 06                	push   $0x6
  8012d6:	e8 56 ff ff ff       	call   801231 <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	52                   	push   %edx
  8012f5:	50                   	push   %eax
  8012f6:	6a 07                	push   $0x7
  8012f8:	e8 34 ff ff ff       	call   801231 <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	ff 75 0c             	pushl  0xc(%ebp)
  80130e:	ff 75 08             	pushl  0x8(%ebp)
  801311:	6a 08                	push   $0x8
  801313:	e8 19 ff ff ff       	call   801231 <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 09                	push   $0x9
  80132c:	e8 00 ff ff ff       	call   801231 <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 0a                	push   $0xa
  801345:	e8 e7 fe ff ff       	call   801231 <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 0b                	push   $0xb
  80135e:	e8 ce fe ff ff       	call   801231 <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 0c                	push   $0xc
  801377:	e8 b5 fe ff ff       	call   801231 <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	6a 0d                	push   $0xd
  801391:	e8 9b fe ff ff       	call   801231 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 0e                	push   $0xe
  8013aa:	e8 82 fe ff ff       	call   801231 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	90                   	nop
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 11                	push   $0x11
  8013c4:	e8 68 fe ff ff       	call   801231 <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 12                	push   $0x12
  8013de:	e8 4e fe ff ff       	call   801231 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	90                   	nop
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	50                   	push   %eax
  801402:	6a 13                	push   $0x13
  801404:	e8 28 fe ff ff       	call   801231 <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 14                	push   $0x14
  80141e:	e8 0e fe ff ff       	call   801231 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	50                   	push   %eax
  801439:	6a 15                	push   $0x15
  80143b:	e8 f1 fd ff ff       	call   801231 <syscall>
  801440:	83 c4 18             	add    $0x18,%esp
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	52                   	push   %edx
  801455:	50                   	push   %eax
  801456:	6a 18                	push   $0x18
  801458:	e8 d4 fd ff ff       	call   801231 <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	52                   	push   %edx
  801472:	50                   	push   %eax
  801473:	6a 16                	push   $0x16
  801475:	e8 b7 fd ff ff       	call   801231 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	90                   	nop
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	52                   	push   %edx
  801490:	50                   	push   %eax
  801491:	6a 17                	push   $0x17
  801493:	e8 99 fd ff ff       	call   801231 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
}
  80149b:	90                   	nop
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	51                   	push   %ecx
  8014b7:	52                   	push   %edx
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	50                   	push   %eax
  8014bc:	6a 19                	push   $0x19
  8014be:	e8 6e fd ff ff       	call   801231 <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	52                   	push   %edx
  8014d8:	50                   	push   %eax
  8014d9:	6a 1a                	push   $0x1a
  8014db:	e8 51 fd ff ff       	call   801231 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	51                   	push   %ecx
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 1b                	push   $0x1b
  8014fa:	e8 32 fd ff ff       	call   801231 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	6a 1c                	push   $0x1c
  801517:	e8 15 fd ff ff       	call   801231 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 1d                	push   $0x1d
  801530:	e8 fc fc ff ff       	call   801231 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	6a 00                	push   $0x0
  801542:	ff 75 14             	pushl  0x14(%ebp)
  801545:	ff 75 10             	pushl  0x10(%ebp)
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	50                   	push   %eax
  80154c:	6a 1e                	push   $0x1e
  80154e:	e8 de fc ff ff       	call   801231 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	50                   	push   %eax
  801567:	6a 1f                	push   $0x1f
  801569:	e8 c3 fc ff ff       	call   801231 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	90                   	nop
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	50                   	push   %eax
  801583:	6a 20                	push   $0x20
  801585:	e8 a7 fc ff ff       	call   801231 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 02                	push   $0x2
  80159e:	e8 8e fc ff ff       	call   801231 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 03                	push   $0x3
  8015b7:	e8 75 fc ff ff       	call   801231 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 04                	push   $0x4
  8015d0:	e8 5c fc ff ff       	call   801231 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_exit_env>:


void sys_exit_env(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 21                	push   $0x21
  8015e9:	e8 43 fc ff ff       	call   801231 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	90                   	nop
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015fd:	8d 50 04             	lea    0x4(%eax),%edx
  801600:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 22                	push   $0x22
  80160d:	e8 1f fc ff ff       	call   801231 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
	return result;
  801615:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801618:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161e:	89 01                	mov    %eax,(%ecx)
  801620:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	c9                   	leave  
  801627:	c2 04 00             	ret    $0x4

0080162a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	ff 75 10             	pushl  0x10(%ebp)
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	6a 10                	push   $0x10
  80163c:	e8 f0 fb ff ff       	call   801231 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
	return ;
  801644:	90                   	nop
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_rcr2>:
uint32 sys_rcr2()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 23                	push   $0x23
  801656:	e8 d6 fb ff ff       	call   801231 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80166c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	50                   	push   %eax
  801679:	6a 24                	push   $0x24
  80167b:	e8 b1 fb ff ff       	call   801231 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
	return ;
  801683:	90                   	nop
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <rsttst>:
void rsttst()
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 26                	push   $0x26
  801695:	e8 97 fb ff ff       	call   801231 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
	return ;
  80169d:	90                   	nop
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8016af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 10             	pushl  0x10(%ebp)
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	6a 25                	push   $0x25
  8016c0:	e8 6c fb ff ff       	call   801231 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c8:	90                   	nop
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <chktst>:
void chktst(uint32 n)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 27                	push   $0x27
  8016db:	e8 51 fb ff ff       	call   801231 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <inctst>:

void inctst()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 28                	push   $0x28
  8016f5:	e8 37 fb ff ff       	call   801231 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <gettst>:
uint32 gettst()
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 29                	push   $0x29
  80170f:	e8 1d fb ff ff       	call   801231 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 2a                	push   $0x2a
  80172b:	e8 01 fb ff ff       	call   801231 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
  801733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801736:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80173a:	75 07                	jne    801743 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80173c:	b8 01 00 00 00       	mov    $0x1,%eax
  801741:	eb 05                	jmp    801748 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 2a                	push   $0x2a
  80175c:	e8 d0 fa ff ff       	call   801231 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
  801764:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801767:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80176b:	75 07                	jne    801774 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	eb 05                	jmp    801779 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 2a                	push   $0x2a
  80178d:	e8 9f fa ff ff       	call   801231 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
  801795:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801798:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80179c:	75 07                	jne    8017a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80179e:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a3:	eb 05                	jmp    8017aa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 2a                	push   $0x2a
  8017be:	e8 6e fa ff ff       	call   801231 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
  8017c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017c9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017cd:	75 07                	jne    8017d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d4:	eb 05                	jmp    8017db <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 2b                	push   $0x2b
  8017ed:	e8 3f fa ff ff       	call   801231 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	53                   	push   %ebx
  80180b:	51                   	push   %ecx
  80180c:	52                   	push   %edx
  80180d:	50                   	push   %eax
  80180e:	6a 2c                	push   $0x2c
  801810:	e8 1c fa ff ff       	call   801231 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 2d                	push   $0x2d
  801830:	e8 fc f9 ff ff       	call   801231 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80183d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	51                   	push   %ecx
  801849:	ff 75 10             	pushl  0x10(%ebp)
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 2e                	push   $0x2e
  801850:	e8 dc f9 ff ff       	call   801231 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	ff 75 10             	pushl  0x10(%ebp)
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	ff 75 08             	pushl  0x8(%ebp)
  80186a:	6a 0f                	push   $0xf
  80186c:	e8 c0 f9 ff ff       	call   801231 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
	return ;
  801874:	90                   	nop
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 2f                	push   $0x2f
  801888:	e8 a4 f9 ff ff       	call   801231 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp

}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 30                	push   $0x30
  8018a3:	e8 89 f9 ff ff       	call   801231 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp

}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 31                	push   $0x31
  8018bf:	e8 6d f9 ff ff       	call   801231 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp

}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_hard_limit>:
uint32 sys_hard_limit(){
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 32                	push   $0x32
  8018d9:	e8 53 f9 ff ff       	call   801231 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ec:	89 d0                	mov    %edx,%eax
  8018ee:	c1 e0 02             	shl    $0x2,%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018fa:	01 d0                	add    %edx,%eax
  8018fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801903:	01 d0                	add    %edx,%eax
  801905:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80190c:	01 d0                	add    %edx,%eax
  80190e:	c1 e0 04             	shl    $0x4,%eax
  801911:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801914:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80191b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	50                   	push   %eax
  801922:	e8 cd fc ff ff       	call   8015f4 <sys_get_virtual_time>
  801927:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80192a:	eb 41                	jmp    80196d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80192c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80192f:	83 ec 0c             	sub    $0xc,%esp
  801932:	50                   	push   %eax
  801933:	e8 bc fc ff ff       	call   8015f4 <sys_get_virtual_time>
  801938:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80193b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80193e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801941:	29 c2                	sub    %eax,%edx
  801943:	89 d0                	mov    %edx,%eax
  801945:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194e:	89 d1                	mov    %edx,%ecx
  801950:	29 c1                	sub    %eax,%ecx
  801952:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801958:	39 c2                	cmp    %eax,%edx
  80195a:	0f 97 c0             	seta   %al
  80195d:	0f b6 c0             	movzbl %al,%eax
  801960:	29 c1                	sub    %eax,%ecx
  801962:	89 c8                	mov    %ecx,%eax
  801964:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801967:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80196a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801970:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801973:	72 b7                	jb     80192c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80197e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801985:	eb 03                	jmp    80198a <busy_wait+0x12>
  801987:	ff 45 fc             	incl   -0x4(%ebp)
  80198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801990:	72 f5                	jb     801987 <busy_wait+0xf>
	return i;
  801992:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    
  801997:	90                   	nop

00801998 <__udivdi3>:
  801998:	55                   	push   %ebp
  801999:	57                   	push   %edi
  80199a:	56                   	push   %esi
  80199b:	53                   	push   %ebx
  80199c:	83 ec 1c             	sub    $0x1c,%esp
  80199f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019af:	89 ca                	mov    %ecx,%edx
  8019b1:	89 f8                	mov    %edi,%eax
  8019b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019b7:	85 f6                	test   %esi,%esi
  8019b9:	75 2d                	jne    8019e8 <__udivdi3+0x50>
  8019bb:	39 cf                	cmp    %ecx,%edi
  8019bd:	77 65                	ja     801a24 <__udivdi3+0x8c>
  8019bf:	89 fd                	mov    %edi,%ebp
  8019c1:	85 ff                	test   %edi,%edi
  8019c3:	75 0b                	jne    8019d0 <__udivdi3+0x38>
  8019c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ca:	31 d2                	xor    %edx,%edx
  8019cc:	f7 f7                	div    %edi
  8019ce:	89 c5                	mov    %eax,%ebp
  8019d0:	31 d2                	xor    %edx,%edx
  8019d2:	89 c8                	mov    %ecx,%eax
  8019d4:	f7 f5                	div    %ebp
  8019d6:	89 c1                	mov    %eax,%ecx
  8019d8:	89 d8                	mov    %ebx,%eax
  8019da:	f7 f5                	div    %ebp
  8019dc:	89 cf                	mov    %ecx,%edi
  8019de:	89 fa                	mov    %edi,%edx
  8019e0:	83 c4 1c             	add    $0x1c,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5f                   	pop    %edi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    
  8019e8:	39 ce                	cmp    %ecx,%esi
  8019ea:	77 28                	ja     801a14 <__udivdi3+0x7c>
  8019ec:	0f bd fe             	bsr    %esi,%edi
  8019ef:	83 f7 1f             	xor    $0x1f,%edi
  8019f2:	75 40                	jne    801a34 <__udivdi3+0x9c>
  8019f4:	39 ce                	cmp    %ecx,%esi
  8019f6:	72 0a                	jb     801a02 <__udivdi3+0x6a>
  8019f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019fc:	0f 87 9e 00 00 00    	ja     801aa0 <__udivdi3+0x108>
  801a02:	b8 01 00 00 00       	mov    $0x1,%eax
  801a07:	89 fa                	mov    %edi,%edx
  801a09:	83 c4 1c             	add    $0x1c,%esp
  801a0c:	5b                   	pop    %ebx
  801a0d:	5e                   	pop    %esi
  801a0e:	5f                   	pop    %edi
  801a0f:	5d                   	pop    %ebp
  801a10:	c3                   	ret    
  801a11:	8d 76 00             	lea    0x0(%esi),%esi
  801a14:	31 ff                	xor    %edi,%edi
  801a16:	31 c0                	xor    %eax,%eax
  801a18:	89 fa                	mov    %edi,%edx
  801a1a:	83 c4 1c             	add    $0x1c,%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5f                   	pop    %edi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    
  801a22:	66 90                	xchg   %ax,%ax
  801a24:	89 d8                	mov    %ebx,%eax
  801a26:	f7 f7                	div    %edi
  801a28:	31 ff                	xor    %edi,%edi
  801a2a:	89 fa                	mov    %edi,%edx
  801a2c:	83 c4 1c             	add    $0x1c,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    
  801a34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a39:	89 eb                	mov    %ebp,%ebx
  801a3b:	29 fb                	sub    %edi,%ebx
  801a3d:	89 f9                	mov    %edi,%ecx
  801a3f:	d3 e6                	shl    %cl,%esi
  801a41:	89 c5                	mov    %eax,%ebp
  801a43:	88 d9                	mov    %bl,%cl
  801a45:	d3 ed                	shr    %cl,%ebp
  801a47:	89 e9                	mov    %ebp,%ecx
  801a49:	09 f1                	or     %esi,%ecx
  801a4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a4f:	89 f9                	mov    %edi,%ecx
  801a51:	d3 e0                	shl    %cl,%eax
  801a53:	89 c5                	mov    %eax,%ebp
  801a55:	89 d6                	mov    %edx,%esi
  801a57:	88 d9                	mov    %bl,%cl
  801a59:	d3 ee                	shr    %cl,%esi
  801a5b:	89 f9                	mov    %edi,%ecx
  801a5d:	d3 e2                	shl    %cl,%edx
  801a5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 e8                	shr    %cl,%eax
  801a67:	09 c2                	or     %eax,%edx
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	89 f2                	mov    %esi,%edx
  801a6d:	f7 74 24 0c          	divl   0xc(%esp)
  801a71:	89 d6                	mov    %edx,%esi
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	f7 e5                	mul    %ebp
  801a77:	39 d6                	cmp    %edx,%esi
  801a79:	72 19                	jb     801a94 <__udivdi3+0xfc>
  801a7b:	74 0b                	je     801a88 <__udivdi3+0xf0>
  801a7d:	89 d8                	mov    %ebx,%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 58 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a8c:	89 f9                	mov    %edi,%ecx
  801a8e:	d3 e2                	shl    %cl,%edx
  801a90:	39 c2                	cmp    %eax,%edx
  801a92:	73 e9                	jae    801a7d <__udivdi3+0xe5>
  801a94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a97:	31 ff                	xor    %edi,%edi
  801a99:	e9 40 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	31 c0                	xor    %eax,%eax
  801aa2:	e9 37 ff ff ff       	jmp    8019de <__udivdi3+0x46>
  801aa7:	90                   	nop

00801aa8 <__umoddi3>:
  801aa8:	55                   	push   %ebp
  801aa9:	57                   	push   %edi
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
  801aac:	83 ec 1c             	sub    $0x1c,%esp
  801aaf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ab3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ab7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801abf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ac7:	89 f3                	mov    %esi,%ebx
  801ac9:	89 fa                	mov    %edi,%edx
  801acb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801acf:	89 34 24             	mov    %esi,(%esp)
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	75 1a                	jne    801af0 <__umoddi3+0x48>
  801ad6:	39 f7                	cmp    %esi,%edi
  801ad8:	0f 86 a2 00 00 00    	jbe    801b80 <__umoddi3+0xd8>
  801ade:	89 c8                	mov    %ecx,%eax
  801ae0:	89 f2                	mov    %esi,%edx
  801ae2:	f7 f7                	div    %edi
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	31 d2                	xor    %edx,%edx
  801ae8:	83 c4 1c             	add    $0x1c,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    
  801af0:	39 f0                	cmp    %esi,%eax
  801af2:	0f 87 ac 00 00 00    	ja     801ba4 <__umoddi3+0xfc>
  801af8:	0f bd e8             	bsr    %eax,%ebp
  801afb:	83 f5 1f             	xor    $0x1f,%ebp
  801afe:	0f 84 ac 00 00 00    	je     801bb0 <__umoddi3+0x108>
  801b04:	bf 20 00 00 00       	mov    $0x20,%edi
  801b09:	29 ef                	sub    %ebp,%edi
  801b0b:	89 fe                	mov    %edi,%esi
  801b0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b11:	89 e9                	mov    %ebp,%ecx
  801b13:	d3 e0                	shl    %cl,%eax
  801b15:	89 d7                	mov    %edx,%edi
  801b17:	89 f1                	mov    %esi,%ecx
  801b19:	d3 ef                	shr    %cl,%edi
  801b1b:	09 c7                	or     %eax,%edi
  801b1d:	89 e9                	mov    %ebp,%ecx
  801b1f:	d3 e2                	shl    %cl,%edx
  801b21:	89 14 24             	mov    %edx,(%esp)
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	d3 e0                	shl    %cl,%eax
  801b28:	89 c2                	mov    %eax,%edx
  801b2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2e:	d3 e0                	shl    %cl,%eax
  801b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b38:	89 f1                	mov    %esi,%ecx
  801b3a:	d3 e8                	shr    %cl,%eax
  801b3c:	09 d0                	or     %edx,%eax
  801b3e:	d3 eb                	shr    %cl,%ebx
  801b40:	89 da                	mov    %ebx,%edx
  801b42:	f7 f7                	div    %edi
  801b44:	89 d3                	mov    %edx,%ebx
  801b46:	f7 24 24             	mull   (%esp)
  801b49:	89 c6                	mov    %eax,%esi
  801b4b:	89 d1                	mov    %edx,%ecx
  801b4d:	39 d3                	cmp    %edx,%ebx
  801b4f:	0f 82 87 00 00 00    	jb     801bdc <__umoddi3+0x134>
  801b55:	0f 84 91 00 00 00    	je     801bec <__umoddi3+0x144>
  801b5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b5f:	29 f2                	sub    %esi,%edx
  801b61:	19 cb                	sbb    %ecx,%ebx
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b69:	d3 e0                	shl    %cl,%eax
  801b6b:	89 e9                	mov    %ebp,%ecx
  801b6d:	d3 ea                	shr    %cl,%edx
  801b6f:	09 d0                	or     %edx,%eax
  801b71:	89 e9                	mov    %ebp,%ecx
  801b73:	d3 eb                	shr    %cl,%ebx
  801b75:	89 da                	mov    %ebx,%edx
  801b77:	83 c4 1c             	add    $0x1c,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5f                   	pop    %edi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    
  801b7f:	90                   	nop
  801b80:	89 fd                	mov    %edi,%ebp
  801b82:	85 ff                	test   %edi,%edi
  801b84:	75 0b                	jne    801b91 <__umoddi3+0xe9>
  801b86:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8b:	31 d2                	xor    %edx,%edx
  801b8d:	f7 f7                	div    %edi
  801b8f:	89 c5                	mov    %eax,%ebp
  801b91:	89 f0                	mov    %esi,%eax
  801b93:	31 d2                	xor    %edx,%edx
  801b95:	f7 f5                	div    %ebp
  801b97:	89 c8                	mov    %ecx,%eax
  801b99:	f7 f5                	div    %ebp
  801b9b:	89 d0                	mov    %edx,%eax
  801b9d:	e9 44 ff ff ff       	jmp    801ae6 <__umoddi3+0x3e>
  801ba2:	66 90                	xchg   %ax,%ax
  801ba4:	89 c8                	mov    %ecx,%eax
  801ba6:	89 f2                	mov    %esi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	3b 04 24             	cmp    (%esp),%eax
  801bb3:	72 06                	jb     801bbb <__umoddi3+0x113>
  801bb5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb9:	77 0f                	ja     801bca <__umoddi3+0x122>
  801bbb:	89 f2                	mov    %esi,%edx
  801bbd:	29 f9                	sub    %edi,%ecx
  801bbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bc3:	89 14 24             	mov    %edx,(%esp)
  801bc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bce:	8b 14 24             	mov    (%esp),%edx
  801bd1:	83 c4 1c             	add    $0x1c,%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
  801bd9:	8d 76 00             	lea    0x0(%esi),%esi
  801bdc:	2b 04 24             	sub    (%esp),%eax
  801bdf:	19 fa                	sbb    %edi,%edx
  801be1:	89 d1                	mov    %edx,%ecx
  801be3:	89 c6                	mov    %eax,%esi
  801be5:	e9 71 ff ff ff       	jmp    801b5b <__umoddi3+0xb3>
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bf0:	72 ea                	jb     801bdc <__umoddi3+0x134>
  801bf2:	89 d9                	mov    %ebx,%ecx
  801bf4:	e9 62 ff ff ff       	jmp    801b5b <__umoddi3+0xb3>
