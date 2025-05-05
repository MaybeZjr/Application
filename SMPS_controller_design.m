% Forward Converter Control System Analysis
close all; clear; clc;

% System Parameters
L = 57.6e-6;       % Inductor (H)
C = 660e-6;       % Capacitor (F)
RC = 0.4/3;         % Capacitor ESR (Ohm)
R = 2.88;           % Load resistance
VA = 0.5;           % PWM chip parameter (V)
VB = 3.8;         % PWM chip parameter (V)
dMAX = 0.45;      % Maximum duty cycle
VS0 = 35;         % Input voltage (V)
n = 9/7;          % Transformer turns ratio (N2/N1)
alpha = 0.25;      % Voltage divider ratio

% Derived values
KPWM = dMAX/(VB-VA);  % PWM gain
KMISC = alpha*KPWM*VS0*n;  % Miscellaneous gain

% Frequencies of interest
f_res = 1/(2*pi*sqrt(L*C));  % Resonant frequency (Hz)
w_res = 2*pi*f_res;          % Resonant frequency (rad/s)
f_ripple = 100;              % Ripple frequency (Hz)
w_ripple = 2*pi*f_ripple;    % Ripple frequency (rad/s)

% Filter transfer function GF(s)
a_GF = R/(R + RC);
num_GF = [RC*C*a_GF,a_GF];
den_GF = [L*C,(L+C*R*RC)/(R+RC),a_GF];
% num_GF = [RC*C 1];
% den_GF = [L*C (L/R + RC*C) 1];
GF = tf(num_GF, den_GF);

% Type 1 controller analysis
f_c_type1 = f_res * 0.676;        % Crossover frequency (Hz)
% f_c_type1 = f_res/6;         %TODO: test different crossover frequencies
w_c_type1 = 2*pi*f_c_type1;  % Crossover frequency (rad/s)

% Evaluate filter at crossover frequency
[mag_GF_wc1, phase_GF_wc1] = bode(GF, w_c_type1);
mag_GF_wc1 = squeeze(mag_GF_wc1);
phase_GF_wc1 = squeeze(phase_GF_wc1);

% Type 1 controller design
G_type1 = 1/(KMISC*mag_GF_wc1);
A_type1 = G_type1 * w_c_type1;
GC_type1 = tf(A_type1, [1 0]);  % A/s

% Type 1 loop gain
T_type1 = KMISC * GC_type1 * GF;

% Type 3 controller analysis
f_c_type3 = 7500;            % Crossover frequency (Hz)
w_c_type3 = 2*pi*f_c_type3;  % Crossover frequency (rad/s)

% Evaluate filter at new crossover frequency
[mag_GF_wc3, phase_GF_wc3] = bode(GF, w_c_type3);
mag_GF_wc3 = squeeze(mag_GF_wc3);
phase_GF_wc3 = squeeze(phase_GF_wc3);

% Type 3 controller design
G_type3 = 1/(KMISC*mag_GF_wc3);
PM_desired = 60;  % Desired phase margin (degrees)
phase_boost = PM_desired - (180 - 90 + phase_GF_wc3);
k = (tan(deg2rad(phase_boost/4 + 45)))^2;
A_type3 = G_type3 * w_c_type3 / k;

% Type 3 controller transfer function
w_z = w_c_type3/sqrt(k);
w_p = w_c_type3*sqrt(k);
num_GC3 = A_type3*[1/w_z^2 2/w_z 1];
den_GC3 = [1/w_p^2 2/w_p 1 0];
GC_type3 = tf(num_GC3, den_GC3);

% Type 3 loop gain
T_type3 = KMISC * GC_type3 * GF;

% Component values for Type 3
R1 = 1e4;  % Choose R1 = 10k
C2 = 1/(R1*w_c_type3*G_type3);
C1 = C2*(k-1);
R2 = sqrt(k)/(w_c_type3*C1);
R3 = R1/(k-1);
C3 = 1/(R3*w_c_type3*sqrt(k));

