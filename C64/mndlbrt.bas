1 t=10:printchr$(147):poke53281,0:poke53280,1:poke646,1
2 ti$="000000":fory=-1to1.1step.1:forx=-2to1step.1
3 a=y:b=x:fori=0totstep1:c=b:b=(b*b-a*a)+x:a=2*c*a+y:r=a*a+b*b
4 ifi=tthenprintchr$(113);:nextx
5 ifr>4thenprintchr$(32);:nextx
6 ifr<=4thennext
7 print:nexty:printtime/60;"s"