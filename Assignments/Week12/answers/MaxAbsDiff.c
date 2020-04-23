#define A( i,j ) *( ap + (j)*lda + (i) )          // map A( i,j )    to array ap    in column-major order
#define B( i,j ) *( bp + (j)*ldb + (i) )          // map B( i,j )    to array bp    in column-major order

#define dabs( x ) ( (x) < 0 ? -(x) : x )

double MaxAbsDiff( int m, int n, double *ap, int lda, double *bp, int ldb )
/* 
   MaxAbsDiff returns the maximum absolute difference over
   corresponding elements of matrices A and B.
*/
{
  double diff=0.0;
  int  i, j;

  for ( i=0; i<m; i++ )
    for ( j=0; j<n; j++ )
      if ( dabs( A( i,j ) - B( i,j ) ) > diff ) 
	  diff = dabs( A( i,j ) - B( i,j ) );

  return diff;
}
