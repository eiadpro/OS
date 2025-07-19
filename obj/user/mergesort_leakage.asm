
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 c5 21 00 00       	call   80220b <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 35 80 00       	push   $0x8035a0
  80004e:	e8 3c 0b 00 00       	call   800b8f <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 35 80 00       	push   $0x8035a2
  80005e:	e8 2c 0b 00 00       	call   800b8f <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 35 80 00       	push   $0x8035b8
  80006e:	e8 1c 0b 00 00       	call   800b8f <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 35 80 00       	push   $0x8035a2
  80007e:	e8 0c 0b 00 00       	call   800b8f <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 35 80 00       	push   $0x8035a0
  80008e:	e8 fc 0a 00 00       	call   800b8f <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 35 80 00       	push   $0x8035d0
  8000a5:	e8 67 11 00 00       	call   801211 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b7 16 00 00       	call   801777 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 ae 1c 00 00       	call   801d83 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 35 80 00       	push   $0x8035f0
  8000e3:	e8 a7 0a 00 00       	call   800b8f <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 36 80 00       	push   $0x803612
  8000f3:	e8 97 0a 00 00       	call   800b8f <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 36 80 00       	push   $0x803620
  800103:	e8 87 0a 00 00       	call   800b8f <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 36 80 00       	push   $0x80362f
  800113:	e8 77 0a 00 00       	call   800b8f <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 36 80 00       	push   $0x80363f
  800123:	e8 67 0a 00 00       	call   800b8f <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 be 20 00 00       	call   802225 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 2f 20 00 00       	call   80220b <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 36 80 00       	push   $0x803648
  8001e4:	e8 a6 09 00 00       	call   800b8f <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 34 20 00 00       	call   802225 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 7c 36 80 00       	push   $0x80367c
  800213:	6a 4a                	push   $0x4a
  800215:	68 9e 36 80 00       	push   $0x80369e
  80021a:	e8 b3 06 00 00       	call   8008d2 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 e7 1f 00 00       	call   80220b <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 b8 36 80 00       	push   $0x8036b8
  80022c:	e8 5e 09 00 00       	call   800b8f <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ec 36 80 00       	push   $0x8036ec
  80023c:	e8 4e 09 00 00       	call   800b8f <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 20 37 80 00       	push   $0x803720
  80024c:	e8 3e 09 00 00       	call   800b8f <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 cc 1f 00 00       	call   802225 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 ad 1f 00 00       	call   80220b <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 52 37 80 00       	push   $0x803752
  80026c:	e8 1e 09 00 00       	call   800b8f <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 6e 1f 00 00       	call   802225 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 a0 35 80 00       	push   $0x8035a0
  80044b:	e8 3f 07 00 00       	call   800b8f <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 70 37 80 00       	push   $0x803770
  80046d:	e8 1d 07 00 00       	call   800b8f <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 75 37 80 00       	push   $0x803775
  80049b:	e8 ef 06 00 00       	call   800b8f <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 42 18 00 00       	call   801d83 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 2d 18 00 00       	call   801d83 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 2b 1b 00 00       	call   80223f <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 e6 1a 00 00       	call   80220b <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 07 1b 00 00       	call   80223f <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 e5 1a 00 00       	call   802225 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 84 19 00 00       	call   8020db <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 9b 1a 00 00       	call   80220b <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 5d 19 00 00       	call   8020db <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 99 1a 00 00       	call   802225 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 58 1c 00 00       	call   8023fe <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 40 80 00       	mov    %eax,0x804024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 40 80 00       	mov    0x804024,%eax
  8007d2:	8a 40 5c             	mov    0x5c(%eax),%al
  8007d5:	84 c0                	test   %al,%al
  8007d7:	74 0d                	je     8007e6 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8007d9:	a1 24 40 80 00       	mov    0x804024,%eax
  8007de:	83 c0 5c             	add    $0x5c,%eax
  8007e1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ea:	7e 0a                	jle    8007f6 <libmain+0x5b>
		binaryname = argv[0];
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	e8 34 f8 ff ff       	call   800038 <_main>
  800804:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800807:	e8 ff 19 00 00       	call   80220b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80080c:	83 ec 0c             	sub    $0xc,%esp
  80080f:	68 94 37 80 00       	push   $0x803794
  800814:	e8 76 03 00 00       	call   800b8f <cprintf>
  800819:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80081c:	a1 24 40 80 00       	mov    0x804024,%eax
  800821:	8b 90 d4 05 00 00    	mov    0x5d4(%eax),%edx
  800827:	a1 24 40 80 00       	mov    0x804024,%eax
  80082c:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	52                   	push   %edx
  800836:	50                   	push   %eax
  800837:	68 bc 37 80 00       	push   $0x8037bc
  80083c:	e8 4e 03 00 00       	call   800b8f <cprintf>
  800841:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800844:	a1 24 40 80 00       	mov    0x804024,%eax
  800849:	8b 88 e8 05 00 00    	mov    0x5e8(%eax),%ecx
  80084f:	a1 24 40 80 00       	mov    0x804024,%eax
  800854:	8b 90 e4 05 00 00    	mov    0x5e4(%eax),%edx
  80085a:	a1 24 40 80 00       	mov    0x804024,%eax
  80085f:	8b 80 e0 05 00 00    	mov    0x5e0(%eax),%eax
  800865:	51                   	push   %ecx
  800866:	52                   	push   %edx
  800867:	50                   	push   %eax
  800868:	68 e4 37 80 00       	push   $0x8037e4
  80086d:	e8 1d 03 00 00       	call   800b8f <cprintf>
  800872:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800875:	a1 24 40 80 00       	mov    0x804024,%eax
  80087a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	50                   	push   %eax
  800884:	68 3c 38 80 00       	push   $0x80383c
  800889:	e8 01 03 00 00       	call   800b8f <cprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800891:	83 ec 0c             	sub    $0xc,%esp
  800894:	68 94 37 80 00       	push   $0x803794
  800899:	e8 f1 02 00 00       	call   800b8f <cprintf>
  80089e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a1:	e8 7f 19 00 00       	call   802225 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008a6:	e8 19 00 00 00       	call   8008c4 <exit>
}
  8008ab:	90                   	nop
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	6a 00                	push   $0x0
  8008b9:	e8 0c 1b 00 00       	call   8023ca <sys_destroy_env>
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	90                   	nop
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <exit>:

void
exit(void)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008ca:	e8 61 1b 00 00       	call   802430 <sys_exit_env>
}
  8008cf:	90                   	nop
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008db:	83 c0 04             	add    $0x4,%eax
  8008de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e1:	a1 2c 41 80 00       	mov    0x80412c,%eax
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	74 16                	je     800900 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ea:	a1 2c 41 80 00       	mov    0x80412c,%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	50                   	push   %eax
  8008f3:	68 50 38 80 00       	push   $0x803850
  8008f8:	e8 92 02 00 00       	call   800b8f <cprintf>
  8008fd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800900:	a1 00 40 80 00       	mov    0x804000,%eax
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	50                   	push   %eax
  80090c:	68 55 38 80 00       	push   $0x803855
  800911:	e8 79 02 00 00       	call   800b8f <cprintf>
  800916:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800919:	8b 45 10             	mov    0x10(%ebp),%eax
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 f4             	pushl  -0xc(%ebp)
  800922:	50                   	push   %eax
  800923:	e8 fc 01 00 00       	call   800b24 <vcprintf>
  800928:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	6a 00                	push   $0x0
  800930:	68 71 38 80 00       	push   $0x803871
  800935:	e8 ea 01 00 00       	call   800b24 <vcprintf>
  80093a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80093d:	e8 82 ff ff ff       	call   8008c4 <exit>

	// should not return here
	while (1) ;
  800942:	eb fe                	jmp    800942 <_panic+0x70>

