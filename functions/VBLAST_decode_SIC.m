function Y_SIC = VBLAST_decode_SIC(Y, H, A)
%VBLAST_DECODE_SIC decode les observations Y par la methode des annulations
%successives des interferences (SIC) par rapport a la matrice du canal H et
%a l'alphabet A.

% -- parametres
[N,L] = size(Y);
[~,M] = size(H);

if M<N
    error("Le decodeur SIC ne fonctionne que pour M >= N");
end

% -- decomposition QR de H
[Q,R] = qr(H);

% -- decodage
Z = Q'*Y;
Y_SIC = zeros(size(Z));
 
% init

[~, Y_SIC(N,:)] = min(abs(Z(N,:)-R(N,N)*A).^2);

% loop

for l=1:L
    sum_rx = R(N-1,N)*A(Y_SIC(N,l));
    for n=N-1:-1:1
        [~, Y_SIC(n,l)] = min(abs(Z(n,l) - sum_rx - R(n,n)*A).^2);
        if n>1 % failsafe
            sum_rx = sum_rx + R(n-1,n)*A(Y_SIC(n,l));
        end
    end
end

%{
for n=N-1:-1:1
    for l=1:L
        Z_diff = min(abs(Z(n,l) - R(n,n+1:end)*Y_SIC(n+1:end,l) - R(n,n)*A).^2);
        [X_hat(n,l), Y_SIC(n,l)] = min(Z_diff);
    end
end
%}

% compensation de l'indice matlab
Y_SIC = Y_SIC - ones(size(Y_SIC));


end
