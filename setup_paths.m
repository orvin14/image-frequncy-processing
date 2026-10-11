function setup_paths()
%SETUP_PATHS Add all project source folders to MATLAB path.
rootDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(rootDir,'src')));
fprintf('IF4073 project paths added from:\n%s\n',rootDir);
end
