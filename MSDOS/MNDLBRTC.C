#include <conio.h>
#include <dos.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <mem.h>

#define COLOR_OFFSET 56/*56*/
#define NUM_COLORS 10/*10*/
int startcolor = 4;/*4;*/
#define SET_MODE 0x00
#define VIDEO_INT 0x10
#define VGA_256_COLOR_MODE 0x13
#define TEXT_MODE 0x03
#define SCREEN_HEIGHT 200
#define SCREEN_WIDTH 320
#define PALETTE_INDEX 0x3C8
#define PALETTE_DATA 0x3C9

#define LEN 256
#define SETPIX(x,y,c) *(VGA+(x)+(y)*SCREEN_WIDTH)=c
#define GETPIX(x,y) *(VGA+(x)+(y)*SCREEN_WIDTH)
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define MIN(x,y) ((x) < (y) ? (x) : (y))

typedef unsigned char byte;

byte far *VGA=(byte far *)0xA0000000L;
byte *pal;

double getAbs(double n) {
    if (n < 0) {
        n = (-1) * n;
    }
	return n;
}

void set_mode(byte mode) {
  union REGS regs;
  regs.h.ah = SET_MODE;
  regs.h.al = mode;
  int86( VIDEO_INT, &regs, &regs );
}

void set_palette(byte *palette) {
	int i;
	outp( PALETTE_INDEX, 0 );
	for (i = 0; i < NUM_COLORS*3; i++) {
		outp( PALETTE_DATA, palette[i]);
	}
}

int intMod(int x, int y) {
	return (x - y*(x/y));
}

double mapRange(double a1, double a2, double b1, double b2, double s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

double smoothColor(int i, int x, int y) {	
	int out = intMod(i/4, NUM_COLORS)+COLOR_OFFSET+startcolor;
	int iModFour = i%4;
	
	/* Change dithering based on iteration */
	switch (iModFour) {
		case 0:
			/* 1 */
			if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
				out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
			}
			return out;
		case 1:
			/* 2 */
			if (y%2) {
				if (x%2) {
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				} else {
					++out;
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				}
			} else {
				if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
					out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
				}
			}
			
			return out;
		case 2:
			/* 3 */
			if (y%2) {
				if (x%2) {
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				} else {
					++out;
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				}
			} else {
				if (x%2) {
					++out;
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				} else {
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+COLOR_OFFSET+startcolor;
					}
				}
			}
			
			return out;
		case 3:
			/* 4 */
			if (y%2) {
				if (x%2) {
					++out;
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+startcolor;
					}
				} else {
					if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
						out = out-NUM_COLORS+startcolor;
					}
				}
			} else {
					++out;
				if (out > NUM_COLORS+COLOR_OFFSET+startcolor) {
					out = out-NUM_COLORS+startcolor;
				}
			}
			
			if (out < COLOR_OFFSET+startcolor) {
				out = out-1;
			}
			return out;
	}
	return out;
}

double funcX(int function, double zx, double zy, double cx) {
	switch ( function ) {
		case 1:
			return (zx*zx - zy*zy + cx);
		case 2:
			return (zx*zx - zy*zy + cx);
		case 3:
			return (zx*zx*zx - 3*zx*zy*zy + cx);
		case 4:
			return (zx*zx*zx*zx - (6*zx*zx - zy*zy)*zy*zy + cx);
		case 5:
			return (zx*zx*zx*zx*zx + zx*zy*zy*(5*zy*zy - 10*zx*zx) + cx);
		case 6:
			return (zx*zx*zx*zx*zx*zx - 15*((zx*zx*zx*zx)*(zy*zy)) + 15*((zx*zx)*(zy*zy*zy*zy)) - zy*zy*zy*zy*zy*zy) + cx;
		
	}
	return 0;
}

double funcY(int function, double zy, double cy, double tmp) {
	switch ( function ) {
		case 1:
			return (getAbs((double)(2*tmp*zy)) + cy);
		case 2:
			return 2*tmp*zy + cy;
		case 3:
			return 3*tmp*tmp*zy - zy*zy*zy + cy;
		case 4:
			return 4*tmp*zy*(tmp*tmp - zy*zy) + cy;
		case 5:
			return zy*(5*tmp*tmp*(tmp*tmp - 2*zy*zy) + zy*zy*zy*zy) + cy;
		case 6:
			return 6*(tmp*tmp*tmp*tmp*tmp)*zy-20*(tmp*tmp*tmp)*(zy*zy*zy)+6*tmp*(zy*zy*zy*zy*zy) + cy;
	}
	return 0;
}

void clrscr() {
	int x,y;
	for (y = 0; y < SCREEN_HEIGHT; ++y) {
		for (x = 0; x < SCREEN_WIDTH; ++x) {
			SETPIX(x,y,0);
		}
	}
}

