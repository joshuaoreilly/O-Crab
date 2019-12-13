function varargout = CAD(varargin)
clc;
addpath(genpath('functions'));
% CAD MATLAB code for CAD.fig
%      CAD, by itself, creates a new CAD or raises the existing
%      singleton*.
%
%      H = CAD returns the handle to a new CAD or the handle to
%      the existing singleton*.
%
%      CAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAD.M with the given input arguments.
%
%      CAD('Property','Value',...) creates a new CAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CAD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CAD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CAD

% Last Modified by GUIDE v2.5 05-Dec-2019 09:45:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CAD_OpeningFcn, ...
                   'gui_OutputFcn',  @CAD_OutputFcn, ...
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


% --- Executes just before CAD is made visible.
function CAD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CAD (see VARARGIN)

% Choose default command line output for CAD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%addpath('functions\leg_geometry');
% UIWAIT makes CAD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CAD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit1, 'String', (get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit2, 'String', (get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit3, 'String', (get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit4, 'String', (get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit5, 'String', (get(hObject,'Value')));

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
if(isnan(str2double(get(hObject,'String'))))
    set(handles.slider1, 'Value', get(handles.slider1, 'Min'));
    set(hObject, 'String', get(handles.slider1, 'Min'));
elseif (str2double(get(hObject,'String'))>get(handles.slider1, 'Max'))
    set(handles.slider1, 'Value', get(handles.slider1, 'Max'));
    set(hObject, 'String', get(handles.slider1, 'Max'));
elseif (str2double(get(hObject,'String'))<get(handles.slider1, 'Min')) 
    set(handles.slider1, 'Value', get(handles.slider1, 'Min'));
    set(hObject, 'String', get(handles.slider1, 'Min'));
else
    set(handles.slider1, 'Value', str2double(get(hObject,'String')));
end




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
if(isnan(str2double(get(hObject,'String'))))
    set(handles.slider2, 'Value', get(handles.slider2, 'Min'));
    set(hObject, 'String', get(handles.slider1, 'Min'));
elseif (str2double(get(hObject,'String'))>get(handles.slider2, 'Max'))
    set(handles.slider2, 'Value', get(handles.slider2, 'Max'));
    set(hObject, 'String', get(handles.slider2, 'Max'));
elseif (str2double(get(hObject,'String'))<get(handles.slider2, 'Min')) 
    set(handles.slider2, 'Value', get(handles.slider2, 'Min'));
    set(hObject, 'String', get(handles.slider1, 'Min'));
else
    set(handles.slider2, 'Value', str2double(get(hObject,'String')));
end

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
if(isnan(str2double(get(hObject,'String'))))
    set(handles.slider3, 'Value', get(handles.slider3, 'Min'));
    set(hObject, 'String', get(handles.slider3, 'Min'));
elseif (str2double(get(hObject,'String'))>get(handles.slider3, 'Max'))
    set(handles.slider3, 'Value', get(handles.slider3, 'Max'));
    set(hObject, 'String', get(handles.slider3, 'Max'));
elseif (str2double(get(hObject,'String'))<get(handles.slider3, 'Min')) 
    set(handles.slider3, 'Value', get(handles.slider3, 'Min'));
    set(hObject, 'String', get(handles.slider3, 'Min'));
else
    set(handles.slider3, 'Value', str2double(get(hObject,'String')));
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
if(isnan(str2double(get(hObject,'String'))))
    set(handles.slider4, 'Value', get(handles.slider4, 'Min'));
    set(hObject, 'String', get(handles.slider4, 'Min'));
elseif (str2double(get(hObject,'String'))>get(handles.slider4, 'Max'))
    set(handles.slider4, 'Value', get(handles.slider4, 'Max'));
    set(hObject, 'String', get(handles.slider4, 'Max'));
elseif (str2double(get(hObject,'String'))<get(handles.slider4, 'Min')) 
    set(handles.slider4, 'Value', get(handles.slider4, 'Min'));
    set(hObject, 'String', get(handles.slider4, 'Min'));
else
    set(handles.slider4, 'Value', str2double(get(hObject,'String')));
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
if(isnan(str2double(get(hObject,'String'))))
    set(handles.slider5, 'Value', get(handles.slider5, 'Min'));
    set(hObject, 'String', get(handles.slider5, 'Min'));
elseif (str2double(get(hObject,'String'))>get(handles.slider5, 'Max'))
    set(handles.slider5, 'Value', get(handles.slider5, 'Max'));
    set(hObject, 'String', get(handles.slider5, 'Max'));
elseif (str2double(get(hObject,'String'))<get(handles.slider5, 'Min')) 
    set(handles.slider5, 'Value', get(handles.slider5, 'Min'));
    set(hObject, 'String', get(handles.slider5, 'Min'));
else
    set(handles.slider5, 'Value', str2double(get(hObject,'String')));
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% (1) Litter Weight, (2) Litter Size, (3) Operating Days, (4) Leg Reach X,
% (5) Leg Reach Y

set(hObject, 'Enable', 'off')
drawnow;
set(handles.text13, 'String', "Current Status: Computing...")
drawnow;
main(get(handles.slider1, 'Value'),get(handles.slider2, 'Value'), get(handles.slider4, 'Value'), get(handles.slider5, 'Value'));
set(handles.text13, 'String', "Current Status: Compute Complete")
set(hObject,'String', "Compute Again!");
set(hObject, 'Enable', 'on')
drawnow;



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns calle
% Hint: place code in OpeningFcn to populate axes1
imshow('functions\Picture\Capture.PNG', 'Parent', hObject);


% --- Executes on button press in outputLog.
function outputLog_Callback(hObject, eventdata, handles)
% hObject    handle to outputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
