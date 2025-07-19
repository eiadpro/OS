
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 e1 12 00 00       	call   801331 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 20 2d 80 00       	push   $0x802d20
  800061:	e8 0a 03 00 00       	call   800370 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 33 2d 80 00       	push   $0x802d33
  8000be:	e8 ad 02 00 00       	call   800370 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 b5 13 00 00       	call   801491 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 47 12 00 00       	call   801331 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 33 2d 80 00       	push   $0x802d33
  800114:	e8 57 02 00 00       	call   800370 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 5f 13 00 00       	call   801491 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 69 18 00 00       	call   8019ac <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 40 5c             	mov    0x5c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0d                	je     800183 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	83 c0 5c             	add    $0x5c,%eax
  80017e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800183:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800187:	7e 0a                	jle    800193 <libmain+0x5b>
		binaryname = argv[0];
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	8b 00                	mov    (%eax),%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	ff 75 0c             	pushl  0xc(%ebp)
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 97 fe ff ff       	call   800038 <_main>
  8001a1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a4:	e8 10 16 00 00       	call   8017b9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	68 58 2d 80 00       	push   $0x802d58
  8001b1:	e8 8d 01 00 00       	call   800343 <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001be:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	68 80 2d 80 00       	push   $0x802d80
  8001d9:	e8 65 01 00 00       	call   800343 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e6:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8001ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f1:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  8001f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fc:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800202:	51                   	push   %ecx
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 a8 2d 80 00       	push   $0x802da8
  80020a:	e8 34 01 00 00       	call   800343 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	68 00 2e 80 00       	push   $0x802e00
  800226:	e8 18 01 00 00       	call   800343 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 58 2d 80 00       	push   $0x802d58
  800236:	e8 08 01 00 00       	call   800343 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80023e:	e8 90 15 00 00       	call   8017d3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800243:	e8 19 00 00 00       	call   800261 <exit>
}
  800248:	90                   	nop
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 00                	push   $0x0
  800256:	e8 1d 17 00 00       	call   801978 <sys_destroy_env>
  80025b:	83 c4 10             	add    $0x10,%esp
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <exit>:

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800267:	e8 72 17 00 00       	call   8019de <sys_exit_env>
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	8d 48 01             	lea    0x1(%eax),%ecx
  80027d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800280:	89 0a                	mov    %ecx,(%edx)
  800282:	8b 55 08             	mov    0x8(%ebp),%edx
  800285:	88 d1                	mov    %dl,%cl
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	8b 00                	mov    (%eax),%eax
  800293:	3d ff 00 00 00       	cmp    $0xff,%eax
  800298:	75 2c                	jne    8002c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029a:	a0 24 40 80 00       	mov    0x804024,%al
  80029f:	0f b6 c0             	movzbl %al,%eax
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	8b 12                	mov    (%edx),%edx
  8002a7:	89 d1                	mov    %edx,%ecx
  8002a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ac:	83 c2 08             	add    $0x8,%edx
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	50                   	push   %eax
  8002b3:	51                   	push   %ecx
  8002b4:	52                   	push   %edx
  8002b5:	e8 a6 13 00 00       	call   801660 <sys_cputs>
  8002ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 40 04             	mov    0x4(%eax),%eax
  8002cc:	8d 50 01             	lea    0x1(%eax),%edx
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002d5:	90                   	nop
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e8:	00 00 00 
	b.cnt = 0;
  8002eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	68 6f 02 80 00       	push   $0x80026f
  800307:	e8 11 02 00 00       	call   80051d <vprintfmt>
  80030c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80030f:	a0 24 40 80 00       	mov    0x804024,%al
  800314:	0f b6 c0             	movzbl %al,%eax
  800317:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80031d:	83 ec 04             	sub    $0x4,%esp
  800320:	50                   	push   %eax
  800321:	52                   	push   %edx
  800322:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800328:	83 c0 08             	add    $0x8,%eax
  80032b:	50                   	push   %eax
  80032c:	e8 2f 13 00 00       	call   801660 <sys_cputs>
  800331:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800334:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80033b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800341:	c9                   	leave  
  800342:	c3                   	ret    

00800343 <cprintf>:

int cprintf(const char *fmt, ...) {
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800349:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800350:	8d 45 0c             	lea    0xc(%ebp),%eax
  800353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	83 ec 08             	sub    $0x8,%esp
  80035c:	ff 75 f4             	pushl  -0xc(%ebp)
  80035f:	50                   	push   %eax
  800360:	e8 73 ff ff ff       	call   8002d8 <vcprintf>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800376:	e8 3e 14 00 00       	call   8017b9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 f4             	pushl  -0xc(%ebp)
  80038a:	50                   	push   %eax
  80038b:	e8 48 ff ff ff       	call   8002d8 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800396:	e8 38 14 00 00       	call   8017d3 <sys_enable_interrupt>
	return cnt;
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 14             	sub    $0x14,%esp
  8003a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003be:	77 55                	ja     800415 <printnum+0x75>
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	72 05                	jb     8003ca <printnum+0x2a>
  8003c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c8:	77 4b                	ja     800415 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	52                   	push   %edx
  8003d9:	50                   	push   %eax
  8003da:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e0:	e8 d3 26 00 00       	call   802ab8 <__udivdi3>
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	ff 75 20             	pushl  0x20(%ebp)
  8003ee:	53                   	push   %ebx
  8003ef:	ff 75 18             	pushl  0x18(%ebp)
  8003f2:	52                   	push   %edx
  8003f3:	50                   	push   %eax
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 a1 ff ff ff       	call   8003a0 <printnum>
  8003ff:	83 c4 20             	add    $0x20,%esp
  800402:	eb 1a                	jmp    80041e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 20             	pushl  0x20(%ebp)
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	ff d0                	call   *%eax
  800412:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800415:	ff 4d 1c             	decl   0x1c(%ebp)
  800418:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80041c:	7f e6                	jg     800404 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800421:	bb 00 00 00 00       	mov    $0x0,%ebx
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80042c:	53                   	push   %ebx
  80042d:	51                   	push   %ecx
  80042e:	52                   	push   %edx
  80042f:	50                   	push   %eax
  800430:	e8 93 27 00 00       	call   802bc8 <__umoddi3>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	05 34 30 80 00       	add    $0x803034,%eax
  80043d:	8a 00                	mov    (%eax),%al
  80043f:	0f be c0             	movsbl %al,%eax
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	50                   	push   %eax
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	ff d0                	call   *%eax
  80044e:	83 c4 10             	add    $0x10,%esp
}
  800451:	90                   	nop
  800452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045e:	7e 1c                	jle    80047c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 50 08             	lea    0x8(%eax),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 10                	mov    %edx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 e8 08             	sub    $0x8,%eax
  800475:	8b 50 04             	mov    0x4(%eax),%edx
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	eb 40                	jmp    8004bc <getuint+0x65>
	else if (lflag)
  80047c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800480:	74 1e                	je     8004a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 04             	lea    0x4(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 04             	sub    $0x4,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	eb 1c                	jmp    8004bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	8d 50 04             	lea    0x4(%eax),%edx
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	89 10                	mov    %edx,(%eax)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	83 e8 04             	sub    $0x4,%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c5:	7e 1c                	jle    8004e3 <getint+0x25>
		return va_arg(*ap, long long);
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 08             	lea    0x8(%eax),%edx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 e8 08             	sub    $0x8,%eax
  8004dc:	8b 50 04             	mov    0x4(%eax),%edx
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	eb 38                	jmp    80051b <getint+0x5d>
	else if (lflag)
  8004e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e7:	74 1a                	je     800503 <getint+0x45>
		return va_arg(*ap, long);
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	89 10                	mov    %edx,(%eax)
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	83 e8 04             	sub    $0x4,%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	99                   	cltd   
  800501:	eb 18                	jmp    80051b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 50 04             	lea    0x4(%eax),%edx
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 10                	mov    %edx,(%eax)
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 e8 04             	sub    $0x4,%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
}
  80051b:	5d                   	pop    %ebp
  80051c:	c3                   	ret    

0080051d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	56                   	push   %esi
  800521:	53                   	push   %ebx
  800522:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800525:	eb 17                	jmp    80053e <vprintfmt+0x21>
			if (ch == '\0')
  800527:	85 db                	test   %ebx,%ebx
  800529:	0f 84 af 03 00 00    	je     8008de <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	53                   	push   %ebx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	ff d0                	call   *%eax
  80053b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053e:	8b 45 10             	mov    0x10(%ebp),%eax
  800541:	8d 50 01             	lea    0x1(%eax),%edx
  800544:	89 55 10             	mov    %edx,0x10(%ebp)
  800547:	8a 00                	mov    (%eax),%al
  800549:	0f b6 d8             	movzbl %al,%ebx
  80054c:	83 fb 25             	cmp    $0x25,%ebx
  80054f:	75 d6                	jne    800527 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800551:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800555:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80055c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800563:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 45 10             	mov    0x10(%ebp),%eax
  800574:	8d 50 01             	lea    0x1(%eax),%edx
  800577:	89 55 10             	mov    %edx,0x10(%ebp)
  80057a:	8a 00                	mov    (%eax),%al
  80057c:	0f b6 d8             	movzbl %al,%ebx
  80057f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800582:	83 f8 55             	cmp    $0x55,%eax
  800585:	0f 87 2b 03 00 00    	ja     8008b6 <vprintfmt+0x399>
  80058b:	8b 04 85 58 30 80 00 	mov    0x803058(,%eax,4),%eax
  800592:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800594:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800598:	eb d7                	jmp    800571 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80059e:	eb d1                	jmp    800571 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005aa:	89 d0                	mov    %edx,%eax
  8005ac:	c1 e0 02             	shl    $0x2,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	01 c0                	add    %eax,%eax
  8005b3:	01 d8                	add    %ebx,%eax
  8005b5:	83 e8 30             	sub    $0x30,%eax
  8005b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005be:	8a 00                	mov    (%eax),%al
  8005c0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c3:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c6:	7e 3e                	jle    800606 <vprintfmt+0xe9>
  8005c8:	83 fb 39             	cmp    $0x39,%ebx
  8005cb:	7f 39                	jg     800606 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d0:	eb d5                	jmp    8005a7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 c0 04             	add    $0x4,%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 e8 04             	sub    $0x4,%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e6:	eb 1f                	jmp    800607 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ec:	79 83                	jns    800571 <vprintfmt+0x54>
				width = 0;
  8005ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f5:	e9 77 ff ff ff       	jmp    800571 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005fa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800601:	e9 6b ff ff ff       	jmp    800571 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800606:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800607:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060b:	0f 89 60 ff ff ff    	jns    800571 <vprintfmt+0x54>
				width = precision, precision = -1;
  800611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800617:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80061e:	e9 4e ff ff ff       	jmp    800571 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800623:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800626:	e9 46 ff ff ff       	jmp    800571 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 c0 04             	add    $0x4,%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	83 e8 04             	sub    $0x4,%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	ff d0                	call   *%eax
  800648:	83 c4 10             	add    $0x10,%esp
			break;
  80064b:	e9 89 02 00 00       	jmp    8008d9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 c0 04             	add    $0x4,%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800661:	85 db                	test   %ebx,%ebx
  800663:	79 02                	jns    800667 <vprintfmt+0x14a>
				err = -err;
  800665:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800667:	83 fb 64             	cmp    $0x64,%ebx
  80066a:	7f 0b                	jg     800677 <vprintfmt+0x15a>
  80066c:	8b 34 9d a0 2e 80 00 	mov    0x802ea0(,%ebx,4),%esi
  800673:	85 f6                	test   %esi,%esi
  800675:	75 19                	jne    800690 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800677:	53                   	push   %ebx
  800678:	68 45 30 80 00       	push   $0x803045
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 08             	pushl  0x8(%ebp)
  800683:	e8 5e 02 00 00       	call   8008e6 <printfmt>
  800688:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068b:	e9 49 02 00 00       	jmp    8008d9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800690:	56                   	push   %esi
  800691:	68 4e 30 80 00       	push   $0x80304e
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	ff 75 08             	pushl  0x8(%ebp)
  80069c:	e8 45 02 00 00       	call   8008e6 <printfmt>
  8006a1:	83 c4 10             	add    $0x10,%esp
			break;
  8006a4:	e9 30 02 00 00       	jmp    8008d9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 c0 04             	add    $0x4,%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	83 e8 04             	sub    $0x4,%eax
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 05                	jne    8006c3 <vprintfmt+0x1a6>
				p = "(null)";
  8006be:	be 51 30 80 00       	mov    $0x803051,%esi
			if (width > 0 && padc != '-')
  8006c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c7:	7e 6d                	jle    800736 <vprintfmt+0x219>
  8006c9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006cd:	74 67                	je     800736 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	50                   	push   %eax
  8006d6:	56                   	push   %esi
  8006d7:	e8 0c 03 00 00       	call   8009e8 <strnlen>
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e2:	eb 16                	jmp    8006fa <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fe:	7f e4                	jg     8006e4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800700:	eb 34                	jmp    800736 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800702:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800706:	74 1c                	je     800724 <vprintfmt+0x207>
  800708:	83 fb 1f             	cmp    $0x1f,%ebx
  80070b:	7e 05                	jle    800712 <vprintfmt+0x1f5>
  80070d:	83 fb 7e             	cmp    $0x7e,%ebx
  800710:	7e 12                	jle    800724 <vprintfmt+0x207>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 3f                	push   $0x3f
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb 0f                	jmp    800733 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	53                   	push   %ebx
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800733:	ff 4d e4             	decl   -0x1c(%ebp)
  800736:	89 f0                	mov    %esi,%eax
  800738:	8d 70 01             	lea    0x1(%eax),%esi
  80073b:	8a 00                	mov    (%eax),%al
  80073d:	0f be d8             	movsbl %al,%ebx
  800740:	85 db                	test   %ebx,%ebx
  800742:	74 24                	je     800768 <vprintfmt+0x24b>
  800744:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800748:	78 b8                	js     800702 <vprintfmt+0x1e5>
  80074a:	ff 4d e0             	decl   -0x20(%ebp)
  80074d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800751:	79 af                	jns    800702 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800753:	eb 13                	jmp    800768 <vprintfmt+0x24b>
				putch(' ', putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	6a 20                	push   $0x20
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800765:	ff 4d e4             	decl   -0x1c(%ebp)
  800768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076c:	7f e7                	jg     800755 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80076e:	e9 66 01 00 00       	jmp    8008d9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 e8             	pushl  -0x18(%ebp)
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	e8 3c fd ff ff       	call   8004be <getint>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800788:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	85 d2                	test   %edx,%edx
  800793:	79 23                	jns    8007b8 <vprintfmt+0x29b>
				putch('-', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	6a 2d                	push   $0x2d
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ab:	f7 d8                	neg    %eax
  8007ad:	83 d2 00             	adc    $0x0,%edx
  8007b0:	f7 da                	neg    %edx
  8007b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007bf:	e9 bc 00 00 00       	jmp    800880 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 84 fc ff ff       	call   800457 <getuint>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e3:	e9 98 00 00 00       	jmp    800880 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 58                	push   $0x58
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	6a 58                	push   $0x58
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	6a 58                	push   $0x58
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	ff d0                	call   *%eax
  800815:	83 c4 10             	add    $0x10,%esp
			break;
  800818:	e9 bc 00 00 00       	jmp    8008d9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 30                	push   $0x30
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 78                	push   $0x78
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800858:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80085f:	eb 1f                	jmp    800880 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 e8             	pushl  -0x18(%ebp)
  800867:	8d 45 14             	lea    0x14(%ebp),%eax
  80086a:	50                   	push   %eax
  80086b:	e8 e7 fb ff ff       	call   800457 <getuint>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800876:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800879:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800880:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800887:	83 ec 04             	sub    $0x4,%esp
  80088a:	52                   	push   %edx
  80088b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088e:	50                   	push   %eax
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	ff 75 f0             	pushl  -0x10(%ebp)
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	ff 75 08             	pushl  0x8(%ebp)
  80089b:	e8 00 fb ff ff       	call   8003a0 <printnum>
  8008a0:	83 c4 20             	add    $0x20,%esp
			break;
  8008a3:	eb 34                	jmp    8008d9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	53                   	push   %ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
			break;
  8008b4:	eb 23                	jmp    8008d9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	6a 25                	push   $0x25
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	ff d0                	call   *%eax
  8008c3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c6:	ff 4d 10             	decl   0x10(%ebp)
  8008c9:	eb 03                	jmp    8008ce <vprintfmt+0x3b1>
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d1:	48                   	dec    %eax
  8008d2:	8a 00                	mov    (%eax),%al
  8008d4:	3c 25                	cmp    $0x25,%al
  8008d6:	75 f3                	jne    8008cb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008d8:	90                   	nop
		}
	}
  8008d9:	e9 47 fc ff ff       	jmp    800525 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008de:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e2:	5b                   	pop    %ebx
  8008e3:	5e                   	pop    %esi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ec:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ef:	83 c0 04             	add    $0x4,%eax
  8008f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	e8 16 fc ff ff       	call   80051d <vprintfmt>
  800907:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090a:	90                   	nop
  80090b:	c9                   	leave  
  80090c:	c3                   	ret    