% Calculate ripple attenuation
[mag_T1_ripple, ~] = bode(T_type1, w_ripple);
mag_T1_ripple = squeeze(mag_T1_ripple);
ripple_attenuation_type1 = 1/(1 + mag_T1_ripple);
output_ripple_type1 = 0.2 * ripple_attenuation_type1;  %TODO: Assuming 20% input ripple

[mag_T3_ripple, ~] = bode(T_type3, w_ripple);
mag_T3_ripple = squeeze(mag_T3_ripple);
ripple_attenuation_type3 = 1/(1 + mag_T3_ripple);
output_ripple_type3 = 0.2 * ripple_attenuation_type3;  % Assuming 20% input ripple

% Bode plots
figure('Position', [100, 100, 800, 600]);
subplot(2,1,1);
margin(T_type1);
title('Type 1 Controller - Loop Gain');
grid on;

subplot(2,1,2);
margin(T_type3);
title('Type 3 Controller - Loop Gain');
grid on;

% Print results
fprintf('System Parameters:\n');
fprintf('Resonant Frequency: %.2f Hz (%.2f rad/s)\n', f_res, w_res);
fprintf('Filter Transfer Function GF(s):\n');
GF

fprintf('\nType 1 Controller Analysis:\n');
fprintf('Crossover Frequency: %.2f Hz (%.2f rad/s)\n', f_c_type1, w_c_type1);
fprintf('G = %.4f, A = %.2f\n', G_type1, A_type1);
fprintf('Components: R1 = %.2f kOhm, C1 = %.2f nF\n', R1/1e3, 1/(A_type1*R1)*1e9);
fprintf('Ripple at 100Hz: %.2f%% (%.3f V with 10V output)\n', output_ripple_type1*100, output_ripple_type1*10);
[GM1, PM1] = margin(T_type1);
fprintf('Phase Margin: %.2f degrees, Gain Margin: %.2f dB\n', PM1, GM1);

fprintf('\nType 3 Controller Analysis:\n');
fprintf('Crossover Frequency: %.2f Hz (%.2f rad/s)\n', f_c_type3, w_c_type3);
fprintf('G = %.4f, k = %.2f, A = %.2f\n', G_type3, k, A_type3);
fprintf('Zero Frequency: %.2f Hz, Pole Frequency: %.2f Hz\n', w_z/(2*pi), w_p/(2*pi));
fprintf('Components:\n');
fprintf('R1 = %.2f kOhm, C1 = %.2f nF\n', R1/1e3, C1*1e9);
fprintf('R2 = %.2f kOhm, C2 = %.2f pF\n', R2/1e3, C2*1e12);
fprintf('R3 = %.2f kOhm, C3 = %.2f nF\n', R3/1e3, C3*1e9);
fprintf('Ripple at 100Hz: %.4f%% (%.4f V with 12V output)\n', output_ripple_type3*100, output_ripple_type3*12);
[GM3, PM3] = margin(T_type3);
fprintf('Phase Margin: %.2f degrees, Gain Margin: %.2f dB\n', PM3, GM3);

% Plot step response
figure;
subplot(2,1,1);
T1_closed = feedback(KMISC*GF*GC_type1, 1);
step(T1_closed);
title('Type 1 Step Response');
grid on;

subplot(2,1,2);
T3_closed = feedback(KMISC*GF*GC_type3, 1);
step(T3_closed);
title('Type 3 Step Response');
grid on;

% Plot ripple attenuation
figure;
f = logspace(1, 4, 1000);
w = 2*pi*f;
[mag_T1, ~] = bode(T_type1, w);
mag_T1 = squeeze(mag_T1);
%TODO: say input ripple is 20%? 
atten_T1 = 20./(1 + mag_T1);

[mag_T3, ~] = bode(T_type3, w);
mag_T3 = squeeze(mag_T3);
atten_T3 = 20./(1 + mag_T3);

