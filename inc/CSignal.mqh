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
      
   private:
      
      bool CheckBuy();
      bool CheckSell();
};

// buy / sell / none
string CSignal::GetSignal(string trend)
{
   if(trend == "up"){
      return this.CheckBuySignal(type);
   }else if(trend == "down"){
      return this.CheckSellSignal(type);
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
      /*
     if(type == 1){
        
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
   /*
    if(type == 1){
        
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