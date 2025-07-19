#include "kheap.h"
#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"
struct filledPages pagesarr[32766];
int pagesarrsize = 0;
void addElement(uint32 start,uint32 end)
{
        pagesarr[pagesarrsize].start = start;
        pagesarr[pagesarrsize].end = end;
        pagesarrsize++;
}

int searchElement(uint32 start) {
    for (int i = 0; i < pagesarrsize; i++) {
        if (pagesarr[i].start == start) {
            return i;
        }
    }
    return -1;
}
void removeElement(uint32 start) {
    int index = searchElement(start);
        for (int i = index; i < pagesarrsize - 1; i++) {
            pagesarr[i] = pagesarr[i + 1];
        }
        pagesarrsize--;
}

void printArray() {
    cprintf("Array elements:\n");
    for (int i = 0; i < pagesarrsize; i++) {
        cprintf("[%d] start: %u, end: %u\n", i, pagesarr[i].start, pagesarr[i].end);
    }
}
int searchfree(uint32 end)
{
	 for (int i = 0; i < pagesarrsize; i++) {
	        if (pagesarr[i].end == end) {
	            return i;
	        }
	    }
	    return -1;
}
void removefree(uint32 end)
{
	while(searchfree(end)!=-1){
    int index = searchfree(end);
        for (int i = index; i < pagesarrsize - 1; i++) {
            pagesarr[i] = pagesarr[i + 1];
        }
        pagesarrsize--;
	}
}
int initialize_kheap_dynamic_allocator(uint32 daStart, uint32 initSizeToAllocate, uint32 daLimit)
{
	//TODO: [PROJECT'23.MS2 - #01] [1] KERNEL HEAP - initialize_kheap_dynamic_allocator()
		//Initialize the dynamic allocator of kernel heap with the given start address, size & limit
		//All pages in the given range should be allocated
		//Remember: call the initialize_dynamic_allocator(..) to complete the initialization
		//Return:
		//	On success: 0
		//	Otherwise (if no memory OR initial size exceed the given limit): E_NO_MEM
		//Comment the following line(s) before start coding...
		//panic("not implemented yet");
		 if(initSizeToAllocate + daStart > daLimit)
		 {
			 return E_NO_MEM;
		 }
		 start=daStart;
		 segment_break=daStart+initSizeToAllocate;
		 hard_limit=daLimit;
		 uint32 i;
		 struct FrameInfo *frame;
		 for (i = daStart; i < daStart + initSizeToAllocate; i += PAGE_SIZE)
		 {
			 if(allocate_frame(&frame) != 0)
			 {
				 return E_NO_MEM;
			 }
			 else
			 {
				 frame->va = i;
				 map_frame(ptr_page_directory, frame,i,PERM_PRESENT|PERM_WRITEABLE);
			 }
		 }
		 initialize_dynamic_allocator(daStart, initSizeToAllocate);
		 return 0;
}

void* sbrk(int increment)
{
	//TODO: [PROJECT'23.MS2 - #02] [1] KERNEL HEAP - sbrk()
			/* increment > 0: move the segment break of the kernel to increase the size of its heap,
			 * 				you should allocate pages and map them into the kernel virtual address space as necessary,
			 * 				and returns the address of the previous break (i.e. the beginning of newly mapped memory).
			 * increment = 0: just return the current position of the segment break
			 * increment < 0: move the segment break of the kernel to decrease the size of its heap,
			 * 				you should deallocate pages that no longer contain part of the heap as necessary.
			 * 				and returns the address of the new break (i.e. the end of the current heap space).
			 *
			 * NOTES:
			 * 	1) You should only have to allocate or deallocate pages if the segment break crosses a page boundary
			 * 	2) New segment break should be aligned on page-boundary to avoid "No Man's Land" problem
			 * 	3) Allocating additional pages for a kernel dynamic allocator will fail if the free frames are exhausted
			 * 		or the break exceed the limit of the dynamic allocator. If sbrk fails, kernel should panic(...)
			 */

			//MS2: COMMENT THIS LINE BEFORE START CODING====
			//return (void*)-1 ;
			//panic("not implemented yet");
	if (increment == 0)
	{
		return (void *)segment_break;
	}
	uint32 breaked=segment_break;
	if (increment > 0){
		uint32 newBreak = ROUNDUP(segment_break + increment, PAGE_SIZE);
		if (newBreak > hard_limit) {
			panic("sbrk: Exceeded hard limit");
		}
		uint32 z;
		struct FrameInfo *frame;
		for(z=segment_break;z<=newBreak;z+=PAGE_SIZE){
			frame= (struct FrameInfo *)z;
			if (allocate_frame(&frame) != 0) {
				panic("sbrk: Failed to allocate frame");
			}
			frame->va = z;
			map_frame(ptr_page_directory, frame, segment_break, PERM_WRITEABLE);
			segment_break += PAGE_SIZE;
		}
		return (void *)(breaked);
	}

	if (increment < 0) {
		int32 newBreak = segment_break + increment;
		if (newBreak < KERNEL_HEAP_START)
		{
			panic("sbrk: Below heap start");
		}

		uint32 i;
		for(i = newBreak;i<segment_break;i+=1){
			unmap_frame(ptr_page_directory,i);
		}
		segment_break = newBreak;
		return (void *)newBreak;
	}
	return 0;
}



