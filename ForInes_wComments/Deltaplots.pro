pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/Documents/2017022Video1/DeltadeltaLMT1.ps", /color, bits=8;


;;Enter the number of frames here
totalframe = long(250);
skipframestartdeltad= long(0);
skipframestartdeltadeltaL= long(0);
noofframedeltad = totalframe - skipframestartdeltad;
noofframedeltadeltaL = totalframe - skipframestartdeltadeltaL;


;;Enter the number of MT here, to get that count the number of MT in frame 1 from the txt file

deltat = 1;



nooflinesdeltad = long(noofframedeltad );
nooflinesdeltadeltaL = long(noofframedeltadeltaL );
noofcolumns=long(2);



tabdeltad=dblarr(noofcolumns,nooflinesdeltad);

tabdeltadeltaL=dblarr(noofcolumns,nooflinesdeltadeltaL);

filenamedeltad = '/Users/varunkapoor/Documents/2017022Video1/MT1porcineVKR0.58MTtracker-deltad.txt';

filenamedeltadeltaL = '/Users/varunkapoor/Documents/2017022Video1/MT1porcineVKR0.58MTtracker-deltadeltal.txt';

openr, l, filenamedeltad, /get_lun;
skip_lun, l , 1, /LINES;
readf, l, tabdeltad;
close, /all;

openr, l2, filenamedeltadeltaL, /get_lun;
skip_lun, l2 , 1, /LINES;
readf, l2, tabdeltadeltaL;
close, /all;

tdeltad=intarr(noofframedeltad);
tdeltadeltaL=intarr(noofframedeltadeltal);



lengtharraydeltad = dblarr(noofframedeltad);
deltalengtharraydeltad = dblarr(noofframedeltad);
lengtharraydeltadeltaL = dblarr(noofframedeltadeltaL);
deltalengtharraydeltadeltaL = dblarr(noofframedeltadeltaL);
;; Length is in column number 1

for i=long(0),noofframedeltad-1 do begin


  lengtharraydeltad(i)=tabdeltad(1,i);
  tdeltad(i) = tabdeltad(0, i);


endfor

for i=long(0),noofframedeltadeltaL-1 do begin


  lengtharraydeltadeltaL(i)=tabdeltadeltaL(1,i) ;
  tdeltadeltaL(i) = tabdeltadeltaL(0, i);


endfor


;;plot,  lengtharraydeltad, color =1, Title = "Lengths", xtitle = "t (Framenumbers)", ytitle = "Delta D (pixel units)";






;;plot, lengtharraydeltadeltaL, color =1, Title = "deltaL", xtitle = "t (Framenumber)", ytitle = "deltaL (pixel units)";






;;cgHistoplot, lengtharraydeltad, BINSIZE=1, /FILL, xtitle = "DeltaD (pixels)", ytitle = "Counts (deltad)", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3;

cgHistoplot, lengtharraydeltadeltaL, BINSIZE=1, /FILL, xtitle = "DeltaDeltaL (pixels)", ytitle = "Counts(deltadeltaL)", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3;



;;probabdens = lengtharray;

;;levelsforprobabdens=lindgen(noofcolors)
;;levelsforprobabdens=levelsforprobabdens/(1.0*(noofcolors-1))
;;levelsforprobabdens=min(probabdens)+(max(probabdens)-min(probabdens))*levelsforprobabdens




;;CONTOUR,(probabdens(*,*)),levels=levelsforprobabdens, c_colors=colors, /fill, /closed,ytitle='Dumdeltad Line number',xtitle='t (pixel units)',pos=[0.15,0.15,0.85,0.98],yrange=[0,lines],xrange=[0,noofframe]

;;colorbar, ncolors=noofcolors, minrange=min(probabdens),maxrange=max(probabdens), position=[0.95,0.15,0.98,0.98],  /vertical, format='(D8.2)'





device, /close;



set_plot, "x";
end
