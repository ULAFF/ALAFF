function [ A ] = TriFromBi( A )
%TriFromBi Returns the symmetric tridiagonal matrix from the diagonal and 
% first subdiagonal of matrix A.
% 
    % extract the first subdiagonal
    Subd = tril( triu( A, -1 ), -1 );
    
    A = diag( diag( A ) ) + Subd + Subd';
end