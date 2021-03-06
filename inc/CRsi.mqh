//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CRsi
{  
   private:
     int period;
     int tf;   //PERIOD_M1
     
   public:
      double data[30];
      
      CRsi(int _tf, int _period){
         period = _period;
         tf = _tf;
         Fill();
      };
      
      void Fill();
};

void CRsi::Fill()
{
   for(int i=0;i<30;i++){
      data[i] = iRSI(NULL, tf, period, PRICE_CLOSE, i);
   }
   Print(TimeCurrent(),"CRsi data=",this.data[1]);
}
