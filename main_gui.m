function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      Manually registration between Nuance and H&E images
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%      
%     
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 21-Feb-2018 14:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% Choose default command line output for main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LOAD_putshbutton.
function LOAD_putshbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD_putshbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image 
[filename1 filepath]=uigetfile('*.*','please choose a Nuance image');%filename?????filepath?????  
image{1}=imread(strcat(filepath,filename1));
str1=[filepath filename1];      %????????
set( handles.edit1,'String',str1);   % ??????????????
[filename2 filepath]=uigetfile('*.*','please choose a H&E image');%filename?????filepath?????  
image{2}=imread(strcat(filepath,filename2));
str2=[filepath filename2];    
set( handles.edit2,'String',str2);  



 



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global aerial_registered
[filename, pathname]=...
     uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tif'},'choose image pathway');
%combination and file name
str = [pathname filename];
if (filename~=0)
imwrite(aerial_registered,str);
else
    return 
end


% --- Executes on button press in cpselect_pushbutton.
function cpselect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cpselect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image
global movingPoints fixedPoints
[movingPoints,fixedPoints] = cpselect(image{1},image{2},'Wait',true);
fix = image{2};
remove = image{1};
% imshowpair(fix,remove,'blend');
t_concord = fitgeotrans(fixedPoints,movingPoints,'projective');
remove_ref = imref2d(size(remove)); %relate intrinsic and world coordinates
global aerial_registered
aerial_registered = imwarp(fix,t_concord,'OutputView',remove_ref);
axes(handles.axes1);
imshow(aerial_registered);
axes(handles.axes2);
imshowpair(aerial_registered,remove,'blend')


% --- Executes on button press in Savepoint_pushbutton.
function Savepoint_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savepoint_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename, foldername] = uiputfile('Where do you want the file saved?');
% complete_name = fullfile(foldername, filename);
global movingPoints fixedPoints
% save(complete_name, movingPoints fixedPoints); 
[filename ,pathname]=uiputfile({'*.mat','MAT-files(*.mat)'},'Where do you want the file saved?');
str=strcat(pathname,filename);
save(char(str), 'movingPoints', 'fixedPoints');
