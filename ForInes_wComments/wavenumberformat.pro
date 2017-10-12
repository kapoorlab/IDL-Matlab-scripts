
FUNCTION WaveNumberFormat, axis, index, value
  ; A function used to calculate the time period given the frequency.
  wavenum = 2 * 3.14d / (value * 60)     ; frequency
  RETURN, String(wavenum, Format = '(f0.2)')
END