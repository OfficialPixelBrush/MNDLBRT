/* Mandelbrot for the Apple ][ */
#include <stdio.h>
#include <stdlib.h>
#include <cc65.h>

/* int mod */
int intMod(int x, int y) {
	return (x - y*(x/y));
}

/* to get absolute number */
long getAbs(long n) {
    if (n < 0) {
        n = (-1) * n;
    }
	return n;
}

int xSize, ySize, t, juliaMode, funcNum, x, y, res, factor;
long xCoord, yCoord, Zoom, multi; 

/* for mapping to the screen */
long mapRange(long a1, long a2, long b1, long b2, long s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}


long funcX(long function, long zx, long zy, long cx) {
	switch ( function ) {
		case 1:
			return ((zx*zx - zy*zy)/factor + cx);
		case 2:
			return (zx*zx - zy*zy)/factor + cx;
		case 3:
			return ((zx*zx*zx - 3*zx*zy*zy)/factor + cx);
		case 4:
			return ((zx*zx*zx*zx - (6*zx*zx - zy*zy)*zy*zy)/factor + cx);
		case 5:
			return ((zx*zx*zx*zx*zx + zx*zy*zy*(5*zy*zy - 10*zx*zx))/factor + cx);
		case 6:
			return (zx*zx*zx*zx*zx*zx - 15*((zx*zx*zx*zx)*(zy*zy)) + 15*((zx*zx)*(zy*zy*zy*zy)) - zy*zy*zy*zy*zy*zy)/factor + cx;
	}
	return 0;
}

long funcY(long function, long zy, long cy, long tmp) {
	switch ( function ) {
		case 1:
			return (getAbs((2*tmp*zy))/factor + cy);
		case 2:
			return 2*tmp*zy/factor + cy;
		case 3:
			return (3*tmp*tmp*zy - zy*zy*zy)/factor + cy;
		case 4:
			return (4*tmp*zy*(tmp*tmp - zy*zy))/factor + cy;
		case 5:
			return (zy*(5*tmp*tmp*(tmp*tmp - 2*zy*zy) + zy*zy*zy*zy))/factor + cy;
		case 6:
			return (6*(tmp*tmp*tmp*tmp*tmp)*zy-20*(tmp*tmp*tmp)*(zy*zy*zy)+6*tmp*(zy*zy*zy*zy*zy))/factor + cy;
	}
	return 0;
}

void drawSetInMode() {
	for (y = 0; y < ySize; y++) {
		for (x = 0; x < xSize; x++) {
			int i;
			long cy,cx,zy,zx;
			cx = mapRange(0, xSize - 1, -2*factor, 2*factor, x);
			cy = mapRange(0, ySize - 1, -2*factor, 2*factor, y);
			zy = cy;
			zx = cx;
			
			for (i = 0; i < t; i++) {
				long tmp = zx;
				zx = funcX(funcNum, zx, zy, cx);
				zy = funcY(funcNum, zy, cy, tmp);

				if ((zx*zx + zy*zy) > (4*(factor*factor))) {
					printf(" ");
					break;
				}
			}
			if (i==t) {
				printf("#");
			}
		}
		printf("\n");
	}
}

int main() {
	factor = 50;
	res = 1;
	x = 0;
	y = 0;
	juliaMode = 0;
	funcNum = 2;
	t = 50;
	xCoord = 0;
	yCoord = -37;
	Zoom = 16;
	xSize = 39;
	ySize = 39;
	/*
	printf("\nxSize:");
	scanf("%d", &xSize);
	
	printf("\nySize: ");
	scanf("%d", &ySize);
	
	printf("\nfuncNum: ");
	scanf("%d", &funcNum);*/
	
	drawSetInMode();
    return 0;
}