/*
cache.java

This is a data cache. No instructions are stored here.
*/

package edumips64.core;

import edumips64.utils.*;
import java.util.*;
import edumips64.core.is.*;
import java.util.logging.Logger;


public class Cache{
	private Map<Integer , String> cache;
	final int tagLength= ;
	final int indexLength= ;
	final int BlockLength= ;



	public Cache(){
		cache = new HashMap<Integer,String>();
	}

	private class block{

	}

	public boolean isHit(int address){

	}

	/** (If cache hits), load data from cache
	*/
	public MemoryElement cacheGet(int address){

	}

	/** (After a cache miss), load data from memory and store into cache
	*/
	public MemoryElement cacheAdd(List<MemoryElement> mem,int address){

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





}









