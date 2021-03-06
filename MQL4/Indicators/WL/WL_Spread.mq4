//+------------------------------------------------------------------+
//|                                                    WL_Spread.mq4 |
//|                                    Copyright 2016, Tsuriganeboz  |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
#include <WL/WL_SpreadUtil.mqh>
#include <WL/WL_ChartWindowSize.mqh>
#include <WL/WL_ObjectUtil.mqh>
#include <WL/WL_ObjectHorizontalLineUtil.mqh>
#include <WL/Classes/WLStopLevel.mqh>

#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property version   "1.00"
#property strict
#property indicator_chart_window


//--- プロパティ。
sinput bool SpreadLabelVisibled = true;

sinput bool UseSpreadLine = true;            // Spread水平線を引くかどうか

sinput color BidColor = Red;
sinput color AskColor = Blue;

sinput bool UseStopLevelLine = true;

sinput color UpperStopLevelColor = DarkTurquoise;
sinput color LowerStopLevelColor = Pink;

//---
#define WL_OBJ_NAME_SPREAD "WL_Spread"

//---
#define WL_OBJ_NAME_BID "WL_Bid"
#define WL_OBJ_NAME_ASK "WL_Ask"

#define WL_OBJ_NAME_UPPER "WL_UpperStopLevel"
#define WL_OBJ_NAME_LOWER "WL_LowerStopLevel"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_AdjustLabelValueXPos(string name, int labelWidth, int x)
{
   string labelName = name + "_label";
   string valueName = name + "_value";

   ObjectSet(labelName, OBJPROP_XDISTANCE, x);
   ObjectSet(valueName, OBJPROP_XDISTANCE, x + labelWidth);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_CreateLabelValue(string name, int labelWidth, int x, int y, color col)
{
   string labelName = name + "_label";
   string valueName = name + "_value";
   
   ObjectCreate(labelName, OBJ_LABEL, 0, 0, 0);
   ObjectSet(labelName, OBJPROP_XDISTANCE, x);
   ObjectSet(labelName, OBJPROP_YDISTANCE, y);
   ObjectSet(labelName, OBJPROP_COLOR, col);

   ObjectCreate(valueName, OBJ_LABEL, 0, 0, 0);
   ObjectSet(valueName, OBJPROP_XDISTANCE, x + labelWidth);
   ObjectSet(valueName, OBJPROP_YDISTANCE, y);
   ObjectSet(valueName, OBJPROP_COLOR, col);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_SetTextLabelValue(string name, string label, string value)
{
   string labelName = name + "_label";
   string valueName = name + "_value";

   ObjectSetText(labelName, label, 11);
   ObjectSetText(valueName, value, 11);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_DeleteLabelValue(string name)
{
   string labelName = name + "_label";
   string valueName = name + "_value";

   ObjectDelete(labelName);
   ObjectDelete(valueName);
}


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   if (SpreadLabelVisibled)
   {
      int windowYPos = 27; 
      int labelWidth = 80;
      
      int windowXPos = (WL_GetChartWindowWidth() - 150);
   
      WL_CreateLabelValue(WL_OBJ_NAME_SPREAD,
                           labelWidth, windowXPos, windowYPos, Green);
   }
   else {}
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---  

   WL_DeleteLabelValue(WL_OBJ_NAME_SPREAD);

   // 水平線を削除。
   ObjectDelete(WL_OBJ_NAME_BID);
   ObjectDelete(WL_OBJ_NAME_ASK);
   
   ObjectDelete(WL_OBJ_NAME_UPPER);
   ObjectDelete(WL_OBJ_NAME_LOWER);
   
//---
   //Alert("Deinit !");
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   //Comment("Spread: " + DoubleToStr(WL_CalcSpreadPips(), 2)); 

   double spreadPips = WL_CalcSpreadPips();  
   
   if (SpreadLabelVisibled)
   {         
      int windowXPos = (WL_GetChartWindowWidth() - 150); 
   
      WL_AdjustLabelValueXPos(WL_OBJ_NAME_SPREAD, 80, windowXPos);
      WL_SetTextLabelValue(WL_OBJ_NAME_SPREAD, "Spread", DoubleToStr(spreadPips, 2));
   }
   else {}
   
   if (UseSpreadLine)
   {
      // 売値。
      WL_CreateHLineIfNotFound(WL_OBJ_NAME_BID, BidColor);
      WL_MoveHLine(WL_OBJ_NAME_BID, Bid);
   
      // 買値。
      WL_CreateHLineIfNotFound(WL_OBJ_NAME_ASK, AskColor);
      WL_MoveHLine(WL_OBJ_NAME_ASK, Ask);
      
      if (UseStopLevelLine)
      {
         WLStopLevel stopLevel;

         WL_CreateHLineIfNotFound(WL_OBJ_NAME_UPPER, UpperStopLevelColor);
         WL_MoveHLine(WL_OBJ_NAME_UPPER, stopLevel.UpperStopLevel());

         WL_CreateHLineIfNotFound(WL_OBJ_NAME_LOWER, LowerStopLevelColor);
         WL_MoveHLine(WL_OBJ_NAME_LOWER, stopLevel.LowerStopLevel()); 
      }
      else {}
   }
   else
   {
      // 水平線を削除。
      ObjectDelete(WL_OBJ_NAME_BID);
      ObjectDelete(WL_OBJ_NAME_ASK);

      ObjectDelete(WL_OBJ_NAME_UPPER);
      ObjectDelete(WL_OBJ_NAME_LOWER);
   }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
