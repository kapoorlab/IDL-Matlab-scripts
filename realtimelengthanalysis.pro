pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/res/OnlyGrowingMTend.ps", /color, bits=8;


;;Enter the number of frames here
totalframe = long(182);
skipframestart = long(40);
noofframe=totalframe - skipframestart;
;;Enter the number of MT here, to get that count the number of MT in frame 1 from the txt file
lines= long(1);
deltat = 1;
nframeaverage = 2;
nframeaveragelong = 5;


nooflines = long(noofframe * lines);

noofcolumns=long(7);



tab=dblarr(noofcolumns,nooflines);

tabt=dblarr(noofcolumns,nooflines);

filename= '/Users/varunkapoor/MSERLine/OnlyGrowingMT-end.txt';


openr, l, filename, /get_lun;
skip_lun, l , 1, /LINES;
readf, l, tab;
close, /all;

t=intarr(noofframe);
MTnumber = lindgen(lines);
lengtharray = dblarr(noofframe, lines);
averagelengtharray = dblarr(noofframe, lines);
averagelonglengtharray = dblarr(noofframe, lines);

;; Length is in column number 6

for i=long(0),noofframe-1 do begin
for j=long(0),lines-1 do begin

lengtharray(i,j)=tab(6,i*lines+j);
t(i) = tab(0, i*lines + j);

endfor
endfor

for i=long(nframeaverage),noofframe - nframeaverage -1 do begin
for j = 0, nframeaverage - 1 do begin

averagelengtharray(i - nframeaverage,*) += lengtharray(i - nframeaverage + j,*) / nframeaverage;


endfor
endfor

for i=long(nframeaveragelong),noofframe - nframeaveragelong -1 do begin
for j = 0, nframeaveragelong - 1 do begin

averagelonglengtharray(i - nframeaveragelong,*) += lengtharray(i - nframeaveragelong + j,*) / nframeaveragelong;

endfor
endfor

for j=long(0),lines-1 do begin

plot, t,  lengtharray(*, j), color =1, Title = "MT", xtitle = "t (pixel units)", ytitle = "L (pixel units)";

endfor

for j=long(0),lines-1 do begin

plot, t,  averagelengtharray(*, j), color =1, Title = "MT (averaged over 2 frames)", xtitle = "t (pixel units)", ytitle = "L (pixel units)";

endfor

for j=long(0),lines-1 do begin

  plot, t,  averagelonglengtharray(*, j), color =1, Title = "MT (averaged over 5 frames)", xtitle = "t (pixel units)", ytitle = "L (pixel units)";

endfor


probabdens = lengtharray;

levelsforprobabdens=lindgen(noofcolors)
levelsforprobabdens=levelsforprobabdens/(1.0*(noofcolors-1))
levelsforprobabdens=min(probabdens)+(max(probabdens)-min(probabdens))*levelsforprobabdens




;;CONTOUR,(probabdens(*,*)),levels=levelsforprobabdens, c_colors=colors, /fill, /closed,ytitle='Dummy Line number',xtitle='t (pixel units)',pos=[0.15,0.15,0.85,0.98],yrange=[0,lines],xrange=[0,noofframe]

;;colorbar, ncolors=noofcolors, minrange=min(probabdens),maxrange=max(probabdens), position=[0.95,0.15,0.98,0.98],  /vertical, format='(D8.2)'





device, /close;



set_plot, "x";
end
