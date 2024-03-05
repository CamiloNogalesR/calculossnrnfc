%% Calculos de Potencias
clc,clear,close
% Leer el archivo .wav que contiene los datos IQ
[x, fs] = audioread('SDRSharp_20240227_RUIDO_13560000Hz_IQ.wav');

% Separar el vector en dos partes: I y Q
x = reshape(x, [], 2);
I = x(:, 1);
Q = x(:, 2);


%% Valores ruido
muestraIQ = I +1j.*Q; %Muestras del Ruido
AmplitudIQ = abs(muestraIQ); %La amplitud de la muestra IQ es el valor absoluto del mismo
t1 = 1:1:size(x(:,1)); %vector tiempo para grafica de amplitudes

subplot(3,1,1)
plot(t1,AmplitudIQ)
title('Ruido')
Valmax = max(AmplitudIQ);

[x1, fs] = audioread('SDRSharp_20240227_SEÑAL_13560000Hz_IQ.wav');

% Separar el vector en dos partes: I y Q MUESTRAS DE LA SEÑAL
x1 = reshape(x1, [], 2);
Ia = x1(:, 1);
Qa = x1(:, 2);
t2 = 1:1:size(x1(:,1));

muestraIQSignal = Ia +1j.*Qa;
AmplitudIQa = abs(muestraIQSignal);
subplot(3,1,2)
plot(t2,AmplitudIQa,'r')
title('Señal con Ruido')

%Condicion, todos los valores por encima del umbral del ruido pertenecen a la senal IQ
vSignal = AmplitudIQa(AmplitudIQa > Valmax);

t3 = 1:1:size(vSignal(:,1));

subplot(3,1,3)
plot(t3,vSignal,'g')
title('Señal por encima del Umbral')
%% Potencias de cada señal
%Potencia del ruido
Pruido = mean((AmplitudIQ).^2)
Pruido_dBW = 10*log10(Pruido)

%Potencia señal
Psignal = mean((vSignal).^2)
Psig_dBW = 10*log10(Psignal)


%SNR
P_SNR_dB = Psig_dBW - Pruido_dBW
