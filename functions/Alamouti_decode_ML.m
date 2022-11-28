function C_hat = Alamouti_decode_ML(Y, H, A)

h1 = H(:,1);
h2 = H(:,2);
y1 = Y(:,1);
y2 = Y(:,2);

z1 = h1'*y1 + y2'*h2;
z2 = h2'*y1 - y2'*h1;


end
