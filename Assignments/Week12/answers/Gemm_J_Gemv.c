#define alpha( i,j ) A[ (j)*ldA + i ]   // map alpha( i,j ) to array A 
#define beta( i,j )  B[ (j)*ldB + i ]   // map beta( i,j )  to array B
#define gamma( i,j ) C[ (j)*ldC + i ]   // map gamma( i,j ) to array C

void MyGemv( int, int, double *, int, double *, int, double *, int );

void MyGemm( int m, int n, int k,
	     double *A, int ldA,
	     double *B, int ldB,
	     double *C, int ldC )
{
  for ( int j=0; j<n; j++ )
    MyGemv( m, k, A, ldA, &beta( 0, j ), 1, &gamma( 0,j ), 1 );
}
  
