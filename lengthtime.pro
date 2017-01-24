pi=3.1415926;

noofcolors=30;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/res/HoughlengthtimeendSNR10.ps", /color, bits=8;



noofframe=long(48);
lines= long(4);
deltat = 1;

nooflines = long(noofframe * lines);

noofcolumns=long(6);



tab=dblarr(noofcolumns,nooflines);

tabt=dblarr(noofcolumns,nooflines);

filename= '/Users/varunkapoor/res/Actuallength-movingend.txt';


openr, l, filename, /get_lun;
readf, l, tab;
close, /all;



filenamefake = '/Users/varunkapoor/res/Houghlength-movingendSNR10.txt';


openr, l, filenamefake, /get_lun;
readf, l, tabt;
close, /all;

t=lindgen(noofframe);
MTnumber = lindgen(lines);


tfake=lindgen(noofframe);
MTnumberfake = lindgen(lines);

lengtharray = dblarr(noofframe, lines);

lengtharrayfake = dblarr(noofframe, lines);

deviation = dblarr(noofframe, lines);

for i=long(0),noofframe-1 do begin
  for j=long(0),lines-1 do begin

    lengtharray(i,j)=tab(5,i*lines+j);


  endfor
endfor


for i=long(0),noofframe-1 do begin
for j=long(0),lines-1 do begin

lengtharrayfake(i,j)=tabt(5,i*lines+j);


endfor
endfor



!p.multi = [0,2,3] 

plot,  lengtharray(*, 0), color =1, Title = "Dummy MT:0", xtitle = "t (pixel units)", ytitle = "L (pixel units)", Thick = 2;
  oplot,  lengtharrayfake(*, 1), color =20, Line = 3, Thick = 3;

deviation =  lengtharray(*, 0) - lengtharrayfake(*, 1);
cgHistoplot, deviation, BINSIZE=0.5, /FILL, xtitle = "deltaL (pixel units)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45];

plot,  lengtharray(*, 1), color =1, Title = "Dummy MT:1", xtitle = "t (pixel units)", ytitle = "L (pixel units)", Thick = 2;
oplot,  lengtharrayfake(*, 0), color =20, Line = 3, Thick = 3;
deviation =  lengtharray(*, 1) - lengtharrayfake(*, 0);
cgHistoplot, deviation, BINSIZE=0.5, /FILL, xtitle = "deltaL (pixel units)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45];;

plot,  lengtharray(*, 2), color =1, Title = "Dummy MT:2", xtitle = "t (pixel units)", ytitle = "L (pixel units)", Thick = 2;
oplot,  lengtharrayfake(*, 2), color =20, Line = 3, Thick = 3;

deviation =  lengtharray(*, 2) - lengtharrayfake(*, 2);
cgHistoplot, deviation, BINSIZE=0.5, /FILL, xtitle = "deltaL (pixel units)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45];;

plot,  lengtharray(*, 3), color =1, Title = "Dummy MT:3", xtitle = "t (pixel units)", ytitle = "L (pixel units)", Thick = 2;
oplot,  lengtharrayfake(*, 3), color =20, Line = 3, Thick = 3;

deviation =  lengtharray(*, 3) - lengtharrayfake(*, 3);
cgHistoplot, deviation, BINSIZE=0.5, /FILL, xtitle = "deltaL (pixel units)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45];;


;;FOR j = 1, lines -1 DO OPLOT,   lengtharray(*, j), color = 1
;;FOR j = 0, lines -1 DO OPLOT,   lengtharrayfake(*, j), color = 20, Line = 1

probabdens = lengtharray;

levelsforprobabdens=lindgen(noofcolors)
levelsforprobabdens=levelsforprobabdens/(1.0*(noofcolors-1))
levelsforprobabdens=min(probabdens)+(max(probabdens)-min(probabdens))*levelsforprobabdens




;;CONTOUR,(probabdens(*,*)),levels=levelsforprobabdens, c_colors=colors, /fill, /closed,ytitle='Dummy Line number',xtitle='t (pixel units)',pos=[0.15,0.15,0.85,0.98],yrange=[0,lines],xrange=[0,noofframe]


;;colorbar, ncolors=noofcolors, minrange=min(probabdens),maxrange=max(probabdens), position=[0.95,0.15,0.98,0.98],  /vertical, format='(D8.2)'


probabdensfake = lengtharrayfake;

levelsforprobabdensfake=lindgen(noofcolors)
levelsforprobabdensfake=levelsforprobabdensfake/(1.0*(noofcolors-1))
levelsforprobabdensfake=min(probabdensfake)+(max(probabdensfake)-min(probabdensfake))*levelsforprobabdensfake




;;CONTOUR,(probabdensfake(*,*)),levels=levelsforprobabdensfake, c_colors=colors, /fill, /closed,ytitle='Dummy Line number',xtitle='t (pixel units)',pos=[0.15,0.15,0.85,0.98],yrange=[0,lines],xrange=[0,noofframe]


;;colorbar, ncolors=noofcolors, minrange=min(probabdens),maxrange=max(probabdens), position=[0.95,0.15,0.98,0.98],  /vertical, format='(D8.2)'





device, /close;



set_plot, "x";
end
