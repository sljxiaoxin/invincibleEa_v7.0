//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CHeikenAshiSmoothed
{  
   private:
     int period;
     int tf;   //PERIOD_M1
     
   public:
      double dataOpen[50];
      double dataClose[50];
      
      CHeikenAshiSmoothed(int _tf, int _period){
         period = _period;
         tf = _tf;
         Fill();
      };
      
      void Fill();
      bool IsUp();
      bool IsDown();
};

void CHeikenAshiSmoothed::Fill()
{
   for(int i=0;i<50;i++){
      dataOpen[i]  = iCustom(NULL,tf,"Heiken_Ashi_Smoothed",2,i);
      dataClose[i] = iCustom(NULL,tf,"Heiken_Ashi_Smoothed",3,i);
   }
   if(tf == PERIOD_M5){
      //Print("[",iTime(NULL,tf,1),"] CHeikenAshiSmoothed dataOpen=",this.dataOpen[1],"，dataClose=",this.dataClose[1]);
      //Print("-------------------------------");
   }
}

bool CHeikenAshiSmoothed::IsUp()
{
   if(dataOpen[1] < dataClose[1]){
      return true;
   }
   return false;
}

bool CHeikenAshiSmoothed::IsDown()
{
   if(dataOpen[1] > dataClose[1]){
      return true;
   }
   return false;
}
