#include "blis.h"

#define alpha( i,j ) A[ (j)*ldA + i ]   // map alpha( i,j ) to array A 
#define beta( i,j )  B[ (j)*ldB + i ]   // map beta( i,j )  to array B
#define gamma( i,j ) C[ (j)*ldC + i ]   // map gamma( i,j ) to array C

void MyGemm( int m, int n, int k, double *A, int ldA,
	     double *B, int ldB, double *C, int ldC )
{
  double d_one = 1.0;
  
  for ( int i=0; i<m; i++ )
    bli_dgemv( BLIS_TRANSPOSE, BLIS_NO_CONJUGATE,
	       k, n, &d_one, B, 1, ldB, &alpha(  ,    ), ldA, &d_one, &gamma(   ,   ), ldC );
}
  
