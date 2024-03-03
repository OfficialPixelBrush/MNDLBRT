/* C MNDLBRT */
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <math.h>
#include <time.h>

/* define global variables */
unsigned int mode, juliaMode, funcNum, t, maxPower;
unsigned long xSize, ySize, x, y;
double setCx, setCy, xCoord, yCoord, Zoom, res; 
FILE * fp;
char str[128];
char * token;

/* rgb color */
struct deadColor {
	int r,g,b;
};

struct deadColor deadColorArray[2000];

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

/* load color array */
void assignDeadColorArray() {
	int i;

	fp = fopen("color.txt", "r");
	for (i = 0; i<2000; i++) {
		fscanf (fp, "%d", &deadColorArray[i].r); /* R */
		fscanf (fp, "%d", &deadColorArray[i].g); /* G */
		fscanf (fp, "%d", &deadColorArray[i].b); /* B */
		/*printf("%d %d %d\n", deadColorArray[i].r, deadColorArray[i].g,deadColorArray[i].b);*/
	}
	fclose(fp);
}

struct deadColor ultraFractalColor(int n, int maxPower, struct complexNumber z) {
	struct deadColor result;
	if (n < t) {
		float i = (float) (n + 1.0 - log(log(complexAbsSqr(z)) / log(1024.0)) / log((double)maxPower));
        int index = (int) (200*sqrt(i)) % 2000;
		result.r = deadColorArray[index].r;
		result.g = deadColorArray[index].g;
		result.b = deadColorArray[index].b;
	} else {
		result.r = 0;
		result.g = 0;
		result.b = 0;
	}
	return result;
}

/* map coordinates to screen */
double mapRange(double a1, double a2, double b1, double b2, double s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

/* draw a pixel based on the render mode */
void drawBasedOnMode(int i, int x, int y, int blank, struct complexNumber z) {
	struct deadColor finalCol;
	finalCol = ultraFractalColor((int)i, (int)maxPower, z);
	fprintf(fp, "%c%c%c", finalCol.b, finalCol.g, finalCol.r);
}

/* This does the actual math */
void drawSetInMode() {
	float aspect;
	int i;
	char header[18] = {66, 77, 54, 00, 12, 00, 00, 00, 00, 00, 54, 00, 00, 00, 40, 00, 00, 00};
	//size1 = {00, 00, 00, 16}
	//size2 = {00, 00, 00, 16}
	char header2[28] = {01, 00, 24, 00, 00, 00, 00, 00, 00, 00, 12, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00};
	int yStart = 0;
	fp = fopen("mndlbrt.bmp", "wb");
	for (i = 0; i < sizeof(header); i++) {
		fprintf(fp, "%c", header[i]);
	}
	
	// it goes left to right!!
	// xSize
	fprintf(fp, "%c", xSize);
	fprintf(fp, "%c", xSize/255);
	fprintf(fp, "%c", xSize/65535);
	fprintf(fp, "%c", xSize/16777215);
	
	fprintf(fp, "%c", ySize);
	fprintf(fp, "%c", ySize/255);
	fprintf(fp, "%c", ySize/65535);
	fprintf(fp, "%c", ySize/16777215);
	
	for (i = 0; i < sizeof(header2); i++) {
		fprintf(fp, "%c", header2[i]);
	}
	
	if (xSize > ySize) {
		aspect = ((float)xSize)/((float)ySize);
	} else {
		aspect = ((float)ySize)/((float)xSize);
	}
	
	for (y = 0; y < ySize; y++) {
		float percent = ((float)y/(float)ySize)*100.0;
		printf("%.2f%c\n", percent, 37);
		for (x = 0; x < xSize; x++) {
			int i;
			struct complexNumber c,z;
			c.real = mapRange(0, xSize, xCoord-(20*aspect)/Zoom, xCoord+(20*aspect)/Zoom, x);
			c.imaginary = mapRange(0, ySize, yCoord-20/Zoom, yCoord+20/Zoom, y);
			z = c;
			
			for (i = 0; i < t; i++) {
				/*z = complexDivide(complexAdd(complexPower(complexDivide(complexPower(z,2),c),4),c),c);
				z = complexPower(z,10);*/
				
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

int main() {	
	clock_t begin, end;
	maxPower = 1;
	xSize = 0;
	ySize = 0;
	t = 25;
	xCoord = 0.0f;
	yCoord = 0.0f;
	Zoom = 10.0f;
	
	start:
	printf("\nMandelbrot Set (in C for CMD)\n");
	printf("Written by PixelBrushArt (2021)\n");
	printf("v8.0\n");
	assignDeadColorArray();
	
	/* Get location */
	printf("\nxCoord: ");
	scanf("%lf", &xCoord);
	printf("\nyCoord: ");
	scanf("%lf", &yCoord);
	printf("\nZoom: ");
	scanf("%lf", &Zoom);
	printf("\nIterations: ");
	scanf("%d", &t);
	printf("\nWidth: ");
	scanf("%d", &xSize);
	printf("\nHeight: ");
	scanf("%d", &ySize);
	
	/* Calculating */
	begin = clock();
	drawSetInMode();
	end = clock();
	printf("The render took %.02lf seconds\n", (double)(end - begin) / CLK_TCK);
	fclose(fp);
	return 0;
}