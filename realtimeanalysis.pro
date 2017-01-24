pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/res/data001.ps", /color, bits=8;


;;Enter the number of frames here
noofframe=long(48);
;;Enter the number of MT here, to get that count the number of MT in frame 1 from the txt file
lines= long(4);
deltat = 1;

nooflines = long(noofframe * lines);

noofcolumns=long(6);



tab=dblarr(noofcolumns,nooflines);

tabt=dblarr(noofcolumns,nooflines);

filename= '/Users/varunkapoor/res/HNActuallength-movingend.txt';


openr, l, filename, /get_lun;
readf, l, tab;
close, /all;

t=lindgen(noofframe);
MTnumber = lindgen(lines);
lengtharray = dblarr(noofframe, lines);



for i=long(0),noofframe-1 do begin
  for j=long(0),lines-1 do begin

    lengtharray(i,j)=tab(5,i*lines+j);


  endfor
endfor


for j=long(0),lines-1 do begin

  plot,  lengtharray(*, j), color =1, Title = "MT", xtitle = "t (pixel units)", ytitle = "L (pixel units)";

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
