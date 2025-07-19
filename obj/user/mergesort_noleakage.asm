
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 ef 21 00 00       	call   802235 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 35 80 00       	push   $0x8035c0
  80004e:	e8 66 0b 00 00       	call   800bb9 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 35 80 00       	push   $0x8035c2
  80005e:	e8 56 0b 00 00       	call   800bb9 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 35 80 00       	push   $0x8035d8
  80006e:	e8 46 0b 00 00       	call   800bb9 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 35 80 00       	push   $0x8035c2
  80007e:	e8 36 0b 00 00       	call   800bb9 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 35 80 00       	push   $0x8035c0
  80008e:	e8 26 0b 00 00       	call   800bb9 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 35 80 00       	push   $0x8035f0
  8000a5:	e8 91 11 00 00       	call   80123b <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 e1 16 00 00       	call   8017a1 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 d8 1c 00 00       	call   801dad <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 10 36 80 00       	push   $0x803610
  8000e3:	e8 d1 0a 00 00       	call   800bb9 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 32 36 80 00       	push   $0x803632
  8000f3:	e8 c1 0a 00 00       	call   800bb9 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 40 36 80 00       	push   $0x803640
  800103:	e8 b1 0a 00 00       	call   800bb9 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 4f 36 80 00       	push   $0x80364f
  800113:	e8 a1 0a 00 00       	call   800bb9 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 5f 36 80 00       	push   $0x80365f
  800123:	e8 91 0a 00 00       	call   800bb9 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 e8 20 00 00       	call   80224f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 59 20 00 00       	call   802235 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 68 36 80 00       	push   $0x803668
  8001e4:	e8 d0 09 00 00       	call   800bb9 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 5e 20 00 00       	call   80224f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 9c 36 80 00       	push   $0x80369c
  800213:	6a 4a                	push   $0x4a
  800215:	68 be 36 80 00       	push   $0x8036be
  80021a:	e8 dd 06 00 00       	call   8008fc <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 11 20 00 00       	call   802235 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 dc 36 80 00       	push   $0x8036dc
  80022c:	e8 88 09 00 00       	call   800bb9 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 10 37 80 00       	push   $0x803710
  80023c:	e8 78 09 00 00       	call   800bb9 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 44 37 80 00       	push   $0x803744
  80024c:	e8 68 09 00 00       	call   800bb9 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 f6 1f 00 00       	call   80224f <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 a9 1c 00 00       	call   801f0d <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 c9 1f 00 00       	call   802235 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 76 37 80 00       	push   $0x803776
  80027a:	e8 3a 09 00 00       	call   800bb9 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 8a 1f 00 00       	call   80224f <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 c0 35 80 00       	push   $0x8035c0
  800459:	e8 5b 07 00 00       	call   800bb9 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 94 37 80 00       	push   $0x803794
  80047b:	e8 39 07 00 00       	call   800bb9 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 99 37 80 00       	push   $0x803799
  8004a9:	e8 0b 07 00 00       	call   800bb9 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 5e 18 00 00       	call   801dad <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 49 18 00 00       	call   801dad <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 fc 17 00 00       	call   801f0d <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 ee 17 00 00       	call   801f0d <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 2b 1b 00 00       	call   802269 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 e6 1a 00 00       	call   802235 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 07 1b 00 00       	call   802269 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 e5 1a 00 00       	call   80224f <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 84 19 00 00       	call   802105 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 9b 1a 00 00       	call   802235 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 5d 19 00 00       	call   802105 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 99 1a 00 00       	call   80224f <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 58 1c 00 00       	call   802428 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 40 80 00       	mov    0x804024,%eax
  8007fc:	8a 40 5c             	mov    0x5c(%eax),%al
  8007ff:	84 c0                	test   %al,%al
  800801:	74 0d                	je     800810 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800803:	a1 24 40 80 00       	mov    0x804024,%eax
  800808:	83 c0 5c             	add    $0x5c,%eax
  80080b:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800810:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800814:	7e 0a                	jle    800820 <libmain+0x5b>
		binaryname = argv[0];
  800816:	8b 45 0c             	mov    0xc(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	ff 75 08             	pushl  0x8(%ebp)
  800829:	e8 0a f8 ff ff       	call   800038 <_main>
  80082e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800831:	e8 ff 19 00 00       	call   802235 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800836:	83 ec 0c             	sub    $0xc,%esp
  800839:	68 b8 37 80 00       	push   $0x8037b8
  80083e:	e8 76 03 00 00       	call   800bb9 <cprintf>
  800843:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800846:	a1 24 40 80 00       	mov    0x804024,%eax
  80084b:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800851:	a1 24 40 80 00       	mov    0x804024,%eax
  800856:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	68 e0 37 80 00       	push   $0x8037e0
  800866:	e8 4e 03 00 00       	call   800bb9 <cprintf>
  80086b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80086e:	a1 24 40 80 00       	mov    0x804024,%eax
  800873:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  800879:	a1 24 40 80 00       	mov    0x804024,%eax
  80087e:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800884:	a1 24 40 80 00       	mov    0x804024,%eax
  800889:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80088f:	51                   	push   %ecx
  800890:	52                   	push   %edx
  800891:	50                   	push   %eax
  800892:	68 08 38 80 00       	push   $0x803808
  800897:	e8 1d 03 00 00       	call   800bb9 <cprintf>
  80089c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80089f:	a1 24 40 80 00       	mov    0x804024,%eax
  8008a4:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	50                   	push   %eax
  8008ae:	68 60 38 80 00       	push   $0x803860
  8008b3:	e8 01 03 00 00       	call   800bb9 <cprintf>
  8008b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	68 b8 37 80 00       	push   $0x8037b8
  8008c3:	e8 f1 02 00 00       	call   800bb9 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008cb:	e8 7f 19 00 00       	call   80224f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d0:	e8 19 00 00 00       	call   8008ee <exit>
}
  8008d5:	90                   	nop
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008de:	83 ec 0c             	sub    $0xc,%esp
  8008e1:	6a 00                	push   $0x0
  8008e3:	e8 0c 1b 00 00       	call   8023f4 <sys_destroy_env>
  8008e8:	83 c4 10             	add    $0x10,%esp
}
  8008eb:	90                   	nop
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    

008008ee <exit>:

void
exit(void)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f4:	e8 61 1b 00 00       	call   80245a <sys_exit_env>
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800902:	8d 45 10             	lea    0x10(%ebp),%eax
  800905:	83 c0 04             	add    $0x4,%eax
  800908:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80090b:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800910:	85 c0                	test   %eax,%eax
  800912:	74 16                	je     80092a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800914:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	50                   	push   %eax
  80091d:	68 74 38 80 00       	push   $0x803874
  800922:	e8 92 02 00 00       	call   800bb9 <cprintf>
  800927:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092a:	a1 00 40 80 00       	mov    0x804000,%eax
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	ff 75 08             	pushl  0x8(%ebp)
  800935:	50                   	push   %eax
  800936:	68 79 38 80 00       	push   $0x803879
  80093b:	e8 79 02 00 00       	call   800bb9 <cprintf>
  800940:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800943:	8b 45 10             	mov    0x10(%ebp),%eax
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 f4             	pushl  -0xc(%ebp)
  80094c:	50                   	push   %eax
  80094d:	e8 fc 01 00 00       	call   800b4e <vcprintf>
  800952:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	6a 00                	push   $0x0
  80095a:	68 95 38 80 00       	push   $0x803895
  80095f:	e8 ea 01 00 00       	call   800b4e <vcprintf>
  800964:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800967:	e8 82 ff ff ff       	call   8008ee <exit>

	// should not return here
	while (1) ;
  80096c:	eb fe                	jmp    80096c <_panic+0x70>

0080096e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800974:	a1 24 40 80 00       	mov    0x804024,%eax
  800979:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	39 c2                	cmp    %eax,%edx
  800984:	74 14                	je     80099a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 98 38 80 00       	push   $0x803898
  80098e:	6a 26                	push   $0x26
  800990:	68 e4 38 80 00       	push   $0x8038e4
  800995:	e8 62 ff ff ff       	call   8008fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009a8:	e9 c5 00 00 00       	jmp    800a72 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	01 d0                	add    %edx,%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	85 c0                	test   %eax,%eax
  8009c0:	75 08                	jne    8009ca <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8009c2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c5:	e9 a5 00 00 00       	jmp    800a6f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009d8:	eb 69                	jmp    800a43 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009da:	a1 24 40 80 00       	mov    0x804024,%eax
  8009df:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8009e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e8:	89 d0                	mov    %edx,%eax
  8009ea:	01 c0                	add    %eax,%eax
  8009ec:	01 d0                	add    %edx,%eax
  8009ee:	c1 e0 03             	shl    $0x3,%eax
  8009f1:	01 c8                	add    %ecx,%eax
  8009f3:	8a 40 04             	mov    0x4(%eax),%al
  8009f6:	84 c0                	test   %al,%al
  8009f8:	75 46                	jne    800a40 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fa:	a1 24 40 80 00       	mov    0x804024,%eax
  8009ff:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800a05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a08:	89 d0                	mov    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d0                	add    %edx,%eax
  800a0e:	c1 e0 03             	shl    $0x3,%eax
  800a11:	01 c8                	add    %ecx,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a20:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	01 c8                	add    %ecx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a33:	39 c2                	cmp    %eax,%edx
  800a35:	75 09                	jne    800a40 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a37:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a3e:	eb 15                	jmp    800a55 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a40:	ff 45 e8             	incl   -0x18(%ebp)
  800a43:	a1 24 40 80 00       	mov    0x804024,%eax
  800a48:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a51:	39 c2                	cmp    %eax,%edx
  800a53:	77 85                	ja     8009da <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a59:	75 14                	jne    800a6f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a5b:	83 ec 04             	sub    $0x4,%esp
  800a5e:	68 f0 38 80 00       	push   $0x8038f0
  800a63:	6a 3a                	push   $0x3a
  800a65:	68 e4 38 80 00       	push   $0x8038e4
  800a6a:	e8 8d fe ff ff       	call   8008fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6f:	ff 45 f0             	incl   -0x10(%ebp)
  800a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a75:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a78:	0f 8c 2f ff ff ff    	jl     8009ad <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8c:	eb 26                	jmp    800ab4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8e:	a1 24 40 80 00       	mov    0x804024,%eax
  800a93:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800a99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9c:	89 d0                	mov    %edx,%eax
  800a9e:	01 c0                	add    %eax,%eax
  800aa0:	01 d0                	add    %edx,%eax
  800aa2:	c1 e0 03             	shl    $0x3,%eax
  800aa5:	01 c8                	add    %ecx,%eax
  800aa7:	8a 40 04             	mov    0x4(%eax),%al
  800aaa:	3c 01                	cmp    $0x1,%al
  800aac:	75 03                	jne    800ab1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800aae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab1:	ff 45 e0             	incl   -0x20(%ebp)
  800ab4:	a1 24 40 80 00       	mov    0x804024,%eax
  800ab9:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800abf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac2:	39 c2                	cmp    %eax,%edx
  800ac4:	77 c8                	ja     800a8e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800acc:	74 14                	je     800ae2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800ace:	83 ec 04             	sub    $0x4,%esp
  800ad1:	68 44 39 80 00       	push   $0x803944
  800ad6:	6a 44                	push   $0x44
  800ad8:	68 e4 38 80 00       	push   $0x8038e4
  800add:	e8 1a fe ff ff       	call   8008fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae2:	90                   	nop
  800ae3:	c9                   	leave  
  800ae4:	c3                   	ret    

00800ae5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 48 01             	lea    0x1(%eax),%ecx
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	89 0a                	mov    %ecx,(%edx)
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
  800afb:	88 d1                	mov    %dl,%cl
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b00:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0e:	75 2c                	jne    800b3c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b10:	a0 28 40 80 00       	mov    0x804028,%al
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	8b 12                	mov    (%edx),%edx
  800b1d:	89 d1                	mov    %edx,%ecx
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	83 ec 04             	sub    $0x4,%esp
  800b28:	50                   	push   %eax
  800b29:	51                   	push   %ecx
  800b2a:	52                   	push   %edx
  800b2b:	e8 ac 15 00 00       	call   8020dc <sys_cputs>
  800b30:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 40 04             	mov    0x4(%eax),%eax
  800b42:	8d 50 01             	lea    0x1(%eax),%edx
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b4b:	90                   	nop
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5e:	00 00 00 
	b.cnt = 0;
  800b61:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b68:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b77:	50                   	push   %eax
  800b78:	68 e5 0a 80 00       	push   $0x800ae5
  800b7d:	e8 11 02 00 00       	call   800d93 <vprintfmt>
  800b82:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b85:	a0 28 40 80 00       	mov    0x804028,%al
  800b8a:	0f b6 c0             	movzbl %al,%eax
  800b8d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	50                   	push   %eax
  800b97:	52                   	push   %edx
  800b98:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9e:	83 c0 08             	add    $0x8,%eax
  800ba1:	50                   	push   %eax
  800ba2:	e8 35 15 00 00       	call   8020dc <sys_cputs>
  800ba7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800baa:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800bb1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    