0080090d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	8b 40 08             	mov    0x8(%eax),%eax
  800916:	8d 50 01             	lea    0x1(%eax),%edx
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	8b 10                	mov    (%eax),%edx
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 40 04             	mov    0x4(%eax),%eax
  80092a:	39 c2                	cmp    %eax,%edx
  80092c:	73 12                	jae    800940 <sprintputch+0x33>
		*b->buf++ = ch;
  80092e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	8d 48 01             	lea    0x1(%eax),%ecx
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
  800939:	89 0a                	mov    %ecx,(%edx)
  80093b:	8b 55 08             	mov    0x8(%ebp),%edx
  80093e:	88 10                	mov    %dl,(%eax)
}
  800940:	90                   	nop
  800941:	5d                   	pop    %ebp
  800942:	c3                   	ret    

00800943 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	8d 50 ff             	lea    -0x1(%eax),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800964:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800968:	74 06                	je     800970 <vsnprintf+0x2d>
  80096a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80096e:	7f 07                	jg     800977 <vsnprintf+0x34>
		return -E_INVAL;
  800970:	b8 03 00 00 00       	mov    $0x3,%eax
  800975:	eb 20                	jmp    800997 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800977:	ff 75 14             	pushl  0x14(%ebp)
  80097a:	ff 75 10             	pushl  0x10(%ebp)
  80097d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800980:	50                   	push   %eax
  800981:	68 0d 09 80 00       	push   $0x80090d
  800986:	e8 92 fb ff ff       	call   80051d <vprintfmt>
  80098b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80098e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800991:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800994:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099f:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a2:	83 c0 04             	add    $0x4,%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 89 ff ff ff       	call   800943 <vsnprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c3:	c9                   	leave  
  8009c4:	c3                   	ret    

008009c5 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d2:	eb 06                	jmp    8009da <strlen+0x15>
		n++;
  8009d4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d7:	ff 45 08             	incl   0x8(%ebp)
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	84 c0                	test   %al,%al
  8009e1:	75 f1                	jne    8009d4 <strlen+0xf>
		n++;
	return n;
  8009e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f5:	eb 09                	jmp    800a00 <strnlen+0x18>
		n++;
  8009f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fa:	ff 45 08             	incl   0x8(%ebp)
  8009fd:	ff 4d 0c             	decl   0xc(%ebp)
  800a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a04:	74 09                	je     800a0f <strnlen+0x27>
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	84 c0                	test   %al,%al
  800a0d:	75 e8                	jne    8009f7 <strnlen+0xf>
		n++;
	return n;
  800a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a20:	90                   	nop
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8d 50 01             	lea    0x1(%eax),%edx
  800a27:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a33:	8a 12                	mov    (%edx),%dl
  800a35:	88 10                	mov    %dl,(%eax)
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	84 c0                	test   %al,%al
  800a3b:	75 e4                	jne    800a21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a55:	eb 1f                	jmp    800a76 <strncpy+0x34>
		*dst++ = *src;
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8d 50 01             	lea    0x1(%eax),%edx
  800a5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	8a 12                	mov    (%edx),%dl
  800a65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	84 c0                	test   %al,%al
  800a6e:	74 03                	je     800a73 <strncpy+0x31>
			src++;
  800a70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a73:	ff 45 fc             	incl   -0x4(%ebp)
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a7c:	72 d9                	jb     800a57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a93:	74 30                	je     800ac5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a95:	eb 16                	jmp    800aad <strlcpy+0x2a>
			*dst++ = *src++;
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8d 50 01             	lea    0x1(%eax),%edx
  800a9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa9:	8a 12                	mov    (%edx),%dl
  800aab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab4:	74 09                	je     800abf <strlcpy+0x3c>
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	84 c0                	test   %al,%al
  800abd:	75 d8                	jne    800a97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800acb:	29 c2                	sub    %eax,%edx
  800acd:	89 d0                	mov    %edx,%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad4:	eb 06                	jmp    800adc <strcmp+0xb>
		p++, q++;
  800ad6:	ff 45 08             	incl   0x8(%ebp)
  800ad9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8a 00                	mov    (%eax),%al
  800ae1:	84 c0                	test   %al,%al
  800ae3:	74 0e                	je     800af3 <strcmp+0x22>
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8a 10                	mov    (%eax),%dl
  800aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	38 c2                	cmp    %al,%dl
  800af1:	74 e3                	je     800ad6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	0f b6 d0             	movzbl %al,%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	8a 00                	mov    (%eax),%al
  800b00:	0f b6 c0             	movzbl %al,%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b0c:	eb 09                	jmp    800b17 <strncmp+0xe>
		n--, p++, q++;
  800b0e:	ff 4d 10             	decl   0x10(%ebp)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1b:	74 17                	je     800b34 <strncmp+0x2b>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	74 0e                	je     800b34 <strncmp+0x2b>
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 10                	mov    (%eax),%dl
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	38 c2                	cmp    %al,%dl
  800b32:	74 da                	je     800b0e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b38:	75 07                	jne    800b41 <strncmp+0x38>
		return 0;
  800b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3f:	eb 14                	jmp    800b55 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	0f b6 d0             	movzbl %al,%edx
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	0f b6 c0             	movzbl %al,%eax
  800b51:	29 c2                	sub    %eax,%edx
  800b53:	89 d0                	mov    %edx,%eax
}
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 04             	sub    $0x4,%esp
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b63:	eb 12                	jmp    800b77 <strchr+0x20>
		if (*s == c)
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8a 00                	mov    (%eax),%al
  800b6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b6d:	75 05                	jne    800b74 <strchr+0x1d>
			return (char *) s;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	eb 11                	jmp    800b85 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b74:	ff 45 08             	incl   0x8(%ebp)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	84 c0                	test   %al,%al
  800b7e:	75 e5                	jne    800b65 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 04             	sub    $0x4,%esp
  800b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b93:	eb 0d                	jmp    800ba2 <strfind+0x1b>
		if (*s == c)
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8a 00                	mov    (%eax),%al
  800b9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b9d:	74 0e                	je     800bad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b9f:	ff 45 08             	incl   0x8(%ebp)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8a 00                	mov    (%eax),%al
  800ba7:	84 c0                	test   %al,%al
  800ba9:	75 ea                	jne    800b95 <strfind+0xe>
  800bab:	eb 01                	jmp    800bae <strfind+0x27>
		if (*s == c)
			break;
  800bad:	90                   	nop
	return (char *) s;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bc5:	eb 0e                	jmp    800bd5 <memset+0x22>
		*p++ = c;
  800bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bca:	8d 50 01             	lea    0x1(%eax),%edx
  800bcd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bd5:	ff 4d f8             	decl   -0x8(%ebp)
  800bd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bdc:	79 e9                	jns    800bc7 <memset+0x14>
		*p++ = c;

	return v;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bf5:	eb 16                	jmp    800c0d <memcpy+0x2a>
		*d++ = *s++;
  800bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfa:	8d 50 01             	lea    0x1(%eax),%edx
  800bfd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c06:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c09:	8a 12                	mov    (%edx),%dl
  800c0b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c13:	89 55 10             	mov    %edx,0x10(%ebp)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	75 dd                	jne    800bf7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c37:	73 50                	jae    800c89 <memmove+0x6a>
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	01 d0                	add    %edx,%eax
  800c41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c44:	76 43                	jbe    800c89 <memmove+0x6a>
		s += n;
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c52:	eb 10                	jmp    800c64 <memmove+0x45>
			*--d = *--s;
  800c54:	ff 4d f8             	decl   -0x8(%ebp)
  800c57:	ff 4d fc             	decl   -0x4(%ebp)
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5d:	8a 10                	mov    (%eax),%dl
  800c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c62:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 e3                	jne    800c54 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c71:	eb 23                	jmp    800c96 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c85:	8a 12                	mov    (%edx),%dl
  800c87:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c89:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c92:	85 c0                	test   %eax,%eax
  800c94:	75 dd                	jne    800c73 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cad:	eb 2a                	jmp    800cd9 <memcmp+0x3e>
		if (*s1 != *s2)
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb2:	8a 10                	mov    (%eax),%dl
  800cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	38 c2                	cmp    %al,%dl
  800cbb:	74 16                	je     800cd3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f b6 d0             	movzbl %al,%edx
  800cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	0f b6 c0             	movzbl %al,%eax
  800ccd:	29 c2                	sub    %eax,%edx
  800ccf:	89 d0                	mov    %edx,%eax
  800cd1:	eb 18                	jmp    800ceb <memcmp+0x50>
		s1++, s2++;
  800cd3:	ff 45 fc             	incl   -0x4(%ebp)
  800cd6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cdf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	75 c9                	jne    800caf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cfe:	eb 15                	jmp    800d15 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	0f b6 d0             	movzbl %al,%edx
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	39 c2                	cmp    %eax,%edx
  800d10:	74 0d                	je     800d1f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d1b:	72 e3                	jb     800d00 <memfind+0x13>
  800d1d:	eb 01                	jmp    800d20 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d1f:	90                   	nop
	return (void *) s;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d39:	eb 03                	jmp    800d3e <strtol+0x19>
		s++;
  800d3b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 20                	cmp    $0x20,%al
  800d45:	74 f4                	je     800d3b <strtol+0x16>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 09                	cmp    $0x9,%al
  800d4e:	74 eb                	je     800d3b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 2b                	cmp    $0x2b,%al
  800d57:	75 05                	jne    800d5e <strtol+0x39>
		s++;
  800d59:	ff 45 08             	incl   0x8(%ebp)
  800d5c:	eb 13                	jmp    800d71 <strtol+0x4c>
	else if (*s == '-')
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 2d                	cmp    $0x2d,%al
  800d65:	75 0a                	jne    800d71 <strtol+0x4c>
		s++, neg = 1;
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 06                	je     800d7d <strtol+0x58>
  800d77:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d7b:	75 20                	jne    800d9d <strtol+0x78>
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3c 30                	cmp    $0x30,%al
  800d84:	75 17                	jne    800d9d <strtol+0x78>
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	40                   	inc    %eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3c 78                	cmp    $0x78,%al
  800d8e:	75 0d                	jne    800d9d <strtol+0x78>
		s += 2, base = 16;
  800d90:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d94:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d9b:	eb 28                	jmp    800dc5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	75 15                	jne    800db8 <strtol+0x93>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 30                	cmp    $0x30,%al
  800daa:	75 0c                	jne    800db8 <strtol+0x93>
		s++, base = 8;
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800db6:	eb 0d                	jmp    800dc5 <strtol+0xa0>
	else if (base == 0)
  800db8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbc:	75 07                	jne    800dc5 <strtol+0xa0>
		base = 10;
  800dbe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	3c 2f                	cmp    $0x2f,%al
  800dcc:	7e 19                	jle    800de7 <strtol+0xc2>
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	3c 39                	cmp    $0x39,%al
  800dd5:	7f 10                	jg     800de7 <strtol+0xc2>
			dig = *s - '0';
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	0f be c0             	movsbl %al,%eax
  800ddf:	83 e8 30             	sub    $0x30,%eax
  800de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800de5:	eb 42                	jmp    800e29 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	3c 60                	cmp    $0x60,%al
  800dee:	7e 19                	jle    800e09 <strtol+0xe4>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	3c 7a                	cmp    $0x7a,%al
  800df7:	7f 10                	jg     800e09 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	0f be c0             	movsbl %al,%eax
  800e01:	83 e8 57             	sub    $0x57,%eax
  800e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e07:	eb 20                	jmp    800e29 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 40                	cmp    $0x40,%al
  800e10:	7e 39                	jle    800e4b <strtol+0x126>
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	3c 5a                	cmp    $0x5a,%al
  800e19:	7f 30                	jg     800e4b <strtol+0x126>
			dig = *s - 'A' + 10;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f be c0             	movsbl %al,%eax
  800e23:	83 e8 37             	sub    $0x37,%eax
  800e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e2c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e2f:	7d 19                	jge    800e4a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e37:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e3b:	89 c2                	mov    %eax,%edx
  800e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e45:	e9 7b ff ff ff       	jmp    800dc5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4f:	74 08                	je     800e59 <strtol+0x134>
		*endptr = (char *) s;
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e5d:	74 07                	je     800e66 <strtol+0x141>
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	f7 d8                	neg    %eax
  800e64:	eb 03                	jmp    800e69 <strtol+0x144>
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <ltostr>:

