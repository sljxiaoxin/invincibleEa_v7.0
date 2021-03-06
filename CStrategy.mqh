//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015    |
//|                                              yangjx009@139.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

#include "inc\CTrade.mqh";
#include "inc\CMa.mqh";
#include "inc\CStoch.mqh";
#include "inc\CTicket.mqh";
#include "inc\CPriceAction.mqh";

#include "inc\CHeikenAshiSmoothed.mqh";
#include "inc\CLaguerreFilter.mqh";
#include "inc\CLaguerreRsi.mqh";
#include "inc\CDoublecciWoody.mqh";
#include "inc\CRsi.mqh";

#include "inc\CSignal.mqh";

#include "inc\CDraw.mqh";

class CStrategy
{  
   private:
   
     datetime CheckTimeM1;
     datetime CheckTimeM5; 
     double   Lots;
     int      Tp;
     int      Sl;
     
     int      SignalAfterNum;
     
     CTrade* oCTrade;
     
     CHeikenAshiSmoothed* oCHa_M1;
     CHeikenAshiSmoothed* oCHa_M5;
     
     CLaguerreFilter* oCLFilter_M5;
     CLaguerreFilter* oCLFilter_M1;
     CLaguerreRsi* oCLRsi_M5;
     CLaguerreRsi* oCLRsi_M1;
     
     CDoublecciWoody* oCci_M1;
     //CRsi* oCRsi_M1;
     
     CStoch* oCStoch_fast;
     CStoch* oCStoch_mid;
     CStoch* oCStoch_slow;
     
     CTicket* oCTicket;
     //CTicket* oCTicket2;
     CSignal* oCSignal;
     //CPriceAction* oCPriceAction;
     
     
     string mTrend;          //main trend up down none
     //bool mIsOpen;         //if current signal has open order
     string mSignalType;   //buy sell none;
     //int mSignalPass;   //from signal income pass K number
     int mSignalOpenNum;  
     
     bool mIsReadyBuy;
     double mThresholdBuy; //
     bool mIsReadySell;
     double mThresholdSell;
     
     
    
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
     
     
   public:
      
