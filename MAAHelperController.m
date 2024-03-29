function varargout = MAAHelperController(varargin)
% MAAHelperController MATLAB code for MAAHelperController.fig (Controller)
%      MAAHelperController, by itself, creates a new MAAHelperController or raises the existing
%      singleton*.
%
%      H = MAAHelperController returns the handle to a new MAAHelperController or the handle to
%      the existing singleton*.
%
%      MAAHelperController('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAAHelperController.M with the given input arguments.
%
%      MAAHelperController('Property','Value',...) creates a new MAAHelperController or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAAHelperController_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAAHelperController_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAAHelperController

% Last Modified by GUIDE v2.5 05-Sep-2019 11:17:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAAHelperController_OpeningFcn, ...
                   'gui_OutputFcn',  @MAAHelperController_OutputFcn, ...
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

% --- Executes just before MAAHelperController is made visible.
function MAAHelperController_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAAHelperController (see VARARGIN)

% Choose default command line output for MAAHelperController
handles.output = hObject;

% Make participant object, session object
handles.participant = Participant();
handles.session = Session();
handles.operator = Operator(handles.session);

% Handles flag for trial info, must select both (or 1 if done direction)
handles.inputtedUphill = 0;
handles.inputtedDownhill = 0;

% actual inputs
handles.resultUphill = '*';
handles.resultDownhill = '*';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAAHelperController wait for user response (see UIRESUME)
% uiwait(handles.figure1);
MAAHelperView(handles.operator);

% handles
movegui(handles.figure1, 'east');

% Last State
handles.lastState = NaN; 

% Undo
set(handles.UndoButton, 'enable', 'off');

% --- Outputs from this function are returned to the command line.
function varargout = MAAHelperController_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Set the confirm results button to enabled if sufficient input given
function checkResultsInput(handles)
handleOperator = handles.operator;
fprintf('Inputted uphill and downhill: %d | %d\n', handles.inputtedUphill, handles.inputtedDownhill);
if ~handleOperator.foundUphill && ~handleOperator.foundDownhill && handles.inputtedUphill && handles.inputtedDownhill
    set(handles.ConfirmButton, 'enable', 'on');
    %fprintf('ready to enable\n');
elseif ~handleOperator.foundUphill && handleOperator.foundDownhill && handles.inputtedUphill
    set(handles.ConfirmButton, 'enable', 'on');
    %fprintf('ready to enable\n');
elseif ~handleOperator.foundDownhill && handleOperator.foundUphill && handles.inputtedDownhill
    set(handles.ConfirmButton, 'enable', 'on');
    %fprintf('ready to enable\n');
end

%% UPHILL RESULTS BUTTONS
% --- Executes on button press in uphillPassButton.
function uphillPassButton_Callback(hObject, eventdata, handles)
% hObject    handle to uphillPassButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uphillStatusIndic, 'String', 'PASS');
handles.inputtedUphill = 1;
handles.resultUphill = 1;


checkResultsInput(handles);
%fprintf('PRESSED UPHILL PASS\n');
guidata(hObject,handles)  % save changes to handles

% --- Executes on button press in uphillFailButton.
function uphillFailButton_Callback(hObject, eventdata, handles)
% hObject    handle to uphillFailButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uphillStatusIndic, 'String', 'FAIL');
handles.inputtedUphill = 1;
handles.resultUphill = 0;

checkResultsInput(handles);
%fprintf('PRESSED UPHILL F\n');
guidata(hObject,handles)  % save changes to handles

%% DOWNHILL RESULTS BUTTONS
% --- Executes on button press in downhillPassButton.
function downhillPassButton_Callback(hObject, eventdata, handles)
% hObject    handle to downhillPassButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.downhillStatusIndic, 'String', 'PASS');
handles.inputtedDownhill = 1;
handles.resultDownhill = 1;

checkResultsInput(handles);
%fprintf('PRESSED DOWNHILL PASS\n');
guidata(hObject,handles)  % save changes to handles

% --- Executes on button press in downhillFailButton.
function downhillFailButton_Callback(hObject, eventdata, handles)
% hObject    handle to downhillFailButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.downhillStatusIndic, 'String', 'FAIL');
handles.inputtedDownhill = 1;
handles.resultDownhill = 0;

