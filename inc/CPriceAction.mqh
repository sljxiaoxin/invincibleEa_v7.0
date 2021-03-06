//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CPriceAction
{  
   private:
     
     
   public:
      
      CPriceAction(){};
      ~CPriceAction(){};
     
      static double HighValue(int counts); 
      static double LowValue(int counts);
      static double Distance(int counts);
      //以当前close为最低点，往前找close小于它的，返回index
      static int GetPreCloseLowerIndex(int beginIndex);
      static int GetPreCloseHigherIndex(int beginIndex);
};

static double CPriceAction::HighValue(int counts)
{
   double high = Close[1];
   for(int i=2;i<counts;i++){
      if(Close[i]>high){
         high = Close[i];
      }
   }
   return high;
}

static double CPriceAction::LowValue(int counts)
{
   double low = Close[1];
   for(int i=2;i<counts;i++){
      if(Close[i]<low){
         low = Close[i];
      }
   }
   return low;
}

static double CPriceAction::Distance(int counts)
{
   double low = Close[1],high = Close[1];
   for(int i=2;i<counts;i++){
      if(Close[i]>high){
         high = Close[i];
      }
      if(Close[i]<low){
         low = Close[i];
      }
   }
   return NormalizeDouble(high - low,Digits);
}

static int CPriceAction::GetPreCloseLowerIndex(int beginIndex)
{
   double low = Close[beginIndex];
   int limit = 200;
   for(int i=beginIndex+1;i<limit;i++){
      if(Close[i]<low){
         return i;
      }
   }
   return limit;
}

static int CPriceAction::GetPreCloseHigherIndex(int beginIndex)
{
   double high = Close[beginIndex];
   int limit = 200;
   for(int i=beginIndex+1;i<limit;i++){
      if(Close[i]>high){
         return i;
      }
   }
   return limit;
}