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
#include "inc\CSolar.mqh";
#include "inc\CTicket.mqh";
#include "inc\CPriceAction.mqh";
//#include "inc\CStochCross.mqh";
#include "inc\CSignal.mqh";

class CStrategy
{  
   private:
   
     datetime CheckTimeM1;
     datetime CheckTimeM5; 
     double   Lots;
     int      Tp;
     int      Sl;
     
     CTrade* oCTrade;
     CMa* oCMa_M5_fast;    //M5 for trend
     CMa* oCMa_M5_slow;
     CMa* oCMa_M1_fast;    //M1  for signal
     CMa* oCMa_M1_slow;
     CStoch* oCStoch_fast;
     CStoch* oCStoch_mid;
     CStoch* oCStoch_slow;
     CTicket* oCTicket;
     CSignal* oCSignal;
     //CPriceAction* oCPriceAction;
     
     CSolar* oCSolar_M1;
     CSolar* oCSolar_M5;
     
     string mTrend;          //main trend up down none
     //bool mIsOpen;         //if current signal has open order
     string mSignalType;   //buy sell none;
     //int mSignalPass;   //from signal income pass K number
     int mSignalOpenNum;  
     
     bool mIsReadyBuy;
     double mThresholdBuy; //阈值
     bool mIsReadySell;
     double mThresholdSell;
     
     
    
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
     
     
   public:
      
      CStrategy(int Magic){
         oCTrade        = new CTrade(Magic);
         oCMa_M1_fast   = new CMa(PERIOD_M1,10);
         oCMa_M1_slow   = new CMa(PERIOD_M1,30);
         oCMa_M5_fast   = new CMa(PERIOD_M5,10);
         oCMa_M5_slow   = new CMa(PERIOD_M5,30);
         
         oCStoch_fast   = new CStoch(PERIOD_M1,7);
         oCStoch_mid    = new CStoch(PERIOD_M1,14);
         oCStoch_slow = new CStoch(PERIOD_M1,100);
         
         oCSolar_M1  = new CSolar(PERIOD_M1,0);
         oCSolar_M5  = new CSolar(PERIOD_M5,0);
         
         oCTicket     = new CTicket(oCTrade);
         oCSignal = new CSignal(oCSolar_M1, oCMa_M1_fast, oCStoch_fast, oCStoch_mid, oCStoch_slow);
         
         //mIsOpen     = false;
         this.mTrend      = "none";
         this.mSignalType = "none";
         //mSignalPass = -1;
         
         this.mIsReadyBuy = false;
         this.mIsReadySell = false;
         
         mSignalOpenNum = 0;
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Entry(int type);
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
         this.Entry(2); //普通类型入口判断买入
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
   oCMa_M1_fast.Fill();
   oCMa_M1_slow.Fill();
   oCMa_M5_fast.Fill();
   oCMa_M5_slow.Fill();
   
   oCStoch_fast.Fill();
   oCStoch_mid.Fill();
   oCStoch_slow.Fill();
   
   oCSolar_M1.Fill();
   oCSolar_M5.Fill();
   
   oCTicket.Update();
}

string CStrategy::getTrend()
{
   return this.mTrend;
}

void CStrategy::GetTrend()
{
   /*
   if(this.mTrend == "none"){
      if(oCSolar_M5.data[1]>0){
         this.mTrend = "up";
         this.OnTrendChange();
      }
      if(oCSolar_M5.data[1]<0){
         this.mTrend = "down";
         this.OnTrendChange();
      }
   }
   */
   
   if(oCSolar_M5.data[1]>0 && oCSolar_M5.data[2]<0){
      this.mTrend = "up";
      this.OnTrendChange();
   }
   if(oCSolar_M5.data[1]<0 && oCSolar_M5.data[2]>0){
      this.mTrend = "down";
      this.OnTrendChange();
   }
   /*
   if(this.mTrend == "up" && oCSolar_M5.data[1]<0){
      this.mTrend = "down";
      this.OnTrendChange();
   }
   if(this.mTrend == "down" && oCSolar_M5.data[1]>0){
      this.mTrend = "up";
      this.OnTrendChange();
   }
   */
}


void CStrategy::OnTrendChange()
{
   oCTicket.Close();
   this.mSignalOpenNum = 0;
   this.Entry(1); //趋势转换入口判断买入
}


void CStrategy::Exit()
{
   if(this.mTrend == "up" && oCSolar_M1.data[2]< oCSolar_M1.data[3] && oCSolar_M1.data[1]< oCSolar_M1.data[2] && oCSolar_M1.data[1]<3){
      if(oCTicket.GetOpType() == OP_BUY){
          oCTicket.Close();
      }      
   }
   if(this.mTrend == "down" && oCSolar_M1.data[2]> oCSolar_M1.data[3] && oCSolar_M1.data[1]> oCSolar_M1.data[2] && oCSolar_M1.data[1]>-3){
      if(oCTicket.GetOpType() == OP_SELL){
          oCTicket.Close();
      }      
   }
   
}

//未调用
void CStrategy::CheckOpen()
{
   if(this.mIsReadyBuy){
      if(Ask <= this.mThresholdBuy)
      {
         this.mIsReadyBuy = false;
          oCTicket.Buy(Lots, Tp, Sl, "mtf2");
      }
   }
   if(this.mIsReadySell){
      if(Bid >= this.mThresholdSell)
      {
         this.mIsReadySell = false;
         oCTicket.Sell(Lots, Tp, Sl, "mtf2");
      }
   }
}

void CStrategy::Entry(int type)
{
   if(!oCTicket.isCanOpenOrder() || this.mSignalOpenNum >= 2){
      return ;
   }
   this.mSignalType = oCSignal.GetSignal(this.mTrend, type);
   if(this.mSignalType == "none"){
      return ;
   }
   if(Ask - Bid <2.5*oCTrade.GetPip() ){
      if(this.mSignalType == "buy"){
         //if(Ask-oCMa_M1_fast.data[1]<2.5*oCTrade.GetPip()){
            this.mSignalOpenNum += 1;
            oCTicket.Buy(Lots, Tp, Sl, "mtf1");
         //}
      }
      
      if(this.mSignalType == "sell"){
        // if(oCMa_M1_fast.data[1] -Bid <2.5*oCTrade.GetPip()){
            this.mSignalOpenNum += 1;
            oCTicket.Sell(Lots, Tp, Sl, "mtf");
         //}
      }
   }
   
}