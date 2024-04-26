10 t = 10
20 print chr$(147)
30 poke 53281,0
40 poke 53280,1
50 poke 646,1
60 for y = -1 to 1.1 step 0.1
70 for x = -2 to 1 step 0.1
80 i = 0
90 cx = x
100 cy = y
110 zy = cy
120 zx = cx
130 for i = 0 to t step 1
140 tmp = zx
150 zx = (zx*zx-zy*zy)+cx
160 zy = 2*tmp*zy+cy
170 r = (zx*zx+zy*zy)
180 if i = t then print chr$(113);: next x
190 if r > 4 then print chr$(32);: next x
200 if r <= 4 then next i
210 print ""
220 next y
230 end