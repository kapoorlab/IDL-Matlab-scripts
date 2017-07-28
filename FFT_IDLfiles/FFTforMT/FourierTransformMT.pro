!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)
fromenerg=1.0E-5
toenerg=0.1



filename=File_Search("/Users/varunkapoor/Documents/Ines_Fourier/FFT_Varun_Exp1/*.txt");
Print, filename.length;


set_plot, "ps";
device, filename = "/Users/varunkapoor/Documents/Ines_Fourier/FFT_Varun_Exp1/AVGFFT_Varun_Exp1.ps", /color, bits=8;

minoutput = 90;




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

if (noofoutputs GE minoutput) then begin

filecount = filecount + 1;

endif

endfor

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

if (noofoutputs GE minoutput) then begin

noofcolumns=long(2)






tab=dblarr(noofcolumns,minoutput );



openr, l, filename(i), /get_lun;
skip_lun, l , nignore, /LINES;
readf, l, tab;
close, /all;


t=tab(0,*);
cwf=tab(1,*);



;;plot, t, cwf, xtitle = 'time (minutes)', ytitle = 'Intensity(a.u. units)'











fftresult=fft(hanning(minoutput)*cwf, /double, /inverse)




fftresultII=fftresult*conj(fftresult)

frequ=lindgen(minoutput)
frequ=frequ-minoutput/2

frequ=(2*3.1415926/(t(minoutput-1)-t(0)))*frequ






finalfrequ = frequ;

fftresultIII=dblarr(minoutput);

fftresultIII(minoutput/2:minoutput-1)=fftresultII(0:minoutput/2-1)
fftresultIII(0:minoutput/2-1)=fftresultII(minoutput/2:minoutput-1)



fftresultIII = fftresultIII/max(fftresultIII);

finalspec(*,j)=fftresultIII
finalspecaverage+=(fftresultIII);
Print,j, filename(j);
j = j + 1;
;;plot, frequ,fftresultIII, xrange=[fromenerg,toenerg]  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = FILE_BASENAME(filename(i)) , XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]


endif


endfor

plot, frequ,finalspecaverage/filecount, xrange=[fromenerg,toenerg]  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = "Averaged Result Exp1", XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]





maxfinalspec = max(finalspec)
finalspec = finalspec/ maxfinalspec;

maxalogfinalspec=max(alog10(finalspec));
orderofmagn=10
levelsforlogfinalspec=lindgen(noofcolors)
levelsforlogfinalspec=levelsforlogfinalspec/(1.0*(noofcolors-1))
levelsforlogfinalspec=maxalogfinalspec-orderofmagn+orderofmagn*levelsforlogfinalspec

contour, transpose(alog10(finalspec)),alphahat,frequ, levels=levelsforlogfinalspec, c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98], yrange=[0.01,toenerg], xstyle=1, ystyle=1, xtitle = "Cell Number", ytitle= "Time Period(hours)", YTickFormat='WaveNumberFormat';

colorbar, ncolors=noofcolors, maxrange=levelsforlogfinalspec(0), minrange=levelsforlogfinalspec(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'


for i=long(0),filename.length-1 do begin



nooflines = FILE_LINES(filename(i));
nignore = 1;
if (nooflines MOD 2 EQ 0) then begin
nignore = 2;
endif

noofoutputs = nooflines - nignore;

if (noofoutputs GE minoutput) then begin

oplot, [i,i], [-100,100]



endif

endfor















device, /close;
set_plot, "x";
end
