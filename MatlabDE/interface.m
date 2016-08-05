function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 05-Aug-2016 00:25:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Global variables %
    handles.cutoffIsValid = 0; handles.cutoff = []; handles.samplesIsValid = 0;
    handles.samples = 0; handles.orderIsValid = 0; handles.order = 0;
    handles.minBIsValid = 0; handles.minB = 0; handles.maxBIsValid = 0; handles.maxB = 0;
    handles.populationIsValid = 0; handles.population = 0; handles.generationsIsValid = 0;
    handles.generations = 0; handles.finalPopIsValid = 0; handles.finalPop = 0;
    handles.fIsValid = 0; handles.f = 0; handles.crIsValid = 0; handles.cr = 0;
    handles.filterType = 0; handles.method = 0;
    handles.filterInputsAreValid = 0; handles.methodInputsAreValid = 0; handles.inputsAreValid = 0;
    handles.filter = DigitalFilter(0, 0); handles.b = []; handles.a = [];
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editCutoff1_Callback(hObject, eventdata, handles)
% hObject    handle to editCutoff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCutoff1 as text
%        str2double(get(hObject,'String')) returns contents of editCutoff1 as a double
    handles = readInputs(handles);
    handles = updateFilter(handles);


% --- Executes during object creation, after setting all properties.
function editCutoff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCutoff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCutoff2_Callback(hObject, eventdata, handles)
% hObject    handle to editCutoff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCutoff2 as text
%        str2double(get(hObject,'String')) returns contents of editCutoff2 as a double
    handles = readInputs(handles);
    handles = updateFilter(handles);


% --- Executes during object creation, after setting all properties.
function editCutoff2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCutoff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuFilterType.
function popupmenuFilterType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuFilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuFilterType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuFilterType
    selected = get(handles.popupmenuFilterType,'Value');
    if(selected > 3)
        set(handles.editCutoff2, 'Visible', 'On');
    else
        set(handles.editCutoff2, 'Visible', 'Off');
    end
    
    handles = readInputs(handles);
    if selected > 1
        handles.filter.cutoff = handles.cutoff;
    end
    
    switch selected
        case 1
            cla(handles.axesFilter,'reset');
            set(handles.axesFilter, 'Visible', 'Off');
        case 2
            handles.filter.lowpass();
        case 3
            handles.filter.highpass();
        case 4
            handles.filter.bandpass();
        case 5
            handles.filter.bandstop();
    end
    
    if selected > 1
        handles = updateFilter(handles);
    end

% --- Executes during object creation, after setting all properties.
function popupmenuFilterType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuFilterType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPopulation_Callback(hObject, eventdata, handles)
% hObject    handle to editPopulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPopulation as text
%        str2double(get(hObject,'String')) returns contents of editPopulation as a double


% --- Executes during object creation, after setting all properties.
function editPopulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPopulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSamples_Callback(hObject, eventdata, handles)
% hObject    handle to editSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSamples as text
%        str2double(get(hObject,'String')) returns contents of editSamples as a double
    handles = readInputs(handles);
    handles = updateFilter(handles);

