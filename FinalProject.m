function varargout = FinalProject(varargin)
%FINALPROJECT MATLAB code file for FinalProject.fig
%      FINALPROJECT, by itself, creates a new FINALPROJECT or raises the existing
%      singleton*.
%
%      H = FINALPROJECT returns the handle to a new FINALPROJECT or the handle to
%      the existing singleton*.
%
%      FINALPROJECT('Property','Value',...) creates a new FINALPROJECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to FinalProject_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FINALPROJECT('CALLBACK') and FINALPROJECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FINALPROJECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalProject

% Last Modified by GUIDE v2.5 02-Jan-2021 21:09:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinalProject_OpeningFcn, ...
                   'gui_OutputFcn',  @FinalProject_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before FinalProject is made visible.
function FinalProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
clc
% Choose default command line output for FinalProject
handles.output = hObject;

handles.img       = 0;
handles.ImageAdded= 0;
handles.NoisyImg  = 0;
handles.NoisyImageAdded = 0;
handles.NoisyFFT  = 0;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes FinalProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FinalProject_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Import.
function Import_Callback(hObject, eventdata, handles)
% hObject    handle to Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%arrayfun(@cla,findall(0,'type','axes'))
arr=[handles.OriginalImage,handles.Equalization,handles.Eq_Histogram,handles.Histogram,handles.NoisyImage,handles.OutputImage,handles.FF_Output,handles.FF];
for i=1:8
    cla(arr(i),'reset');
end
handles.NoisyImageAdded = 0;
[Filename, Pathname] = uigetfile('*');

if Filename ~= 0  

    try
    %colorImage = imread(uigetfile('*.jpg;*.tif;*.png;*.gif'));
    img_dir = strcat(Pathname, Filename);
    img = imread(img_dir);
    if size(img,3)==3
        img=rgb2gray(img);
    end
    handles.img=img;
    guidata(hObject,handles)
    axes(handles.OriginalImage);
    cla reset
    imshow(img);
    Fft=fftshift(fft2(img));
    handles.FFT=Fft;
    guidata(hObject,handles)
    axes(handles.FF_Output);
    cla reset
    fa=abs(Fft);
    fm=max(fa(:));
    imshow(fa/fm);
    axes(handles.FF);
    cla reset
    fl = log(1+abs(Fft));
    fm = max(fl(:));
    imshow(im2uint8(fl/fm));
    handles.ImageAdded = 1;
    guidata(hObject,handles)
    catch ME
      if (strcmp(ME.identifier,'MATLAB:imagesci:imread:fileFormat'))
          warndlg('skipped reading, You should choose an image');
      end  
    end
else 
    handles.ImageAdded = 0;
    guidata(hObject,handles)
    warndlg('Choose an image !!')
end
% --- Executes on button press in EqButton.
function EqButton_Callback(hObject, eventdata, handles)
% hObject    handle to EqButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    eq_image = histeq(img);
    axes(handles.Equalization);
    cla reset
    imshow(eq_image)
    axes(handles.Eq_Histogram);
    cla reset
    imhist(eq_image),axis tight
else 
    warndlg('Add an Image first !!')
end


% --- Executes on button press in HistogramButton.
function HistogramButton_Callback(hObject, eventdata, handles)
% hObject    handle to HistogramButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    axes(handles.Histogram);
    cla reset
    imhist(img),axis tight
else
    warndlg('Add an Image first !!')
end


% --- Executes on button press in S_PButton_Add.
function S_PButton_Add_Callback(hObject, eventdata, handles)
% hObject    handle to S_PButton_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.EditSP,'string');
img=handles.img;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    IntValue = str2num(value); format long;
    S_P=img;
    if all(ismember(value, '0123456789+-.eEdD')) && ~isempty(value) && value ~= " " && IntValue>=0 && IntValue<=1
       S_P = imnoise(img,'salt & pepper',IntValue); 
       axes(handles.NoisyImage);
       cla reset
       imshow(S_P);
    else 
       set(handles.EditSP,'string',"0.02");
       S_P = imnoise(img,'salt & pepper');
       axes(handles.NoisyImage);
       cla reset
       imshow(S_P);
       warndlg('Wrong input data. ADDED WITH DEFAULT VALUE')
    end
    handles.NoisyImg=S_P;
    guidata(hObject,handles)
