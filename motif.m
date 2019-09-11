function [Guardar_Estructura] = motif(Datos,Tm,Ventana,Rafaga,Umbral)

%% La funcion 'motif' esta constituida por dos pasos.
%Paso 1: Determina el numero de actividad en rafagas presentes en ventanas
%de tiempo especificadas por el usuario (en milisegundos).
%Paso 2: Determina la correlacion "R" entre ventanas de tiempo especificada
%por el usuario (en milisegundos) dentro de las rafagas.  
%% Especificaciones de las entradas: 
% Datos -> Matriz de mXn donde m = numero de canales y n = tiempo (en milisegundos)
% Tm -> Tasa de muestreo en Hz.
% Ventana-> Ventana de tiempo (en milisegundos) que dura el motif.
% Rafaga -> Ventana de tiempo (en milisegundos) que dura la actividad en rafaga.
% Umbral -> Determinado por desviaciones estandar.
%% Especificaciones de la salida.
%Variable struct que contiene las matrices con los coefficientes de correlacion "R".
%en donde el campo 'n' corresponde al canal 'n'.


%% Creada por: Moisés Altamira Camacho. 24 de Agosto de 2019


%% Paso 1.
for n = 1:length(Datos(:,1)); %Determinar el numero de canales presentes en la matriz
   
   A = Datos(n,:);
   A(end) = 0; % La funcion no acepta valores difeentes de cero en el ultimo valor.
    
    SD = std(A)*Umbral; % Numero de Desviacion Estandar
    TamanoVentana = ((Ventana*Tm)/1000); % Determina el tamano de la ventana en miliseguntos
    TamanoRafaga = ((Rafaga*Tm)/1000)-1; % Determina el tamano de la rafaga en miliseguntos. Aqui, la ventana es -1 ya que en el ciclo la ventana es +1.
    RafagasConc = NaN(1,length(A));
    c = 1:length(A); % Vector de posicion que senala
    NumRafagas = 0;
    
    for i = 1:length(A) 
        p = c(i);
        if A(p) >= SD;
            RafagasConc(p:p+(TamanoRafaga)) = A(p:p+(TamanoRafaga));
            c(i:length(A)) = c(i:length(A))+(TamanoRafaga);
            NumRafagas = NumRafagas + 1; % Contador de numero de Rafagas (Numero de veces que entra al ciclo)
            
        elseif p == length(A);
            
            break
            
        end
        
    end
    
    %% Paso 2.
    
    siNaN = isnan(RafagasConc);
    RafagasConc(siNaN)=[];              % Concatenar Rafagas
    RafagasConc = RafagasConc';
    
    TotalCorrelaciones = length(RafagasConc)/TamanoVentana;
    Coeficiente_R = zeros(TotalCorrelaciones,TotalCorrelaciones);
     
    % Vectores de posicion.
    ini_ventana = 1:TamanoVentana:length(RafagasConc);               
    fin_ventana = TamanoVentana:TamanoVentana:length(RafagasConc);
    
    for i = 1:length(RafagasConc)/TamanoVentana
        
        ventana = RafagasConc(ini_ventana(i):fin_ventana(i)); 
        
        for j = 1:TotalCorrelaciones;
            
            r = corr(ventana, RafagasConc(ini_ventana(j):fin_ventana(j)));
            Coeficiente_R(j,i) = r;
            
        end
        
    end
    
    Guardar_Estructura(n).Coeficiente_R = Coeficiente_R; % La variable de salida se guarda en un struct.
    
     
    
end

 end