void
ltostr(long value, char *str)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e78:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e83:	79 13                	jns    800e98 <ltostr+0x2d>
	{
		neg = 1;
  800e85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e92:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e95:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea0:	99                   	cltd   
  800ea1:	f7 f9                	idiv   %ecx
  800ea3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaf:	89 c2                	mov    %eax,%edx
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	01 d0                	add    %edx,%eax
  800eb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eb9:	83 c2 30             	add    $0x30,%edx
  800ebc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ebe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ec6:	f7 e9                	imul   %ecx
  800ec8:	c1 fa 02             	sar    $0x2,%edx
  800ecb:	89 c8                	mov    %ecx,%eax
  800ecd:	c1 f8 1f             	sar    $0x1f,%eax
  800ed0:	29 c2                	sub    %eax,%edx
  800ed2:	89 d0                	mov    %edx,%eax
  800ed4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eda:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800edf:	f7 e9                	imul   %ecx
  800ee1:	c1 fa 02             	sar    $0x2,%edx
  800ee4:	89 c8                	mov    %ecx,%eax
  800ee6:	c1 f8 1f             	sar    $0x1f,%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
  800eed:	c1 e0 02             	shl    $0x2,%eax
  800ef0:	01 d0                	add    %edx,%eax
  800ef2:	01 c0                	add    %eax,%eax
  800ef4:	29 c1                	sub    %eax,%ecx
  800ef6:	89 ca                	mov    %ecx,%edx
  800ef8:	85 d2                	test   %edx,%edx
  800efa:	75 9c                	jne    800e98 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800efc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f06:	48                   	dec    %eax
  800f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f0e:	74 3d                	je     800f4d <ltostr+0xe2>
		start = 1 ;
  800f10:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f17:	eb 34                	jmp    800f4d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	01 d0                	add    %edx,%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	01 c2                	add    %eax,%edx
  800f2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	01 c8                	add    %ecx,%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	01 c2                	add    %eax,%edx
  800f42:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f45:	88 02                	mov    %al,(%edx)
		start++ ;
  800f47:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f53:	7c c4                	jl     800f19 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f55:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f60:	90                   	nop
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f69:	ff 75 08             	pushl  0x8(%ebp)
  800f6c:	e8 54 fa ff ff       	call   8009c5 <strlen>
  800f71:	83 c4 04             	add    $0x4,%esp
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f77:	ff 75 0c             	pushl  0xc(%ebp)
  800f7a:	e8 46 fa ff ff       	call   8009c5 <strlen>
  800f7f:	83 c4 04             	add    $0x4,%esp
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f93:	eb 17                	jmp    800fac <strcconcat+0x49>
		final[s] = str1[s] ;
  800f95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	01 c2                	add    %eax,%edx
  800f9d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	01 c8                	add    %ecx,%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fa9:	ff 45 fc             	incl   -0x4(%ebp)
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb2:	7c e1                	jl     800f95 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc2:	eb 1f                	jmp    800fe3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc7:	8d 50 01             	lea    0x1(%eax),%edx
  800fca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fcd:	89 c2                	mov    %eax,%edx
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 c2                	add    %eax,%edx
  800fd4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	01 c8                	add    %ecx,%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe0:	ff 45 f8             	incl   -0x8(%ebp)
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe9:	7c d9                	jl     800fc4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800feb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	01 d0                	add    %edx,%eax
  800ff3:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff6:	90                   	nop
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ffc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801005:	8b 45 14             	mov    0x14(%ebp),%eax
  801008:	8b 00                	mov    (%eax),%eax
  80100a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801011:	8b 45 10             	mov    0x10(%ebp),%eax
  801014:	01 d0                	add    %edx,%eax
  801016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80101c:	eb 0c                	jmp    80102a <strsplit+0x31>
			*string++ = 0;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8d 50 01             	lea    0x1(%eax),%edx
  801024:	89 55 08             	mov    %edx,0x8(%ebp)
  801027:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	74 18                	je     80104b <strsplit+0x52>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	0f be c0             	movsbl %al,%eax
  80103b:	50                   	push   %eax
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	e8 13 fb ff ff       	call   800b57 <strchr>
  801044:	83 c4 08             	add    $0x8,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	75 d3                	jne    80101e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	84 c0                	test   %al,%al
  801052:	74 5a                	je     8010ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	8b 00                	mov    (%eax),%eax
  801059:	83 f8 0f             	cmp    $0xf,%eax
  80105c:	75 07                	jne    801065 <strsplit+0x6c>
		{
			return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
  801063:	eb 66                	jmp    8010cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801065:	8b 45 14             	mov    0x14(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	8d 48 01             	lea    0x1(%eax),%ecx
  80106d:	8b 55 14             	mov    0x14(%ebp),%edx
  801070:	89 0a                	mov    %ecx,(%edx)
  801072:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 c2                	add    %eax,%edx
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801083:	eb 03                	jmp    801088 <strsplit+0x8f>
			string++;
  801085:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	84 c0                	test   %al,%al
  80108f:	74 8b                	je     80101c <strsplit+0x23>
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f be c0             	movsbl %al,%eax
  801099:	50                   	push   %eax
  80109a:	ff 75 0c             	pushl  0xc(%ebp)
  80109d:	e8 b5 fa ff ff       	call   800b57 <strchr>
  8010a2:	83 c4 08             	add    $0x8,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	74 dc                	je     801085 <strsplit+0x8c>
			string++;
	}
  8010a9:	e9 6e ff ff ff       	jmp    80101c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	01 d0                	add    %edx,%eax
  8010c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8010d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010da:	eb 4c                	jmp    801128 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8010dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 40                	cmp    $0x40,%al
  8010e8:	7e 27                	jle    801111 <str2lower+0x44>
  8010ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	01 d0                	add    %edx,%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 5a                	cmp    $0x5a,%al
  8010f6:	7f 19                	jg     801111 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8010f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	01 d0                	add    %edx,%eax
  801100:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	01 ca                	add    %ecx,%edx
  801108:	8a 12                	mov    (%edx),%dl
  80110a:	83 c2 20             	add    $0x20,%edx
  80110d:	88 10                	mov    %dl,(%eax)
  80110f:	eb 14                	jmp    801125 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801111:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	01 c2                	add    %eax,%edx
  801119:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c8                	add    %ecx,%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801125:	ff 45 fc             	incl   -0x4(%ebp)
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	e8 95 f8 ff ff       	call   8009c5 <strlen>
  801130:	83 c4 04             	add    $0x4,%esp
  801133:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801136:	7f a4                	jg     8010dc <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  80114b:	a1 28 40 80 00       	mov    0x804028,%eax
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  80115a:	a1 28 40 80 00       	mov    0x804028,%eax
  80115f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801162:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  801169:	a1 28 40 80 00       	mov    0x804028,%eax
  80116e:	40                   	inc    %eax
  80116f:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801174:	90                   	nop
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <searchElement>:

int searchElement(uint32 start) {
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80117d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801184:	eb 17                	jmp    80119d <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801189:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801190:	3b 45 08             	cmp    0x8(%ebp),%eax
  801193:	75 05                	jne    80119a <searchElement+0x23>
			return i;
  801195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801198:	eb 12                	jmp    8011ac <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  80119a:	ff 45 fc             	incl   -0x4(%ebp)
  80119d:	a1 28 40 80 00       	mov    0x804028,%eax
  8011a2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  8011a5:	7c df                	jl     801186 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  8011a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <removeElement>:
void removeElement(uint32 start) {
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 bb ff ff ff       	call   801177 <searchElement>
  8011bc:	83 c4 04             	add    $0x4,%esp
  8011bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011c8:	eb 26                	jmp    8011f0 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  8011ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cd:	40                   	inc    %eax
  8011ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011d1:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  8011d8:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  8011df:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  8011e6:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  8011ed:	ff 45 fc             	incl   -0x4(%ebp)
  8011f0:	a1 28 40 80 00       	mov    0x804028,%eax
  8011f5:	48                   	dec    %eax
  8011f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011f9:	7f cf                	jg     8011ca <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  8011fb:	a1 28 40 80 00       	mov    0x804028,%eax
  801200:	48                   	dec    %eax
  801201:	a3 28 40 80 00       	mov    %eax,0x804028
}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <searchfree>:
int searchfree(uint32 end)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  80120f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801216:	eb 17                	jmp    80122f <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121b:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801222:	3b 45 08             	cmp    0x8(%ebp),%eax
  801225:	75 05                	jne    80122c <searchfree+0x23>
			return i;
  801227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122a:	eb 12                	jmp    80123e <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  80122c:	ff 45 fc             	incl   -0x4(%ebp)
  80122f:	a1 28 40 80 00       	mov    0x804028,%eax
  801234:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801237:	7c df                	jl     801218 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <removefree>:
void removefree(uint32 end)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  801246:	eb 52                	jmp    80129a <removefree+0x5a>
		int index = searchfree(end);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 b9 ff ff ff       	call   801209 <searchfree>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  801256:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801259:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80125c:	eb 26                	jmp    801284 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  80125e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801261:	40                   	inc    %eax
  801262:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801265:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  80126c:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801273:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  80127a:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801281:	ff 45 fc             	incl   -0x4(%ebp)
  801284:	a1 28 40 80 00       	mov    0x804028,%eax
  801289:	48                   	dec    %eax
  80128a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80128d:	7f cf                	jg     80125e <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  80128f:	a1 28 40 80 00       	mov    0x804028,%eax
  801294:	48                   	dec    %eax
  801295:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  80129a:	ff 75 08             	pushl  0x8(%ebp)
  80129d:	e8 67 ff ff ff       	call   801209 <searchfree>
  8012a2:	83 c4 04             	add    $0x4,%esp
  8012a5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8012a8:	75 9e                	jne    801248 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  8012aa:	90                   	nop
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <printArray>:
void printArray() {
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	68 b0 31 80 00       	push   $0x8031b0
  8012bb:	e8 83 f0 ff ff       	call   800343 <cprintf>
  8012c0:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  8012c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8012ca:	eb 29                	jmp    8012f5 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cf:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  8012d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d9:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  8012e0:	52                   	push   %edx
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e5:	68 c1 31 80 00       	push   $0x8031c1
  8012ea:	e8 54 f0 ff ff       	call   800343 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  8012f2:	ff 45 f4             	incl   -0xc(%ebp)
  8012f5:	a1 28 40 80 00       	mov    0x804028,%eax
  8012fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  8012fd:	7c cd                	jl     8012cc <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  8012ff:	90                   	nop
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801305:	a1 04 40 80 00       	mov    0x804004,%eax
  80130a:	85 c0                	test   %eax,%eax
  80130c:	74 0a                	je     801318 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80130e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801315:	00 00 00 
	}
}
  801318:	90                   	nop
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	e8 4f 09 00 00       	call   801c7b <sys_sbrk>
  80132c:	83 c4 10             	add    $0x10,%esp
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801337:	e8 c6 ff ff ff       	call   801302 <InitializeUHeap>
	if (size == 0) return NULL ;
  80133c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801340:	75 0a                	jne    80134c <malloc+0x1b>
  801342:	b8 00 00 00 00       	mov    $0x0,%eax
  801347:	e9 43 01 00 00       	jmp    80148f <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80134c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801353:	77 3c                	ja     801391 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801355:	e8 c3 07 00 00       	call   801b1d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80135a:	85 c0                	test   %eax,%eax
  80135c:	74 13                	je     801371 <malloc+0x40>
			return alloc_block_FF(size);
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	ff 75 08             	pushl  0x8(%ebp)
  801364:	e8 89 0b 00 00       	call   801ef2 <alloc_block_FF>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	e9 1e 01 00 00       	jmp    80148f <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801371:	e8 d8 07 00 00       	call   801b4e <sys_isUHeapPlacementStrategyBESTFIT>
  801376:	85 c0                	test   %eax,%eax
  801378:	0f 84 0c 01 00 00    	je     80148a <malloc+0x159>
			return alloc_block_BF(size);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 7d 0e 00 00       	call   802206 <alloc_block_BF>
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	e9 fe 00 00 00       	jmp    80148f <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801391:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801398:	8b 55 08             	mov    0x8(%ebp),%edx
  80139b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	f7 75 e0             	divl   -0x20(%ebp)
  8013af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013b2:	29 d0                	sub    %edx,%eax
  8013b4:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	c1 e8 0c             	shr    $0xc,%eax
  8013bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  8013c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  8013c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  8013ce:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  8013d5:	e8 f4 08 00 00       	call   801cce <sys_hard_limit>
  8013da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  8013dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013e0:	05 00 10 00 00       	add    $0x1000,%eax
  8013e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013e8:	eb 49                	jmp    801433 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  8013ea:	83 ec 0c             	sub    $0xc,%esp
  8013ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f0:	e8 82 fd ff ff       	call   801177 <searchElement>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8013fb:	75 28                	jne    801425 <malloc+0xf4>
			{


				count++;
  8013fd:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801403:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801406:	75 24                	jne    80142c <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140b:	05 00 10 00 00       	add    $0x1000,%eax
  801410:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	c1 e0 0c             	shl    $0xc,%eax
  801419:	89 c2                	mov    %eax,%edx
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	29 d0                	sub    %edx,%eax
  801420:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801423:	eb 17                	jmp    80143c <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  80142c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801433:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80143a:	76 ae                	jbe    8013ea <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  80143c:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801440:	75 07                	jne    801449 <malloc+0x118>
		{
			return NULL;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 46                	jmp    80148f <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144f:	eb 1a                	jmp    80146b <malloc+0x13a>
		{
			addElement(i,end);
  801451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	52                   	push   %edx
  80145b:	50                   	push   %eax
  80145c:	e8 e7 fc ff ff       	call   801148 <addElement>
  801461:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801464:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  80146b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801471:	7c de                	jl     801451 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	50                   	push   %eax
  80147d:	e8 30 08 00 00       	call   801cb2 <sys_allocate_user_mem>
  801482:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801488:	eb 05                	jmp    80148f <malloc+0x15e>
	}
	return NULL;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax



}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801497:	e8 32 08 00 00       	call   801cce <sys_hard_limit>
  80149c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	0f 89 82 00 00 00    	jns    80152c <free+0x9b>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8014b2:	77 78                	ja     80152c <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ba:	73 10                	jae    8014cc <free+0x3b>
			free_block(virtual_address);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	ff 75 08             	pushl  0x8(%ebp)
  8014c2:	e8 d2 0e 00 00       	call   802399 <free_block>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  8014ca:	eb 77                	jmp    801543 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 9f fc ff ff       	call   801177 <searchElement>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  8014e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014eb:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  8014f2:	29 c2                	sub    %eax,%edx
  8014f4:	89 d0                	mov    %edx,%eax
  8014f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  8014f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014fc:	c1 e8 0c             	shr    $0xc,%eax
  8014ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	ff 75 ec             	pushl  -0x14(%ebp)
  80150b:	50                   	push   %eax
  80150c:	e8 85 07 00 00       	call   801c96 <sys_free_user_mem>
  801511:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	50                   	push   %eax
  801522:	e8 19 fd ff ff       	call   801240 <removefree>
  801527:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  80152a:	eb 17                	jmp    801543 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	68 da 31 80 00       	push   $0x8031da
  801534:	68 ac 00 00 00       	push   $0xac
  801539:	68 ea 31 80 00       	push   $0x8031ea
  80153e:	e8 8a 13 00 00       	call   8028cd <_panic>
	}
}
  801543:	90                   	nop
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 18             	sub    $0x18,%esp
  80154c:	8b 45 10             	mov    0x10(%ebp),%eax
  80154f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801552:	e8 ab fd ff ff       	call   801302 <InitializeUHeap>
	if (size == 0) return NULL ;
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	75 07                	jne    801564 <smalloc+0x1e>
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 17                	jmp    80157b <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	68 f8 31 80 00       	push   $0x8031f8
  80156c:	68 bc 00 00 00       	push   $0xbc
  801571:	68 ea 31 80 00       	push   $0x8031ea
  801576:	e8 52 13 00 00       	call   8028cd <_panic>
	return NULL;
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801583:	e8 7a fd ff ff       	call   801302 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	68 20 32 80 00       	push   $0x803220
  801590:	68 ca 00 00 00       	push   $0xca
  801595:	68 ea 31 80 00       	push   $0x8031ea
  80159a:	e8 2e 13 00 00       	call   8028cd <_panic>

0080159f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a5:	e8 58 fd ff ff       	call   801302 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 44 32 80 00       	push   $0x803244
  8015b2:	68 ea 00 00 00       	push   $0xea
  8015b7:	68 ea 31 80 00       	push   $0x8031ea
  8015bc:	e8 0c 13 00 00       	call   8028cd <_panic>

008015c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	68 6c 32 80 00       	push   $0x80326c
  8015cf:	68 fe 00 00 00       	push   $0xfe
  8015d4:	68 ea 31 80 00       	push   $0x8031ea
  8015d9:	e8 ef 12 00 00       	call   8028cd <_panic>

008015de <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 90 32 80 00       	push   $0x803290
  8015ec:	68 08 01 00 00       	push   $0x108
  8015f1:	68 ea 31 80 00       	push   $0x8031ea
  8015f6:	e8 d2 12 00 00       	call   8028cd <_panic>

008015fb <shrink>:

}
void shrink(uint32 newSize)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 90 32 80 00       	push   $0x803290
  801609:	68 0d 01 00 00       	push   $0x10d
  80160e:	68 ea 31 80 00       	push   $0x8031ea
  801613:	e8 b5 12 00 00       	call   8028cd <_panic>

