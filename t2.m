function varargout = t2(varargin)
% T2 MATLAB code for t2.fig
%      T2, by itself, creates a new T2 or raises the existing
%      singleton*.
%
%      H = T2 returns the handle to a new T2 or the handle to
%      the existing singleton*.
%
%      T2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in T2.M with the given input arguments.
%
%      T2('Property','Value',...) creates a new T2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before t2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to t2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help t2

% Last Modified by GUIDE v2.5 12-Jul-2021 17:37:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @t2_OpeningFcn, ...
                   'gui_OutputFcn',  @t2_OutputFcn, ...
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


% --- Executes just before t2 is made visible.
function t2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to t2 (see VARARGIN)

% Choose default command line output for t2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes t2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = t2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EyeDetect = vision.CascadeObjectDetector('EyePairBig');                 % detection
a=zeros(200);
b=zeros(200);
c=zeros(200);
a(:,99:103)=255;
a(46:50,:)=255;
a(86:90,:)=255;
b(94:96,76:96)=255;
b(114:116,76:96)=255;
b(94:114,76:78)=255;
b(94:114,94:96)=255;
b(94:96,106:126)=255;
b(114:116,106:126)=255;
b(94:114,106:108)=255;
b(94:114,124:126)=255;
d=cat(3,a,b,c);
dlin=uint8(d);
F=[];
for i1=1:25

    if((i1==2)||(i1==10)||(i1==12)||(i1==19)||(i1==14))
        cls=1;    %Female
    else
        cls=2;     %Male
    end
    
    fold=strcat('s',num2str(i1));
    cd (fold)
    for j1=1:9
    I=imread(strcat(num2str(j1),'.pgm'));
    
    %%%%%%%%%%Eye-Crypt%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    BB = step(EyeDetect,I);
    %rectangle('Position',BB,'LineWidth',3,'LineStyle','-','EdgeColor','r');
    x=imcrop(I,BB);
    axes(handles.axes1)
    imshow(I)
    axes(handles.axes2)
    imshow(x)
    [r1,c1]=size(x);
    a=x(:,1:fix(c1/2));
     axes(handles.axes10)
     imshow(a)
    a3=imresize(a,[200,200]);
    ta2=imresize(a,[300,300]);   %%%%%%%%%%%%%%%%Census tranform%%%%%%%%%%%%%
    d1=ta2;
for i=1:3:300
    for j=1:3:300
      c=ta2(i:i+2,j:j+2);
      b1=c;
      size(c);
      th=c(2,2);
        for p=1:3
           for q=1:3
                if(c(p,q)>th)
                    b1(p,q)=0;
                else
                     b1(p,q)=255;
                end
            end
        end
       d1(i:i+2,j:j+2)=b1;
    end
end
 
    se = strel('line',5,90);
    a4 = imerode(a3,se);   %%%erosion
  
    se1 = strel('line',5,90);
    a5 = imdilate(a4,se1);     %%%dilation
    a55=cat(3,a5,a5,a5);
    %%%%%%%%%%%%%%%%%%%%%
    a6=a55+dlin;
    axes(handles.axes3)
    imshow(a6)
    axes(handles.axes4)
    imshow(d1)
    LoC=imcrop(d1,[74,56,40,40]);
    RoC=imcrop(d1,[74,106,40,40]);
    crL=sum(sum(LoC))/255;
    crR=sum(sum(RoC))/255;
    axes(handles.axes5)
    imshow(LoC) 
    axes(handles.axes6)
    imshow(RoC)
    
    %%%%%%%%%%%%%%%%%HOG%%%%%%%%%%%%%%%%%%%
    [featureVector,hogVisualization] = extractHOGFeatures(I);
    mhog=mean(featureVector);
    axes(handles.axes9)
    imshow(I); 
    hold on;
    plot(hogVisualization);
    hold off;
    %%%%%%%%%%%LBP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55%%%%%
    lbpB1 = extractLBPFeatures(I,'Upright',false);
    I=double(I);
    axes(handles.axes11)
    bar(I);
    m1=mean(mean(I));
    s1=std(std(I));
    lb1=sum(lbpB1);
    
