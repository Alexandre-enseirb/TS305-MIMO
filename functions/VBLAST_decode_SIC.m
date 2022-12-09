function Y_SIC = VBLAST_decode_SIC(Y, H, A, ~)
%VBLAST_DECODE_SIC decode les observations Y par la methode des annulations
%successives des interferences (SIC) par rapport a la matrice du canal H et
%a l'alphabet A.

% -- Parametres
[N,L] = size(Y);
[~,M] = size(H);

if M<N
    error("Le decodeur SIC ne fonctionne que pour M >= N");
end

% -- Decomposition QR de H
[Q,R] = qr(H);

% -- Decodage
Z = Q'*Y;
Y_SIC = zeros(size(Z));
 
% Init
[~, Y_SIC(N,:)] = min(abs(Z(N,:)-R(N,N)*A).^2);

% Boucle principale
for l=1:L
    sum_rx = R(N-1,N)*A(Y_SIC(N,l));
    for n=N-1:-1:1
        [~, Y_SIC(n,l)] = min(abs(Z(n,l) - sum_rx - R(n,n)*A).^2);
        if n>1 % failsafe
            sum_rx = sum_rx + R(n-1,n)*A(Y_SIC(n,l));
        end
    end
end

% récupération des symboles
Y_SIC = A(Y_SIC);

end
