1 t = 10
2 print chr$(147)
3 poke 53281,0
4 poke 53280,1
5 poke 646,1
6 ti$="000000"
7 for y=-1 to 1.1 step .1
8 for x=-2 to 1 step .1
9 a=y:b=x
10 for i = 0 to t step 1
11 c=b:b=(b*b-a*a)+x
12 a=2*c*a+y:r=a*a+b*b
13 if i=t then print chr$(113);: next x
14 if r>4 then print chr$(32);: next x
15 if r<=4 then next
16 print"":next y
17 print time/60;"s"
18 end