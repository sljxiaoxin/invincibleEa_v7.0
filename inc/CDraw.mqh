//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CDraw
{  

   private:
      static int s_index;
   
   public:
   
      static bool Vline(datetime time, color clr);
};

int CDraw::s_index = 0;

static bool CDraw::Vline(datetime time, color clr)
{
   s_index += 1;
   int chart_ID = 0;
   string name = "Vline_"+s_index;
   int width = 1;
   
   if(!ObjectCreate(chart_ID,name,OBJ_VLINE,0,time,0))
   {
     Print(__FUNCTION__,
         ": failed to create a vertical line! Error code = ",GetLastError());
     return(false);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   return true;
}