loglog(f, atten_T1, 'b', 'LineWidth', 1); hold on;
loglog(f, atten_T3, 'r', 'LineWidth', 1, 'LineStyle', '--');
grid on;
title('Ripple Attenuation vs. Frequency');
xlabel('Frequency (Hz)');
ylabel('Output Ripple / Input Ripple (%)');
legend('Type 1 Controller', 'Type 3 Controller');
line([100 100], [1e-3 1e2], 'Color', 'k', 'LineStyle', '--');
text(110, 1e-3, '100Hz', 'FontSize', 10);


% Initialize variables
ripple_results = zeros(19, 2);  % To store frequency and output ripple values
row = 1;

% Loop through different crossover frequencies
for f_c_type3 = 500:100:50000
    % Crossover frequency conversion
    w_c_type3 = 2*pi*f_c_type3;  % Crossover frequency (rad/s)
    
    % Evaluate filter at new crossover frequency
    [mag_GF_wc3, phase_GF_wc3] = bode(GF, w_c_type3);
    mag_GF_wc3 = squeeze(mag_GF_wc3);
    phase_GF_wc3 = squeeze(phase_GF_wc3);
    
    % Type 3 controller design
    G_type3 = 1/(KMISC*mag_GF_wc3);
    PM_desired = 60;  % Desired phase margin (degrees)
    phase_boost = PM_desired - (180 - 90 + phase_GF_wc3);
    k = (tan(deg2rad(phase_boost/4 + 45)))^2;
    A_type3 = G_type3 * w_c_type3 / k;
    
    % Type 3 controller transfer function
    w_z = w_c_type3/sqrt(k);
    w_p = w_c_type3*sqrt(k);
    num_GC3 = A_type3*[1/w_z^2 2/w_z 1];
    den_GC3 = [1/w_p^2 2/w_p 1 0];
    GC_type3 = tf(num_GC3, den_GC3);
    
    % Type 3 loop gain
    T_type3 = KMISC * GC_type3 * GF;
    
    [mag_T3_ripple, ~] = bode(T_type3, w_ripple);
    mag_T3_ripple = squeeze(mag_T3_ripple);
    ripple_attenuation_type3 = 1/(1 + mag_T3_ripple);
    output_ripple_type3 = 0.2 * ripple_attenuation_type3;  % Assuming 20% input ripple
    
    % Store results
    ripple_results(row, :) = [f_c_type3, output_ripple_type3];
    
    % Print results
    %fprintf('f_c_type3 = %d Hz, output_ripple_type3 = %.6f\n', f_c_type3, output_ripple_type3);
    
    row = row + 1;
end

% Optional: Plot the results
figure;
plot(ripple_results(:,1), ripple_results(:,2), 'b-o');
grid on;
xlabel('Crossover Frequency f_{c_{type3}} (Hz)');
ylabel('Output Ripple');
title('Output Ripple vs. Crossover Frequency');




figure;
alphadiff = 1:1:50;
alphaarr = 0.01:0.01:0.5;
for i = 1:50
    KPWM = dMAX/(VB-VA);  % PWM gain
    KMISC = (i/100)*KPWM*VS0*n;  % Miscellaneous gain
      
    % Type 3 controller transfer function
    w_z = w_c_type3/sqrt(k);
    w_p = w_c_type3*sqrt(k);
    num_GC3 = A_type3*[1/w_z^2 2/w_z 1];
    den_GC3 = [1/w_p^2 2/w_p 1 0];
    GC_type3 = tf(num_GC3, den_GC3);
    
    % Type 3 loop gain
    T_type3 = KMISC * GC_type3 * GF;
    [mag_T3, ~] = bode(T_type3, w);
    mag_T3 = squeeze(mag_T3);
    atten_T3 = 20./(1 + mag_T3);

    % loglog(f, atten_T3, 'r');
    % grid on;
    % title('Ripple Attenuation vs. Frequency');
    % xlabel('Frequency (Hz)');
    % ylabel('Output Ripple / Input Ripple');
    % legend('Type 1 Controller', 'Type 3 Controller');
    % line([100 100], [1e-2 1e2], 'Color', 'k', 'LineStyle', '--');

    [mag_T3_ripple, ~] = bode(T_type3, w_ripple);
    mag_T3_ripple = squeeze(mag_T3_ripple);
    ripple_attenuation_type3 = 1/(1 + mag_T3_ripple);
    output_ripple_type3 = 0.2 * ripple_attenuation_type3;  % Assuming 20% input ripple
    alphadiff(i) = output_ripple_type3;