00800944 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094a:	a1 24 40 80 00       	mov    0x804024,%eax
  80094f:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	74 14                	je     800970 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 74 38 80 00       	push   $0x803874
  800964:	6a 26                	push   $0x26
  800966:	68 c0 38 80 00       	push   $0x8038c0
  80096b:	e8 62 ff ff ff       	call   8008d2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800970:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800977:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097e:	e9 c5 00 00 00       	jmp    800a48 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800986:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	85 c0                	test   %eax,%eax
  800996:	75 08                	jne    8009a0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800998:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099b:	e9 a5 00 00 00       	jmp    800a45 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009ae:	eb 69                	jmp    800a19 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b0:	a1 24 40 80 00       	mov    0x804024,%eax
  8009b5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8009bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	01 c0                	add    %eax,%eax
  8009c2:	01 d0                	add    %edx,%eax
  8009c4:	c1 e0 03             	shl    $0x3,%eax
  8009c7:	01 c8                	add    %ecx,%eax
  8009c9:	8a 40 04             	mov    0x4(%eax),%al
  8009cc:	84 c0                	test   %al,%al
  8009ce:	75 46                	jne    800a16 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d0:	a1 24 40 80 00       	mov    0x804024,%eax
  8009d5:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8009db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	01 c0                	add    %eax,%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	c1 e0 03             	shl    $0x3,%eax
  8009e7:	01 c8                	add    %ecx,%eax
  8009e9:	8b 00                	mov    (%eax),%eax
  8009eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a09:	39 c2                	cmp    %eax,%edx
  800a0b:	75 09                	jne    800a16 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a0d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a14:	eb 15                	jmp    800a2b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a16:	ff 45 e8             	incl   -0x18(%ebp)
  800a19:	a1 24 40 80 00       	mov    0x804024,%eax
  800a1e:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	77 85                	ja     8009b0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2f:	75 14                	jne    800a45 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 cc 38 80 00       	push   $0x8038cc
  800a39:	6a 3a                	push   $0x3a
  800a3b:	68 c0 38 80 00       	push   $0x8038c0
  800a40:	e8 8d fe ff ff       	call   8008d2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a45:	ff 45 f0             	incl   -0x10(%ebp)
  800a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4e:	0f 8c 2f ff ff ff    	jl     800983 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a62:	eb 26                	jmp    800a8a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a64:	a1 24 40 80 00       	mov    0x804024,%eax
  800a69:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800a6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a72:	89 d0                	mov    %edx,%eax
  800a74:	01 c0                	add    %eax,%eax
  800a76:	01 d0                	add    %edx,%eax
  800a78:	c1 e0 03             	shl    $0x3,%eax
  800a7b:	01 c8                	add    %ecx,%eax
  800a7d:	8a 40 04             	mov    0x4(%eax),%al
  800a80:	3c 01                	cmp    $0x1,%al
  800a82:	75 03                	jne    800a87 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a84:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a87:	ff 45 e0             	incl   -0x20(%ebp)
  800a8a:	a1 24 40 80 00       	mov    0x804024,%eax
  800a8f:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
  800a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a98:	39 c2                	cmp    %eax,%edx
  800a9a:	77 c8                	ja     800a64 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aa2:	74 14                	je     800ab8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800aa4:	83 ec 04             	sub    $0x4,%esp
  800aa7:	68 20 39 80 00       	push   $0x803920
  800aac:	6a 44                	push   $0x44
  800aae:	68 c0 38 80 00       	push   $0x8038c0
  800ab3:	e8 1a fe ff ff       	call   8008d2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab8:	90                   	nop
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	8b 00                	mov    (%eax),%eax
  800ac6:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 0a                	mov    %ecx,(%edx)
  800ace:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad1:	88 d1                	mov    %dl,%cl
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae4:	75 2c                	jne    800b12 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae6:	a0 28 40 80 00       	mov    0x804028,%al
  800aeb:	0f b6 c0             	movzbl %al,%eax
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	8b 12                	mov    (%edx),%edx
  800af3:	89 d1                	mov    %edx,%ecx
  800af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af8:	83 c2 08             	add    $0x8,%edx
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	50                   	push   %eax
  800aff:	51                   	push   %ecx
  800b00:	52                   	push   %edx
  800b01:	e8 ac 15 00 00       	call   8020b2 <sys_cputs>
  800b06:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 40 04             	mov    0x4(%eax),%eax
  800b18:	8d 50 01             	lea    0x1(%eax),%edx
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b21:	90                   	nop
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b34:	00 00 00 
	b.cnt = 0;
  800b37:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	ff 75 08             	pushl  0x8(%ebp)
  800b47:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b4d:	50                   	push   %eax
  800b4e:	68 bb 0a 80 00       	push   $0x800abb
  800b53:	e8 11 02 00 00       	call   800d69 <vprintfmt>
  800b58:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b5b:	a0 28 40 80 00       	mov    0x804028,%al
  800b60:	0f b6 c0             	movzbl %al,%eax
  800b63:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	50                   	push   %eax
  800b6d:	52                   	push   %edx
  800b6e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b74:	83 c0 08             	add    $0x8,%eax
  800b77:	50                   	push   %eax
  800b78:	e8 35 15 00 00       	call   8020b2 <sys_cputs>
  800b7d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b80:	c6 05 28 40 80 00 00 	movb   $0x0,0x804028
	return b.cnt;
  800b87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b95:	c6 05 28 40 80 00 01 	movb   $0x1,0x804028
	va_start(ap, fmt);
  800b9c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bab:	50                   	push   %eax
  800bac:	e8 73 ff ff ff       	call   800b24 <vcprintf>
  800bb1:	83 c4 10             	add    $0x10,%esp
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bc2:	e8 44 16 00 00       	call   80220b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	e8 48 ff ff ff       	call   800b24 <vcprintf>
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800be2:	e8 3e 16 00 00       	call   802225 <sys_enable_interrupt>
	return cnt;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	53                   	push   %ebx
  800bf0:	83 ec 14             	sub    $0x14,%esp
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bff:	8b 45 18             	mov    0x18(%ebp),%eax
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0a:	77 55                	ja     800c61 <printnum+0x75>
  800c0c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0f:	72 05                	jb     800c16 <printnum+0x2a>
  800c11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c14:	77 4b                	ja     800c61 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c16:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c19:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c1c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	52                   	push   %edx
  800c25:	50                   	push   %eax
  800c26:	ff 75 f4             	pushl  -0xc(%ebp)
  800c29:	ff 75 f0             	pushl  -0x10(%ebp)
  800c2c:	e8 ef 26 00 00       	call   803320 <__udivdi3>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	83 ec 04             	sub    $0x4,%esp
  800c37:	ff 75 20             	pushl  0x20(%ebp)
  800c3a:	53                   	push   %ebx
  800c3b:	ff 75 18             	pushl  0x18(%ebp)
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	ff 75 08             	pushl  0x8(%ebp)
  800c46:	e8 a1 ff ff ff       	call   800bec <printnum>
  800c4b:	83 c4 20             	add    $0x20,%esp
  800c4e:	eb 1a                	jmp    800c6a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 20             	pushl  0x20(%ebp)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c61:	ff 4d 1c             	decl   0x1c(%ebp)
  800c64:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c68:	7f e6                	jg     800c50 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c6a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c78:	53                   	push   %ebx
  800c79:	51                   	push   %ecx
  800c7a:	52                   	push   %edx
  800c7b:	50                   	push   %eax
  800c7c:	e8 af 27 00 00       	call   803430 <__umoddi3>
  800c81:	83 c4 10             	add    $0x10,%esp
  800c84:	05 94 3b 80 00       	add    $0x803b94,%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f be c0             	movsbl %al,%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
}
  800c9d:	90                   	nop
  800c9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800caa:	7e 1c                	jle    800cc8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	8d 50 08             	lea    0x8(%eax),%edx
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	89 10                	mov    %edx,(%eax)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8b 00                	mov    (%eax),%eax
  800cbe:	83 e8 08             	sub    $0x8,%eax
  800cc1:	8b 50 04             	mov    0x4(%eax),%edx
  800cc4:	8b 00                	mov    (%eax),%eax
  800cc6:	eb 40                	jmp    800d08 <getuint+0x65>
	else if (lflag)
  800cc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccc:	74 1e                	je     800cec <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	8d 50 04             	lea    0x4(%eax),%edx
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 10                	mov    %edx,(%eax)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8b 00                	mov    (%eax),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cea:	eb 1c                	jmp    800d08 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	8d 50 04             	lea    0x4(%eax),%edx
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	89 10                	mov    %edx,(%eax)
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	83 e8 04             	sub    $0x4,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d0d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d11:	7e 1c                	jle    800d2f <getint+0x25>
		return va_arg(*ap, long long);
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8b 00                	mov    (%eax),%eax
  800d18:	8d 50 08             	lea    0x8(%eax),%edx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 10                	mov    %edx,(%eax)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	83 e8 08             	sub    $0x8,%eax
  800d28:	8b 50 04             	mov    0x4(%eax),%edx
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	eb 38                	jmp    800d67 <getint+0x5d>
	else if (lflag)
  800d2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d33:	74 1a                	je     800d4f <getint+0x45>
		return va_arg(*ap, long);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8b 00                	mov    (%eax),%eax
  800d3a:	8d 50 04             	lea    0x4(%eax),%edx
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	89 10                	mov    %edx,(%eax)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8b 00                	mov    (%eax),%eax
  800d47:	83 e8 04             	sub    $0x4,%eax
  800d4a:	8b 00                	mov    (%eax),%eax
  800d4c:	99                   	cltd   
  800d4d:	eb 18                	jmp    800d67 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	8d 50 04             	lea    0x4(%eax),%edx
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 10                	mov    %edx,(%eax)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	83 e8 04             	sub    $0x4,%eax
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	99                   	cltd   
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d71:	eb 17                	jmp    800d8a <vprintfmt+0x21>
			if (ch == '\0')
  800d73:	85 db                	test   %ebx,%ebx
  800d75:	0f 84 af 03 00 00    	je     80112a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d7b:	83 ec 08             	sub    $0x8,%esp
  800d7e:	ff 75 0c             	pushl  0xc(%ebp)
  800d81:	53                   	push   %ebx
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	ff d0                	call   *%eax
  800d87:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 10             	mov    %edx,0x10(%ebp)
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	0f b6 d8             	movzbl %al,%ebx
  800d98:	83 fb 25             	cmp    $0x25,%ebx
  800d9b:	75 d6                	jne    800d73 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d9d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800da1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800daf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	8d 50 01             	lea    0x1(%eax),%edx
  800dc3:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	0f b6 d8             	movzbl %al,%ebx
  800dcb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dce:	83 f8 55             	cmp    $0x55,%eax
  800dd1:	0f 87 2b 03 00 00    	ja     801102 <vprintfmt+0x399>
  800dd7:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  800dde:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800de0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de4:	eb d7                	jmp    800dbd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dea:	eb d1                	jmp    800dbd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df6:	89 d0                	mov    %edx,%eax
  800df8:	c1 e0 02             	shl    $0x2,%eax
  800dfb:	01 d0                	add    %edx,%eax
  800dfd:	01 c0                	add    %eax,%eax
  800dff:	01 d8                	add    %ebx,%eax
  800e01:	83 e8 30             	sub    $0x30,%eax
  800e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0f:	83 fb 2f             	cmp    $0x2f,%ebx
  800e12:	7e 3e                	jle    800e52 <vprintfmt+0xe9>
  800e14:	83 fb 39             	cmp    $0x39,%ebx
  800e17:	7f 39                	jg     800e52 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e19:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e1c:	eb d5                	jmp    800df3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e21:	83 c0 04             	add    $0x4,%eax
  800e24:	89 45 14             	mov    %eax,0x14(%ebp)
  800e27:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2a:	83 e8 04             	sub    $0x4,%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e32:	eb 1f                	jmp    800e53 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e38:	79 83                	jns    800dbd <vprintfmt+0x54>
				width = 0;
  800e3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e41:	e9 77 ff ff ff       	jmp    800dbd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e46:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e4d:	e9 6b ff ff ff       	jmp    800dbd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e52:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e57:	0f 89 60 ff ff ff    	jns    800dbd <vprintfmt+0x54>
				width = precision, precision = -1;
  800e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e63:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e6a:	e9 4e ff ff ff       	jmp    800dbd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e72:	e9 46 ff ff ff       	jmp    800dbd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 c0 04             	add    $0x4,%eax
  800e7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e80:	8b 45 14             	mov    0x14(%ebp),%eax
  800e83:	83 e8 04             	sub    $0x4,%eax
  800e86:	8b 00                	mov    (%eax),%eax
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	50                   	push   %eax
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			break;
  800e97:	e9 89 02 00 00       	jmp    801125 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9f:	83 c0 04             	add    $0x4,%eax
  800ea2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea8:	83 e8 04             	sub    $0x4,%eax
  800eab:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ead:	85 db                	test   %ebx,%ebx
  800eaf:	79 02                	jns    800eb3 <vprintfmt+0x14a>
				err = -err;
  800eb1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eb3:	83 fb 64             	cmp    $0x64,%ebx
  800eb6:	7f 0b                	jg     800ec3 <vprintfmt+0x15a>
  800eb8:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800ebf:	85 f6                	test   %esi,%esi
  800ec1:	75 19                	jne    800edc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ec3:	53                   	push   %ebx
  800ec4:	68 a5 3b 80 00       	push   $0x803ba5
  800ec9:	ff 75 0c             	pushl  0xc(%ebp)
  800ecc:	ff 75 08             	pushl  0x8(%ebp)
  800ecf:	e8 5e 02 00 00       	call   801132 <printfmt>
  800ed4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed7:	e9 49 02 00 00       	jmp    801125 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800edc:	56                   	push   %esi
  800edd:	68 ae 3b 80 00       	push   $0x803bae
  800ee2:	ff 75 0c             	pushl  0xc(%ebp)
  800ee5:	ff 75 08             	pushl  0x8(%ebp)
  800ee8:	e8 45 02 00 00       	call   801132 <printfmt>
  800eed:	83 c4 10             	add    $0x10,%esp
			break;
  800ef0:	e9 30 02 00 00       	jmp    801125 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	83 c0 04             	add    $0x4,%eax
  800efb:	89 45 14             	mov    %eax,0x14(%ebp)
  800efe:	8b 45 14             	mov    0x14(%ebp),%eax
  800f01:	83 e8 04             	sub    $0x4,%eax
  800f04:	8b 30                	mov    (%eax),%esi
  800f06:	85 f6                	test   %esi,%esi
  800f08:	75 05                	jne    800f0f <vprintfmt+0x1a6>
				p = "(null)";
  800f0a:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800f0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f13:	7e 6d                	jle    800f82 <vprintfmt+0x219>
  800f15:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f19:	74 67                	je     800f82 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	50                   	push   %eax
  800f22:	56                   	push   %esi
  800f23:	e8 12 05 00 00       	call   80143a <strnlen>
  800f28:	83 c4 10             	add    $0x10,%esp
  800f2b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2e:	eb 16                	jmp    800f46 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f30:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	50                   	push   %eax
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f43:	ff 4d e4             	decl   -0x1c(%ebp)
  800f46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f4a:	7f e4                	jg     800f30 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f4c:	eb 34                	jmp    800f82 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f52:	74 1c                	je     800f70 <vprintfmt+0x207>
  800f54:	83 fb 1f             	cmp    $0x1f,%ebx
  800f57:	7e 05                	jle    800f5e <vprintfmt+0x1f5>
  800f59:	83 fb 7e             	cmp    $0x7e,%ebx
  800f5c:	7e 12                	jle    800f70 <vprintfmt+0x207>
					putch('?', putdat);
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	6a 3f                	push   $0x3f
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	eb 0f                	jmp    800f7f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	53                   	push   %ebx
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	ff d0                	call   *%eax
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f82:	89 f0                	mov    %esi,%eax
  800f84:	8d 70 01             	lea    0x1(%eax),%esi
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f be d8             	movsbl %al,%ebx
  800f8c:	85 db                	test   %ebx,%ebx
  800f8e:	74 24                	je     800fb4 <vprintfmt+0x24b>
  800f90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f94:	78 b8                	js     800f4e <vprintfmt+0x1e5>
  800f96:	ff 4d e0             	decl   -0x20(%ebp)
  800f99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f9d:	79 af                	jns    800f4e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9f:	eb 13                	jmp    800fb4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	6a 20                	push   $0x20
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	ff d0                	call   *%eax
  800fae:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb8:	7f e7                	jg     800fa1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fba:	e9 66 01 00 00       	jmp    801125 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc8:	50                   	push   %eax
  800fc9:	e8 3c fd ff ff       	call   800d0a <getint>
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdd:	85 d2                	test   %edx,%edx
  800fdf:	79 23                	jns    801004 <vprintfmt+0x29b>
				putch('-', putdat);
  800fe1:	83 ec 08             	sub    $0x8,%esp
  800fe4:	ff 75 0c             	pushl  0xc(%ebp)
  800fe7:	6a 2d                	push   $0x2d
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	ff d0                	call   *%eax
  800fee:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff7:	f7 d8                	neg    %eax
  800ff9:	83 d2 00             	adc    $0x0,%edx
  800ffc:	f7 da                	neg    %edx
  800ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801001:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801004:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80100b:	e9 bc 00 00 00       	jmp    8010cc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 e8             	pushl  -0x18(%ebp)
  801016:	8d 45 14             	lea    0x14(%ebp),%eax
  801019:	50                   	push   %eax
  80101a:	e8 84 fc ff ff       	call   800ca3 <getuint>
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801025:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801028:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102f:	e9 98 00 00 00       	jmp    8010cc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801034:	83 ec 08             	sub    $0x8,%esp
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	6a 58                	push   $0x58
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	ff d0                	call   *%eax
  801041:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801044:	83 ec 08             	sub    $0x8,%esp
  801047:	ff 75 0c             	pushl  0xc(%ebp)
  80104a:	6a 58                	push   $0x58
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	ff d0                	call   *%eax
  801051:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	6a 58                	push   $0x58
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	ff d0                	call   *%eax
  801061:	83 c4 10             	add    $0x10,%esp
			break;
  801064:	e9 bc 00 00 00       	jmp    801125 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	6a 30                	push   $0x30
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	ff d0                	call   *%eax
  801076:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	6a 78                	push   $0x78
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	ff d0                	call   *%eax
  801086:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801089:	8b 45 14             	mov    0x14(%ebp),%eax
  80108c:	83 c0 04             	add    $0x4,%eax
  80108f:	89 45 14             	mov    %eax,0x14(%ebp)
  801092:	8b 45 14             	mov    0x14(%ebp),%eax
  801095:	83 e8 04             	sub    $0x4,%eax
  801098:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010ab:	eb 1f                	jmp    8010cc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8010b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b6:	50                   	push   %eax
  8010b7:	e8 e7 fb ff ff       	call   800ca3 <getuint>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010cc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	52                   	push   %edx
  8010d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010da:	50                   	push   %eax
  8010db:	ff 75 f4             	pushl  -0xc(%ebp)
  8010de:	ff 75 f0             	pushl  -0x10(%ebp)
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	ff 75 08             	pushl  0x8(%ebp)
  8010e7:	e8 00 fb ff ff       	call   800bec <printnum>
  8010ec:	83 c4 20             	add    $0x20,%esp
			break;
  8010ef:	eb 34                	jmp    801125 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	ff 75 0c             	pushl  0xc(%ebp)
  8010f7:	53                   	push   %ebx
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	ff d0                	call   *%eax
  8010fd:	83 c4 10             	add    $0x10,%esp
			break;
  801100:	eb 23                	jmp    801125 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	6a 25                	push   $0x25
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801112:	ff 4d 10             	decl   0x10(%ebp)
  801115:	eb 03                	jmp    80111a <vprintfmt+0x3b1>
  801117:	ff 4d 10             	decl   0x10(%ebp)
  80111a:	8b 45 10             	mov    0x10(%ebp),%eax
  80111d:	48                   	dec    %eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 25                	cmp    $0x25,%al
  801122:	75 f3                	jne    801117 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801124:	90                   	nop
		}
	}
  801125:	e9 47 fc ff ff       	jmp    800d71 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80112a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80112b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801138:	8d 45 10             	lea    0x10(%ebp),%eax
  80113b:	83 c0 04             	add    $0x4,%eax
  80113e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	ff 75 f4             	pushl  -0xc(%ebp)
  801147:	50                   	push   %eax
  801148:	ff 75 0c             	pushl  0xc(%ebp)
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 16 fc ff ff       	call   800d69 <vprintfmt>
  801153:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801156:	90                   	nop
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80115c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115f:	8b 40 08             	mov    0x8(%eax),%eax
  801162:	8d 50 01             	lea    0x1(%eax),%edx
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8b 10                	mov    (%eax),%edx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	8b 40 04             	mov    0x4(%eax),%eax
  801176:	39 c2                	cmp    %eax,%edx
  801178:	73 12                	jae    80118c <sprintputch+0x33>
		*b->buf++ = ch;
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	8b 00                	mov    (%eax),%eax
  80117f:	8d 48 01             	lea    0x1(%eax),%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	89 0a                	mov    %ecx,(%edx)
  801187:	8b 55 08             	mov    0x8(%ebp),%edx
  80118a:	88 10                	mov    %dl,(%eax)
}
  80118c:	90                   	nop
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 d0                	add    %edx,%eax
  8011a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b4:	74 06                	je     8011bc <vsnprintf+0x2d>
  8011b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011ba:	7f 07                	jg     8011c3 <vsnprintf+0x34>
		return -E_INVAL;
  8011bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8011c1:	eb 20                	jmp    8011e3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011c3:	ff 75 14             	pushl  0x14(%ebp)
  8011c6:	ff 75 10             	pushl  0x10(%ebp)
  8011c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	68 59 11 80 00       	push   $0x801159
  8011d2:	e8 92 fb ff ff       	call   800d69 <vprintfmt>
  8011d7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011eb:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ee:	83 c0 04             	add    $0x4,%eax
  8011f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fa:	50                   	push   %eax
  8011fb:	ff 75 0c             	pushl  0xc(%ebp)
  8011fe:	ff 75 08             	pushl  0x8(%ebp)
  801201:	e8 89 ff ff ff       	call   80118f <vsnprintf>
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80120c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121b:	74 13                	je     801230 <readline+0x1f>
		cprintf("%s", prompt);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 08             	pushl  0x8(%ebp)
  801223:	68 10 3d 80 00       	push   $0x803d10
  801228:	e8 62 f9 ff ff       	call   800b8f <cprintf>
  80122d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801237:	83 ec 0c             	sub    $0xc,%esp
  80123a:	6a 00                	push   $0x0
  80123c:	e8 50 f5 ff ff       	call   800791 <iscons>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801247:	e8 f7 f4 ff ff       	call   800743 <getchar>
  80124c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801253:	79 22                	jns    801277 <readline+0x66>
			if (c != -E_EOF)
  801255:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801259:	0f 84 ad 00 00 00    	je     80130c <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	ff 75 ec             	pushl  -0x14(%ebp)
  801265:	68 13 3d 80 00       	push   $0x803d13
  80126a:	e8 20 f9 ff ff       	call   800b8f <cprintf>
  80126f:	83 c4 10             	add    $0x10,%esp
			return;
  801272:	e9 95 00 00 00       	jmp    80130c <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801277:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80127b:	7e 34                	jle    8012b1 <readline+0xa0>
  80127d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801284:	7f 2b                	jg     8012b1 <readline+0xa0>
			if (echoing)
  801286:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128a:	74 0e                	je     80129a <readline+0x89>
				cputchar(c);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	ff 75 ec             	pushl  -0x14(%ebp)
  801292:	e8 64 f4 ff ff       	call   8006fb <cputchar>
  801297:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80129a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129d:	8d 50 01             	lea    0x1(%eax),%edx
  8012a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012ad:	88 10                	mov    %dl,(%eax)
  8012af:	eb 56                	jmp    801307 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b5:	75 1f                	jne    8012d6 <readline+0xc5>
  8012b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012bb:	7e 19                	jle    8012d6 <readline+0xc5>
			if (echoing)
  8012bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c1:	74 0e                	je     8012d1 <readline+0xc0>
				cputchar(c);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c9:	e8 2d f4 ff ff       	call   8006fb <cputchar>
  8012ce:	83 c4 10             	add    $0x10,%esp

			i--;
  8012d1:	ff 4d f4             	decl   -0xc(%ebp)
  8012d4:	eb 31                	jmp    801307 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012da:	74 0a                	je     8012e6 <readline+0xd5>
  8012dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012e0:	0f 85 61 ff ff ff    	jne    801247 <readline+0x36>
			if (echoing)
  8012e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ea:	74 0e                	je     8012fa <readline+0xe9>
				cputchar(c);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f2:	e8 04 f4 ff ff       	call   8006fb <cputchar>
  8012f7:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801305:	eb 06                	jmp    80130d <readline+0xfc>
		}
	}
  801307:	e9 3b ff ff ff       	jmp    801247 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80130c:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801315:	e8 f1 0e 00 00       	call   80220b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  80131a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 08             	pushl  0x8(%ebp)
  801326:	68 10 3d 80 00       	push   $0x803d10
  80132b:	e8 5f f8 ff ff       	call   800b8f <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	6a 00                	push   $0x0
  80133f:	e8 4d f4 ff ff       	call   800791 <iscons>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80134a:	e8 f4 f3 ff ff       	call   800743 <getchar>
  80134f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801352:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801356:	79 23                	jns    80137b <atomic_readline+0x6c>
			if (c != -E_EOF)
  801358:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80135c:	74 13                	je     801371 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	ff 75 ec             	pushl  -0x14(%ebp)
  801364:	68 13 3d 80 00       	push   $0x803d13
  801369:	e8 21 f8 ff ff       	call   800b8f <cprintf>
  80136e:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801371:	e8 af 0e 00 00       	call   802225 <sys_enable_interrupt>
			return;
  801376:	e9 9a 00 00 00       	jmp    801415 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80137b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137f:	7e 34                	jle    8013b5 <atomic_readline+0xa6>
  801381:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801388:	7f 2b                	jg     8013b5 <atomic_readline+0xa6>
			if (echoing)
  80138a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138e:	74 0e                	je     80139e <atomic_readline+0x8f>
				cputchar(c);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	ff 75 ec             	pushl  -0x14(%ebp)
  801396:	e8 60 f3 ff ff       	call   8006fb <cputchar>
  80139b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a1:	8d 50 01             	lea    0x1(%eax),%edx
  8013a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b1:	88 10                	mov    %dl,(%eax)
  8013b3:	eb 5b                	jmp    801410 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b9:	75 1f                	jne    8013da <atomic_readline+0xcb>
  8013bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bf:	7e 19                	jle    8013da <atomic_readline+0xcb>
			if (echoing)
  8013c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c5:	74 0e                	je     8013d5 <atomic_readline+0xc6>
				cputchar(c);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8013cd:	e8 29 f3 ff ff       	call   8006fb <cputchar>
  8013d2:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d5:	ff 4d f4             	decl   -0xc(%ebp)
  8013d8:	eb 36                	jmp    801410 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013da:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013de:	74 0a                	je     8013ea <atomic_readline+0xdb>
  8013e0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e4:	0f 85 60 ff ff ff    	jne    80134a <atomic_readline+0x3b>
			if (echoing)
  8013ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ee:	74 0e                	je     8013fe <atomic_readline+0xef>
				cputchar(c);
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f6:	e8 00 f3 ff ff       	call   8006fb <cputchar>
  8013fb:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801409:	e8 17 0e 00 00       	call   802225 <sys_enable_interrupt>
			return;
  80140e:	eb 05                	jmp    801415 <atomic_readline+0x106>
		}
	}
  801410:	e9 35 ff ff ff       	jmp    80134a <atomic_readline+0x3b>
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strlen>:

#include <inc/string.h>
#include <inc/assert.h>
int
strlen(const char *s)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80141d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801424:	eb 06                	jmp    80142c <strlen+0x15>
		n++;
  801426:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801429:	ff 45 08             	incl   0x8(%ebp)
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 f1                	jne    801426 <strlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801447:	eb 09                	jmp    801452 <strnlen+0x18>
		n++;
  801449:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80144c:	ff 45 08             	incl   0x8(%ebp)
  80144f:	ff 4d 0c             	decl   0xc(%ebp)
  801452:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801456:	74 09                	je     801461 <strnlen+0x27>
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	84 c0                	test   %al,%al
  80145f:	75 e8                	jne    801449 <strnlen+0xf>
		n++;
	return n;
  801461:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801472:	90                   	nop
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8d 50 01             	lea    0x1(%eax),%edx
  801479:	89 55 08             	mov    %edx,0x8(%ebp)
  80147c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801482:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801485:	8a 12                	mov    (%edx),%dl
  801487:	88 10                	mov    %dl,(%eax)
  801489:	8a 00                	mov    (%eax),%al
  80148b:	84 c0                	test   %al,%al
  80148d:	75 e4                	jne    801473 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a7:	eb 1f                	jmp    8014c8 <strncpy+0x34>
		*dst++ = *src;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8d 50 01             	lea    0x1(%eax),%edx
  8014af:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b5:	8a 12                	mov    (%edx),%dl
  8014b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	84 c0                	test   %al,%al
  8014c0:	74 03                	je     8014c5 <strncpy+0x31>
			src++;
  8014c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c5:	ff 45 fc             	incl   -0x4(%ebp)
  8014c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ce:	72 d9                	jb     8014a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e5:	74 30                	je     801517 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e7:	eb 16                	jmp    8014ff <strlcpy+0x2a>
			*dst++ = *src++;
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8d 50 01             	lea    0x1(%eax),%edx
  8014ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014fb:	8a 12                	mov    (%edx),%dl
  8014fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014ff:	ff 4d 10             	decl   0x10(%ebp)
  801502:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801506:	74 09                	je     801511 <strlcpy+0x3c>
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	84 c0                	test   %al,%al
  80150f:	75 d8                	jne    8014e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801526:	eb 06                	jmp    80152e <strcmp+0xb>
		p++, q++;
  801528:	ff 45 08             	incl   0x8(%ebp)
  80152b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	74 0e                	je     801545 <strcmp+0x22>
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8a 10                	mov    (%eax),%dl
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	38 c2                	cmp    %al,%dl
  801543:	74 e3                	je     801528 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	0f b6 d0             	movzbl %al,%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	0f b6 c0             	movzbl %al,%eax
  801555:	29 c2                	sub    %eax,%edx
  801557:	89 d0                	mov    %edx,%eax
}
  801559:	5d                   	pop    %ebp
  80155a:	c3                   	ret    

0080155b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155e:	eb 09                	jmp    801569 <strncmp+0xe>
		n--, p++, q++;
  801560:	ff 4d 10             	decl   0x10(%ebp)
  801563:	ff 45 08             	incl   0x8(%ebp)
  801566:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801569:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156d:	74 17                	je     801586 <strncmp+0x2b>
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	84 c0                	test   %al,%al
  801576:	74 0e                	je     801586 <strncmp+0x2b>
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8a 10                	mov    (%eax),%dl
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	38 c2                	cmp    %al,%dl
  801584:	74 da                	je     801560 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801586:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158a:	75 07                	jne    801593 <strncmp+0x38>
		return 0;
  80158c:	b8 00 00 00 00       	mov    $0x0,%eax
  801591:	eb 14                	jmp    8015a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	0f b6 d0             	movzbl %al,%edx
  80159b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159e:	8a 00                	mov    (%eax),%al
  8015a0:	0f b6 c0             	movzbl %al,%eax
  8015a3:	29 c2                	sub    %eax,%edx
  8015a5:	89 d0                	mov    %edx,%eax
}
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b5:	eb 12                	jmp    8015c9 <strchr+0x20>
		if (*s == c)
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8a 00                	mov    (%eax),%al
  8015bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bf:	75 05                	jne    8015c6 <strchr+0x1d>
			return (char *) s;
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	eb 11                	jmp    8015d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c6:	ff 45 08             	incl   0x8(%ebp)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	84 c0                	test   %al,%al
  8015d0:	75 e5                	jne    8015b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e5:	eb 0d                	jmp    8015f4 <strfind+0x1b>
		if (*s == c)
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015ef:	74 0e                	je     8015ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015f1:	ff 45 08             	incl   0x8(%ebp)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	84 c0                	test   %al,%al
  8015fb:	75 ea                	jne    8015e7 <strfind+0xe>
  8015fd:	eb 01                	jmp    801600 <strfind+0x27>
		if (*s == c)
			break;
  8015ff:	90                   	nop
	return (char *) s;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801611:	8b 45 10             	mov    0x10(%ebp),%eax
  801614:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801617:	eb 0e                	jmp    801627 <memset+0x22>
		*p++ = c;
  801619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801627:	ff 4d f8             	decl   -0x8(%ebp)
  80162a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162e:	79 e9                	jns    801619 <memset+0x14>
		*p++ = c;

	return v;
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801647:	eb 16                	jmp    80165f <memcpy+0x2a>
		*d++ = *s++;
  801649:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164c:	8d 50 01             	lea    0x1(%eax),%edx
  80164f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801652:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801655:	8d 4a 01             	lea    0x1(%edx),%ecx
  801658:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165f:	8b 45 10             	mov    0x10(%ebp),%eax
  801662:	8d 50 ff             	lea    -0x1(%eax),%edx
  801665:	89 55 10             	mov    %edx,0x10(%ebp)
  801668:	85 c0                	test   %eax,%eax
  80166a:	75 dd                	jne    801649 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801683:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801689:	73 50                	jae    8016db <memmove+0x6a>
  80168b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801696:	76 43                	jbe    8016db <memmove+0x6a>
		s += n;
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169e:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a4:	eb 10                	jmp    8016b6 <memmove+0x45>
			*--d = *--s;
  8016a6:	ff 4d f8             	decl   -0x8(%ebp)
  8016a9:	ff 4d fc             	decl   -0x4(%ebp)
  8016ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016af:	8a 10                	mov    (%eax),%dl
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	75 e3                	jne    8016a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c3:	eb 23                	jmp    8016e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c8:	8d 50 01             	lea    0x1(%eax),%edx
  8016cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d7:	8a 12                	mov    (%edx),%dl
  8016d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	75 dd                	jne    8016c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016ff:	eb 2a                	jmp    80172b <memcmp+0x3e>
		if (*s1 != *s2)
  801701:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801704:	8a 10                	mov    (%eax),%dl
  801706:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	38 c2                	cmp    %al,%dl
  80170d:	74 16                	je     801725 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	0f b6 d0             	movzbl %al,%edx
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	0f b6 c0             	movzbl %al,%eax
  80171f:	29 c2                	sub    %eax,%edx
  801721:	89 d0                	mov    %edx,%eax
  801723:	eb 18                	jmp    80173d <memcmp+0x50>
		s1++, s2++;
  801725:	ff 45 fc             	incl   -0x4(%ebp)
  801728:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80172b:	8b 45 10             	mov    0x10(%ebp),%eax
  80172e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801731:	89 55 10             	mov    %edx,0x10(%ebp)
  801734:	85 c0                	test   %eax,%eax
  801736:	75 c9                	jne    801701 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801745:	8b 55 08             	mov    0x8(%ebp),%edx
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801750:	eb 15                	jmp    801767 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	0f b6 d0             	movzbl %al,%edx
  80175a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175d:	0f b6 c0             	movzbl %al,%eax
  801760:	39 c2                	cmp    %eax,%edx
  801762:	74 0d                	je     801771 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801764:	ff 45 08             	incl   0x8(%ebp)
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80176d:	72 e3                	jb     801752 <memfind+0x13>
  80176f:	eb 01                	jmp    801772 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801771:	90                   	nop
	return (void *) s;
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80177d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801784:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178b:	eb 03                	jmp    801790 <strtol+0x19>
		s++;
  80178d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	3c 20                	cmp    $0x20,%al
  801797:	74 f4                	je     80178d <strtol+0x16>
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	3c 09                	cmp    $0x9,%al
  8017a0:	74 eb                	je     80178d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	3c 2b                	cmp    $0x2b,%al
  8017a9:	75 05                	jne    8017b0 <strtol+0x39>
		s++;
  8017ab:	ff 45 08             	incl   0x8(%ebp)
  8017ae:	eb 13                	jmp    8017c3 <strtol+0x4c>
	else if (*s == '-')
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3c 2d                	cmp    $0x2d,%al
  8017b7:	75 0a                	jne    8017c3 <strtol+0x4c>
		s++, neg = 1;
  8017b9:	ff 45 08             	incl   0x8(%ebp)
  8017bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	74 06                	je     8017cf <strtol+0x58>
  8017c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017cd:	75 20                	jne    8017ef <strtol+0x78>
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	3c 30                	cmp    $0x30,%al
  8017d6:	75 17                	jne    8017ef <strtol+0x78>
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	40                   	inc    %eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 78                	cmp    $0x78,%al
  8017e0:	75 0d                	jne    8017ef <strtol+0x78>
		s += 2, base = 16;
  8017e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017ed:	eb 28                	jmp    801817 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f3:	75 15                	jne    80180a <strtol+0x93>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 0c                	jne    80180a <strtol+0x93>
		s++, base = 8;
  8017fe:	ff 45 08             	incl   0x8(%ebp)
  801801:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801808:	eb 0d                	jmp    801817 <strtol+0xa0>
	else if (base == 0)
  80180a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180e:	75 07                	jne    801817 <strtol+0xa0>
		base = 10;
  801810:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	3c 2f                	cmp    $0x2f,%al
  80181e:	7e 19                	jle    801839 <strtol+0xc2>
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 39                	cmp    $0x39,%al
  801827:	7f 10                	jg     801839 <strtol+0xc2>
			dig = *s - '0';
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 30             	sub    $0x30,%eax
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801837:	eb 42                	jmp    80187b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	3c 60                	cmp    $0x60,%al
  801840:	7e 19                	jle    80185b <strtol+0xe4>
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8a 00                	mov    (%eax),%al
  801847:	3c 7a                	cmp    $0x7a,%al
  801849:	7f 10                	jg     80185b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8a 00                	mov    (%eax),%al
  801850:	0f be c0             	movsbl %al,%eax
  801853:	83 e8 57             	sub    $0x57,%eax
  801856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801859:	eb 20                	jmp    80187b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8a 00                	mov    (%eax),%al
  801860:	3c 40                	cmp    $0x40,%al
  801862:	7e 39                	jle    80189d <strtol+0x126>
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	8a 00                	mov    (%eax),%al
  801869:	3c 5a                	cmp    $0x5a,%al
  80186b:	7f 30                	jg     80189d <strtol+0x126>
			dig = *s - 'A' + 10;
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8a 00                	mov    (%eax),%al
  801872:	0f be c0             	movsbl %al,%eax
  801875:	83 e8 37             	sub    $0x37,%eax
  801878:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801881:	7d 19                	jge    80189c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801883:	ff 45 08             	incl   0x8(%ebp)
  801886:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801889:	0f af 45 10          	imul   0x10(%ebp),%eax
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	01 d0                	add    %edx,%eax
  801894:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801897:	e9 7b ff ff ff       	jmp    801817 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80189c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80189d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a1:	74 08                	je     8018ab <strtol+0x134>
		*endptr = (char *) s;
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018af:	74 07                	je     8018b8 <strtol+0x141>
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b4:	f7 d8                	neg    %eax
  8018b6:	eb 03                	jmp    8018bb <strtol+0x144>
  8018b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <ltostr>:

void
ltostr(long value, char *str)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d5:	79 13                	jns    8018ea <ltostr+0x2d>
	{
		neg = 1;
  8018d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f2:	99                   	cltd   
  8018f3:	f7 f9                	idiv   %ecx
  8018f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	8d 50 01             	lea    0x1(%eax),%edx
  8018fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801901:	89 c2                	mov    %eax,%edx
  801903:	8b 45 0c             	mov    0xc(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190b:	83 c2 30             	add    $0x30,%edx
  80190e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801910:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801913:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801918:	f7 e9                	imul   %ecx
  80191a:	c1 fa 02             	sar    $0x2,%edx
  80191d:	89 c8                	mov    %ecx,%eax
  80191f:	c1 f8 1f             	sar    $0x1f,%eax
  801922:	29 c2                	sub    %eax,%edx
  801924:	89 d0                	mov    %edx,%eax
  801926:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801929:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801931:	f7 e9                	imul   %ecx
  801933:	c1 fa 02             	sar    $0x2,%edx
  801936:	89 c8                	mov    %ecx,%eax
  801938:	c1 f8 1f             	sar    $0x1f,%eax
  80193b:	29 c2                	sub    %eax,%edx
  80193d:	89 d0                	mov    %edx,%eax
  80193f:	c1 e0 02             	shl    $0x2,%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	01 c0                	add    %eax,%eax
  801946:	29 c1                	sub    %eax,%ecx
  801948:	89 ca                	mov    %ecx,%edx
  80194a:	85 d2                	test   %edx,%edx
  80194c:	75 9c                	jne    8018ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801955:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801958:	48                   	dec    %eax
  801959:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80195c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801960:	74 3d                	je     80199f <ltostr+0xe2>
		start = 1 ;
  801962:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801969:	eb 34                	jmp    80199f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80196b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	01 d0                	add    %edx,%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197e:	01 c2                	add    %eax,%edx
  801980:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801983:	8b 45 0c             	mov    0xc(%ebp),%eax
  801986:	01 c8                	add    %ecx,%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80198c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	01 c2                	add    %eax,%edx
  801994:	8a 45 eb             	mov    -0x15(%ebp),%al
  801997:	88 02                	mov    %al,(%edx)
		start++ ;
  801999:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80199c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a5:	7c c4                	jl     80196b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	e8 54 fa ff ff       	call   801417 <strlen>
  8019c3:	83 c4 04             	add    $0x4,%esp
  8019c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	e8 46 fa ff ff       	call   801417 <strlen>
  8019d1:	83 c4 04             	add    $0x4,%esp
  8019d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e5:	eb 17                	jmp    8019fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ed:	01 c2                	add    %eax,%edx
  8019ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	01 c8                	add    %ecx,%eax
  8019f7:	8a 00                	mov    (%eax),%al
  8019f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019fb:	ff 45 fc             	incl   -0x4(%ebp)
  8019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a01:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a04:	7c e1                	jl     8019e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a06:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a0d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a14:	eb 1f                	jmp    801a35 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a19:	8d 50 01             	lea    0x1(%eax),%edx
  801a1c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1f:	89 c2                	mov    %eax,%edx
  801a21:	8b 45 10             	mov    0x10(%ebp),%eax
  801a24:	01 c2                	add    %eax,%edx
  801a26:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2c:	01 c8                	add    %ecx,%eax
  801a2e:	8a 00                	mov    (%eax),%al
  801a30:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a32:	ff 45 f8             	incl   -0x8(%ebp)
  801a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a3b:	7c d9                	jl     801a16 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	01 d0                	add    %edx,%eax
  801a45:	c6 00 00             	movb   $0x0,(%eax)
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a57:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	01 d0                	add    %edx,%eax
  801a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6e:	eb 0c                	jmp    801a7c <strsplit+0x31>
			*string++ = 0;
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8d 50 01             	lea    0x1(%eax),%edx
  801a76:	89 55 08             	mov    %edx,0x8(%ebp)
  801a79:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	8a 00                	mov    (%eax),%al
  801a81:	84 c0                	test   %al,%al
  801a83:	74 18                	je     801a9d <strsplit+0x52>
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	8a 00                	mov    (%eax),%al
  801a8a:	0f be c0             	movsbl %al,%eax
  801a8d:	50                   	push   %eax
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	e8 13 fb ff ff       	call   8015a9 <strchr>
  801a96:	83 c4 08             	add    $0x8,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	75 d3                	jne    801a70 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8a 00                	mov    (%eax),%al
  801aa2:	84 c0                	test   %al,%al
  801aa4:	74 5a                	je     801b00 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa9:	8b 00                	mov    (%eax),%eax
  801aab:	83 f8 0f             	cmp    $0xf,%eax
  801aae:	75 07                	jne    801ab7 <strsplit+0x6c>
		{
			return 0;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	eb 66                	jmp    801b1d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aba:	8b 00                	mov    (%eax),%eax
  801abc:	8d 48 01             	lea    0x1(%eax),%ecx
  801abf:	8b 55 14             	mov    0x14(%ebp),%edx
  801ac2:	89 0a                	mov    %ecx,(%edx)
  801ac4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ace:	01 c2                	add    %eax,%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad5:	eb 03                	jmp    801ada <strsplit+0x8f>
			string++;
  801ad7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	84 c0                	test   %al,%al
  801ae1:	74 8b                	je     801a6e <strsplit+0x23>
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	8a 00                	mov    (%eax),%al
  801ae8:	0f be c0             	movsbl %al,%eax
  801aeb:	50                   	push   %eax
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	e8 b5 fa ff ff       	call   8015a9 <strchr>
  801af4:	83 c4 08             	add    $0x8,%esp
  801af7:	85 c0                	test   %eax,%eax
  801af9:	74 dc                	je     801ad7 <strsplit+0x8c>
			string++;
	}
  801afb:	e9 6e ff ff ff       	jmp    801a6e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b00:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b01:	8b 45 14             	mov    0x14(%ebp),%eax
  801b04:	8b 00                	mov    (%eax),%eax
  801b06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b18:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <str2lower>:


/*2024*/
char* str2lower(char *dst, const char *src)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801b25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b2c:	eb 4c                	jmp    801b7a <str2lower+0x5b>
	    if (src[i] >= 'A' && src[i] <= 'Z') {
  801b2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	3c 40                	cmp    $0x40,%al
  801b3a:	7e 27                	jle    801b63 <str2lower+0x44>
  801b3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	01 d0                	add    %edx,%eax
  801b44:	8a 00                	mov    (%eax),%al
  801b46:	3c 5a                	cmp    $0x5a,%al
  801b48:	7f 19                	jg     801b63 <str2lower+0x44>
	      dst[i] = src[i] + 32;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	01 d0                	add    %edx,%eax
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	01 ca                	add    %ecx,%edx
  801b5a:	8a 12                	mov    (%edx),%dl
  801b5c:	83 c2 20             	add    $0x20,%edx
  801b5f:	88 10                	mov    %dl,(%eax)
  801b61:	eb 14                	jmp    801b77 <str2lower+0x58>
	    } else {
	      dst[i] = src[i];
  801b63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	01 c2                	add    %eax,%edx
  801b6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b71:	01 c8                	add    %ecx,%eax
  801b73:	8a 00                	mov    (%eax),%al
  801b75:	88 02                	mov    %al,(%edx)
{
	//TODO: [PROJECT'23.MS1 - #1] [1] PLAY WITH CODE! - str2lower
	//Comment the following line before start coding...
	//panic("process_command is not implemented yet");
	int i;
	for( i=0;i<strlen(src);i++) {
  801b77:	ff 45 fc             	incl   -0x4(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	e8 95 f8 ff ff       	call   801417 <strlen>
  801b82:	83 c4 04             	add    $0x4,%esp
  801b85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b88:	7f a4                	jg     801b2e <str2lower+0xf>
	      dst[i] = src[i] + 32;
	    } else {
	      dst[i] = src[i];
	    }
	  }
	  dst[i] = '\0';
  801b8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	01 d0                	add    %edx,%eax
  801b92:	c6 00 00             	movb   $0x0,(%eax)
	  return dst;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <addElement>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct filledPages marked_pages[32766];
int marked_pagessize = 0;
void addElement(uint32 start,uint32 end)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	marked_pages[marked_pagessize].start = start;
  801b9d:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba5:	89 14 c5 40 41 80 00 	mov    %edx,0x804140(,%eax,8)
	marked_pages[marked_pagessize].end = end;
  801bac:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	89 14 c5 44 41 80 00 	mov    %edx,0x804144(,%eax,8)
	marked_pagessize++;
  801bbb:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bc0:	40                   	inc    %eax
  801bc1:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801bc6:	90                   	nop
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <searchElement>:

int searchElement(uint32 start) {
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801bcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bd6:	eb 17                	jmp    801bef <searchElement+0x26>
		if (marked_pages[i].start == start) {
  801bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bdb:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801be2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801be5:	75 05                	jne    801bec <searchElement+0x23>
			return i;
  801be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bea:	eb 12                	jmp    801bfe <searchElement+0x35>
	marked_pages[marked_pagessize].end = end;
	marked_pagessize++;
}

int searchElement(uint32 start) {
	for (int i = 0; i < marked_pagessize; i++) {
  801bec:	ff 45 fc             	incl   -0x4(%ebp)
  801bef:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801bf4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801bf7:	7c df                	jl     801bd8 <searchElement+0xf>
		if (marked_pages[i].start == start) {
			return i;
		}
	}
	return -1;
  801bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <removeElement>:
void removeElement(uint32 start) {
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 10             	sub    $0x10,%esp
	int index = searchElement(start);
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	e8 bb ff ff ff       	call   801bc9 <searchElement>
  801c0e:	83 c4 04             	add    $0x4,%esp
  801c11:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801c1a:	eb 26                	jmp    801c42 <removeElement+0x42>
		marked_pages[i] = marked_pages[i + 1];
  801c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c1f:	40                   	inc    %eax
  801c20:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c23:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801c2a:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801c31:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801c38:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
	}
	return -1;
}
void removeElement(uint32 start) {
	int index = searchElement(start);
	for (int i = index; i < marked_pagessize - 1; i++) {
  801c3f:	ff 45 fc             	incl   -0x4(%ebp)
  801c42:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c47:	48                   	dec    %eax
  801c48:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c4b:	7f cf                	jg     801c1c <removeElement+0x1c>
		marked_pages[i] = marked_pages[i + 1];
	}
	marked_pagessize--;
  801c4d:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c52:	48                   	dec    %eax
  801c53:	a3 2c 40 80 00       	mov    %eax,0x80402c
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <searchfree>:
int searchfree(uint32 end)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801c61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c68:	eb 17                	jmp    801c81 <searchfree+0x26>
		if (marked_pages[i].end == end) {
  801c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c6d:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801c74:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c77:	75 05                	jne    801c7e <searchfree+0x23>
			return i;
  801c79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c7c:	eb 12                	jmp    801c90 <searchfree+0x35>
	}
	marked_pagessize--;
}
int searchfree(uint32 end)
{
	for (int i = 0; i < marked_pagessize; i++) {
  801c7e:	ff 45 fc             	incl   -0x4(%ebp)
  801c81:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801c86:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  801c89:	7c df                	jl     801c6a <searchfree+0xf>
		if (marked_pages[i].end == end) {
			return i;
		}
	}
	return -1;
  801c8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <removefree>:
void removefree(uint32 end)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 10             	sub    $0x10,%esp
	while(searchfree(end)!=-1){
  801c98:	eb 52                	jmp    801cec <removefree+0x5a>
		int index = searchfree(end);
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 b9 ff ff ff       	call   801c5b <searchfree>
  801ca2:	83 c4 04             	add    $0x4,%esp
  801ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		for (int i = index; i < marked_pagessize - 1; i++) {
  801ca8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801cae:	eb 26                	jmp    801cd6 <removefree+0x44>
			marked_pages[i] = marked_pages[i + 1];
  801cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cb3:	40                   	inc    %eax
  801cb4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801cb7:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801cbe:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801cc5:	89 04 cd 40 41 80 00 	mov    %eax,0x804140(,%ecx,8)
  801ccc:	89 14 cd 44 41 80 00 	mov    %edx,0x804144(,%ecx,8)
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
		int index = searchfree(end);
		for (int i = index; i < marked_pagessize - 1; i++) {
  801cd3:	ff 45 fc             	incl   -0x4(%ebp)
  801cd6:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801cdb:	48                   	dec    %eax
  801cdc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cdf:	7f cf                	jg     801cb0 <removefree+0x1e>
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
  801ce1:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801ce6:	48                   	dec    %eax
  801ce7:	a3 2c 40 80 00       	mov    %eax,0x80402c
	}
	return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	e8 67 ff ff ff       	call   801c5b <searchfree>
  801cf4:	83 c4 04             	add    $0x4,%esp
  801cf7:	83 f8 ff             	cmp    $0xffffffff,%eax
  801cfa:	75 9e                	jne    801c9a <removefree+0x8>
		for (int i = index; i < marked_pagessize - 1; i++) {
			marked_pages[i] = marked_pages[i + 1];
		}
		marked_pagessize--;
	}
}
  801cfc:	90                   	nop
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <printArray>:
void printArray() {
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 18             	sub    $0x18,%esp
	cprintf("Array elements:\n");
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	68 24 3d 80 00       	push   $0x803d24
  801d0d:	e8 7d ee ff ff       	call   800b8f <cprintf>
  801d12:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < marked_pagessize; i++) {
  801d15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d1c:	eb 29                	jmp    801d47 <printArray+0x48>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	ff 75 f4             	pushl  -0xc(%ebp)
  801d37:	68 35 3d 80 00       	push   $0x803d35
  801d3c:	e8 4e ee ff ff       	call   800b8f <cprintf>
  801d41:	83 c4 10             	add    $0x10,%esp
		marked_pagessize--;
	}
}
void printArray() {
	cprintf("Array elements:\n");
	for (int i = 0; i < marked_pagessize; i++) {
  801d44:	ff 45 f4             	incl   -0xc(%ebp)
  801d47:	a1 2c 40 80 00       	mov    0x80402c,%eax
  801d4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  801d4f:	7c cd                	jl     801d1e <printArray+0x1f>
		cprintf("[%d] start: %u, end: %u\n", i, marked_pages[i].start, marked_pages[i].end);
	}
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <InitializeUHeap>:
int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	if(FirstTimeFlag)
  801d57:	a1 04 40 80 00       	mov    0x804004,%eax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	74 0a                	je     801d6a <InitializeUHeap+0x16>
	{
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d60:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801d67:	00 00 00 
	}
}
  801d6a:	90                   	nop
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    

00801d6d <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	e8 4f 09 00 00       	call   8026cd <sys_sbrk>
  801d7e:	83 c4 10             	add    $0x10,%esp
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d89:	e8 c6 ff ff ff       	call   801d54 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d92:	75 0a                	jne    801d9e <malloc+0x1b>
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
  801d99:	e9 43 01 00 00       	jmp    801ee1 <malloc+0x15e>
	// Write your code here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");
	//return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801d9e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801da5:	77 3c                	ja     801de3 <malloc+0x60>
	{
		if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801da7:	e8 c3 07 00 00       	call   80256f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dac:	85 c0                	test   %eax,%eax
  801dae:	74 13                	je     801dc3 <malloc+0x40>
			return alloc_block_FF(size);
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	e8 89 0b 00 00       	call   802944 <alloc_block_FF>
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	e9 1e 01 00 00       	jmp    801ee1 <malloc+0x15e>
		}
		if(sys_isUHeapPlacementStrategyBESTFIT()){
  801dc3:	e8 d8 07 00 00       	call   8025a0 <sys_isUHeapPlacementStrategyBESTFIT>
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	0f 84 0c 01 00 00    	je     801edc <malloc+0x159>
			return alloc_block_BF(size);
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 7d 0e 00 00       	call   802c58 <alloc_block_BF>
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	e9 fe 00 00 00       	jmp    801ee1 <malloc+0x15e>
		}
	}
	else
	{
		size = ROUNDUP(size, PAGE_SIZE);
  801de3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801dea:	8b 55 08             	mov    0x8(%ebp),%edx
  801ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	48                   	dec    %eax
  801df3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801df6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801df9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfe:	f7 75 e0             	divl   -0x20(%ebp)
  801e01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e04:	29 d0                	sub    %edx,%eax
  801e06:	89 45 08             	mov    %eax,0x8(%ebp)
		int numOfPages = size / PAGE_SIZE;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	c1 e8 0c             	shr    $0xc,%eax
  801e0f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int end = 0;
  801e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		int count = 0;
  801e19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int start = -1;
  801e20:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)

		uint32 hardLimit= sys_hard_limit();
  801e27:	e8 f4 08 00 00       	call   802720 <sys_hard_limit>
  801e2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801e2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e32:	05 00 10 00 00       	add    $0x1000,%eax
  801e37:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e3a:	eb 49                	jmp    801e85 <malloc+0x102>
		{

			if (searchElement(i)==-1)
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	ff 75 e8             	pushl  -0x18(%ebp)
  801e42:	e8 82 fd ff ff       	call   801bc9 <searchElement>
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	83 f8 ff             	cmp    $0xffffffff,%eax
  801e4d:	75 28                	jne    801e77 <malloc+0xf4>
			{


				count++;
  801e4f:	ff 45 f0             	incl   -0x10(%ebp)
				if (count == numOfPages)
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801e58:	75 24                	jne    801e7e <malloc+0xfb>
				{
					end = i + PAGE_SIZE;
  801e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5d:	05 00 10 00 00       	add    $0x1000,%eax
  801e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
					start = end - (count * PAGE_SIZE);
  801e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e68:	c1 e0 0c             	shl    $0xc,%eax
  801e6b:	89 c2                	mov    %eax,%edx
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	29 d0                	sub    %edx,%eax
  801e72:	89 45 ec             	mov    %eax,-0x14(%ebp)
					break;
  801e75:	eb 17                	jmp    801e8e <malloc+0x10b>
				}
			}
			else
			{
				count = 0;
  801e77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		int end = 0;
		int count = 0;
		int start = -1;

		uint32 hardLimit= sys_hard_limit();
		for (uint32 i = hardLimit+ PAGE_SIZE; i <USER_HEAP_MAX ; i += PAGE_SIZE)
  801e7e:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
  801e85:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801e8c:	76 ae                	jbe    801e3c <malloc+0xb9>
			else
			{
				count = 0;
			}
		}
		if (start == -1)
  801e8e:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  801e92:	75 07                	jne    801e9b <malloc+0x118>
		{
			return NULL;
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	eb 46                	jmp    801ee1 <malloc+0x15e>
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ea1:	eb 1a                	jmp    801ebd <malloc+0x13a>
		{
			addElement(i,end);
  801ea3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea9:	83 ec 08             	sub    $0x8,%esp
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	e8 e7 fc ff ff       	call   801b9a <addElement>
  801eb3:	83 c4 10             	add    $0x10,%esp
		}
		if (start == -1)
		{
			return NULL;
		}
		for (int i = start; i < end; i += PAGE_SIZE)
  801eb6:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ec3:	7c de                	jl     801ea3 <malloc+0x120>
		{
			addElement(i,end);
		}
		sys_allocate_user_mem(start,size);
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	50                   	push   %eax
  801ecf:	e8 30 08 00 00       	call   802704 <sys_allocate_user_mem>
  801ed4:	83 c4 10             	add    $0x10,%esp
		return (void *)start;
  801ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eda:	eb 05                	jmp    801ee1 <malloc+0x15e>
	}
	return NULL;
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax



}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
  801ee9:	e8 32 08 00 00       	call   802720 <sys_hard_limit>
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	0f 89 82 00 00 00    	jns    801f7e <free+0x9b>
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f04:	77 78                	ja     801f7e <free+0x9b>
		if ((uint32)virtual_address < hard_limit) {
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f0c:	73 10                	jae    801f1e <free+0x3b>
			free_block(virtual_address);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	e8 d2 0e 00 00       	call   802deb <free_block>
  801f19:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801f1c:	eb 77                	jmp    801f95 <free+0xb2>
			free_block(virtual_address);
		} else {
			int x = searchElement((uint32)virtual_address);
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	50                   	push   %eax
  801f25:	e8 9f fc ff ff       	call   801bc9 <searchElement>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 size = marked_pages[x].end - marked_pages[x].start;
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	8b 14 c5 44 41 80 00 	mov    0x804144(,%eax,8),%edx
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 04 c5 40 41 80 00 	mov    0x804140(,%eax,8),%eax
  801f44:	29 c2                	sub    %eax,%edx
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
			uint32 numOfPages = size / PAGE_SIZE;
  801f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4e:	c1 e8 0c             	shr    $0xc,%eax
  801f51:	89 45 e8             	mov    %eax,-0x18(%ebp)
			sys_free_user_mem((uint32)virtual_address, size);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	ff 75 ec             	pushl  -0x14(%ebp)
  801f5d:	50                   	push   %eax
  801f5e:	e8 85 07 00 00       	call   8026e8 <sys_free_user_mem>
  801f63:	83 c4 10             	add    $0x10,%esp
			removefree(marked_pages[x].end);
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	8b 04 c5 44 41 80 00 	mov    0x804144(,%eax,8),%eax
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	50                   	push   %eax
  801f74:	e8 19 fd ff ff       	call   801c92 <removefree>
  801f79:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'23.MS2 - #11] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	uint32 hard_limit = sys_hard_limit();
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address <= USER_HEAP_MAX) {
		if ((uint32)virtual_address < hard_limit) {
  801f7c:	eb 17                	jmp    801f95 <free+0xb2>
			uint32 numOfPages = size / PAGE_SIZE;
			sys_free_user_mem((uint32)virtual_address, size);
			removefree(marked_pages[x].end);
		}
	} else {
		panic("Invalid address");
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	68 4e 3d 80 00       	push   $0x803d4e
  801f86:	68 ac 00 00 00       	push   $0xac
  801f8b:	68 5e 3d 80 00       	push   $0x803d5e
  801f90:	e8 3d e9 ff ff       	call   8008d2 <_panic>
	}
}
  801f95:	90                   	nop
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 18             	sub    $0x18,%esp
  801f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fa4:	e8 ab fd ff ff       	call   801d54 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fad:	75 07                	jne    801fb6 <smalloc+0x1e>
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	eb 17                	jmp    801fcd <smalloc+0x35>
	//==============================================================
	panic("smalloc() is not implemented yet...!!");
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 6c 3d 80 00       	push   $0x803d6c
  801fbe:	68 bc 00 00 00       	push   $0xbc
  801fc3:	68 5e 3d 80 00       	push   $0x803d5e
  801fc8:	e8 05 e9 ff ff       	call   8008d2 <_panic>
	return NULL;
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd5:	e8 7a fd ff ff       	call   801d54 <InitializeUHeap>
	//==============================================================
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	68 94 3d 80 00       	push   $0x803d94
  801fe2:	68 ca 00 00 00       	push   $0xca
  801fe7:	68 5e 3d 80 00       	push   $0x803d5e
  801fec:	e8 e1 e8 ff ff       	call   8008d2 <_panic>

00801ff1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff7:	e8 58 fd ff ff       	call   801d54 <InitializeUHeap>
	//==============================================================

	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	68 b8 3d 80 00       	push   $0x803db8
  802004:	68 ea 00 00 00       	push   $0xea
  802009:	68 5e 3d 80 00       	push   $0x803d5e
  80200e:	e8 bf e8 ff ff       	call   8008d2 <_panic>

00802013 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 e0 3d 80 00       	push   $0x803de0
  802021:	68 fe 00 00 00       	push   $0xfe
  802026:	68 5e 3d 80 00       	push   $0x803d5e
  80202b:	e8 a2 e8 ff ff       	call   8008d2 <_panic>

00802030 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	68 04 3e 80 00       	push   $0x803e04
  80203e:	68 08 01 00 00       	push   $0x108
  802043:	68 5e 3d 80 00       	push   $0x803d5e
  802048:	e8 85 e8 ff ff       	call   8008d2 <_panic>

0080204d <shrink>:

}
void shrink(uint32 newSize)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 04 3e 80 00       	push   $0x803e04
  80205b:	68 0d 01 00 00       	push   $0x10d
  802060:	68 5e 3d 80 00       	push   $0x803d5e
  802065:	e8 68 e8 ff ff       	call   8008d2 <_panic>

0080206a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 04 3e 80 00       	push   $0x803e04
  802078:	68 12 01 00 00       	push   $0x112
  80207d:	68 5e 3d 80 00       	push   $0x803d5e
  802082:	e8 4b e8 ff ff       	call   8008d2 <_panic>

00802087 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	57                   	push   %edi
  80208b:	56                   	push   %esi
  80208c:	53                   	push   %ebx
  80208d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	8b 55 0c             	mov    0xc(%ebp),%edx
  802096:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802099:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80209f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020a2:	cd 30                	int    $0x30
  8020a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5f                   	pop    %edi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 04             	sub    $0x4,%esp
  8020b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	52                   	push   %edx
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	e8 b2 ff ff ff       	call   802087 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_cgetc>:

int
sys_cgetc(void)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 01                	push   $0x1
  8020ea:	e8 98 ff ff ff       	call   802087 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	52                   	push   %edx
  802104:	50                   	push   %eax
  802105:	6a 05                	push   $0x5
  802107:	e8 7b ff ff ff       	call   802087 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802116:	8b 75 18             	mov    0x18(%ebp),%esi
  802119:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	56                   	push   %esi
  802126:	53                   	push   %ebx
  802127:	51                   	push   %ecx
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	6a 06                	push   $0x6
  80212c:	e8 56 ff ff ff       	call   802087 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    

0080213b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	6a 07                	push   $0x7
  80214e:	e8 34 ff ff ff       	call   802087 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	6a 08                	push   $0x8
  802169:	e8 19 ff ff ff       	call   802087 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 09                	push   $0x9
  802182:	e8 00 ff ff ff       	call   802087 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 0a                	push   $0xa
  80219b:	e8 e7 fe ff ff       	call   802087 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 0b                	push   $0xb
  8021b4:	e8 ce fe ff ff       	call   802087 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_pf_calculate_allocated_pages>:



int sys_pf_calculate_allocated_pages()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 0c                	push   $0xc
  8021cd:	e8 b5 fe ff ff       	call   802087 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	6a 0d                	push   $0xd
  8021e7:	e8 9b fe ff ff       	call   802087 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 0e                	push   $0xe
  802200:	e8 82 fe ff ff       	call   802087 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	90                   	nop
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 11                	push   $0x11
  80221a:	e8 68 fe ff ff       	call   802087 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 12                	push   $0x12
  802234:	e8 4e fe ff ff       	call   802087 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	90                   	nop
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_cputc>:


void
sys_cputc(const char c)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80224b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	50                   	push   %eax
  802258:	6a 13                	push   $0x13
  80225a:	e8 28 fe ff ff       	call   802087 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 14                	push   $0x14
  802274:	e8 0e fe ff ff       	call   802087 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	90                   	nop
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	ff 75 0c             	pushl  0xc(%ebp)
  80228e:	50                   	push   %eax
  80228f:	6a 15                	push   $0x15
  802291:	e8 f1 fd ff ff       	call   802087 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80229e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	52                   	push   %edx
  8022ab:	50                   	push   %eax
  8022ac:	6a 18                	push   $0x18
  8022ae:	e8 d4 fd ff ff       	call   802087 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	52                   	push   %edx
  8022c8:	50                   	push   %eax
  8022c9:	6a 16                	push   $0x16
  8022cb:	e8 b7 fd ff ff       	call   802087 <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	90                   	nop
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	52                   	push   %edx
  8022e6:	50                   	push   %eax
  8022e7:	6a 17                	push   $0x17
  8022e9:	e8 99 fd ff ff       	call   802087 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	90                   	nop
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802300:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802303:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	51                   	push   %ecx
  80230d:	52                   	push   %edx
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	50                   	push   %eax
  802312:	6a 19                	push   $0x19
  802314:	e8 6e fd ff ff       	call   802087 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802321:	8b 55 0c             	mov    0xc(%ebp),%edx
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	52                   	push   %edx
  80232e:	50                   	push   %eax
  80232f:	6a 1a                	push   $0x1a
  802331:	e8 51 fd ff ff       	call   802087 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80233e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802341:	8b 55 0c             	mov    0xc(%ebp),%edx
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	51                   	push   %ecx
  80234c:	52                   	push   %edx
  80234d:	50                   	push   %eax
  80234e:	6a 1b                	push   $0x1b
  802350:	e8 32 fd ff ff       	call   802087 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80235d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	52                   	push   %edx
  80236a:	50                   	push   %eax
  80236b:	6a 1c                	push   $0x1c
  80236d:	e8 15 fd ff ff       	call   802087 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 1d                	push   $0x1d
  802386:	e8 fc fc ff ff       	call   802087 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	ff 75 14             	pushl  0x14(%ebp)
  80239b:	ff 75 10             	pushl  0x10(%ebp)
  80239e:	ff 75 0c             	pushl  0xc(%ebp)
  8023a1:	50                   	push   %eax
  8023a2:	6a 1e                	push   $0x1e
  8023a4:	e8 de fc ff ff       	call   802087 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	50                   	push   %eax
  8023bd:	6a 1f                	push   $0x1f
  8023bf:	e8 c3 fc ff ff       	call   802087 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	50                   	push   %eax
  8023d9:	6a 20                	push   $0x20
  8023db:	e8 a7 fc ff ff       	call   802087 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 02                	push   $0x2
  8023f4:	e8 8e fc ff ff       	call   802087 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 03                	push   $0x3
  80240d:	e8 75 fc ff ff       	call   802087 <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 04                	push   $0x4
  802426:	e8 5c fc ff ff       	call   802087 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_exit_env>:


void sys_exit_env(void)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 21                	push   $0x21
  80243f:	e8 43 fc ff ff       	call   802087 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	90                   	nop
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802450:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802453:	8d 50 04             	lea    0x4(%eax),%edx
  802456:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	52                   	push   %edx
  802460:	50                   	push   %eax
  802461:	6a 22                	push   $0x22
  802463:	e8 1f fc ff ff       	call   802087 <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
	return result;
  80246b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802474:	89 01                	mov    %eax,(%ecx)
  802476:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	c9                   	leave  
  80247d:	c2 04 00             	ret    $0x4

00802480 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	ff 75 10             	pushl  0x10(%ebp)
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	ff 75 08             	pushl  0x8(%ebp)
  802490:	6a 10                	push   $0x10
  802492:	e8 f0 fb ff ff       	call   802087 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
	return ;
  80249a:	90                   	nop
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_rcr2>:
uint32 sys_rcr2()
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 23                	push   $0x23
  8024ac:	e8 d6 fb ff ff       	call   802087 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024c2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	50                   	push   %eax
  8024cf:	6a 24                	push   $0x24
  8024d1:	e8 b1 fb ff ff       	call   802087 <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d9:	90                   	nop
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <rsttst>:
void rsttst()
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 26                	push   $0x26
  8024eb:	e8 97 fb ff ff       	call   802087 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802502:	8b 55 18             	mov    0x18(%ebp),%edx
  802505:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	ff 75 10             	pushl  0x10(%ebp)
  80250e:	ff 75 0c             	pushl  0xc(%ebp)
  802511:	ff 75 08             	pushl  0x8(%ebp)
  802514:	6a 25                	push   $0x25
  802516:	e8 6c fb ff ff       	call   802087 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return ;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <chktst>:
void chktst(uint32 n)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	6a 27                	push   $0x27
  802531:	e8 51 fb ff ff       	call   802087 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
	return ;
  802539:	90                   	nop
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <inctst>:

void inctst()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 28                	push   $0x28
  80254b:	e8 37 fb ff ff       	call   802087 <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
	return ;
  802553:	90                   	nop
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <gettst>:
uint32 gettst()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 29                	push   $0x29
  802565:	e8 1d fb ff ff       	call   802087 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 2a                	push   $0x2a
  802581:	e8 01 fb ff ff       	call   802087 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
  802589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80258c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802590:	75 07                	jne    802599 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802592:	b8 01 00 00 00       	mov    $0x1,%eax
  802597:	eb 05                	jmp    80259e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 2a                	push   $0x2a
  8025b2:	e8 d0 fa ff ff       	call   802087 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025bd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025c1:	75 07                	jne    8025ca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c8:	eb 05                	jmp    8025cf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 2a                	push   $0x2a
  8025e3:	e8 9f fa ff ff       	call   802087 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
  8025eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025ee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025f2:	75 07                	jne    8025fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f9:	eb 05                	jmp    802600 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 2a                	push   $0x2a
  802614:	e8 6e fa ff ff       	call   802087 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
  80261c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80261f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802623:	75 07                	jne    80262c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802625:	b8 01 00 00 00       	mov    $0x1,%eax
  80262a:	eb 05                	jmp    802631 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	ff 75 08             	pushl  0x8(%ebp)
  802641:	6a 2b                	push   $0x2b
  802643:	e8 3f fa ff ff       	call   802087 <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
	return ;
  80264b:	90                   	nop
}
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802652:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802655:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	6a 00                	push   $0x0
  802660:	53                   	push   %ebx
  802661:	51                   	push   %ecx
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 2c                	push   $0x2c
  802666:	e8 1c fa ff ff       	call   802087 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802676:	8b 55 0c             	mov    0xc(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	52                   	push   %edx
  802683:	50                   	push   %eax
  802684:	6a 2d                	push   $0x2d
  802686:	e8 fc f9 ff ff       	call   802087 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802693:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802696:	8b 55 0c             	mov    0xc(%ebp),%edx
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	6a 00                	push   $0x0
  80269e:	51                   	push   %ecx
  80269f:	ff 75 10             	pushl  0x10(%ebp)
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	6a 2e                	push   $0x2e
  8026a6:	e8 dc f9 ff ff       	call   802087 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	ff 75 10             	pushl  0x10(%ebp)
  8026ba:	ff 75 0c             	pushl  0xc(%ebp)
  8026bd:	ff 75 08             	pushl  0x8(%ebp)
  8026c0:	6a 0f                	push   $0xf
  8026c2:	e8 c0 f9 ff ff       	call   802087 <syscall>
  8026c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ca:	90                   	nop
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <sys_sbrk>:


/*2023*/
//TODO: [PROJECT'23.MS1 - #3] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	return (void*)syscall(SYS_sbrk, (uint32)increment, 0, 0, 0, 0);
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	50                   	push   %eax
  8026dc:	6a 2f                	push   $0x2f
  8026de:	e8 a4 f9 ff ff       	call   802087 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp

}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	  syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	ff 75 0c             	pushl  0xc(%ebp)
  8026f4:	ff 75 08             	pushl  0x8(%ebp)
  8026f7:	6a 30                	push   $0x30
  8026f9:	e8 89 f9 ff ff       	call   802087 <syscall>
  8026fe:	83 c4 18             	add    $0x18,%esp

}
  802701:	90                   	nop
  802702:	c9                   	leave  
  802703:	c3                   	ret    