checkResultsInput(handles);
%fprintf('PRESSED DOWNHILL F\n');
guidata(hObject,handles)  % save changes to handles

%% CONFRIM RESULTS BUTTON
% --- Executes on button press in Button.
function ConfirmButton_Callback(hObject, eventdata, handles)
% hObject    handle to ConfirmButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('--- CURRENT ANGLE: %d ---\n', handles.operator.currAngle);

% notify the viewer to update the data
handles.operator.notifyListeners();
handles.operator.session.notifyListeners();
handles.operator.session.participant.notifyListeners();

% set the curr tested angle before we modify it
% handles.justTestedAngle = handles.operator.currAngle;

handles.lastState = copy(handles.operator);

handles.operator.recordResults(handles.resultUphill, handles.resultDownhill);
handles.operator.checkMAA(); 

% decide next angle:
% implement an if statement to execute this line 
handles.operator.adjustAngle(handles.resultUphill, handles.resultDownhill);

% Enable Undo
set(handles.UndoButton, 'enable', 'on');

if ~handles.operator.foundUphill || ~handles.operator.foundDownhill
    fprintf('    NEXT ANGLE: %d\n', handles.operator.currAngle);
    % notify the viewer to update the data
    handles.operator.notifyListeners();
end 

handles.operator.notifyListeners();

% disable the uphill/downhill panels if we found an MAA for that dir
if handles.operator.foundUphill
    set(handles.uphillFailButton, 'enable', 'off');
    set(handles.uphillPassButton, 'enable', 'off');
    set(handles.uphillStatusIndic, 'String', 'FOUND MAA');
    handles.resultUphill = '*';
else 
    set(handles.uphillFailButton, 'enable', 'on');
    set(handles.uphillPassButton, 'enable', 'on');
    set(handles.uphillStatusIndic, 'String', '');
    handles.resultUphill = '*';
end

if handles.operator.foundDownhill
    set(handles.downhillFailButton, 'enable', 'off');
    set(handles.downhillPassButton, 'enable', 'off');
    set(handles.downhillStatusIndic, 'String', 'FOUND MAA');
    handles.resultDownhill = '*';
else 
    set(handles.downhillFailButton, 'enable', 'on');
    set(handles.downhillPassButton, 'enable', 'on');
    set(handles.downhillStatusIndic, 'String', '');
    handles.resultDownhill = '*';
end

% set these as enabled after we found MAA
if handles.operator.foundDownhill && handles.operator.foundUphill
   % entry fields
   set(handles.preslipEdit, 'enable', 'on');
   set(handles.slipperinessEdit, 'enable', 'on');
   set(handles.thermalEdit, 'enable', 'on');
   set(handles.fitEdit, 'enable', 'on');
   set(handles.heavinessEdit, 'enable', 'on');
   set(handles.winterUseEdit, 'enable', 'on');
   set(handles.easeEdit, 'enable', 'on');
   set(handles.overallScoreEdit, 'enable', 'on');
   set(handles.ExportButton, 'enable', 'on');  % allow to export
   
   set(handles.ConfirmButton, 'enable', 'off');
   
   % text fields
   set(handles.slipperinessTag, 'enable', 'on');
   set(handles.thermalTag, 'enable', 'on');
   set(handles.fitTag, 'enable', 'on');
   set(handles.heavinessTag, 'enable', 'on');
   set(handles.useTag, 'enable', 'on');
   set(handles.easeTag, 'enable', 'on');
   set(handles.overallTag, 'enable', 'on');
end

% reset the input fields for the uphill and downhill results, make the
% confirm button disabled again
set(handles.downhillStatusIndic, 'String', '');
set(handles.uphillStatusIndic, 'String', '');
set(hObject, 'enable', 'off');
handles.inputtedDownhill = 0;
handles.inputtedUphill = 0;
handles.resultUphill = '*';
handles.resultDownhill = '*';

guidata(hObject,handles)  % save changes to handles

%% PARTICIPANT INFO
% --- A bunch of listeners and their call back functions
% --- Similar format in MATLAB

function participantID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to participantID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function participantID_Callback(hObject, eventdata, handles)
% hObject    handle to participantID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Need to parse data 
% Hints: get(hObject,'String') returns contents of participantID as text
%        str2double(get(hObject,'String')) returns contents of participantID as a double

