function matrix = read_matrix_from_txt(file_path)
    fileID = fopen(file_path, 'r');
    if fileID == -1
        error('无法打开文件：%s', file_path);
    end
    A = fscanf(fileID, '%f');
    fclose(fileID);
    matrix = reshape(A, 4, 4)';
end
