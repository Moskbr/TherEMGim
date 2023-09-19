clc; clearvars; close all;

% extraindo e plotando o sinal EMG

raw_emg = load("C:\emg_healthy.txt");

figure(1)
plot(raw_emg(:,1), raw_emg(:,2))
xlabel("Time (seconds)"); ylabel("EMG (mV)"); title("Raw EMG")
grid

% Half Wave Retification (Retificação meia onda)

HWrec_emg = raw_emg;

for j = 1:length(HWrec_emg)
    if HWrec_emg(j,2) <= 0
        HWrec_emg(j,2) = 0;
    end
end

% Filtro:

% RMS envelope (Root Mean Square)

Fs = 4000; % Frequencia de amostragem
Fnyq = Fs/2; % Frequencia de Nyquist
Frms = 3;
Wn = Frms/Fnyq; % Frequencia de corte normalizada

[B, A] = butter(4,Wn,'low');

RMS = filtfilt(B, A, HWrec_emg);

%figure(1)
%plot(HWrec_emg(:,1), HWrec_emg(:,2))
%hold on
%plot(raw_emg(:,1), RMS(:,2), 'r', 'LineWidth',2)
%xlabel("Time (seconds)"); ylabel("EMG (mV)");title("RMS EMG")

% Transformada de Fourier (fft)
L = length(raw_emg);

freq_range = Fs*(0:L/2)/L; % intervalo da frequencia
Fw = fft(raw_emg(:,2));% transformada de Fourier

Fw = abs(Fw/L);% normalização dos dados

Fw = Fw(1:L/2+1);
Fw(2:end-1) = 2*Fw(2:end-1);% intensificação das amplitudes positivas

figure(1)
plot(freq_range, Fw)
xlabel("Frequencia"); ylabel("Magnitude");title("FFT do EMG")

% Filtro passa baixa

Fc = 1000;
Wm = Fc/Fnyq;
[B, A] = butter(4,Wm,'low');

Signal = filtfilt(B, A, HWrec_emg);
figure(2)
plot(HWrec_emg(:,1), HWrec_emg(:,2))
hold on
plot(HWrec_emg(:,1), Signal(:,2), 'r')
xlabel("Time (sec)"); ylabel("EMG (mV)");title("Comparação EMG Filtrado")
grid on


