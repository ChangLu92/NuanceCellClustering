function [perm, blocky_A] = spectral_clustering(A,ndim,nclust)
    % symmetrize (and normalize) A
    A = (A + A');
    % A = symmetric_normalize(A);

    % find a blockifying permutation
    [~,vecs] = get_spectrum(A);
    [~,perm] = sort(kmeans(vecs(:,end-ndim:end-1),nclust,'replicates',100));

    % permute A
    if nargout > 1
        blocky_A = A(perm,perm);
    end
end

function [vals, vecs] = get_spectrum(A)
    [vecs, vals] = eigs(A);
    vals = diag(vals);
    [vals, i] = sort(vals);
    vecs = vecs(:,i);
end

function A = symmetric_normalize(A,maxiter)
    if ~exist('maxiter','var'), maxiter=5000; end
    for i=1:maxiter
        prevA = A;
        A = bsxfun(@rdivide,A,sum(A,1));
        A = bsxfun(@rdivide,A,sum(A,2));
        if max(max(abs(A - prevA))) < 1e-10
            break
        end
    end
end
