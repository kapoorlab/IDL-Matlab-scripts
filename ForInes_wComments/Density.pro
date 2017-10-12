  !p.font=1;
  !p.charthick=2.0;
  !p.charsize=1.5;
  
  pi=3.1415926;
  
  deltx=0.5;
  delty=0.5;
  diffconst = 0.1;
  deltat=0.05; 0.1*(deltx*deltx+delty*delty)/(2*diffconst);
  
  noofx=long(500);
  noofy=long(500);
  
  noofoutputs=long(80);
  
  
  noofcolors=100;
  loadct, 5, ncolors=noofcolors;
  colors=noofcolors-1-indgen(noofcolors)
  
  set_plot, "ps";
  device, filename="diffusiontestkg.ps", /color, bits=8;
  
  
  
  nooflines=long(noofx*noofy);
  noofcolumns=long(2);
  
  
  
  
  x=lindgen(noofx);
  x=(x-0.5*noofx)*deltx;
  y=lindgen(noofy);
  y=(y-0.5*noofy)*delty;
  
  
  dens_output=99;
  t=lindgen(noofoutputs);
  t=t*deltat*dens_output;
  
  
  
  filename='/Users/varunkapoor/Documents/workspace-cpp/Diffusion/res/densitytestkg.dat';
  
  tab=complexarr(noofcolumns,nooflines);
  openr, m, filename, /get_lun;
  
  density=complexarr(noofx,noofy);
  
  for k=long(0),noofoutputs-1 do begin
  
  
    readf, m, tab;
  
  
    for i=long(0),noofx-1 do begin
      for j=long(0),noofy-1 do begin
  
        density(i,j)=complex(tab(0,i*noofy+j),tab(1,i*noofy+j));
  
      endfor
    endfor
    
  density = real_part(density);
  
  
    density=density/max(density)
  
    maxalogdensity=max(alog10(density))
    orderofmagn=5
    levelsforlogdensity=indgen(noofcolors)
    levelsforlogdensity=levelsforlogdensity/(1.0*(noofcolors-1))
    levelsforlogdensity=maxalogdensity-orderofmagn+orderofmagn*levelsforlogdensity
  
  
    contour, alog10(density),x,y, levels=levelsforlogdensity,c_colors=colors, /fill, /closed,pos=[0.15,0.15,0.85,0.98],$
    xtitle='x (a.u.)', ytitle='y (a.u.)', title = (k+1)*deltat*dens_output
  
    COLORBAR,ncolors=noofcolors,maxrange=levelsforlogdensity(0),minrange=levelsforlogdensity(noofcolors-1), position=[0.95,0.15,0.98,0.98], /vertical, format='(D8.2)'
  
  
    
  
  endfor
  
  
  close, /all;
  device, /close;
  set_plot, "x";
  end
