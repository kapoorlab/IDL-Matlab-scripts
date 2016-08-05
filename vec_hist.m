load /Users/varunkapoor/Hough/src/main/resources/SigmaXall488.dat

Vec_histX = SigmaXall488(:,1);

figure;
hx = histogram(Vec_histX);

load /Users/varunkapoor/Hough/src/main/resources/SigmaYall488.dat

Vec_histY = SigmaYall488(:,1);

figure;
hy = histogram(Vec_histY);

colormat = Vec_histX;
figure;
gscatter(Vec_histX, Vec_histY);
hold on;


R = corrcoef(Vec_histX,Vec_histY);


load /Users/varunkapoor/Hough/src/main/resources/Intensityall488.dat

Vec_histampl = Intensityall488(:,1);

figure;
hampl = histogram(Vec_histampl);