      CStrategy(int Magic){
         oCTrade        = new CTrade(Magic);
         
         oCHa_M1      = new CHeikenAshiSmoothed(PERIOD_M1,0);
         oCHa_M5      = new CHeikenAshiSmoothed(PERIOD_M5,0);
         oCLFilter_M5 = new CLaguerreFilter(PERIOD_M5,0);
         oCLFilter_M1 = new CLaguerreFilter(PERIOD_M1,0);
         oCLRsi_M5    = new CLaguerreRsi(PERIOD_M5,0);
         oCLRsi_M1    = new CLaguerreRsi(PERIOD_M1,0);
         oCci_M1      = new CDoublecciWoody(PERIOD_M1,0);
         //oCRsi_M1     = new CRsi(PERIOD_M1,14);
         
         oCStoch_fast   = new CStoch(PERIOD_M1,7);
         oCStoch_mid    = new CStoch(PERIOD_M1,14);
         oCStoch_slow   = new CStoch(PERIOD_M1,100);
         
         
         
         oCTicket     = new CTicket(oCTrade);
         //oCTicket2    = new CTicket(oCTrade);
         oCSignal = new CSignal(oCHa_M1, oCci_M1, oCLRsi_M1, oCStoch_fast, oCStoch_mid, oCStoch_slow);
         
         //mIsOpen     = false;
         this.mTrend      = "none";
         this.mSignalType = "none";
         //mSignalPass = -1;
         
         this.mIsReadyBuy = false;
         this.mIsReadySell = false;
         
         mSignalOpenNum = 0;
         SignalAfterNum = 0;
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Entry();
      void Exit();
      void CheckOpen();
      string getTrend();
      
};

void CStrategy::Init(double _lots, int _tp, int _sl)
{
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategy::Tick(void)
{  
    
    //every M1 do
    if(CheckTimeM1 != iTime(NULL,PERIOD_M1,0)){
         CheckTimeM1 = iTime(NULL,PERIOD_M1,0);
         this.Update();
         this.Exit();
         this.Entry();
    }
    //every M5 do
    if(CheckTimeM5 != iTime(NULL,PERIOD_M5,0)){
         CheckTimeM5 = iTime(NULL,PERIOD_M5,0);
         //GET new trend
         this.GetTrend();
    }
    
   // CheckOpen();
}



void CStrategy::Update()
{

   if(this.SignalAfterNum >0){
      this.SignalAfterNum += 1;
   }
   oCHa_M1.Fill();
   oCHa_M5.Fill();
   oCLFilter_M5.Fill();
   oCLFilter_M1.Fill();
   oCLRsi_M5.Fill();
   oCci_M1.Fill();
   //oCRsi_M1.Fill();
   oCLRsi_M1.Fill();
   
   oCStoch_fast.Fill();
   oCStoch_mid.Fill();
   oCStoch_slow.Fill();
   
   
   oCTicket.Update();
  // oCTicket2.Update();
}

string CStrategy::getTrend()
{
   return this.mTrend;
}

void CStrategy::GetTrend()
{

   if(this.mTrend == "none"){
      if(oCHa_M5.dataOpen[1]<oCHa_M5.dataClose[1] && oCHa_M5.dataClose[1] > oCLFilter_M5.data[1] && oCLRsi_M5.data[1]>0.45){
         this.mTrend = "up";
         this.OnTrendChange();
      }
      if(oCHa_M5.dataOpen[1]>oCHa_M5.dataClose[1] && oCHa_M5.dataClose[1] < oCLFilter_M5.data[1] && oCLRsi_M5.data[1]<0.45){
         this.mTrend = "down";
         this.OnTrendChange();
      }
   }
   if(this.mTrend == "up" && oCHa_M5.dataOpen[1]>oCHa_M5.dataClose[1] && oCHa_M5.dataClose[1] < oCLFilter_M5.data[1] && oCLRsi_M5.data[1]<0.45){
      this.mTrend = "down";
      this.OnTrendChange();
   }
   
   if(this.mTrend == "down" && oCHa_M5.dataOpen[1]<oCHa_M5.dataClose[1] && oCHa_M5.dataClose[1] > oCLFilter_M5.data[1] && oCLRsi_M5.data[1]>0.45){
      this.mTrend = "up";
      this.OnTrendChange();
   }
}


void CStrategy::OnTrendChange()
{
   oCTicket.Close();
   //oCTicket2.Close();
   this.mSignalOpenNum = 0;
   this.SignalAfterNum = 1;
   this.Entry();
   if(this.mTrend == "up"){
      CDraw::Vline(TimeCurrent(), clrBlue);
   }
   if(this.mTrend == "down"){
      CDraw::Vline(TimeCurrent(), clrRed);
   }
}


void CStrategy::Exit()
{
   bool strong = false;
   if(this.mTrend == "up"){
      if(oCTicket.GetOrderPass() ==8){
         for(int i=1;i<8;i++){
            if(oCLRsi_M1.data[i]>=0.85){
               strong = true;
            }
         }
         if(!strong){
            if(oCLRsi_M1.data[1]<0.85 && oCLRsi_M1.data[1]>=0.75 && oCLRsi_M1.data[1]>oCLRsi_M1.data[2]){
               oCTicket.SetOrderPass(7);
            }else if(Open[1]-Close[1]>6*oCTrade.GetPip()){
               oCTicket.SetOrderPass(7);
            }else{
               oCTicket.Close();
            }
         }
      }
   }
   if(this.mTrend == "down"){
      if(oCTicket.GetOrderPass() ==8){
         for(int i=1;i<8;i++){
            if(oCLRsi_M1.data[i]<=0.15){
               strong = true;
            }
         }
         if(!strong){
             if(oCLRsi_M1.data[1]>0.15 && oCLRsi_M1.data[1]<=0.25 && oCLRsi_M1.data[1]<oCLRsi_M1.data[2]){
               oCTicket.SetOrderPass(7);
            }else if(Close[1]-Open[1]>6*oCTrade.GetPip()){
               oCTicket.SetOrderPass(7);
            }else{
               oCTicket.Close();
            }
         }
      }
   }
   /*
   string exitSignal = oCSignal.GetExitSignal(this.mTrend);
   if(exitSignal == "Trend_Buy_Exit" || exitSignal == "Trend_Sell_Exit"){
      oCTicket.Close();
      //oCTicket2.Close();
   }
   
   if(this.mTrend == "up"){
      if(oCTicket.GetOpType() == OP_BUY){
          oCTicket.Close();
      }      
   }
   if(this.mTrend == "down"){
      if(oCTicket.GetOpType() == OP_SELL){
          oCTicket.Close();
      }      
   }
   */
}

void CStrategy::Entry()
{

   if(!oCTicket.isCanOpenOrder()){
      return;
   }
   
   this.mSignalType = oCSignal.GetSignal(this.mTrend);
   Print("this.mSignalType = ",this.mSignalType);
   /*
   if(this.mSignalType == "none"){
      return ;
   }
   */
   
   if(this.mSignalType == "long" || this.mSignalType == "short"){
      this.SignalAfterNum = 1;
   }
   
   if(Ask - Bid >2.5*oCTrade.GetPip() )return ;
   
   
   if(this.SignalAfterNum >0 && this.SignalAfterNum<=8){
      if(this.mTrend == "up"){
         if(Open[1] < oCLFilter_M1.data[1] && Close[1]<oCLFilter_M1.data[1])
         {
            return;
         }
         if(oCLRsi_M1.data[1]<0.5){
            return ;
         }
         if(oCStoch_fast.data[1] > oCStoch_fast.data[2]){
            if(Open[0] - oCLFilter_M1.data[1] <=4*oCTrade.GetPip()){
               oCTicket.Buy(Lots, Tp, Sl, "up");
               this.SignalAfterNum = 0;
               return;
            }
         }
      }
      
      if(this.mTrend == "down"){
         if(Open[1] > oCLFilter_M1.data[1] && Close[1]>oCLFilter_M1.data[1])
         {
            return;
         }
         if(oCLRsi_M1.data[1]>0.5){
            return ;
         }
         if(oCStoch_fast.data[1] < oCStoch_fast.data[2]){
            if(oCLFilter_M1.data[1] - Open[0] <=4*oCTrade.GetPip()){
               oCTicket.Sell(Lots, Tp, Sl, "down");
               this.SignalAfterNum = 0;
               return;
            }
         }
      }
   }
   
   



/*

   if(!oCTicket.isCanOpenOrder() && !oCTicket2.isCanOpenOrder()){
      return;
   }
   this.mSignalType = oCSignal.GetSignal(this.mTrend);
   Print("this.mSignalType = ",this.mSignalType);
   if(this.mSignalType == "none"){
      return ;
   }
   if(Ask - Bid >2.5*oCTrade.GetPip() )return ;
   
   if(oCTicket.isCanOpenOrder()){
      if(this.mSignalOpenNum < 2){
         if(this.mSignalType == "buy_scalp" || this.mSignalType == "long"){
            this.mSignalOpenNum += 1;
            oCTicket.Buy(Lots, Tp, Sl, "Trend-"+this.mSignalType);
            return ;
         }
         if(this.mSignalType == "sell_scalp" || this.mSignalType == "short"){
            this.mSignalOpenNum += 1;
            oCTicket.Sell(Lots, Tp, Sl, "Trend-"+this.mSignalType);
            return ;
         }
      }
   }
   if(oCTicket.GetTicket() >0 && oCTicket.GetOrderPass()<5){
      return ;
   }
   if(oCTicket2.isCanOpenOrder()){
      if(this.mSignalType == "buy_scalp"){
         oCTicket2.Buy(Lots*5, Tp, Sl, "Scalp-"+this.mSignalType);
      }
      if(this.mSignalType == "sell_scalp"){
         oCTicket2.Sell(Lots*5, Tp, Sl, "Scalp-"+this.mSignalType);
      }
   }
   */
   
}