end

plot(alphaarr, alphadiff, '-o',color='k');
xlabel("\alpha");
ylabel("Output Ripple");


figure;
wcc = 0.001:0.001:1;
wcc_ans = linspace(1, 1, 1000);
pmt1 = linspace(1,1,1000);

for i = 1:1000
    % Type 1 controller analysis
    f_c_type1 = i * 0.001 * f_res;        % Crossover frequency (Hz)
    w_c_type1 = 2*pi*f_c_type1;  % Crossover frequency (rad/s)
    
    % Evaluate filter at crossover frequency
    [mag_GF_wc1, phase_GF_wc1] = bode(GF, w_c_type1);
    mag_GF_wc1 = squeeze(mag_GF_wc1);
    phase_GF_wc1 = squeeze(phase_GF_wc1);
    
    % Type 1 controller design
    G_type1 = 1/(KMISC*mag_GF_wc1);
    A_type1 = G_type1 * w_c_type1;
    GC_type1 = tf(A_type1, [1 0]);  % A/s
    
    % Type 1 loop gain
    T_type1 = KMISC * GC_type1 * GF;

    % Calculate ripple attenuation
    [mag_T1_ripple, ~] = bode(T_type1, w_ripple);
    mag_T1_ripple = squeeze(mag_T1_ripple);
    ripple_attenuation_type1 = 1/(1 + mag_T1_ripple);
    output_ripple_type1 = 0.2 * ripple_attenuation_type1;  %TODO: Assuming 20% input ripple
    wcc_ans(i) = output_ripple_type1;
    [GM1, PM1] = margin(T_type1);
    pmt1(i) = PM1;
end

plot(wcc, wcc_ans);
% 
% figure;
% plot(wcc, pmt1);
% xlabel("Factor \lambda",fontname="Arial");
% ylabel("Phase Margin (˚)", fontname="Arial");
% grid on;

figure;
ndiff = 1:1:17;
narr = 6/7:0.5/7:14/7;
for i = narr
    KPWM = dMAX/(VB-VA);  % PWM gain
    KMISC = (narr)*KPWM*VS0*0.25;  % Miscellaneous gain
      
    % Type 3 controller transfer function
    w_z = w_c_type3/sqrt(k);
    w_p = w_c_type3*sqrt(k);
    num_GC3 = A_type3*[1/w_z^2 2/w_z 1];
    den_GC3 = [1/w_p^2 2/w_p 1 0];
    GC_type3 = tf(num_GC3, den_GC3);
    
    % Type 3 loop gain
    T_type3 = KMISC * GC_type3 * GF;
    [mag_T3, ~] = bode(T_type3, w);
    mag_T3 = squeeze(mag_T3);
    atten_T3 = 20./(1 + mag_T3);

    % loglog(f, atten_T3, 'r');
    % grid on;
    % title('Ripple Attenuation vs. Frequency');
    % xlabel('Frequency (Hz)');
    % ylabel('Output Ripple / Input Ripple');
    % legend('Type 1 Controller', 'Type 3 Controller');
    % line([100 100], [1e-2 1e2], 'Color', 'k', 'LineStyle', '--');

    [mag_T3_ripple, ~] = bode(T_type3, w_ripple);
    mag_T3_ripple = squeeze(mag_T3_ripple);
    ripple_attenuation_type3 = 1./(1 + mag_T3_ripple);
    output_ripple_type3 = 0.2 * ripple_attenuation_type3;  % Assuming 20% input ripple
end

plot(narr, output_ripple_type3, '-o',color='k');
xlabel("Turns Ratio \it{n}");
ylabel("Output Ripple");


