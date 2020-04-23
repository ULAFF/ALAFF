#include <math.h>
#include "FLAME.h"
#include "Chol_prototypes.h"

void dpotrfx_( char *, int *, double *, int *, int *, int * );

#define AA(i,j) buff_A[ (j)*ldim_A + (i) ]

FLA_Error REF_Chol( int time_lapack, FLA_Obj A, int nb_alg )
{
  int n, ldim_A;
  
  double *buff_A, sqrt();


  n = FLA_Obj_length( A );
  ldim_A = FLA_Obj_col_stride( A );

  buff_A = (double *) FLA_Obj_buffer_at_view( A );

  if ( time_lapack ){
    // int info;
    //     dpotrfx_( "lower", &n, buff_A, &ldim_A, &info, &nb_alg );

  }
  else{
    int i, j, k;

    for ( j=0; j<n; j++ ){

      /* alpha11 = sqrt( alpha11 ) */
      AA( j, j ) = sqrt( AA( j, j ) );
    
      /* a21 = a21 / alpha11 */
      for ( i=j+1; i<n; i++ )
	AA( i,j ) = AA( i,j )  / AA( j,j );

      /* A22 = A22 - tril( a21 * a21') */
      for ( k=j+1; k<n; k++ )
	for ( i=k; i<n; i++ )
	  AA( i,k ) = AA( i,k ) - AA( i,j ) * AA( k,j );
    }
  }

  return FLA_SUCCESS;
}

