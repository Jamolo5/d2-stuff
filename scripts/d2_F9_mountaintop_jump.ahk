#SingleInstance, Force
SendMode Input
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
; Done using look sensitivity 6, aim smoothing off
F9::
	DllCall("mouse_event", uint, 1, int, 4550, int, 000) ; Turn around 180 degrees
	DllCall("mouse_event", uint, 1, int, 000, int, 10000) ; Look down
	PreciseSleep(100)
	Send {Space} ; Jump
	PreciseSleep(30)
	Loop 6 {
		Send {Click} ; Shoot mountaintop
		PreciseSleep(10)
	}
	PreciseSleep(100)
	DllCall("mouse_event", uint, 1, int, 4550, int, 000) ; Turn around 180 degrees
	DllCall("mouse_event", uint, 1, int, 000, int, -2200) ; Look up again
	
PreciseSleep(s)
{
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}