!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)
fromenerg=1.0E-5
toenerg=0.3



filename=File_Search("/Users/varunkapoor/Documents/Ines_Fourier/FFT_Varun_Exp3All/*.txt");
Print, filename.length;


set_plot, "ps";
device, filename = "/Users/varunkapoor/Documents/Ines_Fourier/extendedFFT_Exp3.ps", /color, bits=8;

minoutput = 200;




noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)

filecount = 0;
for i=long(0),filename.length-1 do begin



nooflines = FILE_LINES(filename(i));
nignore = 1;
if (nooflines MOD 2 EQ 0) then begin
nignore = 2;
endif

noofoutputs = nooflines - nignore;



filecount = filecount + 1;



endfor

textend = dblarr(1,minoutput);
cwfextend = dblarr(1,minoutput);



finalspecaverage= dblarr(minoutput);

finalspec= dblarr(minoutput, filecount);
alphahat=lindgen(filecount);
j = 0;
for i=long(0),filename.length-1 do begin



nooflines = FILE_LINES(filename(i));
nignore = 1;
if (nooflines MOD 2 EQ 0) then begin
nignore = 2;
endif

noofoutputs = nooflines - nignore;



noofcolumns=long(2)






tab=dblarr(noofcolumns,noofoutputs );



openr, l, filename(i), /get_lun;
skip_lun, l , nignore, /LINES;
readf, l, tab;
close, /all;


t=tab(0,*);

cwf=tab(1,*);

deltat = t(1) - t(0);


for arrayindex= long(0), cwf.length - 1 do begin

if (cwf[arrayindex] LT 0) then begin
cwf[arrayindex] = 0;
endif

endfor

if (noofoutputs GE minoutput) then begin
  
  textend = t;
  cwfextend = cwf;
endif
if (noofoutputs LT minoutput) then begin


for xi=0,noofoutputs - 1  do begin

textend(xi) = t(xi)

endfor

for xi=0,noofoutputs - 1  do begin

cwfextend[xi] = cwf[xi]

endfor

count = 1;
for xi = noofoutputs, minoutput - 1  do begin

textend[xi] = t(noofoutputs - 1) + deltat * count;

count++;
endfor

for xi = noofoutputs, minoutput  - 1 do begin


cwfextend[xi] = cwf(noofoutputs - 1 )

endfor

endif

cwfextend = cwfextend/max(cwfextend)

;;plot, textend, cwfextend, xtitle = 'time (minutes)', ytitle = 'Intensity(a.u. units)'



fftresult=fft(hanning(minoutput)*cwfextend, /double)




fftresultII=fftresult*conj(fftresult)

frequ=lindgen(minoutput)
frequ=frequ-(minoutput)/2

frequ=(2*3.1415926/(textend(minoutput -1)-textend(0)))*frequ






finalfrequ = frequ;

fftresultIII=dblarr(minoutput);

fftresultIII(minoutput/2:minoutput-1)=fftresultII(0:minoutput/2-1)
fftresultIII(0:minoutput/2-1)=fftresultII(minoutput/2:minoutput-1)



fftresultIII = fftresultIII/max(fftresultIII);



pk = peaks(fftresultIII,3)




  finalspec(*,j)=fftresultIII;





finalspecaverage+=(fftresultIII);
Print,j, filename(j);

;;endif

j = j + 1;
;;plot, frequ,fftresultIII, xrange=[fromenerg,toenerg]  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = FILE_BASENAME(filename(i)) , XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]





endfor

finalspecaverage = finalspecaverage/filecount;

plot, frequ,finalspecaverage, xrange=[fromenerg,0.5], xtickinterval = 0.04  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = "Averaged Result Exp3", XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]

plot, frequ,finalspecaverage, xrange=[0.01,0.4], xtickinterval = 0.04  , xstyle=1, ystyle=1, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = "Averaged Result Exp3 (Linear scale)", XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]

pk = peaks(finalspecaverage,3)
pk = pk-(minoutput)/2
pk = (2*3.1415926/(textend(minoutput -1)-textend(0)))*pk

count = 0.8;
for ii = long(0),pk.length - 1 do begin
oplot,[pk[ii],pk[ii]],[0.000001,1]
if pk[ii] GT 0 then begin
print,'Peaks at'+ STRTRIM(2*3.14/(pk[ii] * 60))

endif
endfor





maxfinalspec = max(finalspec)
finalspec = finalspec/ maxfinalspec;
finalsepcnozero = dblarr(minoutput, filecount);
finalsepcnozero = finalspec[WHERE(finalspec(*) GT 0.01)]

;;cgHistoplot, finalspec, BINSIZE=0.01, /FILL, xtitle = "Time (hours)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3, XTickFormat='WaveNumberFormat', xrange=[0,0.4], MININPUT = 1.0E-3, xtickinterval = 0.04;

;;cgHistoplot, finalspec, BINSIZE=0.01, /FILL, xtitle = "Time (hours)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3, XTickFormat='WaveNumberFormat', xrange=[0,0.4], MININPUT = 1.0E-2, xtickinterval = 0.04 ;


maxalogfinalspec=max(alog10(finalspec));
orderofmagn=8
levelsforlogfinalspec=lindgen(noofcolors)
levelsforlogfinalspec=levelsforlogfinalspec/(1.0*(noofcolors-1))
levelsforlogfinalspec=maxalogfinalspec-orderofmagn+orderofmagn*levelsforlogfinalspec

contour, transpose(alog10(finalspec)),alphahat,frequ, levels=levelsforlogfinalspec, c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98], ytickinterval = 0.025, yrange=[0.01,toenerg], xstyle=1, ystyle=1, xtitle = "Cell Number", ytitle= "Time Period(hours)", YTickFormat='WaveNumberFormat';

colorbar, ncolors=noofcolors, maxrange=levelsforlogfinalspec(0), minrange=levelsforlogfinalspec(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'


for i=long(0),filename.length-1 do begin



nooflines = FILE_LINES(filename(i));
nignore = 1;
if (nooflines MOD 2 EQ 0) then begin
nignore = 2;
endif

noofoutputs = nooflines - nignore;



oplot, [i,i], [-100,100]





endfor















device, /close;
set_plot, "x";
end
