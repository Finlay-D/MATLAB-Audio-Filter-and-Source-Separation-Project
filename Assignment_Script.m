% u1 = audioread("speaker1.wav");   % read in a single channel signal
% u2 = filter([0 0 1],1,u1);        % delay by two sampling periods
% sound([u1 u2],fs);                % play back stereo

fs = 8000;                                  % sampling frequency in Hertz
[x1,x2] = AssignmentScenario(202140944);    % initial assignment function

sound(x1, fs);    % play signal x1 with set sampling frequency


%%
%Q1, plotting signal x1 in time domain,
%using the plot to estimate frequency of the tone.

clf;
plot(x1);                   % signal x1 at a sampling frequency of 8000
xlabel("samples");           % axis labels
ylabel("magnitude");


%%
%Q2, plotting signal x1 in frequency domain,
%using Fourier transform to estimate frequency of the tone.

clf;
f = ((0:length(x1)-1)/length(x1)*fs);       % frequency scale
plot(f,abs(fft(x1)));                       % discrete Fourier transform of x
xlabel("frequency f / [Hz]");               % label axes
ylabel("magnitude");


%%
%Q3, plotting both x1 and x2 on the same graph,
%in the time domain in order to find the signal delay.

clf;
plot (x1);                  % plot signal x1
hold on;                    % keep x1 on the plot
plot (x2);                  % plot signal x2 on the same graph
xlabel("Samples");          % label axes
ylabel("magnitude");
legend('x1','x2');
xlim([19501, 21548]);       % limit x axis to the specified range


%%
%Q5, create a histogram of gain values for the signal within the range
%and another graph of the phase difference between the signals

clf;
range = (19501:21548);      % Specify the range of the graph
N = length(range);          % Create variable for length of the range
f = (0:(N-1))/N*fs;         % Create frequency variable for x-axis

X1 = fft(x1(range));        % Fourier coefficients via fft()
X2 = fft(x2(range));

histogram(abs(X2./X1), 20000);   % plot histogram of gain values
xlabel("Gain Value");            % label axis

figure;
plot(f,unwrap(angle(X2./X1)));      % plot the unwrapped phase angle of the gain ratio
hold on;
plot([0 8000], [0 -2*4*pi], "r--"); % plot a line of gradient proving a 4 sample delay
grid on;


%%
%Q6, create a histogram of gain values for the signal within the second range
%and another graph of the phase difference between the signals

clf;
range = (24800:25824);      % Specify the range of the graph
N = length(range);          % Create variable for length of the range
f = (0:(N-1))/N*fs;         % Create frequency variable for x-axis

X1 = fft(x1(range));        % Fourier coefficients via fft()
X2 = fft(x2(range));

histogram(abs(X2./X1), 20000);   % plot histogram of gain values
xlabel("Gain Value");            % label axis

figure;
plot(f,unwrap(angle(X2./X1)));    % plot the unwrapped phase angle of the gain ratio
hold on;
grid on;


%%
%Q8, creating variables, filtering, and playing the sounds

y1prime = filter(1,[1 0 0 0 0 -0.8217],x1) + filter([0 -0.91418],[1 0 0 0 0 -0.8217],x2);
y2prime = filter([0 0 0 0 -0.899],[1 0 0 0 0 -0.8217],x1) + filter(1,[1 0 0 0 0 -0.8217],x2);

sound(y1prime, fs);     % play first signal
%sound(y2prime, fs);    % play second signal


%%
%Q10, implement the coefficients of the Notch filter and plot
%the magnitude response

clf;
omega = 2*pi*800/fs;        % create variable for Omega from tone frequency
%gamma = 0.9;
gamma = 0.99;              % second gamma value (selectively comment to choose gamma value)

a0 = 1; a1 = -2*gamma*cos(omega); a2 = gamma*gamma;         % instantiate the coefficients
b0 = 1; b1 = -2*cos(omega); b2 = 1;

numerators = [b0, b1, b2];      % create vector variables for the numerator and denominator
denominators = [a0, a1, a2];

[h, f10] = freqz(numerators, denominators, 'whole');
plot(f10, abs(h));


%%
%Q11, implement the Notch filter and use it to filter the tone
%from both signals

clf;
y1 = filter(numerators, denominators, y1prime);     %y1 is y1prime put through the Notch filter
y2 = filter(numerators, denominators, y2prime);     %y2 is y2prime put through the Notch filter

plot(y1);   % plot y1 and y2 to check signals have no interference
hold on;
plot(y2);

sound(y1);  % play filtered audio files to check for interference tone
%sound(y2);
