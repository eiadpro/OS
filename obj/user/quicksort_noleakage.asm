
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
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
  800041:	e8 6e 20 00 00       	call   8020b4 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 34 80 00       	push   $0x803440
  80004e:	e8 e5 09 00 00       	call   800a38 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 34 80 00       	push   $0x803442
  80005e:	e8 d5 09 00 00       	call   800a38 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 5b 34 80 00       	push   $0x80345b
  80006e:	e8 c5 09 00 00       	call   800a38 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 34 80 00       	push   $0x803442
  80007e:	e8 b5 09 00 00       	call   800a38 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 34 80 00       	push   $0x803440
  80008e:	e8 a5 09 00 00       	call   800a38 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 74 34 80 00       	push   $0x803474
  8000a5:	e8 10 10 00 00       	call   8010ba <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 60 15 00 00       	call   801620 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 57 1b 00 00       	call   801c2c <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 94 34 80 00       	push   $0x803494
  8000e3:	e8 50 09 00 00       	call   800a38 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b6 34 80 00       	push   $0x8034b6
  8000f3:	e8 40 09 00 00       	call   800a38 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c4 34 80 00       	push   $0x8034c4
  800103:	e8 30 09 00 00       	call   800a38 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 d3 34 80 00       	push   $0x8034d3
  800113:	e8 20 09 00 00       	call   800a38 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 e3 34 80 00       	push   $0x8034e3
  800123:	e8 10 09 00 00       	call   800a38 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 67 1f 00 00       	call   8020ce <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
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
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 da 1e 00 00       	call   8020b4 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ec 34 80 00       	push   $0x8034ec
  8001e2:	e8 51 08 00 00       	call   800a38 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 df 1e 00 00       	call   8020ce <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 20 35 80 00       	push   $0x803520
  800211:	6a 49                	push   $0x49
  800213:	68 42 35 80 00       	push   $0x803542
  800218:	e8 5e 05 00 00       	call   80077b <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 92 1e 00 00       	call   8020b4 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 60 35 80 00       	push   $0x803560
  80022a:	e8 09 08 00 00       	call   800a38 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 94 35 80 00       	push   $0x803594
  80023a:	e8 f9 07 00 00       	call   800a38 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 c8 35 80 00       	push   $0x8035c8
  80024a:	e8 e9 07 00 00       	call   800a38 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 77 1e 00 00       	call   8020ce <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 2a 1b 00 00       	call   801d8c <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 4a 1e 00 00       	call   8020b4 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 fa 35 80 00       	push   $0x8035fa
  800272:	e8 c1 07 00 00       	call   800a38 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 2a 1e 00 00       	call   8020ce <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 40 34 80 00       	push   $0x803440
  800549:	e8 ea 04 00 00       	call   800a38 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 18 36 80 00       	push   $0x803618
  80056b:	e8 c8 04 00 00       	call   800a38 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 1d 36 80 00       	push   $0x80361d
  800599:	e8 9a 04 00 00       	call   800a38 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 2b 1b 00 00       	call   8020e8 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 e6 1a 00 00       	call   8020b4 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 07 1b 00 00       	call   8020e8 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 e5 1a 00 00       	call   8020ce <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 84 19 00 00       	call   801f84 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 9b 1a 00 00       	call   8020b4 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 5d 19 00 00       	call   801f84 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 99 1a 00 00       	call   8020ce <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 58 1c 00 00       	call   8022a7 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 40 80 00       	mov    0x804024,%eax
  80067b:	8a 40 5c             	mov    0x5c(%eax),%al
  80067e:	84 c0                	test   %al,%al
  800680:	74 0d                	je     80068f <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800682:	a1 24 40 80 00       	mov    0x804024,%eax
  800687:	83 c0 5c             	add    $0x5c,%eax
  80068a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80068f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800693:	7e 0a                	jle    80069f <libmain+0x5b>
		binaryname = argv[0];
  800695:	8b 45 0c             	mov    0xc(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	ff 75 08             	pushl  0x8(%ebp)
  8006a8:	e8 8b f9 ff ff       	call   800038 <_main>
  8006ad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b0:	e8 ff 19 00 00       	call   8020b4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	68 3c 36 80 00       	push   $0x80363c
  8006bd:	e8 76 03 00 00       	call   800a38 <cprintf>
  8006c2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006c5:	a1 24 40 80 00       	mov    0x804024,%eax
  8006ca:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  8006d0:	a1 24 40 80 00       	mov    0x804024,%eax
  8006d5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	52                   	push   %edx
  8006df:	50                   	push   %eax
  8006e0:	68 64 36 80 00       	push   $0x803664
  8006e5:	e8 4e 03 00 00       	call   800a38 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006ed:	a1 24 40 80 00       	mov    0x804024,%eax
  8006f2:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  8006f8:	a1 24 40 80 00       	mov    0x804024,%eax
  8006fd:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  800703:	a1 24 40 80 00       	mov    0x804024,%eax
  800708:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  80070e:	51                   	push   %ecx
  80070f:	52                   	push   %edx
  800710:	50                   	push   %eax
  800711:	68 8c 36 80 00       	push   $0x80368c
  800716:	e8 1d 03 00 00       	call   800a38 <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80071e:	a1 24 40 80 00       	mov    0x804024,%eax
  800723:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	50                   	push   %eax
  80072d:	68 e4 36 80 00       	push   $0x8036e4
  800732:	e8 01 03 00 00       	call   800a38 <cprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	68 3c 36 80 00       	push   $0x80363c
  800742:	e8 f1 02 00 00       	call   800a38 <cprintf>
  800747:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074a:	e8 7f 19 00 00       	call   8020ce <sys_enable_interrupt>

	// exit gracefully
	exit();
  80074f:	e8 19 00 00 00       	call   80076d <exit>
}
  800754:	90                   	nop
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80075d:	83 ec 0c             	sub    $0xc,%esp
  800760:	6a 00                	push   $0x0
  800762:	e8 0c 1b 00 00       	call   802273 <sys_destroy_env>
  800767:	83 c4 10             	add    $0x10,%esp
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <exit>:

void
exit(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800773:	e8 61 1b 00 00       	call   8022d9 <sys_exit_env>
}
  800778:	90                   	nop
  800779:	c9                   	leave  
  80077a:	c3                   	ret    

0080077b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800781:	8d 45 10             	lea    0x10(%ebp),%eax
  800784:	83 c0 04             	add    $0x4,%eax
  800787:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078a:	a1 2c 41 80 00       	mov    0x80412c,%eax
  80078f:	85 c0                	test   %eax,%eax
  800791:	74 16                	je     8007a9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800793:	a1 2c 41 80 00       	mov    0x80412c,%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	50                   	push   %eax
  80079c:	68 f8 36 80 00       	push   $0x8036f8
  8007a1:	e8 92 02 00 00       	call   800a38 <cprintf>
  8007a6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007a9:	a1 00 40 80 00       	mov    0x804000,%eax
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	50                   	push   %eax
  8007b5:	68 fd 36 80 00       	push   $0x8036fd
  8007ba:	e8 79 02 00 00       	call   800a38 <cprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	e8 fc 01 00 00       	call   8009cd <vcprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	68 19 37 80 00       	push   $0x803719
  8007de:	e8 ea 01 00 00       	call   8009cd <vcprintf>
  8007e3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007e6:	e8 82 ff ff ff       	call   80076d <exit>

	// should not return here
	while (1) ;
  8007eb:	eb fe                	jmp    8007eb <_panic+0x70>

008007ed <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f3:	a1 24 40 80 00       	mov    0x804024,%eax
  8007f8:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	39 c2                	cmp    %eax,%edx
  800803:	74 14                	je     800819 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	68 1c 37 80 00       	push   $0x80371c
  80080d:	6a 26                	push   $0x26
  80080f:	68 68 37 80 00       	push   $0x803768
  800814:	e8 62 ff ff ff       	call   80077b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800820:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800827:	e9 c5 00 00 00       	jmp    8008f1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	75 08                	jne    800849 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800841:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800844:	e9 a5 00 00 00       	jmp    8008ee <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800850:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800857:	eb 69                	jmp    8008c2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800859:	a1 24 40 80 00       	mov    0x804024,%eax
  80085e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800864:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800867:	89 d0                	mov    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	c1 e0 03             	shl    $0x3,%eax
  800870:	01 c8                	add    %ecx,%eax
  800872:	8a 40 04             	mov    0x4(%eax),%al
  800875:	84 c0                	test   %al,%al
  800877:	75 46                	jne    8008bf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800879:	a1 24 40 80 00       	mov    0x804024,%eax
  80087e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800884:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800887:	89 d0                	mov    %edx,%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	01 d0                	add    %edx,%eax
  80088d:	c1 e0 03             	shl    $0x3,%eax
  800890:	01 c8                	add    %ecx,%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80089f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b2:	39 c2                	cmp    %eax,%edx
  8008b4:	75 09                	jne    8008bf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bd:	eb 15                	jmp    8008d4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008bf:	ff 45 e8             	incl   -0x18(%ebp)
  8008c2:	a1 24 40 80 00       	mov    0x804024,%eax
  8008c7:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  8008cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008d0:	39 c2                	cmp    %eax,%edx
  8008d2:	77 85                	ja     800859 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d8:	75 14                	jne    8008ee <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008da:	83 ec 04             	sub    $0x4,%esp
  8008dd:	68 74 37 80 00       	push   $0x803774
  8008e2:	6a 3a                	push   $0x3a
  8008e4:	68 68 37 80 00       	push   $0x803768
  8008e9:	e8 8d fe ff ff       	call   80077b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ee:	ff 45 f0             	incl   -0x10(%ebp)
  8008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f7:	0f 8c 2f ff ff ff    	jl     80082c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800904:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090b:	eb 26                	jmp    800933 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090d:	a1 24 40 80 00       	mov    0x804024,%eax
  800912:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	01 c0                	add    %eax,%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	c1 e0 03             	shl    $0x3,%eax
  800924:	01 c8                	add    %ecx,%eax
  800926:	8a 40 04             	mov    0x4(%eax),%al
  800929:	3c 01                	cmp    $0x1,%al
  80092b:	75 03                	jne    800930 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80092d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800930:	ff 45 e0             	incl   -0x20(%ebp)
  800933:	a1 24 40 80 00       	mov    0x804024,%eax
  800938:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  80093e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800941:	39 c2                	cmp    %eax,%edx
  800943:	77 c8                	ja     80090d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800948:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80094b:	74 14                	je     800961 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80094d:	83 ec 04             	sub    $0x4,%esp
  800950:	68 c8 37 80 00       	push   $0x8037c8
  800955:	6a 44                	push   $0x44
  800957:	68 68 37 80 00       	push   $0x803768
  80095c:	e8 1a fe ff ff       	call   80077b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800961:	90                   	nop
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 48 01             	lea    0x1(%eax),%ecx
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
  800975:	89 0a                	mov    %ecx,(%edx)
  800977:	8b 55 08             	mov    0x8(%ebp),%edx
  80097a:	88 d1                	mov    %dl,%cl
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	3d ff 00 00 00       	cmp    $0xff,%eax
  80098d:	75 2c                	jne    8009bb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098f:	a0 28 40 80 00       	mov    0x804028,%al
  800994:	0f b6 c0             	movzbl %al,%eax
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	8b 12                	mov    (%edx),%edx
  80099c:	89 d1                	mov    %edx,%ecx
  80099e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a1:	83 c2 08             	add    $0x8,%edx
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	50                   	push   %eax
  8009a8:	51                   	push   %ecx
  8009a9:	52                   	push   %edx
  8009aa:	e8 ac 15 00 00       	call   801f5b <sys_cputs>
  8009af:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 40 04             	mov    0x4(%eax),%eax
  8009c1:	8d 50 01             	lea    0x1(%eax),%edx
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ca:	90                   	nop
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009dd:	00 00 00 
	b.cnt = 0;
  8009e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f6:	50                   	push   %eax
  8009f7:	68 64 09 80 00       	push   $0x800964
  8009fc:	e8 11 02 00 00       	call   800c12 <vprintfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a04:	a0 28 40 80 00       	mov    0x804028,%al
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a12:	83 ec 04             	sub    $0x4,%esp
  800a15:	50                   	push   %eax
  800a16:	52                   	push   %edx
  800a17:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a1d:	83 c0 08             	add    $0x8,%eax
  800a20:	50                   	push   %eax
  800a21:	e8 35 15 00 00       	call   801f5b <sys_cputs>
  800a26:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a29:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800a30:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    

