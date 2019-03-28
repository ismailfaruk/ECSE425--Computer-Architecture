package edumips64.core;

import edumips64.utils.*;
import java.util.*;
import edumips64.core.is.*;
import java.util.logging.Logger;


public class Cache{
	private Map<Integer , Integer> cache;
	final int tagLength= ;
	final int indexLength= ;
	final int BlockLength= ;

	private List<MemoryElement> cells;




	public Cache(){
		cells= new ArrayList<MemoryElement>();
		cache = new HashMap<Integer,Integer>();
	}


	public boolean isHit(int address){
       int index = getIndex(address);
       int tag1 = getTag(address); 
       int tag2 = cache.get(index);
       return tag1==tag2;
	}

	/** (If cache hits), load data from cache
	*/
	public MemoryElement cacheGet(int address){
		int tag=getTag(address);
		return cells.get(tag);
	}

	/** (After a cache miss), load data from memory and store into cache
	*/
	public MemoryElement cacheAdd(List<MemoryElement> mem,int address){
		//remove the element from the cell that corresponds to current index
		int index = getIndex(address);
		int tag=getTag(address);
		if(cache.get(index)!=null){
			cells.remove(cache.get(index));
		}
		cache.replace(index,tag);//update the cache mapping

		cell.add(tag,getCell(mem,address));

		//add element to cell
		return getCell(mem,address);
	}


	private int getTag(int address){
		String addressBinary = Integer.toBinaryString(no);
		String tagString=substring(0, tagLength);
		int tag=Integer.parseInt(tagString);
		return tag;
	}

	private int getIndex(int address){
		String addressBinary = Integer.toBinaryString(no);
		String iString=substring(tagLength, tagLength+indexLength);
		int i=Integer.parseInt(iString);
		return i;
	}


	private MemoryElement getCell(List<MemoryElement> mem,int address) throws MemoryElementNotFoundException{

		int index = address / 8;		

		if(index >= CPU.DATALIMIT || index < 0 || address < 0)

			throw new MemoryElementNotFoundException();

		return mem.get(index);

	}



}
