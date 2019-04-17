%%%%%%%%%%%%%%%%%%%%%%%%%%%% data load %%%%%%%%%%%%%%%%%%%%%%%%%%
filename = '../data/kerch_2019_baranova/s1/right2.txt';
[timeScale_min, signal] = textread(filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% --------- %%%%%%%%%%%%%%%%%%%%%%%%%%

calcWavelet = 1;
calcPower = 0;
calcEnergy = 0;

drawMareogramm = 0;
drawWavelet = 1;
drawPower = 0;
drawEnergy = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% defines %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dt = 20;
% dt = 0.47715779549155738407474072169367;
dt = 60;
timeScale_min = dt * (0:1:length(signal)-1) / 60;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ------- %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% mareogramm %%%%%%%%%%%%%%%%%%%%%%%%%%%
if drawMareogramm
    plot_mareogramm(timeScale_min, signal', 40, 34);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% ---------- %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% power %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if calcPower
    windowLength = 301;
    signal2 = signal .^ 2;
    iPower = conv(signal2, hamming(windowLength)/sum(timeScale_min));
    iPower = iPower( (windowLength-1)/2+1 : length(iPower)-(windowLength-1)/2 );
    if drawPower
        plot_iPower(timeScale_min, iPower, 40, 34);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ------- %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% wavelet %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if calcWavelet
    seconds = 3600;
    % ����� �������� � �����
    filterQ = 200;
    % ������������ �������
    maxCpH = 8;
    % ������������� ������: �� 0 �� N ������ � ���
    f0 = linspace(0.1 / seconds, maxCpH / seconds, filterQ);
    % ������ ����������� ��������: ��� ���� - �������� ����������� �������
    df = 0.25 * f0;
    % ������ �����������
    filterBank = cgau_fb(f0, df, 4);

    frequencyScale_cph = seconds * ((f0 / dt) / 2);
    % frequencyScale_cph = seconds * f0;
    intensity = firfb_proc(filterBank, signal');

    if drawWavelet
        plot_wavelet(timeScale_min, frequencyScale_cph, intensity, 0.1, 40, 34);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ------- %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% energy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequencyScale_period = 60 / cph;
if calcEnergy
    energy = zeros(1, filterQ);
    for i = 1:length(energy)
        for j = 1:length(signal)
            energy(i) = energy(i) + 20*log10( abs( intensity(i, j) + 0.1 ) ) + 20; % abs(yy(i, j))^2;
        end
    end
    maxAmplitude = length(signal) * 50;

    if drawEnergy
        plot_energy(energy / maxAmplitude, frequencyScale_cph, 0.1, 40, 34);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ----- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%