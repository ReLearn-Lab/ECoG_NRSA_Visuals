function T = addCoordsAndLabels(T)
    w = unique(T.WindowSize);
    n = numel(w);
    T.coords = cell(size(T, 1), 1);
    T.electrodes = cell(size(T, 1), 1);
    for i = 1:n
        z = T.WindowSize==w(i);
        ix = find(z);
        tmp = load(fullfile(ecogdatapath('OpeningWindow',0,10,0,w(i)),'metadata_raw.mat'), 'metadata');
        metadata = tmp.metadata;
        for j = 1:numel(ix)
            s = T.subject(ix(j));
            r = T.nz_rows{ix(j)};
            M = metadata([metadata.subject] == s);
            v = M.filters(strcmp('colfilter',{M.filters.label})).filter;
            v(v) = r;
            xyz = M.coords.xyz(v,:);
            lab = cellstr(M.coords.labels(v,:));

            T.coords{ix(j)} = xyz;
            T.electrodes{ix(j)} = lab;
        end
    end
end
    
    
    