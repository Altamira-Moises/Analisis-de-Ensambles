function varargout = Reduccion_Dimensiones(varargin)
% REDUCCION_DIMENSIONES MATLAB code for Reduccion_Dimensiones.fig
%      REDUCCION_DIMENSIONES, by itself, creates a new REDUCCION_DIMENSIONES or raises the existing
%      singleton*.
%
%      H = REDUCCION_DIMENSIONES returns the handle to a new REDUCCION_DIMENSIONES or the handle to
%      the existing singleton*.
%
%      REDUCCION_DIMENSIONES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REDUCCION_DIMENSIONES.M with the given input arguments.
%
%      REDUCCION_DIMENSIONES('Property','Value',...) creates a new REDUCCION_DIMENSIONES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reduccion_Dimensiones_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reduccion_Dimensiones_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reduccion_Dimensiones

% Last Modified by GUIDE v2.5 13-Sep-2019 15:01:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reduccion_Dimensiones_OpeningFcn, ...
                   'gui_OutputFcn',  @Reduccion_Dimensiones_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Reduccion_Dimensiones is made visible.
function Reduccion_Dimensiones_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reduccion_Dimensiones (see VARARGIN)

% Choose default command line output for Reduccion_Dimensiones
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reduccion_Dimensiones wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Reduccion_Dimensiones_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Examinar_button.
function Examinar_button_Callback(hObject, eventdata, handles)
% hObject    handle to Examinar_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.mat'});
 dat_archivo = strcat(PathName,FileName);
 Datos = importdata(dat_archivo);
 set(handles.Examinar_button,'UserData',Datos)

 % --- Executes on button press in PCAbutton.
function PCAbutton_Callback(hObject, eventdata, handles)
% hObject    handle to PCAbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% modo = get(handles.Dimensiones_button,'UserData');
Datos = get(handles.Examinar_button,'UserData');
Datos = Datos';

figure(1)

   [coeff,DatosPCA,latent] = pca(Datos);
    
    plot3(DatosPCA(:,1),DatosPCA(:,2),DatosPCA(:,3),'o');
    axis('equal')
    xlabel('PCA1'),ylabel('PCA2'),zlabel('PCA3')
    set(handles.PCAbutton,'UserData',DatosPCA)
    
    % --- Executes on button press in tSNEbutton.
function tSNEbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tSNEbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Datos = get(handles.Examinar_button,'UserData');
Datos = Datos';

% rng('default') % for fair comparison

for i = 1:size(Datos,1)
  
    vector{i,1} = 'vector';
    
    
end
% figure(1)
% group = 1:size(Datos,1)';
 Y = tsne(Datos);%,'Algorithm','exact','Distance','cosine');
% gscatter(Y(:,1),Y(:,2),group)
% title('Cosine')

 figure(1)
idx = kmeans(Y(:,1:2),2);
% colores = [1 1 0; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 1; 0 0 0]; %[138 43 226; 64 224 208; 220 20 60;1 0 0]./255; %???? porque entre 255
colores = rand(100,3);
for n=1: size(Y,1)
    plot(Y(n,1),Y(n,2),'o','color',colores(idx(n),:));
    hold on
%  set(h,'markerfacecolor',colores(idx(n),:))
end

    

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in kmeansbutton.
function kmeansbutton_Callback(hObject, eventdata, handles)
% hObject    handle to kmeansbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.kmeansbutton,'UserData');
DatosPCA1 = get(handles.PCAbutton,'UserData');

idx = kmeans(DatosPCA1(:,1:2),2); % El ultimo numero define el numero de grupos
colores = rand(size(DatosPCA1,1),3);
for n=1: size(DatosPCA1,1)
    Grafico = plot3(DatosPCA1(n,1),DatosPCA1(n,2),DatosPCA1(n,3),'o','color',colores(idx(n),:));
    hold on
%     set(h,'markerfacecolor',colores(idx(n),:))
 end
% set(handles.kmeansbutton,'UserData',Grafico);
% Graff = get(handles.kmeansbutton,'UserData',Grafico);
% savefig
