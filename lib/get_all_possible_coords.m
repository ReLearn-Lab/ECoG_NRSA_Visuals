function T = get_all_possible_coords(coords)
    WindowSize = [coords(1,:).WindowSize];
    Subjects = [coords(:,1).Subject];
    n = numel(WindowSize);
    TC = cell(n,1);
    % T.ms = cell(size(T,1),1);
    for k = 1:n
        C = selectbyfield(coords, 'WindowSize', WindowSize(k))';
        xyz = cat(1, C.xyz);
        N = size(xyz, 1);
        TC{k} = table( ...
            repmat(WindowSize(k),N, 1), ...
            repelem(Subjects,[C.Samples].*[C.Electrodes])', ... % subjects
            repmat((1:C(1).Samples)', sum([C.Electrodes]), 1), ... % ms
            xyz(:,1), xyz(:,2), xyz(:,3), ...
            'VariableNames', {
                'WindowSize'
                'Subject'
                'ms'
                'x'
                'y'
                'z'
            });
    end
    T = cat(1,TC{:});
end