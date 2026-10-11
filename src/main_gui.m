function main_gui
%MAIN_GUI Unified GUI for IF4073 Tugas 2.
% Run:
%   addpath(genpath('src'));
%   main_gui

rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(rootDir));

app = struct();
app.I = [];
app.output = [];
app.currentH = [];
app.currentF = [];
app.rootDir = rootDir;

app.fig = uifigure( ...
    'Name','IF4073 Tugas 2 - Frequency Domain & Image Restoration', ...
    'Position',[80 50 1450 850]);

app.fig.CloseRequestFcn = @closeApp;

%% =========================
% TOP BAR
% ==========================
top = uipanel(app.fig,'Position',[10 790 1430 50]);

app.loadBtn = uibutton(top,'push', ...
    'Text','Load Image', ...
    'Position',[10 10 110 30], ...
    'ButtonPushedFcn',@loadImage);

app.saveBtn = uibutton(top,'push', ...
    'Text','Save Result', ...
    'Position',[130 10 110 30], ...
    'ButtonPushedFcn',@saveResult);

app.info = uilabel(top, ...
    'Text','No image loaded.', ...
    'Position',[260 10 900 30]);

%% =========================
% IMAGE DISPLAY
% ==========================

app.axInput = uiaxes(app.fig, ...
    'Position',[20 430 430 330]);

app.axSpectrum = uiaxes(app.fig, ...
    'Position',[470 430 430 330]);

app.axMask = uiaxes(app.fig, ...
    'Position',[920 430 430 330]);

app.axOutput = uiaxes(app.fig, ...
    'Position',[470 50 430 330]);

app.axOutputSpectrum = uiaxes(app.fig, ...
    'Position',[920 50 430 330]);

% IMPORTANT:
% Title is assigned AFTER uiaxes creation.
title(app.axInput,'Input');
title(app.axSpectrum,'Spectrum');
title(app.axMask,'H(u,v) / Mask');
title(app.axOutput,'Output');
title(app.axOutputSpectrum,'Output spectrum');

%% =========================
% OPERATION TABS
% ==========================

tabs = uitabgroup(app.fig, ...
    'Position',[20 40 430 360]);

%% =========================
% LPF
% ==========================

tab = uitab(tabs,'Title','Smoothing / LPF');

uilabel(tab, ...
    'Text','Filter type', ...
    'Position',[20 285 100 22]);

lpfType = uidropdown(tab, ...
    'Items',{'Ideal','Gaussian','Butterworth'}, ...
    'Value','Gaussian', ...
    'Position',[150 285 220 22]);

uilabel(tab, ...
    'Text','D0 / cutoff', ...
    'Position',[20 245 100 22]);

lpfCut = uieditfield(tab,'numeric', ...
    'Value',30, ...
    'Limits',[0.001 Inf], ...
    'Position',[150 245 100 22]);

uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 205 100 22]);

lpfOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[0.1 Inf], ...
    'Position',[150 205 100 22]);

lpfApply = uibutton(tab,'push', ...
    'Text','Apply LPF', ...
    'Position',[150 145 220 35], ...
    'ButtonPushedFcn',@applyLPF);

%% =========================
% HPF
% ==========================

tab = uitab(tabs,'Title','High-Pass / HPF');

uilabel(tab, ...
    'Text','Filter type', ...
    'Position',[20 285 100 22]);

hpfType = uidropdown(tab, ...
    'Items',{'Ideal','Gaussian','Butterworth'}, ...
    'Value','Butterworth', ...
    'Position',[150 285 220 22]);

uilabel(tab, ...
    'Text','D0 / cutoff', ...
    'Position',[20 245 100 22]);

hpfCut = uieditfield(tab,'numeric', ...
    'Value',30, ...
    'Limits',[0.001 Inf], ...
    'Position',[150 245 100 22]);

uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 205 100 22]);

hpfOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[0.1 Inf], ...
    'Position',[150 205 100 22]);

hpfApply = uibutton(tab,'push', ...
    'Text','Apply HPF', ...
    'Position',[150 145 220 35], ...
    'ButtonPushedFcn',@applyHPF);

%% =========================
% BRIGHTNESS
% ==========================

tab = uitab(tabs,'Title','Brightness');

uilabel(tab, ...
    'Text','Factor k', ...
    'Position',[20 285 100 22]);

brightFactor = uieditfield(tab,'numeric', ...
    'Value',1.0, ...
    'Limits',[0 Inf], ...
    'Position',[150 285 100 22]);

uilabel(tab, ...
    'Text','Offset', ...
    'Position',[20 245 100 22]);

brightOffset = uieditfield(tab,'numeric', ...
    'Value',20, ...
    'Limits',[-255 255], ...
    'Position',[150 245 100 22]);

