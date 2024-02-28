close all;
clear all;
clc;

[data,fs] = audioread('SDRSharp_20240227_SEÑAL_13560000Hz_AF.wav');
t = 1:1:size(data(:,1));
N=length(data);
% Separar Canales IQ
q_sample = data(:,1) ; 
i_sample = data(:,2) ; 
IQ_samples = i_sample + 1i.*q_sample ; 
figure
pspectrum(IQ_samples,fs,'FrequencyLimits',[-13560000 13560000])

%% Dibujar en el dominio del tiempo
figure;
subplot(2,1,1)
plot(t,i_sample,Color='r')
title('Plot in the time domain data')
xlabel('Time(usec)')
ylabel('Amplitude')
legend('Time Domain Signal')

subplot(2,1,2)
i_sample_filtered = medfilt1(i_sample,100);
plot(t,i_sample_filtered,Color='green')
title('Plot filter signal in the time domain data')
xlabel('Time(usec)')
ylabel('Amplitude')
legend('Time Domain Signal')


%% Densidad Espectral
fftsize=1024;
nfft = floor(length(IQ_samples)/fftsize) ;
taxis = [0:fftsize/fs:(nfft-1)*fftsize/fs]; 
rf=13560000;
faxis = [rf-fs/2:fs/fftsize:rf-fs/2+(fftsize-1)*fs/fftsize];

[Pxx, F] = pspectrum(IQ_samples, fs, 'spectrogram');	 
fVals=fs*(-fftsize/2:fftsize/2-1)/fftsize;
figure; plot(faxis,10*log10(abs(Pxx)),'b')
xlabel('frequency(Hz)')
ylabel('PSD (W/HZ)')
%% IQ plot
figure
%subplot(4,1,4)
plot(real(IQ_samples(290000:293000)),"b");
hold on
plot(imag(IQ_samples(290000:293000)),"g");
legend("Inphase signal", "Quadrature signal");
title("IQ Data for 3000 points of acquired signal")
xlabel("Sample number");
ylabel("Voltage");

