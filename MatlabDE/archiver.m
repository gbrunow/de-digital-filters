function [ A, archiveSize ] = archiver( A, D, maxASize, archiveSize, vectors)
    improvSize = size(vectors, 2);
    archiveIndex = (archiveSize+1):(archiveSize + improvSize);
    inBoundIndex = archiveIndex(archiveIndex <= maxASize);
    outBoundIndex = archiveIndex(archiveIndex > maxASize) - archiveSize;
    
    if(~isempty(inBoundIndex))
      A(1:D, inBoundIndex) = vectors(1:D, inBoundIndex - archiveSize);
    end
    
    nremove = improvSize - (maxASize - archiveSize);
    if(nremove > 0)
      removeIndex = randperm(archiveSize, nremove);
      A(1:D, removeIndex) = vectors(1:D, outBoundIndex);
    end
    
    archiveSize = archiveSize + length(vectors);
        
    if archiveSize > maxASize
        archiveSize = maxASize;
    end
end

