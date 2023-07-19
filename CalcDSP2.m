function [f,S] = CalcDSP2(sig,fe)
    L = length(sig);
    NFFT = L;
    SIG = fft(sig,NFFT)/(L/2);
    SIG(1) = SIG(1)/2;
    S = abs(SIG(1:NFFT/2+1));
    f = fe/2 * linspace(0,1,NFFT/2+1);
    
    % Identifică banda de frecvențe cu cea mai mare putere spectrală
    [~, max_index] = max(S);
    max_fr = f(max_index);
    if max_fr >= 30
        fprintf('Semnalul se încadrează în banda Gamma (peste 30 Hz).\n');
    elseif max_fr >= 12
        fprintf('Semnalul se încadrează în banda Beta (12 - 30 Hz).\n');
    elseif max_fr >= 8
        fprintf('Semnalul se încadrează în banda Alfa (8 - 12 Hz).\n');
    elseif max_fr >= 4
        fprintf('Semnalul se încadrează în banda Theta (4 - 8 Hz).\n');
    else
        fprintf('Semnalul se încadrează în banda Delta (0,5 - 4 Hz).\n');
    end
end