uilabel(tab, ...
    'Text','Offset changes the DC component.', ...
    'Position',[20 205 350 22]);

brightApply = uibutton(tab,'push', ...
    'Text','Apply Brightness', ...
    'Position',[150 145 220 35], ...
    'ButtonPushedFcn',@applyBrightness);

%% =========================
% PERIODIC NOISE
% ==========================

tab = uitab(tabs,'Title','Periodic Noise');

uilabel(tab, ...
    'Text','Mode', ...
    'Position',[20 285 100 22]);

periodicMode = uidropdown(tab, ...
    'Items',{'Bandreject','Notch'}, ...
    'Value','Notch', ...
    'Position',[150 285 220 22]);

uilabel(tab, ...
    'Text','Filter type', ...
    'Position',[20 245 100 22]);

periodicType = uidropdown(tab, ...
    'Items',{'Ideal','Gaussian','Butterworth'}, ...
    'Value','Ideal', ...
    'Position',[150 245 220 22]);

periodicFirstLabel = uilabel(tab, ...
    'Text','D0 / u0', ...
    'Position',[20 205 100 22]);

periodicD0 = uieditfield(tab,'numeric', ...
    'Value',40, ...
    'Position',[150 205 100 22]);

periodicSecondLabel = uilabel(tab, ...
    'Text','W / v0', ...
    'Position',[20 165 100 22]);

periodicW = uieditfield(tab,'numeric', ...
    'Value',10, ...
    'Limits',[0.001 Inf], ...
    'Position',[150 165 100 22]);

uilabel(tab, ...
    'Text','Radius', ...
    'Position',[20 125 100 22]);

periodicRadius = uieditfield(tab,'numeric', ...
    'Value',4, ...
    'Limits',[0.001 Inf], ...
    'Position',[150 125 100 22]);

uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 85 100 22]);

periodicOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[0.1 Inf], ...
    'Position',[150 85 100 22]);

periodicApply = uibutton(tab,'push', ...
    'Text','Apply Periodic Restoration', ...
    'Position',[150 35 220 35], ...
    'ButtonPushedFcn',@applyPeriodic);

periodicMode.ValueChangedFcn = @updatePeriodicLabels;
updatePeriodicLabels([],[]);

%% =========================
% MOTION RESTORATION
% ==========================

tab = uitab(tabs,'Title','Motion Restoration');

uilabel(tab, ...
    'Text','Method', ...
    'Position',[20 285 100 22]);

motionMethod = uidropdown(tab, ...
    'Items',{'Inverse','Wiener'}, ...
    'Value','Wiener', ...
    'Position',[150 285 220 22]);

uilabel(tab, ...
    'Text','Length d', ...
    'Position',[20 245 100 22]);

motionD = uieditfield(tab,'numeric', ...
    'Value',0.5, ...
    'Limits',[0.0001 Inf], ...
    'Position',[150 245 100 22]);

uilabel(tab, ...
    'Text','Angle theta', ...
    'Position',[20 205 100 22]);

motionTheta = uieditfield(tab,'numeric', ...
    'Value',0, ...
    'Position',[150 205 100 22]);

uilabel(tab, ...
    'Text','NSR K', ...
    'Position',[20 165 100 22]);

motionK = uieditfield(tab,'numeric', ...
    'Value',0.01, ...
    'Limits',[0 Inf], ...
    'Position',[150 165 100 22]);

uilabel(tab, ...
    'Text','Threshold epsilon', ...
    'Position',[20 125 100 22]);

motionEps = uieditfield(tab,'numeric', ...
    'Value',0.05, ...
    'Limits',[1e-12 Inf], ...
    'Position',[150 125 100 22]);

motionApply = uibutton(tab,'push', ...
    'Text','Restore Motion Blur', ...
    'Position',[150 55 220 35], ...
    'ButtonPushedFcn',@applyMotion);

%% =========================
% STATUS
% ==========================

app.status = uilabel(app.fig, ...
    'Text','Ready. Load an image to begin.', ...
    'Position',[920 30 500 30], ...
    'FontWeight','bold');

%% =========================
% AXES SETTINGS
% ==========================

app.axInput.XTick = [];
app.axInput.YTick = [];

app.axSpectrum.XTick = [];
app.axSpectrum.YTick = [];

app.axMask.XTick = [];
app.axMask.YTick = [];

app.axOutput.XTick = [];
app.axOutput.YTick = [];
app.axOutputSpectrum.XTick = [];
app.axOutputSpectrum.YTick = [];

%% =========================
% HELPER FUNCTIONS
% ==========================

    function requireImage

        if isempty(app.I)
            error('Please load an image first.');
        end

    end