else
   warndlg('Add an Image first !!') 
end

function EditSP_Callback(hObject, eventdata, handles)
% hObject    handle to EditSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSP as text
%        str2double(get(hObject,'String')) returns contents of EditSP as a double

% --- Executes during object creation, after setting all properties.
function EditSP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in S_PButton_Remove.
function S_PButton_Remove_Callback(hObject, eventdata, handles)
% hObject    handle to S_PButton_Remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NoisyImage=handles.NoisyImg;
s=size(NoisyImage);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    Choice = get(handles.SPMethod,'value');
    if Choice == 1
        NewImage = medfilt2(NoisyImage,[3 3]);
    elseif Choice == 2
        NewImage = medfilt2(NoisyImage,[5 5]); 
    else 
        NewImage = medfilt2(NoisyImage,[7 7]); 
    end
    axes(handles.OutputImage);
    cla reset
    imshow(NewImage);
else
    warndlg('Create the noise First !!') 
end

% --- Executes on button press in PeriodicButton.
function PeriodicButton_Callback(hObject, eventdata, handles)
% hObject    handle to PeriodicButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valueX = get(handles.Nx,'string');
valueY = get(handles.Ny,'string');
Choice = get(handles.PeriodicSinCos,'SelectedObject');
Choice = get(Choice,'string');
img=handles.img;
s=size(img);
if  s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    IntValueX=str2num(valueX);
    IntValueY=str2num(valueY);
    NoisyImage=img;
    s = size(img);
    [x, y]= meshgrid(1:s(2),1:s(1));
    Wx = max(max(x)); 
    Wy = max(max(y));
    handles.NoisyImageAdded=0;
    guidata(hObject,handles)
    if  all(ismember(valueX, '0123456789+-.eEdD')) && all(ismember(valueY, '0123456789+-.eEdD')) && ~isempty(valueX)&& ~isempty(valueY) && valueX ~= " " && valueY ~= " " && IntValueX>=0 && IntValueY>=0
        ny = IntValueY;
        nx = IntValueX; 
        fx = nx/Wx;
        fy = ny/Wy;
        if Choice == "Sin"
            NoisyImage = sin(2*pi*fx*x + 2*pi*fy*y)+1; 
            NoisyImageDispay = mat2gray((im2double(img)+NoisyImage));
        else
            NoisyImage = cos(2*pi*fx*x + 2*pi*fy*y)+1; 
            NoisyImageDispay = mat2gray((im2double(img)+NoisyImage));
        end
       axes(handles.NoisyImage);
       cla reset
       imshow(img);
       axes(handles.OutputImage);
       cla reset
       imshow(NoisyImageDispay);
       handles.NoisyImageAdded=1;
       guidata(hObject,handles)

       Fft = fftshift(fft2(NoisyImageDispay));
       axes(handles.FF_Output);
       cla reset
       fa=abs(Fft);
       fm=max(fa(:));
       imshow(fa/fm),impixelinfo;
       axes(handles.FF);
       cla reset
       fl = log(1+abs(Fft));
       fm = max(fl(:));
       imshow(im2uint8(fl/fm)),impixelinfo;

       handles.NoisyFFT = NoisyImageDispay;
       guidata(hObject,handles)
    else
        set(handles.Nx,'string',"3");
        set(handles.Ny,'string',"2");
        ny = 2;
        nx = 3; 
        fx = nx/Wx;
        fy = ny/Wy;
        if Choice == "Sin"
            NoisyImage = sin(2*pi*fx*x + 2*pi*fy*y)+1; 
            NoisyImageDispay = mat2gray((im2double(img)+NoisyImage));
        else
            NoisyImage = cos(2*pi*fx*x + 2*pi*fy*y)+1; 
            NoisyImageDispay = mat2gray((im2double(img)+NoisyImage));
        end
        axes(handles.NoisyImage);
        cla reset
        imshow(img);
        axes(handles.OutputImage);
       cla reset
       imshow(NoisyImageDispay);
       handles.NoisyImageAdded=1;
       guidata(hObject,handles)

       Fft = fftshift(fft2(NoisyImageDispay));
       axes(handles.FF_Output);
       cla reset
       fa=abs(Fft);
       fm=max(fa(:));
       imshow(fa/fm),impixelinfo;
       axes(handles.FF);
       cla reset
       fl = log(1+abs(Fft));
       fm = max(fl(:));
       imshow(im2uint8(fl/fm)),impixelinfo;

       handles.NoisyFFT = NoisyImageDispay;
       guidata(hObject,handles)
       
       warndlg('Wrong input data. ADDED WITH DEFAULT VALUE')
    end
