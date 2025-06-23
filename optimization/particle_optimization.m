%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPTIMIZACIÓN DE CONTROLADOR PID PARA SISTEMA DE CALEFACCIÓN DOMÉSTICO
%
% Descripción:
% Este script optimiza los parámetros PID (Kp, Ki, Kd) de un modelo
% térmico de vivienda en Simulink, buscando minimizar la desviación de 
% temperatura respecto al setpoint y el coste energético.
%
% Método:
% - Optimización global por Particle Swarm (particleswarm)
% - Se ejecuta el modelo de Simulink en cada iteración
% - Se lee logsout para obtener Tindoors y HeatCost
% - Se calcula una función de coste compuesta
%
% Notas:
% - El modelo debe llamarse 'HouseModel'
% - Las señales 'Tindoors' y 'HeatCost' deben estar loggeadas
% - Solver en modo Fixed-step (ej. ode4), dt conocido
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Límites de búsqueda de parámetros PID
lb = [0, 0, 0];      % Límite inferior: Kp, Ki, Kd
ub = [14000, 1000, 0];   % Límite superior: limitamos Kd para estabilidad

% Opciones del optimizador
opts = optimoptions('particleswarm',...
    'Display','iter',...
    'SwarmSize',20,...
    'MaxIterations',10);

% Llamada al optimizador
bestPID = particleswarm(@pid_cost_function, 3, lb, ub, opts);

% Mostramos resultados
disp('Mejores parámetros PID encontrados:');
disp(['Kp: ', num2str(bestPID(1))]);
disp(['Ki: ', num2str(bestPID(2))]);
disp(['Kd: ', num2str(bestPID(3))]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCIÓN DE COSTE INTERNA (nested function)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function J = pid_cost_function(params)

    % Extraemos parámetros PID desde el vector de optimización
    Kp = params(1);
    Ki = params(2);
    Kd = params(3);

    % Asignamos al workspace (Simulink toma los valores desde aquí)
    assignin('base','Kp',Kp);
    assignin('base','Ki',Ki);
    assignin('base','Kd',Kd);

    % Ejecutamos la simulación de Simulink
    simOut = sim('sldemo_househeat_non_linear','ReturnWorkspaceOutputs','on');

    % Leemos logsout para obtener señales loggeadas
    logs = simOut.get('logsout');
    T_in = logs.get('Tindoors').Values.Data;
    Q_heater = logs.get('HeatCost').Values.Data;

    % Parámetros de la función de coste
    T_set = 19;      % Setpoint de temperatura (ºC)
    dt = 60;           % Fixed-step de la simulación (segundos)
    w1 = 1;            % Peso de confort térmico
    w2 = 0.0001;       % Peso de coste energético

    % Error térmico acumulado (ISE)
    J_temp = sum((T_in - T_set).^2) * dt;

    % Energía total consumida (o coste energético)
    J_energy = sum(Q_heater) * dt;

    % Función de coste total
    J = w1 * J_temp + w2 * J_energy;

end 