%% =========================
% LOAD IMAGE
% ==========================

    function loadImage(~,~)

        [file,path] = uigetfile( ...
            {'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff','Image files'}, ...
            'Select input image');

        if isequal(file,0)
            return;
        end

        try

            I = imread(fullfile(path,file));

            if ndims(I) == 3 && size(I,3) ~= 3
                error('Only grayscale or RGB images are supported.');
            end

            app.I = double(I);

            app.output = [];
            app.currentH = [];
            app.currentF = fft_transform(app.I);

            showImage(app.axInput,app.I,'Input');

            showSpectrum(app.currentF);

            cla(app.axMask);
            title(app.axMask,'H(u,v) / Mask');

            cla(app.axOutput);
            title(app.axOutput,'Output');

            cla(app.axOutputSpectrum);
            title(app.axOutputSpectrum,'Output spectrum');

            if ndims(I) == 2
                imageType = 'Grayscale';
            else
                imageType = 'RGB';
            end

            app.info.Text = sprintf( ...
                '%s | %dx%d | %s', ...
                file, ...
                size(I,2), ...
                size(I,1), ...
                imageType);

            app.status.Text = 'Image loaded.';

        catch ME

            uialert( ...
                app.fig, ...
                ME.message, ...
                'Load error');

        end

    end

%% =========================
% SAVE RESULT
% ==========================

    function saveResult(~,~)

        if isempty(app.output)

            uialert( ...
                app.fig, ...
                'Run an operation before saving the result.', ...
                'No result');

            return;

        end

        [file,path] = uiputfile( ...
            {'*.png','PNG'; ...
             '*.jpg','JPEG'; ...
             '*.tif','TIFF'}, ...
            'Save result');

        if isequal(file,0)
            return;
        end

        out = uint8( ...
            min( ...
            max( ...
            round(app.output), ...
            0), ...
            255));

        imwrite(out,fullfile(path,file));

        app.status.Text = ...
            ['Saved: ' fullfile(path,file)];

    end

%% =========================
% LPF
% ==========================

    function applyLPF(~,~)

        runSafe(@() doLPF());

    end

    function doLPF

        requireImage();

        [M,N,~] = size3(app.I);

        H = create_lpf( ...
            M, ...
            N, ...
            lpfCut.Value, ...
            lpfType.Value, ...
            lpfOrder.Value);

        app.currentF = fft_transform(app.I);

        app.currentH = H;

        app.output = apply_frequency_filter( ...
            app.I, ...
            H);

        renderResult();

        app.status.Text = sprintf( ...
            'LPF %s applied, D0=%.3g, n=%.3g.', ...
            lpfType.Value, ...
            lpfCut.Value, ...
            lpfOrder.Value);

    end

%% =========================
% HPF
% ==========================

    function applyHPF(~,~)

        runSafe(@() doHPF());

    end

    function doHPF

        requireImage();

        [M,N,~] = size3(app.I);

        H = create_hpf( ...
            M, ...
            N, ...
            hpfCut.Value, ...
            hpfType.Value, ...
            hpfOrder.Value);

        app.currentF = fft_transform(app.I);

        app.currentH = H;

        app.output = apply_frequency_filter( ...
            app.I, ...
            H);

        renderResult();

        app.status.Text = sprintf( ...
            'HPF %s applied, D0=%.3g, n=%.3g.', ...
            hpfType.Value, ...
            hpfCut.Value, ...
            hpfOrder.Value);

    end

%% =========================
% BRIGHTNESS
% ==========================

    function applyBrightness(~,~)

        runSafe(@() doBrightness());

    end

    function doBrightness

        requireImage();

        F = fft_transform(app.I);

        F2 = create_brightness( ...
            F, ...
            brightFactor.Value, ...
            brightOffset.Value);

        app.currentF = F;

        app.currentH = ...
            ones(size(F,1),size(F,2));

        app.output = ...
            min( ...
            max( ...
            ifft_transform(F2), ...
            0), ...
            255);

        renderResult();

        app.status.Text = sprintf( ...
            'Brightness applied: factor=%.3g, offset=%.3g.', ...
            brightFactor.Value, ...
            brightOffset.Value);

    end

