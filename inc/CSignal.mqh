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
     
     if((oStochFast.data[1]>80 && oStochFast.data[2]<80 && oStochSlow.data[1]>80 && (oStochSlow.data[2]<80 || oStochSlow.data[3]<80 || oStochSlow.data[4]<80)) 
          || (oStochFast.data[1]>20 && oStochFast.data[2]<20) 
          || (oStochFast.data[1]>oStochSlow.data[1] && oStochFast.data[2]<oStochSlow.data[2]) 
       ){
         if(oCci_M1.dataTrend[1]>0 && oCci_M1.dataEntry[1]>0 && (oCci_M1.dataEntry[2]<0 || oCci_M1.dataEntry[3]<0 || oCci_M1.dataEntry[4]<0)){
            return "buy_scalp";
         }
     }
     
     if(oCci_M1.dataTrend[1]>0 && oCRsi_M1.data[1]>0 && oCci_M1.dataEntry[1]>0 && (oCRsi_M1.data[2]<0 || oCci_M1.dataTrend[2]<0 || oCci_M1.dataEntry[2]<0)){
         return "long";
     }
     return "none";
}

string CSignal::CheckSellSignal()
{
   if((oStochFast.data[1]<20 && oStochFast.data[2]>20 && oStochSlow.data[1]<20 && (oStochSlow.data[2]>20 || oStochSlow.data[3]>20 || oStochSlow.data[4]>20)) 
       || (oStochFast.data[1]<80 && oStochFast.data[2]>80) 
       || (oStochFast.data[1]<oStochSlow.data[1] && oStochFast.data[2]>oStochSlow.data[2]) 
    ){
      if(oCci_M1.dataTrend[1]<0 && oCci_M1.dataEntry[1]<0 && (oCci_M1.dataEntry[2]>0 || oCci_M1.dataEntry[3]>0 || oCci_M1.dataEntry[4]>0)){
         return "sell_scalp";
      }
   }
  
   if(oCci_M1.dataTrend[1]<0 && oCRsi_M1.data[1]<0 && oCci_M1.dataEntry[1]<0 && (oCRsi_M1.data[2]>0 || oCci_M1.dataTrend[2]>0 || oCci_M1.dataEntry[2]>0)){
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
   if(oCci_M1.dataEntry[1]<0 && oCci_M1.dataEntry[2]>0){
      for(int i=3;i<=23;i++){
         if(oCci_M1.dataEntry[i] <0){
            break;
         }
      }
      if(i>=21){
         return "Trend_Buy_Exit";
      }
   }
   return "none";
}

string CSignal::CheckExitSell()
{
   if(oCci_M1.dataEntry[1]>0 && oCci_M1.dataEntry[2]<0){
      for(int i=3;i<=23;i++){
         if(oCci_M1.dataEntry[i] >0){
            break;
         }
      }
      if(i>=21){
         return "Trend_Sell_Exit";
      }
   }
   return "none";
}