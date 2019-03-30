package edumips64.core;

import edumips64.utils.*;
import java.util.*;
import edumips64.core.is.*;
import java.util.logging.Logger;

public class Cache {
	private Map<Integer, Integer> cache;
	final int tagLength = 10;
	final int indexLength = 3;
	int cacheSize = 1;
	//final int BlockLength;

	private List<MemoryElement> cells;

	public Cache() {
		for (int i=0;i<indexLength;i++){
			cacheSize*=2;
		}
		
		cells = new ArrayList<MemoryElement>();
		cache = new HashMap<Integer, Integer>();
	
	
		MemoryElement placeHolder=new MemoryElement(-1);
		for(int i =0;i<cacheSize;i++){
			cells.add(placeHolder);
			cache.put(i,-1);
		}
	}

	public boolean isHit(int address) {
		int index = getIndex(address);
		int tag1 = getTag(address);
		int tag2 = cache.get(index);
		return tag1 == tag2;
	}

	/**
	 * (If cache hits), load data from cache
	 */
	public MemoryElement cacheGet(int address) {
		int tag = getTag(address);
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
		try{
			cells.add(tag,getCell(mem,address));
			//page fault
			//add element to cell
			return getCell(mem,address);
		}catch(MemoryElementNotFoundException e){
			return null;
			}
			
		
	
	}

	private int getTag(int address) {
		String addressBinary = Integer.toBinaryString(address);
		String tagString = addressBinary.substring(0, (tagLength - 1));
		int tag = Integer.parseInt(tagString);
		return tag;
	}

	private int getIndex(int address) {
		String addressBinary = Integer.toBinaryString(address);
		String iString = addressBinary.substring(tagLength, (tagLength + indexLength - 1));
		int i = Integer.parseInt(iString);
		return i;
	}

	private MemoryElement getCell(List<MemoryElement> mem, int address) throws MemoryElementNotFoundException {

		int index = address / 8;

		if (index >= CPU.DATALIMIT || index < 0 || address < 0)

			throw new MemoryElementNotFoundException();

		return mem.get(index);

	}

}
