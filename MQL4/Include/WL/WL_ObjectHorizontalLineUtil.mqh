//+------------------------------------------------------------------+
//|                                  WL_ObjectHorizontalLineUtil.mqh |
//|                                    Copyright 2016, Tsuriganeboz  |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_CreateHLine(string name, color col)
{
   ObjectCreate(name, OBJ_HLINE, 0, 0, 0);
   ObjectSet(name, OBJPROP_COLOR, col);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_MoveHLine(string name, double price)
{
   ObjectMove(name, 0, 0, price);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WL_CreateHLineIfNotFound(string name, color col)
{
   if (!WL_ObjectFind(name))
   {
      WL_CreateHLine(name, col);
   }
   else {}
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WL_FindHorizontalLineStrictly(string objectName)
{
   if (WL_ObjectFind(objectName))
   {
      return (ObjectType(objectName) == OBJ_HLINE);
   }
   else
   {
      return false;
   }
}