function partiSexPanel_SelectionChangeFcn(hObject, eventdata, handles)
% Need to parse data 
newButton = get(eventData.NewValue, 'Tag');
switch newButton
    case 'maleRadio' 
        fprintf('M selected');
    otherwise
        fprintf('F selected');
end

function partiHeightEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function partiHeightEdit_Callback(hObject, eventdata, handles)

function partiWeightEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partiWeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function partiWeightEdit_Callback(hObject, eventdata, handles)

function partiSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partiSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function partiSizeEdit_Callback(hObject, eventdata, handles)

function partiAgeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partiAgeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function partiAgeEdit_Callback(hObject, eventdata, handles)

function updatePartiButton_Callback(hObject, eventdata, handles)
% hObject    handle to updatePartiButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Need to parse data 

% change the participant stuff
handles.operator.session.participant.setID(get(handles.participantID, 'String'));
handles.operator.session.participant.setSex(get(get(handles.partiSexPanel, 'SelectedObject'), 'String'));
handles.operator.session.participant.setSize(str2double(get(handles.partiSizeEdit, 'String')));
handles.operator.session.participant.setWeight(get(handles.partiWeightEdit, 'String'));
handles.operator.session.participant.setHeight(get(handles.partiHeightEdit, 'String'));
handles.operator.session.participant.setAge(get(handles.partiAgeEdit, 'String'));

% handles.operator.session.participant.toString()
% notify the viewer
handles.operator.session.participant.notifyListeners();

%% SESSION INFO
% A bunch of listeners and their call back functions
% Similar format in MATLAB

function iceTempEdit_Callback(hObject, eventdata, handles)

function iceTempEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function airTempEdit_Callback(hObject, eventdata, handles)

function airTempEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function humidEdit_Callback(hObject, eventdata, handles)

function humidEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to humidEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dateEdit_Callback(hObject, eventdata, handles)

function dateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeEdit_Callback(hObject, eventdata, handles)

function timeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function shoeIDEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function shoeIDEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shoeIDEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in iceConditionPanel.
function iceConditionPanel_SelectionChangeFcn(hObject, eventdata, handles)
str = get(hObject, 'String');
if strcmp(str, 'dryIceRadio')
	fprintf('dry selected\n');
else
	fprintf('wet selected\n');
end

function dryIceRadio_Callback(hObject, eventdata, handles)

function wetIceRadio_Callback(hObject, eventdata, handles)

function winterUseEdit_Callback(hObject, eventdata, handles)

function winterUseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winterUseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function easeEdit_Callback(hObject, eventdata, handles)

function easeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to easeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function overallScoreEdit_Callback(hObject, eventdata, handles)

function overallScoreEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overallScoreEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function preslipEdit_Callback(hObject, ~, handles)

function preslipEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preslipEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slipperinessEdit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slipperinessEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slipperinessEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function thermalEdit_Callback(hObject, eventdata, handles)

function thermalEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thermalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fitEdit_Callback(hObject, eventdata, handles)

function fitEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function heavinessEdit_Callback(hObject, eventdata, handles)

function heavinessEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function observerEdit_Callback(hObject, eventdata, handles)

function observerEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Some other functionalities

function updateSessInfoButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateSessInfoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% change the session stuff
handles.operator.session.setIceTemp(str2double(get(handles.iceTempEdit, 'String')));
handles.operator.session.setAirTemp(str2double(get(handles.airTempEdit, 'String')));
handles.operator.session.setWalkway(get(get(handles.iceConditionPanel, 'SelectedObject'), 'String'));
handles.operator.session.setHumidity(str2double(get(handles.humidEdit, 'String')));
handles.operator.session.setDate(get(handles.dateEdit, 'String'));
handles.operator.session.setTime(get(handles.timeEdit, 'String'));
handles.operator.session.setFootwear(get(handles.shoeIDEdit, 'String'));

% ratings
handles.operator.session.setPreslip(str2double(get(handles.preslipEdit, 'String')));
handles.operator.session.setSlip(str2double(get(handles.slipperinessEdit, 'String')));
handles.operator.session.setThermal(str2double(get(handles.thermalEdit, 'String')));
handles.operator.session.setFit(str2double(get(handles.fitEdit, 'String')));
handles.operator.session.setHeaviness(str2double(get(handles.heavinessEdit, 'String')));
handles.operator.session.setUseInWinter(str2double(get(handles.winterUseEdit, 'String')));
handles.operator.session.setEase(str2double(get(handles.easeEdit, 'String')));
handles.operator.session.setOverall(str2double(get(handles.overallScoreEdit, 'String')));
handles.operator.session.setObserver(get(handles.observerEdit, 'String'));