else
    warndlg('Add an image first !!')
end

function Nx_Callback(hObject, eventdata, handles)
% hObject    handle to Nx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nx as text
%        str2double(get(hObject,'String')) returns contents of Nx as a double


% --- Executes during object creation, after setting all properties.
function Nx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ny_Callback(hObject, eventdata, handles)
% hObject    handle to Ny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ny as text
%        str2double(get(hObject,'String')) returns contents of Ny as a double


% --- Executes during object creation, after setting all properties.
function Ny_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LapButton.
function LapButton_Callback(hObject, eventdata, handles)
% hObject    handle to LapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.EditLap,'string');
img=handles.img;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    IntValue=str2num(value);format long;
    Lap=img;
    if all(ismember(value, '0123456789+-.eEdD')) && ~isempty(value) && value ~= " " 
       lap=fspecial('laplacian',IntValue);
       Lap = filter2(lap,img);
       axes(handles.NoisyImage);
       cla reset
       imshow(img);
       axes(handles.OutputImage);
       cla reset
       imshow(Lap);
    else
       set(handles.EditLap,'string',"0.02");
       lap=fspecial('laplacian');
       Lap = filter2(lap,img);
       axes(handles.NoisyImage);
       cla reset
       imshow(img);
       axes(handles.OutputImage);
       cla reset
       imshow(Lap);
       warndlg('Wrong input data. ADDED WITH DEFAULT VALUE')
    end
else
    warndlg('Add an image first !!')
end
function EditLap_Callback(hObject, eventdata, handles)
% hObject    handle to EditLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLap as text
%        str2double(get(hObject,'String')) returns contents of EditLap as a double


% --- Executes during object creation, after setting all properties.
function EditLap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EditSobel_Callback(hObject, eventdata, handles)
% hObject    handle to EditSobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSobel as text
%        str2double(get(hObject,'String')) returns contents of EditSobel as a double

% --- Executes during object creation, after setting all properties.
function EditSobel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SobelButton.
function SobelButton_Callback(hObject, eventdata, handles)
% hObject    handle to SobelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.EditSobel,'string');
Choice = get(handles.Sobel_Direction,'value');
img=handles.img;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    IntValue=str2num(value);
    Sobel=img;
    if all(ismember(value, '0123456789+-.eEdD')) && ~isempty(value) && value ~= " " 
       if Choice == 1
       Sobel = edge(img,'sobel',IntValue,'vertical');
       else
       Sobel = edge(img,'sobel',IntValue,'horizontal');
       end
       axes(handles.NoisyImage);
       cla reset
       imshow(img);
       axes(handles.OutputImage);
       cla reset
       imshow(Sobel);
    else 
       set(handles.EditSobel,'string',"0.02");
       IntValue = 0.02;
       if Choice == 1
       Sobel = edge(img,'sobel',IntValue,'vertical');
       else
       Sobel = edge(img,'sobel',IntValue,'horizontal');
       end
       axes(handles.NoisyImage);
       cla reset
       imshow(img);
       axes(handles.OutputImage);
       cla reset
       imshow(Sobel);
       warndlg('Wrong input data. ADDED WITH DEFAULT VALUE')
    end
else
    warndlg('Add an image first !!')
end

% --- Executes on button press in RemovePeriodic.
function RemovePeriodic_Callback(hObject, eventdata, handles)
% hObject    handle to RemovePeriodic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x   = handles.NoisyImageAdded;
img = handles.NoisyFFT;
s=size(img);
if s(1) ~= 1 && s(2) ~= 1 && handles.ImageAdded == 1
    if x 
       Choice = get(handles.Method,'value');
       switch Choice
       case 1 %Notch
            newImage = fftshift(fft2(img));
            axes(handles.FF);
            fa=abs(newImage);
            fm=max(fa(:));
            FFTabs=fa/fm;
            [rows, columns] = find(FFTabs >= 0.2 & FFTabs < 0.9);

            newImage(rows(1),:)=0;
            newImage(rows(2),:)=0;
            newImage(:,columns(1))=0;
            newImage(:,columns(2))=0;
            
