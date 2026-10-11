function check_constraints()
%CHECK_CONSTRAINTS Fail if prohibited filtering calls are present in src.
rootDir = fileparts(fileparts(mfilename('fullpath')));
srcDir = fullfile(rootDir,'src');
files = dir(fullfile(srcDir,'**','*.m'));
for k=1:numel(files)
    txt = fileread(fullfile(files(k).folder,files(k).name));
    forbidden = {'imgaussfilt','imsharpen','deconvwnr','wiener2','imfilter','fspecial'};
    for j=1:numel(forbidden)
        % Ignore this checker file's own literal list.
        if contains(files(k).name,'check_constraints'), continue; end
        assert(~contains(lower(txt),lower(forbidden{j})),...
            'Forbidden function "%s" found in %s.',forbidden{j},files(k).name);
    end
end
fprintf('Constraint check passed: no prohibited filtering function calls in src.\n');
end