% notify the viewer
handles.operator.session.notifyListeners();

function ExportButton_Callback(hObject, eventdata, handles)

fprintf('Exporting to excel...\n');
Excel = actxserver ('Excel.Application');

% Set preferred excel parameters - no sound, complaints, and visible
Excel.visible = true;
Excel.DisplayAlerts = false;
Excel.EnableSound = false;

% Store the data matrix somewhere  
% Undo button in the future 
SPREADSHEET_SESSION = 'U:\Projects\Winter Projects\Kent\GUI\MAA-GUI\exported_session.xlsx'; 
excelWriteCells = handles.operator.exportDataCells;

if ~exist(SPREADSHEET_SESSION, 'file')
    fprintf('Output file doesnt exist, making it now lol...\n');
    f = fopen(SPREADSHEET_SESSION, 'w');
    fclose(f);
end

Excel.Workbooks.Open(SPREADSHEET_SESSION);
Workbook = Excel.ActiveWorkbook;
Worksheets = Workbook.sheets;
% Worksheets.Item(1).Activate;

% SessionData directory
EXPORTED_SHEET = 'SessionData';
Worksheets.Item(EXPORTED_SHEET).Activate;

% Find the next empty row
currentExcelRow = Excel.ActiveSheet.UsedRange.Rows.Count + 1;

% spreadsheet with all our data
% write to the file
% write data to the excel sheet
[rows, cols] = size(excelWriteCells);
cellReference = sprintf('C%d:%s%d', currentExcelRow, xlscol(cols + 2), currentExcelRow + rows - 1);

xlswrite1(SPREADSHEET_SESSION, excelWriteCells, EXPORTED_SHEET, cellReference);

% xlswrite(SPREADSHEET_SESSION, excelWriteCells, 'SessionData', 'A3:AE3');

% Save our changes to file
invoke(Excel.ActiveWorkbook,'Save'); 
Workbook.Close(false);

% Safely close the ActiveX server
Excel.Quit;
Excel.delete;
clear Excel;

function UndoButton_Callback(hObject, eventdata, handles)

% lastState itself has no data change. Change it manually.
handles.operator = handles.lastState;
handles.operator.notifyListeners();
handles.operator.checkMAA(); 
handles.operator.session.notifyListeners();
handles.operator.timesVisitedAngles(handles.operator.currAngle) = handles.operator.timesVisitedAngles(handles.operator.currAngle) - 1;
MAAHelperView(handles.operator);

set(handles.UndoButton, 'enable', 'off');
set(handles.downhillStatusIndic, 'String', '');
set(handles.uphillStatusIndic, 'String', '');
set(hObject, 'enable', 'off');
handles.inputtedDownhill = 0;
handles.inputtedUphill = 0;
handles.resultUphill = '*';
handles.resultDownhill = '*';

set(handles.ConfirmButton, 'enable', 'on');

if handles.operator.foundUphill
    set(handles.uphillFailButton, 'enable', 'off');
    set(handles.uphillPassButton, 'enable', 'off');
    set(handles.uphillStatusIndic, 'String', 'FOUND MAA');
    handles.resultUphill = '*';
else 
    set(handles.uphillFailButton, 'enable', 'on');
    set(handles.uphillPassButton, 'enable', 'on');
    set(handles.uphillStatusIndic, 'String', '');
    handles.resultUphill = '*';
end

if handles.operator.foundDownhill
    set(handles.downhillFailButton, 'enable', 'off');
    set(handles.downhillPassButton, 'enable', 'off');
    set(handles.downhillStatusIndic, 'String', 'FOUND MAA');
    handles.resultDownhill = '*';
else 
    set(handles.downhillFailButton, 'enable', 'on');
    set(handles.downhillPassButton, 'enable', 'on');
    set(handles.downhillStatusIndic, 'String', '');
    handles.resultDownhill = '*';
end

guidata(hObject,handles)  % save changes to handles

