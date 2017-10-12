pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/MTV_Tracker/res/NLplot.ps", /color, bits=8;
filename = '/Users/varunkapoor/MTV_Tracker/res/TestR0.3STATN_L.txt';

noofcolumns = long(3);
nlines = FILE_LINES(filename);



actuallines = (nlines - 1);




openr, l, filename, /get_lun;
skip_lun, l , 1, /LINES;

tab = FLTARR(noofcolumns, actuallines)

readf, l, tab;
close, /all;

Framearrayaverage= FLTARR(noofcolumns - 1, actuallines)

minframe = tab(0,0);
maxframe = tab(0,actuallines - 1);
calibration = 0.15613580129908108;

minlength = min(tab(2,*));
maxlength = max(tab(2,*));


lengthsize = long(maxlength - minlength);
framesize = maxframe - minframe;

NumberLength = FLTARR(lengthsize + 1);

Length = lindgen(lengthsize);

for index = long(minlength), long(maxlength) do begin

k = long(index - minlength);

minindex = WHERE(tab(2,*) EQ index, count)

NumberLength(k) = Mean(( tab(1, minindex)));


endfor

plot, Length, NumberLength , xtitle = " Length (pixel units)", ytitle = " N(L)", title= " Number of MT having length > L (frame averaged)", xrange = [0,100]

plot, Length * calibration, NumberLength  , xtitle = " Length (Micrometer)", ytitle = " N(L)", title= " Number of MT having length > L (frame averaged)", xrange=[0,100*calibration]


device, /close;



set_plot, "x";
end