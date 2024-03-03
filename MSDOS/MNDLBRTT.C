#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <string.h>
#include <time.h>
#include <mem.h>
#include <math.h>

#define COLOR_OFFSET 56/*56*/
#define NUM_COLORS 256/*10*/
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

/* map coordinates to screen */
double mapRange(double a1, double a2, double b1, double b2, double s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

/* define global variables */
unsigned int mode, format, juliaMode, funcNum, t, maxPower, scaleX, scaleY;
unsigned long xSize, ySize, x, y;
double cReal, cImaginary, xCoord, yCoord, Zoom, res; 
FILE * fp;
char str[128];
char * token;

/* rgb color */
struct deadColor {
	int r,g,b;
};

struct deadColor deadColorArray[2000];

/* set graphics mode */
void set_mode(byte mode) {
  union REGS regs;
  regs.h.ah = SET_MODE;
  regs.h.al = mode;
  int86( VIDEO_INT, &regs, &regs );
}

/* set color palette */
void set_palette(byte *palette) {
	int i;
	outp( PALETTE_INDEX, 0 );
	for (i = 0; i < NUM_COLORS*3; i++) {
		outp( PALETTE_DATA, palette[i]);
	}
}

/* complex number */
struct complexNumber {
	double real,imaginary;
};

/* complex number addition */
struct complexNumber complexAdd(struct complexNumber x, struct complexNumber y) {
	struct complexNumber result;
	result.real = x.real + y.real;
	result.imaginary = x.imaginary + y.imaginary;
	return result;
}

/* complex number subtraction */
struct complexNumber complexSubtract(struct complexNumber x, struct complexNumber y) {
	struct complexNumber result;
	result.real = x.real - y.real;
	result.imaginary = x.imaginary - y.imaginary;
	return result;
}

/* complex number multiplication */
struct complexNumber complexMultiply(struct complexNumber x, struct complexNumber y) {
	struct complexNumber result;
	result.real = x.real * y.real - x.imaginary * y.imaginary;
	result.imaginary =  x.real * y.imaginary + x.imaginary * y.real;
	return result;
}

/* complex number power */
struct complexNumber complexPower(struct complexNumber x, int power) {
	struct complexNumber result;
	int i;
	result = x;
	for (i = 1; i < power; i++) {
		result = complexMultiply(x,result);
	}
	
	/* automate power */
	if (power > maxPower) { maxPower = power; }
	
	return result;
}

/* complex number division */
struct complexNumber complexDivide(struct complexNumber x, struct complexNumber y) {
	struct complexNumber result;
	double denominator = y.real * y.real + y.imaginary * y.imaginary;
	result.real = ((x.real * y.real) + (x.imaginary * y.imaginary)) / denominator;
	result.imaginary =  ((x.imaginary * y.real) - (x.real * y.imaginary)) / denominator;
	return result;
}

/* complex number division */
double complexAbsSqr(struct complexNumber x) {
	return x.real * x.real + x.imaginary * x.imaginary;
}

/* dithering algorithm */
double smoothColor(int i, int x, int y) {	
	int out = ((i/4)%NUM_COLORS)+COLOR_OFFSET+startcolor;
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

/* load color array */
void assignDeadColorArray() {
	int i;

	fp = fopen("c:\\color.txt", "r");
	for (i = 0; i<2000; i++) {
		fscanf (fp, "%d", &deadColorArray[i].r); /* R */
		fscanf (fp, "%d", &deadColorArray[i].g); /* G */
		fscanf (fp, "%d", &deadColorArray[i].b); /* B */
	}
	fclose(fp);
}

struct deadColor ultraFractalColor(int n, int index, float i) {
	struct deadColor result;
	int maxVal = MAX(deadColorArray[index].r, MAX(deadColorArray[index].g, deadColorArray[index].b));
	
	if (n < t) {
		result.r = MAX(deadColorArray[index].r * (1 - 255 * 2 / (i * maxVal)), 0);
		result.g = MAX(deadColorArray[index].g * (1 - 255 * 2 / (i * maxVal)), 0);
		result.b = MAX(deadColorArray[index].b * (1 - 255 * 2 / (i * maxVal)), 0);
	} else {
		result.r = 0;
		result.g = 0;
		result.b = 0;
	}
	return result;
}

float ultraFractalColorI(int n, int maxPower, struct complexNumber z) {
	return (float)(n + 1.0 - log(log(complexAbsSqr(z)) / log(1024.0)) / log((double)maxPower));
}

int ultraFractalColorIndex(int n, float i) {
	int index = 0;
	if (n < t) {
		index = (int) (5*sqrt(i*i + 1500*i)) % 2000;
	}
	return index;
}

/* get colors */
byte *getColorpalette() {
	byte *pal;
	int i;
	pal = malloc( NUM_COLORS * 3); /* RGB */
	
	for (i = 0; i < NUM_COLORS; i++) {
		pal[i*3 + 0] = deadColorArray[i*8].r/4; /* RED */
		pal[i*3 + 1] = deadColorArray[i*8].g/4; /* GREEN */
		pal[i*3 + 2] = deadColorArray[i*8].b/4; /* BLUE */
	}
	
	return pal;
}

/* draw a pixel based on the render mode */
void drawBasedOnMode(int i, int x, int y, int blank, struct complexNumber z) {
	struct deadColor finalCol;
	float finalColI;
	int finalColIndex;
	switch(mode) {
		case 1:
			if (x > xSize) {
				printf("\n");
			}
			if (blank > 0) {
				printf("*");
			} else {
				printf(" ");
			}
			break;
		case 2:
			finalColI = ultraFractalColorI((int)i, (int)maxPower, z);
			finalColIndex = ultraFractalColorIndex((int)i, finalColI);
			finalCol = ultraFractalColor((int)i, finalColIndex, finalColI);
			SETPIX(x/scaleX, y/scaleY, (finalColIndex/8));
			break;
		case 3:
			finalColI = ultraFractalColorI((int)i, (int)maxPower, z);
			finalColIndex = ultraFractalColorIndex((int)i, finalColI);
			finalCol = ultraFractalColor((int)i, finalColIndex, finalColI);
			SETPIX(x/scaleX, y/scaleY, (finalColIndex/8));
			break;
		case 4:
			finalColI = ultraFractalColorI((int)i, (int)maxPower, z);
			finalColIndex = ultraFractalColorIndex((int)i, finalColI);
			finalCol = ultraFractalColor((int)i, finalColIndex, finalColI);
			switch(format) {
				case 0:
					fprintf(fp, "%c%c%c", finalCol.r, finalCol.g, finalCol.b);
					break;
				case 1:
					fprintf(fp, "%c%c%c", finalCol.b, finalCol.g, finalCol.r);
					break;
			}
			if (blank > 0) {
				//SETPIX(x, y, ultraFractalColor((int)i, (int)maxPower, z));
				SETPIX(x/scaleX, y/scaleY, (finalColIndex/8));
			}
			break;
	}
}

/* This does the actual math */
void drawSetInMode() {
	int i;
	char header[15] = {66, 77, 36, 54, 00, 00, 00, 00, 00, 00, 54, 00, 00, 00, 40};
	//size1 = {00, 00, 00, 16}
	//size2 = {00, 00, 00, 16}
	char header2[31] = {00, 00, 00, 01, 00, 24, 00, 00, 00, 00, 00, 00, 03, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00};

	int yStart = 0;
	byte *pal;
	scaleX = 1;
	scaleY = 1;
	
	switch(mode) {
		case 1:
			set_mode( TEXT_MODE ); 
			break;
		case 2:
			xSize = SCREEN_WIDTH;
			ySize = SCREEN_HEIGHT;
			set_mode(VGA_256_COLOR_MODE);
			pal = getColorpalette();
			set_palette(pal);
			break;
		case 3:
			if (res < 1) { res = 1; }
			if ( t < 25) { t = 25; }
			xSize = SCREEN_WIDTH/res;
			ySize = SCREEN_HEIGHT/res;
			yStart = 33;
			set_mode(VGA_256_COLOR_MODE);
			pal = getColorpalette();
			set_palette(pal);
			break;
		case 4:
			scaleX = xSize/SCREEN_WIDTH;
			scaleY = ySize/SCREEN_HEIGHT;
			
			if (scaleX == 0) { scaleX++; }
			if (scaleY == 0) { scaleY++; }
			
			printf("\n- Image Format -");
			printf("\nPPM (0), BMP (1) ");
			scanf("%d", &format);
			set_mode(VGA_256_COLOR_MODE);
			pal = getColorpalette();
			set_palette(pal);
			
			switch (format) {
				case 0:
					fp = fopen("c:\\mndlbrt.ppm", "wb");
					fprintf(fp, "P6\n%d %d\n%d\n", (int)xSize, (int)ySize, 255);
					break;
				
				case 1:
					fp = fopen("c:\\mndlbrt.bmp", "wb");
					for (i = 0; i < 15; i++) {
						fprintf(fp, "%c", header[i]);
					}
					
					for (i = 0; i < 3; i++) {
						fprintf(fp, "%c", 0);
					}
					
					fprintf(fp, "%c", (int)xSize);
					
					for (i = 0; i < 3; i++) {
						fprintf(fp, "%c", 0);
					}
					
					fprintf(fp, "%c", (int)ySize);
					
					for (i = 0; i < 31; i++) {
						fprintf(fp, "%c", header2[i]);
					}
					break;
			}
			break;
	}
	
	for (y = 0; y < ySize; y++) {
		/*if (mode == 4) {
			float percent = ((float)y/(float)ySize)*100.0;
			printf("%.2f%c\n", percent, 37);
		}*/
		for (x = 0; x < xSize; x++) {
			int i;
			struct complexNumber c,z;
			if (juliaMode) {
				c.real = cReal;
				c.imaginary = cImaginary;
				z.real = mapRange(0, xSize, xCoord-20/Zoom, xCoord+20/Zoom, x);
				z.imaginary = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
			} else {
				c.real = mapRange(0, xSize, xCoord-20/Zoom, xCoord+20/Zoom, x);
				c.imaginary = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
				z = c;
			}
			
			for (i = 0; i < t; i++) {
				//z = complexDivide(complexAdd(complexPower(complexDivide(complexPower(z,2),c),4),c),c);
				//z = complexPower(z,10);
				// Cool spiral 
				//z = complexAdd(complexPower(z,3),complexDivide(c,z));
				
				// Mandelbrot Set
				z = complexAdd(complexPower(z,2),c);
				
				/* Regular Escape */
				if ((z.real*z.real + z.imaginary*z.imaginary) > 4) {
					drawBasedOnMode(i,(int)x,(int)(y+yStart), 1, z);
					break;
				}
			}
			if (i==t) {
				drawBasedOnMode(i,(int)x,(int)(y+yStart), 0, z);
			}				
		}
	}
}

/* map color to palette */
int mapRGBtoPalette(int colR, int colG, int colB) {
	return 64*floor(colR/64)+16*floor(colG/64)+floor(colB/16);
}

int main() {	
	int readI;
	clock_t begin, end;
	double time_spent;
	char filename[8];
	char dest[255] = "C:\\";
	char kc = 0;
	maxPower = 1;
	
	res = 4;
	mode = 3;
	xSize = SCREEN_WIDTH;
	ySize = SCREEN_HEIGHT;
	juliaMode = 0;
	t = 2000;
	xCoord = -0.138421f;
	yCoord = 0.165036f;
	Zoom = 100000.0f;
	
	printf("Loading color file...");
	assignDeadColorArray();
	printf("Loaded.");
	
	start:
	set_mode(TEXT_MODE);
	printf("\nMandelbrot Set (in C for MS-DOS)\n");
	printf("Written by PixelBrushArt (2021)\n");
	printf("v8.1\n");

	printf("\n- Render Mode -");
	printf("\nExit (0), Text (1), Full VGA (2), Explore VGA (3), Bitmap (4): ");
	scanf("%d", &mode);
	if (mode == 0) {
		goto end;
	}
	
	// to-do - get function
	
	printf("\nSet C values (0/1) ");
	scanf("%d", &juliaMode);
	
	// Julia mode 
	if (juliaMode) {
		printf("\nReal of c: ");
		scanf("%lf", &cReal);
		printf("\nImaginary of c: ");
		scanf("%lf", &cImaginary);
	}
	
	// Get location 
	printf("\nxCoord: ");
	scanf("%lf", &xCoord);
	xCoord = -0.138421;
	printf("\nyCoord: ");
	scanf("%lf", &yCoord);
	printf("\nZoom: ");
	scanf("%lf", &Zoom);
	printf("\nIterations: ");
	scanf("%d", &t);

	if ((mode == 1) || (mode == 4)) {
		if (mode == 1) {
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
	end = clock();
	time_spent = (double)(end - begin) / CLK_TCK;
	switch( mode ) {
		case 1:
			printf("\n%.2lfs - Press Escape to Exit", time_spent);
			break;
		case 2:
			printf("\n%.2lfs - Press Escape to Exit", time_spent);
			break;
		case 3:
			printf("\ni: %d",(int)t);
			printf("\nx: %8.24g",xCoord);
			printf("\ny: %8.24g",yCoord);
			printf("\nZ: %.02f",Zoom);
			break;
		case 4:
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
				case 0x31: /* text */
					mode = 1;
					printf("\nIterations: ");
					scanf("%d", &t);
					printf("\nWidth: ");
					scanf("%d", &xSize);
					printf("\nHeight: ");
					scanf("%d", &ySize);
					break;
				case 0x32: /* vga */
					mode = 2;
					break;
				case 0x33: /* explore */
					mode = 3;
					break;
				case 0x34: /* bitmap */
					mode = 4;
					printf("\nIterations: ");
					scanf("%d", &t);
					printf("\nWidth: ");
					scanf("%d", &xSize);
					printf("\nHeight: ");
					scanf("%d", &ySize);
					break;
			}
			
			goto draw;
		}
	}
	
	end:
	set_mode( TEXT_MODE );
	return 0;
}