import java.util.concurrent.TimeUnit;


public class CacheBenchmark{
	Boolean cacheActiviated=true;
	double hitRate=;
	int numAccess=;

	int cacheMissDelay=;
	int caheHitDelay=;
	int memoryReadDelay=;

	public static void main(String args[]){
		int startTime=System.currentTimeMillis();
		System.out.println("Cache Benchmarking Start");
		System.out.println("Cache Activated?"+cacheActiviated);
		if(cacheActiviated){
			int hit = (int)(hitRate*numAccess);
			for(int i =0;i<hit;i++){
				TimeUnit.NANOSECOND.sleep(cacheHitDelay);
			}

			int miss = (int)((1-hitRate)*numAccess);
			for(int i =0;i<hit;i++){
				TimeUnit.NANOSECOND.sleep(cacheMissDelay);
			}

		}else{
			for(int i =0;i<numAccess;i++){
				TimeUnit.NANOSECOND.sleep(memoryReadDelay);
			}
	}


		int endTime=System.currentTimeMillis();
		System.out.println("Cache Benchmarking End");
		System.out.println("MilliSecond Used"+(endTime-startTime));

	}