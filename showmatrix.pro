!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;

pi=3.1415926;




noofx=long(30);
noofy=long(200);

x = lindgen(noofx);
y= lindgen(noofy);


noofcolors=50;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="test.ps", /color, bits=8;





nooflines=long(noofx*noofy);
noofcolumns=long(1);




tab=dblarr(noofcolumns,nooflines);


matrix=dblarr(noofx,noofy);
tabold=dblarr(noofcolumns,nooflines);


matrixold=dblarr(noofx,noofy);

filenameold='origtraj_matrix.dat';


openr, lold, filenameold, /get_lun;



readf, lold, tabold;





for i=long(0),noofx-1 do begin
  for j=long(0),noofy-1 do begin

    matrixold(i,j)=tabold(0,i*noofy+j);


  endfor
endfor





tab=dblarr(noofcolumns,nooflines);


matrix=dblarr(noofx,noofy);


filename='newtraj_matrix.dat';


openr, l, filename, /get_lun;



readf, l, tab;





for i=long(0),noofx-1 do begin
for j=long(0),noofy-1 do begin

matrix(i,j)=tab(0,i*noofy+j);


endfor
endfor
for i=long(0),noofx-1 do begin
Plot, matrixold(i, *),  PSYM= 4, Title = "original";
endfor

matrixold=matrixold/max(matrixold);

shade_surf, matrixold;
maxalogmatrixold=max(alog10(matrixold));
orderofmagn=5;
levelsforlogmatrixold=lindgen(noofcolors)
levelsforlogmatrixold=levelsforlogmatrixold/(1.0*(noofcolors-1))
levelsforlogmatrixold=maxalogmatrixold-orderofmagn+orderofmagn*levelsforlogmatrixold


contour, alog10(matrixold(*,*)),x,y, levels=levelsforlogmatrixold, c_colors=colors,/fill, /closed,pos=[0.15,0.15,0.85,0.98], xstyle=1, ystyle=1



colorbar, ncolors=noofcolors, maxrange=levelsforlogmatrixold(0), minrange=levelsforlogmatrixold(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'

for i=long(0),noofx-1 do begin
Plot, matrix(i, *),  PSYM= 4, Title = "transformed";
endfor

matrix=matrix/max(matrix);
shade_surf, matrix;
maxalogmatrix=max(alog10(matrix));
orderofmagn=5;
levelsforlogmatrix=lindgen(noofcolors)
levelsforlogmatrix=levelsforlogmatrix/(1.0*(noofcolors-1))
levelsforlogmatrix=maxalogmatrix-orderofmagn+orderofmagn*levelsforlogmatrix


contour, alog10(matrix(*,*)),x,y, levels=levelsforlogmatrix, c_colors=colors,/fill, /closed,pos=[0.15,0.15,0.85,0.98], xstyle=1, ystyle=1



colorbar, ncolors=noofcolors, maxrange=levelsforlogmatrix(0), minrange=levelsforlogmatrix(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'






close, /all;
device, /close;
set_plot, "x";
end
