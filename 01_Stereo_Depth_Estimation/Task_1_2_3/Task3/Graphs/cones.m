clc , clear
x = [3 5 7 9]
y = [33.0563 43.8384 57.0942 60.6446]
plot(x,y,'d-r')
axis([0,12,30,65])
title(' Cones - Quality metrics based Block Radii')
xlabel('block radius')
ylabel('badpixelcount')