//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CLaguerreFilter
{  
   private:
     int period;
     int tf;   //PERIOD_M1
     
   public:
      double data[50];
      
      CLaguerreFilter(int _tf, int _period){
         period = _period;
         tf = _tf;
         Fill();
      };
      
      void Fill();
      bool IsUp();
      bool IsDown();
      double HighValue(int beginIndex, int counts); 
      double LowValue(int beginIndex, int counts);
      double Distance(int beginIndex, int counts);
      
      int HighIndex(int beginIndex, int counts); 
      int LowIndex(int beginIndex, int counts);
};

void CLaguerreFilter::Fill()
{
   for(int i=0;i<50;i++){
      data[i] = iCustom(NULL,tf,"LaguerreFilter",0,i);
      //iStochastic(NULL, tf, period, 3, 3, MODE_SMA, 0, MODE_MAIN, i);
   }
   if(tf == PERIOD_M5){
      //Print(TimeCurrent()," LaguerreFilter M5 data[1-10]=",this.data[1],"，",this.data[2],"，",this.data[3],"，",this.data[4],"，",this.data[5],"，",";");
      //Print("-------------------------------");
   }
}

bool CLaguerreFilter::IsUp()
{
   if(data[1] > data[2] && data[2]>=data[3]){
      return true;
   }
   return false;
}

bool CLaguerreFilter::IsDown()
{
   if(data[1] < data[2] && data[2]<=data[3]){
      return true;
   }
   return false;
}

double CLaguerreFilter::HighValue(int beginIndex, int counts)
{
   double h = -1;
   int limit = beginIndex+counts;
   for(int i=beginIndex;i<limit;i++){ 
      if(data[i] > h){
         h = data[i];
      }
   }
   return h;
}

double CLaguerreFilter::LowValue(int beginIndex, int counts)
{
   double l = 9999999;
   int limit = beginIndex+counts;
   for(int i=beginIndex;i<limit;i++){ 
      if(data[i] < l){
         l = data[i];
      }
   }
   return l;
}

double CLaguerreFilter::Distance(int beginIndex, int counts)
{
   double h = this.HighValue(beginIndex, counts);
   double l = this.LowValue(beginIndex, counts);
   return h - l;
}

int CLaguerreFilter::HighIndex(int beginIndex, int counts)
{
   double h = -1;
   int idx = beginIndex;
   int limit = beginIndex+counts;
   for(int i=beginIndex;i<limit;i++){ 
      if(data[i] > h){
         h = data[i];
         idx = i;
      }
   }
   return idx;
}

int CLaguerreFilter::LowIndex(int beginIndex, int counts)
{
   double l = 9999999;
   int idx = beginIndex;
   int limit = beginIndex+counts;
   for(int i=beginIndex;i<limit;i++){ 
      if(data[i] < l){
         l = data[i];
         idx = i;
      }
   }
   return idx;
}