%egc analisys 
% ref: https://www.youtube.com/watch?v=flSL0SXNjbI

function [ Y ] = ecg_fcn( fs, y )

% nyquist freq.
fn = fs/2;

% number of samples
n = length(y);

%time vector
t = linspace(0,n/fs,n);

ym = movmean(y,10);

% define FIR high pass filter coef.
fc = 1; % in hertz
h = fir1(500, fc/fn, 'high');

%filter the signal
y_filter = filter(h, 1, y);

% define FIR low band filter coef.
fc = 20; % in hertz

h = fir1(100, fc/fn, 'low');

%filter the signal
y_filter = filter(h, 1, y_filter);

Y = y_filter;

% squared signal (maximize  peaks)
detsq = Y .^ 2;

% bpm detection
last = 0;
upflag = 0;
pulse = zeros(n,1);
p = 0;
th = max(detsq(500:n))*0.75;
for i = 1:n
  if (detsq(i) > th)
    if (upflag == 0)
      if (last > 0)
        t0 = i - last;
        p = fs/t0*60; %rates per minute
      endif
      last = i;
    endif
      upflag = 100;
   else
      if (upflag > 0)
        upflag = upflag - 1;
      endif
    endif
    pulse(i) = p;
endfor




%% plot variables
% plot original signal
figure(1)
plot(t,y);
title('Original signal');
ylabel('amplitude (v)');
xlabel('time (s)');

%plot filtered signal
figure(2)
plot(t,y_filter);
title('Filtered signal');
ylabel('amplitude (v)');
xlabel('time (s)');

% plot squared signal
figure(3)
plot(t,detsq);
title('squared signal');
ylabel('amplitude (v)');
xlabel('time (s)');

%plot pulse rate
figure(4);
plot(t,pulse);
title('pulse rate');
ylabel('rate (bps)');
xlabel('time (s)');

% fft
figure(5);
fft_analisys(fs, y);
