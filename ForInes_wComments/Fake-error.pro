pi=3.1415926;

noofcolors=30;
loadct, 5, ncolors=noofcolors;
colors=noofcolors-1-indgen(noofcolors)

set_plot, "ps";
device, filename="/Users/varunkapoor/Documents/JoeVisit/errorstats.ps", /color, bits=8;








filename= '/Users/varunkapoor/Documents/JoeVisit/Fake_errors-1.txt';

nooflines = FILE_LINES(filename) - 1;

drawerror = 0;

noofcolumns=long(8);


tab=dblarr(noofcolumns,nooflines);

openr, l, filename, /get_lun;
skip_lun, l , 1, /LINES;
readf, l, tab;
close, /all;

actualxstart = dblarr(nooflines);
actualxstart = tab(0,*);

actualystart = dblarr(nooflines);
actualystart = tab(1,*);

actualxend = dblarr(nooflines);
actualxend = tab(2,*);

actualyend = dblarr(nooflines);
actualyend = tab(3,*);

Allx = [ actualxstart, actualxend];
Ally =[ actualystart, actualyend];

programxstart = dblarr(nooflines);
programxstart = tab(4,*);

programystart = dblarr(nooflines);
programystart = tab(5,*);

programxend = dblarr(nooflines);
programxend = tab(6,*);

programyend = dblarr(nooflines);
programyend = tab(7,*);


Allprogramx = [programxstart,programxend];
Allprogramy =[programystart, programyend];

AllxErrors= Allx - Allprogramx + drawerror;
AllyErrors = Ally - Allprogramy + drawerror;




!p.multi = [0,2,3]

cgHistoplot, AllxErrors, BINSIZE=0.5, /FILL, xtitle = "Error X (pixels)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3;

cgHistoplot, AllyErrors, BINSIZE=0.5, /FILL, xtitle = "Error Y (pixels)", ytitle = "Counts", POLYCOLOR=['charcoal', 'dodger blue'], ORIENTATION=[45, -45], yticks=3;

device, /close;



set_plot, "x";
end

