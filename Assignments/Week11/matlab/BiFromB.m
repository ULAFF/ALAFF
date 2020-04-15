function [ B ] = BiFromB( B )
%BiFromB Returns the bidiagonal matrix from the diagonal and 
% first superdiagonal of matrix b.
% 

    B = tril( triu( B ), 1 );
end