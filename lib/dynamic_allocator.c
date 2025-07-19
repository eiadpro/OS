/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
uint32 get_block_size(void* va)
{
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
	return curBlkMetaData->size ;
}

//===========================
// 2) GET BLOCK STATUS:
//===========================
int8 is_free_block(void* va)
{
	struct BlockMetaData *curBlkMetaData = ((struct BlockMetaData *)va - 1) ;
	return curBlkMetaData->is_free ;
}

//===========================================
// 3) ALLOCATE BLOCK BASED ON GIVEN STRATEGY:
//===========================================
void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
	void *va = NULL;
	switch (ALLOC_STRATEGY)
	{
	case DA_FF:
		va = alloc_block_FF(size);
		break;
	case DA_NF:
		va = alloc_block_NF(size);
		break;
	case DA_BF:
		va = alloc_block_BF(size);
		break;
	case DA_WF:
		va = alloc_block_WF(size);
		break;
	default:
		cprintf("Invalid allocation strategy\n");
		break;
	}
	return va;
}

//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockMetaData* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
	{
		cprintf("(size: %d, isFree: %d)\n", blk->size, blk->is_free) ;
	}
	cprintf("=========================================\n");

}
//
////********************************************************************************//
////********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//==================================
bool is_initialized=0;
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//=========================================
		//DON'T CHANGE THESE LINES=================
		if (initSizeOfAllocatedSpace == 0)
			return ;
		is_initialized=1;
		//=========================================
		//=========================================
		//TODO: [PROJECT'23.MS1 - #5] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator()
		//panic("initialize_dynamic_allocator is not implemented yet");
		LIST_INIT(&blocklist);
		firstBlock = (struct BlockMetaData*)daStart;
		firstBlock->size = initSizeOfAllocatedSpace;
		firstBlock->is_free=1;
		LIST_INSERT_HEAD(&blocklist,firstBlock);
}

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size){
	if (!is_initialized)
	{
		uint32 required_size = size + sizeOfMetaData();
		uint32 da_start = (uint32)sbrk(required_size);
		//get new break since it's page aligned! thus, the size can be more than the required one
		uint32 da_break = (uint32)sbrk(0);
		initialize_dynamic_allocator(da_start, da_break - da_start);
	}

	 //print_blocks_list(blocklist);
	 if(size<=0){
		 return NULL;
	 }
	 size+=sizeOfMetaData();
	 struct BlockMetaData* currentBlock;
	 bool found =0;
	 LIST_FOREACH(currentBlock,&blocklist){
		 if (currentBlock->is_free && currentBlock->size >= size)
		 {
			 if(currentBlock->size == size)
			 {
				 currentBlock->is_free = 0;
				 return (uint32*)((char*)currentBlock +sizeOfMetaData());
			 }
			 else
			 {
				 found=1;
				 currentBlock->is_free=0;
				 if(currentBlock->size-size>=sizeOfMetaData())
				 {
					 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)currentBlock+size);
					 new_block->size=currentBlock->size-size;
					 currentBlock->size=size;
					 new_block->is_free=1;
					 LIST_INSERT_AFTER(&blocklist,currentBlock,new_block);
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
				 }
				 else
					 return (uint32*)((void*)currentBlock +sizeOfMetaData());
			 }
		 }
	 }
	 if(found==0)
	 {
		 currentBlock = sbrk(size);
		 if(currentBlock!=NULL){
			 struct BlockMetaData *sb;
			 sb = (struct BlockMetaData *)currentBlock;
			 sb->size=size;
			 sb->is_free = 0;
			 LIST_INSERT_TAIL(&blocklist, sb);
			 if(PAGE_SIZE-size>=sizeOfMetaData()){
				 struct BlockMetaData *new_block=(struct BlockMetaData*)((uint32)currentBlock+size);
				 new_block->size=PAGE_SIZE-size;
				 new_block->is_free=1;
				 LIST_INSERT_AFTER(&blocklist,sb,new_block);
			 }
			 return (sb + 1);
		 }
		 return NULL;
	 }
	 return NULL;
	}
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
	size+=sizeOfMetaData();
    struct BlockMetaData *bestFitBlock=NULL;
    uint32 bestFitSize = 4294967295;
    struct BlockMetaData *current;
    LIST_FOREACH(current,&blocklist) {
        if (current->is_free && current->size >= size) {
            if (current->size<bestFitSize) {
                bestFitBlock = current;
                bestFitSize = current->size;
            }
        }
    }
    if (bestFitBlock) {
        bestFitBlock->is_free = 0;
        if (bestFitBlock->size>size &&bestFitBlock->size-size>=sizeOfMetaData()) {
			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)bestFitBlock+size);
			new_block->size = bestFitBlock->size - size;
			new_block->is_free = 1;
            bestFitBlock->size = size;
			LIST_INSERT_AFTER(&blocklist,bestFitBlock,new_block);
        }
        return (uint32 *)((void *)bestFitBlock +sizeOfMetaData());
    }

    return NULL;
}
//=========================================
// [6] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
	panic("alloc_block_WF is not implemented yet");
	return NULL;
}

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
	panic("alloc_block_NF is not implemented yet");
	return NULL;
}

