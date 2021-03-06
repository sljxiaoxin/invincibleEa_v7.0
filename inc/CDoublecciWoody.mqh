//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDoublecciWoody
{  
   private:
     int period;
     int tf;   //PERIOD_M1
     
   public:
      double dataTrend[30];
      double dataEntry[30];
      
      CDoublecciWoody(int _tf, int _period){
         period = _period;
         tf = _tf;
         Fill();
      };
      
      void Fill();
};

void CDoublecciWoody::Fill()
{
   for(int i=0;i<30;i++){
      dataTrend[i] = iCustom(NULL,tf,"DoublecciWoody",170, 34,4,i);
      dataEntry[i] = iCustom(NULL,tf,"DoublecciWoody",170, 34, 5,i);
      //iStochastic(NULL, tf, period, 3, 3, MODE_SMA, 0, MODE_MAIN, i);
   }
   if(tf == PERIOD_M1){
      Print(TimeCurrent(),"CDoublecciWoody dataTrend=",this.dataTrend[1],"，dataEntry=",this.dataEntry[1]);
      Print("-------------------------------");
   }
}