% --- Executes during object creation, after setting all properties.
function editSamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOrder_Callback(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOrder as text
%        str2double(get(hObject,'String')) returns contents of editOrder as a double
    handles = readInputs(handles);
    handles = updateFilter(handles);

% --- Executes during object creation, after setting all properties.
function editOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuMethod.
function popupmenuMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuMethod
selected = get(handles.popupmenuMethod,'Value');
    if(selected == 6)
        set(handles.editF, 'Visible', 'On');
        set(handles.editCR, 'Visible', 'On');
        set(handles.textF, 'Visible', 'On');
        set(handles.textCR, 'Visible', 'On');
    else
        set(handles.editF, 'Visible', 'Off');
        set(handles.editCR, 'Visible', 'Off');
        set(handles.textF, 'Visible', 'Off');
        set(handles.textCR, 'Visible', 'Off');
    end
    
    if(selected == 2)
        set(handles.editFinalPop, 'Visible', 'On');
        set(handles.textFinalPop, 'Visible', 'On');
    else
        set(handles.editFinalPop, 'Visible', 'Off');
        set(handles.textFinalPop, 'Visible', 'Off');
    end


% --- Executes during object creation, after setting all properties.
function popupmenuMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editArchive_Callback(hObject, eventdata, handles)
% hObject    handle to editArchive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editArchive as text
%        str2double(get(hObject,'String')) returns contents of editArchive as a double


% --- Executes during object creation, after setting all properties.
function editArchive_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editArchive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editGenerations_Callback(hObject, eventdata, handles)
% hObject    handle to editGenerations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGenerations as text
%        str2double(get(hObject,'String')) returns contents of editGenerations as a double


% --- Executes during object creation, after setting all properties.
function editGenerations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGenerations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinB_Callback(hObject, eventdata, handles)
% hObject    handle to editMinB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinB as text
%        str2double(get(hObject,'String')) returns contents of editMinB as a double


% --- Executes during object creation, after setting all properties.
function editMinB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxB_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxB as text
%        str2double(get(hObject,'String')) returns contents of editMaxB as a double


% --- Executes during object creation, after setting all properties.
function editMaxB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editF_Callback(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF as text
%        str2double(get(hObject,'String')) returns contents of editF as a double


% --- Executes during object creation, after setting all properties.
function editF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCR_Callback(hObject, eventdata, handles)
% hObject    handle to editCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCR as text
%        str2double(get(hObject,'String')) returns contents of editCR as a double


% --- Executes during object creation, after setting all properties.
function editCR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonClear.
function pushbuttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.popupmenuFilterType, 'Value', 1);
    set(handles.editCutoff1, 'String', '');
    set(handles.editCutoff2, 'String', '');
    set(handles.editCutoff2, 'String', '');
    set(handles.editSamples, 'String', '');
    set(handles.editOrder, 'String', '');
    set(handles.popupmenuMethod, 'Value', 1);
    set(handles.editMinB, 'String', '');
    set(handles.editMaxB, 'String', '');
    set(handles.editPopulation, 'String', '');
    set(handles.editGenerations, 'String', '');
    set(handles.editF, 'String', '');
    set(handles.editCR, 'String', '');
    set(handles.uitableCoefficients, 'Data', cell(2,4));
    cla(handles.axesFilter,'reset')
    set(handles.axesFilter, 'Visible', 'Off');


% --- Executes on button press in pushbuttonRun.
function pushbuttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = readInputs(handles);
    handles = updateFilter(handles);
    
    if handles.inputsAreValid
        
        D = (handles.order + 1) * 2;
        NP = handles.population;
        Nmin = handles.finalPop;
        n = handles.generations;
        minB = handles.minB;
        maxB = handles.maxB;
        eval = handles.filter.getEval();
        maxASize = NP;
        
        selected = get(handles.popupmenuMethod,'Value');
        tic;
        switch selected
            case 2
                best = LSHADE(D, NP, Nmin, n, minB, maxB, eval, @progress);
            case 3
                best = SHADE(D, NP, n, minB, maxB, maxASize, eval, @progress);
            case 4
                best = JADE(D, NP, n, minB, maxB, maxASize, eval, @progress);
            case 5
                best = LJADE(D, NP, Nmin, n, minB, maxB, eval, @progress);
            case 6
                best = DE(D, NP, n, minB, maxB, 0.85, 0.25, eval, @progress);
        end
        
        handles.b = best(1:(D/2));
        handles.a = best((D/2 +1):end);
        handles = updateFilter(handles);
        coefficients = [handles.b'; handles.a'];
        set(handles.uitableCoefficients, 'data', coefficients);
        
    else
        warndlg('Invalid inputs');
    end
    
    
%     eval = f.getEval;
%     D = (f.order + 1) * 2;
%     n = generations;
%     NP = population;
%     Nmin = finalPopIsValid;
%     maxASize = NP;
%     tic

%     best = LSHADE(D, NP, Nmin, n, -100, 100, eval, @progress);

%     b = best(1:(D/2));
%     a = best((D/2 +1):end);
%     f.b = b;
%     f.a = a;
%     axes(handles.axesFilter);
%     f.plot
%     set(handles.axesFilter, 'Visible', 'On');



% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close all;



function editFinalPop_Callback(hObject, eventdata, handles)
% hObject    handle to editFinalPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFinalPop as text
%        str2double(get(hObject,'String')) returns contents of editFinalPop as a double


% --- Executes during object creation, after setting all properties.
function editFinalPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFinalPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [ handles ] = readInputs(handles)
    cutoff1 = get(handles.editCutoff1, 'String');
    cutoff2 = get(handles.editCutoff2, 'String');
    band = strcmpi(get(handles.editCutoff2, 'Visible'), 'on');
    
    handles.filterType = get(handles.popupmenuFilterType, 'Value');
    [handles.cutoffIsValid, handles.cutoff] = validateCutoff(cutoff1, cutoff2, band);    
    [handles.samplesIsValid, handles.samples] = isNumber(get(handles.editSamples, 'String'), true);
    [handles.orderIsValid, handles.order] = isNumber(get(handles.editOrder, 'String'), true);
    
    [handles.minBIsValid, handles.minB] = isNumber(get(handles.editMinB, 'String'), true);
    [handles.maxBIsValid, handles.maxB] = isNumber(get(handles.editMaxB, 'String'), true);
    [handles.populationIsValid, handles.population] = isNumber(get(handles.editPopulation, 'String'), true);
    [handles.generationsIsValid, handles.generations] = isNumber(get(handles.editGenerations, 'String'), true);
    [handles.finalPopIsValid, handles.finalPop] = isNumber(get(handles.editFinalPop, 'String'), strcmpi(get(handles.editFinalPop, 'Visible'), 'on'));
    [handles.fIsValid, handles.f] = validateFandCR(get(handles.editF, 'String'), strcmpi(get(handles.editF, 'Visible'), 'on'));
    [handles.crIsValid, handles.cr] = validateFandCR(get(handles.editCR, 'String'), strcmpi(get(handles.editF, 'Visible'), 'on'));
    
    handles.method = get(handles.popupmenuMethod, 'Value');
    
    handles.filterInputsAreValid = ...
        handles.filterType > 1 && ...
        handles.cutoffIsValid && ...
        handles.orderIsValid;
    
    handles.methodInputsAreValid =  ...
        handles.method > 1 && ...
        handles.minBIsValid && ...
        handles.maxBIsValid && ...
        handles.samplesIsValid && ...
        handles.populationIsValid && ...
        handles.generationsIsValid && ...
        handles.finalPopIsValid && ...
        handles.fIsValid && ...
        handles.crIsValid;
    
    handles.inputsAreValid = handles.filterInputsAreValid && handles.methodInputsAreValid;
    
function [ handles ] = updateFilter(handles)

    if handles.cutoffIsValid > 0
        handles.filter.cutoff = handles.cutoff * pi;
        handles.filter.order = handles.order;
        handles.filter.setSamples(handles.samples);
        handles.filter.b = handles.b;
        handles.filter.a = handles.a;
        axes(handles.axesFilter);
        set(handles.axesFilter, 'Visible', 'On');
        handles.filter.plot();
    else
        cla(handles.axesFilter,'reset')
        set(handles.axesFilter, 'Visible', 'Off');
    end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOrder as text
%        str2double(get(hObject,'String')) returns contents of editOrder as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
