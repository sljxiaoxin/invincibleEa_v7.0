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
      CLaguerreRsi* oCLRsi_M1;
      
      CStoch* oStochFast; //7
      CStoch* oStochMid;  //14
      CStoch* oStochSlow; //100
      
      
      
   public:
      
      
      CSignal(CHeikenAshiSmoothed* _oCHa_M1, CDoublecciWoody* _oCci_M1, CLaguerreRsi* _oCLRsi_M1, CStoch* _oStochFast, CStoch* _oStochMid, CStoch* _oStochSlow){
         oCHa_M1 = _oCHa_M1;
         oCci_M1 = _oCci_M1;
         oCLRsi_M1 = _oCLRsi_M1;
         
         oStochFast = _oStochFast;
         oStochMid  = _oStochMid;
         oStochSlow = _oStochSlow;
      };
      
      string GetSignal(string trend);      //trend is up / down
      string CheckBuySignal();
      string CheckSellSignal();
      
      string GetExitSignal(string trend);
      string CheckExitBuy();
      string CheckExitSell();
};

// buy / sell / none
string CSignal::GetSignal(string trend)
{
   if(trend == "up"){
      return this.CheckBuySignal();
   }else if(trend == "down"){
      return this.CheckSellSignal();
   }
   return "none";
}
 
string CSignal::CheckBuySignal()
{
      /*
     if(oCLRsi_M1.data[1]>=0.15 && oCLRsi_M1.data[2]<0.15){
         if(oCLRsi_M1.data[2] == 0 || oCLRsi_M1.data[3] == 0 || oCLRsi_M1.data[4] == 0 || oCLRsi_M1.data[5] == 0 || oCLRsi_M1.data[6] == 0){
            return "long";
         }
     }
     */
     if(oCLRsi_M1.data[1]>=0.45 && oCLRsi_M1.data[2]<0.45 && oStochSlow.data[1]>50){
         return "long";
     }
     return "none";
}

string CSignal::CheckSellSignal()
{
    /*
     if(oCLRsi_M1.data[1]<=0.85 && oCLRsi_M1.data[2]>0.85){
         if(oCLRsi_M1.data[2] == 1 || oCLRsi_M1.data[3] == 1 || oCLRsi_M1.data[4] == 1 || oCLRsi_M1.data[5] == 1 || oCLRsi_M1.data[6] == 1){
            return "short";
         }
     }
     */
     if(oCLRsi_M1.data[1]<=0.55 && oCLRsi_M1.data[2]>0.55 && oStochSlow.data[1]<50){
         return "short";
     }
     return "none";
}

string CSignal::GetExitSignal(string trend)
{
   if(trend == "up"){
      return this.CheckExitBuy();
   }else if(trend == "down"){
      return this.CheckExitSell();
   }
   return "none";
}

string CSignal::CheckExitBuy()
{
/*
   if(oCLRsi_M1.data[1]<0.77 && oCLRsi_M1.data[2]>=0.77){
      return "Trend_Buy_Exit";
   }
   */
   return "none";
}

string CSignal::CheckExitSell()
{
   /*
  if(oCLRsi_M1.data[1]>0.23 && oCLRsi_M1.data[2]<=0.23){
      return "Trend_Sell_Exit";
   }
   */
   return "none";
}