clc , clear
x = [3 5 7 9]
y = [20.1027 20.3101 22.9313 24.3252]
plot(x,y,'d-r')
axis([0,12,19,25])
title(' Book - Quality metrics based Block Radii')
xlabel('block radius')
ylabel('badpixelcount')