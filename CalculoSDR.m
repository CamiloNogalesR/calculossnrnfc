%% Calculos de Potencias
clc,clear,close
% Leer el archivo .wav que contiene los datos IQ
[x, fs] = audioread('SDRSharp_20240224_NFC025MSPS_13560000Hz_IQ.wav');

% Separar el vector en dos partes: I y Q
x = reshape(x, [], 2);
I = x(:, 1);
Q = x(:, 2);

% Calcular la potencia de cada muestra compleja
P = mean([I Q].^2, 2);

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
    num2str(NT1) ' dB  y  ' num2str(NT2) ' dB'])