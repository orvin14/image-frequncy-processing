function main_gui
%MAIN_GUI Unified GUI for IF4073 Tugas 2.
% Run:
%   addpath(genpath('src'));
%   main_gui

rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(rootDir));

app = struct();
app.I = [];
app.ref = [];
app.refPath = '';
app.refAuto = false;
app.output = [];
app.currentH = [];
app.currentF = [];
app.rootDir = rootDir;

app.fig = uifigure( ...
    'Name','IF4073 Tugas 2 - Frequency Domain & Image Restoration', ...
    'Position',[60 40 1500 900]);

app.fig.CloseRequestFcn = @closeApp;

%% =========================
% TOP BAR
% ==========================
top = uipanel(app.fig,'Position',[10 840 1480 50]);

app.loadBtn = uibutton(top,'push', ...
    'Text','Load Image', ...
    'Position',[10 10 110 30], ...
    'ButtonPushedFcn',@loadImage);

app.loadRefBtn = uibutton(top,'push', ...
    'Text','Load Reference', ...
    'Position',[130 10 130 30], ...
    'ButtonPushedFcn',@loadReference);

app.saveBtn = uibutton(top,'push', ...
    'Text','Save Result', ...
    'Position',[270 10 110 30], ...
    'ButtonPushedFcn',@saveResult);

app.info = uilabel(top, ...
    'Text','No image loaded.', ...
    'Position',[390 10 1080 30]);

%% =========================
% IMAGE DISPLAY
% Input, Output and Reference share the exact same axes rectangle so the
% three images can be compared directly.
% ==========================

app.axInput = uiaxes(app.fig, ...
    'Position',[20 480 480 340]);

app.axOutput = uiaxes(app.fig, ...
    'Position',[510 480 480 340]);

app.axReference = uiaxes(app.fig, ...
    'Position',[1000 480 480 340]);

app.axSpectrum = uiaxes(app.fig, ...
    'Position',[460 70 333 340]);

app.axMask = uiaxes(app.fig, ...
    'Position',[803 70 333 340]);

app.axOutputSpectrum = uiaxes(app.fig, ...
    'Position',[1146 70 333 340]);

% IMPORTANT:
% Title is assigned AFTER uiaxes creation.
title(app.axInput,'Input');
title(app.axOutput,'Output');
title(app.axReference,'Reference');
title(app.axSpectrum,'Spectrum');
title(app.axMask,'H(u,v) / Mask');
title(app.axOutputSpectrum,'Output spectrum');

%% =========================
% OPERATION TABS
% ==========================

tabs = uitabgroup(app.fig, ...
    'Position',[20 70 430 340]);

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
    'Limits',[0.001 1000], ...
    'Position',[150 245 100 22]);

lpfOrderLabel = uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 205 100 22]);

lpfOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[1 50], ...
    'Position',[150 205 100 22]);

uibutton(tab,'push', ...
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
    'Limits',[0.001 1000], ...
    'Position',[150 245 100 22]);

hpfOrderLabel = uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 205 100 22]);

hpfOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[1 50], ...
    'Position',[150 205 100 22]);

uibutton(tab,'push', ...
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
    'Limits',[0 255], ...
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

uibutton(tab,'push', ...
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
    'Text','Notch u0', ...
    'Position',[20 205 100 22]);

periodicD0 = uieditfield(tab,'numeric', ...
    'Value',40, ...
    'Limits',[-1000 1000], ...
    'Position',[150 205 100 22]);

periodicSecondLabel = uilabel(tab, ...
    'Text','Notch v0', ...
    'Position',[20 165 100 22]);

periodicW = uieditfield(tab,'numeric', ...
    'Value',10, ...
    'Limits',[-1000 1000], ...
    'Position',[150 165 100 22]);

periodicRadiusLabel = uilabel(tab, ...
    'Text','Radius', ...
    'Position',[20 125 100 22]);

periodicRadius = uieditfield(tab,'numeric', ...
    'Value',4, ...
    'Limits',[0.001 1000], ...
    'Position',[150 125 100 22]);

periodicOrderLabel = uilabel(tab, ...
    'Text','Order n', ...
    'Position',[20 85 100 22]);

periodicOrder = uieditfield(tab,'numeric', ...
    'Value',2, ...
    'Limits',[1 50], ...
    'Position',[150 85 100 22]);

uibutton(tab,'push', ...
    'Text','Apply Periodic Restoration', ...
    'Position',[150 35 220 35], ...
    'ButtonPushedFcn',@applyPeriodic);

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
    'Limits',[0.001 1000], ...
    'Position',[150 245 100 22]);

