!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)

toenerg = 0.3;
set_plot, "ps";
device, filename = "/Users/varunkapoor/Documents/Ines_Fourier/DerivativeModsig.ps", /color, bits=8;

Nsamples = 100;
noofoutputs = 1000;
finalspec= dblarr(noofoutputs, Nsamples);
alphahat=lindgen(Nsamples);
finalspecaverage= dblarr(noofoutputs);

omega = 0.1 ;
endomega = 0.2;
omegatime = dblarr(noofoutputs);





increment = 0.01;
for index = long(0), Nsamples - 1 do begin


t = lindgen(noofoutputs)

deltat = 0.5;

t= t*deltat;


k = (endomega - omega) / (noofoutputs*deltat);


;;Deviation in frequency, between -0.1 and 0.1




;;Create a wave
cwf =  (SIN((omega + k*t/2) * t));



;;Add randomnoise

cwfnoise = cwf + RANDOMU(SEED,noofoutputs, POISSON = 1.5);

cwfnoise = (cwfnoise)/max(cwfnoise);
;;plot, t, cwfnoise, title="Cell Intensity "+ STRTRIM(index)

fftresult=fft(hanning(noofoutputs)*(cwfnoise - mean(cwfnoise)), /double, /inverse)




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

plot, frequ,finalspecaverage, xrange=[0,toenerg] , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency(hours) ", ytitle = "Amplitude", XTickFormat='WaveNumberFormat', title = "Simulated Cells";;, yrange = [1.0E-3, 1.0]
plot, frequ,finalspecaverage, xrange=[0,toenerg] , xstyle=1, ystyle=1, xtitle = "Frequency(hours) ", ytitle = "Amplitude", XTickFormat='WaveNumberFormat', title = "Simulated Cells (linear scale)";;, yrange = [1.0E-3, 1.0]


cgHistoplot, finalspecaverage, BINSIZE=0.02, /FILL, xtitle = "Time (hours)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3, XTickFormat='WaveNumberFormat', xrange=[0,0.4], xtickinterval = 0.04;





maxfinalspec = max(finalspec)
finalspec = finalspec/ maxfinalspec;


maxalogfinalspec=max(alog10(finalspec));
orderofmagn=5
levelsforlogfinalspec=lindgen(noofcolors)
levelsforlogfinalspec=levelsforlogfinalspec/(1.0*(noofcolors-1))
levelsforlogfinalspec=maxalogfinalspec-orderofmagn+orderofmagn*levelsforlogfinalspec

contour, transpose(alog10(finalspec)),alphahat,frequ, levels=levelsforlogfinalspec, c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98], YTickFormat='WaveNumberFormat', yrange=[0,toenerg], xstyle=1, ystyle=1, xtitle = "Cell Number", ytitle= "Time Period(hours)";

colorbar, ncolors=noofcolors, maxrange=levelsforlogfinalspec(0), minrange=levelsforlogfinalspec(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'



for i=long(0),Nsamples-1 do begin





  oplot, [i,i], [-100,100]





endfor




device, /close;
set_plot, "x";
end