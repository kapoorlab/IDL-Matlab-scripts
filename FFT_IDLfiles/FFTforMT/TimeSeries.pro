!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)

toenerg = 0.3;
set_plot, "ps";
device, filename = "/Users/varunkapoor/Documents/Ines_Fourier/FakeCell.ps", /color, bits=8;

Nsamples = 100;
noofoutputs = 100;
finalspec= dblarr(noofoutputs, Nsamples);
alphahat=lindgen(Nsamples);
finalspecaverage= dblarr(noofoutputs);

omega = 0.1 ;
increment = 0.01;
for index = long(0), Nsamples - 1 do begin







t = lindgen(noofoutputs)
deltat = 10;
t= t*deltat;




if (index LT Nsamples/10 - 1) then begin
omega+=increment;

endif

if (index GT Nsamples/10 && index LT 2 * Nsamples/10 - 1 )then begin
omega-=increment;
endif
if (index GT 2 * Nsamples/10 && index LT 3 * Nsamples/10 - 1 )then begin
omega+=increment;
endif
if (index GT 3 * Nsamples/10 && index LT 4 * Nsamples/10 - 1 )then begin
omega-=increment;
endif

if (index GT 4 * Nsamples/10 && index LT 5 * Nsamples/10 - 1 )then begin
omega+=increment;
endif

if (index GT 5 * Nsamples/10 && index LT 6 * Nsamples/10 - 1 )then begin
omega-=increment;
endif


if (index GT 6 * Nsamples/10 && index LT 7 * Nsamples/10 - 1 )then begin
omega+=increment;
endif

if (index GT 7 * Nsamples/10 && index LT 8 * Nsamples/10 - 1 )then begin
omega-=increment;
endif

if (index GT 8 * Nsamples/10 && index LT 9 * Nsamples/10 - 1 )then begin
  omega+=increment;
endif

if (index GT 9 * Nsamples/10 && index LT 10 * Nsamples/10 - 1 )then begin
  omega-=increment;
endif

print, omega

;;Deviation in frequency, between -0.1 and 0.1



;;Create a wave
cwf =  (SIN((omega) * t)) + 3;



;;Add randomnoise

cwfnoise = cwf + RANDOMU(SEED,noofoutputs, POISSON = 1.5);

cwfnoise = cwfnoise/max(cwfnoise);
;;plot, t, cwfnoise, title="Cell Intensity "+ STRTRIM(index)

fftresult=fft(hanning(noofoutputs)*cwfnoise, /double, /inverse)




fftresultII=fftresult*conj(fftresult)

frequ=lindgen(noofoutputs)
frequ=frequ-noofoutputs/2

frequ=(2*3.1415926/(t(noofoutputs-1)-t(0)))*frequ

finalfrequ = frequ;

fftresultIII=dblarr(noofoutputs);

fftresultIII(noofoutputs/2:noofoutputs-1)=fftresultII(0:noofoutputs/2-1)
fftresultIII(0:noofoutputs/2-1)=fftresultII(noofoutputs/2:noofoutputs-1)



fftresultIII = fftresultIII/max(fftresultIII);


finalspec(*,index)=fftresultIII;





finalspecaverage+=(fftresultIII);

;;plot, frequ,fftresultIII, xrange=[0,toenerg] , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency ", ytitle = "Amplitude", title = "Fake Cells";;, yrange = [1.0E-3, 1.0]




endfor


finalspecaverage = finalspecaverage/Nsamples;

plot, frequ,finalspecaverage, xrange=[0,toenerg] , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency ", ytitle = "Amplitude", title = "Fake Cells";;, yrange = [1.0E-3, 1.0]







maxfinalspec = max(finalspec)
finalspec = finalspec/ maxfinalspec;


maxalogfinalspec=max(alog10(finalspec));
orderofmagn=8
levelsforlogfinalspec=lindgen(noofcolors)
levelsforlogfinalspec=levelsforlogfinalspec/(1.0*(noofcolors-1))
levelsforlogfinalspec=maxalogfinalspec-orderofmagn+orderofmagn*levelsforlogfinalspec

contour, transpose(alog10(finalspec)),alphahat,frequ, levels=levelsforlogfinalspec, c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98], yrange=[0.01,toenerg], xstyle=1, ystyle=1, xtitle = "Cell Number", ytitle= "Time Period";

colorbar, ncolors=noofcolors, maxrange=levelsforlogfinalspec(0), minrange=levelsforlogfinalspec(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'






device, /close;
set_plot, "x";
end