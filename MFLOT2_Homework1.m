close all;
clc on;
%Donnee:
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

%%%%% Modelisation Geometry nozzle %%%%%

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
% plot nozzle
figure
plot(X,H)
grid on
xlim([0 0.12])
ylim([0 8e-3])

%%%%% Calcul %%%%%

%Donnees 
T0 = 300; % [K]
pa = 1.01325; % [bar]
At = 3e-3 * b; % [m^2]
Ae = b * h_e; %[m^2]
Mt = 1;
S = 111; %[K]
Tref = 273.15; %[K]
muref = 1.716e-5; %[Ns/m^2]
R = 287.1;
gamma = 1.4;
 


function [lambda] = iterativeFriction(lambda_init , Re_d)
    x = lambda_init;
    f = @(lambda)(-3.0*log10(2.03*lambda/Re_d))
    epsilon = 1; % difference entre f(i+1) et f(i)
    
    while (epsilon > 0.001) % Precision 1e-3
        y = f(x)
        epsilon = abs(y - x)
        x = y
    end
    
    lambda = x;
end

function [Mx] = iterativeMackNumber(M_init , At , Ax , mode)
    % Constantes
    gamma = 1.4;
    epsilon = 0.001;
    x = M_init;
    
    % Choix d'equation selon supersonique ou subsonique
    if mode == 'subsonic'
        f = @(M)( At/Ax *( ((gamma+1)/2) / (1 + (gamma-1)/2 * M^2) )^((-gamma+1)/(2*gamma - 2)) )
    elseif mode == 'supersonic'
        f = @(M)( sqrt( 2/(gamma-1) * ((gamma+1)/2 * (At/(Ax*M))^((-2*gamma-2)/(gamma+1)) - 1) ) )       
    else
        error('ERROR : wrong parameter "mode" given to the function');
    end
    
    % Boucle iterative
    while (epsilon > 0.001) % Precision 1e-3
        y = f(x)
        epsilon = abs(y - x)
        x = y
    end
    
    % Renvoi de valeur
    Mx = x;
end