00800a38 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3e:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 73 ff ff ff       	call   8009cd <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a6b:	e8 44 16 00 00       	call   8020b4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a70:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7f:	50                   	push   %eax
  800a80:	e8 48 ff ff ff       	call   8009cd <vcprintf>
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a8b:	e8 3e 16 00 00       	call   8020ce <sys_enable_interrupt>
	return cnt;
  800a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	53                   	push   %ebx
  800a99:	83 ec 14             	sub    $0x14,%esp
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa8:	8b 45 18             	mov    0x18(%ebp),%eax
  800aab:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab3:	77 55                	ja     800b0a <printnum+0x75>
  800ab5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab8:	72 05                	jb     800abf <printnum+0x2a>
  800aba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800abd:	77 4b                	ja     800b0a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ac2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  800acd:	52                   	push   %edx
  800ace:	50                   	push   %eax
  800acf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad5:	e8 ee 26 00 00       	call   8031c8 <__udivdi3>
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	83 ec 04             	sub    $0x4,%esp
  800ae0:	ff 75 20             	pushl  0x20(%ebp)
  800ae3:	53                   	push   %ebx
  800ae4:	ff 75 18             	pushl  0x18(%ebp)
  800ae7:	52                   	push   %edx
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 a1 ff ff ff       	call   800a95 <printnum>
  800af4:	83 c4 20             	add    $0x20,%esp
  800af7:	eb 1a                	jmp    800b13 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 20             	pushl  0x20(%ebp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b0a:	ff 4d 1c             	decl   0x1c(%ebp)
  800b0d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b11:	7f e6                	jg     800af9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b13:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b21:	53                   	push   %ebx
  800b22:	51                   	push   %ecx
  800b23:	52                   	push   %edx
  800b24:	50                   	push   %eax
  800b25:	e8 ae 27 00 00       	call   8032d8 <__umoddi3>
  800b2a:	83 c4 10             	add    $0x10,%esp
  800b2d:	05 34 3a 80 00       	add    $0x803a34,%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	0f be c0             	movsbl %al,%eax
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
}
  800b46:	90                   	nop
  800b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b53:	7e 1c                	jle    800b71 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 08             	lea    0x8(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 08             	sub    $0x8,%eax
  800b6a:	8b 50 04             	mov    0x4(%eax),%edx
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	eb 40                	jmp    800bb1 <getuint+0x65>
	else if (lflag)
  800b71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b75:	74 1e                	je     800b95 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	8d 50 04             	lea    0x4(%eax),%edx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 10                	mov    %edx,(%eax)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	eb 1c                	jmp    800bb1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	8d 50 04             	lea    0x4(%eax),%edx
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	89 10                	mov    %edx,(%eax)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	83 e8 04             	sub    $0x4,%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bba:	7e 1c                	jle    800bd8 <getint+0x25>
		return va_arg(*ap, long long);
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	8d 50 08             	lea    0x8(%eax),%edx
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	89 10                	mov    %edx,(%eax)
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	83 e8 08             	sub    $0x8,%eax
  800bd1:	8b 50 04             	mov    0x4(%eax),%edx
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	eb 38                	jmp    800c10 <getint+0x5d>
	else if (lflag)
  800bd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdc:	74 1a                	je     800bf8 <getint+0x45>
		return va_arg(*ap, long);
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	8d 50 04             	lea    0x4(%eax),%edx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 10                	mov    %edx,(%eax)
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	83 e8 04             	sub    $0x4,%eax
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	99                   	cltd   
  800bf6:	eb 18                	jmp    800c10 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 50 04             	lea    0x4(%eax),%edx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	89 10                	mov    %edx,(%eax)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	83 e8 04             	sub    $0x4,%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	99                   	cltd   
}
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	56                   	push   %esi
  800c16:	53                   	push   %ebx
  800c17:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c1a:	eb 17                	jmp    800c33 <vprintfmt+0x21>
			if (ch == '\0')
  800c1c:	85 db                	test   %ebx,%ebx
  800c1e:	0f 84 af 03 00 00    	je     800fd3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	53                   	push   %ebx
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	0f b6 d8             	movzbl %al,%ebx
  800c41:	83 fb 25             	cmp    $0x25,%ebx
  800c44:	75 d6                	jne    800c1c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c46:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c4a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c51:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c58:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	8d 50 01             	lea    0x1(%eax),%edx
  800c6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 d8             	movzbl %al,%ebx
  800c74:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c77:	83 f8 55             	cmp    $0x55,%eax
  800c7a:	0f 87 2b 03 00 00    	ja     800fab <vprintfmt+0x399>
  800c80:	8b 04 85 58 3a 80 00 	mov    0x803a58(,%eax,4),%eax
  800c87:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c89:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c8d:	eb d7                	jmp    800c66 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c93:	eb d1                	jmp    800c66 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c95:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9f:	89 d0                	mov    %edx,%eax
  800ca1:	c1 e0 02             	shl    $0x2,%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	01 c0                	add    %eax,%eax
  800ca8:	01 d8                	add    %ebx,%eax
  800caa:	83 e8 30             	sub    $0x30,%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb8:	83 fb 2f             	cmp    $0x2f,%ebx
  800cbb:	7e 3e                	jle    800cfb <vprintfmt+0xe9>
  800cbd:	83 fb 39             	cmp    $0x39,%ebx
  800cc0:	7f 39                	jg     800cfb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc5:	eb d5                	jmp    800c9c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	83 c0 04             	add    $0x4,%eax
  800ccd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd3:	83 e8 04             	sub    $0x4,%eax
  800cd6:	8b 00                	mov    (%eax),%eax
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cdb:	eb 1f                	jmp    800cfc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ce1:	79 83                	jns    800c66 <vprintfmt+0x54>
				width = 0;
  800ce3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cea:	e9 77 ff ff ff       	jmp    800c66 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cef:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf6:	e9 6b ff ff ff       	jmp    800c66 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cfb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d00:	0f 89 60 ff ff ff    	jns    800c66 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d0c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d13:	e9 4e ff ff ff       	jmp    800c66 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d18:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d1b:	e9 46 ff ff ff       	jmp    800c66 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d20:	8b 45 14             	mov    0x14(%ebp),%eax
  800d23:	83 c0 04             	add    $0x4,%eax
  800d26:	89 45 14             	mov    %eax,0x14(%ebp)
  800d29:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2c:	83 e8 04             	sub    $0x4,%eax
  800d2f:	8b 00                	mov    (%eax),%eax
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	50                   	push   %eax
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	ff d0                	call   *%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
			break;
  800d40:	e9 89 02 00 00       	jmp    800fce <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	83 c0 04             	add    $0x4,%eax
  800d4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d51:	83 e8 04             	sub    $0x4,%eax
  800d54:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d56:	85 db                	test   %ebx,%ebx
  800d58:	79 02                	jns    800d5c <vprintfmt+0x14a>
				err = -err;
  800d5a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d5c:	83 fb 64             	cmp    $0x64,%ebx
  800d5f:	7f 0b                	jg     800d6c <vprintfmt+0x15a>
  800d61:	8b 34 9d a0 38 80 00 	mov    0x8038a0(,%ebx,4),%esi
  800d68:	85 f6                	test   %esi,%esi
  800d6a:	75 19                	jne    800d85 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d6c:	53                   	push   %ebx
  800d6d:	68 45 3a 80 00       	push   $0x803a45
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	ff 75 08             	pushl  0x8(%ebp)
  800d78:	e8 5e 02 00 00       	call   800fdb <printfmt>
  800d7d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d80:	e9 49 02 00 00       	jmp    800fce <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d85:	56                   	push   %esi
  800d86:	68 4e 3a 80 00       	push   $0x803a4e
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	ff 75 08             	pushl  0x8(%ebp)
  800d91:	e8 45 02 00 00       	call   800fdb <printfmt>
  800d96:	83 c4 10             	add    $0x10,%esp
			break;
  800d99:	e9 30 02 00 00       	jmp    800fce <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800da1:	83 c0 04             	add    $0x4,%eax
  800da4:	89 45 14             	mov    %eax,0x14(%ebp)
  800da7:	8b 45 14             	mov    0x14(%ebp),%eax
  800daa:	83 e8 04             	sub    $0x4,%eax
  800dad:	8b 30                	mov    (%eax),%esi
  800daf:	85 f6                	test   %esi,%esi
  800db1:	75 05                	jne    800db8 <vprintfmt+0x1a6>
				p = "(null)";
  800db3:	be 51 3a 80 00       	mov    $0x803a51,%esi
			if (width > 0 && padc != '-')
  800db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbc:	7e 6d                	jle    800e2b <vprintfmt+0x219>
  800dbe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dc2:	74 67                	je     800e2b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	50                   	push   %eax
  800dcb:	56                   	push   %esi
  800dcc:	e8 12 05 00 00       	call   8012e3 <strnlen>
  800dd1:	83 c4 10             	add    $0x10,%esp
  800dd4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd7:	eb 16                	jmp    800def <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ddd:	83 ec 08             	sub    $0x8,%esp
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	50                   	push   %eax
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dec:	ff 4d e4             	decl   -0x1c(%ebp)
  800def:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df3:	7f e4                	jg     800dd9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df5:	eb 34                	jmp    800e2b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dfb:	74 1c                	je     800e19 <vprintfmt+0x207>
  800dfd:	83 fb 1f             	cmp    $0x1f,%ebx
  800e00:	7e 05                	jle    800e07 <vprintfmt+0x1f5>
  800e02:	83 fb 7e             	cmp    $0x7e,%ebx
  800e05:	7e 12                	jle    800e19 <vprintfmt+0x207>
					putch('?', putdat);
  800e07:	83 ec 08             	sub    $0x8,%esp
  800e0a:	ff 75 0c             	pushl  0xc(%ebp)
  800e0d:	6a 3f                	push   $0x3f
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	ff d0                	call   *%eax
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	eb 0f                	jmp    800e28 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e19:	83 ec 08             	sub    $0x8,%esp
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	53                   	push   %ebx
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	ff d0                	call   *%eax
  800e25:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e28:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2b:	89 f0                	mov    %esi,%eax
  800e2d:	8d 70 01             	lea    0x1(%eax),%esi
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
  800e35:	85 db                	test   %ebx,%ebx
  800e37:	74 24                	je     800e5d <vprintfmt+0x24b>
  800e39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e3d:	78 b8                	js     800df7 <vprintfmt+0x1e5>
  800e3f:	ff 4d e0             	decl   -0x20(%ebp)
  800e42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e46:	79 af                	jns    800df7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e48:	eb 13                	jmp    800e5d <vprintfmt+0x24b>
				putch(' ', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 20                	push   $0x20
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e61:	7f e7                	jg     800e4a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e63:	e9 66 01 00 00       	jmp    800fce <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e71:	50                   	push   %eax
  800e72:	e8 3c fd ff ff       	call   800bb3 <getint>
  800e77:	83 c4 10             	add    $0x10,%esp
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e86:	85 d2                	test   %edx,%edx
  800e88:	79 23                	jns    800ead <vprintfmt+0x29b>
				putch('-', putdat);
  800e8a:	83 ec 08             	sub    $0x8,%esp
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	6a 2d                	push   $0x2d
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	ff d0                	call   *%eax
  800e97:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	f7 d8                	neg    %eax
  800ea2:	83 d2 00             	adc    $0x0,%edx
  800ea5:	f7 da                	neg    %edx
  800ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eaa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ead:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb4:	e9 bc 00 00 00       	jmp    800f75 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec2:	50                   	push   %eax
  800ec3:	e8 84 fc ff ff       	call   800b4c <getuint>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ece:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ed1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed8:	e9 98 00 00 00       	jmp    800f75 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800edd:	83 ec 08             	sub    $0x8,%esp
  800ee0:	ff 75 0c             	pushl  0xc(%ebp)
  800ee3:	6a 58                	push   $0x58
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	ff d0                	call   *%eax
  800eea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 0c             	pushl  0xc(%ebp)
  800ef3:	6a 58                	push   $0x58
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	ff d0                	call   *%eax
  800efa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efd:	83 ec 08             	sub    $0x8,%esp
  800f00:	ff 75 0c             	pushl  0xc(%ebp)
  800f03:	6a 58                	push   $0x58
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	ff d0                	call   *%eax
  800f0a:	83 c4 10             	add    $0x10,%esp
			break;
  800f0d:	e9 bc 00 00 00       	jmp    800fce <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	ff 75 0c             	pushl  0xc(%ebp)
  800f18:	6a 30                	push   $0x30
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	ff d0                	call   *%eax
  800f1f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	6a 78                	push   $0x78
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff d0                	call   *%eax
  800f2f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f32:	8b 45 14             	mov    0x14(%ebp),%eax
  800f35:	83 c0 04             	add    $0x4,%eax
  800f38:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	83 e8 04             	sub    $0x4,%eax
  800f41:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f54:	eb 1f                	jmp    800f75 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	ff 75 e8             	pushl  -0x18(%ebp)
  800f5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5f:	50                   	push   %eax
  800f60:	e8 e7 fb ff ff       	call   800b4c <getuint>
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f75:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f7c:	83 ec 04             	sub    $0x4,%esp
  800f7f:	52                   	push   %edx
  800f80:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f83:	50                   	push   %eax
  800f84:	ff 75 f4             	pushl  -0xc(%ebp)
  800f87:	ff 75 f0             	pushl  -0x10(%ebp)
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	ff 75 08             	pushl  0x8(%ebp)
  800f90:	e8 00 fb ff ff       	call   800a95 <printnum>
  800f95:	83 c4 20             	add    $0x20,%esp
			break;
  800f98:	eb 34                	jmp    800fce <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	53                   	push   %ebx
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	ff d0                	call   *%eax
  800fa6:	83 c4 10             	add    $0x10,%esp
			break;
  800fa9:	eb 23                	jmp    800fce <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 25                	push   $0x25
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fbb:	ff 4d 10             	decl   0x10(%ebp)
  800fbe:	eb 03                	jmp    800fc3 <vprintfmt+0x3b1>
  800fc0:	ff 4d 10             	decl   0x10(%ebp)
  800fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc6:	48                   	dec    %eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 25                	cmp    $0x25,%al
  800fcb:	75 f3                	jne    800fc0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fcd:	90                   	nop
		}
	}
  800fce:	e9 47 fc ff ff       	jmp    800c1a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fd3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fe1:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe4:	83 c0 04             	add    $0x4,%eax
  800fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fea:	8b 45 10             	mov    0x10(%ebp),%eax
  800fed:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff0:	50                   	push   %eax
  800ff1:	ff 75 0c             	pushl  0xc(%ebp)
  800ff4:	ff 75 08             	pushl  0x8(%ebp)
  800ff7:	e8 16 fc ff ff       	call   800c12 <vprintfmt>
  800ffc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fff:	90                   	nop
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8b 40 08             	mov    0x8(%eax),%eax
  80100b:	8d 50 01             	lea    0x1(%eax),%edx
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8b 10                	mov    (%eax),%edx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8b 40 04             	mov    0x4(%eax),%eax
  80101f:	39 c2                	cmp    %eax,%edx
  801021:	73 12                	jae    801035 <sprintputch+0x33>
		*b->buf++ = ch;
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8b 00                	mov    (%eax),%eax
  801028:	8d 48 01             	lea    0x1(%eax),%ecx
  80102b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102e:	89 0a                	mov    %ecx,(%edx)
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	88 10                	mov    %dl,(%eax)
}
  801035:	90                   	nop
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801052:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801059:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105d:	74 06                	je     801065 <vsnprintf+0x2d>
  80105f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801063:	7f 07                	jg     80106c <vsnprintf+0x34>
		return -E_INVAL;
  801065:	b8 03 00 00 00       	mov    $0x3,%eax
  80106a:	eb 20                	jmp    80108c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80106c:	ff 75 14             	pushl  0x14(%ebp)
  80106f:	ff 75 10             	pushl  0x10(%ebp)
  801072:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801075:	50                   	push   %eax
  801076:	68 02 10 80 00       	push   $0x801002
  80107b:	e8 92 fb ff ff       	call   800c12 <vprintfmt>
  801080:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801083:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801086:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801089:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801094:	8d 45 10             	lea    0x10(%ebp),%eax
  801097:	83 c0 04             	add    $0x4,%eax
  80109a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a3:	50                   	push   %eax
  8010a4:	ff 75 0c             	pushl  0xc(%ebp)
  8010a7:	ff 75 08             	pushl  0x8(%ebp)
  8010aa:	e8 89 ff ff ff       	call   801038 <vsnprintf>
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c4:	74 13                	je     8010d9 <readline+0x1f>
		cprintf("%s", prompt);
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	ff 75 08             	pushl  0x8(%ebp)
  8010cc:	68 b0 3b 80 00       	push   $0x803bb0
  8010d1:	e8 62 f9 ff ff       	call   800a38 <cprintf>
  8010d6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010e0:	83 ec 0c             	sub    $0xc,%esp
  8010e3:	6a 00                	push   $0x0
  8010e5:	e8 50 f5 ff ff       	call   80063a <iscons>
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010f0:	e8 f7 f4 ff ff       	call   8005ec <getchar>
  8010f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010fc:	79 22                	jns    801120 <readline+0x66>
			if (c != -E_EOF)
  8010fe:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801102:	0f 84 ad 00 00 00    	je     8011b5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801108:	83 ec 08             	sub    $0x8,%esp
  80110b:	ff 75 ec             	pushl  -0x14(%ebp)
  80110e:	68 b3 3b 80 00       	push   $0x803bb3
  801113:	e8 20 f9 ff ff       	call   800a38 <cprintf>
  801118:	83 c4 10             	add    $0x10,%esp
			return;
  80111b:	e9 95 00 00 00       	jmp    8011b5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801120:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801124:	7e 34                	jle    80115a <readline+0xa0>
  801126:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80112d:	7f 2b                	jg     80115a <readline+0xa0>
			if (echoing)
  80112f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801133:	74 0e                	je     801143 <readline+0x89>
				cputchar(c);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	ff 75 ec             	pushl  -0x14(%ebp)
  80113b:	e8 64 f4 ff ff       	call   8005a4 <cputchar>
  801140:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801146:	8d 50 01             	lea    0x1(%eax),%edx
  801149:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80114c:	89 c2                	mov    %eax,%edx
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	01 d0                	add    %edx,%eax
  801153:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801156:	88 10                	mov    %dl,(%eax)
  801158:	eb 56                	jmp    8011b0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80115a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115e:	75 1f                	jne    80117f <readline+0xc5>
  801160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801164:	7e 19                	jle    80117f <readline+0xc5>
			if (echoing)
  801166:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80116a:	74 0e                	je     80117a <readline+0xc0>
				cputchar(c);
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	ff 75 ec             	pushl  -0x14(%ebp)
  801172:	e8 2d f4 ff ff       	call   8005a4 <cputchar>
  801177:	83 c4 10             	add    $0x10,%esp

			i--;
  80117a:	ff 4d f4             	decl   -0xc(%ebp)
  80117d:	eb 31                	jmp    8011b0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801183:	74 0a                	je     80118f <readline+0xd5>
  801185:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801189:	0f 85 61 ff ff ff    	jne    8010f0 <readline+0x36>
			if (echoing)
  80118f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801193:	74 0e                	je     8011a3 <readline+0xe9>
				cputchar(c);
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	ff 75 ec             	pushl  -0x14(%ebp)
  80119b:	e8 04 f4 ff ff       	call   8005a4 <cputchar>
  8011a0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011ae:	eb 06                	jmp    8011b6 <readline+0xfc>
		}
	}
  8011b0:	e9 3b ff ff ff       	jmp    8010f0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b5:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011be:	e8 f1 0e 00 00       	call   8020b4 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c7:	74 13                	je     8011dc <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	68 b0 3b 80 00       	push   $0x803bb0
  8011d4:	e8 5f f8 ff ff       	call   800a38 <cprintf>
  8011d9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 4d f4 ff ff       	call   80063a <iscons>
  8011ed:	83 c4 10             	add    $0x10,%esp
  8011f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011f3:	e8 f4 f3 ff ff       	call   8005ec <getchar>
  8011f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011ff:	79 23                	jns    801224 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801201:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801205:	74 13                	je     80121a <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	ff 75 ec             	pushl  -0x14(%ebp)
  80120d:	68 b3 3b 80 00       	push   $0x803bb3
  801212:	e8 21 f8 ff ff       	call   800a38 <cprintf>
  801217:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80121a:	e8 af 0e 00 00       	call   8020ce <sys_enable_interrupt>
			return;
  80121f:	e9 9a 00 00 00       	jmp    8012be <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801224:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801228:	7e 34                	jle    80125e <atomic_readline+0xa6>
  80122a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801231:	7f 2b                	jg     80125e <atomic_readline+0xa6>
			if (echoing)
  801233:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801237:	74 0e                	je     801247 <atomic_readline+0x8f>
				cputchar(c);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	ff 75 ec             	pushl  -0x14(%ebp)
  80123f:	e8 60 f3 ff ff       	call   8005a4 <cputchar>
  801244:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	8d 50 01             	lea    0x1(%eax),%edx
  80124d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801250:	89 c2                	mov    %eax,%edx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125a:	88 10                	mov    %dl,(%eax)
  80125c:	eb 5b                	jmp    8012b9 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801262:	75 1f                	jne    801283 <atomic_readline+0xcb>
  801264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801268:	7e 19                	jle    801283 <atomic_readline+0xcb>
			if (echoing)
  80126a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126e:	74 0e                	je     80127e <atomic_readline+0xc6>
				cputchar(c);
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	ff 75 ec             	pushl  -0x14(%ebp)
  801276:	e8 29 f3 ff ff       	call   8005a4 <cputchar>
  80127b:	83 c4 10             	add    $0x10,%esp
			i--;
  80127e:	ff 4d f4             	decl   -0xc(%ebp)
  801281:	eb 36                	jmp    8012b9 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801283:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801287:	74 0a                	je     801293 <atomic_readline+0xdb>
  801289:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80128d:	0f 85 60 ff ff ff    	jne    8011f3 <atomic_readline+0x3b>
			if (echoing)
  801293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801297:	74 0e                	je     8012a7 <atomic_readline+0xef>
				cputchar(c);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	ff 75 ec             	pushl  -0x14(%ebp)
  80129f:	e8 00 f3 ff ff       	call   8005a4 <cputchar>
  8012a4:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012b2:	e8 17 0e 00 00       	call   8020ce <sys_enable_interrupt>
			return;
  8012b7:	eb 05                	jmp    8012be <atomic_readline+0x106>
		}
	}
  8012b9:	e9 35 ff ff ff       	jmp    8011f3 <atomic_readline+0x3b>
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cd:	eb 06                	jmp    8012d5 <strlen+0x15>
		n++;
  8012cf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d2:	ff 45 08             	incl   0x8(%ebp)
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	84 c0                	test   %al,%al
  8012dc:	75 f1                	jne    8012cf <strlen+0xf>
		n++;
	return n;
  8012de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f0:	eb 09                	jmp    8012fb <strnlen+0x18>
		n++;
  8012f2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f5:	ff 45 08             	incl   0x8(%ebp)
  8012f8:	ff 4d 0c             	decl   0xc(%ebp)
  8012fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ff:	74 09                	je     80130a <strnlen+0x27>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	84 c0                	test   %al,%al
  801308:	75 e8                	jne    8012f2 <strnlen+0xf>
		n++;
	return n;
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80131b:	90                   	nop
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8d 50 01             	lea    0x1(%eax),%edx
  801322:	89 55 08             	mov    %edx,0x8(%ebp)
  801325:	8b 55 0c             	mov    0xc(%ebp),%edx
  801328:	8d 4a 01             	lea    0x1(%edx),%ecx
  80132b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132e:	8a 12                	mov    (%edx),%dl
  801330:	88 10                	mov    %dl,(%eax)
  801332:	8a 00                	mov    (%eax),%al
  801334:	84 c0                	test   %al,%al
  801336:	75 e4                	jne    80131c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801350:	eb 1f                	jmp    801371 <strncpy+0x34>
		*dst++ = *src;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 08             	mov    %edx,0x8(%ebp)
  80135b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135e:	8a 12                	mov    (%edx),%dl
  801360:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	84 c0                	test   %al,%al
  801369:	74 03                	je     80136e <strncpy+0x31>
			src++;
  80136b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136e:	ff 45 fc             	incl   -0x4(%ebp)
  801371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801374:	3b 45 10             	cmp    0x10(%ebp),%eax
  801377:	72 d9                	jb     801352 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80138a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138e:	74 30                	je     8013c0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801390:	eb 16                	jmp    8013a8 <strlcpy+0x2a>
			*dst++ = *src++;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8d 50 01             	lea    0x1(%eax),%edx
  801398:	89 55 08             	mov    %edx,0x8(%ebp)
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a4:	8a 12                	mov    (%edx),%dl
  8013a6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a8:	ff 4d 10             	decl   0x10(%ebp)
  8013ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013af:	74 09                	je     8013ba <strlcpy+0x3c>
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 d8                	jne    801392 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c6:	29 c2                	sub    %eax,%edx
  8013c8:	89 d0                	mov    %edx,%eax
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cf:	eb 06                	jmp    8013d7 <strcmp+0xb>
		p++, q++;
  8013d1:	ff 45 08             	incl   0x8(%ebp)
  8013d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	84 c0                	test   %al,%al
  8013de:	74 0e                	je     8013ee <strcmp+0x22>
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 10                	mov    (%eax),%dl
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	38 c2                	cmp    %al,%dl
  8013ec:	74 e3                	je     8013d1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f b6 d0             	movzbl %al,%edx
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f b6 c0             	movzbl %al,%eax
  8013fe:	29 c2                	sub    %eax,%edx
  801400:	89 d0                	mov    %edx,%eax
}
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801407:	eb 09                	jmp    801412 <strncmp+0xe>
		n--, p++, q++;
  801409:	ff 4d 10             	decl   0x10(%ebp)
  80140c:	ff 45 08             	incl   0x8(%ebp)
  80140f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801412:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801416:	74 17                	je     80142f <strncmp+0x2b>
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	84 c0                	test   %al,%al
  80141f:	74 0e                	je     80142f <strncmp+0x2b>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 10                	mov    (%eax),%dl
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	38 c2                	cmp    %al,%dl
  80142d:	74 da                	je     801409 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801433:	75 07                	jne    80143c <strncmp+0x38>
		return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	eb 14                	jmp    801450 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	0f b6 d0             	movzbl %al,%edx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	0f b6 c0             	movzbl %al,%eax
  80144c:	29 c2                	sub    %eax,%edx
  80144e:	89 d0                	mov    %edx,%eax
}
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    

