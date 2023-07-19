%  Signal parameters
order = 5;
coefficients1 = [0.5, -0.2, 0.3, -0.1, 0.2]; %ARMA
coefficients2 = [0.5, -0.3, 0.1, -0.2, 0.2]; 
coefficients3 = [0.1, -0.3, 0.5, -0.2, 0.4];
noise_variance = 0.1;
amplitude_scale_eeg1 = 10;   % Scale factor
amplitude_scale_eeg2 = 15; 
amplitude_scale_eeg3 = 20; 


% Generating Artificial EEG Signals
t_eeg = linspace(0, 0.5, 500); % Time vector for 500 ms duration


eeg_signal1 = zeros(size(t_eeg));
eeg_signal1(1:order) = randn(1, order); %Initializing the initial orders with Gaussian noise
for i = order+1:length(t_eeg)
    eeg_signal1(i) = coefficients1 * eeg_signal1(i-order:i-1).' + sqrt(noise_variance) * randn;
end

% Scaling the amplitude of the EEG signal
eeg_signal1 = amplitude_scale_eeg1 * eeg_signal1;

eeg_signal2 = zeros(size(t_eeg));
eeg_signal2(1:order) = randn(1, order);
for i = order+1:length(t_eeg)
    eeg_signal2(i) = coefficients2 * eeg_signal2(i-order:i-1).' + sqrt(noise_variance) * randn;
end
eeg_signal2 = amplitude_scale_eeg2 * eeg_signal2;

eeg_signal3 = zeros(size(t_eeg));
eeg_signal3(1:order) = randn(1, order);
for i = order+1:length(t_eeg)
    eeg_signal3(i) = coefficients3 * eeg_signal3(i-order:i-1).' + sqrt(noise_variance) * randn;
end
eeg_signal3 = amplitude_scale_eeg3 * eeg_signal3;

% Visualizing the generated EEG signals.

figure;
subplot(3, 1, 1);
plot(t_eeg*1000, eeg_signal1);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal 1');

subplot(3, 1, 2);
plot(t_eeg*1000, eeg_signal2);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal 2');

subplot(3, 1, 3);
plot(t_eeg*1000, eeg_signal3);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal 3');

% Generating Gaussian blinking:
%/////////////////////////////////////
% Time vector for 500 ms duration:
t_clipit = linspace(0, 0.5, 500);
% Frequency of the blink in Hz:
f_clipit = 5;
% Standard deviation for Gaussian shape:
sigma_clipit = 0.01;
% Scaling factor for the amplitude of the Gaussian blinking
amplitude_scale_clipit = 100;

clipit = amplitude_scale_clipit * exp(-(t_clipit - 0.2).^2 / (2*sigma_clipit^2)); 
semnal_contaminat1 = eeg_signal1 + clipit;

% Visualizing the EEG signal, blinking signal, and contaminated signal
figure;
subplot(3, 1, 1);
plot(t_eeg*1000, eeg_signal1);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal');

subplot(3, 1, 2);
plot(t_clipit*1000, clipit);
xlabel('Time (ms)');
ylabel('Amplitude');
title('Gaussian Blink');

subplot(3, 1, 3);
plot(t_eeg*1000, semnal_contaminat1);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Contaminated Signal');

semnal_contaminat2=eeg_signal2+clipit;

% Visualizing the EEG signal, blinking signal, and contaminated signal
figure;
subplot(3, 1, 1);
plot(t_eeg*1000, eeg_signal2);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal');

subplot(3, 1, 2);
plot(t_clipit*1000, clipit);
xlabel('Time (ms)');
ylabel('Amplitude');
title('Gaussian Blink');

subplot(3, 1, 3);
plot(t_eeg*1000, semnal_contaminat2);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Contaminated Signal 2');

semnal_contaminat3=eeg_signal3+clipit;

%Visualizing the EEG signal, blinking signal, and contaminated signal
figure;
subplot(3, 1, 1);
plot(t_eeg*1000, eeg_signal3);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal');

subplot(3, 1, 2);
plot(t_clipit*1000, clipit);
xlabel('Time (ms)');
ylabel('Amplitude');
title('Gaussian Blink');

subplot(3, 1, 3);
plot(t_eeg*1000, semnal_contaminat3);
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Contaminated Signal 3');


matrContaminata=[semnal_contaminat1;semnal_contaminat2;semnal_contaminat3;clipit];
[componente_indep_eeg, W, T] = fastICA(matrContaminata,1); 


%Visualizing the independent components
figure;
for i=1:size(componente_indep_eeg,1)
    subplot(size(componente_indep_eeg,1),1,i);
    plot(componente_indep_eeg(i,:));
    title(sprintf('Componenta %d',i));
end

% Visualizing the generated EEG signals.
fact_scalare=max(clipit)/max(componente_indep_eeg);
figure;
plot(t_clipit*1000,clipit,t_clipit*1000,componente_indep_eeg(1,:)*fact_scalare,'r');

figure;
subplot(3, 1, 1);
plot(t_eeg*1000, eeg_signal1,t_eeg*1000,semnal_contaminat1-componente_indep_eeg(1,:)*fact_scalare,'r');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title(' EEG Artificial EEG Signal 1');

subplot(3, 1, 2);
plot(t_eeg*1000, eeg_signal2,t_eeg*1000,semnal_contaminat2-componente_indep_eeg(1,:)*fact_scalare,'r');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal 2');

subplot(3, 1, 3);
plot(t_eeg*1000, eeg_signal3,t_eeg*1000,semnal_contaminat3-componente_indep_eeg(1,:)*fact_scalare,'r');
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
title('Artificial EEG Signal 3');

legend("Artificial EEG  ", "Corrected EEG signal using FastICA");



% %reconstruire matrice 
% Snlrec=inv(T)*componente_independente_sin;
% figure;
% 
% subplot(2,1,1)
% plot(Snlrec(1,:));
% title("Semnal reconstruit ");
% subplot(2,1,2)
% plot(Snlrec(2,:));
% 
% %anularea unei componente
% 
% componente_independente_sin(1,:) = 0;
% 
% %reconstruire matrice
% Snlrec=inv(T).*componente_independente_sin;
% figure;
% subplot(2,1,1)
% plot(Snlrec(1,:));
% title("Semnal reconstruit cu o componenta extrasa");
% subplot(2,1,2)
% plot(Snlrec(2,:));