/* get rgb */
byte *getRGBpalette() {
	byte *pal;
	int i;
	pal = malloc( NUM_COLORS * 3); /* RGB */
	
	for (i = 0; i < NUM_COLORS; i++) {
		pal[i*3 + 0] = MIN(63, i/4); /* RED */
		pal[i*3 + 1] = MIN(63, i/4); /* GREEN */
		pal[i*3 + 2] = MIN(63, i/4); /* BLUE */
	}
	
	for (i = 0; i < NUM_COLORS; i++) {
		pal[i*3 + 2] = i*4; /* BLUE */
		pal[i*3 + 1] = i; /* RED */
	}
	
	return pal;
}

unsigned int mode, fullScr, soundToggle, t, juliaMode, funcNum, stepsTaken, stepLimit;
unsigned long xSize, ySize, x, y;
double setCx, setCy, xCoord, yCoord, Zoom, res; 
FILE * fp;
char str[128];
char * token;

struct deadColor {
	int r,g,b;
};

struct deadColor deadColorArray[2000];

void drawBasedOnMode(int i, int x, int y, int blank) {
	switch(mode) {
		case 1:
			break;
		case 2:
			if (y >= ySize-1) {
				printf("\n");
			}
			if (blank < 1) {
				printf(" ");
			} else {
				printf("*");
			}
			break;
		case 3:
			break;
		case 4:
			if (blank > 0) {
				SETPIX(x,y, smoothColor(i,x,y));
			} else {
				SETPIX(x,y, 0);
			}
			break;
		case 5:
			if (blank > 0) {
				SETPIX(x,y, smoothColor(i,x,y));
			} else {
				SETPIX(x,y, 0);
			}
			break;
		case 6:
			/*fprintf(fp, "%c%c%c", i/4, i/2, i);*/
			fprintf(fp, "%c%c%c", deadColorArray[i].r, deadColorArray[i].g,deadColorArray[i].b);
			break;
	}
}

int assignDeadColorArray() {
	int i;

	fp = fopen("c:\\color.txt", "r");
	for (i = 0; i<2000; i++) {
		fscanf (fp, "%d", &deadColorArray[i].r); /* R */
		fscanf (fp, "%d", &deadColorArray[i].g); /* G */
		fscanf (fp, "%d", &deadColorArray[i].b); /* B */
		printf("%d %d %d\n", deadColorArray[i].r, deadColorArray[i].g,deadColorArray[i].b);
	}
	fclose(fp);
}

/* This does the actual math */
void drawSetInMode() {
	int yStart = 0;
	switch(mode) {
		case 2:
			set_mode( TEXT_MODE ); 
			break;
		case 4:
			set_mode( VGA_256_COLOR_MODE );
			pal = getRGBpalette();
			set_palette(pal);
			xSize = SCREEN_WIDTH;
			ySize = SCREEN_HEIGHT;
			break;
		case 5:
			set_mode( VGA_256_COLOR_MODE );
			pal = getRGBpalette();
			set_palette(pal);
			if (res < 1) { res = 1; }
			if ( t < 25) { t = 25; }
			xSize = SCREEN_WIDTH/res;
			ySize = SCREEN_HEIGHT/res;
			yStart = 25;
			break;
		case 6:
			assignDeadColorArray();
			fp = fopen("c:\\mndlbrt.ppm", "wb");
			fprintf(fp, "P6\n%d %d", xSize, ySize);
			break;
	}
	
	for (y = 0; y < ySize; y++) {
		if (mode == 6) {
			printf("%d\n", y);
		}
		for (x = 0; x < xSize; x++) {
			unsigned int i;
			double cy,cx,zy,zx;
				
			/* Julia sets */
			if (juliaMode) {
				cx = setCx;
				cy = setCy;
				
				/* don't draw what doesn't need to be drawn */
				if (res != 1) {
					zy = yCoord + 20 / Zoom - y * 40 / (Zoom * ySize);
				} else {
					zy = yCoord + 20 / Zoom - y * 40 / (Zoom * ySize);
				}
				zx = xCoord - 20 / Zoom + x * 40 / (Zoom * xSize);
			} else {
				cx = xCoord - 20 / Zoom + x * 40 / (Zoom * xSize);
				
				/* don't draw what doesn't need to be drawn */
				if (res != 1) {
					cy = yCoord + 20 / Zoom - y * 40 / (Zoom * ySize);
				} else {
					cy = yCoord + 20 / Zoom - y * 40 / (Zoom * ySize);
				}
				zy = cy;
				zx = cx;
			}
			
			for (i = 0; i < t; i++) {
				double tmp = zx;
				zx = funcX(funcNum, zx, zy, cx);
				zy = funcY(funcNum, zy, cy, tmp);
				
				/* Regular Escape */
				if ((zx*zx + zy*zy) > 4) {
					drawBasedOnMode(i,(int)x,(int)(y+yStart), 1);
					if ( soundToggle == 1 ) {
						sound(i);
					}
					break;
				}
			}
				
			if (i==t) {
				drawBasedOnMode(i,(int)x,(int)(y+yStart), 0);
			}
		}
	}
}
	
