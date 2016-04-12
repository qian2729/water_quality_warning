function varargout = start(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_OpeningFcn, ...
                   'gui_OutputFcn',  @start_OutputFcn, ...
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


% --- Executes just before start is made visible.
function start_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for start
handles.output = hObject;

handles.wahanie=0.05; % it says haow much initial signal can be warious, +/- 0.05
% Update handles structure
guidata(hObject, handles); 


% --- Outputs from this function are returned to the command line.
function varargout = start_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in wzorzec.
function wzorzec_Callback(hObject, eventdata, handles)
% 1st signal, random noumbers

self=[0.2265 0.1423 0.2871 0.2186 0.273  0.2177 ...
     0.265  0.2508 0.1426 0.0567 0.19   0.0797 ...
     0.1772 0.287 0.2773 0.3113 0.3574 0.2288...
     0.5645 0.2572 0.3113 0.3574 0.2288 0.2871 0.2186 0.273...
     0.265  0.2508 0.3426 0.3567 0.29   0.2797 0.1772 0.287 ...
     0.2645 0.2572 0.3113 0.3574 0.2288 0.2871];
 self=self';
 handles.self=self*1.2;
 
 axes(handles.axes1)
 plot(self,'b');
 hold on
 
 handles.wz=1; %says wchich signal was chosen
 
 guidata(hObject, handles);
 set(handles.text1,'visible','on')
 set(handles.ile,'visible','on')
 set(handles.limfocyty,'visible','on')
 set(handles.ile_iteracji,'visible','on')
 set(handles.text7,'visible','on')
 
 
 % --- Executes on button press in wzorzec2.
function wzorzec2_Callback(hObject, eventdata, handles)
Fs = 30;                    
T = 1/Fs;                   
L = 40;                     
t = (0:L-1)*T;                
handles.wzorzec2 = 0.3*sin(2*pi*1.2*t)+0.5;        % signal 2
handles.wzorzec2=handles.wzorzec2';
 axes(handles.axes1)
 plot(handles.wzorzec2,'b');
 hold on
handles.wz=2; % wchich signal was chosen
handles.self=handles.wzorzec2;  % now we have signal (1 or 2) in self

 guidata(hObject, handles);
 set(handles.text1,'visible','on')
 set(handles.ile,'visible','on')
 set(handles.limfocyty,'visible','on')
 set(handles.ile_iteracji,'visible','on')
 set(handles.text7,'visible','on')
 


% --- Executes on button press in limfocyty.
function limfocyty_Callback(hObject, eventdata, handles)
% lymphocytes

handles.iter=str2num(get(handles.ile_iteracji,'string'));
handles.k=str2num(get(handles.ile,'string'));
d=rand(40,1,handles.k); 

% this for loop is only to show how lymphocytes are generated

for j=1:40  
            for z=1:2;  
                
                 if d(j,1,z)>=handles.self(j,1)+handles.wahanie || d(j,1,z)<=handles.self(j,1)-handles.wahanie   %sprawdzamy czy limfocyt jest z okreœlonego zakresu - selekcja negatywna
                    d(j,1,z)=d(j,1,z); % limfocyt jest z okreœlonego zakresu i jest zostawiany
                 else
                    d(j,1,z)=rand(1,1); % jeœli limfocyt jest spoza zakresu to losujemy nowy
                 end
                 if z==2%refreshdata(h,'caller')p 
                 plot(j,d(j,1,z),'m.')
                    drawnow;
                 end
           end
        end

% mean loop to generate lymphocytes

 for n=1:handles.iter       
        for j=1:40  % 40 beacouse length of signal is 40 and we construct lymphocytes long as signal
            for z=1:handles.k;  
                                 if d(j,1,z)>=handles.self(j,1)+handles.wahanie || d(j,1,z)<=handles.self(j,1)-handles.wahanie   
                    d(j,1,z)=d(j,1,z); 
                 else
                    d(j,1,z)=rand(1,1); % in if we have NEGATIVE SELECTION
                 end
                
           end
        end
end
  
 handles.d=d;
 guidata(hObject, handles);
 
 set(handles.text3,'visible','on');
 set(handles.anomalie,'visible','on')


% --- Executes on button press in anomalie.
function anomalie_Callback(hObject, eventdata, handles)
% annomaly
% here we add to axes with orginal signal signal with annomaly
if handles.wz==1

test=[0.2265 0.1423 0.2871 0.2186 0.273  0.1977 ...
     0.265  0.2008 0.1426 0.0567 0.17   0.0797 ...
     0.1772 0.187 0.2773 0.3113 0.2874 0.2288 ...
     0.3045 0.2572 0.3113 0.3174 0.2288 0.2871 0.2186 0.273...
     0.265  0.2508 0.316 0.3567 0.25   0.2797 0.1772 0.287 ...
     0.2645 0.232 0.3113 0.3574 0.2288 0.2871];
 test=test';
 test=test*1.2;
 
elseif handles.wz==2
    test=handles.wzorzec2;
    test(3)=rand(1,1);
    test(8)=rand(1,1);
    test(11)=rand(1,1);
    test(15)=rand(1,1);
    test(16)=rand(1,1);
    test(19)=rand(1,1);
    test(21)=rand(1,1);
    test(27)=rand(1,1);
    test(32)=rand(1,1);
    test(38)=rand(1,1);
    
end
 handles.test=test;
 
 cla(handles.axes1)
 plot(handles.test,'r--'), hold on ;plot(handles.self,'b');
 
  for i=1:handles.k   
    plot(handles.d(1:40,:,i),'m.')  
  end
 
 set(handles.detekcja,'visible','on')
 guidata(hObject, handles);


% --- Executes on button press in detekcja.
function detekcja_Callback(hObject, eventdata, handles)
% detection
a=0; 
for j=1:40
      for z=1:handles.k;
            dirr(j,z)=abs(handles.test(j,1)-handles.d(j,1,z));
      end
        d_test(j)=min(dirr(j,:)); 
        
          if d_test(j)>=0 && d_test(j)<=0.049   % 0.049 beacouse we think that orginal signal can be +/- 0.05
               plot(j,handles.test(j,1),'mo', ...
                            'LineWidth',2,...
                            'MarkerEdgeColor','k',...
                            'MarkerFaceColor',[.49 1 .63],...
                            'MarkerSize',7); hold on;
               a(j)=1;
          end
end

set(handles.text4,'visible','on')
set(handles.text5,'visible','on')
set(handles.text5,'string',sum(a))



% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)

%resetowanie programu
 set(handles.text1,'visible','off')
 set(handles.ile,'visible','off')
  set(handles.ile,'string','35')
 set(handles.limfocyty,'visible','off')
 set(handles.text3,'visible','off')
 set(handles.anomalie,'visible','off')
 set(handles.detekcja,'visible','off')
 set(handles.text4,'visible','off')
set(handles.text5,'visible','off')
 set(handles.ile_iteracji,'visible','off')
 set(handles.ile_iteracji,'string','400')
 set(handles.text7,'visible','off')
 
 cla(handles.axes1)


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ile_iteracji_Callback(hObject, eventdata, handles)
% hObject    handle to ile_iteracji (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ile_iteracji as text
%        str2double(get(hObject,'String')) returns contents of ile_iteracji as a double


% --- Executes during object creation, after setting all properties.
function ile_iteracji_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ile_iteracji (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end