%% =========================
% PERIODIC NOISE
% ==========================

    function applyPeriodic(~,~)

        runSafe(@() doPeriodic());

    end

    function doPeriodic

        requireImage();

        [M,N,~] = size3(app.I);

        if strcmpi(periodicMode.Value,'Bandreject')

            H = create_bandreject( ...
                M, ...
                N, ...
                periodicD0.Value, ...
                periodicW.Value, ...
                periodicType.Value, ...
                periodicOrder.Value);

            desc = sprintf( ...
                'Bandreject %s', ...
                periodicType.Value);

        else

            H = create_notch( ...
                M, ...
                N, ...
                periodicD0.Value, ...
                periodicW.Value, ...
                periodicRadius.Value, ...
                periodicType.Value, ...
                periodicOrder.Value);

            desc = sprintf( ...
                'Notch %s at (+%g,+%g)', ...
                periodicType.Value, ...
                periodicD0.Value, ...
                periodicW.Value);

        end

        app.currentF = fft_transform(app.I);

        app.currentH = H;

        app.output = apply_frequency_filter( ...
            app.I, ...
            H);

        renderResult();

        app.status.Text = ...
            [desc ' applied.'];

    end

    function updatePeriodicLabels(~,~)

        if strcmpi(periodicMode.Value,'Bandreject')
            periodicFirstLabel.Text = 'Center D0';
            periodicSecondLabel.Text = 'Width W';
            periodicD0.Value = max(periodicD0.Value,0.001);
            periodicW.Value = max(periodicW.Value,0.001);
        else
            periodicFirstLabel.Text = 'Notch u0';
            periodicSecondLabel.Text = 'Notch v0';
        end

    end

%% =========================
% MOTION RESTORATION
% ==========================

    function applyMotion(~,~)

        runSafe(@() doMotion());

    end

    function doMotion

        requireImage();

        [M,N,C] = size3(app.I);

        H = motion_psf( ...
            M, ...
            N, ...
            motionD.Value, ...
            motionTheta.Value);

        G = fft_transform(app.I);

        Fhat = zeros(size(G));

        for c = 1:C

            if C == 1

                Gc = G;

            else

                Gc = G(:,:,c);

            end

            if strcmpi(motionMethod.Value,'Inverse')

                Fc = inverse_filtering( ...
                    Gc, ...
                    H, ...
                    motionEps.Value);

            else

                Fc = wiener_filtering( ...
                    Gc, ...
                    H, ...
                    motionK.Value);

            end

            if C == 1

                Fhat = Fc;

            else

                Fhat(:,:,c) = Fc;

            end

        end

        app.currentF = G;

        app.currentH = abs(H);

        app.output = ...
            min( ...
            max( ...
            ifft_transform(Fhat), ...
            0), ...
            255);

        renderResult();

        app.status.Text = sprintf( ...
            '%s motion restoration: d=%.3g, theta=%.3g deg.', ...
            motionMethod.Value, ...
            motionD.Value, ...
            motionTheta.Value);

    end

%% =========================
% RENDER
% ==========================

    function renderResult

        showSpectrum(app.currentF);

        showSpectrumOnAxes(fft_transform(app.output), ...
            app.axOutputSpectrum,'Output spectrum');

        showMask(app.currentH);

        showImage( ...
            app.axOutput, ...
            app.output, ...
            'Output');

    end

%% =========================
% SHOW IMAGE
% ==========================

    function showImage(ax,I,titleText)

        cla(ax);

        if ndims(I) == 2

            imagesc(ax,I,[0 255]);

            colormap(ax,gray(256));

        else

            image( ...
                ax, ...
                uint8( ...
                min( ...
                max(I,0), ...
                255)));

        end

        axis(ax,'image');

        ax.XTick = [];
        ax.YTick = [];

        title(ax,titleText);

    end

%% =========================
% SHOW SPECTRUM
% ==========================

    function showSpectrum(F)

        showSpectrumOnAxes(F,app.axSpectrum,'Input spectrum');

    end

    function showSpectrumOnAxes(F,ax,titleText)

        S = visualize_spectrum(F);

        cla(ax);

        imagesc(ax,S);

        colormap( ...
            ax, ...
            gray(256));

        axis(ax,'image');

        ax.XTick = [];
        ax.YTick = [];

        title(ax,[titleText ' | log(1 + |F(u,v)|)']);

    end

%% =========================
% SHOW MASK
% ==========================

    function showMask(H)

        cla(app.axMask);

        imagesc( ...
            app.axMask, ...
            H, ...
            [0 1]);

        colormap( ...
            app.axMask, ...
            gray(256));

        axis(app.axMask,'image');

        app.axMask.XTick = [];
        app.axMask.YTick = [];

        title( ...
            app.axMask, ...
            'H(u,v)');

    end

%% =========================
% ERROR HANDLER
% ==========================

    function runSafe(fn)

        try

            fn();

        catch ME

            uialert( ...
                app.fig, ...
                ME.message, ...
                'Operation error');

        end

    end

%% =========================
% CLOSE
% ==========================

    function closeApp(~,~)

        delete(app.fig);

    end

end

%% =========================
% UTILITY
% ==========================

function [M,N,C] = size3(I)

M = size(I,1);

N = size(I,2);

if ndims(I) == 2

    C = 1;

else

    C = size(I,3);

end

end
