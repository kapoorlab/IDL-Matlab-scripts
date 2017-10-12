
  time = (2.0/1000)*findgen(1001)        ; time (s). NB 1001 samples in 2s
  ; so sampling freq is 500 Hz thus
  ; Nyquist freq is 250 Hz

  ;;; so your deltat = 2, aha!
  deltat = 2;
  
  freq = 100.0 + (50.0/1000)*findgen(1001)/deltat ; chirp frequency array

  theta = 2*!pi*freq*time ; chirp phase angle

  i = complex(0,1)

  signal = exp(i*theta)

  neg_freq_axis = reverse(-((250.0/500)*findgen(501)))
  pos_freq_axis = ((250.0/499)*findgen(500)) + 1.0
  freq_axis = [neg_freq_axis,pos_freq_axis]        ; x-axis for plot

  window,2,xsize=500,ysize=250
  plot,freq_axis,alog10(shift(((abs(fft(signal)))^2),500)),$
    xrange=[0,260],$
    /xstyle,$
    xticklen=1,$
    xgridstyle=1,$
    yticklen=1,$
    ygridstyle=1

set_plot, "x";
end