00800bb9 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbf:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800bc6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	e8 73 ff ff ff       	call   800b4e <vcprintf>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bec:	e8 44 16 00 00       	call   802235 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800c00:	50                   	push   %eax
  800c01:	e8 48 ff ff ff       	call   800b4e <vcprintf>
  800c06:	83 c4 10             	add    $0x10,%esp
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c0c:	e8 3e 16 00 00       	call   80224f <sys_enable_interrupt>
	return cnt;
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	53                   	push   %ebx
  800c1a:	83 ec 14             	sub    $0x14,%esp
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c29:	8b 45 18             	mov    0x18(%ebp),%eax
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c34:	77 55                	ja     800c8b <printnum+0x75>
  800c36:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c39:	72 05                	jb     800c40 <printnum+0x2a>
  800c3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3e:	77 4b                	ja     800c8b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c40:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c43:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c46:	8b 45 18             	mov    0x18(%ebp),%eax
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	52                   	push   %edx
  800c4f:	50                   	push   %eax
  800c50:	ff 75 f4             	pushl  -0xc(%ebp)
  800c53:	ff 75 f0             	pushl  -0x10(%ebp)
  800c56:	e8 f1 26 00 00       	call   80334c <__udivdi3>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	ff 75 20             	pushl  0x20(%ebp)
  800c64:	53                   	push   %ebx
  800c65:	ff 75 18             	pushl  0x18(%ebp)
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	ff 75 08             	pushl  0x8(%ebp)
  800c70:	e8 a1 ff ff ff       	call   800c16 <printnum>
  800c75:	83 c4 20             	add    $0x20,%esp
  800c78:	eb 1a                	jmp    800c94 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	ff 75 20             	pushl  0x20(%ebp)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c8b:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c92:	7f e6                	jg     800c7a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c94:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca2:	53                   	push   %ebx
  800ca3:	51                   	push   %ecx
  800ca4:	52                   	push   %edx
  800ca5:	50                   	push   %eax
  800ca6:	e8 b1 27 00 00       	call   80345c <__umoddi3>
  800cab:	83 c4 10             	add    $0x10,%esp
  800cae:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f be c0             	movsbl %al,%eax
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 0c             	pushl  0xc(%ebp)
  800cbe:	50                   	push   %eax
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	ff d0                	call   *%eax
  800cc4:	83 c4 10             	add    $0x10,%esp
}
  800cc7:	90                   	nop
  800cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd4:	7e 1c                	jle    800cf2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	8d 50 08             	lea    0x8(%eax),%edx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 10                	mov    %edx,(%eax)
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8b 00                	mov    (%eax),%eax
  800ce8:	83 e8 08             	sub    $0x8,%eax
  800ceb:	8b 50 04             	mov    0x4(%eax),%edx
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	eb 40                	jmp    800d32 <getuint+0x65>
	else if (lflag)
  800cf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf6:	74 1e                	je     800d16 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	8d 50 04             	lea    0x4(%eax),%edx
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	89 10                	mov    %edx,(%eax)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	83 e8 04             	sub    $0x4,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	eb 1c                	jmp    800d32 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	8d 50 04             	lea    0x4(%eax),%edx
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	89 10                	mov    %edx,(%eax)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d37:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d3b:	7e 1c                	jle    800d59 <getint+0x25>
		return va_arg(*ap, long long);
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	8d 50 08             	lea    0x8(%eax),%edx
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	89 10                	mov    %edx,(%eax)
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	83 e8 08             	sub    $0x8,%eax
  800d52:	8b 50 04             	mov    0x4(%eax),%edx
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	eb 38                	jmp    800d91 <getint+0x5d>
	else if (lflag)
  800d59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5d:	74 1a                	je     800d79 <getint+0x45>
		return va_arg(*ap, long);
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	8d 50 04             	lea    0x4(%eax),%edx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	89 10                	mov    %edx,(%eax)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	83 e8 04             	sub    $0x4,%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	99                   	cltd   
  800d77:	eb 18                	jmp    800d91 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	8d 50 04             	lea    0x4(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 10                	mov    %edx,(%eax)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	83 e8 04             	sub    $0x4,%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	99                   	cltd   
}
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
  800d98:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9b:	eb 17                	jmp    800db4 <vprintfmt+0x21>
			if (ch == '\0')
  800d9d:	85 db                	test   %ebx,%ebx
  800d9f:	0f 84 af 03 00 00    	je     801154 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	53                   	push   %ebx
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	ff d0                	call   *%eax
  800db1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 d8             	movzbl %al,%ebx
  800dc2:	83 fb 25             	cmp    $0x25,%ebx
  800dc5:	75 d6                	jne    800d9d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dcb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 10             	mov    %edx,0x10(%ebp)
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 d8             	movzbl %al,%ebx
  800df5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df8:	83 f8 55             	cmp    $0x55,%eax
  800dfb:	0f 87 2b 03 00 00    	ja     80112c <vprintfmt+0x399>
  800e01:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  800e08:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e0a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0e:	eb d7                	jmp    800de7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e10:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e14:	eb d1                	jmp    800de7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e20:	89 d0                	mov    %edx,%eax
  800e22:	c1 e0 02             	shl    $0x2,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	01 c0                	add    %eax,%eax
  800e29:	01 d8                	add    %ebx,%eax
  800e2b:	83 e8 30             	sub    $0x30,%eax
  800e2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e39:	83 fb 2f             	cmp    $0x2f,%ebx
  800e3c:	7e 3e                	jle    800e7c <vprintfmt+0xe9>
  800e3e:	83 fb 39             	cmp    $0x39,%ebx
  800e41:	7f 39                	jg     800e7c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e43:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e46:	eb d5                	jmp    800e1d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 c0 04             	add    $0x4,%eax
  800e4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e51:	8b 45 14             	mov    0x14(%ebp),%eax
  800e54:	83 e8 04             	sub    $0x4,%eax
  800e57:	8b 00                	mov    (%eax),%eax
  800e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e5c:	eb 1f                	jmp    800e7d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e62:	79 83                	jns    800de7 <vprintfmt+0x54>
				width = 0;
  800e64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e6b:	e9 77 ff ff ff       	jmp    800de7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e70:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e77:	e9 6b ff ff ff       	jmp    800de7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e7c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e81:	0f 89 60 ff ff ff    	jns    800de7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e94:	e9 4e ff ff ff       	jmp    800de7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e99:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e9c:	e9 46 ff ff ff       	jmp    800de7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 c0 04             	add    $0x4,%eax
  800ea7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	50                   	push   %eax
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	ff d0                	call   *%eax
  800ebe:	83 c4 10             	add    $0x10,%esp
			break;
  800ec1:	e9 89 02 00 00       	jmp    80114f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec9:	83 c0 04             	add    $0x4,%eax
  800ecc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed2:	83 e8 04             	sub    $0x4,%eax
  800ed5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed7:	85 db                	test   %ebx,%ebx
  800ed9:	79 02                	jns    800edd <vprintfmt+0x14a>
				err = -err;
  800edb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800edd:	83 fb 64             	cmp    $0x64,%ebx
  800ee0:	7f 0b                	jg     800eed <vprintfmt+0x15a>
  800ee2:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800ee9:	85 f6                	test   %esi,%esi
  800eeb:	75 19                	jne    800f06 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800eed:	53                   	push   %ebx
  800eee:	68 c5 3b 80 00       	push   $0x803bc5
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	ff 75 08             	pushl  0x8(%ebp)
  800ef9:	e8 5e 02 00 00       	call   80115c <printfmt>
  800efe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f01:	e9 49 02 00 00       	jmp    80114f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f06:	56                   	push   %esi
  800f07:	68 ce 3b 80 00       	push   $0x803bce
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	ff 75 08             	pushl  0x8(%ebp)
  800f12:	e8 45 02 00 00       	call   80115c <printfmt>
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 30 02 00 00       	jmp    80114f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f22:	83 c0 04             	add    $0x4,%eax
  800f25:	89 45 14             	mov    %eax,0x14(%ebp)
  800f28:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2b:	83 e8 04             	sub    $0x4,%eax
  800f2e:	8b 30                	mov    (%eax),%esi
  800f30:	85 f6                	test   %esi,%esi
  800f32:	75 05                	jne    800f39 <vprintfmt+0x1a6>
				p = "(null)";
  800f34:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  800f39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f3d:	7e 6d                	jle    800fac <vprintfmt+0x219>
  800f3f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f43:	74 67                	je     800fac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	50                   	push   %eax
  800f4c:	56                   	push   %esi
  800f4d:	e8 12 05 00 00       	call   801464 <strnlen>
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f58:	eb 16                	jmp    800f70 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f5a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	50                   	push   %eax
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	ff d0                	call   *%eax
  800f6a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f74:	7f e4                	jg     800f5a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f76:	eb 34                	jmp    800fac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f7c:	74 1c                	je     800f9a <vprintfmt+0x207>
  800f7e:	83 fb 1f             	cmp    $0x1f,%ebx
  800f81:	7e 05                	jle    800f88 <vprintfmt+0x1f5>
  800f83:	83 fb 7e             	cmp    $0x7e,%ebx
  800f86:	7e 12                	jle    800f9a <vprintfmt+0x207>
					putch('?', putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	6a 3f                	push   $0x3f
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	ff d0                	call   *%eax
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	eb 0f                	jmp    800fa9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	53                   	push   %ebx
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	ff d0                	call   *%eax
  800fa6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fac:	89 f0                	mov    %esi,%eax
  800fae:	8d 70 01             	lea    0x1(%eax),%esi
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f be d8             	movsbl %al,%ebx
  800fb6:	85 db                	test   %ebx,%ebx
  800fb8:	74 24                	je     800fde <vprintfmt+0x24b>
  800fba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fbe:	78 b8                	js     800f78 <vprintfmt+0x1e5>
  800fc0:	ff 4d e0             	decl   -0x20(%ebp)
  800fc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc7:	79 af                	jns    800f78 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	eb 13                	jmp    800fde <vprintfmt+0x24b>
				putch(' ', putdat);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	ff 75 0c             	pushl  0xc(%ebp)
  800fd1:	6a 20                	push   $0x20
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	ff d0                	call   *%eax
  800fd8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800fde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe2:	7f e7                	jg     800fcb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe4:	e9 66 01 00 00       	jmp    80114f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe9:	83 ec 08             	sub    $0x8,%esp
  800fec:	ff 75 e8             	pushl  -0x18(%ebp)
  800fef:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff2:	50                   	push   %eax
  800ff3:	e8 3c fd ff ff       	call   800d34 <getint>
  800ff8:	83 c4 10             	add    $0x10,%esp
  800ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801007:	85 d2                	test   %edx,%edx
  801009:	79 23                	jns    80102e <vprintfmt+0x29b>
				putch('-', putdat);
  80100b:	83 ec 08             	sub    $0x8,%esp
  80100e:	ff 75 0c             	pushl  0xc(%ebp)
  801011:	6a 2d                	push   $0x2d
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	ff d0                	call   *%eax
  801018:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80101b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801021:	f7 d8                	neg    %eax
  801023:	83 d2 00             	adc    $0x0,%edx
  801026:	f7 da                	neg    %edx
  801028:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801035:	e9 bc 00 00 00       	jmp    8010f6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 e8             	pushl  -0x18(%ebp)
  801040:	8d 45 14             	lea    0x14(%ebp),%eax
  801043:	50                   	push   %eax
  801044:	e8 84 fc ff ff       	call   800ccd <getuint>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801052:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801059:	e9 98 00 00 00       	jmp    8010f6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105e:	83 ec 08             	sub    $0x8,%esp
  801061:	ff 75 0c             	pushl  0xc(%ebp)
  801064:	6a 58                	push   $0x58
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	ff d0                	call   *%eax
  80106b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106e:	83 ec 08             	sub    $0x8,%esp
  801071:	ff 75 0c             	pushl  0xc(%ebp)
  801074:	6a 58                	push   $0x58
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	ff d0                	call   *%eax
  80107b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	ff 75 0c             	pushl  0xc(%ebp)
  801084:	6a 58                	push   $0x58
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	ff d0                	call   *%eax
  80108b:	83 c4 10             	add    $0x10,%esp
			break;
  80108e:	e9 bc 00 00 00       	jmp    80114f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	6a 30                	push   $0x30
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	ff d0                	call   *%eax
  8010a0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	6a 78                	push   $0x78
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	ff d0                	call   *%eax
  8010b0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b6:	83 c0 04             	add    $0x4,%eax
  8010b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8010bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bf:	83 e8 04             	sub    $0x4,%eax
  8010c2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d5:	eb 1f                	jmp    8010f6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 e7 fb ff ff       	call   800ccd <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010ef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	52                   	push   %edx
  801101:	ff 75 e4             	pushl  -0x1c(%ebp)
  801104:	50                   	push   %eax
  801105:	ff 75 f4             	pushl  -0xc(%ebp)
  801108:	ff 75 f0             	pushl  -0x10(%ebp)
  80110b:	ff 75 0c             	pushl  0xc(%ebp)
  80110e:	ff 75 08             	pushl  0x8(%ebp)
  801111:	e8 00 fb ff ff       	call   800c16 <printnum>
  801116:	83 c4 20             	add    $0x20,%esp
			break;
  801119:	eb 34                	jmp    80114f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	53                   	push   %ebx
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			break;
  80112a:	eb 23                	jmp    80114f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80112c:	83 ec 08             	sub    $0x8,%esp
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	6a 25                	push   $0x25
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	ff d0                	call   *%eax
  801139:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	eb 03                	jmp    801144 <vprintfmt+0x3b1>
  801141:	ff 4d 10             	decl   0x10(%ebp)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	48                   	dec    %eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 25                	cmp    $0x25,%al
  80114c:	75 f3                	jne    801141 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114e:	90                   	nop
		}
	}
  80114f:	e9 47 fc ff ff       	jmp    800d9b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801154:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801155:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801162:	8d 45 10             	lea    0x10(%ebp),%eax
  801165:	83 c0 04             	add    $0x4,%eax
  801168:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	ff 75 f4             	pushl  -0xc(%ebp)
  801171:	50                   	push   %eax
  801172:	ff 75 0c             	pushl  0xc(%ebp)
  801175:	ff 75 08             	pushl  0x8(%ebp)
  801178:	e8 16 fc ff ff       	call   800d93 <vprintfmt>
  80117d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801180:	90                   	nop
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	8b 40 08             	mov    0x8(%eax),%eax
  80118c:	8d 50 01             	lea    0x1(%eax),%edx
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	8b 10                	mov    (%eax),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	8b 40 04             	mov    0x4(%eax),%eax
  8011a0:	39 c2                	cmp    %eax,%edx
  8011a2:	73 12                	jae    8011b6 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	8b 00                	mov    (%eax),%eax
  8011a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	89 0a                	mov    %ecx,(%edx)
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	88 10                	mov    %dl,(%eax)
}
  8011b6:	90                   	nop
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011de:	74 06                	je     8011e6 <vsnprintf+0x2d>
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	7f 07                	jg     8011ed <vsnprintf+0x34>
		return -E_INVAL;
  8011e6:	b8 03 00 00 00       	mov    $0x3,%eax
  8011eb:	eb 20                	jmp    80120d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011ed:	ff 75 14             	pushl  0x14(%ebp)
  8011f0:	ff 75 10             	pushl  0x10(%ebp)
  8011f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f6:	50                   	push   %eax
  8011f7:	68 83 11 80 00       	push   $0x801183
  8011fc:	e8 92 fb ff ff       	call   800d93 <vprintfmt>
  801201:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801207:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801215:	8d 45 10             	lea    0x10(%ebp),%eax
  801218:	83 c0 04             	add    $0x4,%eax
  80121b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	ff 75 f4             	pushl  -0xc(%ebp)
  801224:	50                   	push   %eax
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	ff 75 08             	pushl  0x8(%ebp)
  80122b:	e8 89 ff ff ff       	call   8011b9 <vsnprintf>
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801236:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801245:	74 13                	je     80125a <readline+0x1f>
		cprintf("%s", prompt);
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	ff 75 08             	pushl  0x8(%ebp)
  80124d:	68 30 3d 80 00       	push   $0x803d30
  801252:	e8 62 f9 ff ff       	call   800bb9 <cprintf>
  801257:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80125a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	6a 00                	push   $0x0
  801266:	e8 50 f5 ff ff       	call   8007bb <iscons>
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801271:	e8 f7 f4 ff ff       	call   80076d <getchar>
  801276:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801279:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80127d:	79 22                	jns    8012a1 <readline+0x66>
			if (c != -E_EOF)
  80127f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801283:	0f 84 ad 00 00 00    	je     801336 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	ff 75 ec             	pushl  -0x14(%ebp)
  80128f:	68 33 3d 80 00       	push   $0x803d33
  801294:	e8 20 f9 ff ff       	call   800bb9 <cprintf>
  801299:	83 c4 10             	add    $0x10,%esp
			return;
  80129c:	e9 95 00 00 00       	jmp    801336 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a5:	7e 34                	jle    8012db <readline+0xa0>
  8012a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012ae:	7f 2b                	jg     8012db <readline+0xa0>
			if (echoing)
  8012b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b4:	74 0e                	je     8012c4 <readline+0x89>
				cputchar(c);
  8012b6:	83 ec 0c             	sub    $0xc,%esp
  8012b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bc:	e8 64 f4 ff ff       	call   800725 <cputchar>
  8012c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d7:	88 10                	mov    %dl,(%eax)
  8012d9:	eb 56                	jmp    801331 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012df:	75 1f                	jne    801300 <readline+0xc5>
  8012e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e5:	7e 19                	jle    801300 <readline+0xc5>
			if (echoing)
  8012e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012eb:	74 0e                	je     8012fb <readline+0xc0>
				cputchar(c);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f3:	e8 2d f4 ff ff       	call   800725 <cputchar>
  8012f8:	83 c4 10             	add    $0x10,%esp

			i--;
  8012fb:	ff 4d f4             	decl   -0xc(%ebp)
  8012fe:	eb 31                	jmp    801331 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801300:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801304:	74 0a                	je     801310 <readline+0xd5>
  801306:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80130a:	0f 85 61 ff ff ff    	jne    801271 <readline+0x36>
			if (echoing)
  801310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801314:	74 0e                	je     801324 <readline+0xe9>
				cputchar(c);
  801316:	83 ec 0c             	sub    $0xc,%esp
  801319:	ff 75 ec             	pushl  -0x14(%ebp)
  80131c:	e8 04 f4 ff ff       	call   800725 <cputchar>
  801321:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132f:	eb 06                	jmp    801337 <readline+0xfc>
		}
	}
  801331:	e9 3b ff ff ff       	jmp    801271 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801336:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133f:	e8 f1 0e 00 00       	call   802235 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801348:	74 13                	je     80135d <atomic_readline+0x24>
		cprintf("%s", prompt);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 08             	pushl  0x8(%ebp)
  801350:	68 30 3d 80 00       	push   $0x803d30
  801355:	e8 5f f8 ff ff       	call   800bb9 <cprintf>
  80135a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80135d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801364:	83 ec 0c             	sub    $0xc,%esp
  801367:	6a 00                	push   $0x0
  801369:	e8 4d f4 ff ff       	call   8007bb <iscons>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801374:	e8 f4 f3 ff ff       	call   80076d <getchar>
  801379:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80137c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801380:	79 23                	jns    8013a5 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801382:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801386:	74 13                	je     80139b <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	ff 75 ec             	pushl  -0x14(%ebp)
  80138e:	68 33 3d 80 00       	push   $0x803d33
  801393:	e8 21 f8 ff ff       	call   800bb9 <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80139b:	e8 af 0e 00 00       	call   80224f <sys_enable_interrupt>
			return;
  8013a0:	e9 9a 00 00 00       	jmp    80143f <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a9:	7e 34                	jle    8013df <atomic_readline+0xa6>
  8013ab:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013b2:	7f 2b                	jg     8013df <atomic_readline+0xa6>
			if (echoing)
  8013b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b8:	74 0e                	je     8013c8 <atomic_readline+0x8f>
				cputchar(c);
  8013ba:	83 ec 0c             	sub    $0xc,%esp
  8013bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c0:	e8 60 f3 ff ff       	call   800725 <cputchar>
  8013c5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cb:	8d 50 01             	lea    0x1(%eax),%edx
  8013ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013d1:	89 c2                	mov    %eax,%edx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013db:	88 10                	mov    %dl,(%eax)
  8013dd:	eb 5b                	jmp    80143a <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013df:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013e3:	75 1f                	jne    801404 <atomic_readline+0xcb>
  8013e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e9:	7e 19                	jle    801404 <atomic_readline+0xcb>
			if (echoing)
  8013eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ef:	74 0e                	je     8013ff <atomic_readline+0xc6>
				cputchar(c);
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f7:	e8 29 f3 ff ff       	call   800725 <cputchar>
  8013fc:	83 c4 10             	add    $0x10,%esp
			i--;
  8013ff:	ff 4d f4             	decl   -0xc(%ebp)
  801402:	eb 36                	jmp    80143a <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801404:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801408:	74 0a                	je     801414 <atomic_readline+0xdb>
  80140a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140e:	0f 85 60 ff ff ff    	jne    801374 <atomic_readline+0x3b>
			if (echoing)
  801414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801418:	74 0e                	je     801428 <atomic_readline+0xef>
				cputchar(c);
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	ff 75 ec             	pushl  -0x14(%ebp)
  801420:	e8 00 f3 ff ff       	call   800725 <cputchar>
  801425:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 d0                	add    %edx,%eax
  801430:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801433:	e8 17 0e 00 00       	call   80224f <sys_enable_interrupt>
			return;
  801438:	eb 05                	jmp    80143f <atomic_readline+0x106>
		}
	}
  80143a:	e9 35 ff ff ff       	jmp    801374 <atomic_readline+0x3b>
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 06                	jmp    801456 <strlen+0x15>
		n++;
  801450:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801453:	ff 45 08             	incl   0x8(%ebp)
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	75 f1                	jne    801450 <strlen+0xf>
		n++;
	return n;
  80145f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80146a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801471:	eb 09                	jmp    80147c <strnlen+0x18>
		n++;
  801473:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	ff 4d 0c             	decl   0xc(%ebp)
  80147c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801480:	74 09                	je     80148b <strnlen+0x27>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e8                	jne    801473 <strnlen+0xf>
		n++;
	return n;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80149c:	90                   	nop
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8d 50 01             	lea    0x1(%eax),%edx
  8014a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014af:	8a 12                	mov    (%edx),%dl
  8014b1:	88 10                	mov    %dl,(%eax)
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	84 c0                	test   %al,%al
  8014b7:	75 e4                	jne    80149d <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d1:	eb 1f                	jmp    8014f2 <strncpy+0x34>
		*dst++ = *src;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8d 50 01             	lea    0x1(%eax),%edx
  8014d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8014dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014df:	8a 12                	mov    (%edx),%dl
  8014e1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	84 c0                	test   %al,%al
  8014ea:	74 03                	je     8014ef <strncpy+0x31>
			src++;
  8014ec:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ef:	ff 45 fc             	incl   -0x4(%ebp)
  8014f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f8:	72 d9                	jb     8014d3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80150b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150f:	74 30                	je     801541 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801511:	eb 16                	jmp    801529 <strlcpy+0x2a>
			*dst++ = *src++;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8d 50 01             	lea    0x1(%eax),%edx
  801519:	89 55 08             	mov    %edx,0x8(%ebp)
  80151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801522:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801525:	8a 12                	mov    (%edx),%dl
  801527:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801529:	ff 4d 10             	decl   0x10(%ebp)
  80152c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801530:	74 09                	je     80153b <strlcpy+0x3c>
  801532:	8b 45 0c             	mov    0xc(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	84 c0                	test   %al,%al
  801539:	75 d8                	jne    801513 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801541:	8b 55 08             	mov    0x8(%ebp),%edx
  801544:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801547:	29 c2                	sub    %eax,%edx
  801549:	89 d0                	mov    %edx,%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801550:	eb 06                	jmp    801558 <strcmp+0xb>
		p++, q++;
  801552:	ff 45 08             	incl   0x8(%ebp)
  801555:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 0e                	je     80156f <strcmp+0x22>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 10                	mov    (%eax),%dl
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	38 c2                	cmp    %al,%dl
  80156d:	74 e3                	je     801552 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 d0             	movzbl %al,%edx
  801577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	0f b6 c0             	movzbl %al,%eax
  80157f:	29 c2                	sub    %eax,%edx
  801581:	89 d0                	mov    %edx,%eax
}
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801588:	eb 09                	jmp    801593 <strncmp+0xe>
		n--, p++, q++;
  80158a:	ff 4d 10             	decl   0x10(%ebp)
  80158d:	ff 45 08             	incl   0x8(%ebp)
  801590:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801593:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801597:	74 17                	je     8015b0 <strncmp+0x2b>
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	74 0e                	je     8015b0 <strncmp+0x2b>
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 10                	mov    (%eax),%dl
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	38 c2                	cmp    %al,%dl
  8015ae:	74 da                	je     80158a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b4:	75 07                	jne    8015bd <strncmp+0x38>
		return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	eb 14                	jmp    8015d1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8a 00                	mov    (%eax),%al
  8015c2:	0f b6 d0             	movzbl %al,%edx
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 c0             	movzbl %al,%eax
  8015cd:	29 c2                	sub    %eax,%edx
  8015cf:	89 d0                	mov    %edx,%eax
}
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015df:	eb 12                	jmp    8015f3 <strchr+0x20>
		if (*s == c)
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e9:	75 05                	jne    8015f0 <strchr+0x1d>
			return (char *) s;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	eb 11                	jmp    801601 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015f0:	ff 45 08             	incl   0x8(%ebp)
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	8a 00                	mov    (%eax),%al
  8015f8:	84 c0                	test   %al,%al
  8015fa:	75 e5                	jne    8015e1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160f:	eb 0d                	jmp    80161e <strfind+0x1b>
		if (*s == c)
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801619:	74 0e                	je     801629 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80161b:	ff 45 08             	incl   0x8(%ebp)
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	84 c0                	test   %al,%al
  801625:	75 ea                	jne    801611 <strfind+0xe>
  801627:	eb 01                	jmp    80162a <strfind+0x27>
		if (*s == c)
			break;
  801629:	90                   	nop
	return (char *) s;
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801641:	eb 0e                	jmp    801651 <memset+0x22>
		*p++ = c;
  801643:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801646:	8d 50 01             	lea    0x1(%eax),%edx
  801649:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801651:	ff 4d f8             	decl   -0x8(%ebp)
  801654:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801658:	79 e9                	jns    801643 <memset+0x14>
		*p++ = c;

	return v;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
  801668:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801671:	eb 16                	jmp    801689 <memcpy+0x2a>
		*d++ = *s++;
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	8d 50 01             	lea    0x1(%eax),%edx
  801679:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80167c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801682:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801685:	8a 12                	mov    (%edx),%dl
  801687:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
  80168c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168f:	89 55 10             	mov    %edx,0x10(%ebp)
  801692:	85 c0                	test   %eax,%eax
  801694:	75 dd                	jne    801673 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016b3:	73 50                	jae    801705 <memmove+0x6a>
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016c0:	76 43                	jbe    801705 <memmove+0x6a>
		s += n;
  8016c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ce:	eb 10                	jmp    8016e0 <memmove+0x45>
			*--d = *--s;
  8016d0:	ff 4d f8             	decl   -0x8(%ebp)
  8016d3:	ff 4d fc             	decl   -0x4(%ebp)
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d9:	8a 10                	mov    (%eax),%dl
  8016db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016de:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	75 e3                	jne    8016d0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016ed:	eb 23                	jmp    801712 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	8d 50 01             	lea    0x1(%eax),%edx
  8016f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801701:	8a 12                	mov    (%edx),%dl
  801703:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801705:	8b 45 10             	mov    0x10(%ebp),%eax
  801708:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170b:	89 55 10             	mov    %edx,0x10(%ebp)
  80170e:	85 c0                	test   %eax,%eax
  801710:	75 dd                	jne    8016ef <memmove+0x54>
			*d++ = *s++;

	return dst;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801729:	eb 2a                	jmp    801755 <memcmp+0x3e>
		if (*s1 != *s2)
  80172b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172e:	8a 10                	mov    (%eax),%dl
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	38 c2                	cmp    %al,%dl
  801737:	74 16                	je     80174f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801739:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
  80174d:	eb 18                	jmp    801767 <memcmp+0x50>
		s1++, s2++;
  80174f:	ff 45 fc             	incl   -0x4(%ebp)
  801752:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	8d 50 ff             	lea    -0x1(%eax),%edx
  80175b:	89 55 10             	mov    %edx,0x10(%ebp)
  80175e:	85 c0                	test   %eax,%eax
  801760:	75 c9                	jne    80172b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176f:	8b 55 08             	mov    0x8(%ebp),%edx
  801772:	8b 45 10             	mov    0x10(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80177a:	eb 15                	jmp    801791 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	0f b6 d0             	movzbl %al,%edx
  801784:	8b 45 0c             	mov    0xc(%ebp),%eax
  801787:	0f b6 c0             	movzbl %al,%eax
  80178a:	39 c2                	cmp    %eax,%edx
  80178c:	74 0d                	je     80179b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178e:	ff 45 08             	incl   0x8(%ebp)
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801797:	72 e3                	jb     80177c <memfind+0x13>
  801799:	eb 01                	jmp    80179c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80179b:	90                   	nop
	return (void *) s;
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b5:	eb 03                	jmp    8017ba <strtol+0x19>
		s++;
  8017b7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8a 00                	mov    (%eax),%al
  8017bf:	3c 20                	cmp    $0x20,%al
  8017c1:	74 f4                	je     8017b7 <strtol+0x16>
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	3c 09                	cmp    $0x9,%al
  8017ca:	74 eb                	je     8017b7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	3c 2b                	cmp    $0x2b,%al
  8017d3:	75 05                	jne    8017da <strtol+0x39>
		s++;
  8017d5:	ff 45 08             	incl   0x8(%ebp)
  8017d8:	eb 13                	jmp    8017ed <strtol+0x4c>
	else if (*s == '-')
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	3c 2d                	cmp    $0x2d,%al
  8017e1:	75 0a                	jne    8017ed <strtol+0x4c>
		s++, neg = 1;
  8017e3:	ff 45 08             	incl   0x8(%ebp)
  8017e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f1:	74 06                	je     8017f9 <strtol+0x58>
  8017f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f7:	75 20                	jne    801819 <strtol+0x78>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	3c 30                	cmp    $0x30,%al
  801800:	75 17                	jne    801819 <strtol+0x78>
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	40                   	inc    %eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	3c 78                	cmp    $0x78,%al
  80180a:	75 0d                	jne    801819 <strtol+0x78>
		s += 2, base = 16;
  80180c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801810:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801817:	eb 28                	jmp    801841 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801819:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80181d:	75 15                	jne    801834 <strtol+0x93>
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	3c 30                	cmp    $0x30,%al
  801826:	75 0c                	jne    801834 <strtol+0x93>
		s++, base = 8;
  801828:	ff 45 08             	incl   0x8(%ebp)
  80182b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801832:	eb 0d                	jmp    801841 <strtol+0xa0>
	else if (base == 0)
  801834:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801838:	75 07                	jne    801841 <strtol+0xa0>
		base = 10;
  80183a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 2f                	cmp    $0x2f,%al
  801848:	7e 19                	jle    801863 <strtol+0xc2>
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	3c 39                	cmp    $0x39,%al
  801851:	7f 10                	jg     801863 <strtol+0xc2>
			dig = *s - '0';
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	0f be c0             	movsbl %al,%eax
  80185b:	83 e8 30             	sub    $0x30,%eax
  80185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801861:	eb 42                	jmp    8018a5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	3c 60                	cmp    $0x60,%al
  80186a:	7e 19                	jle    801885 <strtol+0xe4>
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	3c 7a                	cmp    $0x7a,%al
  801873:	7f 10                	jg     801885 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	8a 00                	mov    (%eax),%al
  80187a:	0f be c0             	movsbl %al,%eax
  80187d:	83 e8 57             	sub    $0x57,%eax
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801883:	eb 20                	jmp    8018a5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	3c 40                	cmp    $0x40,%al
  80188c:	7e 39                	jle    8018c7 <strtol+0x126>
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	3c 5a                	cmp    $0x5a,%al
  801895:	7f 30                	jg     8018c7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	83 e8 37             	sub    $0x37,%eax
  8018a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018ab:	7d 19                	jge    8018c6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018ad:	ff 45 08             	incl   0x8(%ebp)
  8018b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b7:	89 c2                	mov    %eax,%edx
  8018b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018c1:	e9 7b ff ff ff       	jmp    801841 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018cb:	74 08                	je     8018d5 <strtol+0x134>
		*endptr = (char *) s;
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d9:	74 07                	je     8018e2 <strtol+0x141>
  8018db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018de:	f7 d8                	neg    %eax
  8018e0:	eb 03                	jmp    8018e5 <strtol+0x144>
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ff:	79 13                	jns    801914 <ltostr+0x2d>
	{
		neg = 1;
  801901:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801911:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80191c:	99                   	cltd   
  80191d:	f7 f9                	idiv   %ecx
  80191f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801922:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801925:	8d 50 01             	lea    0x1(%eax),%edx
  801928:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80192b:	89 c2                	mov    %eax,%edx
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801935:	83 c2 30             	add    $0x30,%edx
  801938:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80193a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801942:	f7 e9                	imul   %ecx
  801944:	c1 fa 02             	sar    $0x2,%edx
  801947:	89 c8                	mov    %ecx,%eax
  801949:	c1 f8 1f             	sar    $0x1f,%eax
  80194c:	29 c2                	sub    %eax,%edx
  80194e:	89 d0                	mov    %edx,%eax
  801950:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801956:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80195b:	f7 e9                	imul   %ecx
  80195d:	c1 fa 02             	sar    $0x2,%edx
  801960:	89 c8                	mov    %ecx,%eax
  801962:	c1 f8 1f             	sar    $0x1f,%eax
  801965:	29 c2                	sub    %eax,%edx
  801967:	89 d0                	mov    %edx,%eax
  801969:	c1 e0 02             	shl    $0x2,%eax
  80196c:	01 d0                	add    %edx,%eax
  80196e:	01 c0                	add    %eax,%eax
  801970:	29 c1                	sub    %eax,%ecx
  801972:	89 ca                	mov    %ecx,%edx
  801974:	85 d2                	test   %edx,%edx
  801976:	75 9c                	jne    801914 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801978:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801982:	48                   	dec    %eax
  801983:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801986:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80198a:	74 3d                	je     8019c9 <ltostr+0xe2>
		start = 1 ;
  80198c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801993:	eb 34                	jmp    8019c9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	01 d0                	add    %edx,%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	01 c2                	add    %eax,%edx
  8019aa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b0:	01 c8                	add    %ecx,%eax
  8019b2:	8a 00                	mov    (%eax),%al
  8019b4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	01 c2                	add    %eax,%edx
  8019be:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019c1:	88 02                	mov    %al,(%edx)
		start++ ;
  8019c3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cf:	7c c4                	jl     801995 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	01 d0                	add    %edx,%eax
  8019d9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 54 fa ff ff       	call   801441 <strlen>
  8019ed:	83 c4 04             	add    $0x4,%esp
  8019f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	e8 46 fa ff ff       	call   801441 <strlen>
  8019fb:	83 c4 04             	add    $0x4,%esp
  8019fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0f:	eb 17                	jmp    801a28 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 c2                	add    %eax,%edx
  801a19:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	01 c8                	add    %ecx,%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a25:	ff 45 fc             	incl   -0x4(%ebp)
  801a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2e:	7c e1                	jl     801a11 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a30:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3e:	eb 1f                	jmp    801a5f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a43:	8d 50 01             	lea    0x1(%eax),%edx
  801a46:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a49:	89 c2                	mov    %eax,%edx
  801a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4e:	01 c2                	add    %eax,%edx
  801a50:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a56:	01 c8                	add    %ecx,%eax
  801a58:	8a 00                	mov    (%eax),%al
  801a5a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a5c:	ff 45 f8             	incl   -0x8(%ebp)
  801a5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a65:	7c d9                	jl     801a40 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	01 d0                	add    %edx,%eax
  801a6f:	c6 00 00             	movb   $0x0,(%eax)
}
  801a72:	90                   	nop
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a78:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a81:	8b 45 14             	mov    0x14(%ebp),%eax
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a98:	eb 0c                	jmp    801aa6 <strsplit+0x31>
			*string++ = 0;
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	8d 50 01             	lea    0x1(%eax),%edx
  801aa0:	89 55 08             	mov    %edx,0x8(%ebp)
  801aa3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	8a 00                	mov    (%eax),%al
  801aab:	84 c0                	test   %al,%al
  801aad:	74 18                	je     801ac7 <strsplit+0x52>
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	8a 00                	mov    (%eax),%al
  801ab4:	0f be c0             	movsbl %al,%eax
  801ab7:	50                   	push   %eax
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	e8 13 fb ff ff       	call   8015d3 <strchr>
  801ac0:	83 c4 08             	add    $0x8,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	75 d3                	jne    801a9a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8a 00                	mov    (%eax),%al
  801acc:	84 c0                	test   %al,%al
  801ace:	74 5a                	je     801b2a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad3:	8b 00                	mov    (%eax),%eax
  801ad5:	83 f8 0f             	cmp    $0xf,%eax
  801ad8:	75 07                	jne    801ae1 <strsplit+0x6c>
		{
			return 0;
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
  801adf:	eb 66                	jmp    801b47 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae4:	8b 00                	mov    (%eax),%eax
  801ae6:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae9:	8b 55 14             	mov    0x14(%ebp),%edx
  801aec:	89 0a                	mov    %ecx,(%edx)
  801aee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af5:	8b 45 10             	mov    0x10(%ebp),%eax
  801af8:	01 c2                	add    %eax,%edx
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aff:	eb 03                	jmp    801b04 <strsplit+0x8f>
			string++;
  801b01:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8a 00                	mov    (%eax),%al
  801b09:	84 c0                	test   %al,%al
  801b0b:	74 8b                	je     801a98 <strsplit+0x23>
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	0f be c0             	movsbl %al,%eax
  801b15:	50                   	push   %eax
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	e8 b5 fa ff ff       	call   8015d3 <strchr>
  801b1e:	83 c4 08             	add    $0x8,%esp
  801b21:	85 c0                	test   %eax,%eax
  801b23:	74 dc                	je     801b01 <strsplit+0x8c>
			string++;
	}
  801b25:	e9 6e ff ff ff       	jmp    801a98 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b2a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b37:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b42:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801b4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b56:	eb 4c                	jmp    801ba4 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801b58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5e:	01 d0                	add    %edx,%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	3c 40                	cmp    $0x40,%al
  801b64:	7e 27                	jle    801b8d <str2lower+0x44>
  801b66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	8a 00                	mov    (%eax),%al
  801b70:	3c 5a                	cmp    $0x5a,%al
  801b72:	7f 19                	jg     801b8d <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801b74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	01 ca                	add    %ecx,%edx
  801b84:	8a 12                	mov    (%edx),%dl
  801b86:	83 c2 20             	add    $0x20,%edx
  801b89:	88 10                	mov    %dl,(%eax)
  801b8b:	eb 14                	jmp    801ba1 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	e8 95 f8 ff ff       	call   801441 <strlen>
  801bac:	83 c4 04             	add    $0x4,%esp
  801baf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bb2:	7f a4                	jg     801b58 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801bb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	01 d0                	add    %edx,%eax
  801bbc:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801bc7:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801bd6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  801be5:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bea:	40                   	inc    %eax
  801beb:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801bf0:	90                   	nop
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <searchElement>:

int searchElement(uint32 start) {
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c00:	eb 17                	jmp    801c19 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c05:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801c0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c0f:	75 05                	jne    801c16 <searchElement+0x23>
			return i;
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c14:	eb 12                	jmp    801c28 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801c16:	ff 45 fc             	incl   -0x4(%ebp)
  801c19:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c1e:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801c21:	7c df                	jl     801c02 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <removeElement>:
void removeElement(uint32 start) {
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	e8 bb ff ff ff       	call   801bf3 <searchElement>
  801c38:	83 c4 04             	add    $0x4,%esp
  801c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801c44:	eb 26                	jmp    801c6c <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c49:	40                   	inc    %eax
  801c4a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c4d:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801c54:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801c5b:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801c62:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c69:	ff 45 fc             	incl   -0x4(%ebp)
  801c6c:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c71:	48                   	dec    %eax
  801c72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c75:	7f cf                	jg     801c46 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801c77:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c7c:	48                   	dec    %eax
  801c7d:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801c82:	90                   	nop
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <searchfree>:
int searchfree(uint32 end)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801c8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c92:	eb 17                	jmp    801cab <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c97:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801c9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ca1:	75 05                	jne    801ca8 <searchfree+0x23>
			return i;
  801ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca6:	eb 12                	jmp    801cba <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801ca8:	ff 45 fc             	incl   -0x4(%ebp)
  801cab:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801cb0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801cb3:	7c df                	jl     801c94 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <removefree>:
void removefree(uint32 end)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  801cc2:	eb 52                	jmp    801d16 <removefree+0x5a>
		int index = searchfree(end);
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	e8 b9 ff ff ff       	call   801c85 <searchfree>
  801ccc:	83 c4 04             	add    $0x4,%esp
  801ccf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  801cd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801cd8:	eb 26                	jmp    801d00 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cdd:	40                   	inc    %eax
  801cde:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ce1:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801ce8:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801cef:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801cf6:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801cfd:	ff 45 fc             	incl   -0x4(%ebp)
  801d00:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d05:	48                   	dec    %eax
  801d06:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d09:	7f cf                	jg     801cda <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801d0b:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d10:	48                   	dec    %eax
  801d11:	a3 2c 40 80 00       	mov    %eax,0x80402c
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 67 ff ff ff       	call   801c85 <searchfree>
  801d1e:	83 c4 04             	add    $0x4,%esp
  801d21:	83 f8 ff             	cmp    $0xffffffff,%eax
  801d24:	75 9e                	jne    801cc4 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <printArray>:
void printArray() {
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	68 44 3d 80 00       	push   $0x803d44
  801d37:	e8 7d ee ff ff       	call   800bb9 <cprintf>
  801d3c:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801d3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d46:	eb 29                	jmp    801d71 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801d5c:	52                   	push   %edx
  801d5d:	50                   	push   %eax
  801d5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d61:	68 55 3d 80 00       	push   $0x803d55
  801d66:	e8 4e ee ff ff       	call   800bb9 <cprintf>
  801d6b:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801d6e:	ff 45 f4             	incl   -0xc(%ebp)
  801d71:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d79:	7c cd                	jl     801d48 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801d81:	a1 04 40 80 00       	mov    0x804004,%eax
  801d86:	85 c0                	test   %eax,%eax
  801d88:	74 0a                	je     801d94 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	e8 4f 09 00 00       	call   8026f7 <sys_sbrk>
  801da8:	83 c4 10             	add    $0x10,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801db3:	e8 c6 ff ff ff       	call   801d7e <InitializeUHeap>
	if (size == 0) return NULL ;
  801db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dbc:	75 0a                	jne    801dc8 <malloc+0x1b>
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc3:	e9 43 01 00 00       	jmp    801f0b <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801dc8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801dcf:	77 3c                	ja     801e0d <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801dd1:	e8 c3 07 00 00       	call   802599 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	74 13                	je     801ded <malloc+0x40>
			return alloc_block_FF(size);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 89 0b 00 00       	call   80296e <alloc_block_FF>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	e9 1e 01 00 00       	jmp    801f0b <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801ded:	e8 d8 07 00 00       	call   8025ca <sys_isUHeapPlacementStrategyBESTFIT>
  801df2:	85 c0                	test   %eax,%eax
  801df4:	0f 84 0c 01 00 00    	je     801f06 <malloc+0x159>
			return alloc_block_BF(size);
  801dfa:	83 ec 0c             	sub    $0xc,%esp
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	e8 7d 0e 00 00       	call   802c82 <alloc_block_BF>
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	e9 fe 00 00 00       	jmp    801f0b <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801e0d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801e14:	8b 55 08             	mov    0x8(%ebp),%edx
  801e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	48                   	dec    %eax
  801e1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e23:	ba 00 00 00 00       	mov    $0x0,%edx
  801e28:	f7 75 e0             	divl   -0x20(%ebp)
  801e2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e2e:	29 d0                	sub    %edx,%eax
  801e30:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	c1 e8 0c             	shr    $0xc,%eax
  801e39:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801e3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801e43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801e4a:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801e51:	e8 f4 08 00 00       	call   80274a <sys_hard_limit>
  801e56:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801e59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5c:	05 00 10 00 00       	add    $0x1000,%eax
  801e61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e64:	eb 49                	jmp    801eaf <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	ff 75 e8             	pushl  -0x18(%ebp)
  801e6c:	e8 82 fd ff ff       	call   801bf3 <searchElement>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	83 f8 ff             	cmp    $0xffffffff,%eax
  801e77:	75 28                	jne    801ea1 <malloc+0xf4>
			{


				count++;
  801e79:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e82:	75 24                	jne    801ea8 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e87:	05 00 10 00 00       	add    $0x1000,%eax
  801e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	c1 e0 0c             	shl    $0xc,%eax
  801e95:	89 c2                	mov    %eax,%edx
  801e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9a:	29 d0                	sub    %edx,%eax
  801e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801e9f:	eb 17                	jmp    801eb8 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801ea1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801ea8:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801eaf:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801eb6:	76 ae                	jbe    801e66 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801eb8:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801ebc:	75 07                	jne    801ec5 <malloc+0x118>
		{
			return NULL;
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	eb 46                	jmp    801f0b <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ecb:	eb 1a                	jmp    801ee7 <malloc+0x13a>
		{
			addElement(i,end);
  801ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	e8 e7 fc ff ff       	call   801bc4 <addElement>
  801edd:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801ee0:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801ee7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801eed:	7c de                	jl     801ecd <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef2:	83 ec 08             	sub    $0x8,%esp
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	50                   	push   %eax
  801ef9:	e8 30 08 00 00       	call   80272e <sys_allocate_user_mem>
  801efe:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f04:	eb 05                	jmp    801f0b <malloc+0x15e>
	}
	return NULL;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801f13:	e8 32 08 00 00       	call   80274a <sys_hard_limit>
  801f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	0f 89 82 00 00 00    	jns    801fa8 <free+0x9b>
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f2e:	77 78                	ja     801fa8 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f36:	73 10                	jae    801f48 <free+0x3b>
			free_block(virtual_address);
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	e8 d2 0e 00 00       	call   802e15 <free_block>
  801f43:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801f46:	eb 77                	jmp    801fbf <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	50                   	push   %eax
  801f4f:	e8 9f fc ff ff       	call   801bf3 <searchElement>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5d:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f67:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801f6e:	29 c2                	sub    %eax,%edx
  801f70:	89 d0                	mov    %edx,%eax
  801f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f78:	c1 e8 0c             	shr    $0xc,%eax
  801f7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	83 ec 08             	sub    $0x8,%esp
  801f84:	ff 75 ec             	pushl  -0x14(%ebp)
  801f87:	50                   	push   %eax
  801f88:	e8 85 07 00 00       	call   802712 <sys_free_user_mem>
  801f8d:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f93:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	50                   	push   %eax
  801f9e:	e8 19 fd ff ff       	call   801cbc <removefree>
  801fa3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801fa6:	eb 17                	jmp    801fbf <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801fa8:	83 ec 04             	sub    $0x4,%esp
  801fab:	68 6e 3d 80 00       	push   $0x803d6e
  801fb0:	68 ac 00 00 00       	push   $0xac
  801fb5:	68 7e 3d 80 00       	push   $0x803d7e
  801fba:	e8 3d e9 ff ff       	call   8008fc <_panic>
	}
}
  801fbf:	90                   	nop
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 18             	sub    $0x18,%esp
  801fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcb:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fce:	e8 ab fd ff ff       	call   801d7e <InitializeUHeap>
	if (size == 0) return NULL ;
  801fd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fd7:	75 07                	jne    801fe0 <smalloc+0x1e>
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb 17                	jmp    801ff7 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 8c 3d 80 00       	push   $0x803d8c
  801fe8:	68 bc 00 00 00       	push   $0xbc
  801fed:	68 7e 3d 80 00       	push   $0x803d7e
  801ff2:	e8 05 e9 ff ff       	call   8008fc <_panic>
	return NULL;
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fff:	e8 7a fd ff ff       	call   801d7e <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	68 b4 3d 80 00       	push   $0x803db4
  80200c:	68 ca 00 00 00       	push   $0xca
  802011:	68 7e 3d 80 00       	push   $0x803d7e
  802016:	e8 e1 e8 ff ff       	call   8008fc <_panic>

0080201b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802021:	e8 58 fd ff ff       	call   801d7e <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 d8 3d 80 00       	push   $0x803dd8
  80202e:	68 ea 00 00 00       	push   $0xea
  802033:	68 7e 3d 80 00       	push   $0x803d7e
  802038:	e8 bf e8 ff ff       	call   8008fc <_panic>

0080203d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 00 3e 80 00       	push   $0x803e00
  80204b:	68 fe 00 00 00       	push   $0xfe
  802050:	68 7e 3d 80 00       	push   $0x803d7e
  802055:	e8 a2 e8 ff ff       	call   8008fc <_panic>

0080205a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	68 24 3e 80 00       	push   $0x803e24
  802068:	68 08 01 00 00       	push   $0x108
  80206d:	68 7e 3d 80 00       	push   $0x803d7e
  802072:	e8 85 e8 ff ff       	call   8008fc <_panic>

00802077 <shrink>:

}
void shrink(uint32 newSize)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 24 3e 80 00       	push   $0x803e24
  802085:	68 0d 01 00 00       	push   $0x10d
  80208a:	68 7e 3d 80 00       	push   $0x803d7e
  80208f:	e8 68 e8 ff ff       	call   8008fc <_panic>

00802094 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 24 3e 80 00       	push   $0x803e24
  8020a2:	68 12 01 00 00       	push   $0x112
  8020a7:	68 7e 3d 80 00       	push   $0x803d7e
  8020ac:	e8 4b e8 ff ff       	call   8008fc <_panic>

008020b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	57                   	push   %edi
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020c9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020cc:	cd 30                	int    $0x30
  8020ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	52                   	push   %edx
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	50                   	push   %eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	e8 b2 ff ff ff       	call   8020b1 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	90                   	nop
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_cgetc>:

int
sys_cgetc(void)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 01                	push   $0x1
  802114:	e8 98 ff ff ff       	call   8020b1 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802121:	8b 55 0c             	mov    0xc(%ebp),%edx
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	52                   	push   %edx
  80212e:	50                   	push   %eax
  80212f:	6a 05                	push   $0x5
  802131:	e8 7b ff ff ff       	call   8020b1 <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802140:	8b 75 18             	mov    0x18(%ebp),%esi
  802143:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802146:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	56                   	push   %esi
  802150:	53                   	push   %ebx
  802151:	51                   	push   %ecx
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 06                	push   $0x6
  802156:	e8 56 ff ff ff       	call   8020b1 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    

00802165 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	52                   	push   %edx
  802175:	50                   	push   %eax
  802176:	6a 07                	push   $0x7
  802178:	e8 34 ff ff ff       	call   8020b1 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	6a 08                	push   $0x8
  802193:	e8 19 ff ff ff       	call   8020b1 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 09                	push   $0x9
  8021ac:	e8 00 ff ff ff       	call   8020b1 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 0a                	push   $0xa
  8021c5:	e8 e7 fe ff ff       	call   8020b1 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 0b                	push   $0xb
  8021de:	e8 ce fe ff ff       	call   8020b1 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 0c                	push   $0xc
  8021f7:	e8 b5 fe ff ff       	call   8020b1 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	ff 75 08             	pushl  0x8(%ebp)
  80220f:	6a 0d                	push   $0xd
  802211:	e8 9b fe ff ff       	call   8020b1 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 0e                	push   $0xe
  80222a:	e8 82 fe ff ff       	call   8020b1 <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
}
  802232:	90                   	nop
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 11                	push   $0x11
  802244:	e8 68 fe ff ff       	call   8020b1 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	90                   	nop
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 12                	push   $0x12
  80225e:	e8 4e fe ff ff       	call   8020b1 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_cputc>:


void
sys_cputc(const char c)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 04             	sub    $0x4,%esp
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802275:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	50                   	push   %eax
  802282:	6a 13                	push   $0x13
  802284:	e8 28 fe ff ff       	call   8020b1 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	90                   	nop
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 14                	push   $0x14
  80229e:	e8 0e fe ff ff       	call   8020b1 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	90                   	nop
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	50                   	push   %eax
  8022b9:	6a 15                	push   $0x15
  8022bb:	e8 f1 fd ff ff       	call   8020b1 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	52                   	push   %edx
  8022d5:	50                   	push   %eax
  8022d6:	6a 18                	push   $0x18
  8022d8:	e8 d4 fd ff ff       	call   8020b1 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	52                   	push   %edx
  8022f2:	50                   	push   %eax
  8022f3:	6a 16                	push   $0x16
  8022f5:	e8 b7 fd ff ff       	call   8020b1 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	90                   	nop
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802303:	8b 55 0c             	mov    0xc(%ebp),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	52                   	push   %edx
  802310:	50                   	push   %eax
  802311:	6a 17                	push   $0x17
  802313:	e8 99 fd ff ff       	call   8020b1 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	90                   	nop
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	8b 45 10             	mov    0x10(%ebp),%eax
  802327:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80232a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80232d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	6a 00                	push   $0x0
  802336:	51                   	push   %ecx
  802337:	52                   	push   %edx
  802338:	ff 75 0c             	pushl  0xc(%ebp)
  80233b:	50                   	push   %eax
  80233c:	6a 19                	push   $0x19
  80233e:	e8 6e fd ff ff       	call   8020b1 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80234b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	52                   	push   %edx
  802358:	50                   	push   %eax
  802359:	6a 1a                	push   $0x1a
  80235b:	e8 51 fd ff ff       	call   8020b1 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	51                   	push   %ecx
  802376:	52                   	push   %edx
  802377:	50                   	push   %eax
  802378:	6a 1b                	push   $0x1b
  80237a:	e8 32 fd ff ff       	call   8020b1 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	52                   	push   %edx
  802394:	50                   	push   %eax
  802395:	6a 1c                	push   $0x1c
  802397:	e8 15 fd ff ff       	call   8020b1 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 1d                	push   $0x1d
  8023b0:	e8 fc fc ff ff       	call   8020b1 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	ff 75 14             	pushl  0x14(%ebp)
  8023c5:	ff 75 10             	pushl  0x10(%ebp)
  8023c8:	ff 75 0c             	pushl  0xc(%ebp)
  8023cb:	50                   	push   %eax
  8023cc:	6a 1e                	push   $0x1e
  8023ce:	e8 de fc ff ff       	call   8020b1 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	50                   	push   %eax
  8023e7:	6a 1f                	push   $0x1f
  8023e9:	e8 c3 fc ff ff       	call   8020b1 <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
}
  8023f1:	90                   	nop
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	50                   	push   %eax
  802403:	6a 20                	push   $0x20
  802405:	e8 a7 fc ff ff       	call   8020b1 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 02                	push   $0x2
  80241e:	e8 8e fc ff ff       	call   8020b1 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 03                	push   $0x3
  802437:	e8 75 fc ff ff       	call   8020b1 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 04                	push   $0x4
  802450:	e8 5c fc ff ff       	call   8020b1 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_exit_env>:


void sys_exit_env(void)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 21                	push   $0x21
  802469:	e8 43 fc ff ff       	call   8020b1 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	90                   	nop
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80247a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80247d:	8d 50 04             	lea    0x4(%eax),%edx
  802480:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	52                   	push   %edx
  80248a:	50                   	push   %eax
  80248b:	6a 22                	push   $0x22
  80248d:	e8 1f fc ff ff       	call   8020b1 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
	return result;
  802495:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802498:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249e:	89 01                	mov    %eax,(%ecx)
  8024a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	c9                   	leave  
  8024a7:	c2 04 00             	ret    $0x4

008024aa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	ff 75 10             	pushl  0x10(%ebp)
  8024b4:	ff 75 0c             	pushl  0xc(%ebp)
  8024b7:	ff 75 08             	pushl  0x8(%ebp)
  8024ba:	6a 10                	push   $0x10
  8024bc:	e8 f0 fb ff ff       	call   8020b1 <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c4:	90                   	nop
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 23                	push   $0x23
  8024d6:	e8 d6 fb ff ff       	call   8020b1 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 04             	sub    $0x4,%esp
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	50                   	push   %eax
  8024f9:	6a 24                	push   $0x24
  8024fb:	e8 b1 fb ff ff       	call   8020b1 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
	return ;
  802503:	90                   	nop
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <rsttst>:
void rsttst()
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 26                	push   $0x26
  802515:	e8 97 fb ff ff       	call   8020b1 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
	return ;
  80251d:	90                   	nop
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 04             	sub    $0x4,%esp
  802526:	8b 45 14             	mov    0x14(%ebp),%eax
  802529:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80252c:	8b 55 18             	mov    0x18(%ebp),%edx
  80252f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802533:	52                   	push   %edx
  802534:	50                   	push   %eax
  802535:	ff 75 10             	pushl  0x10(%ebp)
  802538:	ff 75 0c             	pushl  0xc(%ebp)
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	6a 25                	push   $0x25
  802540:	e8 6c fb ff ff       	call   8020b1 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return ;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <chktst>:
void chktst(uint32 n)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	ff 75 08             	pushl  0x8(%ebp)
  802559:	6a 27                	push   $0x27
  80255b:	e8 51 fb ff ff       	call   8020b1 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
	return ;
  802563:	90                   	nop
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <inctst>:

void inctst()
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 28                	push   $0x28
  802575:	e8 37 fb ff ff       	call   8020b1 <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
	return ;
  80257d:	90                   	nop
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <gettst>:
uint32 gettst()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 29                	push   $0x29
  80258f:	e8 1d fb ff ff       	call   8020b1 <syscall>
  802594:	83 c4 18             	add    $0x18,%esp
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 2a                	push   $0x2a
  8025ab:	e8 01 fb ff ff       	call   8020b1 <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
  8025b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025b6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025ba:	75 07                	jne    8025c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c1:	eb 05                	jmp    8025c8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 2a                	push   $0x2a
  8025dc:	e8 d0 fa ff ff       	call   8020b1 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
  8025e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025e7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025eb:	75 07                	jne    8025f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f2:	eb 05                	jmp    8025f9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 2a                	push   $0x2a
  80260d:	e8 9f fa ff ff       	call   8020b1 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
  802615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802618:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80261c:	75 07                	jne    802625 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	eb 05                	jmp    80262a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 2a                	push   $0x2a
  80263e:	e8 6e fa ff ff       	call   8020b1 <syscall>
  802643:	83 c4 18             	add    $0x18,%esp
  802646:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802649:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80264d:	75 07                	jne    802656 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80264f:	b8 01 00 00 00       	mov    $0x1,%eax
  802654:	eb 05                	jmp    80265b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	ff 75 08             	pushl  0x8(%ebp)
  80266b:	6a 2b                	push   $0x2b
  80266d:	e8 3f fa ff ff       	call   8020b1 <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
	return ;
  802675:	90                   	nop
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80267c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80267f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802682:	8b 55 0c             	mov    0xc(%ebp),%edx
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	6a 00                	push   $0x0
  80268a:	53                   	push   %ebx
  80268b:	51                   	push   %ecx
  80268c:	52                   	push   %edx
  80268d:	50                   	push   %eax
  80268e:	6a 2c                	push   $0x2c
  802690:	e8 1c fa ff ff       	call   8020b1 <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
}
  802698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	52                   	push   %edx
  8026ad:	50                   	push   %eax
  8026ae:	6a 2d                	push   $0x2d
  8026b0:	e8 fc f9 ff ff       	call   8020b1 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	6a 00                	push   $0x0
  8026c8:	51                   	push   %ecx
  8026c9:	ff 75 10             	pushl  0x10(%ebp)
  8026cc:	52                   	push   %edx
  8026cd:	50                   	push   %eax
  8026ce:	6a 2e                	push   $0x2e
  8026d0:	e8 dc f9 ff ff       	call   8020b1 <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	ff 75 10             	pushl  0x10(%ebp)
  8026e4:	ff 75 0c             	pushl  0xc(%ebp)
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	6a 0f                	push   $0xf
  8026ec:	e8 c0 f9 ff ff       	call   8020b1 <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f4:	90                   	nop
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	50                   	push   %eax
  802706:	6a 2f                	push   $0x2f
  802708:	e8 a4 f9 ff ff       	call   8020b1 <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp

}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	ff 75 0c             	pushl  0xc(%ebp)
  80271e:	ff 75 08             	pushl  0x8(%ebp)
  802721:	6a 30                	push   $0x30
  802723:	e8 89 f9 ff ff       	call   8020b1 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp

}
  80272b:	90                   	nop
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	ff 75 0c             	pushl  0xc(%ebp)
  80273a:	ff 75 08             	pushl  0x8(%ebp)
  80273d:	6a 31                	push   $0x31
  80273f:	e8 6d f9 ff ff       	call   8020b1 <syscall>
  802744:	83 c4 18             	add    $0x18,%esp

}
  802747:	90                   	nop
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <sys_hard_limit>:
uint32 sys_hard_limit(){
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 32                	push   $0x32
  802759:	e8 53 f9 ff ff       	call   8020b1 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	83 e8 10             	sub    $0x10,%eax
  80276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  802772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
}
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	83 e8 10             	sub    $0x10,%eax
  802785:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802788:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80278b:	8a 40 04             	mov    0x4(%eax),%al
}
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80279d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a0:	83 f8 02             	cmp    $0x2,%eax
  8027a3:	74 2b                	je     8027d0 <alloc_block+0x40>
  8027a5:	83 f8 02             	cmp    $0x2,%eax
  8027a8:	7f 07                	jg     8027b1 <alloc_block+0x21>
  8027aa:	83 f8 01             	cmp    $0x1,%eax
  8027ad:	74 0e                	je     8027bd <alloc_block+0x2d>
  8027af:	eb 58                	jmp    802809 <alloc_block+0x79>
  8027b1:	83 f8 03             	cmp    $0x3,%eax
  8027b4:	74 2d                	je     8027e3 <alloc_block+0x53>
  8027b6:	83 f8 04             	cmp    $0x4,%eax
  8027b9:	74 3b                	je     8027f6 <alloc_block+0x66>
  8027bb:	eb 4c                	jmp    802809 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8027bd:	83 ec 0c             	sub    $0xc,%esp
  8027c0:	ff 75 08             	pushl  0x8(%ebp)
  8027c3:	e8 a6 01 00 00       	call   80296e <alloc_block_FF>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027ce:	eb 4a                	jmp    80281a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027d0:	83 ec 0c             	sub    $0xc,%esp
  8027d3:	ff 75 08             	pushl  0x8(%ebp)
  8027d6:	e8 1d 06 00 00       	call   802df8 <alloc_block_NF>
  8027db:	83 c4 10             	add    $0x10,%esp
  8027de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027e1:	eb 37                	jmp    80281a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027e3:	83 ec 0c             	sub    $0xc,%esp
  8027e6:	ff 75 08             	pushl  0x8(%ebp)
  8027e9:	e8 94 04 00 00       	call   802c82 <alloc_block_BF>
  8027ee:	83 c4 10             	add    $0x10,%esp
  8027f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027f4:	eb 24                	jmp    80281a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	ff 75 08             	pushl  0x8(%ebp)
  8027fc:	e8 da 05 00 00       	call   802ddb <alloc_block_WF>
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802807:	eb 11                	jmp    80281a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	68 34 3e 80 00       	push   $0x803e34
  802811:	e8 a3 e3 ff ff       	call   800bb9 <cprintf>
  802816:	83 c4 10             	add    $0x10,%esp
		break;
  802819:	90                   	nop
	}
	return va;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	68 54 3e 80 00       	push   $0x803e54
  80282d:	e8 87 e3 ff ff       	call   800bb9 <cprintf>
  802832:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802835:	83 ec 0c             	sub    $0xc,%esp
  802838:	68 7f 3e 80 00       	push   $0x803e7f
  80283d:	e8 77 e3 ff ff       	call   800bb9 <cprintf>
  802842:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284b:	eb 26                	jmp    802873 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8a 40 04             	mov    0x4(%eax),%al
  802853:	0f b6 d0             	movzbl %al,%edx
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	52                   	push   %edx
  80285f:	50                   	push   %eax
  802860:	68 97 3e 80 00       	push   $0x803e97
  802865:	e8 4f e3 ff ff       	call   800bb9 <cprintf>
  80286a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80286d:	8b 45 10             	mov    0x10(%ebp),%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	74 08                	je     802881 <print_blocks_list+0x62>
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 08             	mov    0x8(%eax),%eax
  80287f:	eb 05                	jmp    802886 <print_blocks_list+0x67>
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
  802886:	89 45 10             	mov    %eax,0x10(%ebp)
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	75 bd                	jne    80284d <print_blocks_list+0x2e>
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	75 b7                	jne    80284d <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802896:	83 ec 0c             	sub    $0xc,%esp
  802899:	68 54 3e 80 00       	push   $0x803e54
  80289e:	e8 16 e3 ff ff       	call   800bb9 <cprintf>
  8028a3:	83 c4 10             	add    $0x10,%esp

}
  8028a6:	90                   	nop
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  8028af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028b3:	0f 84 b2 00 00 00    	je     80296b <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  8028b9:	c7 05 30 40 80 00 01 	movl   $0x1,0x804030
  8028c0:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  8028c3:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  8028ca:	00 00 00 
  8028cd:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  8028d4:	00 00 00 
  8028d7:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  8028de:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  8028e9:	a1 24 41 80 00       	mov    0x804124,%eax
  8028ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f1:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  8028f3:	a1 24 41 80 00       	mov    0x804124,%eax
  8028f8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  8028fc:	a1 24 41 80 00       	mov    0x804124,%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	75 14                	jne    802919 <initialize_dynamic_allocator+0x70>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 b0 3e 80 00       	push   $0x803eb0
  80290d:	6a 68                	push   $0x68
  80290f:	68 d3 3e 80 00       	push   $0x803ed3
  802914:	e8 e3 df ff ff       	call   8008fc <_panic>
  802919:	a1 24 41 80 00       	mov    0x804124,%eax
  80291e:	8b 15 14 41 80 00    	mov    0x804114,%edx
  802924:	89 50 08             	mov    %edx,0x8(%eax)
  802927:	8b 40 08             	mov    0x8(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 10                	je     80293e <initialize_dynamic_allocator+0x95>
  80292e:	a1 14 41 80 00       	mov    0x804114,%eax
  802933:	8b 15 24 41 80 00    	mov    0x804124,%edx
  802939:	89 50 0c             	mov    %edx,0xc(%eax)
  80293c:	eb 0a                	jmp    802948 <initialize_dynamic_allocator+0x9f>
  80293e:	a1 24 41 80 00       	mov    0x804124,%eax
  802943:	a3 18 41 80 00       	mov    %eax,0x804118
  802948:	a1 24 41 80 00       	mov    0x804124,%eax
  80294d:	a3 14 41 80 00       	mov    %eax,0x804114
  802952:	a1 24 41 80 00       	mov    0x804124,%eax
  802957:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80295e:	a1 20 41 80 00       	mov    0x804120,%eax
  802963:	40                   	inc    %eax
  802964:	a3 20 41 80 00       	mov    %eax,0x804120
  802969:	eb 01                	jmp    80296c <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80296b:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  802974:	a1 30 40 80 00       	mov    0x804030,%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	75 40                	jne    8029bd <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	83 c0 10             	add    $0x10,%eax
  802983:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	50                   	push   %eax
  80298d:	e8 05 f4 ff ff       	call   801d97 <sbrk>
  802992:	83 c4 10             	add    $0x10,%esp
  802995:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802998:	83 ec 0c             	sub    $0xc,%esp
  80299b:	6a 00                	push   $0x0
  80299d:	e8 f5 f3 ff ff       	call   801d97 <sbrk>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  8029a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ab:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8029ae:	83 ec 08             	sub    $0x8,%esp
  8029b1:	50                   	push   %eax
  8029b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8029b5:	e8 ef fe ff ff       	call   8028a9 <initialize_dynamic_allocator>
  8029ba:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  8029bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c1:	75 0a                	jne    8029cd <alloc_block_FF+0x5f>
		 return NULL;
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c8:	e9 b3 02 00 00       	jmp    802c80 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  8029cd:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  8029d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  8029d8:	a1 14 41 80 00       	mov    0x804114,%eax
  8029dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e0:	e9 12 01 00 00       	jmp    802af7 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8a 40 04             	mov    0x4(%eax),%al
  8029eb:	84 c0                	test   %al,%al
  8029ed:	0f 84 fc 00 00 00    	je     802aef <alloc_block_FF+0x181>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fb:	0f 82 ee 00 00 00    	jb     802aef <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a09:	75 12                	jne    802a1d <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	83 c0 10             	add    $0x10,%eax
  802a18:	e9 63 02 00 00       	jmp    802c80 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  802a1d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	2b 45 08             	sub    0x8(%ebp),%eax
  802a33:	83 f8 0f             	cmp    $0xf,%eax
  802a36:	0f 86 a8 00 00 00    	jbe    802ae4 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	01 d0                	add    %edx,%eax
  802a44:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4f:	89 c2                	mov    %eax,%edx
  802a51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a54:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5c:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802a5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a61:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a69:	74 06                	je     802a71 <alloc_block_FF+0x103>
  802a6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a6f:	75 17                	jne    802a88 <alloc_block_FF+0x11a>
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	68 ec 3e 80 00       	push   $0x803eec
  802a79:	68 91 00 00 00       	push   $0x91
  802a7e:	68 d3 3e 80 00       	push   $0x803ed3
  802a83:	e8 74 de ff ff       	call   8008fc <_panic>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 50 08             	mov    0x8(%eax),%edx
  802a8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a91:	89 50 08             	mov    %edx,0x8(%eax)
  802a94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a97:	8b 40 08             	mov    0x8(%eax),%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	74 0c                	je     802aaa <alloc_block_FF+0x13c>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 08             	mov    0x8(%eax),%eax
  802aa4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802aa7:	89 50 0c             	mov    %edx,0xc(%eax)
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ab0:	89 50 08             	mov    %edx,0x8(%eax)
  802ab3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	89 50 0c             	mov    %edx,0xc(%eax)
  802abc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802abf:	8b 40 08             	mov    0x8(%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	75 08                	jne    802ace <alloc_block_FF+0x160>
  802ac6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac9:	a3 18 41 80 00       	mov    %eax,0x804118
  802ace:	a1 20 41 80 00       	mov    0x804120,%eax
  802ad3:	40                   	inc    %eax
  802ad4:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	83 c0 10             	add    $0x10,%eax
  802adf:	e9 9c 01 00 00       	jmp    802c80 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	83 c0 10             	add    $0x10,%eax
  802aea:	e9 91 01 00 00       	jmp    802c80 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802aef:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	74 08                	je     802b05 <alloc_block_FF+0x197>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	eb 05                	jmp    802b0a <alloc_block_FF+0x19c>
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802b0f:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	0f 85 c9 fe ff ff    	jne    8029e5 <alloc_block_FF+0x77>
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	0f 85 bf fe ff ff    	jne    8029e5 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b2a:	0f 85 4b 01 00 00    	jne    802c7b <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	83 ec 0c             	sub    $0xc,%esp
  802b36:	50                   	push   %eax
  802b37:	e8 5b f2 ff ff       	call   801d97 <sbrk>
  802b3c:	83 c4 10             	add    $0x10,%esp
  802b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b46:	0f 84 28 01 00 00    	je     802c74 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b55:	8b 55 08             	mov    0x8(%ebp),%edx
  802b58:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802b61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b65:	75 17                	jne    802b7e <alloc_block_FF+0x210>
  802b67:	83 ec 04             	sub    $0x4,%esp
  802b6a:	68 20 3f 80 00       	push   $0x803f20
  802b6f:	68 a1 00 00 00       	push   $0xa1
  802b74:	68 d3 3e 80 00       	push   $0x803ed3
  802b79:	e8 7e dd ff ff       	call   8008fc <_panic>
  802b7e:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b87:	89 50 0c             	mov    %edx,0xc(%eax)
  802b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 0d                	je     802ba1 <alloc_block_FF+0x233>
  802b94:	a1 18 41 80 00       	mov    0x804118,%eax
  802b99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b9c:	89 50 08             	mov    %edx,0x8(%eax)
  802b9f:	eb 08                	jmp    802ba9 <alloc_block_FF+0x23b>
  802ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba4:	a3 14 41 80 00       	mov    %eax,0x804114
  802ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bac:	a3 18 41 80 00       	mov    %eax,0x804118
  802bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bbb:	a1 20 41 80 00       	mov    0x804120,%eax
  802bc0:	40                   	inc    %eax
  802bc1:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802bc6:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bcb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bce:	83 f8 0f             	cmp    $0xf,%eax
  802bd1:	0f 86 95 00 00 00    	jbe    802c6c <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	01 d0                	add    %edx,%eax
  802bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802be2:	b8 00 10 00 00       	mov    $0x1000,%eax
  802be7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bea:	89 c2                	mov    %eax,%edx
  802bec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bef:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802bf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf4:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802bf8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bfc:	74 06                	je     802c04 <alloc_block_FF+0x296>
  802bfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c02:	75 17                	jne    802c1b <alloc_block_FF+0x2ad>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 ec 3e 80 00       	push   $0x803eec
  802c0c:	68 a6 00 00 00       	push   $0xa6
  802c11:	68 d3 3e 80 00       	push   $0x803ed3
  802c16:	e8 e1 dc ff ff       	call   8008fc <_panic>
  802c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1e:	8b 50 08             	mov    0x8(%eax),%edx
  802c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c24:	89 50 08             	mov    %edx,0x8(%eax)
  802c27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c2a:	8b 40 08             	mov    0x8(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0c                	je     802c3d <alloc_block_FF+0x2cf>
  802c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c34:	8b 40 08             	mov    0x8(%eax),%eax
  802c37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c3a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c43:	89 50 08             	mov    %edx,0x8(%eax)
  802c46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c4c:	89 50 0c             	mov    %edx,0xc(%eax)
  802c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c52:	8b 40 08             	mov    0x8(%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	75 08                	jne    802c61 <alloc_block_FF+0x2f3>
  802c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5c:	a3 18 41 80 00       	mov    %eax,0x804118
  802c61:	a1 20 41 80 00       	mov    0x804120,%eax
  802c66:	40                   	inc    %eax
  802c67:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  802c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6f:	83 c0 10             	add    $0x10,%eax
  802c72:	eb 0c                	jmp    802c80 <alloc_block_FF+0x312>
		 }
		 return NULL;
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
  802c79:	eb 05                	jmp    802c80 <alloc_block_FF+0x312>
	 }
	 return NULL;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
  802c85:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802c88:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802c8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  802c93:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802c9a:	a1 14 41 80 00       	mov    0x804114,%eax
  802c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ca2:	eb 34                	jmp    802cd8 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8a 40 04             	mov    0x4(%eax),%al
  802caa:	84 c0                	test   %al,%al
  802cac:	74 22                	je     802cd0 <alloc_block_BF+0x4e>
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb6:	72 18                	jb     802cd0 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cc0:	73 0e                	jae    802cd0 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  802cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802cd0:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cdc:	74 08                	je     802ce6 <alloc_block_BF+0x64>
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 40 08             	mov    0x8(%eax),%eax
  802ce4:	eb 05                	jmp    802ceb <alloc_block_BF+0x69>
  802ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ceb:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802cf0:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	75 ab                	jne    802ca4 <alloc_block_BF+0x22>
  802cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cfd:	75 a5                	jne    802ca4 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802cff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d03:	0f 84 cb 00 00 00    	je     802dd4 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d18:	0f 86 ae 00 00 00    	jbe    802dcc <alloc_block_BF+0x14a>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	2b 45 08             	sub    0x8(%ebp),%eax
  802d26:	83 f8 0f             	cmp    $0xf,%eax
  802d29:	0f 86 9d 00 00 00    	jbe    802dcc <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	01 d0                	add    %edx,%eax
  802d37:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802d42:	89 c2                	mov    %eax,%edx
  802d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d47:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  802d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 55 08             	mov    0x8(%ebp),%edx
  802d56:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  802d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5c:	74 06                	je     802d64 <alloc_block_BF+0xe2>
  802d5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d62:	75 17                	jne    802d7b <alloc_block_BF+0xf9>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 ec 3e 80 00       	push   $0x803eec
  802d6c:	68 c6 00 00 00       	push   $0xc6
  802d71:	68 d3 3e 80 00       	push   $0x803ed3
  802d76:	e8 81 db ff ff       	call   8008fc <_panic>
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d84:	89 50 08             	mov    %edx,0x8(%eax)
  802d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8a:	8b 40 08             	mov    0x8(%eax),%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	74 0c                	je     802d9d <alloc_block_BF+0x11b>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 08             	mov    0x8(%eax),%eax
  802d97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9a:	89 50 0c             	mov    %edx,0xc(%eax)
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da3:	89 50 08             	mov    %edx,0x8(%eax)
  802da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dac:	89 50 0c             	mov    %edx,0xc(%eax)
  802daf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db2:	8b 40 08             	mov    0x8(%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	75 08                	jne    802dc1 <alloc_block_BF+0x13f>
  802db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbc:	a3 18 41 80 00       	mov    %eax,0x804118
  802dc1:	a1 20 41 80 00       	mov    0x804120,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	83 c0 10             	add    $0x10,%eax
  802dd2:	eb 05                	jmp    802dd9 <alloc_block_BF+0x157>
    }

    return NULL;
  802dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd9:	c9                   	leave  
  802dda:	c3                   	ret    

00802ddb <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
  802dde:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 44 3f 80 00       	push   $0x803f44
  802de9:	68 d2 00 00 00       	push   $0xd2
  802dee:	68 d3 3e 80 00       	push   $0x803ed3
  802df3:	e8 04 db ff ff       	call   8008fc <_panic>

00802df8 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
  802dfb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 6c 3f 80 00       	push   $0x803f6c
  802e06:	68 db 00 00 00       	push   $0xdb
  802e0b:	68 d3 3e 80 00       	push   $0x803ed3
  802e10:	e8 e7 da ff ff       	call   8008fc <_panic>

00802e15 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802e15:	55                   	push   %ebp
  802e16:	89 e5                	mov    %esp,%ebp
  802e18:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1f:	0f 84 d2 01 00 00    	je     802ff7 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	83 e8 10             	sub    $0x10,%eax
  802e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8a 40 04             	mov    0x4(%eax),%al
  802e34:	84 c0                	test   %al,%al
  802e36:	0f 85 be 01 00 00    	jne    802ffa <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 08             	mov    0x8(%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	0f 84 cc 00 00 00    	je     802f1d <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 08             	mov    0x8(%eax),%eax
  802e57:	8a 40 04             	mov    0x4(%eax),%al
  802e5a:	84 c0                	test   %al,%al
  802e5c:	0f 84 bb 00 00 00    	je     802f1d <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 10                	mov    (%eax),%edx
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 08             	mov    0x8(%eax),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	01 c2                	add    %eax,%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 08             	mov    0x8(%eax),%eax
  802e7c:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 08             	mov    0x8(%eax),%eax
  802e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802e95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e99:	75 17                	jne    802eb2 <free_block+0x9d>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 92 3f 80 00       	push   $0x803f92
  802ea3:	68 f8 00 00 00       	push   $0xf8
  802ea8:	68 d3 3e 80 00       	push   $0x803ed3
  802ead:	e8 4a da ff ff       	call   8008fc <_panic>
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 11                	je     802ecd <free_block+0xb8>
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 40 08             	mov    0x8(%eax),%eax
  802ec2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec5:	8b 52 0c             	mov    0xc(%edx),%edx
  802ec8:	89 50 0c             	mov    %edx,0xc(%eax)
  802ecb:	eb 0b                	jmp    802ed8 <free_block+0xc3>
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed3:	a3 18 41 80 00       	mov    %eax,0x804118
  802ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 11                	je     802ef3 <free_block+0xde>
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eeb:	8b 52 08             	mov    0x8(%edx),%edx
  802eee:	89 50 08             	mov    %edx,0x8(%eax)
  802ef1:	eb 0b                	jmp    802efe <free_block+0xe9>
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	a3 14 41 80 00       	mov    %eax,0x804114
  802efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802f12:	a1 20 41 80 00       	mov    0x804120,%eax
  802f17:	48                   	dec    %eax
  802f18:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	0f 84 d0 00 00 00    	je     802ffb <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f31:	8a 40 04             	mov    0x4(%eax),%al
  802f34:	84 c0                	test   %al,%al
  802f36:	0f 84 bf 00 00 00    	je     802ffb <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f45:	8b 52 0c             	mov    0xc(%edx),%edx
  802f48:	8b 0a                	mov    (%edx),%ecx
  802f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4d:	8b 12                	mov    (%edx),%edx
  802f4f:	01 ca                	add    %ecx,%edx
  802f51:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 40 0c             	mov    0xc(%eax),%eax
  802f59:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f71:	75 17                	jne    802f8a <free_block+0x175>
  802f73:	83 ec 04             	sub    $0x4,%esp
  802f76:	68 92 3f 80 00       	push   $0x803f92
  802f7b:	68 03 01 00 00       	push   $0x103
  802f80:	68 d3 3e 80 00       	push   $0x803ed3
  802f85:	e8 72 d9 ff ff       	call   8008fc <_panic>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 40 08             	mov    0x8(%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 11                	je     802fa5 <free_block+0x190>
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 40 08             	mov    0x8(%eax),%eax
  802f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9d:	8b 52 0c             	mov    0xc(%edx),%edx
  802fa0:	89 50 0c             	mov    %edx,0xc(%eax)
  802fa3:	eb 0b                	jmp    802fb0 <free_block+0x19b>
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fab:	a3 18 41 80 00       	mov    %eax,0x804118
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 11                	je     802fcb <free_block+0x1b6>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc3:	8b 52 08             	mov    0x8(%edx),%edx
  802fc6:	89 50 08             	mov    %edx,0x8(%eax)
  802fc9:	eb 0b                	jmp    802fd6 <free_block+0x1c1>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	a3 14 41 80 00       	mov    %eax,0x804114
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fea:	a1 20 41 80 00       	mov    0x804120,%eax
  802fef:	48                   	dec    %eax
  802ff0:	a3 20 41 80 00       	mov    %eax,0x804120
  802ff5:	eb 04                	jmp    802ffb <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802ff7:	90                   	nop
  802ff8:	eb 01                	jmp    802ffb <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802ffa:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
  803000:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  803003:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803007:	75 10                	jne    803019 <realloc_block_FF+0x1c>
  803009:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300d:	75 0a                	jne    803019 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  80300f:	b8 00 00 00 00       	mov    $0x0,%eax
  803014:	e9 2e 03 00 00       	jmp    803347 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  803019:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301d:	75 13                	jne    803032 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  80301f:	83 ec 0c             	sub    $0xc,%esp
  803022:	ff 75 0c             	pushl  0xc(%ebp)
  803025:	e8 44 f9 ff ff       	call   80296e <alloc_block_FF>
  80302a:	83 c4 10             	add    $0x10,%esp
  80302d:	e9 15 03 00 00       	jmp    803347 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  803032:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803036:	75 18                	jne    803050 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  803038:	83 ec 0c             	sub    $0xc,%esp
  80303b:	ff 75 08             	pushl  0x8(%ebp)
  80303e:	e8 d2 fd ff ff       	call   802e15 <free_block>
  803043:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  803046:	b8 00 00 00 00       	mov    $0x0,%eax
  80304b:	e9 f7 02 00 00       	jmp    803347 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	83 e8 10             	sub    $0x10,%eax
  803056:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  803059:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803065:	0f 82 c8 00 00 00    	jb     803133 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803073:	75 08                	jne    80307d <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	e9 ca 02 00 00       	jmp    803347 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	2b 45 0c             	sub    0xc(%ebp),%eax
  803085:	83 f8 0f             	cmp    $0xf,%eax
  803088:	0f 86 9d 00 00 00    	jbe    80312b <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  80308e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803091:	8b 45 0c             	mov    0xc(%ebp),%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030a1:	89 c2                	mov    %eax,%edx
  8030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a6:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ae:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  8030b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bb:	74 06                	je     8030c3 <realloc_block_FF+0xc6>
  8030bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c1:	75 17                	jne    8030da <realloc_block_FF+0xdd>
  8030c3:	83 ec 04             	sub    $0x4,%esp
  8030c6:	68 ec 3e 80 00       	push   $0x803eec
  8030cb:	68 2a 01 00 00       	push   $0x12a
  8030d0:	68 d3 3e 80 00       	push   $0x803ed3
  8030d5:	e8 22 d8 ff ff       	call   8008fc <_panic>
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 50 08             	mov    0x8(%eax),%edx
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	89 50 08             	mov    %edx,0x8(%eax)
  8030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ec:	85 c0                	test   %eax,%eax
  8030ee:	74 0c                	je     8030fc <realloc_block_FF+0xff>
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 08             	mov    0x8(%eax),%eax
  8030f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f9:	89 50 0c             	mov    %edx,0xc(%eax)
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803102:	89 50 08             	mov    %edx,0x8(%eax)
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310b:	89 50 0c             	mov    %edx,0xc(%eax)
  80310e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	75 08                	jne    803120 <realloc_block_FF+0x123>
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	a3 18 41 80 00       	mov    %eax,0x804118
  803120:	a1 20 41 80 00       	mov    0x804120,%eax
  803125:	40                   	inc    %eax
  803126:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	e9 14 02 00 00       	jmp    803347 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 08             	mov    0x8(%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	0f 84 97 01 00 00    	je     8032d8 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	8a 40 04             	mov    0x4(%eax),%al
  80314a:	84 c0                	test   %al,%al
  80314c:	0f 84 86 01 00 00    	je     8032d8 <realloc_block_FF+0x2db>
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 10                	mov    (%eax),%edx
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 40 08             	mov    0x8(%eax),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	01 d0                	add    %edx,%eax
  803161:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803164:	0f 82 6e 01 00 00    	jb     8032d8 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 10                	mov    (%eax),%edx
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 40 08             	mov    0x8(%eax),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	01 c2                	add    %eax,%edx
  803179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317c:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 40 08             	mov    0x8(%eax),%eax
  803184:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 40 08             	mov    0x8(%eax),%eax
  80318e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 40 08             	mov    0x8(%eax),%eax
  80319a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  80319d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031a1:	75 17                	jne    8031ba <realloc_block_FF+0x1bd>
  8031a3:	83 ec 04             	sub    $0x4,%esp
  8031a6:	68 92 3f 80 00       	push   $0x803f92
  8031ab:	68 38 01 00 00       	push   $0x138
  8031b0:	68 d3 3e 80 00       	push   $0x803ed3
  8031b5:	e8 42 d7 ff ff       	call   8008fc <_panic>
  8031ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 11                	je     8031d5 <realloc_block_FF+0x1d8>
  8031c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c7:	8b 40 08             	mov    0x8(%eax),%eax
  8031ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8031d0:	89 50 0c             	mov    %edx,0xc(%eax)
  8031d3:	eb 0b                	jmp    8031e0 <realloc_block_FF+0x1e3>
  8031d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031db:	a3 18 41 80 00       	mov    %eax,0x804118
  8031e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 11                	je     8031fb <realloc_block_FF+0x1fe>
  8031ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031f3:	8b 52 08             	mov    0x8(%edx),%edx
  8031f6:	89 50 08             	mov    %edx,0x8(%eax)
  8031f9:	eb 0b                	jmp    803206 <realloc_block_FF+0x209>
  8031fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
  803201:	a3 14 41 80 00       	mov    %eax,0x804114
  803206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803209:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80321a:	a1 20 41 80 00       	mov    0x804120,%eax
  80321f:	48                   	dec    %eax
  803220:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80322d:	83 f8 0f             	cmp    $0xf,%eax
  803230:	0f 86 9d 00 00 00    	jbe    8032d3 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803236:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323c:	01 d0                	add    %edx,%eax
  80323e:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	2b 45 0c             	sub    0xc(%ebp),%eax
  803249:	89 c2                	mov    %eax,%edx
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  803250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803253:	8b 55 0c             	mov    0xc(%ebp),%edx
  803256:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  80325f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803263:	74 06                	je     80326b <realloc_block_FF+0x26e>
  803265:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803269:	75 17                	jne    803282 <realloc_block_FF+0x285>
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	68 ec 3e 80 00       	push   $0x803eec
  803273:	68 3f 01 00 00       	push   $0x13f
  803278:	68 d3 3e 80 00       	push   $0x803ed3
  80327d:	e8 7a d6 ff ff       	call   8008fc <_panic>
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 50 08             	mov    0x8(%eax),%edx
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	89 50 08             	mov    %edx,0x8(%eax)
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	85 c0                	test   %eax,%eax
  803296:	74 0c                	je     8032a4 <realloc_block_FF+0x2a7>
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	8b 40 08             	mov    0x8(%eax),%eax
  80329e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a1:	89 50 0c             	mov    %edx,0xc(%eax)
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032aa:	89 50 08             	mov    %edx,0x8(%eax)
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b3:	89 50 0c             	mov    %edx,0xc(%eax)
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 08             	mov    0x8(%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	75 08                	jne    8032c8 <realloc_block_FF+0x2cb>
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	a3 18 41 80 00       	mov    %eax,0x804118
  8032c8:	a1 20 41 80 00       	mov    0x804120,%eax
  8032cd:	40                   	inc    %eax
  8032ce:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	eb 6f                	jmp    803347 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  8032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032db:	83 e8 10             	sub    $0x10,%eax
  8032de:	83 ec 0c             	sub    $0xc,%esp
  8032e1:	50                   	push   %eax
  8032e2:	e8 87 f6 ff ff       	call   80296e <alloc_block_FF>
  8032e7:	83 c4 10             	add    $0x10,%esp
  8032ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  8032ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f1:	75 29                	jne    80331c <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  8032f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f6:	83 ec 0c             	sub    $0xc,%esp
  8032f9:	50                   	push   %eax
  8032fa:	e8 98 ea ff ff       	call   801d97 <sbrk>
  8032ff:	83 c4 10             	add    $0x10,%esp
  803302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  803305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803308:	83 f8 ff             	cmp    $0xffffffff,%eax
  80330b:	75 07                	jne    803314 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  80330d:	b8 00 00 00 00       	mov    $0x0,%eax
  803312:	eb 33                	jmp    803347 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  803314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803317:	83 c0 10             	add    $0x10,%eax
  80331a:	eb 2b                	jmp    803347 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	50                   	push   %eax
  803325:	ff 75 f4             	pushl  -0xc(%ebp)
  803328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80332b:	e8 2f e3 ff ff       	call   80165f <memcpy>
  803330:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  803333:	83 ec 0c             	sub    $0xc,%esp
  803336:	ff 75 f4             	pushl  -0xc(%ebp)
  803339:	e8 d7 fa ff ff       	call   802e15 <free_block>
  80333e:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  803341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803344:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  803347:	c9                   	leave  
  803348:	c3                   	ret    
  803349:	66 90                	xchg   %ax,%ax
  80334b:	90                   	nop

0080334c <__udivdi3>:
  80334c:	55                   	push   %ebp
  80334d:	57                   	push   %edi
  80334e:	56                   	push   %esi
  80334f:	53                   	push   %ebx
  803350:	83 ec 1c             	sub    $0x1c,%esp
  803353:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803357:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80335b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80335f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803363:	89 ca                	mov    %ecx,%edx
  803365:	89 f8                	mov    %edi,%eax
  803367:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80336b:	85 f6                	test   %esi,%esi
  80336d:	75 2d                	jne    80339c <__udivdi3+0x50>
  80336f:	39 cf                	cmp    %ecx,%edi
  803371:	77 65                	ja     8033d8 <__udivdi3+0x8c>
  803373:	89 fd                	mov    %edi,%ebp
  803375:	85 ff                	test   %edi,%edi
  803377:	75 0b                	jne    803384 <__udivdi3+0x38>
  803379:	b8 01 00 00 00       	mov    $0x1,%eax
  80337e:	31 d2                	xor    %edx,%edx
  803380:	f7 f7                	div    %edi
  803382:	89 c5                	mov    %eax,%ebp
  803384:	31 d2                	xor    %edx,%edx
  803386:	89 c8                	mov    %ecx,%eax
  803388:	f7 f5                	div    %ebp
  80338a:	89 c1                	mov    %eax,%ecx
  80338c:	89 d8                	mov    %ebx,%eax
  80338e:	f7 f5                	div    %ebp
  803390:	89 cf                	mov    %ecx,%edi
  803392:	89 fa                	mov    %edi,%edx
  803394:	83 c4 1c             	add    $0x1c,%esp
  803397:	5b                   	pop    %ebx
  803398:	5e                   	pop    %esi
  803399:	5f                   	pop    %edi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
  80339c:	39 ce                	cmp    %ecx,%esi
  80339e:	77 28                	ja     8033c8 <__udivdi3+0x7c>
  8033a0:	0f bd fe             	bsr    %esi,%edi
  8033a3:	83 f7 1f             	xor    $0x1f,%edi
  8033a6:	75 40                	jne    8033e8 <__udivdi3+0x9c>
  8033a8:	39 ce                	cmp    %ecx,%esi
  8033aa:	72 0a                	jb     8033b6 <__udivdi3+0x6a>
  8033ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033b0:	0f 87 9e 00 00 00    	ja     803454 <__udivdi3+0x108>
  8033b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bb:	89 fa                	mov    %edi,%edx
  8033bd:	83 c4 1c             	add    $0x1c,%esp
  8033c0:	5b                   	pop    %ebx
  8033c1:	5e                   	pop    %esi
  8033c2:	5f                   	pop    %edi
  8033c3:	5d                   	pop    %ebp
  8033c4:	c3                   	ret    
  8033c5:	8d 76 00             	lea    0x0(%esi),%esi
  8033c8:	31 ff                	xor    %edi,%edi
  8033ca:	31 c0                	xor    %eax,%eax
  8033cc:	89 fa                	mov    %edi,%edx
  8033ce:	83 c4 1c             	add    $0x1c,%esp
  8033d1:	5b                   	pop    %ebx
  8033d2:	5e                   	pop    %esi
  8033d3:	5f                   	pop    %edi
  8033d4:	5d                   	pop    %ebp
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax
  8033d8:	89 d8                	mov    %ebx,%eax
  8033da:	f7 f7                	div    %edi
  8033dc:	31 ff                	xor    %edi,%edi
  8033de:	89 fa                	mov    %edi,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033ed:	89 eb                	mov    %ebp,%ebx
  8033ef:	29 fb                	sub    %edi,%ebx
  8033f1:	89 f9                	mov    %edi,%ecx
  8033f3:	d3 e6                	shl    %cl,%esi
  8033f5:	89 c5                	mov    %eax,%ebp
  8033f7:	88 d9                	mov    %bl,%cl
  8033f9:	d3 ed                	shr    %cl,%ebp
  8033fb:	89 e9                	mov    %ebp,%ecx
  8033fd:	09 f1                	or     %esi,%ecx
  8033ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803403:	89 f9                	mov    %edi,%ecx
  803405:	d3 e0                	shl    %cl,%eax
  803407:	89 c5                	mov    %eax,%ebp
  803409:	89 d6                	mov    %edx,%esi
  80340b:	88 d9                	mov    %bl,%cl
  80340d:	d3 ee                	shr    %cl,%esi
  80340f:	89 f9                	mov    %edi,%ecx
  803411:	d3 e2                	shl    %cl,%edx
  803413:	8b 44 24 08          	mov    0x8(%esp),%eax
  803417:	88 d9                	mov    %bl,%cl
  803419:	d3 e8                	shr    %cl,%eax
  80341b:	09 c2                	or     %eax,%edx
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	89 f2                	mov    %esi,%edx
  803421:	f7 74 24 0c          	divl   0xc(%esp)
  803425:	89 d6                	mov    %edx,%esi
  803427:	89 c3                	mov    %eax,%ebx
  803429:	f7 e5                	mul    %ebp
  80342b:	39 d6                	cmp    %edx,%esi
  80342d:	72 19                	jb     803448 <__udivdi3+0xfc>
  80342f:	74 0b                	je     80343c <__udivdi3+0xf0>
  803431:	89 d8                	mov    %ebx,%eax
  803433:	31 ff                	xor    %edi,%edi
  803435:	e9 58 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803440:	89 f9                	mov    %edi,%ecx
  803442:	d3 e2                	shl    %cl,%edx
  803444:	39 c2                	cmp    %eax,%edx
  803446:	73 e9                	jae    803431 <__udivdi3+0xe5>
  803448:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80344b:	31 ff                	xor    %edi,%edi
  80344d:	e9 40 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  803452:	66 90                	xchg   %ax,%ax
  803454:	31 c0                	xor    %eax,%eax
  803456:	e9 37 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80345b:	90                   	nop

0080345c <__umoddi3>:
  80345c:	55                   	push   %ebp
  80345d:	57                   	push   %edi
  80345e:	56                   	push   %esi
  80345f:	53                   	push   %ebx
  803460:	83 ec 1c             	sub    $0x1c,%esp
  803463:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803467:	8b 74 24 34          	mov    0x34(%esp),%esi
  80346b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80346f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803473:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803477:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80347b:	89 f3                	mov    %esi,%ebx
  80347d:	89 fa                	mov    %edi,%edx
  80347f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803483:	89 34 24             	mov    %esi,(%esp)
  803486:	85 c0                	test   %eax,%eax
  803488:	75 1a                	jne    8034a4 <__umoddi3+0x48>
  80348a:	39 f7                	cmp    %esi,%edi
  80348c:	0f 86 a2 00 00 00    	jbe    803534 <__umoddi3+0xd8>
  803492:	89 c8                	mov    %ecx,%eax
  803494:	89 f2                	mov    %esi,%edx
  803496:	f7 f7                	div    %edi
  803498:	89 d0                	mov    %edx,%eax
  80349a:	31 d2                	xor    %edx,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	39 f0                	cmp    %esi,%eax
  8034a6:	0f 87 ac 00 00 00    	ja     803558 <__umoddi3+0xfc>
  8034ac:	0f bd e8             	bsr    %eax,%ebp
  8034af:	83 f5 1f             	xor    $0x1f,%ebp
  8034b2:	0f 84 ac 00 00 00    	je     803564 <__umoddi3+0x108>
  8034b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034bd:	29 ef                	sub    %ebp,%edi
  8034bf:	89 fe                	mov    %edi,%esi
  8034c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034c5:	89 e9                	mov    %ebp,%ecx
  8034c7:	d3 e0                	shl    %cl,%eax
  8034c9:	89 d7                	mov    %edx,%edi
  8034cb:	89 f1                	mov    %esi,%ecx
  8034cd:	d3 ef                	shr    %cl,%edi
  8034cf:	09 c7                	or     %eax,%edi
  8034d1:	89 e9                	mov    %ebp,%ecx
  8034d3:	d3 e2                	shl    %cl,%edx
  8034d5:	89 14 24             	mov    %edx,(%esp)
  8034d8:	89 d8                	mov    %ebx,%eax
  8034da:	d3 e0                	shl    %cl,%eax
  8034dc:	89 c2                	mov    %eax,%edx
  8034de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e2:	d3 e0                	shl    %cl,%eax
  8034e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ec:	89 f1                	mov    %esi,%ecx
  8034ee:	d3 e8                	shr    %cl,%eax
  8034f0:	09 d0                	or     %edx,%eax
  8034f2:	d3 eb                	shr    %cl,%ebx
  8034f4:	89 da                	mov    %ebx,%edx
  8034f6:	f7 f7                	div    %edi
  8034f8:	89 d3                	mov    %edx,%ebx
  8034fa:	f7 24 24             	mull   (%esp)
  8034fd:	89 c6                	mov    %eax,%esi
  8034ff:	89 d1                	mov    %edx,%ecx
  803501:	39 d3                	cmp    %edx,%ebx
  803503:	0f 82 87 00 00 00    	jb     803590 <__umoddi3+0x134>
  803509:	0f 84 91 00 00 00    	je     8035a0 <__umoddi3+0x144>
  80350f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803513:	29 f2                	sub    %esi,%edx
  803515:	19 cb                	sbb    %ecx,%ebx
  803517:	89 d8                	mov    %ebx,%eax
  803519:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80351d:	d3 e0                	shl    %cl,%eax
  80351f:	89 e9                	mov    %ebp,%ecx
  803521:	d3 ea                	shr    %cl,%edx
  803523:	09 d0                	or     %edx,%eax
  803525:	89 e9                	mov    %ebp,%ecx
  803527:	d3 eb                	shr    %cl,%ebx
  803529:	89 da                	mov    %ebx,%edx
  80352b:	83 c4 1c             	add    $0x1c,%esp
  80352e:	5b                   	pop    %ebx
  80352f:	5e                   	pop    %esi
  803530:	5f                   	pop    %edi
  803531:	5d                   	pop    %ebp
  803532:	c3                   	ret    
  803533:	90                   	nop
  803534:	89 fd                	mov    %edi,%ebp
  803536:	85 ff                	test   %edi,%edi
  803538:	75 0b                	jne    803545 <__umoddi3+0xe9>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	31 d2                	xor    %edx,%edx
  803541:	f7 f7                	div    %edi
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 f0                	mov    %esi,%eax
  803547:	31 d2                	xor    %edx,%edx
  803549:	f7 f5                	div    %ebp
  80354b:	89 c8                	mov    %ecx,%eax
  80354d:	f7 f5                	div    %ebp
  80354f:	89 d0                	mov    %edx,%eax
  803551:	e9 44 ff ff ff       	jmp    80349a <__umoddi3+0x3e>
  803556:	66 90                	xchg   %ax,%ax
  803558:	89 c8                	mov    %ecx,%eax
  80355a:	89 f2                	mov    %esi,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	3b 04 24             	cmp    (%esp),%eax
  803567:	72 06                	jb     80356f <__umoddi3+0x113>
  803569:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80356d:	77 0f                	ja     80357e <__umoddi3+0x122>
  80356f:	89 f2                	mov    %esi,%edx
  803571:	29 f9                	sub    %edi,%ecx
  803573:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803577:	89 14 24             	mov    %edx,(%esp)
  80357a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803582:	8b 14 24             	mov    (%esp),%edx
  803585:	83 c4 1c             	add    $0x1c,%esp
  803588:	5b                   	pop    %ebx
  803589:	5e                   	pop    %esi
  80358a:	5f                   	pop    %edi
  80358b:	5d                   	pop    %ebp
  80358c:	c3                   	ret    
  80358d:	8d 76 00             	lea    0x0(%esi),%esi
  803590:	2b 04 24             	sub    (%esp),%eax
  803593:	19 fa                	sbb    %edi,%edx
  803595:	89 d1                	mov    %edx,%ecx
  803597:	89 c6                	mov    %eax,%esi
  803599:	e9 71 ff ff ff       	jmp    80350f <__umoddi3+0xb3>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035a4:	72 ea                	jb     803590 <__umoddi3+0x134>
  8035a6:	89 d9                	mov    %ebx,%ecx
  8035a8:	e9 62 ff ff ff       	jmp    80350f <__umoddi3+0xb3>