uilabel(tab, ...
    'Text','Angle theta', ...
    'Position',[20 205 100 22]);

motionTheta = uieditfield(tab,'numeric', ...
    'Value',0, ...
    'Limits',[-180 180], ...
    'Position',[150 205 100 22]);

motionKLabel = uilabel(tab, ...
    'Text','NSR K', ...
    'Position',[20 165 100 22]);

motionK = uieditfield(tab,'numeric', ...
    'Value',0.01, ...
    'Limits',[0 1000], ...
    'Position',[150 165 100 22]);

motionEpsLabel = uilabel(tab, ...
    'Text','Threshold epsilon', ...
    'Position',[20 125 100 22]);

motionEps = uieditfield(tab,'numeric', ...
    'Value',0.05, ...
    'Limits',[1e-6 1], ...
    'Position',[150 125 100 22]);

uibutton(tab,'push', ...
    'Text','Restore Motion Blur', ...
    'Position',[150 55 220 35], ...
    'ButtonPushedFcn',@applyMotion);

%% =========================
% CONTROL CALLBACKS
% ==========================

lpfType.ValueChangedFcn = @(~,~) updateLpfControls();
hpfType.ValueChangedFcn = @(~,~) updateHpfControls();
periodicMode.ValueChangedFcn = @(~,~) updatePeriodicControls();
periodicType.ValueChangedFcn = @(~,~) updatePeriodicControls();
motionMethod.ValueChangedFcn = @(~,~) updateMotionControls();

updateLpfControls();
updateHpfControls();
updatePeriodicControls();
updateMotionControls();

%% =========================
% STATUS
% ==========================

app.status = uilabel(app.fig, ...
    'Text','Ready. Load an image to begin.', ...
    'Position',[20 30 1450 30], ...
    'FontWeight','bold');

%% =========================
% AXES SETTINGS
% ==========================

app.axInput.XTick = [];
app.axInput.YTick = [];

app.axReference.XTick = [];
app.axReference.YTick = [];

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

    function setVisible(control, tf)

        if tf
            control.Visible = 'on';
        else
            control.Visible = 'off';
        end

    end

    function setLimits(field, lo, hi)

        if hi <= lo
            hi = lo + 1;
        end

        v = min(max(field.Value, lo), hi);

        field.Limits = [lo hi];

        field.Value = v;

    end

%% =========================
% PARAMETER BOUNDS
% ==========================
% Every numeric field is bounded to values the algorithm actually
% supports and that still change the result:
%   - frequency radii cannot exceed the largest spectrum radius (Rmax),
%     beyond which a mask stops changing,
%   - notch offsets cannot lie outside the spectrum,
%   - motion d is capped at the spectrum radius,
%   - theta is periodic over [-180,180],
%   - inverse-filter epsilon is capped at 1 (max |H|), beyond which the
%     filter leaves the input untouched,
%   - Wiener K is capped where the result has already faded to black.

    function [Rmax,maxU,maxV] = freqBounds

        if isempty(app.I)

            Rmax = 1000;
            maxU = 1000;
            maxV = 1000;

        else

            [M,N,~] = size3(app.I);

            Rmax = max(1, sqrt((M/2)^2 + (N/2)^2));
            maxU = max(1, floor(N/2));
            maxV = max(1, floor(M/2));

        end

    end

    function updateLpfControls

        isButterworth = strcmpi(lpfType.Value,'Butterworth');

        setVisible(lpfOrderLabel, isButterworth);
        setVisible(lpfOrder, isButterworth);

        [Rmax,~,~] = freqBounds();
        setLimits(lpfCut, 0.001, Rmax);

    end

    function updateHpfControls

        isButterworth = strcmpi(hpfType.Value,'Butterworth');

        setVisible(hpfOrderLabel, isButterworth);
        setVisible(hpfOrder, isButterworth);

        [Rmax,~,~] = freqBounds();
        setLimits(hpfCut, 0.001, Rmax);

    end

    function updatePeriodicControls

        [Rmax,maxU,maxV] = freqBounds();

        if strcmpi(periodicMode.Value,'Bandreject')

            periodicFirstLabel.Text = 'Center D0';
            periodicSecondLabel.Text = 'Width W';

            setLimits(periodicD0, 0.001, Rmax);
            setLimits(periodicW, 0.001, 2*Rmax);

            setVisible(periodicRadiusLabel, false);
            setVisible(periodicRadius, false);

        else

            periodicFirstLabel.Text = 'Notch u0';
            periodicSecondLabel.Text = 'Notch v0';

            setLimits(periodicD0, -maxU, maxU);
            setLimits(periodicW, -maxV, maxV);

            setVisible(periodicRadiusLabel, true);
            setVisible(periodicRadius, true);

        end

        isButterworth = strcmpi(periodicType.Value,'Butterworth');

        setVisible(periodicOrderLabel, isButterworth);
        setVisible(periodicOrder, isButterworth);

    end

    function updateMotionControls

        isInverse = strcmpi(motionMethod.Value,'Inverse');

        setVisible(motionKLabel, ~isInverse);
        setVisible(motionK, ~isInverse);

        setVisible(motionEpsLabel, isInverse);
        setVisible(motionEps, isInverse);

        [Rmax,~,~] = freqBounds();
        setLimits(motionD, 0.001, Rmax);

    end

    function updateAllControls

        updateLpfControls();
        updateHpfControls();
        updatePeriodicControls();
        updateMotionControls();

    end

