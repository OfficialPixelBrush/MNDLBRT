#include <conio.h>
#include <dos.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <mem.h>

#define COLOR_OFFSET 56
#define NUM_COLORS 16
int startcolor = 4;
#define SET_MODE 0x00
#define VIDEO_INT 0x10
#define VGA_256_COLOR_MODE 0x13
#define TEXT_MODE 0x03
#define SCREEN_HEIGHT 200
#define SCREEN_WIDTH 320

#define LEN 256
#define SETPIX(x,y,c) *(VGA+(x)+(y)*SCREEN_WIDTH)=c
#define GETPIX(x,y) *(VGA+(x)+(y)*SCREEN_WIDTH)
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define MIN(x,y) ((x) < (y) ? (x) : (y))

typedef unsigned char byte;

byte far *VGA=(byte far *)0xA0000000L;

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

int intMod(int x, int y) {
	return (x - y*(x/y));
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

double mapRange(double a1, double a2, double b1, double b2, double s) {
	return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
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

#define cycleCheckLength 10

/* Main Program */
int main()
{	
	double cylceCheck[cycleCheckLength][2];
	char kc = 0;
	char s[255];
	byte *pal;
	double res = 4;
	
	char filename[8];
	char dest[255] = "C:\\";
	int c;
	
	char str[512];
	char * token;

	FILE * fp;

	double halfScreenWidth;
	double halfScreenHeight;

	double xCoord = 0;
	double yCoord = 0;
	double Zoom = 10;
	double x = 0;
	double y = 0;
	double p = 10;
	double xSize = 100;
	double ySize = 100;
	double t = 25;
	int mode = 0;
	int fullScr = 0;
	clock_t begin;
	clock_t end;
	double time_spent;
	int soundToggle = 0;
	int readI = 0;
	double setCx = 0;
	double setCy = 0;
	int juliaX, juliaY;
	int juliaMode;
	
	int funcNum = 1;
	reboot:

	system("cls");
	set_mode( TEXT_MODE );
	system("cls");
	printf("Mandelbrot Set (in C for MS-DOS)\n");
	printf("Written by PixelBrushArt (2021)\n");
	printf("v6.1\n");
	
	printf("\n- Render Mode -");
	printf("\nExit (0), Text (1), Screen (2), T&S (3), Dithered VGA (4), Exploration (5): ");
	scanf("%d", &mode);
	if (mode == 0) {
		return 0;
	}
	
	printf("\n- Function -");
	printf("\nBurning Ship (1), pow2 (2), pow3 (3), pow4 (4), pow5 (5): ");
	scanf("%d", &funcNum);
	printf("\nSet C values (0/1) ");
	scanf("%d", &juliaMode);
	
	if (juliaMode) {
		printf("\nc = _ + []i \n");
		scanf("%lf", &setCx);
		printf("\n c = [] + _i \n");
		scanf("%lf", &setCy);
	}
	
	if (mode == 5) {
		printf("\nFullscreen (0/1): ");
		scanf("%d", &fullScr);
	}
	
	if ((mode == 4) || (mode == 5)) {
		printf("\nSound (0/1): ");
		scanf("%d", &soundToggle);
		set_mode( VGA_256_COLOR_MODE );
	}

	if ((mode < 5)) {
		printf("\nxCoord: ");
		scanf("%lf", &xCoord);
		printf("\nyCoord: ");
		scanf("%lf", &yCoord);
		printf("\nZoom: ");
		scanf("%lf", &Zoom);
	}

	if ((mode > 0) && (mode < 4)) {
		if ((mode == 1) || (mode == 3)) {
			fp = fopen("c:\\mndlbrt.txt", "w");
		}
		printf("\nWidth: ");
		scanf("%lf", &xSize);
		printf("\nHeight: ");
		scanf("%lf", &ySize);
	}
	
	vga:
	if (mode != 5) {
		printf("\nIterations: ");
		scanf("%lf", &t);
	}

	/* Store in Text Mode */
	if (mode == 1) {
		for (y = 0; y < ySize; y++) {
			for (x = 0; x < xSize; x++) {
				int i;
				double cy,cx,zy,zx;
				
				/* Julia sets */
				if (juliaMode) {
					cx = setCx;
					cy = setCy;
					
					/* don't draw what doesn't need to be drawn */
					zy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zx = mapRange(0, xSize, xCoord-32/Zoom, xCoord+32/Zoom, x);
				} else {
					cx = mapRange(0, xSize, xCoord-32/Zoom, xCoord+32/Zoom, x);
					cy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zy = cy;
					zx = cx;
				}
				for (i = 0; i < t; i++) {
					double tmp = zx;
					zx = funcX(funcNum, zx, zy, cx);
					zy = funcY(funcNum, zy, cy, tmp);

					if ((zx*zx + zy*zy) > 4) {
						fprintf(fp, " ");
						break;
					}
				}
				if (i == t) {
					fprintf(fp, "#");
				}
			}
			clrscr();
			fprintf(fp, "\n");
			p = (y/ySize)*100;
			printf("%f%\n",p);
		}
		fclose(fp);
		return 0;
	}

	/* Screen Render Mode */
	if (mode == 2) {
		for (y = 0; y < ySize; y++) {
			double x = 0;
			for (x = 0; x < xSize; x++) {
				int i;
				double cy,cx,zy,zx;
				
				/* Julia sets */
				if (juliaMode) {
					cx = setCx;
					cy = setCy;
					zx = mapRange(0, xSize, xCoord-20/Zoom, xCoord+20/Zoom, x);
					zy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
				} else {
					cx = mapRange(0, xSize, xCoord-20/Zoom, xCoord+20/Zoom, x);
					cy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zy = cy;
					zx = cx;
				}
				for (i = 0; i < t; i++) {
					double tmp = zx;
					zx = funcX(funcNum, zx, zy, cx);
					zy = funcY(funcNum, zy, cy, tmp);

					if ((zx*zx + zy*zy) > 4) {
						printf(" ");
						break;
					}
				}
				if (i == t) {
					printf("#");
				}
			}
			printf("\n");
		}
		printf("Press Escape to Exit\n");
		while (1) {
			if (getch() == 0x1b) {
				goto reboot;
			}
		}
	}

	/* Text and Screen */
	if (mode == 3) {
		for (y = 0; y < ySize; y++) {
			for (x = 0; x < xSize; x++) {
				int i;
				double cy,cx,zy,zx;
				
				/* Julia sets */
				if (juliaMode) {
					cx = setCx;
					cy = setCy;
					
					/* don't draw what doesn't need to be drawn */
					zy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zx = mapRange(0, xSize, xCoord-32/Zoom, xCoord+32/Zoom, x);
				} else {
					cx = mapRange(0, xSize, xCoord-32/Zoom, xCoord+32/Zoom, x);
					cy = mapRange(0, ySize, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zy = cy;
					zx = cx;
				}
				
				for (i = 0; i < t; i++) {
					double tmp = zx;
					zx = funcX(funcNum, zx, zy, cx);
					zy = funcY(funcNum, zy, cy, tmp);

					if ((zx*zx + zy*zy) > 4) {
						printf(" ");
						fprintf(fp, " ");
						break;
					}
				}
				if (i == t) {
					fprintf(fp, "#");
					printf("#");
				}
			}
			printf("\n");
			fprintf(fp, "\n");
		}
		fclose(fp);
		printf("Press Escape to Exit\n");
		while (1) {
			if (getch() == 0x1b) {
				goto reboot;
			}
		}
	}

	/* Dithered VGA Full Render */
	if (mode == 4) {
		set_mode( VGA_256_COLOR_MODE );
		begin = clock();
		for (y = 0; y < SCREEN_HEIGHT; y++) {
			for (x = 0; x < SCREEN_WIDTH; x++) {
				int i = 0;
				double cy,cx,zy,zx;
				
				/* Julia sets */
				if (juliaMode) {
					cx = setCx;
					cy = setCy;
					
					/* don't draw what doesn't need to be drawn */
					zy = mapRange(0, SCREEN_HEIGHT, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zx = mapRange(0, SCREEN_WIDTH, xCoord-32/Zoom, xCoord+32/Zoom, x);
				} else {
					cx = mapRange(0, SCREEN_WIDTH, xCoord-32/Zoom, xCoord+32/Zoom, x);
					cy = mapRange(0, SCREEN_HEIGHT, yCoord+20/Zoom, yCoord-20/Zoom, y);
					zy = cy;
					zx = cx;
				}
				
				for (i = 0; i < t; ++i) {
					double tmp = zx;
						zx = funcX(funcNum, zx, zy, cx);
						zy = funcY(funcNum, zy, cy, tmp);

					if ((zx*zx + zy*zy) > 4) {
						SETPIX((int)x,(int)y, (int)smoothColor(i, (int)x, (int)y));
						if ( soundToggle == 1 ) {
							sound(i+1);
						}
						break;
					} else {
						SETPIX((int)x,(int)y, (int)smoothColor(i, (int)x, (int)y));
					}
				}
			}
		}
		nosound();
		end = clock();
		time_spent = (double)(end - begin) / CLK_TCK;
		printf("%.2lfs - Press Escape to Exit\n", time_spent);
		while (1) {
			if (getch() == 0x1b) {
				goto reboot;
			}
			
			if (getch() == 0x09) {
				goto explore;
			}
		}
	}

	/* Exploration mode */
	if (mode == 5) {
		explore:
		t = 25;
		if (fullScr > 0) {
			goto drawFull;
		} else {
			goto draw;
		}
		
		draw:
		set_mode( VGA_256_COLOR_MODE );
		
		if (res < 1) { res = 1; }
		
		halfScreenWidth = SCREEN_WIDTH/res;
		halfScreenHeight = SCREEN_HEIGHT/res;
		
		if (res == 1) { halfScreenHeight = SCREEN_HEIGHT-24; }
		
		for (y = 24; y < halfScreenHeight+24; y++) {
			for (x = 0; x < SCREEN_WIDTH; x++) {
				
				/* if y is greater than 24 */
				if (x < halfScreenWidth) {
					int i;
					double cy,cx,zy,zx;
					
					/* Julia sets */
					if (juliaMode) {
						cx = setCx;
						cy = setCy;
						
						/* don't draw what doesn't need to be drawn */
						if (res != 1) {
							zy = yCoord + 20 / Zoom - (y-24) * 40 / (Zoom * halfScreenHeight);
						} else {
							zy = yCoord + 20 / Zoom - y * 40 / (Zoom * halfScreenHeight);
						}
						zx = xCoord - 32 / Zoom + x * 64 / (Zoom * halfScreenWidth);
					} else {
						cx = xCoord - 32 / Zoom + x * 64 / (Zoom * halfScreenWidth);
						
						/* don't draw what doesn't need to be drawn */
						if (res != 1) {
							cy = yCoord + 20 / Zoom - (y-24) * 40 / (Zoom * halfScreenHeight);
						} else {
							cy = yCoord + 20 / Zoom - y * 40 / (Zoom * halfScreenHeight);
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
							SETPIX((int)x,(int)y, (int)smoothColor(i, (int)x, (int)y));
							if ( soundToggle == 1 ) {
								sound(i);
							}
							break;
						} else {
							SETPIX((int)x,(int)y,0);
						}
					}
				}
			}
		}
		goto end;
		
		/* Fullscreen drawing */
		drawFull:
		set_mode( VGA_256_COLOR_MODE );
		if (res < 1) { res = 1; }
		
		halfScreenWidth = (SCREEN_WIDTH/res);
		halfScreenHeight = (SCREEN_HEIGHT/res);
		
		if (res == 1) { halfScreenHeight = SCREEN_HEIGHT; }
		
		for (y = 24; y < SCREEN_HEIGHT; y = y+res) {
			for (x = 0; x < SCREEN_WIDTH; x = x+res) {
				
				/* if y is greater than 24 */
				if (x < SCREEN_WIDTH) {
					int i;
					double cy,cx,zy,zx;
					
					/* Julia sets */
					if (juliaMode) {
						cx = setCx;
						cy = setCy;
						
						/* don't draw what doesn't need to be drawn */
						if (res != 1) {
							zy = yCoord + 20 / Zoom - (y-24) * 40 / (Zoom * halfScreenHeight);
						} else {
							zy = yCoord + 20 / Zoom - y * 40 / (Zoom * halfScreenHeight);
						}
						zx = xCoord - 32 / Zoom + x * 64 / (Zoom * halfScreenWidth);
					} else {
						cx = xCoord - 32 / Zoom + x * 64 / (Zoom * halfScreenWidth);
						
						/* don't draw what doesn't need to be drawn */
						if (res != 1) {
							cy = yCoord + 20 / Zoom - (y-24) * 40 / (Zoom * halfScreenHeight);
						} else {
							cy = yCoord + 20 / Zoom - y * 40 / (Zoom * halfScreenHeight);
						}
						zy = cy;
						zx = cx;
					}

					for (i = 0; i < t; i++) {
						double tmp = zx;
						zx = funcX(funcNum, zx, zy, cx);
						zy = funcY(funcNum, zy, cy, tmp);

						if ((zx*zx + zy*zy) > 4) {
							int scalingX, scalingY;
							for (scalingY = 0; scalingY <= res; scalingY++) {
								for (scalingX = 0; scalingX <= res; scalingX++) {
									if (((x+scalingX) <= SCREEN_WIDTH) || ((y+scalingY) <= SCREEN_HEIGHT)) {
										SETPIX((int)(x+scalingX),(int)(y+scalingY), (int)smoothColor(i, (int)(x+scalingX), (int)(y+scalingY)));
										if ( soundToggle == 1 ) {
											sound(i);
										}
									}
								}
							}
							break;
						} else {
							SETPIX((int)x,(int)y,0);
						}
					}
				}
			}
		}
		goto end;
		
		end:
		nosound();		
		printf("\nx: %8.24g",xCoord);
		printf("\ny: %8.24g",yCoord);
		printf("\ni: %d",(int)t);

		while( kc != 0x1b ) {
			if (kbhit()) {
				kc = getch();
				/* Regular Chars */
				switch( kc ) {
					case 0x74: /* increase resolution, T */
						res = res/2;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x67: /* decrease resolution, G */
						res = res*2;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x77: /* up, W */
						yCoord = yCoord+2/Zoom;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x73: /* down, S */
						yCoord = yCoord-2/Zoom;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x61: /* left, A */
						xCoord = xCoord-2/Zoom;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x64: /* right, D */
						xCoord = xCoord+2/Zoom;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x65: /* zoom out, Q */
						Zoom = Zoom*1.25;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x71: /* zoom in, E */
						Zoom = Zoom/1.25;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x72: /* increase iterations, R */
						t = t+25;
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x66: /* decrease iterations, F */
						t = t-25;
						if (t < 1) {
							t = 25;
						}
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x6d: /* save location, M */
						printf("\rSave as: %s", dest);
						scanf("%s", filename);
						strcat(dest, filename);
						strcat(dest, ".txt");
						
						fp = fopen(dest, "w");
						
						fprintf(fp, "%d", (int)t);
						fprintf(fp, "iter_X=");
						fprintf(fp, "%.24g", xCoord);
						fprintf(fp, "_Y=");
						fprintf(fp, "%.24g", yCoord);
						fprintf(fp, "_Zoom=");
						fprintf(fp, "%.2lf", Zoom);
						
						fclose(fp);
						strcpy(dest,"C:\\");
						memset(filename, 0, 8);
						
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					case 0x6e: /* load location, N */
						clrscr();
						printf("\rLoad: %s", dest);
						scanf("%s", filename);
						strcat(dest, filename);
						strcat(dest, ".txt");
						
						printf("\n%s", dest);
						fp = fopen(dest, "r");
						clrscr();
						printf("\n");
						if (fp != NULL) {
							while (fgets(str, 512, fp) != NULL)
								printf("%s", str);
							fclose(fp);
							
							token = strtok(str, "iter_X_Y=Zoom");
							
							readI = 0;
							
							for (readI = 0; readI < 4; ++readI) {
								switch (readI){
									case 0:
										sscanf(token, "%lf", &t);
										printf( "\n%s", token );
										token = strtok(NULL, "iter_X_Y=Zoom");
									case 1:
										sscanf(token, "%lf", &xCoord);
										printf( "\n%s", token );
										token = strtok(NULL, "iter_X_Y=Zoom");
									case 2:
										sscanf(token, "%lf", &yCoord);
										printf( "\n%s", token );
										token = strtok(NULL, "iter_X_Y=Zoom");
									case 3:
										sscanf(token, "%lf", &Zoom);
										printf( "\n%s", token );
										token = strtok(NULL, "iter_X_Y=Zoom");
								}
							}
						} else {
							printf("\nFailed to find %s!", dest);
							delay(5000);
						}
						
						fclose(fp);
						
						strcpy(dest,"C:\\");
						memset(filename, 0, 8);
						
						if (fullScr > 0) {
							goto drawFull;
						} else {
							goto draw;
						}
					/* rendering modes */
					case 0x09: /* render as VGA, Tab */
						mode = 4;
						goto vga;
				}
			}
		}
	}

	set_mode( TEXT_MODE );
	return 0;
}