%             rows = round(ginput(1));
%             columns = round(ginput(1));
%             newImage(rows(1),:)=0;
%             newImage(rows(2),:)=0;
%             newImage(:,columns(1))=0;
%             newImage(:,columns(2))=0;

            axes(handles.FF);
            cla reset
            fl = log(1+abs(newImage));
            fm = max(fl(:));
            imshow(im2uint8(fl/fm)),impixelinfo;

            axes(handles.FF_Output);
            cla reset
            fa=abs(ifft2(newImage));
            fm=max(fa(:));
            imshow(fa/fm),impixelinfo;

       case 2 %Band-reject
           newImage = fftshift(fft2(img));
           sz = size(newImage);
           fa=abs(newImage);
           fm=max(fa(:));
           FFTabs=fa/fm;
           [rows, columns] = find(FFTabs >= 0.2 & FFTabs < 0.9);
           
           [x,y]=meshgrid(-((sz(2))/2):((sz(2))/2)-1,-((sz(1))/2):((sz(1))/2)-1); %% A matrix of distances
           z=sqrt(x.^2+y.^2);
           dist=z(rows,columns);

           br = (z > dist(1)+1 | z < dist(2)-1 );
           FinalImage = newImage.*br;
           axes(handles.FF);
           cla reset
           fl = log(1+abs(FinalImage));
           fm = max(fl(:));
           imshow(im2uint8(fl/fm)),impixelinfo;

           axes(handles.FF_Output);
           cla reset
           fa=abs(ifft2(FinalImage));
           fm=max(fa(:));
           imshow(fa/fm),impixelinfo;

       case 3 %Mask
            newImage = fftshift(fft2(img));
            axes(handles.FF);
            coordinates_1 = round(ginput(1));
            coordinates_2 = round(ginput(1));
            freqImageNoisy = newImage;
            magImageNoisy = log(abs(freqImageNoisy));
            mask = ones(size(magImageNoisy));

            mask(coordinates_1(2),coordinates_1(1)) = 0;
            mask(coordinates_2(2),coordinates_2(1)) = 0;

            filtered = mask.*freqImageNoisy;
            amplitudeImage = log(abs(filtered));
            filteredImage = ifft2(ifftshift(filtered));
            ampFilteredImage = abs(filteredImage);
            minValue = min(min(ampFilteredImage));
            maxValue = max(max(ampFilteredImage));

            axes(handles.FF);
            cla reset
            fl = log(1+abs(fftshift(fft2(ampFilteredImage))));
            fm = max(fl(:));
            imshow(im2uint8(fl/fm)),impixelinfo;

            axes(handles.FF_Output);
            cla reset
            imshow(ampFilteredImage, [minValue maxValue]);

           otherwise
       end
    end
else
    warndlg('Create the noise First !!')
end


% --- Executes on selection change in Method.
function Method_Callback(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Method
img=handles.NoisyFFT;
Fft = fftshift(fft2(img));
axes(handles.FF_Output);
cla reset
fa=abs(Fft);
fm=max(fa(:));
imshow(fa/fm),impixelinfo;
axes(handles.FF);
cla reset
fl = log(1+abs(Fft));
fm = max(fl(:));
imshow(im2uint8(fl/fm)),impixelinfo;
if get(handles.Method,'value')==3
    warndlg('You should zoom-IN first before removing the noise to choose pixels correctly, From top left corner choose the zoom icon and zoom-IN then press on Remove Periodic button to choose 2 pixels ') 
end

% --- Executes during object creation, after setting all properties.
function Method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SPMethod.
function SPMethod_Callback(hObject, eventdata, handles)
% hObject    handle to SPMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SPMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SPMethod


% --- Executes during object creation, after setting all properties.
function SPMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in Sobel_Direction.
function Sobel_Direction_Callback(hObject, eventdata, handles)
% hObject    handle to Sobel_Direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sobel_Direction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sobel_Direction


% --- Executes during object creation, after setting all properties.
function Sobel_Direction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sobel_Direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