//===================================================
// [8] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
	{
		//TODO: [PROJECT'23.MS1 - #7] [3] DYNAMIC ALLOCATOR - free_block()
		//panic("free_block is not implemented yet");
		if (va == NULL) {
				return;
			}
			struct BlockMetaData *block =(struct BlockMetaData *)va-1;
			if(block->is_free){
				return;
			}
			//free block
			block->is_free = 1;
			//check if next is free and merge with the block
			if (LIST_NEXT(block))
			{
				if (LIST_NEXT(block)->is_free)
				{
					block->size += LIST_NEXT(block)->size;
					LIST_NEXT(block)->is_free=0;
					LIST_NEXT(block)->size=0;
					struct BlockMetaData *delnext =LIST_NEXT(block);
					LIST_REMOVE(&blocklist,delnext);
				}
			}
			if( LIST_PREV(block))
			{
				if (LIST_PREV(block)->is_free)
				{
					LIST_PREV(block)->size += block->size;
					LIST_PREV(block)->is_free=1;
					block->is_free=0;
					block->size=0;
					LIST_REMOVE(&blocklist,block);
				}
			}
	}

//=========================================
// [4] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
	//TODO: [PROJECT'23.MS1 - #8] [3] DYNAMIC ALLOCATOR - realloc_block_FF()
	//panic("realloc_block_FF is not implemented yet");
	 if (va == NULL && new_size == 0)
	 {
		 return NULL;
	 }
	 if (va == NULL)
	 {
		 return alloc_block_FF(new_size);
	 }
	 if (new_size == 0)
	 {
		 free_block(va);
		 return NULL;
	 }
	 struct BlockMetaData* block = (struct BlockMetaData*)va - 1;
	 new_size += sizeOfMetaData();
	     if (block->size >= new_size)
	     {
	    	 if(block->size == new_size)
	    	 {
	    		 return va;
	    	 }
	    	 if(block->size - new_size >= sizeOfMetaData())
	    	 {
	    			struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
	    			new_block->size = block->size - new_size;
	    			block->size = new_size;
	    			new_block->is_free = 1;
	    			LIST_INSERT_AFTER(&blocklist,block,new_block);
	    	 }
	    	 return va;
	     }
	     else
	     {
	    	 if (LIST_NEXT(block))
	    	 {
	    		 if (LIST_NEXT(block)->is_free && block->size + LIST_NEXT(block)->size >= new_size)
	    		 {
	    			 block->size += LIST_NEXT(block)->size;
					 LIST_NEXT(block)->is_free=0;
					 LIST_NEXT(block)->size=0;
					 struct BlockMetaData *delnext =LIST_NEXT(block);
					 LIST_REMOVE(&blocklist,delnext);
					 if(block->size - new_size >= sizeOfMetaData())
					 {
						 struct BlockMetaData *new_block=(struct BlockMetaData*)((void*)block + new_size);
						 new_block->size = block->size - new_size;
						 block->size = new_size;
						 new_block->is_free = 1;
						 LIST_INSERT_AFTER(&blocklist,block,new_block);
					 }
					 return va;
	    		 }
	    	 }
	    	 struct BlockMetaData* new_block = alloc_block_FF(new_size - sizeOfMetaData());
	         if (new_block == NULL)
	         {
	        	 new_block = sbrk(new_size);
	        	 if((int)new_block == -1)
	        	 {
	        		 return NULL;
	        	 }
	        	 else
	        	 {
	        		 return (uint32*)((char*)new_block + sizeOfMetaData());
	        	 }
	         }
	         else
	         {
	        	 memcpy(new_block, block, block->size);
	        	 free_block(block);
	        	 return (uint32*)((char*)new_block + sizeOfMetaData());
	         }
	     }
	}
