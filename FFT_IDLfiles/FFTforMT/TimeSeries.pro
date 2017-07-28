!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)

noofoutputs = 1000;

t = lindgen(noofoutputs);
omega = 5;

A= dblarr(noofoutputs, noofoutputs);

cwf = sin(omega * t);

plot, t, cwf

fftresult=fft(hanning(noofoutputs)*cwf, /double, /inverse)




fftresultII=fftresult*conj(fftresult)

frequ=lindgen(noofoutputs)
frequ=frequ-noofoutputs/2

frequ=(2*3.1415926/(t(noofoutputs-1)-t(0)))*frequ

finalfrequ = frequ;

fftresultIII=dblarr(noofoutputs);

fftresultIII(noofoutputs/2:noofoutputs-1)=fftresultII(0:noofoutputs/2-1)
fftresultIII(0:noofoutputs/2-1)=fftresultII(noofoutputs/2:noofoutputs-1)



fftresultIII = fftresultIII/max(fftresultIII);



plot, frequ,fftresultIII, xrange=[-2,2], xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (time inverse)", ytitle = "Amplitude", title = "Fourier Transform of Signal (Log scale)", yrange = [1.0E-3, 1.0];






device, /close;
set_plot, "x";
end