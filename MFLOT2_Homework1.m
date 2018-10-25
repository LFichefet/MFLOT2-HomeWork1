close all;
clc on;
%Donn�e:
b = 50e-3; % largeur de la conduite [m]
d_e = 15e-3; % hauteur de la sortie de la conduite [m]
h_e = 0.5*d_e; % [m]
d_t = 6e-3; % hauteur de la gorge [m]
h_t = 0.5*d_t; % [m]
L_c = 30e-3; % longueur partie convergente [m]
L_d = 90e-3; % longueur partie divergente [m]
L = 270e-3; % longueur conduite [m]
alpha = 3.25*pi/180; % angle de pente divergente [rad]
r1 = 254.3e-3; % rayon de courbure de la gorge [m] 
r2 = 153.7e-3; % rayon de courbure fin de divergente [m]
X = linspace(0,0.39,10000);
H = zeros(1,10000);
X_p1 = L_c + r1/( sqrt( 1/(tan(alpha))^2 -1 ) );

X_p2 = L_c + L_d - r2/( sqrt( 1/(tan(alpha))^2 +1 ) );

for i=1:length(X)
    if X(i)<=X_p1
        H(i) = h_t + r1 - sqrt( (r1)^2 - (X(i) - L_c)^2 );
    elseif X(i)<=X_p2 && X(i)>X_p1
        H(i) = 0.05748375*X(i) + 0.85568e-3;
    elseif X(i)<=0.12 && X(i)>X_p2
        H(i) = h_e - r2 + sqrt( (r2)^2 - (X(i) -L_c -L_d)^2);
    else
        H(i) = h_e;
    end
end

figure
plot(X,H)
grid on
xlim([0 0.12])
ylim([0 8e-3])
%line([X_p2 X_p2],[3e-3 7.5e-3])
%line([X_p1 X_p1],[3e-3 7.5e-3])


