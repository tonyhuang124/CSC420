w = [1.1;-6.0];
x = [5 10];
b = 2.0;
y = 1;

h = 1/(1+exp(-(dot(w,x)+b)));

answer = -y*log(h);

print(answer);