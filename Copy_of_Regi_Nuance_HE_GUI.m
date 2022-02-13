classdef Regi_Nuance_HE_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1                     matlab.ui.Figure
        ImportPanel                 matlab.ui.container.Panel
        GridLayout3                 matlab.ui.container.GridLayout
        AADEditFieldLabel           matlab.ui.control.Label
        AADEditField                matlab.ui.control.EditField
        HEEditFieldLabel            matlab.ui.control.Label
        HEEditField                 matlab.ui.control.EditField
        LOADButton                  matlab.ui.control.Button
        TabGroup                    matlab.ui.container.TabGroup
        ManuallyTab                 matlab.ui.container.Tab
        loadtformButton             matlab.ui.control.Button
        savePanel                   matlab.ui.container.Panel
        save_pushbutton             matlab.ui.control.Button
        tformfileCheckBox           matlab.ui.control.CheckBox
        FeaturepointsCheckBox       matlab.ui.control.CheckBox
        cpselect_pushbutton         matlab.ui.control.Button
        AutoTab                     matlab.ui.container.Tab
        InitailregistrationButton   matlab.ui.control.Button
        precessingPanel             matlab.ui.container.Panel
        GridLayout                  matlab.ui.container.GridLayout
        Binarize7aadimagePanel      matlab.ui.container.Panel
        wiener2EditField_3          matlab.ui.control.NumericEditField
        bwareaopenEditField         matlab.ui.control.NumericEditField
        bwareaopenEditFieldLabel    matlab.ui.control.Label
        wiener2EditField            matlab.ui.control.NumericEditField
        wiener2EditFieldLabel       matlab.ui.control.Label
        greythretholdSlider         matlab.ui.control.Slider
        greythretholdSliderLabel    matlab.ui.control.Label
        BinarizeheimagePanel_2      matlab.ui.container.Panel
        wiener2EditField_4          matlab.ui.control.NumericEditField
        greythretholdSlider_3       matlab.ui.control.Slider
        greythretholdSlider_3Label  matlab.ui.control.Label
        bwareaopenEditField_2       matlab.ui.control.NumericEditField
        bwareaopenEditField_2Label  matlab.ui.control.Label
        wiener2EditField_2          matlab.ui.control.NumericEditField
        wiener2EditField_2Label     matlab.ui.control.Label
        refreshButton               matlab.ui.control.Button
        saveButton                  matlab.ui.control.Button
        SlidiingwindowPanel         matlab.ui.container.Panel
        GridLayout2                 matlab.ui.container.GridLayout
        coreEditFieldLabel          matlab.ui.control.Label
        coreEditField               matlab.ui.control.NumericEditField
        topEditFieldLabel           matlab.ui.control.Label
        topEditField                matlab.ui.control.NumericEditField
        stepEditFieldLabel          matlab.ui.control.Label
        stepEditField               matlab.ui.control.NumericEditField
        RunButton                   matlab.ui.control.Button
        HECheckBox                  matlab.ui.control.CheckBox
        axes2                       matlab.ui.control.UIAxes
        axes1                       matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function main_gui_OpeningFcn(app, varargin)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
            % This function has no output args, see OutputFcn.
            % hObject    handle to figure
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % varargin   command line arguments to main_gui (see VARARGIN)
            
            % Choose default command line output for main_gui
            handles.output = hObject;
            
            % Update handles structure
            guidata(hObject, handles);
        end

        % Button pushed function: LOADButton
        function LOAD_putshbutton_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to LOAD_putshbutton (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            global image
            [filename1, filepath]=uigetfile('*.*','please choose a Nuance image');%filename?????filepath?????
            image{1}=imread(strcat(filepath,filename1));
            str1=[filepath filename1];      %????????
            app.AADEditField.Value = str1;
%             set( handles.edit1,'String',str1);   % ??????????????
            
            [filename2, filepath]=uigetfile('*.*','please choose a H&E image');%filename?????filepath?????
            image{2}=imread(strcat(filepath,filename2));
            str2=[filepath filename2];
%             set( handles.edit2,'String',str2);
            app.HEEditField.Value = str2;
            
            axes(app.axes1);
            imshow(image{1});
            axes(app.axes2);
            imshow(image{2})
            
            
        end

        % Callback function
        function Savepoint_pushbutton_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
        end

        % Button pushed function: cpselect_pushbutton
        function cpselect_pushbutton_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to cpselect_pushbutton (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            
            global image t_concord
            global movingPoints fixedPoints
            [movingPoints,fixedPoints] = cpselect(image{1},image{2},'Wait',true);
            fix = image{2};
            remove = image{1};
            % imshowpair(fix,remove,'blend');
            t_concord = fitgeotrans(fixedPoints,movingPoints,'similarity');
            remove_ref = imref2d(size(remove)); %relate intrinsic and world coordinates
            global aerial_registered
            aerial_registered = imwarp(fix,t_concord,'OutputView',remove_ref);
            axes(handles.axes1);
            imshow(aerial_registered);
            axes(handles.axes2);
            imshowpair(aerial_registered,remove,'blend')
      
            
        end

        % Button pushed function: loadtformButton
        function loadtformButtonPushed(app, event)
            
        end
        
        % Button pushed function: save_pushbutton
        function save_pushbutton_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to save_pushbutton (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            global savehe savepoint savetform aerial_registered movingPoints fixedPoints t_concord
            
            if savehe 
%             global aerial_registered
            %combination and file name
            [filename, pathname]=uiputfile({'*.jpg';'*.bmp';'*.gif';'*.tif'},'Save H&E as');
            str = [pathname filename];
            if (filename~=0)
            imwrite(aerial_registered,str);
            end
            
            if savepoint
            % save(complete_name, movingPoints fixedPoints);
            [filename ,pathname]=uiputfile({'*.mat','MAT-files(*.mat)'},'Save featurepoints as');
            str=strcat(pathname,filename);
            save(char(str), 'movingPoints', 'fixedPoints');
            end
            if savetform
            [filename ,pathname]=uiputfile({'*.mat','MAT-files(*.mat)'},'Save tform as');
            str=strcat(pathname,filename);
            tform_nu2he = invert(t_concord);
            save(char(str), 'tform_nu2he');
            end
           

            end
        end

        % Value changed function: FeaturepointsCheckBox, 
        % HECheckBox, tformfileCheckBox
        function CheckBoxValueChanged(app, event)
            
            global savehe savepoint savetform
            savehe =  app.HECheckBox.Value;
            savepoint =  app.FeaturepointsCheckBox.Value;
            savetform  =  app.tformfileCheckBox.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            app.figure1.Position = [500 100 942 797];
            app.figure1.Name = 'Registration';
            app.figure1.Resize = 'off';
            app.figure1.HandleVisibility = 'callback';
            app.figure1.Tag = 'Registration';

            % Create axes1
            app.axes1 = uiaxes(app.figure1);
            app.axes1.XTick = [];
            app.axes1.YTick = [];
            app.axes1.FontSize = 13.3333333333333;
            app.axes1.NextPlot = 'replace';
            app.axes1.Tag = 'axes1';
            app.axes1.Position = [460 404 461 345];

            % Create axes2
            app.axes2 = uiaxes(app.figure1);
            app.axes2.XTick = [];
            app.axes2.YTick = [];
            app.axes2.FontSize = 13.3333333333333;
            app.axes2.NextPlot = 'replace';
            app.axes2.Tag = 'axes2';
            app.axes2.Position = [463 35 458 345];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.figure1);
            app.TabGroup.Position = [39 29 390 598];

            % Create ManuallyTab
            app.ManuallyTab = uitab(app.TabGroup);
            app.ManuallyTab.Title = 'Manually';

            % Create cpselect_pushbutton
            app.cpselect_pushbutton = uibutton(app.ManuallyTab, 'push');
            app.cpselect_pushbutton.ButtonPushedFcn = createCallbackFcn(app, @cpselect_pushbutton_Callback, true);
            app.cpselect_pushbutton.Tag = 'cpselect_pushbutton';
            app.cpselect_pushbutton.FontSize = 16;
            app.cpselect_pushbutton.FontWeight = 'bold';
            app.cpselect_pushbutton.Position = [44 491 88 37];
            app.cpselect_pushbutton.Text = 'cpselect';

            % Create savePanel
            app.savePanel = uipanel(app.ManuallyTab);
            app.savePanel.Title = 'save';
            app.savePanel.FontWeight = 'bold';
            app.savePanel.FontSize = 16;
            app.savePanel.Position = [26 325 341 118];

            % Create HECheckBox
            app.HECheckBox = uicheckbox(app.savePanel);
            app.HECheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.HECheckBox.Text = 'H&E';
            app.HECheckBox.Position = [8 62 47 22];

            % Create FeaturepointsCheckBox
            app.FeaturepointsCheckBox = uicheckbox(app.savePanel);
            app.FeaturepointsCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.FeaturepointsCheckBox.Text = 'Feature points';
            app.FeaturepointsCheckBox.Position = [8 33 99 22];

            % Create tformfileCheckBox
            app.tformfileCheckBox = uicheckbox(app.savePanel);
            app.tformfileCheckBox.ValueChangedFcn = createCallbackFcn(app, @CheckBoxValueChanged, true);
            app.tformfileCheckBox.Text = 'tform file';
            app.tformfileCheckBox.Position = [8 4 68 22];

            % Create save_pushbutton
            app.save_pushbutton = uibutton(app.savePanel, 'push');
            app.save_pushbutton.ButtonPushedFcn = createCallbackFcn(app, @save_pushbutton_Callback, true);
            app.save_pushbutton.Tag = 'save_pushbutton';
            app.save_pushbutton.FontSize = 16;
            app.save_pushbutton.FontWeight = 'bold';
            app.save_pushbutton.Position = [189 39 88 36];
            app.save_pushbutton.Text = 'SAVE';

            % Create loadtformButton
            app.loadtformButton = uibutton(app.ManuallyTab, 'push');
            app.loadtformButton.ButtonPushedFcn = createCallbackFcn(app, @loadtformButtonPushed, true);
            app.loadtformButton.FontSize = 16;
            app.loadtformButton.FontWeight = 'bold';
            app.loadtformButton.Position = [197 491 100 35];
            app.loadtformButton.Text = 'load tform';

            % Create AutoTab
            app.AutoTab = uitab(app.TabGroup);
            app.AutoTab.Title = 'Auto';

            % Create precessingPanel
            app.precessingPanel = uipanel(app.AutoTab);
            app.precessingPanel.TitlePosition = 'centertop';
            app.precessingPanel.Title = 'precessing';
            app.precessingPanel.FontWeight = 'bold';
            app.precessingPanel.FontSize = 16;
            app.precessingPanel.Position = [20 210 353 348];
            
            % Create GridLayout
            app.GridLayout = uigridlayout(app.precessingPanel);
            app.GridLayout.ColumnWidth = {'1.33x', 100, '1x'};
            app.GridLayout.RowHeight = {125, 125, 26};
            app.GridLayout.ColumnSpacing = 5.75;
            app.GridLayout.RowSpacing = 11.75;
            app.GridLayout.Padding = [5.75 11.75 5.75 11.75];
            
            % Create SlidiingwindowPanel
            app.SlidiingwindowPanel = uipanel(app.AutoTab);
            app.SlidiingwindowPanel.Title = 'Slidiing window';
            app.SlidiingwindowPanel.FontWeight = 'bold';
            app.SlidiingwindowPanel.FontSize = 16;
            app.SlidiingwindowPanel.Position = [16 62 357 97];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.SlidiingwindowPanel);
            app.GridLayout2.ColumnWidth = {29, '1.33x', '1x', 25, 77};
            app.GridLayout2.RowHeight = {22, 26};
            app.GridLayout2.RowSpacing = 8;
            app.GridLayout2.Padding = [10 8 10 8];

            % Create RunButton
            app.RunButton = uibutton(app.GridLayout2, 'push');
            app.RunButton.FontSize = 16;
            app.RunButton.Layout.Row = 2;
            app.RunButton.Layout.Column = [4 5];
            app.RunButton.Text = 'Run';

            % Create stepEditField
            app.stepEditField = uieditfield(app.GridLayout2, 'numeric');
            app.stepEditField.Layout.Row = 1;
            app.stepEditField.Layout.Column = 2;
            app.stepEditField.Value = 20;

            % Create stepEditFieldLabel
            app.stepEditFieldLabel = uilabel(app.GridLayout2);
            app.stepEditFieldLabel.HorizontalAlignment = 'right';
            app.stepEditFieldLabel.Layout.Row = 1;
            app.stepEditFieldLabel.Layout.Column = 1;
            app.stepEditFieldLabel.Text = 'step';

            % Create topEditField
            app.topEditField = uieditfield(app.GridLayout2, 'numeric');
            app.topEditField.Layout.Row = 1;
            app.topEditField.Layout.Column = 5;
            app.topEditField.Value = 10;

            % Create topEditFieldLabel
            app.topEditFieldLabel = uilabel(app.GridLayout2);
            app.topEditFieldLabel.HorizontalAlignment = 'right';
            app.topEditFieldLabel.Layout.Row = 1;
            app.topEditFieldLabel.Layout.Column = 4;
            app.topEditFieldLabel.Text = 'top';

            % Create coreEditField
            app.coreEditField = uieditfield(app.GridLayout2, 'numeric');
            app.coreEditField.Layout.Row = 2;
            app.coreEditField.Layout.Column = 2;
            app.coreEditField.Value = 4;

            % Create coreEditFieldLabel
            app.coreEditFieldLabel = uilabel(app.GridLayout2);
            app.coreEditFieldLabel.HorizontalAlignment = 'right';
            app.coreEditFieldLabel.Layout.Row = 2;
            app.coreEditFieldLabel.Layout.Column = 1;
            app.coreEditFieldLabel.Text = 'core';

            % Create saveButton
            app.saveButton = uibutton(app.AutoTab, 'push');
            app.saveButton.FontSize = 16;
            app.saveButton.FontWeight = 'bold';
            app.saveButton.Position = [156 15 100 26];
            app.saveButton.Text = 'save';

            % Create BinarizeheimagePanel_2
            app.BinarizeheimagePanel_2 = uipanel(app.GridLayout);
            app.BinarizeheimagePanel_2.Title = ' Binarize h&e image';
            app.BinarizeheimagePanel_2.Layout.Row = 2;
            app.BinarizeheimagePanel_2.Layout.Column = [1 3];
            app.BinarizeheimagePanel_2.Position = [7 51 340 125];

            % Create wiener2EditField_2Label
            app.wiener2EditField_2Label = uilabel(app.BinarizeheimagePanel_2);
            app.wiener2EditField_2Label.HorizontalAlignment = 'right';
            app.wiener2EditField_2Label.Position = [14 17 48 22];
            app.wiener2EditField_2Label.Text = 'wiener2';

            % Create wiener2EditField_2
            app.wiener2EditField_2 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.wiener2EditField_2.Position = [77 17 34 22];
            app.wiener2EditField_2.Value = 5;

            % Create bwareaopenEditField_2Label
            app.bwareaopenEditField_2Label = uilabel(app.BinarizeheimagePanel_2);
            app.bwareaopenEditField_2Label.HorizontalAlignment = 'right';
            app.bwareaopenEditField_2Label.Position = [178 17 72 22];
            app.bwareaopenEditField_2Label.Text = 'bwareaopen';

            % Create bwareaopenEditField_2
            app.bwareaopenEditField_2 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.bwareaopenEditField_2.Position = [265 17 45 22];
            app.bwareaopenEditField_2.Value = 3;

            % Create greythretholdSlider_3Label
            app.greythretholdSlider_3Label = uilabel(app.BinarizeheimagePanel_2);
            app.greythretholdSlider_3Label.HorizontalAlignment = 'right';
            app.greythretholdSlider_3Label.Position = [19 73 72 22];
            app.greythretholdSlider_3Label.Text = 'greythrethold';

            % Create greythretholdSlider_3
            app.greythretholdSlider_3 = uislider(app.BinarizeheimagePanel_2);
            app.greythretholdSlider_3.Limits = [0 1];
            app.greythretholdSlider_3.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider_3.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider_3.Position = [104 85 187 3];

            % Create wiener2EditField_4
            app.wiener2EditField_4 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.wiener2EditField_4.Position = [122 17 33 22];
            app.wiener2EditField_4.Value = 5;

            % Create wiener2EditField_4
            app.wiener2EditField_4 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.wiener2EditField_4.Position = [122 17 33 22];
            app.wiener2EditField_4.Value = 5;

            % Create wiener2EditField_4
            app.wiener2EditField_4 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.wiener2EditField_4.Position = [122 17 33 22];
            app.wiener2EditField_4.Value = 5;

            % Create refreshButton
            app.refreshButton = uibutton(app.GridLayout, 'push');
            app.refreshButton.FontSize = 16;
            app.refreshButton.FontWeight = 'bold';
            app.refreshButton.Layout.Row = 3;
            app.refreshButton.Layout.Column = 2;
            app.refreshButton.Position = [143 13 100 26];
            app.refreshButton.Text = 'refresh';

            % Create refreshButton
            app.refreshButton = uibutton(app.GridLayout, 'push');
            app.refreshButton.FontSize = 16;
            app.refreshButton.FontWeight = 'bold';
            app.refreshButton.Layout.Row = 3;
            app.refreshButton.Layout.Column = 2;
            app.refreshButton.Text = 'refresh';

            % Create BinarizeheimagePanel_2
            app.BinarizeheimagePanel_2 = uipanel(app.GridLayout);
            app.BinarizeheimagePanel_2.Title = ' Binarize h&e image';
            app.BinarizeheimagePanel_2.Layout.Row = 2;
            app.BinarizeheimagePanel_2.Layout.Column = [1 3];

            % Create wiener2EditField_2Label
            app.wiener2EditField_2Label = uilabel(app.BinarizeheimagePanel_2);
            app.wiener2EditField_2Label.HorizontalAlignment = 'right';
            app.wiener2EditField_2Label.Position = [14 17 48 22];
            app.wiener2EditField_2Label.Text = 'wiener2';

            % Create wiener2EditField_2
            app.wiener2EditField_2 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.wiener2EditField_2.Position = [77 17 34 22];
            app.wiener2EditField_2.Value = 5;

            % Create bwareaopenEditField_2Label
            app.bwareaopenEditField_2Label = uilabel(app.BinarizeheimagePanel_2);
            app.bwareaopenEditField_2Label.HorizontalAlignment = 'right';
            app.bwareaopenEditField_2Label.Position = [178 17 72 22];
            app.bwareaopenEditField_2Label.Text = 'bwareaopen';

            % Create bwareaopenEditField_2
            app.bwareaopenEditField_2 = uieditfield(app.BinarizeheimagePanel_2, 'numeric');
            app.bwareaopenEditField_2.Position = [265 17 45 22];
            app.bwareaopenEditField_2.Value = 3;

            % Create greythretholdSlider_3Label
            app.greythretholdSlider_3Label = uilabel(app.BinarizeheimagePanel_2);
            app.greythretholdSlider_3Label.HorizontalAlignment = 'right';
            app.greythretholdSlider_3Label.Position = [19 73 72 22];
            app.greythretholdSlider_3Label.Text = 'greythrethold';

            % Create greythretholdSlider_3
            app.greythretholdSlider_3 = uislider(app.BinarizeheimagePanel_2);
            app.greythretholdSlider_3.Limits = [0 1];
            app.greythretholdSlider_3.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider_3.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider_3.Position = [104 85 187 3];

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create Binarize7aadimagePanel
            app.Binarize7aadimagePanel = uipanel(app.GridLayout);
            app.Binarize7aadimagePanel.Title = ' Binarize 7aad image';
            app.Binarize7aadimagePanel.Layout.Row = 1;
            app.Binarize7aadimagePanel.Layout.Column = [1 3];

            % Create greythretholdSliderLabel
            app.greythretholdSliderLabel = uilabel(app.Binarize7aadimagePanel);
            app.greythretholdSliderLabel.HorizontalAlignment = 'right';
            app.greythretholdSliderLabel.Position = [20 70 72 22];
            app.greythretholdSliderLabel.Text = 'greythrethold';

            % Create greythretholdSlider
            app.greythretholdSlider = uislider(app.Binarize7aadimagePanel);
            app.greythretholdSlider.Limits = [0 1];
            app.greythretholdSlider.MajorTicks = [0 0.2 0.4 0.6 0.8 1];
            app.greythretholdSlider.MajorTickLabels = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
            app.greythretholdSlider.Position = [105 82 187 3];

            % Create wiener2EditFieldLabel
            app.wiener2EditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.wiener2EditFieldLabel.HorizontalAlignment = 'right';
            app.wiener2EditFieldLabel.Position = [16 13 48 22];
            app.wiener2EditFieldLabel.Text = 'wiener2';

            % Create wiener2EditField
            app.wiener2EditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField.Position = [79 13 37 22];
            app.wiener2EditField.Value = 5;

            % Create bwareaopenEditFieldLabel
            app.bwareaopenEditFieldLabel = uilabel(app.Binarize7aadimagePanel);
            app.bwareaopenEditFieldLabel.HorizontalAlignment = 'right';
            app.bwareaopenEditFieldLabel.Position = [178 11 72 22];
            app.bwareaopenEditFieldLabel.Text = 'bwareaopen';

            % Create bwareaopenEditField
            app.bwareaopenEditField = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.bwareaopenEditField.Position = [265 11 45 22];
            app.bwareaopenEditField.Value = 3;

            % Create wiener2EditField_3
            app.wiener2EditField_3 = uieditfield(app.Binarize7aadimagePanel, 'numeric');
            app.wiener2EditField_3.Position = [124 13 33 22];
            app.wiener2EditField_3.Value = 5;

            % Create InitailregistrationButton
            app.InitailregistrationButton = uibutton(app.AutoTab, 'push');
            app.InitailregistrationButton.FontSize = 16;
            app.InitailregistrationButton.FontWeight = 'bold';
            app.InitailregistrationButton.Position = [136 173 150 26];
            app.InitailregistrationButton.Text = 'Initail registration';

            % Create ImportPanel
            app.ImportPanel = uipanel(app.figure1);
            app.ImportPanel.Title = 'Import';
            app.ImportPanel.FontWeight = 'bold';
            app.ImportPanel.FontSize = 15;
            app.ImportPanel.Position = [39 642 389 107];

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.ImportPanel);
            app.GridLayout3.ColumnWidth = {37, '1.58x', '1x', 65};
            app.GridLayout3.RowHeight = {26, 22};
            
            % Create LOADButton
            app.LOADButton = uibutton(app.GridLayout3, 'push');
            app.LOADButton.ButtonPushedFcn = createCallbackFcn(app, @LOAD_putshbutton_Callback, true);
            app.LOADButton.FontSize = 16;
            app.LOADButton.FontWeight = 'bold';
            app.LOADButton.Layout.Row = 1;
            app.LOADButton.Layout.Column = 4;
            app.LOADButton.Position = [313 48 65 26];
            app.LOADButton.Text = 'LOAD';

            % Create HEEditFieldLabel
            app.HEEditFieldLabel = uilabel(app.GridLayout3);
            app.HEEditFieldLabel.HorizontalAlignment = 'right';
            app.HEEditFieldLabel.Layout.Row = 1;
            app.HEEditFieldLabel.Layout.Column = 1;
            app.HEEditFieldLabel.Position = [11 48 37 26];
            app.HEEditFieldLabel.Text = 'H&E';

            % Create HEEditField
            app.HEEditField = uieditfield(app.GridLayout3, 'text');
            app.HEEditField.Layout.Row = 1;
            app.HEEditField.Layout.Column = 2;
            app.HEEditField.Position = [58 48 144 26];

            % Create AADEditFieldLabel
            app.AADEditFieldLabel = uilabel(app.GridLayout3);
            app.AADEditFieldLabel.HorizontalAlignment = 'right';
            app.AADEditFieldLabel.Layout.Row = 2;
            app.AADEditFieldLabel.Layout.Column = 1;
            app.AADEditFieldLabel.Position = [11 16 37 22];
            app.AADEditFieldLabel.Text = '7AAD';

            % Create AADEditField
            app.AADEditField = uieditfield(app.GridLayout3, 'text');
            app.AADEditField.Layout.Row = 2;
            app.AADEditField.Layout.Column = 2;
            app.AADEditField.Position = [58 16 144 22];


            % Create LOADButton
            app.LOADButton = uibutton(app.GridLayout3, 'push');
            app.LOADButton.ButtonPushedFcn = createCallbackFcn(app, @LOAD_putshbutton_Callback, true);
            app.LOADButton.FontSize = 16;
            app.LOADButton.FontWeight = 'bold';
            app.LOADButton.Layout.Row = 1;
            app.LOADButton.Layout.Column = 4;
            app.LOADButton.Text = 'LOAD';

            % Create HEEditField
            app.HEEditField = uieditfield(app.GridLayout3, 'text');
            app.HEEditField.Layout.Row = 1;
            app.HEEditField.Layout.Column = 2;

            % Create HEEditFieldLabel
            app.HEEditFieldLabel = uilabel(app.GridLayout3);
            app.HEEditFieldLabel.HorizontalAlignment = 'right';
            app.HEEditFieldLabel.Layout.Row = 1;
            app.HEEditFieldLabel.Layout.Column = 1;
            app.HEEditFieldLabel.Text = 'H&E';

            % Create AADEditField
            app.AADEditField = uieditfield(app.GridLayout3, 'text');
            app.AADEditField.Layout.Row = 2;
            app.AADEditField.Layout.Column = 2;

            % Create AADEditFieldLabel
            app.AADEditFieldLabel = uilabel(app.GridLayout3);
            app.AADEditFieldLabel.HorizontalAlignment = 'right';
            app.AADEditFieldLabel.Layout.Row = 2;
            app.AADEditFieldLabel.Layout.Column = 1;
            app.AADEditFieldLabel.Text = '7AAD';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Regi_Nuance_HE_GUI(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.figure1)

                % Execute the startup function
                runStartupFcn(app, @(app)main_gui_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.figure1)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure1)
        end
    end
end