00801452 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145e:	eb 12                	jmp    801472 <strchr+0x20>
		if (*s == c)
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801468:	75 05                	jne    80146f <strchr+0x1d>
			return (char *) s;
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	eb 11                	jmp    801480 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	84 c0                	test   %al,%al
  801479:	75 e5                	jne    801460 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80147b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148e:	eb 0d                	jmp    80149d <strfind+0x1b>
		if (*s == c)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801498:	74 0e                	je     8014a8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80149a:	ff 45 08             	incl   0x8(%ebp)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	84 c0                	test   %al,%al
  8014a4:	75 ea                	jne    801490 <strfind+0xe>
  8014a6:	eb 01                	jmp    8014a9 <strfind+0x27>
		if (*s == c)
			break;
  8014a8:	90                   	nop
	return (char *) s;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014c0:	eb 0e                	jmp    8014d0 <memset+0x22>
		*p++ = c;
  8014c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c5:	8d 50 01             	lea    0x1(%eax),%edx
  8014c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014d0:	ff 4d f8             	decl   -0x8(%ebp)
  8014d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d7:	79 e9                	jns    8014c2 <memset+0x14>
		*p++ = c;

	return v;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014f0:	eb 16                	jmp    801508 <memcpy+0x2a>
		*d++ = *s++;
  8014f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801501:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801504:	8a 12                	mov    (%edx),%dl
  801506:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801508:	8b 45 10             	mov    0x10(%ebp),%eax
  80150b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150e:	89 55 10             	mov    %edx,0x10(%ebp)
  801511:	85 c0                	test   %eax,%eax
  801513:	75 dd                	jne    8014f2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801520:	8b 45 0c             	mov    0xc(%ebp),%eax
  801523:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801532:	73 50                	jae    801584 <memmove+0x6a>
  801534:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801537:	8b 45 10             	mov    0x10(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	76 43                	jbe    801584 <memmove+0x6a>
		s += n;
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80154d:	eb 10                	jmp    80155f <memmove+0x45>
			*--d = *--s;
  80154f:	ff 4d f8             	decl   -0x8(%ebp)
  801552:	ff 4d fc             	decl   -0x4(%ebp)
  801555:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801558:	8a 10                	mov    (%eax),%dl
  80155a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155f:	8b 45 10             	mov    0x10(%ebp),%eax
  801562:	8d 50 ff             	lea    -0x1(%eax),%edx
  801565:	89 55 10             	mov    %edx,0x10(%ebp)
  801568:	85 c0                	test   %eax,%eax
  80156a:	75 e3                	jne    80154f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80156c:	eb 23                	jmp    801591 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801571:	8d 50 01             	lea    0x1(%eax),%edx
  801574:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801577:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80157d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801580:	8a 12                	mov    (%edx),%dl
  801582:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801584:	8b 45 10             	mov    0x10(%ebp),%eax
  801587:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158a:	89 55 10             	mov    %edx,0x10(%ebp)
  80158d:	85 c0                	test   %eax,%eax
  80158f:	75 dd                	jne    80156e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a8:	eb 2a                	jmp    8015d4 <memcmp+0x3e>
		if (*s1 != *s2)
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	8a 10                	mov    (%eax),%dl
  8015af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	38 c2                	cmp    %al,%dl
  8015b6:	74 16                	je     8015ce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bb:	8a 00                	mov    (%eax),%al
  8015bd:	0f b6 d0             	movzbl %al,%edx
  8015c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	0f b6 c0             	movzbl %al,%eax
  8015c8:	29 c2                	sub    %eax,%edx
  8015ca:	89 d0                	mov    %edx,%eax
  8015cc:	eb 18                	jmp    8015e6 <memcmp+0x50>
		s1++, s2++;
  8015ce:	ff 45 fc             	incl   -0x4(%ebp)
  8015d1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015da:	89 55 10             	mov    %edx,0x10(%ebp)
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	75 c9                	jne    8015aa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f9:	eb 15                	jmp    801610 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	0f b6 d0             	movzbl %al,%edx
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	0f b6 c0             	movzbl %al,%eax
  801609:	39 c2                	cmp    %eax,%edx
  80160b:	74 0d                	je     80161a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80160d:	ff 45 08             	incl   0x8(%ebp)
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801616:	72 e3                	jb     8015fb <memfind+0x13>
  801618:	eb 01                	jmp    80161b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80161a:	90                   	nop
	return (void *) s;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801626:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80162d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801634:	eb 03                	jmp    801639 <strtol+0x19>
		s++;
  801636:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	3c 20                	cmp    $0x20,%al
  801640:	74 f4                	je     801636 <strtol+0x16>
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 09                	cmp    $0x9,%al
  801649:	74 eb                	je     801636 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 2b                	cmp    $0x2b,%al
  801652:	75 05                	jne    801659 <strtol+0x39>
		s++;
  801654:	ff 45 08             	incl   0x8(%ebp)
  801657:	eb 13                	jmp    80166c <strtol+0x4c>
	else if (*s == '-')
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	3c 2d                	cmp    $0x2d,%al
  801660:	75 0a                	jne    80166c <strtol+0x4c>
		s++, neg = 1;
  801662:	ff 45 08             	incl   0x8(%ebp)
  801665:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80166c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801670:	74 06                	je     801678 <strtol+0x58>
  801672:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801676:	75 20                	jne    801698 <strtol+0x78>
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8a 00                	mov    (%eax),%al
  80167d:	3c 30                	cmp    $0x30,%al
  80167f:	75 17                	jne    801698 <strtol+0x78>
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	40                   	inc    %eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	3c 78                	cmp    $0x78,%al
  801689:	75 0d                	jne    801698 <strtol+0x78>
		s += 2, base = 16;
  80168b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801696:	eb 28                	jmp    8016c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801698:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80169c:	75 15                	jne    8016b3 <strtol+0x93>
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	3c 30                	cmp    $0x30,%al
  8016a5:	75 0c                	jne    8016b3 <strtol+0x93>
		s++, base = 8;
  8016a7:	ff 45 08             	incl   0x8(%ebp)
  8016aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016b1:	eb 0d                	jmp    8016c0 <strtol+0xa0>
	else if (base == 0)
  8016b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b7:	75 07                	jne    8016c0 <strtol+0xa0>
		base = 10;
  8016b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	3c 2f                	cmp    $0x2f,%al
  8016c7:	7e 19                	jle    8016e2 <strtol+0xc2>
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	3c 39                	cmp    $0x39,%al
  8016d0:	7f 10                	jg     8016e2 <strtol+0xc2>
			dig = *s - '0';
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	0f be c0             	movsbl %al,%eax
  8016da:	83 e8 30             	sub    $0x30,%eax
  8016dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e0:	eb 42                	jmp    801724 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	3c 60                	cmp    $0x60,%al
  8016e9:	7e 19                	jle    801704 <strtol+0xe4>
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	3c 7a                	cmp    $0x7a,%al
  8016f2:	7f 10                	jg     801704 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	0f be c0             	movsbl %al,%eax
  8016fc:	83 e8 57             	sub    $0x57,%eax
  8016ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801702:	eb 20                	jmp    801724 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 40                	cmp    $0x40,%al
  80170b:	7e 39                	jle    801746 <strtol+0x126>
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	3c 5a                	cmp    $0x5a,%al
  801714:	7f 30                	jg     801746 <strtol+0x126>
			dig = *s - 'A' + 10;
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f be c0             	movsbl %al,%eax
  80171e:	83 e8 37             	sub    $0x37,%eax
  801721:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801727:	3b 45 10             	cmp    0x10(%ebp),%eax
  80172a:	7d 19                	jge    801745 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801732:	0f af 45 10          	imul   0x10(%ebp),%eax
  801736:	89 c2                	mov    %eax,%edx
  801738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173b:	01 d0                	add    %edx,%eax
  80173d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801740:	e9 7b ff ff ff       	jmp    8016c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801745:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801746:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174a:	74 08                	je     801754 <strtol+0x134>
		*endptr = (char *) s;
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	8b 55 08             	mov    0x8(%ebp),%edx
  801752:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801754:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801758:	74 07                	je     801761 <strtol+0x141>
  80175a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175d:	f7 d8                	neg    %eax
  80175f:	eb 03                	jmp    801764 <strtol+0x144>
  801761:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <ltostr>:

void
ltostr(long value, char *str)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80176c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801773:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80177a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177e:	79 13                	jns    801793 <ltostr+0x2d>
	{
		neg = 1;
  801780:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80178d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801790:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80179b:	99                   	cltd   
  80179c:	f7 f9                	idiv   %ecx
  80179e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a4:	8d 50 01             	lea    0x1(%eax),%edx
  8017a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017aa:	89 c2                	mov    %eax,%edx
  8017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b4:	83 c2 30             	add    $0x30,%edx
  8017b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017c1:	f7 e9                	imul   %ecx
  8017c3:	c1 fa 02             	sar    $0x2,%edx
  8017c6:	89 c8                	mov    %ecx,%eax
  8017c8:	c1 f8 1f             	sar    $0x1f,%eax
  8017cb:	29 c2                	sub    %eax,%edx
  8017cd:	89 d0                	mov    %edx,%eax
  8017cf:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017da:	f7 e9                	imul   %ecx
  8017dc:	c1 fa 02             	sar    $0x2,%edx
  8017df:	89 c8                	mov    %ecx,%eax
  8017e1:	c1 f8 1f             	sar    $0x1f,%eax
  8017e4:	29 c2                	sub    %eax,%edx
  8017e6:	89 d0                	mov    %edx,%eax
  8017e8:	c1 e0 02             	shl    $0x2,%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	01 c0                	add    %eax,%eax
  8017ef:	29 c1                	sub    %eax,%ecx
  8017f1:	89 ca                	mov    %ecx,%edx
  8017f3:	85 d2                	test   %edx,%edx
  8017f5:	75 9c                	jne    801793 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801801:	48                   	dec    %eax
  801802:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801805:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801809:	74 3d                	je     801848 <ltostr+0xe2>
		start = 1 ;
  80180b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801812:	eb 34                	jmp    801848 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801814:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 c2                	add    %eax,%edx
  801829:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80182c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182f:	01 c8                	add    %ecx,%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801835:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	01 c2                	add    %eax,%edx
  80183d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801840:	88 02                	mov    %al,(%edx)
		start++ ;
  801842:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801845:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184e:	7c c4                	jl     801814 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801850:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	01 d0                	add    %edx,%eax
  801858:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	e8 54 fa ff ff       	call   8012c0 <strlen>
  80186c:	83 c4 04             	add    $0x4,%esp
  80186f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	e8 46 fa ff ff       	call   8012c0 <strlen>
  80187a:	83 c4 04             	add    $0x4,%esp
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801880:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801887:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188e:	eb 17                	jmp    8018a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801890:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801893:	8b 45 10             	mov    0x10(%ebp),%eax
  801896:	01 c2                	add    %eax,%edx
  801898:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	01 c8                	add    %ecx,%eax
  8018a0:	8a 00                	mov    (%eax),%al
  8018a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a4:	ff 45 fc             	incl   -0x4(%ebp)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ad:	7c e1                	jl     801890 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018bd:	eb 1f                	jmp    8018de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c2:	8d 50 01             	lea    0x1(%eax),%edx
  8018c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c8:	89 c2                	mov    %eax,%edx
  8018ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cd:	01 c2                	add    %eax,%edx
  8018cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d5:	01 c8                	add    %ecx,%eax
  8018d7:	8a 00                	mov    (%eax),%al
  8018d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018db:	ff 45 f8             	incl   -0x8(%ebp)
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e4:	7c d9                	jl     8018bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ec:	01 d0                	add    %edx,%eax
  8018ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8018f1:	90                   	nop
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801900:	8b 45 14             	mov    0x14(%ebp),%eax
  801903:	8b 00                	mov    (%eax),%eax
  801905:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	01 d0                	add    %edx,%eax
  801911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801917:	eb 0c                	jmp    801925 <strsplit+0x31>
			*string++ = 0;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8d 50 01             	lea    0x1(%eax),%edx
  80191f:	89 55 08             	mov    %edx,0x8(%ebp)
  801922:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 18                	je     801946 <strsplit+0x52>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 13 fb ff ff       	call   801452 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	75 d3                	jne    801919 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	8a 00                	mov    (%eax),%al
  80194b:	84 c0                	test   %al,%al
  80194d:	74 5a                	je     8019a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194f:	8b 45 14             	mov    0x14(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	83 f8 0f             	cmp    $0xf,%eax
  801957:	75 07                	jne    801960 <strsplit+0x6c>
		{
			return 0;
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
  80195e:	eb 66                	jmp    8019c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801960:	8b 45 14             	mov    0x14(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 48 01             	lea    0x1(%eax),%ecx
  801968:	8b 55 14             	mov    0x14(%ebp),%edx
  80196b:	89 0a                	mov    %ecx,(%edx)
  80196d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801974:	8b 45 10             	mov    0x10(%ebp),%eax
  801977:	01 c2                	add    %eax,%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197e:	eb 03                	jmp    801983 <strsplit+0x8f>
			string++;
  801980:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	84 c0                	test   %al,%al
  80198a:	74 8b                	je     801917 <strsplit+0x23>
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	50                   	push   %eax
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	e8 b5 fa ff ff       	call   801452 <strchr>
  80199d:	83 c4 08             	add    $0x8,%esp
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	74 dc                	je     801980 <strsplit+0x8c>
			string++;
	}
  8019a4:	e9 6e ff ff ff       	jmp    801917 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ad:	8b 00                	mov    (%eax),%eax
  8019af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  8019ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019d5:	eb 4c                	jmp    801a23 <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  8019d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dd:	01 d0                	add    %edx,%eax
  8019df:	8a 00                	mov    (%eax),%al
  8019e1:	3c 40                	cmp    $0x40,%al
  8019e3:	7e 27                	jle    801a0c <str2lower+0x44>
  8019e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019eb:	01 d0                	add    %edx,%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	3c 5a                	cmp    $0x5a,%al
  8019f1:	7f 19                	jg     801a0c <str2lower+0x44>
	      dst[i] = src[i] + 32;
  8019f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	01 d0                	add    %edx,%eax
  8019fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a01:	01 ca                	add    %ecx,%edx
  801a03:	8a 12                	mov    (%edx),%dl
  801a05:	83 c2 20             	add    $0x20,%edx
  801a08:	88 10                	mov    %dl,(%eax)
  801a0a:	eb 14                	jmp    801a20 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801a0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	01 c2                	add    %eax,%edx
  801a14:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1a:	01 c8                	add    %ecx,%eax
  801a1c:	8a 00                	mov    (%eax),%al
  801a1e:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801a20:	ff 45 fc             	incl   -0x4(%ebp)
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	e8 95 f8 ff ff       	call   8012c0 <strlen>
  801a2b:	83 c4 04             	add    $0x4,%esp
  801a2e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a31:	7f a4                	jg     8019d7 <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801a46:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4e:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801a55:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  801a64:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a69:	40                   	inc    %eax
  801a6a:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801a6f:	90                   	nop
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    

00801a72 <searchElement>:

int searchElement(uint32 start) {
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801a78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a7f:	eb 17                	jmp    801a98 <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a84:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801a8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a8e:	75 05                	jne    801a95 <searchElement+0x23>
			return i;
  801a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a93:	eb 12                	jmp    801aa7 <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801a95:	ff 45 fc             	incl   -0x4(%ebp)
  801a98:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801a9d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801aa0:	7c df                	jl     801a81 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <removeElement>:
void removeElement(uint32 start) {
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	e8 bb ff ff ff       	call   801a72 <searchElement>
  801ab7:	83 c4 04             	add    $0x4,%esp
  801aba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ac3:	eb 26                	jmp    801aeb <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	40                   	inc    %eax
  801ac9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801acc:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801ad3:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801ada:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801ae1:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801ae8:	ff 45 fc             	incl   -0x4(%ebp)
  801aeb:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801af0:	48                   	dec    %eax
  801af1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801af4:	7f cf                	jg     801ac5 <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801af6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801afb:	48                   	dec    %eax
  801afc:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <searchfree>:
int searchfree(uint32 end)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b11:	eb 17                	jmp    801b2a <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b16:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801b1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b20:	75 05                	jne    801b27 <searchfree+0x23>
			return i;
  801b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b25:	eb 12                	jmp    801b39 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801b27:	ff 45 fc             	incl   -0x4(%ebp)
  801b2a:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b2f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801b32:	7c df                	jl     801b13 <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <removefree>:
void removefree(uint32 end)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  801b41:	eb 52                	jmp    801b95 <removefree+0x5a>
		int index = searchfree(end);
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	e8 b9 ff ff ff       	call   801b04 <searchfree>
  801b4b:	83 c4 04             	add    $0x4,%esp
  801b4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  801b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801b57:	eb 26                	jmp    801b7f <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5c:	40                   	inc    %eax
  801b5d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b60:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801b67:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801b6e:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801b75:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801b7c:	ff 45 fc             	incl   -0x4(%ebp)
  801b7f:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b84:	48                   	dec    %eax
  801b85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b88:	7f cf                	jg     801b59 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801b8a:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801b8f:	48                   	dec    %eax
  801b90:	a3 2c 40 80 00       	mov    %eax,0x80402c
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	e8 67 ff ff ff       	call   801b04 <searchfree>
  801b9d:	83 c4 04             	add    $0x4,%esp
  801ba0:	83 f8 ff             	cmp    $0xffffffff,%eax
  801ba3:	75 9e                	jne    801b43 <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <printArray>:
void printArray() {
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	68 c4 3b 80 00       	push   $0x803bc4
  801bb6:	e8 7d ee ff ff       	call   800a38 <cprintf>
  801bbb:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801bc5:	eb 29                	jmp    801bf0 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801be0:	68 d5 3b 80 00       	push   $0x803bd5
  801be5:	e8 4e ee ff ff       	call   800a38 <cprintf>
  801bea:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801bed:	ff 45 f4             	incl   -0xc(%ebp)
  801bf0:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bf5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801bf8:	7c cd                	jl     801bc7 <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801bfa:	90                   	nop
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801c00:	a1 04 40 80 00       	mov    0x804004,%eax
  801c05:	85 c0                	test   %eax,%eax
  801c07:	74 0a                	je     801c13 <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c09:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801c10:	00 00 00 
	}
}
  801c13:	90                   	nop
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    

00801c16 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 4f 09 00 00       	call   802576 <sys_sbrk>
  801c27:	83 c4 10             	add    $0x10,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c32:	e8 c6 ff ff ff       	call   801bfd <InitializeUHeap>
	if (size == 0) return NULL ;
  801c37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c3b:	75 0a                	jne    801c47 <malloc+0x1b>
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	e9 43 01 00 00       	jmp    801d8a <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c47:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c4e:	77 3c                	ja     801c8c <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c50:	e8 c3 07 00 00       	call   802418 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c55:	85 c0                	test   %eax,%eax
  801c57:	74 13                	je     801c6c <malloc+0x40>
			return alloc_block_FF(size);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 89 0b 00 00       	call   8027ed <alloc_block_FF>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	e9 1e 01 00 00       	jmp    801d8a <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801c6c:	e8 d8 07 00 00       	call   802449 <sys_isUHeapPlacementStrategyBESTFIT>
  801c71:	85 c0                	test   %eax,%eax
  801c73:	0f 84 0c 01 00 00    	je     801d85 <malloc+0x159>
			return alloc_block_BF(size);
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	e8 7d 0e 00 00       	call   802b01 <alloc_block_BF>
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	e9 fe 00 00 00       	jmp    801d8a <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801c8c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c93:	8b 55 08             	mov    0x8(%ebp),%edx
  801c96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	48                   	dec    %eax
  801c9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	f7 75 e0             	divl   -0x20(%ebp)
  801caa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cad:	29 d0                	sub    %edx,%eax
  801caf:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	c1 e8 0c             	shr    $0xc,%eax
  801cb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801cbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801cc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801cc9:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801cd0:	e8 f4 08 00 00       	call   8025c9 <sys_hard_limit>
  801cd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801cd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cdb:	05 00 10 00 00       	add    $0x1000,%eax
  801ce0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ce3:	eb 49                	jmp    801d2e <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	ff 75 e8             	pushl  -0x18(%ebp)
  801ceb:	e8 82 fd ff ff       	call   801a72 <searchElement>
  801cf0:	83 c4 10             	add    $0x10,%esp
  801cf3:	83 f8 ff             	cmp    $0xffffffff,%eax
  801cf6:	75 28                	jne    801d20 <malloc+0xf4>
			{


				count++;
  801cf8:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfe:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d01:	75 24                	jne    801d27 <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801d03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d06:	05 00 10 00 00       	add    $0x1000,%eax
  801d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	c1 e0 0c             	shl    $0xc,%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	29 d0                	sub    %edx,%eax
  801d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801d1e:	eb 17                	jmp    801d37 <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801d20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801d27:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801d2e:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801d35:	76 ae                	jbe    801ce5 <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801d37:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801d3b:	75 07                	jne    801d44 <malloc+0x118>
		{
			return NULL;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d42:	eb 46                	jmp    801d8a <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4a:	eb 1a                	jmp    801d66 <malloc+0x13a>
		{
			addElement(i,end);
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d52:	83 ec 08             	sub    $0x8,%esp
  801d55:	52                   	push   %edx
  801d56:	50                   	push   %eax
  801d57:	e8 e7 fc ff ff       	call   801a43 <addElement>
  801d5c:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801d5f:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d6c:	7c de                	jl     801d4c <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d71:	83 ec 08             	sub    $0x8,%esp
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	50                   	push   %eax
  801d78:	e8 30 08 00 00       	call   8025ad <sys_allocate_user_mem>
  801d7d:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d83:	eb 05                	jmp    801d8a <malloc+0x15e>
	}
	return NULL;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801d92:	e8 32 08 00 00       	call   8025c9 <sys_hard_limit>
  801d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	0f 89 82 00 00 00    	jns    801e27 <free+0x9b>
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801dad:	77 78                	ja     801e27 <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801db5:	73 10                	jae    801dc7 <free+0x3b>
			free_block(virtual_address);
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	e8 d2 0e 00 00       	call   802c94 <free_block>
  801dc2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801dc5:	eb 77                	jmp    801e3e <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	50                   	push   %eax
  801dce:	e8 9f fc ff ff       	call   801a72 <searchElement>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddc:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de6:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801ded:	29 c2                	sub    %eax,%edx
  801def:	89 d0                	mov    %edx,%eax
  801df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df7:	c1 e8 0c             	shr    $0xc,%eax
  801dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	ff 75 ec             	pushl  -0x14(%ebp)
  801e06:	50                   	push   %eax
  801e07:	e8 85 07 00 00       	call   802591 <sys_free_user_mem>
  801e0c:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e12:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	50                   	push   %eax
  801e1d:	e8 19 fd ff ff       	call   801b3b <removefree>
  801e22:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801e25:	eb 17                	jmp    801e3e <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	68 ee 3b 80 00       	push   $0x803bee
  801e2f:	68 ac 00 00 00       	push   $0xac
  801e34:	68 fe 3b 80 00       	push   $0x803bfe
  801e39:	e8 3d e9 ff ff       	call   80077b <_panic>
	}
}
  801e3e:	90                   	nop
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
  801e47:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4d:	e8 ab fd ff ff       	call   801bfd <InitializeUHeap>
	if (size == 0) return NULL ;
  801e52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e56:	75 07                	jne    801e5f <smalloc+0x1e>
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	eb 17                	jmp    801e76 <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	68 0c 3c 80 00       	push   $0x803c0c
  801e67:	68 bc 00 00 00       	push   $0xbc
  801e6c:	68 fe 3b 80 00       	push   $0x803bfe
  801e71:	e8 05 e9 ff ff       	call   80077b <_panic>
	return NULL;
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e7e:	e8 7a fd ff ff       	call   801bfd <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	68 34 3c 80 00       	push   $0x803c34
  801e8b:	68 ca 00 00 00       	push   $0xca
  801e90:	68 fe 3b 80 00       	push   $0x803bfe
  801e95:	e8 e1 e8 ff ff       	call   80077b <_panic>

00801e9a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ea0:	e8 58 fd ff ff       	call   801bfd <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 58 3c 80 00       	push   $0x803c58
  801ead:	68 ea 00 00 00       	push   $0xea
  801eb2:	68 fe 3b 80 00       	push   $0x803bfe
  801eb7:	e8 bf e8 ff ff       	call   80077b <_panic>

00801ebc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	68 80 3c 80 00       	push   $0x803c80
  801eca:	68 fe 00 00 00       	push   $0xfe
  801ecf:	68 fe 3b 80 00       	push   $0x803bfe
  801ed4:	e8 a2 e8 ff ff       	call   80077b <_panic>

00801ed9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 a4 3c 80 00       	push   $0x803ca4
  801ee7:	68 08 01 00 00       	push   $0x108
  801eec:	68 fe 3b 80 00       	push   $0x803bfe
  801ef1:	e8 85 e8 ff ff       	call   80077b <_panic>

00801ef6 <shrink>:

}
void shrink(uint32 newSize)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	68 a4 3c 80 00       	push   $0x803ca4
  801f04:	68 0d 01 00 00       	push   $0x10d
  801f09:	68 fe 3b 80 00       	push   $0x803bfe
  801f0e:	e8 68 e8 ff ff       	call   80077b <_panic>

00801f13 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	68 a4 3c 80 00       	push   $0x803ca4
  801f21:	68 12 01 00 00       	push   $0x112
  801f26:	68 fe 3b 80 00       	push   $0x803bfe
  801f2b:	e8 4b e8 ff ff       	call   80077b <_panic>

00801f30 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	57                   	push   %edi
  801f34:	56                   	push   %esi
  801f35:	53                   	push   %ebx
  801f36:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f45:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f48:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f4b:	cd 30                	int    $0x30
  801f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5f                   	pop    %edi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	8b 45 10             	mov    0x10(%ebp),%eax
  801f64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f67:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	52                   	push   %edx
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	50                   	push   %eax
  801f77:	6a 00                	push   $0x0
  801f79:	e8 b2 ff ff ff       	call   801f30 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	90                   	nop
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 01                	push   $0x1
  801f93:	e8 98 ff ff ff       	call   801f30 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 05                	push   $0x5
  801fb0:	e8 7b ff ff ff       	call   801f30 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	56                   	push   %esi
  801fbe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fbf:	8b 75 18             	mov    0x18(%ebp),%esi
  801fc2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	51                   	push   %ecx
  801fd1:	52                   	push   %edx
  801fd2:	50                   	push   %eax
  801fd3:	6a 06                	push   $0x6
  801fd5:	e8 56 ff ff ff       	call   801f30 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    

00801fe4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 07                	push   $0x7
  801ff7:	e8 34 ff ff ff       	call   801f30 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	6a 08                	push   $0x8
  802012:	e8 19 ff ff ff       	call   801f30 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 09                	push   $0x9
  80202b:	e8 00 ff ff ff       	call   801f30 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 0a                	push   $0xa
  802044:	e8 e7 fe ff ff       	call   801f30 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 0b                	push   $0xb
  80205d:	e8 ce fe ff ff       	call   801f30 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 0c                	push   $0xc
  802076:	e8 b5 fe ff ff       	call   801f30 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	ff 75 08             	pushl  0x8(%ebp)
  80208e:	6a 0d                	push   $0xd
  802090:	e8 9b fe ff ff       	call   801f30 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 0e                	push   $0xe
  8020a9:	e8 82 fe ff ff       	call   801f30 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	90                   	nop
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 11                	push   $0x11
  8020c3:	e8 68 fe ff ff       	call   801f30 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	90                   	nop
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 12                	push   $0x12
  8020dd:	e8 4e fe ff ff       	call   801f30 <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	90                   	nop
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	50                   	push   %eax
  802101:	6a 13                	push   $0x13
  802103:	e8 28 fe ff ff       	call   801f30 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 14                	push   $0x14
  80211d:	e8 0e fe ff ff       	call   801f30 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	90                   	nop
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	ff 75 0c             	pushl  0xc(%ebp)
  802137:	50                   	push   %eax
  802138:	6a 15                	push   $0x15
  80213a:	e8 f1 fd ff ff       	call   801f30 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	52                   	push   %edx
  802154:	50                   	push   %eax
  802155:	6a 18                	push   $0x18
  802157:	e8 d4 fd ff ff       	call   801f30 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802164:	8b 55 0c             	mov    0xc(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	6a 16                	push   $0x16
  802174:	e8 b7 fd ff ff       	call   801f30 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	90                   	nop
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	52                   	push   %edx
  80218f:	50                   	push   %eax
  802190:	6a 17                	push   $0x17
  802192:	e8 99 fd ff ff       	call   801f30 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	90                   	nop
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021a9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	51                   	push   %ecx
  8021b6:	52                   	push   %edx
  8021b7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ba:	50                   	push   %eax
  8021bb:	6a 19                	push   $0x19
  8021bd:	e8 6e fd ff ff       	call   801f30 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	52                   	push   %edx
  8021d7:	50                   	push   %eax
  8021d8:	6a 1a                	push   $0x1a
  8021da:	e8 51 fd ff ff       	call   801f30 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	51                   	push   %ecx
  8021f5:	52                   	push   %edx
  8021f6:	50                   	push   %eax
  8021f7:	6a 1b                	push   $0x1b
  8021f9:	e8 32 fd ff ff       	call   801f30 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802206:	8b 55 0c             	mov    0xc(%ebp),%edx
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	52                   	push   %edx
  802213:	50                   	push   %eax
  802214:	6a 1c                	push   $0x1c
  802216:	e8 15 fd ff ff       	call   801f30 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 1d                	push   $0x1d
  80222f:	e8 fc fc ff ff       	call   801f30 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	6a 00                	push   $0x0
  802241:	ff 75 14             	pushl  0x14(%ebp)
  802244:	ff 75 10             	pushl  0x10(%ebp)
  802247:	ff 75 0c             	pushl  0xc(%ebp)
  80224a:	50                   	push   %eax
  80224b:	6a 1e                	push   $0x1e
  80224d:	e8 de fc ff ff       	call   801f30 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	50                   	push   %eax
  802266:	6a 1f                	push   $0x1f
  802268:	e8 c3 fc ff ff       	call   801f30 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	90                   	nop
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	50                   	push   %eax
  802282:	6a 20                	push   $0x20
  802284:	e8 a7 fc ff ff       	call   801f30 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 02                	push   $0x2
  80229d:	e8 8e fc ff ff       	call   801f30 <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 03                	push   $0x3
  8022b6:	e8 75 fc ff ff       	call   801f30 <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 04                	push   $0x4
  8022cf:	e8 5c fc ff ff       	call   801f30 <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_exit_env>:


void sys_exit_env(void)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 21                	push   $0x21
  8022e8:	e8 43 fc ff ff       	call   801f30 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022fc:	8d 50 04             	lea    0x4(%eax),%edx
  8022ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 22                	push   $0x22
  80230c:	e8 1f fc ff ff       	call   801f30 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
	return result;
  802314:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231d:	89 01                	mov    %eax,(%ecx)
  80231f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	c9                   	leave  
  802326:	c2 04 00             	ret    $0x4

00802329 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	ff 75 10             	pushl  0x10(%ebp)
  802333:	ff 75 0c             	pushl  0xc(%ebp)
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	6a 10                	push   $0x10
  80233b:	e8 f0 fb ff ff       	call   801f30 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
	return ;
  802343:	90                   	nop
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_rcr2>:
uint32 sys_rcr2()
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 23                	push   $0x23
  802355:	e8 d6 fb ff ff       	call   801f30 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80236b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	50                   	push   %eax
  802378:	6a 24                	push   $0x24
  80237a:	e8 b1 fb ff ff       	call   801f30 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
	return ;
  802382:	90                   	nop
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <rsttst>:
void rsttst()
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 26                	push   $0x26
  802394:	e8 97 fb ff ff       	call   801f30 <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
	return ;
  80239c:	90                   	nop
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b2:	52                   	push   %edx
  8023b3:	50                   	push   %eax
  8023b4:	ff 75 10             	pushl  0x10(%ebp)
  8023b7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ba:	ff 75 08             	pushl  0x8(%ebp)
  8023bd:	6a 25                	push   $0x25
  8023bf:	e8 6c fb ff ff       	call   801f30 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c7:	90                   	nop
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <chktst>:
void chktst(uint32 n)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	ff 75 08             	pushl  0x8(%ebp)
  8023d8:	6a 27                	push   $0x27
  8023da:	e8 51 fb ff ff       	call   801f30 <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e2:	90                   	nop
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <inctst>:

void inctst()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 28                	push   $0x28
  8023f4:	e8 37 fb ff ff       	call   801f30 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fc:	90                   	nop
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <gettst>:
uint32 gettst()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 29                	push   $0x29
  80240e:	e8 1d fb ff ff       	call   801f30 <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 2a                	push   $0x2a
  80242a:	e8 01 fb ff ff       	call   801f30 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
  802432:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802435:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802439:	75 07                	jne    802442 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80243b:	b8 01 00 00 00       	mov    $0x1,%eax
  802440:	eb 05                	jmp    802447 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 2a                	push   $0x2a
  80245b:	e8 d0 fa ff ff       	call   801f30 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
  802463:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802466:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80246a:	75 07                	jne    802473 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80246c:	b8 01 00 00 00       	mov    $0x1,%eax
  802471:	eb 05                	jmp    802478 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 2a                	push   $0x2a
  80248c:	e8 9f fa ff ff       	call   801f30 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
  802494:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802497:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80249b:	75 07                	jne    8024a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80249d:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a2:	eb 05                	jmp    8024a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 2a                	push   $0x2a
  8024bd:	e8 6e fa ff ff       	call   801f30 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
  8024c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024cc:	75 07                	jne    8024d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	eb 05                	jmp    8024da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	ff 75 08             	pushl  0x8(%ebp)
  8024ea:	6a 2b                	push   $0x2b
  8024ec:	e8 3f fa ff ff       	call   801f30 <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f4:	90                   	nop
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802501:	8b 55 0c             	mov    0xc(%ebp),%edx
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	6a 00                	push   $0x0
  802509:	53                   	push   %ebx
  80250a:	51                   	push   %ecx
  80250b:	52                   	push   %edx
  80250c:	50                   	push   %eax
  80250d:	6a 2c                	push   $0x2c
  80250f:	e8 1c fa ff ff       	call   801f30 <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80251f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	52                   	push   %edx
  80252c:	50                   	push   %eax
  80252d:	6a 2d                	push   $0x2d
  80252f:	e8 fc f9 ff ff       	call   801f30 <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80253c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80253f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	6a 00                	push   $0x0
  802547:	51                   	push   %ecx
  802548:	ff 75 10             	pushl  0x10(%ebp)
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	6a 2e                	push   $0x2e
  80254f:	e8 dc f9 ff ff       	call   801f30 <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	ff 75 10             	pushl  0x10(%ebp)
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	6a 0f                	push   $0xf
  80256b:	e8 c0 f9 ff ff       	call   801f30 <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
	return ;
  802573:	90                   	nop
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	50                   	push   %eax
  802585:	6a 2f                	push   $0x2f
  802587:	e8 a4 f9 ff ff       	call   801f30 <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp

}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	6a 30                	push   $0x30
  8025a2:	e8 89 f9 ff ff       	call   801f30 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp

}
  8025aa:	90                   	nop
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	ff 75 0c             	pushl  0xc(%ebp)
  8025b9:	ff 75 08             	pushl  0x8(%ebp)
  8025bc:	6a 31                	push   $0x31
  8025be:	e8 6d f9 ff ff       	call   801f30 <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp

}
  8025c6:	90                   	nop
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_hard_limit>:
uint32 sys_hard_limit(){
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 32                	push   $0x32
  8025d8:	e8 53 f9 ff ff       	call   801f30 <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	83 e8 10             	sub    $0x10,%eax
  8025ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  8025f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
}
  8025f6:	c9                   	leave  
  8025f7:	c3                   	ret    

008025f8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	83 e8 10             	sub    $0x10,%eax
  802604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  802607:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260a:	8a 40 04             	mov    0x4(%eax),%al
}
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80261c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261f:	83 f8 02             	cmp    $0x2,%eax
  802622:	74 2b                	je     80264f <alloc_block+0x40>
  802624:	83 f8 02             	cmp    $0x2,%eax
  802627:	7f 07                	jg     802630 <alloc_block+0x21>
  802629:	83 f8 01             	cmp    $0x1,%eax
  80262c:	74 0e                	je     80263c <alloc_block+0x2d>
  80262e:	eb 58                	jmp    802688 <alloc_block+0x79>
  802630:	83 f8 03             	cmp    $0x3,%eax
  802633:	74 2d                	je     802662 <alloc_block+0x53>
  802635:	83 f8 04             	cmp    $0x4,%eax
  802638:	74 3b                	je     802675 <alloc_block+0x66>
  80263a:	eb 4c                	jmp    802688 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80263c:	83 ec 0c             	sub    $0xc,%esp
  80263f:	ff 75 08             	pushl  0x8(%ebp)
  802642:	e8 a6 01 00 00       	call   8027ed <alloc_block_FF>
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80264d:	eb 4a                	jmp    802699 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80264f:	83 ec 0c             	sub    $0xc,%esp
  802652:	ff 75 08             	pushl  0x8(%ebp)
  802655:	e8 1d 06 00 00       	call   802c77 <alloc_block_NF>
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802660:	eb 37                	jmp    802699 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	ff 75 08             	pushl  0x8(%ebp)
  802668:	e8 94 04 00 00       	call   802b01 <alloc_block_BF>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802673:	eb 24                	jmp    802699 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	e8 da 05 00 00       	call   802c5a <alloc_block_WF>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802686:	eb 11                	jmp    802699 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	68 b4 3c 80 00       	push   $0x803cb4
  802690:	e8 a3 e3 ff ff       	call   800a38 <cprintf>
  802695:	83 c4 10             	add    $0x10,%esp
		break;
  802698:	90                   	nop
	}
	return va;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8026a4:	83 ec 0c             	sub    $0xc,%esp
  8026a7:	68 d4 3c 80 00       	push   $0x803cd4
  8026ac:	e8 87 e3 ff ff       	call   800a38 <cprintf>
  8026b1:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	68 ff 3c 80 00       	push   $0x803cff
  8026bc:	e8 77 e3 ff ff       	call   800a38 <cprintf>
  8026c1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ca:	eb 26                	jmp    8026f2 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8a 40 04             	mov    0x4(%eax),%al
  8026d2:	0f b6 d0             	movzbl %al,%edx
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	52                   	push   %edx
  8026de:	50                   	push   %eax
  8026df:	68 17 3d 80 00       	push   $0x803d17
  8026e4:	e8 4f e3 ff ff       	call   800a38 <cprintf>
  8026e9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	74 08                	je     802700 <print_blocks_list+0x62>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	eb 05                	jmp    802705 <print_blocks_list+0x67>
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	89 45 10             	mov    %eax,0x10(%ebp)
  802708:	8b 45 10             	mov    0x10(%ebp),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	75 bd                	jne    8026cc <print_blocks_list+0x2e>
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 b7                	jne    8026cc <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  802715:	83 ec 0c             	sub    $0xc,%esp
  802718:	68 d4 3c 80 00       	push   $0x803cd4
  80271d:	e8 16 e3 ff ff       	call   800a38 <cprintf>
  802722:	83 c4 10             	add    $0x10,%esp

}
  802725:	90                   	nop
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  80272e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802732:	0f 84 b2 00 00 00    	je     8027ea <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  802738:	c7 05 30 40 80 00 01 	movl   $0x1,0x804030
  80273f:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  802742:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  802749:	00 00 00 
  80274c:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  802753:	00 00 00 
  802756:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  80275d:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  802768:	a1 24 41 80 00       	mov    0x804124,%eax
  80276d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802770:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  802772:	a1 24 41 80 00       	mov    0x804124,%eax
  802777:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  80277b:	a1 24 41 80 00       	mov    0x804124,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	75 14                	jne    802798 <initialize_dynamic_allocator+0x70>
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 30 3d 80 00       	push   $0x803d30
  80278c:	6a 68                	push   $0x68
  80278e:	68 53 3d 80 00       	push   $0x803d53
  802793:	e8 e3 df ff ff       	call   80077b <_panic>
  802798:	a1 24 41 80 00       	mov    0x804124,%eax
  80279d:	8b 15 14 41 80 00    	mov    0x804114,%edx
  8027a3:	89 50 08             	mov    %edx,0x8(%eax)
  8027a6:	8b 40 08             	mov    0x8(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 10                	je     8027bd <initialize_dynamic_allocator+0x95>
  8027ad:	a1 14 41 80 00       	mov    0x804114,%eax
  8027b2:	8b 15 24 41 80 00    	mov    0x804124,%edx
  8027b8:	89 50 0c             	mov    %edx,0xc(%eax)
  8027bb:	eb 0a                	jmp    8027c7 <initialize_dynamic_allocator+0x9f>
  8027bd:	a1 24 41 80 00       	mov    0x804124,%eax
  8027c2:	a3 18 41 80 00       	mov    %eax,0x804118
  8027c7:	a1 24 41 80 00       	mov    0x804124,%eax
  8027cc:	a3 14 41 80 00       	mov    %eax,0x804114
  8027d1:	a1 24 41 80 00       	mov    0x804124,%eax
  8027d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8027dd:	a1 20 41 80 00       	mov    0x804120,%eax
  8027e2:	40                   	inc    %eax
  8027e3:	a3 20 41 80 00       	mov    %eax,0x804120
  8027e8:	eb 01                	jmp    8027eb <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8027ea:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  8027f3:	a1 30 40 80 00       	mov    0x804030,%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	75 40                	jne    80283c <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	83 c0 10             	add    $0x10,%eax
  802802:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	83 ec 0c             	sub    $0xc,%esp
  80280b:	50                   	push   %eax
  80280c:	e8 05 f4 ff ff       	call   801c16 <sbrk>
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  802817:	83 ec 0c             	sub    $0xc,%esp
  80281a:	6a 00                	push   $0x0
  80281c:	e8 f5 f3 ff ff       	call   801c16 <sbrk>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  802827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80282d:	83 ec 08             	sub    $0x8,%esp
  802830:	50                   	push   %eax
  802831:	ff 75 ec             	pushl  -0x14(%ebp)
  802834:	e8 ef fe ff ff       	call   802728 <initialize_dynamic_allocator>
  802839:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  80283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802840:	75 0a                	jne    80284c <alloc_block_FF+0x5f>
		 return NULL;
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
  802847:	e9 b3 02 00 00       	jmp    802aff <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  80284c:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  802850:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  802857:	a1 14 41 80 00       	mov    0x804114,%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285f:	e9 12 01 00 00       	jmp    802976 <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8a 40 04             	mov    0x4(%eax),%al
  80286a:	84 c0                	test   %al,%al
  80286c:	0f 84 fc 00 00 00    	je     80296e <alloc_block_FF+0x181>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287a:	0f 82 ee 00 00 00    	jb     80296e <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	75 12                	jne    80289c <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	83 c0 10             	add    $0x10,%eax
  802897:	e9 63 02 00 00       	jmp    802aff <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  80289c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b2:	83 f8 0f             	cmp    $0xf,%eax
  8028b5:	0f 86 a8 00 00 00    	jbe    802963 <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	01 d0                	add    %edx,%eax
  8028c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ce:	89 c2                	mov    %eax,%edx
  8028d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028d3:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028db:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  8028dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028e0:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	74 06                	je     8028f0 <alloc_block_FF+0x103>
  8028ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8028ee:	75 17                	jne    802907 <alloc_block_FF+0x11a>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 6c 3d 80 00       	push   $0x803d6c
  8028f8:	68 91 00 00 00       	push   $0x91
  8028fd:	68 53 3d 80 00       	push   $0x803d53
  802902:	e8 74 de ff ff       	call   80077b <_panic>
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 50 08             	mov    0x8(%eax),%edx
  80290d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802910:	89 50 08             	mov    %edx,0x8(%eax)
  802913:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 0c                	je     802929 <alloc_block_FF+0x13c>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 08             	mov    0x8(%eax),%eax
  802923:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802926:	89 50 0c             	mov    %edx,0xc(%eax)
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80292f:	89 50 08             	mov    %edx,0x8(%eax)
  802932:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802938:	89 50 0c             	mov    %edx,0xc(%eax)
  80293b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80293e:	8b 40 08             	mov    0x8(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	75 08                	jne    80294d <alloc_block_FF+0x160>
  802945:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802948:	a3 18 41 80 00       	mov    %eax,0x804118
  80294d:	a1 20 41 80 00       	mov    0x804120,%eax
  802952:	40                   	inc    %eax
  802953:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	83 c0 10             	add    $0x10,%eax
  80295e:	e9 9c 01 00 00       	jmp    802aff <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	83 c0 10             	add    $0x10,%eax
  802969:	e9 91 01 00 00       	jmp    802aff <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  80296e:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297a:	74 08                	je     802984 <alloc_block_FF+0x197>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 08             	mov    0x8(%eax),%eax
  802982:	eb 05                	jmp    802989 <alloc_block_FF+0x19c>
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
  802989:	a3 1c 41 80 00       	mov    %eax,0x80411c
  80298e:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	0f 85 c9 fe ff ff    	jne    802864 <alloc_block_FF+0x77>
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	0f 85 bf fe ff ff    	jne    802864 <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  8029a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029a9:	0f 85 4b 01 00 00    	jne    802afa <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	83 ec 0c             	sub    $0xc,%esp
  8029b5:	50                   	push   %eax
  8029b6:	e8 5b f2 ff ff       	call   801c16 <sbrk>
  8029bb:	83 c4 10             	add    $0x10,%esp
  8029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	0f 84 28 01 00 00    	je     802af3 <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  8029d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d7:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  8029d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029dc:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  8029e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029e4:	75 17                	jne    8029fd <alloc_block_FF+0x210>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 a0 3d 80 00       	push   $0x803da0
  8029ee:	68 a1 00 00 00       	push   $0xa1
  8029f3:	68 53 3d 80 00       	push   $0x803d53
  8029f8:	e8 7e dd ff ff       	call   80077b <_panic>
  8029fd:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a06:	89 50 0c             	mov    %edx,0xc(%eax)
  802a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	74 0d                	je     802a20 <alloc_block_FF+0x233>
  802a13:	a1 18 41 80 00       	mov    0x804118,%eax
  802a18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a1b:	89 50 08             	mov    %edx,0x8(%eax)
  802a1e:	eb 08                	jmp    802a28 <alloc_block_FF+0x23b>
  802a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a23:	a3 14 41 80 00       	mov    %eax,0x804114
  802a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2b:	a3 18 41 80 00       	mov    %eax,0x804118
  802a30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a3a:	a1 20 41 80 00       	mov    0x804120,%eax
  802a3f:	40                   	inc    %eax
  802a40:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802a45:	b8 00 10 00 00       	mov    $0x1000,%eax
  802a4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4d:	83 f8 0f             	cmp    $0xf,%eax
  802a50:	0f 86 95 00 00 00    	jbe    802aeb <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802a61:	b8 00 10 00 00       	mov    $0x1000,%eax
  802a66:	2b 45 08             	sub    0x8(%ebp),%eax
  802a69:	89 c2                	mov    %eax,%edx
  802a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6e:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802a70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a73:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802a77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a7b:	74 06                	je     802a83 <alloc_block_FF+0x296>
  802a7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a81:	75 17                	jne    802a9a <alloc_block_FF+0x2ad>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 6c 3d 80 00       	push   $0x803d6c
  802a8b:	68 a6 00 00 00       	push   $0xa6
  802a90:	68 53 3d 80 00       	push   $0x803d53
  802a95:	e8 e1 dc ff ff       	call   80077b <_panic>
  802a9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9d:	8b 50 08             	mov    0x8(%eax),%edx
  802aa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa3:	89 50 08             	mov    %edx,0x8(%eax)
  802aa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0c                	je     802abc <alloc_block_FF+0x2cf>
  802ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab3:	8b 40 08             	mov    0x8(%eax),%eax
  802ab6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab9:	89 50 0c             	mov    %edx,0xc(%eax)
  802abc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac2:	89 50 08             	mov    %edx,0x8(%eax)
  802ac5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
  802ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ad1:	8b 40 08             	mov    0x8(%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	75 08                	jne    802ae0 <alloc_block_FF+0x2f3>
  802ad8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802adb:	a3 18 41 80 00       	mov    %eax,0x804118
  802ae0:	a1 20 41 80 00       	mov    0x804120,%eax
  802ae5:	40                   	inc    %eax
  802ae6:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  802aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aee:	83 c0 10             	add    $0x10,%eax
  802af1:	eb 0c                	jmp    802aff <alloc_block_FF+0x312>
		 }
		 return NULL;
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	eb 05                	jmp    802aff <alloc_block_FF+0x312>
	 }
	 return NULL;
  802afa:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802b07:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  802b12:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802b19:	a1 14 41 80 00       	mov    0x804114,%eax
  802b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b21:	eb 34                	jmp    802b57 <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8a 40 04             	mov    0x4(%eax),%al
  802b29:	84 c0                	test   %al,%al
  802b2b:	74 22                	je     802b4f <alloc_block_BF+0x4e>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b35:	72 18                	jb     802b4f <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b3f:	73 0e                	jae    802b4f <alloc_block_BF+0x4e>
                bestFitBlock = current;
  802b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802b4f:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b5b:	74 08                	je     802b65 <alloc_block_BF+0x64>
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	eb 05                	jmp    802b6a <alloc_block_BF+0x69>
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6a:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802b6f:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	75 ab                	jne    802b23 <alloc_block_BF+0x22>
  802b78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b7c:	75 a5                	jne    802b23 <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b82:	0f 84 cb 00 00 00    	je     802c53 <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b97:	0f 86 ae 00 00 00    	jbe    802c4b <alloc_block_BF+0x14a>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba5:	83 f8 0f             	cmp    $0xf,%eax
  802ba8:	0f 86 9d 00 00 00    	jbe    802c4b <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	01 d0                	add    %edx,%eax
  802bb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc1:	89 c2                	mov    %eax,%edx
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd5:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  802bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdb:	74 06                	je     802be3 <alloc_block_BF+0xe2>
  802bdd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802be1:	75 17                	jne    802bfa <alloc_block_BF+0xf9>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 6c 3d 80 00       	push   $0x803d6c
  802beb:	68 c6 00 00 00       	push   $0xc6
  802bf0:	68 53 3d 80 00       	push   $0x803d53
  802bf5:	e8 81 db ff ff       	call   80077b <_panic>
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 50 08             	mov    0x8(%eax),%edx
  802c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c03:	89 50 08             	mov    %edx,0x8(%eax)
  802c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c09:	8b 40 08             	mov    0x8(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0c                	je     802c1c <alloc_block_BF+0x11b>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 08             	mov    0x8(%eax),%eax
  802c16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c19:	89 50 0c             	mov    %edx,0xc(%eax)
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c22:	89 50 08             	mov    %edx,0x8(%eax)
  802c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2b:	89 50 0c             	mov    %edx,0xc(%eax)
  802c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c31:	8b 40 08             	mov    0x8(%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	75 08                	jne    802c40 <alloc_block_BF+0x13f>
  802c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3b:	a3 18 41 80 00       	mov    %eax,0x804118
  802c40:	a1 20 41 80 00       	mov    0x804120,%eax
  802c45:	40                   	inc    %eax
  802c46:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	83 c0 10             	add    $0x10,%eax
  802c51:	eb 05                	jmp    802c58 <alloc_block_BF+0x157>
    }

    return NULL;
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c58:	c9                   	leave  
  802c59:	c3                   	ret    

00802c5a <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	68 c4 3d 80 00       	push   $0x803dc4
  802c68:	68 d2 00 00 00       	push   $0xd2
  802c6d:	68 53 3d 80 00       	push   $0x803d53
  802c72:	e8 04 db ff ff       	call   80077b <_panic>

00802c77 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802c77:	55                   	push   %ebp
  802c78:	89 e5                	mov    %esp,%ebp
  802c7a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 ec 3d 80 00       	push   $0x803dec
  802c85:	68 db 00 00 00       	push   $0xdb
  802c8a:	68 53 3d 80 00       	push   $0x803d53
  802c8f:	e8 e7 da ff ff       	call   80077b <_panic>

00802c94 <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9e:	0f 84 d2 01 00 00    	je     802e76 <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	83 e8 10             	sub    $0x10,%eax
  802caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8a 40 04             	mov    0x4(%eax),%al
  802cb3:	84 c0                	test   %al,%al
  802cb5:	0f 85 be 01 00 00    	jne    802e79 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 08             	mov    0x8(%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	0f 84 cc 00 00 00    	je     802d9c <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	8a 40 04             	mov    0x4(%eax),%al
  802cd9:	84 c0                	test   %al,%al
  802cdb:	0f 84 bb 00 00 00    	je     802d9c <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 10                	mov    (%eax),%edx
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 08             	mov    0x8(%eax),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	01 c2                	add    %eax,%edx
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 08             	mov    0x8(%eax),%eax
  802cfb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 08             	mov    0x8(%eax),%eax
  802d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 08             	mov    0x8(%eax),%eax
  802d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d18:	75 17                	jne    802d31 <free_block+0x9d>
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	68 12 3e 80 00       	push   $0x803e12
  802d22:	68 f8 00 00 00       	push   $0xf8
  802d27:	68 53 3d 80 00       	push   $0x803d53
  802d2c:	e8 4a da ff ff       	call   80077b <_panic>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 08             	mov    0x8(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 11                	je     802d4c <free_block+0xb8>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 40 08             	mov    0x8(%eax),%eax
  802d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d44:	8b 52 0c             	mov    0xc(%edx),%edx
  802d47:	89 50 0c             	mov    %edx,0xc(%eax)
  802d4a:	eb 0b                	jmp    802d57 <free_block+0xc3>
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d52:	a3 18 41 80 00       	mov    %eax,0x804118
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 11                	je     802d72 <free_block+0xde>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6a:	8b 52 08             	mov    0x8(%edx),%edx
  802d6d:	89 50 08             	mov    %edx,0x8(%eax)
  802d70:	eb 0b                	jmp    802d7d <free_block+0xe9>
  802d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	a3 14 41 80 00       	mov    %eax,0x804114
  802d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d91:	a1 20 41 80 00       	mov    0x804120,%eax
  802d96:	48                   	dec    %eax
  802d97:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	0f 84 d0 00 00 00    	je     802e7a <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 0c             	mov    0xc(%eax),%eax
  802db0:	8a 40 04             	mov    0x4(%eax),%al
  802db3:	84 c0                	test   %al,%al
  802db5:	0f 84 bf 00 00 00    	je     802e7a <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	8b 52 0c             	mov    0xc(%edx),%edx
  802dc7:	8b 0a                	mov    (%edx),%ecx
  802dc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dcc:	8b 12                	mov    (%edx),%edx
  802dce:	01 ca                	add    %ecx,%edx
  802dd0:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd8:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df0:	75 17                	jne    802e09 <free_block+0x175>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 12 3e 80 00       	push   $0x803e12
  802dfa:	68 03 01 00 00       	push   $0x103
  802dff:	68 53 3d 80 00       	push   $0x803d53
  802e04:	e8 72 d9 ff ff       	call   80077b <_panic>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 11                	je     802e24 <free_block+0x190>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 08             	mov    0x8(%eax),%eax
  802e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1c:	8b 52 0c             	mov    0xc(%edx),%edx
  802e1f:	89 50 0c             	mov    %edx,0xc(%eax)
  802e22:	eb 0b                	jmp    802e2f <free_block+0x19b>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	a3 18 41 80 00       	mov    %eax,0x804118
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 11                	je     802e4a <free_block+0x1b6>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e42:	8b 52 08             	mov    0x8(%edx),%edx
  802e45:	89 50 08             	mov    %edx,0x8(%eax)
  802e48:	eb 0b                	jmp    802e55 <free_block+0x1c1>
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 40 08             	mov    0x8(%eax),%eax
  802e50:	a3 14 41 80 00       	mov    %eax,0x804114
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e69:	a1 20 41 80 00       	mov    0x804120,%eax
  802e6e:	48                   	dec    %eax
  802e6f:	a3 20 41 80 00       	mov    %eax,0x804120
  802e74:	eb 04                	jmp    802e7a <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802e76:	90                   	nop
  802e77:	eb 01                	jmp    802e7a <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802e79:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802e7a:	c9                   	leave  
  802e7b:	c3                   	ret    

00802e7c <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802e7c:	55                   	push   %ebp
  802e7d:	89 e5                	mov    %esp,%ebp
  802e7f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e86:	75 10                	jne    802e98 <realloc_block_FF+0x1c>
  802e88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e8c:	75 0a                	jne    802e98 <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	e9 2e 03 00 00       	jmp    8031c6 <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9c:	75 13                	jne    802eb1 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	ff 75 0c             	pushl  0xc(%ebp)
  802ea4:	e8 44 f9 ff ff       	call   8027ed <alloc_block_FF>
  802ea9:	83 c4 10             	add    $0x10,%esp
  802eac:	e9 15 03 00 00       	jmp    8031c6 <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  802eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb5:	75 18                	jne    802ecf <realloc_block_FF+0x53>
	 {
		 free_block(va);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 08             	pushl  0x8(%ebp)
  802ebd:	e8 d2 fd ff ff       	call   802c94 <free_block>
  802ec2:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eca:	e9 f7 02 00 00       	jmp    8031c6 <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	83 e8 10             	sub    $0x10,%eax
  802ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  802ed8:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ee4:	0f 82 c8 00 00 00    	jb     802fb2 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ef2:	75 08                	jne    802efc <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	e9 ca 02 00 00       	jmp    8031c6 <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f04:	83 f8 0f             	cmp    $0xf,%eax
  802f07:	0f 86 9d 00 00 00    	jbe    802faa <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  802f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f13:	01 d0                	add    %edx,%eax
  802f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f20:	89 c2                	mov    %eax,%edx
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2d:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  802f36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3a:	74 06                	je     802f42 <realloc_block_FF+0xc6>
  802f3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f40:	75 17                	jne    802f59 <realloc_block_FF+0xdd>
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	68 6c 3d 80 00       	push   $0x803d6c
  802f4a:	68 2a 01 00 00       	push   $0x12a
  802f4f:	68 53 3d 80 00       	push   $0x803d53
  802f54:	e8 22 d8 ff ff       	call   80077b <_panic>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 50 08             	mov    0x8(%eax),%edx
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	89 50 08             	mov    %edx,0x8(%eax)
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 40 08             	mov    0x8(%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0c                	je     802f7b <realloc_block_FF+0xff>
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 08             	mov    0x8(%eax),%eax
  802f75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f78:	89 50 0c             	mov    %edx,0xc(%eax)
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f81:	89 50 08             	mov    %edx,0x8(%eax)
  802f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	75 08                	jne    802f9f <realloc_block_FF+0x123>
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	a3 18 41 80 00       	mov    %eax,0x804118
  802f9f:	a1 20 41 80 00       	mov    0x804120,%eax
  802fa4:	40                   	inc    %eax
  802fa5:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	e9 14 02 00 00       	jmp    8031c6 <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 08             	mov    0x8(%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	0f 84 97 01 00 00    	je     803157 <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 40 08             	mov    0x8(%eax),%eax
  802fc6:	8a 40 04             	mov    0x4(%eax),%al
  802fc9:	84 c0                	test   %al,%al
  802fcb:	0f 84 86 01 00 00    	je     803157 <realloc_block_FF+0x2db>
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 10                	mov    (%eax),%edx
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 40 08             	mov    0x8(%eax),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	01 d0                	add    %edx,%eax
  802fe0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fe3:	0f 82 6e 01 00 00    	jb     803157 <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 10                	mov    (%eax),%edx
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 40 08             	mov    0x8(%eax),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	01 c2                	add    %eax,%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 40 08             	mov    0x8(%eax),%eax
  803003:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  80301c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803020:	75 17                	jne    803039 <realloc_block_FF+0x1bd>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 12 3e 80 00       	push   $0x803e12
  80302a:	68 38 01 00 00       	push   $0x138
  80302f:	68 53 3d 80 00       	push   $0x803d53
  803034:	e8 42 d7 ff ff       	call   80077b <_panic>
  803039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303c:	8b 40 08             	mov    0x8(%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 11                	je     803054 <realloc_block_FF+0x1d8>
  803043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803046:	8b 40 08             	mov    0x8(%eax),%eax
  803049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80304c:	8b 52 0c             	mov    0xc(%edx),%edx
  80304f:	89 50 0c             	mov    %edx,0xc(%eax)
  803052:	eb 0b                	jmp    80305f <realloc_block_FF+0x1e3>
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	a3 18 41 80 00       	mov    %eax,0x804118
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	8b 40 0c             	mov    0xc(%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 11                	je     80307a <realloc_block_FF+0x1fe>
  803069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306c:	8b 40 0c             	mov    0xc(%eax),%eax
  80306f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803072:	8b 52 08             	mov    0x8(%edx),%edx
  803075:	89 50 08             	mov    %edx,0x8(%eax)
  803078:	eb 0b                	jmp    803085 <realloc_block_FF+0x209>
  80307a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307d:	8b 40 08             	mov    0x8(%eax),%eax
  803080:	a3 14 41 80 00       	mov    %eax,0x804114
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803092:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803099:	a1 20 41 80 00       	mov    0x804120,%eax
  80309e:	48                   	dec    %eax
  80309f:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030ac:	83 f8 0f             	cmp    $0xf,%eax
  8030af:	0f 86 9d 00 00 00    	jbe    803152 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  8030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bb:	01 d0                	add    %edx,%eax
  8030bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030c8:	89 c2                	mov    %eax,%edx
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d5:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  8030de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e2:	74 06                	je     8030ea <realloc_block_FF+0x26e>
  8030e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e8:	75 17                	jne    803101 <realloc_block_FF+0x285>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 6c 3d 80 00       	push   $0x803d6c
  8030f2:	68 3f 01 00 00       	push   $0x13f
  8030f7:	68 53 3d 80 00       	push   $0x803d53
  8030fc:	e8 7a d6 ff ff       	call   80077b <_panic>
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 50 08             	mov    0x8(%eax),%edx
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	89 50 08             	mov    %edx,0x8(%eax)
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0c                	je     803123 <realloc_block_FF+0x2a7>
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 08             	mov    0x8(%eax),%eax
  80311d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803120:	89 50 0c             	mov    %edx,0xc(%eax)
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803129:	89 50 08             	mov    %edx,0x8(%eax)
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803132:	89 50 0c             	mov    %edx,0xc(%eax)
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 08             	mov    0x8(%eax),%eax
  80313b:	85 c0                	test   %eax,%eax
  80313d:	75 08                	jne    803147 <realloc_block_FF+0x2cb>
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	a3 18 41 80 00       	mov    %eax,0x804118
  803147:	a1 20 41 80 00       	mov    0x804120,%eax
  80314c:	40                   	inc    %eax
  80314d:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	eb 6f                	jmp    8031c6 <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  803157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315a:	83 e8 10             	sub    $0x10,%eax
  80315d:	83 ec 0c             	sub    $0xc,%esp
  803160:	50                   	push   %eax
  803161:	e8 87 f6 ff ff       	call   8027ed <alloc_block_FF>
  803166:	83 c4 10             	add    $0x10,%esp
  803169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  80316c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803170:	75 29                	jne    80319b <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  803172:	8b 45 0c             	mov    0xc(%ebp),%eax
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	50                   	push   %eax
  803179:	e8 98 ea ff ff       	call   801c16 <sbrk>
  80317e:	83 c4 10             	add    $0x10,%esp
  803181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  803184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803187:	83 f8 ff             	cmp    $0xffffffff,%eax
  80318a:	75 07                	jne    803193 <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  80318c:	b8 00 00 00 00       	mov    $0x0,%eax
  803191:	eb 33                	jmp    8031c6 <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	83 c0 10             	add    $0x10,%eax
  803199:	eb 2b                	jmp    8031c6 <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	50                   	push   %eax
  8031a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031aa:	e8 2f e3 ff ff       	call   8014de <memcpy>
  8031af:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  8031b2:	83 ec 0c             	sub    $0xc,%esp
  8031b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b8:	e8 d7 fa ff ff       	call   802c94 <free_block>
  8031bd:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  8031c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c3:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <__udivdi3>:
  8031c8:	55                   	push   %ebp
  8031c9:	57                   	push   %edi
  8031ca:	56                   	push   %esi
  8031cb:	53                   	push   %ebx
  8031cc:	83 ec 1c             	sub    $0x1c,%esp
  8031cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031df:	89 ca                	mov    %ecx,%edx
  8031e1:	89 f8                	mov    %edi,%eax
  8031e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031e7:	85 f6                	test   %esi,%esi
  8031e9:	75 2d                	jne    803218 <__udivdi3+0x50>
  8031eb:	39 cf                	cmp    %ecx,%edi
  8031ed:	77 65                	ja     803254 <__udivdi3+0x8c>
  8031ef:	89 fd                	mov    %edi,%ebp
  8031f1:	85 ff                	test   %edi,%edi
  8031f3:	75 0b                	jne    803200 <__udivdi3+0x38>
  8031f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8031fa:	31 d2                	xor    %edx,%edx
  8031fc:	f7 f7                	div    %edi
  8031fe:	89 c5                	mov    %eax,%ebp
  803200:	31 d2                	xor    %edx,%edx
  803202:	89 c8                	mov    %ecx,%eax
  803204:	f7 f5                	div    %ebp
  803206:	89 c1                	mov    %eax,%ecx
  803208:	89 d8                	mov    %ebx,%eax
  80320a:	f7 f5                	div    %ebp
  80320c:	89 cf                	mov    %ecx,%edi
  80320e:	89 fa                	mov    %edi,%edx
  803210:	83 c4 1c             	add    $0x1c,%esp
  803213:	5b                   	pop    %ebx
  803214:	5e                   	pop    %esi
  803215:	5f                   	pop    %edi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    
  803218:	39 ce                	cmp    %ecx,%esi
  80321a:	77 28                	ja     803244 <__udivdi3+0x7c>
  80321c:	0f bd fe             	bsr    %esi,%edi
  80321f:	83 f7 1f             	xor    $0x1f,%edi
  803222:	75 40                	jne    803264 <__udivdi3+0x9c>
  803224:	39 ce                	cmp    %ecx,%esi
  803226:	72 0a                	jb     803232 <__udivdi3+0x6a>
  803228:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80322c:	0f 87 9e 00 00 00    	ja     8032d0 <__udivdi3+0x108>
  803232:	b8 01 00 00 00       	mov    $0x1,%eax
  803237:	89 fa                	mov    %edi,%edx
  803239:	83 c4 1c             	add    $0x1c,%esp
  80323c:	5b                   	pop    %ebx
  80323d:	5e                   	pop    %esi
  80323e:	5f                   	pop    %edi
  80323f:	5d                   	pop    %ebp
  803240:	c3                   	ret    
  803241:	8d 76 00             	lea    0x0(%esi),%esi
  803244:	31 ff                	xor    %edi,%edi
  803246:	31 c0                	xor    %eax,%eax
  803248:	89 fa                	mov    %edi,%edx
  80324a:	83 c4 1c             	add    $0x1c,%esp
  80324d:	5b                   	pop    %ebx
  80324e:	5e                   	pop    %esi
  80324f:	5f                   	pop    %edi
  803250:	5d                   	pop    %ebp
  803251:	c3                   	ret    
  803252:	66 90                	xchg   %ax,%ax
  803254:	89 d8                	mov    %ebx,%eax
  803256:	f7 f7                	div    %edi
  803258:	31 ff                	xor    %edi,%edi
  80325a:	89 fa                	mov    %edi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	bd 20 00 00 00       	mov    $0x20,%ebp
  803269:	89 eb                	mov    %ebp,%ebx
  80326b:	29 fb                	sub    %edi,%ebx
  80326d:	89 f9                	mov    %edi,%ecx
  80326f:	d3 e6                	shl    %cl,%esi
  803271:	89 c5                	mov    %eax,%ebp
  803273:	88 d9                	mov    %bl,%cl
  803275:	d3 ed                	shr    %cl,%ebp
  803277:	89 e9                	mov    %ebp,%ecx
  803279:	09 f1                	or     %esi,%ecx
  80327b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80327f:	89 f9                	mov    %edi,%ecx
  803281:	d3 e0                	shl    %cl,%eax
  803283:	89 c5                	mov    %eax,%ebp
  803285:	89 d6                	mov    %edx,%esi
  803287:	88 d9                	mov    %bl,%cl
  803289:	d3 ee                	shr    %cl,%esi
  80328b:	89 f9                	mov    %edi,%ecx
  80328d:	d3 e2                	shl    %cl,%edx
  80328f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803293:	88 d9                	mov    %bl,%cl
  803295:	d3 e8                	shr    %cl,%eax
  803297:	09 c2                	or     %eax,%edx
  803299:	89 d0                	mov    %edx,%eax
  80329b:	89 f2                	mov    %esi,%edx
  80329d:	f7 74 24 0c          	divl   0xc(%esp)
  8032a1:	89 d6                	mov    %edx,%esi
  8032a3:	89 c3                	mov    %eax,%ebx
  8032a5:	f7 e5                	mul    %ebp
  8032a7:	39 d6                	cmp    %edx,%esi
  8032a9:	72 19                	jb     8032c4 <__udivdi3+0xfc>
  8032ab:	74 0b                	je     8032b8 <__udivdi3+0xf0>
  8032ad:	89 d8                	mov    %ebx,%eax
  8032af:	31 ff                	xor    %edi,%edi
  8032b1:	e9 58 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032b6:	66 90                	xchg   %ax,%ax
  8032b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032bc:	89 f9                	mov    %edi,%ecx
  8032be:	d3 e2                	shl    %cl,%edx
  8032c0:	39 c2                	cmp    %eax,%edx
  8032c2:	73 e9                	jae    8032ad <__udivdi3+0xe5>
  8032c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032c7:	31 ff                	xor    %edi,%edi
  8032c9:	e9 40 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	31 c0                	xor    %eax,%eax
  8032d2:	e9 37 ff ff ff       	jmp    80320e <__udivdi3+0x46>
  8032d7:	90                   	nop

008032d8 <__umoddi3>:
  8032d8:	55                   	push   %ebp
  8032d9:	57                   	push   %edi
  8032da:	56                   	push   %esi
  8032db:	53                   	push   %ebx
  8032dc:	83 ec 1c             	sub    $0x1c,%esp
  8032df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032f7:	89 f3                	mov    %esi,%ebx
  8032f9:	89 fa                	mov    %edi,%edx
  8032fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ff:	89 34 24             	mov    %esi,(%esp)
  803302:	85 c0                	test   %eax,%eax
  803304:	75 1a                	jne    803320 <__umoddi3+0x48>
  803306:	39 f7                	cmp    %esi,%edi
  803308:	0f 86 a2 00 00 00    	jbe    8033b0 <__umoddi3+0xd8>
  80330e:	89 c8                	mov    %ecx,%eax
  803310:	89 f2                	mov    %esi,%edx
  803312:	f7 f7                	div    %edi
  803314:	89 d0                	mov    %edx,%eax
  803316:	31 d2                	xor    %edx,%edx
  803318:	83 c4 1c             	add    $0x1c,%esp
  80331b:	5b                   	pop    %ebx
  80331c:	5e                   	pop    %esi
  80331d:	5f                   	pop    %edi
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    
  803320:	39 f0                	cmp    %esi,%eax
  803322:	0f 87 ac 00 00 00    	ja     8033d4 <__umoddi3+0xfc>
  803328:	0f bd e8             	bsr    %eax,%ebp
  80332b:	83 f5 1f             	xor    $0x1f,%ebp
  80332e:	0f 84 ac 00 00 00    	je     8033e0 <__umoddi3+0x108>
  803334:	bf 20 00 00 00       	mov    $0x20,%edi
  803339:	29 ef                	sub    %ebp,%edi
  80333b:	89 fe                	mov    %edi,%esi
  80333d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803341:	89 e9                	mov    %ebp,%ecx
  803343:	d3 e0                	shl    %cl,%eax
  803345:	89 d7                	mov    %edx,%edi
  803347:	89 f1                	mov    %esi,%ecx
  803349:	d3 ef                	shr    %cl,%edi
  80334b:	09 c7                	or     %eax,%edi
  80334d:	89 e9                	mov    %ebp,%ecx
  80334f:	d3 e2                	shl    %cl,%edx
  803351:	89 14 24             	mov    %edx,(%esp)
  803354:	89 d8                	mov    %ebx,%eax
  803356:	d3 e0                	shl    %cl,%eax
  803358:	89 c2                	mov    %eax,%edx
  80335a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335e:	d3 e0                	shl    %cl,%eax
  803360:	89 44 24 04          	mov    %eax,0x4(%esp)
  803364:	8b 44 24 08          	mov    0x8(%esp),%eax
  803368:	89 f1                	mov    %esi,%ecx
  80336a:	d3 e8                	shr    %cl,%eax
  80336c:	09 d0                	or     %edx,%eax
  80336e:	d3 eb                	shr    %cl,%ebx
  803370:	89 da                	mov    %ebx,%edx
  803372:	f7 f7                	div    %edi
  803374:	89 d3                	mov    %edx,%ebx
  803376:	f7 24 24             	mull   (%esp)
  803379:	89 c6                	mov    %eax,%esi
  80337b:	89 d1                	mov    %edx,%ecx
  80337d:	39 d3                	cmp    %edx,%ebx
  80337f:	0f 82 87 00 00 00    	jb     80340c <__umoddi3+0x134>
  803385:	0f 84 91 00 00 00    	je     80341c <__umoddi3+0x144>
  80338b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80338f:	29 f2                	sub    %esi,%edx
  803391:	19 cb                	sbb    %ecx,%ebx
  803393:	89 d8                	mov    %ebx,%eax
  803395:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803399:	d3 e0                	shl    %cl,%eax
  80339b:	89 e9                	mov    %ebp,%ecx
  80339d:	d3 ea                	shr    %cl,%edx
  80339f:	09 d0                	or     %edx,%eax
  8033a1:	89 e9                	mov    %ebp,%ecx
  8033a3:	d3 eb                	shr    %cl,%ebx
  8033a5:	89 da                	mov    %ebx,%edx
  8033a7:	83 c4 1c             	add    $0x1c,%esp
  8033aa:	5b                   	pop    %ebx
  8033ab:	5e                   	pop    %esi
  8033ac:	5f                   	pop    %edi
  8033ad:	5d                   	pop    %ebp
  8033ae:	c3                   	ret    
  8033af:	90                   	nop
  8033b0:	89 fd                	mov    %edi,%ebp
  8033b2:	85 ff                	test   %edi,%edi
  8033b4:	75 0b                	jne    8033c1 <__umoddi3+0xe9>
  8033b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bb:	31 d2                	xor    %edx,%edx
  8033bd:	f7 f7                	div    %edi
  8033bf:	89 c5                	mov    %eax,%ebp
  8033c1:	89 f0                	mov    %esi,%eax
  8033c3:	31 d2                	xor    %edx,%edx
  8033c5:	f7 f5                	div    %ebp
  8033c7:	89 c8                	mov    %ecx,%eax
  8033c9:	f7 f5                	div    %ebp
  8033cb:	89 d0                	mov    %edx,%eax
  8033cd:	e9 44 ff ff ff       	jmp    803316 <__umoddi3+0x3e>
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	89 c8                	mov    %ecx,%eax
  8033d6:	89 f2                	mov    %esi,%edx
  8033d8:	83 c4 1c             	add    $0x1c,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5e                   	pop    %esi
  8033dd:	5f                   	pop    %edi
  8033de:	5d                   	pop    %ebp
  8033df:	c3                   	ret    
  8033e0:	3b 04 24             	cmp    (%esp),%eax
  8033e3:	72 06                	jb     8033eb <__umoddi3+0x113>
  8033e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033e9:	77 0f                	ja     8033fa <__umoddi3+0x122>
  8033eb:	89 f2                	mov    %esi,%edx
  8033ed:	29 f9                	sub    %edi,%ecx
  8033ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033f3:	89 14 24             	mov    %edx,(%esp)
  8033f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033fe:	8b 14 24             	mov    (%esp),%edx
  803401:	83 c4 1c             	add    $0x1c,%esp
  803404:	5b                   	pop    %ebx
  803405:	5e                   	pop    %esi
  803406:	5f                   	pop    %edi
  803407:	5d                   	pop    %ebp
  803408:	c3                   	ret    
  803409:	8d 76 00             	lea    0x0(%esi),%esi
  80340c:	2b 04 24             	sub    (%esp),%eax
  80340f:	19 fa                	sbb    %edi,%edx
  803411:	89 d1                	mov    %edx,%ecx
  803413:	89 c6                	mov    %eax,%esi
  803415:	e9 71 ff ff ff       	jmp    80338b <__umoddi3+0xb3>
  80341a:	66 90                	xchg   %ax,%ax
  80341c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803420:	72 ea                	jb     80340c <__umoddi3+0x134>
  803422:	89 d9                	mov    %ebx,%ecx
  803424:	e9 62 ff ff ff       	jmp    80338b <__umoddi3+0xb3>