void* kmalloc(unsigned int size)
{
	//TODO: [PROJECT'23.MS2 - #03] [1] KERNEL HEAP - kmalloc()
		//refer to the` project presentation and documentation for details
		// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy
		//change this "return" according to your answer
		//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
		  if (size <= 0 || size > (KERNEL_HEAP_MAX - KERNEL_HEAP_START))
		  {
			  return NULL;
		  }

		  if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
		  {
		        if (isKHeapPlacementStrategyFIRSTFIT())
		        {
		        	return alloc_block_FF(size);
		        }
		        else if (isKHeapPlacementStrategyBESTFIT())
		        {
		            return alloc_block_BF(size);
		        }
		  }
		  else
		  {
			  size = ROUNDUP(size, PAGE_SIZE);
			  int numOfPages = size / PAGE_SIZE;
			  int end = 0;
			  int count = 0;
			  int start = -1;

			  for (uint32 i = hard_limit + PAGE_SIZE; i < KERNEL_HEAP_MAX; i += PAGE_SIZE)
			  {
				  uint32 *ptr = NULL;
				  struct FrameInfo *frame_info_ptr = get_frame_info(ptr_page_directory, i, &ptr);
				  if (frame_info_ptr == NULL)
				  {
					  count++;
					  if (count == numOfPages)
					  {
						  end = i + PAGE_SIZE;
						  start = end - (count * PAGE_SIZE);
						  break;
					  }
				  }
				  else
				  {
					  count = 0;
				  }
			  }
			  if (start == -1)
			  {
				  return NULL;
			  }

			  for (int i = start; i < end; i += PAGE_SIZE)
			  {
				  struct FrameInfo *frame_info_ptr = NULL;
				  allocate_frame(&frame_info_ptr);
				  frame_info_ptr->va = i;
				  map_frame(ptr_page_directory, frame_info_ptr, i, PERM_PRESENT | PERM_WRITEABLE);
				  addElement(i,end);
			  }
			  return (void *)start;
		  }
		  return NULL;
}


