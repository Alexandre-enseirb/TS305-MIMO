function C_hat = Alamouti_decode_ML(Y, H, A, ~)

h1 = H(:,1);
h2 = H(:,2);
y1 = Y(:,1);
y2 = Y(:,2);

z1 = h1'*y1 + y2'*h2;
z2 = h2'*y1 - y2'*h1;

H_norm_fro2 = sum(abs(H(:)).^2);
[~, ind_min_1] = min(abs(z1 - H_norm_fro2 * A).^2);
[~, ind_min_2] = min(abs(z2 - H_norm_fro2 * A).^2);

C_hat = [A(ind_min_1), A(ind_min_2)];

end
