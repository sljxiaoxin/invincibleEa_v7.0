//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"
#include "CStoch.mqh";

class CSignal
{  
   private:
      CHeikenAshiSmoothed* oCHa_M1;
      CDoublecciWoody* oCci_M1;
      CRsi* oCRsi_M1;
      
      CStoch* oStochFast; //7
      CStoch* oStochMid;  //14
      CStoch* oStochSlow; //100
      
      
      
   public:
      
      
      CSignal(CHeikenAshiSmoothed* _oCHa_M1, CDoublecciWoody* _oCci_M1, CRsi* _oCRsi_M1, CStoch* _oStochFast, CStoch* _oStochMid, CStoch* _oStochSlow){
         oCHa_M1 = _oCHa_M1;
         oCci_M1 = _oCci_M1;
         oCRsi_M1 = _oCRsi_M1;
         
         oStochFast = _oStochFast;
         oStochMid  = _oStochMid;
         oStochSlow = _oStochSlow;
      };
      
      string GetSignal(string trend, int type);      //trend is up / down
      string CheckBuySignal(int type);
      string CheckSellSignal(int type);
      
   private:
      
      bool CheckBuy();
      bool CheckSell();
};

// buy / sell / none
string CSignal::GetSignal(string trend, int type)
{
   if(trend == "up"){
      return this.CheckBuySignal(type);
   }else if(trend == "down"){
      return this.CheckSellSignal(type);
   }
   return "none";
}
 
string CSignal::CheckBuySignal(int type)
{
      /*
     if(type == 1){
        //趋势初次转变判断
        if(oCSolarM1.data[1] < 10 && oCSolarM1.data[1]>oCSolarM1.data[2] ){
            return "buy";
        }else{
            return "none";
        }
     }else{
        if(oCSolarM1.data[1] >= oCSolarM1.data[2] && oCSolarM1.data[1]>-10){
            if(oStochFast.data[1]>20 && oStochFast.data[2]<=20){
               return "buy";
            }
            if(oStochMid.data[1]>20 && oStochMid.data[2]<=20){
               return "buy";
            }
            if(oStochSlow.data[1]>20 && oStochSlow.data[2]<=20){
               return "buy";
            }
        }
     }
     */
     return "none";
}

string CSignal::CheckSellSignal(int type)
{
   /*
    if(type == 1){
        //趋势初次转变判断
        if(oCSolarM1.data[1] > -10 && oCSolarM1.data[1]<oCSolarM1.data[2] ){
            return "sell";
        }else{
            return "none";
        }
     }else{
        if(oCSolarM1.data[1] <= oCSolarM1.data[2] && oCSolarM1.data[1]<10){
            if(oStochFast.data[1]<80 && oStochFast.data[2]>=80){
               return "sell";
            }
            if(oStochMid.data[1]<80 && oStochMid.data[2]>=80){
               return "sell";
            }
            if(oStochSlow.data[1]<80 && oStochSlow.data[2]>=80){
               return "sell";
            }
        }
     }
     */
     return "none";
}

bool CSignal::CheckBuy()
{
   return false;
}

bool CSignal::CheckSell()
{
   return false;
}