void kfree(void* virtual_address)
{
	//TODO: [PROJECT'23.MS2 - #04] [1] KERNEL HEAP - kfree()
	//refer to the project presentation and documentation for details
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");
	if((uint32)virtual_address>KERNEL_HEAP_MAX || (uint32)virtual_address<KERNEL_HEAP_START)
	{
		panic("Invalid Address");
	}
	if ((uint32)virtual_address>= KERNEL_HEAP_START&&(uint32)virtual_address<hard_limit)
	{
		free_block(virtual_address);
	}
	else
	{
		int x = searchElement((uint32) virtual_address);
		uint32 size = pagesarr[x].end - pagesarr[x].start;
		uint32 numOfPages = ROUNDUP(size,PAGE_SIZE)/PAGE_SIZE;
				for(int i = 0; i < numOfPages ; i++)
				{
					unmap_frame(ptr_page_directory, (uint32)virtual_address);
					virtual_address += PAGE_SIZE;

				}
				removefree(pagesarr[x].end);
	}
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'23.MS2 - #05] [1] KERNEL HEAP - kheap_virtual_address()
		//refer to the project presentation and documentation for details
		// Write your code here, remove the panic and write your code
		//panic("kheap_virtual_address() is not implemented yet...!!");

		//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================

		//change this "return" according to your answer
		struct FrameInfo* ptr=to_frame_info(physical_address);

		if(ptr==NULL)
		{
			return 0;
		}
		uint32 *pagetableptr=NULL;
		struct FrameInfo* virtaddinfo=get_frame_info(ptr_page_directory,ptr->va,&pagetableptr);
		if(virtaddinfo==NULL)
		{
			return 0;
		}

		return ptr->va + (physical_address  & 0xFFF);
}
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'23.MS2 - #06] [1] KERNEL HEAP - kheap_physical_address()
	//refer to the project presentation and documentation for details
	// Write your code here, remove the panic and write your code
	//return PTX( virtual_address);

	//panic("kheap_physical_address() is not implemented yet...!!");

	//change this "return" according to your answer
	uint32 *pageTablePtr=NULL;
	struct FrameInfo* ptr=get_frame_info(ptr_page_directory,virtual_address,&pageTablePtr);
	if(ptr==NULL)
		return 0;
	uint32 offset=virtual_address%PAGE_SIZE;
	uint32 PhysAddrres=to_physical_address(ptr)+offset;
	return PhysAddrres;
}
void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}
void *krealloc(void *virtual_address, uint32 new_size)
{
	//=================================================================================//
	//============================== BONUS FUNCTION ===================================//
	//=================================================================================//
	// krealloc():

	//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
	//	possibly moving it in the heap.
	//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
	//	On failure, returns a null pointer, and the old virtual_address remains valid.

	//	A call with virtual_address = null is equivalent to kmalloc().
	//	A call with new_size = zero is equivalent to kfree().
	if (virtual_address == NULL&&new_size == 0)
	{
		return NULL;
	}
	if (virtual_address == NULL)
	{
		return kmalloc(new_size);
	}
	if (new_size == 0)
	{
		kfree(virtual_address);
		return NULL;
	}
	 uint32 new_va=(uint32)virtual_address;
	if(new_va>=KERNEL_HEAP_START&&new_va<hard_limit)
	{
		return realloc_block_FF(virtual_address,new_size);
	}
	else if(new_va>=hard_limit+PAGE_SIZE&&new_va<KERNEL_HEAP_MAX)
	{
	 if(searchElement(new_va)==-1)
	 {
		 if((KERNEL_HEAP_MAX-new_va)>=new_size)
		 {
			 new_size = ROUNDUP(new_size, PAGE_SIZE);
			 uint32 end=new_va+new_size;
			 for (uint32 i = new_va; i < end; i += PAGE_SIZE)
			 {
				  struct FrameInfo *frame_info_ptr = NULL;
				  allocate_frame(&frame_info_ptr);
				  frame_info_ptr->va = i;
				  map_frame(ptr_page_directory, frame_info_ptr, i, PERM_PRESENT | PERM_WRITEABLE);
				  addElement(i,end);
			 }
			 return (void *)new_va;
		 }
		 else
		 {
			 return NULL;
		 }
	 }
	 else
	 {
		 if((KERNEL_HEAP_MAX-new_va)<new_size)
		 {
			 return NULL;
		 }
		 else
		 {
			 int end = 0;
			 int count = 0;
			 int start = -1;
			 int numOfPages = new_size / PAGE_SIZE;
			 uint32 index=searchElement(new_va);
			 for(uint32 i=pagesarr[index].end;i<KERNEL_HEAP_MAX;i+=PAGE_SIZE)
			 {
				 uint32 *ptr = NULL;
				 struct FrameInfo *frame_info_ptr = get_frame_info(ptr_page_directory, i, &ptr);
				 if (frame_info_ptr == NULL)
				 {
					 count++;
					 if (count == numOfPages)
					 {
						 end = i + PAGE_SIZE;
						 start = end - (count * PAGE_SIZE);
						 break;
					 }
				 }
				 else
				 {
					 count = 0;
				 }
			 }
			 if (start == -1)
			 {
				 return NULL;
			 }

			 for (int i = start; i < end; i += PAGE_SIZE)
			 {
				 struct FrameInfo *frame_info_ptr = NULL;
				 allocate_frame(&frame_info_ptr);
				 frame_info_ptr->va = i;
				 map_frame(ptr_page_directory, frame_info_ptr, i, PERM_PRESENT | PERM_WRITEABLE);
				 addElement(i,end);
			 }

			 return (void *)start;
		 }
		 return NULL;
	 }
	}
	return NULL;
}