00802704 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

		syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	ff 75 0c             	pushl  0xc(%ebp)
  802710:	ff 75 08             	pushl  0x8(%ebp)
  802713:	6a 31                	push   $0x31
  802715:	e8 6d f9 ff ff       	call   802087 <syscall>
  80271a:	83 c4 18             	add    $0x18,%esp

}
  80271d:	90                   	nop
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <sys_hard_limit>:
uint32 sys_hard_limit(){
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_hard_limit, 0, 0, 0, 0, 0);
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 32                	push   $0x32
  80272f:	e8 53 f9 ff ff       	call   802087 <syscall>
  802734:	83 c4 18             	add    $0x18,%esp
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  80273f:	8b 45 08             	mov    0x8(%ebp),%eax
  802742:	83 e8 10             	sub    $0x10,%eax
  802745:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->size ;
  802748:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
}
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 10             	sub    $0x10,%esp
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	83 e8 10             	sub    $0x10,%eax
  80275b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return curBlkMetaData->is_free ;
  80275e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802761:	8a 40 04             	mov    0x4(%eax),%al
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <alloc_block>:

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80276c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802773:	8b 45 0c             	mov    0xc(%ebp),%eax
  802776:	83 f8 02             	cmp    $0x2,%eax
  802779:	74 2b                	je     8027a6 <alloc_block+0x40>
  80277b:	83 f8 02             	cmp    $0x2,%eax
  80277e:	7f 07                	jg     802787 <alloc_block+0x21>
  802780:	83 f8 01             	cmp    $0x1,%eax
  802783:	74 0e                	je     802793 <alloc_block+0x2d>
  802785:	eb 58                	jmp    8027df <alloc_block+0x79>
  802787:	83 f8 03             	cmp    $0x3,%eax
  80278a:	74 2d                	je     8027b9 <alloc_block+0x53>
  80278c:	83 f8 04             	cmp    $0x4,%eax
  80278f:	74 3b                	je     8027cc <alloc_block+0x66>
  802791:	eb 4c                	jmp    8027df <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	ff 75 08             	pushl  0x8(%ebp)
  802799:	e8 a6 01 00 00       	call   802944 <alloc_block_FF>
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a4:	eb 4a                	jmp    8027f0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 08             	pushl  0x8(%ebp)
  8027ac:	e8 1d 06 00 00       	call   802dce <alloc_block_NF>
  8027b1:	83 c4 10             	add    $0x10,%esp
  8027b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b7:	eb 37                	jmp    8027f0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	ff 75 08             	pushl  0x8(%ebp)
  8027bf:	e8 94 04 00 00       	call   802c58 <alloc_block_BF>
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027ca:	eb 24                	jmp    8027f0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027cc:	83 ec 0c             	sub    $0xc,%esp
  8027cf:	ff 75 08             	pushl  0x8(%ebp)
  8027d2:	e8 da 05 00 00       	call   802db1 <alloc_block_WF>
  8027d7:	83 c4 10             	add    $0x10,%esp
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027dd:	eb 11                	jmp    8027f0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	68 14 3e 80 00       	push   $0x803e14
  8027e7:	e8 a3 e3 ff ff       	call   800b8f <cprintf>
  8027ec:	83 c4 10             	add    $0x10,%esp
		break;
  8027ef:	90                   	nop
	}
	return va;
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
  8027f8:	83 ec 18             	sub    $0x18,%esp
	cprintf("=========================================\n");
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	68 34 3e 80 00       	push   $0x803e34
  802803:	e8 87 e3 ff ff       	call   800b8f <cprintf>
  802808:	83 c4 10             	add    $0x10,%esp
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	68 5f 3e 80 00       	push   $0x803e5f
  802813:	e8 77 e3 ff ff       	call   800b8f <cprintf>
  802818:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	eb 26                	jmp    802849 <print_blocks_list+0x54>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8a 40 04             	mov    0x4(%eax),%al
  802829:	0f b6 d0             	movzbl %al,%edx
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	52                   	push   %edx
  802835:	50                   	push   %eax
  802836:	68 77 3e 80 00       	push   $0x803e77
  80283b:	e8 4f e3 ff ff       	call   800b8f <cprintf>
  802840:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802843:	8b 45 10             	mov    0x10(%ebp),%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	74 08                	je     802857 <print_blocks_list+0x62>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 08             	mov    0x8(%eax),%eax
  802855:	eb 05                	jmp    80285c <print_blocks_list+0x67>
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	89 45 10             	mov    %eax,0x10(%ebp)
  80285f:	8b 45 10             	mov    0x10(%ebp),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	75 bd                	jne    802823 <print_blocks_list+0x2e>
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 b7                	jne    802823 <print_blocks_list+0x2e>
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");
  80286c:	83 ec 0c             	sub    $0xc,%esp
  80286f:	68 34 3e 80 00       	push   $0x803e34
  802874:	e8 16 e3 ff ff       	call   800b8f <cprintf>
  802879:	83 c4 10             	add    $0x10,%esp

}
  80287c:	90                   	nop
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <initialize_dynamic_allocator>:
//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 08             	sub    $0x8,%esp
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
  802885:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802889:	0f 84 b2 00 00 00    	je     802941 <initialize_dynamic_allocator+0xc2>
			return ;
		is_initialized=1;
  80288f:	c7 05 30 40 80 00 01 	movl   $0x1,0x804030
  802896:	00 00 00 
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
  802899:	c7 05 14 41 80 00 00 	movl   $0x0,0x804114
  8028a0:	00 00 00 
  8028a3:	c7 05 18 41 80 00 00 	movl   $0x0,0x804118
  8028aa:	00 00 00 
  8028ad:	c7 05 20 41 80 00 00 	movl   $0x0,0x804120
  8028b4:	00 00 00 
		firstBlock = (struct BlockMetaData*)daStart;
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 24 41 80 00       	mov    %eax,0x804124
		firstBlock->size = initSizeOfAllocatedSpace;
  8028bf:	a1 24 41 80 00       	mov    0x804124,%eax
  8028c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c7:	89 10                	mov    %edx,(%eax)
		firstBlock->is_free=1;
  8028c9:	a1 24 41 80 00       	mov    0x804124,%eax
  8028ce:	c6 40 04 01          	movb   $0x1,0x4(%eax)
		LIST_INSERT_HEAD(&blocklist,firstBlock);
  8028d2:	a1 24 41 80 00       	mov    0x804124,%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	75 14                	jne    8028ef <initialize_dynamic_allocator+0x70>
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	68 90 3e 80 00       	push   $0x803e90
  8028e3:	6a 68                	push   $0x68
  8028e5:	68 b3 3e 80 00       	push   $0x803eb3
  8028ea:	e8 e3 df ff ff       	call   8008d2 <_panic>
  8028ef:	a1 24 41 80 00       	mov    0x804124,%eax
  8028f4:	8b 15 14 41 80 00    	mov    0x804114,%edx
  8028fa:	89 50 08             	mov    %edx,0x8(%eax)
  8028fd:	8b 40 08             	mov    0x8(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 10                	je     802914 <initialize_dynamic_allocator+0x95>
  802904:	a1 14 41 80 00       	mov    0x804114,%eax
  802909:	8b 15 24 41 80 00    	mov    0x804124,%edx
  80290f:	89 50 0c             	mov    %edx,0xc(%eax)
  802912:	eb 0a                	jmp    80291e <initialize_dynamic_allocator+0x9f>
  802914:	a1 24 41 80 00       	mov    0x804124,%eax
  802919:	a3 18 41 80 00       	mov    %eax,0x804118
  80291e:	a1 24 41 80 00       	mov    0x804124,%eax
  802923:	a3 14 41 80 00       	mov    %eax,0x804114
  802928:	a1 24 41 80 00       	mov    0x804124,%eax
  80292d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802934:	a1 20 41 80 00       	mov    0x804120,%eax
  802939:	40                   	inc    %eax
  80293a:	a3 20 41 80 00       	mov    %eax,0x804120
  80293f:	eb 01                	jmp    802942 <initialize_dynamic_allocator+0xc3>
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802941:	90                   	nop
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 28             	sub    $0x28,%esp
	if (!is_initialized)
  80294a:	a1 30 40 80 00       	mov    0x804030,%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	75 40                	jne    802993 <alloc_block_FF+0x4f>
	{
		uint32 required_size = size + sizeOfMetaData();
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	83 c0 10             	add    $0x10,%eax
  802959:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 da_start = (uint32)sbrk(required_size);
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	83 ec 0c             	sub    $0xc,%esp
  802962:	50                   	push   %eax
  802963:	e8 05 f4 ff ff       	call   801d6d <sbrk>
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
  80296e:	83 ec 0c             	sub    $0xc,%esp
  802971:	6a 00                	push   $0x0
  802973:	e8 f5 f3 ff ff       	call   801d6d <sbrk>
  802978:	83 c4 10             	add    $0x10,%esp
  80297b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		initialize_dynamic_allocator(da_start, da_break - da_start);
  80297e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802981:	2b 45 ec             	sub    -0x14(%ebp),%eax
  802984:	83 ec 08             	sub    $0x8,%esp
  802987:	50                   	push   %eax
  802988:	ff 75 ec             	pushl  -0x14(%ebp)
  80298b:	e8 ef fe ff ff       	call   80287f <initialize_dynamic_allocator>
  802990:	83 c4 10             	add    $0x10,%esp
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
  802993:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802997:	75 0a                	jne    8029a3 <alloc_block_FF+0x5f>
		 return NULL;
  802999:	b8 00 00 00 00       	mov    $0x0,%eax
  80299e:	e9 b3 02 00 00       	jmp    802c56 <alloc_block_FF+0x312>
	 }
	 size+=sizeOfMetaData();
  8029a3:	83 45 08 10          	addl   $0x10,0x8(%ebp)
	 struct BlockMetaData* currentBlock;
	 bool found =0;
  8029a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	 LIST_FOREACH(currentBlock,&blocklist){
  8029ae:	a1 14 41 80 00       	mov    0x804114,%eax
  8029b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b6:	e9 12 01 00 00       	jmp    802acd <alloc_block_FF+0x189>
		 if (currentBlock->is_free && currentBlock->size >= size)
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8a 40 04             	mov    0x4(%eax),%al
  8029c1:	84 c0                	test   %al,%al
  8029c3:	0f 84 fc 00 00 00    	je     802ac5 <alloc_block_FF+0x181>
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d1:	0f 82 ee 00 00 00    	jb     802ac5 <alloc_block_FF+0x181>
		 {
			 if(currentBlock->size == size)
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029df:	75 12                	jne    8029f3 <alloc_block_FF+0xaf>
			 {
				 currentBlock->is_free = 0;
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	83 c0 10             	add    $0x10,%eax
  8029ee:	e9 63 02 00 00       	jmp    802c56 <alloc_block_FF+0x312>
			 }
			 else
			 {
				 found=1;
  8029f3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
				 currentBlock->is_free=0;
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	c6 40 04 00          	movb   $0x0,0x4(%eax)
				 if(currentBlock->size-size>=sizeOfMetaData())
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	2b 45 08             	sub    0x8(%ebp),%eax
  802a09:	83 f8 0f             	cmp    $0xf,%eax
  802a0c:	0f 86 a8 00 00 00    	jbe    802aba <alloc_block_FF+0x176>
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
					 new_block->size=currentBlock->size-size;
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	2b 45 08             	sub    0x8(%ebp),%eax
  802a25:	89 c2                	mov    %eax,%edx
  802a27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a2a:	89 10                	mov    %edx,(%eax)
					 currentBlock->size=size;
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a32:	89 10                	mov    %edx,(%eax)
					 new_block->is_free=1;
  802a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a37:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
  802a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3f:	74 06                	je     802a47 <alloc_block_FF+0x103>
  802a41:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a45:	75 17                	jne    802a5e <alloc_block_FF+0x11a>
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	68 cc 3e 80 00       	push   $0x803ecc
  802a4f:	68 91 00 00 00       	push   $0x91
  802a54:	68 b3 3e 80 00       	push   $0x803eb3
  802a59:	e8 74 de ff ff       	call   8008d2 <_panic>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 50 08             	mov    0x8(%eax),%edx
  802a64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a67:	89 50 08             	mov    %edx,0x8(%eax)
  802a6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a6d:	8b 40 08             	mov    0x8(%eax),%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	74 0c                	je     802a80 <alloc_block_FF+0x13c>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a7d:	89 50 0c             	mov    %edx,0xc(%eax)
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a86:	89 50 08             	mov    %edx,0x8(%eax)
  802a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	89 50 0c             	mov    %edx,0xc(%eax)
  802a92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a95:	8b 40 08             	mov    0x8(%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	75 08                	jne    802aa4 <alloc_block_FF+0x160>
  802a9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a9f:	a3 18 41 80 00       	mov    %eax,0x804118
  802aa4:	a1 20 41 80 00       	mov    0x804120,%eax
  802aa9:	40                   	inc    %eax
  802aaa:	a3 20 41 80 00       	mov    %eax,0x804120
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	83 c0 10             	add    $0x10,%eax
  802ab5:	e9 9c 01 00 00       	jmp    802c56 <alloc_block_FF+0x312>
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	83 c0 10             	add    $0x10,%eax
  802ac0:	e9 91 01 00 00       	jmp    802c56 <alloc_block_FF+0x312>
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
  802ac5:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad1:	74 08                	je     802adb <alloc_block_FF+0x197>
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 08             	mov    0x8(%eax),%eax
  802ad9:	eb 05                	jmp    802ae0 <alloc_block_FF+0x19c>
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae0:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802ae5:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	0f 85 c9 fe ff ff    	jne    8029bb <alloc_block_FF+0x77>
  802af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af6:	0f 85 bf fe ff ff    	jne    8029bb <alloc_block_FF+0x77>
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
  802afc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b00:	0f 85 4b 01 00 00    	jne    802c51 <alloc_block_FF+0x30d>
	 {
		 currentBlock = sbrk(size);
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	83 ec 0c             	sub    $0xc,%esp
  802b0c:	50                   	push   %eax
  802b0d:	e8 5b f2 ff ff       	call   801d6d <sbrk>
  802b12:	83 c4 10             	add    $0x10,%esp
  802b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		 if(currentBlock!=NULL){
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	0f 84 28 01 00 00    	je     802c4a <alloc_block_FF+0x306>
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	89 45 e0             	mov    %eax,-0x20(%ebp)
			 sb->size=size;
  802b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
			 sb->is_free = 0;
  802b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b33:	c6 40 04 00          	movb   $0x0,0x4(%eax)
			 LIST_INSERT_TAIL(&blocklist, sb);
  802b37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b3b:	75 17                	jne    802b54 <alloc_block_FF+0x210>
  802b3d:	83 ec 04             	sub    $0x4,%esp
  802b40:	68 00 3f 80 00       	push   $0x803f00
  802b45:	68 a1 00 00 00       	push   $0xa1
  802b4a:	68 b3 3e 80 00       	push   $0x803eb3
  802b4f:	e8 7e dd ff ff       	call   8008d2 <_panic>
  802b54:	8b 15 18 41 80 00    	mov    0x804118,%edx
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	89 50 0c             	mov    %edx,0xc(%eax)
  802b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b63:	8b 40 0c             	mov    0xc(%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0d                	je     802b77 <alloc_block_FF+0x233>
  802b6a:	a1 18 41 80 00       	mov    0x804118,%eax
  802b6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b72:	89 50 08             	mov    %edx,0x8(%eax)
  802b75:	eb 08                	jmp    802b7f <alloc_block_FF+0x23b>
  802b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7a:	a3 14 41 80 00       	mov    %eax,0x804114
  802b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b82:	a3 18 41 80 00       	mov    %eax,0x804118
  802b87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b91:	a1 20 41 80 00       	mov    0x804120,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 20 41 80 00       	mov    %eax,0x804120
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
  802b9c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ba1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba4:	83 f8 0f             	cmp    $0xf,%eax
  802ba7:	0f 86 95 00 00 00    	jbe    802c42 <alloc_block_FF+0x2fe>
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
  802bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	01 d0                	add    %edx,%eax
  802bb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
				 new_block->size=PAGE_SIZE-size;
  802bb8:	b8 00 10 00 00       	mov    $0x1000,%eax
  802bbd:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc0:	89 c2                	mov    %eax,%edx
  802bc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bc5:	89 10                	mov    %edx,(%eax)
				 new_block->is_free=1;
  802bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bca:	c6 40 04 01          	movb   $0x1,0x4(%eax)
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
  802bce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bd2:	74 06                	je     802bda <alloc_block_FF+0x296>
  802bd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bd8:	75 17                	jne    802bf1 <alloc_block_FF+0x2ad>
  802bda:	83 ec 04             	sub    $0x4,%esp
  802bdd:	68 cc 3e 80 00       	push   $0x803ecc
  802be2:	68 a6 00 00 00       	push   $0xa6
  802be7:	68 b3 3e 80 00       	push   $0x803eb3
  802bec:	e8 e1 dc ff ff       	call   8008d2 <_panic>
  802bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bfa:	89 50 08             	mov    %edx,0x8(%eax)
  802bfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c00:	8b 40 08             	mov    0x8(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0c                	je     802c13 <alloc_block_FF+0x2cf>
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	8b 40 08             	mov    0x8(%eax),%eax
  802c0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c10:	89 50 0c             	mov    %edx,0xc(%eax)
  802c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c19:	89 50 08             	mov    %edx,0x8(%eax)
  802c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c22:	89 50 0c             	mov    %edx,0xc(%eax)
  802c25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c28:	8b 40 08             	mov    0x8(%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	75 08                	jne    802c37 <alloc_block_FF+0x2f3>
  802c2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c32:	a3 18 41 80 00       	mov    %eax,0x804118
  802c37:	a1 20 41 80 00       	mov    0x804120,%eax
  802c3c:	40                   	inc    %eax
  802c3d:	a3 20 41 80 00       	mov    %eax,0x804120
			 }
			 return (sb + 1);
  802c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c45:	83 c0 10             	add    $0x10,%eax
  802c48:	eb 0c                	jmp    802c56 <alloc_block_FF+0x312>
		 }
		 return NULL;
  802c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4f:	eb 05                	jmp    802c56 <alloc_block_FF+0x312>
	 }
	 return NULL;
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802c56:	c9                   	leave  
  802c57:	c3                   	ret    

00802c58 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	83 ec 18             	sub    $0x18,%esp
	size+=sizeOfMetaData();
  802c5e:	83 45 08 10          	addl   $0x10,0x8(%ebp)
    struct BlockMetaData *bestFitBlock=NULL;
  802c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    uint32 bestFitSize = 4294967295;
  802c69:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802c70:	a1 14 41 80 00       	mov    0x804114,%eax
  802c75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c78:	eb 34                	jmp    802cae <alloc_block_BF+0x56>
        if (current->is_free && current->size >= size) {
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	8a 40 04             	mov    0x4(%eax),%al
  802c80:	84 c0                	test   %al,%al
  802c82:	74 22                	je     802ca6 <alloc_block_BF+0x4e>
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8c:	72 18                	jb     802ca6 <alloc_block_BF+0x4e>
            if (current->size<bestFitSize) {
  802c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c96:	73 0e                	jae    802ca6 <alloc_block_BF+0x4e>
                bestFitBlock = current;
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
                bestFitSize = current->size;
  802c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
  802ca6:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb2:	74 08                	je     802cbc <alloc_block_BF+0x64>
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	eb 05                	jmp    802cc1 <alloc_block_BF+0x69>
  802cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc1:	a3 1c 41 80 00       	mov    %eax,0x80411c
  802cc6:	a1 1c 41 80 00       	mov    0x80411c,%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	75 ab                	jne    802c7a <alloc_block_BF+0x22>
  802ccf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd3:	75 a5                	jne    802c7a <alloc_block_BF+0x22>
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
  802cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd9:	0f 84 cb 00 00 00    	je     802daa <alloc_block_BF+0x152>
        bestFitBlock->is_free = 0;
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	c6 40 04 00          	movb   $0x0,0x4(%eax)
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cee:	0f 86 ae 00 00 00    	jbe    802da2 <alloc_block_BF+0x14a>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	2b 45 08             	sub    0x8(%ebp),%eax
  802cfc:	83 f8 0f             	cmp    $0xf,%eax
  802cff:	0f 86 9d 00 00 00    	jbe    802da2 <alloc_block_BF+0x14a>
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
  802d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	01 d0                	add    %edx,%eax
  802d0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			new_block->size = bestFitBlock->size - size;
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	2b 45 08             	sub    0x8(%ebp),%eax
  802d18:	89 c2                	mov    %eax,%edx
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	89 10                	mov    %edx,(%eax)
			new_block->is_free = 1;
  802d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d22:	c6 40 04 01          	movb   $0x1,0x4(%eax)
            bestFitBlock->size = size;
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2c:	89 10                	mov    %edx,(%eax)
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	74 06                	je     802d3a <alloc_block_BF+0xe2>
  802d34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d38:	75 17                	jne    802d51 <alloc_block_BF+0xf9>
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	68 cc 3e 80 00       	push   $0x803ecc
  802d42:	68 c6 00 00 00       	push   $0xc6
  802d47:	68 b3 3e 80 00       	push   $0x803eb3
  802d4c:	e8 81 db ff ff       	call   8008d2 <_panic>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 50 08             	mov    0x8(%eax),%edx
  802d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5a:	89 50 08             	mov    %edx,0x8(%eax)
  802d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d60:	8b 40 08             	mov    0x8(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0c                	je     802d73 <alloc_block_BF+0x11b>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
  802d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d70:	89 50 0c             	mov    %edx,0xc(%eax)
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d79:	89 50 08             	mov    %edx,0x8(%eax)
  802d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d82:	89 50 0c             	mov    %edx,0xc(%eax)
  802d85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	75 08                	jne    802d97 <alloc_block_BF+0x13f>
  802d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d92:	a3 18 41 80 00       	mov    %eax,0x804118
  802d97:	a1 20 41 80 00       	mov    0x804120,%eax
  802d9c:	40                   	inc    %eax
  802d9d:	a3 20 41 80 00       	mov    %eax,0x804120
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	83 c0 10             	add    $0x10,%eax
  802da8:	eb 05                	jmp    802daf <alloc_block_BF+0x157>
    }

    return NULL;
  802daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802daf:	c9                   	leave  
  802db0:	c3                   	ret    

00802db1 <alloc_block_WF>:
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  802db1:	55                   	push   %ebp
  802db2:	89 e5                	mov    %esp,%ebp
  802db4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 24 3f 80 00       	push   $0x803f24
  802dbf:	68 d2 00 00 00       	push   $0xd2
  802dc4:	68 b3 3e 80 00       	push   $0x803eb3
  802dc9:	e8 04 db ff ff       	call   8008d2 <_panic>

00802dce <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  802dce:	55                   	push   %ebp
  802dcf:	89 e5                	mov    %esp,%ebp
  802dd1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  802dd4:	83 ec 04             	sub    $0x4,%esp
  802dd7:	68 4c 3f 80 00       	push   $0x803f4c
  802ddc:	68 db 00 00 00       	push   $0xdb
  802de1:	68 b3 3e 80 00       	push   $0x803eb3
  802de6:	e8 e7 da ff ff       	call   8008d2 <_panic>

00802deb <free_block>:

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
  802deb:	55                   	push   %ebp
  802dec:	89 e5                	mov    %esp,%ebp
  802dee:	83 ec 18             	sub    $0x18,%esp
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
  802df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df5:	0f 84 d2 01 00 00    	je     802fcd <free_block+0x1e2>
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	83 e8 10             	sub    $0x10,%eax
  802e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(block->is_free){
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8a 40 04             	mov    0x4(%eax),%al
  802e0a:	84 c0                	test   %al,%al
  802e0c:	0f 85 be 01 00 00    	jne    802fd0 <free_block+0x1e5>
				return;
			}
			//free block
			block->is_free = 1;
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	0f 84 cc 00 00 00    	je     802ef3 <free_block+0x108>
			{
				if (LIST_NEXT(block)->is_free)
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	8a 40 04             	mov    0x4(%eax),%al
  802e30:	84 c0                	test   %al,%al
  802e32:	0f 84 bb 00 00 00    	je     802ef3 <free_block+0x108>
				{
					block->size += LIST_NEXT(block)->size;
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 10                	mov    (%eax),%edx
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 08             	mov    0x8(%eax),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	01 c2                	add    %eax,%edx
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	89 10                	mov    %edx,(%eax)
					LIST_NEXT(block)->is_free=0;
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 40 08             	mov    0x8(%eax),%eax
  802e52:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					LIST_NEXT(block)->size=0;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 08             	mov    0x8(%eax),%eax
  802e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					struct BlockMetaData *delnext =LIST_NEXT(block);
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&blocklist,delnext);
  802e6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6f:	75 17                	jne    802e88 <free_block+0x9d>
  802e71:	83 ec 04             	sub    $0x4,%esp
  802e74:	68 72 3f 80 00       	push   $0x803f72
  802e79:	68 f8 00 00 00       	push   $0xf8
  802e7e:	68 b3 3e 80 00       	push   $0x803eb3
  802e83:	e8 4a da ff ff       	call   8008d2 <_panic>
  802e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 11                	je     802ea3 <free_block+0xb8>
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	8b 40 08             	mov    0x8(%eax),%eax
  802e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9b:	8b 52 0c             	mov    0xc(%edx),%edx
  802e9e:	89 50 0c             	mov    %edx,0xc(%eax)
  802ea1:	eb 0b                	jmp    802eae <free_block+0xc3>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	a3 18 41 80 00       	mov    %eax,0x804118
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 11                	je     802ec9 <free_block+0xde>
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	8b 52 08             	mov    0x8(%edx),%edx
  802ec4:	89 50 08             	mov    %edx,0x8(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <free_block+0xe9>
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	a3 14 41 80 00       	mov    %eax,0x804114
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802ee8:	a1 20 41 80 00       	mov    0x804120,%eax
  802eed:	48                   	dec    %eax
  802eee:	a3 20 41 80 00       	mov    %eax,0x804120
				}
			}
			if( LIST_PREV(block))
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	0f 84 d0 00 00 00    	je     802fd1 <free_block+0x1e6>
			{
				if (LIST_PREV(block)->is_free)
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	8a 40 04             	mov    0x4(%eax),%al
  802f0a:	84 c0                	test   %al,%al
  802f0c:	0f 84 bf 00 00 00    	je     802fd1 <free_block+0x1e6>
				{
					LIST_PREV(block)->size += block->size;
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 52 0c             	mov    0xc(%edx),%edx
  802f1e:	8b 0a                	mov    (%edx),%ecx
  802f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f23:	8b 12                	mov    (%edx),%edx
  802f25:	01 ca                	add    %ecx,%edx
  802f27:	89 10                	mov    %edx,(%eax)
					LIST_PREV(block)->is_free=1;
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2f:	c6 40 04 01          	movb   $0x1,0x4(%eax)
					block->is_free=0;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					block->size=0;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					LIST_REMOVE(&blocklist,block);
  802f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f47:	75 17                	jne    802f60 <free_block+0x175>
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 72 3f 80 00       	push   $0x803f72
  802f51:	68 03 01 00 00       	push   $0x103
  802f56:	68 b3 3e 80 00       	push   $0x803eb3
  802f5b:	e8 72 d9 ff ff       	call   8008d2 <_panic>
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 08             	mov    0x8(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 11                	je     802f7b <free_block+0x190>
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 40 08             	mov    0x8(%eax),%eax
  802f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f73:	8b 52 0c             	mov    0xc(%edx),%edx
  802f76:	89 50 0c             	mov    %edx,0xc(%eax)
  802f79:	eb 0b                	jmp    802f86 <free_block+0x19b>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f81:	a3 18 41 80 00       	mov    %eax,0x804118
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 11                	je     802fa1 <free_block+0x1b6>
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	8b 40 0c             	mov    0xc(%eax),%eax
  802f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f99:	8b 52 08             	mov    0x8(%edx),%edx
  802f9c:	89 50 08             	mov    %edx,0x8(%eax)
  802f9f:	eb 0b                	jmp    802fac <free_block+0x1c1>
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 08             	mov    0x8(%eax),%eax
  802fa7:	a3 14 41 80 00       	mov    %eax,0x804114
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fc0:	a1 20 41 80 00       	mov    0x804120,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	a3 20 41 80 00       	mov    %eax,0x804120
  802fcb:	eb 04                	jmp    802fd1 <free_block+0x1e6>
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
  802fcd:	90                   	nop
  802fce:	eb 01                	jmp    802fd1 <free_block+0x1e6>
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
  802fd0:	90                   	nop
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}
  802fd1:	c9                   	leave  
  802fd2:	c3                   	ret    

00802fd3 <realloc_block_FF>:

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802fd3:	55                   	push   %ebp
  802fd4:	89 e5                	mov    %esp,%ebp
  802fd6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
  802fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdd:	75 10                	jne    802fef <realloc_block_FF+0x1c>
  802fdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fe3:	75 0a                	jne    802fef <realloc_block_FF+0x1c>
	 {
		 return NULL;
  802fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fea:	e9 2e 03 00 00       	jmp    80331d <realloc_block_FF+0x34a>
	 }
	 if (va == NULL)
  802fef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff3:	75 13                	jne    803008 <realloc_block_FF+0x35>
	 {
		 return alloc_block_FF(new_size);
  802ff5:	83 ec 0c             	sub    $0xc,%esp
  802ff8:	ff 75 0c             	pushl  0xc(%ebp)
  802ffb:	e8 44 f9 ff ff       	call   802944 <alloc_block_FF>
  803000:	83 c4 10             	add    $0x10,%esp
  803003:	e9 15 03 00 00       	jmp    80331d <realloc_block_FF+0x34a>
	 }
	 if (new_size == 0)
  803008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300c:	75 18                	jne    803026 <realloc_block_FF+0x53>
	 {
		 free_block(va);
  80300e:	83 ec 0c             	sub    $0xc,%esp
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 d2 fd ff ff       	call   802deb <free_block>
  803019:	83 c4 10             	add    $0x10,%esp
		 return NULL;
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	e9 f7 02 00 00       	jmp    80331d <realloc_block_FF+0x34a>
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	83 e8 10             	sub    $0x10,%eax
  80302c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 new_size += sizeOfMetaData();
  80302f:	83 45 0c 10          	addl   $0x10,0xc(%ebp)
	     if (block->size >= new_size)
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80303b:	0f 82 c8 00 00 00    	jb     803109 <realloc_block_FF+0x136>
	     {
	    	 if(block->size == new_size)
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803049:	75 08                	jne    803053 <realloc_block_FF+0x80>
	    	 {
	    		 return va;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	e9 ca 02 00 00       	jmp    80331d <realloc_block_FF+0x34a>
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	2b 45 0c             	sub    0xc(%ebp),%eax
  80305b:	83 f8 0f             	cmp    $0xf,%eax
  80305e:	0f 86 9d 00 00 00    	jbe    803101 <realloc_block_FF+0x12e>
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  803064:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306a:	01 d0                	add    %edx,%eax
  80306c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    			new_block->size = block->size - new_size;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	2b 45 0c             	sub    0xc(%ebp),%eax
  803077:	89 c2                	mov    %eax,%edx
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	89 10                	mov    %edx,(%eax)
	    			block->size = new_size;
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 55 0c             	mov    0xc(%ebp),%edx
  803084:	89 10                	mov    %edx,(%eax)
	    			new_block->is_free = 1;
  803086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803089:	c6 40 04 01          	movb   $0x1,0x4(%eax)
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
  80308d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803091:	74 06                	je     803099 <realloc_block_FF+0xc6>
  803093:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803097:	75 17                	jne    8030b0 <realloc_block_FF+0xdd>
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	68 cc 3e 80 00       	push   $0x803ecc
  8030a1:	68 2a 01 00 00       	push   $0x12a
  8030a6:	68 b3 3e 80 00       	push   $0x803eb3
  8030ab:	e8 22 d8 ff ff       	call   8008d2 <_panic>
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 50 08             	mov    0x8(%eax),%edx
  8030b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b9:	89 50 08             	mov    %edx,0x8(%eax)
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0c                	je     8030d2 <realloc_block_FF+0xff>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 08             	mov    0x8(%eax),%eax
  8030cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d8:	89 50 08             	mov    %edx,0x8(%eax)
  8030db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e1:	89 50 0c             	mov    %edx,0xc(%eax)
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	75 08                	jne    8030f6 <realloc_block_FF+0x123>
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	a3 18 41 80 00       	mov    %eax,0x804118
  8030f6:	a1 20 41 80 00       	mov    0x804120,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 20 41 80 00       	mov    %eax,0x804120
	    	 }
	    	 return va;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	e9 14 02 00 00       	jmp    80331d <realloc_block_FF+0x34a>
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 40 08             	mov    0x8(%eax),%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	0f 84 97 01 00 00    	je     8032ae <realloc_block_FF+0x2db>
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 08             	mov    0x8(%eax),%eax
  80311d:	8a 40 04             	mov    0x4(%eax),%al
  803120:	84 c0                	test   %al,%al
  803122:	0f 84 86 01 00 00    	je     8032ae <realloc_block_FF+0x2db>
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 10                	mov    (%eax),%edx
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 40 08             	mov    0x8(%eax),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	01 d0                	add    %edx,%eax
  803137:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80313a:	0f 82 6e 01 00 00    	jb     8032ae <realloc_block_FF+0x2db>
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 10                	mov    (%eax),%edx
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	8b 00                	mov    (%eax),%eax
  80314d:	01 c2                	add    %eax,%edx
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	89 10                	mov    %edx,(%eax)
					 LIST_NEXT(block)->is_free=0;
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 08             	mov    0x8(%eax),%eax
  80315a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
					 LIST_NEXT(block)->size=0;
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	8b 40 08             	mov    0x8(%eax),%eax
  803164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
					 struct BlockMetaData *delnext =LIST_NEXT(block);
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 40 08             	mov    0x8(%eax),%eax
  803170:	89 45 ec             	mov    %eax,-0x14(%ebp)
					 LIST_REMOVE(&blocklist,delnext);
  803173:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803177:	75 17                	jne    803190 <realloc_block_FF+0x1bd>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 72 3f 80 00       	push   $0x803f72
  803181:	68 38 01 00 00       	push   $0x138
  803186:	68 b3 3e 80 00       	push   $0x803eb3
  80318b:	e8 42 d7 ff ff       	call   8008d2 <_panic>
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 40 08             	mov    0x8(%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 11                	je     8031ab <realloc_block_FF+0x1d8>
  80319a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319d:	8b 40 08             	mov    0x8(%eax),%eax
  8031a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8031a6:	89 50 0c             	mov    %edx,0xc(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <realloc_block_FF+0x1e3>
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	a3 18 41 80 00       	mov    %eax,0x804118
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 11                	je     8031d1 <realloc_block_FF+0x1fe>
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031c9:	8b 52 08             	mov    0x8(%edx),%edx
  8031cc:	89 50 08             	mov    %edx,0x8(%eax)
  8031cf:	eb 0b                	jmp    8031dc <realloc_block_FF+0x209>
  8031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	a3 14 41 80 00       	mov    %eax,0x804114
  8031dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8031f0:	a1 20 41 80 00       	mov    0x804120,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 20 41 80 00       	mov    %eax,0x804120
					 if(block->size - new_size >= sizeOfMetaData())
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	2b 45 0c             	sub    0xc(%ebp),%eax
  803203:	83 f8 0f             	cmp    $0xf,%eax
  803206:	0f 86 9d 00 00 00    	jbe    8032a9 <realloc_block_FF+0x2d6>
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
  80320c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803212:	01 d0                	add    %edx,%eax
  803214:	89 45 e8             	mov    %eax,-0x18(%ebp)
						 new_block->size = block->size - new_size;
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80321f:	89 c2                	mov    %eax,%edx
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	89 10                	mov    %edx,(%eax)
						 block->size = new_size;
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80322c:	89 10                	mov    %edx,(%eax)
						 new_block->is_free = 1;
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	c6 40 04 01          	movb   $0x1,0x4(%eax)
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
  803235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803239:	74 06                	je     803241 <realloc_block_FF+0x26e>
  80323b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323f:	75 17                	jne    803258 <realloc_block_FF+0x285>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 cc 3e 80 00       	push   $0x803ecc
  803249:	68 3f 01 00 00       	push   $0x13f
  80324e:	68 b3 3e 80 00       	push   $0x803eb3
  803253:	e8 7a d6 ff ff       	call   8008d2 <_panic>
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 50 08             	mov    0x8(%eax),%edx
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	89 50 08             	mov    %edx,0x8(%eax)
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 40 08             	mov    0x8(%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0c                	je     80327a <realloc_block_FF+0x2a7>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 08             	mov    0x8(%eax),%eax
  803274:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803277:	89 50 0c             	mov    %edx,0xc(%eax)
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803280:	89 50 08             	mov    %edx,0x8(%eax)
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803289:	89 50 0c             	mov    %edx,0xc(%eax)
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	8b 40 08             	mov    0x8(%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	75 08                	jne    80329e <realloc_block_FF+0x2cb>
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	a3 18 41 80 00       	mov    %eax,0x804118
  80329e:	a1 20 41 80 00       	mov    0x804120,%eax
  8032a3:	40                   	inc    %eax
  8032a4:	a3 20 41 80 00       	mov    %eax,0x804120
					 }
					 return va;
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	eb 6f                	jmp    80331d <realloc_block_FF+0x34a>
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
  8032ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b1:	83 e8 10             	sub    $0x10,%eax
  8032b4:	83 ec 0c             	sub    $0xc,%esp
  8032b7:	50                   	push   %eax
  8032b8:	e8 87 f6 ff ff       	call   802944 <alloc_block_FF>
  8032bd:	83 c4 10             	add    $0x10,%esp
  8032c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	         if (new_block == NULL)
  8032c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032c7:	75 29                	jne    8032f2 <realloc_block_FF+0x31f>
	         {
	        	 new_block = sbrk(new_size);
  8032c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032cc:	83 ec 0c             	sub    $0xc,%esp
  8032cf:	50                   	push   %eax
  8032d0:	e8 98 ea ff ff       	call   801d6d <sbrk>
  8032d5:	83 c4 10             	add    $0x10,%esp
  8032d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	        	 if((int)new_block == -1)
  8032db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032de:	83 f8 ff             	cmp    $0xffffffff,%eax
  8032e1:	75 07                	jne    8032ea <realloc_block_FF+0x317>
	        	 {
	        		 return NULL;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	eb 33                	jmp    80331d <realloc_block_FF+0x34a>
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
  8032ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ed:	83 c0 10             	add    $0x10,%eax
  8032f0:	eb 2b                	jmp    80331d <realloc_block_FF+0x34a>
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	50                   	push   %eax
  8032fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8032fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803301:	e8 2f e3 ff ff       	call   801635 <memcpy>
  803306:	83 c4 10             	add    $0x10,%esp
	        	 free_block(block);
  803309:	83 ec 0c             	sub    $0xc,%esp
  80330c:	ff 75 f4             	pushl  -0xc(%ebp)
  80330f:	e8 d7 fa ff ff       	call   802deb <free_block>
  803314:	83 c4 10             	add    $0x10,%esp
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
  803317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331a:	83 c0 10             	add    $0x10,%eax
	         }
	     }
	}
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    
  80331f:	90                   	nop

00803320 <__udivdi3>:
  803320:	55                   	push   %ebp
  803321:	57                   	push   %edi
  803322:	56                   	push   %esi
  803323:	53                   	push   %ebx
  803324:	83 ec 1c             	sub    $0x1c,%esp
  803327:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80332b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80332f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803333:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803337:	89 ca                	mov    %ecx,%edx
  803339:	89 f8                	mov    %edi,%eax
  80333b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80333f:	85 f6                	test   %esi,%esi
  803341:	75 2d                	jne    803370 <__udivdi3+0x50>
  803343:	39 cf                	cmp    %ecx,%edi
  803345:	77 65                	ja     8033ac <__udivdi3+0x8c>
  803347:	89 fd                	mov    %edi,%ebp
  803349:	85 ff                	test   %edi,%edi
  80334b:	75 0b                	jne    803358 <__udivdi3+0x38>
  80334d:	b8 01 00 00 00       	mov    $0x1,%eax
  803352:	31 d2                	xor    %edx,%edx
  803354:	f7 f7                	div    %edi
  803356:	89 c5                	mov    %eax,%ebp
  803358:	31 d2                	xor    %edx,%edx
  80335a:	89 c8                	mov    %ecx,%eax
  80335c:	f7 f5                	div    %ebp
  80335e:	89 c1                	mov    %eax,%ecx
  803360:	89 d8                	mov    %ebx,%eax
  803362:	f7 f5                	div    %ebp
  803364:	89 cf                	mov    %ecx,%edi
  803366:	89 fa                	mov    %edi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	39 ce                	cmp    %ecx,%esi
  803372:	77 28                	ja     80339c <__udivdi3+0x7c>
  803374:	0f bd fe             	bsr    %esi,%edi
  803377:	83 f7 1f             	xor    $0x1f,%edi
  80337a:	75 40                	jne    8033bc <__udivdi3+0x9c>
  80337c:	39 ce                	cmp    %ecx,%esi
  80337e:	72 0a                	jb     80338a <__udivdi3+0x6a>
  803380:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803384:	0f 87 9e 00 00 00    	ja     803428 <__udivdi3+0x108>
  80338a:	b8 01 00 00 00       	mov    $0x1,%eax
  80338f:	89 fa                	mov    %edi,%edx
  803391:	83 c4 1c             	add    $0x1c,%esp
  803394:	5b                   	pop    %ebx
  803395:	5e                   	pop    %esi
  803396:	5f                   	pop    %edi
  803397:	5d                   	pop    %ebp
  803398:	c3                   	ret    
  803399:	8d 76 00             	lea    0x0(%esi),%esi
  80339c:	31 ff                	xor    %edi,%edi
  80339e:	31 c0                	xor    %eax,%eax
  8033a0:	89 fa                	mov    %edi,%edx
  8033a2:	83 c4 1c             	add    $0x1c,%esp
  8033a5:	5b                   	pop    %ebx
  8033a6:	5e                   	pop    %esi
  8033a7:	5f                   	pop    %edi
  8033a8:	5d                   	pop    %ebp
  8033a9:	c3                   	ret    
  8033aa:	66 90                	xchg   %ax,%ax
  8033ac:	89 d8                	mov    %ebx,%eax
  8033ae:	f7 f7                	div    %edi
  8033b0:	31 ff                	xor    %edi,%edi
  8033b2:	89 fa                	mov    %edi,%edx
  8033b4:	83 c4 1c             	add    $0x1c,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5e                   	pop    %esi
  8033b9:	5f                   	pop    %edi
  8033ba:	5d                   	pop    %ebp
  8033bb:	c3                   	ret    
  8033bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033c1:	89 eb                	mov    %ebp,%ebx
  8033c3:	29 fb                	sub    %edi,%ebx
  8033c5:	89 f9                	mov    %edi,%ecx
  8033c7:	d3 e6                	shl    %cl,%esi
  8033c9:	89 c5                	mov    %eax,%ebp
  8033cb:	88 d9                	mov    %bl,%cl
  8033cd:	d3 ed                	shr    %cl,%ebp
  8033cf:	89 e9                	mov    %ebp,%ecx
  8033d1:	09 f1                	or     %esi,%ecx
  8033d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033d7:	89 f9                	mov    %edi,%ecx
  8033d9:	d3 e0                	shl    %cl,%eax
  8033db:	89 c5                	mov    %eax,%ebp
  8033dd:	89 d6                	mov    %edx,%esi
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 ee                	shr    %cl,%esi
  8033e3:	89 f9                	mov    %edi,%ecx
  8033e5:	d3 e2                	shl    %cl,%edx
  8033e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033eb:	88 d9                	mov    %bl,%cl
  8033ed:	d3 e8                	shr    %cl,%eax
  8033ef:	09 c2                	or     %eax,%edx
  8033f1:	89 d0                	mov    %edx,%eax
  8033f3:	89 f2                	mov    %esi,%edx
  8033f5:	f7 74 24 0c          	divl   0xc(%esp)
  8033f9:	89 d6                	mov    %edx,%esi
  8033fb:	89 c3                	mov    %eax,%ebx
  8033fd:	f7 e5                	mul    %ebp
  8033ff:	39 d6                	cmp    %edx,%esi
  803401:	72 19                	jb     80341c <__udivdi3+0xfc>
  803403:	74 0b                	je     803410 <__udivdi3+0xf0>
  803405:	89 d8                	mov    %ebx,%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 58 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	8b 54 24 08          	mov    0x8(%esp),%edx
  803414:	89 f9                	mov    %edi,%ecx
  803416:	d3 e2                	shl    %cl,%edx
  803418:	39 c2                	cmp    %eax,%edx
  80341a:	73 e9                	jae    803405 <__udivdi3+0xe5>
  80341c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80341f:	31 ff                	xor    %edi,%edi
  803421:	e9 40 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  803426:	66 90                	xchg   %ax,%ax
  803428:	31 c0                	xor    %eax,%eax
  80342a:	e9 37 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  80342f:	90                   	nop

00803430 <__umoddi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	53                   	push   %ebx
  803434:	83 ec 1c             	sub    $0x1c,%esp
  803437:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80343b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80343f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803443:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80344b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80344f:	89 f3                	mov    %esi,%ebx
  803451:	89 fa                	mov    %edi,%edx
  803453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803457:	89 34 24             	mov    %esi,(%esp)
  80345a:	85 c0                	test   %eax,%eax
  80345c:	75 1a                	jne    803478 <__umoddi3+0x48>
  80345e:	39 f7                	cmp    %esi,%edi
  803460:	0f 86 a2 00 00 00    	jbe    803508 <__umoddi3+0xd8>
  803466:	89 c8                	mov    %ecx,%eax
  803468:	89 f2                	mov    %esi,%edx
  80346a:	f7 f7                	div    %edi
  80346c:	89 d0                	mov    %edx,%eax
  80346e:	31 d2                	xor    %edx,%edx
  803470:	83 c4 1c             	add    $0x1c,%esp
  803473:	5b                   	pop    %ebx
  803474:	5e                   	pop    %esi
  803475:	5f                   	pop    %edi
  803476:	5d                   	pop    %ebp
  803477:	c3                   	ret    
  803478:	39 f0                	cmp    %esi,%eax
  80347a:	0f 87 ac 00 00 00    	ja     80352c <__umoddi3+0xfc>
  803480:	0f bd e8             	bsr    %eax,%ebp
  803483:	83 f5 1f             	xor    $0x1f,%ebp
  803486:	0f 84 ac 00 00 00    	je     803538 <__umoddi3+0x108>
  80348c:	bf 20 00 00 00       	mov    $0x20,%edi
  803491:	29 ef                	sub    %ebp,%edi
  803493:	89 fe                	mov    %edi,%esi
  803495:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803499:	89 e9                	mov    %ebp,%ecx
  80349b:	d3 e0                	shl    %cl,%eax
  80349d:	89 d7                	mov    %edx,%edi
  80349f:	89 f1                	mov    %esi,%ecx
  8034a1:	d3 ef                	shr    %cl,%edi
  8034a3:	09 c7                	or     %eax,%edi
  8034a5:	89 e9                	mov    %ebp,%ecx
  8034a7:	d3 e2                	shl    %cl,%edx
  8034a9:	89 14 24             	mov    %edx,(%esp)
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	d3 e0                	shl    %cl,%eax
  8034b0:	89 c2                	mov    %eax,%edx
  8034b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b6:	d3 e0                	shl    %cl,%eax
  8034b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c0:	89 f1                	mov    %esi,%ecx
  8034c2:	d3 e8                	shr    %cl,%eax
  8034c4:	09 d0                	or     %edx,%eax
  8034c6:	d3 eb                	shr    %cl,%ebx
  8034c8:	89 da                	mov    %ebx,%edx
  8034ca:	f7 f7                	div    %edi
  8034cc:	89 d3                	mov    %edx,%ebx
  8034ce:	f7 24 24             	mull   (%esp)
  8034d1:	89 c6                	mov    %eax,%esi
  8034d3:	89 d1                	mov    %edx,%ecx
  8034d5:	39 d3                	cmp    %edx,%ebx
  8034d7:	0f 82 87 00 00 00    	jb     803564 <__umoddi3+0x134>
  8034dd:	0f 84 91 00 00 00    	je     803574 <__umoddi3+0x144>
  8034e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034e7:	29 f2                	sub    %esi,%edx
  8034e9:	19 cb                	sbb    %ecx,%ebx
  8034eb:	89 d8                	mov    %ebx,%eax
  8034ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034f1:	d3 e0                	shl    %cl,%eax
  8034f3:	89 e9                	mov    %ebp,%ecx
  8034f5:	d3 ea                	shr    %cl,%edx
  8034f7:	09 d0                	or     %edx,%eax
  8034f9:	89 e9                	mov    %ebp,%ecx
  8034fb:	d3 eb                	shr    %cl,%ebx
  8034fd:	89 da                	mov    %ebx,%edx
  8034ff:	83 c4 1c             	add    $0x1c,%esp
  803502:	5b                   	pop    %ebx
  803503:	5e                   	pop    %esi
  803504:	5f                   	pop    %edi
  803505:	5d                   	pop    %ebp
  803506:	c3                   	ret    
  803507:	90                   	nop
  803508:	89 fd                	mov    %edi,%ebp
  80350a:	85 ff                	test   %edi,%edi
  80350c:	75 0b                	jne    803519 <__umoddi3+0xe9>
  80350e:	b8 01 00 00 00       	mov    $0x1,%eax
  803513:	31 d2                	xor    %edx,%edx
  803515:	f7 f7                	div    %edi
  803517:	89 c5                	mov    %eax,%ebp
  803519:	89 f0                	mov    %esi,%eax
  80351b:	31 d2                	xor    %edx,%edx
  80351d:	f7 f5                	div    %ebp
  80351f:	89 c8                	mov    %ecx,%eax
  803521:	f7 f5                	div    %ebp
  803523:	89 d0                	mov    %edx,%eax
  803525:	e9 44 ff ff ff       	jmp    80346e <__umoddi3+0x3e>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	89 c8                	mov    %ecx,%eax
  80352e:	89 f2                	mov    %esi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	3b 04 24             	cmp    (%esp),%eax
  80353b:	72 06                	jb     803543 <__umoddi3+0x113>
  80353d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803541:	77 0f                	ja     803552 <__umoddi3+0x122>
  803543:	89 f2                	mov    %esi,%edx
  803545:	29 f9                	sub    %edi,%ecx
  803547:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80354b:	89 14 24             	mov    %edx,(%esp)
  80354e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803552:	8b 44 24 04          	mov    0x4(%esp),%eax
  803556:	8b 14 24             	mov    (%esp),%edx
  803559:	83 c4 1c             	add    $0x1c,%esp
  80355c:	5b                   	pop    %ebx
  80355d:	5e                   	pop    %esi
  80355e:	5f                   	pop    %edi
  80355f:	5d                   	pop    %ebp
  803560:	c3                   	ret    
  803561:	8d 76 00             	lea    0x0(%esi),%esi
  803564:	2b 04 24             	sub    (%esp),%eax
  803567:	19 fa                	sbb    %edi,%edx
  803569:	89 d1                	mov    %edx,%ecx
  80356b:	89 c6                	mov    %eax,%esi
  80356d:	e9 71 ff ff ff       	jmp    8034e3 <__umoddi3+0xb3>
  803572:	66 90                	xchg   %ax,%ax
  803574:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803578:	72 ea                	jb     803564 <__umoddi3+0x134>
  80357a:	89 d9                	mov    %ebx,%ecx
  80357c:	e9 62 ff ff ff       	jmp    8034e3 <__umoddi3+0xb3>
