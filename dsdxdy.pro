pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/res/HoughdsdxdySNR10.ps", /color, bits=8;



noofframe=long(48);
lines= long(4);
deltat = 1;
psfx = 1.65;
psfy = 1.47;

psfs = min(psfx,psfy);

nooflines = long(noofframe * lines);

noofcolumns=long(5);




tab=dblarr(noofcolumns,nooflines);

tabt=dblarr(noofcolumns,nooflines);

filename= '/Users/varunkapoor/res/Houghdsparams-movingstartSNR10.txt';


openr, l, filename, /get_lun;
readf, l, tab;
close, /all;




filenamefake = '/Users/varunkapoor/res/Houghdsparams-movingendSNR10.txt';


openr, l, filenamefake, /get_lun;
readf, l, tabt;
close, /all;

t=lindgen(noofframe);
MTnumber = lindgen(lines);


tfake=lindgen(noofframe);
MTnumberfake = lindgen(lines);

dsarraystart = dblarr(noofframe, lines);
dxarraystart = dblarr(noofframe, lines);
dyarraystart = dblarr(noofframe, lines);
numgaussstart = dblarr(noofframe, lines);

dsarrayend = dblarr(noofframe, lines);
dxarrayend = dblarr(noofframe, lines);
dyarrayend = dblarr(noofframe, lines);
numgaussend = dblarr(noofframe, lines);

deviation = dblarr(noofframe, lines);

for i=long(0),noofframe-1 do begin
for j=long(0),lines-1 do begin

dsarraystart(i,j)=tab(1,i*lines+j);

dxarraystart(i,j)=tab(2,i*lines+j);

dyarraystart(i,j)=tab(3,i*lines+j);

numgaussstart(i,j) = tab(4,i*lines+j);

endfor
endfor


for i=long(0),noofframe-1 do begin
for j=long(0),lines-1 do begin

dsarrayend(i,j)=tabt(1,i*lines+j);

dxarrayend(i,j)=tabt(2,i*lines+j);

dyarrayend(i,j)=tabt(3,i*lines+j);

numgaussend(i,j)=tabt(4,i*lines+j);

endfor
endfor



!p.multi = [0,2,3]

for j=long(0),lines-1 do begin

plot,  dsarraystart(*, j) / psfs, color =1,Title =  "SNR 10, Start of MT number:" + STRTRIM(j, 2), xtitle = "t (pixel units)", ytitle = "ds/sigmas (pixelunits)";

plot,  numgaussstart(*, j) , color =1,Title =  "Start of MT number:" + STRTRIM(j, 2), xtitle = "t (pixel units)", ytitle = "Num Gausisans = sigmas / ds", yrange = [1,5];

plot,  dsarrayend(*, j) / psfs, color =1, Title = "SNR 10, End of MT number:" + STRTRIM(j, 2), xtitle = "t (pixel units)", ytitle = "ds/sigmas (pixelunits)";

plot,  numgaussend(*, j) , color =1,Title =  "End of MT number:" + STRTRIM(j, 2), xtitle = "t (pixel units)", ytitle = "No. of Gaussians for mask fits", yrange = [1,5];
endfor






device, /close;



set_plot, "x";
end