%% =========================
% FILE DIALOG WRAPPER
% ==========================
% On most MATLAB releases before R2025a the classic uigetfile/uiputfile
% dialog can minimize the uifigure or push it behind other windows, and it
% then stays that way. Re-show and re-focus the app window afterwards.

    function [file,path] = pickFile(prompt,filter,isSave)

        if nargin < 3
            isSave = false;
        end

        state = getWindowState();

        drawnow;

        if isSave

            [file,path] = uiputfile(filter,prompt);

        else

            [file,path] = uigetfile(filter,prompt);

        end

        restoreAppWindow(state);

    end

    function state = getWindowState

        state = 'normal';

        try
            state = app.fig.WindowState;
        catch
            % WindowState not available on this release.
        end

    end

    function restoreAppWindow(state)

        if isempty(app.fig) || ~isvalid(app.fig)
            return;
        end

        drawnow;

        % Toggle visibility: forces the OS window out of a stuck
        % minimized/hidden state left behind by the native dialog.
        app.fig.Visible = 'off';
        app.fig.Visible = 'on';

        if strcmpi(state,'minimized')
            app.fig.WindowState = 'normal';
        else
            app.fig.WindowState = state;
        end

        try
            figure(app.fig);   % R2018a+: brings the uifigure back to front.
        catch
            % Older releases do not accept uifigures in figure().
        end

        drawnow;

    end

%% =========================
% LOAD IMAGE
% ==========================

    function loadImage(~,~)

        [file,path] = pickFile( ...
            'Select input image', ...
            {'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff','Image files'}, ...
            false);

        if isequal(file,0)
            return;
        end

        inputPath = fullfile(path,file);

        try

            I = imread(inputPath);

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

            clearReference();
            autoLoadReference(inputPath);

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

            updateAllControls();

        catch ME

            uialert( ...
                app.fig, ...
                ME.message, ...
                'Load error');

        end

    end

