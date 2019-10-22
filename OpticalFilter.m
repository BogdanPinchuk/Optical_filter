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
%%%% Блоки %%%%
%%%%%%%%%%%%%%%

function uipanel1_CreateFcn(hObject, eventdata, handles)
% Часть окна со входними данными

% Начальные настройки
set(gcbo, 'Title', 'Входные данные', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel2_CreateFcn(hObject, eventdata, handles)
% Часть окна для результатов расчета

% Начальные настройки
set(gcbo, 'Title', 'Результаты расчета', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel3_CreateFcn(~, ~, ~)
% Часть окна для вывода графиков

% Начальные настройки
set(gcbo, 'Title', 'Графики', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'FontAngle', 'italic');

function uipanel4_CreateFcn(~, ~, ~)
% Часть окна отчета

% Начальные настройки
set(gcbo, 'Title', '');

function pushbutton41_CreateFcn(~, ~, handles)
% Очистка рабочей области

% Установка начального значения
set(gcbo, 'String', 'Очистка', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    'Очистить рабочую область');

function pushbutton42_CreateFcn(hObject, eventdata, ~)
% Создание отчета

% Установка начального значения
set(gcbo, 'String', 'Отчет', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    'Создать текстовый отчет');

function pushbutton43_CreateFcn(hObject, eventdata, handles)
% Справочная информация

% Установка начального значения
set(gcbo, 'String', '?', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    'О програме');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton41_Callback(hObject, eventdata, handles)
% Очистка рабочей области

% Очистка областей
for i = 0:9
    handles = clear_result(i, handles);
end

% Очистка переменных
for i = 0:6
    handles = clear_var(i, handles);
end;

clear i;

% Очистка подсвеченных областей
set(handles.edit21, 'BackgroundColor', 'w');
set(handles.edit22, 'BackgroundColor', 'w');
set(handles.edit23, 'BackgroundColor', 'w');
set(handles.edit24, 'BackgroundColor', 'w');
set(handles.edit219, 'BackgroundColor', 'w');
set(handles.edit220, 'BackgroundColor', 'w');
set(handles.edit221, 'BackgroundColor', 'w');
set(handles.edit222, 'BackgroundColor', 'w');

% Блокировка вводимых данных
set(handles.edit12, 'Enable', 'off');
set(handles.edit14, 'Enable', 'off');
set(handles.edit16, 'Enable', 'off');

% Сохранение данных для общего доступа
guidata(gcbo, handles);
 
function pushbutton42_Callback(hObject, eventdata, handles)
% Создание отчета

% Создаем дату
handles.Date = datestr(now);
guidata(gcbo, handles);

% Создаем отчет
DataReport = generate_report(handles);

fileID = fopen('OpticalFilterReport.m', 'w');

for i = 1:size(DataReport, 1)
    fprintf(fileID, '%s\r\n', DataReport{i,1});
end

FileAdress = imfinfo('figure1.bmp');
FileAdress = FileAdress.Filename;
FileAdress = strrep(FileAdress, '\figure1.bmp', '');

% Создаем отчёт в формате *.doc
publish('OpticalFilterReport.m',...
    struct('format','doc','outputDir', FileAdress));

% Закрываем файл
fclose(fileID);

clear fileID FileAdress;

% Перейменовуем файл
movefile('OpticalFilterReport.doc',...
    [strrep(['Отчет пропускания светофильтра ', handles.Date], ':', '.'),...
    '.doc']);

% Удаляем лишние файлы
delete('figure1.bmp', 'figure2.bmp', 'figure3.bmp', 'figure4.bmp',...
    'OpticalFilterReport.m');

% Оповещаем о создании отчета
msgbox({'Отчет программы Optical Filter'...
    'сохранён в файле:'...
    [strrep(char(['Отчет пропускания светофильтра ',...
    handles.Date]), ':', '.'), '.doc']},...
    'Отчёт', 'help');

function pushbutton43_Callback(hObject, eventdata, handles)
% Справочная информация

% Вывод сообщения в диалоговое окно
msgbox({'Программа: Optical Filter'...
    'Предприятие: КП СПБ "Арсенал"'...
    'Отдел: НВТК-5'...
    'Разработчик: Пинчук Б.Ю.'...
    'Научный руководитель: Тягур В.М.'...
    'Руководитель: Добровольська К.В.'}, 'Info', 'help');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Входные данные %%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function axes12_CreateFcn(hObject, eventdata, handles)
% Центр отсчета графика светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{start} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes13_CreateFcn(hObject, eventdata, handles)
% Нижняя граница коэф. пропускания светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{min} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes14_CreateFcn(hObject, eventdata, handles)
% Верхняя граница коэф. пропуск. светоф. по ТЗ

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{тз} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes15_CreateFcn(hObject, eventdata, handles)
% Левая опорная длина волны

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{0.5l} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes16_CreateFcn(hObject, eventdata, handles)
% Правая опорная длина волны

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{0.5r} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes17_CreateFcn(hObject, eventdata, handles)
% Крутизна коротковолновой границы пропускания

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'K_{р.кв} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes18_CreateFcn(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропускания

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'K_{р.дв} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function edit11_CreateFcn(hObject, eventdata, handles)
% Название файла светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Название светофильтра для анализа');

% Создание переменной
handles.FileNameSf = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit12_CreateFcn(hObject, eventdata, handles)
% Центр отсчета графика светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Центр отсчета для поиска на графике светофильтра');

% Блокировка вводимых данных
set(gcbo, 'Enable', 'off');

% Создание переменной
handles.L_start = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit13_CreateFcn(hObject, eventdata, handles)
% Нижняя граница коэф. пропускания светофильтра

% Установка начального значения
set(gcbo, 'String', 0.01, 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Нижняя граница коэф. пропуск. светофильтра');

% Создание переменной
handles.t_min = 0.01;
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit14_CreateFcn(~, eventdata, handles)
% Верхняя граница коэф. пропуск. светоф. по ТЗ

% Установка начального значения
set(gcbo, 'String', 0.8, 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Верхняя граница коэф. пропуск. светофильтра по ТЗ');

% Создание переменной
handles.t_tz = 0.8;
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit15_CreateFcn(hObject, eventdata, handles)
% Левая опорная длина волны

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Левая опорная длина волны по ТЗ');

% Создание переменной
handles.L_05l = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit16_CreateFcn(hObject, eventdata, handles)
% Правая опорная длина волны

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Правая опорная длина волны по ТЗ');

% Блокировка вводимых данных
set(gcbo, 'Enable', 'off');

% Создание переменной
handles.L_05r = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit17_CreateFcn(~, eventdata, handles)
% Крутизна коротковолновой границы пропускания

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Крутизна коротковолновой границы пропуск. по ТЗ');

% Создание переменной
handles.K_pkv = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit18_CreateFcn(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропускания

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Крутизна длинноволновой границы пропуск. по ТЗ');

% Создание переменной
handles.K_pdv = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit19_CreateFcn(hObject, eventdata, handles)
% Название файла приёмника

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Название приёмника');

% Создание переменной
handles.FileNameDt = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function pushbutton11_CreateFcn(hObject, eventdata, handles)
% Загрузка файла светофильтра

% Установка начального значения
set(gcbo, 'String', 'Светофильтр', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString',...
    'Загрузить файл светофильтра для анализа');

% Создание переменной
handles.DataX_0 = '';
handles.DataY_0 = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function pushbutton19_CreateFcn(hObject, eventdata, handles)
% Загрузка файла приёмника

% Установка начального значения
set(gcbo, 'String', 'Приёмник', 'FontName', 'Times New Roman',...
    'FontSize', 10, 'TooltipString', 'Загрузить файл приёмника');

% Создание переменной
handles.DataX_1 = '';
handles.DataY_1 = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function text12_CreateFcn(hObject, eventdata, handles)
% Центр отсчета графика светофильтра

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text15_CreateFcn(hObject, eventdata, handles)
% Левая опорная длина волны

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text16_CreateFcn(hObject, eventdata, handles)
% Правая опорная длина волны

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function edit11_Callback(hObject, eventdata, handles)
% Название файла светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.FileNameSf) == 0
    % Записываем значение
    set(handles.edit11, 'String', handles.FileNameSf);
else
    % Записываем значение
    set(handles.edit11, 'String', '');
end;

function edit12_Callback(hObject, ~, handles)
% Центр отсчета графика светофильтра

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit12, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit12, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % Очистка расчета
    handles = clear_var(0, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % Создание переменной
    handles.L_start = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit12, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit12, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % Очистка расчета
        handles = clear_var(0, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % Создание переменной
        handles.L_start = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit12, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit12, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % Очистка расчета
            handles = clear_var(0, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);

            % Создание переменной
            handles.L_start = '';
        else
            % Проверка на адекватность введенного значения
            if str2num(get(handles.edit12, 'String')) < 0.0
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit12, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);
                
                % Очистка расчета
                handles = clear_var(0, handles);
                handles = clear_var(2, handles);
                handles = clear_var(3, handles);
                handles = clear_var(5, handles);
                
                % Создание переменной
                handles.L_start = '';
            else
                % Создание переменной
                handles.L_start = str2num(get(handles.edit12, 'String'));
                
                % Проверка наличия переменной
                if (isempty(handles.t_min) == 1) || (isempty(handles.DataX_0) == 1)
                    % Установка красного цвета, что свидетельствует о ошибке
                    set(handles.edit12, 'ForegroundColor', 'r');

                    % Очистка окна расчета
                    handles = clear_result(1, handles);
                    handles = clear_result(2, handles);
                    handles = clear_result(3, handles);
                    handles = clear_result(5, handles);
                    handles = clear_result(6, handles);
                    handles = clear_result(8, handles);
                    
                    % Очистка расчета
                    handles = clear_var(0, handles);
                    handles = clear_var(2, handles);
                    handles = clear_var(3, handles);
                    handles = clear_var(5, handles);
                else
                    % Проверка, находится ли это значение в диапазоне значений
                    % согласно входным данным
                    if (handles.L_start < handles.DataX_0(1)) ||...
                            (handles.L_start > handles.DataX_0(end))
                        
                        % Установка красного цвета, что свидетельствует о ошибке
                        set(handles.edit12, 'ForegroundColor', 'r');

                        % Очистка окна расчета
                        handles = clear_result(1, handles);
                        handles = clear_result(2, handles);
                        handles = clear_result(3, handles);
                        handles = clear_result(5, handles);
                        handles = clear_result(6, handles);
                        handles = clear_result(8, handles);

                        % Очистка расчета
                        handles = clear_var(0, handles);
                        handles = clear_var(2, handles);
                        handles = clear_var(3, handles);
                        handles = clear_var(5, handles);
                    else
                        % Создание масива
                        data = [handles.DataX_0, handles.DataY_0];

                        % Нахождение номера ближайшего значения
                        data(size(data, 1) + 1,:) = [handles.L_start 1.0];
                        data = sortrows(data, 1);
                        Ncenter = find(data == handles.L_start);

                        % Поиск ближайшего значения
                        deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
                        deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
                        if deltaX1 <= deltaX2
                            Ncenter = Ncenter - 1;
                        end;

                        clear deltaX1 deltaX2 data;

                        % Нахождение значения t_start
                        t_start = handles.DataY_0(Ncenter);

                        % Сравнение значения t_min с t_start
                        if t_start <= handles.t_min
                            % Установка красного цвета, что свидетельствует о ошибке
                            set(handles.edit12, 'ForegroundColor', 'r');

                            % Очистка окна расчета
                            handles = clear_result(1, handles);
                            handles = clear_result(2, handles);
                            handles = clear_result(3, handles);
                            handles = clear_result(5, handles);
                            handles = clear_result(6, handles);
                            handles = clear_result(8, handles);

                            % Очистка расчета
                            handles = clear_var(0, handles);
                            handles = clear_var(2, handles);
                            handles = clear_var(3, handles);
                            handles = clear_var(5, handles);

                            % Создание переменной
                            handles.L_start = '';
                        else
                            clear t_start;

                            % Возвращение к нормальному цвету
                            set(handles.edit12, 'ForegroundColor', 'k');
                            set(handles.edit13, 'ForegroundColor', 'k');

                            %%%%%%%%%%%%%%%%%
                            % Расчетная часть
                            %%%%%%%%%%%%%%%%%

                            % Выполнение программы
                            handles = svetofiltr(handles);
                            handles = tz_svetofiltr(handles);

                            % Отображение графика
                            if isempty(handles.FileNameSf) == 0
                                % Построение графика
                                graph_of(handles);
                            end;

                            % Отображение графика
                            if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0) && ...
                                    (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                                    (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                                % Расчет площади анализа
                                handles = ploscha_analiz(handles);

                                if (isempty(handles.S_of) == 0) &&...
                                        strcmp(get(handles.edit12, 'Enable'), 'on')
                                    % Построение графика
                                    graph_ansf(handles);
                                end;
                            end;

                            % Выполнение программы
                            handles = detector(handles);

                            % Отображение графика
                            if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                                    strcmp(get(handles.edit12, 'Enable'), 'on')

                                % Расчет значениий
                                handles = detector_analiz(handles);

                                % Построение графика
                                graph_det(handles);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit13_Callback(hObject, eventdata, handles)
% Нижняя граница коэф. пропускания

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit13, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit13, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % Очистка расчета
    handles = clear_var(0, handles);
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % Блокировка вводимых данных
    set(handles.edit14, 'Enable', 'off');
    
    % Создание переменной
    handles.t_min = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit13, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit13, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % Очистка расчета
        handles = clear_var(0, handles);
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % Блокировка вводимых данных
        set(handles.edit14, 'Enable', 'off');
        
        % Создание переменной
        handles.t_min = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit13, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit13, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % Очистка расчета
            handles = clear_var(0, handles);
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);
            
            % Блокировка вводимых данных
            set(handles.edit14, 'Enable', 'off');
            
            % Создание переменной
            handles.t_min = '';
        else
            % Проверка на адекватность введенного значения
            if (str2num(get(handles.edit13, 'String')) < 0.0) ||...
                    (str2num(get(handles.edit13, 'String')) >= 1.0)
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit13, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);
                
                % Очистка расчета
                handles = clear_var(0, handles);
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                handles = clear_var(3, handles);
                handles = clear_var(5, handles);
                
                % Блокировка вводимых данных
                set(handles.edit14, 'Enable', 'off');
                
                % Создание переменной
                handles.t_min = '';
            else
                % Создание переменной
                handles.t_min = str2num(get(handles.edit13, 'String'));
                
                % Разблокировка вводимых данных
                set(handles.edit14, 'Enable', 'on');
                
                % Проверка на наличие переменной
                if isempty(handles.t_tz) == 0
                    
                    % Сравнение введенных данных
                    if handles.t_min >= handles.t_tz
                        % Установка красного цвета, что свидетельствует о ошибке
                        set(handles.edit14, 'ForegroundColor', 'r');

                        % Очистка окна расчета
                        handles = clear_result(1, handles);
                        handles = clear_result(2, handles);
                        handles = clear_result(3, handles);
                        handles = clear_result(4, handles);
                        handles = clear_result(5, handles);
                        handles = clear_result(6, handles);
                        handles = clear_result(8, handles);

                        % Очистка расчета
                        handles = clear_var(0, handles);
                        handles = clear_var(1, handles);
                        handles = clear_var(2, handles);
                        handles = clear_var(3, handles);
                        handles = clear_var(5, handles);
                    else
                        % Возвращение к нормальному цвету
                        set(handles.edit14, 'ForegroundColor', 'k');
                        
                        % Выполнение программы
                        handles = tz_svetofiltr(handles);
                        
                        % Проверка наличия переменной
                        if (isempty(handles.L_start) == 1) ||...
                                (isempty(handles.DataX_0) == 1)
                            % Установка красного цвета, что свидетельствует о ошибке
                            set(handles.edit13, 'ForegroundColor', 'r');

                            % Очистка окна расчета
                            handles = clear_result(1, handles);
                            handles = clear_result(2, handles);
                            handles = clear_result(3, handles);
                            handles = clear_result(5, handles);
                            handles = clear_result(6, handles);
                            handles = clear_result(8, handles);

                            % Очистка расчета
                            handles = clear_var(0, handles);
                            handles = clear_var(2, handles);
                            handles = clear_var(3, handles);
                            handles = clear_var(5, handles);
                        else
                            % Создание масива
                            data = [handles.DataX_0, handles.DataY_0];

                            % Нахождение номера ближайшего значения
                            data(size(data, 1) + 1,:) = [handles.L_start 1.0];
                            data = sortrows(data, 1);
                            Ncenter = find(data == handles.L_start);

                            % Поиск ближайшего значения
                            deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
                            deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
                            if deltaX1 <= deltaX2
                                Ncenter = Ncenter - 1;
                            end;

                            clear deltaX1 deltaX2 data;

                            % Нахождение значения t_start
                            t_start = handles.DataY_0(Ncenter);

                            % Сравнение значения t_min с t_start
                            if t_start <= handles.t_min
                                % Установка красного цвета, что свидетельствует о ошибке
                                set(handles.edit12, 'ForegroundColor', 'r');

                                % Очистка окна расчета
                                handles = clear_result(1, handles);
                                handles = clear_result(2, handles);
                                handles = clear_result(3, handles);
                                handles = clear_result(5, handles);
                                handles = clear_result(6, handles);
                                handles = clear_result(8, handles);

                                % Очистка расчета
                                handles = clear_var(0, handles);
                                handles = clear_var(2, handles);
                                handles = clear_var(3, handles);
                                handles = clear_var(5, handles);

                                % Создание переменной
                                handles.t_min = '';
                            else
                                clear t_start;

                                % Возвращение к нормальному цвету
                                set(handles.edit12, 'ForegroundColor', 'k');
                                set(handles.edit13, 'ForegroundColor', 'k');

                                %%%%%%%%%%%%%%%%%
                                % Расчетная часть
                                %%%%%%%%%%%%%%%%%

                                % Выполнение программы
                                handles = svetofiltr(handles);

                                % Отображение графика
                                if isempty(handles.FileNameSf) == 0
                                    % Построение графика
                                    graph_of(handles);
                                end;

                                % Отображение графика
                                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0) && ...
                                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                                    % Расчет площади анализа
                                    handles = ploscha_analiz(handles);

                                    if (isempty(handles.S_of) == 0) &&...
                                            strcmp(get(handles.edit12, 'Enable'), 'on')
                                        % Построение графика
                                        graph_ansf(handles);
                                    end;
                                end;

                                % Выполнение программы
                                handles = detector(handles);

                                % Отображение графика
                                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                                        strcmp(get(handles.edit12, 'Enable'), 'on')

                                    % Расчет значениий
                                    handles = detector_analiz(handles);

                                    % Построение графика
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

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit14_Callback(hObject, eventdata, handles)
% Верхняя граница коэф. пропуск. светоф. по ТЗ

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit14, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit14, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % Очистка расчета
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % Создание переменной
    handles.t_tz = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit14, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit14, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % Очистка расчета
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % Создание переменной
        handles.t_tz = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit14, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit14, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % Очистка расчета
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % Создание переменной
            handles.t_tz = '';
        else
            % Проверка на адекватность введенного значения
            if (str2num(get(handles.edit14, 'String')) <= ...
                    str2num(get(handles.edit13, 'String'))) ||...
                    (str2num(get(handles.edit14, 'String')) > 1.0)
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit14, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % Очистка расчета
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % Создание переменной
                handles.t_tz = '';
            else
                % Возвращение к нормальному цвету
                set(handles.edit14, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % Расчетная часть
                %%%%%%%%%%%%%%%%%
                
                % Создание переменной
                handles.t_tz = str2num(get(handles.edit14, 'String'));
                
                % Выполнение программы
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % Отображение графика
                if isempty(handles.FileNameSf) == 0
                    % Построение графика
                    graph_of(handles);
                end
                
                % Отображение графика
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % Расчет площади анализа
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % Построение графика
                        graph_ansf(handles);
                    end;
                end;
                
                % Выполнение программы
                handles = detector(handles);

                % Отображение графика
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % Расчет значениий
                    handles = detector_analiz(handles);

                    % Построение графика
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit15_Callback(hObject, eventdata, handles)
% Левая опорная длина волны

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit15, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit15, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % Очистка расчета
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % Блокировка вводимых данных
    set(handles.edit16, 'Enable', 'off');
    
    % Создание переменной
    handles.L_05l = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit15, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit15, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % Очистка расчета
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % Блокировка вводимых данных
        set(handles.edit16, 'Enable', 'off');
        
        % Создание переменной
        handles.L_05l = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit15, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit15, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % Очистка расчета
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % Блокировка вводимых данных
            set(handles.edit16, 'Enable', 'off');
            
            % Создание переменной
            handles.L_05l = '';
        else
            % Проверка на адекватность введенного значения
            if str2num(get(handles.edit15, 'String')) <= 0.0
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit15, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % Очистка расчета
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % Блокировка вводимых данных
                set(handles.edit16, 'Enable', 'off');
                
                % Создание переменной
                handles.L_05l = '';
            else
                % Возвращение к нормальному цвету
                set(handles.edit15, 'ForegroundColor', 'k');
                
                % Разблокировка вводимых данных
                set(handles.edit16, 'Enable', 'on');
                
                % Проверка на адекватность введенного значения
                if str2num(get(handles.edit16, 'String')) <=...
                        str2num(get(handles.edit15, 'String'))
                    % Установка красного цвета, что свидетельствует о ошибке
                    set(handles.edit16, 'ForegroundColor', 'r');

                    % Очистка окна расчета
                    handles = clear_result(1, handles);
                    handles = clear_result(4, handles);
                    handles = clear_result(5, handles);

                    % Очистка расчета
                    handles = clear_var(1, handles);
                    handles = clear_var(2, handles);
                    
                    % Создание переменной
                    handles.L_05l = '';
                else
                    % Возвращение к нормальному цвету
                    set(handles.edit16, 'ForegroundColor', 'k');
                    
                    % Создание переменной
                    handles.L_05l = str2num(get(handles.edit15, 'String'));
                    handles.L_05r = str2num(get(handles.edit16, 'String'));
                    
                    %%%%%%%%%%%%%%%%%
                    % Расчетная часть
                    %%%%%%%%%%%%%%%%%

                    % Выполнение программы
                    handles = svetofiltr(handles);
                    handles = tz_svetofiltr(handles);

                    % Отображение графика
                    if isempty(handles.FileNameSf) == 0
                        % Построение графика
                        graph_of(handles);
                    end;

                    % Отображение графика
                    if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                            (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                            (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                        % Расчет площади анализа
                        handles = ploscha_analiz(handles);

                        if (isempty(handles.S_of) == 0) &&...
                                strcmp(get(handles.edit12, 'Enable'), 'on')
                            % Построение графика
                            graph_ansf(handles);
                        end;
                    end;

                    % Выполнение программы
                    handles = detector(handles);

                    % Отображение графика
                    if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')

                        % Расчет значениий
                        handles = detector_analiz(handles);

                        % Построение графика
                        graph_det(handles);
                    end;
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit16_Callback(hObject, eventdata, handles)
% Правая опорная длина волны

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit16, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit16, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % Очистка расчета
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % Создание переменной
    handles.L_05r = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit16, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit16, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % Очистка расчета
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % Создание переменной
        handles.L_05r = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit16, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit16, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % Очистка расчета
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % Создание переменной
            handles.L_05r = '';
        else
            % Проверка на адекватность введенного значения
            if str2num(get(handles.edit16, 'String')) <=...
                    str2num(get(handles.edit15, 'String'))
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit16, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % Очистка расчета
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % Создание переменной
                handles.L_05r = '';
            else
                % Возвращение к нормальному цвету
                set(handles.edit16, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % Расчетная часть
                %%%%%%%%%%%%%%%%%
                
                % Создание переменной
                handles.L_05l = str2num(get(handles.edit15, 'String'));
                handles.L_05r = str2num(get(handles.edit16, 'String'));
                
                % Выполнение программы
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % Отображение графика
                if isempty(handles.FileNameSf) == 0
                    % Построение графика
                    graph_of(handles);
                end;
                
                % Отображение графика
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % Расчет площади анализа
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % Построение графика
                        graph_ansf(handles);
                    end;
                end;
                
                % Выполнение программы
                handles = detector(handles);

                % Отображение графика
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % Расчет значениий
                    handles = detector_analiz(handles);

                    % Построение графика
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit17_Callback(hObject, eventdata, handles)
% Крутизна коротковолновой границы пропускания

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit17, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit17, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % Очистка расчета
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % Создание переменной
    handles.K_pkv = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit17, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit17, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % Очистка расчета
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % Создание переменной
        handles.K_pkv = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit17, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit17, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % Очистка расчета
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % Создание переменной
            handles.K_pkv = '';
        else
            % Проверка на адекватность введенного значения
            if str2num(get(handles.edit17, 'String')) <= 0.0
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit17, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % Очистка расчета
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % Создание переменной
                handles.K_pkv = '';
            else
                % Возвращение к нормальному цвету
                set(handles.edit17, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % Расчетная часть
                %%%%%%%%%%%%%%%%%
                
                % Создание переменной
                handles.K_pkv = str2num(get(handles.edit17, 'String'));
                
                % Выполнение программы
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);
                
                % Отображение графика
                if isempty(handles.FileNameSf) == 0
                    % Построение графика
                    graph_of(handles);
                end;
                
                % Отображение графика
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % Расчет площади анализа
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % Построение графика
                        graph_ansf(handles);
                    end;
                end;
                
                % Выполнение программы
                handles = detector(handles);

                % Отображение графика
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % Расчет значениий
                    handles = detector_analiz(handles);

                    % Построение графика
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit18_Callback(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропускания

% Проверка на правильность ввода значения
if isempty(str2num(get(handles.edit18, 'String'))) == 1
    % Установка красного цвета, что свидетельствует о ошибке
    set(handles.edit18, 'ForegroundColor', 'r');
    
    % Очистка окна расчета
    handles = clear_result(1, handles);
    handles = clear_result(4, handles);
    handles = clear_result(5, handles);
    
    % Очистка расчета
    handles = clear_var(1, handles);
    handles = clear_var(2, handles);
    
    % Создание переменной
    handles.K_pdv = '';
else
    % Проверка на количество введенных данных
    if length(str2num(get(handles.edit18, 'String'))) ~= 1
        % Установка красного цвета, что свидетельствует о ошибке
        set(handles.edit18, 'ForegroundColor', 'r');
        
        % Очистка окна расчета
        handles = clear_result(1, handles);
        handles = clear_result(4, handles);
        handles = clear_result(5, handles);
        
        % Очистка расчета
        handles = clear_var(1, handles);
        handles = clear_var(2, handles);
        
        % Создание переменной
        handles.K_pdv = '';
    else
        % Проверка на комплексность
        if isreal(str2num(get(handles.edit18, 'String'))) == 0
            % Установка красного цвета, что свидетельствует о ошибке
            set(handles.edit18, 'ForegroundColor', 'r');
            
            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(4, handles);
            handles = clear_result(5, handles);
            
            % Очистка расчета
            handles = clear_var(1, handles);
            handles = clear_var(2, handles);
            
            % Создание переменной
            handles.K_pdv = '';
        else
            % Проверка на адекватность введенного значения
            if str2num(get(handles.edit18, 'String')) <= 0.0
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit18, 'ForegroundColor', 'r');
                
                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(4, handles);
                handles = clear_result(5, handles);
                
                % Очистка расчета
                handles = clear_var(1, handles);
                handles = clear_var(2, handles);
                
                % Создание переменной
                handles.K_pdv = '';
            else
                % Возвращение к нормальному цвету
                set(handles.edit18, 'ForegroundColor', 'k');
                
                %%%%%%%%%%%%%%%%%
                % Расчетная часть
                %%%%%%%%%%%%%%%%%
                
                % Создание переменной
                handles.K_pdv = str2num(get(handles.edit18, 'String'));
                
                % Выполнение программы
                handles = svetofiltr(handles);
                handles = tz_svetofiltr(handles);

                % Отображение графика
                if isempty(handles.FileNameSf) == 0
                    % Построение графика
                    graph_of(handles);
                end;
                
                % Отображение графика
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
                    
                    % Расчет площади анализа
                    handles = ploscha_analiz(handles);
                    
                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % Построение графика
                        graph_ansf(handles);
                    end;
                end;
                
                % Выполнение программы
                handles = detector(handles);

                % Отображение графика
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % Расчет значениий
                    handles = detector_analiz(handles);

                    % Построение графика
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit19_Callback(hObject, eventdata, handles)
% Название файла приёмника

% Блокируем любое измениение расчитанных данных
if isempty(handles.FileNameDt) == 0
    % Записываем значение
    set(handles.edit19, 'String', handles.FileNameDt);
else
    % Записываем значение
    set(handles.edit19, 'String', '');
end;

function pushbutton11_Callback(hObject, eventdata, handles)
% Загрузка файла светофильтра

% Откритие окна для выбора файла
[handles.FileNameSf, PathName, FilterIndex] = uigetfile({'*.dpt'; '*.txt'; '*.xls*'});

% Проверка на наявность файла
if handles.FileNameSf == 0
    % Стирание названия
    set(handles.edit11, 'String', '');
    handles.FileNameSf = [];
    
    % Блокировка вводимых данных
    set(handles.edit12, 'Enable', 'off');
    
    % Очистка окна расчета
    handles = clear_result(0, handles);
    handles = clear_result(1, handles);
    handles = clear_result(2, handles);
    handles = clear_result(3, handles);
    handles = clear_result(5, handles);
    handles = clear_result(6, handles);
    handles = clear_result(8, handles);
    
    % Очистка расчета
    handles = clear_var(0, handles);
    handles = clear_var(2, handles);
    handles = clear_var(3, handles);
    handles = clear_var(5, handles);
    
    % Создание переменной
    handles.DataX_0 = [];
    handles.DataY_0 = [];
else
    % Загрузка документа
    if (FilterIndex == 1) && (FilterIndex == 2)
        data = importdata([PathName, handles.FileNameSf], ',');
    elseif (FilterIndex == 3)
        data = xlsread([PathName, handles.FileNameSf]);
    else
        data = importdata([PathName, handles.FileNameSf]);
    end;
    
    clear FilterIndex;
    
    % Проверка документа на наличие данных
    if isempty(data) == 1
        % Стирание названия
        set(handles.edit11, 'String', '');
        handles.FileNameSf = [];

        % Блокировка вводимых данных
        set(handles.edit12, 'Enable', 'off');

        % Очистка окна расчета
        handles = clear_result(0, handles);
        handles = clear_result(1, handles);
        handles = clear_result(2, handles);
        handles = clear_result(3, handles);
        handles = clear_result(5, handles);
        handles = clear_result(6, handles);
        handles = clear_result(8, handles);
        
        % Очистка расчета
        handles = clear_var(0, handles);
        handles = clear_var(2, handles);
        handles = clear_var(3, handles);
        handles = clear_var(5, handles);
        
        % Создание переменной
        handles.DataX_0 = [];
        handles.DataY_0 = [];
    else
        % Внесение названия
        set(handles.edit11, 'String', handles.FileNameSf);
    
        % Разблокировка вводимых данных
        set(handles.edit12, 'Enable', 'on');
        
        % Анализ данных на ориентацию (гориз. или вертик.) и ее смена
        if size(data, 2) > size(data, 1)
            data = data';
        end;
        
        % Анализ полученных данных и выбор осей
        Analiz = max(data(:, 1) - sort(data(:, 1)));
        if Analiz == 0
            handles.DataX_0 = data(:, 1);
            handles.DataY_0 = data(:, 2);
        else
            handles.DataX_0 = data(:, 2);
            handles.DataY_0 = data(:, 1);
        end;
        clear Analiz data;

        % Нормировка коэф. пропускания
        if max(handles.DataY_0) > 1.0
            handles.DataY_0 = handles.DataY_0 ./ 100;
        end;
        
        % Построение графика
        graph_of(handles);
        
        % Проверка наличия переменной
        if (isempty(handles.t_min) == 1) || (isempty(handles.L_start) == 1)
            % Возвращение к нормальному цвету
            set(handles.edit12, 'ForegroundColor', 'k');

            % Очистка окна расчета
            handles = clear_result(1, handles);
            handles = clear_result(2, handles);
            handles = clear_result(3, handles);
            handles = clear_result(5, handles);
            handles = clear_result(6, handles);
            handles = clear_result(8, handles);
            
            % Очистка расчета
            handles = clear_var(0, handles);
            handles = clear_var(2, handles);
            handles = clear_var(3, handles);
            handles = clear_var(5, handles);
        else
            % Создание масива
            data = [handles.DataX_0, handles.DataY_0];

            % Нахождение номера ближайшего значения
            data(size(data, 1) + 1,:) = [handles.L_start 1.0];
            data = sortrows(data, 1);
            Ncenter = find(data == handles.L_start);

            % Поиск ближайшего значения
            deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
            deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
            if deltaX1 <= deltaX2
                Ncenter = Ncenter - 1;
            end;

            clear deltaX1 deltaX2 data;

            % Нахождение значения t_start
            t_start = handles.DataY_0(Ncenter);

            % Сравнение значения t_min с t_start
            if t_start <= handles.t_min
                % Установка красного цвета, что свидетельствует о ошибке
                set(handles.edit12, 'ForegroundColor', 'r');

                % Очистка окна расчета
                handles = clear_result(1, handles);
                handles = clear_result(2, handles);
                handles = clear_result(3, handles);
                handles = clear_result(5, handles);
                handles = clear_result(6, handles);
                handles = clear_result(8, handles);

                % Создание переменной
                handles.L_start = '';
            else
                clear t_start;

                % Возвращение к нормальному цвету
                set(handles.edit12, 'ForegroundColor', 'k');
                set(handles.edit13, 'ForegroundColor', 'k');

                %%%%%%%%%%%%%%%%%
                % Расчетная часть
                %%%%%%%%%%%%%%%%%

                % Выполнение программы
                handles = svetofiltr(handles);
                
                % Отображение графика
                if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
                        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
                        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)

                    % Расчет значениий
                    handles = tz_svetofiltr(handles);

                    % Расчет площади анализа
                    handles = ploscha_analiz(handles);

                    if (isempty(handles.S_of) == 0) &&...
                            strcmp(get(handles.edit12, 'Enable'), 'on')
                        % Построение графика
                        graph_ansf(handles);
                    end;
                end;

                % Выполнение программы
                handles = detector(handles);

                % Отображение графика
                if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                        strcmp(get(handles.edit12, 'Enable'), 'on')

                    % Расчет значениий
                    handles = detector_analiz(handles);

                    % Построение графика
                    graph_det(handles);
                end;
            end;
        end;
    end;
end;

% Очистка
clear PathName;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function pushbutton19_Callback(hObject, eventdata, handles)
% Загрузка файла приёмника

% Откритие окна для выбора файла
[handles.FileNameDt, PathName, FilterIndex] = uigetfile({'*.dpt'; '*.txt'; '*.xls*'});

% Проверка на наявность файла
if handles.FileNameDt == 0
    % Стирание названия
    set(handles.edit19, 'String', '');
    handles.FileNameDt = [];
    
    % Очистка окна расчета
    handles = clear_result(2, handles);
    handles = clear_result(6, handles);
    handles = clear_result(7, handles);
    handles = clear_result(8, handles);
    
    % Очистка расчета
    handles = clear_var(3, handles);
    handles = clear_var(4, handles);
    handles = clear_var(5, handles);
    
    % Создание переменной
    handles.DataX_1 = [];
    handles.DataY_1 = [];
else
    % Загрузка документа
    if (FilterIndex == 1) && (FilterIndex == 2)
        data = importdata([PathName, handles.FileNameDt], ',');
    elseif (FilterIndex == 3)
        data = xlsread([PathName, handles.FileNameDt]);
    else
        data = importdata([PathName, handles.FileNameDt]);
    end;
    
    clear FilterIndex;
    
    % Проверка документа на наличие данных
    if isempty(data) == 1
        % Стирание названия
        set(handles.edit11, 'String', '');
        handles.FileNameDt = [];

        % Очистка окна расчета
        handles = clear_result(2, handles);
        handles = clear_result(6, handles);
        handles = clear_result(7, handles);
        handles = clear_result(8, handles);
        
        % Очистка расчета
        handles = clear_var(3, handles);
        handles = clear_var(4, handles);
        handles = clear_var(5, handles);
        
        % Создание переменной
        handles.DataX_1 = [];
        handles.DataY_1 = [];
    else
        % Внесение названия
        set(handles.edit19, 'String', handles.FileNameDt);
        
        % Анализ данных на ориентацию (гориз. или вертик.) и ее смена
        if size(data, 2) > size(data, 1)
            data = data';
        end;
        
        % Анализ полученных данных и выбор осей
        Analiz = max(data(:, 1) - sort(data(:, 1)));
        if Analiz == 0
            handles.DataX_1 = data(:, 1);
            handles.DataY_1 = data(:, 2);
        else
            handles.DataX_1 = data(:, 2);
            handles.DataY_1 = data(:, 1);
        end;
        clear Analiz data;

        % Нормировка коэф. пропускания
        if max(handles.DataY_1) ~= 1.0
            handles.DataY_1 = handles.DataY_1 ./ max(handles.DataY_1);
        end;
        
        % Выполнение программы
        handles = detector(handles);
        
        % Отображение графика
        if (isempty(handles.S_det) == 0) && (isempty(handles.S_of) == 0) &&...
                strcmp(get(handles.edit12, 'Enable'), 'on')
            
            % Расчет значениий
            handles = detector_analiz(handles);
            
            % Построение графика
            graph_det(handles);
        end;
    end;
end;

% Очистка
clear PathName;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Результаты расчетов %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function axes21_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница спектрального диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{кв.г} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes22_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница спектрального диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{дв.г} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes23_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница рабочего спектрального диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{кв.05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes24_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница рабочего спектрального диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{дв.05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes25_CreateFcn(hObject, eventdata, handles)
% Максимальный коэф. пропуск. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{max} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes26_CreateFcn(hObject, eventdata, handles)
% Длина волны при максимальном коэф. пропуск. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{max} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes27_CreateFcn(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{ср.св} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes28_CreateFcn(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра в рабочей полосе

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{ср.уп} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes29_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. реал. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'S_{OF} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes210_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. светофильтра по ТЗ

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'S_{T3} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes211_CreateFcn(hObject, eventdata, handles)
% Отношение площадей под кривыми коэф. пропуск. светофильтров

% Ввод обозначения (формулы)
text('Interpreter', 'latex', 'String', '$$\frac{S_{OF}}{S_{T3}} =$$',...
    'VerticalAlignment', 'bottom', 'FontSize', 12);
set(gca, 'Visible', 'off');

function axes212_CreateFcn(hObject, eventdata, handles)
% Крутизна коротковолновой границы пропуск. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'K_{р.к.с} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes213_CreateFcn(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропуск. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'K_{р.д.с} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes214_CreateFcn(hObject, eventdata, handles)
% Спектральная ширина рабочей полосы пропускания на уровыне 0.5

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\Delta\lambda_{05} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes215_CreateFcn(hObject, eventdata, handles)
% Длина волны цетра рабочей полосы пропускания

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{ср} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes216_CreateFcn(hObject, eventdata, handles)
% Площадь пересеч. кривых светофильтра и приёмника

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'S_{f.d} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes217_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. приёмника

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', 'S_{det} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes218_CreateFcn(hObject, eventdata, handles)
% Отношение площадей под кривой коэф. пропуск. приём. и пересечен.

% Ввод обозначения (формулы)
text('Interpreter', 'latex', 'String', '$$\frac{S_{f.d}}{S_{det}} =$$',...
    'VerticalAlignment', 'bottom', 'FontSize', 12);
set(gca, 'Visible', 'off');

function axes219_CreateFcn(hObject, eventdata, handles)
% Эквивалентный коэф. пропуск. светофильтра

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\tau_{эк} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes220_CreateFcn(hObject, eventdata, handles)
% Эквивалентная спектр. ширина полосы пропускания

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\Delta\lambda_{эк} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes221_CreateFcn(hObject, eventdata, handles)
% Эквивалентная коротковолн. граница спектр. диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{кв.э} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function axes222_CreateFcn(hObject, eventdata, handles)
% Эквивалентная длинноволн. граница спектр. диапазона

% Ввод обозначения (формулы)
text('Interpreter', 'tex', 'String', '\lambda_{дв.э} =',...
    'VerticalAlignment', 'bottom');
set(gca, 'Visible', 'off');

function edit21_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница спектрального диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Коротковолновая граница спектр. диап.');

% Создание переменной
handles.L_kvh = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit22_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница спектрального диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Длинноволновая граница спектр. диап.');

% Создание переменной
handles.L_dvh = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit23_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница рабочего спектрального диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Длина волны для уровня 0.5 на коротковолн. границе пропуск.');

% Создание переменной
handles.L_kvh05 = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit24_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница рабочего спектрального диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Длина волны для уровня 0.5 на длинноволн. границе пропуск.');

% Создание переменной
handles.L_dvh05 = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit25_CreateFcn(hObject, eventdata, handles)
% Максимальный коэф. пропуск. светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Максимальный коэф. пропуск. светофильтра');

% Создание переменной
handles.t_max = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit26_CreateFcn(hObject, eventdata, handles)
% Длина волны при максимальном коэф. пропуск. светоф.

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Длина волны при максим. коэф. пропуск. светофильтра');

% Создание переменной
handles.L_max = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit27_CreateFcn(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Средний коэф. пропускания светофильтра');

% Создание переменной
handles.t_srsf = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit28_CreateFcn(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра в рабочей полосе

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Средний коэф. пропуск. узкополосного светофильтра');

% Создание переменной
handles.t_srup = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit29_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. реал. светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Площадь под кривой коэф. пропуск. светофильтра для анализа');

% Создание переменной
handles.S_of = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit210_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. светофильтра по ТЗ

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Площадь под кривой коэф. пропуск. светофильтра по ТЗ');

% Создание переменной
handles.S_tz = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit211_CreateFcn(hObject, eventdata, handles)
% Отношение площадей под кривыми коэф. пропуск. светофильтров

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Отношение площадей под кривыми коэф. пропуск. светоф.');

% Создание переменной
handles.S_oftz = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit212_CreateFcn(hObject, eventdata, handles)
% Крутизна коротковолновой границы пропуск. светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Крутизна коротковолн. границы пропуск. светофильтра');

% Создание переменной
handles.K_pks = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit213_CreateFcn(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропуск. светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Крутизна длинноволн. границы пропуск. светофильтра');

% Создание переменной
handles.K_pds = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit214_CreateFcn(hObject, eventdata, handles)
% Спектральная ширина рабочей полосы пропускания на уровыне 0.5

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Спектр. ширина рабочей полосы пропуск. на уровыне 0.5');

% Создание переменной
handles.dL_05 = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit215_CreateFcn(hObject, eventdata, handles)
% Длина волны цетра рабочей полосы пропускания

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Длина волны цетра рабочей полосы пропускания');

% Создание переменной
handles.dL_sr = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit216_CreateFcn(hObject, eventdata, handles)
% Площадь пересеч. кривых светофильтра и приёмника

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Площадь пересеч. кривых светофильтра и приёмника');

% Создание переменной
handles.S_fd = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit217_CreateFcn(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. приёмника

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Площадь под кривой коэф. пропуск. приёмника');

% Создание переменной
handles.S_det = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit218_CreateFcn(hObject, eventdata, handles)
% Отношение площадей под кривой коэф. пропуск. приём. и пересечен.

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Отношение площадей под кривой коэф. пропуск. приём. и пересечен.');

% Создание переменной
handles.S_fdet = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit219_CreateFcn(hObject, eventdata, handles)
% Эквивалентный коэф. пропуск. светофильтра

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Эквивалентный коэф. пропуск. светофильтра');

% Создание переменной
handles.t_lim = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit220_CreateFcn(hObject, eventdata, handles)
% Эквивалентная спектр. ширина полосы пропускания

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Эквивалентная спектр. ширина полосы пропускания');

% Создание переменной
handles.dL_lim = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit221_CreateFcn(hObject, eventdata, handles)
% Эквивалентная коротковолн. граница спектр. диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Эквивалентная коротковолн. граница спектр. диапазона');

% Создание переменной
handles.L_kvh_e = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function edit222_CreateFcn(hObject, eventdata, handles)
% Эквивалентная длинноволн. граница спектр. диапазона

% Установка начального значения
set(gcbo, 'String', '', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'BackgroundColor', 'w',...
    'TooltipString', 'Эквивалентная длинноволн. граница спектр. диапазона');

% Создание переменной
handles.L_dvh_e = '';
% Сохранение данных для общего доступа
guidata(gcbo, handles);

function text21_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница спектрального диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text22_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница спектрального диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text23_CreateFcn(hObject, eventdata, handles)
% Коротковолновая граница рабочего спектрального диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text24_CreateFcn(hObject, eventdata, handles)
% Длинноволновая граница рабочего спектрального диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text26_CreateFcn(hObject, eventdata, handles)
% Длина волны при максимальном коэф. пропуск. светоф.

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text221_CreateFcn(hObject, eventdata, handles)
% Эквивалентная коротковолн. граница спектр. диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text214_CreateFcn(hObject, eventdata, handles)
% Спектральная ширина рабочей полосы пропускания на уровыне 0.5

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text215_CreateFcn(hObject, eventdata, handles)
% Длина волны цетра рабочей полосы пропускания

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text220_CreateFcn(hObject, eventdata, handles)
% Эквивалентная спектр. ширина полосы пропускания

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

function text222_CreateFcn(hObject, eventdata, handles)
% Эквивалентная длинноволн. граница спектр. диапазона

% Установка начального значения
set(gcbo, 'String', 'мкм', 'FontName', 'Times New Roman',...
    'FontSize', 11, 'FontAngle', 'italic', 'BackgroundColor', 'none');

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

function edit21_Callback(hObject, eventdata, handles)
% Коротковолновая граница спектрального диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_kvh) == 0
    % Записываем значение
    set(handles.edit21, 'String', roundn(handles.L_kvh, -2));
else
    % Записываем значение
    set(handles.edit21, 'String', '');
end;

function edit22_Callback(hObject, eventdata, handles)
% Длинноволновая граница спектрального диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_dvh) == 0
    % Записываем значение
    set(handles.edit22, 'String', roundn(handles.L_dvh, -2));
else
    % Записываем значение
    set(handles.edit22, 'String', '');
end;

function edit23_Callback(hObject, eventdata, handles)
% Коротковолновая граница рабочего спектрального диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_kvh05) == 0
    % Записываем значение
    set(handles.edit23, 'String', roundn(handles.L_kvh05, -2));
else
    % Записываем значение
    set(handles.edit23, 'String', '');
end;

function edit24_Callback(hObject, eventdata, handles)
% Длинноволновая граница рабочего спектрального диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_dvh05) == 0
    % Записываем значение
    set(handles.edit24, 'String', roundn(handles.L_dvh05, -2));
else
    % Записываем значение
    set(handles.edit24, 'String', '');
end;

function edit25_Callback(hObject, eventdata, handles)
% Максимальный коэф. пропуск. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.t_max) == 0
    % Записываем значение
    set(handles.edit25, 'String', roundn(handles.t_max, -2));
else
    % Записываем значение
    set(handles.edit25, 'String', '');
end;

function edit26_Callback(hObject, eventdata, handles)
% Длина волны при максимальном коэф. пропуск. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_max) == 0
    % Записываем значение
    set(handles.edit26, 'String', roundn(handles.L_max, -2));
else
    % Записываем значение
    set(handles.edit26, 'String', '');
end;

function edit27_Callback(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.t_srsf) == 0
    % Записываем значение
    set(handles.edit27, 'String', roundn(handles.t_srsf, -2));
else
    % Записываем значение
    set(handles.edit27, 'String', '');
end;

function edit28_Callback(hObject, eventdata, handles)
% Средний коэф. пропускания светофильтра в рабочей полосе

% Блокируем любое измениение расчитанных данных
if isempty(handles.t_srup) == 0
    % Записываем значение
    set(handles.edit28, 'String', roundn(handles.t_srup, -2));
else
    % Записываем значение
    set(handles.edit28, 'String', '');
end;

function edit29_Callback(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. реал. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_of) == 0
    % Записываем значение
    set(handles.edit29, 'String', roundn(handles.S_of, -3));
else
    % Записываем значение
    set(handles.edit29, 'String', '');
end;

function edit210_Callback(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. светофильтра по ТЗ

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_tz) == 0
    % Записываем значение
    set(handles.edit210, 'String', roundn(handles.S_tz, -3));
else
    % Записываем значение
    set(handles.edit210, 'String', '');
end;

function edit211_Callback(hObject, eventdata, handles)
% Отношение площадей под кривой коэф. пропуск. светофильтров

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_oftz) == 0
    % Записываем значение
    set(handles.edit211, 'String', roundn(handles.S_oftz, -3));
else
    % Записываем значение
    set(handles.edit211, 'String', '');
end;

function edit212_Callback(hObject, eventdata, handles)
% Крутизна коротковолновой границы пропуск. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.K_pks) == 0
    % Записываем значение
    set(handles.edit212, 'String', roundn(handles.K_pks, -2));
else
    % Записываем значение
    set(handles.edit212, 'String', '');
end;

function edit213_Callback(hObject, eventdata, handles)
% Крутизна длинноволновой границы пропуск. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.K_pds) == 0
    % Записываем значение
    set(handles.edit213, 'String', roundn(handles.K_pds, -2));
else
    % Записываем значение
    set(handles.edit213, 'String', '');
end;

function edit214_Callback(hObject, eventdata, handles)
% Спектральная ширина рабочей полосы пропускания на уровыне 0.5

% Блокируем любое измениение расчитанных данных
if isempty(handles.dL_05) == 0
    % Записываем значение
    set(handles.edit214, 'String', roundn(handles.dL_05, -2));
else
    % Записываем значение
    set(handles.edit214, 'String', '');
end;

function edit215_Callback(hObject, eventdata, handles)
% Длина волны цетра рабочей полосы пропускания

% Блокируем любое измениение расчитанных данных
if isempty(handles.dL_sr) == 0
    % Записываем значение
    set(handles.edit215, 'String', roundn(handles.dL_sr, -2));
else
    % Записываем значение
    set(handles.edit215, 'String', '');
end;

function edit216_Callback(hObject, eventdata, handles)
% Площадь пересеч. кривых светофильтра и приёмника

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_fd) == 0
    % Записываем значение
    set(handles.edit216, 'String', roundn(handles.S_fd, -3));
else
    % Записываем значение
    set(handles.edit216, 'String', '');
end;

function edit217_Callback(hObject, eventdata, handles)
% Площадь под кривой коэф. пропуск. приёмника

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_det) == 0
    % Записываем значение
    set(handles.edit217, 'String', roundn(handles.S_det, -3));
else
    % Записываем значение
    set(handles.edit217, 'String', '');
end;

function edit218_Callback(hObject, eventdata, handles)
% Отношение площадей под кривой коэф. пропуск. приём. и пересечен.

% Блокируем любое измениение расчитанных данных
if isempty(handles.S_fdet) == 0
    % Записываем значение
    set(handles.edit218, 'String', roundn(handles.S_fdet, -3));
else
    % Записываем значение
    set(handles.edit218, 'String', '');
end;

function edit219_Callback(hObject, eventdata, handles)
% Эквивалентный коэф. пропуск. светофильтра

% Блокируем любое измениение расчитанных данных
if isempty(handles.t_lim) == 0
    % Записываем значение
    set(handles.edit219, 'String', roundn(handles.t_lim, -2));
else
    % Записываем значение
    set(handles.edit219, 'String', '');
end;

function edit220_Callback(hObject, eventdata, handles)
% Эквивалентная спектр. ширина полосы пропускания

% Блокируем любое измениение расчитанных данных
if isempty(handles.dL_lim) == 0
    % Записываем значение
    set(handles.edit220, 'String', roundn(handles.dL_lim, -2));
else
    % Записываем значение
    set(handles.edit220, 'String', '');
end;

function edit221_Callback(hObject, eventdata, handles)
% Эквивалентная коротковолн. граница спектр. диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_kvh_e) == 0
    % Записываем значение
    set(handles.edit221, 'String', roundn(handles.L_kvh_e, -2));
else
    % Записываем значение
    set(handles.edit221, 'String', '');
end;

function edit222_Callback(hObject, eventdata, handles)
% Эквивалентная длинноволн. граница спектр. диапазона

% Блокируем любое измениение расчитанных данных
if isempty(handles.L_dvh_e) == 0
    % Записываем значение
    set(handles.edit222, 'String', roundn(handles.L_dvh_e, -2));
else
    % Записываем значение
    set(handles.edit222, 'String', '');
end;

%%%%%%%%%%%%%%%%%
%%%% Графики %%%%
%%%%%%%%%%%%%%%%%

function axes31_CreateFcn(hObject, eventdata, handles)
% Спектральный коэф. пропускания светофильтра

% Очистка области
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

function axes32_CreateFcn(hObject, eventdata, handles)
% Анализ пропускания светофильтра

% Очистка области
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

function axes33_CreateFcn(hObject, eventdata, handles)
% Сравнение светофильтра и приёмника

% Очистка области
set(gca, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
    'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
    'XLim', [0 1], 'YLim', [0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Дополнительные функции %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = clear_result(num, handles)
% Очистка расчетной части и графиков

switch num
    case 0
        % Очистка области
        set(handles.axes31, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % Очистка подписей
        title(handles.axes31, '');
        xlabel(handles.axes31, '');
        ylabel(handles.axes31, '');
        
        % Убираем активность графика
        set(handles.axes31, 'ButtonDownFcn', '');
    case 1
        % Очистка области
        set(handles.axes32, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % Очистка подписей
        title(handles.axes32, '');
        xlabel(handles.axes32, '');
        ylabel(handles.axes32, '');
        
        % Убираем активность графика
        set(handles.axes32, 'ButtonDownFcn', '');
    case 2
        % Очистка области
        set(handles.axes33, 'Visible', 'on', 'XGrid', 'off', 'YGrid', 'off',...
            'XTickLabel', '', 'YTickLabel', '', 'XTick', 0, 'YTick', 0,...
            'XLim', [0 1], 'YLim', [0 1]);
        
        % Очистка подписей
        title(handles.axes33, '');
        xlabel(handles.axes33, '');
        ylabel(handles.axes33, '');
        
        % Убираем активность графика
        set(handles.axes33, 'ButtonDownFcn', '');
    case 3
        % Очистка полей
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
% Очистка значений переменных

switch num
    case 0
        % Очистка полей
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
        % Очистка данных
        handles.DataX = [];
        handles.DataY = [];
        handles.func_of = [];
    case 1
        % Очистка полей
        handles.S_tz = [];
        % Очистка данных
        handles.Data_tzX = [];
        handles.Data_tzY = [];
        handles.func_tz = [];
    case 2
        % Очистка полей
        handles.S_oftz = [];
    case 3
        % Очистка полей
        handles.S_fd = [];
    case 4
        % Очистка полей
        handles.S_det = [];
        % Очистка данных
        handles.DataX_1 = [];
        handles.DataY_1 = [];
        handles.func_det = [];
        handles.FileNameDt = [];
    case 5
        % Очистка полей
        handles.S_fdet = [];
        % Очистка данных
        handles.DataX_2 = [];
        handles.DataY_2 = [];
        handles.func_fd = [];
    otherwise
        % Очистка полей
        handles.L_start = [];
        handles.t_min = [];
        handles.t_tz = [];
        handles.L_05l = [];
        handles.L_05r = [];
        handles.K_pkv = [];
        handles.K_pdv = [];
        % Очистка данных
        handles.DataX_0 = [];
        handles.DataY_0 = [];
        handles.FileNameSf = [];
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function graph_of(handles)
% Построение графика светофильтра

% Стираем старый
handles = clear_result(0, handles);

% Отключаем возможность рисования нескольких графиков
set(handles.axes31, 'NextPlot', 'new');
set(handles.axes31, 'NextPlot', 'replace');

p1 = plot(handles.axes31, handles.DataX_0, handles.DataY_0, 'LineWidth', 2, 'Color', 'b');

title(handles.axes31, 'Светофильтр', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes31, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes31, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% Настраиваем оси
set(handles.axes31, 'YTickLabel', '', 'XTick', roundn([handles.DataX_0(1) handles.DataX_0(end)], -1),...
    'YTick', 0, 'XLim', roundn([handles.DataX_0(1) handles.DataX_0(end)], -1), 'YLim', [0 1]);

% Задаем активность графика
set(handles.axes31, 'ButtonDownFcn', {@mouse_click_axes31, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes31, handles});

clear p1;

function graph_ansf(handles)
% Построение графика анализа светофильтра

% Стираем старый
handles = clear_result(1, handles);

% Отключаем возможность рисования нескольких графиков
set(handles.axes32, 'NextPlot', 'replace');
p1 = plot(handles.axes32, handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');

% Включаем возможность рисования нескольких графиков
set(handles.axes32, 'NextPlot', 'new');
p2 = plot(handles.axes32, handles.Data_tzX, handles.Data_tzY, 'LineWidth', 2, 'Color', 'r');

Data_X = [handles.L_kvh_e; handles.L_kvh_e; handles.L_dvh_e; handles.L_dvh_e];
Data_Y = [handles.t_min; handles.t_lim; handles.t_lim; handles.t_min];

p3 = plot(handles.axes32, Data_X, Data_Y, 'LineWidth', 2, 'Color', 'g');

title(handles.axes32, 'Анализ', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes32, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes32, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% Настраиваем оси
set(handles.axes32, 'YTickLabel', '', 'XTick', roundn([min([handles.DataX(1),...
    handles.Data_tzX(1), Data_X(1)]) max([handles.DataX(end), handles.Data_tzX(end),...
    Data_X(end)])], -1), 'YTick', 0, 'XLim', roundn([min([handles.DataX(1),...
    handles.Data_tzX(1), Data_X(1)]) max([handles.DataX(end), handles.Data_tzX(end),...
    Data_X(end)])], -1), 'YLim', [0 1]);

clear Data_X Data_Y;

% Задаем активность графика
set(handles.axes32, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p2, 'ButtonDownFcn', {@mouse_click_axes32, handles});
set(p3, 'ButtonDownFcn', {@mouse_click_axes32, handles});

clear p1 p2 p3;

function graph_det(handles)
% Построение графика анализа приёмника

% Стираем старый
handles = clear_result(2, handles);

% Отключаем возможность рисования нескольких графиков
set(handles.axes33, 'NextPlot', 'replace');
p1 = plot(handles.axes33,handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');

% Включаем возможность рисования нескольких графиков
set(handles.axes33, 'NextPlot', 'new');
p2 = plot(handles.axes33, handles.DataX_1, handles.DataY_1, 'LineWidth', 2, 'Color', 'r');

% Закраска графика
set(handles.axes33, 'NextPlot', 'new');
p3 = stem(handles.axes33, handles.DataX_2, handles.DataY_2, 'LineWidth', 0.5,...
    'Marker', 'none', 'Color', [0.6 0.6 0.6]);

title(handles.axes33, 'Приёмник', 'FontName', 'Times New Roman', 'FontSize', 10);
xlabel(handles.axes33, '\lambda', 'FontName', 'Times New Roman', 'FontSize', 10);
ylabel(handles.axes33, '\tau(\lambda)', 'FontName', 'Times New Roman', 'FontSize', 10);

% Настраиваем оси
set(handles.axes33, 'YTickLabel', '', 'XTick', roundn([min(handles.DataX(1),...
    handles.DataX_1(1)) max(handles.DataX(end), handles.DataX_1(end))], -1),...
    'YTick', 0, 'XLim', roundn([min(handles.DataX(1), handles.DataX_1(1))...
    max(handles.DataX(end), handles.DataX_1(end))], -1), 'YLim', [0 1]);

% Задаем активность графика
set(handles.axes33, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p1, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p2, 'ButtonDownFcn', {@mouse_click_axes33, handles});
set(p3, 'ButtonDownFcn', {@mouse_click_axes33, handles});

clear p1 p2 p3;

function handles = mouse_click_axes31(src, evt, handles)
% Построение графика светофильтра

% Открытие нового окна
handles.f2 = figure(2);
set(gcf, 'Name', 'Светофильтр', 'NumberTitle', 'off');
plot(handles.DataX_0, handles.DataY_0, 'LineWidth', 2);
grid on;
title('Коэффициент пропускания светофильтра', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('Длина волны \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Коэффициент пропускания    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([handles.DataX_0(1) handles.DataX_0(end)]);
ylim([0.0 1.0]);

% Подпись кривых
legend('Светофильтр', 0);

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = mouse_click_axes32(src, evt, handles)
% Построение графика светофильтра для анализа

% Открытие нового окна
handles.f3 = figure(3);
set(gcf, 'Name', 'Анализ светофильтра', 'NumberTitle', 'off');
plot(handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');
hold on;
plot(handles.Data_tzX, handles.Data_tzY, 'LineWidth', 2, 'Color', 'r');

Data_X = [handles.L_kvh_e; handles.L_kvh_e; handles.L_dvh_e; handles.L_dvh_e];
Data_Y = [handles.t_min; handles.t_lim; handles.t_lim; handles.t_min];

plot(Data_X, Data_Y, 'LineWidth', 2, 'Color', 'g');

hold off;
grid on;
title('Анализ коэффициента пропускания светофильтра по ТЗ', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('Длина волны \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Коэффициент пропускания    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([min([handles.DataX(1), handles.Data_tzX(1), Data_X(1)])...
    max([handles.DataX(end), handles.Data_tzX(end), Data_X(end)])]);
ylim([0.0 1.0]);

clear Data_X Data_Y;

% Подпись кривых
legend('Светофильтр', 'Светофильтр по ТЗ', 'Эквив. светофильтр', 0);

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = mouse_click_axes33(src, evt, handles)
% Построение графика приёмника для анализа

% Открытие нового окна
handles.f4 = figure(4);
set(gcf, 'Name', 'Анализ приёмника', 'NumberTitle', 'off');
plot(handles.DataX, handles.DataY, 'LineWidth', 2, 'Color', 'b');
hold on;
plot(handles.DataX_1, handles.DataY_1, 'LineWidth', 2, 'Color', 'r');
hold on;

% Закраска графика
stem(handles.DataX_2, handles.DataY_2, 'LineWidth', 0.5,...
    'Marker', 'none', 'Color', [0.6 0.6 0.6]);

hold off;
grid on;
title('Анализ коэффициента пропускания приёмника', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlabel('Длина волны \lambda', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('Коэффициент пропускания    \tau (\lambda)', 'FontName',...
    'Times New Roman', 'FontSize', 12);
xlim([min(handles.DataX(1), handles.DataX_1(1))...
    max(handles.DataX(end), handles.DataX_1(end))]);
ylim([0.0 1.0]);

% Подпись кривых
legend('Светофильтр', 'Приёмник', 0);

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = svetofiltr(handles)
% Расчет параметров которые относятся к светофильтру

% Очистка ранее расчитаных данных
handles.DataX = [];
handles.DataY = [];

% Проверка данных
if (isempty(handles.L_start) == 0) && (isempty(handles.t_min) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    
    % Создание масива
    handles.DataX = handles.DataX_0;
    handles.DataY = handles.DataY_0;
    data = [handles.DataX, handles.DataY];
    
    % Нахождение номера ближайшего значения
    data(size(data, 1) + 1,:) = [handles.L_start 1.0];
    data = sortrows(data, 1);
    Ncenter = find(data == handles.L_start);
    
    % Вибираем одно значение
    Ncenter = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    
    % Поиск ближайшего значения
    deltaX1 = abs(data(Ncenter,1) - data(Ncenter - 1,1));
    deltaX2 = abs(data(Ncenter,1) - data(Ncenter + 1,1));
    if deltaX1 <= deltaX2
        Ncenter = Ncenter - 1;
    end;
    
    clear deltaX1 deltaX2 data;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Длинноволновая граница спектрального диапазона
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = Ncenter;
    %i = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    while (handles.t_min < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    
    % Подсвечивание если граница больше t_min, а количество данных
    % ограничено
    if i == size(handles.DataY, 1)
        set(handles.edit22, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit22, 'BackgroundColor', 'w');
    end;
    
    % Создание переменной
    handles.L_dvh = handles.DataX(i);
    
    % Обрезаем лишние значения
    handles.DataX = handles.DataX(1:i);
    handles.DataY = handles.DataY(1:i);
    
    % Записываем значение
    set(handles.edit22, 'String', roundn(handles.L_dvh, -2));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Коротковолновая граница спектрального диапазона
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = Ncenter;
    %i = Ncenter(round(size(Ncenter, 1) / 2.0), 1);
    while (handles.t_min < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    
    % Подсвечивание если граница больше t_min, а количество данных
    % ограничено
    if i == 1
        set(handles.edit21, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit21, 'BackgroundColor', 'w');
    end;
    
    clear Ncenter;
    
    % Создание переменной
    handles.L_kvh = handles.DataX(i);
    
    % Обрезаем лишние значения
    handles.DataX = handles.DataX(i:end);
    handles.DataY = handles.DataY(i:end);
    
    % Записываем значение
    set(handles.edit21, 'String', roundn(handles.L_kvh, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Максимальный коэф. пропуск. светофильтра
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание переменной
    handles.t_max = max(handles.DataY);
    
    % Записываем значение
    set(handles.edit25, 'String', roundn(handles.t_max, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Длина волны при максимальном коэф. пропуск. светоф.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Номер максимального элемента
    N_max = find(handles.DataY == handles.t_max);
    % В случае нескольких максимумов
    if size(N_max, 1) > 1
        N_max = N_max(round(size(N_max, 1)/2.0));
    end;
    
    % Создание переменной
    handles.L_max = handles.DataX(N_max);
    
    % Записываем значение
    set(handles.edit26, 'String', roundn(handles.L_max, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Коротковолновая граница рабочего спектрального диапазона (0.5)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = N_max;
    while ((0.5 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= 1)
        i = i - 1;
    end;
    
    % Подсвечивание если ошибка в количестве данных
    if (0.5 * handles.t_max) < handles.DataY(i)
        set(handles.edit23, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit23, 'BackgroundColor', 'w');
    end;
    
    % Создание переменной
    handles.L_kvh05 = handles.DataX(i);
    
    % Записываем значение
    set(handles.edit23, 'String', roundn(handles.L_kvh05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Длинноволновая граница рабочего спектрального диапазона (0.5)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i = N_max;
    while ((0.5 * handles.t_max) < handles.DataY(i)) &&...
            (i ~= size(handles.DataY, 1))
        i = i + 1;
    end;
    
    % Подсвечивание если ошибка в количестве данных
    if (0.5 * handles.t_max) < handles.DataY(i)
        set(handles.edit24, 'BackgroundColor', [0.0 0.8 1.0]);
    else
        set(handles.edit24, 'BackgroundColor', 'w');
    end;
    
    % Создание переменной
    handles.L_dvh05 = handles.DataX(i);
    
    % Записываем значение
    set(handles.edit24, 'String', roundn(handles.L_dvh05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Спектральная ширина рабочей полосы пропускания на уровыне 0.5
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание переменной
    handles.dL_05 = abs(handles.L_dvh05 - handles.L_kvh05);
    
    % Записываем значение
    set(handles.edit214, 'String', roundn(handles.dL_05, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Длина волны цетра рабочей полосы пропускания
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание переменной
    handles.dL_sr = (0.5 * handles.dL_05) + handles.L_dvh05;
    
    % Записываем значение
    set(handles.edit215, 'String', roundn(handles.dL_sr, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Средний коэф. пропускания светофильтра
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Проверка максимального коэф. пропускания
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
    
    % Создание переменной
    handles.t_srsf = sum(handles.DataY(find(handles.DataX == L_kvh06):...
        find(handles.DataX == L_dvh06))) / abs(find(handles.DataX ==...
        L_dvh06) - find(handles.DataX == L_kvh06));
    
    % Записываем значение
    set(handles.edit27, 'String', roundn(handles.t_srsf, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Средний коэф. пропускания светофильтра в рабочей полосе
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
    
    % Создание переменной
    handles.t_srup = sum(handles.DataY(find(handles.DataX == L_kvh08):...
        find(handles.DataX == L_dvh08))) / abs(find(handles.DataX ==...
        L_dvh08) - find(handles.DataX == L_kvh08));
    
    clear L_kvh08 L_dvh08;
    
    % Записываем значение
    set(handles.edit28, 'String', roundn(handles.t_srup, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Крутизна коротковолновой границы пропуск. светофильтра
    % Крутизна длинноволновой границы пропуск. светофильтра
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
    
    % Создание переменной
    handles.K_pks = L_kvh01 / L_kvh06;
    handles.K_pds = L_dvh01 / L_dvh06;
    
    clear L_kvh01 L_dvh01 L_kvh06 L_dvh06;
    
    % Записываем значение
    set(handles.edit212, 'String',  roundn(handles.K_pks, -2));
    set(handles.edit213, 'String',  roundn(handles.K_pds, -2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Площадь под кривой коэф. пропуск. реал. светофильтра
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание функции светофильтра
    handles.func_of = @(z)interp1(handles.DataX, handles.DataY, z);
    
    % Нахождение площади под кривой светофильтра
    handles.S_of = integral(handles.func_of, handles.L_kvh, handles.L_dvh);
    
    % Записываем значение
    set(handles.edit29, 'String',  roundn(handles.S_of, -3));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Эквивалентный прямоугольник пропускания светофильтра
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Нахождение эквив. коэф. пропуск. светофильтра
    handles.t_lim = handles.S_of / handles.dL_05;
    
    % Подсвечивание если эквив. полосы пропускания больше рабочей
    % полосы полосы пропускания
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
    
    % Задаем реальную ширину полосы пропускания
    handles.dL_lim = handles.dL_05;
    
    % Вычисляем границы эквив. полосы пропускания
    handles.L_kvh_e = handles.L_kvh05;
    handles.L_dvh_e = handles.L_dvh05;
    
    % Проверка на адекватность значения
    if handles.t_lim > 1.0
        % Устанавливаем реальную границу
        handles.t_lim = 1.0;
        
        % Задаем реальную ширину полосы пропускания
        handles.dL_lim = handles.S_of;

        % Записываем значение
        set(handles.edit220, 'String',  roundn(handles.dL_lim, -2));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Вычисляем границы эквив. полосы пропускания
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        handles.L_kvh_e = handles.L_kvh05 - 0.5 * (handles.S_of - handles.dL_05);
        
        handles.L_dvh_e = handles.L_dvh05 + 0.5 * (handles.S_of - handles.dL_05);
    end;
    
    % Записываем значение
    set(handles.edit219, 'String',  roundn(handles.t_lim, -2));
    set(handles.edit220, 'String',  roundn(handles.dL_lim, -2));
    set(handles.edit221, 'String',  roundn(handles.L_kvh_e, -2));
    set(handles.edit222, 'String',  roundn(handles.L_dvh_e, -2));
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = tz_svetofiltr(handles)
% Расчет параметров которые относятся к анализу светофильтра

if (isempty(handles.t_min) == 0) && (isempty(handles.t_tz) == 0)&& ...
        (isempty(handles.L_05l) == 0) && (isempty(handles.L_05r) == 0) && ...
        (isempty(handles.K_pkv) == 0) && (isempty(handles.K_pdv) == 0)
    
    % Центр, основа точка построения боковых граней
    t_osn = 0.5;
    
    % Точки коэф. пропускания согласно формуле
    t_01 = 0.1;
    t_06 = 0.6;
    
    % Нахождение левой и правой опоры
    l_opl = handles.L_05l * ((t_06 - t_01) / ((t_osn - t_01) * (1 - handles.K_pkv) + handles.K_pkv * (t_06 - t_01)));
    l_opr = handles.L_05r * ((t_06 - t_01) / ((t_osn - t_01) * (1 - handles.K_pdv) + handles.K_pdv * (t_06 - t_01)));
    
    clear t_osn;

    % Задание функций по боковых гранях 
%     f_l = @(z)((((z - l_opl * handles.K_pkv) * (t_06 - t_01)) / (l_opl * (1 - handles.K_pkv))) + t_01);
%     f_r = @(z)((((z - l_opr * handles.K_pdv) * (t_06 - t_01)) / (l_opr * (1 - handles.K_pdv))) + t_01);
%   clear f_l f_r;

    % Функции для нахождения граничных точек идеального графика
    g_l = @(z)(l_opl * (((z - t_01) * (1 - handles.K_pkv) / (t_06 - t_01)) + handles.K_pkv));
    g_r = @(z)(l_opr * (((z - t_01) * (1 - handles.K_pdv) / (t_06 - t_01)) + handles.K_pdv));
    
    clear t_01 t_06 l_opl l_opr;

    % Нахождение опорных точек идеального графика
    Lminl = g_l(handles.t_min);
    Lmaxl = g_l(handles.t_tz);
    Lminr = g_r(handles.t_tz);
    Lmaxr = g_r(handles.t_min);
    
    clear g_l g_r;
    
    % Нахождение точек графика
    handles.Data_tzX = [Lminl; Lmaxl; Lminr; Lmaxr];
    handles.Data_tzY = [handles.t_min; handles.t_tz; handles.t_tz; handles.t_min];
    
    clear Lmaxl Lmaxr Lminl Lminr;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Площадь под кривой коэф. пропуск. светофильтра по ТЗ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание функции светофильтра ТЗ
    handles.func_tz = @(z)interp1(handles.Data_tzX, handles.Data_tzY, z);
    
    % Нахождение площади под кривой светофильтра
    handles.S_tz = integral(handles.func_tz, min(handles.Data_tzX), max(handles.Data_tzX));
    
    % Записываем значение
    set(handles.edit210, 'String',  roundn(handles.S_tz, -3));
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = ploscha_analiz(handles)
% Расчет относительной площади которая относятся к анализу светофильтра

if (isempty(handles.S_of) == 0) && (isempty(handles.S_tz) == 0)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Отношение площадей под кривой коэф. пропуск. светофильтров
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    handles.S_oftz = handles.S_of / handles.S_tz;
    
    % Записываем значение
    set(handles.edit211, 'String',  roundn(handles.S_oftz, -3));
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = detector(handles)
% Расчет параметров которые относятся приёмнику

if (isempty(handles.DataY_1) == 0)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Площадь под кривой коэф. пропуск. приёмника
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создание функции приёмника
    handles.func_det = @(z)interp1(handles.DataX_1, handles.DataY_1, z);
    
    % Нахождение площади под кривой светофильтра
    handles.S_det = integral(handles.func_det, min(handles.DataX_1), max(handles.DataX_1));
    
    % Записываем значение
    set(handles.edit217, 'String',  roundn(handles.S_det, -3));
    
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function handles = detector_analiz(handles)
% Расчет параметров которые относятся к анализу приёмника

if (isempty(handles.S_of) == 0) && (isempty(handles.S_det) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Площадь пересеч. кривых светофильтра и приёмника
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Создаем произведение функций
    func_of = @(z)handles.func_of(z);
    func_det = @(z)handles.func_det(z);
    handles.func_fd = @(z)(min(func_of(z), func_det(z)));
    
    % Вычисляем границы пересечения
    Xmin = max(handles.DataX(1), handles.DataX_1(1));
    Xmax = min(handles.DataX(end), handles.DataX_1(end));
    
    % Проверка наличия данных
    if Xmin >= Xmax
        % Записываем значение
        set(handles.edit216, 'String', 'NaN');
        set(handles.edit218, 'String', 'NaN');
        
        handles.S_fd = NaN;
        handles.S_fdet = NaN;
    else
        % Расчитываем свертку функций светофильтра и приёмника
        handles.S_fd = integral(handles.func_fd,...
            max(handles.DataX(1), handles.DataX_1(1)),...
            min(handles.DataX(end), handles.DataX_1(end)));
        
        % Записываем значение
        set(handles.edit216, 'String',  roundn(handles.S_fd, -3));
    end;

    clear func_of func_det;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Отношение площадей под кривой коэф. пропуск. приём. и пересечен.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Проверка наличия данных
    if Xmin < Xmax
        % Расчитываем отношение площадей приёмника и светофильтра
        handles.S_fdet = handles.S_fd / handles.S_det;
        
        % Записываем значение
        set(handles.edit218, 'String',  roundn(handles.S_fdet, -3));
    end;
    
    % Объединяем два масива (без повторений)
    handles.DataX_2 = union(handles.DataX, handles.DataX_1);

    % Находим номера границ и обрезаем лишние данные
    handles.DataX_2 = handles.DataX_2(1:find(handles.DataX_2 == Xmax));
    handles.DataX_2 = handles.DataX_2(find(handles.DataX_2 == Xmin):end);
    
    clear Xmin Xmax;
    
    % Расчитываем значения
    handles.DataY_2 = handles.func_fd(handles.DataX_2);
end;

% Сохранение данных для общего доступа
guidata(gcbo, handles);

function DataReport = generate_report(handles)
% Генерация отчета для файла *.doc

% Создаем переменную
DataReport = [];
DataReport{size(DataReport, 1) + 1, 1} = '%% *Отчет программы Optical Filter*';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = char(['% *Дата:* _', handles.Date, '_']);
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% Проверяем наявность расчитанных данных и сохраняем в переменную
if isempty(get(handles.edit11, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Название светофильтра для анализа: _',...
        get(handles.edit11, 'String'), '_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit19, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Название приёмника для анализа: _',...
        get(handles.edit19, 'String'), '_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*Входные данные:*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

if (isempty(get(handles.edit12, 'String')) == 0) &&...
    strcmp(get(handles.edit12, 'Enable'), 'on')
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Центр отсчета для поиска на графике светофильтра: *',...
        get(handles.edit12, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit13, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Нижняя граница коэффициента пропускания светофильтра: *',...
        get(handles.edit13, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit14, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Верхняя граница коэффициента пропускания светофильтра по ТЗ: *',...
        get(handles.edit14, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit15, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Левая опорная длина волны по ТЗ: *',...
        get(handles.edit15, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if (isempty(get(handles.edit16, 'String')) == 0) &&...
        strcmp(get(handles.edit12, 'Enable'), 'on')
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Правая опорная длина волны по ТЗ: *',...
        get(handles.edit16, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit17, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Крутизна коротковолновой границы пропускания по ТЗ: *',...
        get(handles.edit17, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit18, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Крутизна длинноволновой границы пропускания по ТЗ: *',...
        get(handles.edit18, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*Результаты расчета:*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

if isempty(get(handles.edit21, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Коротковолновая граница спектрального диапазона: *',...
        get(handles.edit21, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit22, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Длинноволновая граница спектрального диапазона: *',...
        get(handles.edit22, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end

if isempty(get(handles.edit23, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Длина волны для уровня 0.5 на коротковолновой границе пропускания: *',...
        get(handles.edit23, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit24, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Длина волны для уровня 0.5 на длинноволновой границе пропускания: *',...
        get(handles.edit24, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit25, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Максимальный коэффициент пропускания светофильтра: *',...
        get(handles.edit25, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit26, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Длина волны при максимальном коэффициенте пропускания светофильтра: *',...
        get(handles.edit26, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit27, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Средний коэффициент пропускания светофильтра: *',...
        get(handles.edit27, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit28, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Средний коэффициент пропускания узкополосного светофильтра: *',...
        get(handles.edit28, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit29, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Площадь под кривой пропускания светофильтра для анализа: *',...
        get(handles.edit29, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit212, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Крутизна коротковолновой границы пропускания светофильтра: *',...
        get(handles.edit212, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit213, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Крутизна длинноволновой границы пропускания светофильтра: *',...
        get(handles.edit213, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit214, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Спектральная ширина рабочей полосы пропускания на уровне 0.5: *',...
        get(handles.edit214, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit215, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Длина волны центра рабочей полосы пропускания: *',...
        get(handles.edit215, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit210, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Площадь под кривой коэффициент пропускания светофильтра по ТЗ: *',...
        get(handles.edit210, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit211, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Отношение площадей под кривыми коэффициента пропускания светофильтра: *',...
        get(handles.edit211, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit219, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Эквивалентный коэффициент пропускания светофильтра: *',...
        get(handles.edit219, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit220, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Эквивалентная спектральная ширина полосы пропускания: *',...
        get(handles.edit220, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit221, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Эквивалентная коротковолновая граница спектрального диапазона: *',...
        get(handles.edit221, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit222, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Эквивалентная длинноволновая граница спектрального диапазона: *',...
        get(handles.edit22, 'String'), '* _мкм_']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit216, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Площадь пересечения кривых светофильтра и приёмника: *',...
        get(handles.edit216, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit217, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Площадь под кривой коэффициента пропускания приёмника: *',...
        get(handles.edit217, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

if isempty(get(handles.edit218, 'String')) == 0
    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% Отношение площадей под кривой коэффициента пропускания приёмника и пересечения: *',...
        get(handles.edit218, 'String'), '*']);
    DataReport{size(DataReport, 1) + 1, 1} = '%';
end;

DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% _*Диалоговое окно*_';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% Сохраняем изображение диалогового окна
saveas(handles.figure1, 'figure1.bmp');

% Записываем адрес изображения
AdressFile = imfinfo('figure1.bmp');

DataReport{size(DataReport, 1) + 1, 1} =...
    char(['% <<', AdressFile.Filename, '>>']);

DataReport{size(DataReport, 1) + 1, 1} = '%';
DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
DataReport{size(DataReport, 1) + 1, 1} = '%';

% График светофильтра
if isempty(handles.DataX_0) == 0
    % Строим график светофильтра
    handles = mouse_click_axes31(0, 0, handles);
    
    % Сохраняем изображение
    saveas(handles.f2, 'figure2.bmp');
    
    % Записываем адрес изображения
    AdressFile = imfinfo('figure2.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*График коэффициента пропускания светофильтра:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % Закрываем окно графика
    close(handles.f2);
end;

% График светофильтра для анализа
if (isempty(handles.DataX) == 0) &&...
        (isempty(handles.Data_tzX) == 0)
    % Строим график светофильтра
    handles = mouse_click_axes32(0, 0, handles);
    
    % Сохраняем изображение
    saveas(handles.f3, 'figure3.bmp');
    
    % Записываем адрес изображения
    AdressFile = imfinfo('figure3.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*График анализа коэффициента пропускания светофильтра по ТЗ:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % Закрываем окно графика
    close(handles.f3);
end

% График приёмника для анализа
if (isempty(handles.DataX) == 0) &&...
        (isempty(handles.DataX_1) == 0)
    % Строим график светофильтра
    handles = mouse_click_axes33(0, 0, handles);
    
    % Сохраняем изображение
    saveas(handles.f4, 'figure4.bmp');
    
    % Записываем адрес изображения
    AdressFile = imfinfo('figure4.bmp');
    
    DataReport{size(DataReport, 1) + 1, 1} = '% _*Анализ коэффициента пропускания приёмника:*_';
    DataReport{size(DataReport, 1) + 1, 1} = '%';

    DataReport{size(DataReport, 1) + 1, 1} =...
        char(['% <<', AdressFile.Filename, '>>']);
    
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    DataReport{size(DataReport, 1) + 1, 1} = '% <latex></latex>';
    DataReport{size(DataReport, 1) + 1, 1} = '%';
    
    % Закрываем окно графика
    close(handles.f4);
end

%%%%%%%%%%%%%%%%%%%%%%%
%%%% Новые функции %%%%
%%%%%%%%%%%%%%%%%%%%%%%
