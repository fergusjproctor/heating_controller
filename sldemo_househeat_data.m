% HOUSEHEAT_DATA_ADAPTED
% Initialization script for the updated house heat model (aerotermia version)
% Units: SI (meters, seconds, Kelvin, Joules)

% -------------------------------
% Define house geometry
% -------------------------------
lenHouse = 9;   % m
widHouse = 9;   % m
htHouse = 6;    % m

% Window configuration
numWindows = 6;
htWindows = 1.2; % m
widWindows = 2;  % m
windowArea = numWindows * htWindows * widWindows; % m²

% Wall area (subtracting windows)
wallArea = 2 * lenHouse * htHouse + 2 * widHouse * htHouse - windowArea; % m²

% Roof area (flat roof)
roofArea = lenHouse * widHouse; % m²

% -------------------------------
% Thermal properties
% -------------------------------
% Brick cavity wall (2 x 0.125 m bricks + 0.05 m air gap)
% R = sum of layers

% Brick layer
L_brick = 0.125; % m
k_brick = 0.72;  % W/m·K
R_brick = L_brick / k_brick; % K·m²/W

% Air gap
L_air = 0.05; % m
k_air = 0.026; % W/m·K
R_airgap = L_air / k_air; % K·m²/W

% Total wall R per m²
R_wall_per_m2 = 2 * R_brick + R_airgap;
U_wall = 1 / R_wall_per_m2; % W/m²K

% Windows (single glazing)
U_window = 5.5; % W/m²K

% Roof (moderately insulated)
U_roof = 0.8; % W/m²K

% -------------------------------
% Total conductances
% -------------------------------
G_walls = U_wall * wallArea;       % W/K
G_windows = U_window * windowArea; % W/K
G_roof = U_roof * roofArea;        % W/K

G_total = G_walls + G_windows + G_roof; % W/K
R0 = 1 / G_total;  % Overall thermal resistance (K/W)

% -------------------------------
% Air thermal mass
% -------------------------------
densAir = 1.225; % kg/m³
M_air = lenHouse * widHouse * htHouse * densAir; % kg

% Air specific heat
c_air = 1005.4; % J/kg·K

% -------------------------------
% Wall thermal mass (thermal inertia)
% -------------------------------
Mbrick = 500 * wallArea; % kg (approx. 500 kg/m² for brick)
cbrick = 850;            % J/kg·K (brick specific heat)

% -------------------------------
% Heater properties (aerotermia)
% -------------------------------
QAerotermia = 14000; % W (thermal power)

% -------------------------------
% Electricity cost parameters
% -------------------------------
% Electricity price: 0.25 €/kWh → €/J
cost = 0.25 / 3.6e6; % €/J

% -------------------------------
% Initial conditions
% -------------------------------
TinIC = 20; % °C (initial indoor temperature)

% -------------------------------
% Constants for radiation (optional nonlinear effects)
% -------------------------------
sigma = 5.670374419e-8;  % W/m²·K^4 (Stefan-Boltzmann)
epsilon = 0.9;           % surface emissivity

% -------------------------------
% Optional: sensitivity of resistance to temperature (nonlinear effects)
% -------------------------------
alpha = 0.01; % (dimensionless modifier)