%% =========================
% LOAD REFERENCE
% ==========================

    function loadReference(~,~)

        [file,path] = pickFile( ...
            'Select reference image', ...
            {'*.png;*.jpg;*.jpeg;*.bmp;*.tif;*.tiff','Image files'}, ...
            false);

        if isequal(file,0)
            return;
        end

        refPath = fullfile(path,file);

        try

            R = imread(refPath);

            if ndims(R) == 3 && size(R,3) ~= 3
                error('Only grayscale or RGB reference images are supported.');
            end

            app.ref = double(R);
            app.refPath = refPath;
            app.refAuto = false;

            showImage(app.axReference,app.ref,'Reference');

            app.status.Text = ['Reference loaded: ' file];

        catch ME

            uialert( ...
                app.fig, ...
                ME.message, ...
                'Reference error');

        end

    end

    function autoLoadReference(inputPath)

        refPath = findReferenceForInput(inputPath);

        if isempty(refPath)
            return;
        end

        try

            R = imread(refPath);

            if size(R,1) ~= size(app.I,1) || size(R,2) ~= size(app.I,2)
                return;
            end

            app.ref = double(R);
            app.refPath = refPath;
            app.refAuto = true;

            showImage(app.axReference,app.ref,'Reference');

            app.status.Text = sprintf( ...
                'Reference auto-loaded: %s', ...
                shortName(refPath));

        catch
            % Ignore unreadable auto-reference; user can load manually.
        end

    end

    function clearReference

        app.ref = [];
        app.refPath = '';
        app.refAuto = false;

        cla(app.axReference);
        title(app.axReference,'Reference');

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

        [file,path] = pickFile( ...
            'Save result', ...
            {'*.png','PNG'; ...
             '*.jpg','JPEG'; ...
             '*.tif','TIFF'}, ...
            true);

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

        if strcmpi(lpfType.Value,'Butterworth')

            H = create_lpf( ...
                M, ...
                N, ...
                lpfCut.Value, ...
                lpfType.Value, ...
                lpfOrder.Value);

        else

            H = create_lpf( ...
                M, ...
                N, ...
                lpfCut.Value, ...
                lpfType.Value);

        end

        app.currentF = fft_transform(app.I);

        app.currentH = H;

        app.output = apply_frequency_filter( ...
            app.I, ...
            H);

        renderResult();

        app.status.Text = sprintf( ...
            'LPF %s applied, D0=%.3g.', ...
            lpfType.Value, ...
            lpfCut.Value);

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

        if strcmpi(hpfType.Value,'Butterworth')

            H = create_hpf( ...
                M, ...
                N, ...
                hpfCut.Value, ...
                hpfType.Value, ...
                hpfOrder.Value);

        else

            H = create_hpf( ...
                M, ...
                N, ...
                hpfCut.Value, ...
                hpfType.Value);

        end

        app.currentF = fft_transform(app.I);

        app.currentH = H;

        app.output = apply_frequency_filter( ...
            app.I, ...
            H);

        renderResult();

        app.status.Text = sprintf( ...
            'HPF %s applied, D0=%.3g.', ...
            hpfType.Value, ...
            hpfCut.Value);

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

        isButterworth = strcmpi(periodicType.Value,'Butterworth');

        if strcmpi(periodicMode.Value,'Bandreject')

            if isButterworth

                H = create_bandreject( ...
                    M, ...
                    N, ...
                    periodicD0.Value, ...
                    periodicW.Value, ...
                    periodicType.Value, ...
                    periodicOrder.Value);

            else

                H = create_bandreject( ...
                    M, ...
                    N, ...
                    periodicD0.Value, ...
                    periodicW.Value, ...
                    periodicType.Value);

            end

            desc = sprintf( ...
                'Bandreject %s', ...
                periodicType.Value);

        else

            if isButterworth

                H = create_notch( ...
                    M, ...
                    N, ...
                    periodicD0.Value, ...
                    periodicW.Value, ...
                    periodicRadius.Value, ...
                    periodicType.Value, ...
                    periodicOrder.Value);

            else

                H = create_notch( ...
                    M, ...
                    N, ...
                    periodicD0.Value, ...
                    periodicW.Value, ...
                    periodicRadius.Value, ...
                    periodicType.Value);

            end

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

function name = shortName(p)

[~,base,ext] = fileparts(p);

name = [base ext];

end

function refPath = findReferenceForInput(inputPath)

%FINDREFERENCEFORINPUT Match <case>/input/<file> to <case>/reference/<file>.
%   The dataset names inputs with a degradation suffix
%   (e.g. cell_gray_dark.png, rocket_color_periodic_noise.png), so the
%   suffix is stripped before matching against the reference folder.

refPath = '';

[inDir,inName] = fileparts(inputPath);
[caseDir,inFolder] = fileparts(inDir);

if ~strcmpi(inFolder,'input')
    return;
end

refDir = fullfile(caseDir,'reference');

if ~isfolder(refDir)
    return;
end

exts = {'*.png','*.jpg','*.jpeg','*.bmp','*.tif','*.tiff'};
files = [];

for k = 1:numel(exts)
    files = [files; dir(fullfile(refDir,exts{k}))]; %#ok<AGROW>
end

key = normalizeName(inName);

for k = 1:numel(files)

    [~,refBase] = fileparts(files(k).name);

    if strcmp(normalizeName(refBase),key)
        refPath = fullfile(refDir,files(k).name);
        return;
    end

end

end

function key = normalizeName(name)

key = lower(name);
key = regexprep(key,'_motion_l\d+_a-?\d+','');
key = regexprep(key,'_(gaussian|periodic)_noise','');
key = regexprep(key,'_dark','');
key = regexprep(key,'_+','_');
key = regexprep(key,'^_|_$','');

end
