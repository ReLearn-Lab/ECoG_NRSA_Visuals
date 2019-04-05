function T = add_ms_to_results(T)
    root = 'R:\crcox\ECoG\KyotoNaming\data\OpeningWindow\BaselineWindow\0000\avg\BoxCar\010\WindowStart\0000\WindowSize\';
    WindowSize = [50,100:100:1000];
    n = numel(WindowSize);
    T.ms = cell(size(T,1),1);
    for k = 1:n
        filename = fullfile(root,sprintf('%04d',WindowSize(k)),'metadata_raw.mat');
        tmp = load(filename, 'metadata');
        metadata = tmp.metadata;
        for j = 1:length(metadata)
            M = selectbyfield(metadata, 'subject', j);
            nelectrodes = numel(unique(string(M.coords.labels)));
            m = WindowSize(k) / 10;
            ix = repmat(1:m, 1, nelectrodes) * 10;
            for i = 1:max(T.cvholdout)
                z = T.cvholdout == i;
                z = z & T.WindowSize == WindowSize(k);
                z = z & T.subject == M.subject;
                T.ms{z} = ix(T.nz_rows{z})';
            end
        end
    end
end