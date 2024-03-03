/* Mandelbrot for the Apple ][ */
#include <stdio.h>
#include <stdlib.h>
#include <cc65.h>
#include <conio.h>
#include <ctype.h>
#include <modload.h>
#include <tgi.h>

#ifndef DYN_DRV
#  define DYN_DRV       0
#endif

int xSize = 30;
int ySize = 30;
int x,y;
int Zoom = 10;
int xCoord = 0;
int yCoord = 0;
int t = 25;
int i;
int tmp;
int factor = 30;

int mapRange(int a1, int a2,int b1, int b2,int s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}	

int funcX(int function, int zx, int zy, int cx) {
	switch ( function ) {
		case 1:
			return (zx*zx - zy*zy)/factor + cx;
		case 2:
			return (zx*zx - zy*zy)/factor + cx;
		case 3:
			return (zx*zx*zx - 3*zx*zy*zy)/factor + cx;
		case 4:
			return (zx*zx*zx*zx - (6*zx*zx - zy*zy)*zy*zy)/factor + cx;
		case 5:
			return (zx*zx*zx*zx*zx + zx*zy*zy*(5*zy*zy - 10*zx*zx))/factor + cx;
	}
	return 0;
}


int getAbs(int n) {
    if (n < 0) {
        n = (-1) * n;
    }
	return n;
}

int funcY(int function, int zy, int cy, int tmp) {
	switch ( function ) {
		case 1:
			return (getAbs(2*tmp*zy))/factor  + cy;
		case 2:
			return (2*tmp*zy)/factor  + cy;
		case 3:
			return (3*tmp*tmp*zy - zy*zy*zy)/factor  + cy;
		case 4:
			return (4*tmp*zy*(tmp*tmp - zy*zy))/factor  + cy;
		case 5:
			return (zy*(5*tmp*tmp*(tmp*tmp - 2*zy*zy) + zy*zy*zy*zy))/factor  + cy;
	}
	return 0;
}

int main () {
    static const unsigned char Palette[2] = { TGI_COLOR_WHITE, TGI_COLOR_BLACK };
    unsigned char Border;

	#if DYN_DRV
		/* Warn the user that the tgi driver is needed */
		DoWarning ();

		/* Load and initialize the driver */
		tgi_load_driver (tgi_stddrv);
	#else
		/* Install the driver */
		tgi_install (tgi_static_stddrv);
	#endif

		tgi_init ();

		/* Get stuff from the driver */
		xSize = tgi_getmaxx ();
		ySize = tgi_getmaxy ();
    Border = bordercolor (COLOR_BLACK);
	
	tgi_setpalette (Palette);
    tgi_setcolor (TGI_COLOR_BLACK);
    tgi_clear ();
	
	for (y=0; y <= ySize; y++) {
		for (x=0; x <= xSize; x++) { 
			int cx,cy,zx,zy;
			/* values get mapped to screen */
			cx = mapRange(0, xSize-1, (xCoord-30/Zoom)*factor, (xCoord+30/Zoom)*factor, x);
			cy = mapRange(0, ySize-1, (yCoord+20/Zoom)*factor, (yCoord-20/Zoom)*factor, y);
			zx = cx;
			zy = cy;
			
			for (i=0; i < t; i++) {
				/* mandelbrot math */
				tmp = zx;
				zx = funcX(2, zx, zy, cx);
				zy = funcY(2, zy, cy, tmp);
				
				/* if it's outside of the set */
				if ((zx*zx + zy*zy) > 4*factor*factor) {
					tgi_setcolor (TGI_COLOR_WHITE);
					tgi_setpixel(x,y);
					//printf("#");
					break;
				}
			}
			if (i == t) {
				tgi_setcolor (TGI_COLOR_BLACK);
				tgi_setpixel(x,y);
				//printf(" ");
			
			}
		}
		/* new line */
		//printf("\n");
	}
	while (1) {
		
	}
	
    (void) bordercolor (Border);
	return 0;
}