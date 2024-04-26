1 printchr$(147):poke53281,0:poke53280,1:poke646,1
2 ti$="000000":fory=-1to1.1step.1:forx=-2to1step.1:a=y:b=x
3 fori=0to8step1:c=b:b=(b*b-a*a)+x:a=2*c*a+y:r=a*a+b*b:ifi=8thenprint"@";:nextx
4 ifr>4thenprint".";:nextx
5 ifr<=4thennext
6 print:nexty:printtime/60;"seconds"