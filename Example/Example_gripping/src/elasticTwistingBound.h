#ifndef ELASTICTWISTINGBOUND_H
#define ELASTICTWISTINGBOUND_H

#include "eigenIncludes.h"
#include "elasticPlate.h"
#include "timeStepper.h"

class elasticTwistingBound
{
public:
	elasticTwistingBound(elasticPlate &m_plate, timeStepper &m_stepper);
	~elasticTwistingBound();
	void computeFt();
	void computeJt();

    void setFirstJacobian();

private:

	elasticPlate *plate;
	timeStepper *stepper;

    int ci, ind, ind1, ind2;
    double norm_e,norm_f;
    double norm2_e,norm2_f;
    double value,chi,milen;

    Vector3d t0,t1;
    Vector3d te,tf;
    Vector3d kbLocal;
    Vector3d tilde_t;
    double deltam;
    VectorXd gradTwistLocal;
    VectorXd getUndeformedTwist;
    VectorXd f;

    Matrix3d D2mDe2,D2mDf2,D2mDeDf,D2mDfDe;
    Matrix3d teMatrix;
    MatrixXd J;
    MatrixXd DDtwist;
    MatrixXd Jtt;
    MatrixXd gradTwist;
    double GJ;
    
	void crossMat(const Vector3d &a,Matrix3d &b);

    VectorXi localDOF;
};

#endif