/* Main Program */
int main()
{	
	/*unsigned char *pixels = malloc(192000);
	unsigned char *pptr = pixels;*/
	int readI;
	clock_t begin, end;
	double time_spent;
	char filename[8];
	char dest[255] = "C:\\";
	char kc = 0;
	
	res = 4;
	mode = 2;
	xSize = 50;
	ySize = 25;
	juliaMode = 0;
	funcNum = 2;
	fullScr = 0;
	soundToggle = 0;
	t = 25;
	xCoord = 0.0f;
	yCoord = 0.0f;
	Zoom = 10.0f;
	
	start:
	printf("\nMandelbrot Set (in C for MS-DOS)\n");
	printf("Written by PixelBrushArt (2021)\n");
	printf("v7.2\n");

	printf("\n- Render Mode -");
	printf("\nExit (0), Text (1), Screen (2), T&S (3), Dithered VGA (4), Exploration (5), Bitmap (6): ");
	scanf("%d", &mode);
	if (mode == 0) {
		goto end;
	}
	
	printf("\n- Function -");
	printf("\nBurning Ship (1), pow2 (2), pow3 (3), pow4 (4), pow5 (5), pow (6): ");
	scanf("%d", &funcNum);
	printf("\nSet C values (0/1) ");
	scanf("%d", &juliaMode);
	
	/* Julia mode */
	if (juliaMode) {
		printf("\nc = _ + []i \n");
		scanf("%lf", &setCx);
		printf("\n c = [] + _i \n");
		scanf("%lf", &setCy);
	}
	
	/* Get location */
	if ((mode < 5) || mode > 5) {
		printf("\nxCoord: ");
		scanf("%lf", &xCoord);
		printf("\nyCoord: ");
		scanf("%lf", &yCoord);
		printf("\nZoom: ");
		scanf("%lf", &Zoom);
		printf("\nIterations: ");
		scanf("%d", &t);
	}

	if ((mode > 0) && (mode < 4) || (mode == 6)) {
		if ((mode == 1) || (mode == 3)) {
			fp = fopen("c:\\mndlbrt.txt", "w");
		}
		
		printf("\nWidth: ");
		scanf("%d", &xSize);
		printf("\nHeight: ");
		scanf("%d", &ySize);
	}
	
	/* Calculating */
	draw:
		begin = clock();
		drawSetInMode();
	fclose(fp);
	nosound();
	end = clock();
	time_spent = (double)(end - begin) / CLK_TCK;
	switch( mode ) {
		case 2:
			printf("\n%.2lfs - Press Escape to Exit", time_spent);
			break;
		case 4:
			printf("\n%.2lfs - Press Escape to Exit", time_spent);
			break;
		case 5:
			printf("\nx: %8.24g",xCoord);
			printf("\ny: %8.24g",yCoord);
			printf("\ni: %d",(int)t);
			break;
		case 6:
			printf("\n%.2lfs - Press Escape to Exit", time_spent);
			break;
	}
	end = 0;
	time_spent = 0;
	
	/* Keyboard input */
	while( kc != 0x1b ) {
		if (kbhit()) {kc = getch();
			/* Regular Chars */
			switch( kc ) {
				case 0x1b:
					goto start;
				/* rendering modes */
				case 0x09: /* render as VGA, Tab */
					if (mode == 5 ) {
						mode = 4;
					} else {
						mode = 5;
					}
					break;
				case 0x74: /* increase resolution, T */
					res /= 2;
					break;
				case 0x67: /* decrease resolution, G */
					res *= 2;
					break;
				case 0x77: /* up, W */
					yCoord = yCoord+2/Zoom;
					break;
				case 0x73: /* down, S */
					yCoord = yCoord-2/Zoom;
					break;
				case 0x61: /* left, A */
					xCoord = xCoord-2/Zoom;
					break;
				case 0x64: /* right, D */
					xCoord = xCoord+2/Zoom;
					break;
				case 0x65: /* zoom out, Q */
					Zoom = Zoom*1.25;
					break;
				case 0x71: /* zoom in, E */
					Zoom = Zoom/1.25;
					break;
				case 0x72: /* increase iterations, R */
					t = t+25;
					break;
				case 0x66: /* decrease iterations, F */
					t = t-25;
					if (t < 1) {
						t = 25;
					}
					break;
				case 0x31: /* render mode */
					mode = 6;
					printf("\nIterations: ");
					scanf("%d", &t);
					printf("\nWidth: ");
					scanf("%d", &xSize);
					printf("\nHeight: ");
					scanf("%d", &ySize);
					break;
				case 0x32: /* explore mode */
					mode = 5;
					break;
			}
			
			goto draw;
		}
	}
	
	end:
	set_mode( TEXT_MODE );
	return 0;
}