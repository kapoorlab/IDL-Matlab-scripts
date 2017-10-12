!p.font=1;
!p.charthick=2.0;
!p.charsize=1.5;


pi=3.1415926;


noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)
fromenerg=-0.0
toenerg=0.31

;;!P.MULTI = [0, 1, 6]

;; Enter the directory path here, where all the txt files for Intensity oscillations are stored
;; Example you have a directory /Users/Ines/Desktop/ExperimentOne/*.txt
;; the *.txt tell the program to load all the txt files in that directory onto here, remember to replace the comma with decimal places 
filename=File_Search("/Users/varunkapoor/Documents/Ines_Fourier/FFT_Varun_Exp3All/*.txt");
Print, filename.length;

;; Here the output enviornment is set to postscript and you cna enter the directory and the filename for your results file
set_plot, "ps";
device, filename = "/Users/varunkapoor/Documents/Ines_Fourier/derivextendedFFT_Exp3.ps", /color, bits=8;



;; This is a number to extend short tracks till this value if they are shorter
;; The extension is done by extending the last value till this extended end time
;; This causes the peak at zero frequency to increase in height but leads to no other artifacts
minoutput = 200;




noofcolors=64;
loadct, 4, ncolors=noofcolors;
colors=noofcolors-1-lindgen(noofcolors)

filecount = 0;
for i=long(0),filename.length-1 do begin



nooflines = FILE_LINES(filename(i));

;; Sometimes the first lines are text or strings and you can ignore reading them by setting the variable nignore
nignore = 1;
if (nooflines MOD 2 EQ 0) then begin
nignore = 2;
endif

noofoutputs = nooflines - nignore;



filecount = filecount + 1;



endfor

textend = dblarr(1,minoutput);
cwfextend = dblarr(1,minoutput);

cwfderiv = dblarr(1,minoutput);

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

cwf = cwf/max(cwf);
for arrayindex= long(0), cwf.length - 1 do begin

;; Sometimes your Intensity calues were negative, should never happen but I put them to zero if they do

if (cwf[arrayindex] LT 0) then begin
cwf[arrayindex] = 0*cwf[arrayindex];
endif

endfor


cwfextend(noofoutputs:minoutput - 1) = cwf(noofoutputs - 1);
cwfextend(0:noofoutputs - 1) = cwf(0:noofoutputs - 1);

textend(0:noofoutputs - 1) = t(0:noofoutputs - 1);

count = 1;
for xi = noofoutputs, minoutput - 1  do begin

textend(xi) = t(noofoutputs - 1) + deltat * count;

count++;
endfor


;; If you want to plot the Intensity profiles, uncomment the line below

;;plot, textend, cwfextend, xtitle = 'time (minutes)', ytitle = 'Intensity(a.u. units)'


;; Here we are doing the fast fourier transform
fftresult=fft((cwfextend ), /double)




fftresultII=fftresult*conj(fftresult)

frequ=lindgen(minoutput)
frequ=frequ-(minoutput)/2

frequ=(2*3.1415926/(textend(minoutput -1)-textend(0)))*frequ






finalfrequ = frequ;

fftresultIII=dblarr(minoutput);

fftresultIII(minoutput/2:minoutput-1)=fftresultII(0:minoutput/2-1)
fftresultIII(0:minoutput/2-1)=fftresultII(minoutput/2:minoutput-1)



fftresultIII = fftresultIII/max(fftresultIII);


;; Now we have the peaks
pk = peaks(fftresultIII,3)




  finalspec(*,j)=fftresultIII;




;; This is where we start averaging the Fourier spectra of all files
finalspecaverage+=(fftresultIII);




j = j + 1;
;;plot, frequ,fftresultIII, xrange=[fromenerg,toenerg]  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = FILE_BASENAME(filename(i)) , XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]





endfor

finalspecaverage = finalspecaverage/filecount;

;; Plotting the average spectra in log scale, notice the \ylog variable
plot, frequ,finalspecaverage, xrange=[fromenerg,toenerg], xtickinterval = 0.04  , xstyle=1, ystyle=1, /ylog, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = "Averaged Result Exp3", XTickFormat='WaveNumberFormat', yrange = [1.0E-5, 1.0]

;; Plotting the average spectra in linear scale
plot, frequ,finalspecaverage,  xrange=[fromenerg,toenerg], xtickinterval = 0.04  , xstyle=1, ystyle=1, xtitle = "Frequency (hours)", ytitle = "Amplitude", title = "Averaged Result Exp3 (Linear scale)", XTickFormat='WaveNumberFormat';;, yrange = [1.0E-3, 1.0]


;; This part uses the powerful peak estimator to obtain peaks for astronomical spectrum
pk = peaks(finalspecaverage,3)
pk = pk-(minoutput)/2
pk = (2*3.1415926/(textend(minoutput -1)-textend(0)))*pk

count = 0.8;
for ii = long(0),pk.length - 1 do begin
;;oplot,[pk[ii],pk[ii]],[0.000001,1]
;; Here I print the positions of the peak found in the units of time
if pk[ii] GT 0 then begin
print,'Peaks at'+ STRTRIM(2*3.14/(pk[ii] * 60))

endif
endfor



;; This is where you get the colourful contour plot 

maxfinalspec = max(finalspec)
finalspec = finalspec/ maxfinalspec;
finalsepcnozero = dblarr(minoutput, filecount);
finalsepcnozero = finalspec[WHERE(finalspec(*) GT 0.01)]

cgHistoplot, finalspecaverage, BINSIZE=0.01, /FILL, xtitle = "Time (hours)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3, XTickFormat='WaveNumberFormat', xrange=[0,0.4], xtickinterval = 0.04, MININPUT= 0.02;

cgHistoplot, finalspecaverage, BINSIZE=0.05, /FILL, xtitle = "Time (hours)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3, XTickFormat='WaveNumberFormat', xrange=[0,0.4], xtickinterval = 0.04, MININPUT= 0.02;


maxalogfinalspec=max(alog10(finalspec));
orderofmagn=8
levelsforlogfinalspec=lindgen(noofcolors)
levelsforlogfinalspec=levelsforlogfinalspec/(1.0*(noofcolors-1))
levelsforlogfinalspec=maxalogfinalspec-orderofmagn+orderofmagn*levelsforlogfinalspec

contour, transpose(alog10(finalspec)),alphahat,frequ, levels=levelsforlogfinalspec, c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98], ytickinterval = 0.025, yrange=[fromenerg,toenerg], xstyle=1, ystyle=1, xtitle = "Cell Number", ytitle= "Time Period(hours)", YTickFormat='WaveNumberFormat';

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
