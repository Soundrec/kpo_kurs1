#pragma once
#include <math.h>
#include <iostream>

// Экспорт Функций
#define DLLEXPORT extern "C" __declspec(dllexport)

// Типы данных
#define uchar unsigned char 

// Выделение Глобальной памяти
#define AllocMEM_1D(size,type)	   (type*)GlobalAlloc(0, size*sizeof(type))
#define AllocMEM_1DP(size,type)	  (type**)GlobalAlloc(0, size*sizeof(type*))
#define AllocMEM_2DP(size,type)  (type***)GlobalAlloc(0, size*sizeof(type**)) 



// Простые интерфейсные функции
DLLEXPORT const char* PluginFunctions();
DLLEXPORT const char* PluginDescriptions(char* str);
DLLEXPORT const char* PluginLName(char* str);
DLLEXPORT const char* PluginCFG(char* str);
DLLEXPORT const char* GetPluginType(char* str); // для определения типа например для встраивание в интерфейс


/// Работа с картинками
// Чтение изображений 32bit
void ReadRGB(uchar* InIMGp, uchar& r, uchar& g, uchar& b)
{
	b = *(InIMGp);
	g = *(InIMGp + 1);
	r = *(InIMGp + 2);
}

// Запись серого в RGB блок
void  SetVtoRGB(uchar* InIMGp, const double val)
{
	uchar v = min(abs(val), 255);

	*(InIMGp) = v;
	*(InIMGp + 1) = v;
	*(InIMGp + 2) = v;
}

void SetRGBdtoRGB(uchar* InIMGp, double* vals)
{
	*(InIMGp) = min(abs(vals[0]), 255);
	*(InIMGp + 1) = min(abs(vals[1]), 255);
	*(InIMGp + 2) = min(abs(vals[2]), 255);
}

/// Кодирование в модель YUV (JPEG)
void RGBToYUV(unsigned char R, unsigned char G, unsigned char B, double& Y, double& U, double& V)   //Rec 601-1
{
	Y = R * 0.299 + G * 0.587 + B * 0.114;
	U = R * (-0.168) + G * -0.332 + B * 0.500;
	V = R * 0.500 + G * -0.419 + B * (-0.0813);
}

/// Обратное преобразование
unsigned char set255(double inVal)
{
	int tmp = int(inVal);
	if (inVal < 0) tmp = 0;
	if (inVal > 255) tmp = 255;
	return tmp;
}

void YUVToRGB(double Y, double U, double V, unsigned char& R, unsigned char& G, unsigned char& B)
{
	R = set255(Y + (1.4075 * V));
	G = set255(Y - (0.3455 * U) - (0.7169 * V));
	B = set255(Y + (1.7790 * U));
}

