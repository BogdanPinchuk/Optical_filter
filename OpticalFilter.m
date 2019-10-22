function varargout = OpticalFilter(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OpticalFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @OpticalFilter_OutputFcn, ...
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

function OpticalFilter_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = OpticalFilter_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%%%%%%%%%%%%%%%
%%%% ����� %%%%
%%%%%%%%%%%%%%%

function uipanel1_CreateFcn(hObject, eventdata, handles)
% ����� ���� �� �������� �������

% ��������� ���������
set(gcbo, 'Title', '������� ������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel2_CreateFcn(hObject, eventdata, handles)
% ����� ���� ��� ����������� �������

% ��������� ���������
set(gcbo, 'Title', '���������� �������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel3_CreateFcn(~, ~, ~)
% ����� ���� ��� ������ ��������

% ��������� ���������
set(gcbo, 'Title', '�������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel4_CreateFcn(~, ~, ~)
% ����� ���� ������

% ��������� ���������
set(gcbo, 'Title', '');

function pushbutton41_CreateFcn(~, ~, handles)
% ������� ������� �������

% ��������� ���������� ��������
set(gcbo, 'String', '�������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    '�������� ������� �������');

function pushbutton42_CreateFcn(hObject, eventdata, ~)
% �������� ������

% ��������� ���������� ��������
set(gcbo, 'String', '�����', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    '������� ��������� �����');

function pushbutton43_CreateFcn(hObject, eventdata, handles)
% ���������� ����������

% ��������� ���������� ��������
set(gcbo, 'String', '?', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    '� ��������');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton41_Callback(hObject, eventdata, handles)
% ������� ������� �������

% ������� ��������
for i = 0:9
    handles = clear_result(i, handles);
end

% ������� ����������
for i = 0:6
    handles = clear_var(i, handles);
end;

clear i;

% ������� ������������ ��������
set(handles.edit21, 'BackgroundColor', 'w');
set(handles.edit22, 'BackgroundColor', 'w');
set(handles.edit23, 'BackgroundColor', 'w');
set(handles.edit24, 'BackgroundColor', 'w');
set(handles.edit219, 'BackgroundColor', 'w');
set(handles.edit220, 'BackgroundColor', 'w');
set(handles.edit221, 'BackgroundColor', 'w');
set(handles.edit222, 'BackgroundColor', 'w');

% ���������� �������� ������
set(handles.edit12, 'Enable', 'off');
set(handles.edit14, 'Enable', 'off');
set(handles.edit16, 'Enable', 'off');

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);
 
function pushbutton42_Callback(hObject, eventdata, handles)
% �������� ������

% ������� ����
handles.Date = datestr(now);
guidata(gcbo, handles);

% ������� �����
DataReport = generate_report(handles);

fileID = fopen('OpticalFilterReport.m', 'w');

for i = 1:size(DataReport, 1)
    fprintf(fileID, '%s\r\n', DataReport{i,1});
end

FileAdress = imfinfo('figure1.bmp');
FileAdress = FileAdress.Filename;
FileAdress = strrep(FileAdress, '\figure1.bmp', '');

% ������� ����� � ������� *.doc
publish('OpticalFilterReport.m',...
    struct('format','doc','outputDir', FileAdress));

% ��������� ����
fclose(fileID);

clear fileID FileAdress;

% ������������� ����
movefile('OpticalFilterReport.doc',...
    [strrep(['����� ����������� ������������ ', handles.Date], ':', '.'),...
    '.doc']);

% ������� ������ �����
delete('figure1.bmp', 'figure2.bmp', 'figure3.bmp', 'figure4.bmp',...
    'OpticalFilterReport.m');

% ��������� � �������� ������
msgbox({'����� ��������� Optical Filter'...
    '������� � �����:'...
    [strrep(char(['����� ����������� ������������ ',...
    handles.Date]), ':', '.'), '.doc']},...
    '�����', 'help');

function pushbutton43_Callback(hObject, eventdata, handles)
% ���������� ����������

% ����� ��������� � ���������� ����
msgbox({'���������: Optical Filter'...
    '�����������: �� ��� "�������"'...
    '�����: ����-5'...
    '�����������: ������ �.�.'...
    '������� ������������: ����� �.�.'...
    '������������: ������������� �.�.'}, 'Info', 'help');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ������� ������ %%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function axes12_CreateFcn(hObject, eventdata, handles)
% ����� ������� ������� ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{start} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes13_CreateFcn(hObject, eventdata, handles)
% ������ ������� ����. ����������� ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{min} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes14_CreateFcn(hObject, eventdata, handles)
% ������� ������� ����. �������. ������. �� ��

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes15_CreateFcn(hObject, eventdata, handles)
% ����� ������� ����� �����

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{0.5l} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes16_CreateFcn(hObject, eventdata, handles)
% ������ ������� ����� �����

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{0.5r} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes17_CreateFcn(hObject, eventdata, handles)
% �������� ��������������� ������� �����������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'K_{�.��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes18_CreateFcn(hObject, eventdata, handles)
% �������� �������������� ������� �����������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'K_{�.��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function edit11_CreateFcn(hObject, eventdata, handles)
% �������� ����� ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� ������������ ��� �������');

% �������� ����������
handles.FileNameSf = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit12_CreateFcn(hObject, eventdata, handles)
% ����� ������� ������� ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ������� ��� ������ �� ������� ������������');

% ���������� �������� ������
set(gcbo, 'Enable', 'off');

% �������� ����������
handles.L_start = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit13_CreateFcn(hObject, eventdata, handles)
% ������ ������� ����. ����������� ������������

% ��������� ���������� ��������
set(gcbo, 'String', 0.01, 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������ ������� ����. �������. ������������');

% �������� ����������
handles.t_min = 0.01;
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit14_CreateFcn(~, eventdata, handles)
% ������� ������� ����. �������. ������. �� ��

% ��������� ���������� ��������
set(gcbo, 'String', 0.8, 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ������� ����. �������. ������������ �� ��');

% �������� ����������
handles.t_tz = 0.8;
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit15_CreateFcn(hObject, eventdata, handles)
% ����� ������� ����� �����

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ������� ����� ����� �� ��');

% �������� ����������
handles.L_05l = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit16_CreateFcn(hObject, eventdata, handles)
% ������ ������� ����� �����

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������ ������� ����� ����� �� ��');

% ���������� �������� ������
set(gcbo, 'Enable', 'off');

% �������� ����������
handles.L_05r = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit17_CreateFcn(~, eventdata, handles)
% �������� ��������������� ������� �����������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� ��������������� ������� �������. �� ��');

% �������� ����������
handles.K_pkv = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit18_CreateFcn(hObject, eventdata, handles)
% �������� �������������� ������� �����������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� �������������� ������� �������. �� ��');

% �������� ����������
handles.K_pdv = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit19_CreateFcn(hObject, eventdata, handles)
% �������� ����� ��������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� ��������');

% �������� ����������
handles.FileNameDt = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function pushbutton11_CreateFcn(hObject, eventdata, handles)
% �������� ����� ������������

% ��������� ���������� ��������
set(gcbo, 'String', '�����������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    '��������� ���� ������������ ��� �������');

% �������� ����������
handles.DataX_0 = '';
handles.DataY_0 = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function pushbutton19_CreateFcn(hObject, eventdata, handles)
% �������� ����� ��������

% ��������� ���������� ��������
set(gcbo, 'String', '�������', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString', '��������� ���� ��������');

% �������� ����������
handles.DataX_1 = '';
handles.DataY_1 = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function text12_CreateFcn(hObject, eventdata, handles)
% ����� ������� ������� ������������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text15_CreateFcn(hObject, eventdata, handles)
% ����� ������� ����� �����

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text16_CreateFcn(hObject, eventdata, handles)
% ������ ������� ����� �����

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function edit11_Callback(hObject, eventdata, handles)
% �������� ����� ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.FileNameSf) == 0
    % ���������� ��������
    set(handles.edit11, 'String', handles.FileNameSf);
else
    % ���������� ��������
    set(handles.edit11, 'String', '');
end;

function edit12_Callback(hObject, ~, handles)
% ����� ������� ������� ������������

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit12, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit12, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % ������� �������
    handles = clear_var(0, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % �������� ����������
    handles.L_start = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit12, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit12, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % ������� �������
        handles = clear_var(0, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % �������� ����������
        handles.L_start = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit12, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit12, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % ������� �������
            handles = clear_var(0, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);

            % �������� ����������
            handles.L_start = '';
        else
            % �������� �� ������������ ���������� ��������
            if str2num(get(handles.edit12, 'String')) < 0.0
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit12, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);
                
                % ������� �������
                handles = clear_var(0, handles);
                handles = clear_var(2, handles);
                handles = clear_var(3, handles);
                handles = clear_var(5, handles);
                
                % �������� ����������
                handles.L_start = '';
            else
                % �������� ����������
                handles.L_start = str2num(get(handles.edit12, 'String'));
                
                % �������� ������� ����������
                if (isempty(handles.t_min) == 1) || (isempty(handles.DataX_0) == 1)
                    % ��������� �������� �����, ��� ��������������� � ������
                    set(handles.edit12, 'ForegroundColor', 'r');

                    % ������� ���� �������
                    handles = clear_result(1, handles);
                    handles = clear_result(2, handles);
                    handles = clear_result(3, handles);
                    handles = clear_result(5, handles);
                    handles = clear_result(6, handles);
                    handles = clear_result(8, handles);
                    
                    % ������� �������
                    handles = clear_var(0, handles);
                    handles = clear_var(2, handles);
                    handles = clear_var(3, handles);
                    handles = clear_var(5, handles);
                else
                    % ��������, ��������� �� ��� �������� � ��������� ��������
                    % �������� ������� ������
                    if (handles.L_start < handles.DataX_0(1)) ||...
                            (handles.L_start > handles.DataX_0(end))
                        
                        % ��������� �������� �����, ��� ��������������� � ������
                        set(handles.edit12, 'ForegroundColor', 'r');

                        % ������� ���� �������
                        handles = clear_result(1, handles);
                        handles = clear_result(2, handles);
                        handles = clear_result(3, handles);
                        handles = clear_result(5, handles);
                        handles = clear_result(6, handles);
                        handles = clear_result(8, handles);

                        % ������� �������
                        handles = clear_var(0, handles);
                        handles = clear_var(2, handles);
                        handles = clear_var(3, handles);
                        handles = clear_var(5, handles);
                    else
                        % �������� ������
                        data = [handles.DataX_0, handles.DataY_0];

                        % ���������� ������ ���������� ��������
                        data(size(data, 1) + 1,:) = [handles.L_start 1.0];
                        data = sortrows(data, 1);
                        Ncenter = find(data == handles.L_start);

                        % ����� ���������� ��������
                        deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
                        deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
                        if deltaX1 <= deltaX2
                            Ncenter = Ncenter - 1;
                        end;

                        clear deltaX1 deltaX2 data;

                        % ���������� �������� t_start
                        t_start = handles.DataY_0(Ncenter);

                        % ��������� �������� t_min � t_start
                        if t_start <= handles.t_min
                            % ��������� �������� �����, ��� ��������������� � ������
                            set(handles.edit12, 'ForegroundColor', 'r');

                            % ������� ���� �������
                            handles = clear_result(1, handles);
                            handles = clear_result(2, handles);
                            handles = clear_result(3, handles);
                            handles = clear_result(5, handles);
                            handles = clear_result(6, handles);
                            handles = clear_result(8, handles);

                            % ������� �������
                            handles = clear_var(0, handles);
                            handles = clear_var(2, handles);
                            handles = clear_var(3, handles);
                            handles = clear_var(5, handles);

                            % �������� ����������
                            handles.L_start = '';
                        else
                            clear t_start;

                            % ����������� � ����������� �����
                            set(handles.edit12, 'ForegroundColor', 'k');
                            set(handles.edit13, 'ForegroundColor', 'k');

                            %%%%%%%%%%%%%%%%%
                            % ��������� �����
                            %%%%%%%%%%%%%%%%%

                            % ���������� ���������
                            handles = svetofiltr(handles);
                            handles = tz_svetofiltr(handles);

                            % ����������� �������
                            if isempty(handles.FileNameSf) == 0
                                % ���������� �������
                                graph_of(handles);
                            end;

                            % ����������� �������
                            if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0) && ...
                                    (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                                    (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                                % ������ ������� �������
                                handles = ploscha_analiz(handles);

                                if (isempty(handles.S_of) == 0) &&...
                                        strcmp(get(handles.edit12, 'Enable'), 'on')
                                    % ���������� �������
                                    graph_ansf(handles);
                                end;
                            end;

                            % ���������� ���������
                            handles = detector(handles);

                            % ����������� �������
                            if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                                    strcmp(get(handles.edit12, 'Enable'), 'on')

                                % ������ ���������
                                handles = detector_analiz(handles);

                                % ���������� �������
                                graph_det(handles);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit13_Callback(hObject, eventdata, handles)
% ������ ������� ����. �����������

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit13, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit13, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % ������� �������
    handles = clear_var(0, handles);
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % ���������� �������� ������
    set(handles.edit14, 'Enable', 'off');
    
    % �������� ����������
    handles.t_min = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit13, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit13, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % ������� �������
        handles = clear_var(0, handles);
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % ���������� �������� ������
        set(handles.edit14, 'Enable', 'off');
        
        % �������� ����������
        handles.t_min = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit13, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit13, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % ������� �������
            handles = clear_var(0, handles);
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);
            
            % ���������� �������� ������
            set(handles.edit14, 'Enable', 'off');
            
            % �������� ����������
            handles.t_min = '';
        else
            % �������� �� ������������ ���������� ��������
            if (str2num(get(handles.edit13, 'String')) < 0.0) ||...
                    (str2num(get(handles.edit13, 'String')) >= 1.0)
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit13, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);
                
                % ������� �������
                handles = clear_var(0, handles);
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                handles = clear_var(3, handles);
                handles = clear_var(5, handles);
                
                % ���������� �������� ������
                set(handles.edit14, 'Enable', 'off');
                
                % �������� ����������
                handles.t_min = '';
            else
                % �������� ����������
                handles.t_min = str2num(get(handles.edit13, 'String'));
                
                % ������������� �������� ������
                set(handles.edit14, 'Enable', 'on');
                
                % �������� �� ������� ����������
                if isempty(handles.t_tz) == 0
                    
                    % ��������� ��������� ������
                    if handles.t_min >= handles.t_tz
                        % ��������� �������� �����, ��� ��������������� � ������
                        set(handles.edit14, 'ForegroundColor', 'r');

                        % ������� ���� �������
                        handles = clear_result(1, handles);
                        handles = clear_result(2, handles);
                        handles = clear_result(3, handles);
                        handles = clear_result(4, handles);
                        handles = clear_result(5, handles);
                        handles = clear_result(6, handles);
                        handles = clear_result(8, handles);

                        % ������� �������
                        handles = clear_var(0, handles);
                        handles = clear_var(1, handles);
                        handles = clear_var(2, handles);
                        handles = clear_var(3, handles);
                        handles = clear_var(5, handles);
                    else
                        % ����������� � ����������� �����
                        set(handles.edit14, 'ForegroundColor', 'k');
                        
                        % ���������� ���������
                        handles = tz_svetofiltr(handles);
                        
                        % �������� ������� ����������
                        if (isempty(handles.L_start) == 1) ||...
                                (isempty(handles.DataX_0) == 1)
                            % ��������� �������� �����, ��� ��������������� � ������
                            set(handles.edit13, 'ForegroundColor', 'r');

                            % ������� ���� �������
                            handles = clear_result(1, handles);
                            handles = clear_result(2, handles);
                            handles = clear_result(3, handles);
                            handles = clear_result(5, handles);
                            handles = clear_result(6, handles);
                            handles = clear_result(8, handles);

                            % ������� �������
                            handles = clear_var(0, handles);
                            handles = clear_var(2, handles);
                            handles = clear_var(3, handles);
                            handles = clear_var(5, handles);
                        else
                            % �������� ������
                            data = [handles.DataX_0, handles.DataY_0];

                            % ���������� ������ ���������� ��������
                            data(size(data, 1) + 1,:) = [handles.L_start 1.0];
                            data = sortrows(data, 1);
                            Ncenter = find(data == handles.L_start);

                            % ����� ���������� ��������
                            deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
                            deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
                            if deltaX1 <= deltaX2
                                Ncenter = Ncenter - 1;
                            end;

                            clear deltaX1 deltaX2 data;

                            % ���������� �������� t_start
                            t_start = handles.DataY_0(Ncenter);

                            % ��������� �������� t_min � t_start
                            if t_start <= handles.t_min
                                % ��������� �������� �����, ��� ��������������� � ������
                                set(handles.edit12, 'ForegroundColor', 'r');

                                % ������� ���� �������
                                handles = clear_result(1, handles);
                                handles = clear_result(2, handles);
                                handles = clear_result(3, handles);
                                handles = clear_result(5, handles);
                                handles = clear_result(6, handles);
                                handles = clear_result(8, handles);

                                % ������� �������
                                handles = clear_var(0, handles);
                                handles = clear_var(2, handles);
                                handles = clear_var(3, handles);
                                handles = clear_var(5, handles);

                                % �������� ����������
                                handles.t_min = '';
                            else
                                clear t_start;

                                % ����������� � ����������� �����
                                set(handles.edit12, 'ForegroundColor', 'k');
                                set(handles.edit13, 'ForegroundColor', 'k');

                                %%%%%%%%%%%%%%%%%
                                % ��������� �����
                                %%%%%%%%%%%%%%%%%

                                % ���������� ���������
                                handles = svetofiltr(handles);

                                % ����������� �������
                                if isempty(handles.FileNameSf) == 0
                                    % ���������� �������
                                    graph_of(handles);
                                end;

                                % ����������� �������
                                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0) && ...
                                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                                    % ������ ������� �������
                                    handles = ploscha_analiz(handles);

                                    if (isempty(handles.S_of) == 0) &&...
                                            strcmp(get(handles.edit12, 'Enable'), 'on')
                                        % ���������� �������
                                        graph_ansf(handles);
                                    end;
                                end;

                                % ���������� ���������
                                handles = detector(handles);

                                % ����������� �������
                                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                                        strcmp(get(handles.edit12, 'Enable'), 'on')

                                    % ������ ���������
                                    handles = detector_analiz(handles);

                                    % ���������� �������
                                    graph_det(handles);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit14_Callback(hObject, eventdata, handles)
% ������� ������� ����. �������. ������. �� ��

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit14, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit14, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % ������� �������
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % �������� ����������
    handles.t_tz = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit14, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit14, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % ������� �������
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % �������� ����������
        handles.t_tz = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit14, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit14, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % ������� �������
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % �������� ����������
            handles.t_tz = '';
        else
            % �������� �� ������������ ���������� ��������
            if (str2num(get(handles.edit14, 'String')) <= ...
                    str2num(get(handles.edit13, 'String'))) ||...
                    (str2num(get(handles.edit14, 'String')) > 1.0)
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit14, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % ������� �������
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % �������� ����������
                handles.t_tz = '';
            else
                % ����������� � ����������� �����
                set(handles.edit14, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % ��������� �����
                %%%%%%%%%%%%%%%%%
                
                % �������� ����������
                handles.t_tz = str2num(get(handles.edit14, 'String'));
                
                % ���������� ���������
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % ����������� �������
                if isempty(handles.FileNameSf) == 0
                    % ���������� �������
                    graph_of(handles);
                end
                
                % ����������� �������
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % ������ ������� �������
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % ���������� �������
                        graph_ansf(handles);
                    end;
                end;
                
                % ���������� ���������
                handles = detector(handles);

                % ����������� �������
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % ������ ���������
                    handles = detector_analiz(handles);

                    % ���������� �������
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit15_Callback(hObject, eventdata, handles)
% ����� ������� ����� �����

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit15, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit15, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % ������� �������
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % ���������� �������� ������
    set(handles.edit16, 'Enable', 'off');
    
    % �������� ����������
    handles.L_05l = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit15, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit15, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % ������� �������
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % ���������� �������� ������
        set(handles.edit16, 'Enable', 'off');
        
        % �������� ����������
        handles.L_05l = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit15, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit15, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % ������� �������
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % ���������� �������� ������
            set(handles.edit16, 'Enable', 'off');
            
            % �������� ����������
            handles.L_05l = '';
        else
            % �������� �� ������������ ���������� ��������
            if str2num(get(handles.edit15, 'String')) <= 0.0
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit15, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % ������� �������
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % ���������� �������� ������
                set(handles.edit16, 'Enable', 'off');
                
                % �������� ����������
                handles.L_05l = '';
            else
                % ����������� � ����������� �����
                set(handles.edit15, 'ForegroundColor', 'k');
                
                % ������������� �������� ������
                set(handles.edit16, 'Enable', 'on');
                
                % �������� �� ������������ ���������� ��������
                if str2num(get(handles.edit16, 'String')) <=...
                        str2num(get(handles.edit15, 'String'))
                    % ��������� �������� �����, ��� ��������������� � ������
                    set(handles.edit16, 'ForegroundColor', 'r');

                    % ������� ���� �������
                    handles = clear_result(1, handles);
                    handles = clear_result(4, handles);
                    handles = clear_result(5, handles);

                    % ������� �������
                    handles = clear_var(1, handles);
                    handles = clear_var(2, handles);
                    
                    % �������� ����������
                    handles.L_05l = '';
                else
                    % ����������� � ����������� �����
                    set(handles.edit16, 'ForegroundColor', 'k');
                    
                    % �������� ����������
                    handles.L_05l = str2num(get(handles.edit15, 'String'));
                    handles.L_05r = str2num(get(handles.edit16, 'String'));
                    
                    %%%%%%%%%%%%%%%%%
                    % ��������� �����
                    %%%%%%%%%%%%%%%%%

                    % ���������� ���������
                    handles = svetofiltr(handles);
                    handles = tz_svetofiltr(handles);

                    % ����������� �������
                    if isempty(handles.FileNameSf) == 0
                        % ���������� �������
                        graph_of(handles);
                    end;

                    % ����������� �������
                    if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                            (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                            (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                        % ������ ������� �������
                        handles = ploscha_analiz(handles);

                        if (isempty(handles.S_of) == 0) &&...
                                strcmp(get(handles.edit12, 'Enable'), 'on')
                            % ���������� �������
                            graph_ansf(handles);
                        end;
                    end;

                    % ���������� ���������
                    handles = detector(handles);

                    % ����������� �������
                    if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')

                        % ������ ���������
                        handles = detector_analiz(handles);

                        % ���������� �������
                        graph_det(handles);
                    end;
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit16_Callback(hObject, eventdata, handles)
% ������ ������� ����� �����

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit16, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit16, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % ������� �������
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % �������� ����������
    handles.L_05r = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit16, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit16, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % ������� �������
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % �������� ����������
        handles.L_05r = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit16, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit16, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % ������� �������
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % �������� ����������
            handles.L_05r = '';
        else
            % �������� �� ������������ ���������� ��������
            if str2num(get(handles.edit16, 'String')) <=...
                    str2num(get(handles.edit15, 'String'))
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit16, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % ������� �������
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % �������� ����������
                handles.L_05r = '';
            else
                % ����������� � ����������� �����
                set(handles.edit16, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % ��������� �����
                %%%%%%%%%%%%%%%%%
                
                % �������� ����������
                handles.L_05l = str2num(get(handles.edit15, 'String'));
                handles.L_05r = str2num(get(handles.edit16, 'String'));
                
                % ���������� ���������
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % ����������� �������
                if isempty(handles.FileNameSf) == 0
                    % ���������� �������
                    graph_of(handles);
                end;
                
                % ����������� �������
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % ������ ������� �������
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % ���������� �������
                        graph_ansf(handles);
                    end;
                end;
                
                % ���������� ���������
                handles = detector(handles);

                % ����������� �������
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % ������ ���������
                    handles = detector_analiz(handles);

                    % ���������� �������
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit17_Callback(hObject, eventdata, handles)
% �������� ��������������� ������� �����������

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit17, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit17, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % ������� �������
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % �������� ����������
    handles.K_pkv = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit17, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit17, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % ������� �������
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % �������� ����������
        handles.K_pkv = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit17, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit17, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % ������� �������
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % �������� ����������
            handles.K_pkv = '';
        else
            % �������� �� ������������ ���������� ��������
            if str2num(get(handles.edit17, 'String')) <= 0.0
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit17, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % ������� �������
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % �������� ����������
                handles.K_pkv = '';
            else
                % ����������� � ����������� �����
                set(handles.edit17, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % ��������� �����
                %%%%%%%%%%%%%%%%%
                
                % �������� ����������
                handles.K_pkv = str2num(get(handles.edit17, 'String'));
                
                % ���������� ���������
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);
                
                % ����������� �������
                if isempty(handles.FileNameSf) == 0
                    % ���������� �������
                    graph_of(handles);
                end;
                
                % ����������� �������
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % ������ ������� �������
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % ���������� �������
                        graph_ansf(handles);
                    end;
                end;
                
                % ���������� ���������
                handles = detector(handles);

                % ����������� �������
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % ������ ���������
                    handles = detector_analiz(handles);

                    % ���������� �������
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit18_Callback(hObject, eventdata, handles)
% �������� �������������� ������� �����������

% �������� �� ������������ ����� ��������
if isempty(str2num(get(handles.edit18, 'String'))) == 1
    % ��������� �������� �����, ��� ��������������� � ������
    set(handles.edit18, 'ForegroundColor', 'r');
    
    % ������� ���� �������
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % ������� �������
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % �������� ����������
    handles.K_pdv = '';
else
    % �������� �� ���������� ��������� ������
    if length(str2num(get(handles.edit18, 'String'))) ~= 1
        % ��������� �������� �����, ��� ��������������� � ������
        set(handles.edit18, 'ForegroundColor', 'r');
        
        % ������� ���� �������
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % ������� �������
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % �������� ����������
        handles.K_pdv = '';
    else
        % �������� �� �������������
        if isreal(str2num(get(handles.edit18, 'String'))) == 0
            % ��������� �������� �����, ��� ��������������� � ������
            set(handles.edit18, 'ForegroundColor', 'r');
            
            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % ������� �������
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % �������� ����������
            handles.K_pdv = '';
        else
            % �������� �� ������������ ���������� ��������
            if str2num(get(handles.edit18, 'String')) <= 0.0
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit18, 'ForegroundColor', 'r');
                
                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % ������� �������
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % �������� ����������
                handles.K_pdv = '';
            else
                % ����������� � ����������� �����
                set(handles.edit18, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % ��������� �����
                %%%%%%%%%%%%%%%%%
                
                % �������� ����������
                handles.K_pdv = str2num(get(handles.edit18, 'String'));
                
                % ���������� ���������
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % ����������� �������
                if isempty(handles.FileNameSf) == 0
                    % ���������� �������
                    graph_of(handles);
                end;
                
                % ����������� �������
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % ������ ������� �������
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % ���������� �������
                        graph_ansf(handles);
                    end;
                end;
                
                % ���������� ���������
                handles = detector(handles);

                % ����������� �������
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % ������ ���������
                    handles = detector_analiz(handles);

                    % ���������� �������
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit19_Callback(hObject, eventdata, handles)
% �������� ����� ��������

% ��������� ����� ���������� ����������� ������
if isempty(handles.FileNameDt) == 0
    % ���������� ��������
    set(handles.edit19, 'String', handles.FileNameDt);
else
    % ���������� ��������
    set(handles.edit19, 'String', '');
end;

function pushbutton11_Callback(hObject, eventdata, handles)
% �������� ����� ������������

% �������� ���� ��� ������ �����
[handles.FileNameSf, PathName, FilterIndex] = uigetfile({'*.dpt'; '*.txt'; '*.xls*'});

% �������� �� ��������� �����
if handles.FileNameSf == 0
    % �������� ��������
    set(handles.edit11, 'String', '');
    handles.FileNameSf = [];
    
    % ���������� �������� ������
    set(handles.edit12, 'Enable', 'off');
    
    % ������� ���� �������
    handles = clear_result(0, handles);
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % ������� �������
    handles = clear_var(0, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % �������� ����������
    handles.DataX_0 = [];
    handles.DataY_0 = [];
else
    % �������� ���������
    if (FilterIndex == 1) && (FilterIndex == 2)
        data = importdata([PathName, handles.FileNameSf], ',');
    elseif (FilterIndex == 3)
        data = xlsread([PathName, handles.FileNameSf]);
    else
        data = importdata([PathName, handles.FileNameSf]);
    end;
    
    clear FilterIndex;
    
    % �������� ��������� �� ������� ������
    if isempty(data) == 1
        % �������� ��������
        set(handles.edit11, 'String', '');
        handles.FileNameSf = [];

        % ���������� �������� ������
        set(handles.edit12, 'Enable', 'off');

        % ������� ���� �������
        handles = clear_result(0, handles);
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % ������� �������
        handles = clear_var(0, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % �������� ����������
        handles.DataX_0 = [];
        handles.DataY_0 = [];
    else
        % �������� ��������
        set(handles.edit11, 'String', handles.FileNameSf);
    
        % ������������� �������� ������
        set(handles.edit12, 'Enable', 'on');
        
        % ������ ������ �� ���������� (�����. ��� ������.) � �� �����
        if size(data, 2) > size(data, 1)
            data = data';
        end;
        
        % ������ ���������� ������ � ����� ����
        Analiz = max(data(:, 1) - sort(data(:, 1)));
        if Analiz == 0
            handles.DataX_0 = data(:, 1);
            handles.DataY_0 = data(:, 2);
        else
            handles.DataX_0 = data(:, 2);
            handles.DataY_0 = data(:, 1);
        end;
        clear Analiz data;

        % ���������� ����. �����������
        if max(handles.DataY_0) > 1.0
            handles.DataY_0 = handles.DataY_0 ./ 100;
        end;
        
        % ���������� �������
        graph_of(handles);
        
        % �������� ������� ����������
        if (isempty(handles.t_min) == 1) || (isempty(handles.L_start) == 1)
            % ����������� � ����������� �����
            set(handles.edit12, 'ForegroundColor', 'k');

            % ������� ���� �������
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % ������� �������
            handles = clear_var(0, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);
        else
            % �������� ������
            data = [handles.DataX_0, handles.DataY_0];

            % ���������� ������ ���������� ��������
            data(size(data, 1) + 1,:) = [handles.L_start 1.0];
            data = sortrows(data, 1);
            Ncenter = find(data == handles.L_start);

            % ����� ���������� ��������
            deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
            deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
            if deltaX1 <= deltaX2
                Ncenter = Ncenter - 1;
            end;

            clear deltaX1 deltaX2 data;

            % ���������� �������� t_start
            t_start = handles.DataY_0(Ncenter);

            % ��������� �������� t_min � t_start
            if t_start <= handles.t_min
                % ��������� �������� �����, ��� ��������������� � ������
                set(handles.edit12, 'ForegroundColor', 'r');

                % ������� ���� �������
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);

                % �������� ����������
                handles.L_start = '';
            else
                clear t_start;

                % ����������� � ����������� �����
                set(handles.edit12, 'ForegroundColor', 'k');
                set(handles.edit13, 'ForegroundColor', 'k');

                %%%%%%%%%%%%%%%%%
                % ��������� �����
                %%%%%%%%%%%%%%%%%

                % ���������� ���������
                handles = svetofiltr(handles);
                
                % ����������� �������
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                    % ������ ���������
                    handles = tz_svetofiltr(handles);

                    % ������ ������� �������
                    handles = ploscha_analiz(handles);

                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % ���������� �������
                        graph_ansf(handles);
                    end;
                end;

                % ���������� ���������
                handles = detector(handles);

                % ����������� �������
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % ������ ���������
                    handles = detector_analiz(handles);

                    % ���������� �������
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% �������
clear PathName;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function pushbutton19_Callback(hObject, eventdata, handles)
% �������� ����� ��������

% �������� ���� ��� ������ �����
[handles.FileNameDt, PathName, FilterIndex] = uigetfile({'*.dpt'; '*.txt'; '*.xls*'});

% �������� �� ��������� �����
if handles.FileNameDt == 0
    % �������� ��������
    set(handles.edit19, 'String', '');
    handles.FileNameDt = [];
    
    % ������� ���� �������
    handles = clear_result(2, handles);
    handles = clear_result(6, handles);
    handles = clear_result(7, handles);
    handles = clear_result(8, handles);
    
    % ������� �������
    handles = clear_var(3, handles);
    handles = clear_var(4, handles);
    handles = clear_var(5, handles);
    
    % �������� ����������
    handles.DataX_1 = [];
    handles.DataY_1 = [];
else
    % �������� ���������
    if (FilterIndex == 1) && (FilterIndex == 2)
        data = importdata([PathName, handles.FileNameDt], ',');
    elseif (FilterIndex == 3)
        data = xlsread([PathName, handles.FileNameDt]);
    else
        data = importdata([PathName, handles.FileNameDt]);
    end;
    
    clear FilterIndex;
    
    % �������� ��������� �� ������� ������
    if isempty(data) == 1
        % �������� ��������
        set(handles.edit11, 'String', '');
        handles.FileNameDt = [];

        % ������� ���� �������
        handles = clear_result(2, handles);
        handles = clear_result(6, handles);
        handles = clear_result(7, handles);
        handles = clear_result(8, handles);
        
        % ������� �������
        handles = clear_var(3, handles);
        handles = clear_var(4, handles);
        handles = clear_var(5, handles);
        
        % �������� ����������
        handles.DataX_1 = [];
        handles.DataY_1 = [];
    else
        % �������� ��������
        set(handles.edit19, 'String', handles.FileNameDt);
        
        % ������ ������ �� ���������� (�����. ��� ������.) � �� �����
        if size(data, 2) > size(data, 1)
            data = data';
        end;
        
        % ������ ���������� ������ � ����� ����
        Analiz = max(data(:, 1) - sort(data(:, 1)));
        if Analiz == 0
            handles.DataX_1 = data(:, 1);
            handles.DataY_1 = data(:, 2);
        else
            handles.DataX_1 = data(:, 2);
            handles.DataY_1 = data(:, 1);
        end;
        clear Analiz data;

        % ���������� ����. �����������
        if max(handles.DataY_1) ~= 1.0
            handles.DataY_1 = handles.DataY_1 ./ max(handles.DataY_1);
        end;
        
        % ���������� ���������
        handles = detector(handles);
        
        % ����������� �������
        if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                strcmp(get(handles.edit12, 'Enable'), 'on')
            
            % ������ ���������
            handles = detector_analiz(handles);
            
            % ���������� �������
            graph_det(handles);
        end;
    end;
end;

% �������
clear PathName;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ���������� �������� %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function axes21_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� ������������� ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes22_CreateFcn(hObject, eventdata, handles)
% �������������� ������� ������������� ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes23_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� �������� ������������� ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes24_CreateFcn(hObject, eventdata, handles)
% �������������� ������� �������� ������������� ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes25_CreateFcn(hObject, eventdata, handles)
% ������������ ����. �������. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{max} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes26_CreateFcn(hObject, eventdata, handles)
% ����� ����� ��� ������������ ����. �������. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{max} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes27_CreateFcn(hObject, eventdata, handles)
% ������� ����. ����������� ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{��.��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes28_CreateFcn(hObject, eventdata, handles)
% ������� ����. ����������� ������������ � ������� ������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{��.��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes29_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ����. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'S_{OF} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes210_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ������������ �� ��

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'S_{T3} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes211_CreateFcn(hObject, eventdata, handles)
% ��������� �������� ��� ������� ����. �������. �������������

% ���� ����������� (�������)
text('Interpreter', 'latex', 'String', '$$\frac{S_{OF}}{S_{T3}} =$$',...
    'VerticalAlignment', 'bottom', 'FontSize', 12);
set(gca, 'Visible', 'off');

function axes212_CreateFcn(hObject, eventdata, handles)
% �������� ��������������� ������� �������. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'K_{�.�.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes213_CreateFcn(hObject, eventdata, handles)
% �������� �������������� ������� �������. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'K_{�.�.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes214_CreateFcn(hObject, eventdata, handles)
% ������������ ������ ������� ������ ����������� �� ������� 0.5

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\Delta\lambda_{05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes215_CreateFcn(hObject, eventdata, handles)
% ����� ����� ����� ������� ������ �����������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes216_CreateFcn(hObject, eventdata, handles)
% ������� �������. ������ ������������ � ��������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'S_{f.d} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes217_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ��������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', 'S_{det} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes218_CreateFcn(hObject, eventdata, handles)
% ��������� �������� ��� ������ ����. �������. ����. � ���������.

% ���� ����������� (�������)
text('Interpreter', 'latex', 'String', '$$\frac{S_{f.d}}{S_{det}} =$$',...
    'VerticalAlignment', 'bottom', 'FontSize', 12);
set(gca, 'Visible', 'off');

function axes219_CreateFcn(hObject, eventdata, handles)
% ������������� ����. �������. ������������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\tau_{��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes220_CreateFcn(hObject, eventdata, handles)
% ������������� ������. ������ ������ �����������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\Delta\lambda_{��} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes221_CreateFcn(hObject, eventdata, handles)
% ������������� �����������. ������� ������. ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes222_CreateFcn(hObject, eventdata, handles)
% ������������� ����������. ������� ������. ���������

% ���� ����������� (�������)
text('Interpreter', 'tex', 'String', '\lambda_{��.�} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function edit21_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '��������������� ������� ������. ����.');

% �������� ����������
handles.L_kvh = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit22_CreateFcn(hObject, eventdata, handles)
% �������������� ������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������������� ������� ������. ����.');

% �������� ����������
handles.L_dvh = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit23_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� �������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ����� ��� ������ 0.5 �� �����������. ������� �������.');

% �������� ����������
handles.L_kvh05 = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit24_CreateFcn(hObject, eventdata, handles)
% �������������� ������� �������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ����� ��� ������ 0.5 �� ����������. ������� �������.');

% �������� ����������
handles.L_dvh05 = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit25_CreateFcn(hObject, eventdata, handles)
% ������������ ����. �������. ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������������ ����. �������. ������������');

% �������� ����������
handles.t_max = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit26_CreateFcn(hObject, eventdata, handles)
% ����� ����� ��� ������������ ����. �������. ������.

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ����� ��� ������. ����. �������. ������������');

% �������� ����������
handles.L_max = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit27_CreateFcn(hObject, eventdata, handles)
% ������� ����. ����������� ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ����. ����������� ������������');

% �������� ����������
handles.t_srsf = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit28_CreateFcn(hObject, eventdata, handles)
% ������� ����. ����������� ������������ � ������� ������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ����. �������. ������������� ������������');

% �������� ����������
handles.t_srup = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit29_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ����. ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ��� ������ ����. �������. ������������ ��� �������');

% �������� ����������
handles.S_of = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit210_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ������������ �� ��

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ��� ������ ����. �������. ������������ �� ��');

% �������� ����������
handles.S_tz = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit211_CreateFcn(hObject, eventdata, handles)
% ��������� �������� ��� ������� ����. �������. �������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '��������� �������� ��� ������� ����. �������. ������.');

% �������� ����������
handles.S_oftz = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit212_CreateFcn(hObject, eventdata, handles)
% �������� ��������������� ������� �������. ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� �����������. ������� �������. ������������');

% �������� ����������
handles.K_pks = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit213_CreateFcn(hObject, eventdata, handles)
% �������� �������������� ������� �������. ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '�������� ����������. ������� �������. ������������');

% �������� ����������
handles.K_pds = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit214_CreateFcn(hObject, eventdata, handles)
% ������������ ������ ������� ������ ����������� �� ������� 0.5

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������. ������ ������� ������ �������. �� ������� 0.5');

% �������� ����������
handles.dL_05 = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit215_CreateFcn(hObject, eventdata, handles)
% ����� ����� ����� ������� ������ �����������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '����� ����� ����� ������� ������ �����������');

% �������� ����������
handles.dL_sr = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit216_CreateFcn(hObject, eventdata, handles)
% ������� �������. ������ ������������ � ��������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� �������. ������ ������������ � ��������');

% �������� ����������
handles.S_fd = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit217_CreateFcn(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ��������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������� ��� ������ ����. �������. ��������');

% �������� ����������
handles.S_det = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit218_CreateFcn(hObject, eventdata, handles)
% ��������� �������� ��� ������ ����. �������. ����. � ���������.

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '��������� �������� ��� ������ ����. �������. ����. � ���������.');

% �������� ����������
handles.S_fdet = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit219_CreateFcn(hObject, eventdata, handles)
% ������������� ����. �������. ������������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������������� ����. �������. ������������');

% �������� ����������
handles.t_lim = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit220_CreateFcn(hObject, eventdata, handles)
% ������������� ������. ������ ������ �����������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������������� ������. ������ ������ �����������');

% �������� ����������
handles.dL_lim = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit221_CreateFcn(hObject, eventdata, handles)
% ������������� �����������. ������� ������. ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������������� �����������. ������� ������. ���������');

% �������� ����������
handles.L_kvh_e = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function edit222_CreateFcn(hObject, eventdata, handles)
% ������������� ����������. ������� ������. ���������

% ��������� ���������� ��������
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', '������������� ����������. ������� ������. ���������');

% �������� ����������
handles.L_dvh_e = '';
% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function text21_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text22_CreateFcn(hObject, eventdata, handles)
% �������������� ������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text23_CreateFcn(hObject, eventdata, handles)
% ��������������� ������� �������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text24_CreateFcn(hObject, eventdata, handles)
% �������������� ������� �������� ������������� ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text26_CreateFcn(hObject, eventdata, handles)
% ����� ����� ��� ������������ ����. �������. ������.

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text221_CreateFcn(hObject, eventdata, handles)
% ������������� �����������. ������� ������. ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text214_CreateFcn(hObject, eventdata, handles)
% ������������ ������ ������� ������ ����������� �� ������� 0.5

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text215_CreateFcn(hObject, eventdata, handles)
% ����� ����� ����� ������� ������ �����������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text220_CreateFcn(hObject, eventdata, handles)
% ������������� ������. ������ ������ �����������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text222_CreateFcn(hObject, eventdata, handles)
% ������������� ����������. ������� ������. ���������

% ��������� ���������� ��������
set(gcbo, 'String', '���', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function edit21_Callback(hObject, eventdata, handles)
% ��������������� ������� ������������� ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_kvh) == 0
    % ���������� ��������
    set(handles.edit21, 'String', roundn(handles.L_kvh, -2));
else
    % ���������� ��������
    set(handles.edit21, 'String', '');
end;

function edit22_Callback(hObject, eventdata, handles)
% �������������� ������� ������������� ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_dvh) == 0
    % ���������� ��������
    set(handles.edit22, 'String', roundn(handles.L_dvh, -2));
else
    % ���������� ��������
    set(handles.edit22, 'String', '');
end;

function edit23_Callback(hObject, eventdata, handles)
% ��������������� ������� �������� ������������� ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_kvh05) == 0
    % ���������� ��������
    set(handles.edit23, 'String', roundn(handles.L_kvh05, -2));
else
    % ���������� ��������
    set(handles.edit23, 'String', '');
end;

function edit24_Callback(hObject, eventdata, handles)
% �������������� ������� �������� ������������� ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_dvh05) == 0
    % ���������� ��������
    set(handles.edit24, 'String', roundn(handles.L_dvh05, -2));
else
    % ���������� ��������
    set(handles.edit24, 'String', '');
end;

function edit25_Callback(hObject, eventdata, handles)
% ������������ ����. �������. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.t_max) == 0
    % ���������� ��������
    set(handles.edit25, 'String', roundn(handles.t_max, -2));
else
    % ���������� ��������
    set(handles.edit25, 'String', '');
end;

function edit26_Callback(hObject, eventdata, handles)
% ����� ����� ��� ������������ ����. �������. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_max) == 0
    % ���������� ��������
    set(handles.edit26, 'String', roundn(handles.L_max, -2));
else
    % ���������� ��������
    set(handles.edit26, 'String', '');
end;

function edit27_Callback(hObject, eventdata, handles)
% ������� ����. ����������� ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.t_srsf) == 0
    % ���������� ��������
    set(handles.edit27, 'String', roundn(handles.t_srsf, -2));
else
    % ���������� ��������
    set(handles.edit27, 'String', '');
end;

function edit28_Callback(hObject, eventdata, handles)
% ������� ����. ����������� ������������ � ������� ������

% ��������� ����� ���������� ����������� ������
if isempty(handles.t_srup) == 0
    % ���������� ��������
    set(handles.edit28, 'String', roundn(handles.t_srup, -2));
else
    % ���������� ��������
    set(handles.edit28, 'String', '');
end;

function edit29_Callback(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ����. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_of) == 0
    % ���������� ��������
    set(handles.edit29, 'String', roundn(handles.S_of, -3));
else
    % ���������� ��������
    set(handles.edit29, 'String', '');
end;

function edit210_Callback(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ������������ �� ��

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_tz) == 0
    % ���������� ��������
    set(handles.edit210, 'String', roundn(handles.S_tz, -3));
else
    % ���������� ��������
    set(handles.edit210, 'String', '');
end;

function edit211_Callback(hObject, eventdata, handles)
% ��������� �������� ��� ������ ����. �������. �������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_oftz) == 0
    % ���������� ��������
    set(handles.edit211, 'String', roundn(handles.S_oftz, -3));
else
    % ���������� ��������
    set(handles.edit211, 'String', '');
end;

function edit212_Callback(hObject, eventdata, handles)
% �������� ��������������� ������� �������. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.K_pks) == 0
    % ���������� ��������
    set(handles.edit212, 'String', roundn(handles.K_pks, -2));
else
    % ���������� ��������
    set(handles.edit212, 'String', '');
end;

function edit213_Callback(hObject, eventdata, handles)
% �������� �������������� ������� �������. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.K_pds) == 0
    % ���������� ��������
    set(handles.edit213, 'String', roundn(handles.K_pds, -2));
else
    % ���������� ��������
    set(handles.edit213, 'String', '');
end;

function edit214_Callback(hObject, eventdata, handles)
% ������������ ������ ������� ������ ����������� �� ������� 0.5

% ��������� ����� ���������� ����������� ������
if isempty(handles.dL_05) == 0
    % ���������� ��������
    set(handles.edit214, 'String', roundn(handles.dL_05, -2));
else
    % ���������� ��������
    set(handles.edit214, 'String', '');
end;

function edit215_Callback(hObject, eventdata, handles)
% ����� ����� ����� ������� ������ �����������

% ��������� ����� ���������� ����������� ������
if isempty(handles.dL_sr) == 0
    % ���������� ��������
    set(handles.edit215, 'String', roundn(handles.dL_sr, -2));
else
    % ���������� ��������
    set(handles.edit215, 'String', '');
end;

function edit216_Callback(hObject, eventdata, handles)
% ������� �������. ������ ������������ � ��������

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_fd) == 0
    % ���������� ��������
    set(handles.edit216, 'String', roundn(handles.S_fd, -3));
else
    % ���������� ��������
    set(handles.edit216, 'String', '');
end;

function edit217_Callback(hObject, eventdata, handles)
% ������� ��� ������ ����. �������. ��������

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_det) == 0
    % ���������� ��������
    set(handles.edit217, 'String', roundn(handles.S_det, -3));
else
    % ���������� ��������
    set(handles.edit217, 'String', '');
end;

function edit218_Callback(hObject, eventdata, handles)
% ��������� �������� ��� ������ ����. �������. ����. � ���������.

% ��������� ����� ���������� ����������� ������
if isempty(handles.S_fdet) == 0
    % ���������� ��������
    set(handles.edit218, 'String', roundn(handles.S_fdet, -3));
else
    % ���������� ��������
    set(handles.edit218, 'String', '');
end;

function edit219_Callback(hObject, eventdata, handles)
% ������������� ����. �������. ������������

% ��������� ����� ���������� ����������� ������
if isempty(handles.t_lim) == 0
    % ���������� ��������
    set(handles.edit219, 'String', roundn(handles.t_lim, -2));
else
    % ���������� ��������
    set(handles.edit219, 'String', '');
end;

function edit220_Callback(hObject, eventdata, handles)
% ������������� ������. ������ ������ �����������

% ��������� ����� ���������� ����������� ������
if isempty(handles.dL_lim) == 0
    % ���������� ��������
    set(handles.edit220, 'String', roundn(handles.dL_lim, -2));
else
    % ���������� ��������
    set(handles.edit220, 'String', '');
end;

function edit221_Callback(hObject, eventdata, handles)
% ������������� �����������. ������� ������. ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_kvh_e) == 0
    % ���������� ��������
    set(handles.edit221, 'String', roundn(handles.L_kvh_e, -2));
else
    % ���������� ��������
    set(handles.edit221, 'String', '');
end;

function edit222_Callback(hObject, eventdata, handles)
% ������������� ����������. ������� ������. ���������

% ��������� ����� ���������� ����������� ������
if isempty(handles.L_dvh_e) == 0
    % ���������� ��������
    set(handles.edit222, 'String', roundn(handles.L_dvh_e, -2));
else
    % ���������� ��������
    set(handles.edit222, 'String', '');
end;

%%%%%%%%%%%%%%%%%
%%%% ������� %%%%
%%%%%%%%%%%%%%%%%

function axes31_CreateFcn(hObject, eventdata, handles)
% ������������ ����. ����������� ������������

% ������� �������
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

function axes32_CreateFcn(hObject, eventdata, handles)
% ������ ����������� ������������

% ������� �������
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

function axes33_CreateFcn(hObject, eventdata, handles)
% ��������� ������������ � ��������

% ������� �������
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% �������������� ������� %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = clear_result(num, handles)
% ������� ��������� ����� � ��������

switch num
    case 0
        % ������� �������
        set(handles.axes31, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % ������� ��������
        title(handles.axes31, '');
        xlabel(handles.axes31, '');
        ylabel(handles.axes31, '');
        
        % ������� ���������� �������
        set(handles.axes31, 'ButtonDownFcn', '');
    case 1
        % ������� �������
        set(handles.axes32, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % ������� ��������
        title(handles.axes32, '');
        xlabel(handles.axes32, '');
        ylabel(handles.axes32, '');
        
        % ������� ���������� �������
        set(handles.axes32, 'ButtonDownFcn', '');
    case 2
        % ������� �������
        set(handles.axes33, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % ������� ��������
        title(handles.axes33, '');
        xlabel(handles.axes33, '');
        ylabel(handles.axes33, '');
        
        % ������� ���������� �������
        set(handles.axes33, 'ButtonDownFcn', '');
    case 3
        % ������� �����
        set(handles.edit21, 'String', '');
        set(handles.edit22, 'String', '');
        set(handles.edit23, 'String', '');
        set(handles.edit24, 'String', '');
        set(handles.edit25, 'String', '');
        set(handles.edit26, 'String', '');
        set(handles.edit27, 'String', '');
        set(handles.edit28, 'String', '');
        set(handles.edit29, 'String', '');
        set(handles.edit212, 'String', '');
        set(handles.edit213, 'String', '');
        set(handles.edit214, 'String', '');
        set(handles.edit215, 'String', '');
        set(handles.edit219, 'String', '');
        set(handles.edit220, 'String', '');
        set(handles.edit221, 'String', '');
        set(handles.edit222, 'String', '');
    case 4
        set(handles.edit210, 'String', '');
    case 5
        set(handles.edit211, 'String', '');
    case 6
        set(handles.edit216, 'String', '');
    case 7
        set(handles.edit217, 'String', '');
    case 8
        set(handles.edit218, 'String', '');
    otherwise
        set(handles.edit11, 'String', '');
        set(handles.edit12, 'String', '');
        set(handles.edit13, 'String', '');
        set(handles.edit14, 'String', '');
        set(handles.edit15, 'String', '');
        set(handles.edit16, 'String', '');
        set(handles.edit17, 'String', '');
        set(handles.edit18, 'String', '');
        set(handles.edit19, 'String', '');
end;

function handles = clear_var(num, handles)
% ������� �������� ����������

switch num
    case 0
        % ������� �����
        handles.L_kvh = [];
        handles.L_dvh = [];
        handles.L_kvh05 = [];
        handles.L_dvh05 = [];
        handles.t_max = [];
        handles.L_max = [];
        handles.t_srsf = [];
        handles.t_srup = [];
        handles.S_of = [];
        handles.K_pks = [];
        handles.K_pds = [];
        handles.dL_05 = [];
        handles.dL_sr = [];
        handles.t_lim = [];
        handles.dL_lim = [];
        handles.L_kvh_e = [];
        handles.L_dvh_e = [];
        % ������� ������
        handles.DataX = [];
        handles.DataY = [];
        handles.func_of = [];
    case 1
        % ������� �����
        handles.S_tz = [];
        % ������� ������
        handles.Data_tzX = [];
        handles.Data_tzY = [];
        handles.func_tz = [];
    case 2
        % ������� �����
        handles.S_oftz = [];
    case 3
        % ������� �����
        handles.S_fd = [];
    case 4
        % ������� �����
        handles.S_det = [];
        % ������� ������
        handles.DataX_1 = [];
        handles.DataY_1 = [];
        handles.func_det = [];
        handles.FileNameDt = [];
    case 5
        % ������� �����
        handles.S_fdet = [];
        % ������� ������
        handles.DataX_2 = [];
        handles.DataY_2 = [];
        handles.func_fd = [];
    otherwise
        % ������� �����
        handles.L_start = [];
        handles.t_min = [];
        handles.t_tz = [];
        handles.L_05l = [];
        handles.L_05r = [];
        handles.K_pkv = [];
        handles.K_pdv = [];
        % ������� ������
        handles.DataX_0 = [];
        handles.DataY_0 = [];
        handles.FileNameSf = [];
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function graph_of(handles)
% ���������� ������� ������������

% ������� ������
handles = clear_result(0, handles);

% ��������� ����������� ��������� ���������� ��������
set(handles.axes31, 'NextPlot', 'new');
set(handles.axes31, 'NextPlot', 'replace');

p1 = plot(handles.axes31, handles.DataX_0, handles.DataY_0, 'LineWidth', 2, 'Color', 'b');

title(handles.axes31, '�����������', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes31, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes31, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% ����������� ���
set(handles.axes31, 'YTickLabel', '', 'XTick', roundn([handles.DataX_0(1) handles.DataX_0(end)], -1),...
    'YTick', 0, 'XLim', roundn([handles.DataX_0(1) handles.DataX_0(end)], -1), 'YLim', [0 1]);

% ������ ���������� �������
set(handles.axes31, 'ButtonDownFcn', {@mouse_click_axes31, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes31, handles});

clear p1;

function graph_ansf(handles)
% ���������� ������� ������� ������������

% ������� ������
handles = clear_result(1, handles);

% ��������� ����������� ��������� ���������� ��������
set(handles.axes32, 'NextPlot', 'replace');
p1 = plot(handles.axes32, handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');

% �������� ����������� ��������� ���������� ��������
set(handles.axes32, 'NextPlot', 'new');
p2 = plot(handles.axes32, handles.Data_tzX, handles.Data_tzY, 'LineWidth', 2, 'Color', 'r');

Data_X = [handles.L_kvh_e; handles.L_kvh_e; handles.L_dvh_e; handles.L_dvh_e];
Data_Y = [handles.t_min; handles.t_lim; handles.t_lim; handles.t_min];

p3 = plot(handles.axes32, Data_X, Data_Y, 'LineWidth', 2, 'Color', 'g');

title(handles.axes32, '������', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes32, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes32, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% ����������� ���
set(handles.axes32, 'YTickLabel', '', 'XTick', roundn([min([handles.DataX(1),...
    handles.Data_tzX(1), Data_X(1)]) max([handles.DataX(end), handles.Data_tzX(end),...
    Data_X(end)])], -1), 'YTick', 0, 'XLim', roundn([min([handles.DataX(1),...
    handles.Data_tzX(1), Data_X(1)]) max([handles.DataX(end), handles.Data_tzX(end),...
    Data_X(end)])], -1), 'YLim', [0 1]);

clear Data_X Data_Y;

% ������ ���������� �������
set(handles.axes32, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p2, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p3, 'ButtonDownFcn', {@mouse_click_axes32, handles});

clear p1 p2 p3;

function graph_det(handles)
% ���������� ������� ������� ��������

% ������� ������
handles = clear_result(2, handles);

% ��������� ����������� ��������� ���������� ��������
set(handles.axes33, 'NextPlot', 'replace');
p1 = plot(handles.axes33,handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');

% �������� ����������� ��������� ���������� ��������
set(handles.axes33, 'NextPlot', 'new');
p2 = plot(handles.axes33, handles.DataX_1, handles.DataY_1, 'LineWidth', 2, 'Color', 'r');

% �������� �������
set(handles.axes33, 'NextPlot', 'new');
p3 = stem(handles.axes33, handles.DataX_2, handles.DataY_2, 'LineWidth', 0.5,...
    'Marker', 'none', 'Color', [0.6 0.6 0.6]);

title(handles.axes33, '�������', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes33, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes33, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% ����������� ���
set(handles.axes33, 'YTickLabel', '', 'XTick', roundn([min(handles.DataX(1),...
    handles.DataX_1(1)) max(handles.DataX(end), handles.DataX_1(end))], -1),...
    'YTick', 0, 'XLim', roundn([min(handles.DataX(1), handles.DataX_1(1))...
    max(handles.DataX(end), handles.DataX_1(end))], -1), 'YLim', [0 1]);

% ������ ���������� �������
set(handles.axes33, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p2, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p3, 'ButtonDownFcn', {@mouse_click_axes33, handles});

clear p1 p2 p3;

function handles = mouse_click_axes31(src, evt, handles)
% ���������� ������� ������������

% �������� ������ ����
handles.f2 = figure(2);
set(gcf, 'Name', '�����������', 'NumberTitle', 'off');
plot(handles.DataX_0, handles.DataY_0, 'LineWidth', 2);
grid on;
title('����������� ����������� ������������', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('����� ����� \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('����������� �����������    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([handles.DataX_0(1) handles.DataX_0(end)]);
ylim([0.0 1.0]);

% ������� ������
legend('�����������', 0);

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = mouse_click_axes32(src, evt, handles)
% ���������� ������� ������������ ��� �������

% �������� ������ ����
handles.f3 = figure(3);
set(gcf, 'Name', '������ ������������', 'NumberTitle', 'off');
plot(handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');
hold on;
plot(handles.Data_tzX, handles.Data_tzY, 'LineWidth', 2, 'Color', 'r');

Data_X = [handles.L_kvh_e; handles.L_kvh_e; handles.L_dvh_e; handles.L_dvh_e];
Data_Y = [handles.t_min; handles.t_lim; handles.t_lim; handles.t_min];

plot(Data_X, Data_Y, 'LineWidth', 2, 'Color', 'g');

hold off;
grid on;
title('������ ������������ ����������� ������������ �� ��', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('����� ����� \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('����������� �����������    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([min([handles.DataX(1), handles.Data_tzX(1), Data_X(1)])...
    max([handles.DataX(end), handles.Data_tzX(end), Data_X(end)])]);
ylim([0.0 1.0]);

clear Data_X Data_Y;

% ������� ������
legend('�����������', '����������� �� ��', '�����. �����������', 0);

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = mouse_click_axes33(src, evt, handles)
% ���������� ������� �������� ��� �������

% �������� ������ ����
handles.f4 = figure(4);
set(gcf, 'Name', '������ ��������', 'NumberTitle', 'off');
plot(handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');
hold on;
plot(handles.DataX_1, handles.DataY_1, 'LineWidth', 2, 'Color', 'r');
hold on;

% �������� �������
stem(handles.DataX_2, handles.DataY_2, 'LineWidth', 0.5,...
    'Marker', 'none', 'Color', [0.6 0.6 0.6]);

hold off;
grid on;
title('������ ������������ ����������� ��������', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('����� ����� \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('����������� �����������    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([min(handles.DataX(1), handles.DataX_1(1))...
    max(handles.DataX(end), handles.DataX_1(end))]);
ylim([0.0 1.0]);

% ������� ������
legend('�����������', '�������', 0);

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = svetofiltr(handles)
% ������ ���������� ������� ��������� � ������������

% ������� ����� ���������� ������
handles.DataX = [];
handles.DataY = [];

% �������� ������
if (isempty(handles.L_start) == 0) && (isempty(handles.t_min) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    
    % �������� ������
    handles.DataX = handles.DataX_0;
    handles.DataY = handles.DataY_0;
    data = [handles.DataX, handles.DataY];
    
    % ���������� ������ ���������� ��������
    data(size(data, 1) + 1,:) = [handles.L_start 1.0];
    data = sortrows(data, 1);
    Ncenter = find(data == handles.L_start);
    
    % �������� ���� ��������
    Ncenter = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    
    % ����� ���������� ��������
    deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
    deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
    if deltaX1 <= deltaX2
        Ncenter = Ncenter - 1;
    end;
    
    clear deltaX1 deltaX2 data;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �������������� ������� ������������� ���������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = Ncenter;
    %i = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    while (handles.t_min < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    
    % ������������� ���� ������� ������ t_min, � ���������� ������
    % ����������
    if i == size(handles.DataY, 1)
        set(handles.edit22, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit22, 'BackgroundColor', 'w');
    end;
    
    % �������� ����������
    handles.L_dvh = handles.DataX(i);
    
    % �������� ������ ��������
    handles.DataX = handles.DataX(1:i);
    handles.DataY = handles.DataY(1:i);
    
    % ���������� ��������
    set(handles.edit22, 'String', roundn(handles.L_dvh, -2));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ��������������� ������� ������������� ���������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = Ncenter;
    %i = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    while (handles.t_min < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    
    % ������������� ���� ������� ������ t_min, � ���������� ������
    % ����������
    if i == 1
        set(handles.edit21, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit21, 'BackgroundColor', 'w');
    end;
    
    clear Ncenter;
    
    % �������� ����������
    handles.L_kvh = handles.DataX(i);
    
    % �������� ������ ��������
    handles.DataX = handles.DataX(i:end);
    handles.DataY = handles.DataY(i:end);
    
    % ���������� ��������
    set(handles.edit21, 'String', roundn(handles.L_kvh, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������������ ����. �������. ������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ����������
    handles.t_max = max(handles.DataY);
    
    % ���������� ��������
    set(handles.edit25, 'String', roundn(handles.t_max, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ����� ����� ��� ������������ ����. �������. ������.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ����� ������������� ��������
    N_max = find(handles.DataY == handles.t_max);
    % � ������ ���������� ����������
    if size(N_max, 1) > 1
        N_max = N_max(round(size(N_max, 1)/2.0));
    end;
    
    % �������� ����������
    handles.L_max = handles.DataX(N_max);
    
    % ���������� ��������
    set(handles.edit26, 'String', roundn(handles.L_max, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ��������������� ������� �������� ������������� ��������� (0.5)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = N_max;
    while ((0.5 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    
    % ������������� ���� ������ � ���������� ������
    if (0.5 * handles.t_max) < handles.DataY(i)
        set(handles.edit23, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit23, 'BackgroundColor', 'w');
    end;
    
    % �������� ����������
    handles.L_kvh05 = handles.DataX(i);
    
    % ���������� ��������
    set(handles.edit23, 'String', roundn(handles.L_kvh05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �������������� ������� �������� ������������� ��������� (0.5)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = N_max;
    while ((0.5 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    
    % ������������� ���� ������ � ���������� ������
    if (0.5 * handles.t_max) < handles.DataY(i)
        set(handles.edit24, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit24, 'BackgroundColor', 'w');
    end;
    
    % �������� ����������
    handles.L_dvh05 = handles.DataX(i);
    
    % ���������� ��������
    set(handles.edit24, 'String', roundn(handles.L_dvh05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������������ ������ ������� ������ ����������� �� ������� 0.5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ����������
    handles.dL_05 = abs(handles.L_dvh05 - handles.L_kvh05);
    
    % ���������� ��������
    set(handles.edit214, 'String', roundn(handles.dL_05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ����� ����� ����� ������� ������ �����������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ����������
    handles.dL_sr = (0.5 * handles.dL_05) + handles.L_dvh05;
    
    % ���������� ��������
    set(handles.edit215, 'String', roundn(handles.dL_sr, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� ����. ����������� ������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ������������� ����. �����������
    if handles.t_max > 0.6
        i = N_max;
        while (0.6 < handles.DataY(i)) &&...
                (i ~= 1)
            i = i - 1;
        end;
        L_kvh06 = handles.DataX(i);
        
        i = N_max;
        while (0.6 < handles.DataY(i)) &&...
                (i ~= size(handles.DataY, 1))
            i = i + 1;
        end;
        L_dvh06 = handles.DataX(i);
        
    else
        i = N_max;
        while ((0.8 * handles.t_max) < handles.DataY(i)) &&...
                (i ~= 1)
            i = i - 1;
        end;
        L_kvh06 = handles.DataX(i);
        
        i = N_max;
        while ((0.8 * handles.t_max) < handles.DataY(i)) &&...
                (i ~= size(handles.DataY, 1))
            i = i + 1;
        end;
        L_dvh06 = handles.DataX(i);
        
    end;
    
    clear i;
    
    % �������� ����������
    handles.t_srsf = sum(handles.DataY(find(handles.DataX == L_kvh06):...
        find(handles.DataX == L_dvh06))) / abs(find(handles.DataX ==...
        L_dvh06) - find(handles.DataX == L_kvh06));
    
    % ���������� ��������
    set(handles.edit27, 'String', roundn(handles.t_srsf, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� ����. ����������� ������������ � ������� ������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    i = N_max;
    while ((0.8 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    L_kvh08 = handles.DataX(i);

    i = N_max;
    while ((0.8 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    L_dvh08 = handles.DataX(i);
    
    clear i;
    
    % �������� ����������
    handles.t_srup = sum(handles.DataY(find(handles.DataX == L_kvh08):...
        find(handles.DataX == L_dvh08))) / abs(find(handles.DataX ==...
        L_dvh08) - find(handles.DataX == L_kvh08));
    
    clear L_kvh08 L_dvh08;
    
    % ���������� ��������
    set(handles.edit28, 'String', roundn(handles.t_srup, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �������� ��������������� ������� �������. ������������
    % �������� �������������� ������� �������. ������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = N_max;
    while (0.1 < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    L_kvh01 = handles.DataX(i);
    
    i = N_max;
    while (0.1 < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    L_dvh01 = handles.DataX(i);
    
    clear i N_max;
    
    % �������� ����������
    handles.K_pks = L_kvh01 / L_kvh06;
    handles.K_pds = L_dvh01 / L_dvh06;
    
    clear L_kvh01 L_dvh01 L_kvh06 L_dvh06;
    
    % ���������� ��������
    set(handles.edit212, 'String',  roundn(handles.K_pks, -2));
    set(handles.edit213, 'String',  roundn(handles.K_pds, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� ��� ������ ����. �������. ����. ������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ������� ������������
    handles.func_of = @(z)interp1(handles.DataX, handles.DataY, z);
    
    % ���������� ������� ��� ������ ������������
    handles.S_of = integral(handles.func_of, handles.L_kvh, handles.L_dvh);
    
    % ���������� ��������
    set(handles.edit29, 'String',  roundn(handles.S_of, -3));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������������� ������������� ����������� ������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ���������� �����. ����. �������. ������������
    handles.t_lim = handles.S_of / handles.dL_05;
    
    % ������������� ���� �����. ������ ����������� ������ �������
    % ������ ������ �����������
    if handles.t_lim > 1.0
        set(handles.edit219, 'BackgroundColor', [0.0 0.8 1.0]);
        set(handles.edit220, 'BackgroundColor', [0.0 0.8 1.0]);
        set(handles.edit221, 'BackgroundColor', [0.0 0.8 1.0]);
        set(handles.edit222, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit219, 'BackgroundColor', 'w');
        set(handles.edit220, 'BackgroundColor', 'w');
        set(handles.edit221, 'BackgroundColor', 'w');
        set(handles.edit222, 'BackgroundColor', 'w');
    end;
    
    % ������ �������� ������ ������ �����������
    handles.dL_lim = handles.dL_05;
    
    % ��������� ������� �����. ������ �����������
    handles.L_kvh_e = handles.L_kvh05;
    handles.L_dvh_e = handles.L_dvh05;
    
    % �������� �� ������������ ��������
    if handles.t_lim > 1.0
        % ������������� �������� �������
        handles.t_lim = 1.0;
        
        % ������ �������� ������ ������ �����������
        handles.dL_lim = handles.S_of;

        % ���������� ��������
        set(handles.edit220, 'String',  roundn(handles.dL_lim, -2));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ��������� ������� �����. ������ �����������
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        handles.L_kvh_e = handles.L_kvh05 - 0.5 * (handles.S_of - handles.dL_05);
        
        handles.L_dvh_e = handles.L_dvh05 + 0.5 * (handles.S_of - handles.dL_05);
    end;
    
    % ���������� ��������
    set(handles.edit219, 'String',  roundn(handles.t_lim, -2));
    set(handles.edit220, 'String',  roundn(handles.dL_lim, -2));
    set(handles.edit221, 'String',  roundn(handles.L_kvh_e, -2));
    set(handles.edit222, 'String',  roundn(handles.L_dvh_e, -2));
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = tz_svetofiltr(handles)
% ������ ���������� ������� ��������� � ������� ������������

if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
    
    % �����, ������ ����� ���������� ������� ������
    t_osn = 0.5;
    
    % ����� ����. ����������� �������� �������
    t_01 = 0.1;
    t_06 = 0.6;
    
    % ���������� ����� � ������ �����
    l_opl = handles.L_05l * ((t_06 - t_01) / ((t_osn - t_01) * (1 - handles.K_pkv) + handles.K_pkv * (t_06 - t_01)));
    l_opr = handles.L_05r * ((t_06 - t_01) / ((t_osn - t_01) * (1 - handles.K_pdv) + handles.K_pdv * (t_06 - t_01)));
    
    clear t_osn;

    % ������� ������� �� ������� ������ 
%     f_l = @(z)((((z - l_opl * handles.K_pkv) * (t_06 - t_01)) / (l_opl * (1 - handles.K_pkv))) + t_01);
%     f_r = @(z)((((z - l_opr * handles.K_pdv) * (t_06 - t_01)) / (l_opr * (1 - handles.K_pdv))) + t_01);
%   clear f_l f_r;

    % ������� ��� ���������� ��������� ����� ���������� �������
    g_l = @(z)(l_opl * (((z - t_01) * (1 - handles.K_pkv) / (t_06 - t_01)) + handles.K_pkv));
    g_r = @(z)(l_opr * (((z - t_01) * (1 - handles.K_pdv) / (t_06 - t_01)) + handles.K_pdv));
    
    clear t_01 t_06 l_opl l_opr;

    % ���������� ������� ����� ���������� �������
    Lminl = g_l(handles.t_min);
    Lmaxl = g_l(handles.t_tz);
    Lminr = g_r(handles.t_tz);
    Lmaxr = g_r(handles.t_min);
    
    clear g_l g_r;
    
    % ���������� ����� �������
    handles.Data_tzX = [Lminl; Lmaxl; Lminr; Lmaxr];
    handles.Data_tzY = [handles.t_min; handles.t_tz; handles.t_tz; handles.t_min];
    
    clear Lmaxl Lmaxr Lminl Lminr;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� ��� ������ ����. �������. ������������ �� ��
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ������� ������������ ��
    handles.func_tz = @(z)interp1(handles.Data_tzX, handles.Data_tzY, z);
    
    % ���������� ������� ��� ������ ������������
    handles.S_tz = integral(handles.func_tz, min(handles.Data_tzX), max(handles.Data_tzX));
    
    % ���������� ��������
    set(handles.edit210, 'String',  roundn(handles.S_tz, -3));
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = ploscha_analiz(handles)
% ������ ������������� ������� ������� ��������� � ������� ������������

if (isempty(handles.S_of) == 0) && (isempty(handles.S_tz) == 0)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ��������� �������� ��� ������ ����. �������. �������������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    handles.S_oftz = handles.S_of / handles.S_tz;
    
    % ���������� ��������
    set(handles.edit211, 'String',  roundn(handles.S_oftz, -3));
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = detector(handles)
% ������ ���������� ������� ��������� ��������

if (isempty(handles.DataY_1) == 0)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� ��� ������ ����. �������. ��������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ������� ��������
    handles.func_det = @(z)interp1(handles.DataX_1, handles.DataY_1, z);
    
    % ���������� ������� ��� ������ ������������
    handles.S_det = integral(handles.func_det, min(handles.DataX_1), max(handles.DataX_1));
    
    % ���������� ��������
    set(handles.edit217, 'String',  roundn(handles.S_det, -3));
    
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function handles = detector_analiz(handles)
% ������ ���������� ������� ��������� � ������� ��������

if (isempty(handles.S_of) == 0) && (isempty(handles.S_det) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ������� �������. ������ ������������ � ��������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % ������� ������������ �������
    func_of = @(z)handles.func_of(z);
    func_det = @(z)handles.func_det(z);
    handles.func_fd = @(z)(min(func_of(z), func_det(z)));
    
    % ��������� ������� �����������
    Xmin = max(handles.DataX(1), handles.DataX_1(1));
    Xmax = min(handles.DataX(end), handles.DataX_1(end));
    
    % �������� ������� ������
    if Xmin >= Xmax
        % ���������� ��������
        set(handles.edit216, 'String', 'NaN');
        set(handles.edit218, 'String', 'NaN');
        
        handles.S_fd = NaN;
        handles.S_fdet = NaN;
    else
        % ����������� ������� ������� ������������ � ��������
        handles.S_fd = integral(handles.func_fd,...
            max(handles.DataX(1), handles.DataX_1(1)),...
            min(handles.DataX(end), handles.DataX_1(end)));
        
        % ���������� ��������
        set(handles.edit216, 'String',  roundn(handles.S_fd, -3));
    end;

    clear func_of func_det;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % ��������� �������� ��� ������ ����. �������. ����. � ���������.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % �������� ������� ������
    if Xmin < Xmax
        % ����������� ��������� �������� �������� � ������������
        handles.S_fdet = handles.S_fd / handles.S_det;
        
        % ���������� ��������
        set(handles.edit218, 'String',  roundn(handles.S_fdet, -3));
    end;
    
    % ���������� ��� ������ (��� ����������)
    handles.DataX_2 = union(handles.DataX, handles.DataX_1);

    % ������� ������ ������ � �������� ������ ������
    handles.DataX_2 = handles.DataX_2(1:find(handles.DataX_2 == Xmax));
    handles.DataX_2 = handles.DataX_2(find(handles.DataX_2 == Xmin):end);
    
    clear Xmin Xmax;
    
    % ����������� ��������
    handles.DataY_2 = handles.func_fd(handles.DataX_2);
end;

% ���������� ������ ��� ������ �������
guidata(gcbo, handles);

function DataReport = generate_report(handles)
% ��������� ������ ��� ����� *.doc

% ������� ����������
DataReport = [];
DataReport{size(DataReport, 1) + 1, 1} = '%% *����� ��������� Optical Filter*';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = char(['% *����:* _', handles.Date, '_']);
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% ��������� ��������� ����������� ������ � ��������� � ����������
if isempty(get(handles.edit11, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� ������������ ��� �������: _',...
        get(handles.edit11, 'String'), '_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit19, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� �������� ��� �������: _',...
        get(handles.edit19, 'String'), '_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*������� ������:*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

if (isempty(get(handles.edit12, 'String')) == 0) &&...
    strcmp(get(handles.edit12, 'Enable'), 'on')
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ������� ��� ������ �� ������� ������������: *',...
        get(handles.edit12, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit13, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������ ������� ������������ ����������� ������������: *',...
        get(handles.edit13, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit14, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ������� ������������ ����������� ������������ �� ��: *',...
        get(handles.edit14, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit15, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ������� ����� ����� �� ��: *',...
        get(handles.edit15, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if (isempty(get(handles.edit16, 'String')) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������ ������� ����� ����� �� ��: *',...
        get(handles.edit16, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit17, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� ��������������� ������� ����������� �� ��: *',...
        get(handles.edit17, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit18, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� �������������� ������� ����������� �� ��: *',...
        get(handles.edit18, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*���������� �������:*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

if isempty(get(handles.edit21, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ��������������� ������� ������������� ���������: *',...
        get(handles.edit21, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit22, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������������� ������� ������������� ���������: *',...
        get(handles.edit22, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end

if isempty(get(handles.edit23, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ����� ��� ������ 0.5 �� ��������������� ������� �����������: *',...
        get(handles.edit23, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit24, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ����� ��� ������ 0.5 �� �������������� ������� �����������: *',...
        get(handles.edit24, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit25, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������ ����������� ����������� ������������: *',...
        get(handles.edit25, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit26, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ����� ��� ������������ ������������ ����������� ������������: *',...
        get(handles.edit26, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit27, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ����������� ����������� ������������: *',...
        get(handles.edit27, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit28, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ����������� ����������� ������������� ������������: *',...
        get(handles.edit28, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit29, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ��� ������ ����������� ������������ ��� �������: *',...
        get(handles.edit29, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit212, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� ��������������� ������� ����������� ������������: *',...
        get(handles.edit212, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit213, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% �������� �������������� ������� ����������� ������������: *',...
        get(handles.edit213, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit214, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������ ������ ������� ������ ����������� �� ������ 0.5: *',...
        get(handles.edit214, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit215, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ����� ����� ������ ������� ������ �����������: *',...
        get(handles.edit215, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit210, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ��� ������ ����������� ����������� ������������ �� ��: *',...
        get(handles.edit210, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit211, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ��������� �������� ��� ������� ������������ ����������� ������������: *',...
        get(handles.edit211, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit219, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������� ����������� ����������� ������������: *',...
        get(handles.edit219, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit220, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������� ������������ ������ ������ �����������: *',...
        get(handles.edit220, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit221, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������� ��������������� ������� ������������� ���������: *',...
        get(handles.edit221, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit222, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������������� �������������� ������� ������������� ���������: *',...
        get(handles.edit22, 'String'), '* _���_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit216, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ����������� ������ ������������ � ��������: *',...
        get(handles.edit216, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit217, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ������� ��� ������ ������������ ����������� ��������: *',...
        get(handles.edit217, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit218, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% ��������� �������� ��� ������ ������������ ����������� �������� � �����������: *',...
        get(handles.edit218, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*���������� ����*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% ��������� ����������� ����������� ����
saveas(handles.figure1, 'figure1.bmp');

% ���������� ����� �����������
AdressFile = imfinfo('figure1.bmp');

DataReport{size(DataReport, 1) + 1, 1} =...
    char(['% <<', AdressFile.Filename, '>>']);

DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% ������ ������������
if isempty(handles.DataX_0) == 0
    % ������ ������ ������������
    handles = mouse_click_axes31(0, 0, handles);
    
    % ��������� �����������
    saveas(handles.f2, 'figure2.bmp');
    
    % ���������� ����� �����������
    AdressFile = imfinfo('figure2.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*������ ������������ ����������� ������������:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % ��������� ���� �������
    close(handles.f2);
end;

% ������ ������������ ��� �������
if (isempty(handles.DataX) == 0) &&...
        (isempty(handles.Data_tzX) == 0)
    % ������ ������ ������������
    handles = mouse_click_axes32(0, 0, handles);
    
    % ��������� �����������
    saveas(handles.f3, 'figure3.bmp');
    
    % ���������� ����� �����������
    AdressFile = imfinfo('figure3.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*������ ������� ������������ ����������� ������������ �� ��:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % ��������� ���� �������
    close(handles.f3);
end

% ������ �������� ��� �������
if (isempty(handles.DataX) == 0) &&...
        (isempty(handles.DataX_1) == 0)
    % ������ ������ ������������
    handles = mouse_click_axes33(0, 0, handles);
    
    % ��������� �����������
    saveas(handles.f4, 'figure4.bmp');
    
    % ���������� ����� �����������
    AdressFile = imfinfo('figure4.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*������ ������������ ����������� ��������:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % ��������� ���� �������
    close(handles.f4);
end

%%%%%%%%%%%%%%%%%%%%%%%
%%%% ����� ������� %%%%
%%%%%%%%%%%%%%%%%%%%%%%
