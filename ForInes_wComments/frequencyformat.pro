
FUNCTION FrequencyFormat, axis, index, value
  ; A function used to calculate the time period given the frequency.
  wavenum = 2 * 3.14d / (value)     ; frequency
  RETURN, String(wavenum, Format = '(f0.2)')
END