00801618 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 90 32 80 00       	push   $0x803290
  801626:	68 12 01 00 00       	push   $0x112
  80162b:	68 ea 31 80 00       	push   $0x8031ea
  801630:	e8 98 12 00 00       	call   8028cd <_panic>

00801635 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	57                   	push   %edi
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
  80163b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8b 55 0c             	mov    0xc(%ebp),%edx
  801644:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801647:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80164d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801650:	cd 30                	int    $0x30
  801652:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	5b                   	pop    %ebx
  80165c:	5e                   	pop    %esi
  80165d:	5f                   	pop    %edi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80166c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	50                   	push   %eax
  80167c:	6a 00                	push   $0x0
  80167e:	e8 b2 ff ff ff       	call   801635 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_cgetc>:

int
sys_cgetc(void)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 01                	push   $0x1
  801698:	e8 98 ff ff ff       	call   801635 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 05                	push   $0x5
  8016b5:	e8 7b ff ff ff       	call   801635 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	51                   	push   %ecx
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 06                	push   $0x6
  8016da:	e8 56 ff ff ff       	call   801635 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	6a 07                	push   $0x7
  8016fc:	e8 34 ff ff ff       	call   801635 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	6a 08                	push   $0x8
  801717:	e8 19 ff ff ff       	call   801635 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 09                	push   $0x9
  801730:	e8 00 ff ff ff       	call   801635 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 0a                	push   $0xa
  801749:	e8 e7 fe ff ff       	call   801635 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 0b                	push   $0xb
  801762:	e8 ce fe ff ff       	call   801635 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 0c                	push   $0xc
  80177b:	e8 b5 fe ff ff       	call   801635 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	6a 0d                	push   $0xd
  801795:	e8 9b fe ff ff       	call   801635 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 0e                	push   $0xe
  8017ae:	e8 82 fe ff ff       	call   801635 <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	90                   	nop
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 11                	push   $0x11
  8017c8:	e8 68 fe ff ff       	call   801635 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	90                   	nop
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 12                	push   $0x12
  8017e2:	e8 4e fe ff ff       	call   801635 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	90                   	nop
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_cputc>:


void
sys_cputc(const char c)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 13                	push   $0x13
  801808:	e8 28 fe ff ff       	call   801635 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 14                	push   $0x14
  801822:	e8 0e fe ff ff       	call   801635 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	90                   	nop
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	50                   	push   %eax
  80183d:	6a 15                	push   $0x15
  80183f:	e8 f1 fd ff ff       	call   801635 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	52                   	push   %edx
  801859:	50                   	push   %eax
  80185a:	6a 18                	push   $0x18
  80185c:	e8 d4 fd ff ff       	call   801635 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 16                	push   $0x16
  801879:	e8 b7 fd ff ff       	call   801635 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	90                   	nop
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 17                	push   $0x17
  801897:	e8 99 fd ff ff       	call   801635 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	51                   	push   %ecx
  8018bb:	52                   	push   %edx
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	6a 19                	push   $0x19
  8018c2:	e8 6e fd ff ff       	call   801635 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 1a                	push   $0x1a
  8018df:	e8 51 fd ff ff       	call   801635 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	51                   	push   %ecx
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 1b                	push   $0x1b
  8018fe:	e8 32 fd ff ff       	call   801635 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 1c                	push   $0x1c
  80191b:	e8 15 fd ff ff       	call   801635 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 1d                	push   $0x1d
  801934:	e8 fc fc ff ff       	call   801635 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	ff 75 14             	pushl  0x14(%ebp)
  801949:	ff 75 10             	pushl  0x10(%ebp)
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	6a 1e                	push   $0x1e
  801952:	e8 de fc ff ff       	call   801635 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	50                   	push   %eax
  80196b:	6a 1f                	push   $0x1f
  80196d:	e8 c3 fc ff ff       	call   801635 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	50                   	push   %eax
  801987:	6a 20                	push   $0x20
  801989:	e8 a7 fc ff ff       	call   801635 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 02                	push   $0x2
  8019a2:	e8 8e fc ff ff       	call   801635 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 03                	push   $0x3
  8019bb:	e8 75 fc ff ff       	call   801635 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 04                	push   $0x4
  8019d4:	e8 5c fc ff ff       	call   801635 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_exit_env>:


void sys_exit_env(void)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 21                	push   $0x21
  8019ed:	e8 43 fc ff ff       	call   801635 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a01:	8d 50 04             	lea    0x4(%eax),%edx
  801a04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 22                	push   $0x22
  801a11:	e8 1f fc ff ff       	call   801635 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return result;
  801a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a22:	89 01                	mov    %eax,(%ecx)
  801a24:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	c9                   	leave  
  801a2b:	c2 04 00             	ret    $0x4

00801a2e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 10                	push   $0x10
  801a40:	e8 f0 fb ff ff       	call   801635 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return ;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 23                	push   $0x23
  801a5a:	e8 d6 fb ff ff       	call   801635 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a70:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	50                   	push   %eax
  801a7d:	6a 24                	push   $0x24
  801a7f:	e8 b1 fb ff ff       	call   801635 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	return ;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <rsttst>:
void rsttst()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 26                	push   $0x26
  801a99:	e8 97 fb ff ff       	call   801635 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa1:	90                   	nop
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ab3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	6a 25                	push   $0x25
  801ac4:	e8 6c fb ff ff       	call   801635 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return ;
  801acc:	90                   	nop
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <chktst>:
void chktst(uint32 n)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 27                	push   $0x27
  801adf:	e8 51 fb ff ff       	call   801635 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae7:	90                   	nop
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <inctst>:

void inctst()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 28                	push   $0x28
  801af9:	e8 37 fb ff ff       	call   801635 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <gettst>:
uint32 gettst()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 29                	push   $0x29
  801b13:	e8 1d fb ff ff       	call   801635 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 2a                	push   $0x2a
  801b2f:	e8 01 fb ff ff       	call   801635 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
  801b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b3a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b3e:	75 07                	jne    801b47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b40:	b8 01 00 00 00       	mov    $0x1,%eax
  801b45:	eb 05                	jmp    801b4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2a                	push   $0x2a
  801b60:	e8 d0 fa ff ff       	call   801635 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
  801b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b6b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b6f:	75 07                	jne    801b78 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	eb 05                	jmp    801b7d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 2a                	push   $0x2a
  801b91:	e8 9f fa ff ff       	call   801635 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
  801b99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b9c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ba0:	75 07                	jne    801ba9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba7:	eb 05                	jmp    801bae <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 2a                	push   $0x2a
  801bc2:	e8 6e fa ff ff       	call   801635 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
  801bca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bcd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bd1:	75 07                	jne    801bda <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd8:	eb 05                	jmp    801bdf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	6a 2b                	push   $0x2b
  801bf1:	e8 3f fa ff ff       	call   801635 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf9:	90                   	nop
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	53                   	push   %ebx
  801c0f:	51                   	push   %ecx
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	6a 2c                	push   $0x2c
  801c14:	e8 1c fa ff ff       	call   801635 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 2d                	push   $0x2d
  801c34:	e8 fc f9 ff ff       	call   801635 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	51                   	push   %ecx
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 2e                	push   $0x2e
  801c54:	e8 dc f9 ff ff       	call   801635 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 10             	pushl  0x10(%ebp)
  801c68:	ff 75 0c             	pushl  0xc(%ebp)
  801c6b:	ff 75 08             	pushl  0x8(%ebp)
  801c6e:	6a 0f                	push   $0xf
  801c70:	e8 c0 f9 ff ff       	call   801635 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
	return ;
  801c78:	90                   	nop
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	50                   	push   %eax
  801c8a:	6a 2f                	push   $0x2f
  801c8c:	e8 a4 f9 ff ff       	call   801635 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp

}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 30                	push   $0x30
  801ca7:	e8 89 f9 ff ff       	call   801635 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp

}
  801caf:	90                   	nop
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	6a 31                	push   $0x31
  801cc3:	e8 6d f9 ff ff       	call   801635 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp

}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_hard_limit>:
uint32 sys_hard_limit(){
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 32                	push   $0x32
  801cdd:	e8 53 f9 ff ff       	call   801635 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	83 e8 10             	sub    $0x10,%eax
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  801cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	83 e8 10             	sub    $0x10,%eax
  801d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  801d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d0f:	8a 40 04             	mov    0x4(%eax),%al
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	83 f8 02             	cmp    $0x2,%eax
  801d27:	74 2b                	je     801d54 <alloc_block+0x40>
  801d29:	83 f8 02             	cmp    $0x2,%eax
  801d2c:	7f 07                	jg     801d35 <alloc_block+0x21>
  801d2e:	83 f8 01             	cmp    $0x1,%eax
  801d31:	74 0e                	je     801d41 <alloc_block+0x2d>
  801d33:	eb 58                	jmp    801d8d <alloc_block+0x79>
  801d35:	83 f8 03             	cmp    $0x3,%eax
  801d38:	74 2d                	je     801d67 <alloc_block+0x53>
  801d3a:	83 f8 04             	cmp    $0x4,%eax
  801d3d:	74 3b                	je     801d7a <alloc_block+0x66>
  801d3f:	eb 4c                	jmp    801d8d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	e8 a6 01 00 00       	call   801ef2 <alloc_block_FF>
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d52:	eb 4a                	jmp    801d9e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	e8 1d 06 00 00       	call   80237c <alloc_block_NF>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d65:	eb 37                	jmp    801d9e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 94 04 00 00       	call   802206 <alloc_block_BF>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d78:	eb 24                	jmp    801d9e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	ff 75 08             	pushl  0x8(%ebp)
  801d80:	e8 da 05 00 00       	call   80235f <alloc_block_WF>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d8b:	eb 11                	jmp    801d9e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	68 a0 32 80 00       	push   $0x8032a0
  801d95:	e8 a9 e5 ff ff       	call   800343 <cprintf>
  801d9a:	83 c4 10             	add    $0x10,%esp
		break;
  801d9d:	90                   	nop
	}
	return va;
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	68 c0 32 80 00       	push   $0x8032c0
  801db1:	e8 8d e5 ff ff       	call   800343 <cprintf>
  801db6:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	68 eb 32 80 00       	push   $0x8032eb
  801dc1:	e8 7d e5 ff ff       	call   800343 <cprintf>
  801dc6:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcf:	eb 26                	jmp    801df7 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8a 40 04             	mov    0x4(%eax),%al
  801dd7:	0f b6 d0             	movzbl %al,%edx
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	68 03 33 80 00       	push   $0x803303
  801de9:	e8 55 e5 ff ff       	call   800343 <cprintf>
  801dee:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801df1:	8b 45 10             	mov    0x10(%ebp),%eax
  801df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfb:	74 08                	je     801e05 <print_blocks_list+0x62>
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	8b 40 08             	mov    0x8(%eax),%eax
  801e03:	eb 05                	jmp    801e0a <print_blocks_list+0x67>
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	89 45 10             	mov    %eax,0x10(%ebp)
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	85 c0                	test   %eax,%eax
  801e12:	75 bd                	jne    801dd1 <print_blocks_list+0x2e>
  801e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e18:	75 b7                	jne    801dd1 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	68 c0 32 80 00       	push   $0x8032c0
  801e22:	e8 1c e5 ff ff       	call   800343 <cprintf>
  801e27:	83 c4 10             	add    $0x10,%esp

}
  801e2a:	90                   	nop
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  801e33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e37:	0f 84 b2 00 00 00    	je     801eef <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  801e3d:	c7 05 2c 40 80 00 01 	movl   $0x1,0x80402c
  801e44:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  801e47:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  801e4e:	00 00 00 
  801e51:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  801e58:	00 00 00 
  801e5b:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  801e62:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  801e6d:	a1 24 41 80 00       	mov    0x804124,%eax
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  801e77:	a1 24 41 80 00       	mov    0x804124,%eax
  801e7c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  801e80:	a1 24 41 80 00       	mov    0x804124,%eax
  801e85:	85 c0                	test   %eax,%eax
  801e87:	75 14                	jne    801e9d <initialize_dynamic_allocator+0x70>
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 1c 33 80 00       	push   $0x80331c
  801e91:	6a 68                	push   $0x68
  801e93:	68 3f 33 80 00       	push   $0x80333f
  801e98:	e8 30 0a 00 00       	call   8028cd <_panic>
  801e9d:	a1 24 41 80 00       	mov    0x804124,%eax
  801ea2:	8b 15 14 41 80 00    	mov    0x804114,%edx
  801ea8:	89 50 08             	mov    %edx,0x8(%eax)
  801eab:	8b 40 08             	mov    0x8(%eax),%eax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	74 10                	je     801ec2 <initialize_dynamic_allocator+0x95>
  801eb2:	a1 14 41 80 00       	mov    0x804114,%eax
  801eb7:	8b 15 24 41 80 00    	mov    0x804124,%edx
  801ebd:	89 50 0c             	mov    %edx,0xc(%eax)
  801ec0:	eb 0a                	jmp    801ecc <initialize_dynamic_allocator+0x9f>
  801ec2:	a1 24 41 80 00       	mov    0x804124,%eax
  801ec7:	a3 18 41 80 00       	mov    %eax,0x804118
  801ecc:	a1 24 41 80 00       	mov    0x804124,%eax
  801ed1:	a3 14 41 80 00       	mov    %eax,0x804114
  801ed6:	a1 24 41 80 00       	mov    0x804124,%eax
  801edb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801ee2:	a1 20 41 80 00       	mov    0x804120,%eax
  801ee7:	40                   	inc    %eax
  801ee8:	a3 20 41 80 00       	mov    %eax,0x804120
  801eed:	eb 01                	jmp    801ef0 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  801eef:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  801ef8:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 40                	jne    801f41 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	83 c0 10             	add    $0x10,%eax
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	50                   	push   %eax
  801f11:	e8 05 f4 ff ff       	call   80131b <sbrk>
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 f5 f3 ff ff       	call   80131b <sbrk>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  801f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f2f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	50                   	push   %eax
  801f36:	ff 75 ec             	pushl  -0x14(%ebp)
  801f39:	e8 ef fe ff ff       	call   801e2d <initialize_dynamic_allocator>
  801f3e:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  801f41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f45:	75 0a                	jne    801f51 <alloc_block_FF+0x5f>
		 return NULL;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	e9 b3 02 00 00       	jmp    802204 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  801f51:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  801f55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  801f5c:	a1 14 41 80 00       	mov    0x804114,%eax
  801f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f64:	e9 12 01 00 00       	jmp    80207b <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8a 40 04             	mov    0x4(%eax),%al
  801f6f:	84 c0                	test   %al,%al
  801f71:	0f 84 fc 00 00 00    	je     802073 <alloc_block_FF+0x181>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f7f:	0f 82 ee 00 00 00    	jb     802073 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f8d:	75 12                	jne    801fa1 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	83 c0 10             	add    $0x10,%eax
  801f9c:	e9 63 02 00 00       	jmp    802204 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  801fa1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 00                	mov    (%eax),%eax
  801fb4:	2b 45 08             	sub    0x8(%ebp),%eax
  801fb7:	83 f8 0f             	cmp    $0xf,%eax
  801fba:	0f 86 a8 00 00 00    	jbe    802068 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  801fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	01 d0                	add    %edx,%eax
  801fc8:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	2b 45 08             	sub    0x8(%ebp),%eax
  801fd3:	89 c2                	mov    %eax,%edx
  801fd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fd8:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe0:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  801fe2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fe5:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	74 06                	je     801ff5 <alloc_block_FF+0x103>
  801fef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ff3:	75 17                	jne    80200c <alloc_block_FF+0x11a>
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	68 58 33 80 00       	push   $0x803358
  801ffd:	68 91 00 00 00       	push   $0x91
  802002:	68 3f 33 80 00       	push   $0x80333f
  802007:	e8 c1 08 00 00       	call   8028cd <_panic>
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 50 08             	mov    0x8(%eax),%edx
  802012:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802015:	89 50 08             	mov    %edx,0x8(%eax)
  802018:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	85 c0                	test   %eax,%eax
  802020:	74 0c                	je     80202e <alloc_block_FF+0x13c>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 40 08             	mov    0x8(%eax),%eax
  802028:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80202b:	89 50 0c             	mov    %edx,0xc(%eax)
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802034:	89 50 08             	mov    %edx,0x8(%eax)
  802037:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80203a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203d:	89 50 0c             	mov    %edx,0xc(%eax)
  802040:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802043:	8b 40 08             	mov    0x8(%eax),%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	75 08                	jne    802052 <alloc_block_FF+0x160>
  80204a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80204d:	a3 18 41 80 00       	mov    %eax,0x804118
  802052:	a1 20 41 80 00       	mov    0x804120,%eax
  802057:	40                   	inc    %eax
  802058:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	83 c0 10             	add    $0x10,%eax
  802063:	e9 9c 01 00 00       	jmp    802204 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	83 c0 10             	add    $0x10,%eax
  80206e:	e9 91 01 00 00       	jmp    802204 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802073:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207f:	74 08                	je     802089 <alloc_block_FF+0x197>
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	eb 05                	jmp    80208e <alloc_block_FF+0x19c>
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802093:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802098:	85 c0                	test   %eax,%eax
  80209a:	0f 85 c9 fe ff ff    	jne    801f69 <alloc_block_FF+0x77>
  8020a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a4:	0f 85 bf fe ff ff    	jne    801f69 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  8020aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020ae:	0f 85 4b 01 00 00    	jne    8021ff <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	50                   	push   %eax
  8020bb:	e8 5b f2 ff ff       	call   80131b <sbrk>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  8020c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ca:	0f 84 28 01 00 00    	je     8021f8 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  8020d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dc:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  8020de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  8020e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020e9:	75 17                	jne    802102 <alloc_block_FF+0x210>
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	68 8c 33 80 00       	push   $0x80338c
  8020f3:	68 a1 00 00 00       	push   $0xa1
  8020f8:	68 3f 33 80 00       	push   $0x80333f
  8020fd:	e8 cb 07 00 00       	call   8028cd <_panic>
  802102:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210b:	89 50 0c             	mov    %edx,0xc(%eax)
  80210e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802111:	8b 40 0c             	mov    0xc(%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 0d                	je     802125 <alloc_block_FF+0x233>
  802118:	a1 18 41 80 00       	mov    0x804118,%eax
  80211d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802120:	89 50 08             	mov    %edx,0x8(%eax)
  802123:	eb 08                	jmp    80212d <alloc_block_FF+0x23b>
  802125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802128:	a3 14 41 80 00       	mov    %eax,0x804114
  80212d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802130:	a3 18 41 80 00       	mov    %eax,0x804118
  802135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802138:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80213f:	a1 20 41 80 00       	mov    0x804120,%eax
  802144:	40                   	inc    %eax
  802145:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  80214a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80214f:	2b 45 08             	sub    0x8(%ebp),%eax
  802152:	83 f8 0f             	cmp    $0xf,%eax
  802155:	0f 86 95 00 00 00    	jbe    8021f0 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  80215b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	01 d0                	add    %edx,%eax
  802163:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802166:	b8 00 10 00 00       	mov    $0x1000,%eax
  80216b:	2b 45 08             	sub    0x8(%ebp),%eax
  80216e:	89 c2                	mov    %eax,%edx
  802170:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802173:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802175:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802178:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  80217c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802180:	74 06                	je     802188 <alloc_block_FF+0x296>
  802182:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802186:	75 17                	jne    80219f <alloc_block_FF+0x2ad>
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	68 58 33 80 00       	push   $0x803358
  802190:	68 a6 00 00 00       	push   $0xa6
  802195:	68 3f 33 80 00       	push   $0x80333f
  80219a:	e8 2e 07 00 00       	call   8028cd <_panic>
  80219f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a2:	8b 50 08             	mov    0x8(%eax),%edx
  8021a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021a8:	89 50 08             	mov    %edx,0x8(%eax)
  8021ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021ae:	8b 40 08             	mov    0x8(%eax),%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	74 0c                	je     8021c1 <alloc_block_FF+0x2cf>
  8021b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021be:	89 50 0c             	mov    %edx,0xc(%eax)
  8021c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021c7:	89 50 08             	mov    %edx,0x8(%eax)
  8021ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8021d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021d6:	8b 40 08             	mov    0x8(%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	75 08                	jne    8021e5 <alloc_block_FF+0x2f3>
  8021dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021e0:	a3 18 41 80 00       	mov    %eax,0x804118
  8021e5:	a1 20 41 80 00       	mov    0x804120,%eax
  8021ea:	40                   	inc    %eax
  8021eb:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  8021f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f3:	83 c0 10             	add    $0x10,%eax
  8021f6:	eb 0c                	jmp    802204 <alloc_block_FF+0x312>
		 }
		 return NULL;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	eb 05                	jmp    802204 <alloc_block_FF+0x312>
	 }
	 return NULL;
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  80220c:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  802217:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  80221e:	a1 14 41 80 00       	mov    0x804114,%eax
  802223:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802226:	eb 34                	jmp    80225c <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222b:	8a 40 04             	mov    0x4(%eax),%al
  80222e:	84 c0                	test   %al,%al
  802230:	74 22                	je     802254 <alloc_block_BF+0x4e>
  802232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223a:	72 18                	jb     802254 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  80223c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802244:	73 0e                	jae    802254 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  802246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802249:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  80224c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802254:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802259:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80225c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802260:	74 08                	je     80226a <alloc_block_BF+0x64>
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	eb 05                	jmp    80226f <alloc_block_BF+0x69>
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802274:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	75 ab                	jne    802228 <alloc_block_BF+0x22>
  80227d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802281:	75 a5                	jne    802228 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802287:	0f 84 cb 00 00 00    	je     802358 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229c:	0f 86 ae 00 00 00    	jbe    802350 <alloc_block_BF+0x14a>
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8022aa:	83 f8 0f             	cmp    $0xf,%eax
  8022ad:	0f 86 9d 00 00 00    	jbe    802350 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8022c6:	89 c2                	mov    %eax,%edx
  8022c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022cb:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  8022cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022da:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e0:	74 06                	je     8022e8 <alloc_block_BF+0xe2>
  8022e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022e6:	75 17                	jne    8022ff <alloc_block_BF+0xf9>
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 58 33 80 00       	push   $0x803358
  8022f0:	68 c6 00 00 00       	push   $0xc6
  8022f5:	68 3f 33 80 00       	push   $0x80333f
  8022fa:	e8 ce 05 00 00       	call   8028cd <_panic>
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 50 08             	mov    0x8(%eax),%edx
  802305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802308:	89 50 08             	mov    %edx,0x8(%eax)
  80230b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	74 0c                	je     802321 <alloc_block_BF+0x11b>
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 40 08             	mov    0x8(%eax),%eax
  80231b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80231e:	89 50 0c             	mov    %edx,0xc(%eax)
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802327:	89 50 08             	mov    %edx,0x8(%eax)
  80232a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802330:	89 50 0c             	mov    %edx,0xc(%eax)
  802333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802336:	8b 40 08             	mov    0x8(%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	75 08                	jne    802345 <alloc_block_BF+0x13f>
  80233d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802340:	a3 18 41 80 00       	mov    %eax,0x804118
  802345:	a1 20 41 80 00       	mov    0x804120,%eax
  80234a:	40                   	inc    %eax
  80234b:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	83 c0 10             	add    $0x10,%eax
  802356:	eb 05                	jmp    80235d <alloc_block_BF+0x157>
    }

    return NULL;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 b0 33 80 00       	push   $0x8033b0
  80236d:	68 d2 00 00 00       	push   $0xd2
  802372:	68 3f 33 80 00       	push   $0x80333f
  802377:	e8 51 05 00 00       	call   8028cd <_panic>