%%%%%%%%%create database    
LF=[m1 s1 lb1  crL crR mhog cls];
    F=[F;LF]   
  pause(0.01)
    end
     cd .. 
end
handles.F=F;
guidata(hObject,handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F=handles.F;
EyeDetect = vision.CascadeObjectDetector('EyePairBig');                 % detection
a=zeros(200);
b=zeros(200);
c=zeros(200);
a(:,99:103)=255;
a(46:50,:)=255;
a(86:90,:)=255;
b(94:96,76:96)=255;
b(114:116,76:96)=255;
b(94:114,76:78)=255;
b(94:114,94:96)=255;
b(94:96,106:126)=255;
b(114:116,106:126)=255;
b(94:114,106:108)=255;
b(94:114,124:126)=255;
d=cat(3,a,b,c);
dlin=uint8(d);
[f,p]=uigetfile('*.*');
test=imread(strcat(p,f));
axes(handles.axes7)
imshow(test)
  
%%%%%%%%%%Eye-Crypt%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BB = step(EyeDetect,test);
rectangle('Position',BB,'LineWidth',3,'LineStyle','-','EdgeColor','r');
x=imcrop(test,BB);
axes(handles.axes8)
imshow(x)
    [r1,c1]=size(x);
    a=x(:,1:fix(c1/2));
    a3=imresize(a,[200,200]);
    ta2=imresize(a,[300,300]);   %%%%%%%%%%%%%%%%Census tranform%%%%%%%%%%%%%
    d1=ta2;
for i=1:3:300
    for j=1:3:300
      c=ta2(i:i+2,j:j+2);
      b1=c;
      size(c);
      th=c(2,2);
        for p=1:3
           for q=1:3
                if(c(p,q)>th)
                    b1(p,q)=0;
                else
                     b1(p,q)=255;
                end
            end
        end
       d1(i:i+2,j:j+2)=b1;
    end
end
 
    se = strel('line',5,90);
    a4 = imerode(a3,se);   %%%erosion
  
    se1 = strel('line',5,90);
    a5 = imdilate(a4,se1);     %%%dilation
    a55=cat(3,a5,a5,a5);
    %%%%%%%%%%%%%%%%%%%%%
    LoC=imcrop(d1,[74,56,40,40]);
    RoC=imcrop(d1,[74,106,40,40]);
    crL=sum(sum(LoC))/255;
    crR=sum(sum(RoC))/255;
        %%%%%%%%%%%%%%%%%%%%%%%%HOG
        [featureVector,hogVisualization] = extractHOGFeatures(test);
    mhog=mean(featureVector);
    set(handles.edit4,'string',mhog)
    %%%%%%%%%%%LBP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55%%%%%
    lbpB1 = extractLBPFeatures(test,'Upright',false);
    test=double(test);
    m1=mean(mean(test));
    set(handles.edit2,'string',m1) 
    s1=std(std(test));
    set(handles.edit3,'string',s1) 
    lb1=sum(lbpB1);
    Ftest=[m1 s1 lb1 crL crR mhog];
    %%%%%%%%%create database
    
    %%%%%%%%%%%%%%%%%%SVM Classification%%%%%%%%%%%%%%%%
        Ftrain=F(:,1:6);
        Ctrain=F(:,7);
    for (k=1:size(Ftrain,1))
         dist(k,:)=sum(abs(Ftrain(k,:)-Ftest));
    end   
   m=find(dist==min(dist),1);
   det_class=Ctrain(m);
   if (det_class==1)
   set(handles.edit1,'string','FEMALE') 
   else
   set(handles.edit1,'string','MALE') 
   end
   msgbox(strcat('Detected Class=',num2str(det_class)));



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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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
