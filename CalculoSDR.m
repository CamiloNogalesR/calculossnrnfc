%% Calculos de Potencias
clc,clear,close
% Leer el archivo .wav que contiene los datos IQ
[x, fs] = audioread('SDRSharp_20240227_RUIDO_13560000Hz_AF.wav');

% Separar el vector en dos partes: I y Q
x = reshape(x, [], 2);
I = x(:, 1);
Q = x(:, 2);

% Calcular la potencia de cada muestra compleja
P = mean((abs(I+1j*Q)).^2, 2);
vP_dB = 10*log10(P);
% Convertir la potencia a dBW
P_dBW = 10 * log10(P / 1);

% Calcular la potencia de la señal como el máximo de la potencia de las muestras
Ps = max(P);

% Calcular la potencia del ruido como el promedio de la potencia de las muestras
% que están por debajo de un umbral (por ejemplo, el 0.0004% de la potencia de la señal)
umbral = 0.000004 * Ps;
Pn = mean(P(P < umbral));

% Convertir la potencia de la señal y del ruido a dBW
Ps_dBW = 10 * log10(Ps / 1);
Pn_dBW = 10 * log10(Pn / 1);

% Mostrar los resultados
disp(['Potencia del Ruido: ' num2str(Pn_dBW) ' dBW']);

%% Filtrado de la señal
P_signal = medfilt1(P,100);
PSenal = mean(P_signal);
PSignal_dBW = 10 * log10(PSenal / 1);

disp(['Potencia de la Señal: ' num2str(PSignal_dBW) ' dBW']);

disp(['El valor de la SNR de la señal NFC es: ' num2str(PSignal_dBW-Pn_dBW) ' dB'])

%% Calculo Teorico
%C=106000 bps , AB=7000Hz
C=106000;
AB=7000;

SNR_NFC = 2^(C/AB) - 1;
SNR_NFC_dB = 10 * log10(SNR_NFC);
 
disp(['El valor teórico de SNR para NFC es : ' num2str(SNR_NFC_dB) ' dB'])

%Dado a que los valores de potencia teóricos estan entre 0.1W y 0.01W
%entonces se puede restar para obtener el valor del ruido teórico en dBs

PT1 = 10 * log10(0.1);
PT2 = 10 * log10(0.01);

NT1 = PT1 - SNR_NFC_dB;
NT2 = PT2 - SNR_NFC_dB;

disp(['Por tanto los valores teoricos del ruido estan entre : ' ...
    num2str(NT1) ' dBW  y  ' num2str(NT2) ' dBW'])

%% Valores ruido
muestraIQ = I +1j.*Q; %Muestras del Ruido
AmplitudIQ = abs(muestraIQ);
t1 = 1:1:size(x(:,1));

subplot(3,1,1)
plot(t1,AmplitudIQ)
title('Ruido')
Valmax = max(AmplitudIQ);

[x1, fs] = audioread('SDRSharp_20240227_SEÑAL_13560000Hz_AF.wav');

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