0080237c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	68 d8 33 80 00       	push   $0x8033d8
  80238a:	68 db 00 00 00       	push   $0xdb
  80238f:	68 3f 33 80 00       	push   $0x80333f
  802394:	e8 34 05 00 00       	call   8028cd <_panic>

00802399 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  80239f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a3:	0f 84 d2 01 00 00    	je     80257b <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	83 e8 10             	sub    $0x10,%eax
  8023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8a 40 04             	mov    0x4(%eax),%al
  8023b8:	84 c0                	test   %al,%al
  8023ba:	0f 85 be 01 00 00    	jne    80257e <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 08             	mov    0x8(%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	0f 84 cc 00 00 00    	je     8024a1 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 08             	mov    0x8(%eax),%eax
  8023db:	8a 40 04             	mov    0x4(%eax),%al
  8023de:	84 c0                	test   %al,%al
  8023e0:	0f 84 bb 00 00 00    	je     8024a1 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 10                	mov    (%eax),%edx
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 08             	mov    0x8(%eax),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	01 c2                	add    %eax,%edx
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 08             	mov    0x8(%eax),%eax
  802400:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 08             	mov    0x8(%eax),%eax
  80240a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 08             	mov    0x8(%eax),%eax
  802416:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80241d:	75 17                	jne    802436 <free_block+0x9d>
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 fe 33 80 00       	push   $0x8033fe
  802427:	68 f8 00 00 00       	push   $0xf8
  80242c:	68 3f 33 80 00       	push   $0x80333f
  802431:	e8 97 04 00 00       	call   8028cd <_panic>
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	8b 40 08             	mov    0x8(%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 11                	je     802451 <free_block+0xb8>
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	8b 40 08             	mov    0x8(%eax),%eax
  802446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802449:	8b 52 0c             	mov    0xc(%edx),%edx
  80244c:	89 50 0c             	mov    %edx,0xc(%eax)
  80244f:	eb 0b                	jmp    80245c <free_block+0xc3>
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	a3 18 41 80 00       	mov    %eax,0x804118
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	8b 40 0c             	mov    0xc(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 11                	je     802477 <free_block+0xde>
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	8b 40 0c             	mov    0xc(%eax),%eax
  80246c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246f:	8b 52 08             	mov    0x8(%edx),%edx
  802472:	89 50 08             	mov    %edx,0x8(%eax)
  802475:	eb 0b                	jmp    802482 <free_block+0xe9>
  802477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247a:	8b 40 08             	mov    0x8(%eax),%eax
  80247d:	a3 14 41 80 00       	mov    %eax,0x804114
  802482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802485:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802496:	a1 20 41 80 00       	mov    0x804120,%eax
  80249b:	48                   	dec    %eax
  80249c:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 84 d0 00 00 00    	je     80257f <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b5:	8a 40 04             	mov    0x4(%eax),%al
  8024b8:	84 c0                	test   %al,%al
  8024ba:	0f 84 bf 00 00 00    	je     80257f <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8024cc:	8b 0a                	mov    (%edx),%ecx
  8024ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d1:	8b 12                	mov    (%edx),%edx
  8024d3:	01 ca                	add    %ecx,%edx
  8024d5:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dd:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  8024f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f5:	75 17                	jne    80250e <free_block+0x175>
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	68 fe 33 80 00       	push   $0x8033fe
  8024ff:	68 03 01 00 00       	push   $0x103
  802504:	68 3f 33 80 00       	push   $0x80333f
  802509:	e8 bf 03 00 00       	call   8028cd <_panic>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 08             	mov    0x8(%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 11                	je     802529 <free_block+0x190>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 08             	mov    0x8(%eax),%eax
  80251e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802521:	8b 52 0c             	mov    0xc(%edx),%edx
  802524:	89 50 0c             	mov    %edx,0xc(%eax)
  802527:	eb 0b                	jmp    802534 <free_block+0x19b>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 0c             	mov    0xc(%eax),%eax
  80252f:	a3 18 41 80 00       	mov    %eax,0x804118
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 11                	je     80254f <free_block+0x1b6>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802547:	8b 52 08             	mov    0x8(%edx),%edx
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
  80254d:	eb 0b                	jmp    80255a <free_block+0x1c1>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 08             	mov    0x8(%eax),%eax
  802555:	a3 14 41 80 00       	mov    %eax,0x804114
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80256e:	a1 20 41 80 00       	mov    0x804120,%eax
  802573:	48                   	dec    %eax
  802574:	a3 20 41 80 00       	mov    %eax,0x804120
  802579:	eb 04                	jmp    80257f <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  80257b:	90                   	nop
  80257c:	eb 01                	jmp    80257f <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  80257e:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80258b:	75 10                	jne    80259d <realloc_block_FF+0x1c>
  80258d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802591:	75 0a                	jne    80259d <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	e9 2e 03 00 00       	jmp    8028cb <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  80259d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a1:	75 13                	jne    8025b6 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	e8 44 f9 ff ff       	call   801ef2 <alloc_block_FF>
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	e9 15 03 00 00       	jmp    8028cb <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  8025b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025ba:	75 18                	jne    8025d4 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 08             	pushl  0x8(%ebp)
  8025c2:	e8 d2 fd ff ff       	call   802399 <free_block>
  8025c7:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	e9 f7 02 00 00       	jmp    8028cb <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	83 e8 10             	sub    $0x10,%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  8025dd:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025e9:	0f 82 c8 00 00 00    	jb     8026b7 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025f7:	75 08                	jne    802601 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	e9 ca 02 00 00       	jmp    8028cb <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	2b 45 0c             	sub    0xc(%ebp),%eax
  802609:	83 f8 0f             	cmp    $0xf,%eax
  80260c:	0f 86 9d 00 00 00    	jbe    8026af <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802615:	8b 45 0c             	mov    0xc(%ebp),%eax
  802618:	01 d0                	add    %edx,%eax
  80261a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	2b 45 0c             	sub    0xc(%ebp),%eax
  802625:	89 c2                	mov    %eax,%edx
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802632:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  802634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802637:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	74 06                	je     802647 <realloc_block_FF+0xc6>
  802641:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802645:	75 17                	jne    80265e <realloc_block_FF+0xdd>
  802647:	83 ec 04             	sub    $0x4,%esp
  80264a:	68 58 33 80 00       	push   $0x803358
  80264f:	68 2a 01 00 00       	push   $0x12a
  802654:	68 3f 33 80 00       	push   $0x80333f
  802659:	e8 6f 02 00 00       	call   8028cd <_panic>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 50 08             	mov    0x8(%eax),%edx
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	89 50 08             	mov    %edx,0x8(%eax)
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	8b 40 08             	mov    0x8(%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 0c                	je     802680 <realloc_block_FF+0xff>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 08             	mov    0x8(%eax),%eax
  80267a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267d:	89 50 0c             	mov    %edx,0xc(%eax)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802686:	89 50 08             	mov    %edx,0x8(%eax)
  802689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	89 50 0c             	mov    %edx,0xc(%eax)
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	8b 40 08             	mov    0x8(%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	75 08                	jne    8026a4 <realloc_block_FF+0x123>
  80269c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269f:	a3 18 41 80 00       	mov    %eax,0x804118
  8026a4:	a1 20 41 80 00       	mov    0x804120,%eax
  8026a9:	40                   	inc    %eax
  8026aa:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	e9 14 02 00 00       	jmp    8028cb <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 08             	mov    0x8(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	0f 84 97 01 00 00    	je     80285c <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 08             	mov    0x8(%eax),%eax
  8026cb:	8a 40 04             	mov    0x4(%eax),%al
  8026ce:	84 c0                	test   %al,%al
  8026d0:	0f 84 86 01 00 00    	je     80285c <realloc_block_FF+0x2db>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 10                	mov    (%eax),%edx
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 40 08             	mov    0x8(%eax),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	01 d0                	add    %edx,%eax
  8026e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026e8:	0f 82 6e 01 00 00    	jb     80285c <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 10                	mov    (%eax),%edx
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 40 08             	mov    0x8(%eax),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	01 c2                	add    %eax,%edx
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 08             	mov    0x8(%eax),%eax
  802708:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 08             	mov    0x8(%eax),%eax
  802712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 08             	mov    0x8(%eax),%eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  802721:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802725:	75 17                	jne    80273e <realloc_block_FF+0x1bd>
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	68 fe 33 80 00       	push   $0x8033fe
  80272f:	68 38 01 00 00       	push   $0x138
  802734:	68 3f 33 80 00       	push   $0x80333f
  802739:	e8 8f 01 00 00       	call   8028cd <_panic>
  80273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802741:	8b 40 08             	mov    0x8(%eax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	74 11                	je     802759 <realloc_block_FF+0x1d8>
  802748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274b:	8b 40 08             	mov    0x8(%eax),%eax
  80274e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802751:	8b 52 0c             	mov    0xc(%edx),%edx
  802754:	89 50 0c             	mov    %edx,0xc(%eax)
  802757:	eb 0b                	jmp    802764 <realloc_block_FF+0x1e3>
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	a3 18 41 80 00       	mov    %eax,0x804118
  802764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 11                	je     80277f <realloc_block_FF+0x1fe>
  80276e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802771:	8b 40 0c             	mov    0xc(%eax),%eax
  802774:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802777:	8b 52 08             	mov    0x8(%edx),%edx
  80277a:	89 50 08             	mov    %edx,0x8(%eax)
  80277d:	eb 0b                	jmp    80278a <realloc_block_FF+0x209>
  80277f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802782:	8b 40 08             	mov    0x8(%eax),%eax
  802785:	a3 14 41 80 00       	mov    %eax,0x804114
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802797:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80279e:	a1 20 41 80 00       	mov    0x804120,%eax
  8027a3:	48                   	dec    %eax
  8027a4:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	2b 45 0c             	sub    0xc(%ebp),%eax
  8027b1:	83 f8 0f             	cmp    $0xf,%eax
  8027b4:	0f 86 9d 00 00 00    	jbe    802857 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c0:	01 d0                	add    %edx,%eax
  8027c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	2b 45 0c             	sub    0xc(%ebp),%eax
  8027cd:	89 c2                	mov    %eax,%edx
  8027cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d2:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027da:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  8027dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027df:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	74 06                	je     8027ef <realloc_block_FF+0x26e>
  8027e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ed:	75 17                	jne    802806 <realloc_block_FF+0x285>
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	68 58 33 80 00       	push   $0x803358
  8027f7:	68 3f 01 00 00       	push   $0x13f
  8027fc:	68 3f 33 80 00       	push   $0x80333f
  802801:	e8 c7 00 00 00       	call   8028cd <_panic>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 50 08             	mov    0x8(%eax),%edx
  80280c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280f:	89 50 08             	mov    %edx,0x8(%eax)
  802812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802815:	8b 40 08             	mov    0x8(%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0c                	je     802828 <realloc_block_FF+0x2a7>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 08             	mov    0x8(%eax),%eax
  802822:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802825:	89 50 0c             	mov    %edx,0xc(%eax)
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80282e:	89 50 08             	mov    %edx,0x8(%eax)
  802831:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802837:	89 50 0c             	mov    %edx,0xc(%eax)
  80283a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283d:	8b 40 08             	mov    0x8(%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	75 08                	jne    80284c <realloc_block_FF+0x2cb>
  802844:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802847:	a3 18 41 80 00       	mov    %eax,0x804118
  80284c:	a1 20 41 80 00       	mov    0x804120,%eax
  802851:	40                   	inc    %eax
  802852:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	eb 6f                	jmp    8028cb <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  80285c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285f:	83 e8 10             	sub    $0x10,%eax
  802862:	83 ec 0c             	sub    $0xc,%esp
  802865:	50                   	push   %eax
  802866:	e8 87 f6 ff ff       	call   801ef2 <alloc_block_FF>
  80286b:	83 c4 10             	add    $0x10,%esp
  80286e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  802871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802875:	75 29                	jne    8028a0 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  802877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	50                   	push   %eax
  80287e:	e8 98 ea ff ff       	call   80131b <sbrk>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  802889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288c:	83 f8 ff             	cmp    $0xffffffff,%eax
  80288f:	75 07                	jne    802898 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  802891:	b8 00 00 00 00       	mov    $0x0,%eax
  802896:	eb 33                	jmp    8028cb <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  802898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289b:	83 c0 10             	add    $0x10,%eax
  80289e:	eb 2b                	jmp    8028cb <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	50                   	push   %eax
  8028a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028af:	e8 2f e3 ff ff       	call   800be3 <memcpy>
  8028b4:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  8028b7:	83 ec 0c             	sub    $0xc,%esp
  8028ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8028bd:	e8 d7 fa ff ff       	call   802399 <free_block>
  8028c2:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  8028c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c8:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8028d3:	8d 45 10             	lea    0x10(%ebp),%eax
  8028d6:	83 c0 04             	add    $0x4,%eax
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8028dc:	a1 30 41 84 00       	mov    0x844130,%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 16                	je     8028fb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8028e5:	a1 30 41 84 00       	mov    0x844130,%eax
  8028ea:	83 ec 08             	sub    $0x8,%esp
  8028ed:	50                   	push   %eax
  8028ee:	68 1c 34 80 00       	push   $0x80341c
  8028f3:	e8 4b da ff ff       	call   800343 <cprintf>
  8028f8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8028fb:	a1 00 40 80 00       	mov    0x804000,%eax
  802900:	ff 75 0c             	pushl  0xc(%ebp)
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	50                   	push   %eax
  802907:	68 21 34 80 00       	push   $0x803421
  80290c:	e8 32 da ff ff       	call   800343 <cprintf>
  802911:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802914:	8b 45 10             	mov    0x10(%ebp),%eax
  802917:	83 ec 08             	sub    $0x8,%esp
  80291a:	ff 75 f4             	pushl  -0xc(%ebp)
  80291d:	50                   	push   %eax
  80291e:	e8 b5 d9 ff ff       	call   8002d8 <vcprintf>
  802923:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802926:	83 ec 08             	sub    $0x8,%esp
  802929:	6a 00                	push   $0x0
  80292b:	68 3d 34 80 00       	push   $0x80343d
  802930:	e8 a3 d9 ff ff       	call   8002d8 <vcprintf>
  802935:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802938:	e8 24 d9 ff ff       	call   800261 <exit>

	// should not return here
	while (1) ;
  80293d:	eb fe                	jmp    80293d <_panic+0x70>

0080293f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802945:	a1 20 40 80 00       	mov    0x804020,%eax
  80294a:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  802950:	8b 45 0c             	mov    0xc(%ebp),%eax
  802953:	39 c2                	cmp    %eax,%edx
  802955:	74 14                	je     80296b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 40 34 80 00       	push   $0x803440
  80295f:	6a 26                	push   $0x26
  802961:	68 8c 34 80 00       	push   $0x80348c
  802966:	e8 62 ff ff ff       	call   8028cd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80296b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802979:	e9 c5 00 00 00       	jmp    802a43 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	01 d0                	add    %edx,%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	75 08                	jne    80299b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  802993:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802996:	e9 a5 00 00 00       	jmp    802a40 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80299b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8029a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8029a9:	eb 69                	jmp    802a14 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8029ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8029b0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8029b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b9:	89 d0                	mov    %edx,%eax
  8029bb:	01 c0                	add    %eax,%eax
  8029bd:	01 d0                	add    %edx,%eax
  8029bf:	c1 e0 03             	shl    $0x3,%eax
  8029c2:	01 c8                	add    %ecx,%eax
  8029c4:	8a 40 04             	mov    0x4(%eax),%al
  8029c7:	84 c0                	test   %al,%al
  8029c9:	75 46                	jne    802a11 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8029cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8029d0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8029d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d9:	89 d0                	mov    %edx,%eax
  8029db:	01 c0                	add    %eax,%eax
  8029dd:	01 d0                	add    %edx,%eax
  8029df:	c1 e0 03             	shl    $0x3,%eax
  8029e2:	01 c8                	add    %ecx,%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8029e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	01 c8                	add    %ecx,%eax
  802a02:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802a04:	39 c2                	cmp    %eax,%edx
  802a06:	75 09                	jne    802a11 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  802a08:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802a0f:	eb 15                	jmp    802a26 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a11:	ff 45 e8             	incl   -0x18(%ebp)
  802a14:	a1 20 40 80 00       	mov    0x804020,%eax
  802a19:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	39 c2                	cmp    %eax,%edx
  802a24:	77 85                	ja     8029ab <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802a26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2a:	75 14                	jne    802a40 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 98 34 80 00       	push   $0x803498
  802a34:	6a 3a                	push   $0x3a
  802a36:	68 8c 34 80 00       	push   $0x80348c
  802a3b:	e8 8d fe ff ff       	call   8028cd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802a40:	ff 45 f0             	incl   -0x10(%ebp)
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a49:	0f 8c 2f ff ff ff    	jl     80297e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802a4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a5d:	eb 26                	jmp    802a85 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802a5f:	a1 20 40 80 00       	mov    0x804020,%eax
  802a64:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  802a6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a6d:	89 d0                	mov    %edx,%eax
  802a6f:	01 c0                	add    %eax,%eax
  802a71:	01 d0                	add    %edx,%eax
  802a73:	c1 e0 03             	shl    $0x3,%eax
  802a76:	01 c8                	add    %ecx,%eax
  802a78:	8a 40 04             	mov    0x4(%eax),%al
  802a7b:	3c 01                	cmp    $0x1,%al
  802a7d:	75 03                	jne    802a82 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  802a7f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802a82:	ff 45 e0             	incl   -0x20(%ebp)
  802a85:	a1 20 40 80 00       	mov    0x804020,%eax
  802a8a:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  802a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a93:	39 c2                	cmp    %eax,%edx
  802a95:	77 c8                	ja     802a5f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a9d:	74 14                	je     802ab3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	68 ec 34 80 00       	push   $0x8034ec
  802aa7:	6a 44                	push   $0x44
  802aa9:	68 8c 34 80 00       	push   $0x80348c
  802aae:	e8 1a fe ff ff       	call   8028cd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802ab3:	90                   	nop
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    
  802ab6:	66 90                	xchg   %ax,%ax

00802ab8 <__udivdi3>:
  802ab8:	55                   	push   %ebp
  802ab9:	57                   	push   %edi
  802aba:	56                   	push   %esi
  802abb:	53                   	push   %ebx
  802abc:	83 ec 1c             	sub    $0x1c,%esp
  802abf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802ac3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802ac7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802acb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802acf:	89 ca                	mov    %ecx,%edx
  802ad1:	89 f8                	mov    %edi,%eax
  802ad3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802ad7:	85 f6                	test   %esi,%esi
  802ad9:	75 2d                	jne    802b08 <__udivdi3+0x50>
  802adb:	39 cf                	cmp    %ecx,%edi
  802add:	77 65                	ja     802b44 <__udivdi3+0x8c>
  802adf:	89 fd                	mov    %edi,%ebp
  802ae1:	85 ff                	test   %edi,%edi
  802ae3:	75 0b                	jne    802af0 <__udivdi3+0x38>
  802ae5:	b8 01 00 00 00       	mov    $0x1,%eax
  802aea:	31 d2                	xor    %edx,%edx
  802aec:	f7 f7                	div    %edi
  802aee:	89 c5                	mov    %eax,%ebp
  802af0:	31 d2                	xor    %edx,%edx
  802af2:	89 c8                	mov    %ecx,%eax
  802af4:	f7 f5                	div    %ebp
  802af6:	89 c1                	mov    %eax,%ecx
  802af8:	89 d8                	mov    %ebx,%eax
  802afa:	f7 f5                	div    %ebp
  802afc:	89 cf                	mov    %ecx,%edi
  802afe:	89 fa                	mov    %edi,%edx
  802b00:	83 c4 1c             	add    $0x1c,%esp
  802b03:	5b                   	pop    %ebx
  802b04:	5e                   	pop    %esi
  802b05:	5f                   	pop    %edi
  802b06:	5d                   	pop    %ebp
  802b07:	c3                   	ret    
  802b08:	39 ce                	cmp    %ecx,%esi
  802b0a:	77 28                	ja     802b34 <__udivdi3+0x7c>
  802b0c:	0f bd fe             	bsr    %esi,%edi
  802b0f:	83 f7 1f             	xor    $0x1f,%edi
  802b12:	75 40                	jne    802b54 <__udivdi3+0x9c>
  802b14:	39 ce                	cmp    %ecx,%esi
  802b16:	72 0a                	jb     802b22 <__udivdi3+0x6a>
  802b18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802b1c:	0f 87 9e 00 00 00    	ja     802bc0 <__udivdi3+0x108>
  802b22:	b8 01 00 00 00       	mov    $0x1,%eax
  802b27:	89 fa                	mov    %edi,%edx
  802b29:	83 c4 1c             	add    $0x1c,%esp
  802b2c:	5b                   	pop    %ebx
  802b2d:	5e                   	pop    %esi
  802b2e:	5f                   	pop    %edi
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    
  802b31:	8d 76 00             	lea    0x0(%esi),%esi
  802b34:	31 ff                	xor    %edi,%edi
  802b36:	31 c0                	xor    %eax,%eax
  802b38:	89 fa                	mov    %edi,%edx
  802b3a:	83 c4 1c             	add    $0x1c,%esp
  802b3d:	5b                   	pop    %ebx
  802b3e:	5e                   	pop    %esi
  802b3f:	5f                   	pop    %edi
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    
  802b42:	66 90                	xchg   %ax,%ax
  802b44:	89 d8                	mov    %ebx,%eax
  802b46:	f7 f7                	div    %edi
  802b48:	31 ff                	xor    %edi,%edi
  802b4a:	89 fa                	mov    %edi,%edx
  802b4c:	83 c4 1c             	add    $0x1c,%esp
  802b4f:	5b                   	pop    %ebx
  802b50:	5e                   	pop    %esi
  802b51:	5f                   	pop    %edi
  802b52:	5d                   	pop    %ebp
  802b53:	c3                   	ret    
  802b54:	bd 20 00 00 00       	mov    $0x20,%ebp
  802b59:	89 eb                	mov    %ebp,%ebx
  802b5b:	29 fb                	sub    %edi,%ebx
  802b5d:	89 f9                	mov    %edi,%ecx
  802b5f:	d3 e6                	shl    %cl,%esi
  802b61:	89 c5                	mov    %eax,%ebp
  802b63:	88 d9                	mov    %bl,%cl
  802b65:	d3 ed                	shr    %cl,%ebp
  802b67:	89 e9                	mov    %ebp,%ecx
  802b69:	09 f1                	or     %esi,%ecx
  802b6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b6f:	89 f9                	mov    %edi,%ecx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 c5                	mov    %eax,%ebp
  802b75:	89 d6                	mov    %edx,%esi
  802b77:	88 d9                	mov    %bl,%cl
  802b79:	d3 ee                	shr    %cl,%esi
  802b7b:	89 f9                	mov    %edi,%ecx
  802b7d:	d3 e2                	shl    %cl,%edx
  802b7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b83:	88 d9                	mov    %bl,%cl
  802b85:	d3 e8                	shr    %cl,%eax
  802b87:	09 c2                	or     %eax,%edx
  802b89:	89 d0                	mov    %edx,%eax
  802b8b:	89 f2                	mov    %esi,%edx
  802b8d:	f7 74 24 0c          	divl   0xc(%esp)
  802b91:	89 d6                	mov    %edx,%esi
  802b93:	89 c3                	mov    %eax,%ebx
  802b95:	f7 e5                	mul    %ebp
  802b97:	39 d6                	cmp    %edx,%esi
  802b99:	72 19                	jb     802bb4 <__udivdi3+0xfc>
  802b9b:	74 0b                	je     802ba8 <__udivdi3+0xf0>
  802b9d:	89 d8                	mov    %ebx,%eax
  802b9f:	31 ff                	xor    %edi,%edi
  802ba1:	e9 58 ff ff ff       	jmp    802afe <__udivdi3+0x46>
  802ba6:	66 90                	xchg   %ax,%ax
  802ba8:	8b 54 24 08          	mov    0x8(%esp),%edx
  802bac:	89 f9                	mov    %edi,%ecx
  802bae:	d3 e2                	shl    %cl,%edx
  802bb0:	39 c2                	cmp    %eax,%edx
  802bb2:	73 e9                	jae    802b9d <__udivdi3+0xe5>
  802bb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802bb7:	31 ff                	xor    %edi,%edi
  802bb9:	e9 40 ff ff ff       	jmp    802afe <__udivdi3+0x46>
  802bbe:	66 90                	xchg   %ax,%ax
  802bc0:	31 c0                	xor    %eax,%eax
  802bc2:	e9 37 ff ff ff       	jmp    802afe <__udivdi3+0x46>
  802bc7:	90                   	nop

00802bc8 <__umoddi3>:
  802bc8:	55                   	push   %ebp
  802bc9:	57                   	push   %edi
  802bca:	56                   	push   %esi
  802bcb:	53                   	push   %ebx
  802bcc:	83 ec 1c             	sub    $0x1c,%esp
  802bcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802bd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802bd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802bdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802be3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be7:	89 f3                	mov    %esi,%ebx
  802be9:	89 fa                	mov    %edi,%edx
  802beb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802bef:	89 34 24             	mov    %esi,(%esp)
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	75 1a                	jne    802c10 <__umoddi3+0x48>
  802bf6:	39 f7                	cmp    %esi,%edi
  802bf8:	0f 86 a2 00 00 00    	jbe    802ca0 <__umoddi3+0xd8>
  802bfe:	89 c8                	mov    %ecx,%eax
  802c00:	89 f2                	mov    %esi,%edx
  802c02:	f7 f7                	div    %edi
  802c04:	89 d0                	mov    %edx,%eax
  802c06:	31 d2                	xor    %edx,%edx
  802c08:	83 c4 1c             	add    $0x1c,%esp
  802c0b:	5b                   	pop    %ebx
  802c0c:	5e                   	pop    %esi
  802c0d:	5f                   	pop    %edi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    
  802c10:	39 f0                	cmp    %esi,%eax
  802c12:	0f 87 ac 00 00 00    	ja     802cc4 <__umoddi3+0xfc>
  802c18:	0f bd e8             	bsr    %eax,%ebp
  802c1b:	83 f5 1f             	xor    $0x1f,%ebp
  802c1e:	0f 84 ac 00 00 00    	je     802cd0 <__umoddi3+0x108>
  802c24:	bf 20 00 00 00       	mov    $0x20,%edi
  802c29:	29 ef                	sub    %ebp,%edi
  802c2b:	89 fe                	mov    %edi,%esi
  802c2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c31:	89 e9                	mov    %ebp,%ecx
  802c33:	d3 e0                	shl    %cl,%eax
  802c35:	89 d7                	mov    %edx,%edi
  802c37:	89 f1                	mov    %esi,%ecx
  802c39:	d3 ef                	shr    %cl,%edi
  802c3b:	09 c7                	or     %eax,%edi
  802c3d:	89 e9                	mov    %ebp,%ecx
  802c3f:	d3 e2                	shl    %cl,%edx
  802c41:	89 14 24             	mov    %edx,(%esp)
  802c44:	89 d8                	mov    %ebx,%eax
  802c46:	d3 e0                	shl    %cl,%eax
  802c48:	89 c2                	mov    %eax,%edx
  802c4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c4e:	d3 e0                	shl    %cl,%eax
  802c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c54:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c58:	89 f1                	mov    %esi,%ecx
  802c5a:	d3 e8                	shr    %cl,%eax
  802c5c:	09 d0                	or     %edx,%eax
  802c5e:	d3 eb                	shr    %cl,%ebx
  802c60:	89 da                	mov    %ebx,%edx
  802c62:	f7 f7                	div    %edi
  802c64:	89 d3                	mov    %edx,%ebx
  802c66:	f7 24 24             	mull   (%esp)
  802c69:	89 c6                	mov    %eax,%esi
  802c6b:	89 d1                	mov    %edx,%ecx
  802c6d:	39 d3                	cmp    %edx,%ebx
  802c6f:	0f 82 87 00 00 00    	jb     802cfc <__umoddi3+0x134>
  802c75:	0f 84 91 00 00 00    	je     802d0c <__umoddi3+0x144>
  802c7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c7f:	29 f2                	sub    %esi,%edx
  802c81:	19 cb                	sbb    %ecx,%ebx
  802c83:	89 d8                	mov    %ebx,%eax
  802c85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c89:	d3 e0                	shl    %cl,%eax
  802c8b:	89 e9                	mov    %ebp,%ecx
  802c8d:	d3 ea                	shr    %cl,%edx
  802c8f:	09 d0                	or     %edx,%eax
  802c91:	89 e9                	mov    %ebp,%ecx
  802c93:	d3 eb                	shr    %cl,%ebx
  802c95:	89 da                	mov    %ebx,%edx
  802c97:	83 c4 1c             	add    $0x1c,%esp
  802c9a:	5b                   	pop    %ebx
  802c9b:	5e                   	pop    %esi
  802c9c:	5f                   	pop    %edi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    
  802c9f:	90                   	nop
  802ca0:	89 fd                	mov    %edi,%ebp
  802ca2:	85 ff                	test   %edi,%edi
  802ca4:	75 0b                	jne    802cb1 <__umoddi3+0xe9>
  802ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	f7 f7                	div    %edi
  802caf:	89 c5                	mov    %eax,%ebp
  802cb1:	89 f0                	mov    %esi,%eax
  802cb3:	31 d2                	xor    %edx,%edx
  802cb5:	f7 f5                	div    %ebp
  802cb7:	89 c8                	mov    %ecx,%eax
  802cb9:	f7 f5                	div    %ebp
  802cbb:	89 d0                	mov    %edx,%eax
  802cbd:	e9 44 ff ff ff       	jmp    802c06 <__umoddi3+0x3e>
  802cc2:	66 90                	xchg   %ax,%ax
  802cc4:	89 c8                	mov    %ecx,%eax
  802cc6:	89 f2                	mov    %esi,%edx
  802cc8:	83 c4 1c             	add    $0x1c,%esp
  802ccb:	5b                   	pop    %ebx
  802ccc:	5e                   	pop    %esi
  802ccd:	5f                   	pop    %edi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    
  802cd0:	3b 04 24             	cmp    (%esp),%eax
  802cd3:	72 06                	jb     802cdb <__umoddi3+0x113>
  802cd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802cd9:	77 0f                	ja     802cea <__umoddi3+0x122>
  802cdb:	89 f2                	mov    %esi,%edx
  802cdd:	29 f9                	sub    %edi,%ecx
  802cdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802ce3:	89 14 24             	mov    %edx,(%esp)
  802ce6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802cea:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cee:	8b 14 24             	mov    (%esp),%edx
  802cf1:	83 c4 1c             	add    $0x1c,%esp
  802cf4:	5b                   	pop    %ebx
  802cf5:	5e                   	pop    %esi
  802cf6:	5f                   	pop    %edi
  802cf7:	5d                   	pop    %ebp
  802cf8:	c3                   	ret    
  802cf9:	8d 76 00             	lea    0x0(%esi),%esi
  802cfc:	2b 04 24             	sub    (%esp),%eax
  802cff:	19 fa                	sbb    %edi,%edx
  802d01:	89 d1                	mov    %edx,%ecx
  802d03:	89 c6                	mov    %eax,%esi
  802d05:	e9 71 ff ff ff       	jmp    802c7b <__umoddi3+0xb3>
  802d0a:	66 90                	xchg   %ax,%ax
  802d0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802d10:	72 ea                	jb     802cfc <__umoddi3+0x134>
  802d12:	89 d9                	mov    %ebx,%ecx
  802d14:	e9 62 ff ff ff       	jmp    802c7b <__umoddi3+0xb3>
